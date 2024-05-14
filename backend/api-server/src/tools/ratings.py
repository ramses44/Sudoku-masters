weights = {
    "game_type": {
        'Classic': 1,
        'Cooperative': 0.5,
        'Duel': 2
    },
    "sudoku": {
        (4, 'easy'): 0.1,
        (4, 'medium'): 0.15,
        (4, 'hard'): 0.2,
        (9, 'easy'): 1,
        (9, 'medium'): 2,
        (9, 'hard'): 4,
        (16, 'easy'): 4
    }
}


def rating_for_win(game_type: str, size: int, difficulty: str) -> float:
    return weights['game_type'][game_type] * weights['sudoku'][(size, difficulty)]


def rating_for_lose(game_type: str, size: int, difficulty: str) -> float:
    return -2 / rating_for_win(game_type, size, difficulty)
