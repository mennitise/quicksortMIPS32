CC = gcc
CFLAGS = -Wall
PROG = qsort

all:
	$(CC) $(CFLAGS) main.c -o $(PROG)

clean :
	rm $(PROG) *.o *.s
