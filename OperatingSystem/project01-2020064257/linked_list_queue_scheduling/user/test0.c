#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char* argv[])
{
    int pid;

    for(int i = 0; i < 4; i++)  {
        pid = fork();

        if(pid == 0) {
            for(int j = 0; j < 200; j++) {
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
                yield();
            }
            exit(0);
        }
    }

    for(int i = 0; i < 4; i++) {
        wait(0);
    }

    mlfqmode();
    mlfqmode();

    for(int i = 0; i < 4; i++)  {
        pid = fork();

        if(pid == 0) {
            for(int j = 0; j < 200; j++) {
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
            }
            exit(0);
        }
    }

    for(int i = 0; i < 4; i++) {
        wait(0);
    }

    fcfsmode();
    fcfsmode();

    for(int i = 0; i < 4; i++)  {
        pid = fork();

        if(pid == 0) {
            for(int j = 0; j < 200; j++) {
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
            }
            exit(0);
        }
    }

    for(int i = 0; i < 4; i++) {
        wait(0);
    }

    exit(0);
}