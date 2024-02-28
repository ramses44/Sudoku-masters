#include "solver.h"

std::optional<Sudoku> SudokuSolver::_EasySolve(bool save) {
    bool changed = true;
    std::optional<Sudoku> saved;

    if (save) {
        saved = Sudoku(_sudoku);
    }

    while (!_sudoku.IsFilled() && changed) {
        changed = false;

        for (int i = 0; i < _sudoku.size(); ++i) {
            for (int j = 0; j < _sudoku.size(); ++j) {
                if (_sudoku[i][j].number == 0) {
                    auto nums = _GetAvailableNumbersForCell(i, j);
                    if (nums.size() == 1) {
                        _sudoku[i][j].number = *nums.begin();
                        changed = true;
                    }
                }
            }
        }
    }

    if (save && !_sudoku.IsFilled()) {
        _sudoku = std::move(saved.value());
    }

    return _sudoku.IsFilled() ? std::optional(_sudoku) : std::nullopt;
}

std::optional<Sudoku> SudokuSolver::_MediumSolve() {
    if (_EasySolve(false).has_value()) {
        return _sudoku;
    }

    _solved = std::nullopt;
    _TrySolve(normal_rec_depth);

    return _solved;
}

std::optional<Sudoku> SudokuSolver::_HardSolve() {
    if (_EasySolve(false).has_value()) {
        return _sudoku;
    }

    _solved = std::nullopt;
    _TrySolve(enough_rec_depth);

    return _solved;
}

std::vector<size_t> SudokuSolver::_GetAvailableNumbersForCell(size_t i, size_t j) const {
    std::vector<bool> avail(_sudoku.size() + 1, true);
    avail[0] = false;

    // Sift for row and cols
    for (int p = 0; p < _sudoku.size(); ++p) {
        avail[_sudoku[i][p].number] = false;
        avail[_sudoku[p][j].number] = false;
    }

    // Sift for section
    size_t si = i / _sudoku.SubSize();
    size_t sj = j / _sudoku.SubSize();

    for (size_t ii = si * _sudoku.SubSize();
         ii < (si + 1) * _sudoku.SubSize();
         ++ii) {
        for (size_t jj = sj * _sudoku.SubSize();
             jj < (sj + 1) * _sudoku.SubSize();
             ++jj) {
            avail[_sudoku[ii][jj].number] = false;
        }
    }

    std::vector<size_t> res;
    res.reserve(avail.size());

    for (size_t k = 0; k < avail.size(); ++k) {
        if (avail[k]) {
            res.push_back(k);
        }
    }

    return std::move(res);
}

void SudokuSolver::_TrySolve(size_t max_rec_depth) {
    if (max_rec_depth < 0) {
        return;
    }

    Sudoku saved = Sudoku(_sudoku);

    // find cell with minimum available numbers
    size_t mi = 0;
    size_t mj = 0;
    size_t variants = SIZE_MAX;

    for (int i = 0; i < _sudoku.size(); ++i) {
        for (int j = 0; j < _sudoku.size(); ++j) {
            if (_sudoku[i][j].number != 0) {
                continue;
            }

            auto avail = _GetAvailableNumbersForCell(i, j);
            if (avail.empty()) {
                return;
            }

            if (avail.size() < variants) {
                variants = avail.size();
                mi = i;
                mj = j;
            }
        }
    }

    auto try_substitute = [&](size_t num) {
        _sudoku[mi][mj].number = num;

        if (_EasySolve(false).has_value()) {
            _solved = Sudoku(_sudoku);
        } else {
            _TrySolve(max_rec_depth - 1);
        }

        _sudoku = Sudoku(saved);

        return _solved.has_value();
    };

    auto avail = _GetAvailableNumbersForCell(mi, mj);
    if (_reverse) {
        for (auto it = avail.rbegin(); it != avail.rend(); ++it) {
            if (try_substitute(*it)) return;
        }
    } else {
        for (auto it = avail.begin(); it != avail.end(); ++it) {
            if (try_substitute(*it)) return;
        }
    }
}

std::optional<Sudoku> SudokuSolver::Solve(Difficulty difficulty) {
    switch (difficulty) {
        case Difficulty::easy:
            return _EasySolve();
        case Difficulty::medium:
            return _MediumSolve();
        case Difficulty::hard:
            return _HardSolve();
    }

    return std::nullopt;
}