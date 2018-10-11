#include <string.h>

const int LENGHT = 256;

int compare_str_lx(const void *_a, const void *_b) {
	char *a, *b;
	a = (char *) _a;
	b = (char *) _b;
	return strcmp(a, b);
}

int compare_int_lx(const void *_a, const void *_b) {
	int *a, *b;
	a = (int *) _a;
	b = (int *) _b;
	return (*a - *b);
}

void qsortMIPS(char** limit_left, char** limit_right, int numeric_order) {
	char** left = limit_left;
	char** right = limit_right;

	char temp[LENGHT];
	char** pivot = right;

	//strcpy(pivot, (left+right)/2]);

	while (left <= right) {
		
		if (numeric_order == 0){
			while ((compare_str_lx(*left, *pivot) < 0) && (left < limit_right)){
				left++;
			}
		} else {
			while ((compare_int_lx(*left, *pivot) < 0) && (left < limit_right)){
				left++;
			}
		}

		if (numeric_order == 0){
			while ((compare_str_lx(*pivot, *right) < 0) && (right > limit_left)){
				right--;
			}
		} else {
			while ((compare_int_lx(*pivot, *right) < 0) && (right > limit_left)){
				right--;
			}
		}

		if (left <= right) {
			strcpy(temp, *left);
			strcpy(*left, *right);
			strcpy(*right, temp);
			left++;
			right--;
		}
	}

	if (limit_left < right){
		qsortMIPS(limit_left, right, numeric_order);
	}
	if (limit_right > left){
		qsortMIPS(left, limit_right, numeric_order);
	}
}

