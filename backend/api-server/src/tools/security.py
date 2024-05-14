from hashlib import md5
import jwt

import logging
from pathlib import Path
from os import environ

PUB_KEY = Path(environ.get('PUBLIC_KEY_PATH')).read_text()
PRV_KEY = Path(environ.get('PRIVATE_KEY_PATH')).read_text()
JWT_ALGORITHM = environ.get('JWT_ALGORITHM', 'RS256')


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
