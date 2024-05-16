from sqlalchemy import (
    Table,
    Column,
    Integer,
    String,
    Float,
    Boolean,
    Enum,
    Text,
    ForeignKey,
    LargeBinary,
    DateTime,
)
from sqlalchemy.orm import relationship
from datetime import datetime

from db.session import Base

Table(
    "user_chat",
    Base.metadata,
    Column("user_id", Integer, ForeignKey("user.id"), primary_key=True),
    Column("chat_id", Integer, ForeignKey("chat.id"), primary_key=True),
)

class UserGame(Base):
    __tablename__ = "user_game"
    user_id = Column(Integer, ForeignKey("user.id"), primary_key=True)
    game_id = Column(Integer, ForeignKey("game.id"), primary_key=True)
    mistakes = Column(Integer, nullable=False, default=0)


class UserContact(Base):
    __tablename__ = "user_contact"

    user_id = Column(Integer, ForeignKey("user.id"), primary_key=True)
    contact_user_id = Column(Integer, ForeignKey("user.id"), primary_key=True)


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(32), nullable=False, unique=True)
    password_hash = Column(LargeBinary(32), nullable=False)
    alias = Column(String(64), nullable=False)
    rating = Column(Float, nullable=False, default=0)

    games = relationship(
        "Game", secondary="user_game", back_populates="players", lazy="joined"
    )
    contacts = relationship(
        "User",
        secondary=UserContact.__table__,
        primaryjoin=UserContact.user_id == id,
        secondaryjoin=UserContact.contact_user_id == id,
        backref="user_id",
        lazy="joined",
    )
    chats = relationship(
        "Chat", secondary="user_chat", back_populates="participants", lazy="selectin"
    )

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "username": self.username,
            "alias": self.alias,
            "rating": int(self.rating),
        }


class Sudoku(Base):
    __tablename__ = "sudoku"

    id = Column(Integer, primary_key=True, autoincrement=True)
    difficulty = Column(String(16), nullable=False)
    size = Column(Integer, nullable=False)
    data = Column(LargeBinary, nullable=False)

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "difficulty": self.difficulty,
            "size": self.size,
            "data": self.data.decode(),
        }


class Game(Base):
    __tablename__ = "game"

    id = Column(Integer, primary_key=True, autoincrement=True)
    type = Column(String(16), nullable=False, default="Classic")
    sudoku_id = Column(Integer, ForeignKey("sudoku.id"), nullable=False)
    start_timestamp = Column(DateTime, nullable=True)
    is_finished = Column(Boolean, nullable=False, default=False)
    winner_id = Column(Integer, ForeignKey("user.id"), nullable=True)
    time = Column(Integer, default=0)

    players = relationship(
        "User", secondary="user_game", back_populates="games", lazy="joined"
    )
    sudoku = relationship("Sudoku", foreign_keys=[sudoku_id], lazy="joined")

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "type": self.type,
            "sudoku": self.sudoku.to_dict(),
            "start": (
                self.start_timestamp.strftime("%Y-%m-%d %H:%M:%S")
                if self.start_timestamp
                else None
            ),
            "is_finished": self.is_finished,
            "winner": self.winner_id,
            "players": list(map(User.to_dict, self.players)),
            "time": self.time if self.is_finished or not self.start_timestamp else (datetime.now() - self.start_timestamp).seconds
        }


class Chat(Base):
    __tablename__ = "chat"

    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(64), nullable=False)
    is_private = Column(Boolean, nullable=False, default=False)

    messages = relationship("Message", back_populates="chat", lazy="joined")
    participants = relationship(
        "User", secondary="user_chat", back_populates="chats", lazy="selectin"
    )

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "title": self.title,
            "is_private": self.is_private,
            "participants": list(map(User.to_dict, self.participants)),
        }


class Message(Base):
    __tablename__ = "message"

    id = Column(Integer, primary_key=True, autoincrement=True)
    chat_id = Column(Integer, ForeignKey("chat.id"), nullable=False)
    sender_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    type = Column(
        Enum("TEXT", "SUDOKU", "CONTACT", "CHAT_INVITATION"),
        nullable=False,
        default="TEXT",
    )
    data = Column(Text)
    sending_datetime = Column(DateTime, nullable=False, default=datetime.now)

    chat = relationship("Chat", foreign_keys=[chat_id], lazy="joined")
    sender = relationship("User", foreign_keys=[sender_id], lazy="joined")

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "chat": self.chat_id,
            "sender": self.sender.to_dict(),
            "type": self.type,
            "data": self.data,
            "sending_datetime": self.sending_datetime.strftime("%Y-%m-%d %H:%M"),
        }
