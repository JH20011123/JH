
user/_test1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <long_task>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void long_task(void) {
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
  44:	e04a                	sd	s2,0(sp)
  46:	1000                	addi	s0,sp,32
  int i;
  for (i = 1; i <= 10; i++) {
  48:	4485                	li	s1,1
  4a:	492d                	li	s2,11
    int pid = fork();
  4c:	304000ef          	jal	350 <fork>
    if (pid == 0) {
  50:	c11d                	beqz	a0,76 <main+0x3a>
  for (i = 1; i <= 10; i++) {
  52:	2485                	addiw	s1,s1,1
  54:	ff249ce3          	bne	s1,s2,4c <main+0x10>
  58:	44a9                	li	s1,10
      printf("P%d: end\n", i);
      exit(0);
    }
  }
  for (i = 0; i < 10; i++)
    wait(0);
  5a:	4501                	li	a0,0
  5c:	304000ef          	jal	360 <wait>
  for (i = 0; i < 10; i++)
  60:	34fd                	addiw	s1,s1,-1
  62:	fce5                	bnez	s1,5a <main+0x1e>
  printf("FCFS test completed.\n");
  64:	00001517          	auipc	a0,0x1
  68:	92c50513          	addi	a0,a0,-1748 # 990 <malloc+0x144>
  6c:	72c000ef          	jal	798 <printf>
  exit(0);
  70:	4501                	li	a0,0
  72:	2e6000ef          	jal	358 <exit>
      printf("P%d: start\n", i);
  76:	85a6                	mv	a1,s1
  78:	00001517          	auipc	a0,0x1
  7c:	8d850513          	addi	a0,a0,-1832 # 950 <malloc+0x104>
  80:	718000ef          	jal	798 <printf>
      if (i >= 1 && i <= 5) {
  84:	fff4879b          	addiw	a5,s1,-1
  88:	4711                	li	a4,4
  8a:	02f77763          	bgeu	a4,a5,b8 <main+0x7c>
      } else if (i == 6) {
  8e:	4799                	li	a5,6
  90:	04f48063          	beq	s1,a5,d0 <main+0x94>
      } else if (i >= 7 && i <= 9) {
  94:	47a9                	li	a5,10
  96:	02f49363          	bne	s1,a5,bc <main+0x80>
        printf("call yield\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	8c650513          	addi	a0,a0,-1850 # 960 <malloc+0x114>
  a2:	6f6000ef          	jal	798 <printf>
        yield();
  a6:	352000ef          	jal	3f8 <yield>
        printf("end yield\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	8c650513          	addi	a0,a0,-1850 # 970 <malloc+0x124>
  b2:	6e6000ef          	jal	798 <printf>
  b6:	a019                	j	bc <main+0x80>
        long_task();
  b8:	f49ff0ef          	jal	0 <long_task>
      printf("P%d: end\n", i);
  bc:	85a6                	mv	a1,s1
  be:	00001517          	auipc	a0,0x1
  c2:	8c250513          	addi	a0,a0,-1854 # 980 <malloc+0x134>
  c6:	6d2000ef          	jal	798 <printf>
      exit(0);
  ca:	4501                	li	a0,0
  cc:	28c000ef          	jal	358 <exit>
        printf("call yield\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	89050513          	addi	a0,a0,-1904 # 960 <malloc+0x114>
  d8:	6c0000ef          	jal	798 <printf>
        yield();
  dc:	31c000ef          	jal	3f8 <yield>
        printf("end yield\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	89050513          	addi	a0,a0,-1904 # 970 <malloc+0x124>
  e8:	6b0000ef          	jal	798 <printf>
  ec:	bfc1                	j	bc <main+0x80>

00000000000000ee <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  extern int main();
  main();
  f6:	f47ff0ef          	jal	3c <main>
  exit(0);
  fa:	4501                	li	a0,0
  fc:	25c000ef          	jal	358 <exit>

0000000000000100 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 100:	1141                	addi	sp,sp,-16
 102:	e422                	sd	s0,8(sp)
 104:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 106:	87aa                	mv	a5,a0
 108:	0585                	addi	a1,a1,1
 10a:	0785                	addi	a5,a5,1
 10c:	fff5c703          	lbu	a4,-1(a1)
 110:	fee78fa3          	sb	a4,-1(a5)
 114:	fb75                	bnez	a4,108 <strcpy+0x8>
    ;
  return os;
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 122:	00054783          	lbu	a5,0(a0)
 126:	cb91                	beqz	a5,13a <strcmp+0x1e>
 128:	0005c703          	lbu	a4,0(a1)
 12c:	00f71763          	bne	a4,a5,13a <strcmp+0x1e>
    p++, q++;
 130:	0505                	addi	a0,a0,1
 132:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	fbe5                	bnez	a5,128 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 13a:	0005c503          	lbu	a0,0(a1)
}
 13e:	40a7853b          	subw	a0,a5,a0
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 14e:	00054783          	lbu	a5,0(a0)
 152:	cf91                	beqz	a5,16e <strlen+0x26>
 154:	0505                	addi	a0,a0,1
 156:	87aa                	mv	a5,a0
 158:	86be                	mv	a3,a5
 15a:	0785                	addi	a5,a5,1
 15c:	fff7c703          	lbu	a4,-1(a5)
 160:	ff65                	bnez	a4,158 <strlen+0x10>
 162:	40a6853b          	subw	a0,a3,a0
 166:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret
  for(n = 0; s[n]; n++)
 16e:	4501                	li	a0,0
 170:	bfe5                	j	168 <strlen+0x20>

0000000000000172 <memset>:

void*
memset(void *dst, int c, uint n)
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 178:	ca19                	beqz	a2,18e <memset+0x1c>
 17a:	87aa                	mv	a5,a0
 17c:	1602                	slli	a2,a2,0x20
 17e:	9201                	srli	a2,a2,0x20
 180:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 184:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 188:	0785                	addi	a5,a5,1
 18a:	fee79de3          	bne	a5,a4,184 <memset+0x12>
  }
  return dst;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret

0000000000000194 <strchr>:

char*
strchr(const char *s, char c)
{
 194:	1141                	addi	sp,sp,-16
 196:	e422                	sd	s0,8(sp)
 198:	0800                	addi	s0,sp,16
  for(; *s; s++)
 19a:	00054783          	lbu	a5,0(a0)
 19e:	cb99                	beqz	a5,1b4 <strchr+0x20>
    if(*s == c)
 1a0:	00f58763          	beq	a1,a5,1ae <strchr+0x1a>
  for(; *s; s++)
 1a4:	0505                	addi	a0,a0,1
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	fbfd                	bnez	a5,1a0 <strchr+0xc>
      return (char*)s;
  return 0;
 1ac:	4501                	li	a0,0
}
 1ae:	6422                	ld	s0,8(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret
  return 0;
 1b4:	4501                	li	a0,0
 1b6:	bfe5                	j	1ae <strchr+0x1a>

00000000000001b8 <gets>:

char*
gets(char *buf, int max)
{
 1b8:	711d                	addi	sp,sp,-96
 1ba:	ec86                	sd	ra,88(sp)
 1bc:	e8a2                	sd	s0,80(sp)
 1be:	e4a6                	sd	s1,72(sp)
 1c0:	e0ca                	sd	s2,64(sp)
 1c2:	fc4e                	sd	s3,56(sp)
 1c4:	f852                	sd	s4,48(sp)
 1c6:	f456                	sd	s5,40(sp)
 1c8:	f05a                	sd	s6,32(sp)
 1ca:	ec5e                	sd	s7,24(sp)
 1cc:	1080                	addi	s0,sp,96
 1ce:	8baa                	mv	s7,a0
 1d0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d2:	892a                	mv	s2,a0
 1d4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d6:	4aa9                	li	s5,10
 1d8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1da:	89a6                	mv	s3,s1
 1dc:	2485                	addiw	s1,s1,1
 1de:	0344d663          	bge	s1,s4,20a <gets+0x52>
    cc = read(0, &c, 1);
 1e2:	4605                	li	a2,1
 1e4:	faf40593          	addi	a1,s0,-81
 1e8:	4501                	li	a0,0
 1ea:	186000ef          	jal	370 <read>
    if(cc < 1)
 1ee:	00a05e63          	blez	a0,20a <gets+0x52>
    buf[i++] = c;
 1f2:	faf44783          	lbu	a5,-81(s0)
 1f6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1fa:	01578763          	beq	a5,s5,208 <gets+0x50>
 1fe:	0905                	addi	s2,s2,1
 200:	fd679de3          	bne	a5,s6,1da <gets+0x22>
    buf[i++] = c;
 204:	89a6                	mv	s3,s1
 206:	a011                	j	20a <gets+0x52>
 208:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 20a:	99de                	add	s3,s3,s7
 20c:	00098023          	sb	zero,0(s3)
  return buf;
}
 210:	855e                	mv	a0,s7
 212:	60e6                	ld	ra,88(sp)
 214:	6446                	ld	s0,80(sp)
 216:	64a6                	ld	s1,72(sp)
 218:	6906                	ld	s2,64(sp)
 21a:	79e2                	ld	s3,56(sp)
 21c:	7a42                	ld	s4,48(sp)
 21e:	7aa2                	ld	s5,40(sp)
 220:	7b02                	ld	s6,32(sp)
 222:	6be2                	ld	s7,24(sp)
 224:	6125                	addi	sp,sp,96
 226:	8082                	ret

0000000000000228 <stat>:

int
stat(const char *n, struct stat *st)
{
 228:	1101                	addi	sp,sp,-32
 22a:	ec06                	sd	ra,24(sp)
 22c:	e822                	sd	s0,16(sp)
 22e:	e04a                	sd	s2,0(sp)
 230:	1000                	addi	s0,sp,32
 232:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	4581                	li	a1,0
 236:	162000ef          	jal	398 <open>
  if(fd < 0)
 23a:	02054263          	bltz	a0,25e <stat+0x36>
 23e:	e426                	sd	s1,8(sp)
 240:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 242:	85ca                	mv	a1,s2
 244:	16c000ef          	jal	3b0 <fstat>
 248:	892a                	mv	s2,a0
  close(fd);
 24a:	8526                	mv	a0,s1
 24c:	134000ef          	jal	380 <close>
  return r;
 250:	64a2                	ld	s1,8(sp)
}
 252:	854a                	mv	a0,s2
 254:	60e2                	ld	ra,24(sp)
 256:	6442                	ld	s0,16(sp)
 258:	6902                	ld	s2,0(sp)
 25a:	6105                	addi	sp,sp,32
 25c:	8082                	ret
    return -1;
 25e:	597d                	li	s2,-1
 260:	bfcd                	j	252 <stat+0x2a>

0000000000000262 <atoi>:

int
atoi(const char *s)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 268:	00054683          	lbu	a3,0(a0)
 26c:	fd06879b          	addiw	a5,a3,-48
 270:	0ff7f793          	zext.b	a5,a5
 274:	4625                	li	a2,9
 276:	02f66863          	bltu	a2,a5,2a6 <atoi+0x44>
 27a:	872a                	mv	a4,a0
  n = 0;
 27c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27e:	0705                	addi	a4,a4,1
 280:	0025179b          	slliw	a5,a0,0x2
 284:	9fa9                	addw	a5,a5,a0
 286:	0017979b          	slliw	a5,a5,0x1
 28a:	9fb5                	addw	a5,a5,a3
 28c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 290:	00074683          	lbu	a3,0(a4)
 294:	fd06879b          	addiw	a5,a3,-48
 298:	0ff7f793          	zext.b	a5,a5
 29c:	fef671e3          	bgeu	a2,a5,27e <atoi+0x1c>
  return n;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  n = 0;
 2a6:	4501                	li	a0,0
 2a8:	bfe5                	j	2a0 <atoi+0x3e>

00000000000002aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b0:	02b57463          	bgeu	a0,a1,2d8 <memmove+0x2e>
    while(n-- > 0)
 2b4:	00c05f63          	blez	a2,2d2 <memmove+0x28>
 2b8:	1602                	slli	a2,a2,0x20
 2ba:	9201                	srli	a2,a2,0x20
 2bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c2:	0585                	addi	a1,a1,1
 2c4:	0705                	addi	a4,a4,1
 2c6:	fff5c683          	lbu	a3,-1(a1)
 2ca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ce:	fef71ae3          	bne	a4,a5,2c2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
    dst += n;
 2d8:	00c50733          	add	a4,a0,a2
    src += n;
 2dc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2de:	fec05ae3          	blez	a2,2d2 <memmove+0x28>
 2e2:	fff6079b          	addiw	a5,a2,-1
 2e6:	1782                	slli	a5,a5,0x20
 2e8:	9381                	srli	a5,a5,0x20
 2ea:	fff7c793          	not	a5,a5
 2ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f0:	15fd                	addi	a1,a1,-1
 2f2:	177d                	addi	a4,a4,-1
 2f4:	0005c683          	lbu	a3,0(a1)
 2f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fc:	fee79ae3          	bne	a5,a4,2f0 <memmove+0x46>
 300:	bfc9                	j	2d2 <memmove+0x28>

0000000000000302 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 308:	ca05                	beqz	a2,338 <memcmp+0x36>
 30a:	fff6069b          	addiw	a3,a2,-1
 30e:	1682                	slli	a3,a3,0x20
 310:	9281                	srli	a3,a3,0x20
 312:	0685                	addi	a3,a3,1
 314:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 316:	00054783          	lbu	a5,0(a0)
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00e79863          	bne	a5,a4,32e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 322:	0505                	addi	a0,a0,1
    p2++;
 324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 326:	fed518e3          	bne	a0,a3,316 <memcmp+0x14>
  }
  return 0;
 32a:	4501                	li	a0,0
 32c:	a019                	j	332 <memcmp+0x30>
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
  return 0;
 338:	4501                	li	a0,0
 33a:	bfe5                	j	332 <memcmp+0x30>

000000000000033c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 344:	f67ff0ef          	jal	2aa <memmove>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 350:	4885                	li	a7,1
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exit>:
.global exit
exit:
 li a7, SYS_exit
 358:	4889                	li	a7,2
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <wait>:
.global wait
wait:
 li a7, SYS_wait
 360:	488d                	li	a7,3
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 368:	4891                	li	a7,4
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <read>:
.global read
read:
 li a7, SYS_read
 370:	4895                	li	a7,5
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <write>:
.global write
write:
 li a7, SYS_write
 378:	48c1                	li	a7,16
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <close>:
.global close
close:
 li a7, SYS_close
 380:	48d5                	li	a7,21
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <kill>:
.global kill
kill:
 li a7, SYS_kill
 388:	4899                	li	a7,6
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <exec>:
.global exec
exec:
 li a7, SYS_exec
 390:	489d                	li	a7,7
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <open>:
.global open
open:
 li a7, SYS_open
 398:	48bd                	li	a7,15
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a0:	48c5                	li	a7,17
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a8:	48c9                	li	a7,18
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b0:	48a1                	li	a7,8
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <link>:
.global link
link:
 li a7, SYS_link
 3b8:	48cd                	li	a7,19
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c0:	48d1                	li	a7,20
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c8:	48a5                	li	a7,9
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d0:	48a9                	li	a7,10
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d8:	48ad                	li	a7,11
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e0:	48b1                	li	a7,12
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e8:	48b5                	li	a7,13
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f0:	48b9                	li	a7,14
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <yield>:
.global yield
yield:
 li a7, SYS_yield
 3f8:	48d9                	li	a7,22
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 400:	48dd                	li	a7,23
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 408:	48e1                	li	a7,24
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 410:	48e5                	li	a7,25
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 418:	48e9                	li	a7,26
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	1000                	addi	s0,sp,32
 428:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42c:	4605                	li	a2,1
 42e:	fef40593          	addi	a1,s0,-17
 432:	f47ff0ef          	jal	378 <write>
}
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	6105                	addi	sp,sp,32
 43c:	8082                	ret

000000000000043e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43e:	7139                	addi	sp,sp,-64
 440:	fc06                	sd	ra,56(sp)
 442:	f822                	sd	s0,48(sp)
 444:	f426                	sd	s1,40(sp)
 446:	0080                	addi	s0,sp,64
 448:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44a:	c299                	beqz	a3,450 <printint+0x12>
 44c:	0805c963          	bltz	a1,4de <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 450:	2581                	sext.w	a1,a1
  neg = 0;
 452:	4881                	li	a7,0
 454:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 458:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45a:	2601                	sext.w	a2,a2
 45c:	00000517          	auipc	a0,0x0
 460:	55450513          	addi	a0,a0,1364 # 9b0 <digits>
 464:	883a                	mv	a6,a4
 466:	2705                	addiw	a4,a4,1
 468:	02c5f7bb          	remuw	a5,a1,a2
 46c:	1782                	slli	a5,a5,0x20
 46e:	9381                	srli	a5,a5,0x20
 470:	97aa                	add	a5,a5,a0
 472:	0007c783          	lbu	a5,0(a5)
 476:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47a:	0005879b          	sext.w	a5,a1
 47e:	02c5d5bb          	divuw	a1,a1,a2
 482:	0685                	addi	a3,a3,1
 484:	fec7f0e3          	bgeu	a5,a2,464 <printint+0x26>
  if(neg)
 488:	00088c63          	beqz	a7,4a0 <printint+0x62>
    buf[i++] = '-';
 48c:	fd070793          	addi	a5,a4,-48
 490:	00878733          	add	a4,a5,s0
 494:	02d00793          	li	a5,45
 498:	fef70823          	sb	a5,-16(a4)
 49c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a0:	02e05a63          	blez	a4,4d4 <printint+0x96>
 4a4:	f04a                	sd	s2,32(sp)
 4a6:	ec4e                	sd	s3,24(sp)
 4a8:	fc040793          	addi	a5,s0,-64
 4ac:	00e78933          	add	s2,a5,a4
 4b0:	fff78993          	addi	s3,a5,-1
 4b4:	99ba                	add	s3,s3,a4
 4b6:	377d                	addiw	a4,a4,-1
 4b8:	1702                	slli	a4,a4,0x20
 4ba:	9301                	srli	a4,a4,0x20
 4bc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c0:	fff94583          	lbu	a1,-1(s2)
 4c4:	8526                	mv	a0,s1
 4c6:	f5bff0ef          	jal	420 <putc>
  while(--i >= 0)
 4ca:	197d                	addi	s2,s2,-1
 4cc:	ff391ae3          	bne	s2,s3,4c0 <printint+0x82>
 4d0:	7902                	ld	s2,32(sp)
 4d2:	69e2                	ld	s3,24(sp)
}
 4d4:	70e2                	ld	ra,56(sp)
 4d6:	7442                	ld	s0,48(sp)
 4d8:	74a2                	ld	s1,40(sp)
 4da:	6121                	addi	sp,sp,64
 4dc:	8082                	ret
    x = -xx;
 4de:	40b005bb          	negw	a1,a1
    neg = 1;
 4e2:	4885                	li	a7,1
    x = -xx;
 4e4:	bf85                	j	454 <printint+0x16>

00000000000004e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e6:	711d                	addi	sp,sp,-96
 4e8:	ec86                	sd	ra,88(sp)
 4ea:	e8a2                	sd	s0,80(sp)
 4ec:	e0ca                	sd	s2,64(sp)
 4ee:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f0:	0005c903          	lbu	s2,0(a1)
 4f4:	26090863          	beqz	s2,764 <vprintf+0x27e>
 4f8:	e4a6                	sd	s1,72(sp)
 4fa:	fc4e                	sd	s3,56(sp)
 4fc:	f852                	sd	s4,48(sp)
 4fe:	f456                	sd	s5,40(sp)
 500:	f05a                	sd	s6,32(sp)
 502:	ec5e                	sd	s7,24(sp)
 504:	e862                	sd	s8,16(sp)
 506:	e466                	sd	s9,8(sp)
 508:	8b2a                	mv	s6,a0
 50a:	8a2e                	mv	s4,a1
 50c:	8bb2                	mv	s7,a2
  state = 0;
 50e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 510:	4481                	li	s1,0
 512:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 514:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 518:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 51c:	06c00c93          	li	s9,108
 520:	a005                	j	540 <vprintf+0x5a>
        putc(fd, c0);
 522:	85ca                	mv	a1,s2
 524:	855a                	mv	a0,s6
 526:	efbff0ef          	jal	420 <putc>
 52a:	a019                	j	530 <vprintf+0x4a>
    } else if(state == '%'){
 52c:	03598263          	beq	s3,s5,550 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 530:	2485                	addiw	s1,s1,1
 532:	8726                	mv	a4,s1
 534:	009a07b3          	add	a5,s4,s1
 538:	0007c903          	lbu	s2,0(a5)
 53c:	20090c63          	beqz	s2,754 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 540:	0009079b          	sext.w	a5,s2
    if(state == 0){
 544:	fe0994e3          	bnez	s3,52c <vprintf+0x46>
      if(c0 == '%'){
 548:	fd579de3          	bne	a5,s5,522 <vprintf+0x3c>
        state = '%';
 54c:	89be                	mv	s3,a5
 54e:	b7cd                	j	530 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 550:	00ea06b3          	add	a3,s4,a4
 554:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 558:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 55a:	c681                	beqz	a3,562 <vprintf+0x7c>
 55c:	9752                	add	a4,a4,s4
 55e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 562:	03878f63          	beq	a5,s8,5a0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 566:	05978963          	beq	a5,s9,5b8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 56a:	07500713          	li	a4,117
 56e:	0ee78363          	beq	a5,a4,654 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 572:	07800713          	li	a4,120
 576:	12e78563          	beq	a5,a4,6a0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 57a:	07000713          	li	a4,112
 57e:	14e78a63          	beq	a5,a4,6d2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 582:	07300713          	li	a4,115
 586:	18e78a63          	beq	a5,a4,71a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 58a:	02500713          	li	a4,37
 58e:	04e79563          	bne	a5,a4,5d8 <vprintf+0xf2>
        putc(fd, '%');
 592:	02500593          	li	a1,37
 596:	855a                	mv	a0,s6
 598:	e89ff0ef          	jal	420 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bf49                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	e91ff0ef          	jal	43e <printint>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bfad                	j	530 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5b8:	06400793          	li	a5,100
 5bc:	02f68963          	beq	a3,a5,5ee <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c0:	06c00793          	li	a5,108
 5c4:	04f68263          	beq	a3,a5,608 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5c8:	07500793          	li	a5,117
 5cc:	0af68063          	beq	a3,a5,66c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5d0:	07800793          	li	a5,120
 5d4:	0ef68263          	beq	a3,a5,6b8 <vprintf+0x1d2>
        putc(fd, '%');
 5d8:	02500593          	li	a1,37
 5dc:	855a                	mv	a0,s6
 5de:	e43ff0ef          	jal	420 <putc>
        putc(fd, c0);
 5e2:	85ca                	mv	a1,s2
 5e4:	855a                	mv	a0,s6
 5e6:	e3bff0ef          	jal	420 <putc>
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b791                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4685                	li	a3,1
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	e43ff0ef          	jal	43e <printint>
        i += 1;
 600:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
        i += 1;
 606:	b72d                	j	530 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 608:	06400793          	li	a5,100
 60c:	02f60763          	beq	a2,a5,63a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 610:	07500793          	li	a5,117
 614:	06f60963          	beq	a2,a5,686 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 618:	07800793          	li	a5,120
 61c:	faf61ee3          	bne	a2,a5,5d8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4641                	li	a2,16
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	e11ff0ef          	jal	43e <printint>
        i += 2;
 632:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
        i += 2;
 638:	bde5                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	df7ff0ef          	jal	43e <printint>
        i += 2;
 64c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 2;
 652:	bdf9                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 654:	008b8913          	addi	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4629                	li	a2,10
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	dddff0ef          	jal	43e <printint>
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	b5d9                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66c:	008b8913          	addi	s2,s7,8
 670:	4681                	li	a3,0
 672:	4629                	li	a2,10
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	dc5ff0ef          	jal	43e <printint>
        i += 1;
 67e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
        i += 1;
 684:	b575                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 686:	008b8913          	addi	s2,s7,8
 68a:	4681                	li	a3,0
 68c:	4629                	li	a2,10
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	dabff0ef          	jal	43e <printint>
        i += 2;
 698:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
        i += 2;
 69e:	bd49                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4641                	li	a2,16
 6a8:	000ba583          	lw	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	d91ff0ef          	jal	43e <printint>
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bdad                	j	530 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4681                	li	a3,0
 6be:	4641                	li	a2,16
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	d79ff0ef          	jal	43e <printint>
        i += 1;
 6ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 1;
 6d0:	b585                	j	530 <vprintf+0x4a>
 6d2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6d4:	008b8d13          	addi	s10,s7,8
 6d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6dc:	03000593          	li	a1,48
 6e0:	855a                	mv	a0,s6
 6e2:	d3fff0ef          	jal	420 <putc>
  putc(fd, 'x');
 6e6:	07800593          	li	a1,120
 6ea:	855a                	mv	a0,s6
 6ec:	d35ff0ef          	jal	420 <putc>
 6f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f2:	00000b97          	auipc	s7,0x0
 6f6:	2beb8b93          	addi	s7,s7,702 # 9b0 <digits>
 6fa:	03c9d793          	srli	a5,s3,0x3c
 6fe:	97de                	add	a5,a5,s7
 700:	0007c583          	lbu	a1,0(a5)
 704:	855a                	mv	a0,s6
 706:	d1bff0ef          	jal	420 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70a:	0992                	slli	s3,s3,0x4
 70c:	397d                	addiw	s2,s2,-1
 70e:	fe0916e3          	bnez	s2,6fa <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 712:	8bea                	mv	s7,s10
      state = 0;
 714:	4981                	li	s3,0
 716:	6d02                	ld	s10,0(sp)
 718:	bd21                	j	530 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 71a:	008b8993          	addi	s3,s7,8
 71e:	000bb903          	ld	s2,0(s7)
 722:	00090f63          	beqz	s2,740 <vprintf+0x25a>
        for(; *s; s++)
 726:	00094583          	lbu	a1,0(s2)
 72a:	c195                	beqz	a1,74e <vprintf+0x268>
          putc(fd, *s);
 72c:	855a                	mv	a0,s6
 72e:	cf3ff0ef          	jal	420 <putc>
        for(; *s; s++)
 732:	0905                	addi	s2,s2,1
 734:	00094583          	lbu	a1,0(s2)
 738:	f9f5                	bnez	a1,72c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bbcd                	j	530 <vprintf+0x4a>
          s = "(null)";
 740:	00000917          	auipc	s2,0x0
 744:	26890913          	addi	s2,s2,616 # 9a8 <malloc+0x15c>
        for(; *s; s++)
 748:	02800593          	li	a1,40
 74c:	b7c5                	j	72c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 74e:	8bce                	mv	s7,s3
      state = 0;
 750:	4981                	li	s3,0
 752:	bbf9                	j	530 <vprintf+0x4a>
 754:	64a6                	ld	s1,72(sp)
 756:	79e2                	ld	s3,56(sp)
 758:	7a42                	ld	s4,48(sp)
 75a:	7aa2                	ld	s5,40(sp)
 75c:	7b02                	ld	s6,32(sp)
 75e:	6be2                	ld	s7,24(sp)
 760:	6c42                	ld	s8,16(sp)
 762:	6ca2                	ld	s9,8(sp)
    }
  }
}
 764:	60e6                	ld	ra,88(sp)
 766:	6446                	ld	s0,80(sp)
 768:	6906                	ld	s2,64(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76e:	715d                	addi	sp,sp,-80
 770:	ec06                	sd	ra,24(sp)
 772:	e822                	sd	s0,16(sp)
 774:	1000                	addi	s0,sp,32
 776:	e010                	sd	a2,0(s0)
 778:	e414                	sd	a3,8(s0)
 77a:	e818                	sd	a4,16(s0)
 77c:	ec1c                	sd	a5,24(s0)
 77e:	03043023          	sd	a6,32(s0)
 782:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 786:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78a:	8622                	mv	a2,s0
 78c:	d5bff0ef          	jal	4e6 <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6161                	addi	sp,sp,80
 796:	8082                	ret

0000000000000798 <printf>:

void
printf(const char *fmt, ...)
{
 798:	711d                	addi	sp,sp,-96
 79a:	ec06                	sd	ra,24(sp)
 79c:	e822                	sd	s0,16(sp)
 79e:	1000                	addi	s0,sp,32
 7a0:	e40c                	sd	a1,8(s0)
 7a2:	e810                	sd	a2,16(s0)
 7a4:	ec14                	sd	a3,24(s0)
 7a6:	f018                	sd	a4,32(s0)
 7a8:	f41c                	sd	a5,40(s0)
 7aa:	03043823          	sd	a6,48(s0)
 7ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	00840613          	addi	a2,s0,8
 7b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ba:	85aa                	mv	a1,a0
 7bc:	4505                	li	a0,1
 7be:	d29ff0ef          	jal	4e6 <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret

00000000000007ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ca:	1141                	addi	sp,sp,-16
 7cc:	e422                	sd	s0,8(sp)
 7ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	00001797          	auipc	a5,0x1
 7d8:	82c7b783          	ld	a5,-2004(a5) # 1000 <freep>
 7dc:	a02d                	j	806 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7de:	4618                	lw	a4,8(a2)
 7e0:	9f2d                	addw	a4,a4,a1
 7e2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	6398                	ld	a4,0(a5)
 7e8:	6310                	ld	a2,0(a4)
 7ea:	a83d                	j	828 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ec:	ff852703          	lw	a4,-8(a0)
 7f0:	9f31                	addw	a4,a4,a2
 7f2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f4:	ff053683          	ld	a3,-16(a0)
 7f8:	a091                	j	83c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e7e463          	bltu	a5,a4,804 <free+0x3a>
 800:	00e6ea63          	bltu	a3,a4,814 <free+0x4a>
{
 804:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 806:	fed7fae3          	bgeu	a5,a3,7fa <free+0x30>
 80a:	6398                	ld	a4,0(a5)
 80c:	00e6e463          	bltu	a3,a4,814 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	fee7eae3          	bltu	a5,a4,804 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 814:	ff852583          	lw	a1,-8(a0)
 818:	6390                	ld	a2,0(a5)
 81a:	02059813          	slli	a6,a1,0x20
 81e:	01c85713          	srli	a4,a6,0x1c
 822:	9736                	add	a4,a4,a3
 824:	fae60de3          	beq	a2,a4,7de <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 82c:	4790                	lw	a2,8(a5)
 82e:	02061593          	slli	a1,a2,0x20
 832:	01c5d713          	srli	a4,a1,0x1c
 836:	973e                	add	a4,a4,a5
 838:	fae68ae3          	beq	a3,a4,7ec <free+0x22>
    p->s.ptr = bp->s.ptr;
 83c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73123          	sd	a5,1986(a4) # 1000 <freep>
}
 846:	6422                	ld	s0,8(sp)
 848:	0141                	addi	sp,sp,16
 84a:	8082                	ret

000000000000084c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 84c:	7139                	addi	sp,sp,-64
 84e:	fc06                	sd	ra,56(sp)
 850:	f822                	sd	s0,48(sp)
 852:	f426                	sd	s1,40(sp)
 854:	ec4e                	sd	s3,24(sp)
 856:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 858:	02051493          	slli	s1,a0,0x20
 85c:	9081                	srli	s1,s1,0x20
 85e:	04bd                	addi	s1,s1,15
 860:	8091                	srli	s1,s1,0x4
 862:	0014899b          	addiw	s3,s1,1
 866:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 868:	00000517          	auipc	a0,0x0
 86c:	79853503          	ld	a0,1944(a0) # 1000 <freep>
 870:	c915                	beqz	a0,8a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 874:	4798                	lw	a4,8(a5)
 876:	08977a63          	bgeu	a4,s1,90a <malloc+0xbe>
 87a:	f04a                	sd	s2,32(sp)
 87c:	e852                	sd	s4,16(sp)
 87e:	e456                	sd	s5,8(sp)
 880:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 882:	8a4e                	mv	s4,s3
 884:	0009871b          	sext.w	a4,s3
 888:	6685                	lui	a3,0x1
 88a:	00d77363          	bgeu	a4,a3,890 <malloc+0x44>
 88e:	6a05                	lui	s4,0x1
 890:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 894:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 898:	00000917          	auipc	s2,0x0
 89c:	76890913          	addi	s2,s2,1896 # 1000 <freep>
  if(p == (char*)-1)
 8a0:	5afd                	li	s5,-1
 8a2:	a081                	j	8e2 <malloc+0x96>
 8a4:	f04a                	sd	s2,32(sp)
 8a6:	e852                	sd	s4,16(sp)
 8a8:	e456                	sd	s5,8(sp)
 8aa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ac:	00000797          	auipc	a5,0x0
 8b0:	76478793          	addi	a5,a5,1892 # 1010 <base>
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74f73623          	sd	a5,1868(a4) # 1000 <freep>
 8bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c2:	b7c1                	j	882 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8c4:	6398                	ld	a4,0(a5)
 8c6:	e118                	sd	a4,0(a0)
 8c8:	a8a9                	j	922 <malloc+0xd6>
  hp->s.size = nu;
 8ca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ce:	0541                	addi	a0,a0,16
 8d0:	efbff0ef          	jal	7ca <free>
  return freep;
 8d4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d8:	c12d                	beqz	a0,93a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8dc:	4798                	lw	a4,8(a5)
 8de:	02977263          	bgeu	a4,s1,902 <malloc+0xb6>
    if(p == freep)
 8e2:	00093703          	ld	a4,0(s2)
 8e6:	853e                	mv	a0,a5
 8e8:	fef719e3          	bne	a4,a5,8da <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8ec:	8552                	mv	a0,s4
 8ee:	af3ff0ef          	jal	3e0 <sbrk>
  if(p == (char*)-1)
 8f2:	fd551ce3          	bne	a0,s5,8ca <malloc+0x7e>
        return 0;
 8f6:	4501                	li	a0,0
 8f8:	7902                	ld	s2,32(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
 900:	a03d                	j	92e <malloc+0xe2>
 902:	7902                	ld	s2,32(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 90a:	fae48de3          	beq	s1,a4,8c4 <malloc+0x78>
        p->s.size -= nunits;
 90e:	4137073b          	subw	a4,a4,s3
 912:	c798                	sw	a4,8(a5)
        p += p->s.size;
 914:	02071693          	slli	a3,a4,0x20
 918:	01c6d713          	srli	a4,a3,0x1c
 91c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 922:	00000717          	auipc	a4,0x0
 926:	6ca73f23          	sd	a0,1758(a4) # 1000 <freep>
      return (void*)(p + 1);
 92a:	01078513          	addi	a0,a5,16
  }
}
 92e:	70e2                	ld	ra,56(sp)
 930:	7442                	ld	s0,48(sp)
 932:	74a2                	ld	s1,40(sp)
 934:	69e2                	ld	s3,24(sp)
 936:	6121                	addi	sp,sp,64
 938:	8082                	ret
 93a:	7902                	ld	s2,32(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	b7f5                	j	92e <malloc+0xe2>
