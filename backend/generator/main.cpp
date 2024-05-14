#include <chrono>
#include <iostream>
#include <libconfig.h++>
#include <thread>
#include <vector>

#include "lib/connector.h"
#include "lib/sudoku.h"

static const std::vector<std::pair<unsigned, std::string_view>>
    avail_sudoku_conf = {{4, "easy"},   {4, "medium"}, {4, "hard"}, {9, "easy"},
                         {9, "medium"}, {9, "hard"},   {16, "easy"}};

std::string sudoku_encode(Sudoku sudoku) {
  return sudoku.ToString(0) + "\n\n" + sudoku.ToString(1);
}

void gen_thread_func(unsigned size, std::string_view dif_str,
                     SudokuConnector &con, unsigned limit,
                     size_t break_time = 0) {
  auto dif = DifficultyFromString(dif_str);

  std::cout << "Thread for " << size << "x" << size << " " << dif_str
            << " started." << std::endl;

  auto builder = SudokuBuilder(size);

  while (con.sudokuCount(size, dif_str) < limit) {
    auto sudoku = builder.Build(dif);
    auto sudoku_str = sudoku_encode(sudoku);

    if (con.writeSudoku(size, dif_str, sudoku_str)) {
      std::cout << "Sudoku " << size << "x" << size << " " << dif_str
                << " successfully generated. " << std::endl;
    }

    std::this_thread::sleep_for(std::chrono::milliseconds(break_time));
  }
}

int main(int argc, char **argv) {
  libconfig::Config cfg;
  cfg.readFile("gen.cfg");

  std::string user, password, db_name, server;
  int port;

  cfg.lookupValue("sudoku_generator.db_connection.address", server);
  cfg.lookupValue("sudoku_generator.db_connection.port", port);
  cfg.lookupValue("sudoku_generator.db_connection.db_name", db_name);
  cfg.lookupValue("sudoku_generator.db_connection.username", user);
  cfg.lookupValue("sudoku_generator.db_connection.password", password);
  std::cout << server << " " << password << " " << db_name << " " << port << " "
            << user << "\n";

  SudokuConnector conn = SudokuConnector(user.c_str(), password.c_str(),
                                         db_name.c_str(), server.c_str(), port);

  std::vector<std::jthread> threads;

  for (const auto &[size, dif] : avail_sudoku_conf) {
    unsigned limit;
    cfg.lookupValue(
        std::format("sudoku_generator.limits.size_{}.difficulty_{}", size, dif),
        limit);

    threads.push_back(
        std::jthread(gen_thread_func, size, dif, std::ref(conn), limit, 500));
  }

  for (auto &thr : threads) {
    thr.join();
  }
}
