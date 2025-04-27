
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2b6000ef          	jal	2c2 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	28e000ef          	jal	2c2 <strlen>
  38:	2501                	sext.w	a0,a0
  3a:	47b5                	li	a5,13
  3c:	00a7f863          	bgeu	a5,a0,4c <fmtname+0x4c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  40:	8526                	mv	a0,s1
  42:	70a2                	ld	ra,40(sp)
  44:	7402                	ld	s0,32(sp)
  46:	64e2                	ld	s1,24(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  50:	8526                	mv	a0,s1
  52:	270000ef          	jal	2c2 <strlen>
  56:	00001997          	auipc	s3,0x1
  5a:	fba98993          	addi	s3,s3,-70 # 1010 <buf.0>
  5e:	0005061b          	sext.w	a2,a0
  62:	85a6                	mv	a1,s1
  64:	854e                	mv	a0,s3
  66:	3be000ef          	jal	424 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8526                	mv	a0,s1
  6c:	256000ef          	jal	2c2 <strlen>
  70:	0005091b          	sext.w	s2,a0
  74:	8526                	mv	a0,s1
  76:	24c000ef          	jal	2c2 <strlen>
  7a:	1902                	slli	s2,s2,0x20
  7c:	02095913          	srli	s2,s2,0x20
  80:	4639                	li	a2,14
  82:	9e09                	subw	a2,a2,a0
  84:	02000593          	li	a1,32
  88:	01298533          	add	a0,s3,s2
  8c:	260000ef          	jal	2ec <memset>
  return buf;
  90:	84ce                	mv	s1,s3
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	b76d                	j	40 <fmtname+0x40>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	25213823          	sd	s2,592(sp)
  a8:	1c80                	addi	s0,sp,624
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ac:	4581                	li	a1,0
  ae:	464000ef          	jal	512 <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913c23          	sd	s1,600(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	d9840593          	addi	a1,s0,-616
  c0:	46a000ef          	jal	52a <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c8:	da041783          	lh	a5,-608(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	da842703          	lw	a4,-600(s0)
  e8:	d9c42683          	lw	a3,-612(s0)
  ec:	da041603          	lh	a2,-608(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	a0050513          	addi	a0,a0,-1536 # af0 <malloc+0x12a>
  f8:	01b000ef          	jal	912 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	3fc000ef          	jal	4fa <close>
 102:	25813483          	ld	s1,600(sp)
}
 106:	26813083          	ld	ra,616(sp)
 10a:	26013403          	ld	s0,608(sp)
 10e:	25013903          	ld	s2,592(sp)
 112:	27010113          	addi	sp,sp,624
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	9a658593          	addi	a1,a1,-1626 # ac0 <malloc+0xfa>
 122:	4509                	li	a0,2
 124:	7c4000ef          	jal	8e8 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	9ac58593          	addi	a1,a1,-1620 # ad8 <malloc+0x112>
 134:	4509                	li	a0,2
 136:	7b2000ef          	jal	8e8 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	3be000ef          	jal	4fa <close>
    return;
 140:	25813483          	ld	s1,600(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 146:	854a                	mv	a0,s2
 148:	17a000ef          	jal	2c2 <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	9aa50513          	addi	a0,a0,-1622 # b00 <malloc+0x13a>
 15e:	7b4000ef          	jal	912 <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	25313423          	sd	s3,584(sp)
 168:	25413023          	sd	s4,576(sp)
 16c:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 170:	85ca                	mv	a1,s2
 172:	dc040513          	addi	a0,s0,-576
 176:	104000ef          	jal	27a <strcpy>
    p = buf+strlen(buf);
 17a:	dc040513          	addi	a0,s0,-576
 17e:	144000ef          	jal	2c2 <strlen>
 182:	1502                	slli	a0,a0,0x20
 184:	9101                	srli	a0,a0,0x20
 186:	dc040793          	addi	a5,s0,-576
 18a:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 18e:	00190993          	addi	s3,s2,1
 192:	02f00793          	li	a5,47
 196:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 19a:	00001a17          	auipc	s4,0x1
 19e:	956a0a13          	addi	s4,s4,-1706 # af0 <malloc+0x12a>
        printf("ls: cannot stat %s\n", buf);
 1a2:	00001a97          	auipc	s5,0x1
 1a6:	936a8a93          	addi	s5,s5,-1738 # ad8 <malloc+0x112>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1aa:	a031                	j	1b6 <ls+0x11e>
        printf("ls: cannot stat %s\n", buf);
 1ac:	dc040593          	addi	a1,s0,-576
 1b0:	8556                	mv	a0,s5
 1b2:	760000ef          	jal	912 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b6:	4641                	li	a2,16
 1b8:	db040593          	addi	a1,s0,-592
 1bc:	8526                	mv	a0,s1
 1be:	32c000ef          	jal	4ea <read>
 1c2:	47c1                	li	a5,16
 1c4:	04f51463          	bne	a0,a5,20c <ls+0x174>
      if(de.inum == 0)
 1c8:	db045783          	lhu	a5,-592(s0)
 1cc:	d7ed                	beqz	a5,1b6 <ls+0x11e>
      memmove(p, de.name, DIRSIZ);
 1ce:	4639                	li	a2,14
 1d0:	db240593          	addi	a1,s0,-590
 1d4:	854e                	mv	a0,s3
 1d6:	24e000ef          	jal	424 <memmove>
      p[DIRSIZ] = 0;
 1da:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1de:	d9840593          	addi	a1,s0,-616
 1e2:	dc040513          	addi	a0,s0,-576
 1e6:	1bc000ef          	jal	3a2 <stat>
 1ea:	fc0541e3          	bltz	a0,1ac <ls+0x114>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1ee:	dc040513          	addi	a0,s0,-576
 1f2:	e0fff0ef          	jal	0 <fmtname>
 1f6:	85aa                	mv	a1,a0
 1f8:	da842703          	lw	a4,-600(s0)
 1fc:	d9c42683          	lw	a3,-612(s0)
 200:	da041603          	lh	a2,-608(s0)
 204:	8552                	mv	a0,s4
 206:	70c000ef          	jal	912 <printf>
 20a:	b775                	j	1b6 <ls+0x11e>
 20c:	24813983          	ld	s3,584(sp)
 210:	24013a03          	ld	s4,576(sp)
 214:	23813a83          	ld	s5,568(sp)
 218:	b5d5                	j	fc <ls+0x64>

000000000000021a <main>:

int
main(int argc, char *argv[])
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 222:	4785                	li	a5,1
 224:	02a7d763          	bge	a5,a0,252 <main+0x38>
 228:	e426                	sd	s1,8(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	00858493          	addi	s1,a1,8
 230:	ffe5091b          	addiw	s2,a0,-2
 234:	02091793          	slli	a5,s2,0x20
 238:	01d7d913          	srli	s2,a5,0x1d
 23c:	05c1                	addi	a1,a1,16
 23e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 240:	6088                	ld	a0,0(s1)
 242:	e57ff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 246:	04a1                	addi	s1,s1,8
 248:	ff249ce3          	bne	s1,s2,240 <main+0x26>
  exit(0);
 24c:	4501                	li	a0,0
 24e:	284000ef          	jal	4d2 <exit>
 252:	e426                	sd	s1,8(sp)
 254:	e04a                	sd	s2,0(sp)
    ls(".");
 256:	00001517          	auipc	a0,0x1
 25a:	8c250513          	addi	a0,a0,-1854 # b18 <malloc+0x152>
 25e:	e3bff0ef          	jal	98 <ls>
    exit(0);
 262:	4501                	li	a0,0
 264:	26e000ef          	jal	4d2 <exit>

0000000000000268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 270:	fabff0ef          	jal	21a <main>
  exit(0);
 274:	4501                	li	a0,0
 276:	25c000ef          	jal	4d2 <exit>

000000000000027a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 280:	87aa                	mv	a5,a0
 282:	0585                	addi	a1,a1,1
 284:	0785                	addi	a5,a5,1
 286:	fff5c703          	lbu	a4,-1(a1)
 28a:	fee78fa3          	sb	a4,-1(a5)
 28e:	fb75                	bnez	a4,282 <strcpy+0x8>
    ;
  return os;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb91                	beqz	a5,2b4 <strcmp+0x1e>
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00f71763          	bne	a4,a5,2b4 <strcmp+0x1e>
    p++, q++;
 2aa:	0505                	addi	a0,a0,1
 2ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	fbe5                	bnez	a5,2a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b4:	0005c503          	lbu	a0,0(a1)
}
 2b8:	40a7853b          	subw	a0,a5,a0
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strlen>:

uint
strlen(const char *s)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cf91                	beqz	a5,2e8 <strlen+0x26>
 2ce:	0505                	addi	a0,a0,1
 2d0:	87aa                	mv	a5,a0
 2d2:	86be                	mv	a3,a5
 2d4:	0785                	addi	a5,a5,1
 2d6:	fff7c703          	lbu	a4,-1(a5)
 2da:	ff65                	bnez	a4,2d2 <strlen+0x10>
 2dc:	40a6853b          	subw	a0,a3,a0
 2e0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  for(n = 0; s[n]; n++)
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <strlen+0x20>

00000000000002ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f2:	ca19                	beqz	a2,308 <memset+0x1c>
 2f4:	87aa                	mv	a5,a0
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 302:	0785                	addi	a5,a5,1
 304:	fee79de3          	bne	a5,a4,2fe <memset+0x12>
  }
  return dst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strchr>:

char*
strchr(const char *s, char c)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  for(; *s; s++)
 314:	00054783          	lbu	a5,0(a0)
 318:	cb99                	beqz	a5,32e <strchr+0x20>
    if(*s == c)
 31a:	00f58763          	beq	a1,a5,328 <strchr+0x1a>
  for(; *s; s++)
 31e:	0505                	addi	a0,a0,1
 320:	00054783          	lbu	a5,0(a0)
 324:	fbfd                	bnez	a5,31a <strchr+0xc>
      return (char*)s;
  return 0;
 326:	4501                	li	a0,0
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <strchr+0x1a>

0000000000000332 <gets>:

char*
gets(char *buf, int max)
{
 332:	711d                	addi	sp,sp,-96
 334:	ec86                	sd	ra,88(sp)
 336:	e8a2                	sd	s0,80(sp)
 338:	e4a6                	sd	s1,72(sp)
 33a:	e0ca                	sd	s2,64(sp)
 33c:	fc4e                	sd	s3,56(sp)
 33e:	f852                	sd	s4,48(sp)
 340:	f456                	sd	s5,40(sp)
 342:	f05a                	sd	s6,32(sp)
 344:	ec5e                	sd	s7,24(sp)
 346:	1080                	addi	s0,sp,96
 348:	8baa                	mv	s7,a0
 34a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	892a                	mv	s2,a0
 34e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 350:	4aa9                	li	s5,10
 352:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 354:	89a6                	mv	s3,s1
 356:	2485                	addiw	s1,s1,1
 358:	0344d663          	bge	s1,s4,384 <gets+0x52>
    cc = read(0, &c, 1);
 35c:	4605                	li	a2,1
 35e:	faf40593          	addi	a1,s0,-81
 362:	4501                	li	a0,0
 364:	186000ef          	jal	4ea <read>
    if(cc < 1)
 368:	00a05e63          	blez	a0,384 <gets+0x52>
    buf[i++] = c;
 36c:	faf44783          	lbu	a5,-81(s0)
 370:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 374:	01578763          	beq	a5,s5,382 <gets+0x50>
 378:	0905                	addi	s2,s2,1
 37a:	fd679de3          	bne	a5,s6,354 <gets+0x22>
    buf[i++] = c;
 37e:	89a6                	mv	s3,s1
 380:	a011                	j	384 <gets+0x52>
 382:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 384:	99de                	add	s3,s3,s7
 386:	00098023          	sb	zero,0(s3)
  return buf;
}
 38a:	855e                	mv	a0,s7
 38c:	60e6                	ld	ra,88(sp)
 38e:	6446                	ld	s0,80(sp)
 390:	64a6                	ld	s1,72(sp)
 392:	6906                	ld	s2,64(sp)
 394:	79e2                	ld	s3,56(sp)
 396:	7a42                	ld	s4,48(sp)
 398:	7aa2                	ld	s5,40(sp)
 39a:	7b02                	ld	s6,32(sp)
 39c:	6be2                	ld	s7,24(sp)
 39e:	6125                	addi	sp,sp,96
 3a0:	8082                	ret

00000000000003a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	e04a                	sd	s2,0(sp)
 3aa:	1000                	addi	s0,sp,32
 3ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ae:	4581                	li	a1,0
 3b0:	162000ef          	jal	512 <open>
  if(fd < 0)
 3b4:	02054263          	bltz	a0,3d8 <stat+0x36>
 3b8:	e426                	sd	s1,8(sp)
 3ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3bc:	85ca                	mv	a1,s2
 3be:	16c000ef          	jal	52a <fstat>
 3c2:	892a                	mv	s2,a0
  close(fd);
 3c4:	8526                	mv	a0,s1
 3c6:	134000ef          	jal	4fa <close>
  return r;
 3ca:	64a2                	ld	s1,8(sp)
}
 3cc:	854a                	mv	a0,s2
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	6902                	ld	s2,0(sp)
 3d4:	6105                	addi	sp,sp,32
 3d6:	8082                	ret
    return -1;
 3d8:	597d                	li	s2,-1
 3da:	bfcd                	j	3cc <stat+0x2a>

00000000000003dc <atoi>:

int
atoi(const char *s)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e2:	00054683          	lbu	a3,0(a0)
 3e6:	fd06879b          	addiw	a5,a3,-48
 3ea:	0ff7f793          	zext.b	a5,a5
 3ee:	4625                	li	a2,9
 3f0:	02f66863          	bltu	a2,a5,420 <atoi+0x44>
 3f4:	872a                	mv	a4,a0
  n = 0;
 3f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3f8:	0705                	addi	a4,a4,1
 3fa:	0025179b          	slliw	a5,a0,0x2
 3fe:	9fa9                	addw	a5,a5,a0
 400:	0017979b          	slliw	a5,a5,0x1
 404:	9fb5                	addw	a5,a5,a3
 406:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40a:	00074683          	lbu	a3,0(a4)
 40e:	fd06879b          	addiw	a5,a3,-48
 412:	0ff7f793          	zext.b	a5,a5
 416:	fef671e3          	bgeu	a2,a5,3f8 <atoi+0x1c>
  return n;
}
 41a:	6422                	ld	s0,8(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret
  n = 0;
 420:	4501                	li	a0,0
 422:	bfe5                	j	41a <atoi+0x3e>

0000000000000424 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42a:	02b57463          	bgeu	a0,a1,452 <memmove+0x2e>
    while(n-- > 0)
 42e:	00c05f63          	blez	a2,44c <memmove+0x28>
 432:	1602                	slli	a2,a2,0x20
 434:	9201                	srli	a2,a2,0x20
 436:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43a:	872a                	mv	a4,a0
      *dst++ = *src++;
 43c:	0585                	addi	a1,a1,1
 43e:	0705                	addi	a4,a4,1
 440:	fff5c683          	lbu	a3,-1(a1)
 444:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 448:	fef71ae3          	bne	a4,a5,43c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
    dst += n;
 452:	00c50733          	add	a4,a0,a2
    src += n;
 456:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 458:	fec05ae3          	blez	a2,44c <memmove+0x28>
 45c:	fff6079b          	addiw	a5,a2,-1
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	fff7c793          	not	a5,a5
 468:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46a:	15fd                	addi	a1,a1,-1
 46c:	177d                	addi	a4,a4,-1
 46e:	0005c683          	lbu	a3,0(a1)
 472:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 476:	fee79ae3          	bne	a5,a4,46a <memmove+0x46>
 47a:	bfc9                	j	44c <memmove+0x28>

000000000000047c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 482:	ca05                	beqz	a2,4b2 <memcmp+0x36>
 484:	fff6069b          	addiw	a3,a2,-1
 488:	1682                	slli	a3,a3,0x20
 48a:	9281                	srli	a3,a3,0x20
 48c:	0685                	addi	a3,a3,1
 48e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 490:	00054783          	lbu	a5,0(a0)
 494:	0005c703          	lbu	a4,0(a1)
 498:	00e79863          	bne	a5,a4,4a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49c:	0505                	addi	a0,a0,1
    p2++;
 49e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a0:	fed518e3          	bne	a0,a3,490 <memcmp+0x14>
  }
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	a019                	j	4ac <memcmp+0x30>
      return *p1 - *p2;
 4a8:	40e7853b          	subw	a0,a5,a4
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	bfe5                	j	4ac <memcmp+0x30>

00000000000004b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b6:	1141                	addi	sp,sp,-16
 4b8:	e406                	sd	ra,8(sp)
 4ba:	e022                	sd	s0,0(sp)
 4bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4be:	f67ff0ef          	jal	424 <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ca:	4885                	li	a7,1
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d2:	4889                	li	a7,2
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <wait>:
.global wait
wait:
 li a7, SYS_wait
 4da:	488d                	li	a7,3
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e2:	4891                	li	a7,4
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <read>:
.global read
read:
 li a7, SYS_read
 4ea:	4895                	li	a7,5
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <write>:
.global write
write:
 li a7, SYS_write
 4f2:	48c1                	li	a7,16
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <close>:
.global close
close:
 li a7, SYS_close
 4fa:	48d5                	li	a7,21
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <kill>:
.global kill
kill:
 li a7, SYS_kill
 502:	4899                	li	a7,6
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exec>:
.global exec
exec:
 li a7, SYS_exec
 50a:	489d                	li	a7,7
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <open>:
.global open
open:
 li a7, SYS_open
 512:	48bd                	li	a7,15
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51a:	48c5                	li	a7,17
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 522:	48c9                	li	a7,18
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52a:	48a1                	li	a7,8
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <link>:
.global link
link:
 li a7, SYS_link
 532:	48cd                	li	a7,19
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53a:	48d1                	li	a7,20
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 542:	48a5                	li	a7,9
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <dup>:
.global dup
dup:
 li a7, SYS_dup
 54a:	48a9                	li	a7,10
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 552:	48ad                	li	a7,11
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55a:	48b1                	li	a7,12
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 562:	48b5                	li	a7,13
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56a:	48b9                	li	a7,14
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <yield>:
.global yield
yield:
 li a7, SYS_yield
 572:	48d9                	li	a7,22
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 57a:	48dd                	li	a7,23
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 582:	48e1                	li	a7,24
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 58a:	48e5                	li	a7,25
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 592:	48e9                	li	a7,26
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 59a:	1101                	addi	sp,sp,-32
 59c:	ec06                	sd	ra,24(sp)
 59e:	e822                	sd	s0,16(sp)
 5a0:	1000                	addi	s0,sp,32
 5a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5a6:	4605                	li	a2,1
 5a8:	fef40593          	addi	a1,s0,-17
 5ac:	f47ff0ef          	jal	4f2 <write>
}
 5b0:	60e2                	ld	ra,24(sp)
 5b2:	6442                	ld	s0,16(sp)
 5b4:	6105                	addi	sp,sp,32
 5b6:	8082                	ret

00000000000005b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b8:	7139                	addi	sp,sp,-64
 5ba:	fc06                	sd	ra,56(sp)
 5bc:	f822                	sd	s0,48(sp)
 5be:	f426                	sd	s1,40(sp)
 5c0:	0080                	addi	s0,sp,64
 5c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c4:	c299                	beqz	a3,5ca <printint+0x12>
 5c6:	0805c963          	bltz	a1,658 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ca:	2581                	sext.w	a1,a1
  neg = 0;
 5cc:	4881                	li	a7,0
 5ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5d4:	2601                	sext.w	a2,a2
 5d6:	00000517          	auipc	a0,0x0
 5da:	55250513          	addi	a0,a0,1362 # b28 <digits>
 5de:	883a                	mv	a6,a4
 5e0:	2705                	addiw	a4,a4,1
 5e2:	02c5f7bb          	remuw	a5,a1,a2
 5e6:	1782                	slli	a5,a5,0x20
 5e8:	9381                	srli	a5,a5,0x20
 5ea:	97aa                	add	a5,a5,a0
 5ec:	0007c783          	lbu	a5,0(a5)
 5f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5f4:	0005879b          	sext.w	a5,a1
 5f8:	02c5d5bb          	divuw	a1,a1,a2
 5fc:	0685                	addi	a3,a3,1
 5fe:	fec7f0e3          	bgeu	a5,a2,5de <printint+0x26>
  if(neg)
 602:	00088c63          	beqz	a7,61a <printint+0x62>
    buf[i++] = '-';
 606:	fd070793          	addi	a5,a4,-48
 60a:	00878733          	add	a4,a5,s0
 60e:	02d00793          	li	a5,45
 612:	fef70823          	sb	a5,-16(a4)
 616:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 61a:	02e05a63          	blez	a4,64e <printint+0x96>
 61e:	f04a                	sd	s2,32(sp)
 620:	ec4e                	sd	s3,24(sp)
 622:	fc040793          	addi	a5,s0,-64
 626:	00e78933          	add	s2,a5,a4
 62a:	fff78993          	addi	s3,a5,-1
 62e:	99ba                	add	s3,s3,a4
 630:	377d                	addiw	a4,a4,-1
 632:	1702                	slli	a4,a4,0x20
 634:	9301                	srli	a4,a4,0x20
 636:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 63a:	fff94583          	lbu	a1,-1(s2)
 63e:	8526                	mv	a0,s1
 640:	f5bff0ef          	jal	59a <putc>
  while(--i >= 0)
 644:	197d                	addi	s2,s2,-1
 646:	ff391ae3          	bne	s2,s3,63a <printint+0x82>
 64a:	7902                	ld	s2,32(sp)
 64c:	69e2                	ld	s3,24(sp)
}
 64e:	70e2                	ld	ra,56(sp)
 650:	7442                	ld	s0,48(sp)
 652:	74a2                	ld	s1,40(sp)
 654:	6121                	addi	sp,sp,64
 656:	8082                	ret
    x = -xx;
 658:	40b005bb          	negw	a1,a1
    neg = 1;
 65c:	4885                	li	a7,1
    x = -xx;
 65e:	bf85                	j	5ce <printint+0x16>

0000000000000660 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 660:	711d                	addi	sp,sp,-96
 662:	ec86                	sd	ra,88(sp)
 664:	e8a2                	sd	s0,80(sp)
 666:	e0ca                	sd	s2,64(sp)
 668:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 66a:	0005c903          	lbu	s2,0(a1)
 66e:	26090863          	beqz	s2,8de <vprintf+0x27e>
 672:	e4a6                	sd	s1,72(sp)
 674:	fc4e                	sd	s3,56(sp)
 676:	f852                	sd	s4,48(sp)
 678:	f456                	sd	s5,40(sp)
 67a:	f05a                	sd	s6,32(sp)
 67c:	ec5e                	sd	s7,24(sp)
 67e:	e862                	sd	s8,16(sp)
 680:	e466                	sd	s9,8(sp)
 682:	8b2a                	mv	s6,a0
 684:	8a2e                	mv	s4,a1
 686:	8bb2                	mv	s7,a2
  state = 0;
 688:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 68a:	4481                	li	s1,0
 68c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 68e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 692:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 696:	06c00c93          	li	s9,108
 69a:	a005                	j	6ba <vprintf+0x5a>
        putc(fd, c0);
 69c:	85ca                	mv	a1,s2
 69e:	855a                	mv	a0,s6
 6a0:	efbff0ef          	jal	59a <putc>
 6a4:	a019                	j	6aa <vprintf+0x4a>
    } else if(state == '%'){
 6a6:	03598263          	beq	s3,s5,6ca <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6aa:	2485                	addiw	s1,s1,1
 6ac:	8726                	mv	a4,s1
 6ae:	009a07b3          	add	a5,s4,s1
 6b2:	0007c903          	lbu	s2,0(a5)
 6b6:	20090c63          	beqz	s2,8ce <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6ba:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6be:	fe0994e3          	bnez	s3,6a6 <vprintf+0x46>
      if(c0 == '%'){
 6c2:	fd579de3          	bne	a5,s5,69c <vprintf+0x3c>
        state = '%';
 6c6:	89be                	mv	s3,a5
 6c8:	b7cd                	j	6aa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6ca:	00ea06b3          	add	a3,s4,a4
 6ce:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6d2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6d4:	c681                	beqz	a3,6dc <vprintf+0x7c>
 6d6:	9752                	add	a4,a4,s4
 6d8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6dc:	03878f63          	beq	a5,s8,71a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6e0:	05978963          	beq	a5,s9,732 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6e4:	07500713          	li	a4,117
 6e8:	0ee78363          	beq	a5,a4,7ce <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ec:	07800713          	li	a4,120
 6f0:	12e78563          	beq	a5,a4,81a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6f4:	07000713          	li	a4,112
 6f8:	14e78a63          	beq	a5,a4,84c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6fc:	07300713          	li	a4,115
 700:	18e78a63          	beq	a5,a4,894 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 704:	02500713          	li	a4,37
 708:	04e79563          	bne	a5,a4,752 <vprintf+0xf2>
        putc(fd, '%');
 70c:	02500593          	li	a1,37
 710:	855a                	mv	a0,s6
 712:	e89ff0ef          	jal	59a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 716:	4981                	li	s3,0
 718:	bf49                	j	6aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 71a:	008b8913          	addi	s2,s7,8
 71e:	4685                	li	a3,1
 720:	4629                	li	a2,10
 722:	000ba583          	lw	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	e91ff0ef          	jal	5b8 <printint>
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	bfad                	j	6aa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 732:	06400793          	li	a5,100
 736:	02f68963          	beq	a3,a5,768 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 73a:	06c00793          	li	a5,108
 73e:	04f68263          	beq	a3,a5,782 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 742:	07500793          	li	a5,117
 746:	0af68063          	beq	a3,a5,7e6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 74a:	07800793          	li	a5,120
 74e:	0ef68263          	beq	a3,a5,832 <vprintf+0x1d2>
        putc(fd, '%');
 752:	02500593          	li	a1,37
 756:	855a                	mv	a0,s6
 758:	e43ff0ef          	jal	59a <putc>
        putc(fd, c0);
 75c:	85ca                	mv	a1,s2
 75e:	855a                	mv	a0,s6
 760:	e3bff0ef          	jal	59a <putc>
      state = 0;
 764:	4981                	li	s3,0
 766:	b791                	j	6aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 768:	008b8913          	addi	s2,s7,8
 76c:	4685                	li	a3,1
 76e:	4629                	li	a2,10
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	e43ff0ef          	jal	5b8 <printint>
        i += 1;
 77a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
        i += 1;
 780:	b72d                	j	6aa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 782:	06400793          	li	a5,100
 786:	02f60763          	beq	a2,a5,7b4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 78a:	07500793          	li	a5,117
 78e:	06f60963          	beq	a2,a5,800 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 792:	07800793          	li	a5,120
 796:	faf61ee3          	bne	a2,a5,752 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 79a:	008b8913          	addi	s2,s7,8
 79e:	4681                	li	a3,0
 7a0:	4641                	li	a2,16
 7a2:	000ba583          	lw	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	e11ff0ef          	jal	5b8 <printint>
        i += 2;
 7ac:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
        i += 2;
 7b2:	bde5                	j	6aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	df7ff0ef          	jal	5b8 <printint>
        i += 2;
 7c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c8:	8bca                	mv	s7,s2
      state = 0;
 7ca:	4981                	li	s3,0
        i += 2;
 7cc:	bdf9                	j	6aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4629                	li	a2,10
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	dddff0ef          	jal	5b8 <printint>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b5d9                	j	6aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e6:	008b8913          	addi	s2,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4629                	li	a2,10
 7ee:	000ba583          	lw	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	dc5ff0ef          	jal	5b8 <printint>
        i += 1;
 7f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fa:	8bca                	mv	s7,s2
      state = 0;
 7fc:	4981                	li	s3,0
        i += 1;
 7fe:	b575                	j	6aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 800:	008b8913          	addi	s2,s7,8
 804:	4681                	li	a3,0
 806:	4629                	li	a2,10
 808:	000ba583          	lw	a1,0(s7)
 80c:	855a                	mv	a0,s6
 80e:	dabff0ef          	jal	5b8 <printint>
        i += 2;
 812:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 814:	8bca                	mv	s7,s2
      state = 0;
 816:	4981                	li	s3,0
        i += 2;
 818:	bd49                	j	6aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 81a:	008b8913          	addi	s2,s7,8
 81e:	4681                	li	a3,0
 820:	4641                	li	a2,16
 822:	000ba583          	lw	a1,0(s7)
 826:	855a                	mv	a0,s6
 828:	d91ff0ef          	jal	5b8 <printint>
 82c:	8bca                	mv	s7,s2
      state = 0;
 82e:	4981                	li	s3,0
 830:	bdad                	j	6aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 832:	008b8913          	addi	s2,s7,8
 836:	4681                	li	a3,0
 838:	4641                	li	a2,16
 83a:	000ba583          	lw	a1,0(s7)
 83e:	855a                	mv	a0,s6
 840:	d79ff0ef          	jal	5b8 <printint>
        i += 1;
 844:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 846:	8bca                	mv	s7,s2
      state = 0;
 848:	4981                	li	s3,0
        i += 1;
 84a:	b585                	j	6aa <vprintf+0x4a>
 84c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 84e:	008b8d13          	addi	s10,s7,8
 852:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 856:	03000593          	li	a1,48
 85a:	855a                	mv	a0,s6
 85c:	d3fff0ef          	jal	59a <putc>
  putc(fd, 'x');
 860:	07800593          	li	a1,120
 864:	855a                	mv	a0,s6
 866:	d35ff0ef          	jal	59a <putc>
 86a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 86c:	00000b97          	auipc	s7,0x0
 870:	2bcb8b93          	addi	s7,s7,700 # b28 <digits>
 874:	03c9d793          	srli	a5,s3,0x3c
 878:	97de                	add	a5,a5,s7
 87a:	0007c583          	lbu	a1,0(a5)
 87e:	855a                	mv	a0,s6
 880:	d1bff0ef          	jal	59a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 884:	0992                	slli	s3,s3,0x4
 886:	397d                	addiw	s2,s2,-1
 888:	fe0916e3          	bnez	s2,874 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 88c:	8bea                	mv	s7,s10
      state = 0;
 88e:	4981                	li	s3,0
 890:	6d02                	ld	s10,0(sp)
 892:	bd21                	j	6aa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 894:	008b8993          	addi	s3,s7,8
 898:	000bb903          	ld	s2,0(s7)
 89c:	00090f63          	beqz	s2,8ba <vprintf+0x25a>
        for(; *s; s++)
 8a0:	00094583          	lbu	a1,0(s2)
 8a4:	c195                	beqz	a1,8c8 <vprintf+0x268>
          putc(fd, *s);
 8a6:	855a                	mv	a0,s6
 8a8:	cf3ff0ef          	jal	59a <putc>
        for(; *s; s++)
 8ac:	0905                	addi	s2,s2,1
 8ae:	00094583          	lbu	a1,0(s2)
 8b2:	f9f5                	bnez	a1,8a6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8b4:	8bce                	mv	s7,s3
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	bbcd                	j	6aa <vprintf+0x4a>
          s = "(null)";
 8ba:	00000917          	auipc	s2,0x0
 8be:	26690913          	addi	s2,s2,614 # b20 <malloc+0x15a>
        for(; *s; s++)
 8c2:	02800593          	li	a1,40
 8c6:	b7c5                	j	8a6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8c8:	8bce                	mv	s7,s3
      state = 0;
 8ca:	4981                	li	s3,0
 8cc:	bbf9                	j	6aa <vprintf+0x4a>
 8ce:	64a6                	ld	s1,72(sp)
 8d0:	79e2                	ld	s3,56(sp)
 8d2:	7a42                	ld	s4,48(sp)
 8d4:	7aa2                	ld	s5,40(sp)
 8d6:	7b02                	ld	s6,32(sp)
 8d8:	6be2                	ld	s7,24(sp)
 8da:	6c42                	ld	s8,16(sp)
 8dc:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8de:	60e6                	ld	ra,88(sp)
 8e0:	6446                	ld	s0,80(sp)
 8e2:	6906                	ld	s2,64(sp)
 8e4:	6125                	addi	sp,sp,96
 8e6:	8082                	ret

00000000000008e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e8:	715d                	addi	sp,sp,-80
 8ea:	ec06                	sd	ra,24(sp)
 8ec:	e822                	sd	s0,16(sp)
 8ee:	1000                	addi	s0,sp,32
 8f0:	e010                	sd	a2,0(s0)
 8f2:	e414                	sd	a3,8(s0)
 8f4:	e818                	sd	a4,16(s0)
 8f6:	ec1c                	sd	a5,24(s0)
 8f8:	03043023          	sd	a6,32(s0)
 8fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 900:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 904:	8622                	mv	a2,s0
 906:	d5bff0ef          	jal	660 <vprintf>
}
 90a:	60e2                	ld	ra,24(sp)
 90c:	6442                	ld	s0,16(sp)
 90e:	6161                	addi	sp,sp,80
 910:	8082                	ret

0000000000000912 <printf>:

void
printf(const char *fmt, ...)
{
 912:	711d                	addi	sp,sp,-96
 914:	ec06                	sd	ra,24(sp)
 916:	e822                	sd	s0,16(sp)
 918:	1000                	addi	s0,sp,32
 91a:	e40c                	sd	a1,8(s0)
 91c:	e810                	sd	a2,16(s0)
 91e:	ec14                	sd	a3,24(s0)
 920:	f018                	sd	a4,32(s0)
 922:	f41c                	sd	a5,40(s0)
 924:	03043823          	sd	a6,48(s0)
 928:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92c:	00840613          	addi	a2,s0,8
 930:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 934:	85aa                	mv	a1,a0
 936:	4505                	li	a0,1
 938:	d29ff0ef          	jal	660 <vprintf>
}
 93c:	60e2                	ld	ra,24(sp)
 93e:	6442                	ld	s0,16(sp)
 940:	6125                	addi	sp,sp,96
 942:	8082                	ret

0000000000000944 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 944:	1141                	addi	sp,sp,-16
 946:	e422                	sd	s0,8(sp)
 948:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94e:	00000797          	auipc	a5,0x0
 952:	6b27b783          	ld	a5,1714(a5) # 1000 <freep>
 956:	a02d                	j	980 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 958:	4618                	lw	a4,8(a2)
 95a:	9f2d                	addw	a4,a4,a1
 95c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	6310                	ld	a2,0(a4)
 964:	a83d                	j	9a2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 966:	ff852703          	lw	a4,-8(a0)
 96a:	9f31                	addw	a4,a4,a2
 96c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 96e:	ff053683          	ld	a3,-16(a0)
 972:	a091                	j	9b6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 974:	6398                	ld	a4,0(a5)
 976:	00e7e463          	bltu	a5,a4,97e <free+0x3a>
 97a:	00e6ea63          	bltu	a3,a4,98e <free+0x4a>
{
 97e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 980:	fed7fae3          	bgeu	a5,a3,974 <free+0x30>
 984:	6398                	ld	a4,0(a5)
 986:	00e6e463          	bltu	a3,a4,98e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98a:	fee7eae3          	bltu	a5,a4,97e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 98e:	ff852583          	lw	a1,-8(a0)
 992:	6390                	ld	a2,0(a5)
 994:	02059813          	slli	a6,a1,0x20
 998:	01c85713          	srli	a4,a6,0x1c
 99c:	9736                	add	a4,a4,a3
 99e:	fae60de3          	beq	a2,a4,958 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9a2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9a6:	4790                	lw	a2,8(a5)
 9a8:	02061593          	slli	a1,a2,0x20
 9ac:	01c5d713          	srli	a4,a1,0x1c
 9b0:	973e                	add	a4,a4,a5
 9b2:	fae68ae3          	beq	a3,a4,966 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9b6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9b8:	00000717          	auipc	a4,0x0
 9bc:	64f73423          	sd	a5,1608(a4) # 1000 <freep>
}
 9c0:	6422                	ld	s0,8(sp)
 9c2:	0141                	addi	sp,sp,16
 9c4:	8082                	ret

00000000000009c6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c6:	7139                	addi	sp,sp,-64
 9c8:	fc06                	sd	ra,56(sp)
 9ca:	f822                	sd	s0,48(sp)
 9cc:	f426                	sd	s1,40(sp)
 9ce:	ec4e                	sd	s3,24(sp)
 9d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	02051493          	slli	s1,a0,0x20
 9d6:	9081                	srli	s1,s1,0x20
 9d8:	04bd                	addi	s1,s1,15
 9da:	8091                	srli	s1,s1,0x4
 9dc:	0014899b          	addiw	s3,s1,1
 9e0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e2:	00000517          	auipc	a0,0x0
 9e6:	61e53503          	ld	a0,1566(a0) # 1000 <freep>
 9ea:	c915                	beqz	a0,a1e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ee:	4798                	lw	a4,8(a5)
 9f0:	08977a63          	bgeu	a4,s1,a84 <malloc+0xbe>
 9f4:	f04a                	sd	s2,32(sp)
 9f6:	e852                	sd	s4,16(sp)
 9f8:	e456                	sd	s5,8(sp)
 9fa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9fc:	8a4e                	mv	s4,s3
 9fe:	0009871b          	sext.w	a4,s3
 a02:	6685                	lui	a3,0x1
 a04:	00d77363          	bgeu	a4,a3,a0a <malloc+0x44>
 a08:	6a05                	lui	s4,0x1
 a0a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a12:	00000917          	auipc	s2,0x0
 a16:	5ee90913          	addi	s2,s2,1518 # 1000 <freep>
  if(p == (char*)-1)
 a1a:	5afd                	li	s5,-1
 a1c:	a081                	j	a5c <malloc+0x96>
 a1e:	f04a                	sd	s2,32(sp)
 a20:	e852                	sd	s4,16(sp)
 a22:	e456                	sd	s5,8(sp)
 a24:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a26:	00000797          	auipc	a5,0x0
 a2a:	5fa78793          	addi	a5,a5,1530 # 1020 <base>
 a2e:	00000717          	auipc	a4,0x0
 a32:	5cf73923          	sd	a5,1490(a4) # 1000 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3c:	b7c1                	j	9fc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a3e:	6398                	ld	a4,0(a5)
 a40:	e118                	sd	a4,0(a0)
 a42:	a8a9                	j	a9c <malloc+0xd6>
  hp->s.size = nu;
 a44:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a48:	0541                	addi	a0,a0,16
 a4a:	efbff0ef          	jal	944 <free>
  return freep;
 a4e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a52:	c12d                	beqz	a0,ab4 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a54:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a56:	4798                	lw	a4,8(a5)
 a58:	02977263          	bgeu	a4,s1,a7c <malloc+0xb6>
    if(p == freep)
 a5c:	00093703          	ld	a4,0(s2)
 a60:	853e                	mv	a0,a5
 a62:	fef719e3          	bne	a4,a5,a54 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a66:	8552                	mv	a0,s4
 a68:	af3ff0ef          	jal	55a <sbrk>
  if(p == (char*)-1)
 a6c:	fd551ce3          	bne	a0,s5,a44 <malloc+0x7e>
        return 0;
 a70:	4501                	li	a0,0
 a72:	7902                	ld	s2,32(sp)
 a74:	6a42                	ld	s4,16(sp)
 a76:	6aa2                	ld	s5,8(sp)
 a78:	6b02                	ld	s6,0(sp)
 a7a:	a03d                	j	aa8 <malloc+0xe2>
 a7c:	7902                	ld	s2,32(sp)
 a7e:	6a42                	ld	s4,16(sp)
 a80:	6aa2                	ld	s5,8(sp)
 a82:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a84:	fae48de3          	beq	s1,a4,a3e <malloc+0x78>
        p->s.size -= nunits;
 a88:	4137073b          	subw	a4,a4,s3
 a8c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a8e:	02071693          	slli	a3,a4,0x20
 a92:	01c6d713          	srli	a4,a3,0x1c
 a96:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a98:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a9c:	00000717          	auipc	a4,0x0
 aa0:	56a73223          	sd	a0,1380(a4) # 1000 <freep>
      return (void*)(p + 1);
 aa4:	01078513          	addi	a0,a5,16
  }
}
 aa8:	70e2                	ld	ra,56(sp)
 aaa:	7442                	ld	s0,48(sp)
 aac:	74a2                	ld	s1,40(sp)
 aae:	69e2                	ld	s3,24(sp)
 ab0:	6121                	addi	sp,sp,64
 ab2:	8082                	ret
 ab4:	7902                	ld	s2,32(sp)
 ab6:	6a42                	ld	s4,16(sp)
 ab8:	6aa2                	ld	s5,8(sp)
 aba:	6b02                	ld	s6,0(sp)
 abc:	b7f5                	j	aa8 <malloc+0xe2>
