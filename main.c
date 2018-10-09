#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <getopt.h>
#include <string.h>

const char* VERSION = "1.0.0\n";
const char* HELP_MESSAGE = "Usage:\n	qsort -h\n	qsort -V\n	qsort [options] archivo\nOptions:\n	-h, --help Imprime ayuda.\n	-V, --version Versión del programa.\n	-o, --output\nArchivo de salida.\n	-n, --numeric Ordenar los datos numéricamente en vez de alfabéticamente.\nExamples:\n	qsort -n numeros.txt\n";
const int MAX_LENGHT = 2048;

static struct option long_options[] = {
	{"help", 0, NULL, 'h'},
	{"output", 0, NULL, 'o'},
	{"version", 0, NULL, 'V'},
	{"numeric", 0, NULL, 'n'},
	{NULL, 0, NULL, 0}
};

/*----------------------------------QUICKSORT IMPLEMENTATION------------------------------------*/

void qs(char list[MAX_LENGHT][MAX_LENGHT], int limit_left, int limit_right, int (*compare)(const void *, const void*)) {
	int left, right;
	char temp[MAX_LENGHT];
	char pivot[MAX_LENGHT];

	left = limit_left;
	right = limit_right;
	strcpy(pivot, list[(left+right)/2]);

	while (left <= right) {
		
		while ((compare(list[left], pivot) < 0) && (left < limit_right)){
			left++;
		}

		while ((compare(pivot, list[right]) < 0) && (right > limit_left)){
			right--;
		}

		if (left <= right) {
			strcpy(temp, list[left]);
			strcpy(list[left], list[right]);
			strcpy(list[right], temp);
			left++;
			right--;
		}
	}

	if (limit_left < right){
		qs(list, limit_left, right, compare);
	}
	if (limit_right > left){
		qs(list, left, limit_right, compare);
	}
}

void quicksort(char list[MAX_LENGHT][MAX_LENGHT], int len, int (*compare)(const void *, const void*)) {
	qs(list, 0, len-1, compare);
}

/*----------------------------------------------------------------------------------------------*/

int compare_str(const void *_a, const void *_b) {
	char *a, *b;
	a = (char *) _a;
	b = (char *) _b;
	return (*a - *b);
}

int compare_int(const void *_a, const void *_b) {
	int *a, *b;
	a = (int *) _a;
	b = (int *) _b;
	return (*a - *b);
}

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
				*numeric_order = true;
				break;
			case 'o':
				printf("%s",optarg);
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

void print_list(char list[MAX_LENGHT][MAX_LENGHT], size_t len){
	for (int i = 0; i < len; ++i) {
		printf ("%d %s", i, list[i]);
	}
}

void sort_file(char* filename, bool numeric_order) {
	char chars[1024];
	FILE *file = fopen(filename,"r");

	char lines[MAX_LENGHT][MAX_LENGHT];
	int lenLines = 0;

	if (file == NULL){
		printf("No such file\n");
		exit(1);
	} else {
		while (feof(file) == 0) {
			fgets(chars,1024,file);
			strcpy(lines[lenLines], chars);
			lenLines++;
		}
	}
	lenLines--;
	fclose(file);

	if (numeric_order) {
		quicksort(lines, lenLines, compare_int);
	} else {
		quicksort(lines, lenLines, compare_str);
	}
	print_list(lines, lenLines);
}

int main(int argc, char *argv[]) { 
	bool numeric_order = false; /* FLAG: numeric */
	read_parameters(argc, argv, &numeric_order);
	sort_file(argv[argc-1], numeric_order);
	return 0; 
}
