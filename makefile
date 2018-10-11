CC = gcc
CFLAGS = -Wall -g
PROG = qsort
MIPSFLAGS = quicksort.S
LINUXFLAGS = quicksort.c

mips:
	$(CC) $(CFLAGS) $(MIPSFLAGS) main.c -o $(PROG)

linux:
	$(CC) $(CFLAGS) $(LINUXFLAGS) main.c -o $(PROG)

all:
	$(CC) $(CFLAGS) main.c -o $(PROG)

clean :
	rm $(PROG) *.o *.s
