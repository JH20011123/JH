#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void long_task() {
  volatile unsigned long dummy = 0;
  for (int i = 0; i < 500000000; i++) {
    dummy += i % 7;
  }
}

int main() {
  int pid;

  // P1: FCFS에서 실행 + MLFQ 전환
  pid = fork();
  if (pid == 0) {
    printf("P1: start and switch to MLFQ\n");
    long_task();
    mlfqmode(); // 모드 전환
    long_task();
    printf("P1: end\n");
    exit(0);
  }

  // P2~P5: FCFS 모드에서 인큐될 프로세스들
  for (int i = 2; i <= 5; i++) {
    pid = fork();
    if (pid == 0) {
      printf("P%d: start\n", i);
      long_task();
      printf("P%d: end\n", i);
      exit(0);
    }
  }

  // 부모 프로세스: 자식 모두 대기
  for (int i = 1; i <= 5; i++) {
    wait(0);
  }

  printf("test3 complete.\n");
  exit(0);
}