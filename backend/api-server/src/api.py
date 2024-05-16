from flask import Flask, request, abort, Response
from os import environ
from endpoints.messenger import messenger
from endpoints.game import game
from endpoints.user import user
from flask_sse import sse

from tools.security import *
from db.session import async_session
from db.models import User, Chat, Game


app = Flask(__name__)
app.config["REDIS_URL"] = environ.get("REDIS_URL")


@sse.before_request
async def check_access_game():
    token = request.authorization.token
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    channel = request.args.get("channel", ".").split(".")

    match channel[0]:
        case "message":
            chat_id = int(channel[1])

            async with async_session() as sess:
                chat: Chat = await sess.get(Chat, chat_id)
                user_: User = await sess.get(User, user_id)

                if user_ not in chat.participants:
                    abort(Response("You are not a chat participant!", 403))
        case "game":
            game_id = int(channel[1])

            async with async_session() as sess:
                game: Game = await sess.get(Game, game_id)
                user_: User = await sess.get(User, user_id)

                if not game:
                    abort(404)

                if user_ not in game.players:
                    abort(403)

                if game.is_finished:
                    abort(410)


app.register_blueprint(messenger, url_prefix="/messenger")
app.register_blueprint(game, url_prefix="/game")
app.register_blueprint(user, url_prefix="/user")
app.register_blueprint(sse, url_prefix="/listen")

@app.get("/publish/<string:channel>/<string:type>/<string:data>")
async def get_game_state(channel, type, data):
    sse.publish(data, type=type, channel=channel)
    return Response(status=200)

if __name__ == "__main__":
    app.run(
        environ.get("SERVER_HOST", "0.0.0.0"), environ.get("SERVER_PORT", 80)
    )
