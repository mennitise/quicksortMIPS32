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

void qs(char** list, int limit_left, int limit_right, int numeric_order) {
	int left, right;
	char temp[LENGHT];
	char pivot[LENGHT];

	left = limit_left;
	right = limit_right;
	strcpy(pivot, list[(left+right)/2]);

	while (left <= right) {
		
		if (numeric_order == 0){
			while ((compare_str_lx(list[left], pivot) < 0) && (left < limit_right)){
				left++;
			}
		} else {
			while ((compare_int_lx(list[left], pivot) < 0) && (left < limit_right)){
				left++;
			}
		}

		if (numeric_order == 0){
			while ((compare_str_lx(pivot, list[right]) < 0) && (right > limit_left)){
				right--;
			}
		} else {
			while ((compare_int_lx(pivot, list[right]) < 0) && (right > limit_left)){
				right--;
			}
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
		qs(list, limit_left, right, numeric_order);
	}
	if (limit_right > left){
		qs(list, left, limit_right, numeric_order);
	}
}
