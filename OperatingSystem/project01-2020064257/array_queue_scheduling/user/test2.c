#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void long_task() {
  unsigned long dummy = 0;
    for (volatile int j = 0; j < 500000000; j++) {
      dummy += j % 7;
    }
}

int main() {
  int i;
  for (i = 1; i <= 3; i++) {
    int pid = fork();
    if (pid == 0) {
        printf("P%d: start\n", i);

      if (i == 3) {
        printf("switching to MLFQ\n");
        mlfqmode();
      }

      long_task(); // FCFS에서 길게 실행
      printf("P%d: end\n", i);
      exit(0);
    }
  }

  for (i = 4; i <= 8; i++) {
    int pid = fork();
    if (pid == 0) {
      printf("P%d: start\n", i);
      long_task(); // MLFQ로 돌입한 후 더 긴 작업
      printf("P%d: end\n", i);
      exit(0);
    }
  }

  for (i = 1; i <= 8; i++) {
    wait(0);
  }

  printf("Test complete.\n");
  exit(0);
}