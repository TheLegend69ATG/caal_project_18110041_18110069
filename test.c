#include <stdio.h>

// Function Declaration
extern int walk_stack();
extern void stackfull();
int sum(int a, int b)
{
	int c=1;
	int d=2;
	int e=3;
	int f=4;
	walk_stack();
	stackfull();
	return 0;
}

int recursive(int a)
{

	if (a > 1)
		recursive(a-1);
	else
	{
		walk_stack();
		printf("Assembly is hard\n");
		return 1;
	}
}
int main()
{
	int a = 9;
	int b = 6;
	int c=7;
	int d=8;
	//register void *sp asm ("ebp");
    	//printf("%p\n", sp);
	//printf("Sum of %d + %d = %d\n", a, b, sum(a, b));
	 sum(a,b);


}
