CC = g++

test_flex.out: parser.hpp scanner.cpp main.cpp
	$(CC) -o $@ $^ 
scanner.cpp: scanner.l
	flex -o $@ $^

