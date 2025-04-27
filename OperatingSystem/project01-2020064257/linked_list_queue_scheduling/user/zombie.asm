
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	278000ef          	jal	280 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	276000ef          	jal	288 <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	300000ef          	jal	318 <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	25c000ef          	jal	288 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	86be                	mv	a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	ff65                	bnez	a4,88 <strlen+0x10>
  92:	40a6853b          	subw	a0,a3,a0
  96:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	186000ef          	jal	2a0 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
    buf[i++] = c;
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	162000ef          	jal	2c8 <open>
  if(fd < 0)
 16a:	02054263          	bltz	a0,18e <stat+0x36>
 16e:	e426                	sd	s1,8(sp)
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	16c000ef          	jal	2e0 <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	134000ef          	jal	2b0 <close>
  return r;
 180:	64a2                	ld	s1,8(sp)
}
 182:	854a                	mv	a0,s2
 184:	60e2                	ld	ra,24(sp)
 186:	6442                	ld	s0,16(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfcd                	j	182 <stat+0x2a>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addiw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	addi	a4,a4,1
 1b0:	0025179b          	slliw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	slliw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	slli	a2,a2,0x20
 1ea:	9201                	srli	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	addi	a1,a1,1
 1f4:	0705                	addi	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fef71ae3          	bne	a4,a5,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addiw	a5,a2,-1
 216:	1782                	slli	a5,a5,0x20
 218:	9381                	srli	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	addi	a1,a1,-1
 222:	177d                	addi	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addiw	a3,a2,-1
 23e:	1682                	slli	a3,a3,0x20
 240:	9281                	srli	a3,a3,0x20
 242:	0685                	addi	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	addi	a0,a0,1
    p2++;
 254:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 274:	f67ff0ef          	jal	1da <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 280:	4885                	li	a7,1
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <exit>:
.global exit
exit:
 li a7, SYS_exit
 288:	4889                	li	a7,2
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <wait>:
.global wait
wait:
 li a7, SYS_wait
 290:	488d                	li	a7,3
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 298:	4891                	li	a7,4
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <read>:
.global read
read:
 li a7, SYS_read
 2a0:	4895                	li	a7,5
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <write>:
.global write
write:
 li a7, SYS_write
 2a8:	48c1                	li	a7,16
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <close>:
.global close
close:
 li a7, SYS_close
 2b0:	48d5                	li	a7,21
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b8:	4899                	li	a7,6
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c0:	489d                	li	a7,7
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <open>:
.global open
open:
 li a7, SYS_open
 2c8:	48bd                	li	a7,15
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d0:	48c5                	li	a7,17
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d8:	48c9                	li	a7,18
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e0:	48a1                	li	a7,8
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <link>:
.global link
link:
 li a7, SYS_link
 2e8:	48cd                	li	a7,19
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f0:	48d1                	li	a7,20
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f8:	48a5                	li	a7,9
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <dup>:
.global dup
dup:
 li a7, SYS_dup
 300:	48a9                	li	a7,10
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 308:	48ad                	li	a7,11
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 310:	48b1                	li	a7,12
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 318:	48b5                	li	a7,13
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 320:	48b9                	li	a7,14
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <yield>:
.global yield
yield:
 li a7, SYS_yield
 328:	48d9                	li	a7,22
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 330:	48dd                	li	a7,23
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 338:	48e1                	li	a7,24
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 340:	48e5                	li	a7,25
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 348:	48e9                	li	a7,26
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 350:	1101                	addi	sp,sp,-32
 352:	ec06                	sd	ra,24(sp)
 354:	e822                	sd	s0,16(sp)
 356:	1000                	addi	s0,sp,32
 358:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35c:	4605                	li	a2,1
 35e:	fef40593          	addi	a1,s0,-17
 362:	f47ff0ef          	jal	2a8 <write>
}
 366:	60e2                	ld	ra,24(sp)
 368:	6442                	ld	s0,16(sp)
 36a:	6105                	addi	sp,sp,32
 36c:	8082                	ret

000000000000036e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36e:	7139                	addi	sp,sp,-64
 370:	fc06                	sd	ra,56(sp)
 372:	f822                	sd	s0,48(sp)
 374:	f426                	sd	s1,40(sp)
 376:	0080                	addi	s0,sp,64
 378:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37a:	c299                	beqz	a3,380 <printint+0x12>
 37c:	0805c963          	bltz	a1,40e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 380:	2581                	sext.w	a1,a1
  neg = 0;
 382:	4881                	li	a7,0
 384:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 388:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 38a:	2601                	sext.w	a2,a2
 38c:	00000517          	auipc	a0,0x0
 390:	4fc50513          	addi	a0,a0,1276 # 888 <digits>
 394:	883a                	mv	a6,a4
 396:	2705                	addiw	a4,a4,1
 398:	02c5f7bb          	remuw	a5,a1,a2
 39c:	1782                	slli	a5,a5,0x20
 39e:	9381                	srli	a5,a5,0x20
 3a0:	97aa                	add	a5,a5,a0
 3a2:	0007c783          	lbu	a5,0(a5)
 3a6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3aa:	0005879b          	sext.w	a5,a1
 3ae:	02c5d5bb          	divuw	a1,a1,a2
 3b2:	0685                	addi	a3,a3,1
 3b4:	fec7f0e3          	bgeu	a5,a2,394 <printint+0x26>
  if(neg)
 3b8:	00088c63          	beqz	a7,3d0 <printint+0x62>
    buf[i++] = '-';
 3bc:	fd070793          	addi	a5,a4,-48
 3c0:	00878733          	add	a4,a5,s0
 3c4:	02d00793          	li	a5,45
 3c8:	fef70823          	sb	a5,-16(a4)
 3cc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3d0:	02e05a63          	blez	a4,404 <printint+0x96>
 3d4:	f04a                	sd	s2,32(sp)
 3d6:	ec4e                	sd	s3,24(sp)
 3d8:	fc040793          	addi	a5,s0,-64
 3dc:	00e78933          	add	s2,a5,a4
 3e0:	fff78993          	addi	s3,a5,-1
 3e4:	99ba                	add	s3,s3,a4
 3e6:	377d                	addiw	a4,a4,-1
 3e8:	1702                	slli	a4,a4,0x20
 3ea:	9301                	srli	a4,a4,0x20
 3ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f0:	fff94583          	lbu	a1,-1(s2)
 3f4:	8526                	mv	a0,s1
 3f6:	f5bff0ef          	jal	350 <putc>
  while(--i >= 0)
 3fa:	197d                	addi	s2,s2,-1
 3fc:	ff391ae3          	bne	s2,s3,3f0 <printint+0x82>
 400:	7902                	ld	s2,32(sp)
 402:	69e2                	ld	s3,24(sp)
}
 404:	70e2                	ld	ra,56(sp)
 406:	7442                	ld	s0,48(sp)
 408:	74a2                	ld	s1,40(sp)
 40a:	6121                	addi	sp,sp,64
 40c:	8082                	ret
    x = -xx;
 40e:	40b005bb          	negw	a1,a1
    neg = 1;
 412:	4885                	li	a7,1
    x = -xx;
 414:	bf85                	j	384 <printint+0x16>

0000000000000416 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 416:	711d                	addi	sp,sp,-96
 418:	ec86                	sd	ra,88(sp)
 41a:	e8a2                	sd	s0,80(sp)
 41c:	e0ca                	sd	s2,64(sp)
 41e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 420:	0005c903          	lbu	s2,0(a1)
 424:	26090863          	beqz	s2,694 <vprintf+0x27e>
 428:	e4a6                	sd	s1,72(sp)
 42a:	fc4e                	sd	s3,56(sp)
 42c:	f852                	sd	s4,48(sp)
 42e:	f456                	sd	s5,40(sp)
 430:	f05a                	sd	s6,32(sp)
 432:	ec5e                	sd	s7,24(sp)
 434:	e862                	sd	s8,16(sp)
 436:	e466                	sd	s9,8(sp)
 438:	8b2a                	mv	s6,a0
 43a:	8a2e                	mv	s4,a1
 43c:	8bb2                	mv	s7,a2
  state = 0;
 43e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 440:	4481                	li	s1,0
 442:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 444:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 448:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 44c:	06c00c93          	li	s9,108
 450:	a005                	j	470 <vprintf+0x5a>
        putc(fd, c0);
 452:	85ca                	mv	a1,s2
 454:	855a                	mv	a0,s6
 456:	efbff0ef          	jal	350 <putc>
 45a:	a019                	j	460 <vprintf+0x4a>
    } else if(state == '%'){
 45c:	03598263          	beq	s3,s5,480 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 460:	2485                	addiw	s1,s1,1
 462:	8726                	mv	a4,s1
 464:	009a07b3          	add	a5,s4,s1
 468:	0007c903          	lbu	s2,0(a5)
 46c:	20090c63          	beqz	s2,684 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 470:	0009079b          	sext.w	a5,s2
    if(state == 0){
 474:	fe0994e3          	bnez	s3,45c <vprintf+0x46>
      if(c0 == '%'){
 478:	fd579de3          	bne	a5,s5,452 <vprintf+0x3c>
        state = '%';
 47c:	89be                	mv	s3,a5
 47e:	b7cd                	j	460 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 480:	00ea06b3          	add	a3,s4,a4
 484:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 488:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 48a:	c681                	beqz	a3,492 <vprintf+0x7c>
 48c:	9752                	add	a4,a4,s4
 48e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 492:	03878f63          	beq	a5,s8,4d0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 496:	05978963          	beq	a5,s9,4e8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 49a:	07500713          	li	a4,117
 49e:	0ee78363          	beq	a5,a4,584 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4a2:	07800713          	li	a4,120
 4a6:	12e78563          	beq	a5,a4,5d0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4aa:	07000713          	li	a4,112
 4ae:	14e78a63          	beq	a5,a4,602 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4b2:	07300713          	li	a4,115
 4b6:	18e78a63          	beq	a5,a4,64a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4ba:	02500713          	li	a4,37
 4be:	04e79563          	bne	a5,a4,508 <vprintf+0xf2>
        putc(fd, '%');
 4c2:	02500593          	li	a1,37
 4c6:	855a                	mv	a0,s6
 4c8:	e89ff0ef          	jal	350 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4cc:	4981                	li	s3,0
 4ce:	bf49                	j	460 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4d0:	008b8913          	addi	s2,s7,8
 4d4:	4685                	li	a3,1
 4d6:	4629                	li	a2,10
 4d8:	000ba583          	lw	a1,0(s7)
 4dc:	855a                	mv	a0,s6
 4de:	e91ff0ef          	jal	36e <printint>
 4e2:	8bca                	mv	s7,s2
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	bfad                	j	460 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4e8:	06400793          	li	a5,100
 4ec:	02f68963          	beq	a3,a5,51e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4f0:	06c00793          	li	a5,108
 4f4:	04f68263          	beq	a3,a5,538 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4f8:	07500793          	li	a5,117
 4fc:	0af68063          	beq	a3,a5,59c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 500:	07800793          	li	a5,120
 504:	0ef68263          	beq	a3,a5,5e8 <vprintf+0x1d2>
        putc(fd, '%');
 508:	02500593          	li	a1,37
 50c:	855a                	mv	a0,s6
 50e:	e43ff0ef          	jal	350 <putc>
        putc(fd, c0);
 512:	85ca                	mv	a1,s2
 514:	855a                	mv	a0,s6
 516:	e3bff0ef          	jal	350 <putc>
      state = 0;
 51a:	4981                	li	s3,0
 51c:	b791                	j	460 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 51e:	008b8913          	addi	s2,s7,8
 522:	4685                	li	a3,1
 524:	4629                	li	a2,10
 526:	000ba583          	lw	a1,0(s7)
 52a:	855a                	mv	a0,s6
 52c:	e43ff0ef          	jal	36e <printint>
        i += 1;
 530:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 532:	8bca                	mv	s7,s2
      state = 0;
 534:	4981                	li	s3,0
        i += 1;
 536:	b72d                	j	460 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 538:	06400793          	li	a5,100
 53c:	02f60763          	beq	a2,a5,56a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 540:	07500793          	li	a5,117
 544:	06f60963          	beq	a2,a5,5b6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 548:	07800793          	li	a5,120
 54c:	faf61ee3          	bne	a2,a5,508 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 550:	008b8913          	addi	s2,s7,8
 554:	4681                	li	a3,0
 556:	4641                	li	a2,16
 558:	000ba583          	lw	a1,0(s7)
 55c:	855a                	mv	a0,s6
 55e:	e11ff0ef          	jal	36e <printint>
        i += 2;
 562:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 564:	8bca                	mv	s7,s2
      state = 0;
 566:	4981                	li	s3,0
        i += 2;
 568:	bde5                	j	460 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000ba583          	lw	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	df7ff0ef          	jal	36e <printint>
        i += 2;
 57c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
        i += 2;
 582:	bdf9                	j	460 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 584:	008b8913          	addi	s2,s7,8
 588:	4681                	li	a3,0
 58a:	4629                	li	a2,10
 58c:	000ba583          	lw	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	dddff0ef          	jal	36e <printint>
 596:	8bca                	mv	s7,s2
      state = 0;
 598:	4981                	li	s3,0
 59a:	b5d9                	j	460 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4629                	li	a2,10
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	dc5ff0ef          	jal	36e <printint>
        i += 1;
 5ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
        i += 1;
 5b4:	b575                	j	460 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	dabff0ef          	jal	36e <printint>
        i += 2;
 5c8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 2;
 5ce:	bd49                	j	460 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4641                	li	a2,16
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	d91ff0ef          	jal	36e <printint>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bdad                	j	460 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4641                	li	a2,16
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	d79ff0ef          	jal	36e <printint>
        i += 1;
 5fa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
        i += 1;
 600:	b585                	j	460 <vprintf+0x4a>
 602:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 604:	008b8d13          	addi	s10,s7,8
 608:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60c:	03000593          	li	a1,48
 610:	855a                	mv	a0,s6
 612:	d3fff0ef          	jal	350 <putc>
  putc(fd, 'x');
 616:	07800593          	li	a1,120
 61a:	855a                	mv	a0,s6
 61c:	d35ff0ef          	jal	350 <putc>
 620:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 622:	00000b97          	auipc	s7,0x0
 626:	266b8b93          	addi	s7,s7,614 # 888 <digits>
 62a:	03c9d793          	srli	a5,s3,0x3c
 62e:	97de                	add	a5,a5,s7
 630:	0007c583          	lbu	a1,0(a5)
 634:	855a                	mv	a0,s6
 636:	d1bff0ef          	jal	350 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63a:	0992                	slli	s3,s3,0x4
 63c:	397d                	addiw	s2,s2,-1
 63e:	fe0916e3          	bnez	s2,62a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 642:	8bea                	mv	s7,s10
      state = 0;
 644:	4981                	li	s3,0
 646:	6d02                	ld	s10,0(sp)
 648:	bd21                	j	460 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 64a:	008b8993          	addi	s3,s7,8
 64e:	000bb903          	ld	s2,0(s7)
 652:	00090f63          	beqz	s2,670 <vprintf+0x25a>
        for(; *s; s++)
 656:	00094583          	lbu	a1,0(s2)
 65a:	c195                	beqz	a1,67e <vprintf+0x268>
          putc(fd, *s);
 65c:	855a                	mv	a0,s6
 65e:	cf3ff0ef          	jal	350 <putc>
        for(; *s; s++)
 662:	0905                	addi	s2,s2,1
 664:	00094583          	lbu	a1,0(s2)
 668:	f9f5                	bnez	a1,65c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 66a:	8bce                	mv	s7,s3
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bbcd                	j	460 <vprintf+0x4a>
          s = "(null)";
 670:	00000917          	auipc	s2,0x0
 674:	21090913          	addi	s2,s2,528 # 880 <malloc+0x104>
        for(; *s; s++)
 678:	02800593          	li	a1,40
 67c:	b7c5                	j	65c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 67e:	8bce                	mv	s7,s3
      state = 0;
 680:	4981                	li	s3,0
 682:	bbf9                	j	460 <vprintf+0x4a>
 684:	64a6                	ld	s1,72(sp)
 686:	79e2                	ld	s3,56(sp)
 688:	7a42                	ld	s4,48(sp)
 68a:	7aa2                	ld	s5,40(sp)
 68c:	7b02                	ld	s6,32(sp)
 68e:	6be2                	ld	s7,24(sp)
 690:	6c42                	ld	s8,16(sp)
 692:	6ca2                	ld	s9,8(sp)
    }
  }
}
 694:	60e6                	ld	ra,88(sp)
 696:	6446                	ld	s0,80(sp)
 698:	6906                	ld	s2,64(sp)
 69a:	6125                	addi	sp,sp,96
 69c:	8082                	ret

000000000000069e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 69e:	715d                	addi	sp,sp,-80
 6a0:	ec06                	sd	ra,24(sp)
 6a2:	e822                	sd	s0,16(sp)
 6a4:	1000                	addi	s0,sp,32
 6a6:	e010                	sd	a2,0(s0)
 6a8:	e414                	sd	a3,8(s0)
 6aa:	e818                	sd	a4,16(s0)
 6ac:	ec1c                	sd	a5,24(s0)
 6ae:	03043023          	sd	a6,32(s0)
 6b2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ba:	8622                	mv	a2,s0
 6bc:	d5bff0ef          	jal	416 <vprintf>
}
 6c0:	60e2                	ld	ra,24(sp)
 6c2:	6442                	ld	s0,16(sp)
 6c4:	6161                	addi	sp,sp,80
 6c6:	8082                	ret

00000000000006c8 <printf>:

void
printf(const char *fmt, ...)
{
 6c8:	711d                	addi	sp,sp,-96
 6ca:	ec06                	sd	ra,24(sp)
 6cc:	e822                	sd	s0,16(sp)
 6ce:	1000                	addi	s0,sp,32
 6d0:	e40c                	sd	a1,8(s0)
 6d2:	e810                	sd	a2,16(s0)
 6d4:	ec14                	sd	a3,24(s0)
 6d6:	f018                	sd	a4,32(s0)
 6d8:	f41c                	sd	a5,40(s0)
 6da:	03043823          	sd	a6,48(s0)
 6de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e2:	00840613          	addi	a2,s0,8
 6e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ea:	85aa                	mv	a1,a0
 6ec:	4505                	li	a0,1
 6ee:	d29ff0ef          	jal	416 <vprintf>
}
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6125                	addi	sp,sp,96
 6f8:	8082                	ret

00000000000006fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fa:	1141                	addi	sp,sp,-16
 6fc:	e422                	sd	s0,8(sp)
 6fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 700:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 704:	00001797          	auipc	a5,0x1
 708:	8fc7b783          	ld	a5,-1796(a5) # 1000 <freep>
 70c:	a02d                	j	736 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70e:	4618                	lw	a4,8(a2)
 710:	9f2d                	addw	a4,a4,a1
 712:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	6398                	ld	a4,0(a5)
 718:	6310                	ld	a2,0(a4)
 71a:	a83d                	j	758 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71c:	ff852703          	lw	a4,-8(a0)
 720:	9f31                	addw	a4,a4,a2
 722:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 724:	ff053683          	ld	a3,-16(a0)
 728:	a091                	j	76c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	6398                	ld	a4,0(a5)
 72c:	00e7e463          	bltu	a5,a4,734 <free+0x3a>
 730:	00e6ea63          	bltu	a3,a4,744 <free+0x4a>
{
 734:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	fed7fae3          	bgeu	a5,a3,72a <free+0x30>
 73a:	6398                	ld	a4,0(a5)
 73c:	00e6e463          	bltu	a3,a4,744 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	fee7eae3          	bltu	a5,a4,734 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 744:	ff852583          	lw	a1,-8(a0)
 748:	6390                	ld	a2,0(a5)
 74a:	02059813          	slli	a6,a1,0x20
 74e:	01c85713          	srli	a4,a6,0x1c
 752:	9736                	add	a4,a4,a3
 754:	fae60de3          	beq	a2,a4,70e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75c:	4790                	lw	a2,8(a5)
 75e:	02061593          	slli	a1,a2,0x20
 762:	01c5d713          	srli	a4,a1,0x1c
 766:	973e                	add	a4,a4,a5
 768:	fae68ae3          	beq	a3,a4,71c <free+0x22>
    p->s.ptr = bp->s.ptr;
 76c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 76e:	00001717          	auipc	a4,0x1
 772:	88f73923          	sd	a5,-1902(a4) # 1000 <freep>
}
 776:	6422                	ld	s0,8(sp)
 778:	0141                	addi	sp,sp,16
 77a:	8082                	ret

000000000000077c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77c:	7139                	addi	sp,sp,-64
 77e:	fc06                	sd	ra,56(sp)
 780:	f822                	sd	s0,48(sp)
 782:	f426                	sd	s1,40(sp)
 784:	ec4e                	sd	s3,24(sp)
 786:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 788:	02051493          	slli	s1,a0,0x20
 78c:	9081                	srli	s1,s1,0x20
 78e:	04bd                	addi	s1,s1,15
 790:	8091                	srli	s1,s1,0x4
 792:	0014899b          	addiw	s3,s1,1
 796:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 798:	00001517          	auipc	a0,0x1
 79c:	86853503          	ld	a0,-1944(a0) # 1000 <freep>
 7a0:	c915                	beqz	a0,7d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a4:	4798                	lw	a4,8(a5)
 7a6:	08977a63          	bgeu	a4,s1,83a <malloc+0xbe>
 7aa:	f04a                	sd	s2,32(sp)
 7ac:	e852                	sd	s4,16(sp)
 7ae:	e456                	sd	s5,8(sp)
 7b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b2:	8a4e                	mv	s4,s3
 7b4:	0009871b          	sext.w	a4,s3
 7b8:	6685                	lui	a3,0x1
 7ba:	00d77363          	bgeu	a4,a3,7c0 <malloc+0x44>
 7be:	6a05                	lui	s4,0x1
 7c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c8:	00001917          	auipc	s2,0x1
 7cc:	83890913          	addi	s2,s2,-1992 # 1000 <freep>
  if(p == (char*)-1)
 7d0:	5afd                	li	s5,-1
 7d2:	a081                	j	812 <malloc+0x96>
 7d4:	f04a                	sd	s2,32(sp)
 7d6:	e852                	sd	s4,16(sp)
 7d8:	e456                	sd	s5,8(sp)
 7da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7dc:	00001797          	auipc	a5,0x1
 7e0:	83478793          	addi	a5,a5,-1996 # 1010 <base>
 7e4:	00001717          	auipc	a4,0x1
 7e8:	80f73e23          	sd	a5,-2020(a4) # 1000 <freep>
 7ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f2:	b7c1                	j	7b2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	e118                	sd	a4,0(a0)
 7f8:	a8a9                	j	852 <malloc+0xd6>
  hp->s.size = nu;
 7fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fe:	0541                	addi	a0,a0,16
 800:	efbff0ef          	jal	6fa <free>
  return freep;
 804:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 808:	c12d                	beqz	a0,86a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	02977263          	bgeu	a4,s1,832 <malloc+0xb6>
    if(p == freep)
 812:	00093703          	ld	a4,0(s2)
 816:	853e                	mv	a0,a5
 818:	fef719e3          	bne	a4,a5,80a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 81c:	8552                	mv	a0,s4
 81e:	af3ff0ef          	jal	310 <sbrk>
  if(p == (char*)-1)
 822:	fd551ce3          	bne	a0,s5,7fa <malloc+0x7e>
        return 0;
 826:	4501                	li	a0,0
 828:	7902                	ld	s2,32(sp)
 82a:	6a42                	ld	s4,16(sp)
 82c:	6aa2                	ld	s5,8(sp)
 82e:	6b02                	ld	s6,0(sp)
 830:	a03d                	j	85e <malloc+0xe2>
 832:	7902                	ld	s2,32(sp)
 834:	6a42                	ld	s4,16(sp)
 836:	6aa2                	ld	s5,8(sp)
 838:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83a:	fae48de3          	beq	s1,a4,7f4 <malloc+0x78>
        p->s.size -= nunits;
 83e:	4137073b          	subw	a4,a4,s3
 842:	c798                	sw	a4,8(a5)
        p += p->s.size;
 844:	02071693          	slli	a3,a4,0x20
 848:	01c6d713          	srli	a4,a3,0x1c
 84c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 852:	00000717          	auipc	a4,0x0
 856:	7aa73723          	sd	a0,1966(a4) # 1000 <freep>
      return (void*)(p + 1);
 85a:	01078513          	addi	a0,a5,16
  }
}
 85e:	70e2                	ld	ra,56(sp)
 860:	7442                	ld	s0,48(sp)
 862:	74a2                	ld	s1,40(sp)
 864:	69e2                	ld	s3,24(sp)
 866:	6121                	addi	sp,sp,64
 868:	8082                	ret
 86a:	7902                	ld	s2,32(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
 872:	b7f5                	j	85e <malloc+0xe2>
