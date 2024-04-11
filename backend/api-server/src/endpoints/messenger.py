from flask import Blueprint, request, jsonify, Response, abort
from flask_sse import sse

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

import json
import logging
from os import environ

from db.session import async_session
from db.models import User, Chat, Message, UserContact
from tools.security import *

messenger = Blueprint('messenger', __name__)


@sse.before_request
async def check_access():
    token = request.args.get('auth-token')
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 401))

    channel = request.args.get('channel', ' .').split('.')

    match channel[0]:
        case 'message':
            chat_id = int(channel[1])

            async with async_session() as sess:
                sess: AsyncSession

                chat: Chat = await sess.get(Chat, chat_id)
                user: User = await sess.get(User, user_id)

                if user not in chat.participants:
                    abort(Response('You are not a chat participant!', 403))
                
                
messenger.register_blueprint(sse, url_prefix='/listen')


@messenger.post('/signup')
async def signup() -> Response:
    data = json.loads(request.data.decode('utf-8'))
    username = data.get('username')
    password = data.get('password')

    if not is_valid_password(password):
        abort(Response('Bad password!', 400))
    
    password_hash = hash_password(password)

    async with async_session() as sess:
        sess: AsyncSession

        if (await sess.execute(select(User).where(User.username == username))).unique().scalar_one_or_none():
            abort(Response('That user is already registered!', 409))
        
        user = User(username=username, password_hash=password_hash, alias=data.get('alias', username))

        sess.add(user)
        await sess.commit()
        await sess.refresh(user)

        token = encode_auth_token(user.id)
        
    return jsonify({'auth-token': token})


@messenger.post("/who-am-i")
async def who_am_i() -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid token!', 401))

    return user_id


@messenger.post('/signin')
async def signin() -> Response:
    data = json.loads(request.data.decode('utf-8'))
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        abort(Response('Missed JSON fields!', 400))
    
    password_hash = hash_password(password)

    async with async_session() as sess:
        sess: AsyncSession

        user: User = (await sess.execute(select(User).where(User.username == username))).unique().scalar_one_or_none()
        if not user:
            abort(Response('User with that username does not exist!', 404))
        
        if user.password_hash != password_hash:
            abort(Response('Wrong password!', 400))
    
        token = encode_auth_token(user.id)
        
    return jsonify({'auth-token': token})


@messenger.post('/add-contact/<username>')
async def add_contact(username: str) -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    
    initiator_id = decode_auth_token(token)

    if not initiator_id:
        abort(Response('Invalid token!', 401))
    
    async with async_session() as sess:
        sess: AsyncSession

        initiator_user: User = await sess.get(User, initiator_id)
        contact_user: User = (await sess.execute(select(User).where(User.username == username))).unique().scalar_one_or_none()

        if not initiator_user or not contact_user:
            abort(Response('Invalid username!', 404))
    
        contact = UserContact(user_id=initiator_user.id, contact_user_id=contact_user.id)
        sess.add(contact)
        await sess.commit()

    return Response(status=200)


@messenger.post('/join-chat/<int:chat_id>')
async def join_chat(chat_id: int) -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    invite_token = data.get('invite-token')
    
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 401))
    
    async with async_session() as sess:
        sess: AsyncSession
        
        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if not chat:
            abort(Response('Chat not found!', 404))
        
        if chat.is_private:
            token_data = decode_invite_token(invite_token)

            if not token_data:
                abort(Response('This chat is private!', 403))

            invitor = await sess.get(User, token_data[0])

            if token_data[1] != chat_id or invitor not in chat.participants:
                abort(Response('Invalid invite-token!', 403))
            
        chat.participants.append(user)

        sess.add(chat)
        await sess.commit()

    return Response(status=200)


@messenger.post('/get-invite-token/<int:chat_id>')
async def get_invite_token(chat_id: int) -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 401))
    
    async with async_session() as sess:
        sess: AsyncSession
        
        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if user not in chat.participants:
            abort(Response('You are not a chat participant!', 403))
        
        token = encode_invite_token(user_id, chat_id)

    return jsonify({'invite-token': token})


@messenger.post('/create-chat')
async def create_chat() -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    chat_title = data.get('chat-title')
    chat_is_private = data.get('is-private')

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 401))

    async with async_session() as sess:
        sess: AsyncSession
        
        user: User = await sess.get(User, user_id)
        chat = Chat(title=chat_title, is_private=chat_is_private)
        chat.participants.append(user)
        sess.add(chat)

        await sess.commit()
        await sess.refresh(chat)

        return jsonify({'chat-id': chat.id})
        

@messenger.post('/send-message/<chat_id>')
async def send_message(chat_id: int) -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    msg_type = data.get('msg-type')
    msg_data = data.get('msg-data')

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 401))

    async with async_session() as sess:
        sess: AsyncSession
        
        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if not chat:
            abort(Response('Chat not found!', 404))
        
        if user not in chat.participants:
            abort(Response('You are not a chat participant!', 403))
        
        msg = Message(chat_id=chat_id, sender_id=user_id, type=msg_type, data=msg_data)
        
        sess.add(msg)
        await sess.commit()

        sse.publish({'sender': user.username, 'type': msg_type, 'data': msg_data,
                      'sending_datetime': msg.sending_datetime.strftime("%Y-%m-%d %H:%M")},
                      channel=f'message.{chat_id}')

    return Response(status=200)
