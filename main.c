#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <getopt.h>
#include <string.h>

const char* VERSION = "1.0.0\n";
const char* HELP_MESSAGE = "Usage:\n	qsort -h\n	qsort -V\n	qsort [options] archivo\nOptions:\n	-h, --help Imprime ayuda.\n	-V, --version Versión del programa.\n	-o, --output\nArchivo de salida.\n	-n, --numeric Ordenar los datos numéricamente en vez de alfabéticamente.\nExamples:\n	qsort -n numeros.txt\n";
const int MAX_LENGHT = 256;
const int MAX_LENGHT_LINES = 256;

static struct option long_options[] = {
	{"help", 0, NULL, 'h'},
	{"output", 0, NULL, 'o'},
	{"version", 0, NULL, 'V'},
	{"numeric", 0, NULL, 'n'},
	{NULL, 0, NULL, 0}
};

int compare_str(const void *_a, const void *_b) {
	char *a, *b;
	a = (char *) _a;
	b = (char *) _b;
	return strcmp(a, b);
}

int compare_int(const void *_a, const void *_b) {
	int *a, *b;
	a = (int *) _a;
	b = (int *) _b;
	return (*a - *b);
}

/*----------------------------------QUICKSORT IMPLEMENTATION------------------------------------*/

// MIPS IMPLEMENTATION
extern void qsortMIPS(char** left, char** right, int numeric_order);

// C IMPLEMENTATION
extern void qs(char** list, int limit_left, int limit_right, int numeric_order);

void quicksort(char** list, int len, int numeric_order) {
	qsortMIPS(&list[0], &list[len-1], numeric_order);
}

/*----------------------------------------------------------------------------------------------*/


void read_parameters(int argc, char *argv[], bool *numeric_order) {
	char c;
	while ((c = getopt_long(argc, argv, "hVno:", long_options, NULL)) != -1) {
		switch (c) {
			case 'h':
				printf("%s",HELP_MESSAGE);
				exit(1);
				break;
			case 'V':
				printf("%s",VERSION);
				exit(1);
				break;
			case 'n':
				*numeric_order = 1;
				break;
			case 'o':
				if (strcmp(optarg, "-") != 0) {
					freopen(optarg, "a+", stdout);
				}
				break;
			default:
				abort();
		}
	}

	if (argv[optind] == NULL) {
		printf("File to order missing\nEnter \e[3m'./qsort -h'\e[0m to see help.\n");
		exit(1);
	}
}

void print_list(char** list, size_t len){
	int i;
	for (i = 0; i < len; ++i) {
		printf ("%s", list[i]);
	}
}

void free_list(char** list, size_t len){
	int i;
	for (i = 0; i < len; ++i) {
		free(list[i]);
	}
	free(list);
}

void sort_file(char* filename, bool numeric_order) {
	char chars[MAX_LENGHT];
	FILE *file = fopen(filename,"r");

	int lenLines = 0;
	char **lines;
	lines = malloc(MAX_LENGHT_LINES * sizeof(char*));

	if (file == NULL){
		free(lines);
		printf("No such file\n");
		exit(1);
	} else {
		while (feof(file) == 0) {
			fgets(chars,1024,file);
			lines[lenLines] = malloc(MAX_LENGHT*sizeof(char));
			strcpy(lines[lenLines], chars);
			lenLines++;
		}
	}
	lenLines--;
	fclose(file);

	quicksort(lines, lenLines, numeric_order);
	print_list(lines, lenLines);

	free_list(lines, lenLines+1);
}

void debug(char* s){
	printf("%s\n", s);
}

int main(int argc, char *argv[]) { 
	bool numeric_order = 0; /* FLAG: numeric */
	read_parameters(argc, argv, &numeric_order);
	sort_file(argv[argc-1], numeric_order);
	return 0;
}
