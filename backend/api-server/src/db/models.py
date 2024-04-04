from sqlalchemy import Table, Column, Integer, String, Boolean, Enum, Text, ForeignKey, LargeBinary, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from db.session import Base

Table('user_chat', Base.metadata, 
      Column('user_id', Integer, ForeignKey('user.id'), primary_key=True),
      Column('chat_id', Integer, ForeignKey('chat.id'), primary_key=True))

Table('user_game', Base.metadata, 
      Column('user_id', Integer, ForeignKey('user.id'), primary_key=True),
      Column('game_id', Integer, ForeignKey('game.id'), primary_key=True))


class UserContact(Base):
    __tablename__ = 'user_contact'

    user_id = Column(Integer, ForeignKey('user.id'), primary_key=True)
    contact_user_id = Column(Integer, ForeignKey('user.id'), primary_key=True)


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(32), nullable=False, unique=True)
    password_hash = Column(LargeBinary(32), nullable=False)
    alias = Column(String(64), nullable=False)
    rating = Column(Integer, nullable=False, default=0)

    games = relationship('Game', secondary='user_game', back_populates='players', lazy='joined')
    contacts = relationship('User', secondary=UserContact.__table__,
                                    primaryjoin=UserContact.user_id==id,
                                    secondaryjoin=UserContact.contact_user_id==id,
                                    backref='user_id', lazy='joined')
    chats = relationship('Chat', secondary='user_chat', back_populates='participants', lazy='selectin')


class Sudoku(Base):
    __tablename__ = "sudoku"

    id = Column(Integer, primary_key=True, autoincrement=True)
    difficulty = Column(String(16), nullable=False)
    size = Column(Integer, nullable=False)
    data = Column(LargeBinary, nullable=False)


class Game(Base):
    __tablename__ = "game"

    id = Column(Integer, primary_key=True, autoincrement=True)
    type = Column(String(16), nullable=False, default='Classic')
    sudoku_id = Column(Integer, ForeignKey('sudoku.id'), nullable=False)
    status = Column(Enum('IN_PROGRESS', 'WON', 'LOST', 'DRAW'), nullable=False, default='IN_PROGRESS')

    players = relationship('User', secondary='user_game', back_populates='games', lazy='joined')
    sudoku = relationship('Sudoku', foreign_keys=[sudoku_id], lazy='joined')


class Chat(Base):
    __tablename__ = "chat"

    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(64), nullable=False)
    is_private = Column(Boolean, nullable=False, default=False)

    messages = relationship('Message', back_populates='chat', lazy='joined')
    participants = relationship('User', secondary='user_chat', back_populates='chats', lazy='selectin')


class Message(Base):
    __tablename__ = "message"

    id = Column(Integer, primary_key=True, autoincrement=True)
    chat_id = Column(Integer, ForeignKey('chat.id'), nullable=False)
    sender_id = Column(Integer, ForeignKey('user.id'), nullable=False)
    type = Column(Enum('TEXT', 'SUDOKU', 'CONTACT', 'CHAT_INVITATION', 'GAME_SUGGESTION'), nullable=False, default='TEXT')
    data = Column(Text)
    sending_datetime = Column(DateTime(timezone=True), nullable=False, default=datetime.now)

    chat = relationship('Chat', foreign_keys=[chat_id], lazy='joined')
    sender = relationship('User', foreign_keys=[sender_id], lazy='joined')

