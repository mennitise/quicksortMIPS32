#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <getopt.h>

const char* VERSION = "1.0.0\n";
const char* HELP_MESSAGE = "Usage:\n	qsort -h\n	qsort -V\n	qsort [options] archivo\nOptions:\n	-h, --help Imprime ayuda.\n	-V, --version Versión del programa.\n	-o, --output\nArchivo de salida.\n	-n, --numeric Ordenar los datos numéricamente en vez de alfabéticamente.\nExamples:\n	qsort -n numeros.txt\n";

static struct option long_options[] = {
	{"help", 0, NULL, 'h'},
	{"output", 0, NULL, 'o'},
	{"version", 0, NULL, 'V'},
	{"numeric", 0, NULL, 'n'},
	{NULL, 0, NULL, 0}
};

int main(int argc, char *argv[]) { 

	bool numericOrder = false;
	char c;

	while ((c = getopt_long(argc, argv, "hVno:", long_options, NULL)) != -1) {
		switch (c) {
			case 'h':
				printf("%s",HELP_MESSAGE);
				break;
			case 'V':
				printf("%s",VERSION);
				break;
			case 'n':
				numericOrder = true;
				break;
			case 'o':
				printf("%s",optarg);
				break;
			default:
				abort();
		}
	}

    return 0; 
}