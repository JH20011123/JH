
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	4b013103          	ld	sp,1200(sp) # 8000a4b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda8b7>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	4ad010ef          	jal	80001da6 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00012517          	auipc	a0,0x12
    80000158:	3bc50513          	addi	a0,a0,956 # 80012510 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	3b048493          	addi	s1,s1,944 # 80012510 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	44090913          	addi	s2,s2,1088 # 800125a8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	6aa010ef          	jal	8000182a <myproc>
    80000184:	2b5010ef          	jal	80001c38 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	23b010ef          	jal	80001bc8 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	37070713          	addi	a4,a4,880 # 80012510 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	38b010ef          	jal	80001d5c <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00012517          	auipc	a0,0x12
    800001ee:	32650513          	addi	a0,a0,806 # 80012510 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00012717          	auipc	a4,0x12
    80000218:	38f72a23          	sw	a5,916(a4) # 800125a8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	2e650513          	addi	a0,a0,742 # 80012510 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00012517          	auipc	a0,0x12
    80000282:	29250513          	addi	a0,a0,658 # 80012510 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002a0:	351010ef          	jal	80001df0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	00012517          	auipc	a0,0x12
    800002a8:	26c50513          	addi	a0,a0,620 # 80012510 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	00012717          	auipc	a4,0x12
    800002c6:	24e70713          	addi	a4,a4,590 # 80012510 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	00012797          	auipc	a5,0x12
    800002ec:	22878793          	addi	a5,a5,552 # 80012510 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	00012797          	auipc	a5,0x12
    8000031a:	2927a783          	lw	a5,658(a5) # 800125a8 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	00012717          	auipc	a4,0x12
    80000330:	1e470713          	addi	a4,a4,484 # 80012510 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	00012497          	auipc	s1,0x12
    80000340:	1d448493          	addi	s1,s1,468 # 80012510 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	00012717          	auipc	a4,0x12
    80000382:	19270713          	addi	a4,a4,402 # 80012510 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	00012717          	auipc	a4,0x12
    80000398:	20f72e23          	sw	a5,540(a4) # 800125b0 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	00012797          	auipc	a5,0x12
    800003b6:	15e78793          	addi	a5,a5,350 # 80012510 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	00012797          	auipc	a5,0x12
    800003da:	1cc7ab23          	sw	a2,470(a5) # 800125ac <cons+0x9c>
        wakeup(&cons.r);
    800003de:	00012517          	auipc	a0,0x12
    800003e2:	1ca50513          	addi	a0,a0,458 # 800125a8 <cons+0x98>
    800003e6:	6d1010ef          	jal	800022b6 <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00007597          	auipc	a1,0x7
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80007000 <etext>
    800003fc:	00012517          	auipc	a0,0x12
    80000400:	11450513          	addi	a0,a0,276 # 80012510 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00023797          	auipc	a5,0x23
    80000410:	9a478793          	addi	a5,a5,-1628 # 80022db0 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7179                	addi	sp,sp,-48
    80000432:	f406                	sd	ra,40(sp)
    80000434:	f022                	sd	s0,32(sp)
    80000436:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00007617          	auipc	a2,0x7
    8000044a:	38a60613          	addi	a2,a2,906 # 800077d0 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78823          	sb	a4,-16(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	ec26                	sd	s1,24(sp)
    80000486:	e84a                	sd	s2,16(sp)
    80000488:	fd040713          	addi	a4,s0,-48
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	64e2                	ld	s1,24(sp)
    800004b0:	6942                	ld	s2,16(sp)
}
    800004b2:	70a2                	ld	ra,40(sp)
    800004b4:	7402                	ld	s0,32(sp)
    800004b6:	6145                	addi	sp,sp,48
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	00012797          	auipc	a5,0x12
    800004e4:	0f07a783          	lw	a5,240(a5) # 800125d0 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	00012517          	auipc	a0,0x12
    80000530:	08c50513          	addi	a0,a0,140 # 800125b8 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00007b97          	auipc	s7,0x7
    800006f0:	0e4b8b93          	addi	s7,s7,228 # 800077d0 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00007917          	auipc	s2,0x7
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	00012517          	auipc	a0,0x12
    8000078a:	e3250513          	addi	a0,a0,-462 # 800125b8 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	00012797          	auipc	a5,0x12
    800007a4:	e207a823          	sw	zero,-464(a5) # 800125d0 <pr+0x18>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87050513          	addi	a0,a0,-1936 # 80007018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	0000a717          	auipc	a4,0xa
    800007c8:	d0f72623          	sw	a5,-756(a4) # 8000a4d0 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	00012497          	auipc	s1,0x12
    800007dc:	de048493          	addi	s1,s1,-544 # 800125b8 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00006597          	auipc	a1,0x6
    8000083c:	7f858593          	addi	a1,a1,2040 # 80007030 <etext+0x30>
    80000840:	00012517          	auipc	a0,0x12
    80000844:	d9850513          	addi	a0,a0,-616 # 800125d8 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	0000a797          	auipc	a5,0xa
    80000868:	c6c7a783          	lw	a5,-916(a5) # 8000a4d0 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	0000a797          	auipc	a5,0xa
    8000089e:	c3e7b783          	ld	a5,-962(a5) # 8000a4d8 <uart_tx_r>
    800008a2:	0000a717          	auipc	a4,0xa
    800008a6:	c3e73703          	ld	a4,-962(a4) # 8000a4e0 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	00012a97          	auipc	s5,0x12
    800008cc:	d10a8a93          	addi	s5,s5,-752 # 800125d8 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	0000a497          	auipc	s1,0xa
    800008d4:	c0848493          	addi	s1,s1,-1016 # 8000a4d8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	0000a997          	auipc	s3,0xa
    800008e0:	c0498993          	addi	s3,s3,-1020 # 8000a4e0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	1b9010ef          	jal	800022b6 <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	00012517          	auipc	a0,0x12
    80000950:	c8c50513          	addi	a0,a0,-884 # 800125d8 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	0000a797          	auipc	a5,0xa
    8000095c:	b787a783          	lw	a5,-1160(a5) # 8000a4d0 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	0000a717          	auipc	a4,0xa
    80000966:	b7e73703          	ld	a4,-1154(a4) # 8000a4e0 <uart_tx_w>
    8000096a:	0000a797          	auipc	a5,0xa
    8000096e:	b6e7b783          	ld	a5,-1170(a5) # 8000a4d8 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	00012997          	auipc	s3,0x12
    8000097a:	c6298993          	addi	s3,s3,-926 # 800125d8 <uart_tx_lock>
    8000097e:	0000a497          	auipc	s1,0xa
    80000982:	b5a48493          	addi	s1,s1,-1190 # 8000a4d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	0000a917          	auipc	s2,0xa
    8000098a:	b5a90913          	addi	s2,s2,-1190 # 8000a4e0 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	232010ef          	jal	80001bc8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	c3048493          	addi	s1,s1,-976 # 800125d8 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	0000a797          	auipc	a5,0xa
    800009c0:	b2e7b223          	sd	a4,-1244(a5) # 8000a4e0 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	00012497          	auipc	s1,0x12
    80000a24:	bb848493          	addi	s1,s1,-1096 # 800125d8 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00023797          	auipc	a5,0x23
    80000a5a:	4f278793          	addi	a5,a5,1266 # 80023f48 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	00012917          	auipc	s2,0x12
    80000a76:	b9e90913          	addi	s2,s2,-1122 # 80012610 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00006517          	auipc	a0,0x6
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80007038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00006597          	auipc	a1,0x6
    80000afc:	54858593          	addi	a1,a1,1352 # 80007040 <etext+0x40>
    80000b00:	00012517          	auipc	a0,0x12
    80000b04:	b1050513          	addi	a0,a0,-1264 # 80012610 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00023517          	auipc	a0,0x23
    80000b14:	43850513          	addi	a0,a0,1080 # 80023f48 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	00012497          	auipc	s1,0x12
    80000b32:	ae248493          	addi	s1,s1,-1310 # 80012610 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00012517          	auipc	a0,0x12
    80000b46:	ace50513          	addi	a0,a0,-1330 # 80012610 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	00012517          	auipc	a0,0x12
    80000b6a:	aaa50513          	addi	a0,a0,-1366 # 80012610 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	471000ef          	jal	8000180e <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	443000ef          	jal	8000180e <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	43b000ef          	jal	8000180e <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	427000ef          	jal	8000180e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk))
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk))
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c1c:	3f3000ef          	jal	8000180e <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	41c50513          	addi	a0,a0,1052 # 80007048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	3cf000ef          	jal	8000180e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00006517          	auipc	a0,0x6
    80000c78:	3dc50513          	addi	a0,a0,988 # 80007050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00006517          	auipc	a0,0x6
    80000c84:	3e850513          	addi	a0,a0,1000 # 80007068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000ca6:	0310000f          	fence	rw,w
    80000caa:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00006517          	auipc	a0,0x6
    80000cc0:	3b450513          	addi	a0,a0,948 # 80007070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb0b9>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	195000ef          	jal	800017fe <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	00009717          	auipc	a4,0x9
    80000e72:	67a70713          	addi	a4,a4,1658 # 8000a4e8 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e82:	17d000ef          	jal	800017fe <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	263010ef          	jal	800028fa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	1fd040ef          	jal	80005898 <plicinithart>
  }

  scheduler();        
    80000ea0:	670010ef          	jal	80002510 <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00006517          	auipc	a0,0x6
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80007078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00006517          	auipc	a0,0x6
    80000ebc:	1c850513          	addi	a0,a0,456 # 80007080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	1b450513          	addi	a0,a0,436 # 80007078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	2ca000ef          	jal	8000119e <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	03c000ef          	jal	80000f14 <kvminithart>
    procinit();      // process table
    80000edc:	020010ef          	jal	80001efc <procinit>
    trapinit();      // trap vectors
    80000ee0:	1f7010ef          	jal	800028d6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	217010ef          	jal	800028fa <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	197040ef          	jal	8000587e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	1ad040ef          	jal	80005898 <plicinithart>
    binit();         // buffer cache
    80000ef0:	14c020ef          	jal	8000303c <binit>
    iinit();         // inode table
    80000ef4:	73e020ef          	jal	80003632 <iinit>
    fileinit();      // file table
    80000ef8:	4ea030ef          	jal	800043e2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	28d040ef          	jal	80005988 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	1fc010ef          	jal	800020fc <userinit>
    __sync_synchronize();
    80000f04:	0330000f          	fence	rw,rw
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	00009717          	auipc	a4,0x9
    80000f0e:	5cf72f23          	sw	a5,1502(a4) # 8000a4e8 <started>
    80000f12:	b779                	j	80000ea0 <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	00009797          	auipc	a5,0x9
    80000f22:	5d27b783          	ld	a5,1490(a5) # 8000a4f0 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3c:	7139                	addi	sp,sp,-64
    80000f3e:	fc06                	sd	ra,56(sp)
    80000f40:	f822                	sd	s0,48(sp)
    80000f42:	f426                	sd	s1,40(sp)
    80000f44:	f04a                	sd	s2,32(sp)
    80000f46:	ec4e                	sd	s3,24(sp)
    80000f48:	e852                	sd	s4,16(sp)
    80000f4a:	e456                	sd	s5,8(sp)
    80000f4c:	e05a                	sd	s6,0(sp)
    80000f4e:	0080                	addi	s0,sp,64
    80000f50:	84aa                	mv	s1,a0
    80000f52:	89ae                	mv	s3,a1
    80000f54:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f56:	57fd                	li	a5,-1
    80000f58:	83e9                	srli	a5,a5,0x1a
    80000f5a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5c:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5e:	02b7fc63          	bgeu	a5,a1,80000f96 <walk+0x5a>
    panic("walk");
    80000f62:	00006517          	auipc	a0,0x6
    80000f66:	14e50513          	addi	a0,a0,334 # 800070b0 <etext+0xb0>
    80000f6a:	82bff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6e:	060a8263          	beqz	s5,80000fd2 <walk+0x96>
    80000f72:	bb3ff0ef          	jal	80000b24 <kalloc>
    80000f76:	84aa                	mv	s1,a0
    80000f78:	c139                	beqz	a0,80000fbe <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	4581                	li	a1,0
    80000f7e:	d4bff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f82:	00c4d793          	srli	a5,s1,0xc
    80000f86:	07aa                	slli	a5,a5,0xa
    80000f88:	0017e793          	ori	a5,a5,1
    80000f8c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb0af>
    80000f92:	036a0063          	beq	s4,s6,80000fb2 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f96:	0149d933          	srl	s2,s3,s4
    80000f9a:	1ff97913          	andi	s2,s2,511
    80000f9e:	090e                	slli	s2,s2,0x3
    80000fa0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa2:	00093483          	ld	s1,0(s2)
    80000fa6:	0014f793          	andi	a5,s1,1
    80000faa:	d3f1                	beqz	a5,80000f6e <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fac:	80a9                	srli	s1,s1,0xa
    80000fae:	04b2                	slli	s1,s1,0xc
    80000fb0:	b7c5                	j	80000f90 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb2:	00c9d513          	srli	a0,s3,0xc
    80000fb6:	1ff57513          	andi	a0,a0,511
    80000fba:	050e                	slli	a0,a0,0x3
    80000fbc:	9526                	add	a0,a0,s1
}
    80000fbe:	70e2                	ld	ra,56(sp)
    80000fc0:	7442                	ld	s0,48(sp)
    80000fc2:	74a2                	ld	s1,40(sp)
    80000fc4:	7902                	ld	s2,32(sp)
    80000fc6:	69e2                	ld	s3,24(sp)
    80000fc8:	6a42                	ld	s4,16(sp)
    80000fca:	6aa2                	ld	s5,8(sp)
    80000fcc:	6b02                	ld	s6,0(sp)
    80000fce:	6121                	addi	sp,sp,64
    80000fd0:	8082                	ret
        return 0;
    80000fd2:	4501                	li	a0,0
    80000fd4:	b7ed                	j	80000fbe <walk+0x82>

0000000080000fd6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fd6:	57fd                	li	a5,-1
    80000fd8:	83e9                	srli	a5,a5,0x1a
    80000fda:	00b7f463          	bgeu	a5,a1,80000fe2 <walkaddr+0xc>
    return 0;
    80000fde:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe0:	8082                	ret
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fea:	4601                	li	a2,0
    80000fec:	f51ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80000ff0:	c105                	beqz	a0,80001010 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff4:	0117f693          	andi	a3,a5,17
    80000ff8:	4745                	li	a4,17
    return 0;
    80000ffa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ffc:	00e68663          	beq	a3,a4,80001008 <walkaddr+0x32>
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
  pa = PTE2PA(*pte);
    80001008:	83a9                	srli	a5,a5,0xa
    8000100a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000100e:	bfcd                	j	80001000 <walkaddr+0x2a>
    return 0;
    80001010:	4501                	li	a0,0
    80001012:	b7fd                	j	80001000 <walkaddr+0x2a>

0000000080001014 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001014:	715d                	addi	sp,sp,-80
    80001016:	e486                	sd	ra,72(sp)
    80001018:	e0a2                	sd	s0,64(sp)
    8000101a:	fc26                	sd	s1,56(sp)
    8000101c:	f84a                	sd	s2,48(sp)
    8000101e:	f44e                	sd	s3,40(sp)
    80001020:	f052                	sd	s4,32(sp)
    80001022:	ec56                	sd	s5,24(sp)
    80001024:	e85a                	sd	s6,16(sp)
    80001026:	e45e                	sd	s7,8(sp)
    80001028:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000102a:	03459793          	slli	a5,a1,0x34
    8000102e:	e7a9                	bnez	a5,80001078 <mappages+0x64>
    80001030:	8aaa                	mv	s5,a0
    80001032:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001034:	03461793          	slli	a5,a2,0x34
    80001038:	e7b1                	bnez	a5,80001084 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000103a:	ca39                	beqz	a2,80001090 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000103c:	77fd                	lui	a5,0xfffff
    8000103e:	963e                	add	a2,a2,a5
    80001040:	00b609b3          	add	s3,a2,a1
  a = va;
    80001044:	892e                	mv	s2,a1
    80001046:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000104a:	6b85                	lui	s7,0x1
    8000104c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	4605                	li	a2,1
    80001052:	85ca                	mv	a1,s2
    80001054:	8556                	mv	a0,s5
    80001056:	ee7ff0ef          	jal	80000f3c <walk>
    8000105a:	c539                	beqz	a0,800010a8 <mappages+0x94>
    if(*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	ef95                	bnez	a5,8000109c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	80b1                	srli	s1,s1,0xc
    80001064:	04aa                	slli	s1,s1,0xa
    80001066:	0164e4b3          	or	s1,s1,s6
    8000106a:	0014e493          	ori	s1,s1,1
    8000106e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001070:	05390863          	beq	s2,s3,800010c0 <mappages+0xac>
    a += PGSIZE;
    80001074:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001076:	bfd9                	j	8000104c <mappages+0x38>
    panic("mappages: va not aligned");
    80001078:	00006517          	auipc	a0,0x6
    8000107c:	04050513          	addi	a0,a0,64 # 800070b8 <etext+0xb8>
    80001080:	f14ff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    80001084:	00006517          	auipc	a0,0x6
    80001088:	05450513          	addi	a0,a0,84 # 800070d8 <etext+0xd8>
    8000108c:	f08ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    80001090:	00006517          	auipc	a0,0x6
    80001094:	06850513          	addi	a0,a0,104 # 800070f8 <etext+0xf8>
    80001098:	efcff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    8000109c:	00006517          	auipc	a0,0x6
    800010a0:	06c50513          	addi	a0,a0,108 # 80007108 <etext+0x108>
    800010a4:	ef0ff0ef          	jal	80000794 <panic>
      return -1;
    800010a8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010aa:	60a6                	ld	ra,72(sp)
    800010ac:	6406                	ld	s0,64(sp)
    800010ae:	74e2                	ld	s1,56(sp)
    800010b0:	7942                	ld	s2,48(sp)
    800010b2:	79a2                	ld	s3,40(sp)
    800010b4:	7a02                	ld	s4,32(sp)
    800010b6:	6ae2                	ld	s5,24(sp)
    800010b8:	6b42                	ld	s6,16(sp)
    800010ba:	6ba2                	ld	s7,8(sp)
    800010bc:	6161                	addi	sp,sp,80
    800010be:	8082                	ret
  return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	b7e5                	j	800010aa <mappages+0x96>

00000000800010c4 <kvmmap>:
{
    800010c4:	1141                	addi	sp,sp,-16
    800010c6:	e406                	sd	ra,8(sp)
    800010c8:	e022                	sd	s0,0(sp)
    800010ca:	0800                	addi	s0,sp,16
    800010cc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010ce:	86b2                	mv	a3,a2
    800010d0:	863e                	mv	a2,a5
    800010d2:	f43ff0ef          	jal	80001014 <mappages>
    800010d6:	e509                	bnez	a0,800010e0 <kvmmap+0x1c>
}
    800010d8:	60a2                	ld	ra,8(sp)
    800010da:	6402                	ld	s0,0(sp)
    800010dc:	0141                	addi	sp,sp,16
    800010de:	8082                	ret
    panic("kvmmap");
    800010e0:	00006517          	auipc	a0,0x6
    800010e4:	03850513          	addi	a0,a0,56 # 80007118 <etext+0x118>
    800010e8:	eacff0ef          	jal	80000794 <panic>

00000000800010ec <kvmmake>:
{
    800010ec:	1101                	addi	sp,sp,-32
    800010ee:	ec06                	sd	ra,24(sp)
    800010f0:	e822                	sd	s0,16(sp)
    800010f2:	e426                	sd	s1,8(sp)
    800010f4:	e04a                	sd	s2,0(sp)
    800010f6:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f8:	a2dff0ef          	jal	80000b24 <kalloc>
    800010fc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fe:	6605                	lui	a2,0x1
    80001100:	4581                	li	a1,0
    80001102:	bc7ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001106:	4719                	li	a4,6
    80001108:	6685                	lui	a3,0x1
    8000110a:	10000637          	lui	a2,0x10000
    8000110e:	100005b7          	lui	a1,0x10000
    80001112:	8526                	mv	a0,s1
    80001114:	fb1ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	100015b7          	lui	a1,0x10001
    80001124:	8526                	mv	a0,s1
    80001126:	f9fff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112a:	4719                	li	a4,6
    8000112c:	040006b7          	lui	a3,0x4000
    80001130:	0c000637          	lui	a2,0xc000
    80001134:	0c0005b7          	lui	a1,0xc000
    80001138:	8526                	mv	a0,s1
    8000113a:	f8bff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000113e:	00006917          	auipc	s2,0x6
    80001142:	ec290913          	addi	s2,s2,-318 # 80007000 <etext>
    80001146:	4729                	li	a4,10
    80001148:	80006697          	auipc	a3,0x80006
    8000114c:	eb868693          	addi	a3,a3,-328 # 7000 <_entry-0x7fff9000>
    80001150:	4605                	li	a2,1
    80001152:	067e                	slli	a2,a2,0x1f
    80001154:	85b2                	mv	a1,a2
    80001156:	8526                	mv	a0,s1
    80001158:	f6dff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000115c:	46c5                	li	a3,17
    8000115e:	06ee                	slli	a3,a3,0x1b
    80001160:	4719                	li	a4,6
    80001162:	412686b3          	sub	a3,a3,s2
    80001166:	864a                	mv	a2,s2
    80001168:	85ca                	mv	a1,s2
    8000116a:	8526                	mv	a0,s1
    8000116c:	f59ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001170:	4729                	li	a4,10
    80001172:	6685                	lui	a3,0x1
    80001174:	00005617          	auipc	a2,0x5
    80001178:	e8c60613          	addi	a2,a2,-372 # 80006000 <_trampoline>
    8000117c:	040005b7          	lui	a1,0x4000
    80001180:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001182:	05b2                	slli	a1,a1,0xc
    80001184:	8526                	mv	a0,s1
    80001186:	f3fff0ef          	jal	800010c4 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118a:	8526                	mv	a0,s1
    8000118c:	5da000ef          	jal	80001766 <proc_mapstacks>
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f47ff0ef          	jal	800010ec <kvmmake>
    800011aa:	00009797          	auipc	a5,0x9
    800011ae:	34a7b323          	sd	a0,838(a5) # 8000a4f0 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	715d                	addi	sp,sp,-80
    800011bc:	e486                	sd	ra,72(sp)
    800011be:	e0a2                	sd	s0,64(sp)
    800011c0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e39d                	bnez	a5,800011ec <uvmunmap+0x32>
    800011c8:	f84a                	sd	s2,48(sp)
    800011ca:	f44e                	sd	s3,40(sp)
    800011cc:	f052                	sd	s4,32(sp)
    800011ce:	ec56                	sd	s5,24(sp)
    800011d0:	e85a                	sd	s6,16(sp)
    800011d2:	e45e                	sd	s7,8(sp)
    800011d4:	8a2a                	mv	s4,a0
    800011d6:	892e                	mv	s2,a1
    800011d8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011da:	0632                	slli	a2,a2,0xc
    800011dc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e2:	6b05                	lui	s6,0x1
    800011e4:	0735ff63          	bgeu	a1,s3,80001262 <uvmunmap+0xa8>
    800011e8:	fc26                	sd	s1,56(sp)
    800011ea:	a0a9                	j	80001234 <uvmunmap+0x7a>
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011fa:	00006517          	auipc	a0,0x6
    800011fe:	f2650513          	addi	a0,a0,-218 # 80007120 <etext+0x120>
    80001202:	d92ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    80001206:	00006517          	auipc	a0,0x6
    8000120a:	f3250513          	addi	a0,a0,-206 # 80007138 <etext+0x138>
    8000120e:	d86ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001212:	00006517          	auipc	a0,0x6
    80001216:	f3650513          	addi	a0,a0,-202 # 80007148 <etext+0x148>
    8000121a:	d7aff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    8000121e:	00006517          	auipc	a0,0x6
    80001222:	f4250513          	addi	a0,a0,-190 # 80007160 <etext+0x160>
    80001226:	d6eff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000122a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000122e:	995a                	add	s2,s2,s6
    80001230:	03397863          	bgeu	s2,s3,80001260 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001234:	4601                	li	a2,0
    80001236:	85ca                	mv	a1,s2
    80001238:	8552                	mv	a0,s4
    8000123a:	d03ff0ef          	jal	80000f3c <walk>
    8000123e:	84aa                	mv	s1,a0
    80001240:	d179                	beqz	a0,80001206 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001242:	6108                	ld	a0,0(a0)
    80001244:	00157793          	andi	a5,a0,1
    80001248:	d7e9                	beqz	a5,80001212 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000124a:	3ff57793          	andi	a5,a0,1023
    8000124e:	fd7788e3          	beq	a5,s7,8000121e <uvmunmap+0x64>
    if(do_free){
    80001252:	fc0a8ce3          	beqz	s5,8000122a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001256:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001258:	0532                	slli	a0,a0,0xc
    8000125a:	fe8ff0ef          	jal	80000a42 <kfree>
    8000125e:	b7f1                	j	8000122a <uvmunmap+0x70>
    80001260:	74e2                	ld	s1,56(sp)
    80001262:	7942                	ld	s2,48(sp)
    80001264:	79a2                	ld	s3,40(sp)
    80001266:	7a02                	ld	s4,32(sp)
    80001268:	6ae2                	ld	s5,24(sp)
    8000126a:	6b42                	ld	s6,16(sp)
    8000126c:	6ba2                	ld	s7,8(sp)
  }
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	6161                	addi	sp,sp,80
    80001274:	8082                	ret

0000000080001276 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001276:	1101                	addi	sp,sp,-32
    80001278:	ec06                	sd	ra,24(sp)
    8000127a:	e822                	sd	s0,16(sp)
    8000127c:	e426                	sd	s1,8(sp)
    8000127e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001280:	8a5ff0ef          	jal	80000b24 <kalloc>
    80001284:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001286:	c509                	beqz	a0,80001290 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001288:	6605                	lui	a2,0x1
    8000128a:	4581                	li	a1,0
    8000128c:	a3dff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000129c:	7179                	addi	sp,sp,-48
    8000129e:	f406                	sd	ra,40(sp)
    800012a0:	f022                	sd	s0,32(sp)
    800012a2:	ec26                	sd	s1,24(sp)
    800012a4:	e84a                	sd	s2,16(sp)
    800012a6:	e44e                	sd	s3,8(sp)
    800012a8:	e052                	sd	s4,0(sp)
    800012aa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012ac:	6785                	lui	a5,0x1
    800012ae:	04f67063          	bgeu	a2,a5,800012ee <uvmfirst+0x52>
    800012b2:	8a2a                	mv	s4,a0
    800012b4:	89ae                	mv	s3,a1
    800012b6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012b8:	86dff0ef          	jal	80000b24 <kalloc>
    800012bc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012be:	6605                	lui	a2,0x1
    800012c0:	4581                	li	a1,0
    800012c2:	a07ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012c6:	4779                	li	a4,30
    800012c8:	86ca                	mv	a3,s2
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	8552                	mv	a0,s4
    800012d0:	d45ff0ef          	jal	80001014 <mappages>
  memmove(mem, src, sz);
    800012d4:	8626                	mv	a2,s1
    800012d6:	85ce                	mv	a1,s3
    800012d8:	854a                	mv	a0,s2
    800012da:	a4bff0ef          	jal	80000d24 <memmove>
}
    800012de:	70a2                	ld	ra,40(sp)
    800012e0:	7402                	ld	s0,32(sp)
    800012e2:	64e2                	ld	s1,24(sp)
    800012e4:	6942                	ld	s2,16(sp)
    800012e6:	69a2                	ld	s3,8(sp)
    800012e8:	6a02                	ld	s4,0(sp)
    800012ea:	6145                	addi	sp,sp,48
    800012ec:	8082                	ret
    panic("uvmfirst: more than a page");
    800012ee:	00006517          	auipc	a0,0x6
    800012f2:	e8a50513          	addi	a0,a0,-374 # 80007178 <etext+0x178>
    800012f6:	c9eff0ef          	jal	80000794 <panic>

00000000800012fa <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001304:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001306:	00b67d63          	bgeu	a2,a1,80001320 <uvmdealloc+0x26>
    8000130a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000130c:	6785                	lui	a5,0x1
    8000130e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001310:	00f60733          	add	a4,a2,a5
    80001314:	76fd                	lui	a3,0xfffff
    80001316:	8f75                	and	a4,a4,a3
    80001318:	97ae                	add	a5,a5,a1
    8000131a:	8ff5                	and	a5,a5,a3
    8000131c:	00f76863          	bltu	a4,a5,8000132c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001320:	8526                	mv	a0,s1
    80001322:	60e2                	ld	ra,24(sp)
    80001324:	6442                	ld	s0,16(sp)
    80001326:	64a2                	ld	s1,8(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000132c:	8f99                	sub	a5,a5,a4
    8000132e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001330:	4685                	li	a3,1
    80001332:	0007861b          	sext.w	a2,a5
    80001336:	85ba                	mv	a1,a4
    80001338:	e83ff0ef          	jal	800011ba <uvmunmap>
    8000133c:	b7d5                	j	80001320 <uvmdealloc+0x26>

000000008000133e <uvmalloc>:
  if(newsz < oldsz)
    8000133e:	08b66f63          	bltu	a2,a1,800013dc <uvmalloc+0x9e>
{
    80001342:	7139                	addi	sp,sp,-64
    80001344:	fc06                	sd	ra,56(sp)
    80001346:	f822                	sd	s0,48(sp)
    80001348:	ec4e                	sd	s3,24(sp)
    8000134a:	e852                	sd	s4,16(sp)
    8000134c:	e456                	sd	s5,8(sp)
    8000134e:	0080                	addi	s0,sp,64
    80001350:	8aaa                	mv	s5,a0
    80001352:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001354:	6785                	lui	a5,0x1
    80001356:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001358:	95be                	add	a1,a1,a5
    8000135a:	77fd                	lui	a5,0xfffff
    8000135c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001360:	08c9f063          	bgeu	s3,a2,800013e0 <uvmalloc+0xa2>
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	e05a                	sd	s6,0(sp)
    8000136a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000136c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001370:	fb4ff0ef          	jal	80000b24 <kalloc>
    80001374:	84aa                	mv	s1,a0
    if(mem == 0){
    80001376:	c515                	beqz	a0,800013a2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	94dff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001380:	875a                	mv	a4,s6
    80001382:	86a6                	mv	a3,s1
    80001384:	6605                	lui	a2,0x1
    80001386:	85ca                	mv	a1,s2
    80001388:	8556                	mv	a0,s5
    8000138a:	c8bff0ef          	jal	80001014 <mappages>
    8000138e:	e915                	bnez	a0,800013c2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001390:	6785                	lui	a5,0x1
    80001392:	993e                	add	s2,s2,a5
    80001394:	fd496ee3          	bltu	s2,s4,80001370 <uvmalloc+0x32>
  return newsz;
    80001398:	8552                	mv	a0,s4
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	6b02                	ld	s6,0(sp)
    800013a0:	a811                	j	800013b4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013a2:	864e                	mv	a2,s3
    800013a4:	85ca                	mv	a1,s2
    800013a6:	8556                	mv	a0,s5
    800013a8:	f53ff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013ac:	4501                	li	a0,0
    800013ae:	74a2                	ld	s1,40(sp)
    800013b0:	7902                	ld	s2,32(sp)
    800013b2:	6b02                	ld	s6,0(sp)
}
    800013b4:	70e2                	ld	ra,56(sp)
    800013b6:	7442                	ld	s0,48(sp)
    800013b8:	69e2                	ld	s3,24(sp)
    800013ba:	6a42                	ld	s4,16(sp)
    800013bc:	6aa2                	ld	s5,8(sp)
    800013be:	6121                	addi	sp,sp,64
    800013c0:	8082                	ret
      kfree(mem);
    800013c2:	8526                	mv	a0,s1
    800013c4:	e7eff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013c8:	864e                	mv	a2,s3
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	f2dff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013d2:	4501                	li	a0,0
    800013d4:	74a2                	ld	s1,40(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6b02                	ld	s6,0(sp)
    800013da:	bfe9                	j	800013b4 <uvmalloc+0x76>
    return oldsz;
    800013dc:	852e                	mv	a0,a1
}
    800013de:	8082                	ret
  return newsz;
    800013e0:	8532                	mv	a0,a2
    800013e2:	bfc9                	j	800013b4 <uvmalloc+0x76>

00000000800013e4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013f6:	84aa                	mv	s1,a0
    800013f8:	6905                	lui	s2,0x1
    800013fa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013fc:	4985                	li	s3,1
    800013fe:	a819                	j	80001414 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001400:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001402:	00c79513          	slli	a0,a5,0xc
    80001406:	fdfff0ef          	jal	800013e4 <freewalk>
      pagetable[i] = 0;
    8000140a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000140e:	04a1                	addi	s1,s1,8
    80001410:	01248f63          	beq	s1,s2,8000142e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001414:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001416:	00f7f713          	andi	a4,a5,15
    8000141a:	ff3703e3          	beq	a4,s3,80001400 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000141e:	8b85                	andi	a5,a5,1
    80001420:	d7fd                	beqz	a5,8000140e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001422:	00006517          	auipc	a0,0x6
    80001426:	d7650513          	addi	a0,a0,-650 # 80007198 <etext+0x198>
    8000142a:	b6aff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    8000142e:	8552                	mv	a0,s4
    80001430:	e12ff0ef          	jal	80000a42 <kfree>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret

0000000080001444 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001444:	1101                	addi	sp,sp,-32
    80001446:	ec06                	sd	ra,24(sp)
    80001448:	e822                	sd	s0,16(sp)
    8000144a:	e426                	sd	s1,8(sp)
    8000144c:	1000                	addi	s0,sp,32
    8000144e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001450:	e989                	bnez	a1,80001462 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001452:	8526                	mv	a0,s1
    80001454:	f91ff0ef          	jal	800013e4 <freewalk>
}
    80001458:	60e2                	ld	ra,24(sp)
    8000145a:	6442                	ld	s0,16(sp)
    8000145c:	64a2                	ld	s1,8(sp)
    8000145e:	6105                	addi	sp,sp,32
    80001460:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001462:	6785                	lui	a5,0x1
    80001464:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001466:	95be                	add	a1,a1,a5
    80001468:	4685                	li	a3,1
    8000146a:	00c5d613          	srli	a2,a1,0xc
    8000146e:	4581                	li	a1,0
    80001470:	d4bff0ef          	jal	800011ba <uvmunmap>
    80001474:	bff9                	j	80001452 <uvmfree+0xe>

0000000080001476 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001476:	c65d                	beqz	a2,80001524 <uvmcopy+0xae>
{
    80001478:	715d                	addi	sp,sp,-80
    8000147a:	e486                	sd	ra,72(sp)
    8000147c:	e0a2                	sd	s0,64(sp)
    8000147e:	fc26                	sd	s1,56(sp)
    80001480:	f84a                	sd	s2,48(sp)
    80001482:	f44e                	sd	s3,40(sp)
    80001484:	f052                	sd	s4,32(sp)
    80001486:	ec56                	sd	s5,24(sp)
    80001488:	e85a                	sd	s6,16(sp)
    8000148a:	e45e                	sd	s7,8(sp)
    8000148c:	0880                	addi	s0,sp,80
    8000148e:	8b2a                	mv	s6,a0
    80001490:	8aae                	mv	s5,a1
    80001492:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001494:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001496:	4601                	li	a2,0
    80001498:	85ce                	mv	a1,s3
    8000149a:	855a                	mv	a0,s6
    8000149c:	aa1ff0ef          	jal	80000f3c <walk>
    800014a0:	c121                	beqz	a0,800014e0 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a2:	6118                	ld	a4,0(a0)
    800014a4:	00177793          	andi	a5,a4,1
    800014a8:	c3b1                	beqz	a5,800014ec <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014aa:	00a75593          	srli	a1,a4,0xa
    800014ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014b6:	e6eff0ef          	jal	80000b24 <kalloc>
    800014ba:	892a                	mv	s2,a0
    800014bc:	c129                	beqz	a0,800014fe <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014be:	6605                	lui	a2,0x1
    800014c0:	85de                	mv	a1,s7
    800014c2:	863ff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014c6:	8726                	mv	a4,s1
    800014c8:	86ca                	mv	a3,s2
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ce                	mv	a1,s3
    800014ce:	8556                	mv	a0,s5
    800014d0:	b45ff0ef          	jal	80001014 <mappages>
    800014d4:	e115                	bnez	a0,800014f8 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014d6:	6785                	lui	a5,0x1
    800014d8:	99be                	add	s3,s3,a5
    800014da:	fb49eee3          	bltu	s3,s4,80001496 <uvmcopy+0x20>
    800014de:	a805                	j	8000150e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014e0:	00006517          	auipc	a0,0x6
    800014e4:	cc850513          	addi	a0,a0,-824 # 800071a8 <etext+0x1a8>
    800014e8:	aacff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	cdc50513          	addi	a0,a0,-804 # 800071c8 <etext+0x1c8>
    800014f4:	aa0ff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014f8:	854a                	mv	a0,s2
    800014fa:	d48ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014fe:	4685                	li	a3,1
    80001500:	00c9d613          	srli	a2,s3,0xc
    80001504:	4581                	li	a1,0
    80001506:	8556                	mv	a0,s5
    80001508:	cb3ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	a0bff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80001536:	c901                	beqz	a0,80001546 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001538:	611c                	ld	a5,0(a0)
    8000153a:	9bbd                	andi	a5,a5,-17
    8000153c:	e11c                	sd	a5,0(a0)
}
    8000153e:	60a2                	ld	ra,8(sp)
    80001540:	6402                	ld	s0,0(sp)
    80001542:	0141                	addi	sp,sp,16
    80001544:	8082                	ret
    panic("uvmclear");
    80001546:	00006517          	auipc	a0,0x6
    8000154a:	ca250513          	addi	a0,a0,-862 # 800071e8 <etext+0x1e8>
    8000154e:	a46ff0ef          	jal	80000794 <panic>

0000000080001552 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001552:	cad1                	beqz	a3,800015e6 <copyout+0x94>
{
    80001554:	711d                	addi	sp,sp,-96
    80001556:	ec86                	sd	ra,88(sp)
    80001558:	e8a2                	sd	s0,80(sp)
    8000155a:	e4a6                	sd	s1,72(sp)
    8000155c:	fc4e                	sd	s3,56(sp)
    8000155e:	f456                	sd	s5,40(sp)
    80001560:	f05a                	sd	s6,32(sp)
    80001562:	ec5e                	sd	s7,24(sp)
    80001564:	1080                	addi	s0,sp,96
    80001566:	8baa                	mv	s7,a0
    80001568:	8aae                	mv	s5,a1
    8000156a:	8b32                	mv	s6,a2
    8000156c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000156e:	74fd                	lui	s1,0xfffff
    80001570:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001572:	57fd                	li	a5,-1
    80001574:	83e9                	srli	a5,a5,0x1a
    80001576:	0697ea63          	bltu	a5,s1,800015ea <copyout+0x98>
    8000157a:	e0ca                	sd	s2,64(sp)
    8000157c:	f852                	sd	s4,48(sp)
    8000157e:	e862                	sd	s8,16(sp)
    80001580:	e466                	sd	s9,8(sp)
    80001582:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001584:	4cd5                	li	s9,21
    80001586:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001588:	8c3e                	mv	s8,a5
    8000158a:	a025                	j	800015b2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000158c:	83a9                	srli	a5,a5,0xa
    8000158e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001590:	409a8533          	sub	a0,s5,s1
    80001594:	0009061b          	sext.w	a2,s2
    80001598:	85da                	mv	a1,s6
    8000159a:	953e                	add	a0,a0,a5
    8000159c:	f88ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015a0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015a4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015a6:	02098963          	beqz	s3,800015d8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015aa:	054c6263          	bltu	s8,s4,800015ee <copyout+0x9c>
    800015ae:	84d2                	mv	s1,s4
    800015b0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015b2:	4601                	li	a2,0
    800015b4:	85a6                	mv	a1,s1
    800015b6:	855e                	mv	a0,s7
    800015b8:	985ff0ef          	jal	80000f3c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015bc:	c121                	beqz	a0,800015fc <copyout+0xaa>
    800015be:	611c                	ld	a5,0(a0)
    800015c0:	0157f713          	andi	a4,a5,21
    800015c4:	05971b63          	bne	a4,s9,8000161a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015c8:	01a48a33          	add	s4,s1,s10
    800015cc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015d0:	fb29fee3          	bgeu	s3,s2,8000158c <copyout+0x3a>
    800015d4:	894e                	mv	s2,s3
    800015d6:	bf5d                	j	8000158c <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	6906                	ld	s2,64(sp)
    800015dc:	7a42                	ld	s4,48(sp)
    800015de:	6c42                	ld	s8,16(sp)
    800015e0:	6ca2                	ld	s9,8(sp)
    800015e2:	6d02                	ld	s10,0(sp)
    800015e4:	a015                	j	80001608 <copyout+0xb6>
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret
      return -1;
    800015ea:	557d                	li	a0,-1
    800015ec:	a831                	j	80001608 <copyout+0xb6>
    800015ee:	557d                	li	a0,-1
    800015f0:	6906                	ld	s2,64(sp)
    800015f2:	7a42                	ld	s4,48(sp)
    800015f4:	6c42                	ld	s8,16(sp)
    800015f6:	6ca2                	ld	s9,8(sp)
    800015f8:	6d02                	ld	s10,0(sp)
    800015fa:	a039                	j	80001608 <copyout+0xb6>
      return -1;
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
}
    80001608:	60e6                	ld	ra,88(sp)
    8000160a:	6446                	ld	s0,80(sp)
    8000160c:	64a6                	ld	s1,72(sp)
    8000160e:	79e2                	ld	s3,56(sp)
    80001610:	7aa2                	ld	s5,40(sp)
    80001612:	7b02                	ld	s6,32(sp)
    80001614:	6be2                	ld	s7,24(sp)
    80001616:	6125                	addi	sp,sp,96
    80001618:	8082                	ret
      return -1;
    8000161a:	557d                	li	a0,-1
    8000161c:	6906                	ld	s2,64(sp)
    8000161e:	7a42                	ld	s4,48(sp)
    80001620:	6c42                	ld	s8,16(sp)
    80001622:	6ca2                	ld	s9,8(sp)
    80001624:	6d02                	ld	s10,0(sp)
    80001626:	b7cd                	j	80001608 <copyout+0xb6>

0000000080001628 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001628:	c6a5                	beqz	a3,80001690 <copyin+0x68>
{
    8000162a:	715d                	addi	sp,sp,-80
    8000162c:	e486                	sd	ra,72(sp)
    8000162e:	e0a2                	sd	s0,64(sp)
    80001630:	fc26                	sd	s1,56(sp)
    80001632:	f84a                	sd	s2,48(sp)
    80001634:	f44e                	sd	s3,40(sp)
    80001636:	f052                	sd	s4,32(sp)
    80001638:	ec56                	sd	s5,24(sp)
    8000163a:	e85a                	sd	s6,16(sp)
    8000163c:	e45e                	sd	s7,8(sp)
    8000163e:	e062                	sd	s8,0(sp)
    80001640:	0880                	addi	s0,sp,80
    80001642:	8b2a                	mv	s6,a0
    80001644:	8a2e                	mv	s4,a1
    80001646:	8c32                	mv	s8,a2
    80001648:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000164a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000164c:	6a85                	lui	s5,0x1
    8000164e:	a00d                	j	80001670 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001650:	018505b3          	add	a1,a0,s8
    80001654:	0004861b          	sext.w	a2,s1
    80001658:	412585b3          	sub	a1,a1,s2
    8000165c:	8552                	mv	a0,s4
    8000165e:	ec6ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001662:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001666:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001668:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000166c:	02098063          	beqz	s3,8000168c <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001670:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001674:	85ca                	mv	a1,s2
    80001676:	855a                	mv	a0,s6
    80001678:	95fff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    8000167c:	cd01                	beqz	a0,80001694 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000167e:	418904b3          	sub	s1,s2,s8
    80001682:	94d6                	add	s1,s1,s5
    if(n > len)
    80001684:	fc99f6e3          	bgeu	s3,s1,80001650 <copyin+0x28>
    80001688:	84ce                	mv	s1,s3
    8000168a:	b7d9                	j	80001650 <copyin+0x28>
  }
  return 0;
    8000168c:	4501                	li	a0,0
    8000168e:	a021                	j	80001696 <copyin+0x6e>
    80001690:	4501                	li	a0,0
}
    80001692:	8082                	ret
      return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6c02                	ld	s8,0(sp)
    800016aa:	6161                	addi	sp,sp,80
    800016ac:	8082                	ret

00000000800016ae <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ae:	c6dd                	beqz	a3,8000175c <copyinstr+0xae>
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	0880                	addi	s0,sp,80
    800016c6:	8a2a                	mv	s4,a0
    800016c8:	8b2e                	mv	s6,a1
    800016ca:	8bb2                	mv	s7,a2
    800016cc:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ce:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d0:	6985                	lui	s3,0x1
    800016d2:	a825                	j	8000170a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016d4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016d8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016da:	37fd                	addiw	a5,a5,-1
    800016dc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6161                	addi	sp,sp,80
    800016f4:	8082                	ret
    800016f6:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016fa:	9742                	add	a4,a4,a6
      --max;
    800016fc:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001700:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001704:	04e58463          	beq	a1,a4,8000174c <copyinstr+0x9e>
{
    80001708:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000170a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000170e:	85a6                	mv	a1,s1
    80001710:	8552                	mv	a0,s4
    80001712:	8c5ff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    80001716:	cd0d                	beqz	a0,80001750 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001718:	417486b3          	sub	a3,s1,s7
    8000171c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000171e:	00d97363          	bgeu	s2,a3,80001724 <copyinstr+0x76>
    80001722:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001724:	955e                	add	a0,a0,s7
    80001726:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001728:	c695                	beqz	a3,80001754 <copyinstr+0xa6>
    8000172a:	87da                	mv	a5,s6
    8000172c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000172e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001732:	96da                	add	a3,a3,s6
    80001734:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001736:	00f60733          	add	a4,a2,a5
    8000173a:	00074703          	lbu	a4,0(a4)
    8000173e:	db59                	beqz	a4,800016d4 <copyinstr+0x26>
        *dst = *p;
    80001740:	00e78023          	sb	a4,0(a5)
      dst++;
    80001744:	0785                	addi	a5,a5,1
    while(n > 0){
    80001746:	fed797e3          	bne	a5,a3,80001734 <copyinstr+0x86>
    8000174a:	b775                	j	800016f6 <copyinstr+0x48>
    8000174c:	4781                	li	a5,0
    8000174e:	b771                	j	800016da <copyinstr+0x2c>
      return -1;
    80001750:	557d                	li	a0,-1
    80001752:	b779                	j	800016e0 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001754:	6b85                	lui	s7,0x1
    80001756:	9ba6                	add	s7,s7,s1
    80001758:	87da                	mv	a5,s6
    8000175a:	b77d                	j	80001708 <copyinstr+0x5a>
  int got_null = 0;
    8000175c:	4781                	li	a5,0
  if(got_null){
    8000175e:	37fd                	addiw	a5,a5,-1
    80001760:	0007851b          	sext.w	a0,a5
}
    80001764:	8082                	ret

0000000080001766 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001766:	7139                	addi	sp,sp,-64
    80001768:	fc06                	sd	ra,56(sp)
    8000176a:	f822                	sd	s0,48(sp)
    8000176c:	f426                	sd	s1,40(sp)
    8000176e:	f04a                	sd	s2,32(sp)
    80001770:	ec4e                	sd	s3,24(sp)
    80001772:	e852                	sd	s4,16(sp)
    80001774:	e456                	sd	s5,8(sp)
    80001776:	e05a                	sd	s6,0(sp)
    80001778:	0080                	addi	s0,sp,64
    8000177a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000177c:	00011497          	auipc	s1,0x11
    80001780:	3ec48493          	addi	s1,s1,1004 # 80012b68 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001784:	8b26                	mv	s6,s1
    80001786:	faaab937          	lui	s2,0xfaaab
    8000178a:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa86b63>
    8000178e:	0932                	slli	s2,s2,0xc
    80001790:	aab90913          	addi	s2,s2,-1365
    80001794:	0932                	slli	s2,s2,0xc
    80001796:	aab90913          	addi	s2,s2,-1365
    8000179a:	0932                	slli	s2,s2,0xc
    8000179c:	aab90913          	addi	s2,s2,-1365
    800017a0:	040009b7          	lui	s3,0x4000
    800017a4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017a6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a8:	00017a97          	auipc	s5,0x17
    800017ac:	3c0a8a93          	addi	s5,s5,960 # 80018b68 <tickslock>
    char *pa = kalloc();
    800017b0:	b74ff0ef          	jal	80000b24 <kalloc>
    800017b4:	862a                	mv	a2,a0
    if(pa == 0)
    800017b6:	cd15                	beqz	a0,800017f2 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017b8:	416485b3          	sub	a1,s1,s6
    800017bc:	859d                	srai	a1,a1,0x7
    800017be:	032585b3          	mul	a1,a1,s2
    800017c2:	2585                	addiw	a1,a1,1
    800017c4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c8:	4719                	li	a4,6
    800017ca:	6685                	lui	a3,0x1
    800017cc:	40b985b3          	sub	a1,s3,a1
    800017d0:	8552                	mv	a0,s4
    800017d2:	8f3ff0ef          	jal	800010c4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d6:	18048493          	addi	s1,s1,384
    800017da:	fd549be3          	bne	s1,s5,800017b0 <proc_mapstacks+0x4a>
  }
}
    800017de:	70e2                	ld	ra,56(sp)
    800017e0:	7442                	ld	s0,48(sp)
    800017e2:	74a2                	ld	s1,40(sp)
    800017e4:	7902                	ld	s2,32(sp)
    800017e6:	69e2                	ld	s3,24(sp)
    800017e8:	6a42                	ld	s4,16(sp)
    800017ea:	6aa2                	ld	s5,8(sp)
    800017ec:	6b02                	ld	s6,0(sp)
    800017ee:	6121                	addi	sp,sp,64
    800017f0:	8082                	ret
      panic("kalloc");
    800017f2:	00006517          	auipc	a0,0x6
    800017f6:	a0650513          	addi	a0,a0,-1530 # 800071f8 <etext+0x1f8>
    800017fa:	f9bfe0ef          	jal	80000794 <panic>

00000000800017fe <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800017fe:	1141                	addi	sp,sp,-16
    80001800:	e422                	sd	s0,8(sp)
    80001802:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001804:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001806:	2501                	sext.w	a0,a0
    80001808:	6422                	ld	s0,8(sp)
    8000180a:	0141                	addi	sp,sp,16
    8000180c:	8082                	ret

000000008000180e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000180e:	1141                	addi	sp,sp,-16
    80001810:	e422                	sd	s0,8(sp)
    80001812:	0800                	addi	s0,sp,16
    80001814:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001816:	2781                	sext.w	a5,a5
    80001818:	079e                	slli	a5,a5,0x7
  return c;
}
    8000181a:	00011517          	auipc	a0,0x11
    8000181e:	e1650513          	addi	a0,a0,-490 # 80012630 <cpus>
    80001822:	953e                	add	a0,a0,a5
    80001824:	6422                	ld	s0,8(sp)
    80001826:	0141                	addi	sp,sp,16
    80001828:	8082                	ret

000000008000182a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000182a:	1101                	addi	sp,sp,-32
    8000182c:	ec06                	sd	ra,24(sp)
    8000182e:	e822                	sd	s0,16(sp)
    80001830:	e426                	sd	s1,8(sp)
    80001832:	1000                	addi	s0,sp,32
  push_off();
    80001834:	b80ff0ef          	jal	80000bb4 <push_off>
    80001838:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000183a:	2781                	sext.w	a5,a5
    8000183c:	079e                	slli	a5,a5,0x7
    8000183e:	00011717          	auipc	a4,0x11
    80001842:	df270713          	addi	a4,a4,-526 # 80012630 <cpus>
    80001846:	97ba                	add	a5,a5,a4
    80001848:	6384                	ld	s1,0(a5)
  pop_off();
    8000184a:	beeff0ef          	jal	80000c38 <pop_off>
  return p;
}
    8000184e:	8526                	mv	a0,s1
    80001850:	60e2                	ld	ra,24(sp)
    80001852:	6442                	ld	s0,16(sp)
    80001854:	64a2                	ld	s1,8(sp)
    80001856:	6105                	addi	sp,sp,32
    80001858:	8082                	ret

000000008000185a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000185a:	1141                	addi	sp,sp,-16
    8000185c:	e406                	sd	ra,8(sp)
    8000185e:	e022                	sd	s0,0(sp)
    80001860:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001862:	fc9ff0ef          	jal	8000182a <myproc>
    80001866:	c26ff0ef          	jal	80000c8c <release>

  if (first) {
    8000186a:	00009797          	auipc	a5,0x9
    8000186e:	bf67a783          	lw	a5,-1034(a5) # 8000a460 <first.1>
    80001872:	e799                	bnez	a5,80001880 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001874:	09e010ef          	jal	80002912 <usertrapret>
}
    80001878:	60a2                	ld	ra,8(sp)
    8000187a:	6402                	ld	s0,0(sp)
    8000187c:	0141                	addi	sp,sp,16
    8000187e:	8082                	ret
    fsinit(ROOTDEV);
    80001880:	4505                	li	a0,1
    80001882:	545010ef          	jal	800035c6 <fsinit>
    first = 0;
    80001886:	00009797          	auipc	a5,0x9
    8000188a:	bc07ad23          	sw	zero,-1062(a5) # 8000a460 <first.1>
    __sync_synchronize();
    8000188e:	0330000f          	fence	rw,rw
    80001892:	b7cd                	j	80001874 <forkret+0x1a>

0000000080001894 <allocpid>:
{
    80001894:	1101                	addi	sp,sp,-32
    80001896:	ec06                	sd	ra,24(sp)
    80001898:	e822                	sd	s0,16(sp)
    8000189a:	e426                	sd	s1,8(sp)
    8000189c:	e04a                	sd	s2,0(sp)
    8000189e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018a0:	00011917          	auipc	s2,0x11
    800018a4:	19090913          	addi	s2,s2,400 # 80012a30 <pid_lock>
    800018a8:	854a                	mv	a0,s2
    800018aa:	b4aff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    800018ae:	00009797          	auipc	a5,0x9
    800018b2:	bb678793          	addi	a5,a5,-1098 # 8000a464 <nextpid>
    800018b6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018b8:	0014871b          	addiw	a4,s1,1
    800018bc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018be:	854a                	mv	a0,s2
    800018c0:	bccff0ef          	jal	80000c8c <release>
}
    800018c4:	8526                	mv	a0,s1
    800018c6:	60e2                	ld	ra,24(sp)
    800018c8:	6442                	ld	s0,16(sp)
    800018ca:	64a2                	ld	s1,8(sp)
    800018cc:	6902                	ld	s2,0(sp)
    800018ce:	6105                	addi	sp,sp,32
    800018d0:	8082                	ret

00000000800018d2 <proc_pagetable>:
{
    800018d2:	1101                	addi	sp,sp,-32
    800018d4:	ec06                	sd	ra,24(sp)
    800018d6:	e822                	sd	s0,16(sp)
    800018d8:	e426                	sd	s1,8(sp)
    800018da:	e04a                	sd	s2,0(sp)
    800018dc:	1000                	addi	s0,sp,32
    800018de:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800018e0:	997ff0ef          	jal	80001276 <uvmcreate>
    800018e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800018e6:	cd05                	beqz	a0,8000191e <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800018e8:	4729                	li	a4,10
    800018ea:	00004697          	auipc	a3,0x4
    800018ee:	71668693          	addi	a3,a3,1814 # 80006000 <_trampoline>
    800018f2:	6605                	lui	a2,0x1
    800018f4:	040005b7          	lui	a1,0x4000
    800018f8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800018fa:	05b2                	slli	a1,a1,0xc
    800018fc:	f18ff0ef          	jal	80001014 <mappages>
    80001900:	02054663          	bltz	a0,8000192c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001904:	4719                	li	a4,6
    80001906:	05893683          	ld	a3,88(s2)
    8000190a:	6605                	lui	a2,0x1
    8000190c:	020005b7          	lui	a1,0x2000
    80001910:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001912:	05b6                	slli	a1,a1,0xd
    80001914:	8526                	mv	a0,s1
    80001916:	efeff0ef          	jal	80001014 <mappages>
    8000191a:	00054f63          	bltz	a0,80001938 <proc_pagetable+0x66>
}
    8000191e:	8526                	mv	a0,s1
    80001920:	60e2                	ld	ra,24(sp)
    80001922:	6442                	ld	s0,16(sp)
    80001924:	64a2                	ld	s1,8(sp)
    80001926:	6902                	ld	s2,0(sp)
    80001928:	6105                	addi	sp,sp,32
    8000192a:	8082                	ret
    uvmfree(pagetable, 0);
    8000192c:	4581                	li	a1,0
    8000192e:	8526                	mv	a0,s1
    80001930:	b15ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001934:	4481                	li	s1,0
    80001936:	b7e5                	j	8000191e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001938:	4681                	li	a3,0
    8000193a:	4605                	li	a2,1
    8000193c:	040005b7          	lui	a1,0x4000
    80001940:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001942:	05b2                	slli	a1,a1,0xc
    80001944:	8526                	mv	a0,s1
    80001946:	875ff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    8000194a:	4581                	li	a1,0
    8000194c:	8526                	mv	a0,s1
    8000194e:	af7ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001952:	4481                	li	s1,0
    80001954:	b7e9                	j	8000191e <proc_pagetable+0x4c>

0000000080001956 <proc_freepagetable>:
{
    80001956:	1101                	addi	sp,sp,-32
    80001958:	ec06                	sd	ra,24(sp)
    8000195a:	e822                	sd	s0,16(sp)
    8000195c:	e426                	sd	s1,8(sp)
    8000195e:	e04a                	sd	s2,0(sp)
    80001960:	1000                	addi	s0,sp,32
    80001962:	84aa                	mv	s1,a0
    80001964:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001966:	4681                	li	a3,0
    80001968:	4605                	li	a2,1
    8000196a:	040005b7          	lui	a1,0x4000
    8000196e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001970:	05b2                	slli	a1,a1,0xc
    80001972:	849ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001976:	4681                	li	a3,0
    80001978:	4605                	li	a2,1
    8000197a:	020005b7          	lui	a1,0x2000
    8000197e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001980:	05b6                	slli	a1,a1,0xd
    80001982:	8526                	mv	a0,s1
    80001984:	837ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001988:	85ca                	mv	a1,s2
    8000198a:	8526                	mv	a0,s1
    8000198c:	ab9ff0ef          	jal	80001444 <uvmfree>
}
    80001990:	60e2                	ld	ra,24(sp)
    80001992:	6442                	ld	s0,16(sp)
    80001994:	64a2                	ld	s1,8(sp)
    80001996:	6902                	ld	s2,0(sp)
    80001998:	6105                	addi	sp,sp,32
    8000199a:	8082                	ret

000000008000199c <freeproc>:
{
    8000199c:	1101                	addi	sp,sp,-32
    8000199e:	ec06                	sd	ra,24(sp)
    800019a0:	e822                	sd	s0,16(sp)
    800019a2:	e426                	sd	s1,8(sp)
    800019a4:	1000                	addi	s0,sp,32
    800019a6:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019a8:	6d28                	ld	a0,88(a0)
    800019aa:	c119                	beqz	a0,800019b0 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019ac:	896ff0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    800019b0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800019b4:	68a8                	ld	a0,80(s1)
    800019b6:	c501                	beqz	a0,800019be <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019b8:	64ac                	ld	a1,72(s1)
    800019ba:	f9dff0ef          	jal	80001956 <proc_freepagetable>
  p->pagetable = 0;
    800019be:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800019c2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800019c6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800019ca:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800019ce:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800019d2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800019d6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800019da:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800019de:	0004ac23          	sw	zero,24(s1)
}
    800019e2:	60e2                	ld	ra,24(sp)
    800019e4:	6442                	ld	s0,16(sp)
    800019e6:	64a2                	ld	s1,8(sp)
    800019e8:	6105                	addi	sp,sp,32
    800019ea:	8082                	ret

00000000800019ec <allocproc>:
{
    800019ec:	1101                	addi	sp,sp,-32
    800019ee:	ec06                	sd	ra,24(sp)
    800019f0:	e822                	sd	s0,16(sp)
    800019f2:	e426                	sd	s1,8(sp)
    800019f4:	e04a                	sd	s2,0(sp)
    800019f6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800019f8:	00011497          	auipc	s1,0x11
    800019fc:	17048493          	addi	s1,s1,368 # 80012b68 <proc>
    80001a00:	00017917          	auipc	s2,0x17
    80001a04:	16890913          	addi	s2,s2,360 # 80018b68 <tickslock>
    acquire(&p->lock);
    80001a08:	8526                	mv	a0,s1
    80001a0a:	9eaff0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001a0e:	4c9c                	lw	a5,24(s1)
    80001a10:	cb91                	beqz	a5,80001a24 <allocproc+0x38>
      release(&p->lock);
    80001a12:	8526                	mv	a0,s1
    80001a14:	a78ff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a18:	18048493          	addi	s1,s1,384
    80001a1c:	ff2496e3          	bne	s1,s2,80001a08 <allocproc+0x1c>
  return 0;
    80001a20:	4481                	li	s1,0
    80001a22:	a899                	j	80001a78 <allocproc+0x8c>
  p->pid = allocpid();
    80001a24:	e71ff0ef          	jal	80001894 <allocpid>
    80001a28:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a2a:	4785                	li	a5,1
    80001a2c:	cc9c                	sw	a5,24(s1)
  p->next = 0;
    80001a2e:	1604b423          	sd	zero,360(s1)
  switch (sched_mode) {
    80001a32:	00009797          	auipc	a5,0x9
    80001a36:	ac67a783          	lw	a5,-1338(a5) # 8000a4f8 <sched_mode>
    80001a3a:	c7b1                	beqz	a5,80001a86 <allocproc+0x9a>
    80001a3c:	4705                	li	a4,1
    80001a3e:	04e78c63          	beq	a5,a4,80001a96 <allocproc+0xaa>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a42:	8e2ff0ef          	jal	80000b24 <kalloc>
    80001a46:	892a                	mv	s2,a0
    80001a48:	eca8                	sd	a0,88(s1)
    80001a4a:	cd31                	beqz	a0,80001aa6 <allocproc+0xba>
  p->pagetable = proc_pagetable(p);
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	e85ff0ef          	jal	800018d2 <proc_pagetable>
    80001a52:	892a                	mv	s2,a0
    80001a54:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a56:	c125                	beqz	a0,80001ab6 <allocproc+0xca>
  memset(&p->context, 0, sizeof(p->context));
    80001a58:	07000613          	li	a2,112
    80001a5c:	4581                	li	a1,0
    80001a5e:	06048513          	addi	a0,s1,96
    80001a62:	a66ff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001a66:	00000797          	auipc	a5,0x0
    80001a6a:	df478793          	addi	a5,a5,-524 # 8000185a <forkret>
    80001a6e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a70:	60bc                	ld	a5,64(s1)
    80001a72:	6705                	lui	a4,0x1
    80001a74:	97ba                	add	a5,a5,a4
    80001a76:	f4bc                	sd	a5,104(s1)
}
    80001a78:	8526                	mv	a0,s1
    80001a7a:	60e2                	ld	ra,24(sp)
    80001a7c:	6442                	ld	s0,16(sp)
    80001a7e:	64a2                	ld	s1,8(sp)
    80001a80:	6902                	ld	s2,0(sp)
    80001a82:	6105                	addi	sp,sp,32
    80001a84:	8082                	ret
      p->time_quantum = -1;
    80001a86:	57fd                	li	a5,-1
    80001a88:	16f4a823          	sw	a5,368(s1)
      p->level = -1;
    80001a8c:	16f4aa23          	sw	a5,372(s1)
      p->priority = -1;
    80001a90:	16f4ac23          	sw	a5,376(s1)
      break;
    80001a94:	b77d                	j	80001a42 <allocproc+0x56>
      p->time_quantum = 0;
    80001a96:	1604a823          	sw	zero,368(s1)
      p->level = 0;
    80001a9a:	1604aa23          	sw	zero,372(s1)
      p->priority = 3;
    80001a9e:	478d                	li	a5,3
    80001aa0:	16f4ac23          	sw	a5,376(s1)
      break;
    80001aa4:	bf79                	j	80001a42 <allocproc+0x56>
    freeproc(p);
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	ef5ff0ef          	jal	8000199c <freeproc>
    release(&p->lock);
    80001aac:	8526                	mv	a0,s1
    80001aae:	9deff0ef          	jal	80000c8c <release>
    return 0;
    80001ab2:	84ca                	mv	s1,s2
    80001ab4:	b7d1                	j	80001a78 <allocproc+0x8c>
    freeproc(p);
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	ee5ff0ef          	jal	8000199c <freeproc>
    release(&p->lock);
    80001abc:	8526                	mv	a0,s1
    80001abe:	9ceff0ef          	jal	80000c8c <release>
    return 0;
    80001ac2:	84ca                	mv	s1,s2
    80001ac4:	bf55                	j	80001a78 <allocproc+0x8c>

0000000080001ac6 <growproc>:
{
    80001ac6:	1101                	addi	sp,sp,-32
    80001ac8:	ec06                	sd	ra,24(sp)
    80001aca:	e822                	sd	s0,16(sp)
    80001acc:	e426                	sd	s1,8(sp)
    80001ace:	e04a                	sd	s2,0(sp)
    80001ad0:	1000                	addi	s0,sp,32
    80001ad2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001ad4:	d57ff0ef          	jal	8000182a <myproc>
    80001ad8:	84aa                	mv	s1,a0
  sz = p->sz;
    80001ada:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001adc:	01204c63          	bgtz	s2,80001af4 <growproc+0x2e>
  } else if(n < 0){
    80001ae0:	02094463          	bltz	s2,80001b08 <growproc+0x42>
  p->sz = sz;
    80001ae4:	e4ac                	sd	a1,72(s1)
  return 0;
    80001ae6:	4501                	li	a0,0
}
    80001ae8:	60e2                	ld	ra,24(sp)
    80001aea:	6442                	ld	s0,16(sp)
    80001aec:	64a2                	ld	s1,8(sp)
    80001aee:	6902                	ld	s2,0(sp)
    80001af0:	6105                	addi	sp,sp,32
    80001af2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001af4:	4691                	li	a3,4
    80001af6:	00b90633          	add	a2,s2,a1
    80001afa:	6928                	ld	a0,80(a0)
    80001afc:	843ff0ef          	jal	8000133e <uvmalloc>
    80001b00:	85aa                	mv	a1,a0
    80001b02:	f16d                	bnez	a0,80001ae4 <growproc+0x1e>
      return -1;
    80001b04:	557d                	li	a0,-1
    80001b06:	b7cd                	j	80001ae8 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b08:	00b90633          	add	a2,s2,a1
    80001b0c:	6928                	ld	a0,80(a0)
    80001b0e:	fecff0ef          	jal	800012fa <uvmdealloc>
    80001b12:	85aa                	mv	a1,a0
    80001b14:	bfc1                	j	80001ae4 <growproc+0x1e>

0000000080001b16 <sched>:
{
    80001b16:	7179                	addi	sp,sp,-48
    80001b18:	f406                	sd	ra,40(sp)
    80001b1a:	f022                	sd	s0,32(sp)
    80001b1c:	ec26                	sd	s1,24(sp)
    80001b1e:	e84a                	sd	s2,16(sp)
    80001b20:	e44e                	sd	s3,8(sp)
    80001b22:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001b24:	d07ff0ef          	jal	8000182a <myproc>
    80001b28:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001b2a:	860ff0ef          	jal	80000b8a <holding>
    80001b2e:	c52d                	beqz	a0,80001b98 <sched+0x82>
    80001b30:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001b32:	2781                	sext.w	a5,a5
    80001b34:	079e                	slli	a5,a5,0x7
    80001b36:	00011717          	auipc	a4,0x11
    80001b3a:	afa70713          	addi	a4,a4,-1286 # 80012630 <cpus>
    80001b3e:	97ba                	add	a5,a5,a4
    80001b40:	5fb8                	lw	a4,120(a5)
    80001b42:	4785                	li	a5,1
    80001b44:	06f71063          	bne	a4,a5,80001ba4 <sched+0x8e>
  if(p->state == RUNNING)
    80001b48:	4c98                	lw	a4,24(s1)
    80001b4a:	4791                	li	a5,4
    80001b4c:	06f70263          	beq	a4,a5,80001bb0 <sched+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b50:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b54:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001b56:	e3bd                	bnez	a5,80001bbc <sched+0xa6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b58:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001b5a:	00011917          	auipc	s2,0x11
    80001b5e:	ad690913          	addi	s2,s2,-1322 # 80012630 <cpus>
    80001b62:	2781                	sext.w	a5,a5
    80001b64:	079e                	slli	a5,a5,0x7
    80001b66:	97ca                	add	a5,a5,s2
    80001b68:	07c7a983          	lw	s3,124(a5)
    80001b6c:	8592                	mv	a1,tp
  swtch(&p->context, &mycpu()->context);
    80001b6e:	2581                	sext.w	a1,a1
    80001b70:	059e                	slli	a1,a1,0x7
    80001b72:	05a1                	addi	a1,a1,8
    80001b74:	95ca                	add	a1,a1,s2
    80001b76:	06048513          	addi	a0,s1,96
    80001b7a:	4f3000ef          	jal	8000286c <swtch>
    80001b7e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001b80:	2781                	sext.w	a5,a5
    80001b82:	079e                	slli	a5,a5,0x7
    80001b84:	993e                	add	s2,s2,a5
    80001b86:	07392e23          	sw	s3,124(s2)
}
    80001b8a:	70a2                	ld	ra,40(sp)
    80001b8c:	7402                	ld	s0,32(sp)
    80001b8e:	64e2                	ld	s1,24(sp)
    80001b90:	6942                	ld	s2,16(sp)
    80001b92:	69a2                	ld	s3,8(sp)
    80001b94:	6145                	addi	sp,sp,48
    80001b96:	8082                	ret
    panic("sched p->lock");
    80001b98:	00005517          	auipc	a0,0x5
    80001b9c:	66850513          	addi	a0,a0,1640 # 80007200 <etext+0x200>
    80001ba0:	bf5fe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001ba4:	00005517          	auipc	a0,0x5
    80001ba8:	66c50513          	addi	a0,a0,1644 # 80007210 <etext+0x210>
    80001bac:	be9fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001bb0:	00005517          	auipc	a0,0x5
    80001bb4:	67050513          	addi	a0,a0,1648 # 80007220 <etext+0x220>
    80001bb8:	bddfe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001bbc:	00005517          	auipc	a0,0x5
    80001bc0:	67450513          	addi	a0,a0,1652 # 80007230 <etext+0x230>
    80001bc4:	bd1fe0ef          	jal	80000794 <panic>

0000000080001bc8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001bc8:	7179                	addi	sp,sp,-48
    80001bca:	f406                	sd	ra,40(sp)
    80001bcc:	f022                	sd	s0,32(sp)
    80001bce:	ec26                	sd	s1,24(sp)
    80001bd0:	e84a                	sd	s2,16(sp)
    80001bd2:	e44e                	sd	s3,8(sp)
    80001bd4:	1800                	addi	s0,sp,48
    80001bd6:	89aa                	mv	s3,a0
    80001bd8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001bda:	c51ff0ef          	jal	8000182a <myproc>
    80001bde:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001be0:	814ff0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001be4:	854a                	mv	a0,s2
    80001be6:	8a6ff0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001bea:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001bee:	4789                	li	a5,2
    80001bf0:	cc9c                	sw	a5,24(s1)

  sched();
    80001bf2:	f25ff0ef          	jal	80001b16 <sched>

  // Tidy up.
  p->chan = 0;
    80001bf6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001bfa:	8526                	mv	a0,s1
    80001bfc:	890ff0ef          	jal	80000c8c <release>
  acquire(lk);
    80001c00:	854a                	mv	a0,s2
    80001c02:	ff3fe0ef          	jal	80000bf4 <acquire>
}
    80001c06:	70a2                	ld	ra,40(sp)
    80001c08:	7402                	ld	s0,32(sp)
    80001c0a:	64e2                	ld	s1,24(sp)
    80001c0c:	6942                	ld	s2,16(sp)
    80001c0e:	69a2                	ld	s3,8(sp)
    80001c10:	6145                	addi	sp,sp,48
    80001c12:	8082                	ret

0000000080001c14 <setkilled>:
  return -1;
}

void
setkilled(struct proc *p)
{
    80001c14:	1101                	addi	sp,sp,-32
    80001c16:	ec06                	sd	ra,24(sp)
    80001c18:	e822                	sd	s0,16(sp)
    80001c1a:	e426                	sd	s1,8(sp)
    80001c1c:	1000                	addi	s0,sp,32
    80001c1e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001c20:	fd5fe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    80001c24:	4785                	li	a5,1
    80001c26:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	862ff0ef          	jal	80000c8c <release>
}
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6105                	addi	sp,sp,32
    80001c36:	8082                	ret

0000000080001c38 <killed>:

int
killed(struct proc *p)
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	e426                	sd	s1,8(sp)
    80001c40:	e04a                	sd	s2,0(sp)
    80001c42:	1000                	addi	s0,sp,32
    80001c44:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001c46:	faffe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80001c4a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	83cff0ef          	jal	80000c8c <release>
  return k;
}
    80001c54:	854a                	mv	a0,s2
    80001c56:	60e2                	ld	ra,24(sp)
    80001c58:	6442                	ld	s0,16(sp)
    80001c5a:	64a2                	ld	s1,8(sp)
    80001c5c:	6902                	ld	s2,0(sp)
    80001c5e:	6105                	addi	sp,sp,32
    80001c60:	8082                	ret

0000000080001c62 <wait>:
{
    80001c62:	715d                	addi	sp,sp,-80
    80001c64:	e486                	sd	ra,72(sp)
    80001c66:	e0a2                	sd	s0,64(sp)
    80001c68:	fc26                	sd	s1,56(sp)
    80001c6a:	f84a                	sd	s2,48(sp)
    80001c6c:	f44e                	sd	s3,40(sp)
    80001c6e:	f052                	sd	s4,32(sp)
    80001c70:	ec56                	sd	s5,24(sp)
    80001c72:	e85a                	sd	s6,16(sp)
    80001c74:	e45e                	sd	s7,8(sp)
    80001c76:	e062                	sd	s8,0(sp)
    80001c78:	0880                	addi	s0,sp,80
    80001c7a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001c7c:	bafff0ef          	jal	8000182a <myproc>
    80001c80:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001c82:	00011517          	auipc	a0,0x11
    80001c86:	dc650513          	addi	a0,a0,-570 # 80012a48 <wait_lock>
    80001c8a:	f6bfe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    80001c8e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001c90:	4a15                	li	s4,5
        havekids = 1;
    80001c92:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001c94:	00017997          	auipc	s3,0x17
    80001c98:	ed498993          	addi	s3,s3,-300 # 80018b68 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001c9c:	00011c17          	auipc	s8,0x11
    80001ca0:	dacc0c13          	addi	s8,s8,-596 # 80012a48 <wait_lock>
    80001ca4:	a871                	j	80001d40 <wait+0xde>
          pid = pp->pid;
    80001ca6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001caa:	000b0c63          	beqz	s6,80001cc2 <wait+0x60>
    80001cae:	4691                	li	a3,4
    80001cb0:	02c48613          	addi	a2,s1,44
    80001cb4:	85da                	mv	a1,s6
    80001cb6:	05093503          	ld	a0,80(s2)
    80001cba:	899ff0ef          	jal	80001552 <copyout>
    80001cbe:	02054b63          	bltz	a0,80001cf4 <wait+0x92>
          freeproc(pp);
    80001cc2:	8526                	mv	a0,s1
    80001cc4:	cd9ff0ef          	jal	8000199c <freeproc>
          release(&pp->lock);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	fc3fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    80001cce:	00011517          	auipc	a0,0x11
    80001cd2:	d7a50513          	addi	a0,a0,-646 # 80012a48 <wait_lock>
    80001cd6:	fb7fe0ef          	jal	80000c8c <release>
}
    80001cda:	854e                	mv	a0,s3
    80001cdc:	60a6                	ld	ra,72(sp)
    80001cde:	6406                	ld	s0,64(sp)
    80001ce0:	74e2                	ld	s1,56(sp)
    80001ce2:	7942                	ld	s2,48(sp)
    80001ce4:	79a2                	ld	s3,40(sp)
    80001ce6:	7a02                	ld	s4,32(sp)
    80001ce8:	6ae2                	ld	s5,24(sp)
    80001cea:	6b42                	ld	s6,16(sp)
    80001cec:	6ba2                	ld	s7,8(sp)
    80001cee:	6c02                	ld	s8,0(sp)
    80001cf0:	6161                	addi	sp,sp,80
    80001cf2:	8082                	ret
            release(&pp->lock);
    80001cf4:	8526                	mv	a0,s1
    80001cf6:	f97fe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    80001cfa:	00011517          	auipc	a0,0x11
    80001cfe:	d4e50513          	addi	a0,a0,-690 # 80012a48 <wait_lock>
    80001d02:	f8bfe0ef          	jal	80000c8c <release>
            return -1;
    80001d06:	59fd                	li	s3,-1
    80001d08:	bfc9                	j	80001cda <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d0a:	18048493          	addi	s1,s1,384
    80001d0e:	03348063          	beq	s1,s3,80001d2e <wait+0xcc>
      if(pp->parent == p){
    80001d12:	7c9c                	ld	a5,56(s1)
    80001d14:	ff279be3          	bne	a5,s2,80001d0a <wait+0xa8>
        acquire(&pp->lock);
    80001d18:	8526                	mv	a0,s1
    80001d1a:	edbfe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    80001d1e:	4c9c                	lw	a5,24(s1)
    80001d20:	f94783e3          	beq	a5,s4,80001ca6 <wait+0x44>
        release(&pp->lock);
    80001d24:	8526                	mv	a0,s1
    80001d26:	f67fe0ef          	jal	80000c8c <release>
        havekids = 1;
    80001d2a:	8756                	mv	a4,s5
    80001d2c:	bff9                	j	80001d0a <wait+0xa8>
    if(!havekids || killed(p)){
    80001d2e:	cf19                	beqz	a4,80001d4c <wait+0xea>
    80001d30:	854a                	mv	a0,s2
    80001d32:	f07ff0ef          	jal	80001c38 <killed>
    80001d36:	e919                	bnez	a0,80001d4c <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001d38:	85e2                	mv	a1,s8
    80001d3a:	854a                	mv	a0,s2
    80001d3c:	e8dff0ef          	jal	80001bc8 <sleep>
    havekids = 0;
    80001d40:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d42:	00011497          	auipc	s1,0x11
    80001d46:	e2648493          	addi	s1,s1,-474 # 80012b68 <proc>
    80001d4a:	b7e1                	j	80001d12 <wait+0xb0>
      release(&wait_lock);
    80001d4c:	00011517          	auipc	a0,0x11
    80001d50:	cfc50513          	addi	a0,a0,-772 # 80012a48 <wait_lock>
    80001d54:	f39fe0ef          	jal	80000c8c <release>
      return -1;
    80001d58:	59fd                	li	s3,-1
    80001d5a:	b741                	j	80001cda <wait+0x78>

0000000080001d5c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001d5c:	7179                	addi	sp,sp,-48
    80001d5e:	f406                	sd	ra,40(sp)
    80001d60:	f022                	sd	s0,32(sp)
    80001d62:	ec26                	sd	s1,24(sp)
    80001d64:	e84a                	sd	s2,16(sp)
    80001d66:	e44e                	sd	s3,8(sp)
    80001d68:	e052                	sd	s4,0(sp)
    80001d6a:	1800                	addi	s0,sp,48
    80001d6c:	84aa                	mv	s1,a0
    80001d6e:	892e                	mv	s2,a1
    80001d70:	89b2                	mv	s3,a2
    80001d72:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001d74:	ab7ff0ef          	jal	8000182a <myproc>
  if(user_dst){
    80001d78:	cc99                	beqz	s1,80001d96 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001d7a:	86d2                	mv	a3,s4
    80001d7c:	864e                	mv	a2,s3
    80001d7e:	85ca                	mv	a1,s2
    80001d80:	6928                	ld	a0,80(a0)
    80001d82:	fd0ff0ef          	jal	80001552 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001d86:	70a2                	ld	ra,40(sp)
    80001d88:	7402                	ld	s0,32(sp)
    80001d8a:	64e2                	ld	s1,24(sp)
    80001d8c:	6942                	ld	s2,16(sp)
    80001d8e:	69a2                	ld	s3,8(sp)
    80001d90:	6a02                	ld	s4,0(sp)
    80001d92:	6145                	addi	sp,sp,48
    80001d94:	8082                	ret
    memmove((char *)dst, src, len);
    80001d96:	000a061b          	sext.w	a2,s4
    80001d9a:	85ce                	mv	a1,s3
    80001d9c:	854a                	mv	a0,s2
    80001d9e:	f87fe0ef          	jal	80000d24 <memmove>
    return 0;
    80001da2:	8526                	mv	a0,s1
    80001da4:	b7cd                	j	80001d86 <either_copyout+0x2a>

0000000080001da6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001da6:	7179                	addi	sp,sp,-48
    80001da8:	f406                	sd	ra,40(sp)
    80001daa:	f022                	sd	s0,32(sp)
    80001dac:	ec26                	sd	s1,24(sp)
    80001dae:	e84a                	sd	s2,16(sp)
    80001db0:	e44e                	sd	s3,8(sp)
    80001db2:	e052                	sd	s4,0(sp)
    80001db4:	1800                	addi	s0,sp,48
    80001db6:	892a                	mv	s2,a0
    80001db8:	84ae                	mv	s1,a1
    80001dba:	89b2                	mv	s3,a2
    80001dbc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001dbe:	a6dff0ef          	jal	8000182a <myproc>
  if(user_src){
    80001dc2:	cc99                	beqz	s1,80001de0 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001dc4:	86d2                	mv	a3,s4
    80001dc6:	864e                	mv	a2,s3
    80001dc8:	85ca                	mv	a1,s2
    80001dca:	6928                	ld	a0,80(a0)
    80001dcc:	85dff0ef          	jal	80001628 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001dd0:	70a2                	ld	ra,40(sp)
    80001dd2:	7402                	ld	s0,32(sp)
    80001dd4:	64e2                	ld	s1,24(sp)
    80001dd6:	6942                	ld	s2,16(sp)
    80001dd8:	69a2                	ld	s3,8(sp)
    80001dda:	6a02                	ld	s4,0(sp)
    80001ddc:	6145                	addi	sp,sp,48
    80001dde:	8082                	ret
    memmove(dst, (char*)src, len);
    80001de0:	000a061b          	sext.w	a2,s4
    80001de4:	85ce                	mv	a1,s3
    80001de6:	854a                	mv	a0,s2
    80001de8:	f3dfe0ef          	jal	80000d24 <memmove>
    return 0;
    80001dec:	8526                	mv	a0,s1
    80001dee:	b7cd                	j	80001dd0 <either_copyin+0x2a>

0000000080001df0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001df0:	715d                	addi	sp,sp,-80
    80001df2:	e486                	sd	ra,72(sp)
    80001df4:	e0a2                	sd	s0,64(sp)
    80001df6:	fc26                	sd	s1,56(sp)
    80001df8:	f84a                	sd	s2,48(sp)
    80001dfa:	f44e                	sd	s3,40(sp)
    80001dfc:	f052                	sd	s4,32(sp)
    80001dfe:	ec56                	sd	s5,24(sp)
    80001e00:	e85a                	sd	s6,16(sp)
    80001e02:	e45e                	sd	s7,8(sp)
    80001e04:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001e06:	00005517          	auipc	a0,0x5
    80001e0a:	27250513          	addi	a0,a0,626 # 80007078 <etext+0x78>
    80001e0e:	eb4fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e12:	00011497          	auipc	s1,0x11
    80001e16:	eae48493          	addi	s1,s1,-338 # 80012cc0 <proc+0x158>
    80001e1a:	00017917          	auipc	s2,0x17
    80001e1e:	ea690913          	addi	s2,s2,-346 # 80018cc0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e22:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001e24:	00005997          	auipc	s3,0x5
    80001e28:	42498993          	addi	s3,s3,1060 # 80007248 <etext+0x248>
    printf("%d %s %s", p->pid, state, p->name);
    80001e2c:	00005a97          	auipc	s5,0x5
    80001e30:	424a8a93          	addi	s5,s5,1060 # 80007250 <etext+0x250>
    printf("\n");
    80001e34:	00005a17          	auipc	s4,0x5
    80001e38:	244a0a13          	addi	s4,s4,580 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e3c:	00006b97          	auipc	s7,0x6
    80001e40:	9acb8b93          	addi	s7,s7,-1620 # 800077e8 <states.0>
    80001e44:	a829                	j	80001e5e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001e46:	ed86a583          	lw	a1,-296(a3)
    80001e4a:	8556                	mv	a0,s5
    80001e4c:	e76fe0ef          	jal	800004c2 <printf>
    printf("\n");
    80001e50:	8552                	mv	a0,s4
    80001e52:	e70fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e56:	18048493          	addi	s1,s1,384
    80001e5a:	03248263          	beq	s1,s2,80001e7e <procdump+0x8e>
    if(p->state == UNUSED)
    80001e5e:	86a6                	mv	a3,s1
    80001e60:	ec04a783          	lw	a5,-320(s1)
    80001e64:	dbed                	beqz	a5,80001e56 <procdump+0x66>
      state = "???";
    80001e66:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e68:	fcfb6fe3          	bltu	s6,a5,80001e46 <procdump+0x56>
    80001e6c:	02079713          	slli	a4,a5,0x20
    80001e70:	01d75793          	srli	a5,a4,0x1d
    80001e74:	97de                	add	a5,a5,s7
    80001e76:	6390                	ld	a2,0(a5)
    80001e78:	f679                	bnez	a2,80001e46 <procdump+0x56>
      state = "???";
    80001e7a:	864e                	mv	a2,s3
    80001e7c:	b7e9                	j	80001e46 <procdump+0x56>
  }
}
    80001e7e:	60a6                	ld	ra,72(sp)
    80001e80:	6406                	ld	s0,64(sp)
    80001e82:	74e2                	ld	s1,56(sp)
    80001e84:	7942                	ld	s2,48(sp)
    80001e86:	79a2                	ld	s3,40(sp)
    80001e88:	7a02                	ld	s4,32(sp)
    80001e8a:	6ae2                	ld	s5,24(sp)
    80001e8c:	6b42                	ld	s6,16(sp)
    80001e8e:	6ba2                	ld	s7,8(sp)
    80001e90:	6161                	addi	sp,sp,80
    80001e92:	8082                	ret

0000000080001e94 <schedinit>:

void
schedinit(void)
{
    80001e94:	7179                	addi	sp,sp,-48
    80001e96:	f406                	sd	ra,40(sp)
    80001e98:	f022                	sd	s0,32(sp)
    80001e9a:	ec26                	sd	s1,24(sp)
    80001e9c:	e84a                	sd	s2,16(sp)
    80001e9e:	e44e                	sd	s3,8(sp)
    80001ea0:	1800                	addi	s0,sp,48
  sched_mode = FCFS;
    80001ea2:	00008797          	auipc	a5,0x8
    80001ea6:	6407ab23          	sw	zero,1622(a5) # 8000a4f8 <sched_mode>
  initlock(&sched_mode_lock, "sched_mode");
    80001eaa:	00005597          	auipc	a1,0x5
    80001eae:	3b658593          	addi	a1,a1,950 # 80007260 <etext+0x260>
    80001eb2:	00011517          	auipc	a0,0x11
    80001eb6:	bae50513          	addi	a0,a0,-1106 # 80012a60 <sched_mode_lock>
    80001eba:	cbbfe0ef          	jal	80000b74 <initlock>

  for(int lv = 0; lv < 6; lv++) {
    80001ebe:	00011497          	auipc	s1,0x11
    80001ec2:	bba48493          	addi	s1,s1,-1094 # 80012a78 <mlfq>
    80001ec6:	00011997          	auipc	s3,0x11
    80001eca:	ca298993          	addi	s3,s3,-862 # 80012b68 <proc>
    mlfq[lv].head = 0;
    mlfq[lv].tail = 0;
    initlock(&mlfq[lv].lock, "queue");
    80001ece:	00005917          	auipc	s2,0x5
    80001ed2:	3a290913          	addi	s2,s2,930 # 80007270 <etext+0x270>
    mlfq[lv].head = 0;
    80001ed6:	0004bc23          	sd	zero,24(s1)
    mlfq[lv].tail = 0;
    80001eda:	0204b023          	sd	zero,32(s1)
    initlock(&mlfq[lv].lock, "queue");
    80001ede:	85ca                	mv	a1,s2
    80001ee0:	8526                	mv	a0,s1
    80001ee2:	c93fe0ef          	jal	80000b74 <initlock>
  for(int lv = 0; lv < 6; lv++) {
    80001ee6:	02848493          	addi	s1,s1,40
    80001eea:	ff3496e3          	bne	s1,s3,80001ed6 <schedinit+0x42>
  }
}
    80001eee:	70a2                	ld	ra,40(sp)
    80001ef0:	7402                	ld	s0,32(sp)
    80001ef2:	64e2                	ld	s1,24(sp)
    80001ef4:	6942                	ld	s2,16(sp)
    80001ef6:	69a2                	ld	s3,8(sp)
    80001ef8:	6145                	addi	sp,sp,48
    80001efa:	8082                	ret

0000000080001efc <procinit>:
{
    80001efc:	7139                	addi	sp,sp,-64
    80001efe:	fc06                	sd	ra,56(sp)
    80001f00:	f822                	sd	s0,48(sp)
    80001f02:	f426                	sd	s1,40(sp)
    80001f04:	f04a                	sd	s2,32(sp)
    80001f06:	ec4e                	sd	s3,24(sp)
    80001f08:	e852                	sd	s4,16(sp)
    80001f0a:	e456                	sd	s5,8(sp)
    80001f0c:	e05a                	sd	s6,0(sp)
    80001f0e:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80001f10:	00005597          	auipc	a1,0x5
    80001f14:	36858593          	addi	a1,a1,872 # 80007278 <etext+0x278>
    80001f18:	00011517          	auipc	a0,0x11
    80001f1c:	b1850513          	addi	a0,a0,-1256 # 80012a30 <pid_lock>
    80001f20:	c55fe0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001f24:	00005597          	auipc	a1,0x5
    80001f28:	35c58593          	addi	a1,a1,860 # 80007280 <etext+0x280>
    80001f2c:	00011517          	auipc	a0,0x11
    80001f30:	b1c50513          	addi	a0,a0,-1252 # 80012a48 <wait_lock>
    80001f34:	c41fe0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f38:	00011497          	auipc	s1,0x11
    80001f3c:	c3048493          	addi	s1,s1,-976 # 80012b68 <proc>
      initlock(&p->lock, "proc");
    80001f40:	00005b17          	auipc	s6,0x5
    80001f44:	350b0b13          	addi	s6,s6,848 # 80007290 <etext+0x290>
      p->kstack = KSTACK((int) (p - proc));
    80001f48:	8aa6                	mv	s5,s1
    80001f4a:	faaab937          	lui	s2,0xfaaab
    80001f4e:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa86b63>
    80001f52:	0932                	slli	s2,s2,0xc
    80001f54:	aab90913          	addi	s2,s2,-1365
    80001f58:	0932                	slli	s2,s2,0xc
    80001f5a:	aab90913          	addi	s2,s2,-1365
    80001f5e:	0932                	slli	s2,s2,0xc
    80001f60:	aab90913          	addi	s2,s2,-1365
    80001f64:	040009b7          	lui	s3,0x4000
    80001f68:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001f6a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f6c:	00017a17          	auipc	s4,0x17
    80001f70:	bfca0a13          	addi	s4,s4,-1028 # 80018b68 <tickslock>
      initlock(&p->lock, "proc");
    80001f74:	85da                	mv	a1,s6
    80001f76:	8526                	mv	a0,s1
    80001f78:	bfdfe0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    80001f7c:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001f80:	415487b3          	sub	a5,s1,s5
    80001f84:	879d                	srai	a5,a5,0x7
    80001f86:	032787b3          	mul	a5,a5,s2
    80001f8a:	2785                	addiw	a5,a5,1
    80001f8c:	00d7979b          	slliw	a5,a5,0xd
    80001f90:	40f987b3          	sub	a5,s3,a5
    80001f94:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f96:	18048493          	addi	s1,s1,384
    80001f9a:	fd449de3          	bne	s1,s4,80001f74 <procinit+0x78>
  schedinit();
    80001f9e:	ef7ff0ef          	jal	80001e94 <schedinit>
}
    80001fa2:	70e2                	ld	ra,56(sp)
    80001fa4:	7442                	ld	s0,48(sp)
    80001fa6:	74a2                	ld	s1,40(sp)
    80001fa8:	7902                	ld	s2,32(sp)
    80001faa:	69e2                	ld	s3,24(sp)
    80001fac:	6a42                	ld	s4,16(sp)
    80001fae:	6aa2                	ld	s5,8(sp)
    80001fb0:	6b02                	ld	s6,0(sp)
    80001fb2:	6121                	addi	sp,sp,64
    80001fb4:	8082                	ret

0000000080001fb6 <enqueue>:
}

void
enqueue(struct proc* p)
{
  if (p) {
    80001fb6:	14050263          	beqz	a0,800020fa <enqueue+0x144>
{
    80001fba:	7179                	addi	sp,sp,-48
    80001fbc:	f406                	sd	ra,40(sp)
    80001fbe:	f022                	sd	s0,32(sp)
    80001fc0:	ec26                	sd	s1,24(sp)
    80001fc2:	1800                	addi	s0,sp,48
    80001fc4:	84aa                	mv	s1,a0
    switch (sched_mode) {
    80001fc6:	00008797          	auipc	a5,0x8
    80001fca:	5327a783          	lw	a5,1330(a5) # 8000a4f8 <sched_mode>
    80001fce:	cfbd                	beqz	a5,8000204c <enqueue+0x96>
    80001fd0:	4705                	li	a4,1
    80001fd2:	0ae79863          	bne	a5,a4,80002082 <enqueue+0xcc>
    80001fd6:	e84a                	sd	s2,16(sp)
    80001fd8:	e44e                	sd	s3,8(sp)
    80001fda:	e052                	sd	s4,0(sp)
            mlfq[0].tail = p;
        }
        release(&mlfq[0].lock);
        break;
      case MLFQ:
        int lv = p->level;
    80001fdc:	17452903          	lw	s2,372(a0)
        if(lv == 2) {
    80001fe0:	4789                	li	a5,2
    80001fe2:	0ef90163          	beq	s2,a5,800020c4 <enqueue+0x10e>
            case 3:
              lv = L2_priority3;
              break;
          }
        }
        acquire(&mlfq[lv].lock);
    80001fe6:	00291993          	slli	s3,s2,0x2
    80001fea:	012987b3          	add	a5,s3,s2
    80001fee:	078e                	slli	a5,a5,0x3
    80001ff0:	00011a17          	auipc	s4,0x11
    80001ff4:	a88a0a13          	addi	s4,s4,-1400 # 80012a78 <mlfq>
    80001ff8:	9a3e                	add	s4,s4,a5
    80001ffa:	8552                	mv	a0,s4
    80001ffc:	bf9fe0ef          	jal	80000bf4 <acquire>
        if(mlfq[lv].head)
    80002000:	99ca                	add	s3,s3,s2
    80002002:	098e                	slli	s3,s3,0x3
    80002004:	00010797          	auipc	a5,0x10
    80002008:	62c78793          	addi	a5,a5,1580 # 80012630 <cpus>
    8000200c:	97ce                	add	a5,a5,s3
    8000200e:	4607b783          	ld	a5,1120(a5)
    80002012:	cbe1                	beqz	a5,800020e2 <enqueue+0x12c>
          mlfq[lv].tail->next = p;
    80002014:	00010717          	auipc	a4,0x10
    80002018:	61c70713          	addi	a4,a4,1564 # 80012630 <cpus>
    8000201c:	013707b3          	add	a5,a4,s3
    80002020:	4687b783          	ld	a5,1128(a5)
    80002024:	1697b423          	sd	s1,360(a5)
        else
          mlfq[lv].head = p;
        mlfq[lv].tail = p;
    80002028:	00291793          	slli	a5,s2,0x2
    8000202c:	97ca                	add	a5,a5,s2
    8000202e:	078e                	slli	a5,a5,0x3
    80002030:	00010717          	auipc	a4,0x10
    80002034:	60070713          	addi	a4,a4,1536 # 80012630 <cpus>
    80002038:	97ba                	add	a5,a5,a4
    8000203a:	4697b423          	sd	s1,1128(a5)
        release(&mlfq[lv].lock);
    8000203e:	8552                	mv	a0,s4
    80002040:	c4dfe0ef          	jal	80000c8c <release>
    80002044:	6942                	ld	s2,16(sp)
    80002046:	69a2                	ld	s3,8(sp)
    80002048:	6a02                	ld	s4,0(sp)
        break;
    }
  }
}
    8000204a:	a825                	j	80002082 <enqueue+0xcc>
        acquire(&mlfq[0].lock);
    8000204c:	00011517          	auipc	a0,0x11
    80002050:	a2c50513          	addi	a0,a0,-1492 # 80012a78 <mlfq>
    80002054:	ba1fe0ef          	jal	80000bf4 <acquire>
        if(mlfq[0].head == 0)
    80002058:	00011797          	auipc	a5,0x11
    8000205c:	a387b783          	ld	a5,-1480(a5) # 80012a90 <mlfq+0x18>
    80002060:	c795                	beqz	a5,8000208c <enqueue+0xd6>
        else if (p->pid < mlfq[0].head->pid) {
    80002062:	5894                	lw	a3,48(s1)
    80002064:	5b98                	lw	a4,48(a5)
    80002066:	02e6dc63          	bge	a3,a4,8000209e <enqueue+0xe8>
          p->next = mlfq[0].head;
    8000206a:	16f4b423          	sd	a5,360(s1)
          mlfq[0].head = p;
    8000206e:	00011797          	auipc	a5,0x11
    80002072:	a297b123          	sd	s1,-1502(a5) # 80012a90 <mlfq+0x18>
        release(&mlfq[0].lock);
    80002076:	00011517          	auipc	a0,0x11
    8000207a:	a0250513          	addi	a0,a0,-1534 # 80012a78 <mlfq>
    8000207e:	c0ffe0ef          	jal	80000c8c <release>
}
    80002082:	70a2                	ld	ra,40(sp)
    80002084:	7402                	ld	s0,32(sp)
    80002086:	64e2                	ld	s1,24(sp)
    80002088:	6145                	addi	sp,sp,48
    8000208a:	8082                	ret
          mlfq[0].head = mlfq[0].tail = p;
    8000208c:	00010797          	auipc	a5,0x10
    80002090:	5a478793          	addi	a5,a5,1444 # 80012630 <cpus>
    80002094:	4697b423          	sd	s1,1128(a5)
    80002098:	4697b023          	sd	s1,1120(a5)
    8000209c:	bfe9                	j	80002076 <enqueue+0xc0>
          while (cur->next && cur->next->pid < p->pid)
    8000209e:	863e                	mv	a2,a5
    800020a0:	1687b783          	ld	a5,360(a5)
    800020a4:	c781                	beqz	a5,800020ac <enqueue+0xf6>
    800020a6:	5b98                	lw	a4,48(a5)
    800020a8:	fed74be3          	blt	a4,a3,8000209e <enqueue+0xe8>
          p->next = cur->next;
    800020ac:	16f4b423          	sd	a5,360(s1)
          cur->next = p;
    800020b0:	16963423          	sd	s1,360(a2) # 1168 <_entry-0x7fffee98>
          if(p->next == 0)
    800020b4:	1684b783          	ld	a5,360(s1)
    800020b8:	ffdd                	bnez	a5,80002076 <enqueue+0xc0>
            mlfq[0].tail = p;
    800020ba:	00011797          	auipc	a5,0x11
    800020be:	9c97bf23          	sd	s1,-1570(a5) # 80012a98 <mlfq+0x20>
    800020c2:	bf55                	j	80002076 <enqueue+0xc0>
          switch(p->priority) {
    800020c4:	17852783          	lw	a5,376(a0)
    800020c8:	4705                	li	a4,1
    800020ca:	00e78863          	beq	a5,a4,800020da <enqueue+0x124>
    800020ce:	4709                	li	a4,2
    800020d0:	00e78763          	beq	a5,a4,800020de <enqueue+0x128>
    800020d4:	fb89                	bnez	a5,80001fe6 <enqueue+0x30>
    800020d6:	4915                	li	s2,5
    800020d8:	b739                	j	80001fe6 <enqueue+0x30>
              lv = L2_priority1;
    800020da:	4911                	li	s2,4
    800020dc:	b729                	j	80001fe6 <enqueue+0x30>
              lv = L2_priority2;
    800020de:	490d                	li	s2,3
    800020e0:	b719                	j	80001fe6 <enqueue+0x30>
          mlfq[lv].head = p;
    800020e2:	00291793          	slli	a5,s2,0x2
    800020e6:	97ca                	add	a5,a5,s2
    800020e8:	078e                	slli	a5,a5,0x3
    800020ea:	00010717          	auipc	a4,0x10
    800020ee:	54670713          	addi	a4,a4,1350 # 80012630 <cpus>
    800020f2:	97ba                	add	a5,a5,a4
    800020f4:	4697b023          	sd	s1,1120(a5)
    800020f8:	bf05                	j	80002028 <enqueue+0x72>
    800020fa:	8082                	ret

00000000800020fc <userinit>:
{
    800020fc:	1101                	addi	sp,sp,-32
    800020fe:	ec06                	sd	ra,24(sp)
    80002100:	e822                	sd	s0,16(sp)
    80002102:	e426                	sd	s1,8(sp)
    80002104:	1000                	addi	s0,sp,32
  p = allocproc();
    80002106:	8e7ff0ef          	jal	800019ec <allocproc>
    8000210a:	84aa                	mv	s1,a0
  initproc = p;
    8000210c:	00008797          	auipc	a5,0x8
    80002110:	3ea7ba23          	sd	a0,1012(a5) # 8000a500 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002114:	03400613          	li	a2,52
    80002118:	00008597          	auipc	a1,0x8
    8000211c:	35858593          	addi	a1,a1,856 # 8000a470 <initcode>
    80002120:	6928                	ld	a0,80(a0)
    80002122:	97aff0ef          	jal	8000129c <uvmfirst>
  p->sz = PGSIZE;
    80002126:	6785                	lui	a5,0x1
    80002128:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000212a:	6cb8                	ld	a4,88(s1)
    8000212c:	00073c23          	sd	zero,24(a4)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002130:	6cb8                	ld	a4,88(s1)
    80002132:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002134:	4641                	li	a2,16
    80002136:	00005597          	auipc	a1,0x5
    8000213a:	16258593          	addi	a1,a1,354 # 80007298 <etext+0x298>
    8000213e:	15848513          	addi	a0,s1,344
    80002142:	cc5fe0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80002146:	00005517          	auipc	a0,0x5
    8000214a:	16250513          	addi	a0,a0,354 # 800072a8 <etext+0x2a8>
    8000214e:	587010ef          	jal	80003ed4 <namei>
    80002152:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80002156:	478d                	li	a5,3
    80002158:	cc9c                	sw	a5,24(s1)
  enqueue(p);
    8000215a:	8526                	mv	a0,s1
    8000215c:	e5bff0ef          	jal	80001fb6 <enqueue>
  release(&p->lock);
    80002160:	8526                	mv	a0,s1
    80002162:	b2bfe0ef          	jal	80000c8c <release>
}
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6105                	addi	sp,sp,32
    8000216e:	8082                	ret

0000000080002170 <fork>:
{
    80002170:	7139                	addi	sp,sp,-64
    80002172:	fc06                	sd	ra,56(sp)
    80002174:	f822                	sd	s0,48(sp)
    80002176:	f04a                	sd	s2,32(sp)
    80002178:	e456                	sd	s5,8(sp)
    8000217a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000217c:	eaeff0ef          	jal	8000182a <myproc>
    80002180:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80002182:	86bff0ef          	jal	800019ec <allocproc>
    80002186:	0e050d63          	beqz	a0,80002280 <fork+0x110>
    8000218a:	ec4e                	sd	s3,24(sp)
    8000218c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000218e:	048ab603          	ld	a2,72(s5)
    80002192:	692c                	ld	a1,80(a0)
    80002194:	050ab503          	ld	a0,80(s5)
    80002198:	adeff0ef          	jal	80001476 <uvmcopy>
    8000219c:	04054a63          	bltz	a0,800021f0 <fork+0x80>
    800021a0:	f426                	sd	s1,40(sp)
    800021a2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800021a4:	048ab783          	ld	a5,72(s5)
    800021a8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800021ac:	058ab683          	ld	a3,88(s5)
    800021b0:	87b6                	mv	a5,a3
    800021b2:	0589b703          	ld	a4,88(s3)
    800021b6:	12068693          	addi	a3,a3,288
    800021ba:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800021be:	6788                	ld	a0,8(a5)
    800021c0:	6b8c                	ld	a1,16(a5)
    800021c2:	6f90                	ld	a2,24(a5)
    800021c4:	01073023          	sd	a6,0(a4)
    800021c8:	e708                	sd	a0,8(a4)
    800021ca:	eb0c                	sd	a1,16(a4)
    800021cc:	ef10                	sd	a2,24(a4)
    800021ce:	02078793          	addi	a5,a5,32
    800021d2:	02070713          	addi	a4,a4,32
    800021d6:	fed792e3          	bne	a5,a3,800021ba <fork+0x4a>
  np->trapframe->a0 = 0;
    800021da:	0589b783          	ld	a5,88(s3)
    800021de:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800021e2:	0d0a8493          	addi	s1,s5,208
    800021e6:	0d098913          	addi	s2,s3,208
    800021ea:	150a8a13          	addi	s4,s5,336
    800021ee:	a831                	j	8000220a <fork+0x9a>
    freeproc(np);
    800021f0:	854e                	mv	a0,s3
    800021f2:	faaff0ef          	jal	8000199c <freeproc>
    release(&np->lock);
    800021f6:	854e                	mv	a0,s3
    800021f8:	a95fe0ef          	jal	80000c8c <release>
    return -1;
    800021fc:	597d                	li	s2,-1
    800021fe:	69e2                	ld	s3,24(sp)
    80002200:	a88d                	j	80002272 <fork+0x102>
  for(i = 0; i < NOFILE; i++)
    80002202:	04a1                	addi	s1,s1,8
    80002204:	0921                	addi	s2,s2,8
    80002206:	01448963          	beq	s1,s4,80002218 <fork+0xa8>
    if(p->ofile[i])
    8000220a:	6088                	ld	a0,0(s1)
    8000220c:	d97d                	beqz	a0,80002202 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000220e:	256020ef          	jal	80004464 <filedup>
    80002212:	00a93023          	sd	a0,0(s2)
    80002216:	b7f5                	j	80002202 <fork+0x92>
  np->cwd = idup(p->cwd);
    80002218:	150ab503          	ld	a0,336(s5)
    8000221c:	5a8010ef          	jal	800037c4 <idup>
    80002220:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002224:	4641                	li	a2,16
    80002226:	158a8593          	addi	a1,s5,344
    8000222a:	15898513          	addi	a0,s3,344
    8000222e:	bd9fe0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80002232:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80002236:	854e                	mv	a0,s3
    80002238:	a55fe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    8000223c:	00011497          	auipc	s1,0x11
    80002240:	80c48493          	addi	s1,s1,-2036 # 80012a48 <wait_lock>
    80002244:	8526                	mv	a0,s1
    80002246:	9affe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    8000224a:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000224e:	8526                	mv	a0,s1
    80002250:	a3dfe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    80002254:	854e                	mv	a0,s3
    80002256:	99ffe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    8000225a:	478d                	li	a5,3
    8000225c:	00f9ac23          	sw	a5,24(s3)
  enqueue(np);
    80002260:	854e                	mv	a0,s3
    80002262:	d55ff0ef          	jal	80001fb6 <enqueue>
  release(&np->lock);
    80002266:	854e                	mv	a0,s3
    80002268:	a25fe0ef          	jal	80000c8c <release>
  return pid;
    8000226c:	74a2                	ld	s1,40(sp)
    8000226e:	69e2                	ld	s3,24(sp)
    80002270:	6a42                	ld	s4,16(sp)
}
    80002272:	854a                	mv	a0,s2
    80002274:	70e2                	ld	ra,56(sp)
    80002276:	7442                	ld	s0,48(sp)
    80002278:	7902                	ld	s2,32(sp)
    8000227a:	6aa2                	ld	s5,8(sp)
    8000227c:	6121                	addi	sp,sp,64
    8000227e:	8082                	ret
    return -1;
    80002280:	597d                	li	s2,-1
    80002282:	bfc5                	j	80002272 <fork+0x102>

0000000080002284 <yield>:
{
    80002284:	1101                	addi	sp,sp,-32
    80002286:	ec06                	sd	ra,24(sp)
    80002288:	e822                	sd	s0,16(sp)
    8000228a:	e426                	sd	s1,8(sp)
    8000228c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000228e:	d9cff0ef          	jal	8000182a <myproc>
    80002292:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002294:	961fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80002298:	478d                	li	a5,3
    8000229a:	cc9c                	sw	a5,24(s1)
  enqueue(p);
    8000229c:	8526                	mv	a0,s1
    8000229e:	d19ff0ef          	jal	80001fb6 <enqueue>
  sched();
    800022a2:	875ff0ef          	jal	80001b16 <sched>
  release(&p->lock);
    800022a6:	8526                	mv	a0,s1
    800022a8:	9e5fe0ef          	jal	80000c8c <release>
}
    800022ac:	60e2                	ld	ra,24(sp)
    800022ae:	6442                	ld	s0,16(sp)
    800022b0:	64a2                	ld	s1,8(sp)
    800022b2:	6105                	addi	sp,sp,32
    800022b4:	8082                	ret

00000000800022b6 <wakeup>:
{
    800022b6:	7139                	addi	sp,sp,-64
    800022b8:	fc06                	sd	ra,56(sp)
    800022ba:	f822                	sd	s0,48(sp)
    800022bc:	f426                	sd	s1,40(sp)
    800022be:	f04a                	sd	s2,32(sp)
    800022c0:	ec4e                	sd	s3,24(sp)
    800022c2:	e852                	sd	s4,16(sp)
    800022c4:	e456                	sd	s5,8(sp)
    800022c6:	0080                	addi	s0,sp,64
    800022c8:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800022ca:	00011497          	auipc	s1,0x11
    800022ce:	89e48493          	addi	s1,s1,-1890 # 80012b68 <proc>
      if(p->state == SLEEPING && p->chan == chan) {
    800022d2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800022d4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800022d6:	00017917          	auipc	s2,0x17
    800022da:	89290913          	addi	s2,s2,-1902 # 80018b68 <tickslock>
    800022de:	a801                	j	800022ee <wakeup+0x38>
      release(&p->lock);
    800022e0:	8526                	mv	a0,s1
    800022e2:	9abfe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022e6:	18048493          	addi	s1,s1,384
    800022ea:	03248563          	beq	s1,s2,80002314 <wakeup+0x5e>
    if(p != myproc()){
    800022ee:	d3cff0ef          	jal	8000182a <myproc>
    800022f2:	fea48ae3          	beq	s1,a0,800022e6 <wakeup+0x30>
      acquire(&p->lock);
    800022f6:	8526                	mv	a0,s1
    800022f8:	8fdfe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800022fc:	4c9c                	lw	a5,24(s1)
    800022fe:	ff3791e3          	bne	a5,s3,800022e0 <wakeup+0x2a>
    80002302:	709c                	ld	a5,32(s1)
    80002304:	fd479ee3          	bne	a5,s4,800022e0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002308:	0154ac23          	sw	s5,24(s1)
        enqueue(p);
    8000230c:	8526                	mv	a0,s1
    8000230e:	ca9ff0ef          	jal	80001fb6 <enqueue>
    80002312:	b7f9                	j	800022e0 <wakeup+0x2a>
}
    80002314:	70e2                	ld	ra,56(sp)
    80002316:	7442                	ld	s0,48(sp)
    80002318:	74a2                	ld	s1,40(sp)
    8000231a:	7902                	ld	s2,32(sp)
    8000231c:	69e2                	ld	s3,24(sp)
    8000231e:	6a42                	ld	s4,16(sp)
    80002320:	6aa2                	ld	s5,8(sp)
    80002322:	6121                	addi	sp,sp,64
    80002324:	8082                	ret

0000000080002326 <reparent>:
{
    80002326:	7179                	addi	sp,sp,-48
    80002328:	f406                	sd	ra,40(sp)
    8000232a:	f022                	sd	s0,32(sp)
    8000232c:	ec26                	sd	s1,24(sp)
    8000232e:	e84a                	sd	s2,16(sp)
    80002330:	e44e                	sd	s3,8(sp)
    80002332:	e052                	sd	s4,0(sp)
    80002334:	1800                	addi	s0,sp,48
    80002336:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002338:	00011497          	auipc	s1,0x11
    8000233c:	83048493          	addi	s1,s1,-2000 # 80012b68 <proc>
      pp->parent = initproc;
    80002340:	00008a17          	auipc	s4,0x8
    80002344:	1c0a0a13          	addi	s4,s4,448 # 8000a500 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002348:	00017997          	auipc	s3,0x17
    8000234c:	82098993          	addi	s3,s3,-2016 # 80018b68 <tickslock>
    80002350:	a029                	j	8000235a <reparent+0x34>
    80002352:	18048493          	addi	s1,s1,384
    80002356:	01348b63          	beq	s1,s3,8000236c <reparent+0x46>
    if(pp->parent == p){
    8000235a:	7c9c                	ld	a5,56(s1)
    8000235c:	ff279be3          	bne	a5,s2,80002352 <reparent+0x2c>
      pp->parent = initproc;
    80002360:	000a3503          	ld	a0,0(s4)
    80002364:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002366:	f51ff0ef          	jal	800022b6 <wakeup>
    8000236a:	b7e5                	j	80002352 <reparent+0x2c>
}
    8000236c:	70a2                	ld	ra,40(sp)
    8000236e:	7402                	ld	s0,32(sp)
    80002370:	64e2                	ld	s1,24(sp)
    80002372:	6942                	ld	s2,16(sp)
    80002374:	69a2                	ld	s3,8(sp)
    80002376:	6a02                	ld	s4,0(sp)
    80002378:	6145                	addi	sp,sp,48
    8000237a:	8082                	ret

000000008000237c <exit>:
{
    8000237c:	7179                	addi	sp,sp,-48
    8000237e:	f406                	sd	ra,40(sp)
    80002380:	f022                	sd	s0,32(sp)
    80002382:	ec26                	sd	s1,24(sp)
    80002384:	e84a                	sd	s2,16(sp)
    80002386:	e44e                	sd	s3,8(sp)
    80002388:	e052                	sd	s4,0(sp)
    8000238a:	1800                	addi	s0,sp,48
    8000238c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000238e:	c9cff0ef          	jal	8000182a <myproc>
    80002392:	89aa                	mv	s3,a0
  if(p == initproc)
    80002394:	00008797          	auipc	a5,0x8
    80002398:	16c7b783          	ld	a5,364(a5) # 8000a500 <initproc>
    8000239c:	0d050493          	addi	s1,a0,208
    800023a0:	15050913          	addi	s2,a0,336
    800023a4:	00a79f63          	bne	a5,a0,800023c2 <exit+0x46>
    panic("init exiting");
    800023a8:	00005517          	auipc	a0,0x5
    800023ac:	f0850513          	addi	a0,a0,-248 # 800072b0 <etext+0x2b0>
    800023b0:	be4fe0ef          	jal	80000794 <panic>
      fileclose(f);
    800023b4:	0f6020ef          	jal	800044aa <fileclose>
      p->ofile[fd] = 0;
    800023b8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800023bc:	04a1                	addi	s1,s1,8
    800023be:	01248563          	beq	s1,s2,800023c8 <exit+0x4c>
    if(p->ofile[fd]){
    800023c2:	6088                	ld	a0,0(s1)
    800023c4:	f965                	bnez	a0,800023b4 <exit+0x38>
    800023c6:	bfdd                	j	800023bc <exit+0x40>
  begin_op();
    800023c8:	4c9010ef          	jal	80004090 <begin_op>
  iput(p->cwd);
    800023cc:	1509b503          	ld	a0,336(s3)
    800023d0:	5ac010ef          	jal	8000397c <iput>
  end_op();
    800023d4:	527010ef          	jal	800040fa <end_op>
  p->cwd = 0;
    800023d8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800023dc:	00010497          	auipc	s1,0x10
    800023e0:	66c48493          	addi	s1,s1,1644 # 80012a48 <wait_lock>
    800023e4:	8526                	mv	a0,s1
    800023e6:	80ffe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    800023ea:	854e                	mv	a0,s3
    800023ec:	f3bff0ef          	jal	80002326 <reparent>
  wakeup(p->parent);
    800023f0:	0389b503          	ld	a0,56(s3)
    800023f4:	ec3ff0ef          	jal	800022b6 <wakeup>
  acquire(&p->lock);
    800023f8:	854e                	mv	a0,s3
    800023fa:	ffafe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    800023fe:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002402:	4795                	li	a5,5
    80002404:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002408:	8526                	mv	a0,s1
    8000240a:	883fe0ef          	jal	80000c8c <release>
  sched();
    8000240e:	f08ff0ef          	jal	80001b16 <sched>
  panic("zombie exit");
    80002412:	00005517          	auipc	a0,0x5
    80002416:	eae50513          	addi	a0,a0,-338 # 800072c0 <etext+0x2c0>
    8000241a:	b7afe0ef          	jal	80000794 <panic>

000000008000241e <kill>:
{
    8000241e:	7179                	addi	sp,sp,-48
    80002420:	f406                	sd	ra,40(sp)
    80002422:	f022                	sd	s0,32(sp)
    80002424:	ec26                	sd	s1,24(sp)
    80002426:	e84a                	sd	s2,16(sp)
    80002428:	e44e                	sd	s3,8(sp)
    8000242a:	1800                	addi	s0,sp,48
    8000242c:	892a                	mv	s2,a0
  for(p = proc; p < &proc[NPROC]; p++){
    8000242e:	00010497          	auipc	s1,0x10
    80002432:	73a48493          	addi	s1,s1,1850 # 80012b68 <proc>
    80002436:	00016997          	auipc	s3,0x16
    8000243a:	73298993          	addi	s3,s3,1842 # 80018b68 <tickslock>
    acquire(&p->lock);
    8000243e:	8526                	mv	a0,s1
    80002440:	fb4fe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    80002444:	589c                	lw	a5,48(s1)
    80002446:	01278b63          	beq	a5,s2,8000245c <kill+0x3e>
    release(&p->lock);
    8000244a:	8526                	mv	a0,s1
    8000244c:	841fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002450:	18048493          	addi	s1,s1,384
    80002454:	ff3495e3          	bne	s1,s3,8000243e <kill+0x20>
  return -1;
    80002458:	557d                	li	a0,-1
    8000245a:	a819                	j	80002470 <kill+0x52>
      p->killed = 1;
    8000245c:	4785                	li	a5,1
    8000245e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002460:	4c98                	lw	a4,24(s1)
    80002462:	4789                	li	a5,2
    80002464:	00f70d63          	beq	a4,a5,8000247e <kill+0x60>
      release(&p->lock);
    80002468:	8526                	mv	a0,s1
    8000246a:	823fe0ef          	jal	80000c8c <release>
      return 0;
    8000246e:	4501                	li	a0,0
}
    80002470:	70a2                	ld	ra,40(sp)
    80002472:	7402                	ld	s0,32(sp)
    80002474:	64e2                	ld	s1,24(sp)
    80002476:	6942                	ld	s2,16(sp)
    80002478:	69a2                	ld	s3,8(sp)
    8000247a:	6145                	addi	sp,sp,48
    8000247c:	8082                	ret
        p->state = RUNNABLE;
    8000247e:	478d                	li	a5,3
    80002480:	cc9c                	sw	a5,24(s1)
        enqueue(p);
    80002482:	8526                	mv	a0,s1
    80002484:	b33ff0ef          	jal	80001fb6 <enqueue>
    80002488:	b7c5                	j	80002468 <kill+0x4a>

000000008000248a <dequeue>:

struct proc*
dequeue(int level)
{
    8000248a:	7179                	addi	sp,sp,-48
    8000248c:	f406                	sd	ra,40(sp)
    8000248e:	f022                	sd	s0,32(sp)
    80002490:	ec26                	sd	s1,24(sp)
    80002492:	e84a                	sd	s2,16(sp)
    80002494:	e44e                	sd	s3,8(sp)
    80002496:	1800                	addi	s0,sp,48
    80002498:	84aa                	mv	s1,a0
  struct proc *ret;

  acquire(&mlfq[level].lock);
    8000249a:	00251913          	slli	s2,a0,0x2
    8000249e:	00a907b3          	add	a5,s2,a0
    800024a2:	078e                	slli	a5,a5,0x3
    800024a4:	00010997          	auipc	s3,0x10
    800024a8:	5d498993          	addi	s3,s3,1492 # 80012a78 <mlfq>
    800024ac:	99be                	add	s3,s3,a5
    800024ae:	854e                	mv	a0,s3
    800024b0:	f44fe0ef          	jal	80000bf4 <acquire>
  if((ret = mlfq[level].head)) {
    800024b4:	9926                	add	s2,s2,s1
    800024b6:	090e                	slli	s2,s2,0x3
    800024b8:	00010797          	auipc	a5,0x10
    800024bc:	17878793          	addi	a5,a5,376 # 80012630 <cpus>
    800024c0:	97ca                	add	a5,a5,s2
    800024c2:	4607b903          	ld	s2,1120(a5)
    800024c6:	02090263          	beqz	s2,800024ea <dequeue+0x60>
    mlfq[level].head = ret->next;
    800024ca:	16893683          	ld	a3,360(s2)
    800024ce:	00249793          	slli	a5,s1,0x2
    800024d2:	97a6                	add	a5,a5,s1
    800024d4:	078e                	slli	a5,a5,0x3
    800024d6:	00010717          	auipc	a4,0x10
    800024da:	15a70713          	addi	a4,a4,346 # 80012630 <cpus>
    800024de:	97ba                	add	a5,a5,a4
    800024e0:	46d7b023          	sd	a3,1120(a5)
    if (mlfq[level].head == 0)
    800024e4:	ce91                	beqz	a3,80002500 <dequeue+0x76>
      mlfq[level].tail = 0;
    ret->next = 0;
    800024e6:	16093423          	sd	zero,360(s2)
  }
  release(&mlfq[level].lock);
    800024ea:	854e                	mv	a0,s3
    800024ec:	fa0fe0ef          	jal	80000c8c <release>

  return ret;
}
    800024f0:	854a                	mv	a0,s2
    800024f2:	70a2                	ld	ra,40(sp)
    800024f4:	7402                	ld	s0,32(sp)
    800024f6:	64e2                	ld	s1,24(sp)
    800024f8:	6942                	ld	s2,16(sp)
    800024fa:	69a2                	ld	s3,8(sp)
    800024fc:	6145                	addi	sp,sp,48
    800024fe:	8082                	ret
      mlfq[level].tail = 0;
    80002500:	00249793          	slli	a5,s1,0x2
    80002504:	97a6                	add	a5,a5,s1
    80002506:	078e                	slli	a5,a5,0x3
    80002508:	97ba                	add	a5,a5,a4
    8000250a:	4607b423          	sd	zero,1128(a5)
    8000250e:	bfe1                	j	800024e6 <dequeue+0x5c>

0000000080002510 <scheduler>:
{
    80002510:	711d                	addi	sp,sp,-96
    80002512:	ec86                	sd	ra,88(sp)
    80002514:	e8a2                	sd	s0,80(sp)
    80002516:	e4a6                	sd	s1,72(sp)
    80002518:	e0ca                	sd	s2,64(sp)
    8000251a:	fc4e                	sd	s3,56(sp)
    8000251c:	f852                	sd	s4,48(sp)
    8000251e:	f456                	sd	s5,40(sp)
    80002520:	f05a                	sd	s6,32(sp)
    80002522:	ec5e                	sd	s7,24(sp)
    80002524:	e862                	sd	s8,16(sp)
    80002526:	e466                	sd	s9,8(sp)
    80002528:	e06a                	sd	s10,0(sp)
    8000252a:	1080                	addi	s0,sp,96
    8000252c:	8792                	mv	a5,tp
  int id = r_tp();
    8000252e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002530:	00010c17          	auipc	s8,0x10
    80002534:	100c0c13          	addi	s8,s8,256 # 80012630 <cpus>
    80002538:	00779713          	slli	a4,a5,0x7
    8000253c:	00ec06b3          	add	a3,s8,a4
    80002540:	0006b023          	sd	zero,0(a3)
      swtch(&c->context, &p->context);
    80002544:	0721                	addi	a4,a4,8
    80002546:	9c3a                	add	s8,s8,a4
  struct proc *current_proc = 0;
    80002548:	4b81                	li	s7,0
    switch (sched_mode) {
    8000254a:	00008a17          	auipc	s4,0x8
    8000254e:	faea0a13          	addi	s4,s4,-82 # 8000a4f8 <sched_mode>
      p->state = RUNNING;
    80002552:	4c91                	li	s9,4
      c->proc = p;
    80002554:	00010d17          	auipc	s10,0x10
    80002558:	0dcd0d13          	addi	s10,s10,220 # 80012630 <cpus>
    8000255c:	8b36                	mv	s6,a3
      if(sched_mode == MLFQ) {
    8000255e:	4a85                	li	s5,1
        for(int level = 0; level < 6; level++) {
    80002560:	4999                	li	s3,6
    80002562:	a09d                	j	800025c8 <scheduler+0xb8>
        if(((p = dequeue(0)) != 0) && (p == current_proc) && mlfq[0].head) {
    80002564:	4501                	li	a0,0
    80002566:	f25ff0ef          	jal	8000248a <dequeue>
    8000256a:	84aa                	mv	s1,a0
    8000256c:	c531                	beqz	a0,800025b8 <scheduler+0xa8>
    8000256e:	02ab8a63          	beq	s7,a0,800025a2 <scheduler+0x92>
      acquire(&p->lock);
    80002572:	8926                	mv	s2,s1
    80002574:	8526                	mv	a0,s1
    80002576:	e7efe0ef          	jal	80000bf4 <acquire>
      p->state = RUNNING;
    8000257a:	0194ac23          	sw	s9,24(s1)
      c->proc = p;
    8000257e:	009b3023          	sd	s1,0(s6)
      swtch(&c->context, &p->context);
    80002582:	06048593          	addi	a1,s1,96
    80002586:	8562                	mv	a0,s8
    80002588:	2e4000ef          	jal	8000286c <swtch>
      if(sched_mode == MLFQ) {
    8000258c:	000a2783          	lw	a5,0(s4)
    80002590:	07578163          	beq	a5,s5,800025f2 <scheduler+0xe2>
      c->proc = 0;
    80002594:	000b3023          	sd	zero,0(s6)
      release(&p->lock);
    80002598:	854a                	mv	a0,s2
    8000259a:	ef2fe0ef          	jal	80000c8c <release>
      current_proc = p;
    8000259e:	8ba6                	mv	s7,s1
    800025a0:	a025                	j	800025c8 <scheduler+0xb8>
        if(((p = dequeue(0)) != 0) && (p == current_proc) && mlfq[0].head) {
    800025a2:	460d3783          	ld	a5,1120(s10)
    800025a6:	d7f1                	beqz	a5,80002572 <scheduler+0x62>
          p = dequeue(0);
    800025a8:	4501                	li	a0,0
    800025aa:	ee1ff0ef          	jal	8000248a <dequeue>
    800025ae:	84aa                	mv	s1,a0
          enqueue(current_proc);
    800025b0:	855e                	mv	a0,s7
    800025b2:	a05ff0ef          	jal	80001fb6 <enqueue>
    if(p) {
    800025b6:	fcd5                	bnez	s1,80002572 <scheduler+0x62>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025bc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025c0:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    800025c4:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025d0:	10079073          	csrw	sstatus,a5
    switch (sched_mode) {
    800025d4:	000a2783          	lw	a5,0(s4)
    800025d8:	d7d1                	beqz	a5,80002564 <scheduler+0x54>
    800025da:	fd579fe3          	bne	a5,s5,800025b8 <scheduler+0xa8>
    800025de:	4901                	li	s2,0
          if((p = dequeue(level)) != 0)
    800025e0:	854a                	mv	a0,s2
    800025e2:	ea9ff0ef          	jal	8000248a <dequeue>
    800025e6:	84aa                	mv	s1,a0
    800025e8:	f549                	bnez	a0,80002572 <scheduler+0x62>
        for(int level = 0; level < 6; level++) {
    800025ea:	2905                	addiw	s2,s2,1
    800025ec:	ff391ae3          	bne	s2,s3,800025e0 <scheduler+0xd0>
    800025f0:	b7e1                	j	800025b8 <scheduler+0xa8>
        if(++p->time_quantum >= 2*p->level + 1) {
    800025f2:	1744a703          	lw	a4,372(s1)
    800025f6:	1704a783          	lw	a5,368(s1)
    800025fa:	2785                	addiw	a5,a5,1
    800025fc:	0007869b          	sext.w	a3,a5
    80002600:	16f4a823          	sw	a5,368(s1)
    80002604:	0017179b          	slliw	a5,a4,0x1
    80002608:	f8d7d6e3          	bge	a5,a3,80002594 <scheduler+0x84>
          if(p->level < 2) {
    8000260c:	00eada63          	bge	s5,a4,80002620 <scheduler+0x110>
          }else if(p->priority > 0)
    80002610:	1784a783          	lw	a5,376(s1)
    80002614:	f8f050e3          	blez	a5,80002594 <scheduler+0x84>
            p->priority--;
    80002618:	37fd                	addiw	a5,a5,-1
    8000261a:	16f4ac23          	sw	a5,376(s1)
    8000261e:	bf9d                	j	80002594 <scheduler+0x84>
            p->level++;
    80002620:	2705                	addiw	a4,a4,1
    80002622:	16e4aa23          	sw	a4,372(s1)
            p->time_quantum = 0;
    80002626:	1604a823          	sw	zero,368(s1)
    8000262a:	b7ad                	j	80002594 <scheduler+0x84>

000000008000262c <mlfqinit>:
{
    8000262c:	1101                	addi	sp,sp,-32
    8000262e:	ec06                	sd	ra,24(sp)
    80002630:	e822                	sd	s0,16(sp)
    80002632:	e426                	sd	s1,8(sp)
    80002634:	e04a                	sd	s2,0(sp)
    80002636:	1000                	addi	s0,sp,32
  printf("[Boost] ticks: %d\n", ticks);
    80002638:	00008597          	auipc	a1,0x8
    8000263c:	ed05a583          	lw	a1,-304(a1) # 8000a508 <ticks>
    80002640:	00005517          	auipc	a0,0x5
    80002644:	c9050513          	addi	a0,a0,-880 # 800072d0 <etext+0x2d0>
    80002648:	e7bfd0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000264c:	00010797          	auipc	a5,0x10
    80002650:	51c78793          	addi	a5,a5,1308 # 80012b68 <proc>
    p->priority = 3;
    80002654:	468d                	li	a3,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002656:	00016717          	auipc	a4,0x16
    8000265a:	51270713          	addi	a4,a4,1298 # 80018b68 <tickslock>
    p->time_quantum = 0;
    8000265e:	1607a823          	sw	zero,368(a5)
    p->level = 0;
    80002662:	1607aa23          	sw	zero,372(a5)
    p->priority = 3;
    80002666:	16d7ac23          	sw	a3,376(a5)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000266a:	18078793          	addi	a5,a5,384
    8000266e:	fee798e3          	bne	a5,a4,8000265e <mlfqinit+0x32>
  for(int lv = 1; lv < 6; lv++) {
    80002672:	4485                	li	s1,1
    80002674:	4919                	li	s2,6
    80002676:	a019                	j	8000267c <mlfqinit+0x50>
      enqueue(p);
    80002678:	93fff0ef          	jal	80001fb6 <enqueue>
    while((p = dequeue(lv))) {
    8000267c:	8526                	mv	a0,s1
    8000267e:	e0dff0ef          	jal	8000248a <dequeue>
    80002682:	f97d                	bnez	a0,80002678 <mlfqinit+0x4c>
  for(int lv = 1; lv < 6; lv++) {
    80002684:	2485                	addiw	s1,s1,1
    80002686:	ff249be3          	bne	s1,s2,8000267c <mlfqinit+0x50>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6902                	ld	s2,0(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret

0000000080002696 <setpriority>:

int
setpriority(int pid, int priority)
{
    80002696:	7179                	addi	sp,sp,-48
    80002698:	f406                	sd	ra,40(sp)
    8000269a:	f022                	sd	s0,32(sp)
    8000269c:	ec26                	sd	s1,24(sp)
    8000269e:	e84a                	sd	s2,16(sp)
    800026a0:	e44e                	sd	s3,8(sp)
    800026a2:	e052                	sd	s4,0(sp)
    800026a4:	1800                	addi	s0,sp,48
    800026a6:	892a                	mv	s2,a0
    800026a8:	8a2e                	mv	s4,a1
  if(priority < 0 && priority > 3)
    return -2;

  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800026aa:	00010497          	auipc	s1,0x10
    800026ae:	4be48493          	addi	s1,s1,1214 # 80012b68 <proc>
    800026b2:	00016997          	auipc	s3,0x16
    800026b6:	4b698993          	addi	s3,s3,1206 # 80018b68 <tickslock>
    acquire(&p->lock);
    800026ba:	8526                	mv	a0,s1
    800026bc:	d38fe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    800026c0:	589c                	lw	a5,48(s1)
    800026c2:	01278b63          	beq	a5,s2,800026d8 <setpriority+0x42>
      p->priority = priority;
      return 0;
    }
    release(&p->lock);
    800026c6:	8526                	mv	a0,s1
    800026c8:	dc4fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800026cc:	18048493          	addi	s1,s1,384
    800026d0:	ff3495e3          	bne	s1,s3,800026ba <setpriority+0x24>
  }
  return -1;
    800026d4:	557d                	li	a0,-1
    800026d6:	a021                	j	800026de <setpriority+0x48>
      p->priority = priority;
    800026d8:	1744ac23          	sw	s4,376(s1)
      return 0;
    800026dc:	4501                	li	a0,0
}
    800026de:	70a2                	ld	ra,40(sp)
    800026e0:	7402                	ld	s0,32(sp)
    800026e2:	64e2                	ld	s1,24(sp)
    800026e4:	6942                	ld	s2,16(sp)
    800026e6:	69a2                	ld	s3,8(sp)
    800026e8:	6a02                	ld	s4,0(sp)
    800026ea:	6145                	addi	sp,sp,48
    800026ec:	8082                	ret

00000000800026ee <mlfqmode>:

int
mlfqmode(void)
{
    800026ee:	1141                	addi	sp,sp,-16
    800026f0:	e406                	sd	ra,8(sp)
    800026f2:	e022                	sd	s0,0(sp)
    800026f4:	0800                	addi	s0,sp,16
  acquire(&sched_mode_lock);
    800026f6:	00010517          	auipc	a0,0x10
    800026fa:	36a50513          	addi	a0,a0,874 # 80012a60 <sched_mode_lock>
    800026fe:	cf6fe0ef          	jal	80000bf4 <acquire>
  if(sched_mode == MLFQ) {
    80002702:	00008717          	auipc	a4,0x8
    80002706:	df672703          	lw	a4,-522(a4) # 8000a4f8 <sched_mode>
    8000270a:	4785                	li	a5,1
    8000270c:	04f70463          	beq	a4,a5,80002754 <mlfqmode+0x66>
    printf("Already in MFLQ\n");
    release(&sched_mode_lock);
    return -1;
  }
  else {
    sched_mode = MLFQ;
    80002710:	4785                	li	a5,1
    80002712:	00008717          	auipc	a4,0x8
    80002716:	def72323          	sw	a5,-538(a4) # 8000a4f8 <sched_mode>

    mlfqinit();
    8000271a:	f13ff0ef          	jal	8000262c <mlfqinit>

    acquire(&tickslock);
    8000271e:	00016517          	auipc	a0,0x16
    80002722:	44a50513          	addi	a0,a0,1098 # 80018b68 <tickslock>
    80002726:	ccefe0ef          	jal	80000bf4 <acquire>
    ticks = 0;
    8000272a:	00008797          	auipc	a5,0x8
    8000272e:	dc07af23          	sw	zero,-546(a5) # 8000a508 <ticks>
    release(&tickslock);
    80002732:	00016517          	auipc	a0,0x16
    80002736:	43650513          	addi	a0,a0,1078 # 80018b68 <tickslock>
    8000273a:	d52fe0ef          	jal	80000c8c <release>

    release(&sched_mode_lock);
    8000273e:	00010517          	auipc	a0,0x10
    80002742:	32250513          	addi	a0,a0,802 # 80012a60 <sched_mode_lock>
    80002746:	d46fe0ef          	jal	80000c8c <release>

    return 0;
    8000274a:	4501                	li	a0,0
  }
}
    8000274c:	60a2                	ld	ra,8(sp)
    8000274e:	6402                	ld	s0,0(sp)
    80002750:	0141                	addi	sp,sp,16
    80002752:	8082                	ret
    printf("Already in MFLQ\n");
    80002754:	00005517          	auipc	a0,0x5
    80002758:	b9450513          	addi	a0,a0,-1132 # 800072e8 <etext+0x2e8>
    8000275c:	d67fd0ef          	jal	800004c2 <printf>
    release(&sched_mode_lock);
    80002760:	00010517          	auipc	a0,0x10
    80002764:	30050513          	addi	a0,a0,768 # 80012a60 <sched_mode_lock>
    80002768:	d24fe0ef          	jal	80000c8c <release>
    return -1;
    8000276c:	557d                	li	a0,-1
    8000276e:	bff9                	j	8000274c <mlfqmode+0x5e>

0000000080002770 <fcfsmode>:

int
fcfsmode(void)
{
    80002770:	7179                	addi	sp,sp,-48
    80002772:	f406                	sd	ra,40(sp)
    80002774:	f022                	sd	s0,32(sp)
    80002776:	1800                	addi	s0,sp,48
  acquire(&sched_mode_lock);
    80002778:	00010517          	auipc	a0,0x10
    8000277c:	2e850513          	addi	a0,a0,744 # 80012a60 <sched_mode_lock>
    80002780:	c74fe0ef          	jal	80000bf4 <acquire>
  if(sched_mode == FCFS) {
    80002784:	00008797          	auipc	a5,0x8
    80002788:	d747a783          	lw	a5,-652(a5) # 8000a4f8 <sched_mode>
    8000278c:	cbb1                	beqz	a5,800027e0 <fcfsmode+0x70>
    8000278e:	ec26                	sd	s1,24(sp)
    80002790:	e84a                	sd	s2,16(sp)
    80002792:	e44e                	sd	s3,8(sp)
    80002794:	e052                	sd	s4,0(sp)
    return -1;
  }
  else {
    struct proc* p;

    sched_mode = FCFS;
    80002796:	00008797          	auipc	a5,0x8
    8000279a:	d607a123          	sw	zero,-670(a5) # 8000a4f8 <sched_mode>

    for(int lv = 0; lv < 6; lv++) {
    8000279e:	00010497          	auipc	s1,0x10
    800027a2:	2da48493          	addi	s1,s1,730 # 80012a78 <mlfq>
    800027a6:	00010917          	auipc	s2,0x10
    800027aa:	3c290913          	addi	s2,s2,962 # 80012b68 <proc>
      acquire(&mlfq[lv].lock);
    800027ae:	8526                	mv	a0,s1
    800027b0:	c44fe0ef          	jal	80000bf4 <acquire>
      mlfq[lv].head = 0;
    800027b4:	0004bc23          	sd	zero,24(s1)
      mlfq[lv].tail = 0;
    800027b8:	0204b023          	sd	zero,32(s1)
      release(&mlfq[lv].lock);
    800027bc:	8526                	mv	a0,s1
    800027be:	ccefe0ef          	jal	80000c8c <release>
    for(int lv = 0; lv < 6; lv++) {
    800027c2:	02848493          	addi	s1,s1,40
    800027c6:	ff2494e3          	bne	s1,s2,800027ae <fcfsmode+0x3e>
    }

    for(p = proc; p < &proc[NPROC]; p++) {
    800027ca:	00010497          	auipc	s1,0x10
    800027ce:	39e48493          	addi	s1,s1,926 # 80012b68 <proc>
      acquire(&p->lock);
      p->next = 0;
      p->time_quantum = -1;
    800027d2:	597d                	li	s2,-1
      p->level = -1;
      p->priority = -1;
      if(p->state == RUNNABLE)
    800027d4:	4a0d                	li	s4,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800027d6:	00016997          	auipc	s3,0x16
    800027da:	39298993          	addi	s3,s3,914 # 80018b68 <tickslock>
    800027de:	a035                	j	8000280a <fcfsmode+0x9a>
    printf("Already in FCFS\n");
    800027e0:	00005517          	auipc	a0,0x5
    800027e4:	b2050513          	addi	a0,a0,-1248 # 80007300 <etext+0x300>
    800027e8:	cdbfd0ef          	jal	800004c2 <printf>
    release(&sched_mode_lock);
    800027ec:	00010517          	auipc	a0,0x10
    800027f0:	27450513          	addi	a0,a0,628 # 80012a60 <sched_mode_lock>
    800027f4:	c98fe0ef          	jal	80000c8c <release>
    return -1;
    800027f8:	557d                	li	a0,-1
    800027fa:	a0ad                	j	80002864 <fcfsmode+0xf4>
        enqueue(p);
      release(&p->lock);
    800027fc:	8526                	mv	a0,s1
    800027fe:	c8efe0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002802:	18048493          	addi	s1,s1,384
    80002806:	03348463          	beq	s1,s3,8000282e <fcfsmode+0xbe>
      acquire(&p->lock);
    8000280a:	8526                	mv	a0,s1
    8000280c:	be8fe0ef          	jal	80000bf4 <acquire>
      p->next = 0;
    80002810:	1604b423          	sd	zero,360(s1)
      p->time_quantum = -1;
    80002814:	1724a823          	sw	s2,368(s1)
      p->level = -1;
    80002818:	1724aa23          	sw	s2,372(s1)
      p->priority = -1;
    8000281c:	1724ac23          	sw	s2,376(s1)
      if(p->state == RUNNABLE)
    80002820:	4c9c                	lw	a5,24(s1)
    80002822:	fd479de3          	bne	a5,s4,800027fc <fcfsmode+0x8c>
        enqueue(p);
    80002826:	8526                	mv	a0,s1
    80002828:	f8eff0ef          	jal	80001fb6 <enqueue>
    8000282c:	bfc1                	j	800027fc <fcfsmode+0x8c>
    }

    acquire(&tickslock);
    8000282e:	00016517          	auipc	a0,0x16
    80002832:	33a50513          	addi	a0,a0,826 # 80018b68 <tickslock>
    80002836:	bbefe0ef          	jal	80000bf4 <acquire>
    ticks = 0;
    8000283a:	00008797          	auipc	a5,0x8
    8000283e:	cc07a723          	sw	zero,-818(a5) # 8000a508 <ticks>
    release(&tickslock);
    80002842:	00016517          	auipc	a0,0x16
    80002846:	32650513          	addi	a0,a0,806 # 80018b68 <tickslock>
    8000284a:	c42fe0ef          	jal	80000c8c <release>
    
    release(&sched_mode_lock);
    8000284e:	00010517          	auipc	a0,0x10
    80002852:	21250513          	addi	a0,a0,530 # 80012a60 <sched_mode_lock>
    80002856:	c36fe0ef          	jal	80000c8c <release>

    return 0;
    8000285a:	4501                	li	a0,0
    8000285c:	64e2                	ld	s1,24(sp)
    8000285e:	6942                	ld	s2,16(sp)
    80002860:	69a2                	ld	s3,8(sp)
    80002862:	6a02                	ld	s4,0(sp)
  }
    80002864:	70a2                	ld	ra,40(sp)
    80002866:	7402                	ld	s0,32(sp)
    80002868:	6145                	addi	sp,sp,48
    8000286a:	8082                	ret

000000008000286c <swtch>:
    8000286c:	00153023          	sd	ra,0(a0)
    80002870:	00253423          	sd	sp,8(a0)
    80002874:	e900                	sd	s0,16(a0)
    80002876:	ed04                	sd	s1,24(a0)
    80002878:	03253023          	sd	s2,32(a0)
    8000287c:	03353423          	sd	s3,40(a0)
    80002880:	03453823          	sd	s4,48(a0)
    80002884:	03553c23          	sd	s5,56(a0)
    80002888:	05653023          	sd	s6,64(a0)
    8000288c:	05753423          	sd	s7,72(a0)
    80002890:	05853823          	sd	s8,80(a0)
    80002894:	05953c23          	sd	s9,88(a0)
    80002898:	07a53023          	sd	s10,96(a0)
    8000289c:	07b53423          	sd	s11,104(a0)
    800028a0:	0005b083          	ld	ra,0(a1)
    800028a4:	0085b103          	ld	sp,8(a1)
    800028a8:	6980                	ld	s0,16(a1)
    800028aa:	6d84                	ld	s1,24(a1)
    800028ac:	0205b903          	ld	s2,32(a1)
    800028b0:	0285b983          	ld	s3,40(a1)
    800028b4:	0305ba03          	ld	s4,48(a1)
    800028b8:	0385ba83          	ld	s5,56(a1)
    800028bc:	0405bb03          	ld	s6,64(a1)
    800028c0:	0485bb83          	ld	s7,72(a1)
    800028c4:	0505bc03          	ld	s8,80(a1)
    800028c8:	0585bc83          	ld	s9,88(a1)
    800028cc:	0605bd03          	ld	s10,96(a1)
    800028d0:	0685bd83          	ld	s11,104(a1)
    800028d4:	8082                	ret

00000000800028d6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800028d6:	1141                	addi	sp,sp,-16
    800028d8:	e406                	sd	ra,8(sp)
    800028da:	e022                	sd	s0,0(sp)
    800028dc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800028de:	00005597          	auipc	a1,0x5
    800028e2:	a6a58593          	addi	a1,a1,-1430 # 80007348 <etext+0x348>
    800028e6:	00016517          	auipc	a0,0x16
    800028ea:	28250513          	addi	a0,a0,642 # 80018b68 <tickslock>
    800028ee:	a86fe0ef          	jal	80000b74 <initlock>
}
    800028f2:	60a2                	ld	ra,8(sp)
    800028f4:	6402                	ld	s0,0(sp)
    800028f6:	0141                	addi	sp,sp,16
    800028f8:	8082                	ret

00000000800028fa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800028fa:	1141                	addi	sp,sp,-16
    800028fc:	e422                	sd	s0,8(sp)
    800028fe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002900:	00003797          	auipc	a5,0x3
    80002904:	f2078793          	addi	a5,a5,-224 # 80005820 <kernelvec>
    80002908:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000290c:	6422                	ld	s0,8(sp)
    8000290e:	0141                	addi	sp,sp,16
    80002910:	8082                	ret

0000000080002912 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002912:	1141                	addi	sp,sp,-16
    80002914:	e406                	sd	ra,8(sp)
    80002916:	e022                	sd	s0,0(sp)
    80002918:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000291a:	f11fe0ef          	jal	8000182a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000291e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002922:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002924:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002928:	00003697          	auipc	a3,0x3
    8000292c:	6d868693          	addi	a3,a3,1752 # 80006000 <_trampoline>
    80002930:	00003717          	auipc	a4,0x3
    80002934:	6d070713          	addi	a4,a4,1744 # 80006000 <_trampoline>
    80002938:	8f15                	sub	a4,a4,a3
    8000293a:	040007b7          	lui	a5,0x4000
    8000293e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002940:	07b2                	slli	a5,a5,0xc
    80002942:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002944:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002948:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000294a:	18002673          	csrr	a2,satp
    8000294e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002950:	6d30                	ld	a2,88(a0)
    80002952:	6138                	ld	a4,64(a0)
    80002954:	6585                	lui	a1,0x1
    80002956:	972e                	add	a4,a4,a1
    80002958:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000295a:	6d38                	ld	a4,88(a0)
    8000295c:	00000617          	auipc	a2,0x0
    80002960:	11060613          	addi	a2,a2,272 # 80002a6c <usertrap>
    80002964:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002966:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002968:	8612                	mv	a2,tp
    8000296a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000296c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002970:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002974:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002978:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000297c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000297e:	6f18                	ld	a4,24(a4)
    80002980:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002984:	6928                	ld	a0,80(a0)
    80002986:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002988:	00003717          	auipc	a4,0x3
    8000298c:	71470713          	addi	a4,a4,1812 # 8000609c <userret>
    80002990:	8f15                	sub	a4,a4,a3
    80002992:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002994:	577d                	li	a4,-1
    80002996:	177e                	slli	a4,a4,0x3f
    80002998:	8d59                	or	a0,a0,a4
    8000299a:	9782                	jalr	a5
}
    8000299c:	60a2                	ld	ra,8(sp)
    8000299e:	6402                	ld	s0,0(sp)
    800029a0:	0141                	addi	sp,sp,16
    800029a2:	8082                	ret

00000000800029a4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800029a4:	1101                	addi	sp,sp,-32
    800029a6:	ec06                	sd	ra,24(sp)
    800029a8:	e822                	sd	s0,16(sp)
    800029aa:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800029ac:	e53fe0ef          	jal	800017fe <cpuid>
    800029b0:	cd11                	beqz	a0,800029cc <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800029b2:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800029b6:	000f4737          	lui	a4,0xf4
    800029ba:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800029be:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800029c0:	14d79073          	csrw	stimecmp,a5
}
    800029c4:	60e2                	ld	ra,24(sp)
    800029c6:	6442                	ld	s0,16(sp)
    800029c8:	6105                	addi	sp,sp,32
    800029ca:	8082                	ret
    800029cc:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800029ce:	00016497          	auipc	s1,0x16
    800029d2:	19a48493          	addi	s1,s1,410 # 80018b68 <tickslock>
    800029d6:	8526                	mv	a0,s1
    800029d8:	a1cfe0ef          	jal	80000bf4 <acquire>
    ticks++;
    800029dc:	00008517          	auipc	a0,0x8
    800029e0:	b2c50513          	addi	a0,a0,-1236 # 8000a508 <ticks>
    800029e4:	411c                	lw	a5,0(a0)
    800029e6:	2785                	addiw	a5,a5,1
    800029e8:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800029ea:	8cdff0ef          	jal	800022b6 <wakeup>
    release(&tickslock);
    800029ee:	8526                	mv	a0,s1
    800029f0:	a9cfe0ef          	jal	80000c8c <release>
    800029f4:	64a2                	ld	s1,8(sp)
    800029f6:	bf75                	j	800029b2 <clockintr+0xe>

00000000800029f8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800029f8:	1101                	addi	sp,sp,-32
    800029fa:	ec06                	sd	ra,24(sp)
    800029fc:	e822                	sd	s0,16(sp)
    800029fe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a00:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002a04:	57fd                	li	a5,-1
    80002a06:	17fe                	slli	a5,a5,0x3f
    80002a08:	07a5                	addi	a5,a5,9
    80002a0a:	00f70c63          	beq	a4,a5,80002a22 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002a0e:	57fd                	li	a5,-1
    80002a10:	17fe                	slli	a5,a5,0x3f
    80002a12:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002a14:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002a16:	04f70763          	beq	a4,a5,80002a64 <devintr+0x6c>
  }
}
    80002a1a:	60e2                	ld	ra,24(sp)
    80002a1c:	6442                	ld	s0,16(sp)
    80002a1e:	6105                	addi	sp,sp,32
    80002a20:	8082                	ret
    80002a22:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002a24:	6a9020ef          	jal	800058cc <plic_claim>
    80002a28:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002a2a:	47a9                	li	a5,10
    80002a2c:	00f50963          	beq	a0,a5,80002a3e <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002a30:	4785                	li	a5,1
    80002a32:	00f50963          	beq	a0,a5,80002a44 <devintr+0x4c>
    return 1;
    80002a36:	4505                	li	a0,1
    } else if(irq){
    80002a38:	e889                	bnez	s1,80002a4a <devintr+0x52>
    80002a3a:	64a2                	ld	s1,8(sp)
    80002a3c:	bff9                	j	80002a1a <devintr+0x22>
      uartintr();
    80002a3e:	fc9fd0ef          	jal	80000a06 <uartintr>
    if(irq)
    80002a42:	a819                	j	80002a58 <devintr+0x60>
      virtio_disk_intr();
    80002a44:	34e030ef          	jal	80005d92 <virtio_disk_intr>
    if(irq)
    80002a48:	a801                	j	80002a58 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002a4a:	85a6                	mv	a1,s1
    80002a4c:	00005517          	auipc	a0,0x5
    80002a50:	90450513          	addi	a0,a0,-1788 # 80007350 <etext+0x350>
    80002a54:	a6ffd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    80002a58:	8526                	mv	a0,s1
    80002a5a:	693020ef          	jal	800058ec <plic_complete>
    return 1;
    80002a5e:	4505                	li	a0,1
    80002a60:	64a2                	ld	s1,8(sp)
    80002a62:	bf65                	j	80002a1a <devintr+0x22>
    clockintr();
    80002a64:	f41ff0ef          	jal	800029a4 <clockintr>
    return 2;
    80002a68:	4509                	li	a0,2
    80002a6a:	bf45                	j	80002a1a <devintr+0x22>

0000000080002a6c <usertrap>:
{
    80002a6c:	1101                	addi	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	e04a                	sd	s2,0(sp)
    80002a76:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a78:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002a7c:	1007f793          	andi	a5,a5,256
    80002a80:	ebb1                	bnez	a5,80002ad4 <usertrap+0x68>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a82:	00003797          	auipc	a5,0x3
    80002a86:	d9e78793          	addi	a5,a5,-610 # 80005820 <kernelvec>
    80002a8a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002a8e:	d9dfe0ef          	jal	8000182a <myproc>
    80002a92:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002a94:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a96:	14102773          	csrr	a4,sepc
    80002a9a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a9c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002aa0:	47a1                	li	a5,8
    80002aa2:	02f70f63          	beq	a4,a5,80002ae0 <usertrap+0x74>
  } else if((which_dev = devintr()) != 0){
    80002aa6:	f53ff0ef          	jal	800029f8 <devintr>
    80002aaa:	892a                	mv	s2,a0
    80002aac:	cd39                	beqz	a0,80002b0a <usertrap+0x9e>
  if(killed(p))
    80002aae:	8526                	mv	a0,s1
    80002ab0:	988ff0ef          	jal	80001c38 <killed>
    80002ab4:	e151                	bnez	a0,80002b38 <usertrap+0xcc>
  if(sched_mode == MLFQ && which_dev == 2) {
    80002ab6:	00008717          	auipc	a4,0x8
    80002aba:	a4272703          	lw	a4,-1470(a4) # 8000a4f8 <sched_mode>
    80002abe:	4785                	li	a5,1
    80002ac0:	08f70063          	beq	a4,a5,80002b40 <usertrap+0xd4>
  usertrapret();
    80002ac4:	e4fff0ef          	jal	80002912 <usertrapret>
}
    80002ac8:	60e2                	ld	ra,24(sp)
    80002aca:	6442                	ld	s0,16(sp)
    80002acc:	64a2                	ld	s1,8(sp)
    80002ace:	6902                	ld	s2,0(sp)
    80002ad0:	6105                	addi	sp,sp,32
    80002ad2:	8082                	ret
    panic("usertrap: not from user mode");
    80002ad4:	00005517          	auipc	a0,0x5
    80002ad8:	89c50513          	addi	a0,a0,-1892 # 80007370 <etext+0x370>
    80002adc:	cb9fd0ef          	jal	80000794 <panic>
    if(killed(p))
    80002ae0:	958ff0ef          	jal	80001c38 <killed>
    80002ae4:	ed19                	bnez	a0,80002b02 <usertrap+0x96>
    p->trapframe->epc += 4;
    80002ae6:	6cb8                	ld	a4,88(s1)
    80002ae8:	6f1c                	ld	a5,24(a4)
    80002aea:	0791                	addi	a5,a5,4
    80002aec:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002aee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002af2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002af6:	10079073          	csrw	sstatus,a5
    syscall();
    80002afa:	2a6000ef          	jal	80002da0 <syscall>
  int which_dev = 0;
    80002afe:	4901                	li	s2,0
    80002b00:	b77d                	j	80002aae <usertrap+0x42>
      exit(-1);
    80002b02:	557d                	li	a0,-1
    80002b04:	879ff0ef          	jal	8000237c <exit>
    80002b08:	bff9                	j	80002ae6 <usertrap+0x7a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b0a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002b0e:	5890                	lw	a2,48(s1)
    80002b10:	00005517          	auipc	a0,0x5
    80002b14:	88050513          	addi	a0,a0,-1920 # 80007390 <etext+0x390>
    80002b18:	9abfd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b1c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b20:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002b24:	00005517          	auipc	a0,0x5
    80002b28:	89c50513          	addi	a0,a0,-1892 # 800073c0 <etext+0x3c0>
    80002b2c:	997fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    80002b30:	8526                	mv	a0,s1
    80002b32:	8e2ff0ef          	jal	80001c14 <setkilled>
    80002b36:	bfa5                	j	80002aae <usertrap+0x42>
    exit(-1);
    80002b38:	557d                	li	a0,-1
    80002b3a:	843ff0ef          	jal	8000237c <exit>
    80002b3e:	bfa5                	j	80002ab6 <usertrap+0x4a>
  if(sched_mode == MLFQ && which_dev == 2) {
    80002b40:	4789                	li	a5,2
    80002b42:	f8f911e3          	bne	s2,a5,80002ac4 <usertrap+0x58>
    acquire(&tickslock);
    80002b46:	00016517          	auipc	a0,0x16
    80002b4a:	02250513          	addi	a0,a0,34 # 80018b68 <tickslock>
    80002b4e:	8a6fe0ef          	jal	80000bf4 <acquire>
    if((ticks % 50) == 0)
    80002b52:	00008797          	auipc	a5,0x8
    80002b56:	9b67a783          	lw	a5,-1610(a5) # 8000a508 <ticks>
    80002b5a:	03200713          	li	a4,50
    80002b5e:	02e7f7bb          	remuw	a5,a5,a4
    80002b62:	2781                	sext.w	a5,a5
    80002b64:	cb91                	beqz	a5,80002b78 <usertrap+0x10c>
    release(&tickslock);
    80002b66:	00016517          	auipc	a0,0x16
    80002b6a:	00250513          	addi	a0,a0,2 # 80018b68 <tickslock>
    80002b6e:	91efe0ef          	jal	80000c8c <release>
    yield();
    80002b72:	f12ff0ef          	jal	80002284 <yield>
    80002b76:	b7b9                	j	80002ac4 <usertrap+0x58>
      mlfqinit();
    80002b78:	ab5ff0ef          	jal	8000262c <mlfqinit>
    80002b7c:	b7ed                	j	80002b66 <usertrap+0xfa>

0000000080002b7e <kerneltrap>:
{
    80002b7e:	7179                	addi	sp,sp,-48
    80002b80:	f406                	sd	ra,40(sp)
    80002b82:	f022                	sd	s0,32(sp)
    80002b84:	ec26                	sd	s1,24(sp)
    80002b86:	e84a                	sd	s2,16(sp)
    80002b88:	e44e                	sd	s3,8(sp)
    80002b8a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b8c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b90:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b94:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002b98:	1004f793          	andi	a5,s1,256
    80002b9c:	cb95                	beqz	a5,80002bd0 <kerneltrap+0x52>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b9e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002ba2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002ba4:	ef85                	bnez	a5,80002bdc <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002ba6:	e53ff0ef          	jal	800029f8 <devintr>
    80002baa:	cd1d                	beqz	a0,80002be8 <kerneltrap+0x6a>
  if(sched_mode == MLFQ && which_dev == 2 && myproc() != 0) {
    80002bac:	00008717          	auipc	a4,0x8
    80002bb0:	94c72703          	lw	a4,-1716(a4) # 8000a4f8 <sched_mode>
    80002bb4:	4785                	li	a5,1
    80002bb6:	04f70a63          	beq	a4,a5,80002c0a <kerneltrap+0x8c>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bba:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bbe:	10049073          	csrw	sstatus,s1
}
    80002bc2:	70a2                	ld	ra,40(sp)
    80002bc4:	7402                	ld	s0,32(sp)
    80002bc6:	64e2                	ld	s1,24(sp)
    80002bc8:	6942                	ld	s2,16(sp)
    80002bca:	69a2                	ld	s3,8(sp)
    80002bcc:	6145                	addi	sp,sp,48
    80002bce:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002bd0:	00005517          	auipc	a0,0x5
    80002bd4:	81850513          	addi	a0,a0,-2024 # 800073e8 <etext+0x3e8>
    80002bd8:	bbdfd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002bdc:	00005517          	auipc	a0,0x5
    80002be0:	83450513          	addi	a0,a0,-1996 # 80007410 <etext+0x410>
    80002be4:	bb1fd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002be8:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002bec:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002bf0:	85ce                	mv	a1,s3
    80002bf2:	00005517          	auipc	a0,0x5
    80002bf6:	83e50513          	addi	a0,a0,-1986 # 80007430 <etext+0x430>
    80002bfa:	8c9fd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002bfe:	00005517          	auipc	a0,0x5
    80002c02:	85a50513          	addi	a0,a0,-1958 # 80007458 <etext+0x458>
    80002c06:	b8ffd0ef          	jal	80000794 <panic>
  if(sched_mode == MLFQ && which_dev == 2 && myproc() != 0) {
    80002c0a:	4789                	li	a5,2
    80002c0c:	faf517e3          	bne	a0,a5,80002bba <kerneltrap+0x3c>
    80002c10:	c1bfe0ef          	jal	8000182a <myproc>
    80002c14:	d15d                	beqz	a0,80002bba <kerneltrap+0x3c>
    acquire(&tickslock);
    80002c16:	00016517          	auipc	a0,0x16
    80002c1a:	f5250513          	addi	a0,a0,-174 # 80018b68 <tickslock>
    80002c1e:	fd7fd0ef          	jal	80000bf4 <acquire>
    if((ticks % 50) == 0)
    80002c22:	00008797          	auipc	a5,0x8
    80002c26:	8e67a783          	lw	a5,-1818(a5) # 8000a508 <ticks>
    80002c2a:	03200713          	li	a4,50
    80002c2e:	02e7f7bb          	remuw	a5,a5,a4
    80002c32:	2781                	sext.w	a5,a5
    80002c34:	cb91                	beqz	a5,80002c48 <kerneltrap+0xca>
    release(&tickslock);
    80002c36:	00016517          	auipc	a0,0x16
    80002c3a:	f3250513          	addi	a0,a0,-206 # 80018b68 <tickslock>
    80002c3e:	84efe0ef          	jal	80000c8c <release>
    yield();
    80002c42:	e42ff0ef          	jal	80002284 <yield>
    80002c46:	bf95                	j	80002bba <kerneltrap+0x3c>
      mlfqinit();
    80002c48:	9e5ff0ef          	jal	8000262c <mlfqinit>
    80002c4c:	b7ed                	j	80002c36 <kerneltrap+0xb8>

0000000080002c4e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002c4e:	1101                	addi	sp,sp,-32
    80002c50:	ec06                	sd	ra,24(sp)
    80002c52:	e822                	sd	s0,16(sp)
    80002c54:	e426                	sd	s1,8(sp)
    80002c56:	1000                	addi	s0,sp,32
    80002c58:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002c5a:	bd1fe0ef          	jal	8000182a <myproc>
  switch (n) {
    80002c5e:	4795                	li	a5,5
    80002c60:	0497e163          	bltu	a5,s1,80002ca2 <argraw+0x54>
    80002c64:	048a                	slli	s1,s1,0x2
    80002c66:	00005717          	auipc	a4,0x5
    80002c6a:	bb270713          	addi	a4,a4,-1102 # 80007818 <states.0+0x30>
    80002c6e:	94ba                	add	s1,s1,a4
    80002c70:	409c                	lw	a5,0(s1)
    80002c72:	97ba                	add	a5,a5,a4
    80002c74:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002c76:	6d3c                	ld	a5,88(a0)
    80002c78:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002c7a:	60e2                	ld	ra,24(sp)
    80002c7c:	6442                	ld	s0,16(sp)
    80002c7e:	64a2                	ld	s1,8(sp)
    80002c80:	6105                	addi	sp,sp,32
    80002c82:	8082                	ret
    return p->trapframe->a1;
    80002c84:	6d3c                	ld	a5,88(a0)
    80002c86:	7fa8                	ld	a0,120(a5)
    80002c88:	bfcd                	j	80002c7a <argraw+0x2c>
    return p->trapframe->a2;
    80002c8a:	6d3c                	ld	a5,88(a0)
    80002c8c:	63c8                	ld	a0,128(a5)
    80002c8e:	b7f5                	j	80002c7a <argraw+0x2c>
    return p->trapframe->a3;
    80002c90:	6d3c                	ld	a5,88(a0)
    80002c92:	67c8                	ld	a0,136(a5)
    80002c94:	b7dd                	j	80002c7a <argraw+0x2c>
    return p->trapframe->a4;
    80002c96:	6d3c                	ld	a5,88(a0)
    80002c98:	6bc8                	ld	a0,144(a5)
    80002c9a:	b7c5                	j	80002c7a <argraw+0x2c>
    return p->trapframe->a5;
    80002c9c:	6d3c                	ld	a5,88(a0)
    80002c9e:	6fc8                	ld	a0,152(a5)
    80002ca0:	bfe9                	j	80002c7a <argraw+0x2c>
  panic("argraw");
    80002ca2:	00004517          	auipc	a0,0x4
    80002ca6:	7c650513          	addi	a0,a0,1990 # 80007468 <etext+0x468>
    80002caa:	aebfd0ef          	jal	80000794 <panic>

0000000080002cae <fetchaddr>:
{
    80002cae:	1101                	addi	sp,sp,-32
    80002cb0:	ec06                	sd	ra,24(sp)
    80002cb2:	e822                	sd	s0,16(sp)
    80002cb4:	e426                	sd	s1,8(sp)
    80002cb6:	e04a                	sd	s2,0(sp)
    80002cb8:	1000                	addi	s0,sp,32
    80002cba:	84aa                	mv	s1,a0
    80002cbc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002cbe:	b6dfe0ef          	jal	8000182a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002cc2:	653c                	ld	a5,72(a0)
    80002cc4:	02f4f663          	bgeu	s1,a5,80002cf0 <fetchaddr+0x42>
    80002cc8:	00848713          	addi	a4,s1,8
    80002ccc:	02e7e463          	bltu	a5,a4,80002cf4 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002cd0:	46a1                	li	a3,8
    80002cd2:	8626                	mv	a2,s1
    80002cd4:	85ca                	mv	a1,s2
    80002cd6:	6928                	ld	a0,80(a0)
    80002cd8:	951fe0ef          	jal	80001628 <copyin>
    80002cdc:	00a03533          	snez	a0,a0
    80002ce0:	40a00533          	neg	a0,a0
}
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6902                	ld	s2,0(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret
    return -1;
    80002cf0:	557d                	li	a0,-1
    80002cf2:	bfcd                	j	80002ce4 <fetchaddr+0x36>
    80002cf4:	557d                	li	a0,-1
    80002cf6:	b7fd                	j	80002ce4 <fetchaddr+0x36>

0000000080002cf8 <fetchstr>:
{
    80002cf8:	7179                	addi	sp,sp,-48
    80002cfa:	f406                	sd	ra,40(sp)
    80002cfc:	f022                	sd	s0,32(sp)
    80002cfe:	ec26                	sd	s1,24(sp)
    80002d00:	e84a                	sd	s2,16(sp)
    80002d02:	e44e                	sd	s3,8(sp)
    80002d04:	1800                	addi	s0,sp,48
    80002d06:	892a                	mv	s2,a0
    80002d08:	84ae                	mv	s1,a1
    80002d0a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002d0c:	b1ffe0ef          	jal	8000182a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002d10:	86ce                	mv	a3,s3
    80002d12:	864a                	mv	a2,s2
    80002d14:	85a6                	mv	a1,s1
    80002d16:	6928                	ld	a0,80(a0)
    80002d18:	997fe0ef          	jal	800016ae <copyinstr>
    80002d1c:	00054c63          	bltz	a0,80002d34 <fetchstr+0x3c>
  return strlen(buf);
    80002d20:	8526                	mv	a0,s1
    80002d22:	916fe0ef          	jal	80000e38 <strlen>
}
    80002d26:	70a2                	ld	ra,40(sp)
    80002d28:	7402                	ld	s0,32(sp)
    80002d2a:	64e2                	ld	s1,24(sp)
    80002d2c:	6942                	ld	s2,16(sp)
    80002d2e:	69a2                	ld	s3,8(sp)
    80002d30:	6145                	addi	sp,sp,48
    80002d32:	8082                	ret
    return -1;
    80002d34:	557d                	li	a0,-1
    80002d36:	bfc5                	j	80002d26 <fetchstr+0x2e>

0000000080002d38 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002d38:	1101                	addi	sp,sp,-32
    80002d3a:	ec06                	sd	ra,24(sp)
    80002d3c:	e822                	sd	s0,16(sp)
    80002d3e:	e426                	sd	s1,8(sp)
    80002d40:	1000                	addi	s0,sp,32
    80002d42:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d44:	f0bff0ef          	jal	80002c4e <argraw>
    80002d48:	c088                	sw	a0,0(s1)
}
    80002d4a:	60e2                	ld	ra,24(sp)
    80002d4c:	6442                	ld	s0,16(sp)
    80002d4e:	64a2                	ld	s1,8(sp)
    80002d50:	6105                	addi	sp,sp,32
    80002d52:	8082                	ret

0000000080002d54 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002d54:	1101                	addi	sp,sp,-32
    80002d56:	ec06                	sd	ra,24(sp)
    80002d58:	e822                	sd	s0,16(sp)
    80002d5a:	e426                	sd	s1,8(sp)
    80002d5c:	1000                	addi	s0,sp,32
    80002d5e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d60:	eefff0ef          	jal	80002c4e <argraw>
    80002d64:	e088                	sd	a0,0(s1)
}
    80002d66:	60e2                	ld	ra,24(sp)
    80002d68:	6442                	ld	s0,16(sp)
    80002d6a:	64a2                	ld	s1,8(sp)
    80002d6c:	6105                	addi	sp,sp,32
    80002d6e:	8082                	ret

0000000080002d70 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002d70:	7179                	addi	sp,sp,-48
    80002d72:	f406                	sd	ra,40(sp)
    80002d74:	f022                	sd	s0,32(sp)
    80002d76:	ec26                	sd	s1,24(sp)
    80002d78:	e84a                	sd	s2,16(sp)
    80002d7a:	1800                	addi	s0,sp,48
    80002d7c:	84ae                	mv	s1,a1
    80002d7e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002d80:	fd840593          	addi	a1,s0,-40
    80002d84:	fd1ff0ef          	jal	80002d54 <argaddr>
  return fetchstr(addr, buf, max);
    80002d88:	864a                	mv	a2,s2
    80002d8a:	85a6                	mv	a1,s1
    80002d8c:	fd843503          	ld	a0,-40(s0)
    80002d90:	f69ff0ef          	jal	80002cf8 <fetchstr>
}
    80002d94:	70a2                	ld	ra,40(sp)
    80002d96:	7402                	ld	s0,32(sp)
    80002d98:	64e2                	ld	s1,24(sp)
    80002d9a:	6942                	ld	s2,16(sp)
    80002d9c:	6145                	addi	sp,sp,48
    80002d9e:	8082                	ret

0000000080002da0 <syscall>:
[SYS_fcfsmode]    sys_fcfsmode,
};

void
syscall(void)
{
    80002da0:	1101                	addi	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	e04a                	sd	s2,0(sp)
    80002daa:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002dac:	a7ffe0ef          	jal	8000182a <myproc>
    80002db0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002db2:	05853903          	ld	s2,88(a0)
    80002db6:	0a893783          	ld	a5,168(s2)
    80002dba:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002dbe:	37fd                	addiw	a5,a5,-1
    80002dc0:	4765                	li	a4,25
    80002dc2:	00f76f63          	bltu	a4,a5,80002de0 <syscall+0x40>
    80002dc6:	00369713          	slli	a4,a3,0x3
    80002dca:	00005797          	auipc	a5,0x5
    80002dce:	a6678793          	addi	a5,a5,-1434 # 80007830 <syscalls>
    80002dd2:	97ba                	add	a5,a5,a4
    80002dd4:	639c                	ld	a5,0(a5)
    80002dd6:	c789                	beqz	a5,80002de0 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002dd8:	9782                	jalr	a5
    80002dda:	06a93823          	sd	a0,112(s2)
    80002dde:	a829                	j	80002df8 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002de0:	15848613          	addi	a2,s1,344
    80002de4:	588c                	lw	a1,48(s1)
    80002de6:	00004517          	auipc	a0,0x4
    80002dea:	68a50513          	addi	a0,a0,1674 # 80007470 <etext+0x470>
    80002dee:	ed4fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002df2:	6cbc                	ld	a5,88(s1)
    80002df4:	577d                	li	a4,-1
    80002df6:	fbb8                	sd	a4,112(a5)
  }
}
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	64a2                	ld	s1,8(sp)
    80002dfe:	6902                	ld	s2,0(sp)
    80002e00:	6105                	addi	sp,sp,32
    80002e02:	8082                	ret

0000000080002e04 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002e04:	1101                	addi	sp,sp,-32
    80002e06:	ec06                	sd	ra,24(sp)
    80002e08:	e822                	sd	s0,16(sp)
    80002e0a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002e0c:	fec40593          	addi	a1,s0,-20
    80002e10:	4501                	li	a0,0
    80002e12:	f27ff0ef          	jal	80002d38 <argint>
  exit(n);
    80002e16:	fec42503          	lw	a0,-20(s0)
    80002e1a:	d62ff0ef          	jal	8000237c <exit>
  return 0;  // not reached
}
    80002e1e:	4501                	li	a0,0
    80002e20:	60e2                	ld	ra,24(sp)
    80002e22:	6442                	ld	s0,16(sp)
    80002e24:	6105                	addi	sp,sp,32
    80002e26:	8082                	ret

0000000080002e28 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002e28:	1141                	addi	sp,sp,-16
    80002e2a:	e406                	sd	ra,8(sp)
    80002e2c:	e022                	sd	s0,0(sp)
    80002e2e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002e30:	9fbfe0ef          	jal	8000182a <myproc>
}
    80002e34:	5908                	lw	a0,48(a0)
    80002e36:	60a2                	ld	ra,8(sp)
    80002e38:	6402                	ld	s0,0(sp)
    80002e3a:	0141                	addi	sp,sp,16
    80002e3c:	8082                	ret

0000000080002e3e <sys_fork>:

uint64
sys_fork(void)
{
    80002e3e:	1141                	addi	sp,sp,-16
    80002e40:	e406                	sd	ra,8(sp)
    80002e42:	e022                	sd	s0,0(sp)
    80002e44:	0800                	addi	s0,sp,16
  return fork();
    80002e46:	b2aff0ef          	jal	80002170 <fork>
}
    80002e4a:	60a2                	ld	ra,8(sp)
    80002e4c:	6402                	ld	s0,0(sp)
    80002e4e:	0141                	addi	sp,sp,16
    80002e50:	8082                	ret

0000000080002e52 <sys_wait>:

uint64
sys_wait(void)
{
    80002e52:	1101                	addi	sp,sp,-32
    80002e54:	ec06                	sd	ra,24(sp)
    80002e56:	e822                	sd	s0,16(sp)
    80002e58:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002e5a:	fe840593          	addi	a1,s0,-24
    80002e5e:	4501                	li	a0,0
    80002e60:	ef5ff0ef          	jal	80002d54 <argaddr>
  return wait(p);
    80002e64:	fe843503          	ld	a0,-24(s0)
    80002e68:	dfbfe0ef          	jal	80001c62 <wait>
}
    80002e6c:	60e2                	ld	ra,24(sp)
    80002e6e:	6442                	ld	s0,16(sp)
    80002e70:	6105                	addi	sp,sp,32
    80002e72:	8082                	ret

0000000080002e74 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002e74:	7179                	addi	sp,sp,-48
    80002e76:	f406                	sd	ra,40(sp)
    80002e78:	f022                	sd	s0,32(sp)
    80002e7a:	ec26                	sd	s1,24(sp)
    80002e7c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002e7e:	fdc40593          	addi	a1,s0,-36
    80002e82:	4501                	li	a0,0
    80002e84:	eb5ff0ef          	jal	80002d38 <argint>
  addr = myproc()->sz;
    80002e88:	9a3fe0ef          	jal	8000182a <myproc>
    80002e8c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002e8e:	fdc42503          	lw	a0,-36(s0)
    80002e92:	c35fe0ef          	jal	80001ac6 <growproc>
    80002e96:	00054863          	bltz	a0,80002ea6 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002e9a:	8526                	mv	a0,s1
    80002e9c:	70a2                	ld	ra,40(sp)
    80002e9e:	7402                	ld	s0,32(sp)
    80002ea0:	64e2                	ld	s1,24(sp)
    80002ea2:	6145                	addi	sp,sp,48
    80002ea4:	8082                	ret
    return -1;
    80002ea6:	54fd                	li	s1,-1
    80002ea8:	bfcd                	j	80002e9a <sys_sbrk+0x26>

0000000080002eaa <sys_sleep>:

uint64
sys_sleep(void)
{
    80002eaa:	7139                	addi	sp,sp,-64
    80002eac:	fc06                	sd	ra,56(sp)
    80002eae:	f822                	sd	s0,48(sp)
    80002eb0:	f04a                	sd	s2,32(sp)
    80002eb2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002eb4:	fcc40593          	addi	a1,s0,-52
    80002eb8:	4501                	li	a0,0
    80002eba:	e7fff0ef          	jal	80002d38 <argint>
  if(n < 0)
    80002ebe:	fcc42783          	lw	a5,-52(s0)
    80002ec2:	0607c763          	bltz	a5,80002f30 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002ec6:	00016517          	auipc	a0,0x16
    80002eca:	ca250513          	addi	a0,a0,-862 # 80018b68 <tickslock>
    80002ece:	d27fd0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002ed2:	00007917          	auipc	s2,0x7
    80002ed6:	63692903          	lw	s2,1590(s2) # 8000a508 <ticks>
  while(ticks - ticks0 < n){
    80002eda:	fcc42783          	lw	a5,-52(s0)
    80002ede:	cf8d                	beqz	a5,80002f18 <sys_sleep+0x6e>
    80002ee0:	f426                	sd	s1,40(sp)
    80002ee2:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002ee4:	00016997          	auipc	s3,0x16
    80002ee8:	c8498993          	addi	s3,s3,-892 # 80018b68 <tickslock>
    80002eec:	00007497          	auipc	s1,0x7
    80002ef0:	61c48493          	addi	s1,s1,1564 # 8000a508 <ticks>
    if(killed(myproc())){
    80002ef4:	937fe0ef          	jal	8000182a <myproc>
    80002ef8:	d41fe0ef          	jal	80001c38 <killed>
    80002efc:	ed0d                	bnez	a0,80002f36 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002efe:	85ce                	mv	a1,s3
    80002f00:	8526                	mv	a0,s1
    80002f02:	cc7fe0ef          	jal	80001bc8 <sleep>
  while(ticks - ticks0 < n){
    80002f06:	409c                	lw	a5,0(s1)
    80002f08:	412787bb          	subw	a5,a5,s2
    80002f0c:	fcc42703          	lw	a4,-52(s0)
    80002f10:	fee7e2e3          	bltu	a5,a4,80002ef4 <sys_sleep+0x4a>
    80002f14:	74a2                	ld	s1,40(sp)
    80002f16:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002f18:	00016517          	auipc	a0,0x16
    80002f1c:	c5050513          	addi	a0,a0,-944 # 80018b68 <tickslock>
    80002f20:	d6dfd0ef          	jal	80000c8c <release>
  return 0;
    80002f24:	4501                	li	a0,0
}
    80002f26:	70e2                	ld	ra,56(sp)
    80002f28:	7442                	ld	s0,48(sp)
    80002f2a:	7902                	ld	s2,32(sp)
    80002f2c:	6121                	addi	sp,sp,64
    80002f2e:	8082                	ret
    n = 0;
    80002f30:	fc042623          	sw	zero,-52(s0)
    80002f34:	bf49                	j	80002ec6 <sys_sleep+0x1c>
      release(&tickslock);
    80002f36:	00016517          	auipc	a0,0x16
    80002f3a:	c3250513          	addi	a0,a0,-974 # 80018b68 <tickslock>
    80002f3e:	d4ffd0ef          	jal	80000c8c <release>
      return -1;
    80002f42:	557d                	li	a0,-1
    80002f44:	74a2                	ld	s1,40(sp)
    80002f46:	69e2                	ld	s3,24(sp)
    80002f48:	bff9                	j	80002f26 <sys_sleep+0x7c>

0000000080002f4a <sys_kill>:

uint64
sys_kill(void)
{
    80002f4a:	1101                	addi	sp,sp,-32
    80002f4c:	ec06                	sd	ra,24(sp)
    80002f4e:	e822                	sd	s0,16(sp)
    80002f50:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002f52:	fec40593          	addi	a1,s0,-20
    80002f56:	4501                	li	a0,0
    80002f58:	de1ff0ef          	jal	80002d38 <argint>
  return kill(pid);
    80002f5c:	fec42503          	lw	a0,-20(s0)
    80002f60:	cbeff0ef          	jal	8000241e <kill>
}
    80002f64:	60e2                	ld	ra,24(sp)
    80002f66:	6442                	ld	s0,16(sp)
    80002f68:	6105                	addi	sp,sp,32
    80002f6a:	8082                	ret

0000000080002f6c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002f6c:	1101                	addi	sp,sp,-32
    80002f6e:	ec06                	sd	ra,24(sp)
    80002f70:	e822                	sd	s0,16(sp)
    80002f72:	e426                	sd	s1,8(sp)
    80002f74:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002f76:	00016517          	auipc	a0,0x16
    80002f7a:	bf250513          	addi	a0,a0,-1038 # 80018b68 <tickslock>
    80002f7e:	c77fd0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002f82:	00007497          	auipc	s1,0x7
    80002f86:	5864a483          	lw	s1,1414(s1) # 8000a508 <ticks>
  release(&tickslock);
    80002f8a:	00016517          	auipc	a0,0x16
    80002f8e:	bde50513          	addi	a0,a0,-1058 # 80018b68 <tickslock>
    80002f92:	cfbfd0ef          	jal	80000c8c <release>
  return xticks;
}
    80002f96:	02049513          	slli	a0,s1,0x20
    80002f9a:	9101                	srli	a0,a0,0x20
    80002f9c:	60e2                	ld	ra,24(sp)
    80002f9e:	6442                	ld	s0,16(sp)
    80002fa0:	64a2                	ld	s1,8(sp)
    80002fa2:	6105                	addi	sp,sp,32
    80002fa4:	8082                	ret

0000000080002fa6 <sys_yield>:

uint64
sys_yield(void)
{
    80002fa6:	1141                	addi	sp,sp,-16
    80002fa8:	e406                	sd	ra,8(sp)
    80002faa:	e022                	sd	s0,0(sp)
    80002fac:	0800                	addi	s0,sp,16
  yield();
    80002fae:	ad6ff0ef          	jal	80002284 <yield>
  return 0;
}
    80002fb2:	4501                	li	a0,0
    80002fb4:	60a2                	ld	ra,8(sp)
    80002fb6:	6402                	ld	s0,0(sp)
    80002fb8:	0141                	addi	sp,sp,16
    80002fba:	8082                	ret

0000000080002fbc <sys_getlev>:

uint64
sys_getlev(void)
{
  if (sched_mode == FCFS)
    80002fbc:	00007797          	auipc	a5,0x7
    80002fc0:	53c7a783          	lw	a5,1340(a5) # 8000a4f8 <sched_mode>
    return 99;
    80002fc4:	06300513          	li	a0,99
  if (sched_mode == FCFS)
    80002fc8:	e391                	bnez	a5,80002fcc <sys_getlev+0x10>
  else
    return myproc()->level;
}
    80002fca:	8082                	ret
{
    80002fcc:	1141                	addi	sp,sp,-16
    80002fce:	e406                	sd	ra,8(sp)
    80002fd0:	e022                	sd	s0,0(sp)
    80002fd2:	0800                	addi	s0,sp,16
    return myproc()->level;
    80002fd4:	857fe0ef          	jal	8000182a <myproc>
    80002fd8:	17452503          	lw	a0,372(a0)
}
    80002fdc:	60a2                	ld	ra,8(sp)
    80002fde:	6402                	ld	s0,0(sp)
    80002fe0:	0141                	addi	sp,sp,16
    80002fe2:	8082                	ret

0000000080002fe4 <sys_setpriority>:

uint64
sys_setpriority(void)
{
    80002fe4:	1101                	addi	sp,sp,-32
    80002fe6:	ec06                	sd	ra,24(sp)
    80002fe8:	e822                	sd	s0,16(sp)
    80002fea:	1000                	addi	s0,sp,32
  int pid;
  int priority;

  argint(0, &pid);
    80002fec:	fec40593          	addi	a1,s0,-20
    80002ff0:	4501                	li	a0,0
    80002ff2:	d47ff0ef          	jal	80002d38 <argint>
  argint(1, &priority);
    80002ff6:	fe840593          	addi	a1,s0,-24
    80002ffa:	4505                	li	a0,1
    80002ffc:	d3dff0ef          	jal	80002d38 <argint>

  return setpriority(pid, priority);
    80003000:	fe842583          	lw	a1,-24(s0)
    80003004:	fec42503          	lw	a0,-20(s0)
    80003008:	e8eff0ef          	jal	80002696 <setpriority>
}
    8000300c:	60e2                	ld	ra,24(sp)
    8000300e:	6442                	ld	s0,16(sp)
    80003010:	6105                	addi	sp,sp,32
    80003012:	8082                	ret

0000000080003014 <sys_mlfqmode>:

uint64
sys_mlfqmode(void)
{
    80003014:	1141                	addi	sp,sp,-16
    80003016:	e406                	sd	ra,8(sp)
    80003018:	e022                	sd	s0,0(sp)
    8000301a:	0800                	addi	s0,sp,16
  return mlfqmode();
    8000301c:	ed2ff0ef          	jal	800026ee <mlfqmode>
}
    80003020:	60a2                	ld	ra,8(sp)
    80003022:	6402                	ld	s0,0(sp)
    80003024:	0141                	addi	sp,sp,16
    80003026:	8082                	ret

0000000080003028 <sys_fcfsmode>:

uint64
sys_fcfsmode(void)
{
    80003028:	1141                	addi	sp,sp,-16
    8000302a:	e406                	sd	ra,8(sp)
    8000302c:	e022                	sd	s0,0(sp)
    8000302e:	0800                	addi	s0,sp,16
  return fcfsmode();
    80003030:	f40ff0ef          	jal	80002770 <fcfsmode>
    80003034:	60a2                	ld	ra,8(sp)
    80003036:	6402                	ld	s0,0(sp)
    80003038:	0141                	addi	sp,sp,16
    8000303a:	8082                	ret

000000008000303c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000303c:	7179                	addi	sp,sp,-48
    8000303e:	f406                	sd	ra,40(sp)
    80003040:	f022                	sd	s0,32(sp)
    80003042:	ec26                	sd	s1,24(sp)
    80003044:	e84a                	sd	s2,16(sp)
    80003046:	e44e                	sd	s3,8(sp)
    80003048:	e052                	sd	s4,0(sp)
    8000304a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000304c:	00004597          	auipc	a1,0x4
    80003050:	44458593          	addi	a1,a1,1092 # 80007490 <etext+0x490>
    80003054:	00016517          	auipc	a0,0x16
    80003058:	b2c50513          	addi	a0,a0,-1236 # 80018b80 <bcache>
    8000305c:	b19fd0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003060:	0001e797          	auipc	a5,0x1e
    80003064:	b2078793          	addi	a5,a5,-1248 # 80020b80 <bcache+0x8000>
    80003068:	0001e717          	auipc	a4,0x1e
    8000306c:	d8070713          	addi	a4,a4,-640 # 80020de8 <bcache+0x8268>
    80003070:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003074:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003078:	00016497          	auipc	s1,0x16
    8000307c:	b2048493          	addi	s1,s1,-1248 # 80018b98 <bcache+0x18>
    b->next = bcache.head.next;
    80003080:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003082:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003084:	00004a17          	auipc	s4,0x4
    80003088:	414a0a13          	addi	s4,s4,1044 # 80007498 <etext+0x498>
    b->next = bcache.head.next;
    8000308c:	2b893783          	ld	a5,696(s2)
    80003090:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003092:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003096:	85d2                	mv	a1,s4
    80003098:	01048513          	addi	a0,s1,16
    8000309c:	248010ef          	jal	800042e4 <initsleeplock>
    bcache.head.next->prev = b;
    800030a0:	2b893783          	ld	a5,696(s2)
    800030a4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800030a6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800030aa:	45848493          	addi	s1,s1,1112
    800030ae:	fd349fe3          	bne	s1,s3,8000308c <binit+0x50>
  }
}
    800030b2:	70a2                	ld	ra,40(sp)
    800030b4:	7402                	ld	s0,32(sp)
    800030b6:	64e2                	ld	s1,24(sp)
    800030b8:	6942                	ld	s2,16(sp)
    800030ba:	69a2                	ld	s3,8(sp)
    800030bc:	6a02                	ld	s4,0(sp)
    800030be:	6145                	addi	sp,sp,48
    800030c0:	8082                	ret

00000000800030c2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800030c2:	7179                	addi	sp,sp,-48
    800030c4:	f406                	sd	ra,40(sp)
    800030c6:	f022                	sd	s0,32(sp)
    800030c8:	ec26                	sd	s1,24(sp)
    800030ca:	e84a                	sd	s2,16(sp)
    800030cc:	e44e                	sd	s3,8(sp)
    800030ce:	1800                	addi	s0,sp,48
    800030d0:	892a                	mv	s2,a0
    800030d2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800030d4:	00016517          	auipc	a0,0x16
    800030d8:	aac50513          	addi	a0,a0,-1364 # 80018b80 <bcache>
    800030dc:	b19fd0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030e0:	0001e497          	auipc	s1,0x1e
    800030e4:	d584b483          	ld	s1,-680(s1) # 80020e38 <bcache+0x82b8>
    800030e8:	0001e797          	auipc	a5,0x1e
    800030ec:	d0078793          	addi	a5,a5,-768 # 80020de8 <bcache+0x8268>
    800030f0:	02f48b63          	beq	s1,a5,80003126 <bread+0x64>
    800030f4:	873e                	mv	a4,a5
    800030f6:	a021                	j	800030fe <bread+0x3c>
    800030f8:	68a4                	ld	s1,80(s1)
    800030fa:	02e48663          	beq	s1,a4,80003126 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800030fe:	449c                	lw	a5,8(s1)
    80003100:	ff279ce3          	bne	a5,s2,800030f8 <bread+0x36>
    80003104:	44dc                	lw	a5,12(s1)
    80003106:	ff3799e3          	bne	a5,s3,800030f8 <bread+0x36>
      b->refcnt++;
    8000310a:	40bc                	lw	a5,64(s1)
    8000310c:	2785                	addiw	a5,a5,1
    8000310e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003110:	00016517          	auipc	a0,0x16
    80003114:	a7050513          	addi	a0,a0,-1424 # 80018b80 <bcache>
    80003118:	b75fd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    8000311c:	01048513          	addi	a0,s1,16
    80003120:	1fa010ef          	jal	8000431a <acquiresleep>
      return b;
    80003124:	a889                	j	80003176 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003126:	0001e497          	auipc	s1,0x1e
    8000312a:	d0a4b483          	ld	s1,-758(s1) # 80020e30 <bcache+0x82b0>
    8000312e:	0001e797          	auipc	a5,0x1e
    80003132:	cba78793          	addi	a5,a5,-838 # 80020de8 <bcache+0x8268>
    80003136:	00f48863          	beq	s1,a5,80003146 <bread+0x84>
    8000313a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000313c:	40bc                	lw	a5,64(s1)
    8000313e:	cb91                	beqz	a5,80003152 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003140:	64a4                	ld	s1,72(s1)
    80003142:	fee49de3          	bne	s1,a4,8000313c <bread+0x7a>
  panic("bget: no buffers");
    80003146:	00004517          	auipc	a0,0x4
    8000314a:	35a50513          	addi	a0,a0,858 # 800074a0 <etext+0x4a0>
    8000314e:	e46fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80003152:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003156:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000315a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000315e:	4785                	li	a5,1
    80003160:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003162:	00016517          	auipc	a0,0x16
    80003166:	a1e50513          	addi	a0,a0,-1506 # 80018b80 <bcache>
    8000316a:	b23fd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    8000316e:	01048513          	addi	a0,s1,16
    80003172:	1a8010ef          	jal	8000431a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003176:	409c                	lw	a5,0(s1)
    80003178:	cb89                	beqz	a5,8000318a <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000317a:	8526                	mv	a0,s1
    8000317c:	70a2                	ld	ra,40(sp)
    8000317e:	7402                	ld	s0,32(sp)
    80003180:	64e2                	ld	s1,24(sp)
    80003182:	6942                	ld	s2,16(sp)
    80003184:	69a2                	ld	s3,8(sp)
    80003186:	6145                	addi	sp,sp,48
    80003188:	8082                	ret
    virtio_disk_rw(b, 0);
    8000318a:	4581                	li	a1,0
    8000318c:	8526                	mv	a0,s1
    8000318e:	1f3020ef          	jal	80005b80 <virtio_disk_rw>
    b->valid = 1;
    80003192:	4785                	li	a5,1
    80003194:	c09c                	sw	a5,0(s1)
  return b;
    80003196:	b7d5                	j	8000317a <bread+0xb8>

0000000080003198 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003198:	1101                	addi	sp,sp,-32
    8000319a:	ec06                	sd	ra,24(sp)
    8000319c:	e822                	sd	s0,16(sp)
    8000319e:	e426                	sd	s1,8(sp)
    800031a0:	1000                	addi	s0,sp,32
    800031a2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031a4:	0541                	addi	a0,a0,16
    800031a6:	1f2010ef          	jal	80004398 <holdingsleep>
    800031aa:	c911                	beqz	a0,800031be <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800031ac:	4585                	li	a1,1
    800031ae:	8526                	mv	a0,s1
    800031b0:	1d1020ef          	jal	80005b80 <virtio_disk_rw>
}
    800031b4:	60e2                	ld	ra,24(sp)
    800031b6:	6442                	ld	s0,16(sp)
    800031b8:	64a2                	ld	s1,8(sp)
    800031ba:	6105                	addi	sp,sp,32
    800031bc:	8082                	ret
    panic("bwrite");
    800031be:	00004517          	auipc	a0,0x4
    800031c2:	2fa50513          	addi	a0,a0,762 # 800074b8 <etext+0x4b8>
    800031c6:	dcefd0ef          	jal	80000794 <panic>

00000000800031ca <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800031ca:	1101                	addi	sp,sp,-32
    800031cc:	ec06                	sd	ra,24(sp)
    800031ce:	e822                	sd	s0,16(sp)
    800031d0:	e426                	sd	s1,8(sp)
    800031d2:	e04a                	sd	s2,0(sp)
    800031d4:	1000                	addi	s0,sp,32
    800031d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031d8:	01050913          	addi	s2,a0,16
    800031dc:	854a                	mv	a0,s2
    800031de:	1ba010ef          	jal	80004398 <holdingsleep>
    800031e2:	c135                	beqz	a0,80003246 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800031e4:	854a                	mv	a0,s2
    800031e6:	17a010ef          	jal	80004360 <releasesleep>

  acquire(&bcache.lock);
    800031ea:	00016517          	auipc	a0,0x16
    800031ee:	99650513          	addi	a0,a0,-1642 # 80018b80 <bcache>
    800031f2:	a03fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    800031f6:	40bc                	lw	a5,64(s1)
    800031f8:	37fd                	addiw	a5,a5,-1
    800031fa:	0007871b          	sext.w	a4,a5
    800031fe:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003200:	e71d                	bnez	a4,8000322e <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003202:	68b8                	ld	a4,80(s1)
    80003204:	64bc                	ld	a5,72(s1)
    80003206:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003208:	68b8                	ld	a4,80(s1)
    8000320a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000320c:	0001e797          	auipc	a5,0x1e
    80003210:	97478793          	addi	a5,a5,-1676 # 80020b80 <bcache+0x8000>
    80003214:	2b87b703          	ld	a4,696(a5)
    80003218:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000321a:	0001e717          	auipc	a4,0x1e
    8000321e:	bce70713          	addi	a4,a4,-1074 # 80020de8 <bcache+0x8268>
    80003222:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003224:	2b87b703          	ld	a4,696(a5)
    80003228:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000322a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000322e:	00016517          	auipc	a0,0x16
    80003232:	95250513          	addi	a0,a0,-1710 # 80018b80 <bcache>
    80003236:	a57fd0ef          	jal	80000c8c <release>
}
    8000323a:	60e2                	ld	ra,24(sp)
    8000323c:	6442                	ld	s0,16(sp)
    8000323e:	64a2                	ld	s1,8(sp)
    80003240:	6902                	ld	s2,0(sp)
    80003242:	6105                	addi	sp,sp,32
    80003244:	8082                	ret
    panic("brelse");
    80003246:	00004517          	auipc	a0,0x4
    8000324a:	27a50513          	addi	a0,a0,634 # 800074c0 <etext+0x4c0>
    8000324e:	d46fd0ef          	jal	80000794 <panic>

0000000080003252 <bpin>:

void
bpin(struct buf *b) {
    80003252:	1101                	addi	sp,sp,-32
    80003254:	ec06                	sd	ra,24(sp)
    80003256:	e822                	sd	s0,16(sp)
    80003258:	e426                	sd	s1,8(sp)
    8000325a:	1000                	addi	s0,sp,32
    8000325c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000325e:	00016517          	auipc	a0,0x16
    80003262:	92250513          	addi	a0,a0,-1758 # 80018b80 <bcache>
    80003266:	98ffd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    8000326a:	40bc                	lw	a5,64(s1)
    8000326c:	2785                	addiw	a5,a5,1
    8000326e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003270:	00016517          	auipc	a0,0x16
    80003274:	91050513          	addi	a0,a0,-1776 # 80018b80 <bcache>
    80003278:	a15fd0ef          	jal	80000c8c <release>
}
    8000327c:	60e2                	ld	ra,24(sp)
    8000327e:	6442                	ld	s0,16(sp)
    80003280:	64a2                	ld	s1,8(sp)
    80003282:	6105                	addi	sp,sp,32
    80003284:	8082                	ret

0000000080003286 <bunpin>:

void
bunpin(struct buf *b) {
    80003286:	1101                	addi	sp,sp,-32
    80003288:	ec06                	sd	ra,24(sp)
    8000328a:	e822                	sd	s0,16(sp)
    8000328c:	e426                	sd	s1,8(sp)
    8000328e:	1000                	addi	s0,sp,32
    80003290:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003292:	00016517          	auipc	a0,0x16
    80003296:	8ee50513          	addi	a0,a0,-1810 # 80018b80 <bcache>
    8000329a:	95bfd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    8000329e:	40bc                	lw	a5,64(s1)
    800032a0:	37fd                	addiw	a5,a5,-1
    800032a2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032a4:	00016517          	auipc	a0,0x16
    800032a8:	8dc50513          	addi	a0,a0,-1828 # 80018b80 <bcache>
    800032ac:	9e1fd0ef          	jal	80000c8c <release>
}
    800032b0:	60e2                	ld	ra,24(sp)
    800032b2:	6442                	ld	s0,16(sp)
    800032b4:	64a2                	ld	s1,8(sp)
    800032b6:	6105                	addi	sp,sp,32
    800032b8:	8082                	ret

00000000800032ba <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032ba:	1101                	addi	sp,sp,-32
    800032bc:	ec06                	sd	ra,24(sp)
    800032be:	e822                	sd	s0,16(sp)
    800032c0:	e426                	sd	s1,8(sp)
    800032c2:	e04a                	sd	s2,0(sp)
    800032c4:	1000                	addi	s0,sp,32
    800032c6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800032c8:	00d5d59b          	srliw	a1,a1,0xd
    800032cc:	0001e797          	auipc	a5,0x1e
    800032d0:	f907a783          	lw	a5,-112(a5) # 8002125c <sb+0x1c>
    800032d4:	9dbd                	addw	a1,a1,a5
    800032d6:	dedff0ef          	jal	800030c2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800032da:	0074f713          	andi	a4,s1,7
    800032de:	4785                	li	a5,1
    800032e0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800032e4:	14ce                	slli	s1,s1,0x33
    800032e6:	90d9                	srli	s1,s1,0x36
    800032e8:	00950733          	add	a4,a0,s1
    800032ec:	05874703          	lbu	a4,88(a4)
    800032f0:	00e7f6b3          	and	a3,a5,a4
    800032f4:	c29d                	beqz	a3,8000331a <bfree+0x60>
    800032f6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800032f8:	94aa                	add	s1,s1,a0
    800032fa:	fff7c793          	not	a5,a5
    800032fe:	8f7d                	and	a4,a4,a5
    80003300:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003304:	711000ef          	jal	80004214 <log_write>
  brelse(bp);
    80003308:	854a                	mv	a0,s2
    8000330a:	ec1ff0ef          	jal	800031ca <brelse>
}
    8000330e:	60e2                	ld	ra,24(sp)
    80003310:	6442                	ld	s0,16(sp)
    80003312:	64a2                	ld	s1,8(sp)
    80003314:	6902                	ld	s2,0(sp)
    80003316:	6105                	addi	sp,sp,32
    80003318:	8082                	ret
    panic("freeing free block");
    8000331a:	00004517          	auipc	a0,0x4
    8000331e:	1ae50513          	addi	a0,a0,430 # 800074c8 <etext+0x4c8>
    80003322:	c72fd0ef          	jal	80000794 <panic>

0000000080003326 <balloc>:
{
    80003326:	711d                	addi	sp,sp,-96
    80003328:	ec86                	sd	ra,88(sp)
    8000332a:	e8a2                	sd	s0,80(sp)
    8000332c:	e4a6                	sd	s1,72(sp)
    8000332e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003330:	0001e797          	auipc	a5,0x1e
    80003334:	f147a783          	lw	a5,-236(a5) # 80021244 <sb+0x4>
    80003338:	0e078f63          	beqz	a5,80003436 <balloc+0x110>
    8000333c:	e0ca                	sd	s2,64(sp)
    8000333e:	fc4e                	sd	s3,56(sp)
    80003340:	f852                	sd	s4,48(sp)
    80003342:	f456                	sd	s5,40(sp)
    80003344:	f05a                	sd	s6,32(sp)
    80003346:	ec5e                	sd	s7,24(sp)
    80003348:	e862                	sd	s8,16(sp)
    8000334a:	e466                	sd	s9,8(sp)
    8000334c:	8baa                	mv	s7,a0
    8000334e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003350:	0001eb17          	auipc	s6,0x1e
    80003354:	ef0b0b13          	addi	s6,s6,-272 # 80021240 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003358:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000335a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000335c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000335e:	6c89                	lui	s9,0x2
    80003360:	a0b5                	j	800033cc <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003362:	97ca                	add	a5,a5,s2
    80003364:	8e55                	or	a2,a2,a3
    80003366:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000336a:	854a                	mv	a0,s2
    8000336c:	6a9000ef          	jal	80004214 <log_write>
        brelse(bp);
    80003370:	854a                	mv	a0,s2
    80003372:	e59ff0ef          	jal	800031ca <brelse>
  bp = bread(dev, bno);
    80003376:	85a6                	mv	a1,s1
    80003378:	855e                	mv	a0,s7
    8000337a:	d49ff0ef          	jal	800030c2 <bread>
    8000337e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003380:	40000613          	li	a2,1024
    80003384:	4581                	li	a1,0
    80003386:	05850513          	addi	a0,a0,88
    8000338a:	93ffd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    8000338e:	854a                	mv	a0,s2
    80003390:	685000ef          	jal	80004214 <log_write>
  brelse(bp);
    80003394:	854a                	mv	a0,s2
    80003396:	e35ff0ef          	jal	800031ca <brelse>
}
    8000339a:	6906                	ld	s2,64(sp)
    8000339c:	79e2                	ld	s3,56(sp)
    8000339e:	7a42                	ld	s4,48(sp)
    800033a0:	7aa2                	ld	s5,40(sp)
    800033a2:	7b02                	ld	s6,32(sp)
    800033a4:	6be2                	ld	s7,24(sp)
    800033a6:	6c42                	ld	s8,16(sp)
    800033a8:	6ca2                	ld	s9,8(sp)
}
    800033aa:	8526                	mv	a0,s1
    800033ac:	60e6                	ld	ra,88(sp)
    800033ae:	6446                	ld	s0,80(sp)
    800033b0:	64a6                	ld	s1,72(sp)
    800033b2:	6125                	addi	sp,sp,96
    800033b4:	8082                	ret
    brelse(bp);
    800033b6:	854a                	mv	a0,s2
    800033b8:	e13ff0ef          	jal	800031ca <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800033bc:	015c87bb          	addw	a5,s9,s5
    800033c0:	00078a9b          	sext.w	s5,a5
    800033c4:	004b2703          	lw	a4,4(s6)
    800033c8:	04eaff63          	bgeu	s5,a4,80003426 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800033cc:	41fad79b          	sraiw	a5,s5,0x1f
    800033d0:	0137d79b          	srliw	a5,a5,0x13
    800033d4:	015787bb          	addw	a5,a5,s5
    800033d8:	40d7d79b          	sraiw	a5,a5,0xd
    800033dc:	01cb2583          	lw	a1,28(s6)
    800033e0:	9dbd                	addw	a1,a1,a5
    800033e2:	855e                	mv	a0,s7
    800033e4:	cdfff0ef          	jal	800030c2 <bread>
    800033e8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033ea:	004b2503          	lw	a0,4(s6)
    800033ee:	000a849b          	sext.w	s1,s5
    800033f2:	8762                	mv	a4,s8
    800033f4:	fca4f1e3          	bgeu	s1,a0,800033b6 <balloc+0x90>
      m = 1 << (bi % 8);
    800033f8:	00777693          	andi	a3,a4,7
    800033fc:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003400:	41f7579b          	sraiw	a5,a4,0x1f
    80003404:	01d7d79b          	srliw	a5,a5,0x1d
    80003408:	9fb9                	addw	a5,a5,a4
    8000340a:	4037d79b          	sraiw	a5,a5,0x3
    8000340e:	00f90633          	add	a2,s2,a5
    80003412:	05864603          	lbu	a2,88(a2)
    80003416:	00c6f5b3          	and	a1,a3,a2
    8000341a:	d5a1                	beqz	a1,80003362 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000341c:	2705                	addiw	a4,a4,1
    8000341e:	2485                	addiw	s1,s1,1
    80003420:	fd471ae3          	bne	a4,s4,800033f4 <balloc+0xce>
    80003424:	bf49                	j	800033b6 <balloc+0x90>
    80003426:	6906                	ld	s2,64(sp)
    80003428:	79e2                	ld	s3,56(sp)
    8000342a:	7a42                	ld	s4,48(sp)
    8000342c:	7aa2                	ld	s5,40(sp)
    8000342e:	7b02                	ld	s6,32(sp)
    80003430:	6be2                	ld	s7,24(sp)
    80003432:	6c42                	ld	s8,16(sp)
    80003434:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003436:	00004517          	auipc	a0,0x4
    8000343a:	0aa50513          	addi	a0,a0,170 # 800074e0 <etext+0x4e0>
    8000343e:	884fd0ef          	jal	800004c2 <printf>
  return 0;
    80003442:	4481                	li	s1,0
    80003444:	b79d                	j	800033aa <balloc+0x84>

0000000080003446 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003446:	7179                	addi	sp,sp,-48
    80003448:	f406                	sd	ra,40(sp)
    8000344a:	f022                	sd	s0,32(sp)
    8000344c:	ec26                	sd	s1,24(sp)
    8000344e:	e84a                	sd	s2,16(sp)
    80003450:	e44e                	sd	s3,8(sp)
    80003452:	1800                	addi	s0,sp,48
    80003454:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003456:	47ad                	li	a5,11
    80003458:	02b7e663          	bltu	a5,a1,80003484 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000345c:	02059793          	slli	a5,a1,0x20
    80003460:	01e7d593          	srli	a1,a5,0x1e
    80003464:	00b504b3          	add	s1,a0,a1
    80003468:	0504a903          	lw	s2,80(s1)
    8000346c:	06091a63          	bnez	s2,800034e0 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003470:	4108                	lw	a0,0(a0)
    80003472:	eb5ff0ef          	jal	80003326 <balloc>
    80003476:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000347a:	06090363          	beqz	s2,800034e0 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000347e:	0524a823          	sw	s2,80(s1)
    80003482:	a8b9                	j	800034e0 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003484:	ff45849b          	addiw	s1,a1,-12
    80003488:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000348c:	0ff00793          	li	a5,255
    80003490:	06e7ee63          	bltu	a5,a4,8000350c <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003494:	08052903          	lw	s2,128(a0)
    80003498:	00091d63          	bnez	s2,800034b2 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000349c:	4108                	lw	a0,0(a0)
    8000349e:	e89ff0ef          	jal	80003326 <balloc>
    800034a2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800034a6:	02090d63          	beqz	s2,800034e0 <bmap+0x9a>
    800034aa:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800034ac:	0929a023          	sw	s2,128(s3)
    800034b0:	a011                	j	800034b4 <bmap+0x6e>
    800034b2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800034b4:	85ca                	mv	a1,s2
    800034b6:	0009a503          	lw	a0,0(s3)
    800034ba:	c09ff0ef          	jal	800030c2 <bread>
    800034be:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800034c0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800034c4:	02049713          	slli	a4,s1,0x20
    800034c8:	01e75593          	srli	a1,a4,0x1e
    800034cc:	00b784b3          	add	s1,a5,a1
    800034d0:	0004a903          	lw	s2,0(s1)
    800034d4:	00090e63          	beqz	s2,800034f0 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800034d8:	8552                	mv	a0,s4
    800034da:	cf1ff0ef          	jal	800031ca <brelse>
    return addr;
    800034de:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800034e0:	854a                	mv	a0,s2
    800034e2:	70a2                	ld	ra,40(sp)
    800034e4:	7402                	ld	s0,32(sp)
    800034e6:	64e2                	ld	s1,24(sp)
    800034e8:	6942                	ld	s2,16(sp)
    800034ea:	69a2                	ld	s3,8(sp)
    800034ec:	6145                	addi	sp,sp,48
    800034ee:	8082                	ret
      addr = balloc(ip->dev);
    800034f0:	0009a503          	lw	a0,0(s3)
    800034f4:	e33ff0ef          	jal	80003326 <balloc>
    800034f8:	0005091b          	sext.w	s2,a0
      if(addr){
    800034fc:	fc090ee3          	beqz	s2,800034d8 <bmap+0x92>
        a[bn] = addr;
    80003500:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003504:	8552                	mv	a0,s4
    80003506:	50f000ef          	jal	80004214 <log_write>
    8000350a:	b7f9                	j	800034d8 <bmap+0x92>
    8000350c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000350e:	00004517          	auipc	a0,0x4
    80003512:	fea50513          	addi	a0,a0,-22 # 800074f8 <etext+0x4f8>
    80003516:	a7efd0ef          	jal	80000794 <panic>

000000008000351a <iget>:
{
    8000351a:	7179                	addi	sp,sp,-48
    8000351c:	f406                	sd	ra,40(sp)
    8000351e:	f022                	sd	s0,32(sp)
    80003520:	ec26                	sd	s1,24(sp)
    80003522:	e84a                	sd	s2,16(sp)
    80003524:	e44e                	sd	s3,8(sp)
    80003526:	e052                	sd	s4,0(sp)
    80003528:	1800                	addi	s0,sp,48
    8000352a:	89aa                	mv	s3,a0
    8000352c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000352e:	0001e517          	auipc	a0,0x1e
    80003532:	d3250513          	addi	a0,a0,-718 # 80021260 <itable>
    80003536:	ebefd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    8000353a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000353c:	0001e497          	auipc	s1,0x1e
    80003540:	d3c48493          	addi	s1,s1,-708 # 80021278 <itable+0x18>
    80003544:	0001f697          	auipc	a3,0x1f
    80003548:	7c468693          	addi	a3,a3,1988 # 80022d08 <log>
    8000354c:	a039                	j	8000355a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000354e:	02090963          	beqz	s2,80003580 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003552:	08848493          	addi	s1,s1,136
    80003556:	02d48863          	beq	s1,a3,80003586 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000355a:	449c                	lw	a5,8(s1)
    8000355c:	fef059e3          	blez	a5,8000354e <iget+0x34>
    80003560:	4098                	lw	a4,0(s1)
    80003562:	ff3716e3          	bne	a4,s3,8000354e <iget+0x34>
    80003566:	40d8                	lw	a4,4(s1)
    80003568:	ff4713e3          	bne	a4,s4,8000354e <iget+0x34>
      ip->ref++;
    8000356c:	2785                	addiw	a5,a5,1
    8000356e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003570:	0001e517          	auipc	a0,0x1e
    80003574:	cf050513          	addi	a0,a0,-784 # 80021260 <itable>
    80003578:	f14fd0ef          	jal	80000c8c <release>
      return ip;
    8000357c:	8926                	mv	s2,s1
    8000357e:	a02d                	j	800035a8 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003580:	fbe9                	bnez	a5,80003552 <iget+0x38>
      empty = ip;
    80003582:	8926                	mv	s2,s1
    80003584:	b7f9                	j	80003552 <iget+0x38>
  if(empty == 0)
    80003586:	02090a63          	beqz	s2,800035ba <iget+0xa0>
  ip->dev = dev;
    8000358a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000358e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003592:	4785                	li	a5,1
    80003594:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003598:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000359c:	0001e517          	auipc	a0,0x1e
    800035a0:	cc450513          	addi	a0,a0,-828 # 80021260 <itable>
    800035a4:	ee8fd0ef          	jal	80000c8c <release>
}
    800035a8:	854a                	mv	a0,s2
    800035aa:	70a2                	ld	ra,40(sp)
    800035ac:	7402                	ld	s0,32(sp)
    800035ae:	64e2                	ld	s1,24(sp)
    800035b0:	6942                	ld	s2,16(sp)
    800035b2:	69a2                	ld	s3,8(sp)
    800035b4:	6a02                	ld	s4,0(sp)
    800035b6:	6145                	addi	sp,sp,48
    800035b8:	8082                	ret
    panic("iget: no inodes");
    800035ba:	00004517          	auipc	a0,0x4
    800035be:	f5650513          	addi	a0,a0,-170 # 80007510 <etext+0x510>
    800035c2:	9d2fd0ef          	jal	80000794 <panic>

00000000800035c6 <fsinit>:
fsinit(int dev) {
    800035c6:	7179                	addi	sp,sp,-48
    800035c8:	f406                	sd	ra,40(sp)
    800035ca:	f022                	sd	s0,32(sp)
    800035cc:	ec26                	sd	s1,24(sp)
    800035ce:	e84a                	sd	s2,16(sp)
    800035d0:	e44e                	sd	s3,8(sp)
    800035d2:	1800                	addi	s0,sp,48
    800035d4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800035d6:	4585                	li	a1,1
    800035d8:	aebff0ef          	jal	800030c2 <bread>
    800035dc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800035de:	0001e997          	auipc	s3,0x1e
    800035e2:	c6298993          	addi	s3,s3,-926 # 80021240 <sb>
    800035e6:	02000613          	li	a2,32
    800035ea:	05850593          	addi	a1,a0,88
    800035ee:	854e                	mv	a0,s3
    800035f0:	f34fd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    800035f4:	8526                	mv	a0,s1
    800035f6:	bd5ff0ef          	jal	800031ca <brelse>
  if(sb.magic != FSMAGIC)
    800035fa:	0009a703          	lw	a4,0(s3)
    800035fe:	102037b7          	lui	a5,0x10203
    80003602:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003606:	02f71063          	bne	a4,a5,80003626 <fsinit+0x60>
  initlog(dev, &sb);
    8000360a:	0001e597          	auipc	a1,0x1e
    8000360e:	c3658593          	addi	a1,a1,-970 # 80021240 <sb>
    80003612:	854a                	mv	a0,s2
    80003614:	1f9000ef          	jal	8000400c <initlog>
}
    80003618:	70a2                	ld	ra,40(sp)
    8000361a:	7402                	ld	s0,32(sp)
    8000361c:	64e2                	ld	s1,24(sp)
    8000361e:	6942                	ld	s2,16(sp)
    80003620:	69a2                	ld	s3,8(sp)
    80003622:	6145                	addi	sp,sp,48
    80003624:	8082                	ret
    panic("invalid file system");
    80003626:	00004517          	auipc	a0,0x4
    8000362a:	efa50513          	addi	a0,a0,-262 # 80007520 <etext+0x520>
    8000362e:	966fd0ef          	jal	80000794 <panic>

0000000080003632 <iinit>:
{
    80003632:	7179                	addi	sp,sp,-48
    80003634:	f406                	sd	ra,40(sp)
    80003636:	f022                	sd	s0,32(sp)
    80003638:	ec26                	sd	s1,24(sp)
    8000363a:	e84a                	sd	s2,16(sp)
    8000363c:	e44e                	sd	s3,8(sp)
    8000363e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003640:	00004597          	auipc	a1,0x4
    80003644:	ef858593          	addi	a1,a1,-264 # 80007538 <etext+0x538>
    80003648:	0001e517          	auipc	a0,0x1e
    8000364c:	c1850513          	addi	a0,a0,-1000 # 80021260 <itable>
    80003650:	d24fd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003654:	0001e497          	auipc	s1,0x1e
    80003658:	c3448493          	addi	s1,s1,-972 # 80021288 <itable+0x28>
    8000365c:	0001f997          	auipc	s3,0x1f
    80003660:	6bc98993          	addi	s3,s3,1724 # 80022d18 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003664:	00004917          	auipc	s2,0x4
    80003668:	edc90913          	addi	s2,s2,-292 # 80007540 <etext+0x540>
    8000366c:	85ca                	mv	a1,s2
    8000366e:	8526                	mv	a0,s1
    80003670:	475000ef          	jal	800042e4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003674:	08848493          	addi	s1,s1,136
    80003678:	ff349ae3          	bne	s1,s3,8000366c <iinit+0x3a>
}
    8000367c:	70a2                	ld	ra,40(sp)
    8000367e:	7402                	ld	s0,32(sp)
    80003680:	64e2                	ld	s1,24(sp)
    80003682:	6942                	ld	s2,16(sp)
    80003684:	69a2                	ld	s3,8(sp)
    80003686:	6145                	addi	sp,sp,48
    80003688:	8082                	ret

000000008000368a <ialloc>:
{
    8000368a:	7139                	addi	sp,sp,-64
    8000368c:	fc06                	sd	ra,56(sp)
    8000368e:	f822                	sd	s0,48(sp)
    80003690:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003692:	0001e717          	auipc	a4,0x1e
    80003696:	bba72703          	lw	a4,-1094(a4) # 8002124c <sb+0xc>
    8000369a:	4785                	li	a5,1
    8000369c:	06e7f063          	bgeu	a5,a4,800036fc <ialloc+0x72>
    800036a0:	f426                	sd	s1,40(sp)
    800036a2:	f04a                	sd	s2,32(sp)
    800036a4:	ec4e                	sd	s3,24(sp)
    800036a6:	e852                	sd	s4,16(sp)
    800036a8:	e456                	sd	s5,8(sp)
    800036aa:	e05a                	sd	s6,0(sp)
    800036ac:	8aaa                	mv	s5,a0
    800036ae:	8b2e                	mv	s6,a1
    800036b0:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800036b2:	0001ea17          	auipc	s4,0x1e
    800036b6:	b8ea0a13          	addi	s4,s4,-1138 # 80021240 <sb>
    800036ba:	00495593          	srli	a1,s2,0x4
    800036be:	018a2783          	lw	a5,24(s4)
    800036c2:	9dbd                	addw	a1,a1,a5
    800036c4:	8556                	mv	a0,s5
    800036c6:	9fdff0ef          	jal	800030c2 <bread>
    800036ca:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800036cc:	05850993          	addi	s3,a0,88
    800036d0:	00f97793          	andi	a5,s2,15
    800036d4:	079a                	slli	a5,a5,0x6
    800036d6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800036d8:	00099783          	lh	a5,0(s3)
    800036dc:	cb9d                	beqz	a5,80003712 <ialloc+0x88>
    brelse(bp);
    800036de:	aedff0ef          	jal	800031ca <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800036e2:	0905                	addi	s2,s2,1
    800036e4:	00ca2703          	lw	a4,12(s4)
    800036e8:	0009079b          	sext.w	a5,s2
    800036ec:	fce7e7e3          	bltu	a5,a4,800036ba <ialloc+0x30>
    800036f0:	74a2                	ld	s1,40(sp)
    800036f2:	7902                	ld	s2,32(sp)
    800036f4:	69e2                	ld	s3,24(sp)
    800036f6:	6a42                	ld	s4,16(sp)
    800036f8:	6aa2                	ld	s5,8(sp)
    800036fa:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800036fc:	00004517          	auipc	a0,0x4
    80003700:	e4c50513          	addi	a0,a0,-436 # 80007548 <etext+0x548>
    80003704:	dbffc0ef          	jal	800004c2 <printf>
  return 0;
    80003708:	4501                	li	a0,0
}
    8000370a:	70e2                	ld	ra,56(sp)
    8000370c:	7442                	ld	s0,48(sp)
    8000370e:	6121                	addi	sp,sp,64
    80003710:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003712:	04000613          	li	a2,64
    80003716:	4581                	li	a1,0
    80003718:	854e                	mv	a0,s3
    8000371a:	daefd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    8000371e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003722:	8526                	mv	a0,s1
    80003724:	2f1000ef          	jal	80004214 <log_write>
      brelse(bp);
    80003728:	8526                	mv	a0,s1
    8000372a:	aa1ff0ef          	jal	800031ca <brelse>
      return iget(dev, inum);
    8000372e:	0009059b          	sext.w	a1,s2
    80003732:	8556                	mv	a0,s5
    80003734:	de7ff0ef          	jal	8000351a <iget>
    80003738:	74a2                	ld	s1,40(sp)
    8000373a:	7902                	ld	s2,32(sp)
    8000373c:	69e2                	ld	s3,24(sp)
    8000373e:	6a42                	ld	s4,16(sp)
    80003740:	6aa2                	ld	s5,8(sp)
    80003742:	6b02                	ld	s6,0(sp)
    80003744:	b7d9                	j	8000370a <ialloc+0x80>

0000000080003746 <iupdate>:
{
    80003746:	1101                	addi	sp,sp,-32
    80003748:	ec06                	sd	ra,24(sp)
    8000374a:	e822                	sd	s0,16(sp)
    8000374c:	e426                	sd	s1,8(sp)
    8000374e:	e04a                	sd	s2,0(sp)
    80003750:	1000                	addi	s0,sp,32
    80003752:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003754:	415c                	lw	a5,4(a0)
    80003756:	0047d79b          	srliw	a5,a5,0x4
    8000375a:	0001e597          	auipc	a1,0x1e
    8000375e:	afe5a583          	lw	a1,-1282(a1) # 80021258 <sb+0x18>
    80003762:	9dbd                	addw	a1,a1,a5
    80003764:	4108                	lw	a0,0(a0)
    80003766:	95dff0ef          	jal	800030c2 <bread>
    8000376a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000376c:	05850793          	addi	a5,a0,88
    80003770:	40d8                	lw	a4,4(s1)
    80003772:	8b3d                	andi	a4,a4,15
    80003774:	071a                	slli	a4,a4,0x6
    80003776:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003778:	04449703          	lh	a4,68(s1)
    8000377c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003780:	04649703          	lh	a4,70(s1)
    80003784:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003788:	04849703          	lh	a4,72(s1)
    8000378c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003790:	04a49703          	lh	a4,74(s1)
    80003794:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003798:	44f8                	lw	a4,76(s1)
    8000379a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000379c:	03400613          	li	a2,52
    800037a0:	05048593          	addi	a1,s1,80
    800037a4:	00c78513          	addi	a0,a5,12
    800037a8:	d7cfd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    800037ac:	854a                	mv	a0,s2
    800037ae:	267000ef          	jal	80004214 <log_write>
  brelse(bp);
    800037b2:	854a                	mv	a0,s2
    800037b4:	a17ff0ef          	jal	800031ca <brelse>
}
    800037b8:	60e2                	ld	ra,24(sp)
    800037ba:	6442                	ld	s0,16(sp)
    800037bc:	64a2                	ld	s1,8(sp)
    800037be:	6902                	ld	s2,0(sp)
    800037c0:	6105                	addi	sp,sp,32
    800037c2:	8082                	ret

00000000800037c4 <idup>:
{
    800037c4:	1101                	addi	sp,sp,-32
    800037c6:	ec06                	sd	ra,24(sp)
    800037c8:	e822                	sd	s0,16(sp)
    800037ca:	e426                	sd	s1,8(sp)
    800037cc:	1000                	addi	s0,sp,32
    800037ce:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037d0:	0001e517          	auipc	a0,0x1e
    800037d4:	a9050513          	addi	a0,a0,-1392 # 80021260 <itable>
    800037d8:	c1cfd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    800037dc:	449c                	lw	a5,8(s1)
    800037de:	2785                	addiw	a5,a5,1
    800037e0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037e2:	0001e517          	auipc	a0,0x1e
    800037e6:	a7e50513          	addi	a0,a0,-1410 # 80021260 <itable>
    800037ea:	ca2fd0ef          	jal	80000c8c <release>
}
    800037ee:	8526                	mv	a0,s1
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6105                	addi	sp,sp,32
    800037f8:	8082                	ret

00000000800037fa <ilock>:
{
    800037fa:	1101                	addi	sp,sp,-32
    800037fc:	ec06                	sd	ra,24(sp)
    800037fe:	e822                	sd	s0,16(sp)
    80003800:	e426                	sd	s1,8(sp)
    80003802:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003804:	cd19                	beqz	a0,80003822 <ilock+0x28>
    80003806:	84aa                	mv	s1,a0
    80003808:	451c                	lw	a5,8(a0)
    8000380a:	00f05c63          	blez	a5,80003822 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000380e:	0541                	addi	a0,a0,16
    80003810:	30b000ef          	jal	8000431a <acquiresleep>
  if(ip->valid == 0){
    80003814:	40bc                	lw	a5,64(s1)
    80003816:	cf89                	beqz	a5,80003830 <ilock+0x36>
}
    80003818:	60e2                	ld	ra,24(sp)
    8000381a:	6442                	ld	s0,16(sp)
    8000381c:	64a2                	ld	s1,8(sp)
    8000381e:	6105                	addi	sp,sp,32
    80003820:	8082                	ret
    80003822:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003824:	00004517          	auipc	a0,0x4
    80003828:	d3c50513          	addi	a0,a0,-708 # 80007560 <etext+0x560>
    8000382c:	f69fc0ef          	jal	80000794 <panic>
    80003830:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003832:	40dc                	lw	a5,4(s1)
    80003834:	0047d79b          	srliw	a5,a5,0x4
    80003838:	0001e597          	auipc	a1,0x1e
    8000383c:	a205a583          	lw	a1,-1504(a1) # 80021258 <sb+0x18>
    80003840:	9dbd                	addw	a1,a1,a5
    80003842:	4088                	lw	a0,0(s1)
    80003844:	87fff0ef          	jal	800030c2 <bread>
    80003848:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000384a:	05850593          	addi	a1,a0,88
    8000384e:	40dc                	lw	a5,4(s1)
    80003850:	8bbd                	andi	a5,a5,15
    80003852:	079a                	slli	a5,a5,0x6
    80003854:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003856:	00059783          	lh	a5,0(a1)
    8000385a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000385e:	00259783          	lh	a5,2(a1)
    80003862:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003866:	00459783          	lh	a5,4(a1)
    8000386a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000386e:	00659783          	lh	a5,6(a1)
    80003872:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003876:	459c                	lw	a5,8(a1)
    80003878:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000387a:	03400613          	li	a2,52
    8000387e:	05b1                	addi	a1,a1,12
    80003880:	05048513          	addi	a0,s1,80
    80003884:	ca0fd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    80003888:	854a                	mv	a0,s2
    8000388a:	941ff0ef          	jal	800031ca <brelse>
    ip->valid = 1;
    8000388e:	4785                	li	a5,1
    80003890:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003892:	04449783          	lh	a5,68(s1)
    80003896:	c399                	beqz	a5,8000389c <ilock+0xa2>
    80003898:	6902                	ld	s2,0(sp)
    8000389a:	bfbd                	j	80003818 <ilock+0x1e>
      panic("ilock: no type");
    8000389c:	00004517          	auipc	a0,0x4
    800038a0:	ccc50513          	addi	a0,a0,-820 # 80007568 <etext+0x568>
    800038a4:	ef1fc0ef          	jal	80000794 <panic>

00000000800038a8 <iunlock>:
{
    800038a8:	1101                	addi	sp,sp,-32
    800038aa:	ec06                	sd	ra,24(sp)
    800038ac:	e822                	sd	s0,16(sp)
    800038ae:	e426                	sd	s1,8(sp)
    800038b0:	e04a                	sd	s2,0(sp)
    800038b2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800038b4:	c505                	beqz	a0,800038dc <iunlock+0x34>
    800038b6:	84aa                	mv	s1,a0
    800038b8:	01050913          	addi	s2,a0,16
    800038bc:	854a                	mv	a0,s2
    800038be:	2db000ef          	jal	80004398 <holdingsleep>
    800038c2:	cd09                	beqz	a0,800038dc <iunlock+0x34>
    800038c4:	449c                	lw	a5,8(s1)
    800038c6:	00f05b63          	blez	a5,800038dc <iunlock+0x34>
  releasesleep(&ip->lock);
    800038ca:	854a                	mv	a0,s2
    800038cc:	295000ef          	jal	80004360 <releasesleep>
}
    800038d0:	60e2                	ld	ra,24(sp)
    800038d2:	6442                	ld	s0,16(sp)
    800038d4:	64a2                	ld	s1,8(sp)
    800038d6:	6902                	ld	s2,0(sp)
    800038d8:	6105                	addi	sp,sp,32
    800038da:	8082                	ret
    panic("iunlock");
    800038dc:	00004517          	auipc	a0,0x4
    800038e0:	c9c50513          	addi	a0,a0,-868 # 80007578 <etext+0x578>
    800038e4:	eb1fc0ef          	jal	80000794 <panic>

00000000800038e8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800038e8:	7179                	addi	sp,sp,-48
    800038ea:	f406                	sd	ra,40(sp)
    800038ec:	f022                	sd	s0,32(sp)
    800038ee:	ec26                	sd	s1,24(sp)
    800038f0:	e84a                	sd	s2,16(sp)
    800038f2:	e44e                	sd	s3,8(sp)
    800038f4:	1800                	addi	s0,sp,48
    800038f6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038f8:	05050493          	addi	s1,a0,80
    800038fc:	08050913          	addi	s2,a0,128
    80003900:	a021                	j	80003908 <itrunc+0x20>
    80003902:	0491                	addi	s1,s1,4
    80003904:	01248b63          	beq	s1,s2,8000391a <itrunc+0x32>
    if(ip->addrs[i]){
    80003908:	408c                	lw	a1,0(s1)
    8000390a:	dde5                	beqz	a1,80003902 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000390c:	0009a503          	lw	a0,0(s3)
    80003910:	9abff0ef          	jal	800032ba <bfree>
      ip->addrs[i] = 0;
    80003914:	0004a023          	sw	zero,0(s1)
    80003918:	b7ed                	j	80003902 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000391a:	0809a583          	lw	a1,128(s3)
    8000391e:	ed89                	bnez	a1,80003938 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003920:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003924:	854e                	mv	a0,s3
    80003926:	e21ff0ef          	jal	80003746 <iupdate>
}
    8000392a:	70a2                	ld	ra,40(sp)
    8000392c:	7402                	ld	s0,32(sp)
    8000392e:	64e2                	ld	s1,24(sp)
    80003930:	6942                	ld	s2,16(sp)
    80003932:	69a2                	ld	s3,8(sp)
    80003934:	6145                	addi	sp,sp,48
    80003936:	8082                	ret
    80003938:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000393a:	0009a503          	lw	a0,0(s3)
    8000393e:	f84ff0ef          	jal	800030c2 <bread>
    80003942:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003944:	05850493          	addi	s1,a0,88
    80003948:	45850913          	addi	s2,a0,1112
    8000394c:	a021                	j	80003954 <itrunc+0x6c>
    8000394e:	0491                	addi	s1,s1,4
    80003950:	01248963          	beq	s1,s2,80003962 <itrunc+0x7a>
      if(a[j])
    80003954:	408c                	lw	a1,0(s1)
    80003956:	dde5                	beqz	a1,8000394e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003958:	0009a503          	lw	a0,0(s3)
    8000395c:	95fff0ef          	jal	800032ba <bfree>
    80003960:	b7fd                	j	8000394e <itrunc+0x66>
    brelse(bp);
    80003962:	8552                	mv	a0,s4
    80003964:	867ff0ef          	jal	800031ca <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003968:	0809a583          	lw	a1,128(s3)
    8000396c:	0009a503          	lw	a0,0(s3)
    80003970:	94bff0ef          	jal	800032ba <bfree>
    ip->addrs[NDIRECT] = 0;
    80003974:	0809a023          	sw	zero,128(s3)
    80003978:	6a02                	ld	s4,0(sp)
    8000397a:	b75d                	j	80003920 <itrunc+0x38>

000000008000397c <iput>:
{
    8000397c:	1101                	addi	sp,sp,-32
    8000397e:	ec06                	sd	ra,24(sp)
    80003980:	e822                	sd	s0,16(sp)
    80003982:	e426                	sd	s1,8(sp)
    80003984:	1000                	addi	s0,sp,32
    80003986:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003988:	0001e517          	auipc	a0,0x1e
    8000398c:	8d850513          	addi	a0,a0,-1832 # 80021260 <itable>
    80003990:	a64fd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003994:	4498                	lw	a4,8(s1)
    80003996:	4785                	li	a5,1
    80003998:	02f70063          	beq	a4,a5,800039b8 <iput+0x3c>
  ip->ref--;
    8000399c:	449c                	lw	a5,8(s1)
    8000399e:	37fd                	addiw	a5,a5,-1
    800039a0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800039a2:	0001e517          	auipc	a0,0x1e
    800039a6:	8be50513          	addi	a0,a0,-1858 # 80021260 <itable>
    800039aa:	ae2fd0ef          	jal	80000c8c <release>
}
    800039ae:	60e2                	ld	ra,24(sp)
    800039b0:	6442                	ld	s0,16(sp)
    800039b2:	64a2                	ld	s1,8(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039b8:	40bc                	lw	a5,64(s1)
    800039ba:	d3ed                	beqz	a5,8000399c <iput+0x20>
    800039bc:	04a49783          	lh	a5,74(s1)
    800039c0:	fff1                	bnez	a5,8000399c <iput+0x20>
    800039c2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800039c4:	01048913          	addi	s2,s1,16
    800039c8:	854a                	mv	a0,s2
    800039ca:	151000ef          	jal	8000431a <acquiresleep>
    release(&itable.lock);
    800039ce:	0001e517          	auipc	a0,0x1e
    800039d2:	89250513          	addi	a0,a0,-1902 # 80021260 <itable>
    800039d6:	ab6fd0ef          	jal	80000c8c <release>
    itrunc(ip);
    800039da:	8526                	mv	a0,s1
    800039dc:	f0dff0ef          	jal	800038e8 <itrunc>
    ip->type = 0;
    800039e0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039e4:	8526                	mv	a0,s1
    800039e6:	d61ff0ef          	jal	80003746 <iupdate>
    ip->valid = 0;
    800039ea:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800039ee:	854a                	mv	a0,s2
    800039f0:	171000ef          	jal	80004360 <releasesleep>
    acquire(&itable.lock);
    800039f4:	0001e517          	auipc	a0,0x1e
    800039f8:	86c50513          	addi	a0,a0,-1940 # 80021260 <itable>
    800039fc:	9f8fd0ef          	jal	80000bf4 <acquire>
    80003a00:	6902                	ld	s2,0(sp)
    80003a02:	bf69                	j	8000399c <iput+0x20>

0000000080003a04 <iunlockput>:
{
    80003a04:	1101                	addi	sp,sp,-32
    80003a06:	ec06                	sd	ra,24(sp)
    80003a08:	e822                	sd	s0,16(sp)
    80003a0a:	e426                	sd	s1,8(sp)
    80003a0c:	1000                	addi	s0,sp,32
    80003a0e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a10:	e99ff0ef          	jal	800038a8 <iunlock>
  iput(ip);
    80003a14:	8526                	mv	a0,s1
    80003a16:	f67ff0ef          	jal	8000397c <iput>
}
    80003a1a:	60e2                	ld	ra,24(sp)
    80003a1c:	6442                	ld	s0,16(sp)
    80003a1e:	64a2                	ld	s1,8(sp)
    80003a20:	6105                	addi	sp,sp,32
    80003a22:	8082                	ret

0000000080003a24 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a24:	1141                	addi	sp,sp,-16
    80003a26:	e422                	sd	s0,8(sp)
    80003a28:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a2a:	411c                	lw	a5,0(a0)
    80003a2c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a2e:	415c                	lw	a5,4(a0)
    80003a30:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a32:	04451783          	lh	a5,68(a0)
    80003a36:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a3a:	04a51783          	lh	a5,74(a0)
    80003a3e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a42:	04c56783          	lwu	a5,76(a0)
    80003a46:	e99c                	sd	a5,16(a1)
}
    80003a48:	6422                	ld	s0,8(sp)
    80003a4a:	0141                	addi	sp,sp,16
    80003a4c:	8082                	ret

0000000080003a4e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a4e:	457c                	lw	a5,76(a0)
    80003a50:	0ed7eb63          	bltu	a5,a3,80003b46 <readi+0xf8>
{
    80003a54:	7159                	addi	sp,sp,-112
    80003a56:	f486                	sd	ra,104(sp)
    80003a58:	f0a2                	sd	s0,96(sp)
    80003a5a:	eca6                	sd	s1,88(sp)
    80003a5c:	e0d2                	sd	s4,64(sp)
    80003a5e:	fc56                	sd	s5,56(sp)
    80003a60:	f85a                	sd	s6,48(sp)
    80003a62:	f45e                	sd	s7,40(sp)
    80003a64:	1880                	addi	s0,sp,112
    80003a66:	8b2a                	mv	s6,a0
    80003a68:	8bae                	mv	s7,a1
    80003a6a:	8a32                	mv	s4,a2
    80003a6c:	84b6                	mv	s1,a3
    80003a6e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a70:	9f35                	addw	a4,a4,a3
    return 0;
    80003a72:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a74:	0cd76063          	bltu	a4,a3,80003b34 <readi+0xe6>
    80003a78:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003a7a:	00e7f463          	bgeu	a5,a4,80003a82 <readi+0x34>
    n = ip->size - off;
    80003a7e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a82:	080a8f63          	beqz	s5,80003b20 <readi+0xd2>
    80003a86:	e8ca                	sd	s2,80(sp)
    80003a88:	f062                	sd	s8,32(sp)
    80003a8a:	ec66                	sd	s9,24(sp)
    80003a8c:	e86a                	sd	s10,16(sp)
    80003a8e:	e46e                	sd	s11,8(sp)
    80003a90:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a92:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a96:	5c7d                	li	s8,-1
    80003a98:	a80d                	j	80003aca <readi+0x7c>
    80003a9a:	020d1d93          	slli	s11,s10,0x20
    80003a9e:	020ddd93          	srli	s11,s11,0x20
    80003aa2:	05890613          	addi	a2,s2,88
    80003aa6:	86ee                	mv	a3,s11
    80003aa8:	963a                	add	a2,a2,a4
    80003aaa:	85d2                	mv	a1,s4
    80003aac:	855e                	mv	a0,s7
    80003aae:	aaefe0ef          	jal	80001d5c <either_copyout>
    80003ab2:	05850763          	beq	a0,s8,80003b00 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ab6:	854a                	mv	a0,s2
    80003ab8:	f12ff0ef          	jal	800031ca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003abc:	013d09bb          	addw	s3,s10,s3
    80003ac0:	009d04bb          	addw	s1,s10,s1
    80003ac4:	9a6e                	add	s4,s4,s11
    80003ac6:	0559f763          	bgeu	s3,s5,80003b14 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003aca:	00a4d59b          	srliw	a1,s1,0xa
    80003ace:	855a                	mv	a0,s6
    80003ad0:	977ff0ef          	jal	80003446 <bmap>
    80003ad4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ad8:	c5b1                	beqz	a1,80003b24 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003ada:	000b2503          	lw	a0,0(s6)
    80003ade:	de4ff0ef          	jal	800030c2 <bread>
    80003ae2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ae4:	3ff4f713          	andi	a4,s1,1023
    80003ae8:	40ec87bb          	subw	a5,s9,a4
    80003aec:	413a86bb          	subw	a3,s5,s3
    80003af0:	8d3e                	mv	s10,a5
    80003af2:	2781                	sext.w	a5,a5
    80003af4:	0006861b          	sext.w	a2,a3
    80003af8:	faf671e3          	bgeu	a2,a5,80003a9a <readi+0x4c>
    80003afc:	8d36                	mv	s10,a3
    80003afe:	bf71                	j	80003a9a <readi+0x4c>
      brelse(bp);
    80003b00:	854a                	mv	a0,s2
    80003b02:	ec8ff0ef          	jal	800031ca <brelse>
      tot = -1;
    80003b06:	59fd                	li	s3,-1
      break;
    80003b08:	6946                	ld	s2,80(sp)
    80003b0a:	7c02                	ld	s8,32(sp)
    80003b0c:	6ce2                	ld	s9,24(sp)
    80003b0e:	6d42                	ld	s10,16(sp)
    80003b10:	6da2                	ld	s11,8(sp)
    80003b12:	a831                	j	80003b2e <readi+0xe0>
    80003b14:	6946                	ld	s2,80(sp)
    80003b16:	7c02                	ld	s8,32(sp)
    80003b18:	6ce2                	ld	s9,24(sp)
    80003b1a:	6d42                	ld	s10,16(sp)
    80003b1c:	6da2                	ld	s11,8(sp)
    80003b1e:	a801                	j	80003b2e <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b20:	89d6                	mv	s3,s5
    80003b22:	a031                	j	80003b2e <readi+0xe0>
    80003b24:	6946                	ld	s2,80(sp)
    80003b26:	7c02                	ld	s8,32(sp)
    80003b28:	6ce2                	ld	s9,24(sp)
    80003b2a:	6d42                	ld	s10,16(sp)
    80003b2c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003b2e:	0009851b          	sext.w	a0,s3
    80003b32:	69a6                	ld	s3,72(sp)
}
    80003b34:	70a6                	ld	ra,104(sp)
    80003b36:	7406                	ld	s0,96(sp)
    80003b38:	64e6                	ld	s1,88(sp)
    80003b3a:	6a06                	ld	s4,64(sp)
    80003b3c:	7ae2                	ld	s5,56(sp)
    80003b3e:	7b42                	ld	s6,48(sp)
    80003b40:	7ba2                	ld	s7,40(sp)
    80003b42:	6165                	addi	sp,sp,112
    80003b44:	8082                	ret
    return 0;
    80003b46:	4501                	li	a0,0
}
    80003b48:	8082                	ret

0000000080003b4a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b4a:	457c                	lw	a5,76(a0)
    80003b4c:	10d7e063          	bltu	a5,a3,80003c4c <writei+0x102>
{
    80003b50:	7159                	addi	sp,sp,-112
    80003b52:	f486                	sd	ra,104(sp)
    80003b54:	f0a2                	sd	s0,96(sp)
    80003b56:	e8ca                	sd	s2,80(sp)
    80003b58:	e0d2                	sd	s4,64(sp)
    80003b5a:	fc56                	sd	s5,56(sp)
    80003b5c:	f85a                	sd	s6,48(sp)
    80003b5e:	f45e                	sd	s7,40(sp)
    80003b60:	1880                	addi	s0,sp,112
    80003b62:	8aaa                	mv	s5,a0
    80003b64:	8bae                	mv	s7,a1
    80003b66:	8a32                	mv	s4,a2
    80003b68:	8936                	mv	s2,a3
    80003b6a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b6c:	00e687bb          	addw	a5,a3,a4
    80003b70:	0ed7e063          	bltu	a5,a3,80003c50 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b74:	00043737          	lui	a4,0x43
    80003b78:	0cf76e63          	bltu	a4,a5,80003c54 <writei+0x10a>
    80003b7c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b7e:	0a0b0f63          	beqz	s6,80003c3c <writei+0xf2>
    80003b82:	eca6                	sd	s1,88(sp)
    80003b84:	f062                	sd	s8,32(sp)
    80003b86:	ec66                	sd	s9,24(sp)
    80003b88:	e86a                	sd	s10,16(sp)
    80003b8a:	e46e                	sd	s11,8(sp)
    80003b8c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b8e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b92:	5c7d                	li	s8,-1
    80003b94:	a825                	j	80003bcc <writei+0x82>
    80003b96:	020d1d93          	slli	s11,s10,0x20
    80003b9a:	020ddd93          	srli	s11,s11,0x20
    80003b9e:	05848513          	addi	a0,s1,88
    80003ba2:	86ee                	mv	a3,s11
    80003ba4:	8652                	mv	a2,s4
    80003ba6:	85de                	mv	a1,s7
    80003ba8:	953a                	add	a0,a0,a4
    80003baa:	9fcfe0ef          	jal	80001da6 <either_copyin>
    80003bae:	05850a63          	beq	a0,s8,80003c02 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bb2:	8526                	mv	a0,s1
    80003bb4:	660000ef          	jal	80004214 <log_write>
    brelse(bp);
    80003bb8:	8526                	mv	a0,s1
    80003bba:	e10ff0ef          	jal	800031ca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bbe:	013d09bb          	addw	s3,s10,s3
    80003bc2:	012d093b          	addw	s2,s10,s2
    80003bc6:	9a6e                	add	s4,s4,s11
    80003bc8:	0569f063          	bgeu	s3,s6,80003c08 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003bcc:	00a9559b          	srliw	a1,s2,0xa
    80003bd0:	8556                	mv	a0,s5
    80003bd2:	875ff0ef          	jal	80003446 <bmap>
    80003bd6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003bda:	c59d                	beqz	a1,80003c08 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003bdc:	000aa503          	lw	a0,0(s5)
    80003be0:	ce2ff0ef          	jal	800030c2 <bread>
    80003be4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003be6:	3ff97713          	andi	a4,s2,1023
    80003bea:	40ec87bb          	subw	a5,s9,a4
    80003bee:	413b06bb          	subw	a3,s6,s3
    80003bf2:	8d3e                	mv	s10,a5
    80003bf4:	2781                	sext.w	a5,a5
    80003bf6:	0006861b          	sext.w	a2,a3
    80003bfa:	f8f67ee3          	bgeu	a2,a5,80003b96 <writei+0x4c>
    80003bfe:	8d36                	mv	s10,a3
    80003c00:	bf59                	j	80003b96 <writei+0x4c>
      brelse(bp);
    80003c02:	8526                	mv	a0,s1
    80003c04:	dc6ff0ef          	jal	800031ca <brelse>
  }

  if(off > ip->size)
    80003c08:	04caa783          	lw	a5,76(s5)
    80003c0c:	0327fa63          	bgeu	a5,s2,80003c40 <writei+0xf6>
    ip->size = off;
    80003c10:	052aa623          	sw	s2,76(s5)
    80003c14:	64e6                	ld	s1,88(sp)
    80003c16:	7c02                	ld	s8,32(sp)
    80003c18:	6ce2                	ld	s9,24(sp)
    80003c1a:	6d42                	ld	s10,16(sp)
    80003c1c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c1e:	8556                	mv	a0,s5
    80003c20:	b27ff0ef          	jal	80003746 <iupdate>

  return tot;
    80003c24:	0009851b          	sext.w	a0,s3
    80003c28:	69a6                	ld	s3,72(sp)
}
    80003c2a:	70a6                	ld	ra,104(sp)
    80003c2c:	7406                	ld	s0,96(sp)
    80003c2e:	6946                	ld	s2,80(sp)
    80003c30:	6a06                	ld	s4,64(sp)
    80003c32:	7ae2                	ld	s5,56(sp)
    80003c34:	7b42                	ld	s6,48(sp)
    80003c36:	7ba2                	ld	s7,40(sp)
    80003c38:	6165                	addi	sp,sp,112
    80003c3a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c3c:	89da                	mv	s3,s6
    80003c3e:	b7c5                	j	80003c1e <writei+0xd4>
    80003c40:	64e6                	ld	s1,88(sp)
    80003c42:	7c02                	ld	s8,32(sp)
    80003c44:	6ce2                	ld	s9,24(sp)
    80003c46:	6d42                	ld	s10,16(sp)
    80003c48:	6da2                	ld	s11,8(sp)
    80003c4a:	bfd1                	j	80003c1e <writei+0xd4>
    return -1;
    80003c4c:	557d                	li	a0,-1
}
    80003c4e:	8082                	ret
    return -1;
    80003c50:	557d                	li	a0,-1
    80003c52:	bfe1                	j	80003c2a <writei+0xe0>
    return -1;
    80003c54:	557d                	li	a0,-1
    80003c56:	bfd1                	j	80003c2a <writei+0xe0>

0000000080003c58 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c58:	1141                	addi	sp,sp,-16
    80003c5a:	e406                	sd	ra,8(sp)
    80003c5c:	e022                	sd	s0,0(sp)
    80003c5e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c60:	4639                	li	a2,14
    80003c62:	932fd0ef          	jal	80000d94 <strncmp>
}
    80003c66:	60a2                	ld	ra,8(sp)
    80003c68:	6402                	ld	s0,0(sp)
    80003c6a:	0141                	addi	sp,sp,16
    80003c6c:	8082                	ret

0000000080003c6e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c6e:	7139                	addi	sp,sp,-64
    80003c70:	fc06                	sd	ra,56(sp)
    80003c72:	f822                	sd	s0,48(sp)
    80003c74:	f426                	sd	s1,40(sp)
    80003c76:	f04a                	sd	s2,32(sp)
    80003c78:	ec4e                	sd	s3,24(sp)
    80003c7a:	e852                	sd	s4,16(sp)
    80003c7c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c7e:	04451703          	lh	a4,68(a0)
    80003c82:	4785                	li	a5,1
    80003c84:	00f71a63          	bne	a4,a5,80003c98 <dirlookup+0x2a>
    80003c88:	892a                	mv	s2,a0
    80003c8a:	89ae                	mv	s3,a1
    80003c8c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c8e:	457c                	lw	a5,76(a0)
    80003c90:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c92:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c94:	e39d                	bnez	a5,80003cba <dirlookup+0x4c>
    80003c96:	a095                	j	80003cfa <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003c98:	00004517          	auipc	a0,0x4
    80003c9c:	8e850513          	addi	a0,a0,-1816 # 80007580 <etext+0x580>
    80003ca0:	af5fc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003ca4:	00004517          	auipc	a0,0x4
    80003ca8:	8f450513          	addi	a0,a0,-1804 # 80007598 <etext+0x598>
    80003cac:	ae9fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cb0:	24c1                	addiw	s1,s1,16
    80003cb2:	04c92783          	lw	a5,76(s2)
    80003cb6:	04f4f163          	bgeu	s1,a5,80003cf8 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cba:	4741                	li	a4,16
    80003cbc:	86a6                	mv	a3,s1
    80003cbe:	fc040613          	addi	a2,s0,-64
    80003cc2:	4581                	li	a1,0
    80003cc4:	854a                	mv	a0,s2
    80003cc6:	d89ff0ef          	jal	80003a4e <readi>
    80003cca:	47c1                	li	a5,16
    80003ccc:	fcf51ce3          	bne	a0,a5,80003ca4 <dirlookup+0x36>
    if(de.inum == 0)
    80003cd0:	fc045783          	lhu	a5,-64(s0)
    80003cd4:	dff1                	beqz	a5,80003cb0 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003cd6:	fc240593          	addi	a1,s0,-62
    80003cda:	854e                	mv	a0,s3
    80003cdc:	f7dff0ef          	jal	80003c58 <namecmp>
    80003ce0:	f961                	bnez	a0,80003cb0 <dirlookup+0x42>
      if(poff)
    80003ce2:	000a0463          	beqz	s4,80003cea <dirlookup+0x7c>
        *poff = off;
    80003ce6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cea:	fc045583          	lhu	a1,-64(s0)
    80003cee:	00092503          	lw	a0,0(s2)
    80003cf2:	829ff0ef          	jal	8000351a <iget>
    80003cf6:	a011                	j	80003cfa <dirlookup+0x8c>
  return 0;
    80003cf8:	4501                	li	a0,0
}
    80003cfa:	70e2                	ld	ra,56(sp)
    80003cfc:	7442                	ld	s0,48(sp)
    80003cfe:	74a2                	ld	s1,40(sp)
    80003d00:	7902                	ld	s2,32(sp)
    80003d02:	69e2                	ld	s3,24(sp)
    80003d04:	6a42                	ld	s4,16(sp)
    80003d06:	6121                	addi	sp,sp,64
    80003d08:	8082                	ret

0000000080003d0a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d0a:	711d                	addi	sp,sp,-96
    80003d0c:	ec86                	sd	ra,88(sp)
    80003d0e:	e8a2                	sd	s0,80(sp)
    80003d10:	e4a6                	sd	s1,72(sp)
    80003d12:	e0ca                	sd	s2,64(sp)
    80003d14:	fc4e                	sd	s3,56(sp)
    80003d16:	f852                	sd	s4,48(sp)
    80003d18:	f456                	sd	s5,40(sp)
    80003d1a:	f05a                	sd	s6,32(sp)
    80003d1c:	ec5e                	sd	s7,24(sp)
    80003d1e:	e862                	sd	s8,16(sp)
    80003d20:	e466                	sd	s9,8(sp)
    80003d22:	1080                	addi	s0,sp,96
    80003d24:	84aa                	mv	s1,a0
    80003d26:	8b2e                	mv	s6,a1
    80003d28:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d2a:	00054703          	lbu	a4,0(a0)
    80003d2e:	02f00793          	li	a5,47
    80003d32:	00f70e63          	beq	a4,a5,80003d4e <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d36:	af5fd0ef          	jal	8000182a <myproc>
    80003d3a:	15053503          	ld	a0,336(a0)
    80003d3e:	a87ff0ef          	jal	800037c4 <idup>
    80003d42:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d44:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d48:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d4a:	4b85                	li	s7,1
    80003d4c:	a871                	j	80003de8 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003d4e:	4585                	li	a1,1
    80003d50:	4505                	li	a0,1
    80003d52:	fc8ff0ef          	jal	8000351a <iget>
    80003d56:	8a2a                	mv	s4,a0
    80003d58:	b7f5                	j	80003d44 <namex+0x3a>
      iunlockput(ip);
    80003d5a:	8552                	mv	a0,s4
    80003d5c:	ca9ff0ef          	jal	80003a04 <iunlockput>
      return 0;
    80003d60:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d62:	8552                	mv	a0,s4
    80003d64:	60e6                	ld	ra,88(sp)
    80003d66:	6446                	ld	s0,80(sp)
    80003d68:	64a6                	ld	s1,72(sp)
    80003d6a:	6906                	ld	s2,64(sp)
    80003d6c:	79e2                	ld	s3,56(sp)
    80003d6e:	7a42                	ld	s4,48(sp)
    80003d70:	7aa2                	ld	s5,40(sp)
    80003d72:	7b02                	ld	s6,32(sp)
    80003d74:	6be2                	ld	s7,24(sp)
    80003d76:	6c42                	ld	s8,16(sp)
    80003d78:	6ca2                	ld	s9,8(sp)
    80003d7a:	6125                	addi	sp,sp,96
    80003d7c:	8082                	ret
      iunlock(ip);
    80003d7e:	8552                	mv	a0,s4
    80003d80:	b29ff0ef          	jal	800038a8 <iunlock>
      return ip;
    80003d84:	bff9                	j	80003d62 <namex+0x58>
      iunlockput(ip);
    80003d86:	8552                	mv	a0,s4
    80003d88:	c7dff0ef          	jal	80003a04 <iunlockput>
      return 0;
    80003d8c:	8a4e                	mv	s4,s3
    80003d8e:	bfd1                	j	80003d62 <namex+0x58>
  len = path - s;
    80003d90:	40998633          	sub	a2,s3,s1
    80003d94:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d98:	099c5063          	bge	s8,s9,80003e18 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003d9c:	4639                	li	a2,14
    80003d9e:	85a6                	mv	a1,s1
    80003da0:	8556                	mv	a0,s5
    80003da2:	f83fc0ef          	jal	80000d24 <memmove>
    80003da6:	84ce                	mv	s1,s3
  while(*path == '/')
    80003da8:	0004c783          	lbu	a5,0(s1)
    80003dac:	01279763          	bne	a5,s2,80003dba <namex+0xb0>
    path++;
    80003db0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003db2:	0004c783          	lbu	a5,0(s1)
    80003db6:	ff278de3          	beq	a5,s2,80003db0 <namex+0xa6>
    ilock(ip);
    80003dba:	8552                	mv	a0,s4
    80003dbc:	a3fff0ef          	jal	800037fa <ilock>
    if(ip->type != T_DIR){
    80003dc0:	044a1783          	lh	a5,68(s4)
    80003dc4:	f9779be3          	bne	a5,s7,80003d5a <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003dc8:	000b0563          	beqz	s6,80003dd2 <namex+0xc8>
    80003dcc:	0004c783          	lbu	a5,0(s1)
    80003dd0:	d7dd                	beqz	a5,80003d7e <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dd2:	4601                	li	a2,0
    80003dd4:	85d6                	mv	a1,s5
    80003dd6:	8552                	mv	a0,s4
    80003dd8:	e97ff0ef          	jal	80003c6e <dirlookup>
    80003ddc:	89aa                	mv	s3,a0
    80003dde:	d545                	beqz	a0,80003d86 <namex+0x7c>
    iunlockput(ip);
    80003de0:	8552                	mv	a0,s4
    80003de2:	c23ff0ef          	jal	80003a04 <iunlockput>
    ip = next;
    80003de6:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003de8:	0004c783          	lbu	a5,0(s1)
    80003dec:	01279763          	bne	a5,s2,80003dfa <namex+0xf0>
    path++;
    80003df0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003df2:	0004c783          	lbu	a5,0(s1)
    80003df6:	ff278de3          	beq	a5,s2,80003df0 <namex+0xe6>
  if(*path == 0)
    80003dfa:	cb8d                	beqz	a5,80003e2c <namex+0x122>
  while(*path != '/' && *path != 0)
    80003dfc:	0004c783          	lbu	a5,0(s1)
    80003e00:	89a6                	mv	s3,s1
  len = path - s;
    80003e02:	4c81                	li	s9,0
    80003e04:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e06:	01278963          	beq	a5,s2,80003e18 <namex+0x10e>
    80003e0a:	d3d9                	beqz	a5,80003d90 <namex+0x86>
    path++;
    80003e0c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e0e:	0009c783          	lbu	a5,0(s3)
    80003e12:	ff279ce3          	bne	a5,s2,80003e0a <namex+0x100>
    80003e16:	bfad                	j	80003d90 <namex+0x86>
    memmove(name, s, len);
    80003e18:	2601                	sext.w	a2,a2
    80003e1a:	85a6                	mv	a1,s1
    80003e1c:	8556                	mv	a0,s5
    80003e1e:	f07fc0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003e22:	9cd6                	add	s9,s9,s5
    80003e24:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e28:	84ce                	mv	s1,s3
    80003e2a:	bfbd                	j	80003da8 <namex+0x9e>
  if(nameiparent){
    80003e2c:	f20b0be3          	beqz	s6,80003d62 <namex+0x58>
    iput(ip);
    80003e30:	8552                	mv	a0,s4
    80003e32:	b4bff0ef          	jal	8000397c <iput>
    return 0;
    80003e36:	4a01                	li	s4,0
    80003e38:	b72d                	j	80003d62 <namex+0x58>

0000000080003e3a <dirlink>:
{
    80003e3a:	7139                	addi	sp,sp,-64
    80003e3c:	fc06                	sd	ra,56(sp)
    80003e3e:	f822                	sd	s0,48(sp)
    80003e40:	f04a                	sd	s2,32(sp)
    80003e42:	ec4e                	sd	s3,24(sp)
    80003e44:	e852                	sd	s4,16(sp)
    80003e46:	0080                	addi	s0,sp,64
    80003e48:	892a                	mv	s2,a0
    80003e4a:	8a2e                	mv	s4,a1
    80003e4c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e4e:	4601                	li	a2,0
    80003e50:	e1fff0ef          	jal	80003c6e <dirlookup>
    80003e54:	e535                	bnez	a0,80003ec0 <dirlink+0x86>
    80003e56:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e58:	04c92483          	lw	s1,76(s2)
    80003e5c:	c48d                	beqz	s1,80003e86 <dirlink+0x4c>
    80003e5e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e60:	4741                	li	a4,16
    80003e62:	86a6                	mv	a3,s1
    80003e64:	fc040613          	addi	a2,s0,-64
    80003e68:	4581                	li	a1,0
    80003e6a:	854a                	mv	a0,s2
    80003e6c:	be3ff0ef          	jal	80003a4e <readi>
    80003e70:	47c1                	li	a5,16
    80003e72:	04f51b63          	bne	a0,a5,80003ec8 <dirlink+0x8e>
    if(de.inum == 0)
    80003e76:	fc045783          	lhu	a5,-64(s0)
    80003e7a:	c791                	beqz	a5,80003e86 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e7c:	24c1                	addiw	s1,s1,16
    80003e7e:	04c92783          	lw	a5,76(s2)
    80003e82:	fcf4efe3          	bltu	s1,a5,80003e60 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003e86:	4639                	li	a2,14
    80003e88:	85d2                	mv	a1,s4
    80003e8a:	fc240513          	addi	a0,s0,-62
    80003e8e:	f3dfc0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003e92:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e96:	4741                	li	a4,16
    80003e98:	86a6                	mv	a3,s1
    80003e9a:	fc040613          	addi	a2,s0,-64
    80003e9e:	4581                	li	a1,0
    80003ea0:	854a                	mv	a0,s2
    80003ea2:	ca9ff0ef          	jal	80003b4a <writei>
    80003ea6:	1541                	addi	a0,a0,-16
    80003ea8:	00a03533          	snez	a0,a0
    80003eac:	40a00533          	neg	a0,a0
    80003eb0:	74a2                	ld	s1,40(sp)
}
    80003eb2:	70e2                	ld	ra,56(sp)
    80003eb4:	7442                	ld	s0,48(sp)
    80003eb6:	7902                	ld	s2,32(sp)
    80003eb8:	69e2                	ld	s3,24(sp)
    80003eba:	6a42                	ld	s4,16(sp)
    80003ebc:	6121                	addi	sp,sp,64
    80003ebe:	8082                	ret
    iput(ip);
    80003ec0:	abdff0ef          	jal	8000397c <iput>
    return -1;
    80003ec4:	557d                	li	a0,-1
    80003ec6:	b7f5                	j	80003eb2 <dirlink+0x78>
      panic("dirlink read");
    80003ec8:	00003517          	auipc	a0,0x3
    80003ecc:	6e050513          	addi	a0,a0,1760 # 800075a8 <etext+0x5a8>
    80003ed0:	8c5fc0ef          	jal	80000794 <panic>

0000000080003ed4 <namei>:

struct inode*
namei(char *path)
{
    80003ed4:	1101                	addi	sp,sp,-32
    80003ed6:	ec06                	sd	ra,24(sp)
    80003ed8:	e822                	sd	s0,16(sp)
    80003eda:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003edc:	fe040613          	addi	a2,s0,-32
    80003ee0:	4581                	li	a1,0
    80003ee2:	e29ff0ef          	jal	80003d0a <namex>
}
    80003ee6:	60e2                	ld	ra,24(sp)
    80003ee8:	6442                	ld	s0,16(sp)
    80003eea:	6105                	addi	sp,sp,32
    80003eec:	8082                	ret

0000000080003eee <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003eee:	1141                	addi	sp,sp,-16
    80003ef0:	e406                	sd	ra,8(sp)
    80003ef2:	e022                	sd	s0,0(sp)
    80003ef4:	0800                	addi	s0,sp,16
    80003ef6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ef8:	4585                	li	a1,1
    80003efa:	e11ff0ef          	jal	80003d0a <namex>
}
    80003efe:	60a2                	ld	ra,8(sp)
    80003f00:	6402                	ld	s0,0(sp)
    80003f02:	0141                	addi	sp,sp,16
    80003f04:	8082                	ret

0000000080003f06 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f06:	1101                	addi	sp,sp,-32
    80003f08:	ec06                	sd	ra,24(sp)
    80003f0a:	e822                	sd	s0,16(sp)
    80003f0c:	e426                	sd	s1,8(sp)
    80003f0e:	e04a                	sd	s2,0(sp)
    80003f10:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f12:	0001f917          	auipc	s2,0x1f
    80003f16:	df690913          	addi	s2,s2,-522 # 80022d08 <log>
    80003f1a:	01892583          	lw	a1,24(s2)
    80003f1e:	02892503          	lw	a0,40(s2)
    80003f22:	9a0ff0ef          	jal	800030c2 <bread>
    80003f26:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f28:	02c92603          	lw	a2,44(s2)
    80003f2c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f2e:	00c05f63          	blez	a2,80003f4c <write_head+0x46>
    80003f32:	0001f717          	auipc	a4,0x1f
    80003f36:	e0670713          	addi	a4,a4,-506 # 80022d38 <log+0x30>
    80003f3a:	87aa                	mv	a5,a0
    80003f3c:	060a                	slli	a2,a2,0x2
    80003f3e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f40:	4314                	lw	a3,0(a4)
    80003f42:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f44:	0711                	addi	a4,a4,4
    80003f46:	0791                	addi	a5,a5,4
    80003f48:	fec79ce3          	bne	a5,a2,80003f40 <write_head+0x3a>
  }
  bwrite(buf);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	a4aff0ef          	jal	80003198 <bwrite>
  brelse(buf);
    80003f52:	8526                	mv	a0,s1
    80003f54:	a76ff0ef          	jal	800031ca <brelse>
}
    80003f58:	60e2                	ld	ra,24(sp)
    80003f5a:	6442                	ld	s0,16(sp)
    80003f5c:	64a2                	ld	s1,8(sp)
    80003f5e:	6902                	ld	s2,0(sp)
    80003f60:	6105                	addi	sp,sp,32
    80003f62:	8082                	ret

0000000080003f64 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f64:	0001f797          	auipc	a5,0x1f
    80003f68:	dd07a783          	lw	a5,-560(a5) # 80022d34 <log+0x2c>
    80003f6c:	08f05f63          	blez	a5,8000400a <install_trans+0xa6>
{
    80003f70:	7139                	addi	sp,sp,-64
    80003f72:	fc06                	sd	ra,56(sp)
    80003f74:	f822                	sd	s0,48(sp)
    80003f76:	f426                	sd	s1,40(sp)
    80003f78:	f04a                	sd	s2,32(sp)
    80003f7a:	ec4e                	sd	s3,24(sp)
    80003f7c:	e852                	sd	s4,16(sp)
    80003f7e:	e456                	sd	s5,8(sp)
    80003f80:	e05a                	sd	s6,0(sp)
    80003f82:	0080                	addi	s0,sp,64
    80003f84:	8b2a                	mv	s6,a0
    80003f86:	0001fa97          	auipc	s5,0x1f
    80003f8a:	db2a8a93          	addi	s5,s5,-590 # 80022d38 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f8e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f90:	0001f997          	auipc	s3,0x1f
    80003f94:	d7898993          	addi	s3,s3,-648 # 80022d08 <log>
    80003f98:	a829                	j	80003fb2 <install_trans+0x4e>
    brelse(lbuf);
    80003f9a:	854a                	mv	a0,s2
    80003f9c:	a2eff0ef          	jal	800031ca <brelse>
    brelse(dbuf);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	a28ff0ef          	jal	800031ca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fa6:	2a05                	addiw	s4,s4,1
    80003fa8:	0a91                	addi	s5,s5,4
    80003faa:	02c9a783          	lw	a5,44(s3)
    80003fae:	04fa5463          	bge	s4,a5,80003ff6 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fb2:	0189a583          	lw	a1,24(s3)
    80003fb6:	014585bb          	addw	a1,a1,s4
    80003fba:	2585                	addiw	a1,a1,1
    80003fbc:	0289a503          	lw	a0,40(s3)
    80003fc0:	902ff0ef          	jal	800030c2 <bread>
    80003fc4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003fc6:	000aa583          	lw	a1,0(s5)
    80003fca:	0289a503          	lw	a0,40(s3)
    80003fce:	8f4ff0ef          	jal	800030c2 <bread>
    80003fd2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fd4:	40000613          	li	a2,1024
    80003fd8:	05890593          	addi	a1,s2,88
    80003fdc:	05850513          	addi	a0,a0,88
    80003fe0:	d45fc0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	9b2ff0ef          	jal	80003198 <bwrite>
    if(recovering == 0)
    80003fea:	fa0b18e3          	bnez	s6,80003f9a <install_trans+0x36>
      bunpin(dbuf);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	a96ff0ef          	jal	80003286 <bunpin>
    80003ff4:	b75d                	j	80003f9a <install_trans+0x36>
}
    80003ff6:	70e2                	ld	ra,56(sp)
    80003ff8:	7442                	ld	s0,48(sp)
    80003ffa:	74a2                	ld	s1,40(sp)
    80003ffc:	7902                	ld	s2,32(sp)
    80003ffe:	69e2                	ld	s3,24(sp)
    80004000:	6a42                	ld	s4,16(sp)
    80004002:	6aa2                	ld	s5,8(sp)
    80004004:	6b02                	ld	s6,0(sp)
    80004006:	6121                	addi	sp,sp,64
    80004008:	8082                	ret
    8000400a:	8082                	ret

000000008000400c <initlog>:
{
    8000400c:	7179                	addi	sp,sp,-48
    8000400e:	f406                	sd	ra,40(sp)
    80004010:	f022                	sd	s0,32(sp)
    80004012:	ec26                	sd	s1,24(sp)
    80004014:	e84a                	sd	s2,16(sp)
    80004016:	e44e                	sd	s3,8(sp)
    80004018:	1800                	addi	s0,sp,48
    8000401a:	892a                	mv	s2,a0
    8000401c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000401e:	0001f497          	auipc	s1,0x1f
    80004022:	cea48493          	addi	s1,s1,-790 # 80022d08 <log>
    80004026:	00003597          	auipc	a1,0x3
    8000402a:	59258593          	addi	a1,a1,1426 # 800075b8 <etext+0x5b8>
    8000402e:	8526                	mv	a0,s1
    80004030:	b45fc0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80004034:	0149a583          	lw	a1,20(s3)
    80004038:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000403a:	0109a783          	lw	a5,16(s3)
    8000403e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004040:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004044:	854a                	mv	a0,s2
    80004046:	87cff0ef          	jal	800030c2 <bread>
  log.lh.n = lh->n;
    8000404a:	4d30                	lw	a2,88(a0)
    8000404c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000404e:	00c05f63          	blez	a2,8000406c <initlog+0x60>
    80004052:	87aa                	mv	a5,a0
    80004054:	0001f717          	auipc	a4,0x1f
    80004058:	ce470713          	addi	a4,a4,-796 # 80022d38 <log+0x30>
    8000405c:	060a                	slli	a2,a2,0x2
    8000405e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004060:	4ff4                	lw	a3,92(a5)
    80004062:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004064:	0791                	addi	a5,a5,4
    80004066:	0711                	addi	a4,a4,4
    80004068:	fec79ce3          	bne	a5,a2,80004060 <initlog+0x54>
  brelse(buf);
    8000406c:	95eff0ef          	jal	800031ca <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004070:	4505                	li	a0,1
    80004072:	ef3ff0ef          	jal	80003f64 <install_trans>
  log.lh.n = 0;
    80004076:	0001f797          	auipc	a5,0x1f
    8000407a:	ca07af23          	sw	zero,-834(a5) # 80022d34 <log+0x2c>
  write_head(); // clear the log
    8000407e:	e89ff0ef          	jal	80003f06 <write_head>
}
    80004082:	70a2                	ld	ra,40(sp)
    80004084:	7402                	ld	s0,32(sp)
    80004086:	64e2                	ld	s1,24(sp)
    80004088:	6942                	ld	s2,16(sp)
    8000408a:	69a2                	ld	s3,8(sp)
    8000408c:	6145                	addi	sp,sp,48
    8000408e:	8082                	ret

0000000080004090 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004090:	1101                	addi	sp,sp,-32
    80004092:	ec06                	sd	ra,24(sp)
    80004094:	e822                	sd	s0,16(sp)
    80004096:	e426                	sd	s1,8(sp)
    80004098:	e04a                	sd	s2,0(sp)
    8000409a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000409c:	0001f517          	auipc	a0,0x1f
    800040a0:	c6c50513          	addi	a0,a0,-916 # 80022d08 <log>
    800040a4:	b51fc0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    800040a8:	0001f497          	auipc	s1,0x1f
    800040ac:	c6048493          	addi	s1,s1,-928 # 80022d08 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040b0:	4979                	li	s2,30
    800040b2:	a029                	j	800040bc <begin_op+0x2c>
      sleep(&log, &log.lock);
    800040b4:	85a6                	mv	a1,s1
    800040b6:	8526                	mv	a0,s1
    800040b8:	b11fd0ef          	jal	80001bc8 <sleep>
    if(log.committing){
    800040bc:	50dc                	lw	a5,36(s1)
    800040be:	fbfd                	bnez	a5,800040b4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040c0:	5098                	lw	a4,32(s1)
    800040c2:	2705                	addiw	a4,a4,1
    800040c4:	0027179b          	slliw	a5,a4,0x2
    800040c8:	9fb9                	addw	a5,a5,a4
    800040ca:	0017979b          	slliw	a5,a5,0x1
    800040ce:	54d4                	lw	a3,44(s1)
    800040d0:	9fb5                	addw	a5,a5,a3
    800040d2:	00f95763          	bge	s2,a5,800040e0 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800040d6:	85a6                	mv	a1,s1
    800040d8:	8526                	mv	a0,s1
    800040da:	aeffd0ef          	jal	80001bc8 <sleep>
    800040de:	bff9                	j	800040bc <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800040e0:	0001f517          	auipc	a0,0x1f
    800040e4:	c2850513          	addi	a0,a0,-984 # 80022d08 <log>
    800040e8:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800040ea:	ba3fc0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    800040ee:	60e2                	ld	ra,24(sp)
    800040f0:	6442                	ld	s0,16(sp)
    800040f2:	64a2                	ld	s1,8(sp)
    800040f4:	6902                	ld	s2,0(sp)
    800040f6:	6105                	addi	sp,sp,32
    800040f8:	8082                	ret

00000000800040fa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800040fa:	7139                	addi	sp,sp,-64
    800040fc:	fc06                	sd	ra,56(sp)
    800040fe:	f822                	sd	s0,48(sp)
    80004100:	f426                	sd	s1,40(sp)
    80004102:	f04a                	sd	s2,32(sp)
    80004104:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004106:	0001f497          	auipc	s1,0x1f
    8000410a:	c0248493          	addi	s1,s1,-1022 # 80022d08 <log>
    8000410e:	8526                	mv	a0,s1
    80004110:	ae5fc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80004114:	509c                	lw	a5,32(s1)
    80004116:	37fd                	addiw	a5,a5,-1
    80004118:	0007891b          	sext.w	s2,a5
    8000411c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000411e:	50dc                	lw	a5,36(s1)
    80004120:	ef9d                	bnez	a5,8000415e <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80004122:	04091763          	bnez	s2,80004170 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80004126:	0001f497          	auipc	s1,0x1f
    8000412a:	be248493          	addi	s1,s1,-1054 # 80022d08 <log>
    8000412e:	4785                	li	a5,1
    80004130:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004132:	8526                	mv	a0,s1
    80004134:	b59fc0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004138:	54dc                	lw	a5,44(s1)
    8000413a:	04f04b63          	bgtz	a5,80004190 <end_op+0x96>
    acquire(&log.lock);
    8000413e:	0001f497          	auipc	s1,0x1f
    80004142:	bca48493          	addi	s1,s1,-1078 # 80022d08 <log>
    80004146:	8526                	mv	a0,s1
    80004148:	aadfc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    8000414c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004150:	8526                	mv	a0,s1
    80004152:	964fe0ef          	jal	800022b6 <wakeup>
    release(&log.lock);
    80004156:	8526                	mv	a0,s1
    80004158:	b35fc0ef          	jal	80000c8c <release>
}
    8000415c:	a025                	j	80004184 <end_op+0x8a>
    8000415e:	ec4e                	sd	s3,24(sp)
    80004160:	e852                	sd	s4,16(sp)
    80004162:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004164:	00003517          	auipc	a0,0x3
    80004168:	45c50513          	addi	a0,a0,1116 # 800075c0 <etext+0x5c0>
    8000416c:	e28fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80004170:	0001f497          	auipc	s1,0x1f
    80004174:	b9848493          	addi	s1,s1,-1128 # 80022d08 <log>
    80004178:	8526                	mv	a0,s1
    8000417a:	93cfe0ef          	jal	800022b6 <wakeup>
  release(&log.lock);
    8000417e:	8526                	mv	a0,s1
    80004180:	b0dfc0ef          	jal	80000c8c <release>
}
    80004184:	70e2                	ld	ra,56(sp)
    80004186:	7442                	ld	s0,48(sp)
    80004188:	74a2                	ld	s1,40(sp)
    8000418a:	7902                	ld	s2,32(sp)
    8000418c:	6121                	addi	sp,sp,64
    8000418e:	8082                	ret
    80004190:	ec4e                	sd	s3,24(sp)
    80004192:	e852                	sd	s4,16(sp)
    80004194:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004196:	0001fa97          	auipc	s5,0x1f
    8000419a:	ba2a8a93          	addi	s5,s5,-1118 # 80022d38 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000419e:	0001fa17          	auipc	s4,0x1f
    800041a2:	b6aa0a13          	addi	s4,s4,-1174 # 80022d08 <log>
    800041a6:	018a2583          	lw	a1,24(s4)
    800041aa:	012585bb          	addw	a1,a1,s2
    800041ae:	2585                	addiw	a1,a1,1
    800041b0:	028a2503          	lw	a0,40(s4)
    800041b4:	f0ffe0ef          	jal	800030c2 <bread>
    800041b8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800041ba:	000aa583          	lw	a1,0(s5)
    800041be:	028a2503          	lw	a0,40(s4)
    800041c2:	f01fe0ef          	jal	800030c2 <bread>
    800041c6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800041c8:	40000613          	li	a2,1024
    800041cc:	05850593          	addi	a1,a0,88
    800041d0:	05848513          	addi	a0,s1,88
    800041d4:	b51fc0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    800041d8:	8526                	mv	a0,s1
    800041da:	fbffe0ef          	jal	80003198 <bwrite>
    brelse(from);
    800041de:	854e                	mv	a0,s3
    800041e0:	febfe0ef          	jal	800031ca <brelse>
    brelse(to);
    800041e4:	8526                	mv	a0,s1
    800041e6:	fe5fe0ef          	jal	800031ca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041ea:	2905                	addiw	s2,s2,1
    800041ec:	0a91                	addi	s5,s5,4
    800041ee:	02ca2783          	lw	a5,44(s4)
    800041f2:	faf94ae3          	blt	s2,a5,800041a6 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800041f6:	d11ff0ef          	jal	80003f06 <write_head>
    install_trans(0); // Now install writes to home locations
    800041fa:	4501                	li	a0,0
    800041fc:	d69ff0ef          	jal	80003f64 <install_trans>
    log.lh.n = 0;
    80004200:	0001f797          	auipc	a5,0x1f
    80004204:	b207aa23          	sw	zero,-1228(a5) # 80022d34 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004208:	cffff0ef          	jal	80003f06 <write_head>
    8000420c:	69e2                	ld	s3,24(sp)
    8000420e:	6a42                	ld	s4,16(sp)
    80004210:	6aa2                	ld	s5,8(sp)
    80004212:	b735                	j	8000413e <end_op+0x44>

0000000080004214 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004214:	1101                	addi	sp,sp,-32
    80004216:	ec06                	sd	ra,24(sp)
    80004218:	e822                	sd	s0,16(sp)
    8000421a:	e426                	sd	s1,8(sp)
    8000421c:	e04a                	sd	s2,0(sp)
    8000421e:	1000                	addi	s0,sp,32
    80004220:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004222:	0001f917          	auipc	s2,0x1f
    80004226:	ae690913          	addi	s2,s2,-1306 # 80022d08 <log>
    8000422a:	854a                	mv	a0,s2
    8000422c:	9c9fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004230:	02c92603          	lw	a2,44(s2)
    80004234:	47f5                	li	a5,29
    80004236:	06c7c363          	blt	a5,a2,8000429c <log_write+0x88>
    8000423a:	0001f797          	auipc	a5,0x1f
    8000423e:	aea7a783          	lw	a5,-1302(a5) # 80022d24 <log+0x1c>
    80004242:	37fd                	addiw	a5,a5,-1
    80004244:	04f65c63          	bge	a2,a5,8000429c <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004248:	0001f797          	auipc	a5,0x1f
    8000424c:	ae07a783          	lw	a5,-1312(a5) # 80022d28 <log+0x20>
    80004250:	04f05c63          	blez	a5,800042a8 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004254:	4781                	li	a5,0
    80004256:	04c05f63          	blez	a2,800042b4 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000425a:	44cc                	lw	a1,12(s1)
    8000425c:	0001f717          	auipc	a4,0x1f
    80004260:	adc70713          	addi	a4,a4,-1316 # 80022d38 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004264:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004266:	4314                	lw	a3,0(a4)
    80004268:	04b68663          	beq	a3,a1,800042b4 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000426c:	2785                	addiw	a5,a5,1
    8000426e:	0711                	addi	a4,a4,4
    80004270:	fef61be3          	bne	a2,a5,80004266 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004274:	0621                	addi	a2,a2,8
    80004276:	060a                	slli	a2,a2,0x2
    80004278:	0001f797          	auipc	a5,0x1f
    8000427c:	a9078793          	addi	a5,a5,-1392 # 80022d08 <log>
    80004280:	97b2                	add	a5,a5,a2
    80004282:	44d8                	lw	a4,12(s1)
    80004284:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004286:	8526                	mv	a0,s1
    80004288:	fcbfe0ef          	jal	80003252 <bpin>
    log.lh.n++;
    8000428c:	0001f717          	auipc	a4,0x1f
    80004290:	a7c70713          	addi	a4,a4,-1412 # 80022d08 <log>
    80004294:	575c                	lw	a5,44(a4)
    80004296:	2785                	addiw	a5,a5,1
    80004298:	d75c                	sw	a5,44(a4)
    8000429a:	a80d                	j	800042cc <log_write+0xb8>
    panic("too big a transaction");
    8000429c:	00003517          	auipc	a0,0x3
    800042a0:	33450513          	addi	a0,a0,820 # 800075d0 <etext+0x5d0>
    800042a4:	cf0fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    800042a8:	00003517          	auipc	a0,0x3
    800042ac:	34050513          	addi	a0,a0,832 # 800075e8 <etext+0x5e8>
    800042b0:	ce4fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    800042b4:	00878693          	addi	a3,a5,8
    800042b8:	068a                	slli	a3,a3,0x2
    800042ba:	0001f717          	auipc	a4,0x1f
    800042be:	a4e70713          	addi	a4,a4,-1458 # 80022d08 <log>
    800042c2:	9736                	add	a4,a4,a3
    800042c4:	44d4                	lw	a3,12(s1)
    800042c6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800042c8:	faf60fe3          	beq	a2,a5,80004286 <log_write+0x72>
  }
  release(&log.lock);
    800042cc:	0001f517          	auipc	a0,0x1f
    800042d0:	a3c50513          	addi	a0,a0,-1476 # 80022d08 <log>
    800042d4:	9b9fc0ef          	jal	80000c8c <release>
}
    800042d8:	60e2                	ld	ra,24(sp)
    800042da:	6442                	ld	s0,16(sp)
    800042dc:	64a2                	ld	s1,8(sp)
    800042de:	6902                	ld	s2,0(sp)
    800042e0:	6105                	addi	sp,sp,32
    800042e2:	8082                	ret

00000000800042e4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800042e4:	1101                	addi	sp,sp,-32
    800042e6:	ec06                	sd	ra,24(sp)
    800042e8:	e822                	sd	s0,16(sp)
    800042ea:	e426                	sd	s1,8(sp)
    800042ec:	e04a                	sd	s2,0(sp)
    800042ee:	1000                	addi	s0,sp,32
    800042f0:	84aa                	mv	s1,a0
    800042f2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800042f4:	00003597          	auipc	a1,0x3
    800042f8:	31458593          	addi	a1,a1,788 # 80007608 <etext+0x608>
    800042fc:	0521                	addi	a0,a0,8
    800042fe:	877fc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80004302:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004306:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000430a:	0204a423          	sw	zero,40(s1)
}
    8000430e:	60e2                	ld	ra,24(sp)
    80004310:	6442                	ld	s0,16(sp)
    80004312:	64a2                	ld	s1,8(sp)
    80004314:	6902                	ld	s2,0(sp)
    80004316:	6105                	addi	sp,sp,32
    80004318:	8082                	ret

000000008000431a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000431a:	1101                	addi	sp,sp,-32
    8000431c:	ec06                	sd	ra,24(sp)
    8000431e:	e822                	sd	s0,16(sp)
    80004320:	e426                	sd	s1,8(sp)
    80004322:	e04a                	sd	s2,0(sp)
    80004324:	1000                	addi	s0,sp,32
    80004326:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004328:	00850913          	addi	s2,a0,8
    8000432c:	854a                	mv	a0,s2
    8000432e:	8c7fc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80004332:	409c                	lw	a5,0(s1)
    80004334:	c799                	beqz	a5,80004342 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004336:	85ca                	mv	a1,s2
    80004338:	8526                	mv	a0,s1
    8000433a:	88ffd0ef          	jal	80001bc8 <sleep>
  while (lk->locked) {
    8000433e:	409c                	lw	a5,0(s1)
    80004340:	fbfd                	bnez	a5,80004336 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004342:	4785                	li	a5,1
    80004344:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004346:	ce4fd0ef          	jal	8000182a <myproc>
    8000434a:	591c                	lw	a5,48(a0)
    8000434c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000434e:	854a                	mv	a0,s2
    80004350:	93dfc0ef          	jal	80000c8c <release>
}
    80004354:	60e2                	ld	ra,24(sp)
    80004356:	6442                	ld	s0,16(sp)
    80004358:	64a2                	ld	s1,8(sp)
    8000435a:	6902                	ld	s2,0(sp)
    8000435c:	6105                	addi	sp,sp,32
    8000435e:	8082                	ret

0000000080004360 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004360:	1101                	addi	sp,sp,-32
    80004362:	ec06                	sd	ra,24(sp)
    80004364:	e822                	sd	s0,16(sp)
    80004366:	e426                	sd	s1,8(sp)
    80004368:	e04a                	sd	s2,0(sp)
    8000436a:	1000                	addi	s0,sp,32
    8000436c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000436e:	00850913          	addi	s2,a0,8
    80004372:	854a                	mv	a0,s2
    80004374:	881fc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80004378:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000437c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004380:	8526                	mv	a0,s1
    80004382:	f35fd0ef          	jal	800022b6 <wakeup>
  release(&lk->lk);
    80004386:	854a                	mv	a0,s2
    80004388:	905fc0ef          	jal	80000c8c <release>
}
    8000438c:	60e2                	ld	ra,24(sp)
    8000438e:	6442                	ld	s0,16(sp)
    80004390:	64a2                	ld	s1,8(sp)
    80004392:	6902                	ld	s2,0(sp)
    80004394:	6105                	addi	sp,sp,32
    80004396:	8082                	ret

0000000080004398 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004398:	7179                	addi	sp,sp,-48
    8000439a:	f406                	sd	ra,40(sp)
    8000439c:	f022                	sd	s0,32(sp)
    8000439e:	ec26                	sd	s1,24(sp)
    800043a0:	e84a                	sd	s2,16(sp)
    800043a2:	1800                	addi	s0,sp,48
    800043a4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800043a6:	00850913          	addi	s2,a0,8
    800043aa:	854a                	mv	a0,s2
    800043ac:	849fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800043b0:	409c                	lw	a5,0(s1)
    800043b2:	ef81                	bnez	a5,800043ca <holdingsleep+0x32>
    800043b4:	4481                	li	s1,0
  release(&lk->lk);
    800043b6:	854a                	mv	a0,s2
    800043b8:	8d5fc0ef          	jal	80000c8c <release>
  return r;
}
    800043bc:	8526                	mv	a0,s1
    800043be:	70a2                	ld	ra,40(sp)
    800043c0:	7402                	ld	s0,32(sp)
    800043c2:	64e2                	ld	s1,24(sp)
    800043c4:	6942                	ld	s2,16(sp)
    800043c6:	6145                	addi	sp,sp,48
    800043c8:	8082                	ret
    800043ca:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800043cc:	0284a983          	lw	s3,40(s1)
    800043d0:	c5afd0ef          	jal	8000182a <myproc>
    800043d4:	5904                	lw	s1,48(a0)
    800043d6:	413484b3          	sub	s1,s1,s3
    800043da:	0014b493          	seqz	s1,s1
    800043de:	69a2                	ld	s3,8(sp)
    800043e0:	bfd9                	j	800043b6 <holdingsleep+0x1e>

00000000800043e2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800043e2:	1141                	addi	sp,sp,-16
    800043e4:	e406                	sd	ra,8(sp)
    800043e6:	e022                	sd	s0,0(sp)
    800043e8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800043ea:	00003597          	auipc	a1,0x3
    800043ee:	22e58593          	addi	a1,a1,558 # 80007618 <etext+0x618>
    800043f2:	0001f517          	auipc	a0,0x1f
    800043f6:	a5e50513          	addi	a0,a0,-1442 # 80022e50 <ftable>
    800043fa:	f7afc0ef          	jal	80000b74 <initlock>
}
    800043fe:	60a2                	ld	ra,8(sp)
    80004400:	6402                	ld	s0,0(sp)
    80004402:	0141                	addi	sp,sp,16
    80004404:	8082                	ret

0000000080004406 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004406:	1101                	addi	sp,sp,-32
    80004408:	ec06                	sd	ra,24(sp)
    8000440a:	e822                	sd	s0,16(sp)
    8000440c:	e426                	sd	s1,8(sp)
    8000440e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004410:	0001f517          	auipc	a0,0x1f
    80004414:	a4050513          	addi	a0,a0,-1472 # 80022e50 <ftable>
    80004418:	fdcfc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000441c:	0001f497          	auipc	s1,0x1f
    80004420:	a4c48493          	addi	s1,s1,-1460 # 80022e68 <ftable+0x18>
    80004424:	00020717          	auipc	a4,0x20
    80004428:	9e470713          	addi	a4,a4,-1564 # 80023e08 <disk>
    if(f->ref == 0){
    8000442c:	40dc                	lw	a5,4(s1)
    8000442e:	cf89                	beqz	a5,80004448 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004430:	02848493          	addi	s1,s1,40
    80004434:	fee49ce3          	bne	s1,a4,8000442c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004438:	0001f517          	auipc	a0,0x1f
    8000443c:	a1850513          	addi	a0,a0,-1512 # 80022e50 <ftable>
    80004440:	84dfc0ef          	jal	80000c8c <release>
  return 0;
    80004444:	4481                	li	s1,0
    80004446:	a809                	j	80004458 <filealloc+0x52>
      f->ref = 1;
    80004448:	4785                	li	a5,1
    8000444a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000444c:	0001f517          	auipc	a0,0x1f
    80004450:	a0450513          	addi	a0,a0,-1532 # 80022e50 <ftable>
    80004454:	839fc0ef          	jal	80000c8c <release>
}
    80004458:	8526                	mv	a0,s1
    8000445a:	60e2                	ld	ra,24(sp)
    8000445c:	6442                	ld	s0,16(sp)
    8000445e:	64a2                	ld	s1,8(sp)
    80004460:	6105                	addi	sp,sp,32
    80004462:	8082                	ret

0000000080004464 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004464:	1101                	addi	sp,sp,-32
    80004466:	ec06                	sd	ra,24(sp)
    80004468:	e822                	sd	s0,16(sp)
    8000446a:	e426                	sd	s1,8(sp)
    8000446c:	1000                	addi	s0,sp,32
    8000446e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004470:	0001f517          	auipc	a0,0x1f
    80004474:	9e050513          	addi	a0,a0,-1568 # 80022e50 <ftable>
    80004478:	f7cfc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    8000447c:	40dc                	lw	a5,4(s1)
    8000447e:	02f05063          	blez	a5,8000449e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004482:	2785                	addiw	a5,a5,1
    80004484:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004486:	0001f517          	auipc	a0,0x1f
    8000448a:	9ca50513          	addi	a0,a0,-1590 # 80022e50 <ftable>
    8000448e:	ffefc0ef          	jal	80000c8c <release>
  return f;
}
    80004492:	8526                	mv	a0,s1
    80004494:	60e2                	ld	ra,24(sp)
    80004496:	6442                	ld	s0,16(sp)
    80004498:	64a2                	ld	s1,8(sp)
    8000449a:	6105                	addi	sp,sp,32
    8000449c:	8082                	ret
    panic("filedup");
    8000449e:	00003517          	auipc	a0,0x3
    800044a2:	18250513          	addi	a0,a0,386 # 80007620 <etext+0x620>
    800044a6:	aeefc0ef          	jal	80000794 <panic>

00000000800044aa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044aa:	7139                	addi	sp,sp,-64
    800044ac:	fc06                	sd	ra,56(sp)
    800044ae:	f822                	sd	s0,48(sp)
    800044b0:	f426                	sd	s1,40(sp)
    800044b2:	0080                	addi	s0,sp,64
    800044b4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044b6:	0001f517          	auipc	a0,0x1f
    800044ba:	99a50513          	addi	a0,a0,-1638 # 80022e50 <ftable>
    800044be:	f36fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    800044c2:	40dc                	lw	a5,4(s1)
    800044c4:	04f05a63          	blez	a5,80004518 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800044c8:	37fd                	addiw	a5,a5,-1
    800044ca:	0007871b          	sext.w	a4,a5
    800044ce:	c0dc                	sw	a5,4(s1)
    800044d0:	04e04e63          	bgtz	a4,8000452c <fileclose+0x82>
    800044d4:	f04a                	sd	s2,32(sp)
    800044d6:	ec4e                	sd	s3,24(sp)
    800044d8:	e852                	sd	s4,16(sp)
    800044da:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044dc:	0004a903          	lw	s2,0(s1)
    800044e0:	0094ca83          	lbu	s5,9(s1)
    800044e4:	0104ba03          	ld	s4,16(s1)
    800044e8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044ec:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044f0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044f4:	0001f517          	auipc	a0,0x1f
    800044f8:	95c50513          	addi	a0,a0,-1700 # 80022e50 <ftable>
    800044fc:	f90fc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    80004500:	4785                	li	a5,1
    80004502:	04f90063          	beq	s2,a5,80004542 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004506:	3979                	addiw	s2,s2,-2
    80004508:	4785                	li	a5,1
    8000450a:	0527f563          	bgeu	a5,s2,80004554 <fileclose+0xaa>
    8000450e:	7902                	ld	s2,32(sp)
    80004510:	69e2                	ld	s3,24(sp)
    80004512:	6a42                	ld	s4,16(sp)
    80004514:	6aa2                	ld	s5,8(sp)
    80004516:	a00d                	j	80004538 <fileclose+0x8e>
    80004518:	f04a                	sd	s2,32(sp)
    8000451a:	ec4e                	sd	s3,24(sp)
    8000451c:	e852                	sd	s4,16(sp)
    8000451e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004520:	00003517          	auipc	a0,0x3
    80004524:	10850513          	addi	a0,a0,264 # 80007628 <etext+0x628>
    80004528:	a6cfc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    8000452c:	0001f517          	auipc	a0,0x1f
    80004530:	92450513          	addi	a0,a0,-1756 # 80022e50 <ftable>
    80004534:	f58fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004538:	70e2                	ld	ra,56(sp)
    8000453a:	7442                	ld	s0,48(sp)
    8000453c:	74a2                	ld	s1,40(sp)
    8000453e:	6121                	addi	sp,sp,64
    80004540:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004542:	85d6                	mv	a1,s5
    80004544:	8552                	mv	a0,s4
    80004546:	336000ef          	jal	8000487c <pipeclose>
    8000454a:	7902                	ld	s2,32(sp)
    8000454c:	69e2                	ld	s3,24(sp)
    8000454e:	6a42                	ld	s4,16(sp)
    80004550:	6aa2                	ld	s5,8(sp)
    80004552:	b7dd                	j	80004538 <fileclose+0x8e>
    begin_op();
    80004554:	b3dff0ef          	jal	80004090 <begin_op>
    iput(ff.ip);
    80004558:	854e                	mv	a0,s3
    8000455a:	c22ff0ef          	jal	8000397c <iput>
    end_op();
    8000455e:	b9dff0ef          	jal	800040fa <end_op>
    80004562:	7902                	ld	s2,32(sp)
    80004564:	69e2                	ld	s3,24(sp)
    80004566:	6a42                	ld	s4,16(sp)
    80004568:	6aa2                	ld	s5,8(sp)
    8000456a:	b7f9                	j	80004538 <fileclose+0x8e>

000000008000456c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000456c:	715d                	addi	sp,sp,-80
    8000456e:	e486                	sd	ra,72(sp)
    80004570:	e0a2                	sd	s0,64(sp)
    80004572:	fc26                	sd	s1,56(sp)
    80004574:	f44e                	sd	s3,40(sp)
    80004576:	0880                	addi	s0,sp,80
    80004578:	84aa                	mv	s1,a0
    8000457a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000457c:	aaefd0ef          	jal	8000182a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004580:	409c                	lw	a5,0(s1)
    80004582:	37f9                	addiw	a5,a5,-2
    80004584:	4705                	li	a4,1
    80004586:	04f76063          	bltu	a4,a5,800045c6 <filestat+0x5a>
    8000458a:	f84a                	sd	s2,48(sp)
    8000458c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000458e:	6c88                	ld	a0,24(s1)
    80004590:	a6aff0ef          	jal	800037fa <ilock>
    stati(f->ip, &st);
    80004594:	fb840593          	addi	a1,s0,-72
    80004598:	6c88                	ld	a0,24(s1)
    8000459a:	c8aff0ef          	jal	80003a24 <stati>
    iunlock(f->ip);
    8000459e:	6c88                	ld	a0,24(s1)
    800045a0:	b08ff0ef          	jal	800038a8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045a4:	46e1                	li	a3,24
    800045a6:	fb840613          	addi	a2,s0,-72
    800045aa:	85ce                	mv	a1,s3
    800045ac:	05093503          	ld	a0,80(s2)
    800045b0:	fa3fc0ef          	jal	80001552 <copyout>
    800045b4:	41f5551b          	sraiw	a0,a0,0x1f
    800045b8:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800045ba:	60a6                	ld	ra,72(sp)
    800045bc:	6406                	ld	s0,64(sp)
    800045be:	74e2                	ld	s1,56(sp)
    800045c0:	79a2                	ld	s3,40(sp)
    800045c2:	6161                	addi	sp,sp,80
    800045c4:	8082                	ret
  return -1;
    800045c6:	557d                	li	a0,-1
    800045c8:	bfcd                	j	800045ba <filestat+0x4e>

00000000800045ca <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045ca:	7179                	addi	sp,sp,-48
    800045cc:	f406                	sd	ra,40(sp)
    800045ce:	f022                	sd	s0,32(sp)
    800045d0:	e84a                	sd	s2,16(sp)
    800045d2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045d4:	00854783          	lbu	a5,8(a0)
    800045d8:	cfd1                	beqz	a5,80004674 <fileread+0xaa>
    800045da:	ec26                	sd	s1,24(sp)
    800045dc:	e44e                	sd	s3,8(sp)
    800045de:	84aa                	mv	s1,a0
    800045e0:	89ae                	mv	s3,a1
    800045e2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045e4:	411c                	lw	a5,0(a0)
    800045e6:	4705                	li	a4,1
    800045e8:	04e78363          	beq	a5,a4,8000462e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045ec:	470d                	li	a4,3
    800045ee:	04e78763          	beq	a5,a4,8000463c <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800045f2:	4709                	li	a4,2
    800045f4:	06e79a63          	bne	a5,a4,80004668 <fileread+0x9e>
    ilock(f->ip);
    800045f8:	6d08                	ld	a0,24(a0)
    800045fa:	a00ff0ef          	jal	800037fa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800045fe:	874a                	mv	a4,s2
    80004600:	5094                	lw	a3,32(s1)
    80004602:	864e                	mv	a2,s3
    80004604:	4585                	li	a1,1
    80004606:	6c88                	ld	a0,24(s1)
    80004608:	c46ff0ef          	jal	80003a4e <readi>
    8000460c:	892a                	mv	s2,a0
    8000460e:	00a05563          	blez	a0,80004618 <fileread+0x4e>
      f->off += r;
    80004612:	509c                	lw	a5,32(s1)
    80004614:	9fa9                	addw	a5,a5,a0
    80004616:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004618:	6c88                	ld	a0,24(s1)
    8000461a:	a8eff0ef          	jal	800038a8 <iunlock>
    8000461e:	64e2                	ld	s1,24(sp)
    80004620:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004622:	854a                	mv	a0,s2
    80004624:	70a2                	ld	ra,40(sp)
    80004626:	7402                	ld	s0,32(sp)
    80004628:	6942                	ld	s2,16(sp)
    8000462a:	6145                	addi	sp,sp,48
    8000462c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000462e:	6908                	ld	a0,16(a0)
    80004630:	388000ef          	jal	800049b8 <piperead>
    80004634:	892a                	mv	s2,a0
    80004636:	64e2                	ld	s1,24(sp)
    80004638:	69a2                	ld	s3,8(sp)
    8000463a:	b7e5                	j	80004622 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000463c:	02451783          	lh	a5,36(a0)
    80004640:	03079693          	slli	a3,a5,0x30
    80004644:	92c1                	srli	a3,a3,0x30
    80004646:	4725                	li	a4,9
    80004648:	02d76863          	bltu	a4,a3,80004678 <fileread+0xae>
    8000464c:	0792                	slli	a5,a5,0x4
    8000464e:	0001e717          	auipc	a4,0x1e
    80004652:	76270713          	addi	a4,a4,1890 # 80022db0 <devsw>
    80004656:	97ba                	add	a5,a5,a4
    80004658:	639c                	ld	a5,0(a5)
    8000465a:	c39d                	beqz	a5,80004680 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000465c:	4505                	li	a0,1
    8000465e:	9782                	jalr	a5
    80004660:	892a                	mv	s2,a0
    80004662:	64e2                	ld	s1,24(sp)
    80004664:	69a2                	ld	s3,8(sp)
    80004666:	bf75                	j	80004622 <fileread+0x58>
    panic("fileread");
    80004668:	00003517          	auipc	a0,0x3
    8000466c:	fd050513          	addi	a0,a0,-48 # 80007638 <etext+0x638>
    80004670:	924fc0ef          	jal	80000794 <panic>
    return -1;
    80004674:	597d                	li	s2,-1
    80004676:	b775                	j	80004622 <fileread+0x58>
      return -1;
    80004678:	597d                	li	s2,-1
    8000467a:	64e2                	ld	s1,24(sp)
    8000467c:	69a2                	ld	s3,8(sp)
    8000467e:	b755                	j	80004622 <fileread+0x58>
    80004680:	597d                	li	s2,-1
    80004682:	64e2                	ld	s1,24(sp)
    80004684:	69a2                	ld	s3,8(sp)
    80004686:	bf71                	j	80004622 <fileread+0x58>

0000000080004688 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004688:	00954783          	lbu	a5,9(a0)
    8000468c:	10078b63          	beqz	a5,800047a2 <filewrite+0x11a>
{
    80004690:	715d                	addi	sp,sp,-80
    80004692:	e486                	sd	ra,72(sp)
    80004694:	e0a2                	sd	s0,64(sp)
    80004696:	f84a                	sd	s2,48(sp)
    80004698:	f052                	sd	s4,32(sp)
    8000469a:	e85a                	sd	s6,16(sp)
    8000469c:	0880                	addi	s0,sp,80
    8000469e:	892a                	mv	s2,a0
    800046a0:	8b2e                	mv	s6,a1
    800046a2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800046a4:	411c                	lw	a5,0(a0)
    800046a6:	4705                	li	a4,1
    800046a8:	02e78763          	beq	a5,a4,800046d6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046ac:	470d                	li	a4,3
    800046ae:	02e78863          	beq	a5,a4,800046de <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046b2:	4709                	li	a4,2
    800046b4:	0ce79c63          	bne	a5,a4,8000478c <filewrite+0x104>
    800046b8:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046ba:	0ac05863          	blez	a2,8000476a <filewrite+0xe2>
    800046be:	fc26                	sd	s1,56(sp)
    800046c0:	ec56                	sd	s5,24(sp)
    800046c2:	e45e                	sd	s7,8(sp)
    800046c4:	e062                	sd	s8,0(sp)
    int i = 0;
    800046c6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800046c8:	6b85                	lui	s7,0x1
    800046ca:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800046ce:	6c05                	lui	s8,0x1
    800046d0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800046d4:	a8b5                	j	80004750 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800046d6:	6908                	ld	a0,16(a0)
    800046d8:	1fc000ef          	jal	800048d4 <pipewrite>
    800046dc:	a04d                	j	8000477e <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046de:	02451783          	lh	a5,36(a0)
    800046e2:	03079693          	slli	a3,a5,0x30
    800046e6:	92c1                	srli	a3,a3,0x30
    800046e8:	4725                	li	a4,9
    800046ea:	0ad76e63          	bltu	a4,a3,800047a6 <filewrite+0x11e>
    800046ee:	0792                	slli	a5,a5,0x4
    800046f0:	0001e717          	auipc	a4,0x1e
    800046f4:	6c070713          	addi	a4,a4,1728 # 80022db0 <devsw>
    800046f8:	97ba                	add	a5,a5,a4
    800046fa:	679c                	ld	a5,8(a5)
    800046fc:	c7dd                	beqz	a5,800047aa <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800046fe:	4505                	li	a0,1
    80004700:	9782                	jalr	a5
    80004702:	a8b5                	j	8000477e <filewrite+0xf6>
      if(n1 > max)
    80004704:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004708:	989ff0ef          	jal	80004090 <begin_op>
      ilock(f->ip);
    8000470c:	01893503          	ld	a0,24(s2)
    80004710:	8eaff0ef          	jal	800037fa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004714:	8756                	mv	a4,s5
    80004716:	02092683          	lw	a3,32(s2)
    8000471a:	01698633          	add	a2,s3,s6
    8000471e:	4585                	li	a1,1
    80004720:	01893503          	ld	a0,24(s2)
    80004724:	c26ff0ef          	jal	80003b4a <writei>
    80004728:	84aa                	mv	s1,a0
    8000472a:	00a05763          	blez	a0,80004738 <filewrite+0xb0>
        f->off += r;
    8000472e:	02092783          	lw	a5,32(s2)
    80004732:	9fa9                	addw	a5,a5,a0
    80004734:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004738:	01893503          	ld	a0,24(s2)
    8000473c:	96cff0ef          	jal	800038a8 <iunlock>
      end_op();
    80004740:	9bbff0ef          	jal	800040fa <end_op>

      if(r != n1){
    80004744:	029a9563          	bne	s5,s1,8000476e <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004748:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000474c:	0149da63          	bge	s3,s4,80004760 <filewrite+0xd8>
      int n1 = n - i;
    80004750:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004754:	0004879b          	sext.w	a5,s1
    80004758:	fafbd6e3          	bge	s7,a5,80004704 <filewrite+0x7c>
    8000475c:	84e2                	mv	s1,s8
    8000475e:	b75d                	j	80004704 <filewrite+0x7c>
    80004760:	74e2                	ld	s1,56(sp)
    80004762:	6ae2                	ld	s5,24(sp)
    80004764:	6ba2                	ld	s7,8(sp)
    80004766:	6c02                	ld	s8,0(sp)
    80004768:	a039                	j	80004776 <filewrite+0xee>
    int i = 0;
    8000476a:	4981                	li	s3,0
    8000476c:	a029                	j	80004776 <filewrite+0xee>
    8000476e:	74e2                	ld	s1,56(sp)
    80004770:	6ae2                	ld	s5,24(sp)
    80004772:	6ba2                	ld	s7,8(sp)
    80004774:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004776:	033a1c63          	bne	s4,s3,800047ae <filewrite+0x126>
    8000477a:	8552                	mv	a0,s4
    8000477c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000477e:	60a6                	ld	ra,72(sp)
    80004780:	6406                	ld	s0,64(sp)
    80004782:	7942                	ld	s2,48(sp)
    80004784:	7a02                	ld	s4,32(sp)
    80004786:	6b42                	ld	s6,16(sp)
    80004788:	6161                	addi	sp,sp,80
    8000478a:	8082                	ret
    8000478c:	fc26                	sd	s1,56(sp)
    8000478e:	f44e                	sd	s3,40(sp)
    80004790:	ec56                	sd	s5,24(sp)
    80004792:	e45e                	sd	s7,8(sp)
    80004794:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004796:	00003517          	auipc	a0,0x3
    8000479a:	eb250513          	addi	a0,a0,-334 # 80007648 <etext+0x648>
    8000479e:	ff7fb0ef          	jal	80000794 <panic>
    return -1;
    800047a2:	557d                	li	a0,-1
}
    800047a4:	8082                	ret
      return -1;
    800047a6:	557d                	li	a0,-1
    800047a8:	bfd9                	j	8000477e <filewrite+0xf6>
    800047aa:	557d                	li	a0,-1
    800047ac:	bfc9                	j	8000477e <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800047ae:	557d                	li	a0,-1
    800047b0:	79a2                	ld	s3,40(sp)
    800047b2:	b7f1                	j	8000477e <filewrite+0xf6>

00000000800047b4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047b4:	7179                	addi	sp,sp,-48
    800047b6:	f406                	sd	ra,40(sp)
    800047b8:	f022                	sd	s0,32(sp)
    800047ba:	ec26                	sd	s1,24(sp)
    800047bc:	e052                	sd	s4,0(sp)
    800047be:	1800                	addi	s0,sp,48
    800047c0:	84aa                	mv	s1,a0
    800047c2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800047c4:	0005b023          	sd	zero,0(a1)
    800047c8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800047cc:	c3bff0ef          	jal	80004406 <filealloc>
    800047d0:	e088                	sd	a0,0(s1)
    800047d2:	c549                	beqz	a0,8000485c <pipealloc+0xa8>
    800047d4:	c33ff0ef          	jal	80004406 <filealloc>
    800047d8:	00aa3023          	sd	a0,0(s4)
    800047dc:	cd25                	beqz	a0,80004854 <pipealloc+0xa0>
    800047de:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800047e0:	b44fc0ef          	jal	80000b24 <kalloc>
    800047e4:	892a                	mv	s2,a0
    800047e6:	c12d                	beqz	a0,80004848 <pipealloc+0x94>
    800047e8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800047ea:	4985                	li	s3,1
    800047ec:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800047f0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800047f4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800047f8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800047fc:	00003597          	auipc	a1,0x3
    80004800:	e5c58593          	addi	a1,a1,-420 # 80007658 <etext+0x658>
    80004804:	b70fc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    80004808:	609c                	ld	a5,0(s1)
    8000480a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000480e:	609c                	ld	a5,0(s1)
    80004810:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004814:	609c                	ld	a5,0(s1)
    80004816:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000481a:	609c                	ld	a5,0(s1)
    8000481c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004820:	000a3783          	ld	a5,0(s4)
    80004824:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004828:	000a3783          	ld	a5,0(s4)
    8000482c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004830:	000a3783          	ld	a5,0(s4)
    80004834:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004838:	000a3783          	ld	a5,0(s4)
    8000483c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004840:	4501                	li	a0,0
    80004842:	6942                	ld	s2,16(sp)
    80004844:	69a2                	ld	s3,8(sp)
    80004846:	a01d                	j	8000486c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004848:	6088                	ld	a0,0(s1)
    8000484a:	c119                	beqz	a0,80004850 <pipealloc+0x9c>
    8000484c:	6942                	ld	s2,16(sp)
    8000484e:	a029                	j	80004858 <pipealloc+0xa4>
    80004850:	6942                	ld	s2,16(sp)
    80004852:	a029                	j	8000485c <pipealloc+0xa8>
    80004854:	6088                	ld	a0,0(s1)
    80004856:	c10d                	beqz	a0,80004878 <pipealloc+0xc4>
    fileclose(*f0);
    80004858:	c53ff0ef          	jal	800044aa <fileclose>
  if(*f1)
    8000485c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004860:	557d                	li	a0,-1
  if(*f1)
    80004862:	c789                	beqz	a5,8000486c <pipealloc+0xb8>
    fileclose(*f1);
    80004864:	853e                	mv	a0,a5
    80004866:	c45ff0ef          	jal	800044aa <fileclose>
  return -1;
    8000486a:	557d                	li	a0,-1
}
    8000486c:	70a2                	ld	ra,40(sp)
    8000486e:	7402                	ld	s0,32(sp)
    80004870:	64e2                	ld	s1,24(sp)
    80004872:	6a02                	ld	s4,0(sp)
    80004874:	6145                	addi	sp,sp,48
    80004876:	8082                	ret
  return -1;
    80004878:	557d                	li	a0,-1
    8000487a:	bfcd                	j	8000486c <pipealloc+0xb8>

000000008000487c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000487c:	1101                	addi	sp,sp,-32
    8000487e:	ec06                	sd	ra,24(sp)
    80004880:	e822                	sd	s0,16(sp)
    80004882:	e426                	sd	s1,8(sp)
    80004884:	e04a                	sd	s2,0(sp)
    80004886:	1000                	addi	s0,sp,32
    80004888:	84aa                	mv	s1,a0
    8000488a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000488c:	b68fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    80004890:	02090763          	beqz	s2,800048be <pipeclose+0x42>
    pi->writeopen = 0;
    80004894:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004898:	21848513          	addi	a0,s1,536
    8000489c:	a1bfd0ef          	jal	800022b6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048a0:	2204b783          	ld	a5,544(s1)
    800048a4:	e785                	bnez	a5,800048cc <pipeclose+0x50>
    release(&pi->lock);
    800048a6:	8526                	mv	a0,s1
    800048a8:	be4fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    800048ac:	8526                	mv	a0,s1
    800048ae:	994fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    800048b2:	60e2                	ld	ra,24(sp)
    800048b4:	6442                	ld	s0,16(sp)
    800048b6:	64a2                	ld	s1,8(sp)
    800048b8:	6902                	ld	s2,0(sp)
    800048ba:	6105                	addi	sp,sp,32
    800048bc:	8082                	ret
    pi->readopen = 0;
    800048be:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800048c2:	21c48513          	addi	a0,s1,540
    800048c6:	9f1fd0ef          	jal	800022b6 <wakeup>
    800048ca:	bfd9                	j	800048a0 <pipeclose+0x24>
    release(&pi->lock);
    800048cc:	8526                	mv	a0,s1
    800048ce:	bbefc0ef          	jal	80000c8c <release>
}
    800048d2:	b7c5                	j	800048b2 <pipeclose+0x36>

00000000800048d4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800048d4:	711d                	addi	sp,sp,-96
    800048d6:	ec86                	sd	ra,88(sp)
    800048d8:	e8a2                	sd	s0,80(sp)
    800048da:	e4a6                	sd	s1,72(sp)
    800048dc:	e0ca                	sd	s2,64(sp)
    800048de:	fc4e                	sd	s3,56(sp)
    800048e0:	f852                	sd	s4,48(sp)
    800048e2:	f456                	sd	s5,40(sp)
    800048e4:	1080                	addi	s0,sp,96
    800048e6:	84aa                	mv	s1,a0
    800048e8:	8aae                	mv	s5,a1
    800048ea:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800048ec:	f3ffc0ef          	jal	8000182a <myproc>
    800048f0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800048f2:	8526                	mv	a0,s1
    800048f4:	b00fc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    800048f8:	0b405a63          	blez	s4,800049ac <pipewrite+0xd8>
    800048fc:	f05a                	sd	s6,32(sp)
    800048fe:	ec5e                	sd	s7,24(sp)
    80004900:	e862                	sd	s8,16(sp)
  int i = 0;
    80004902:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004904:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004906:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000490a:	21c48b93          	addi	s7,s1,540
    8000490e:	a81d                	j	80004944 <pipewrite+0x70>
      release(&pi->lock);
    80004910:	8526                	mv	a0,s1
    80004912:	b7afc0ef          	jal	80000c8c <release>
      return -1;
    80004916:	597d                	li	s2,-1
    80004918:	7b02                	ld	s6,32(sp)
    8000491a:	6be2                	ld	s7,24(sp)
    8000491c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000491e:	854a                	mv	a0,s2
    80004920:	60e6                	ld	ra,88(sp)
    80004922:	6446                	ld	s0,80(sp)
    80004924:	64a6                	ld	s1,72(sp)
    80004926:	6906                	ld	s2,64(sp)
    80004928:	79e2                	ld	s3,56(sp)
    8000492a:	7a42                	ld	s4,48(sp)
    8000492c:	7aa2                	ld	s5,40(sp)
    8000492e:	6125                	addi	sp,sp,96
    80004930:	8082                	ret
      wakeup(&pi->nread);
    80004932:	8562                	mv	a0,s8
    80004934:	983fd0ef          	jal	800022b6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004938:	85a6                	mv	a1,s1
    8000493a:	855e                	mv	a0,s7
    8000493c:	a8cfd0ef          	jal	80001bc8 <sleep>
  while(i < n){
    80004940:	05495b63          	bge	s2,s4,80004996 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004944:	2204a783          	lw	a5,544(s1)
    80004948:	d7e1                	beqz	a5,80004910 <pipewrite+0x3c>
    8000494a:	854e                	mv	a0,s3
    8000494c:	aecfd0ef          	jal	80001c38 <killed>
    80004950:	f161                	bnez	a0,80004910 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004952:	2184a783          	lw	a5,536(s1)
    80004956:	21c4a703          	lw	a4,540(s1)
    8000495a:	2007879b          	addiw	a5,a5,512
    8000495e:	fcf70ae3          	beq	a4,a5,80004932 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004962:	4685                	li	a3,1
    80004964:	01590633          	add	a2,s2,s5
    80004968:	faf40593          	addi	a1,s0,-81
    8000496c:	0509b503          	ld	a0,80(s3)
    80004970:	cb9fc0ef          	jal	80001628 <copyin>
    80004974:	03650e63          	beq	a0,s6,800049b0 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004978:	21c4a783          	lw	a5,540(s1)
    8000497c:	0017871b          	addiw	a4,a5,1
    80004980:	20e4ae23          	sw	a4,540(s1)
    80004984:	1ff7f793          	andi	a5,a5,511
    80004988:	97a6                	add	a5,a5,s1
    8000498a:	faf44703          	lbu	a4,-81(s0)
    8000498e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004992:	2905                	addiw	s2,s2,1
    80004994:	b775                	j	80004940 <pipewrite+0x6c>
    80004996:	7b02                	ld	s6,32(sp)
    80004998:	6be2                	ld	s7,24(sp)
    8000499a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000499c:	21848513          	addi	a0,s1,536
    800049a0:	917fd0ef          	jal	800022b6 <wakeup>
  release(&pi->lock);
    800049a4:	8526                	mv	a0,s1
    800049a6:	ae6fc0ef          	jal	80000c8c <release>
  return i;
    800049aa:	bf95                	j	8000491e <pipewrite+0x4a>
  int i = 0;
    800049ac:	4901                	li	s2,0
    800049ae:	b7fd                	j	8000499c <pipewrite+0xc8>
    800049b0:	7b02                	ld	s6,32(sp)
    800049b2:	6be2                	ld	s7,24(sp)
    800049b4:	6c42                	ld	s8,16(sp)
    800049b6:	b7dd                	j	8000499c <pipewrite+0xc8>

00000000800049b8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800049b8:	715d                	addi	sp,sp,-80
    800049ba:	e486                	sd	ra,72(sp)
    800049bc:	e0a2                	sd	s0,64(sp)
    800049be:	fc26                	sd	s1,56(sp)
    800049c0:	f84a                	sd	s2,48(sp)
    800049c2:	f44e                	sd	s3,40(sp)
    800049c4:	f052                	sd	s4,32(sp)
    800049c6:	ec56                	sd	s5,24(sp)
    800049c8:	0880                	addi	s0,sp,80
    800049ca:	84aa                	mv	s1,a0
    800049cc:	892e                	mv	s2,a1
    800049ce:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800049d0:	e5bfc0ef          	jal	8000182a <myproc>
    800049d4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800049d6:	8526                	mv	a0,s1
    800049d8:	a1cfc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049dc:	2184a703          	lw	a4,536(s1)
    800049e0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800049e4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049e8:	02f71563          	bne	a4,a5,80004a12 <piperead+0x5a>
    800049ec:	2244a783          	lw	a5,548(s1)
    800049f0:	cb85                	beqz	a5,80004a20 <piperead+0x68>
    if(killed(pr)){
    800049f2:	8552                	mv	a0,s4
    800049f4:	a44fd0ef          	jal	80001c38 <killed>
    800049f8:	ed19                	bnez	a0,80004a16 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800049fa:	85a6                	mv	a1,s1
    800049fc:	854e                	mv	a0,s3
    800049fe:	9cafd0ef          	jal	80001bc8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a02:	2184a703          	lw	a4,536(s1)
    80004a06:	21c4a783          	lw	a5,540(s1)
    80004a0a:	fef701e3          	beq	a4,a5,800049ec <piperead+0x34>
    80004a0e:	e85a                	sd	s6,16(sp)
    80004a10:	a809                	j	80004a22 <piperead+0x6a>
    80004a12:	e85a                	sd	s6,16(sp)
    80004a14:	a039                	j	80004a22 <piperead+0x6a>
      release(&pi->lock);
    80004a16:	8526                	mv	a0,s1
    80004a18:	a74fc0ef          	jal	80000c8c <release>
      return -1;
    80004a1c:	59fd                	li	s3,-1
    80004a1e:	a8b1                	j	80004a7a <piperead+0xc2>
    80004a20:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a22:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a24:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a26:	05505263          	blez	s5,80004a6a <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004a2a:	2184a783          	lw	a5,536(s1)
    80004a2e:	21c4a703          	lw	a4,540(s1)
    80004a32:	02f70c63          	beq	a4,a5,80004a6a <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004a36:	0017871b          	addiw	a4,a5,1
    80004a3a:	20e4ac23          	sw	a4,536(s1)
    80004a3e:	1ff7f793          	andi	a5,a5,511
    80004a42:	97a6                	add	a5,a5,s1
    80004a44:	0187c783          	lbu	a5,24(a5)
    80004a48:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a4c:	4685                	li	a3,1
    80004a4e:	fbf40613          	addi	a2,s0,-65
    80004a52:	85ca                	mv	a1,s2
    80004a54:	050a3503          	ld	a0,80(s4)
    80004a58:	afbfc0ef          	jal	80001552 <copyout>
    80004a5c:	01650763          	beq	a0,s6,80004a6a <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a60:	2985                	addiw	s3,s3,1
    80004a62:	0905                	addi	s2,s2,1
    80004a64:	fd3a93e3          	bne	s5,s3,80004a2a <piperead+0x72>
    80004a68:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004a6a:	21c48513          	addi	a0,s1,540
    80004a6e:	849fd0ef          	jal	800022b6 <wakeup>
  release(&pi->lock);
    80004a72:	8526                	mv	a0,s1
    80004a74:	a18fc0ef          	jal	80000c8c <release>
    80004a78:	6b42                	ld	s6,16(sp)
  return i;
}
    80004a7a:	854e                	mv	a0,s3
    80004a7c:	60a6                	ld	ra,72(sp)
    80004a7e:	6406                	ld	s0,64(sp)
    80004a80:	74e2                	ld	s1,56(sp)
    80004a82:	7942                	ld	s2,48(sp)
    80004a84:	79a2                	ld	s3,40(sp)
    80004a86:	7a02                	ld	s4,32(sp)
    80004a88:	6ae2                	ld	s5,24(sp)
    80004a8a:	6161                	addi	sp,sp,80
    80004a8c:	8082                	ret

0000000080004a8e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004a8e:	1141                	addi	sp,sp,-16
    80004a90:	e422                	sd	s0,8(sp)
    80004a92:	0800                	addi	s0,sp,16
    80004a94:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004a96:	8905                	andi	a0,a0,1
    80004a98:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004a9a:	8b89                	andi	a5,a5,2
    80004a9c:	c399                	beqz	a5,80004aa2 <flags2perm+0x14>
      perm |= PTE_W;
    80004a9e:	00456513          	ori	a0,a0,4
    return perm;
}
    80004aa2:	6422                	ld	s0,8(sp)
    80004aa4:	0141                	addi	sp,sp,16
    80004aa6:	8082                	ret

0000000080004aa8 <exec>:

int
exec(char *path, char **argv)
{
    80004aa8:	df010113          	addi	sp,sp,-528
    80004aac:	20113423          	sd	ra,520(sp)
    80004ab0:	20813023          	sd	s0,512(sp)
    80004ab4:	ffa6                	sd	s1,504(sp)
    80004ab6:	fbca                	sd	s2,496(sp)
    80004ab8:	0c00                	addi	s0,sp,528
    80004aba:	892a                	mv	s2,a0
    80004abc:	dea43c23          	sd	a0,-520(s0)
    80004ac0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004ac4:	d67fc0ef          	jal	8000182a <myproc>
    80004ac8:	84aa                	mv	s1,a0

  begin_op();
    80004aca:	dc6ff0ef          	jal	80004090 <begin_op>

  if((ip = namei(path)) == 0){
    80004ace:	854a                	mv	a0,s2
    80004ad0:	c04ff0ef          	jal	80003ed4 <namei>
    80004ad4:	c931                	beqz	a0,80004b28 <exec+0x80>
    80004ad6:	f3d2                	sd	s4,480(sp)
    80004ad8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ada:	d21fe0ef          	jal	800037fa <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004ade:	04000713          	li	a4,64
    80004ae2:	4681                	li	a3,0
    80004ae4:	e5040613          	addi	a2,s0,-432
    80004ae8:	4581                	li	a1,0
    80004aea:	8552                	mv	a0,s4
    80004aec:	f63fe0ef          	jal	80003a4e <readi>
    80004af0:	04000793          	li	a5,64
    80004af4:	00f51a63          	bne	a0,a5,80004b08 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004af8:	e5042703          	lw	a4,-432(s0)
    80004afc:	464c47b7          	lui	a5,0x464c4
    80004b00:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b04:	02f70663          	beq	a4,a5,80004b30 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004b08:	8552                	mv	a0,s4
    80004b0a:	efbfe0ef          	jal	80003a04 <iunlockput>
    end_op();
    80004b0e:	decff0ef          	jal	800040fa <end_op>
  }
  return -1;
    80004b12:	557d                	li	a0,-1
    80004b14:	7a1e                	ld	s4,480(sp)
}
    80004b16:	20813083          	ld	ra,520(sp)
    80004b1a:	20013403          	ld	s0,512(sp)
    80004b1e:	74fe                	ld	s1,504(sp)
    80004b20:	795e                	ld	s2,496(sp)
    80004b22:	21010113          	addi	sp,sp,528
    80004b26:	8082                	ret
    end_op();
    80004b28:	dd2ff0ef          	jal	800040fa <end_op>
    return -1;
    80004b2c:	557d                	li	a0,-1
    80004b2e:	b7e5                	j	80004b16 <exec+0x6e>
    80004b30:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004b32:	8526                	mv	a0,s1
    80004b34:	d9ffc0ef          	jal	800018d2 <proc_pagetable>
    80004b38:	8b2a                	mv	s6,a0
    80004b3a:	2c050b63          	beqz	a0,80004e10 <exec+0x368>
    80004b3e:	f7ce                	sd	s3,488(sp)
    80004b40:	efd6                	sd	s5,472(sp)
    80004b42:	e7de                	sd	s7,456(sp)
    80004b44:	e3e2                	sd	s8,448(sp)
    80004b46:	ff66                	sd	s9,440(sp)
    80004b48:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b4a:	e7042d03          	lw	s10,-400(s0)
    80004b4e:	e8845783          	lhu	a5,-376(s0)
    80004b52:	12078963          	beqz	a5,80004c84 <exec+0x1dc>
    80004b56:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b58:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b5a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004b5c:	6c85                	lui	s9,0x1
    80004b5e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004b62:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004b66:	6a85                	lui	s5,0x1
    80004b68:	a085                	j	80004bc8 <exec+0x120>
      panic("loadseg: address should exist");
    80004b6a:	00003517          	auipc	a0,0x3
    80004b6e:	af650513          	addi	a0,a0,-1290 # 80007660 <etext+0x660>
    80004b72:	c23fb0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004b76:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004b78:	8726                	mv	a4,s1
    80004b7a:	012c06bb          	addw	a3,s8,s2
    80004b7e:	4581                	li	a1,0
    80004b80:	8552                	mv	a0,s4
    80004b82:	ecdfe0ef          	jal	80003a4e <readi>
    80004b86:	2501                	sext.w	a0,a0
    80004b88:	24a49a63          	bne	s1,a0,80004ddc <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004b8c:	012a893b          	addw	s2,s5,s2
    80004b90:	03397363          	bgeu	s2,s3,80004bb6 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004b94:	02091593          	slli	a1,s2,0x20
    80004b98:	9181                	srli	a1,a1,0x20
    80004b9a:	95de                	add	a1,a1,s7
    80004b9c:	855a                	mv	a0,s6
    80004b9e:	c38fc0ef          	jal	80000fd6 <walkaddr>
    80004ba2:	862a                	mv	a2,a0
    if(pa == 0)
    80004ba4:	d179                	beqz	a0,80004b6a <exec+0xc2>
    if(sz - i < PGSIZE)
    80004ba6:	412984bb          	subw	s1,s3,s2
    80004baa:	0004879b          	sext.w	a5,s1
    80004bae:	fcfcf4e3          	bgeu	s9,a5,80004b76 <exec+0xce>
    80004bb2:	84d6                	mv	s1,s5
    80004bb4:	b7c9                	j	80004b76 <exec+0xce>
    sz = sz1;
    80004bb6:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bba:	2d85                	addiw	s11,s11,1
    80004bbc:	038d0d1b          	addiw	s10,s10,56
    80004bc0:	e8845783          	lhu	a5,-376(s0)
    80004bc4:	08fdd063          	bge	s11,a5,80004c44 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004bc8:	2d01                	sext.w	s10,s10
    80004bca:	03800713          	li	a4,56
    80004bce:	86ea                	mv	a3,s10
    80004bd0:	e1840613          	addi	a2,s0,-488
    80004bd4:	4581                	li	a1,0
    80004bd6:	8552                	mv	a0,s4
    80004bd8:	e77fe0ef          	jal	80003a4e <readi>
    80004bdc:	03800793          	li	a5,56
    80004be0:	1cf51663          	bne	a0,a5,80004dac <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004be4:	e1842783          	lw	a5,-488(s0)
    80004be8:	4705                	li	a4,1
    80004bea:	fce798e3          	bne	a5,a4,80004bba <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004bee:	e4043483          	ld	s1,-448(s0)
    80004bf2:	e3843783          	ld	a5,-456(s0)
    80004bf6:	1af4ef63          	bltu	s1,a5,80004db4 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004bfa:	e2843783          	ld	a5,-472(s0)
    80004bfe:	94be                	add	s1,s1,a5
    80004c00:	1af4ee63          	bltu	s1,a5,80004dbc <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004c04:	df043703          	ld	a4,-528(s0)
    80004c08:	8ff9                	and	a5,a5,a4
    80004c0a:	1a079d63          	bnez	a5,80004dc4 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004c0e:	e1c42503          	lw	a0,-484(s0)
    80004c12:	e7dff0ef          	jal	80004a8e <flags2perm>
    80004c16:	86aa                	mv	a3,a0
    80004c18:	8626                	mv	a2,s1
    80004c1a:	85ca                	mv	a1,s2
    80004c1c:	855a                	mv	a0,s6
    80004c1e:	f20fc0ef          	jal	8000133e <uvmalloc>
    80004c22:	e0a43423          	sd	a0,-504(s0)
    80004c26:	1a050363          	beqz	a0,80004dcc <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004c2a:	e2843b83          	ld	s7,-472(s0)
    80004c2e:	e2042c03          	lw	s8,-480(s0)
    80004c32:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004c36:	00098463          	beqz	s3,80004c3e <exec+0x196>
    80004c3a:	4901                	li	s2,0
    80004c3c:	bfa1                	j	80004b94 <exec+0xec>
    sz = sz1;
    80004c3e:	e0843903          	ld	s2,-504(s0)
    80004c42:	bfa5                	j	80004bba <exec+0x112>
    80004c44:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004c46:	8552                	mv	a0,s4
    80004c48:	dbdfe0ef          	jal	80003a04 <iunlockput>
  end_op();
    80004c4c:	caeff0ef          	jal	800040fa <end_op>
  p = myproc();
    80004c50:	bdbfc0ef          	jal	8000182a <myproc>
    80004c54:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004c56:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004c5a:	6985                	lui	s3,0x1
    80004c5c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004c5e:	99ca                	add	s3,s3,s2
    80004c60:	77fd                	lui	a5,0xfffff
    80004c62:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004c66:	4691                	li	a3,4
    80004c68:	6609                	lui	a2,0x2
    80004c6a:	964e                	add	a2,a2,s3
    80004c6c:	85ce                	mv	a1,s3
    80004c6e:	855a                	mv	a0,s6
    80004c70:	ecefc0ef          	jal	8000133e <uvmalloc>
    80004c74:	892a                	mv	s2,a0
    80004c76:	e0a43423          	sd	a0,-504(s0)
    80004c7a:	e519                	bnez	a0,80004c88 <exec+0x1e0>
  if(pagetable)
    80004c7c:	e1343423          	sd	s3,-504(s0)
    80004c80:	4a01                	li	s4,0
    80004c82:	aab1                	j	80004dde <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004c84:	4901                	li	s2,0
    80004c86:	b7c1                	j	80004c46 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004c88:	75f9                	lui	a1,0xffffe
    80004c8a:	95aa                	add	a1,a1,a0
    80004c8c:	855a                	mv	a0,s6
    80004c8e:	89bfc0ef          	jal	80001528 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004c92:	7bfd                	lui	s7,0xfffff
    80004c94:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004c96:	e0043783          	ld	a5,-512(s0)
    80004c9a:	6388                	ld	a0,0(a5)
    80004c9c:	cd39                	beqz	a0,80004cfa <exec+0x252>
    80004c9e:	e9040993          	addi	s3,s0,-368
    80004ca2:	f9040c13          	addi	s8,s0,-112
    80004ca6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004ca8:	990fc0ef          	jal	80000e38 <strlen>
    80004cac:	0015079b          	addiw	a5,a0,1
    80004cb0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004cb4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004cb8:	11796e63          	bltu	s2,s7,80004dd4 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004cbc:	e0043d03          	ld	s10,-512(s0)
    80004cc0:	000d3a03          	ld	s4,0(s10)
    80004cc4:	8552                	mv	a0,s4
    80004cc6:	972fc0ef          	jal	80000e38 <strlen>
    80004cca:	0015069b          	addiw	a3,a0,1
    80004cce:	8652                	mv	a2,s4
    80004cd0:	85ca                	mv	a1,s2
    80004cd2:	855a                	mv	a0,s6
    80004cd4:	87ffc0ef          	jal	80001552 <copyout>
    80004cd8:	10054063          	bltz	a0,80004dd8 <exec+0x330>
    ustack[argc] = sp;
    80004cdc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004ce0:	0485                	addi	s1,s1,1
    80004ce2:	008d0793          	addi	a5,s10,8
    80004ce6:	e0f43023          	sd	a5,-512(s0)
    80004cea:	008d3503          	ld	a0,8(s10)
    80004cee:	c909                	beqz	a0,80004d00 <exec+0x258>
    if(argc >= MAXARG)
    80004cf0:	09a1                	addi	s3,s3,8
    80004cf2:	fb899be3          	bne	s3,s8,80004ca8 <exec+0x200>
  ip = 0;
    80004cf6:	4a01                	li	s4,0
    80004cf8:	a0dd                	j	80004dde <exec+0x336>
  sp = sz;
    80004cfa:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004cfe:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d00:	00349793          	slli	a5,s1,0x3
    80004d04:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb048>
    80004d08:	97a2                	add	a5,a5,s0
    80004d0a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004d0e:	00148693          	addi	a3,s1,1
    80004d12:	068e                	slli	a3,a3,0x3
    80004d14:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004d18:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004d1c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004d20:	f5796ee3          	bltu	s2,s7,80004c7c <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004d24:	e9040613          	addi	a2,s0,-368
    80004d28:	85ca                	mv	a1,s2
    80004d2a:	855a                	mv	a0,s6
    80004d2c:	827fc0ef          	jal	80001552 <copyout>
    80004d30:	0e054263          	bltz	a0,80004e14 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004d34:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004d38:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004d3c:	df843783          	ld	a5,-520(s0)
    80004d40:	0007c703          	lbu	a4,0(a5)
    80004d44:	cf11                	beqz	a4,80004d60 <exec+0x2b8>
    80004d46:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004d48:	02f00693          	li	a3,47
    80004d4c:	a039                	j	80004d5a <exec+0x2b2>
      last = s+1;
    80004d4e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004d52:	0785                	addi	a5,a5,1
    80004d54:	fff7c703          	lbu	a4,-1(a5)
    80004d58:	c701                	beqz	a4,80004d60 <exec+0x2b8>
    if(*s == '/')
    80004d5a:	fed71ce3          	bne	a4,a3,80004d52 <exec+0x2aa>
    80004d5e:	bfc5                	j	80004d4e <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004d60:	4641                	li	a2,16
    80004d62:	df843583          	ld	a1,-520(s0)
    80004d66:	158a8513          	addi	a0,s5,344
    80004d6a:	89cfc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004d6e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004d72:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004d76:	e0843783          	ld	a5,-504(s0)
    80004d7a:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004d7e:	058ab783          	ld	a5,88(s5)
    80004d82:	e6843703          	ld	a4,-408(s0)
    80004d86:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004d88:	058ab783          	ld	a5,88(s5)
    80004d8c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004d90:	85e6                	mv	a1,s9
    80004d92:	bc5fc0ef          	jal	80001956 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004d96:	0004851b          	sext.w	a0,s1
    80004d9a:	79be                	ld	s3,488(sp)
    80004d9c:	7a1e                	ld	s4,480(sp)
    80004d9e:	6afe                	ld	s5,472(sp)
    80004da0:	6b5e                	ld	s6,464(sp)
    80004da2:	6bbe                	ld	s7,456(sp)
    80004da4:	6c1e                	ld	s8,448(sp)
    80004da6:	7cfa                	ld	s9,440(sp)
    80004da8:	7d5a                	ld	s10,432(sp)
    80004daa:	b3b5                	j	80004b16 <exec+0x6e>
    80004dac:	e1243423          	sd	s2,-504(s0)
    80004db0:	7dba                	ld	s11,424(sp)
    80004db2:	a035                	j	80004dde <exec+0x336>
    80004db4:	e1243423          	sd	s2,-504(s0)
    80004db8:	7dba                	ld	s11,424(sp)
    80004dba:	a015                	j	80004dde <exec+0x336>
    80004dbc:	e1243423          	sd	s2,-504(s0)
    80004dc0:	7dba                	ld	s11,424(sp)
    80004dc2:	a831                	j	80004dde <exec+0x336>
    80004dc4:	e1243423          	sd	s2,-504(s0)
    80004dc8:	7dba                	ld	s11,424(sp)
    80004dca:	a811                	j	80004dde <exec+0x336>
    80004dcc:	e1243423          	sd	s2,-504(s0)
    80004dd0:	7dba                	ld	s11,424(sp)
    80004dd2:	a031                	j	80004dde <exec+0x336>
  ip = 0;
    80004dd4:	4a01                	li	s4,0
    80004dd6:	a021                	j	80004dde <exec+0x336>
    80004dd8:	4a01                	li	s4,0
  if(pagetable)
    80004dda:	a011                	j	80004dde <exec+0x336>
    80004ddc:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004dde:	e0843583          	ld	a1,-504(s0)
    80004de2:	855a                	mv	a0,s6
    80004de4:	b73fc0ef          	jal	80001956 <proc_freepagetable>
  return -1;
    80004de8:	557d                	li	a0,-1
  if(ip){
    80004dea:	000a1b63          	bnez	s4,80004e00 <exec+0x358>
    80004dee:	79be                	ld	s3,488(sp)
    80004df0:	7a1e                	ld	s4,480(sp)
    80004df2:	6afe                	ld	s5,472(sp)
    80004df4:	6b5e                	ld	s6,464(sp)
    80004df6:	6bbe                	ld	s7,456(sp)
    80004df8:	6c1e                	ld	s8,448(sp)
    80004dfa:	7cfa                	ld	s9,440(sp)
    80004dfc:	7d5a                	ld	s10,432(sp)
    80004dfe:	bb21                	j	80004b16 <exec+0x6e>
    80004e00:	79be                	ld	s3,488(sp)
    80004e02:	6afe                	ld	s5,472(sp)
    80004e04:	6b5e                	ld	s6,464(sp)
    80004e06:	6bbe                	ld	s7,456(sp)
    80004e08:	6c1e                	ld	s8,448(sp)
    80004e0a:	7cfa                	ld	s9,440(sp)
    80004e0c:	7d5a                	ld	s10,432(sp)
    80004e0e:	b9ed                	j	80004b08 <exec+0x60>
    80004e10:	6b5e                	ld	s6,464(sp)
    80004e12:	b9dd                	j	80004b08 <exec+0x60>
  sz = sz1;
    80004e14:	e0843983          	ld	s3,-504(s0)
    80004e18:	b595                	j	80004c7c <exec+0x1d4>

0000000080004e1a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e1a:	7179                	addi	sp,sp,-48
    80004e1c:	f406                	sd	ra,40(sp)
    80004e1e:	f022                	sd	s0,32(sp)
    80004e20:	ec26                	sd	s1,24(sp)
    80004e22:	e84a                	sd	s2,16(sp)
    80004e24:	1800                	addi	s0,sp,48
    80004e26:	892e                	mv	s2,a1
    80004e28:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004e2a:	fdc40593          	addi	a1,s0,-36
    80004e2e:	f0bfd0ef          	jal	80002d38 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004e32:	fdc42703          	lw	a4,-36(s0)
    80004e36:	47bd                	li	a5,15
    80004e38:	02e7e963          	bltu	a5,a4,80004e6a <argfd+0x50>
    80004e3c:	9effc0ef          	jal	8000182a <myproc>
    80004e40:	fdc42703          	lw	a4,-36(s0)
    80004e44:	01a70793          	addi	a5,a4,26
    80004e48:	078e                	slli	a5,a5,0x3
    80004e4a:	953e                	add	a0,a0,a5
    80004e4c:	611c                	ld	a5,0(a0)
    80004e4e:	c385                	beqz	a5,80004e6e <argfd+0x54>
    return -1;
  if(pfd)
    80004e50:	00090463          	beqz	s2,80004e58 <argfd+0x3e>
    *pfd = fd;
    80004e54:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004e58:	4501                	li	a0,0
  if(pf)
    80004e5a:	c091                	beqz	s1,80004e5e <argfd+0x44>
    *pf = f;
    80004e5c:	e09c                	sd	a5,0(s1)
}
    80004e5e:	70a2                	ld	ra,40(sp)
    80004e60:	7402                	ld	s0,32(sp)
    80004e62:	64e2                	ld	s1,24(sp)
    80004e64:	6942                	ld	s2,16(sp)
    80004e66:	6145                	addi	sp,sp,48
    80004e68:	8082                	ret
    return -1;
    80004e6a:	557d                	li	a0,-1
    80004e6c:	bfcd                	j	80004e5e <argfd+0x44>
    80004e6e:	557d                	li	a0,-1
    80004e70:	b7fd                	j	80004e5e <argfd+0x44>

0000000080004e72 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004e72:	1101                	addi	sp,sp,-32
    80004e74:	ec06                	sd	ra,24(sp)
    80004e76:	e822                	sd	s0,16(sp)
    80004e78:	e426                	sd	s1,8(sp)
    80004e7a:	1000                	addi	s0,sp,32
    80004e7c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004e7e:	9adfc0ef          	jal	8000182a <myproc>
    80004e82:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004e84:	0d050793          	addi	a5,a0,208
    80004e88:	4501                	li	a0,0
    80004e8a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004e8c:	6398                	ld	a4,0(a5)
    80004e8e:	cb19                	beqz	a4,80004ea4 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004e90:	2505                	addiw	a0,a0,1
    80004e92:	07a1                	addi	a5,a5,8
    80004e94:	fed51ce3          	bne	a0,a3,80004e8c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004e98:	557d                	li	a0,-1
}
    80004e9a:	60e2                	ld	ra,24(sp)
    80004e9c:	6442                	ld	s0,16(sp)
    80004e9e:	64a2                	ld	s1,8(sp)
    80004ea0:	6105                	addi	sp,sp,32
    80004ea2:	8082                	ret
      p->ofile[fd] = f;
    80004ea4:	01a50793          	addi	a5,a0,26
    80004ea8:	078e                	slli	a5,a5,0x3
    80004eaa:	963e                	add	a2,a2,a5
    80004eac:	e204                	sd	s1,0(a2)
      return fd;
    80004eae:	b7f5                	j	80004e9a <fdalloc+0x28>

0000000080004eb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004eb0:	715d                	addi	sp,sp,-80
    80004eb2:	e486                	sd	ra,72(sp)
    80004eb4:	e0a2                	sd	s0,64(sp)
    80004eb6:	fc26                	sd	s1,56(sp)
    80004eb8:	f84a                	sd	s2,48(sp)
    80004eba:	f44e                	sd	s3,40(sp)
    80004ebc:	ec56                	sd	s5,24(sp)
    80004ebe:	e85a                	sd	s6,16(sp)
    80004ec0:	0880                	addi	s0,sp,80
    80004ec2:	8b2e                	mv	s6,a1
    80004ec4:	89b2                	mv	s3,a2
    80004ec6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004ec8:	fb040593          	addi	a1,s0,-80
    80004ecc:	822ff0ef          	jal	80003eee <nameiparent>
    80004ed0:	84aa                	mv	s1,a0
    80004ed2:	10050a63          	beqz	a0,80004fe6 <create+0x136>
    return 0;

  ilock(dp);
    80004ed6:	925fe0ef          	jal	800037fa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004eda:	4601                	li	a2,0
    80004edc:	fb040593          	addi	a1,s0,-80
    80004ee0:	8526                	mv	a0,s1
    80004ee2:	d8dfe0ef          	jal	80003c6e <dirlookup>
    80004ee6:	8aaa                	mv	s5,a0
    80004ee8:	c129                	beqz	a0,80004f2a <create+0x7a>
    iunlockput(dp);
    80004eea:	8526                	mv	a0,s1
    80004eec:	b19fe0ef          	jal	80003a04 <iunlockput>
    ilock(ip);
    80004ef0:	8556                	mv	a0,s5
    80004ef2:	909fe0ef          	jal	800037fa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004ef6:	4789                	li	a5,2
    80004ef8:	02fb1463          	bne	s6,a5,80004f20 <create+0x70>
    80004efc:	044ad783          	lhu	a5,68(s5)
    80004f00:	37f9                	addiw	a5,a5,-2
    80004f02:	17c2                	slli	a5,a5,0x30
    80004f04:	93c1                	srli	a5,a5,0x30
    80004f06:	4705                	li	a4,1
    80004f08:	00f76c63          	bltu	a4,a5,80004f20 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004f0c:	8556                	mv	a0,s5
    80004f0e:	60a6                	ld	ra,72(sp)
    80004f10:	6406                	ld	s0,64(sp)
    80004f12:	74e2                	ld	s1,56(sp)
    80004f14:	7942                	ld	s2,48(sp)
    80004f16:	79a2                	ld	s3,40(sp)
    80004f18:	6ae2                	ld	s5,24(sp)
    80004f1a:	6b42                	ld	s6,16(sp)
    80004f1c:	6161                	addi	sp,sp,80
    80004f1e:	8082                	ret
    iunlockput(ip);
    80004f20:	8556                	mv	a0,s5
    80004f22:	ae3fe0ef          	jal	80003a04 <iunlockput>
    return 0;
    80004f26:	4a81                	li	s5,0
    80004f28:	b7d5                	j	80004f0c <create+0x5c>
    80004f2a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004f2c:	85da                	mv	a1,s6
    80004f2e:	4088                	lw	a0,0(s1)
    80004f30:	f5afe0ef          	jal	8000368a <ialloc>
    80004f34:	8a2a                	mv	s4,a0
    80004f36:	cd15                	beqz	a0,80004f72 <create+0xc2>
  ilock(ip);
    80004f38:	8c3fe0ef          	jal	800037fa <ilock>
  ip->major = major;
    80004f3c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004f40:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004f44:	4905                	li	s2,1
    80004f46:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004f4a:	8552                	mv	a0,s4
    80004f4c:	ffafe0ef          	jal	80003746 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004f50:	032b0763          	beq	s6,s2,80004f7e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004f54:	004a2603          	lw	a2,4(s4)
    80004f58:	fb040593          	addi	a1,s0,-80
    80004f5c:	8526                	mv	a0,s1
    80004f5e:	eddfe0ef          	jal	80003e3a <dirlink>
    80004f62:	06054563          	bltz	a0,80004fcc <create+0x11c>
  iunlockput(dp);
    80004f66:	8526                	mv	a0,s1
    80004f68:	a9dfe0ef          	jal	80003a04 <iunlockput>
  return ip;
    80004f6c:	8ad2                	mv	s5,s4
    80004f6e:	7a02                	ld	s4,32(sp)
    80004f70:	bf71                	j	80004f0c <create+0x5c>
    iunlockput(dp);
    80004f72:	8526                	mv	a0,s1
    80004f74:	a91fe0ef          	jal	80003a04 <iunlockput>
    return 0;
    80004f78:	8ad2                	mv	s5,s4
    80004f7a:	7a02                	ld	s4,32(sp)
    80004f7c:	bf41                	j	80004f0c <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004f7e:	004a2603          	lw	a2,4(s4)
    80004f82:	00002597          	auipc	a1,0x2
    80004f86:	6fe58593          	addi	a1,a1,1790 # 80007680 <etext+0x680>
    80004f8a:	8552                	mv	a0,s4
    80004f8c:	eaffe0ef          	jal	80003e3a <dirlink>
    80004f90:	02054e63          	bltz	a0,80004fcc <create+0x11c>
    80004f94:	40d0                	lw	a2,4(s1)
    80004f96:	00002597          	auipc	a1,0x2
    80004f9a:	6f258593          	addi	a1,a1,1778 # 80007688 <etext+0x688>
    80004f9e:	8552                	mv	a0,s4
    80004fa0:	e9bfe0ef          	jal	80003e3a <dirlink>
    80004fa4:	02054463          	bltz	a0,80004fcc <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004fa8:	004a2603          	lw	a2,4(s4)
    80004fac:	fb040593          	addi	a1,s0,-80
    80004fb0:	8526                	mv	a0,s1
    80004fb2:	e89fe0ef          	jal	80003e3a <dirlink>
    80004fb6:	00054b63          	bltz	a0,80004fcc <create+0x11c>
    dp->nlink++;  // for ".."
    80004fba:	04a4d783          	lhu	a5,74(s1)
    80004fbe:	2785                	addiw	a5,a5,1
    80004fc0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004fc4:	8526                	mv	a0,s1
    80004fc6:	f80fe0ef          	jal	80003746 <iupdate>
    80004fca:	bf71                	j	80004f66 <create+0xb6>
  ip->nlink = 0;
    80004fcc:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004fd0:	8552                	mv	a0,s4
    80004fd2:	f74fe0ef          	jal	80003746 <iupdate>
  iunlockput(ip);
    80004fd6:	8552                	mv	a0,s4
    80004fd8:	a2dfe0ef          	jal	80003a04 <iunlockput>
  iunlockput(dp);
    80004fdc:	8526                	mv	a0,s1
    80004fde:	a27fe0ef          	jal	80003a04 <iunlockput>
  return 0;
    80004fe2:	7a02                	ld	s4,32(sp)
    80004fe4:	b725                	j	80004f0c <create+0x5c>
    return 0;
    80004fe6:	8aaa                	mv	s5,a0
    80004fe8:	b715                	j	80004f0c <create+0x5c>

0000000080004fea <sys_dup>:
{
    80004fea:	7179                	addi	sp,sp,-48
    80004fec:	f406                	sd	ra,40(sp)
    80004fee:	f022                	sd	s0,32(sp)
    80004ff0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004ff2:	fd840613          	addi	a2,s0,-40
    80004ff6:	4581                	li	a1,0
    80004ff8:	4501                	li	a0,0
    80004ffa:	e21ff0ef          	jal	80004e1a <argfd>
    return -1;
    80004ffe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005000:	02054363          	bltz	a0,80005026 <sys_dup+0x3c>
    80005004:	ec26                	sd	s1,24(sp)
    80005006:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005008:	fd843903          	ld	s2,-40(s0)
    8000500c:	854a                	mv	a0,s2
    8000500e:	e65ff0ef          	jal	80004e72 <fdalloc>
    80005012:	84aa                	mv	s1,a0
    return -1;
    80005014:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005016:	00054d63          	bltz	a0,80005030 <sys_dup+0x46>
  filedup(f);
    8000501a:	854a                	mv	a0,s2
    8000501c:	c48ff0ef          	jal	80004464 <filedup>
  return fd;
    80005020:	87a6                	mv	a5,s1
    80005022:	64e2                	ld	s1,24(sp)
    80005024:	6942                	ld	s2,16(sp)
}
    80005026:	853e                	mv	a0,a5
    80005028:	70a2                	ld	ra,40(sp)
    8000502a:	7402                	ld	s0,32(sp)
    8000502c:	6145                	addi	sp,sp,48
    8000502e:	8082                	ret
    80005030:	64e2                	ld	s1,24(sp)
    80005032:	6942                	ld	s2,16(sp)
    80005034:	bfcd                	j	80005026 <sys_dup+0x3c>

0000000080005036 <sys_read>:
{
    80005036:	7179                	addi	sp,sp,-48
    80005038:	f406                	sd	ra,40(sp)
    8000503a:	f022                	sd	s0,32(sp)
    8000503c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000503e:	fd840593          	addi	a1,s0,-40
    80005042:	4505                	li	a0,1
    80005044:	d11fd0ef          	jal	80002d54 <argaddr>
  argint(2, &n);
    80005048:	fe440593          	addi	a1,s0,-28
    8000504c:	4509                	li	a0,2
    8000504e:	cebfd0ef          	jal	80002d38 <argint>
  if(argfd(0, 0, &f) < 0)
    80005052:	fe840613          	addi	a2,s0,-24
    80005056:	4581                	li	a1,0
    80005058:	4501                	li	a0,0
    8000505a:	dc1ff0ef          	jal	80004e1a <argfd>
    8000505e:	87aa                	mv	a5,a0
    return -1;
    80005060:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005062:	0007ca63          	bltz	a5,80005076 <sys_read+0x40>
  return fileread(f, p, n);
    80005066:	fe442603          	lw	a2,-28(s0)
    8000506a:	fd843583          	ld	a1,-40(s0)
    8000506e:	fe843503          	ld	a0,-24(s0)
    80005072:	d58ff0ef          	jal	800045ca <fileread>
}
    80005076:	70a2                	ld	ra,40(sp)
    80005078:	7402                	ld	s0,32(sp)
    8000507a:	6145                	addi	sp,sp,48
    8000507c:	8082                	ret

000000008000507e <sys_write>:
{
    8000507e:	7179                	addi	sp,sp,-48
    80005080:	f406                	sd	ra,40(sp)
    80005082:	f022                	sd	s0,32(sp)
    80005084:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005086:	fd840593          	addi	a1,s0,-40
    8000508a:	4505                	li	a0,1
    8000508c:	cc9fd0ef          	jal	80002d54 <argaddr>
  argint(2, &n);
    80005090:	fe440593          	addi	a1,s0,-28
    80005094:	4509                	li	a0,2
    80005096:	ca3fd0ef          	jal	80002d38 <argint>
  if(argfd(0, 0, &f) < 0)
    8000509a:	fe840613          	addi	a2,s0,-24
    8000509e:	4581                	li	a1,0
    800050a0:	4501                	li	a0,0
    800050a2:	d79ff0ef          	jal	80004e1a <argfd>
    800050a6:	87aa                	mv	a5,a0
    return -1;
    800050a8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800050aa:	0007ca63          	bltz	a5,800050be <sys_write+0x40>
  return filewrite(f, p, n);
    800050ae:	fe442603          	lw	a2,-28(s0)
    800050b2:	fd843583          	ld	a1,-40(s0)
    800050b6:	fe843503          	ld	a0,-24(s0)
    800050ba:	dceff0ef          	jal	80004688 <filewrite>
}
    800050be:	70a2                	ld	ra,40(sp)
    800050c0:	7402                	ld	s0,32(sp)
    800050c2:	6145                	addi	sp,sp,48
    800050c4:	8082                	ret

00000000800050c6 <sys_close>:
{
    800050c6:	1101                	addi	sp,sp,-32
    800050c8:	ec06                	sd	ra,24(sp)
    800050ca:	e822                	sd	s0,16(sp)
    800050cc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800050ce:	fe040613          	addi	a2,s0,-32
    800050d2:	fec40593          	addi	a1,s0,-20
    800050d6:	4501                	li	a0,0
    800050d8:	d43ff0ef          	jal	80004e1a <argfd>
    return -1;
    800050dc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800050de:	02054063          	bltz	a0,800050fe <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800050e2:	f48fc0ef          	jal	8000182a <myproc>
    800050e6:	fec42783          	lw	a5,-20(s0)
    800050ea:	07e9                	addi	a5,a5,26
    800050ec:	078e                	slli	a5,a5,0x3
    800050ee:	953e                	add	a0,a0,a5
    800050f0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800050f4:	fe043503          	ld	a0,-32(s0)
    800050f8:	bb2ff0ef          	jal	800044aa <fileclose>
  return 0;
    800050fc:	4781                	li	a5,0
}
    800050fe:	853e                	mv	a0,a5
    80005100:	60e2                	ld	ra,24(sp)
    80005102:	6442                	ld	s0,16(sp)
    80005104:	6105                	addi	sp,sp,32
    80005106:	8082                	ret

0000000080005108 <sys_fstat>:
{
    80005108:	1101                	addi	sp,sp,-32
    8000510a:	ec06                	sd	ra,24(sp)
    8000510c:	e822                	sd	s0,16(sp)
    8000510e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005110:	fe040593          	addi	a1,s0,-32
    80005114:	4505                	li	a0,1
    80005116:	c3ffd0ef          	jal	80002d54 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000511a:	fe840613          	addi	a2,s0,-24
    8000511e:	4581                	li	a1,0
    80005120:	4501                	li	a0,0
    80005122:	cf9ff0ef          	jal	80004e1a <argfd>
    80005126:	87aa                	mv	a5,a0
    return -1;
    80005128:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000512a:	0007c863          	bltz	a5,8000513a <sys_fstat+0x32>
  return filestat(f, st);
    8000512e:	fe043583          	ld	a1,-32(s0)
    80005132:	fe843503          	ld	a0,-24(s0)
    80005136:	c36ff0ef          	jal	8000456c <filestat>
}
    8000513a:	60e2                	ld	ra,24(sp)
    8000513c:	6442                	ld	s0,16(sp)
    8000513e:	6105                	addi	sp,sp,32
    80005140:	8082                	ret

0000000080005142 <sys_link>:
{
    80005142:	7169                	addi	sp,sp,-304
    80005144:	f606                	sd	ra,296(sp)
    80005146:	f222                	sd	s0,288(sp)
    80005148:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000514a:	08000613          	li	a2,128
    8000514e:	ed040593          	addi	a1,s0,-304
    80005152:	4501                	li	a0,0
    80005154:	c1dfd0ef          	jal	80002d70 <argstr>
    return -1;
    80005158:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000515a:	0c054e63          	bltz	a0,80005236 <sys_link+0xf4>
    8000515e:	08000613          	li	a2,128
    80005162:	f5040593          	addi	a1,s0,-176
    80005166:	4505                	li	a0,1
    80005168:	c09fd0ef          	jal	80002d70 <argstr>
    return -1;
    8000516c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000516e:	0c054463          	bltz	a0,80005236 <sys_link+0xf4>
    80005172:	ee26                	sd	s1,280(sp)
  begin_op();
    80005174:	f1dfe0ef          	jal	80004090 <begin_op>
  if((ip = namei(old)) == 0){
    80005178:	ed040513          	addi	a0,s0,-304
    8000517c:	d59fe0ef          	jal	80003ed4 <namei>
    80005180:	84aa                	mv	s1,a0
    80005182:	c53d                	beqz	a0,800051f0 <sys_link+0xae>
  ilock(ip);
    80005184:	e76fe0ef          	jal	800037fa <ilock>
  if(ip->type == T_DIR){
    80005188:	04449703          	lh	a4,68(s1)
    8000518c:	4785                	li	a5,1
    8000518e:	06f70663          	beq	a4,a5,800051fa <sys_link+0xb8>
    80005192:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005194:	04a4d783          	lhu	a5,74(s1)
    80005198:	2785                	addiw	a5,a5,1
    8000519a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000519e:	8526                	mv	a0,s1
    800051a0:	da6fe0ef          	jal	80003746 <iupdate>
  iunlock(ip);
    800051a4:	8526                	mv	a0,s1
    800051a6:	f02fe0ef          	jal	800038a8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800051aa:	fd040593          	addi	a1,s0,-48
    800051ae:	f5040513          	addi	a0,s0,-176
    800051b2:	d3dfe0ef          	jal	80003eee <nameiparent>
    800051b6:	892a                	mv	s2,a0
    800051b8:	cd21                	beqz	a0,80005210 <sys_link+0xce>
  ilock(dp);
    800051ba:	e40fe0ef          	jal	800037fa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800051be:	00092703          	lw	a4,0(s2)
    800051c2:	409c                	lw	a5,0(s1)
    800051c4:	04f71363          	bne	a4,a5,8000520a <sys_link+0xc8>
    800051c8:	40d0                	lw	a2,4(s1)
    800051ca:	fd040593          	addi	a1,s0,-48
    800051ce:	854a                	mv	a0,s2
    800051d0:	c6bfe0ef          	jal	80003e3a <dirlink>
    800051d4:	02054b63          	bltz	a0,8000520a <sys_link+0xc8>
  iunlockput(dp);
    800051d8:	854a                	mv	a0,s2
    800051da:	82bfe0ef          	jal	80003a04 <iunlockput>
  iput(ip);
    800051de:	8526                	mv	a0,s1
    800051e0:	f9cfe0ef          	jal	8000397c <iput>
  end_op();
    800051e4:	f17fe0ef          	jal	800040fa <end_op>
  return 0;
    800051e8:	4781                	li	a5,0
    800051ea:	64f2                	ld	s1,280(sp)
    800051ec:	6952                	ld	s2,272(sp)
    800051ee:	a0a1                	j	80005236 <sys_link+0xf4>
    end_op();
    800051f0:	f0bfe0ef          	jal	800040fa <end_op>
    return -1;
    800051f4:	57fd                	li	a5,-1
    800051f6:	64f2                	ld	s1,280(sp)
    800051f8:	a83d                	j	80005236 <sys_link+0xf4>
    iunlockput(ip);
    800051fa:	8526                	mv	a0,s1
    800051fc:	809fe0ef          	jal	80003a04 <iunlockput>
    end_op();
    80005200:	efbfe0ef          	jal	800040fa <end_op>
    return -1;
    80005204:	57fd                	li	a5,-1
    80005206:	64f2                	ld	s1,280(sp)
    80005208:	a03d                	j	80005236 <sys_link+0xf4>
    iunlockput(dp);
    8000520a:	854a                	mv	a0,s2
    8000520c:	ff8fe0ef          	jal	80003a04 <iunlockput>
  ilock(ip);
    80005210:	8526                	mv	a0,s1
    80005212:	de8fe0ef          	jal	800037fa <ilock>
  ip->nlink--;
    80005216:	04a4d783          	lhu	a5,74(s1)
    8000521a:	37fd                	addiw	a5,a5,-1
    8000521c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005220:	8526                	mv	a0,s1
    80005222:	d24fe0ef          	jal	80003746 <iupdate>
  iunlockput(ip);
    80005226:	8526                	mv	a0,s1
    80005228:	fdcfe0ef          	jal	80003a04 <iunlockput>
  end_op();
    8000522c:	ecffe0ef          	jal	800040fa <end_op>
  return -1;
    80005230:	57fd                	li	a5,-1
    80005232:	64f2                	ld	s1,280(sp)
    80005234:	6952                	ld	s2,272(sp)
}
    80005236:	853e                	mv	a0,a5
    80005238:	70b2                	ld	ra,296(sp)
    8000523a:	7412                	ld	s0,288(sp)
    8000523c:	6155                	addi	sp,sp,304
    8000523e:	8082                	ret

0000000080005240 <sys_unlink>:
{
    80005240:	7151                	addi	sp,sp,-240
    80005242:	f586                	sd	ra,232(sp)
    80005244:	f1a2                	sd	s0,224(sp)
    80005246:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005248:	08000613          	li	a2,128
    8000524c:	f3040593          	addi	a1,s0,-208
    80005250:	4501                	li	a0,0
    80005252:	b1ffd0ef          	jal	80002d70 <argstr>
    80005256:	16054063          	bltz	a0,800053b6 <sys_unlink+0x176>
    8000525a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000525c:	e35fe0ef          	jal	80004090 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005260:	fb040593          	addi	a1,s0,-80
    80005264:	f3040513          	addi	a0,s0,-208
    80005268:	c87fe0ef          	jal	80003eee <nameiparent>
    8000526c:	84aa                	mv	s1,a0
    8000526e:	c945                	beqz	a0,8000531e <sys_unlink+0xde>
  ilock(dp);
    80005270:	d8afe0ef          	jal	800037fa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005274:	00002597          	auipc	a1,0x2
    80005278:	40c58593          	addi	a1,a1,1036 # 80007680 <etext+0x680>
    8000527c:	fb040513          	addi	a0,s0,-80
    80005280:	9d9fe0ef          	jal	80003c58 <namecmp>
    80005284:	10050e63          	beqz	a0,800053a0 <sys_unlink+0x160>
    80005288:	00002597          	auipc	a1,0x2
    8000528c:	40058593          	addi	a1,a1,1024 # 80007688 <etext+0x688>
    80005290:	fb040513          	addi	a0,s0,-80
    80005294:	9c5fe0ef          	jal	80003c58 <namecmp>
    80005298:	10050463          	beqz	a0,800053a0 <sys_unlink+0x160>
    8000529c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000529e:	f2c40613          	addi	a2,s0,-212
    800052a2:	fb040593          	addi	a1,s0,-80
    800052a6:	8526                	mv	a0,s1
    800052a8:	9c7fe0ef          	jal	80003c6e <dirlookup>
    800052ac:	892a                	mv	s2,a0
    800052ae:	0e050863          	beqz	a0,8000539e <sys_unlink+0x15e>
  ilock(ip);
    800052b2:	d48fe0ef          	jal	800037fa <ilock>
  if(ip->nlink < 1)
    800052b6:	04a91783          	lh	a5,74(s2)
    800052ba:	06f05763          	blez	a5,80005328 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800052be:	04491703          	lh	a4,68(s2)
    800052c2:	4785                	li	a5,1
    800052c4:	06f70963          	beq	a4,a5,80005336 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800052c8:	4641                	li	a2,16
    800052ca:	4581                	li	a1,0
    800052cc:	fc040513          	addi	a0,s0,-64
    800052d0:	9f9fb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800052d4:	4741                	li	a4,16
    800052d6:	f2c42683          	lw	a3,-212(s0)
    800052da:	fc040613          	addi	a2,s0,-64
    800052de:	4581                	li	a1,0
    800052e0:	8526                	mv	a0,s1
    800052e2:	869fe0ef          	jal	80003b4a <writei>
    800052e6:	47c1                	li	a5,16
    800052e8:	08f51b63          	bne	a0,a5,8000537e <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800052ec:	04491703          	lh	a4,68(s2)
    800052f0:	4785                	li	a5,1
    800052f2:	08f70d63          	beq	a4,a5,8000538c <sys_unlink+0x14c>
  iunlockput(dp);
    800052f6:	8526                	mv	a0,s1
    800052f8:	f0cfe0ef          	jal	80003a04 <iunlockput>
  ip->nlink--;
    800052fc:	04a95783          	lhu	a5,74(s2)
    80005300:	37fd                	addiw	a5,a5,-1
    80005302:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005306:	854a                	mv	a0,s2
    80005308:	c3efe0ef          	jal	80003746 <iupdate>
  iunlockput(ip);
    8000530c:	854a                	mv	a0,s2
    8000530e:	ef6fe0ef          	jal	80003a04 <iunlockput>
  end_op();
    80005312:	de9fe0ef          	jal	800040fa <end_op>
  return 0;
    80005316:	4501                	li	a0,0
    80005318:	64ee                	ld	s1,216(sp)
    8000531a:	694e                	ld	s2,208(sp)
    8000531c:	a849                	j	800053ae <sys_unlink+0x16e>
    end_op();
    8000531e:	dddfe0ef          	jal	800040fa <end_op>
    return -1;
    80005322:	557d                	li	a0,-1
    80005324:	64ee                	ld	s1,216(sp)
    80005326:	a061                	j	800053ae <sys_unlink+0x16e>
    80005328:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000532a:	00002517          	auipc	a0,0x2
    8000532e:	36650513          	addi	a0,a0,870 # 80007690 <etext+0x690>
    80005332:	c62fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005336:	04c92703          	lw	a4,76(s2)
    8000533a:	02000793          	li	a5,32
    8000533e:	f8e7f5e3          	bgeu	a5,a4,800052c8 <sys_unlink+0x88>
    80005342:	e5ce                	sd	s3,200(sp)
    80005344:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005348:	4741                	li	a4,16
    8000534a:	86ce                	mv	a3,s3
    8000534c:	f1840613          	addi	a2,s0,-232
    80005350:	4581                	li	a1,0
    80005352:	854a                	mv	a0,s2
    80005354:	efafe0ef          	jal	80003a4e <readi>
    80005358:	47c1                	li	a5,16
    8000535a:	00f51c63          	bne	a0,a5,80005372 <sys_unlink+0x132>
    if(de.inum != 0)
    8000535e:	f1845783          	lhu	a5,-232(s0)
    80005362:	efa1                	bnez	a5,800053ba <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005364:	29c1                	addiw	s3,s3,16
    80005366:	04c92783          	lw	a5,76(s2)
    8000536a:	fcf9efe3          	bltu	s3,a5,80005348 <sys_unlink+0x108>
    8000536e:	69ae                	ld	s3,200(sp)
    80005370:	bfa1                	j	800052c8 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80005372:	00002517          	auipc	a0,0x2
    80005376:	33650513          	addi	a0,a0,822 # 800076a8 <etext+0x6a8>
    8000537a:	c1afb0ef          	jal	80000794 <panic>
    8000537e:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005380:	00002517          	auipc	a0,0x2
    80005384:	34050513          	addi	a0,a0,832 # 800076c0 <etext+0x6c0>
    80005388:	c0cfb0ef          	jal	80000794 <panic>
    dp->nlink--;
    8000538c:	04a4d783          	lhu	a5,74(s1)
    80005390:	37fd                	addiw	a5,a5,-1
    80005392:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005396:	8526                	mv	a0,s1
    80005398:	baefe0ef          	jal	80003746 <iupdate>
    8000539c:	bfa9                	j	800052f6 <sys_unlink+0xb6>
    8000539e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800053a0:	8526                	mv	a0,s1
    800053a2:	e62fe0ef          	jal	80003a04 <iunlockput>
  end_op();
    800053a6:	d55fe0ef          	jal	800040fa <end_op>
  return -1;
    800053aa:	557d                	li	a0,-1
    800053ac:	64ee                	ld	s1,216(sp)
}
    800053ae:	70ae                	ld	ra,232(sp)
    800053b0:	740e                	ld	s0,224(sp)
    800053b2:	616d                	addi	sp,sp,240
    800053b4:	8082                	ret
    return -1;
    800053b6:	557d                	li	a0,-1
    800053b8:	bfdd                	j	800053ae <sys_unlink+0x16e>
    iunlockput(ip);
    800053ba:	854a                	mv	a0,s2
    800053bc:	e48fe0ef          	jal	80003a04 <iunlockput>
    goto bad;
    800053c0:	694e                	ld	s2,208(sp)
    800053c2:	69ae                	ld	s3,200(sp)
    800053c4:	bff1                	j	800053a0 <sys_unlink+0x160>

00000000800053c6 <sys_open>:

uint64
sys_open(void)
{
    800053c6:	7131                	addi	sp,sp,-192
    800053c8:	fd06                	sd	ra,184(sp)
    800053ca:	f922                	sd	s0,176(sp)
    800053cc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800053ce:	f4c40593          	addi	a1,s0,-180
    800053d2:	4505                	li	a0,1
    800053d4:	965fd0ef          	jal	80002d38 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800053d8:	08000613          	li	a2,128
    800053dc:	f5040593          	addi	a1,s0,-176
    800053e0:	4501                	li	a0,0
    800053e2:	98ffd0ef          	jal	80002d70 <argstr>
    800053e6:	87aa                	mv	a5,a0
    return -1;
    800053e8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800053ea:	0a07c263          	bltz	a5,8000548e <sys_open+0xc8>
    800053ee:	f526                	sd	s1,168(sp)

  begin_op();
    800053f0:	ca1fe0ef          	jal	80004090 <begin_op>

  if(omode & O_CREATE){
    800053f4:	f4c42783          	lw	a5,-180(s0)
    800053f8:	2007f793          	andi	a5,a5,512
    800053fc:	c3d5                	beqz	a5,800054a0 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800053fe:	4681                	li	a3,0
    80005400:	4601                	li	a2,0
    80005402:	4589                	li	a1,2
    80005404:	f5040513          	addi	a0,s0,-176
    80005408:	aa9ff0ef          	jal	80004eb0 <create>
    8000540c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000540e:	c541                	beqz	a0,80005496 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005410:	04449703          	lh	a4,68(s1)
    80005414:	478d                	li	a5,3
    80005416:	00f71763          	bne	a4,a5,80005424 <sys_open+0x5e>
    8000541a:	0464d703          	lhu	a4,70(s1)
    8000541e:	47a5                	li	a5,9
    80005420:	0ae7ed63          	bltu	a5,a4,800054da <sys_open+0x114>
    80005424:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005426:	fe1fe0ef          	jal	80004406 <filealloc>
    8000542a:	892a                	mv	s2,a0
    8000542c:	c179                	beqz	a0,800054f2 <sys_open+0x12c>
    8000542e:	ed4e                	sd	s3,152(sp)
    80005430:	a43ff0ef          	jal	80004e72 <fdalloc>
    80005434:	89aa                	mv	s3,a0
    80005436:	0a054a63          	bltz	a0,800054ea <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000543a:	04449703          	lh	a4,68(s1)
    8000543e:	478d                	li	a5,3
    80005440:	0cf70263          	beq	a4,a5,80005504 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005444:	4789                	li	a5,2
    80005446:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000544a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000544e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005452:	f4c42783          	lw	a5,-180(s0)
    80005456:	0017c713          	xori	a4,a5,1
    8000545a:	8b05                	andi	a4,a4,1
    8000545c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005460:	0037f713          	andi	a4,a5,3
    80005464:	00e03733          	snez	a4,a4
    80005468:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000546c:	4007f793          	andi	a5,a5,1024
    80005470:	c791                	beqz	a5,8000547c <sys_open+0xb6>
    80005472:	04449703          	lh	a4,68(s1)
    80005476:	4789                	li	a5,2
    80005478:	08f70d63          	beq	a4,a5,80005512 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000547c:	8526                	mv	a0,s1
    8000547e:	c2afe0ef          	jal	800038a8 <iunlock>
  end_op();
    80005482:	c79fe0ef          	jal	800040fa <end_op>

  return fd;
    80005486:	854e                	mv	a0,s3
    80005488:	74aa                	ld	s1,168(sp)
    8000548a:	790a                	ld	s2,160(sp)
    8000548c:	69ea                	ld	s3,152(sp)
}
    8000548e:	70ea                	ld	ra,184(sp)
    80005490:	744a                	ld	s0,176(sp)
    80005492:	6129                	addi	sp,sp,192
    80005494:	8082                	ret
      end_op();
    80005496:	c65fe0ef          	jal	800040fa <end_op>
      return -1;
    8000549a:	557d                	li	a0,-1
    8000549c:	74aa                	ld	s1,168(sp)
    8000549e:	bfc5                	j	8000548e <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800054a0:	f5040513          	addi	a0,s0,-176
    800054a4:	a31fe0ef          	jal	80003ed4 <namei>
    800054a8:	84aa                	mv	s1,a0
    800054aa:	c11d                	beqz	a0,800054d0 <sys_open+0x10a>
    ilock(ip);
    800054ac:	b4efe0ef          	jal	800037fa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800054b0:	04449703          	lh	a4,68(s1)
    800054b4:	4785                	li	a5,1
    800054b6:	f4f71de3          	bne	a4,a5,80005410 <sys_open+0x4a>
    800054ba:	f4c42783          	lw	a5,-180(s0)
    800054be:	d3bd                	beqz	a5,80005424 <sys_open+0x5e>
      iunlockput(ip);
    800054c0:	8526                	mv	a0,s1
    800054c2:	d42fe0ef          	jal	80003a04 <iunlockput>
      end_op();
    800054c6:	c35fe0ef          	jal	800040fa <end_op>
      return -1;
    800054ca:	557d                	li	a0,-1
    800054cc:	74aa                	ld	s1,168(sp)
    800054ce:	b7c1                	j	8000548e <sys_open+0xc8>
      end_op();
    800054d0:	c2bfe0ef          	jal	800040fa <end_op>
      return -1;
    800054d4:	557d                	li	a0,-1
    800054d6:	74aa                	ld	s1,168(sp)
    800054d8:	bf5d                	j	8000548e <sys_open+0xc8>
    iunlockput(ip);
    800054da:	8526                	mv	a0,s1
    800054dc:	d28fe0ef          	jal	80003a04 <iunlockput>
    end_op();
    800054e0:	c1bfe0ef          	jal	800040fa <end_op>
    return -1;
    800054e4:	557d                	li	a0,-1
    800054e6:	74aa                	ld	s1,168(sp)
    800054e8:	b75d                	j	8000548e <sys_open+0xc8>
      fileclose(f);
    800054ea:	854a                	mv	a0,s2
    800054ec:	fbffe0ef          	jal	800044aa <fileclose>
    800054f0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800054f2:	8526                	mv	a0,s1
    800054f4:	d10fe0ef          	jal	80003a04 <iunlockput>
    end_op();
    800054f8:	c03fe0ef          	jal	800040fa <end_op>
    return -1;
    800054fc:	557d                	li	a0,-1
    800054fe:	74aa                	ld	s1,168(sp)
    80005500:	790a                	ld	s2,160(sp)
    80005502:	b771                	j	8000548e <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005504:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005508:	04649783          	lh	a5,70(s1)
    8000550c:	02f91223          	sh	a5,36(s2)
    80005510:	bf3d                	j	8000544e <sys_open+0x88>
    itrunc(ip);
    80005512:	8526                	mv	a0,s1
    80005514:	bd4fe0ef          	jal	800038e8 <itrunc>
    80005518:	b795                	j	8000547c <sys_open+0xb6>

000000008000551a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000551a:	7175                	addi	sp,sp,-144
    8000551c:	e506                	sd	ra,136(sp)
    8000551e:	e122                	sd	s0,128(sp)
    80005520:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005522:	b6ffe0ef          	jal	80004090 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005526:	08000613          	li	a2,128
    8000552a:	f7040593          	addi	a1,s0,-144
    8000552e:	4501                	li	a0,0
    80005530:	841fd0ef          	jal	80002d70 <argstr>
    80005534:	02054363          	bltz	a0,8000555a <sys_mkdir+0x40>
    80005538:	4681                	li	a3,0
    8000553a:	4601                	li	a2,0
    8000553c:	4585                	li	a1,1
    8000553e:	f7040513          	addi	a0,s0,-144
    80005542:	96fff0ef          	jal	80004eb0 <create>
    80005546:	c911                	beqz	a0,8000555a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005548:	cbcfe0ef          	jal	80003a04 <iunlockput>
  end_op();
    8000554c:	baffe0ef          	jal	800040fa <end_op>
  return 0;
    80005550:	4501                	li	a0,0
}
    80005552:	60aa                	ld	ra,136(sp)
    80005554:	640a                	ld	s0,128(sp)
    80005556:	6149                	addi	sp,sp,144
    80005558:	8082                	ret
    end_op();
    8000555a:	ba1fe0ef          	jal	800040fa <end_op>
    return -1;
    8000555e:	557d                	li	a0,-1
    80005560:	bfcd                	j	80005552 <sys_mkdir+0x38>

0000000080005562 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005562:	7135                	addi	sp,sp,-160
    80005564:	ed06                	sd	ra,152(sp)
    80005566:	e922                	sd	s0,144(sp)
    80005568:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000556a:	b27fe0ef          	jal	80004090 <begin_op>
  argint(1, &major);
    8000556e:	f6c40593          	addi	a1,s0,-148
    80005572:	4505                	li	a0,1
    80005574:	fc4fd0ef          	jal	80002d38 <argint>
  argint(2, &minor);
    80005578:	f6840593          	addi	a1,s0,-152
    8000557c:	4509                	li	a0,2
    8000557e:	fbafd0ef          	jal	80002d38 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005582:	08000613          	li	a2,128
    80005586:	f7040593          	addi	a1,s0,-144
    8000558a:	4501                	li	a0,0
    8000558c:	fe4fd0ef          	jal	80002d70 <argstr>
    80005590:	02054563          	bltz	a0,800055ba <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005594:	f6841683          	lh	a3,-152(s0)
    80005598:	f6c41603          	lh	a2,-148(s0)
    8000559c:	458d                	li	a1,3
    8000559e:	f7040513          	addi	a0,s0,-144
    800055a2:	90fff0ef          	jal	80004eb0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800055a6:	c911                	beqz	a0,800055ba <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800055a8:	c5cfe0ef          	jal	80003a04 <iunlockput>
  end_op();
    800055ac:	b4ffe0ef          	jal	800040fa <end_op>
  return 0;
    800055b0:	4501                	li	a0,0
}
    800055b2:	60ea                	ld	ra,152(sp)
    800055b4:	644a                	ld	s0,144(sp)
    800055b6:	610d                	addi	sp,sp,160
    800055b8:	8082                	ret
    end_op();
    800055ba:	b41fe0ef          	jal	800040fa <end_op>
    return -1;
    800055be:	557d                	li	a0,-1
    800055c0:	bfcd                	j	800055b2 <sys_mknod+0x50>

00000000800055c2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800055c2:	7135                	addi	sp,sp,-160
    800055c4:	ed06                	sd	ra,152(sp)
    800055c6:	e922                	sd	s0,144(sp)
    800055c8:	e14a                	sd	s2,128(sp)
    800055ca:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800055cc:	a5efc0ef          	jal	8000182a <myproc>
    800055d0:	892a                	mv	s2,a0
  
  begin_op();
    800055d2:	abffe0ef          	jal	80004090 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800055d6:	08000613          	li	a2,128
    800055da:	f6040593          	addi	a1,s0,-160
    800055de:	4501                	li	a0,0
    800055e0:	f90fd0ef          	jal	80002d70 <argstr>
    800055e4:	04054363          	bltz	a0,8000562a <sys_chdir+0x68>
    800055e8:	e526                	sd	s1,136(sp)
    800055ea:	f6040513          	addi	a0,s0,-160
    800055ee:	8e7fe0ef          	jal	80003ed4 <namei>
    800055f2:	84aa                	mv	s1,a0
    800055f4:	c915                	beqz	a0,80005628 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800055f6:	a04fe0ef          	jal	800037fa <ilock>
  if(ip->type != T_DIR){
    800055fa:	04449703          	lh	a4,68(s1)
    800055fe:	4785                	li	a5,1
    80005600:	02f71963          	bne	a4,a5,80005632 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005604:	8526                	mv	a0,s1
    80005606:	aa2fe0ef          	jal	800038a8 <iunlock>
  iput(p->cwd);
    8000560a:	15093503          	ld	a0,336(s2)
    8000560e:	b6efe0ef          	jal	8000397c <iput>
  end_op();
    80005612:	ae9fe0ef          	jal	800040fa <end_op>
  p->cwd = ip;
    80005616:	14993823          	sd	s1,336(s2)
  return 0;
    8000561a:	4501                	li	a0,0
    8000561c:	64aa                	ld	s1,136(sp)
}
    8000561e:	60ea                	ld	ra,152(sp)
    80005620:	644a                	ld	s0,144(sp)
    80005622:	690a                	ld	s2,128(sp)
    80005624:	610d                	addi	sp,sp,160
    80005626:	8082                	ret
    80005628:	64aa                	ld	s1,136(sp)
    end_op();
    8000562a:	ad1fe0ef          	jal	800040fa <end_op>
    return -1;
    8000562e:	557d                	li	a0,-1
    80005630:	b7fd                	j	8000561e <sys_chdir+0x5c>
    iunlockput(ip);
    80005632:	8526                	mv	a0,s1
    80005634:	bd0fe0ef          	jal	80003a04 <iunlockput>
    end_op();
    80005638:	ac3fe0ef          	jal	800040fa <end_op>
    return -1;
    8000563c:	557d                	li	a0,-1
    8000563e:	64aa                	ld	s1,136(sp)
    80005640:	bff9                	j	8000561e <sys_chdir+0x5c>

0000000080005642 <sys_exec>:

uint64
sys_exec(void)
{
    80005642:	7121                	addi	sp,sp,-448
    80005644:	ff06                	sd	ra,440(sp)
    80005646:	fb22                	sd	s0,432(sp)
    80005648:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000564a:	e4840593          	addi	a1,s0,-440
    8000564e:	4505                	li	a0,1
    80005650:	f04fd0ef          	jal	80002d54 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005654:	08000613          	li	a2,128
    80005658:	f5040593          	addi	a1,s0,-176
    8000565c:	4501                	li	a0,0
    8000565e:	f12fd0ef          	jal	80002d70 <argstr>
    80005662:	87aa                	mv	a5,a0
    return -1;
    80005664:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005666:	0c07c463          	bltz	a5,8000572e <sys_exec+0xec>
    8000566a:	f726                	sd	s1,424(sp)
    8000566c:	f34a                	sd	s2,416(sp)
    8000566e:	ef4e                	sd	s3,408(sp)
    80005670:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005672:	10000613          	li	a2,256
    80005676:	4581                	li	a1,0
    80005678:	e5040513          	addi	a0,s0,-432
    8000567c:	e4cfb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005680:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005684:	89a6                	mv	s3,s1
    80005686:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005688:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000568c:	00391513          	slli	a0,s2,0x3
    80005690:	e4040593          	addi	a1,s0,-448
    80005694:	e4843783          	ld	a5,-440(s0)
    80005698:	953e                	add	a0,a0,a5
    8000569a:	e14fd0ef          	jal	80002cae <fetchaddr>
    8000569e:	02054663          	bltz	a0,800056ca <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800056a2:	e4043783          	ld	a5,-448(s0)
    800056a6:	c3a9                	beqz	a5,800056e8 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800056a8:	c7cfb0ef          	jal	80000b24 <kalloc>
    800056ac:	85aa                	mv	a1,a0
    800056ae:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800056b2:	cd01                	beqz	a0,800056ca <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800056b4:	6605                	lui	a2,0x1
    800056b6:	e4043503          	ld	a0,-448(s0)
    800056ba:	e3efd0ef          	jal	80002cf8 <fetchstr>
    800056be:	00054663          	bltz	a0,800056ca <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800056c2:	0905                	addi	s2,s2,1
    800056c4:	09a1                	addi	s3,s3,8
    800056c6:	fd4913e3          	bne	s2,s4,8000568c <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056ca:	f5040913          	addi	s2,s0,-176
    800056ce:	6088                	ld	a0,0(s1)
    800056d0:	c931                	beqz	a0,80005724 <sys_exec+0xe2>
    kfree(argv[i]);
    800056d2:	b70fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056d6:	04a1                	addi	s1,s1,8
    800056d8:	ff249be3          	bne	s1,s2,800056ce <sys_exec+0x8c>
  return -1;
    800056dc:	557d                	li	a0,-1
    800056de:	74ba                	ld	s1,424(sp)
    800056e0:	791a                	ld	s2,416(sp)
    800056e2:	69fa                	ld	s3,408(sp)
    800056e4:	6a5a                	ld	s4,400(sp)
    800056e6:	a0a1                	j	8000572e <sys_exec+0xec>
      argv[i] = 0;
    800056e8:	0009079b          	sext.w	a5,s2
    800056ec:	078e                	slli	a5,a5,0x3
    800056ee:	fd078793          	addi	a5,a5,-48
    800056f2:	97a2                	add	a5,a5,s0
    800056f4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800056f8:	e5040593          	addi	a1,s0,-432
    800056fc:	f5040513          	addi	a0,s0,-176
    80005700:	ba8ff0ef          	jal	80004aa8 <exec>
    80005704:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005706:	f5040993          	addi	s3,s0,-176
    8000570a:	6088                	ld	a0,0(s1)
    8000570c:	c511                	beqz	a0,80005718 <sys_exec+0xd6>
    kfree(argv[i]);
    8000570e:	b34fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005712:	04a1                	addi	s1,s1,8
    80005714:	ff349be3          	bne	s1,s3,8000570a <sys_exec+0xc8>
  return ret;
    80005718:	854a                	mv	a0,s2
    8000571a:	74ba                	ld	s1,424(sp)
    8000571c:	791a                	ld	s2,416(sp)
    8000571e:	69fa                	ld	s3,408(sp)
    80005720:	6a5a                	ld	s4,400(sp)
    80005722:	a031                	j	8000572e <sys_exec+0xec>
  return -1;
    80005724:	557d                	li	a0,-1
    80005726:	74ba                	ld	s1,424(sp)
    80005728:	791a                	ld	s2,416(sp)
    8000572a:	69fa                	ld	s3,408(sp)
    8000572c:	6a5a                	ld	s4,400(sp)
}
    8000572e:	70fa                	ld	ra,440(sp)
    80005730:	745a                	ld	s0,432(sp)
    80005732:	6139                	addi	sp,sp,448
    80005734:	8082                	ret

0000000080005736 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005736:	7139                	addi	sp,sp,-64
    80005738:	fc06                	sd	ra,56(sp)
    8000573a:	f822                	sd	s0,48(sp)
    8000573c:	f426                	sd	s1,40(sp)
    8000573e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005740:	8eafc0ef          	jal	8000182a <myproc>
    80005744:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005746:	fd840593          	addi	a1,s0,-40
    8000574a:	4501                	li	a0,0
    8000574c:	e08fd0ef          	jal	80002d54 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005750:	fc840593          	addi	a1,s0,-56
    80005754:	fd040513          	addi	a0,s0,-48
    80005758:	85cff0ef          	jal	800047b4 <pipealloc>
    return -1;
    8000575c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000575e:	0a054463          	bltz	a0,80005806 <sys_pipe+0xd0>
  fd0 = -1;
    80005762:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005766:	fd043503          	ld	a0,-48(s0)
    8000576a:	f08ff0ef          	jal	80004e72 <fdalloc>
    8000576e:	fca42223          	sw	a0,-60(s0)
    80005772:	08054163          	bltz	a0,800057f4 <sys_pipe+0xbe>
    80005776:	fc843503          	ld	a0,-56(s0)
    8000577a:	ef8ff0ef          	jal	80004e72 <fdalloc>
    8000577e:	fca42023          	sw	a0,-64(s0)
    80005782:	06054063          	bltz	a0,800057e2 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005786:	4691                	li	a3,4
    80005788:	fc440613          	addi	a2,s0,-60
    8000578c:	fd843583          	ld	a1,-40(s0)
    80005790:	68a8                	ld	a0,80(s1)
    80005792:	dc1fb0ef          	jal	80001552 <copyout>
    80005796:	00054e63          	bltz	a0,800057b2 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000579a:	4691                	li	a3,4
    8000579c:	fc040613          	addi	a2,s0,-64
    800057a0:	fd843583          	ld	a1,-40(s0)
    800057a4:	0591                	addi	a1,a1,4
    800057a6:	68a8                	ld	a0,80(s1)
    800057a8:	dabfb0ef          	jal	80001552 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800057ac:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800057ae:	04055c63          	bgez	a0,80005806 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800057b2:	fc442783          	lw	a5,-60(s0)
    800057b6:	07e9                	addi	a5,a5,26
    800057b8:	078e                	slli	a5,a5,0x3
    800057ba:	97a6                	add	a5,a5,s1
    800057bc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800057c0:	fc042783          	lw	a5,-64(s0)
    800057c4:	07e9                	addi	a5,a5,26
    800057c6:	078e                	slli	a5,a5,0x3
    800057c8:	94be                	add	s1,s1,a5
    800057ca:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800057ce:	fd043503          	ld	a0,-48(s0)
    800057d2:	cd9fe0ef          	jal	800044aa <fileclose>
    fileclose(wf);
    800057d6:	fc843503          	ld	a0,-56(s0)
    800057da:	cd1fe0ef          	jal	800044aa <fileclose>
    return -1;
    800057de:	57fd                	li	a5,-1
    800057e0:	a01d                	j	80005806 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800057e2:	fc442783          	lw	a5,-60(s0)
    800057e6:	0007c763          	bltz	a5,800057f4 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800057ea:	07e9                	addi	a5,a5,26
    800057ec:	078e                	slli	a5,a5,0x3
    800057ee:	97a6                	add	a5,a5,s1
    800057f0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800057f4:	fd043503          	ld	a0,-48(s0)
    800057f8:	cb3fe0ef          	jal	800044aa <fileclose>
    fileclose(wf);
    800057fc:	fc843503          	ld	a0,-56(s0)
    80005800:	cabfe0ef          	jal	800044aa <fileclose>
    return -1;
    80005804:	57fd                	li	a5,-1
}
    80005806:	853e                	mv	a0,a5
    80005808:	70e2                	ld	ra,56(sp)
    8000580a:	7442                	ld	s0,48(sp)
    8000580c:	74a2                	ld	s1,40(sp)
    8000580e:	6121                	addi	sp,sp,64
    80005810:	8082                	ret
	...

0000000080005820 <kernelvec>:
    80005820:	7111                	addi	sp,sp,-256
    80005822:	e006                	sd	ra,0(sp)
    80005824:	e40a                	sd	sp,8(sp)
    80005826:	e80e                	sd	gp,16(sp)
    80005828:	ec12                	sd	tp,24(sp)
    8000582a:	f016                	sd	t0,32(sp)
    8000582c:	f41a                	sd	t1,40(sp)
    8000582e:	f81e                	sd	t2,48(sp)
    80005830:	e4aa                	sd	a0,72(sp)
    80005832:	e8ae                	sd	a1,80(sp)
    80005834:	ecb2                	sd	a2,88(sp)
    80005836:	f0b6                	sd	a3,96(sp)
    80005838:	f4ba                	sd	a4,104(sp)
    8000583a:	f8be                	sd	a5,112(sp)
    8000583c:	fcc2                	sd	a6,120(sp)
    8000583e:	e146                	sd	a7,128(sp)
    80005840:	edf2                	sd	t3,216(sp)
    80005842:	f1f6                	sd	t4,224(sp)
    80005844:	f5fa                	sd	t5,232(sp)
    80005846:	f9fe                	sd	t6,240(sp)
    80005848:	b36fd0ef          	jal	80002b7e <kerneltrap>
    8000584c:	6082                	ld	ra,0(sp)
    8000584e:	6122                	ld	sp,8(sp)
    80005850:	61c2                	ld	gp,16(sp)
    80005852:	7282                	ld	t0,32(sp)
    80005854:	7322                	ld	t1,40(sp)
    80005856:	73c2                	ld	t2,48(sp)
    80005858:	6526                	ld	a0,72(sp)
    8000585a:	65c6                	ld	a1,80(sp)
    8000585c:	6666                	ld	a2,88(sp)
    8000585e:	7686                	ld	a3,96(sp)
    80005860:	7726                	ld	a4,104(sp)
    80005862:	77c6                	ld	a5,112(sp)
    80005864:	7866                	ld	a6,120(sp)
    80005866:	688a                	ld	a7,128(sp)
    80005868:	6e6e                	ld	t3,216(sp)
    8000586a:	7e8e                	ld	t4,224(sp)
    8000586c:	7f2e                	ld	t5,232(sp)
    8000586e:	7fce                	ld	t6,240(sp)
    80005870:	6111                	addi	sp,sp,256
    80005872:	10200073          	sret
	...

000000008000587e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000587e:	1141                	addi	sp,sp,-16
    80005880:	e422                	sd	s0,8(sp)
    80005882:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005884:	0c0007b7          	lui	a5,0xc000
    80005888:	4705                	li	a4,1
    8000588a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000588c:	0c0007b7          	lui	a5,0xc000
    80005890:	c3d8                	sw	a4,4(a5)
}
    80005892:	6422                	ld	s0,8(sp)
    80005894:	0141                	addi	sp,sp,16
    80005896:	8082                	ret

0000000080005898 <plicinithart>:

void
plicinithart(void)
{
    80005898:	1141                	addi	sp,sp,-16
    8000589a:	e406                	sd	ra,8(sp)
    8000589c:	e022                	sd	s0,0(sp)
    8000589e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800058a0:	f5ffb0ef          	jal	800017fe <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800058a4:	0085171b          	slliw	a4,a0,0x8
    800058a8:	0c0027b7          	lui	a5,0xc002
    800058ac:	97ba                	add	a5,a5,a4
    800058ae:	40200713          	li	a4,1026
    800058b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800058b6:	00d5151b          	slliw	a0,a0,0xd
    800058ba:	0c2017b7          	lui	a5,0xc201
    800058be:	97aa                	add	a5,a5,a0
    800058c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800058c4:	60a2                	ld	ra,8(sp)
    800058c6:	6402                	ld	s0,0(sp)
    800058c8:	0141                	addi	sp,sp,16
    800058ca:	8082                	ret

00000000800058cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800058cc:	1141                	addi	sp,sp,-16
    800058ce:	e406                	sd	ra,8(sp)
    800058d0:	e022                	sd	s0,0(sp)
    800058d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800058d4:	f2bfb0ef          	jal	800017fe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800058d8:	00d5151b          	slliw	a0,a0,0xd
    800058dc:	0c2017b7          	lui	a5,0xc201
    800058e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800058e2:	43c8                	lw	a0,4(a5)
    800058e4:	60a2                	ld	ra,8(sp)
    800058e6:	6402                	ld	s0,0(sp)
    800058e8:	0141                	addi	sp,sp,16
    800058ea:	8082                	ret

00000000800058ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800058ec:	1101                	addi	sp,sp,-32
    800058ee:	ec06                	sd	ra,24(sp)
    800058f0:	e822                	sd	s0,16(sp)
    800058f2:	e426                	sd	s1,8(sp)
    800058f4:	1000                	addi	s0,sp,32
    800058f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800058f8:	f07fb0ef          	jal	800017fe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800058fc:	00d5151b          	slliw	a0,a0,0xd
    80005900:	0c2017b7          	lui	a5,0xc201
    80005904:	97aa                	add	a5,a5,a0
    80005906:	c3c4                	sw	s1,4(a5)
}
    80005908:	60e2                	ld	ra,24(sp)
    8000590a:	6442                	ld	s0,16(sp)
    8000590c:	64a2                	ld	s1,8(sp)
    8000590e:	6105                	addi	sp,sp,32
    80005910:	8082                	ret

0000000080005912 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005912:	1141                	addi	sp,sp,-16
    80005914:	e406                	sd	ra,8(sp)
    80005916:	e022                	sd	s0,0(sp)
    80005918:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000591a:	479d                	li	a5,7
    8000591c:	04a7ca63          	blt	a5,a0,80005970 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005920:	0001e797          	auipc	a5,0x1e
    80005924:	4e878793          	addi	a5,a5,1256 # 80023e08 <disk>
    80005928:	97aa                	add	a5,a5,a0
    8000592a:	0187c783          	lbu	a5,24(a5)
    8000592e:	e7b9                	bnez	a5,8000597c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005930:	00451693          	slli	a3,a0,0x4
    80005934:	0001e797          	auipc	a5,0x1e
    80005938:	4d478793          	addi	a5,a5,1236 # 80023e08 <disk>
    8000593c:	6398                	ld	a4,0(a5)
    8000593e:	9736                	add	a4,a4,a3
    80005940:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005944:	6398                	ld	a4,0(a5)
    80005946:	9736                	add	a4,a4,a3
    80005948:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000594c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005950:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005954:	97aa                	add	a5,a5,a0
    80005956:	4705                	li	a4,1
    80005958:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000595c:	0001e517          	auipc	a0,0x1e
    80005960:	4c450513          	addi	a0,a0,1220 # 80023e20 <disk+0x18>
    80005964:	953fc0ef          	jal	800022b6 <wakeup>
}
    80005968:	60a2                	ld	ra,8(sp)
    8000596a:	6402                	ld	s0,0(sp)
    8000596c:	0141                	addi	sp,sp,16
    8000596e:	8082                	ret
    panic("free_desc 1");
    80005970:	00002517          	auipc	a0,0x2
    80005974:	d6050513          	addi	a0,a0,-672 # 800076d0 <etext+0x6d0>
    80005978:	e1dfa0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000597c:	00002517          	auipc	a0,0x2
    80005980:	d6450513          	addi	a0,a0,-668 # 800076e0 <etext+0x6e0>
    80005984:	e11fa0ef          	jal	80000794 <panic>

0000000080005988 <virtio_disk_init>:
{
    80005988:	1101                	addi	sp,sp,-32
    8000598a:	ec06                	sd	ra,24(sp)
    8000598c:	e822                	sd	s0,16(sp)
    8000598e:	e426                	sd	s1,8(sp)
    80005990:	e04a                	sd	s2,0(sp)
    80005992:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005994:	00002597          	auipc	a1,0x2
    80005998:	d5c58593          	addi	a1,a1,-676 # 800076f0 <etext+0x6f0>
    8000599c:	0001e517          	auipc	a0,0x1e
    800059a0:	59450513          	addi	a0,a0,1428 # 80023f30 <disk+0x128>
    800059a4:	9d0fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800059a8:	100017b7          	lui	a5,0x10001
    800059ac:	4398                	lw	a4,0(a5)
    800059ae:	2701                	sext.w	a4,a4
    800059b0:	747277b7          	lui	a5,0x74727
    800059b4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800059b8:	18f71063          	bne	a4,a5,80005b38 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800059bc:	100017b7          	lui	a5,0x10001
    800059c0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800059c2:	439c                	lw	a5,0(a5)
    800059c4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800059c6:	4709                	li	a4,2
    800059c8:	16e79863          	bne	a5,a4,80005b38 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800059cc:	100017b7          	lui	a5,0x10001
    800059d0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800059d2:	439c                	lw	a5,0(a5)
    800059d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800059d6:	16e79163          	bne	a5,a4,80005b38 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800059da:	100017b7          	lui	a5,0x10001
    800059de:	47d8                	lw	a4,12(a5)
    800059e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800059e2:	554d47b7          	lui	a5,0x554d4
    800059e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800059ea:	14f71763          	bne	a4,a5,80005b38 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800059ee:	100017b7          	lui	a5,0x10001
    800059f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800059f6:	4705                	li	a4,1
    800059f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800059fa:	470d                	li	a4,3
    800059fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800059fe:	10001737          	lui	a4,0x10001
    80005a02:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005a04:	c7ffe737          	lui	a4,0xc7ffe
    80005a08:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda817>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005a0c:	8ef9                	and	a3,a3,a4
    80005a0e:	10001737          	lui	a4,0x10001
    80005a12:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a14:	472d                	li	a4,11
    80005a16:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a18:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005a1c:	439c                	lw	a5,0(a5)
    80005a1e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005a22:	8ba1                	andi	a5,a5,8
    80005a24:	12078063          	beqz	a5,80005b44 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005a28:	100017b7          	lui	a5,0x10001
    80005a2c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005a30:	100017b7          	lui	a5,0x10001
    80005a34:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005a38:	439c                	lw	a5,0(a5)
    80005a3a:	2781                	sext.w	a5,a5
    80005a3c:	10079a63          	bnez	a5,80005b50 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005a40:	100017b7          	lui	a5,0x10001
    80005a44:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005a48:	439c                	lw	a5,0(a5)
    80005a4a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005a4c:	10078863          	beqz	a5,80005b5c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005a50:	471d                	li	a4,7
    80005a52:	10f77b63          	bgeu	a4,a5,80005b68 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005a56:	8cefb0ef          	jal	80000b24 <kalloc>
    80005a5a:	0001e497          	auipc	s1,0x1e
    80005a5e:	3ae48493          	addi	s1,s1,942 # 80023e08 <disk>
    80005a62:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005a64:	8c0fb0ef          	jal	80000b24 <kalloc>
    80005a68:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005a6a:	8bafb0ef          	jal	80000b24 <kalloc>
    80005a6e:	87aa                	mv	a5,a0
    80005a70:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005a72:	6088                	ld	a0,0(s1)
    80005a74:	10050063          	beqz	a0,80005b74 <virtio_disk_init+0x1ec>
    80005a78:	0001e717          	auipc	a4,0x1e
    80005a7c:	39873703          	ld	a4,920(a4) # 80023e10 <disk+0x8>
    80005a80:	0e070a63          	beqz	a4,80005b74 <virtio_disk_init+0x1ec>
    80005a84:	0e078863          	beqz	a5,80005b74 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005a88:	6605                	lui	a2,0x1
    80005a8a:	4581                	li	a1,0
    80005a8c:	a3cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005a90:	0001e497          	auipc	s1,0x1e
    80005a94:	37848493          	addi	s1,s1,888 # 80023e08 <disk>
    80005a98:	6605                	lui	a2,0x1
    80005a9a:	4581                	li	a1,0
    80005a9c:	6488                	ld	a0,8(s1)
    80005a9e:	a2afb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005aa2:	6605                	lui	a2,0x1
    80005aa4:	4581                	li	a1,0
    80005aa6:	6888                	ld	a0,16(s1)
    80005aa8:	a20fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005aac:	100017b7          	lui	a5,0x10001
    80005ab0:	4721                	li	a4,8
    80005ab2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005ab4:	4098                	lw	a4,0(s1)
    80005ab6:	100017b7          	lui	a5,0x10001
    80005aba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005abe:	40d8                	lw	a4,4(s1)
    80005ac0:	100017b7          	lui	a5,0x10001
    80005ac4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005ac8:	649c                	ld	a5,8(s1)
    80005aca:	0007869b          	sext.w	a3,a5
    80005ace:	10001737          	lui	a4,0x10001
    80005ad2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005ad6:	9781                	srai	a5,a5,0x20
    80005ad8:	10001737          	lui	a4,0x10001
    80005adc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005ae0:	689c                	ld	a5,16(s1)
    80005ae2:	0007869b          	sext.w	a3,a5
    80005ae6:	10001737          	lui	a4,0x10001
    80005aea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005aee:	9781                	srai	a5,a5,0x20
    80005af0:	10001737          	lui	a4,0x10001
    80005af4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005af8:	10001737          	lui	a4,0x10001
    80005afc:	4785                	li	a5,1
    80005afe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005b00:	00f48c23          	sb	a5,24(s1)
    80005b04:	00f48ca3          	sb	a5,25(s1)
    80005b08:	00f48d23          	sb	a5,26(s1)
    80005b0c:	00f48da3          	sb	a5,27(s1)
    80005b10:	00f48e23          	sb	a5,28(s1)
    80005b14:	00f48ea3          	sb	a5,29(s1)
    80005b18:	00f48f23          	sb	a5,30(s1)
    80005b1c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005b20:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b24:	100017b7          	lui	a5,0x10001
    80005b28:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005b2c:	60e2                	ld	ra,24(sp)
    80005b2e:	6442                	ld	s0,16(sp)
    80005b30:	64a2                	ld	s1,8(sp)
    80005b32:	6902                	ld	s2,0(sp)
    80005b34:	6105                	addi	sp,sp,32
    80005b36:	8082                	ret
    panic("could not find virtio disk");
    80005b38:	00002517          	auipc	a0,0x2
    80005b3c:	bc850513          	addi	a0,a0,-1080 # 80007700 <etext+0x700>
    80005b40:	c55fa0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005b44:	00002517          	auipc	a0,0x2
    80005b48:	bdc50513          	addi	a0,a0,-1060 # 80007720 <etext+0x720>
    80005b4c:	c49fa0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005b50:	00002517          	auipc	a0,0x2
    80005b54:	bf050513          	addi	a0,a0,-1040 # 80007740 <etext+0x740>
    80005b58:	c3dfa0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    80005b5c:	00002517          	auipc	a0,0x2
    80005b60:	c0450513          	addi	a0,a0,-1020 # 80007760 <etext+0x760>
    80005b64:	c31fa0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005b68:	00002517          	auipc	a0,0x2
    80005b6c:	c1850513          	addi	a0,a0,-1000 # 80007780 <etext+0x780>
    80005b70:	c25fa0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005b74:	00002517          	auipc	a0,0x2
    80005b78:	c2c50513          	addi	a0,a0,-980 # 800077a0 <etext+0x7a0>
    80005b7c:	c19fa0ef          	jal	80000794 <panic>

0000000080005b80 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005b80:	7159                	addi	sp,sp,-112
    80005b82:	f486                	sd	ra,104(sp)
    80005b84:	f0a2                	sd	s0,96(sp)
    80005b86:	eca6                	sd	s1,88(sp)
    80005b88:	e8ca                	sd	s2,80(sp)
    80005b8a:	e4ce                	sd	s3,72(sp)
    80005b8c:	e0d2                	sd	s4,64(sp)
    80005b8e:	fc56                	sd	s5,56(sp)
    80005b90:	f85a                	sd	s6,48(sp)
    80005b92:	f45e                	sd	s7,40(sp)
    80005b94:	f062                	sd	s8,32(sp)
    80005b96:	ec66                	sd	s9,24(sp)
    80005b98:	1880                	addi	s0,sp,112
    80005b9a:	8a2a                	mv	s4,a0
    80005b9c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005b9e:	00c52c83          	lw	s9,12(a0)
    80005ba2:	001c9c9b          	slliw	s9,s9,0x1
    80005ba6:	1c82                	slli	s9,s9,0x20
    80005ba8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005bac:	0001e517          	auipc	a0,0x1e
    80005bb0:	38450513          	addi	a0,a0,900 # 80023f30 <disk+0x128>
    80005bb4:	840fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005bb8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005bba:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005bbc:	0001eb17          	auipc	s6,0x1e
    80005bc0:	24cb0b13          	addi	s6,s6,588 # 80023e08 <disk>
  for(int i = 0; i < 3; i++){
    80005bc4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005bc6:	0001ec17          	auipc	s8,0x1e
    80005bca:	36ac0c13          	addi	s8,s8,874 # 80023f30 <disk+0x128>
    80005bce:	a8b9                	j	80005c2c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005bd0:	00fb0733          	add	a4,s6,a5
    80005bd4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005bd8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005bda:	0207c563          	bltz	a5,80005c04 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005bde:	2905                	addiw	s2,s2,1
    80005be0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005be2:	05590963          	beq	s2,s5,80005c34 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005be6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005be8:	0001e717          	auipc	a4,0x1e
    80005bec:	22070713          	addi	a4,a4,544 # 80023e08 <disk>
    80005bf0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005bf2:	01874683          	lbu	a3,24(a4)
    80005bf6:	fee9                	bnez	a3,80005bd0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005bf8:	2785                	addiw	a5,a5,1
    80005bfa:	0705                	addi	a4,a4,1
    80005bfc:	fe979be3          	bne	a5,s1,80005bf2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005c00:	57fd                	li	a5,-1
    80005c02:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005c04:	01205d63          	blez	s2,80005c1e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005c08:	f9042503          	lw	a0,-112(s0)
    80005c0c:	d07ff0ef          	jal	80005912 <free_desc>
      for(int j = 0; j < i; j++)
    80005c10:	4785                	li	a5,1
    80005c12:	0127d663          	bge	a5,s2,80005c1e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005c16:	f9442503          	lw	a0,-108(s0)
    80005c1a:	cf9ff0ef          	jal	80005912 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005c1e:	85e2                	mv	a1,s8
    80005c20:	0001e517          	auipc	a0,0x1e
    80005c24:	20050513          	addi	a0,a0,512 # 80023e20 <disk+0x18>
    80005c28:	fa1fb0ef          	jal	80001bc8 <sleep>
  for(int i = 0; i < 3; i++){
    80005c2c:	f9040613          	addi	a2,s0,-112
    80005c30:	894e                	mv	s2,s3
    80005c32:	bf55                	j	80005be6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c34:	f9042503          	lw	a0,-112(s0)
    80005c38:	00451693          	slli	a3,a0,0x4

  if(write)
    80005c3c:	0001e797          	auipc	a5,0x1e
    80005c40:	1cc78793          	addi	a5,a5,460 # 80023e08 <disk>
    80005c44:	00a50713          	addi	a4,a0,10
    80005c48:	0712                	slli	a4,a4,0x4
    80005c4a:	973e                	add	a4,a4,a5
    80005c4c:	01703633          	snez	a2,s7
    80005c50:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005c52:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005c56:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005c5a:	6398                	ld	a4,0(a5)
    80005c5c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c5e:	0a868613          	addi	a2,a3,168
    80005c62:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005c64:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005c66:	6390                	ld	a2,0(a5)
    80005c68:	00d605b3          	add	a1,a2,a3
    80005c6c:	4741                	li	a4,16
    80005c6e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005c70:	4805                	li	a6,1
    80005c72:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005c76:	f9442703          	lw	a4,-108(s0)
    80005c7a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005c7e:	0712                	slli	a4,a4,0x4
    80005c80:	963a                	add	a2,a2,a4
    80005c82:	058a0593          	addi	a1,s4,88
    80005c86:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005c88:	0007b883          	ld	a7,0(a5)
    80005c8c:	9746                	add	a4,a4,a7
    80005c8e:	40000613          	li	a2,1024
    80005c92:	c710                	sw	a2,8(a4)
  if(write)
    80005c94:	001bb613          	seqz	a2,s7
    80005c98:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005c9c:	00166613          	ori	a2,a2,1
    80005ca0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005ca4:	f9842583          	lw	a1,-104(s0)
    80005ca8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005cac:	00250613          	addi	a2,a0,2
    80005cb0:	0612                	slli	a2,a2,0x4
    80005cb2:	963e                	add	a2,a2,a5
    80005cb4:	577d                	li	a4,-1
    80005cb6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005cba:	0592                	slli	a1,a1,0x4
    80005cbc:	98ae                	add	a7,a7,a1
    80005cbe:	03068713          	addi	a4,a3,48
    80005cc2:	973e                	add	a4,a4,a5
    80005cc4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005cc8:	6398                	ld	a4,0(a5)
    80005cca:	972e                	add	a4,a4,a1
    80005ccc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005cd0:	4689                	li	a3,2
    80005cd2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005cd6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005cda:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005cde:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005ce2:	6794                	ld	a3,8(a5)
    80005ce4:	0026d703          	lhu	a4,2(a3)
    80005ce8:	8b1d                	andi	a4,a4,7
    80005cea:	0706                	slli	a4,a4,0x1
    80005cec:	96ba                	add	a3,a3,a4
    80005cee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005cf2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005cf6:	6798                	ld	a4,8(a5)
    80005cf8:	00275783          	lhu	a5,2(a4)
    80005cfc:	2785                	addiw	a5,a5,1
    80005cfe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005d02:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005d06:	100017b7          	lui	a5,0x10001
    80005d0a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005d0e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005d12:	0001e917          	auipc	s2,0x1e
    80005d16:	21e90913          	addi	s2,s2,542 # 80023f30 <disk+0x128>
  while(b->disk == 1) {
    80005d1a:	4485                	li	s1,1
    80005d1c:	01079a63          	bne	a5,a6,80005d30 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005d20:	85ca                	mv	a1,s2
    80005d22:	8552                	mv	a0,s4
    80005d24:	ea5fb0ef          	jal	80001bc8 <sleep>
  while(b->disk == 1) {
    80005d28:	004a2783          	lw	a5,4(s4)
    80005d2c:	fe978ae3          	beq	a5,s1,80005d20 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005d30:	f9042903          	lw	s2,-112(s0)
    80005d34:	00290713          	addi	a4,s2,2
    80005d38:	0712                	slli	a4,a4,0x4
    80005d3a:	0001e797          	auipc	a5,0x1e
    80005d3e:	0ce78793          	addi	a5,a5,206 # 80023e08 <disk>
    80005d42:	97ba                	add	a5,a5,a4
    80005d44:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005d48:	0001e997          	auipc	s3,0x1e
    80005d4c:	0c098993          	addi	s3,s3,192 # 80023e08 <disk>
    80005d50:	00491713          	slli	a4,s2,0x4
    80005d54:	0009b783          	ld	a5,0(s3)
    80005d58:	97ba                	add	a5,a5,a4
    80005d5a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005d5e:	854a                	mv	a0,s2
    80005d60:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005d64:	bafff0ef          	jal	80005912 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005d68:	8885                	andi	s1,s1,1
    80005d6a:	f0fd                	bnez	s1,80005d50 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005d6c:	0001e517          	auipc	a0,0x1e
    80005d70:	1c450513          	addi	a0,a0,452 # 80023f30 <disk+0x128>
    80005d74:	f19fa0ef          	jal	80000c8c <release>
}
    80005d78:	70a6                	ld	ra,104(sp)
    80005d7a:	7406                	ld	s0,96(sp)
    80005d7c:	64e6                	ld	s1,88(sp)
    80005d7e:	6946                	ld	s2,80(sp)
    80005d80:	69a6                	ld	s3,72(sp)
    80005d82:	6a06                	ld	s4,64(sp)
    80005d84:	7ae2                	ld	s5,56(sp)
    80005d86:	7b42                	ld	s6,48(sp)
    80005d88:	7ba2                	ld	s7,40(sp)
    80005d8a:	7c02                	ld	s8,32(sp)
    80005d8c:	6ce2                	ld	s9,24(sp)
    80005d8e:	6165                	addi	sp,sp,112
    80005d90:	8082                	ret

0000000080005d92 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005d92:	1101                	addi	sp,sp,-32
    80005d94:	ec06                	sd	ra,24(sp)
    80005d96:	e822                	sd	s0,16(sp)
    80005d98:	e426                	sd	s1,8(sp)
    80005d9a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005d9c:	0001e497          	auipc	s1,0x1e
    80005da0:	06c48493          	addi	s1,s1,108 # 80023e08 <disk>
    80005da4:	0001e517          	auipc	a0,0x1e
    80005da8:	18c50513          	addi	a0,a0,396 # 80023f30 <disk+0x128>
    80005dac:	e49fa0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005db0:	100017b7          	lui	a5,0x10001
    80005db4:	53b8                	lw	a4,96(a5)
    80005db6:	8b0d                	andi	a4,a4,3
    80005db8:	100017b7          	lui	a5,0x10001
    80005dbc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005dbe:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005dc2:	689c                	ld	a5,16(s1)
    80005dc4:	0204d703          	lhu	a4,32(s1)
    80005dc8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005dcc:	04f70663          	beq	a4,a5,80005e18 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005dd0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005dd4:	6898                	ld	a4,16(s1)
    80005dd6:	0204d783          	lhu	a5,32(s1)
    80005dda:	8b9d                	andi	a5,a5,7
    80005ddc:	078e                	slli	a5,a5,0x3
    80005dde:	97ba                	add	a5,a5,a4
    80005de0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005de2:	00278713          	addi	a4,a5,2
    80005de6:	0712                	slli	a4,a4,0x4
    80005de8:	9726                	add	a4,a4,s1
    80005dea:	01074703          	lbu	a4,16(a4)
    80005dee:	e321                	bnez	a4,80005e2e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005df0:	0789                	addi	a5,a5,2
    80005df2:	0792                	slli	a5,a5,0x4
    80005df4:	97a6                	add	a5,a5,s1
    80005df6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005df8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005dfc:	cbafc0ef          	jal	800022b6 <wakeup>

    disk.used_idx += 1;
    80005e00:	0204d783          	lhu	a5,32(s1)
    80005e04:	2785                	addiw	a5,a5,1
    80005e06:	17c2                	slli	a5,a5,0x30
    80005e08:	93c1                	srli	a5,a5,0x30
    80005e0a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005e0e:	6898                	ld	a4,16(s1)
    80005e10:	00275703          	lhu	a4,2(a4)
    80005e14:	faf71ee3          	bne	a4,a5,80005dd0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005e18:	0001e517          	auipc	a0,0x1e
    80005e1c:	11850513          	addi	a0,a0,280 # 80023f30 <disk+0x128>
    80005e20:	e6dfa0ef          	jal	80000c8c <release>
}
    80005e24:	60e2                	ld	ra,24(sp)
    80005e26:	6442                	ld	s0,16(sp)
    80005e28:	64a2                	ld	s1,8(sp)
    80005e2a:	6105                	addi	sp,sp,32
    80005e2c:	8082                	ret
      panic("virtio_disk_intr status");
    80005e2e:	00002517          	auipc	a0,0x2
    80005e32:	98a50513          	addi	a0,a0,-1654 # 800077b8 <etext+0x7b8>
    80005e36:	95ffa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
