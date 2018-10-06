all : main

main : main.o
	gcc main.o -o qsort

main.o : main.c
	gcc -c main.c

clean :
	rm qsort *.o