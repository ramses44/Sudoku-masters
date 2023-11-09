#include "solver.h"

std::optional<Sudoku> SudokuSolver::EasySolve(bool save) {
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
                    auto nums = GetAvailableNumbersForCell(i, j);
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

std::optional<Sudoku> SudokuSolver::MediumSolve() {
    if (EasySolve(false).has_value()) {
        return _sudoku;
    }

    _solved = std::nullopt;
    TrySolve(normal_rec_depth);

    if (!_solved.has_value()) {
        return std::nullopt;
    }

    Sudoku saved = Sudoku(_solved.value());

    TrySolve(normal_rec_depth, true);

    return saved == _solved.value() ? std::optional(saved) : std::nullopt;
}

std::optional<Sudoku> SudokuSolver::HardSolve() {
    if (EasySolve(false).has_value()) {
        return _sudoku;
    }

    _solved = std::nullopt;
    TrySolve(enough_rec_depth);

    if (!_solved.has_value()) {
        return std::nullopt;
    }

    Sudoku saved = Sudoku(_solved.value());

    TrySolve(enough_rec_depth, true);

    return saved == _solved.value() ? std::optional(saved) : std::nullopt;
}

std::set<size_t> SudokuSolver::GetAvailableNumbersForCell(size_t i, size_t j) const {
    std::set<size_t> res;

    for (size_t k = 1; k <= _sudoku.size(); ++k) {
        res.insert(k);
    }

    // Sift for row and cols
    for (int p = 0; p < _sudoku.size(); ++p) {
        res.erase(_sudoku[i][p].number);
        res.erase(_sudoku[p][j].number);
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
            res.erase(_sudoku[ii][jj].number);
        }
    }

    return std::move(res);
}

void SudokuSolver::TrySolve(size_t max_rec_depth, bool reverse) {
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

            auto avail = GetAvailableNumbersForCell(i, j);
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

        if (EasySolve(false).has_value()) {
            _solved = Sudoku(_sudoku);
        } else {
            TrySolve(max_rec_depth - 1);
        }

        _sudoku = Sudoku(saved);

        return _solved.has_value();
    };

    auto avail = GetAvailableNumbersForCell(mi, mj);
    if (reverse) {
        for (auto it = avail.rbegin(); it != avail.rend(); ++it) {
            if (try_substitute(*it)) return;
        }
    } else {
        for (auto it = avail.begin(); it != avail.end(); ++it) {
            if (try_substitute(*it)) return;
        }
    }
}
