#include <optional>
#include <atomic>
#include "sudoku.h"

enum Difficulty {
    easy,
    medium,
    hard
};

class SudokuSolver {
public:
    static std::atomic<int> threads_available;

    const size_t normal_rec_depth;
    const size_t enough_rec_depth;

    explicit SudokuSolver(const Sudoku& sudoku, bool reverse = false)
            : _sudoku(sudoku),
              _reverse(reverse),
              normal_rec_depth(sudoku.SubSize()),
              enough_rec_depth(sudoku.CellsCount()) {}

    std::optional<Sudoku> Solve(Difficulty difficulty);

protected:
    std::optional<Sudoku> _EasySolve(bool save = true);

    std::optional<Sudoku> _MediumSolve();

    std::optional<Sudoku> _HardSolve();

    std::vector<size_t> _GetAvailableNumbersForCell(size_t i, size_t j) const;

    void _TrySolve(size_t max_rec_depth);

    Sudoku _sudoku;
    std::optional<Sudoku> _solved;
    bool _reverse;
};