from flask import Blueprint, request, jsonify, Response, abort
from flask_sse import sse

from sqlalchemy import select, func
from sqlalchemy.orm import joinedload
from sqlalchemy.ext.asyncio import AsyncSession

import logging
from datetime import datetime
import json

from db.session import async_session
from db.models import User, Sudoku, Game
from tools.security import *

SUDOKU_TYPES = [
    (4, "easy"),
    (4, "medium"),
    (4, "hard"),
    (9, "easy"),
    (9, "medium"),
    (9, "hard"),
    (16, "easy"),
]
GAME_TYPES = ["Classic", "Duel", "Cooperative"]


class GameState:
    def __init__(self) -> None:
        self.mistakes = 0
        self.solved = set()

    def solve(self, x, y) -> None:
        self.solved.add((x, y))

    def mistake(self) -> int:
        self.mistakes += 1
        return self.mistakes

    def to_dict(self) -> dict:
        return {"mistakes": self.mistakes, "solved-cells": list(self.solved)}


game = Blueprint("game", __name__)
awaiting_games: dict[int, list[int, int]] = {}  # {game_id: [awaiting_player_1, ...]}
game_states: dict[int, dict[int, GameState] | GameState] = (
    {}
)  # {game_id: {player_id: state, ...} | state}


@sse.before_request
async def check_access():
    token = request.args.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    game_id = int(request.args.get("channel", -1))

    async with async_session() as sess:
        game: Game = await sess.get(Game, game_id)
        user: User = await sess.get(User, user_id)

        if not game:
            abort(404)

        if user not in game.players:
            abort(403)

        if game.end_timestamp:
            abort(410)


game.register_blueprint(sse, url_prefix="/listen")


def start_game(game: Game) -> None:
    game.start_timestamp = datetime.now()
    game_states[game.id] = (
        {player.id: GameState() for player in game.players}
        if game.type == "Duel"
        else GameState()
    )
    sse.publish(
        {"start-timestamp": game.start_timestamp.strftime("%Y-%m-%d %H:%M:%S")},
        type="start",
        channel=str(game.id),
    )


def finish_game(game: Game) -> None:
    game.end_timestamp = datetime.now()
    game_states.pop(game.id, None)
    sse.publish(
        {
            "winner": game.winner_id,
            "end-timestamp": game.start_timestamp.strftime("%Y-%m-%d %H:%M:%S"),
        },
        type="finish",
        channel=str(game.id),
    )


@game.get("/get-sudoku/<int:size>/<string:dif>")
async def get_sudoku(size: int, dif: str):
    if (size, dif) not in SUDOKU_TYPES:
        abort(400)

    async with async_session() as sess:
        sess: AsyncSession

        query = await sess.execute(
            select(Sudoku)
            .filter_by(size=size, difficulty=dif)
            .order_by(func.rand())
            .limit(1)
        )
        sudoku: Sudoku = query.scalar_one()

        return jsonify(sudoku.to_dict())


@game.get("/get-sudoku/<int:id>")
async def get_sudoku_by_id(id: int):
    async with async_session() as sess:
        sess: AsyncSession

        sudoku: Sudoku = await sess.get(Sudoku, id)

        if not sudoku:
            abort(404)

        return jsonify(sudoku.to_dict())


@game.post("/create-game")
async def create_game():
    data = json.loads(request.data.decode())

    game_type = data.get("game-type")
    size = data.get("sudoku-size")
    dif = data.get("sudoku-difficulty")
    players = data.get("players")
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    if game_type not in GAME_TYPES and (size, dif) not in SUDOKU_TYPES:
        abort(400)

    if (
        user_id not in players
        or game_type == "Classic"
        and len(players) != 1
        or game_type != "Classic"
        and len(players) != 2
    ):
        abort(400)

    async with async_session() as sess:
        sess: AsyncSession

        sidoku_query = await sess.execute(
            select(Sudoku)
            .filter_by(size=size, difficulty=dif)
            .order_by(func.rand())
            .limit(1)
        )
        sudoku: Sudoku = sidoku_query.scalar_one()

        game = Game(type=game_type, sudoku=sudoku)

        for player_id in players[:2]:
            player: User = await sess.get(User, player_id)
            game.players.append(player)

        sess.add(game)
        await sess.commit()
        await sess.refresh(game)

        game_dict = game.to_dict()

        awaiting_games[game.id] = game_dict["players"]

        return jsonify(game_dict)


@game.post("/cancel-game/<int:game_id>")
async def cancel_game(game_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session.begin() as sess:
        game: Game = await sess.get(Game, game_id)
        user: User = await sess.get(User, user_id)

        if not game:
            abort(404)

        if user not in game.players:
            abort(403)

        if game.start_timestamp:
            abort(Response("Cannot cancel started game!", 406))

        await sess.delete(game)

        awaiting_games.pop(game_id, None)

    return Response(status=200)


@game.get("/get-active-games/<int:user_id>")
async def get_active_games(user_id: int):
    async with async_session() as sess:
        user: User = (
            (
                await sess.execute(
                    select(User)
                    .options(joinedload(User.games).joinedload(Game.players))
                    .where(User.id == user_id)
                )
            )
            .scalars()
            .unique()
            .one()
        )

        games = list(
            map(
                Game.to_dict,
                filter(lambda x: not x.end_timestamp, user.games),
            )
        )

    return jsonify({"active-games": games})


@game.get("/get-finished-games/<int:user_id>")
async def get_finished_games(user_id: int):
    async with async_session() as sess:
        user: User = (
            (
                await sess.execute(
                    select(User)
                    .options(joinedload(User.games).joinedload(Game.players))
                    .where(User.id == user_id)
                )
            )
            .scalars()
            .unique()
            .one()
        )

        games = list(
            map(
                Game.to_dict,
                filter(lambda x: x.end_timestamp, user.games),
            )
        )

    return jsonify({"finished-games": games})


@game.post("/join-game/<int:game_id>")
async def join_game(game_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session.begin() as sess:
        game: Game = await sess.get(Game, game_id)
        user: User = await sess.get(User, user_id)

        if not game:
            abort(404)

        if user not in game.players:
            abort(403)

        if game.id not in awaiting_games:
            abort(410)

        try:
            awaiting_games[game.id].remove(user_id)
        except ValueError:
            pass

        if not awaiting_games[game.id]:
            start_game(game)

    return Response(status=200)


@game.post("/solve-cell/<int:game_id>/<int:x>/<int:y>")
async def solve_cell(game_id: int, x: int, y: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    if game_id not in game_states:
        abort(404)

    async with async_session() as sess:
        game: Game = await sess.get(Game, game_id)
        user: User = await sess.get(User, user_id)

        if user not in game.players:
            abort(403)

    if type(game_states[game_id]) == GameState:
        game_states[game_id].solve(x, y)
    else:
        game_states[game_id][user_id].solve(x, y)

    sse.publish({user_id: [x, y]}, type="solve-cell", channel=str(game_id))

    return Response(status=200)


@game.post("/give-up/<int:game_id>")
async def give_up(game_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session.begin() as sess:
        game: Game = await sess.get(Game, game_id)
        user: User = await sess.get(User, user_id)

        if user not in game.players:
            abort(403)

        if game.type == "Duel":
            other_player_id = (
                game.players[1].id
                if game.players[0].id == user_id
                else game.players[0].id
            )
            game.winner_id = other_player_id

        finish_game(game)

        sess.add(game)

    return Response(status=200)


@game.post("/win/<int:game_id>")
async def win(game_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session.begin() as sess:
        game: Game = await sess.get(Game, game_id)
        user: User = await sess.get(User, user_id)

        if user not in game.players:
            abort(403)

        game.winner_id = user_id
        finish_game(game)

        sess.add(game)

    return Response(status=200)


@game.post("/mistake/<int:game_id>")
async def mistake(game_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session() as sess:
        game: Game = await sess.get(Game, game_id)
        user: User = await sess.get(User, user_id)

        if user not in game.players:
            abort(403)

        if type(game_states[game_id]) == GameState:
            game_states[game_id].mistake()
        else:
            game_states[game_id][user_id].mistake()

    sse.publish({user_id: None}, type="mistake", channel=str(game_id))

    return Response(status=200)


@game.get("/get-game-info/<int:game_id>")
async def get_game_info(game_id: int):
    async with async_session() as sess:
        game: Game = await sess.get(Game, game_id)

        if not game:
            abort(404)

        return jsonify(game.to_dict())


@game.get("/get-game-state/<int:game_id>")
async def get_game_state(game_id: int):
    if game_id not in game_states:
        abort(404)

    if type(game_states[game_id]) == GameState:
        state = game_states[game_id].to_dict()
    else:
        state = {
            player_id: game_state.to_dict()
            for player_id, game_state in game_states[game_id].items()
        }

    return jsonify(state)
