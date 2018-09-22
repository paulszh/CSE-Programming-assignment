# CSE 101 PA 4 Makefile
#
# DO NOT MODIFY

CC=g++
FLAGS=-std=c++0x -I./

HEADERS=$(wildcard *.hpp)
SOURCES=$(wildcard *.cpp)
OBJECTS=$(SOURCES:.cpp=.o)

TestTSP.o: testsrc/TestTSP.cpp $(HEADERS)
	$(CC) -I testsrc/ $(FLAGS) -g -c testsrc/TestTSP.cpp

TestAStar.o: testsrc/TestAStar.cpp $(HEADERS)
	$(CC) -I testsrc/ $(FLAGS) -g -c testsrc/TestAStar.cpp

TestTSP: TestTSP.o TSP.o
	$(CC) $(FLAGS) -g -o TestTSP.out TestTSP.o TSP.o

TestAStar: TestAStar.o AStar.o
	$(CC) $(FLAGS) -g -o TestAStar.out TestAStar.o AStar.o

TestAll: TestTSP TestAStar

%.o: %.cpp
	$(CC) $(FLAGS) -g -c -o $@ $<

clean:
	rm -f *.o
	rm -f *.out
