#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
	printf("My student ID is 2020064257\nMy pid is %d\nMy ppid is %d\n", getpid(), getppid());
	exit(0);
}
