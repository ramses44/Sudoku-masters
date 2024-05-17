from flask import Blueprint, request, jsonify, Response, abort
from flask_sse import sse

from sqlalchemy import select, func
from sqlalchemy.orm import joinedload
from sqlalchemy.ext.asyncio import AsyncSession

import logging
from datetime import datetime
import json
from asyncio import sleep

from db.session import async_session
from db.models import User, Sudoku, Game, UserGame
from tools.security import *
from tools.ratings import rating_for_lose, rating_for_win

SUDOKU_TYPES = [
    (4, "Easy"),
    (4, "Medium"),
    (4, "Hard"),
    (9, "Easy"),
    (9, "Medium"),
    (9, "Hard"),
    (16, "Easy"),
]
GAME_TYPES = ["Classic", "Duel", "Cooperative"]

MAX_ANONYM_GAMES_STORE = 50


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

    def __repr__(self) -> str:
        return f"GameState(mistakes: {self.mistakes}, solved: {self.solved})"


game = Blueprint("game", __name__)
awaiting_games: dict[int, list[int]] = {}  # {game_id: [awaiting_player_1, ...]}
game_states: dict[int, dict[int, GameState]] = {}  # {game_id: {player_id: state, ...}}
searching_players_games: dict[int, set[int]] = {}  # {game_id: {joined_player_id, ...}}


def start_game(game: Game) -> None:
    game.start_timestamp = datetime.now()

    if game.type != "Classic":
        game_states[game.id] = {player.id: GameState() for player in game.players}
        sse.publish(
            {"start-timestamp": game.start_timestamp.strftime("%Y-%m-%d %H:%M:%S")},
            type="start",
            channel="game." + str(game.id),
        )


def finish_game(game: Game, time: int = None) -> None:
    game.is_finished = True
    game.time = (
        (datetime.now() - game.start_timestamp).seconds if time is None else time
    )
    game_states.pop(game.id, None)
    sse.publish(
        {
            "winner": game.winner_id,
            "time": game.time,
        },
        type="finish",
        channel=f"game.{game.id}",
    )

    if not game.winner_id:
        return

    for player in game.players:
        player.rating += (
            rating_for_win
            if player.id == game.winner_id
            or game.type == "Cooperative"
            and game.winner_id != -1
            else rating_for_lose
        )(game.type, game.sudoku.size, game.sudoku.difficulty)


async def get_mistakes(game_id: int) -> dict:
    async with async_session() as sess:
        sess: AsyncSession

        mistakes: UserGame = (
            (await sess.execute(select(UserGame).where(UserGame.game_id == game_id)))
            .unique()
            .scalars()
            .all()
        )

        return {record.user_id: record.mistakes for record in mistakes}


@game.get("/get-sudoku/<int:size>/<string:dif>")
async def get_sudoku(size: int, dif: str):
    dif = dif.capitalize()
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

    game_type = data.get("game-type", "").capitalize()
    size = data.get("sudoku-size")
    dif = data.get("sudoku-difficulty", "").capitalize()
    players = data.get("players", [])
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))
    
    if game_type not in GAME_TYPES or (size, dif) not in SUDOKU_TYPES:
        abort(400)

    players = list({user_id} | set(players))

    async with async_session() as sess:
        sess: AsyncSession

        sudoku: Sudoku = (
            await sess.execute(
                select(Sudoku)
                .filter_by(size=size, difficulty=dif)
                .order_by(func.rand())
                .limit(1)
            )
        ).scalar_one()

        game = Game(type=game_type, sudoku=sudoku)

        for player_id in players:
            player: User = await sess.get(User, player_id)
            game.players.append(player)

        sess.add(game)
        await sess.commit()
        await sess.refresh(game)

        game_dict = game.to_dict()

        if game_type != "Classic":
            if len(players) == 1:
                searching_players_games[game.id] = set()
            else:
                awaiting_games[game.id] = players

        return jsonify(game_dict)


@game.post("/game-from-sudoku/<int:sudoku_id>")
async def game_from_sudoku(sudoku_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session() as sess:
        user: User = await sess.get(User, user_id)

        game = Game(type="Classic", sudoku_id=sudoku_id, players=[user])

        sess.add(game)
        await sess.commit()
        await sess.refresh(game)

        game_dict = game.to_dict()

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
        searching_players_games.pop(game_id, None)
        sse.publish({}, type="cancel", channel=f"game.{game_id}")

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
            .one_or_none()
        )

        if not user:
            abort(404)

        games = list(
            map(
                Game.to_dict,
                filter(
                    lambda x: not x.is_finished,
                    user.games
                    + (
                        await sess.execute(
                            select(Game)
                            .where(Game.id.in_(searching_players_games.keys()))
                            .limit(MAX_ANONYM_GAMES_STORE)
                        )
                    )
                    .scalars()
                    .unique()
                    .all(),
                ),
            )
        )

    return jsonify(games)


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
            .one_or_none()
        )

        if not user:
            abort(404)

        games = list(
            map(
                Game.to_dict,
                filter(lambda x: x.is_finished, user.games),
            )
        )

    return jsonify(games)


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

        if user not in game.players and len(game.players) > 1:
            abort(403)

        if game_id in awaiting_games:
            try:
                awaiting_games[game_id].remove(user_id)
            except ValueError:
                pass

            if not awaiting_games[game_id]:
                awaiting_games.pop(game_id)
                start_game(game)
        elif game_id in searching_players_games:
            searching_players_games[game_id] = searching_players_games.get(
                game_id, set()
            ) | {user_id}
            if len(searching_players_games[game_id]) >= 2:
                searching_players_games.pop(game_id)
                if user not in game.players:
                    game.players.append(user)
                start_game(game)
        else:
            abort(410)

        sess.add(game)

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

    game_states[game_id][user_id].solve(x, y)

    sse.publish({user_id: [x, y]}, type="solve-cell", channel="game." + str(game_id))

    return Response(status=200)


@game.post("/lose/<int:game_id>")
async def lose(game_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    time = data.get("time")
    mistakes = data.get("mistakes")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session.begin() as sess:
        game: Game = await sess.get(Game, game_id)
        user_game: UserGame = (
            (
                await sess.execute(
                    select(UserGame).where(
                        UserGame.user_id == user_id,
                        UserGame.game_id == game_id,
                    )
                )
            )
            .scalars()
            .unique()
            .one()
        )

        if not user_game:
            abort(403)

        if game.type == "Duel":
            other_player_id = (
                game.players[1].id
                if game.players[0].id == user_id
                else game.players[0].id
            )
            game.winner_id = other_player_id
        else:
            game.winner_id = -1

        if mistakes:
            user_game.mistakes = mistakes
        finish_game(game, time)

        sess.add(game)
        sess.add(user_game)

    return Response(status=200)


@game.post("/win/<int:game_id>")
async def win(game_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    time = data.get("time")
    mistakes = data.get("mistakes")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session.begin() as sess:
        game: Game = await sess.get(Game, game_id)
        user_game: UserGame = (
            (
                await sess.execute(
                    select(UserGame).where(
                        UserGame.user_id == user_id,
                        UserGame.game_id == game_id,
                    )
                )
            )
            .scalars()
            .unique()
            .one()
        )

        if not user_game:
            abort(403)

        game.winner_id = user_id
        if mistakes:
            user_game.mistakes = mistakes
        finish_game(game, time)

        sess.add(game)
        sess.add(user_game)

    return Response(status=200)


@game.post("/mistake/<int:game_id>")
async def mistake(game_id: int):
    data = json.loads(request.data.decode())
    token = data.get("auth-token")
    user_id = decode_auth_token(token)

    if not user_id:
        abort(Response("Invalid auth-token!", 401))

    async with async_session.begin() as sess:
        sess: AsyncSession

        user_game: UserGame = (
            (
                await sess.execute(
                    select(UserGame).where(
                        UserGame.user_id == user_id,
                        UserGame.game_id == game_id,
                    )
                )
            )
            .scalars()
            .unique()
            .one()
        )

        if not user_game:
            abort(403)

        user_game.mistakes += 1
        game_states[game_id][user_id].mistake()
        sess.add(user_game)

    sse.publish({user_id: user_id}, type="mistake", channel="game." + str(game_id))

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

    return jsonify(
        {
            player_id: game_state.to_dict()
            for player_id, game_state in game_states[game_id].items()
        }
    )


@game.get("/get-internal-structs")
async def get_internal_structs():
    return jsonify(
        awaiting_games=str(awaiting_games),
        game_states=str(game_states),
        searching_players_games=str(searching_players_games),
    )
