#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) { 

	char c;

	while ((c = getopt(argc, argv, "h")) != -1) {
		switch (c) {
			case 'h':
				printf("Help option.\n");
				break;
			default:
				abort();
		}
	}

    return 0; 
}