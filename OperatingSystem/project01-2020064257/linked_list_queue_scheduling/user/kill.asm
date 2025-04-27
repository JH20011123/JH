
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1a0000ef          	jal	1c8 <atoi>
  2c:	2c2000ef          	jal	2ee <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	286000ef          	jal	2be <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	87058593          	addi	a1,a1,-1936 # 8b0 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	68a000ef          	jal	6d4 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	26e000ef          	jal	2be <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5c:	fa5ff0ef          	jal	0 <main>
  exit(0);
  60:	4501                	li	a0,0
  62:	25c000ef          	jal	2be <exit>

0000000000000066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  66:	1141                	addi	sp,sp,-16
  68:	e422                	sd	s0,8(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0x8>
    ;
  return os;
}
  7c:	6422                	ld	s0,8(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret

0000000000000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x1e>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x1e>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cf91                	beqz	a5,d4 <strlen+0x26>
  ba:	0505                	addi	a0,a0,1
  bc:	87aa                	mv	a5,a0
  be:	86be                	mv	a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	ff65                	bnez	a4,be <strlen+0x10>
  c8:	40a6853b          	subw	a0,a3,a0
  cc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret
  for(n = 0; s[n]; n++)
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strlen+0x20>

00000000000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  de:	ca19                	beqz	a2,f4 <memset+0x1c>
  e0:	87aa                	mv	a5,a0
  e2:	1602                	slli	a2,a2,0x20
  e4:	9201                	srli	a2,a2,0x20
  e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x12>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d663          	bge	s1,s4,170 <gets+0x52>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	186000ef          	jal	2d6 <read>
    if(cc < 1)
 154:	00a05e63          	blez	a0,170 <gets+0x52>
    buf[i++] = c;
 158:	faf44783          	lbu	a5,-81(s0)
 15c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 160:	01578763          	beq	a5,s5,16e <gets+0x50>
 164:	0905                	addi	s2,s2,1
 166:	fd679de3          	bne	a5,s6,140 <gets+0x22>
    buf[i++] = c;
 16a:	89a6                	mv	s3,s1
 16c:	a011                	j	170 <gets+0x52>
 16e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 170:	99de                	add	s3,s3,s7
 172:	00098023          	sb	zero,0(s3)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6125                	addi	sp,sp,96
 18c:	8082                	ret

000000000000018e <stat>:

int
stat(const char *n, struct stat *st)
{
 18e:	1101                	addi	sp,sp,-32
 190:	ec06                	sd	ra,24(sp)
 192:	e822                	sd	s0,16(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	162000ef          	jal	2fe <open>
  if(fd < 0)
 1a0:	02054263          	bltz	a0,1c4 <stat+0x36>
 1a4:	e426                	sd	s1,8(sp)
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	16c000ef          	jal	316 <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	134000ef          	jal	2e6 <close>
  return r;
 1b6:	64a2                	ld	s1,8(sp)
}
 1b8:	854a                	mv	a0,s2
 1ba:	60e2                	ld	ra,24(sp)
 1bc:	6442                	ld	s0,16(sp)
 1be:	6902                	ld	s2,0(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret
    return -1;
 1c4:	597d                	li	s2,-1
 1c6:	bfcd                	j	1b8 <stat+0x2a>

00000000000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054683          	lbu	a3,0(a0)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	4625                	li	a2,9
 1dc:	02f66863          	bltu	a2,a5,20c <atoi+0x44>
 1e0:	872a                	mv	a4,a0
  n = 0;
 1e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e4:	0705                	addi	a4,a4,1
 1e6:	0025179b          	slliw	a5,a0,0x2
 1ea:	9fa9                	addw	a5,a5,a0
 1ec:	0017979b          	slliw	a5,a5,0x1
 1f0:	9fb5                	addw	a5,a5,a3
 1f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f6:	00074683          	lbu	a3,0(a4)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	fef671e3          	bgeu	a2,a5,1e4 <atoi+0x1c>
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  n = 0;
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <atoi+0x3e>

0000000000000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 216:	02b57463          	bgeu	a0,a1,23e <memmove+0x2e>
    while(n-- > 0)
 21a:	00c05f63          	blez	a2,238 <memmove+0x28>
 21e:	1602                	slli	a2,a2,0x20
 220:	9201                	srli	a2,a2,0x20
 222:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 226:	872a                	mv	a4,a0
      *dst++ = *src++;
 228:	0585                	addi	a1,a1,1
 22a:	0705                	addi	a4,a4,1
 22c:	fff5c683          	lbu	a3,-1(a1)
 230:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 234:	fef71ae3          	bne	a4,a5,228 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    dst += n;
 23e:	00c50733          	add	a4,a0,a2
    src += n;
 242:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 244:	fec05ae3          	blez	a2,238 <memmove+0x28>
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 262:	fee79ae3          	bne	a5,a4,256 <memmove+0x46>
 266:	bfc9                	j	238 <memmove+0x28>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26e:	ca05                	beqz	a2,29e <memcmp+0x36>
 270:	fff6069b          	addiw	a3,a2,-1
 274:	1682                	slli	a3,a3,0x20
 276:	9281                	srli	a3,a3,0x20
 278:	0685                	addi	a3,a3,1
 27a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27c:	00054783          	lbu	a5,0(a0)
 280:	0005c703          	lbu	a4,0(a1)
 284:	00e79863          	bne	a5,a4,294 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 288:	0505                	addi	a0,a0,1
    p2++;
 28a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28c:	fed518e3          	bne	a0,a3,27c <memcmp+0x14>
  }
  return 0;
 290:	4501                	li	a0,0
 292:	a019                	j	298 <memcmp+0x30>
      return *p1 - *p2;
 294:	40e7853b          	subw	a0,a5,a4
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <memcmp+0x30>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	f67ff0ef          	jal	210 <memmove>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b6:	4885                	li	a7,1
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <exit>:
.global exit
exit:
 li a7, SYS_exit
 2be:	4889                	li	a7,2
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c6:	488d                	li	a7,3
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ce:	4891                	li	a7,4
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <read>:
.global read
read:
 li a7, SYS_read
 2d6:	4895                	li	a7,5
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <write>:
.global write
write:
 li a7, SYS_write
 2de:	48c1                	li	a7,16
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <close>:
.global close
close:
 li a7, SYS_close
 2e6:	48d5                	li	a7,21
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ee:	4899                	li	a7,6
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f6:	489d                	li	a7,7
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <open>:
.global open
open:
 li a7, SYS_open
 2fe:	48bd                	li	a7,15
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 306:	48c5                	li	a7,17
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30e:	48c9                	li	a7,18
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 316:	48a1                	li	a7,8
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <link>:
.global link
link:
 li a7, SYS_link
 31e:	48cd                	li	a7,19
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 326:	48d1                	li	a7,20
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32e:	48a5                	li	a7,9
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <dup>:
.global dup
dup:
 li a7, SYS_dup
 336:	48a9                	li	a7,10
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33e:	48ad                	li	a7,11
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 346:	48b1                	li	a7,12
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34e:	48b5                	li	a7,13
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 356:	48b9                	li	a7,14
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <yield>:
.global yield
yield:
 li a7, SYS_yield
 35e:	48d9                	li	a7,22
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 366:	48dd                	li	a7,23
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 36e:	48e1                	li	a7,24
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 376:	48e5                	li	a7,25
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 37e:	48e9                	li	a7,26
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 386:	1101                	addi	sp,sp,-32
 388:	ec06                	sd	ra,24(sp)
 38a:	e822                	sd	s0,16(sp)
 38c:	1000                	addi	s0,sp,32
 38e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 392:	4605                	li	a2,1
 394:	fef40593          	addi	a1,s0,-17
 398:	f47ff0ef          	jal	2de <write>
}
 39c:	60e2                	ld	ra,24(sp)
 39e:	6442                	ld	s0,16(sp)
 3a0:	6105                	addi	sp,sp,32
 3a2:	8082                	ret

00000000000003a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a4:	7139                	addi	sp,sp,-64
 3a6:	fc06                	sd	ra,56(sp)
 3a8:	f822                	sd	s0,48(sp)
 3aa:	f426                	sd	s1,40(sp)
 3ac:	0080                	addi	s0,sp,64
 3ae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b0:	c299                	beqz	a3,3b6 <printint+0x12>
 3b2:	0805c963          	bltz	a1,444 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b6:	2581                	sext.w	a1,a1
  neg = 0;
 3b8:	4881                	li	a7,0
 3ba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3be:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c0:	2601                	sext.w	a2,a2
 3c2:	00000517          	auipc	a0,0x0
 3c6:	50e50513          	addi	a0,a0,1294 # 8d0 <digits>
 3ca:	883a                	mv	a6,a4
 3cc:	2705                	addiw	a4,a4,1
 3ce:	02c5f7bb          	remuw	a5,a1,a2
 3d2:	1782                	slli	a5,a5,0x20
 3d4:	9381                	srli	a5,a5,0x20
 3d6:	97aa                	add	a5,a5,a0
 3d8:	0007c783          	lbu	a5,0(a5)
 3dc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e0:	0005879b          	sext.w	a5,a1
 3e4:	02c5d5bb          	divuw	a1,a1,a2
 3e8:	0685                	addi	a3,a3,1
 3ea:	fec7f0e3          	bgeu	a5,a2,3ca <printint+0x26>
  if(neg)
 3ee:	00088c63          	beqz	a7,406 <printint+0x62>
    buf[i++] = '-';
 3f2:	fd070793          	addi	a5,a4,-48
 3f6:	00878733          	add	a4,a5,s0
 3fa:	02d00793          	li	a5,45
 3fe:	fef70823          	sb	a5,-16(a4)
 402:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 406:	02e05a63          	blez	a4,43a <printint+0x96>
 40a:	f04a                	sd	s2,32(sp)
 40c:	ec4e                	sd	s3,24(sp)
 40e:	fc040793          	addi	a5,s0,-64
 412:	00e78933          	add	s2,a5,a4
 416:	fff78993          	addi	s3,a5,-1
 41a:	99ba                	add	s3,s3,a4
 41c:	377d                	addiw	a4,a4,-1
 41e:	1702                	slli	a4,a4,0x20
 420:	9301                	srli	a4,a4,0x20
 422:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 426:	fff94583          	lbu	a1,-1(s2)
 42a:	8526                	mv	a0,s1
 42c:	f5bff0ef          	jal	386 <putc>
  while(--i >= 0)
 430:	197d                	addi	s2,s2,-1
 432:	ff391ae3          	bne	s2,s3,426 <printint+0x82>
 436:	7902                	ld	s2,32(sp)
 438:	69e2                	ld	s3,24(sp)
}
 43a:	70e2                	ld	ra,56(sp)
 43c:	7442                	ld	s0,48(sp)
 43e:	74a2                	ld	s1,40(sp)
 440:	6121                	addi	sp,sp,64
 442:	8082                	ret
    x = -xx;
 444:	40b005bb          	negw	a1,a1
    neg = 1;
 448:	4885                	li	a7,1
    x = -xx;
 44a:	bf85                	j	3ba <printint+0x16>

000000000000044c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44c:	711d                	addi	sp,sp,-96
 44e:	ec86                	sd	ra,88(sp)
 450:	e8a2                	sd	s0,80(sp)
 452:	e0ca                	sd	s2,64(sp)
 454:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 456:	0005c903          	lbu	s2,0(a1)
 45a:	26090863          	beqz	s2,6ca <vprintf+0x27e>
 45e:	e4a6                	sd	s1,72(sp)
 460:	fc4e                	sd	s3,56(sp)
 462:	f852                	sd	s4,48(sp)
 464:	f456                	sd	s5,40(sp)
 466:	f05a                	sd	s6,32(sp)
 468:	ec5e                	sd	s7,24(sp)
 46a:	e862                	sd	s8,16(sp)
 46c:	e466                	sd	s9,8(sp)
 46e:	8b2a                	mv	s6,a0
 470:	8a2e                	mv	s4,a1
 472:	8bb2                	mv	s7,a2
  state = 0;
 474:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 476:	4481                	li	s1,0
 478:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 47a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 47e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 482:	06c00c93          	li	s9,108
 486:	a005                	j	4a6 <vprintf+0x5a>
        putc(fd, c0);
 488:	85ca                	mv	a1,s2
 48a:	855a                	mv	a0,s6
 48c:	efbff0ef          	jal	386 <putc>
 490:	a019                	j	496 <vprintf+0x4a>
    } else if(state == '%'){
 492:	03598263          	beq	s3,s5,4b6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 496:	2485                	addiw	s1,s1,1
 498:	8726                	mv	a4,s1
 49a:	009a07b3          	add	a5,s4,s1
 49e:	0007c903          	lbu	s2,0(a5)
 4a2:	20090c63          	beqz	s2,6ba <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4a6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4aa:	fe0994e3          	bnez	s3,492 <vprintf+0x46>
      if(c0 == '%'){
 4ae:	fd579de3          	bne	a5,s5,488 <vprintf+0x3c>
        state = '%';
 4b2:	89be                	mv	s3,a5
 4b4:	b7cd                	j	496 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4b6:	00ea06b3          	add	a3,s4,a4
 4ba:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4be:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4c0:	c681                	beqz	a3,4c8 <vprintf+0x7c>
 4c2:	9752                	add	a4,a4,s4
 4c4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4c8:	03878f63          	beq	a5,s8,506 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4cc:	05978963          	beq	a5,s9,51e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4d0:	07500713          	li	a4,117
 4d4:	0ee78363          	beq	a5,a4,5ba <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4d8:	07800713          	li	a4,120
 4dc:	12e78563          	beq	a5,a4,606 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4e0:	07000713          	li	a4,112
 4e4:	14e78a63          	beq	a5,a4,638 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4e8:	07300713          	li	a4,115
 4ec:	18e78a63          	beq	a5,a4,680 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4f0:	02500713          	li	a4,37
 4f4:	04e79563          	bne	a5,a4,53e <vprintf+0xf2>
        putc(fd, '%');
 4f8:	02500593          	li	a1,37
 4fc:	855a                	mv	a0,s6
 4fe:	e89ff0ef          	jal	386 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 502:	4981                	li	s3,0
 504:	bf49                	j	496 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 506:	008b8913          	addi	s2,s7,8
 50a:	4685                	li	a3,1
 50c:	4629                	li	a2,10
 50e:	000ba583          	lw	a1,0(s7)
 512:	855a                	mv	a0,s6
 514:	e91ff0ef          	jal	3a4 <printint>
 518:	8bca                	mv	s7,s2
      state = 0;
 51a:	4981                	li	s3,0
 51c:	bfad                	j	496 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 51e:	06400793          	li	a5,100
 522:	02f68963          	beq	a3,a5,554 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 526:	06c00793          	li	a5,108
 52a:	04f68263          	beq	a3,a5,56e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 52e:	07500793          	li	a5,117
 532:	0af68063          	beq	a3,a5,5d2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 536:	07800793          	li	a5,120
 53a:	0ef68263          	beq	a3,a5,61e <vprintf+0x1d2>
        putc(fd, '%');
 53e:	02500593          	li	a1,37
 542:	855a                	mv	a0,s6
 544:	e43ff0ef          	jal	386 <putc>
        putc(fd, c0);
 548:	85ca                	mv	a1,s2
 54a:	855a                	mv	a0,s6
 54c:	e3bff0ef          	jal	386 <putc>
      state = 0;
 550:	4981                	li	s3,0
 552:	b791                	j	496 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 554:	008b8913          	addi	s2,s7,8
 558:	4685                	li	a3,1
 55a:	4629                	li	a2,10
 55c:	000ba583          	lw	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	e43ff0ef          	jal	3a4 <printint>
        i += 1;
 566:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 568:	8bca                	mv	s7,s2
      state = 0;
 56a:	4981                	li	s3,0
        i += 1;
 56c:	b72d                	j	496 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 56e:	06400793          	li	a5,100
 572:	02f60763          	beq	a2,a5,5a0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 576:	07500793          	li	a5,117
 57a:	06f60963          	beq	a2,a5,5ec <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 57e:	07800793          	li	a5,120
 582:	faf61ee3          	bne	a2,a5,53e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 586:	008b8913          	addi	s2,s7,8
 58a:	4681                	li	a3,0
 58c:	4641                	li	a2,16
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e11ff0ef          	jal	3a4 <printint>
        i += 2;
 598:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
        i += 2;
 59e:	bde5                	j	496 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	df7ff0ef          	jal	3a4 <printint>
        i += 2;
 5b2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b4:	8bca                	mv	s7,s2
      state = 0;
 5b6:	4981                	li	s3,0
        i += 2;
 5b8:	bdf9                	j	496 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4681                	li	a3,0
 5c0:	4629                	li	a2,10
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	dddff0ef          	jal	3a4 <printint>
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b5d9                	j	496 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	dc5ff0ef          	jal	3a4 <printint>
        i += 1;
 5e4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
        i += 1;
 5ea:	b575                	j	496 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	dabff0ef          	jal	3a4 <printint>
        i += 2;
 5fe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	bd49                	j	496 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 606:	008b8913          	addi	s2,s7,8
 60a:	4681                	li	a3,0
 60c:	4641                	li	a2,16
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	d91ff0ef          	jal	3a4 <printint>
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bdad                	j	496 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61e:	008b8913          	addi	s2,s7,8
 622:	4681                	li	a3,0
 624:	4641                	li	a2,16
 626:	000ba583          	lw	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	d79ff0ef          	jal	3a4 <printint>
        i += 1;
 630:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
        i += 1;
 636:	b585                	j	496 <vprintf+0x4a>
 638:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 63a:	008b8d13          	addi	s10,s7,8
 63e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 642:	03000593          	li	a1,48
 646:	855a                	mv	a0,s6
 648:	d3fff0ef          	jal	386 <putc>
  putc(fd, 'x');
 64c:	07800593          	li	a1,120
 650:	855a                	mv	a0,s6
 652:	d35ff0ef          	jal	386 <putc>
 656:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 658:	00000b97          	auipc	s7,0x0
 65c:	278b8b93          	addi	s7,s7,632 # 8d0 <digits>
 660:	03c9d793          	srli	a5,s3,0x3c
 664:	97de                	add	a5,a5,s7
 666:	0007c583          	lbu	a1,0(a5)
 66a:	855a                	mv	a0,s6
 66c:	d1bff0ef          	jal	386 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 670:	0992                	slli	s3,s3,0x4
 672:	397d                	addiw	s2,s2,-1
 674:	fe0916e3          	bnez	s2,660 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 678:	8bea                	mv	s7,s10
      state = 0;
 67a:	4981                	li	s3,0
 67c:	6d02                	ld	s10,0(sp)
 67e:	bd21                	j	496 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 680:	008b8993          	addi	s3,s7,8
 684:	000bb903          	ld	s2,0(s7)
 688:	00090f63          	beqz	s2,6a6 <vprintf+0x25a>
        for(; *s; s++)
 68c:	00094583          	lbu	a1,0(s2)
 690:	c195                	beqz	a1,6b4 <vprintf+0x268>
          putc(fd, *s);
 692:	855a                	mv	a0,s6
 694:	cf3ff0ef          	jal	386 <putc>
        for(; *s; s++)
 698:	0905                	addi	s2,s2,1
 69a:	00094583          	lbu	a1,0(s2)
 69e:	f9f5                	bnez	a1,692 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6a0:	8bce                	mv	s7,s3
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bbcd                	j	496 <vprintf+0x4a>
          s = "(null)";
 6a6:	00000917          	auipc	s2,0x0
 6aa:	22290913          	addi	s2,s2,546 # 8c8 <malloc+0x116>
        for(; *s; s++)
 6ae:	02800593          	li	a1,40
 6b2:	b7c5                	j	692 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6b4:	8bce                	mv	s7,s3
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bbf9                	j	496 <vprintf+0x4a>
 6ba:	64a6                	ld	s1,72(sp)
 6bc:	79e2                	ld	s3,56(sp)
 6be:	7a42                	ld	s4,48(sp)
 6c0:	7aa2                	ld	s5,40(sp)
 6c2:	7b02                	ld	s6,32(sp)
 6c4:	6be2                	ld	s7,24(sp)
 6c6:	6c42                	ld	s8,16(sp)
 6c8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6ca:	60e6                	ld	ra,88(sp)
 6cc:	6446                	ld	s0,80(sp)
 6ce:	6906                	ld	s2,64(sp)
 6d0:	6125                	addi	sp,sp,96
 6d2:	8082                	ret

00000000000006d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d4:	715d                	addi	sp,sp,-80
 6d6:	ec06                	sd	ra,24(sp)
 6d8:	e822                	sd	s0,16(sp)
 6da:	1000                	addi	s0,sp,32
 6dc:	e010                	sd	a2,0(s0)
 6de:	e414                	sd	a3,8(s0)
 6e0:	e818                	sd	a4,16(s0)
 6e2:	ec1c                	sd	a5,24(s0)
 6e4:	03043023          	sd	a6,32(s0)
 6e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f0:	8622                	mv	a2,s0
 6f2:	d5bff0ef          	jal	44c <vprintf>
}
 6f6:	60e2                	ld	ra,24(sp)
 6f8:	6442                	ld	s0,16(sp)
 6fa:	6161                	addi	sp,sp,80
 6fc:	8082                	ret

00000000000006fe <printf>:

void
printf(const char *fmt, ...)
{
 6fe:	711d                	addi	sp,sp,-96
 700:	ec06                	sd	ra,24(sp)
 702:	e822                	sd	s0,16(sp)
 704:	1000                	addi	s0,sp,32
 706:	e40c                	sd	a1,8(s0)
 708:	e810                	sd	a2,16(s0)
 70a:	ec14                	sd	a3,24(s0)
 70c:	f018                	sd	a4,32(s0)
 70e:	f41c                	sd	a5,40(s0)
 710:	03043823          	sd	a6,48(s0)
 714:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 718:	00840613          	addi	a2,s0,8
 71c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 720:	85aa                	mv	a1,a0
 722:	4505                	li	a0,1
 724:	d29ff0ef          	jal	44c <vprintf>
}
 728:	60e2                	ld	ra,24(sp)
 72a:	6442                	ld	s0,16(sp)
 72c:	6125                	addi	sp,sp,96
 72e:	8082                	ret

0000000000000730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 730:	1141                	addi	sp,sp,-16
 732:	e422                	sd	s0,8(sp)
 734:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 736:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	00001797          	auipc	a5,0x1
 73e:	8c67b783          	ld	a5,-1850(a5) # 1000 <freep>
 742:	a02d                	j	76c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 744:	4618                	lw	a4,8(a2)
 746:	9f2d                	addw	a4,a4,a1
 748:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	6398                	ld	a4,0(a5)
 74e:	6310                	ld	a2,0(a4)
 750:	a83d                	j	78e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 752:	ff852703          	lw	a4,-8(a0)
 756:	9f31                	addw	a4,a4,a2
 758:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75a:	ff053683          	ld	a3,-16(a0)
 75e:	a091                	j	7a2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	6398                	ld	a4,0(a5)
 762:	00e7e463          	bltu	a5,a4,76a <free+0x3a>
 766:	00e6ea63          	bltu	a3,a4,77a <free+0x4a>
{
 76a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	fed7fae3          	bgeu	a5,a3,760 <free+0x30>
 770:	6398                	ld	a4,0(a5)
 772:	00e6e463          	bltu	a3,a4,77a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	fee7eae3          	bltu	a5,a4,76a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 77a:	ff852583          	lw	a1,-8(a0)
 77e:	6390                	ld	a2,0(a5)
 780:	02059813          	slli	a6,a1,0x20
 784:	01c85713          	srli	a4,a6,0x1c
 788:	9736                	add	a4,a4,a3
 78a:	fae60de3          	beq	a2,a4,744 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 78e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 792:	4790                	lw	a2,8(a5)
 794:	02061593          	slli	a1,a2,0x20
 798:	01c5d713          	srli	a4,a1,0x1c
 79c:	973e                	add	a4,a4,a5
 79e:	fae68ae3          	beq	a3,a4,752 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7a2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a4:	00001717          	auipc	a4,0x1
 7a8:	84f73e23          	sd	a5,-1956(a4) # 1000 <freep>
}
 7ac:	6422                	ld	s0,8(sp)
 7ae:	0141                	addi	sp,sp,16
 7b0:	8082                	ret

00000000000007b2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b2:	7139                	addi	sp,sp,-64
 7b4:	fc06                	sd	ra,56(sp)
 7b6:	f822                	sd	s0,48(sp)
 7b8:	f426                	sd	s1,40(sp)
 7ba:	ec4e                	sd	s3,24(sp)
 7bc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7be:	02051493          	slli	s1,a0,0x20
 7c2:	9081                	srli	s1,s1,0x20
 7c4:	04bd                	addi	s1,s1,15
 7c6:	8091                	srli	s1,s1,0x4
 7c8:	0014899b          	addiw	s3,s1,1
 7cc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ce:	00001517          	auipc	a0,0x1
 7d2:	83253503          	ld	a0,-1998(a0) # 1000 <freep>
 7d6:	c915                	beqz	a0,80a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7da:	4798                	lw	a4,8(a5)
 7dc:	08977a63          	bgeu	a4,s1,870 <malloc+0xbe>
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	e852                	sd	s4,16(sp)
 7e4:	e456                	sd	s5,8(sp)
 7e6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e8:	8a4e                	mv	s4,s3
 7ea:	0009871b          	sext.w	a4,s3
 7ee:	6685                	lui	a3,0x1
 7f0:	00d77363          	bgeu	a4,a3,7f6 <malloc+0x44>
 7f4:	6a05                	lui	s4,0x1
 7f6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fe:	00001917          	auipc	s2,0x1
 802:	80290913          	addi	s2,s2,-2046 # 1000 <freep>
  if(p == (char*)-1)
 806:	5afd                	li	s5,-1
 808:	a081                	j	848 <malloc+0x96>
 80a:	f04a                	sd	s2,32(sp)
 80c:	e852                	sd	s4,16(sp)
 80e:	e456                	sd	s5,8(sp)
 810:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 812:	00000797          	auipc	a5,0x0
 816:	7fe78793          	addi	a5,a5,2046 # 1010 <base>
 81a:	00000717          	auipc	a4,0x0
 81e:	7ef73323          	sd	a5,2022(a4) # 1000 <freep>
 822:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 824:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 828:	b7c1                	j	7e8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 82a:	6398                	ld	a4,0(a5)
 82c:	e118                	sd	a4,0(a0)
 82e:	a8a9                	j	888 <malloc+0xd6>
  hp->s.size = nu;
 830:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 834:	0541                	addi	a0,a0,16
 836:	efbff0ef          	jal	730 <free>
  return freep;
 83a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83e:	c12d                	beqz	a0,8a0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	02977263          	bgeu	a4,s1,868 <malloc+0xb6>
    if(p == freep)
 848:	00093703          	ld	a4,0(s2)
 84c:	853e                	mv	a0,a5
 84e:	fef719e3          	bne	a4,a5,840 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 852:	8552                	mv	a0,s4
 854:	af3ff0ef          	jal	346 <sbrk>
  if(p == (char*)-1)
 858:	fd551ce3          	bne	a0,s5,830 <malloc+0x7e>
        return 0;
 85c:	4501                	li	a0,0
 85e:	7902                	ld	s2,32(sp)
 860:	6a42                	ld	s4,16(sp)
 862:	6aa2                	ld	s5,8(sp)
 864:	6b02                	ld	s6,0(sp)
 866:	a03d                	j	894 <malloc+0xe2>
 868:	7902                	ld	s2,32(sp)
 86a:	6a42                	ld	s4,16(sp)
 86c:	6aa2                	ld	s5,8(sp)
 86e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 870:	fae48de3          	beq	s1,a4,82a <malloc+0x78>
        p->s.size -= nunits;
 874:	4137073b          	subw	a4,a4,s3
 878:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87a:	02071693          	slli	a3,a4,0x20
 87e:	01c6d713          	srli	a4,a3,0x1c
 882:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 884:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 888:	00000717          	auipc	a4,0x0
 88c:	76a73c23          	sd	a0,1912(a4) # 1000 <freep>
      return (void*)(p + 1);
 890:	01078513          	addi	a0,a5,16
  }
}
 894:	70e2                	ld	ra,56(sp)
 896:	7442                	ld	s0,48(sp)
 898:	74a2                	ld	s1,40(sp)
 89a:	69e2                	ld	s3,24(sp)
 89c:	6121                	addi	sp,sp,64
 89e:	8082                	ret
 8a0:	7902                	ld	s2,32(sp)
 8a2:	6a42                	ld	s4,16(sp)
 8a4:	6aa2                	ld	s5,8(sp)
 8a6:	6b02                	ld	s6,0(sp)
 8a8:	b7f5                	j	894 <malloc+0xe2>
