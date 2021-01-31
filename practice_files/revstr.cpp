#include <stdio.h>

void reverse(char* str)
{
	if (str) {
		char *front = str;
		char *back = front;
		int len;

		while (*back)
			++back;

		if (len % 2 != 0)
			len = --back - front;

		for (int i = 0; i<(len/2); ++i, ++front, --back) {
			char temp = *back;
			*back = *front;
			*front = temp;
		}
	}
}

int main(int argc, char** argv)
{
	char* str = argv[1];
	reverse(str);
	(str) ? printf("%s\n", str) : printf("null string\n");
	return 0;
}
