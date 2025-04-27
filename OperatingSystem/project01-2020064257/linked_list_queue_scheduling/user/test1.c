#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void long_task(void) {
  unsigned long dummy = 0;
  for (volatile int j = 0; j < 500000000; j++) {
      dummy += j % 7;
  }
}


int main() {
  int i;
  for (i = 1; i <= 10; i++) {
    int pid = fork();
    if (pid == 0) {
      printf("P%d: start\n", i);

      if (i >= 1 && i <= 5) {
        long_task();
      } else if (i == 6) {
        printf("call yield\n");
        yield();
        printf("end yield\n");
      } else if (i >= 7 && i <= 9) {
      } else if (i == 10) {
        printf("call yield\n");
        yield();
        printf("end yield\n");
      }

      printf("P%d: end\n", i);
      exit(0);
    }
  }
  for (i = 0; i < 10; i++)
    wait(0);
  printf("FCFS test completed.\n");
  exit(0);
}