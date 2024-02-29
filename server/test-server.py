from flask import Flask, jsonify
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from db import models, session


app = Flask(__name__)


@app.route("/get-users")
async def get_users():
    async with session.async_session() as sess:
        users = await sess.execute(select(models.User))
        
        return str(list(map(lambda x: x.__dict__, users.scalars().all())))


@app.route("/add-chat")
async def add_chat():
    async with session.async_session() as sess:
        chat = models.Chat(title='test_chat')
        sess.add(chat)
        await sess.commit()
        await sess.refresh(chat)

        return str(chat.id)
    

@app.route("/add-user")
async def add_user():
    async with session.async_session() as sess:
        user = models.User(username='admin', password_hash=b'ashfthndtoyghtpoudtntyuonfromnsb', alias='administrator')
        sess.add(user)
        await sess.commit()
        await sess.refresh(user)

        return str(user.id)
    

@app.route("/relate-user-chat")
async def relate_user_chat():
    async with session.async_session() as sess:
        user: models.User = await sess.get(models.User, 1)
        chat: models.Chat = await sess.get(models.Chat, 1)

        user.chats.append(chat)
        print(chat.participants)

        sess.add(user)
        sess.add(chat)

        await sess.commit()

        return 'OK'
    

@app.route("/send-message")
async def send_message():
    async with session.async_session() as sess:
        user: models.User = await sess.get(models.User, 1)
        chat: models.Chat = await sess.get(models.Chat, 1)

        msg = models.Message(chat=chat, sender=user, data='test msg 1')

        chat.messages.append(msg)
        print('QWERTY', len(chat.messages))

        sess.add(msg)

        await sess.commit()

        return 'OK'
    

@app.route("/create-game")
async def create_game():
    async with session.async_session() as sess:
        user: models.User = await sess.get(models.User, 1)

        sudoku = models.Sudoku(difficulty='EASY', size=0, data=b'55')
        game = models.Game(sudoku=sudoku, players=[user])

        sess.add(game)
        await sess.commit()

        return 'OK'


app.run(host='0.0.0.0', port=8080)
