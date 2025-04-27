
user/_test2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <long_task>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void long_task() {
   0:	1101                	addi	sp,sp,-32
   2:	ec22                	sd	s0,24(sp)
   4:	1000                	addi	s0,sp,32
  unsigned long dummy = 0;
    for (volatile int j = 0; j < 500000000; j++) {
   6:	fe042623          	sw	zero,-20(s0)
   a:	fec42703          	lw	a4,-20(s0)
   e:	2701                	sext.w	a4,a4
  10:	1dcd67b7          	lui	a5,0x1dcd6
  14:	4ff78793          	addi	a5,a5,1279 # 1dcd64ff <base+0x1dcd54ef>
  18:	00e7cf63          	blt	a5,a4,36 <long_task+0x36>
  1c:	873e                	mv	a4,a5
      dummy += j % 7;
  1e:	fec42783          	lw	a5,-20(s0)
    for (volatile int j = 0; j < 500000000; j++) {
  22:	fec42783          	lw	a5,-20(s0)
  26:	2785                	addiw	a5,a5,1
  28:	fef42623          	sw	a5,-20(s0)
  2c:	fec42783          	lw	a5,-20(s0)
  30:	2781                	sext.w	a5,a5
  32:	fef756e3          	bge	a4,a5,1e <long_task+0x1e>
    }
}
  36:	6462                	ld	s0,24(sp)
  38:	6105                	addi	sp,sp,32
  3a:	8082                	ret

000000000000003c <main>:

int main() {
  3c:	1101                	addi	sp,sp,-32
  3e:	ec06                	sd	ra,24(sp)
  40:	e822                	sd	s0,16(sp)
  42:	e426                	sd	s1,8(sp)
  44:	1000                	addi	s0,sp,32
  int i;
  for (i = 1; i <= 3; i++) {
    int pid = fork();
  46:	31a000ef          	jal	360 <fork>
    if (pid == 0) {
  4a:	c135                	beqz	a0,ae <main+0x72>
    int pid = fork();
  4c:	314000ef          	jal	360 <fork>
    if (pid == 0) {
  50:	c541                	beqz	a0,d8 <main+0x9c>
    int pid = fork();
  52:	30e000ef          	jal	360 <fork>
    if (pid == 0) {
  56:	c159                	beqz	a0,dc <main+0xa0>
  58:	e04a                	sd	s2,0(sp)
      printf("P%d: end\n", i);
      exit(0);
    }
  }

  for (i = 4; i <= 8; i++) {
  5a:	4491                	li	s1,4
  5c:	4925                	li	s2,9
    int pid = fork();
  5e:	302000ef          	jal	360 <fork>
    if (pid == 0) {
  62:	c11d                	beqz	a0,88 <main+0x4c>
  for (i = 4; i <= 8; i++) {
  64:	2485                	addiw	s1,s1,1
  66:	ff249ce3          	bne	s1,s2,5e <main+0x22>
  6a:	44a1                	li	s1,8
      exit(0);
    }
  }

  for (i = 1; i <= 8; i++) {
    wait(0);
  6c:	4501                	li	a0,0
  6e:	302000ef          	jal	370 <wait>
  for (i = 1; i <= 8; i++) {
  72:	34fd                	addiw	s1,s1,-1
  74:	fce5                	bnez	s1,6c <main+0x30>
  }

  printf("Test complete.\n");
  76:	00001517          	auipc	a0,0x1
  7a:	90a50513          	addi	a0,a0,-1782 # 980 <malloc+0x124>
  7e:	72a000ef          	jal	7a8 <printf>
  exit(0);
  82:	4501                	li	a0,0
  84:	2e4000ef          	jal	368 <exit>
      printf("P%d: start\n", i);
  88:	85a6                	mv	a1,s1
  8a:	00001517          	auipc	a0,0x1
  8e:	8e650513          	addi	a0,a0,-1818 # 970 <malloc+0x114>
  92:	716000ef          	jal	7a8 <printf>
      long_task(); // MLFQ로 돌입한 후 더 긴 작업
  96:	f6bff0ef          	jal	0 <long_task>
      printf("P%d: end\n", i);
  9a:	85a6                	mv	a1,s1
  9c:	00001517          	auipc	a0,0x1
  a0:	8c450513          	addi	a0,a0,-1852 # 960 <malloc+0x104>
  a4:	704000ef          	jal	7a8 <printf>
      exit(0);
  a8:	4501                	li	a0,0
  aa:	2be000ef          	jal	368 <exit>
  for (i = 1; i <= 3; i++) {
  ae:	4485                	li	s1,1
        printf("P%d: start\n", i);
  b0:	85a6                	mv	a1,s1
  b2:	00001517          	auipc	a0,0x1
  b6:	8be50513          	addi	a0,a0,-1858 # 970 <malloc+0x114>
  ba:	6ee000ef          	jal	7a8 <printf>
      if (i == 3) {
  be:	e04a                	sd	s2,0(sp)
      long_task(); // FCFS에서 길게 실행
  c0:	f41ff0ef          	jal	0 <long_task>
      printf("P%d: end\n", i);
  c4:	85a6                	mv	a1,s1
  c6:	00001517          	auipc	a0,0x1
  ca:	89a50513          	addi	a0,a0,-1894 # 960 <malloc+0x104>
  ce:	6da000ef          	jal	7a8 <printf>
      exit(0);
  d2:	4501                	li	a0,0
  d4:	294000ef          	jal	368 <exit>
  for (i = 1; i <= 3; i++) {
  d8:	4489                	li	s1,2
  da:	bfd9                	j	b0 <main+0x74>
        printf("P%d: start\n", i);
  dc:	458d                	li	a1,3
  de:	00001517          	auipc	a0,0x1
  e2:	89250513          	addi	a0,a0,-1902 # 970 <malloc+0x114>
  e6:	6c2000ef          	jal	7a8 <printf>
        printf("switching to MLFQ\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	8a650513          	addi	a0,a0,-1882 # 990 <malloc+0x134>
  f2:	6b6000ef          	jal	7a8 <printf>
        mlfqmode();
  f6:	32a000ef          	jal	420 <mlfqmode>
  fa:	448d                	li	s1,3
  fc:	b7c9                	j	be <main+0x82>

00000000000000fe <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  fe:	1141                	addi	sp,sp,-16
 100:	e406                	sd	ra,8(sp)
 102:	e022                	sd	s0,0(sp)
 104:	0800                	addi	s0,sp,16
  extern int main();
  main();
 106:	f37ff0ef          	jal	3c <main>
  exit(0);
 10a:	4501                	li	a0,0
 10c:	25c000ef          	jal	368 <exit>

0000000000000110 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 116:	87aa                	mv	a5,a0
 118:	0585                	addi	a1,a1,1
 11a:	0785                	addi	a5,a5,1
 11c:	fff5c703          	lbu	a4,-1(a1)
 120:	fee78fa3          	sb	a4,-1(a5)
 124:	fb75                	bnez	a4,118 <strcpy+0x8>
    ;
  return os;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb91                	beqz	a5,14a <strcmp+0x1e>
 138:	0005c703          	lbu	a4,0(a1)
 13c:	00f71763          	bne	a4,a5,14a <strcmp+0x1e>
    p++, q++;
 140:	0505                	addi	a0,a0,1
 142:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	fbe5                	bnez	a5,138 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14a:	0005c503          	lbu	a0,0(a1)
}
 14e:	40a7853b          	subw	a0,a5,a0
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x26>
 164:	0505                	addi	a0,a0,1
 166:	87aa                	mv	a5,a0
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x10>
 172:	40a6853b          	subw	a0,a3,a0
 176:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for(n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfe5                	j	178 <strlen+0x20>

0000000000000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 188:	ca19                	beqz	a2,19e <memset+0x1c>
 18a:	87aa                	mv	a5,a0
 18c:	1602                	slli	a2,a2,0x20
 18e:	9201                	srli	a2,a2,0x20
 190:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 198:	0785                	addi	a5,a5,1
 19a:	fee79de3          	bne	a5,a4,194 <memset+0x12>
  }
  return dst;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb99                	beqz	a5,1c4 <strchr+0x20>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1a>
  for(; *s; s++)
 1b4:	0505                	addi	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xc>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  return 0;
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strchr+0x1a>

00000000000001c8 <gets>:

char*
gets(char *buf, int max)
{
 1c8:	711d                	addi	sp,sp,-96
 1ca:	ec86                	sd	ra,88(sp)
 1cc:	e8a2                	sd	s0,80(sp)
 1ce:	e4a6                	sd	s1,72(sp)
 1d0:	e0ca                	sd	s2,64(sp)
 1d2:	fc4e                	sd	s3,56(sp)
 1d4:	f852                	sd	s4,48(sp)
 1d6:	f456                	sd	s5,40(sp)
 1d8:	f05a                	sd	s6,32(sp)
 1da:	ec5e                	sd	s7,24(sp)
 1dc:	1080                	addi	s0,sp,96
 1de:	8baa                	mv	s7,a0
 1e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	892a                	mv	s2,a0
 1e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e6:	4aa9                	li	s5,10
 1e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ea:	89a6                	mv	s3,s1
 1ec:	2485                	addiw	s1,s1,1
 1ee:	0344d663          	bge	s1,s4,21a <gets+0x52>
    cc = read(0, &c, 1);
 1f2:	4605                	li	a2,1
 1f4:	faf40593          	addi	a1,s0,-81
 1f8:	4501                	li	a0,0
 1fa:	186000ef          	jal	380 <read>
    if(cc < 1)
 1fe:	00a05e63          	blez	a0,21a <gets+0x52>
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20a:	01578763          	beq	a5,s5,218 <gets+0x50>
 20e:	0905                	addi	s2,s2,1
 210:	fd679de3          	bne	a5,s6,1ea <gets+0x22>
    buf[i++] = c;
 214:	89a6                	mv	s3,s1
 216:	a011                	j	21a <gets+0x52>
 218:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21a:	99de                	add	s3,s3,s7
 21c:	00098023          	sb	zero,0(s3)
  return buf;
}
 220:	855e                	mv	a0,s7
 222:	60e6                	ld	ra,88(sp)
 224:	6446                	ld	s0,80(sp)
 226:	64a6                	ld	s1,72(sp)
 228:	6906                	ld	s2,64(sp)
 22a:	79e2                	ld	s3,56(sp)
 22c:	7a42                	ld	s4,48(sp)
 22e:	7aa2                	ld	s5,40(sp)
 230:	7b02                	ld	s6,32(sp)
 232:	6be2                	ld	s7,24(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e04a                	sd	s2,0(sp)
 240:	1000                	addi	s0,sp,32
 242:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	4581                	li	a1,0
 246:	162000ef          	jal	3a8 <open>
  if(fd < 0)
 24a:	02054263          	bltz	a0,26e <stat+0x36>
 24e:	e426                	sd	s1,8(sp)
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	16c000ef          	jal	3c0 <fstat>
 258:	892a                	mv	s2,a0
  close(fd);
 25a:	8526                	mv	a0,s1
 25c:	134000ef          	jal	390 <close>
  return r;
 260:	64a2                	ld	s1,8(sp)
}
 262:	854a                	mv	a0,s2
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	6902                	ld	s2,0(sp)
 26a:	6105                	addi	sp,sp,32
 26c:	8082                	ret
    return -1;
 26e:	597d                	li	s2,-1
 270:	bfcd                	j	262 <stat+0x2a>

0000000000000272 <atoi>:

int
atoi(const char *s)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 278:	00054683          	lbu	a3,0(a0)
 27c:	fd06879b          	addiw	a5,a3,-48
 280:	0ff7f793          	zext.b	a5,a5
 284:	4625                	li	a2,9
 286:	02f66863          	bltu	a2,a5,2b6 <atoi+0x44>
 28a:	872a                	mv	a4,a0
  n = 0;
 28c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 28e:	0705                	addi	a4,a4,1
 290:	0025179b          	slliw	a5,a0,0x2
 294:	9fa9                	addw	a5,a5,a0
 296:	0017979b          	slliw	a5,a5,0x1
 29a:	9fb5                	addw	a5,a5,a3
 29c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a0:	00074683          	lbu	a3,0(a4)
 2a4:	fd06879b          	addiw	a5,a3,-48
 2a8:	0ff7f793          	zext.b	a5,a5
 2ac:	fef671e3          	bgeu	a2,a5,28e <atoi+0x1c>
  return n;
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  n = 0;
 2b6:	4501                	li	a0,0
 2b8:	bfe5                	j	2b0 <atoi+0x3e>

00000000000002ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c0:	02b57463          	bgeu	a0,a1,2e8 <memmove+0x2e>
    while(n-- > 0)
 2c4:	00c05f63          	blez	a2,2e2 <memmove+0x28>
 2c8:	1602                	slli	a2,a2,0x20
 2ca:	9201                	srli	a2,a2,0x20
 2cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d2:	0585                	addi	a1,a1,1
 2d4:	0705                	addi	a4,a4,1
 2d6:	fff5c683          	lbu	a3,-1(a1)
 2da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2de:	fef71ae3          	bne	a4,a5,2d2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
    dst += n;
 2e8:	00c50733          	add	a4,a0,a2
    src += n;
 2ec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ee:	fec05ae3          	blez	a2,2e2 <memmove+0x28>
 2f2:	fff6079b          	addiw	a5,a2,-1
 2f6:	1782                	slli	a5,a5,0x20
 2f8:	9381                	srli	a5,a5,0x20
 2fa:	fff7c793          	not	a5,a5
 2fe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 300:	15fd                	addi	a1,a1,-1
 302:	177d                	addi	a4,a4,-1
 304:	0005c683          	lbu	a3,0(a1)
 308:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 30c:	fee79ae3          	bne	a5,a4,300 <memmove+0x46>
 310:	bfc9                	j	2e2 <memmove+0x28>

0000000000000312 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 318:	ca05                	beqz	a2,348 <memcmp+0x36>
 31a:	fff6069b          	addiw	a3,a2,-1
 31e:	1682                	slli	a3,a3,0x20
 320:	9281                	srli	a3,a3,0x20
 322:	0685                	addi	a3,a3,1
 324:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 326:	00054783          	lbu	a5,0(a0)
 32a:	0005c703          	lbu	a4,0(a1)
 32e:	00e79863          	bne	a5,a4,33e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 332:	0505                	addi	a0,a0,1
    p2++;
 334:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 336:	fed518e3          	bne	a0,a3,326 <memcmp+0x14>
  }
  return 0;
 33a:	4501                	li	a0,0
 33c:	a019                	j	342 <memcmp+0x30>
      return *p1 - *p2;
 33e:	40e7853b          	subw	a0,a5,a4
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
  return 0;
 348:	4501                	li	a0,0
 34a:	bfe5                	j	342 <memcmp+0x30>

000000000000034c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 354:	f67ff0ef          	jal	2ba <memmove>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 360:	4885                	li	a7,1
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <exit>:
.global exit
exit:
 li a7, SYS_exit
 368:	4889                	li	a7,2
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <wait>:
.global wait
wait:
 li a7, SYS_wait
 370:	488d                	li	a7,3
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 378:	4891                	li	a7,4
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <read>:
.global read
read:
 li a7, SYS_read
 380:	4895                	li	a7,5
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <write>:
.global write
write:
 li a7, SYS_write
 388:	48c1                	li	a7,16
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <close>:
.global close
close:
 li a7, SYS_close
 390:	48d5                	li	a7,21
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <kill>:
.global kill
kill:
 li a7, SYS_kill
 398:	4899                	li	a7,6
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a0:	489d                	li	a7,7
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <open>:
.global open
open:
 li a7, SYS_open
 3a8:	48bd                	li	a7,15
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b0:	48c5                	li	a7,17
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b8:	48c9                	li	a7,18
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c0:	48a1                	li	a7,8
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <link>:
.global link
link:
 li a7, SYS_link
 3c8:	48cd                	li	a7,19
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d0:	48d1                	li	a7,20
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d8:	48a5                	li	a7,9
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e0:	48a9                	li	a7,10
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e8:	48ad                	li	a7,11
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3f0:	48b1                	li	a7,12
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f8:	48b5                	li	a7,13
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 400:	48b9                	li	a7,14
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <yield>:
.global yield
yield:
 li a7, SYS_yield
 408:	48d9                	li	a7,22
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 410:	48dd                	li	a7,23
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 418:	48e1                	li	a7,24
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 420:	48e5                	li	a7,25
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 428:	48e9                	li	a7,26
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 430:	1101                	addi	sp,sp,-32
 432:	ec06                	sd	ra,24(sp)
 434:	e822                	sd	s0,16(sp)
 436:	1000                	addi	s0,sp,32
 438:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43c:	4605                	li	a2,1
 43e:	fef40593          	addi	a1,s0,-17
 442:	f47ff0ef          	jal	388 <write>
}
 446:	60e2                	ld	ra,24(sp)
 448:	6442                	ld	s0,16(sp)
 44a:	6105                	addi	sp,sp,32
 44c:	8082                	ret

000000000000044e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44e:	7139                	addi	sp,sp,-64
 450:	fc06                	sd	ra,56(sp)
 452:	f822                	sd	s0,48(sp)
 454:	f426                	sd	s1,40(sp)
 456:	0080                	addi	s0,sp,64
 458:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45a:	c299                	beqz	a3,460 <printint+0x12>
 45c:	0805c963          	bltz	a1,4ee <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 460:	2581                	sext.w	a1,a1
  neg = 0;
 462:	4881                	li	a7,0
 464:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 468:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 46a:	2601                	sext.w	a2,a2
 46c:	00000517          	auipc	a0,0x0
 470:	54450513          	addi	a0,a0,1348 # 9b0 <digits>
 474:	883a                	mv	a6,a4
 476:	2705                	addiw	a4,a4,1
 478:	02c5f7bb          	remuw	a5,a1,a2
 47c:	1782                	slli	a5,a5,0x20
 47e:	9381                	srli	a5,a5,0x20
 480:	97aa                	add	a5,a5,a0
 482:	0007c783          	lbu	a5,0(a5)
 486:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 48a:	0005879b          	sext.w	a5,a1
 48e:	02c5d5bb          	divuw	a1,a1,a2
 492:	0685                	addi	a3,a3,1
 494:	fec7f0e3          	bgeu	a5,a2,474 <printint+0x26>
  if(neg)
 498:	00088c63          	beqz	a7,4b0 <printint+0x62>
    buf[i++] = '-';
 49c:	fd070793          	addi	a5,a4,-48
 4a0:	00878733          	add	a4,a5,s0
 4a4:	02d00793          	li	a5,45
 4a8:	fef70823          	sb	a5,-16(a4)
 4ac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b0:	02e05a63          	blez	a4,4e4 <printint+0x96>
 4b4:	f04a                	sd	s2,32(sp)
 4b6:	ec4e                	sd	s3,24(sp)
 4b8:	fc040793          	addi	a5,s0,-64
 4bc:	00e78933          	add	s2,a5,a4
 4c0:	fff78993          	addi	s3,a5,-1
 4c4:	99ba                	add	s3,s3,a4
 4c6:	377d                	addiw	a4,a4,-1
 4c8:	1702                	slli	a4,a4,0x20
 4ca:	9301                	srli	a4,a4,0x20
 4cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d0:	fff94583          	lbu	a1,-1(s2)
 4d4:	8526                	mv	a0,s1
 4d6:	f5bff0ef          	jal	430 <putc>
  while(--i >= 0)
 4da:	197d                	addi	s2,s2,-1
 4dc:	ff391ae3          	bne	s2,s3,4d0 <printint+0x82>
 4e0:	7902                	ld	s2,32(sp)
 4e2:	69e2                	ld	s3,24(sp)
}
 4e4:	70e2                	ld	ra,56(sp)
 4e6:	7442                	ld	s0,48(sp)
 4e8:	74a2                	ld	s1,40(sp)
 4ea:	6121                	addi	sp,sp,64
 4ec:	8082                	ret
    x = -xx;
 4ee:	40b005bb          	negw	a1,a1
    neg = 1;
 4f2:	4885                	li	a7,1
    x = -xx;
 4f4:	bf85                	j	464 <printint+0x16>

00000000000004f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f6:	711d                	addi	sp,sp,-96
 4f8:	ec86                	sd	ra,88(sp)
 4fa:	e8a2                	sd	s0,80(sp)
 4fc:	e0ca                	sd	s2,64(sp)
 4fe:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 500:	0005c903          	lbu	s2,0(a1)
 504:	26090863          	beqz	s2,774 <vprintf+0x27e>
 508:	e4a6                	sd	s1,72(sp)
 50a:	fc4e                	sd	s3,56(sp)
 50c:	f852                	sd	s4,48(sp)
 50e:	f456                	sd	s5,40(sp)
 510:	f05a                	sd	s6,32(sp)
 512:	ec5e                	sd	s7,24(sp)
 514:	e862                	sd	s8,16(sp)
 516:	e466                	sd	s9,8(sp)
 518:	8b2a                	mv	s6,a0
 51a:	8a2e                	mv	s4,a1
 51c:	8bb2                	mv	s7,a2
  state = 0;
 51e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 520:	4481                	li	s1,0
 522:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 524:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 528:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 52c:	06c00c93          	li	s9,108
 530:	a005                	j	550 <vprintf+0x5a>
        putc(fd, c0);
 532:	85ca                	mv	a1,s2
 534:	855a                	mv	a0,s6
 536:	efbff0ef          	jal	430 <putc>
 53a:	a019                	j	540 <vprintf+0x4a>
    } else if(state == '%'){
 53c:	03598263          	beq	s3,s5,560 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 540:	2485                	addiw	s1,s1,1
 542:	8726                	mv	a4,s1
 544:	009a07b3          	add	a5,s4,s1
 548:	0007c903          	lbu	s2,0(a5)
 54c:	20090c63          	beqz	s2,764 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 550:	0009079b          	sext.w	a5,s2
    if(state == 0){
 554:	fe0994e3          	bnez	s3,53c <vprintf+0x46>
      if(c0 == '%'){
 558:	fd579de3          	bne	a5,s5,532 <vprintf+0x3c>
        state = '%';
 55c:	89be                	mv	s3,a5
 55e:	b7cd                	j	540 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 560:	00ea06b3          	add	a3,s4,a4
 564:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 568:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 56a:	c681                	beqz	a3,572 <vprintf+0x7c>
 56c:	9752                	add	a4,a4,s4
 56e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 572:	03878f63          	beq	a5,s8,5b0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 576:	05978963          	beq	a5,s9,5c8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 57a:	07500713          	li	a4,117
 57e:	0ee78363          	beq	a5,a4,664 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 582:	07800713          	li	a4,120
 586:	12e78563          	beq	a5,a4,6b0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 58a:	07000713          	li	a4,112
 58e:	14e78a63          	beq	a5,a4,6e2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 592:	07300713          	li	a4,115
 596:	18e78a63          	beq	a5,a4,72a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 59a:	02500713          	li	a4,37
 59e:	04e79563          	bne	a5,a4,5e8 <vprintf+0xf2>
        putc(fd, '%');
 5a2:	02500593          	li	a1,37
 5a6:	855a                	mv	a0,s6
 5a8:	e89ff0ef          	jal	430 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	bf49                	j	540 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e91ff0ef          	jal	44e <printint>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bfad                	j	540 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5c8:	06400793          	li	a5,100
 5cc:	02f68963          	beq	a3,a5,5fe <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d0:	06c00793          	li	a5,108
 5d4:	04f68263          	beq	a3,a5,618 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5d8:	07500793          	li	a5,117
 5dc:	0af68063          	beq	a3,a5,67c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5e0:	07800793          	li	a5,120
 5e4:	0ef68263          	beq	a3,a5,6c8 <vprintf+0x1d2>
        putc(fd, '%');
 5e8:	02500593          	li	a1,37
 5ec:	855a                	mv	a0,s6
 5ee:	e43ff0ef          	jal	430 <putc>
        putc(fd, c0);
 5f2:	85ca                	mv	a1,s2
 5f4:	855a                	mv	a0,s6
 5f6:	e3bff0ef          	jal	430 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b791                	j	540 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	e43ff0ef          	jal	44e <printint>
        i += 1;
 610:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
        i += 1;
 616:	b72d                	j	540 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 618:	06400793          	li	a5,100
 61c:	02f60763          	beq	a2,a5,64a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 620:	07500793          	li	a5,117
 624:	06f60963          	beq	a2,a5,696 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 628:	07800793          	li	a5,120
 62c:	faf61ee3          	bne	a2,a5,5e8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	008b8913          	addi	s2,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000ba583          	lw	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e11ff0ef          	jal	44e <printint>
        i += 2;
 642:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	bde5                	j	540 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	008b8913          	addi	s2,s7,8
 64e:	4685                	li	a3,1
 650:	4629                	li	a2,10
 652:	000ba583          	lw	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	df7ff0ef          	jal	44e <printint>
        i += 2;
 65c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
        i += 2;
 662:	bdf9                	j	540 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 664:	008b8913          	addi	s2,s7,8
 668:	4681                	li	a3,0
 66a:	4629                	li	a2,10
 66c:	000ba583          	lw	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	dddff0ef          	jal	44e <printint>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b5d9                	j	540 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8913          	addi	s2,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000ba583          	lw	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	dc5ff0ef          	jal	44e <printint>
        i += 1;
 68e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 1;
 694:	b575                	j	540 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	dabff0ef          	jal	44e <printint>
        i += 2;
 6a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
        i += 2;
 6ae:	bd49                	j	540 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6b0:	008b8913          	addi	s2,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000ba583          	lw	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	d91ff0ef          	jal	44e <printint>
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bdad                	j	540 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000ba583          	lw	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	d79ff0ef          	jal	44e <printint>
        i += 1;
 6da:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 1;
 6e0:	b585                	j	540 <vprintf+0x4a>
 6e2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6e4:	008b8d13          	addi	s10,s7,8
 6e8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ec:	03000593          	li	a1,48
 6f0:	855a                	mv	a0,s6
 6f2:	d3fff0ef          	jal	430 <putc>
  putc(fd, 'x');
 6f6:	07800593          	li	a1,120
 6fa:	855a                	mv	a0,s6
 6fc:	d35ff0ef          	jal	430 <putc>
 700:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 702:	00000b97          	auipc	s7,0x0
 706:	2aeb8b93          	addi	s7,s7,686 # 9b0 <digits>
 70a:	03c9d793          	srli	a5,s3,0x3c
 70e:	97de                	add	a5,a5,s7
 710:	0007c583          	lbu	a1,0(a5)
 714:	855a                	mv	a0,s6
 716:	d1bff0ef          	jal	430 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71a:	0992                	slli	s3,s3,0x4
 71c:	397d                	addiw	s2,s2,-1
 71e:	fe0916e3          	bnez	s2,70a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 722:	8bea                	mv	s7,s10
      state = 0;
 724:	4981                	li	s3,0
 726:	6d02                	ld	s10,0(sp)
 728:	bd21                	j	540 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 72a:	008b8993          	addi	s3,s7,8
 72e:	000bb903          	ld	s2,0(s7)
 732:	00090f63          	beqz	s2,750 <vprintf+0x25a>
        for(; *s; s++)
 736:	00094583          	lbu	a1,0(s2)
 73a:	c195                	beqz	a1,75e <vprintf+0x268>
          putc(fd, *s);
 73c:	855a                	mv	a0,s6
 73e:	cf3ff0ef          	jal	430 <putc>
        for(; *s; s++)
 742:	0905                	addi	s2,s2,1
 744:	00094583          	lbu	a1,0(s2)
 748:	f9f5                	bnez	a1,73c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 74a:	8bce                	mv	s7,s3
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bbcd                	j	540 <vprintf+0x4a>
          s = "(null)";
 750:	00000917          	auipc	s2,0x0
 754:	25890913          	addi	s2,s2,600 # 9a8 <malloc+0x14c>
        for(; *s; s++)
 758:	02800593          	li	a1,40
 75c:	b7c5                	j	73c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 75e:	8bce                	mv	s7,s3
      state = 0;
 760:	4981                	li	s3,0
 762:	bbf9                	j	540 <vprintf+0x4a>
 764:	64a6                	ld	s1,72(sp)
 766:	79e2                	ld	s3,56(sp)
 768:	7a42                	ld	s4,48(sp)
 76a:	7aa2                	ld	s5,40(sp)
 76c:	7b02                	ld	s6,32(sp)
 76e:	6be2                	ld	s7,24(sp)
 770:	6c42                	ld	s8,16(sp)
 772:	6ca2                	ld	s9,8(sp)
    }
  }
}
 774:	60e6                	ld	ra,88(sp)
 776:	6446                	ld	s0,80(sp)
 778:	6906                	ld	s2,64(sp)
 77a:	6125                	addi	sp,sp,96
 77c:	8082                	ret

000000000000077e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77e:	715d                	addi	sp,sp,-80
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e010                	sd	a2,0(s0)
 788:	e414                	sd	a3,8(s0)
 78a:	e818                	sd	a4,16(s0)
 78c:	ec1c                	sd	a5,24(s0)
 78e:	03043023          	sd	a6,32(s0)
 792:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79a:	8622                	mv	a2,s0
 79c:	d5bff0ef          	jal	4f6 <vprintf>
}
 7a0:	60e2                	ld	ra,24(sp)
 7a2:	6442                	ld	s0,16(sp)
 7a4:	6161                	addi	sp,sp,80
 7a6:	8082                	ret

00000000000007a8 <printf>:

void
printf(const char *fmt, ...)
{
 7a8:	711d                	addi	sp,sp,-96
 7aa:	ec06                	sd	ra,24(sp)
 7ac:	e822                	sd	s0,16(sp)
 7ae:	1000                	addi	s0,sp,32
 7b0:	e40c                	sd	a1,8(s0)
 7b2:	e810                	sd	a2,16(s0)
 7b4:	ec14                	sd	a3,24(s0)
 7b6:	f018                	sd	a4,32(s0)
 7b8:	f41c                	sd	a5,40(s0)
 7ba:	03043823          	sd	a6,48(s0)
 7be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c2:	00840613          	addi	a2,s0,8
 7c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ca:	85aa                	mv	a1,a0
 7cc:	4505                	li	a0,1
 7ce:	d29ff0ef          	jal	4f6 <vprintf>
}
 7d2:	60e2                	ld	ra,24(sp)
 7d4:	6442                	ld	s0,16(sp)
 7d6:	6125                	addi	sp,sp,96
 7d8:	8082                	ret

00000000000007da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7da:	1141                	addi	sp,sp,-16
 7dc:	e422                	sd	s0,8(sp)
 7de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	00001797          	auipc	a5,0x1
 7e8:	81c7b783          	ld	a5,-2020(a5) # 1000 <freep>
 7ec:	a02d                	j	816 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ee:	4618                	lw	a4,8(a2)
 7f0:	9f2d                	addw	a4,a4,a1
 7f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	6398                	ld	a4,0(a5)
 7f8:	6310                	ld	a2,0(a4)
 7fa:	a83d                	j	838 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7fc:	ff852703          	lw	a4,-8(a0)
 800:	9f31                	addw	a4,a4,a2
 802:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 804:	ff053683          	ld	a3,-16(a0)
 808:	a091                	j	84c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80a:	6398                	ld	a4,0(a5)
 80c:	00e7e463          	bltu	a5,a4,814 <free+0x3a>
 810:	00e6ea63          	bltu	a3,a4,824 <free+0x4a>
{
 814:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 816:	fed7fae3          	bgeu	a5,a3,80a <free+0x30>
 81a:	6398                	ld	a4,0(a5)
 81c:	00e6e463          	bltu	a3,a4,824 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	fee7eae3          	bltu	a5,a4,814 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 824:	ff852583          	lw	a1,-8(a0)
 828:	6390                	ld	a2,0(a5)
 82a:	02059813          	slli	a6,a1,0x20
 82e:	01c85713          	srli	a4,a6,0x1c
 832:	9736                	add	a4,a4,a3
 834:	fae60de3          	beq	a2,a4,7ee <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 838:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 83c:	4790                	lw	a2,8(a5)
 83e:	02061593          	slli	a1,a2,0x20
 842:	01c5d713          	srli	a4,a1,0x1c
 846:	973e                	add	a4,a4,a5
 848:	fae68ae3          	beq	a3,a4,7fc <free+0x22>
    p->s.ptr = bp->s.ptr;
 84c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 84e:	00000717          	auipc	a4,0x0
 852:	7af73923          	sd	a5,1970(a4) # 1000 <freep>
}
 856:	6422                	ld	s0,8(sp)
 858:	0141                	addi	sp,sp,16
 85a:	8082                	ret

000000000000085c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 85c:	7139                	addi	sp,sp,-64
 85e:	fc06                	sd	ra,56(sp)
 860:	f822                	sd	s0,48(sp)
 862:	f426                	sd	s1,40(sp)
 864:	ec4e                	sd	s3,24(sp)
 866:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 868:	02051493          	slli	s1,a0,0x20
 86c:	9081                	srli	s1,s1,0x20
 86e:	04bd                	addi	s1,s1,15
 870:	8091                	srli	s1,s1,0x4
 872:	0014899b          	addiw	s3,s1,1
 876:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 878:	00000517          	auipc	a0,0x0
 87c:	78853503          	ld	a0,1928(a0) # 1000 <freep>
 880:	c915                	beqz	a0,8b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 884:	4798                	lw	a4,8(a5)
 886:	08977a63          	bgeu	a4,s1,91a <malloc+0xbe>
 88a:	f04a                	sd	s2,32(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 892:	8a4e                	mv	s4,s3
 894:	0009871b          	sext.w	a4,s3
 898:	6685                	lui	a3,0x1
 89a:	00d77363          	bgeu	a4,a3,8a0 <malloc+0x44>
 89e:	6a05                	lui	s4,0x1
 8a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a8:	00000917          	auipc	s2,0x0
 8ac:	75890913          	addi	s2,s2,1880 # 1000 <freep>
  if(p == (char*)-1)
 8b0:	5afd                	li	s5,-1
 8b2:	a081                	j	8f2 <malloc+0x96>
 8b4:	f04a                	sd	s2,32(sp)
 8b6:	e852                	sd	s4,16(sp)
 8b8:	e456                	sd	s5,8(sp)
 8ba:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8bc:	00000797          	auipc	a5,0x0
 8c0:	75478793          	addi	a5,a5,1876 # 1010 <base>
 8c4:	00000717          	auipc	a4,0x0
 8c8:	72f73e23          	sd	a5,1852(a4) # 1000 <freep>
 8cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d2:	b7c1                	j	892 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8d4:	6398                	ld	a4,0(a5)
 8d6:	e118                	sd	a4,0(a0)
 8d8:	a8a9                	j	932 <malloc+0xd6>
  hp->s.size = nu;
 8da:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8de:	0541                	addi	a0,a0,16
 8e0:	efbff0ef          	jal	7da <free>
  return freep;
 8e4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e8:	c12d                	beqz	a0,94a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ec:	4798                	lw	a4,8(a5)
 8ee:	02977263          	bgeu	a4,s1,912 <malloc+0xb6>
    if(p == freep)
 8f2:	00093703          	ld	a4,0(s2)
 8f6:	853e                	mv	a0,a5
 8f8:	fef719e3          	bne	a4,a5,8ea <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8fc:	8552                	mv	a0,s4
 8fe:	af3ff0ef          	jal	3f0 <sbrk>
  if(p == (char*)-1)
 902:	fd551ce3          	bne	a0,s5,8da <malloc+0x7e>
        return 0;
 906:	4501                	li	a0,0
 908:	7902                	ld	s2,32(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
 910:	a03d                	j	93e <malloc+0xe2>
 912:	7902                	ld	s2,32(sp)
 914:	6a42                	ld	s4,16(sp)
 916:	6aa2                	ld	s5,8(sp)
 918:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 91a:	fae48de3          	beq	s1,a4,8d4 <malloc+0x78>
        p->s.size -= nunits;
 91e:	4137073b          	subw	a4,a4,s3
 922:	c798                	sw	a4,8(a5)
        p += p->s.size;
 924:	02071693          	slli	a3,a4,0x20
 928:	01c6d713          	srli	a4,a3,0x1c
 92c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 932:	00000717          	auipc	a4,0x0
 936:	6ca73723          	sd	a0,1742(a4) # 1000 <freep>
      return (void*)(p + 1);
 93a:	01078513          	addi	a0,a5,16
  }
}
 93e:	70e2                	ld	ra,56(sp)
 940:	7442                	ld	s0,48(sp)
 942:	74a2                	ld	s1,40(sp)
 944:	69e2                	ld	s3,24(sp)
 946:	6121                	addi	sp,sp,64
 948:	8082                	ret
 94a:	7902                	ld	s2,32(sp)
 94c:	6a42                	ld	s4,16(sp)
 94e:	6aa2                	ld	s5,8(sp)
 950:	6b02                	ld	s6,0(sp)
 952:	b7f5                	j	93e <malloc+0xe2>
