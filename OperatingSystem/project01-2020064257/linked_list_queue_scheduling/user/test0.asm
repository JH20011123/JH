
user/_test0:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char* argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	4911                	li	s2,4
    int pid;

    for(int i = 0; i < 4; i++)  {
        pid = fork();
  12:	37c000ef          	jal	38e <fork>
  16:	84aa                	mv	s1,a0

        if(pid == 0) {
  18:	c159                	beqz	a0,9e <main+0x9e>
    for(int i = 0; i < 4; i++)  {
  1a:	397d                	addiw	s2,s2,-1
  1c:	fe091be3          	bnez	s2,12 <main+0x12>
            exit(0);
        }
    }

    for(int i = 0; i < 4; i++) {
        wait(0);
  20:	4501                	li	a0,0
  22:	37c000ef          	jal	39e <wait>
  26:	4501                	li	a0,0
  28:	376000ef          	jal	39e <wait>
  2c:	4501                	li	a0,0
  2e:	370000ef          	jal	39e <wait>
  32:	4501                	li	a0,0
  34:	36a000ef          	jal	39e <wait>
    }

    mlfqmode();
  38:	416000ef          	jal	44e <mlfqmode>
    mlfqmode();
  3c:	412000ef          	jal	44e <mlfqmode>
  40:	4911                	li	s2,4

    for(int i = 0; i < 4; i++)  {
        pid = fork();
  42:	34c000ef          	jal	38e <fork>
  46:	84aa                	mv	s1,a0

        if(pid == 0) {
  48:	c541                	beqz	a0,d0 <main+0xd0>
    for(int i = 0; i < 4; i++)  {
  4a:	397d                	addiw	s2,s2,-1
  4c:	fe091be3          	bnez	s2,42 <main+0x42>
            exit(0);
        }
    }

    for(int i = 0; i < 4; i++) {
        wait(0);
  50:	4501                	li	a0,0
  52:	34c000ef          	jal	39e <wait>
  56:	4501                	li	a0,0
  58:	346000ef          	jal	39e <wait>
  5c:	4501                	li	a0,0
  5e:	340000ef          	jal	39e <wait>
  62:	4501                	li	a0,0
  64:	33a000ef          	jal	39e <wait>
    }

    fcfsmode();
  68:	3ee000ef          	jal	456 <fcfsmode>
    fcfsmode();
  6c:	3ea000ef          	jal	456 <fcfsmode>
  70:	4911                	li	s2,4

    for(int i = 0; i < 4; i++)  {
        pid = fork();
  72:	31c000ef          	jal	38e <fork>
  76:	84aa                	mv	s1,a0

        if(pid == 0) {
  78:	c159                	beqz	a0,fe <main+0xfe>
    for(int i = 0; i < 4; i++)  {
  7a:	397d                	addiw	s2,s2,-1
  7c:	fe091be3          	bnez	s2,72 <main+0x72>
            exit(0);
        }
    }

    for(int i = 0; i < 4; i++) {
        wait(0);
  80:	4501                	li	a0,0
  82:	31c000ef          	jal	39e <wait>
  86:	4501                	li	a0,0
  88:	316000ef          	jal	39e <wait>
  8c:	4501                	li	a0,0
  8e:	310000ef          	jal	39e <wait>
  92:	4501                	li	a0,0
  94:	30a000ef          	jal	39e <wait>
    }

    exit(0);
  98:	4501                	li	a0,0
  9a:	2fc000ef          	jal	396 <exit>
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
  9e:	00001a17          	auipc	s4,0x1
  a2:	8f2a0a13          	addi	s4,s4,-1806 # 990 <malloc+0x106>
            for(int j = 0; j < 200; j++) {
  a6:	0c800993          	li	s3,200
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
  aa:	36c000ef          	jal	416 <getpid>
  ae:	892a                	mv	s2,a0
  b0:	38e000ef          	jal	43e <getlev>
  b4:	862a                	mv	a2,a0
  b6:	86a6                	mv	a3,s1
  b8:	85ca                	mv	a1,s2
  ba:	8552                	mv	a0,s4
  bc:	71a000ef          	jal	7d6 <printf>
                yield();
  c0:	376000ef          	jal	436 <yield>
            for(int j = 0; j < 200; j++) {
  c4:	2485                	addiw	s1,s1,1
  c6:	ff3492e3          	bne	s1,s3,aa <main+0xaa>
            exit(0);
  ca:	4501                	li	a0,0
  cc:	2ca000ef          	jal	396 <exit>
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
  d0:	00001a17          	auipc	s4,0x1
  d4:	8c0a0a13          	addi	s4,s4,-1856 # 990 <malloc+0x106>
            for(int j = 0; j < 200; j++) {
  d8:	0c800993          	li	s3,200
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
  dc:	33a000ef          	jal	416 <getpid>
  e0:	892a                	mv	s2,a0
  e2:	35c000ef          	jal	43e <getlev>
  e6:	862a                	mv	a2,a0
  e8:	86a6                	mv	a3,s1
  ea:	85ca                	mv	a1,s2
  ec:	8552                	mv	a0,s4
  ee:	6e8000ef          	jal	7d6 <printf>
            for(int j = 0; j < 200; j++) {
  f2:	2485                	addiw	s1,s1,1
  f4:	ff3494e3          	bne	s1,s3,dc <main+0xdc>
            exit(0);
  f8:	4501                	li	a0,0
  fa:	29c000ef          	jal	396 <exit>
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
  fe:	00001a17          	auipc	s4,0x1
 102:	892a0a13          	addi	s4,s4,-1902 # 990 <malloc+0x106>
            for(int j = 0; j < 200; j++) {
 106:	0c800993          	li	s3,200
                printf("pid: %d, level %d, interation: %d \n", getpid(), getlev(), j);
 10a:	30c000ef          	jal	416 <getpid>
 10e:	892a                	mv	s2,a0
 110:	32e000ef          	jal	43e <getlev>
 114:	862a                	mv	a2,a0
 116:	86a6                	mv	a3,s1
 118:	85ca                	mv	a1,s2
 11a:	8552                	mv	a0,s4
 11c:	6ba000ef          	jal	7d6 <printf>
            for(int j = 0; j < 200; j++) {
 120:	2485                	addiw	s1,s1,1
 122:	ff3494e3          	bne	s1,s3,10a <main+0x10a>
            exit(0);
 126:	4501                	li	a0,0
 128:	26e000ef          	jal	396 <exit>

000000000000012c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
  extern int main();
  main();
 134:	ecdff0ef          	jal	0 <main>
  exit(0);
 138:	4501                	li	a0,0
 13a:	25c000ef          	jal	396 <exit>

000000000000013e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 144:	87aa                	mv	a5,a0
 146:	0585                	addi	a1,a1,1
 148:	0785                	addi	a5,a5,1
 14a:	fff5c703          	lbu	a4,-1(a1)
 14e:	fee78fa3          	sb	a4,-1(a5)
 152:	fb75                	bnez	a4,146 <strcpy+0x8>
    ;
  return os;
}
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 160:	00054783          	lbu	a5,0(a0)
 164:	cb91                	beqz	a5,178 <strcmp+0x1e>
 166:	0005c703          	lbu	a4,0(a1)
 16a:	00f71763          	bne	a4,a5,178 <strcmp+0x1e>
    p++, q++;
 16e:	0505                	addi	a0,a0,1
 170:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 172:	00054783          	lbu	a5,0(a0)
 176:	fbe5                	bnez	a5,166 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 178:	0005c503          	lbu	a0,0(a1)
}
 17c:	40a7853b          	subw	a0,a5,a0
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strlen>:

uint
strlen(const char *s)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18c:	00054783          	lbu	a5,0(a0)
 190:	cf91                	beqz	a5,1ac <strlen+0x26>
 192:	0505                	addi	a0,a0,1
 194:	87aa                	mv	a5,a0
 196:	86be                	mv	a3,a5
 198:	0785                	addi	a5,a5,1
 19a:	fff7c703          	lbu	a4,-1(a5)
 19e:	ff65                	bnez	a4,196 <strlen+0x10>
 1a0:	40a6853b          	subw	a0,a3,a0
 1a4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  for(n = 0; s[n]; n++)
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strlen+0x20>

00000000000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b6:	ca19                	beqz	a2,1cc <memset+0x1c>
 1b8:	87aa                	mv	a5,a0
 1ba:	1602                	slli	a2,a2,0x20
 1bc:	9201                	srli	a2,a2,0x20
 1be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c6:	0785                	addi	a5,a5,1
 1c8:	fee79de3          	bne	a5,a4,1c2 <memset+0x12>
  }
  return dst;
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strchr>:

char*
strchr(const char *s, char c)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	cb99                	beqz	a5,1f2 <strchr+0x20>
    if(*s == c)
 1de:	00f58763          	beq	a1,a5,1ec <strchr+0x1a>
  for(; *s; s++)
 1e2:	0505                	addi	a0,a0,1
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbfd                	bnez	a5,1de <strchr+0xc>
      return (char*)s;
  return 0;
 1ea:	4501                	li	a0,0
}
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret
  return 0;
 1f2:	4501                	li	a0,0
 1f4:	bfe5                	j	1ec <strchr+0x1a>

00000000000001f6 <gets>:

char*
gets(char *buf, int max)
{
 1f6:	711d                	addi	sp,sp,-96
 1f8:	ec86                	sd	ra,88(sp)
 1fa:	e8a2                	sd	s0,80(sp)
 1fc:	e4a6                	sd	s1,72(sp)
 1fe:	e0ca                	sd	s2,64(sp)
 200:	fc4e                	sd	s3,56(sp)
 202:	f852                	sd	s4,48(sp)
 204:	f456                	sd	s5,40(sp)
 206:	f05a                	sd	s6,32(sp)
 208:	ec5e                	sd	s7,24(sp)
 20a:	1080                	addi	s0,sp,96
 20c:	8baa                	mv	s7,a0
 20e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	892a                	mv	s2,a0
 212:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 214:	4aa9                	li	s5,10
 216:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 218:	89a6                	mv	s3,s1
 21a:	2485                	addiw	s1,s1,1
 21c:	0344d663          	bge	s1,s4,248 <gets+0x52>
    cc = read(0, &c, 1);
 220:	4605                	li	a2,1
 222:	faf40593          	addi	a1,s0,-81
 226:	4501                	li	a0,0
 228:	186000ef          	jal	3ae <read>
    if(cc < 1)
 22c:	00a05e63          	blez	a0,248 <gets+0x52>
    buf[i++] = c;
 230:	faf44783          	lbu	a5,-81(s0)
 234:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 238:	01578763          	beq	a5,s5,246 <gets+0x50>
 23c:	0905                	addi	s2,s2,1
 23e:	fd679de3          	bne	a5,s6,218 <gets+0x22>
    buf[i++] = c;
 242:	89a6                	mv	s3,s1
 244:	a011                	j	248 <gets+0x52>
 246:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 248:	99de                	add	s3,s3,s7
 24a:	00098023          	sb	zero,0(s3)
  return buf;
}
 24e:	855e                	mv	a0,s7
 250:	60e6                	ld	ra,88(sp)
 252:	6446                	ld	s0,80(sp)
 254:	64a6                	ld	s1,72(sp)
 256:	6906                	ld	s2,64(sp)
 258:	79e2                	ld	s3,56(sp)
 25a:	7a42                	ld	s4,48(sp)
 25c:	7aa2                	ld	s5,40(sp)
 25e:	7b02                	ld	s6,32(sp)
 260:	6be2                	ld	s7,24(sp)
 262:	6125                	addi	sp,sp,96
 264:	8082                	ret

0000000000000266 <stat>:

int
stat(const char *n, struct stat *st)
{
 266:	1101                	addi	sp,sp,-32
 268:	ec06                	sd	ra,24(sp)
 26a:	e822                	sd	s0,16(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	162000ef          	jal	3d6 <open>
  if(fd < 0)
 278:	02054263          	bltz	a0,29c <stat+0x36>
 27c:	e426                	sd	s1,8(sp)
 27e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 280:	85ca                	mv	a1,s2
 282:	16c000ef          	jal	3ee <fstat>
 286:	892a                	mv	s2,a0
  close(fd);
 288:	8526                	mv	a0,s1
 28a:	134000ef          	jal	3be <close>
  return r;
 28e:	64a2                	ld	s1,8(sp)
}
 290:	854a                	mv	a0,s2
 292:	60e2                	ld	ra,24(sp)
 294:	6442                	ld	s0,16(sp)
 296:	6902                	ld	s2,0(sp)
 298:	6105                	addi	sp,sp,32
 29a:	8082                	ret
    return -1;
 29c:	597d                	li	s2,-1
 29e:	bfcd                	j	290 <stat+0x2a>

00000000000002a0 <atoi>:

int
atoi(const char *s)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a6:	00054683          	lbu	a3,0(a0)
 2aa:	fd06879b          	addiw	a5,a3,-48
 2ae:	0ff7f793          	zext.b	a5,a5
 2b2:	4625                	li	a2,9
 2b4:	02f66863          	bltu	a2,a5,2e4 <atoi+0x44>
 2b8:	872a                	mv	a4,a0
  n = 0;
 2ba:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2bc:	0705                	addi	a4,a4,1
 2be:	0025179b          	slliw	a5,a0,0x2
 2c2:	9fa9                	addw	a5,a5,a0
 2c4:	0017979b          	slliw	a5,a5,0x1
 2c8:	9fb5                	addw	a5,a5,a3
 2ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ce:	00074683          	lbu	a3,0(a4)
 2d2:	fd06879b          	addiw	a5,a3,-48
 2d6:	0ff7f793          	zext.b	a5,a5
 2da:	fef671e3          	bgeu	a2,a5,2bc <atoi+0x1c>
  return n;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  n = 0;
 2e4:	4501                	li	a0,0
 2e6:	bfe5                	j	2de <atoi+0x3e>

00000000000002e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ee:	02b57463          	bgeu	a0,a1,316 <memmove+0x2e>
    while(n-- > 0)
 2f2:	00c05f63          	blez	a2,310 <memmove+0x28>
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2fe:	872a                	mv	a4,a0
      *dst++ = *src++;
 300:	0585                	addi	a1,a1,1
 302:	0705                	addi	a4,a4,1
 304:	fff5c683          	lbu	a3,-1(a1)
 308:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30c:	fef71ae3          	bne	a4,a5,300 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
    dst += n;
 316:	00c50733          	add	a4,a0,a2
    src += n;
 31a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 31c:	fec05ae3          	blez	a2,310 <memmove+0x28>
 320:	fff6079b          	addiw	a5,a2,-1
 324:	1782                	slli	a5,a5,0x20
 326:	9381                	srli	a5,a5,0x20
 328:	fff7c793          	not	a5,a5
 32c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 32e:	15fd                	addi	a1,a1,-1
 330:	177d                	addi	a4,a4,-1
 332:	0005c683          	lbu	a3,0(a1)
 336:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33a:	fee79ae3          	bne	a5,a4,32e <memmove+0x46>
 33e:	bfc9                	j	310 <memmove+0x28>

0000000000000340 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 346:	ca05                	beqz	a2,376 <memcmp+0x36>
 348:	fff6069b          	addiw	a3,a2,-1
 34c:	1682                	slli	a3,a3,0x20
 34e:	9281                	srli	a3,a3,0x20
 350:	0685                	addi	a3,a3,1
 352:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 354:	00054783          	lbu	a5,0(a0)
 358:	0005c703          	lbu	a4,0(a1)
 35c:	00e79863          	bne	a5,a4,36c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 360:	0505                	addi	a0,a0,1
    p2++;
 362:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 364:	fed518e3          	bne	a0,a3,354 <memcmp+0x14>
  }
  return 0;
 368:	4501                	li	a0,0
 36a:	a019                	j	370 <memcmp+0x30>
      return *p1 - *p2;
 36c:	40e7853b          	subw	a0,a5,a4
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
  return 0;
 376:	4501                	li	a0,0
 378:	bfe5                	j	370 <memcmp+0x30>

000000000000037a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e406                	sd	ra,8(sp)
 37e:	e022                	sd	s0,0(sp)
 380:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 382:	f67ff0ef          	jal	2e8 <memmove>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38e:	4885                	li	a7,1
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <exit>:
.global exit
exit:
 li a7, SYS_exit
 396:	4889                	li	a7,2
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <wait>:
.global wait
wait:
 li a7, SYS_wait
 39e:	488d                	li	a7,3
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a6:	4891                	li	a7,4
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <read>:
.global read
read:
 li a7, SYS_read
 3ae:	4895                	li	a7,5
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <write>:
.global write
write:
 li a7, SYS_write
 3b6:	48c1                	li	a7,16
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <close>:
.global close
close:
 li a7, SYS_close
 3be:	48d5                	li	a7,21
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c6:	4899                	li	a7,6
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ce:	489d                	li	a7,7
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <open>:
.global open
open:
 li a7, SYS_open
 3d6:	48bd                	li	a7,15
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3de:	48c5                	li	a7,17
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e6:	48c9                	li	a7,18
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ee:	48a1                	li	a7,8
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <link>:
.global link
link:
 li a7, SYS_link
 3f6:	48cd                	li	a7,19
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fe:	48d1                	li	a7,20
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 406:	48a5                	li	a7,9
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <dup>:
.global dup
dup:
 li a7, SYS_dup
 40e:	48a9                	li	a7,10
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 416:	48ad                	li	a7,11
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41e:	48b1                	li	a7,12
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 426:	48b5                	li	a7,13
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42e:	48b9                	li	a7,14
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <yield>:
.global yield
yield:
 li a7, SYS_yield
 436:	48d9                	li	a7,22
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 43e:	48dd                	li	a7,23
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 446:	48e1                	li	a7,24
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 44e:	48e5                	li	a7,25
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 456:	48e9                	li	a7,26
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45e:	1101                	addi	sp,sp,-32
 460:	ec06                	sd	ra,24(sp)
 462:	e822                	sd	s0,16(sp)
 464:	1000                	addi	s0,sp,32
 466:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46a:	4605                	li	a2,1
 46c:	fef40593          	addi	a1,s0,-17
 470:	f47ff0ef          	jal	3b6 <write>
}
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	6105                	addi	sp,sp,32
 47a:	8082                	ret

000000000000047c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47c:	7139                	addi	sp,sp,-64
 47e:	fc06                	sd	ra,56(sp)
 480:	f822                	sd	s0,48(sp)
 482:	f426                	sd	s1,40(sp)
 484:	0080                	addi	s0,sp,64
 486:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 488:	c299                	beqz	a3,48e <printint+0x12>
 48a:	0805c963          	bltz	a1,51c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48e:	2581                	sext.w	a1,a1
  neg = 0;
 490:	4881                	li	a7,0
 492:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 496:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 498:	2601                	sext.w	a2,a2
 49a:	00000517          	auipc	a0,0x0
 49e:	52650513          	addi	a0,a0,1318 # 9c0 <digits>
 4a2:	883a                	mv	a6,a4
 4a4:	2705                	addiw	a4,a4,1
 4a6:	02c5f7bb          	remuw	a5,a1,a2
 4aa:	1782                	slli	a5,a5,0x20
 4ac:	9381                	srli	a5,a5,0x20
 4ae:	97aa                	add	a5,a5,a0
 4b0:	0007c783          	lbu	a5,0(a5)
 4b4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b8:	0005879b          	sext.w	a5,a1
 4bc:	02c5d5bb          	divuw	a1,a1,a2
 4c0:	0685                	addi	a3,a3,1
 4c2:	fec7f0e3          	bgeu	a5,a2,4a2 <printint+0x26>
  if(neg)
 4c6:	00088c63          	beqz	a7,4de <printint+0x62>
    buf[i++] = '-';
 4ca:	fd070793          	addi	a5,a4,-48
 4ce:	00878733          	add	a4,a5,s0
 4d2:	02d00793          	li	a5,45
 4d6:	fef70823          	sb	a5,-16(a4)
 4da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4de:	02e05a63          	blez	a4,512 <printint+0x96>
 4e2:	f04a                	sd	s2,32(sp)
 4e4:	ec4e                	sd	s3,24(sp)
 4e6:	fc040793          	addi	a5,s0,-64
 4ea:	00e78933          	add	s2,a5,a4
 4ee:	fff78993          	addi	s3,a5,-1
 4f2:	99ba                	add	s3,s3,a4
 4f4:	377d                	addiw	a4,a4,-1
 4f6:	1702                	slli	a4,a4,0x20
 4f8:	9301                	srli	a4,a4,0x20
 4fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fe:	fff94583          	lbu	a1,-1(s2)
 502:	8526                	mv	a0,s1
 504:	f5bff0ef          	jal	45e <putc>
  while(--i >= 0)
 508:	197d                	addi	s2,s2,-1
 50a:	ff391ae3          	bne	s2,s3,4fe <printint+0x82>
 50e:	7902                	ld	s2,32(sp)
 510:	69e2                	ld	s3,24(sp)
}
 512:	70e2                	ld	ra,56(sp)
 514:	7442                	ld	s0,48(sp)
 516:	74a2                	ld	s1,40(sp)
 518:	6121                	addi	sp,sp,64
 51a:	8082                	ret
    x = -xx;
 51c:	40b005bb          	negw	a1,a1
    neg = 1;
 520:	4885                	li	a7,1
    x = -xx;
 522:	bf85                	j	492 <printint+0x16>

0000000000000524 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 524:	711d                	addi	sp,sp,-96
 526:	ec86                	sd	ra,88(sp)
 528:	e8a2                	sd	s0,80(sp)
 52a:	e0ca                	sd	s2,64(sp)
 52c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52e:	0005c903          	lbu	s2,0(a1)
 532:	26090863          	beqz	s2,7a2 <vprintf+0x27e>
 536:	e4a6                	sd	s1,72(sp)
 538:	fc4e                	sd	s3,56(sp)
 53a:	f852                	sd	s4,48(sp)
 53c:	f456                	sd	s5,40(sp)
 53e:	f05a                	sd	s6,32(sp)
 540:	ec5e                	sd	s7,24(sp)
 542:	e862                	sd	s8,16(sp)
 544:	e466                	sd	s9,8(sp)
 546:	8b2a                	mv	s6,a0
 548:	8a2e                	mv	s4,a1
 54a:	8bb2                	mv	s7,a2
  state = 0;
 54c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 54e:	4481                	li	s1,0
 550:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 552:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 556:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 55a:	06c00c93          	li	s9,108
 55e:	a005                	j	57e <vprintf+0x5a>
        putc(fd, c0);
 560:	85ca                	mv	a1,s2
 562:	855a                	mv	a0,s6
 564:	efbff0ef          	jal	45e <putc>
 568:	a019                	j	56e <vprintf+0x4a>
    } else if(state == '%'){
 56a:	03598263          	beq	s3,s5,58e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 56e:	2485                	addiw	s1,s1,1
 570:	8726                	mv	a4,s1
 572:	009a07b3          	add	a5,s4,s1
 576:	0007c903          	lbu	s2,0(a5)
 57a:	20090c63          	beqz	s2,792 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 57e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 582:	fe0994e3          	bnez	s3,56a <vprintf+0x46>
      if(c0 == '%'){
 586:	fd579de3          	bne	a5,s5,560 <vprintf+0x3c>
        state = '%';
 58a:	89be                	mv	s3,a5
 58c:	b7cd                	j	56e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 58e:	00ea06b3          	add	a3,s4,a4
 592:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 596:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 598:	c681                	beqz	a3,5a0 <vprintf+0x7c>
 59a:	9752                	add	a4,a4,s4
 59c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5a0:	03878f63          	beq	a5,s8,5de <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5a4:	05978963          	beq	a5,s9,5f6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a8:	07500713          	li	a4,117
 5ac:	0ee78363          	beq	a5,a4,692 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5b0:	07800713          	li	a4,120
 5b4:	12e78563          	beq	a5,a4,6de <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5b8:	07000713          	li	a4,112
 5bc:	14e78a63          	beq	a5,a4,710 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5c0:	07300713          	li	a4,115
 5c4:	18e78a63          	beq	a5,a4,758 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c8:	02500713          	li	a4,37
 5cc:	04e79563          	bne	a5,a4,616 <vprintf+0xf2>
        putc(fd, '%');
 5d0:	02500593          	li	a1,37
 5d4:	855a                	mv	a0,s6
 5d6:	e89ff0ef          	jal	45e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bf49                	j	56e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e91ff0ef          	jal	47c <printint>
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	bfad                	j	56e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5f6:	06400793          	li	a5,100
 5fa:	02f68963          	beq	a3,a5,62c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fe:	06c00793          	li	a5,108
 602:	04f68263          	beq	a3,a5,646 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 606:	07500793          	li	a5,117
 60a:	0af68063          	beq	a3,a5,6aa <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 60e:	07800793          	li	a5,120
 612:	0ef68263          	beq	a3,a5,6f6 <vprintf+0x1d2>
        putc(fd, '%');
 616:	02500593          	li	a1,37
 61a:	855a                	mv	a0,s6
 61c:	e43ff0ef          	jal	45e <putc>
        putc(fd, c0);
 620:	85ca                	mv	a1,s2
 622:	855a                	mv	a0,s6
 624:	e3bff0ef          	jal	45e <putc>
      state = 0;
 628:	4981                	li	s3,0
 62a:	b791                	j	56e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62c:	008b8913          	addi	s2,s7,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000ba583          	lw	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	e43ff0ef          	jal	47c <printint>
        i += 1;
 63e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
        i += 1;
 644:	b72d                	j	56e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 646:	06400793          	li	a5,100
 64a:	02f60763          	beq	a2,a5,678 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 64e:	07500793          	li	a5,117
 652:	06f60963          	beq	a2,a5,6c4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 656:	07800793          	li	a5,120
 65a:	faf61ee3          	bne	a2,a5,616 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65e:	008b8913          	addi	s2,s7,8
 662:	4681                	li	a3,0
 664:	4641                	li	a2,16
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e11ff0ef          	jal	47c <printint>
        i += 2;
 670:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	bde5                	j	56e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	008b8913          	addi	s2,s7,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	df7ff0ef          	jal	47c <printint>
        i += 2;
 68a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	bdf9                	j	56e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 692:	008b8913          	addi	s2,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	dddff0ef          	jal	47c <printint>
 6a4:	8bca                	mv	s7,s2
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b5d9                	j	56e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4629                	li	a2,10
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	dc5ff0ef          	jal	47c <printint>
        i += 1;
 6bc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
        i += 1;
 6c2:	b575                	j	56e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	008b8913          	addi	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4629                	li	a2,10
 6cc:	000ba583          	lw	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	dabff0ef          	jal	47c <printint>
        i += 2;
 6d6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
        i += 2;
 6dc:	bd49                	j	56e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6de:	008b8913          	addi	s2,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4641                	li	a2,16
 6e6:	000ba583          	lw	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	d91ff0ef          	jal	47c <printint>
 6f0:	8bca                	mv	s7,s2
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bdad                	j	56e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	008b8913          	addi	s2,s7,8
 6fa:	4681                	li	a3,0
 6fc:	4641                	li	a2,16
 6fe:	000ba583          	lw	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	d79ff0ef          	jal	47c <printint>
        i += 1;
 708:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
        i += 1;
 70e:	b585                	j	56e <vprintf+0x4a>
 710:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 712:	008b8d13          	addi	s10,s7,8
 716:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 71a:	03000593          	li	a1,48
 71e:	855a                	mv	a0,s6
 720:	d3fff0ef          	jal	45e <putc>
  putc(fd, 'x');
 724:	07800593          	li	a1,120
 728:	855a                	mv	a0,s6
 72a:	d35ff0ef          	jal	45e <putc>
 72e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 730:	00000b97          	auipc	s7,0x0
 734:	290b8b93          	addi	s7,s7,656 # 9c0 <digits>
 738:	03c9d793          	srli	a5,s3,0x3c
 73c:	97de                	add	a5,a5,s7
 73e:	0007c583          	lbu	a1,0(a5)
 742:	855a                	mv	a0,s6
 744:	d1bff0ef          	jal	45e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 748:	0992                	slli	s3,s3,0x4
 74a:	397d                	addiw	s2,s2,-1
 74c:	fe0916e3          	bnez	s2,738 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 750:	8bea                	mv	s7,s10
      state = 0;
 752:	4981                	li	s3,0
 754:	6d02                	ld	s10,0(sp)
 756:	bd21                	j	56e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 758:	008b8993          	addi	s3,s7,8
 75c:	000bb903          	ld	s2,0(s7)
 760:	00090f63          	beqz	s2,77e <vprintf+0x25a>
        for(; *s; s++)
 764:	00094583          	lbu	a1,0(s2)
 768:	c195                	beqz	a1,78c <vprintf+0x268>
          putc(fd, *s);
 76a:	855a                	mv	a0,s6
 76c:	cf3ff0ef          	jal	45e <putc>
        for(; *s; s++)
 770:	0905                	addi	s2,s2,1
 772:	00094583          	lbu	a1,0(s2)
 776:	f9f5                	bnez	a1,76a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 778:	8bce                	mv	s7,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bbcd                	j	56e <vprintf+0x4a>
          s = "(null)";
 77e:	00000917          	auipc	s2,0x0
 782:	23a90913          	addi	s2,s2,570 # 9b8 <malloc+0x12e>
        for(; *s; s++)
 786:	02800593          	li	a1,40
 78a:	b7c5                	j	76a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 78c:	8bce                	mv	s7,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	bbf9                	j	56e <vprintf+0x4a>
 792:	64a6                	ld	s1,72(sp)
 794:	79e2                	ld	s3,56(sp)
 796:	7a42                	ld	s4,48(sp)
 798:	7aa2                	ld	s5,40(sp)
 79a:	7b02                	ld	s6,32(sp)
 79c:	6be2                	ld	s7,24(sp)
 79e:	6c42                	ld	s8,16(sp)
 7a0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7a2:	60e6                	ld	ra,88(sp)
 7a4:	6446                	ld	s0,80(sp)
 7a6:	6906                	ld	s2,64(sp)
 7a8:	6125                	addi	sp,sp,96
 7aa:	8082                	ret

00000000000007ac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ac:	715d                	addi	sp,sp,-80
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e010                	sd	a2,0(s0)
 7b6:	e414                	sd	a3,8(s0)
 7b8:	e818                	sd	a4,16(s0)
 7ba:	ec1c                	sd	a5,24(s0)
 7bc:	03043023          	sd	a6,32(s0)
 7c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c8:	8622                	mv	a2,s0
 7ca:	d5bff0ef          	jal	524 <vprintf>
}
 7ce:	60e2                	ld	ra,24(sp)
 7d0:	6442                	ld	s0,16(sp)
 7d2:	6161                	addi	sp,sp,80
 7d4:	8082                	ret

00000000000007d6 <printf>:

void
printf(const char *fmt, ...)
{
 7d6:	711d                	addi	sp,sp,-96
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	e40c                	sd	a1,8(s0)
 7e0:	e810                	sd	a2,16(s0)
 7e2:	ec14                	sd	a3,24(s0)
 7e4:	f018                	sd	a4,32(s0)
 7e6:	f41c                	sd	a5,40(s0)
 7e8:	03043823          	sd	a6,48(s0)
 7ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	00840613          	addi	a2,s0,8
 7f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f8:	85aa                	mv	a1,a0
 7fa:	4505                	li	a0,1
 7fc:	d29ff0ef          	jal	524 <vprintf>
}
 800:	60e2                	ld	ra,24(sp)
 802:	6442                	ld	s0,16(sp)
 804:	6125                	addi	sp,sp,96
 806:	8082                	ret

0000000000000808 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 808:	1141                	addi	sp,sp,-16
 80a:	e422                	sd	s0,8(sp)
 80c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 812:	00000797          	auipc	a5,0x0
 816:	7ee7b783          	ld	a5,2030(a5) # 1000 <freep>
 81a:	a02d                	j	844 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81c:	4618                	lw	a4,8(a2)
 81e:	9f2d                	addw	a4,a4,a1
 820:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	6310                	ld	a2,0(a4)
 828:	a83d                	j	866 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 82a:	ff852703          	lw	a4,-8(a0)
 82e:	9f31                	addw	a4,a4,a2
 830:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 832:	ff053683          	ld	a3,-16(a0)
 836:	a091                	j	87a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	6398                	ld	a4,0(a5)
 83a:	00e7e463          	bltu	a5,a4,842 <free+0x3a>
 83e:	00e6ea63          	bltu	a3,a4,852 <free+0x4a>
{
 842:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	fed7fae3          	bgeu	a5,a3,838 <free+0x30>
 848:	6398                	ld	a4,0(a5)
 84a:	00e6e463          	bltu	a3,a4,852 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	fee7eae3          	bltu	a5,a4,842 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 852:	ff852583          	lw	a1,-8(a0)
 856:	6390                	ld	a2,0(a5)
 858:	02059813          	slli	a6,a1,0x20
 85c:	01c85713          	srli	a4,a6,0x1c
 860:	9736                	add	a4,a4,a3
 862:	fae60de3          	beq	a2,a4,81c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 86a:	4790                	lw	a2,8(a5)
 86c:	02061593          	slli	a1,a2,0x20
 870:	01c5d713          	srli	a4,a1,0x1c
 874:	973e                	add	a4,a4,a5
 876:	fae68ae3          	beq	a3,a4,82a <free+0x22>
    p->s.ptr = bp->s.ptr;
 87a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 87c:	00000717          	auipc	a4,0x0
 880:	78f73223          	sd	a5,1924(a4) # 1000 <freep>
}
 884:	6422                	ld	s0,8(sp)
 886:	0141                	addi	sp,sp,16
 888:	8082                	ret

000000000000088a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 88a:	7139                	addi	sp,sp,-64
 88c:	fc06                	sd	ra,56(sp)
 88e:	f822                	sd	s0,48(sp)
 890:	f426                	sd	s1,40(sp)
 892:	ec4e                	sd	s3,24(sp)
 894:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	02051493          	slli	s1,a0,0x20
 89a:	9081                	srli	s1,s1,0x20
 89c:	04bd                	addi	s1,s1,15
 89e:	8091                	srli	s1,s1,0x4
 8a0:	0014899b          	addiw	s3,s1,1
 8a4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8a6:	00000517          	auipc	a0,0x0
 8aa:	75a53503          	ld	a0,1882(a0) # 1000 <freep>
 8ae:	c915                	beqz	a0,8e2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b2:	4798                	lw	a4,8(a5)
 8b4:	08977a63          	bgeu	a4,s1,948 <malloc+0xbe>
 8b8:	f04a                	sd	s2,32(sp)
 8ba:	e852                	sd	s4,16(sp)
 8bc:	e456                	sd	s5,8(sp)
 8be:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8c0:	8a4e                	mv	s4,s3
 8c2:	0009871b          	sext.w	a4,s3
 8c6:	6685                	lui	a3,0x1
 8c8:	00d77363          	bgeu	a4,a3,8ce <malloc+0x44>
 8cc:	6a05                	lui	s4,0x1
 8ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d6:	00000917          	auipc	s2,0x0
 8da:	72a90913          	addi	s2,s2,1834 # 1000 <freep>
  if(p == (char*)-1)
 8de:	5afd                	li	s5,-1
 8e0:	a081                	j	920 <malloc+0x96>
 8e2:	f04a                	sd	s2,32(sp)
 8e4:	e852                	sd	s4,16(sp)
 8e6:	e456                	sd	s5,8(sp)
 8e8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ea:	00000797          	auipc	a5,0x0
 8ee:	72678793          	addi	a5,a5,1830 # 1010 <base>
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70f73723          	sd	a5,1806(a4) # 1000 <freep>
 8fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 900:	b7c1                	j	8c0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 902:	6398                	ld	a4,0(a5)
 904:	e118                	sd	a4,0(a0)
 906:	a8a9                	j	960 <malloc+0xd6>
  hp->s.size = nu;
 908:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 90c:	0541                	addi	a0,a0,16
 90e:	efbff0ef          	jal	808 <free>
  return freep;
 912:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 916:	c12d                	beqz	a0,978 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 918:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91a:	4798                	lw	a4,8(a5)
 91c:	02977263          	bgeu	a4,s1,940 <malloc+0xb6>
    if(p == freep)
 920:	00093703          	ld	a4,0(s2)
 924:	853e                	mv	a0,a5
 926:	fef719e3          	bne	a4,a5,918 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 92a:	8552                	mv	a0,s4
 92c:	af3ff0ef          	jal	41e <sbrk>
  if(p == (char*)-1)
 930:	fd551ce3          	bne	a0,s5,908 <malloc+0x7e>
        return 0;
 934:	4501                	li	a0,0
 936:	7902                	ld	s2,32(sp)
 938:	6a42                	ld	s4,16(sp)
 93a:	6aa2                	ld	s5,8(sp)
 93c:	6b02                	ld	s6,0(sp)
 93e:	a03d                	j	96c <malloc+0xe2>
 940:	7902                	ld	s2,32(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 948:	fae48de3          	beq	s1,a4,902 <malloc+0x78>
        p->s.size -= nunits;
 94c:	4137073b          	subw	a4,a4,s3
 950:	c798                	sw	a4,8(a5)
        p += p->s.size;
 952:	02071693          	slli	a3,a4,0x20
 956:	01c6d713          	srli	a4,a3,0x1c
 95a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 95c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 960:	00000717          	auipc	a4,0x0
 964:	6aa73023          	sd	a0,1696(a4) # 1000 <freep>
      return (void*)(p + 1);
 968:	01078513          	addi	a0,a5,16
  }
}
 96c:	70e2                	ld	ra,56(sp)
 96e:	7442                	ld	s0,48(sp)
 970:	74a2                	ld	s1,40(sp)
 972:	69e2                	ld	s3,24(sp)
 974:	6121                	addi	sp,sp,64
 976:	8082                	ret
 978:	7902                	ld	s2,32(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
 980:	b7f5                	j	96c <malloc+0xe2>
