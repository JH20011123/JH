
user/_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fork_children>:
int parent;
int fcfs_pids[NUM_THREAD];
int fcfs_count[100] = {0};

int fork_children()
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	4491                	li	s1,4
  int i, p;
  for (i = 0; i < NUM_THREAD; i++) {
    if ((p = fork()) == 0) {
   c:	44e000ef          	jal	45a <fork>
  10:	cd01                	beqz	a0,28 <fork_children+0x28>
  for (i = 0; i < NUM_THREAD; i++) {
  12:	34fd                	addiw	s1,s1,-1
  14:	fce5                	bnez	s1,c <fork_children+0xc>
      return getpid();
    } 
  }
  return parent;
  16:	00002517          	auipc	a0,0x2
  1a:	fea52503          	lw	a0,-22(a0) # 2000 <parent>
}
  1e:	60e2                	ld	ra,24(sp)
  20:	6442                	ld	s0,16(sp)
  22:	64a2                	ld	s1,8(sp)
  24:	6105                	addi	sp,sp,32
  26:	8082                	ret
      return getpid();
  28:	4ba000ef          	jal	4e2 <getpid>
  2c:	bfcd                	j	1e <fork_children+0x1e>

000000000000002e <exit_children>:

void exit_children()
{
  2e:	7179                	addi	sp,sp,-48
  30:	f406                	sd	ra,40(sp)
  32:	f022                	sd	s0,32(sp)
  34:	ec26                	sd	s1,24(sp)
  36:	1800                	addi	s0,sp,48
  if (getpid() != parent)
  38:	4aa000ef          	jal	4e2 <getpid>
  3c:	00002797          	auipc	a5,0x2
  40:	fc47a783          	lw	a5,-60(a5) # 2000 <parent>
    exit(0);
  int status;
  while (wait(&status) != -1);
  44:	54fd                	li	s1,-1
  if (getpid() != parent)
  46:	00a79d63          	bne	a5,a0,60 <exit_children+0x32>
  while (wait(&status) != -1);
  4a:	fdc40513          	addi	a0,s0,-36
  4e:	41c000ef          	jal	46a <wait>
  52:	fe951ce3          	bne	a0,s1,4a <exit_children+0x1c>
}
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6145                	addi	sp,sp,48
  5e:	8082                	ret
    exit(0);
  60:	4501                	li	a0,0
  62:	400000ef          	jal	462 <exit>

0000000000000066 <main>:

int main(int argc, char *argv[])
{
  66:	7139                	addi	sp,sp,-64
  68:	fc06                	sd	ra,56(sp)
  6a:	f822                	sd	s0,48(sp)
  6c:	f426                	sd	s1,40(sp)
  6e:	f04a                	sd	s2,32(sp)
  70:	ec4e                	sd	s3,24(sp)
  72:	e852                	sd	s4,16(sp)
  74:	0080                	addi	s0,sp,64
  int i, pid;
  int count[MAX_LEVEL] = {0};
  76:	fc043023          	sd	zero,-64(s0)
  7a:	fc042423          	sw	zero,-56(s0)

  parent = getpid();
  7e:	464000ef          	jal	4e2 <getpid>
  82:	00002497          	auipc	s1,0x2
  86:	f7e48493          	addi	s1,s1,-130 # 2000 <parent>
  8a:	c088                	sw	a0,0(s1)

  printf("FCFS & MLFQ test start\n\n");
  8c:	00001517          	auipc	a0,0x1
  90:	9c450513          	addi	a0,a0,-1596 # a50 <malloc+0xfa>
  94:	00f000ef          	jal	8a2 <printf>

  // [Test 1] FCFS test
  printf("[Test 1] FCFS Queue Execution Order\n");
  98:	00001517          	auipc	a0,0x1
  9c:	9d850513          	addi	a0,a0,-1576 # a70 <malloc+0x11a>
  a0:	003000ef          	jal	8a2 <printf>
  pid = fork_children();
  a4:	f5dff0ef          	jal	0 <fork_children>

  if (pid != parent)
  a8:	409c                	lw	a5,0(s1)
  aa:	04a78763          	beq	a5,a0,f8 <main+0x92>
  ae:	85aa                	mv	a1,a0
  {
    while(fcfs_count[pid] < NUM_LOOP)
  b0:	00251713          	slli	a4,a0,0x2
  b4:	00002797          	auipc	a5,0x2
  b8:	f5c78793          	addi	a5,a5,-164 # 2010 <fcfs_count>
  bc:	97ba                	add	a5,a5,a4
  be:	4390                	lw	a2,0(a5)
  c0:	67e1                	lui	a5,0x18
  c2:	69f78793          	addi	a5,a5,1695 # 1869f <base+0x164ef>
  c6:	02c7c363          	blt	a5,a2,ec <main+0x86>
  ca:	67e1                	lui	a5,0x18
  cc:	6a078793          	addi	a5,a5,1696 # 186a0 <base+0x164f0>
    {
      fcfs_count[pid]++;
  d0:	2605                	addiw	a2,a2,1
    while(fcfs_count[pid] < NUM_LOOP)
  d2:	fef61fe3          	bne	a2,a5,d0 <main+0x6a>
  d6:	00259713          	slli	a4,a1,0x2
  da:	00002797          	auipc	a5,0x2
  de:	f3678793          	addi	a5,a5,-202 # 2010 <fcfs_count>
  e2:	97ba                	add	a5,a5,a4
  e4:	6761                	lui	a4,0x18
  e6:	6a070713          	addi	a4,a4,1696 # 186a0 <base+0x164f0>
  ea:	c398                	sw	a4,0(a5)
    }

    printf("Process %d executed %d times\n", pid, fcfs_count[pid]);
  ec:	00001517          	auipc	a0,0x1
  f0:	9ac50513          	addi	a0,a0,-1620 # a98 <malloc+0x142>
  f4:	7ae000ef          	jal	8a2 <printf>
  }
  exit_children();
  f8:	f37ff0ef          	jal	2e <exit_children>
  printf("[Test 1] FCFS Test Finished\n\n");
  fc:	00001517          	auipc	a0,0x1
 100:	9bc50513          	addi	a0,a0,-1604 # ab8 <malloc+0x162>
 104:	79e000ef          	jal	8a2 <printf>

  // Switch to FCFS mode - should not be changed
  if(fcfsmode() == 0) printf("successfully changed to FCFS mode!\n");
 108:	41a000ef          	jal	522 <fcfsmode>
 10c:	ed55                	bnez	a0,1c8 <main+0x162>
 10e:	00001517          	auipc	a0,0x1
 112:	9ca50513          	addi	a0,a0,-1590 # ad8 <malloc+0x182>
 116:	78c000ef          	jal	8a2 <printf>
  else printf("nothing has been changed\n");

  // Switch to MLFQ mode
  if(mlfqmode() == 0) printf("successfully changed to MLFQ mode!\n");
 11a:	400000ef          	jal	51a <mlfqmode>
 11e:	ed45                	bnez	a0,1d6 <main+0x170>
 120:	00001517          	auipc	a0,0x1
 124:	a0050513          	addi	a0,a0,-1536 # b20 <malloc+0x1ca>
 128:	77a000ef          	jal	8a2 <printf>
  else printf("nothing has been changed\n");

  // [Test 2] MLFQ test
  printf("\n[Test 2] MLFQ Scheduling\n");
 12c:	00001517          	auipc	a0,0x1
 130:	a1c50513          	addi	a0,a0,-1508 # b48 <malloc+0x1f2>
 134:	76e000ef          	jal	8a2 <printf>
  pid = fork_children();
 138:	ec9ff0ef          	jal	0 <fork_children>
 13c:	89aa                	mv	s3,a0

  if (pid != parent)
 13e:	00002797          	auipc	a5,0x2
 142:	ec27a783          	lw	a5,-318(a5) # 2000 <parent>
 146:	06a78063          	beq	a5,a0,1a6 <main+0x140>
 14a:	64e1                	lui	s1,0x18
 14c:	6a048493          	addi	s1,s1,1696 # 186a0 <base+0x164f0>
  {
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x >= MAX_LEVEL)
 150:	4909                	li	s2,2
      int x = getlev();
 152:	3b8000ef          	jal	50a <getlev>
      if (x < 0 || x >= MAX_LEVEL)
 156:	0005079b          	sext.w	a5,a0
 15a:	08f96563          	bltu	s2,a5,1e4 <main+0x17e>
      {
        printf("Wrong level: %d\n", x);
        exit(1);
      }
      count[x]++;
 15e:	050a                	slli	a0,a0,0x2
 160:	fd050793          	addi	a5,a0,-48
 164:	00878533          	add	a0,a5,s0
 168:	ff052783          	lw	a5,-16(a0)
 16c:	2785                	addiw	a5,a5,1
 16e:	fef52823          	sw	a5,-16(a0)
    for (i = 0; i < NUM_LOOP; i++)
 172:	34fd                	addiw	s1,s1,-1
 174:	fcf9                	bnez	s1,152 <main+0xec>
    }

    printf("Process %d (MLFQ L0-L2 hit count):\n", pid);
 176:	85ce                	mv	a1,s3
 178:	00001517          	auipc	a0,0x1
 17c:	a0850513          	addi	a0,a0,-1528 # b80 <malloc+0x22a>
 180:	722000ef          	jal	8a2 <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 184:	fc040913          	addi	s2,s0,-64
      printf("L%d: %d\n", i, count[i]);
 188:	00001a17          	auipc	s4,0x1
 18c:	a20a0a13          	addi	s4,s4,-1504 # ba8 <malloc+0x252>
    for (i = 0; i < MAX_LEVEL; i++)
 190:	498d                	li	s3,3
      printf("L%d: %d\n", i, count[i]);
 192:	00092603          	lw	a2,0(s2)
 196:	85a6                	mv	a1,s1
 198:	8552                	mv	a0,s4
 19a:	708000ef          	jal	8a2 <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 19e:	2485                	addiw	s1,s1,1
 1a0:	0911                	addi	s2,s2,4
 1a2:	ff3498e3          	bne	s1,s3,192 <main+0x12c>
  }
  exit_children();
 1a6:	e89ff0ef          	jal	2e <exit_children>

  printf("[Test 2] MLFQ Test Finished\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	a0e50513          	addi	a0,a0,-1522 # bb8 <malloc+0x262>
 1b2:	6f0000ef          	jal	8a2 <printf>
  printf("\nFCFS & MLFQ test completed!\n");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	a2250513          	addi	a0,a0,-1502 # bd8 <malloc+0x282>
 1be:	6e4000ef          	jal	8a2 <printf>
  exit(0);
 1c2:	4501                	li	a0,0
 1c4:	29e000ef          	jal	462 <exit>
  else printf("nothing has been changed\n");
 1c8:	00001517          	auipc	a0,0x1
 1cc:	93850513          	addi	a0,a0,-1736 # b00 <malloc+0x1aa>
 1d0:	6d2000ef          	jal	8a2 <printf>
 1d4:	b799                	j	11a <main+0xb4>
  else printf("nothing has been changed\n");
 1d6:	00001517          	auipc	a0,0x1
 1da:	92a50513          	addi	a0,a0,-1750 # b00 <malloc+0x1aa>
 1de:	6c4000ef          	jal	8a2 <printf>
 1e2:	b7a9                	j	12c <main+0xc6>
        printf("Wrong level: %d\n", x);
 1e4:	85aa                	mv	a1,a0
 1e6:	00001517          	auipc	a0,0x1
 1ea:	98250513          	addi	a0,a0,-1662 # b68 <malloc+0x212>
 1ee:	6b4000ef          	jal	8a2 <printf>
        exit(1);
 1f2:	4505                	li	a0,1
 1f4:	26e000ef          	jal	462 <exit>

00000000000001f8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e406                	sd	ra,8(sp)
 1fc:	e022                	sd	s0,0(sp)
 1fe:	0800                	addi	s0,sp,16
  extern int main();
  main();
 200:	e67ff0ef          	jal	66 <main>
  exit(0);
 204:	4501                	li	a0,0
 206:	25c000ef          	jal	462 <exit>

000000000000020a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 210:	87aa                	mv	a5,a0
 212:	0585                	addi	a1,a1,1
 214:	0785                	addi	a5,a5,1
 216:	fff5c703          	lbu	a4,-1(a1)
 21a:	fee78fa3          	sb	a4,-1(a5)
 21e:	fb75                	bnez	a4,212 <strcpy+0x8>
    ;
  return os;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret

0000000000000226 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 22c:	00054783          	lbu	a5,0(a0)
 230:	cb91                	beqz	a5,244 <strcmp+0x1e>
 232:	0005c703          	lbu	a4,0(a1)
 236:	00f71763          	bne	a4,a5,244 <strcmp+0x1e>
    p++, q++;
 23a:	0505                	addi	a0,a0,1
 23c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 23e:	00054783          	lbu	a5,0(a0)
 242:	fbe5                	bnez	a5,232 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 244:	0005c503          	lbu	a0,0(a1)
}
 248:	40a7853b          	subw	a0,a5,a0
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret

0000000000000252 <strlen>:

uint
strlen(const char *s)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 258:	00054783          	lbu	a5,0(a0)
 25c:	cf91                	beqz	a5,278 <strlen+0x26>
 25e:	0505                	addi	a0,a0,1
 260:	87aa                	mv	a5,a0
 262:	86be                	mv	a3,a5
 264:	0785                	addi	a5,a5,1
 266:	fff7c703          	lbu	a4,-1(a5)
 26a:	ff65                	bnez	a4,262 <strlen+0x10>
 26c:	40a6853b          	subw	a0,a3,a0
 270:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
  for(n = 0; s[n]; n++)
 278:	4501                	li	a0,0
 27a:	bfe5                	j	272 <strlen+0x20>

000000000000027c <memset>:

void*
memset(void *dst, int c, uint n)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 282:	ca19                	beqz	a2,298 <memset+0x1c>
 284:	87aa                	mv	a5,a0
 286:	1602                	slli	a2,a2,0x20
 288:	9201                	srli	a2,a2,0x20
 28a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 28e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 292:	0785                	addi	a5,a5,1
 294:	fee79de3          	bne	a5,a4,28e <memset+0x12>
  }
  return dst;
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret

000000000000029e <strchr>:

char*
strchr(const char *s, char c)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	cb99                	beqz	a5,2be <strchr+0x20>
    if(*s == c)
 2aa:	00f58763          	beq	a1,a5,2b8 <strchr+0x1a>
  for(; *s; s++)
 2ae:	0505                	addi	a0,a0,1
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	fbfd                	bnez	a5,2aa <strchr+0xc>
      return (char*)s;
  return 0;
 2b6:	4501                	li	a0,0
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
  return 0;
 2be:	4501                	li	a0,0
 2c0:	bfe5                	j	2b8 <strchr+0x1a>

00000000000002c2 <gets>:

char*
gets(char *buf, int max)
{
 2c2:	711d                	addi	sp,sp,-96
 2c4:	ec86                	sd	ra,88(sp)
 2c6:	e8a2                	sd	s0,80(sp)
 2c8:	e4a6                	sd	s1,72(sp)
 2ca:	e0ca                	sd	s2,64(sp)
 2cc:	fc4e                	sd	s3,56(sp)
 2ce:	f852                	sd	s4,48(sp)
 2d0:	f456                	sd	s5,40(sp)
 2d2:	f05a                	sd	s6,32(sp)
 2d4:	ec5e                	sd	s7,24(sp)
 2d6:	1080                	addi	s0,sp,96
 2d8:	8baa                	mv	s7,a0
 2da:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2dc:	892a                	mv	s2,a0
 2de:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e0:	4aa9                	li	s5,10
 2e2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2e4:	89a6                	mv	s3,s1
 2e6:	2485                	addiw	s1,s1,1
 2e8:	0344d663          	bge	s1,s4,314 <gets+0x52>
    cc = read(0, &c, 1);
 2ec:	4605                	li	a2,1
 2ee:	faf40593          	addi	a1,s0,-81
 2f2:	4501                	li	a0,0
 2f4:	186000ef          	jal	47a <read>
    if(cc < 1)
 2f8:	00a05e63          	blez	a0,314 <gets+0x52>
    buf[i++] = c;
 2fc:	faf44783          	lbu	a5,-81(s0)
 300:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 304:	01578763          	beq	a5,s5,312 <gets+0x50>
 308:	0905                	addi	s2,s2,1
 30a:	fd679de3          	bne	a5,s6,2e4 <gets+0x22>
    buf[i++] = c;
 30e:	89a6                	mv	s3,s1
 310:	a011                	j	314 <gets+0x52>
 312:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 314:	99de                	add	s3,s3,s7
 316:	00098023          	sb	zero,0(s3)
  return buf;
}
 31a:	855e                	mv	a0,s7
 31c:	60e6                	ld	ra,88(sp)
 31e:	6446                	ld	s0,80(sp)
 320:	64a6                	ld	s1,72(sp)
 322:	6906                	ld	s2,64(sp)
 324:	79e2                	ld	s3,56(sp)
 326:	7a42                	ld	s4,48(sp)
 328:	7aa2                	ld	s5,40(sp)
 32a:	7b02                	ld	s6,32(sp)
 32c:	6be2                	ld	s7,24(sp)
 32e:	6125                	addi	sp,sp,96
 330:	8082                	ret

0000000000000332 <stat>:

int
stat(const char *n, struct stat *st)
{
 332:	1101                	addi	sp,sp,-32
 334:	ec06                	sd	ra,24(sp)
 336:	e822                	sd	s0,16(sp)
 338:	e04a                	sd	s2,0(sp)
 33a:	1000                	addi	s0,sp,32
 33c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33e:	4581                	li	a1,0
 340:	162000ef          	jal	4a2 <open>
  if(fd < 0)
 344:	02054263          	bltz	a0,368 <stat+0x36>
 348:	e426                	sd	s1,8(sp)
 34a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34c:	85ca                	mv	a1,s2
 34e:	16c000ef          	jal	4ba <fstat>
 352:	892a                	mv	s2,a0
  close(fd);
 354:	8526                	mv	a0,s1
 356:	134000ef          	jal	48a <close>
  return r;
 35a:	64a2                	ld	s1,8(sp)
}
 35c:	854a                	mv	a0,s2
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	6902                	ld	s2,0(sp)
 364:	6105                	addi	sp,sp,32
 366:	8082                	ret
    return -1;
 368:	597d                	li	s2,-1
 36a:	bfcd                	j	35c <stat+0x2a>

000000000000036c <atoi>:

int
atoi(const char *s)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 372:	00054683          	lbu	a3,0(a0)
 376:	fd06879b          	addiw	a5,a3,-48
 37a:	0ff7f793          	zext.b	a5,a5
 37e:	4625                	li	a2,9
 380:	02f66863          	bltu	a2,a5,3b0 <atoi+0x44>
 384:	872a                	mv	a4,a0
  n = 0;
 386:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 388:	0705                	addi	a4,a4,1
 38a:	0025179b          	slliw	a5,a0,0x2
 38e:	9fa9                	addw	a5,a5,a0
 390:	0017979b          	slliw	a5,a5,0x1
 394:	9fb5                	addw	a5,a5,a3
 396:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 39a:	00074683          	lbu	a3,0(a4)
 39e:	fd06879b          	addiw	a5,a3,-48
 3a2:	0ff7f793          	zext.b	a5,a5
 3a6:	fef671e3          	bgeu	a2,a5,388 <atoi+0x1c>
  return n;
}
 3aa:	6422                	ld	s0,8(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret
  n = 0;
 3b0:	4501                	li	a0,0
 3b2:	bfe5                	j	3aa <atoi+0x3e>

00000000000003b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ba:	02b57463          	bgeu	a0,a1,3e2 <memmove+0x2e>
    while(n-- > 0)
 3be:	00c05f63          	blez	a2,3dc <memmove+0x28>
 3c2:	1602                	slli	a2,a2,0x20
 3c4:	9201                	srli	a2,a2,0x20
 3c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 3cc:	0585                	addi	a1,a1,1
 3ce:	0705                	addi	a4,a4,1
 3d0:	fff5c683          	lbu	a3,-1(a1)
 3d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3d8:	fef71ae3          	bne	a4,a5,3cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret
    dst += n;
 3e2:	00c50733          	add	a4,a0,a2
    src += n;
 3e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3e8:	fec05ae3          	blez	a2,3dc <memmove+0x28>
 3ec:	fff6079b          	addiw	a5,a2,-1
 3f0:	1782                	slli	a5,a5,0x20
 3f2:	9381                	srli	a5,a5,0x20
 3f4:	fff7c793          	not	a5,a5
 3f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3fa:	15fd                	addi	a1,a1,-1
 3fc:	177d                	addi	a4,a4,-1
 3fe:	0005c683          	lbu	a3,0(a1)
 402:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 406:	fee79ae3          	bne	a5,a4,3fa <memmove+0x46>
 40a:	bfc9                	j	3dc <memmove+0x28>

000000000000040c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e422                	sd	s0,8(sp)
 410:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 412:	ca05                	beqz	a2,442 <memcmp+0x36>
 414:	fff6069b          	addiw	a3,a2,-1
 418:	1682                	slli	a3,a3,0x20
 41a:	9281                	srli	a3,a3,0x20
 41c:	0685                	addi	a3,a3,1
 41e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 420:	00054783          	lbu	a5,0(a0)
 424:	0005c703          	lbu	a4,0(a1)
 428:	00e79863          	bne	a5,a4,438 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 42c:	0505                	addi	a0,a0,1
    p2++;
 42e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 430:	fed518e3          	bne	a0,a3,420 <memcmp+0x14>
  }
  return 0;
 434:	4501                	li	a0,0
 436:	a019                	j	43c <memcmp+0x30>
      return *p1 - *p2;
 438:	40e7853b          	subw	a0,a5,a4
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret
  return 0;
 442:	4501                	li	a0,0
 444:	bfe5                	j	43c <memcmp+0x30>

0000000000000446 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 446:	1141                	addi	sp,sp,-16
 448:	e406                	sd	ra,8(sp)
 44a:	e022                	sd	s0,0(sp)
 44c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 44e:	f67ff0ef          	jal	3b4 <memmove>
}
 452:	60a2                	ld	ra,8(sp)
 454:	6402                	ld	s0,0(sp)
 456:	0141                	addi	sp,sp,16
 458:	8082                	ret

000000000000045a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 45a:	4885                	li	a7,1
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <exit>:
.global exit
exit:
 li a7, SYS_exit
 462:	4889                	li	a7,2
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <wait>:
.global wait
wait:
 li a7, SYS_wait
 46a:	488d                	li	a7,3
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 472:	4891                	li	a7,4
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <read>:
.global read
read:
 li a7, SYS_read
 47a:	4895                	li	a7,5
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <write>:
.global write
write:
 li a7, SYS_write
 482:	48c1                	li	a7,16
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <close>:
.global close
close:
 li a7, SYS_close
 48a:	48d5                	li	a7,21
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <kill>:
.global kill
kill:
 li a7, SYS_kill
 492:	4899                	li	a7,6
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <exec>:
.global exec
exec:
 li a7, SYS_exec
 49a:	489d                	li	a7,7
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <open>:
.global open
open:
 li a7, SYS_open
 4a2:	48bd                	li	a7,15
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4aa:	48c5                	li	a7,17
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b2:	48c9                	li	a7,18
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ba:	48a1                	li	a7,8
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <link>:
.global link
link:
 li a7, SYS_link
 4c2:	48cd                	li	a7,19
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ca:	48d1                	li	a7,20
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d2:	48a5                	li	a7,9
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <dup>:
.global dup
dup:
 li a7, SYS_dup
 4da:	48a9                	li	a7,10
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e2:	48ad                	li	a7,11
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ea:	48b1                	li	a7,12
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4f2:	48b5                	li	a7,13
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4fa:	48b9                	li	a7,14
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <yield>:
.global yield
yield:
 li a7, SYS_yield
 502:	48d9                	li	a7,22
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 50a:	48dd                	li	a7,23
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 512:	48e1                	li	a7,24
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 51a:	48e5                	li	a7,25
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 522:	48e9                	li	a7,26
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52a:	1101                	addi	sp,sp,-32
 52c:	ec06                	sd	ra,24(sp)
 52e:	e822                	sd	s0,16(sp)
 530:	1000                	addi	s0,sp,32
 532:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 536:	4605                	li	a2,1
 538:	fef40593          	addi	a1,s0,-17
 53c:	f47ff0ef          	jal	482 <write>
}
 540:	60e2                	ld	ra,24(sp)
 542:	6442                	ld	s0,16(sp)
 544:	6105                	addi	sp,sp,32
 546:	8082                	ret

0000000000000548 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 548:	7139                	addi	sp,sp,-64
 54a:	fc06                	sd	ra,56(sp)
 54c:	f822                	sd	s0,48(sp)
 54e:	f426                	sd	s1,40(sp)
 550:	0080                	addi	s0,sp,64
 552:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 554:	c299                	beqz	a3,55a <printint+0x12>
 556:	0805c963          	bltz	a1,5e8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 55a:	2581                	sext.w	a1,a1
  neg = 0;
 55c:	4881                	li	a7,0
 55e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 562:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 564:	2601                	sext.w	a2,a2
 566:	00000517          	auipc	a0,0x0
 56a:	69a50513          	addi	a0,a0,1690 # c00 <digits>
 56e:	883a                	mv	a6,a4
 570:	2705                	addiw	a4,a4,1
 572:	02c5f7bb          	remuw	a5,a1,a2
 576:	1782                	slli	a5,a5,0x20
 578:	9381                	srli	a5,a5,0x20
 57a:	97aa                	add	a5,a5,a0
 57c:	0007c783          	lbu	a5,0(a5)
 580:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 584:	0005879b          	sext.w	a5,a1
 588:	02c5d5bb          	divuw	a1,a1,a2
 58c:	0685                	addi	a3,a3,1
 58e:	fec7f0e3          	bgeu	a5,a2,56e <printint+0x26>
  if(neg)
 592:	00088c63          	beqz	a7,5aa <printint+0x62>
    buf[i++] = '-';
 596:	fd070793          	addi	a5,a4,-48
 59a:	00878733          	add	a4,a5,s0
 59e:	02d00793          	li	a5,45
 5a2:	fef70823          	sb	a5,-16(a4)
 5a6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5aa:	02e05a63          	blez	a4,5de <printint+0x96>
 5ae:	f04a                	sd	s2,32(sp)
 5b0:	ec4e                	sd	s3,24(sp)
 5b2:	fc040793          	addi	a5,s0,-64
 5b6:	00e78933          	add	s2,a5,a4
 5ba:	fff78993          	addi	s3,a5,-1
 5be:	99ba                	add	s3,s3,a4
 5c0:	377d                	addiw	a4,a4,-1
 5c2:	1702                	slli	a4,a4,0x20
 5c4:	9301                	srli	a4,a4,0x20
 5c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ca:	fff94583          	lbu	a1,-1(s2)
 5ce:	8526                	mv	a0,s1
 5d0:	f5bff0ef          	jal	52a <putc>
  while(--i >= 0)
 5d4:	197d                	addi	s2,s2,-1
 5d6:	ff391ae3          	bne	s2,s3,5ca <printint+0x82>
 5da:	7902                	ld	s2,32(sp)
 5dc:	69e2                	ld	s3,24(sp)
}
 5de:	70e2                	ld	ra,56(sp)
 5e0:	7442                	ld	s0,48(sp)
 5e2:	74a2                	ld	s1,40(sp)
 5e4:	6121                	addi	sp,sp,64
 5e6:	8082                	ret
    x = -xx;
 5e8:	40b005bb          	negw	a1,a1
    neg = 1;
 5ec:	4885                	li	a7,1
    x = -xx;
 5ee:	bf85                	j	55e <printint+0x16>

00000000000005f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f0:	711d                	addi	sp,sp,-96
 5f2:	ec86                	sd	ra,88(sp)
 5f4:	e8a2                	sd	s0,80(sp)
 5f6:	e0ca                	sd	s2,64(sp)
 5f8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5fa:	0005c903          	lbu	s2,0(a1)
 5fe:	26090863          	beqz	s2,86e <vprintf+0x27e>
 602:	e4a6                	sd	s1,72(sp)
 604:	fc4e                	sd	s3,56(sp)
 606:	f852                	sd	s4,48(sp)
 608:	f456                	sd	s5,40(sp)
 60a:	f05a                	sd	s6,32(sp)
 60c:	ec5e                	sd	s7,24(sp)
 60e:	e862                	sd	s8,16(sp)
 610:	e466                	sd	s9,8(sp)
 612:	8b2a                	mv	s6,a0
 614:	8a2e                	mv	s4,a1
 616:	8bb2                	mv	s7,a2
  state = 0;
 618:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 61a:	4481                	li	s1,0
 61c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 61e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 622:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 626:	06c00c93          	li	s9,108
 62a:	a005                	j	64a <vprintf+0x5a>
        putc(fd, c0);
 62c:	85ca                	mv	a1,s2
 62e:	855a                	mv	a0,s6
 630:	efbff0ef          	jal	52a <putc>
 634:	a019                	j	63a <vprintf+0x4a>
    } else if(state == '%'){
 636:	03598263          	beq	s3,s5,65a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 63a:	2485                	addiw	s1,s1,1
 63c:	8726                	mv	a4,s1
 63e:	009a07b3          	add	a5,s4,s1
 642:	0007c903          	lbu	s2,0(a5)
 646:	20090c63          	beqz	s2,85e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 64a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 64e:	fe0994e3          	bnez	s3,636 <vprintf+0x46>
      if(c0 == '%'){
 652:	fd579de3          	bne	a5,s5,62c <vprintf+0x3c>
        state = '%';
 656:	89be                	mv	s3,a5
 658:	b7cd                	j	63a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 65a:	00ea06b3          	add	a3,s4,a4
 65e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 662:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 664:	c681                	beqz	a3,66c <vprintf+0x7c>
 666:	9752                	add	a4,a4,s4
 668:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 66c:	03878f63          	beq	a5,s8,6aa <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 670:	05978963          	beq	a5,s9,6c2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 674:	07500713          	li	a4,117
 678:	0ee78363          	beq	a5,a4,75e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 67c:	07800713          	li	a4,120
 680:	12e78563          	beq	a5,a4,7aa <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 684:	07000713          	li	a4,112
 688:	14e78a63          	beq	a5,a4,7dc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 68c:	07300713          	li	a4,115
 690:	18e78a63          	beq	a5,a4,824 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 694:	02500713          	li	a4,37
 698:	04e79563          	bne	a5,a4,6e2 <vprintf+0xf2>
        putc(fd, '%');
 69c:	02500593          	li	a1,37
 6a0:	855a                	mv	a0,s6
 6a2:	e89ff0ef          	jal	52a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bf49                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	e91ff0ef          	jal	548 <printint>
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bfad                	j	63a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6c2:	06400793          	li	a5,100
 6c6:	02f68963          	beq	a3,a5,6f8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ca:	06c00793          	li	a5,108
 6ce:	04f68263          	beq	a3,a5,712 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6d2:	07500793          	li	a5,117
 6d6:	0af68063          	beq	a3,a5,776 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6da:	07800793          	li	a5,120
 6de:	0ef68263          	beq	a3,a5,7c2 <vprintf+0x1d2>
        putc(fd, '%');
 6e2:	02500593          	li	a1,37
 6e6:	855a                	mv	a0,s6
 6e8:	e43ff0ef          	jal	52a <putc>
        putc(fd, c0);
 6ec:	85ca                	mv	a1,s2
 6ee:	855a                	mv	a0,s6
 6f0:	e3bff0ef          	jal	52a <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b791                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e43ff0ef          	jal	548 <printint>
        i += 1;
 70a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
        i += 1;
 710:	b72d                	j	63a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 712:	06400793          	li	a5,100
 716:	02f60763          	beq	a2,a5,744 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 71a:	07500793          	li	a5,117
 71e:	06f60963          	beq	a2,a5,790 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 722:	07800793          	li	a5,120
 726:	faf61ee3          	bne	a2,a5,6e2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72a:	008b8913          	addi	s2,s7,8
 72e:	4681                	li	a3,0
 730:	4641                	li	a2,16
 732:	000ba583          	lw	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e11ff0ef          	jal	548 <printint>
        i += 2;
 73c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
        i += 2;
 742:	bde5                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 744:	008b8913          	addi	s2,s7,8
 748:	4685                	li	a3,1
 74a:	4629                	li	a2,10
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	df7ff0ef          	jal	548 <printint>
        i += 2;
 756:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 758:	8bca                	mv	s7,s2
      state = 0;
 75a:	4981                	li	s3,0
        i += 2;
 75c:	bdf9                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 75e:	008b8913          	addi	s2,s7,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	dddff0ef          	jal	548 <printint>
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
 774:	b5d9                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 776:	008b8913          	addi	s2,s7,8
 77a:	4681                	li	a3,0
 77c:	4629                	li	a2,10
 77e:	000ba583          	lw	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	dc5ff0ef          	jal	548 <printint>
        i += 1;
 788:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	8bca                	mv	s7,s2
      state = 0;
 78c:	4981                	li	s3,0
        i += 1;
 78e:	b575                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 790:	008b8913          	addi	s2,s7,8
 794:	4681                	li	a3,0
 796:	4629                	li	a2,10
 798:	000ba583          	lw	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	dabff0ef          	jal	548 <printint>
        i += 2;
 7a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a4:	8bca                	mv	s7,s2
      state = 0;
 7a6:	4981                	li	s3,0
        i += 2;
 7a8:	bd49                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7aa:	008b8913          	addi	s2,s7,8
 7ae:	4681                	li	a3,0
 7b0:	4641                	li	a2,16
 7b2:	000ba583          	lw	a1,0(s7)
 7b6:	855a                	mv	a0,s6
 7b8:	d91ff0ef          	jal	548 <printint>
 7bc:	8bca                	mv	s7,s2
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bdad                	j	63a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c2:	008b8913          	addi	s2,s7,8
 7c6:	4681                	li	a3,0
 7c8:	4641                	li	a2,16
 7ca:	000ba583          	lw	a1,0(s7)
 7ce:	855a                	mv	a0,s6
 7d0:	d79ff0ef          	jal	548 <printint>
        i += 1;
 7d4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d6:	8bca                	mv	s7,s2
      state = 0;
 7d8:	4981                	li	s3,0
        i += 1;
 7da:	b585                	j	63a <vprintf+0x4a>
 7dc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7de:	008b8d13          	addi	s10,s7,8
 7e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e6:	03000593          	li	a1,48
 7ea:	855a                	mv	a0,s6
 7ec:	d3fff0ef          	jal	52a <putc>
  putc(fd, 'x');
 7f0:	07800593          	li	a1,120
 7f4:	855a                	mv	a0,s6
 7f6:	d35ff0ef          	jal	52a <putc>
 7fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fc:	00000b97          	auipc	s7,0x0
 800:	404b8b93          	addi	s7,s7,1028 # c00 <digits>
 804:	03c9d793          	srli	a5,s3,0x3c
 808:	97de                	add	a5,a5,s7
 80a:	0007c583          	lbu	a1,0(a5)
 80e:	855a                	mv	a0,s6
 810:	d1bff0ef          	jal	52a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 814:	0992                	slli	s3,s3,0x4
 816:	397d                	addiw	s2,s2,-1
 818:	fe0916e3          	bnez	s2,804 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 81c:	8bea                	mv	s7,s10
      state = 0;
 81e:	4981                	li	s3,0
 820:	6d02                	ld	s10,0(sp)
 822:	bd21                	j	63a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 824:	008b8993          	addi	s3,s7,8
 828:	000bb903          	ld	s2,0(s7)
 82c:	00090f63          	beqz	s2,84a <vprintf+0x25a>
        for(; *s; s++)
 830:	00094583          	lbu	a1,0(s2)
 834:	c195                	beqz	a1,858 <vprintf+0x268>
          putc(fd, *s);
 836:	855a                	mv	a0,s6
 838:	cf3ff0ef          	jal	52a <putc>
        for(; *s; s++)
 83c:	0905                	addi	s2,s2,1
 83e:	00094583          	lbu	a1,0(s2)
 842:	f9f5                	bnez	a1,836 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 844:	8bce                	mv	s7,s3
      state = 0;
 846:	4981                	li	s3,0
 848:	bbcd                	j	63a <vprintf+0x4a>
          s = "(null)";
 84a:	00000917          	auipc	s2,0x0
 84e:	3ae90913          	addi	s2,s2,942 # bf8 <malloc+0x2a2>
        for(; *s; s++)
 852:	02800593          	li	a1,40
 856:	b7c5                	j	836 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 858:	8bce                	mv	s7,s3
      state = 0;
 85a:	4981                	li	s3,0
 85c:	bbf9                	j	63a <vprintf+0x4a>
 85e:	64a6                	ld	s1,72(sp)
 860:	79e2                	ld	s3,56(sp)
 862:	7a42                	ld	s4,48(sp)
 864:	7aa2                	ld	s5,40(sp)
 866:	7b02                	ld	s6,32(sp)
 868:	6be2                	ld	s7,24(sp)
 86a:	6c42                	ld	s8,16(sp)
 86c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 86e:	60e6                	ld	ra,88(sp)
 870:	6446                	ld	s0,80(sp)
 872:	6906                	ld	s2,64(sp)
 874:	6125                	addi	sp,sp,96
 876:	8082                	ret

0000000000000878 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 878:	715d                	addi	sp,sp,-80
 87a:	ec06                	sd	ra,24(sp)
 87c:	e822                	sd	s0,16(sp)
 87e:	1000                	addi	s0,sp,32
 880:	e010                	sd	a2,0(s0)
 882:	e414                	sd	a3,8(s0)
 884:	e818                	sd	a4,16(s0)
 886:	ec1c                	sd	a5,24(s0)
 888:	03043023          	sd	a6,32(s0)
 88c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 890:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 894:	8622                	mv	a2,s0
 896:	d5bff0ef          	jal	5f0 <vprintf>
}
 89a:	60e2                	ld	ra,24(sp)
 89c:	6442                	ld	s0,16(sp)
 89e:	6161                	addi	sp,sp,80
 8a0:	8082                	ret

00000000000008a2 <printf>:

void
printf(const char *fmt, ...)
{
 8a2:	711d                	addi	sp,sp,-96
 8a4:	ec06                	sd	ra,24(sp)
 8a6:	e822                	sd	s0,16(sp)
 8a8:	1000                	addi	s0,sp,32
 8aa:	e40c                	sd	a1,8(s0)
 8ac:	e810                	sd	a2,16(s0)
 8ae:	ec14                	sd	a3,24(s0)
 8b0:	f018                	sd	a4,32(s0)
 8b2:	f41c                	sd	a5,40(s0)
 8b4:	03043823          	sd	a6,48(s0)
 8b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	00840613          	addi	a2,s0,8
 8c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c4:	85aa                	mv	a1,a0
 8c6:	4505                	li	a0,1
 8c8:	d29ff0ef          	jal	5f0 <vprintf>
}
 8cc:	60e2                	ld	ra,24(sp)
 8ce:	6442                	ld	s0,16(sp)
 8d0:	6125                	addi	sp,sp,96
 8d2:	8082                	ret

00000000000008d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d4:	1141                	addi	sp,sp,-16
 8d6:	e422                	sd	s0,8(sp)
 8d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	00001797          	auipc	a5,0x1
 8e2:	72a7b783          	ld	a5,1834(a5) # 2008 <freep>
 8e6:	a02d                	j	910 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e8:	4618                	lw	a4,8(a2)
 8ea:	9f2d                	addw	a4,a4,a1
 8ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	6398                	ld	a4,0(a5)
 8f2:	6310                	ld	a2,0(a4)
 8f4:	a83d                	j	932 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f6:	ff852703          	lw	a4,-8(a0)
 8fa:	9f31                	addw	a4,a4,a2
 8fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8fe:	ff053683          	ld	a3,-16(a0)
 902:	a091                	j	946 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 904:	6398                	ld	a4,0(a5)
 906:	00e7e463          	bltu	a5,a4,90e <free+0x3a>
 90a:	00e6ea63          	bltu	a3,a4,91e <free+0x4a>
{
 90e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 910:	fed7fae3          	bgeu	a5,a3,904 <free+0x30>
 914:	6398                	ld	a4,0(a5)
 916:	00e6e463          	bltu	a3,a4,91e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91a:	fee7eae3          	bltu	a5,a4,90e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 91e:	ff852583          	lw	a1,-8(a0)
 922:	6390                	ld	a2,0(a5)
 924:	02059813          	slli	a6,a1,0x20
 928:	01c85713          	srli	a4,a6,0x1c
 92c:	9736                	add	a4,a4,a3
 92e:	fae60de3          	beq	a2,a4,8e8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 932:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 936:	4790                	lw	a2,8(a5)
 938:	02061593          	slli	a1,a2,0x20
 93c:	01c5d713          	srli	a4,a1,0x1c
 940:	973e                	add	a4,a4,a5
 942:	fae68ae3          	beq	a3,a4,8f6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 946:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 948:	00001717          	auipc	a4,0x1
 94c:	6cf73023          	sd	a5,1728(a4) # 2008 <freep>
}
 950:	6422                	ld	s0,8(sp)
 952:	0141                	addi	sp,sp,16
 954:	8082                	ret

0000000000000956 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 956:	7139                	addi	sp,sp,-64
 958:	fc06                	sd	ra,56(sp)
 95a:	f822                	sd	s0,48(sp)
 95c:	f426                	sd	s1,40(sp)
 95e:	ec4e                	sd	s3,24(sp)
 960:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 962:	02051493          	slli	s1,a0,0x20
 966:	9081                	srli	s1,s1,0x20
 968:	04bd                	addi	s1,s1,15
 96a:	8091                	srli	s1,s1,0x4
 96c:	0014899b          	addiw	s3,s1,1
 970:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 972:	00001517          	auipc	a0,0x1
 976:	69653503          	ld	a0,1686(a0) # 2008 <freep>
 97a:	c915                	beqz	a0,9ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97e:	4798                	lw	a4,8(a5)
 980:	08977a63          	bgeu	a4,s1,a14 <malloc+0xbe>
 984:	f04a                	sd	s2,32(sp)
 986:	e852                	sd	s4,16(sp)
 988:	e456                	sd	s5,8(sp)
 98a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 98c:	8a4e                	mv	s4,s3
 98e:	0009871b          	sext.w	a4,s3
 992:	6685                	lui	a3,0x1
 994:	00d77363          	bgeu	a4,a3,99a <malloc+0x44>
 998:	6a05                	lui	s4,0x1
 99a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 99e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a2:	00001917          	auipc	s2,0x1
 9a6:	66690913          	addi	s2,s2,1638 # 2008 <freep>
  if(p == (char*)-1)
 9aa:	5afd                	li	s5,-1
 9ac:	a081                	j	9ec <malloc+0x96>
 9ae:	f04a                	sd	s2,32(sp)
 9b0:	e852                	sd	s4,16(sp)
 9b2:	e456                	sd	s5,8(sp)
 9b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9b6:	00001797          	auipc	a5,0x1
 9ba:	7fa78793          	addi	a5,a5,2042 # 21b0 <base>
 9be:	00001717          	auipc	a4,0x1
 9c2:	64f73523          	sd	a5,1610(a4) # 2008 <freep>
 9c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9cc:	b7c1                	j	98c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9ce:	6398                	ld	a4,0(a5)
 9d0:	e118                	sd	a4,0(a0)
 9d2:	a8a9                	j	a2c <malloc+0xd6>
  hp->s.size = nu;
 9d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d8:	0541                	addi	a0,a0,16
 9da:	efbff0ef          	jal	8d4 <free>
  return freep;
 9de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9e2:	c12d                	beqz	a0,a44 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e6:	4798                	lw	a4,8(a5)
 9e8:	02977263          	bgeu	a4,s1,a0c <malloc+0xb6>
    if(p == freep)
 9ec:	00093703          	ld	a4,0(s2)
 9f0:	853e                	mv	a0,a5
 9f2:	fef719e3          	bne	a4,a5,9e4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9f6:	8552                	mv	a0,s4
 9f8:	af3ff0ef          	jal	4ea <sbrk>
  if(p == (char*)-1)
 9fc:	fd551ce3          	bne	a0,s5,9d4 <malloc+0x7e>
        return 0;
 a00:	4501                	li	a0,0
 a02:	7902                	ld	s2,32(sp)
 a04:	6a42                	ld	s4,16(sp)
 a06:	6aa2                	ld	s5,8(sp)
 a08:	6b02                	ld	s6,0(sp)
 a0a:	a03d                	j	a38 <malloc+0xe2>
 a0c:	7902                	ld	s2,32(sp)
 a0e:	6a42                	ld	s4,16(sp)
 a10:	6aa2                	ld	s5,8(sp)
 a12:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a14:	fae48de3          	beq	s1,a4,9ce <malloc+0x78>
        p->s.size -= nunits;
 a18:	4137073b          	subw	a4,a4,s3
 a1c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a1e:	02071693          	slli	a3,a4,0x20
 a22:	01c6d713          	srli	a4,a3,0x1c
 a26:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a28:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a2c:	00001717          	auipc	a4,0x1
 a30:	5ca73e23          	sd	a0,1500(a4) # 2008 <freep>
      return (void*)(p + 1);
 a34:	01078513          	addi	a0,a5,16
  }
}
 a38:	70e2                	ld	ra,56(sp)
 a3a:	7442                	ld	s0,48(sp)
 a3c:	74a2                	ld	s1,40(sp)
 a3e:	69e2                	ld	s3,24(sp)
 a40:	6121                	addi	sp,sp,64
 a42:	8082                	ret
 a44:	7902                	ld	s2,32(sp)
 a46:	6a42                	ld	s4,16(sp)
 a48:	6aa2                	ld	s5,8(sp)
 a4a:	6b02                	ld	s6,0(sp)
 a4c:	b7f5                	j	a38 <malloc+0xe2>
