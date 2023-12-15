#include <thread>
#include "solver.h"

std::atomic<int> SudokuSolver::threads_available = 2;

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

std::optional<Sudoku> SudokuSolver::_MediumSolve() {
    if (_EasySolve(false).has_value()) {
        return _sudoku;
    }

    _solved = std::nullopt;
    TrySolve(normal_rec_depth);

    return _solved;
}

std::optional<Sudoku> SudokuSolver::_HardSolve() {
    if (_EasySolve(false).has_value()) {
        return _sudoku;
    }

    _solved = std::nullopt;
    TrySolve(enough_rec_depth);

    return _solved;
}

std::vector<size_t> SudokuSolver::GetAvailableNumbersForCell(size_t i, size_t j) const {
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

void SudokuSolver::TrySolve(size_t max_rec_depth) {
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

    auto try_solve = [&saved](SudokuSolver* executor, size_t max_rec_depth, bool threaded = false) {
        if (executor->_EasySolve(false).has_value()) {
            executor->_solved = Sudoku(executor->_sudoku);
        } else {
            executor->TrySolve(max_rec_depth - 1);
        }

        executor->_sudoku = Sudoku(saved);

        if (threaded) ++threads_available;
    };

    auto avail = GetAvailableNumbersForCell(mi, mj);

    std::vector<SudokuSolver*> executors;
    std::vector<std::thread> threads;

    for (size_t i = _reverse ? avail.size() : 1; (_reverse ? (i > 0) : (i <= avail.size())); i += _reverse ? -1 : 1) {
        if (_solved.has_value()) {
            break;
        }

        _sudoku[mi][mj].number = avail[i - 1];

        int threads_avail = threads_available--;
        if (threads_avail <= 0) {
            ++threads_available;

            try_solve(this, max_rec_depth);
        } else {
            executors.push_back(new SudokuSolver(_sudoku, _reverse));
            threads.emplace_back(try_solve, executors.back(), max_rec_depth, true);
        }
    }

    for (auto& thread : threads) {
        thread.join();
    }

    for (auto& executor : executors) {
        if (!_solved.has_value() and executor->_solved.has_value()) {
            _solved = std::move(executor->_solved);
        }
        delete executor;
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
