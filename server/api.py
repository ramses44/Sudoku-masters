from flask import Flask, request, jsonify, Response, abort
from flask_sse import sse

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

import json
from hashlib import md5
import jwt

import logging
from pathlib import Path
from os import environ

from db.session import async_session
from db.models import *

PUB_KEY = Path(environ.get('PUBLIC_KEY_PATH')).read_text()
PRV_KEY = Path(environ.get('PRIVATE_KEY_PATH')).read_text()
JWT_ALGORITHM = environ.get('JWT_ALGORITHM', 'RS256')

app = Flask(__name__)
app.config['REDIS_URL'] = environ.get('REDIS_URL')

@sse.before_request
async def check_access():
    token = request.args.get('auth-token')
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 400))

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
                
                
app.register_blueprint(sse, url_prefix='/listen')


def hash_password(password: str) -> bytes:
    """Реализация функции хэширования пароля. Возвращает бинарный хэш"""
    pwd_hash = md5(password.encode()).hexdigest()
    return pwd_hash.encode()


def encode_auth_token(user_id: int) -> str:
    """Генерирует JWT токен, содержащий поле user-id, используя, указанные в константах параметры"""
    token = jwt.encode({'user-id': user_id}, PRV_KEY, algorithm=JWT_ALGORITHM)
    return token


def decode_auth_token(token: str) -> int | None:
    """Возвращает ID пользователя по токену. Если токен невалидный, возвращается None"""
    try:
        jwt_data = jwt.decode(token, PUB_KEY, algorithms=[JWT_ALGORITHM])
        return jwt_data.get('user-id')
    except Exception as err:
        logging.error(err)


def encode_invite_token(invitor_id: int, chat_id: int) -> str:
    """Генерирует JWT токен, содержащий информацию о приглашении в чат, используя, указанные в константах параметры"""
    token = jwt.encode({'invitor-id': invitor_id, 'chat-id': chat_id}, PRV_KEY, algorithm=JWT_ALGORITHM)
    return token


def decode_invite_token(token: str) -> tuple[int, int] | None:
    """Возвращает котртеж из ID пригласителя и чата по токену. Если токен невалидный, возвращается None"""
    try:
        jwt_data = jwt.decode(token, PUB_KEY, algorithms=[JWT_ALGORITHM])
        return (jwt_data['invitor-id'], jwt_data['chat-id']
                ) if 'invitor-id' in jwt_data and 'chat-id' in jwt_data else None
    except Exception as err:
        logging.error(err)


def is_valid_password(password: str) -> bool:
    """Предикат, удовлетворяет ли пароль требованиям безопасности."""
    return 8 <= len(password) <= 64


@app.post('/signup')
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


@app.post('/signin')
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
            abort(Response('User with that username does not exist!', 400))
        
        if user.password_hash != password_hash:
            abort(Response('Wrong password!', 400))
    
        token = encode_auth_token(user.id)
        
    return jsonify({'auth-token': token})


@app.post('/add-contact/<username>')
async def add_contact(username: str) -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    
    initiator_id = decode_auth_token(token)

    if not initiator_id:
        abort(Response('Invalid token!', 400))
    
    async with async_session() as sess:
        sess: AsyncSession

        initiator_user: User = await sess.get(User, initiator_id)
        contact_user: User = (await sess.execute(select(User).where(User.username == username))).unique().scalar_one_or_none()

        if not initiator_user or not contact_user:
            abort(Response('Invalid username!', 400))
    
        contact = UserContact(user_id=initiator_user.id, contact_user_id=contact_user.id)
        sess.add(contact)
        await sess.commit()

    return Response(status=200)


@app.post('/join-chat/<int:chat_id>')
async def join_chat(chat_id: int) -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    invite_token = data.get('invite-token')
    
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 400))
    
    async with async_session() as sess:
        sess: AsyncSession
        
        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if not user:
            abort(Response('Invalid username!', 400))
        if not chat:
            abort(Response('Chat not found!', 404))
        
        if chat.is_private:
            token_data = decode_invite_token(invite_token)

            if not token_data:
                abort(Response('This chat is private!', 403))

            invitor = await sess.get(User, token_data[0])

            if token_data[1] != chat_id or invitor not in chat.participants:
                abort(Response('Invalid invite-token!', 400))
            
        chat.participants.append(user)

        sess.add(chat)
        await sess.commit()

    return Response(status=200)


@app.post('/get-invite-token/<int:chat_id>')
async def get_invite_token(chat_id: int) -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 400))
    
    async with async_session() as sess:
        sess: AsyncSession
        
        chat: Chat = await sess.get(Chat, chat_id)
        user: User = await sess.get(User, user_id)

        if user not in chat.participants:
            abort(Response('You are not a chat participant!', 403))
        
        token = encode_invite_token(user_id, chat_id)

    return jsonify({'invite-token': token})


@app.post('/create-chat')
async def create_chat() -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    chat_title = data.get('chat-title')
    chat_is_private = data.get('is-private')

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 400))

    async with async_session() as sess:
        sess: AsyncSession
        
        user: User = await sess.get(User, user_id)
        chat = Chat(title=chat_title, is_private=chat_is_private)
        chat.participants.append(user)
        sess.add(chat)

        await sess.commit()
        await sess.refresh(chat)

        return jsonify({'chat-id': chat.id})
        

@app.post('/send-message/<chat_id>')
async def send_message(chat_id: int) -> Response:
    data = json.loads(request.data.decode('utf-8'))
    token = data.get('auth-token')
    msg_type = data.get('msg-type')
    msg_data = data.get('msg-data')

    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response('Invalid auth-token!', 400))

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


if __name__ == '__main__':
    app.run(environ.get('SERVER_HOST', '0.0.0.0'), environ.get('SERVER_PORT', 80))
