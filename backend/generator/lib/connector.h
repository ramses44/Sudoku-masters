#include <mysql++.h>

#include <format>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>

class Connector {
public:
  Connector(const char *user, const char *password, const char *db_name,
            const char *addr, int port) {
    try {
      _conn.connect(db_name, addr, user, password, port);
    } catch (mysqlpp::ConnectionFailed err) {
      std::cerr << "Не удалось подключится к базе данных, причина: "
                << err.what() << std::endl;
      throw std::runtime_error("Connection failed!");
    }
  }

  mysqlpp::StoreQueryResult Query(std::string_view body) {
    std::lock_guard<std::mutex> lock(_mutex);

    if (_conn.connected()) {
      mysqlpp::Query query = _conn.query(body.data());
      mysqlpp::StoreQueryResult res = query.store();
      return res;
    } else {
      std::cerr << "Подключение к базе данных потеряно..." << std::endl;
      throw std::runtime_error("Connection failed!");
    }
  }

  ~Connector() { _conn.disconnect(); }

protected:
  mysqlpp::Connection _conn;
  std::mutex _mutex;
};

class SudokuConnector : public Connector {
public:
  SudokuConnector(const char *user, const char *password, const char *db_name,
                  const char *addr, int port)
      : Connector(user, password, db_name, addr, port) {}

  long sudokuCount(unsigned size, std::string_view difficulty) {
    std::string query_string = std::format(
        "SELECT COUNT(*) FROM sudoku WHERE size = {} AND difficulty = '{}'",
        size, difficulty);

    try {
      mysqlpp::StoreQueryResult res = Query(query_string.c_str());
      return res.empty() ? -1 : strtol(res[0][0], NULL, 10);
      return 0;
    } catch (std::runtime_error err) {
      return -1;
    }
  }

  bool writeSudoku(unsigned size, std::string_view difficulty,
                   std::string_view data) {
    std::string query_string = std::format(
        "INSERT INTO sudoku(size, difficulty, data) VALUES ({}, '{}', '{}')",
        size, difficulty, data);

    try {
      mysqlpp::StoreQueryResult res = Query(query_string);
    } catch (std::runtime_error err) {
      return false;
    }

    return true;
  }
};