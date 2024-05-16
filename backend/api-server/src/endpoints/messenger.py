from flask import Blueprint, request, jsonify, Response, abort
from flask_sse import sse

from sqlalchemy import select, func, or_
from sqlalchemy.orm import joinedload
from sqlalchemy.ext.asyncio import AsyncSession

import json
import logging

from db.session import async_session
from db.models import User, Chat, Message
from tools.security import *

MESSAGES_ON_PAGE = 10

messenger = Blueprint("messenger", __name__)

last_unread_messages: dict[int, dict[int, int | None]] = (
    {}
)  # {chat_id: {user_id: msg_id}}


@messenger.post("/join-chat/<int:chat_id>")
async def join_chat(chat_id: int) -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")
    invite_token = data.get("invite-token")

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session() as sess:
        sess: AsyncSession

        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if not chat:
            abort(Response("Chat not found!", 404))

        if chat.is_private:
            token_data = decode_invite_token(invite_token)

            if not token_data:
                abort(Response("This chat is private!", 403))

            invitor = await sess.get(User, token_data[0])

            if token_data[1] != chat_id or invitor not in chat.participants:
                abort(Response("Invalid invite-token!", 403))

        chat.participants.append(user)

        sess.add(chat)
        await sess.commit()

    return Response(status=200)


@messenger.get("/get-invite-token/<int:chat_id>")
async def get_invite_token(chat_id: int) -> Response:
    token = request.authorization.token
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session() as sess:
        sess: AsyncSession

        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if user not in chat.participants:
            abort(Response("You are not a chat participant!", 403))

        token = encode_invite_token(user_id, chat_id)

    return jsonify({"invite-token": token})


@messenger.post("/create-chat")
async def create_chat() -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")
    chat_title = data.get("chat-title")
    chat_is_private = data.get("is-private")
    participants = data.get("participants", [])

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    participants = {user_id} | set(participants)

    async with async_session() as sess:
        sess: AsyncSession

        chat = Chat(title=chat_title, is_private=chat_is_private)
        chat.participants.extend([await sess.get(User, uid) for uid in participants])
        sess.add(chat)

        await sess.commit()
        await sess.refresh(chat)

        return jsonify({"chat-id": chat.id})


@messenger.post("/send-message/<int:chat_id>")
async def send_message(chat_id: int) -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")
    msg_type = data.get("msg-type")
    msg_data = data.get("msg-data")

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session() as sess:
        sess: AsyncSession

        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if not chat:
            abort(Response("Chat not found!", 404))

        if user not in chat.participants:
            abort(Response("You are not a chat participant!", 403))

        msg = Message(chat_id=chat_id, sender_id=user_id, type=msg_type, data=msg_data)

        sess.add(msg)
        await sess.commit()
        await sess.refresh(msg)

        if chat_id not in last_unread_messages:
            last_unread_messages[chat_id] = {}
        for participant in chat.participants:
            last_unread_messages[chat_id][participant.id] = msg.id

        sse.publish(msg.to_dict(), channel=f"message.{chat_id}")

    return Response(status=200)


@messenger.post("/read-message/<int:chat_id>/<int:msg_id>")
async def read_message(chat_id: int, msg_id: int) -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    last_unread = last_unread_messages.get(chat_id, {}).get(user_id)
    if msg_id >= (last_unread if last_unread else 0):
        if chat_id not in last_unread_messages:
            last_unread_messages[chat_id] = {}
        last_unread_messages[chat_id][user_id] = None

    return Response(status=200)


@messenger.get("/get-chats/<int:user_id>")
async def get_chats(user_id: int) -> Response:
    async with async_session() as sess:
        sess: AsyncSession

        user: User = (
            (
                await sess.execute(
                    select(User)
                    .options(
                        joinedload(User.chats).options(joinedload(Chat.participants))
                    )
                    .where(User.id == user_id)
                )
            )
            .scalars()
            .unique()
            .one()
        )

        if not user:
            abort(Response("User not found!", 404))

        return jsonify(
            list(
                map(
                    lambda x: x.to_dict()
                    | {
                        "unread": last_unread_messages.get(x.id, {}).get(user_id)
                        is not None
                    },
                    user.chats,
                )
            )
        )


@messenger.get("/search-for-chats/<string:query>")
async def search_for_chats(query: str) -> Response:
    token = request.authorization.token
    user_id = decode_auth_token(token)

    if not user_id:
        abort(401)

    async with async_session() as sess:
        sess: AsyncSession

        user: User = (
            (
                await sess.execute(
                    select(User)
                    .where(User.id == user_id)
                    .options(joinedload(User.chats))
                )
            )
            .scalars()
            .unique()
            .one()
        )

        users_chats_id = [chat.id for chat in user.chats]

        chats = (
            (
                await sess.execute(
                    select(Chat)
                    .where(
                        or_(
                            Chat.is_private == False,
                            Chat.id.in_(users_chats_id),
                        )
                    )
                    .where(func.lower(Chat.title).like(f"%{query.lower()}%"))
                )
            )
            .unique()
            .scalars()
            .all()
        )

        return jsonify(
            list(
                map(
                    lambda x: x.to_dict()
                    | ({"joined": x.id in users_chats_id} if user else {}),
                    chats,
                )
            )
        )


@messenger.post("/store-messages/<int:chat_id>")
async def store_messages(chat_id: int) -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")
    before_msg_id = data.get("before-message")

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session() as sess:
        sess: AsyncSession

        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if not chat:
            abort(Response("Chat not found!", 404))

        if user not in chat.participants:
            abort(Response("You are not a chat participant!", 403))

        msgs = (
            (
                await sess.execute(
                    select(Message)
                    .where(Message.chat_id == chat_id)
                    .where((Message.id < before_msg_id) if before_msg_id else True)
                    .order_by(Message.id.desc())
                    .limit(MESSAGES_ON_PAGE)
                )
            )
            .unique()
            .scalars()
            .all()
        )

        return jsonify(list(map(Message.to_dict, msgs)))


@messenger.post("/add-to-chat/<int:chat_id>/<int:user_id>")
async def add_to_chat(chat_id: int, user_id: int) -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")

    if not decode_auth_token(token):
        abort(Response("Invalid auth-token!", 401))

    async with async_session.begin() as sess:
        sess: AsyncSession

        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if not chat:
            abort(Response("Chat not found!", 404))
        if not user:
            abort(Response("User not found!", 404))

        chat.participants.append(user)

        sess.add(chat)

    return Response(status=200)
