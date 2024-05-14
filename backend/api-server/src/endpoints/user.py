from flask import Blueprint, request, jsonify, Response, abort

from sqlalchemy import select, func, exc, or_
from sqlalchemy.orm import joinedload
from sqlalchemy.ext.asyncio import AsyncSession

import json
import logging

from db.session import async_session
from db.models import User, UserGame, UserContact
from tools.security import *

user = Blueprint("user", __name__)

@user.post("/signup", strict_slashes=False)
async def signup() -> Response:
    data = json.loads(request.data.decode("utf-8"))
    username = data.get("username")
    password = data.get("password")

    if not is_valid_password(password):
        abort(Response("Bad password!", 400))

    password_hash = hash_password(password)

    async with async_session() as sess:
        sess: AsyncSession

        if (
            (await sess.execute(select(User).where(User.username == username)))
            .unique()
            .scalar_one_or_none()
        ):
            abort(Response("That user is already registered!", 409))

        user_ = User(
            username=username,
            password_hash=password_hash,
            alias=data.get("alias", username),
        )

        sess.add(user_)
        await sess.commit()
        await sess.refresh(user_)

        token = encode_auth_token(user_.id)

        return jsonify(user_.to_dict() | {"auth-token": token})


@user.post("/who-am-i")
async def who_am_i() -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid token!", 401))

    async with async_session() as sess:
        user_: User = await sess.get(User, user_id)
        return jsonify(user_.to_dict())


@user.get("/get-user-info/<int:user_id>")
async def get_user_info(user_id: int) -> Response:
    token = request.authorization.token
    initiator_id = decode_auth_token(token)

    async with async_session() as sess:
        sess: AsyncSession

        user_: User = await sess.get(User, user_id)

        if not user_:
            abort(405)

        contact: UserContact = (
                (
                    await sess.execute(
                        select(UserContact).where(
                            UserContact.user_id == initiator_id,
                            UserContact.contact_user_id == user_id,
                        )
                    )
                )
                .scalars()
                .unique()
                .one_or_none()
            )

        return jsonify(user_.to_dict() | {"is_contact": contact is not None})


@user.post("/signin")
async def signin() -> Response:
    data = json.loads(request.data.decode("utf-8"))
    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        abort(Response("Missed JSON fields!", 400))

    password_hash = hash_password(password)

    async with async_session() as sess:
        sess: AsyncSession

        user_: User = (
            (await sess.execute(select(User).where(User.username == username)))
            .unique()
            .scalar_one_or_none()
        )
        if not user_:
            abort(Response("User with that username does not exist!", 404))

        if user_.password_hash != password_hash:
            abort(Response("Wrong password!", 400))

        token = encode_auth_token(user_.id)

        return jsonify(user_.to_dict() | {"auth-token": token})


@user.post("/add-contact/<int:user_id>")
async def add_contact(user_id: int) -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")

    initiator_id = decode_auth_token(token)

    if not initiator_id:
        abort(Response("Invalid token!", 401))

    async with async_session() as sess:
        sess: AsyncSession

        initiator_user: User = await sess.get(User, initiator_id)
        contact_user: User = await sess.get(User, user_id)

        if not initiator_user or not contact_user:
            abort(Response("Invalid ID!", 404))

        try:
            contact = UserContact(
                user_id=initiator_user.id, contact_user_id=contact_user.id
            )
            sess.add(contact)
            await sess.commit()
        except exc.IntegrityError:
            abort(409)

    return Response(status=200)


@user.post("/delete-contact/<int:user_id>")
async def delete_contact(user_id: int) -> Response:
    data = json.loads(request.data.decode("utf-8"))
    token = data.get("auth-token")

    initiator_id = decode_auth_token(token)

    if not initiator_id:
        abort(Response("Invalid token!", 401))

    async with async_session.begin() as sess:
        sess: AsyncSession

        initiator: User = (
            (
                await sess.execute(
                    select(User)
                    .options(joinedload(User.contacts))
                    .where(User.id == initiator_id)
                )
            )
            .scalars()
            .unique()
            .one()
        )
        contact: User = await sess.get(User, user_id)

        try:
            initiator.contacts.remove(contact)
        except Exception as err:
            logging.error(err)
            abort(404)

        sess.add(initiator)
        
    return Response(status=200)


@user.get("/get-contacts/<int:user_id>")
async def get_contacts(user_id: int) -> Response:
    async with async_session() as sess:
        sess: AsyncSession

        user_: User = (
            (
                await sess.execute(
                    select(User)
                    .options(joinedload(User.contacts))
                    .where(User.id == user_id)
                )
            )
            .scalars()
            .unique()
            .one()
        )

        if not user_:
            abort(Response("User not found!", 404))

        return jsonify(list(map(User.to_dict, user_.contacts)))


@user.get("/search-for-users/<string:query>")
async def search_for_users(query: str) -> Response:
    async with async_session() as sess:
        sess: AsyncSession
        users = (
            (
                await sess.execute(
                    select(User)
                    .where(
                        or_(
                            func.lower(User.alias).like(f"%{query.lower()}%"),
                            func.lower(User.username).like(f"%{query.lower()}%"),
                        )
                    )
                )
            )
            .unique()
            .scalars()
            .all()
        )

        return jsonify(list(map(User.to_dict, users)))
    

@user.get("/get-user-stat/<int:user_id>")
async def get_user_stat(user_id: int):
    async with async_session.begin() as sess:
        sess: AsyncSession

        user_: User = (
            (
                await sess.execute(
                    select(User)
                    .where(User.id == user_id)
                    .options(joinedload(User.games))
                )
            )
            .scalars()
            .unique()
            .one()
        )

        if not user_:
            abort(404)

        classic_games = list(filter(lambda x: x.is_finished and x.type == 'Classic', user_.games))
        duel_games = list(filter(lambda x: x.is_finished and x.type == 'Duel', user_.games))
        coop_games = list(filter(lambda x: x.is_finished and x.type == 'Cooperative', user_.games))

        return jsonify({
            type: {
                'count': len(games),
                'time': sum(map(lambda x: x.time, games)) / len(games) if games else None,
                'winrate': sum(map(lambda x: x.winner_id == user_id, games)) / len(games) if games else None,
                'mistakes': sum(map(lambda x: x.mistakes, (await sess.execute(select(UserGame).where(UserGame.user_id == user_id, UserGame.game_id.in_([g.id for g in games])))).scalars().unique().all())) / len(games) if games else None
            }
            for type, games in [('All', user_.games), ('Classic', classic_games), ('Duel', duel_games), ('Cooperative', coop_games)]
        })
