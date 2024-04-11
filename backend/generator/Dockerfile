FROM gcc:latest

SHELL ["/bin/bash", "-c"]
WORKDIR /home

RUN wget https://tangentsoft.com/mysqlpp/releases/mysql++-3.3.0.tar.gz
RUN tar -xf mysql++-3.3.0.tar.gz 
RUN rm mysql++-3.3.0.tar.gz 
WORKDIR /home/mysql++-3.3.0

RUN ./configure
RUN make
RUN su
RUN make install
RUN apt update
RUN apt install -y libconfig++-dev
RUN cp /usr/local/lib/libmysql* /usr/lib/

WORKDIR /app
COPY generator .

RUN g++ -o a.out -I/usr/include/mysql -I/usr/local/include/mysql++ -L/usr/local/lib -lmysqlpp -lconfig++ -std=c++20 main.cpp lib/sudoku/*.cpp

CMD ["./a.out"]
