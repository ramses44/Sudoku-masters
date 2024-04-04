from flask import Blueprint, request, jsonify, Response, abort
from flask_sse import sse

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

import logging
from os import environ
import subprocess
from random import shuffle
from threading import Thread, Lock, Condition

from db.session import async_session
from db.models import User, Sudoku, Game
from tools.security import *

GENERATOR_APP_PATH = environ.get('GENERATOR_APP_PATH')
GENERATION_TIMEOUT = environ.get('GENERATION_TIMEOUT', 15)  # Seconds
THREDS_COUNT = environ.get('THREADS', 1)

SUDOKU_TYPES = [(4, 'easy'), (4, 'medium'), (4, 'hard'),
                (9, 'easy'), (9, 'medium'), (9, 'hard'),
                (16, 'easy')]


game = Blueprint('game', __name__)