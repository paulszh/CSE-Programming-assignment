# CSE 101 PA 3 Makefile
#
# DO NOT MODIFY

CC=g++
FLAGS=-std=c++0x -I./

HEADERS=$(wildcard *.hpp)
SOURCES=$(wildcard *.cpp)
OBJECTS=$(SOURCES:.cpp=.o)

TestStrRecon.o: testsrc/TestStrRecon.cpp $(HEADERS)
	$(CC) -I testsrc/ $(FLAGS) -g -c testsrc/TestStrRecon.cpp

TestGridSum.o: testsrc/TestGridSum.cpp $(HEADERS)
	$(CC) -I testsrc/ $(FLAGS) -g -c testsrc/TestGridSum.cpp

TestLCS.o: testsrc/TestLCS.cpp $(HEADERS)
	$(CC) -I testsrc/ $(FLAGS) -g -c testsrc/TestLCS.cpp

TestStamps.o: testsrc/TestStamps.cpp $(HEADERS)
	$(CC) -I testsrc/ $(FLAGS) -g -c testsrc/TestStamps.cpp

TestStrRecon: TestStrRecon.o StrRecon.o
	$(CC) $(FLAGS) -g -o TestStrRecon.out TestStrRecon.o StrRecon.o

TestGridSum: TestGridSum.o GridSum.o
	$(CC) $(FLAGS) -g -o TestGridSum.out TestGridSum.o GridSum.o

TestLCS: TestLCS.o LCS.o
	$(CC) $(FLAGS) -g -o TestLCS.out TestLCS.o LCS.o

TestStamps: TestStamps.o Stamps.o
	$(CC) $(FLAGS) -g -o TestStamps.out TestStamps.o Stamps.o

TestAll: TestStrRecon TestLCS TestGridSum TestStamps

%.o: %.cpp
	$(CC) $(FLAGS) -g -c -o $@ $<

clean:
	rm -f *.o
	rm -f *.out

