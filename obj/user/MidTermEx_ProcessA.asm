
obj/user/MidTermEx_ProcessA:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 36 01 00 00       	call   80016c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 e6 19 00 00       	call   801a29 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 33 80 00       	push   $0x8033a0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 9a 14 00 00       	call   8014f0 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 33 80 00       	push   $0x8033a2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 84 14 00 00       	call   8014f0 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 33 80 00       	push   $0x8033a9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 6e 14 00 00       	call   8014f0 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 c8 19 00 00       	call   801a5c <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 e1 2d 00 00       	call   802e9d <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 87 19 00 00       	call   801a5c <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 a0 2d 00 00       	call   802e9d <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 48 19 00 00       	call   801a5c <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 61 2d 00 00       	call   802e9d <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 13                	jne    80015c <_main+0x124>
	{
		sys_signalSemaphore(parentenvID, "T") ;
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 b7 33 80 00       	push   $0x8033b7
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 8f 17 00 00       	call   8018e8 <sys_signalSemaphore>
  800159:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	8d 50 01             	lea    0x1(%eax),%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	89 10                	mov    %edx,(%eax)

}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800172:	e8 99 18 00 00       	call   801a10 <sys_getenvindex>
  800177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 e0 03             	shl    $0x3,%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018f:	01 d0                	add    %edx,%eax
  800191:	c1 e0 04             	shl    $0x4,%eax
  800194:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800199:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019e:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a9:	84 c0                	test   %al,%al
  8001ab:	74 0f                	je     8001bc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b2:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b7:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c0:	7e 0a                	jle    8001cc <libmain+0x60>
		binaryname = argv[0];
  8001c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c5:	8b 00                	mov    (%eax),%eax
  8001c7:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	e8 5e fe ff ff       	call   800038 <_main>
  8001da:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dd:	e8 3b 16 00 00       	call   80181d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 d4 33 80 00       	push   $0x8033d4
  8001ea:	e8 8d 01 00 00       	call   80037c <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800202:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 fc 33 80 00       	push   $0x8033fc
  800212:	e8 65 01 00 00       	call   80037c <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800230:	a1 20 40 80 00       	mov    0x804020,%eax
  800235:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023b:	51                   	push   %ecx
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 24 34 80 00       	push   $0x803424
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 7c 34 80 00       	push   $0x80347c
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 d4 33 80 00       	push   $0x8033d4
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 bb 15 00 00       	call   801837 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027c:	e8 19 00 00 00       	call   80029a <exit>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	e8 48 17 00 00       	call   8019dc <sys_destroy_env>
  800294:	83 c4 10             	add    $0x10,%esp
}
  800297:	90                   	nop
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <exit>:

void
exit(void)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a0:	e8 9d 17 00 00       	call   801a42 <sys_exit_env>
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b9:	89 0a                	mov    %ecx,(%edx)
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	88 d1                	mov    %dl,%cl
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d1:	75 2c                	jne    8002ff <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d3:	a0 24 40 80 00       	mov    0x804024,%al
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	8b 12                	mov    (%edx),%edx
  8002e0:	89 d1                	mov    %edx,%ecx
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	83 c2 08             	add    $0x8,%edx
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	50                   	push   %eax
  8002ec:	51                   	push   %ecx
  8002ed:	52                   	push   %edx
  8002ee:	e8 7c 13 00 00       	call   80166f <sys_cputs>
  8002f3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	8b 40 04             	mov    0x4(%eax),%eax
  800305:	8d 50 01             	lea    0x1(%eax),%edx
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	68 a8 02 80 00       	push   $0x8002a8
  800340:	e8 11 02 00 00       	call   800556 <vprintfmt>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800348:	a0 24 40 80 00       	mov    0x804024,%al
  80034d:	0f b6 c0             	movzbl %al,%eax
  800350:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	50                   	push   %eax
  80035a:	52                   	push   %edx
  80035b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800361:	83 c0 08             	add    $0x8,%eax
  800364:	50                   	push   %eax
  800365:	e8 05 13 00 00       	call   80166f <sys_cputs>
  80036a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036d:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800374:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf>:

int cprintf(const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800382:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 73 ff ff ff       	call   800311 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003af:	e8 69 14 00 00       	call   80181d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	e8 48 ff ff ff       	call   800311 <vcprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003cf:	e8 63 14 00 00       	call   801837 <sys_enable_interrupt>
	return cnt;
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 14             	sub    $0x14,%esp
  8003e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f7:	77 55                	ja     80044e <printnum+0x75>
  8003f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fc:	72 05                	jb     800403 <printnum+0x2a>
  8003fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800401:	77 4b                	ja     80044e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800403:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800406:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800409:	8b 45 18             	mov    0x18(%ebp),%eax
  80040c:	ba 00 00 00 00       	mov    $0x0,%edx
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	ff 75 f4             	pushl  -0xc(%ebp)
  800416:	ff 75 f0             	pushl  -0x10(%ebp)
  800419:	e8 16 2d 00 00       	call   803134 <__udivdi3>
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 20             	pushl  0x20(%ebp)
  800427:	53                   	push   %ebx
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	ff 75 0c             	pushl  0xc(%ebp)
  800430:	ff 75 08             	pushl  0x8(%ebp)
  800433:	e8 a1 ff ff ff       	call   8003d9 <printnum>
  800438:	83 c4 20             	add    $0x20,%esp
  80043b:	eb 1a                	jmp    800457 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 20             	pushl  0x20(%ebp)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	ff d0                	call   *%eax
  80044b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044e:	ff 4d 1c             	decl   0x1c(%ebp)
  800451:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800455:	7f e6                	jg     80043d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800457:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	53                   	push   %ebx
  800466:	51                   	push   %ecx
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	e8 d6 2d 00 00       	call   803244 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 b4 36 80 00       	add    $0x8036b4,%eax
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f be c0             	movsbl %al,%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
}
  80048a:	90                   	nop
  80048b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 1c                	jle    8004b5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 08             	lea    0x8(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 08             	sub    $0x8,%eax
  8004ae:	8b 50 04             	mov    0x4(%eax),%edx
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	eb 40                	jmp    8004f5 <getuint+0x65>
	else if (lflag)
  8004b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b9:	74 1e                	je     8004d9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 04             	lea    0x4(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 04             	sub    $0x4,%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	eb 1c                	jmp    8004f5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	89 10                	mov    %edx,(%eax)
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	83 e8 04             	sub    $0x4,%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fe:	7e 1c                	jle    80051c <getint+0x25>
		return va_arg(*ap, long long);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	8d 50 08             	lea    0x8(%eax),%edx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	89 10                	mov    %edx,(%eax)
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	83 e8 08             	sub    $0x8,%eax
  800515:	8b 50 04             	mov    0x4(%eax),%edx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	eb 38                	jmp    800554 <getint+0x5d>
	else if (lflag)
  80051c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800520:	74 1a                	je     80053c <getint+0x45>
		return va_arg(*ap, long);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	eb 18                	jmp    800554 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 04             	lea    0x4(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	99                   	cltd   
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055e:	eb 17                	jmp    800577 <vprintfmt+0x21>
			if (ch == '\0')
  800560:	85 db                	test   %ebx,%ebx
  800562:	0f 84 af 03 00 00    	je     800917 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	53                   	push   %ebx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	ff d0                	call   *%eax
  800574:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800577:	8b 45 10             	mov    0x10(%ebp),%eax
  80057a:	8d 50 01             	lea    0x1(%eax),%edx
  80057d:	89 55 10             	mov    %edx,0x10(%ebp)
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f b6 d8             	movzbl %al,%ebx
  800585:	83 fb 25             	cmp    $0x25,%ebx
  800588:	75 d6                	jne    800560 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800595:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8d 50 01             	lea    0x1(%eax),%edx
  8005b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b3:	8a 00                	mov    (%eax),%al
  8005b5:	0f b6 d8             	movzbl %al,%ebx
  8005b8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005bb:	83 f8 55             	cmp    $0x55,%eax
  8005be:	0f 87 2b 03 00 00    	ja     8008ef <vprintfmt+0x399>
  8005c4:	8b 04 85 d8 36 80 00 	mov    0x8036d8(,%eax,4),%eax
  8005cb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d1:	eb d7                	jmp    8005aa <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d7:	eb d1                	jmp    8005aa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	01 d8                	add    %ebx,%eax
  8005ee:	83 e8 30             	sub    $0x30,%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f7:	8a 00                	mov    (%eax),%al
  8005f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ff:	7e 3e                	jle    80063f <vprintfmt+0xe9>
  800601:	83 fb 39             	cmp    $0x39,%ebx
  800604:	7f 39                	jg     80063f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800606:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800609:	eb d5                	jmp    8005e0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061f:	eb 1f                	jmp    800640 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	79 83                	jns    8005aa <vprintfmt+0x54>
				width = 0;
  800627:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062e:	e9 77 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80063a:	e9 6b ff ff ff       	jmp    8005aa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800644:	0f 89 60 ff ff ff    	jns    8005aa <vprintfmt+0x54>
				width = precision, precision = -1;
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800650:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800657:	e9 4e ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065f:	e9 46 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
			break;
  800684:	e9 89 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 c0 04             	add    $0x4,%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80069a:	85 db                	test   %ebx,%ebx
  80069c:	79 02                	jns    8006a0 <vprintfmt+0x14a>
				err = -err;
  80069e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a0:	83 fb 64             	cmp    $0x64,%ebx
  8006a3:	7f 0b                	jg     8006b0 <vprintfmt+0x15a>
  8006a5:	8b 34 9d 20 35 80 00 	mov    0x803520(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 c5 36 80 00       	push   $0x8036c5
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 5e 02 00 00       	call   80091f <printfmt>
  8006c1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c4:	e9 49 02 00 00       	jmp    800912 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c9:	56                   	push   %esi
  8006ca:	68 ce 36 80 00       	push   $0x8036ce
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 45 02 00 00       	call   80091f <printfmt>
  8006da:	83 c4 10             	add    $0x10,%esp
			break;
  8006dd:	e9 30 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	83 c0 04             	add    $0x4,%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 30                	mov    (%eax),%esi
  8006f3:	85 f6                	test   %esi,%esi
  8006f5:	75 05                	jne    8006fc <vprintfmt+0x1a6>
				p = "(null)";
  8006f7:	be d1 36 80 00       	mov    $0x8036d1,%esi
			if (width > 0 && padc != '-')
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	7e 6d                	jle    80076f <vprintfmt+0x219>
  800702:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800706:	74 67                	je     80076f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	50                   	push   %eax
  80070f:	56                   	push   %esi
  800710:	e8 0c 03 00 00       	call   800a21 <strnlen>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071b:	eb 16                	jmp    800733 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	ff 4d e4             	decl   -0x1c(%ebp)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	7f e4                	jg     80071d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800739:	eb 34                	jmp    80076f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073f:	74 1c                	je     80075d <vprintfmt+0x207>
  800741:	83 fb 1f             	cmp    $0x1f,%ebx
  800744:	7e 05                	jle    80074b <vprintfmt+0x1f5>
  800746:	83 fb 7e             	cmp    $0x7e,%ebx
  800749:	7e 12                	jle    80075d <vprintfmt+0x207>
					putch('?', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	6a 3f                	push   $0x3f
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb 0f                	jmp    80076c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	89 f0                	mov    %esi,%eax
  800771:	8d 70 01             	lea    0x1(%eax),%esi
  800774:	8a 00                	mov    (%eax),%al
  800776:	0f be d8             	movsbl %al,%ebx
  800779:	85 db                	test   %ebx,%ebx
  80077b:	74 24                	je     8007a1 <vprintfmt+0x24b>
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	78 b8                	js     80073b <vprintfmt+0x1e5>
  800783:	ff 4d e0             	decl   -0x20(%ebp)
  800786:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078a:	79 af                	jns    80073b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078c:	eb 13                	jmp    8007a1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 20                	push   $0x20
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a5:	7f e7                	jg     80078e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a7:	e9 66 01 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 3c fd ff ff       	call   8004f7 <getint>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	79 23                	jns    8007f1 <vprintfmt+0x29b>
				putch('-', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 2d                	push   $0x2d
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f8:	e9 bc 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 e8             	pushl  -0x18(%ebp)
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	e8 84 fc ff ff       	call   800490 <getuint>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800815:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081c:	e9 98 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	6a 58                	push   $0x58
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	6a 58                	push   $0x58
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	6a 58                	push   $0x58
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			break;
  800851:	e9 bc 00 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 30                	push   $0x30
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 78                	push   $0x78
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800891:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800898:	eb 1f                	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	50                   	push   %eax
  8008a4:	e8 e7 fb ff ff       	call   800490 <getuint>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	52                   	push   %edx
  8008c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 00 fb ff ff       	call   8003d9 <printnum>
  8008d9:	83 c4 20             	add    $0x20,%esp
			break;
  8008dc:	eb 34                	jmp    800912 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
			break;
  8008ed:	eb 23                	jmp    800912 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	6a 25                	push   $0x25
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ff:	ff 4d 10             	decl   0x10(%ebp)
  800902:	eb 03                	jmp    800907 <vprintfmt+0x3b1>
  800904:	ff 4d 10             	decl   0x10(%ebp)
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	48                   	dec    %eax
  80090b:	8a 00                	mov    (%eax),%al
  80090d:	3c 25                	cmp    $0x25,%al
  80090f:	75 f3                	jne    800904 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800911:	90                   	nop
		}
	}
  800912:	e9 47 fc ff ff       	jmp    80055e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800917:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800925:	8d 45 10             	lea    0x10(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	ff 75 f4             	pushl  -0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 16 fc ff ff       	call   800556 <vprintfmt>
  800940:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800943:	90                   	nop
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	8b 40 08             	mov    0x8(%eax),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	39 c2                	cmp    %eax,%edx
  800965:	73 12                	jae    800979 <sprintputch+0x33>
		*b->buf++ = ch;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 48 01             	lea    0x1(%eax),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800972:	89 0a                	mov    %ecx,(%edx)
  800974:	8b 55 08             	mov    0x8(%ebp),%edx
  800977:	88 10                	mov    %dl,(%eax)
}
  800979:	90                   	nop
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a1:	74 06                	je     8009a9 <vsnprintf+0x2d>
  8009a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a7:	7f 07                	jg     8009b0 <vsnprintf+0x34>
		return -E_INVAL;
  8009a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ae:	eb 20                	jmp    8009d0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 46 09 80 00       	push   $0x800946
  8009bf:	e8 92 fb ff ff       	call   800556 <vprintfmt>
  8009c4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 89 ff ff ff       	call   80097c <vsnprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0b:	eb 06                	jmp    800a13 <strlen+0x15>
		n++;
  800a0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a10:	ff 45 08             	incl   0x8(%ebp)
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	84 c0                	test   %al,%al
  800a1a:	75 f1                	jne    800a0d <strlen+0xf>
		n++;
	return n;
  800a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2e:	eb 09                	jmp    800a39 <strnlen+0x18>
		n++;
  800a30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a33:	ff 45 08             	incl   0x8(%ebp)
  800a36:	ff 4d 0c             	decl   0xc(%ebp)
  800a39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3d:	74 09                	je     800a48 <strnlen+0x27>
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e8                	jne    800a30 <strnlen+0xf>
		n++;
	return n;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a59:	90                   	nop
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8d 50 01             	lea    0x1(%eax),%edx
  800a60:	89 55 08             	mov    %edx,0x8(%ebp)
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6c:	8a 12                	mov    (%edx),%dl
  800a6e:	88 10                	mov    %dl,(%eax)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	84 c0                	test   %al,%al
  800a74:	75 e4                	jne    800a5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8e:	eb 1f                	jmp    800aaf <strncpy+0x34>
		*dst++ = *src;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8d 50 01             	lea    0x1(%eax),%edx
  800a96:	89 55 08             	mov    %edx,0x8(%ebp)
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	8a 12                	mov    (%edx),%dl
  800a9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 03                	je     800aac <strncpy+0x31>
			src++;
  800aa9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aac:	ff 45 fc             	incl   -0x4(%ebp)
  800aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab5:	72 d9                	jb     800a90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	74 30                	je     800afe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ace:	eb 16                	jmp    800ae6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800adf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae2:	8a 12                	mov    (%edx),%dl
  800ae4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae6:	ff 4d 10             	decl   0x10(%ebp)
  800ae9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aed:	74 09                	je     800af8 <strlcpy+0x3c>
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 d8                	jne    800ad0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0d:	eb 06                	jmp    800b15 <strcmp+0xb>
		p++, q++;
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	74 0e                	je     800b2c <strcmp+0x22>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 10                	mov    (%eax),%dl
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	38 c2                	cmp    %al,%dl
  800b2a:	74 e3                	je     800b0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	0f b6 d0             	movzbl %al,%edx
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	29 c2                	sub    %eax,%edx
  800b3e:	89 d0                	mov    %edx,%eax
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b45:	eb 09                	jmp    800b50 <strncmp+0xe>
		n--, p++, q++;
  800b47:	ff 4d 10             	decl   0x10(%ebp)
  800b4a:	ff 45 08             	incl   0x8(%ebp)
  800b4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b54:	74 17                	je     800b6d <strncmp+0x2b>
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	74 0e                	je     800b6d <strncmp+0x2b>
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8a 10                	mov    (%eax),%dl
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	38 c2                	cmp    %al,%dl
  800b6b:	74 da                	je     800b47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	75 07                	jne    800b7a <strncmp+0x38>
		return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	eb 14                	jmp    800b8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d0             	movzbl %al,%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	29 c2                	sub    %eax,%edx
  800b8c:	89 d0                	mov    %edx,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9c:	eb 12                	jmp    800bb0 <strchr+0x20>
		if (*s == c)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba6:	75 05                	jne    800bad <strchr+0x1d>
			return (char *) s;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	eb 11                	jmp    800bbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 e5                	jne    800b9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcc:	eb 0d                	jmp    800bdb <strfind+0x1b>
		if (*s == c)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd6:	74 0e                	je     800be6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 ea                	jne    800bce <strfind+0xe>
  800be4:	eb 01                	jmp    800be7 <strfind+0x27>
		if (*s == c)
			break;
  800be6:	90                   	nop
	return (char *) s;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfe:	eb 0e                	jmp    800c0e <memset+0x22>
		*p++ = c;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0e:	ff 4d f8             	decl   -0x8(%ebp)
  800c11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c15:	79 e9                	jns    800c00 <memset+0x14>
		*p++ = c;

	return v;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2e:	eb 16                	jmp    800c46 <memcpy+0x2a>
		*d++ = *s++;
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 dd                	jne    800c30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c70:	73 50                	jae    800cc2 <memmove+0x6a>
  800c72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
  800c7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7d:	76 43                	jbe    800cc2 <memmove+0x6a>
		s += n;
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8b:	eb 10                	jmp    800c9d <memmove+0x45>
			*--d = *--s;
  800c8d:	ff 4d f8             	decl   -0x8(%ebp)
  800c90:	ff 4d fc             	decl   -0x4(%ebp)
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c96:	8a 10                	mov    (%eax),%dl
  800c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 e3                	jne    800c8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800caa:	eb 23                	jmp    800ccf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbe:	8a 12                	mov    (%edx),%dl
  800cc0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	75 dd                	jne    800cac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce6:	eb 2a                	jmp    800d12 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ceb:	8a 10                	mov    (%eax),%dl
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	38 c2                	cmp    %al,%dl
  800cf4:	74 16                	je     800d0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 d0             	movzbl %al,%edx
  800cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	29 c2                	sub    %eax,%edx
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	eb 18                	jmp    800d24 <memcmp+0x50>
		s1++, s2++;
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d18:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	75 c9                	jne    800ce8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d37:	eb 15                	jmp    800d4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 d0             	movzbl %al,%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	0f b6 c0             	movzbl %al,%eax
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	74 0d                	je     800d58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d54:	72 e3                	jb     800d39 <memfind+0x13>
  800d56:	eb 01                	jmp    800d59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d58:	90                   	nop
	return (void *) s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d72:	eb 03                	jmp    800d77 <strtol+0x19>
		s++;
  800d74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 20                	cmp    $0x20,%al
  800d7e:	74 f4                	je     800d74 <strtol+0x16>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 09                	cmp    $0x9,%al
  800d87:	74 eb                	je     800d74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 2b                	cmp    $0x2b,%al
  800d90:	75 05                	jne    800d97 <strtol+0x39>
		s++;
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	eb 13                	jmp    800daa <strtol+0x4c>
	else if (*s == '-')
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 2d                	cmp    $0x2d,%al
  800d9e:	75 0a                	jne    800daa <strtol+0x4c>
		s++, neg = 1;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 06                	je     800db6 <strtol+0x58>
  800db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db4:	75 20                	jne    800dd6 <strtol+0x78>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 30                	cmp    $0x30,%al
  800dbd:	75 17                	jne    800dd6 <strtol+0x78>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	40                   	inc    %eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 78                	cmp    $0x78,%al
  800dc7:	75 0d                	jne    800dd6 <strtol+0x78>
		s += 2, base = 16;
  800dc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd4:	eb 28                	jmp    800dfe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	75 15                	jne    800df1 <strtol+0x93>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 0c                	jne    800df1 <strtol+0x93>
		s++, base = 8;
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800def:	eb 0d                	jmp    800dfe <strtol+0xa0>
	else if (base == 0)
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	75 07                	jne    800dfe <strtol+0xa0>
		base = 10;
  800df7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 2f                	cmp    $0x2f,%al
  800e05:	7e 19                	jle    800e20 <strtol+0xc2>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 39                	cmp    $0x39,%al
  800e0e:	7f 10                	jg     800e20 <strtol+0xc2>
			dig = *s - '0';
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	83 e8 30             	sub    $0x30,%eax
  800e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1e:	eb 42                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 60                	cmp    $0x60,%al
  800e27:	7e 19                	jle    800e42 <strtol+0xe4>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 7a                	cmp    $0x7a,%al
  800e30:	7f 10                	jg     800e42 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f be c0             	movsbl %al,%eax
  800e3a:	83 e8 57             	sub    $0x57,%eax
  800e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e40:	eb 20                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	3c 40                	cmp    $0x40,%al
  800e49:	7e 39                	jle    800e84 <strtol+0x126>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 5a                	cmp    $0x5a,%al
  800e52:	7f 30                	jg     800e84 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f be c0             	movsbl %al,%eax
  800e5c:	83 e8 37             	sub    $0x37,%eax
  800e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e68:	7d 19                	jge    800e83 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7e:	e9 7b ff ff ff       	jmp    800dfe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e83:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e88:	74 08                	je     800e92 <strtol+0x134>
		*endptr = (char *) s;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e96:	74 07                	je     800e9f <strtol+0x141>
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	f7 d8                	neg    %eax
  800e9d:	eb 03                	jmp    800ea2 <strtol+0x144>
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebc:	79 13                	jns    800ed1 <ltostr+0x2d>
	{
		neg = 1;
  800ebe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ecb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ece:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed9:	99                   	cltd   
  800eda:	f7 f9                	idiv   %ecx
  800edc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 d0                	add    %edx,%eax
  800eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef2:	83 c2 30             	add    $0x30,%edx
  800ef5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eff:	f7 e9                	imul   %ecx
  800f01:	c1 fa 02             	sar    $0x2,%edx
  800f04:	89 c8                	mov    %ecx,%eax
  800f06:	c1 f8 1f             	sar    $0x1f,%eax
  800f09:	29 c2                	sub    %eax,%edx
  800f0b:	89 d0                	mov    %edx,%eax
  800f0d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f18:	f7 e9                	imul   %ecx
  800f1a:	c1 fa 02             	sar    $0x2,%edx
  800f1d:	89 c8                	mov    %ecx,%eax
  800f1f:	c1 f8 1f             	sar    $0x1f,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	c1 e0 02             	shl    $0x2,%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	01 c0                	add    %eax,%eax
  800f2d:	29 c1                	sub    %eax,%ecx
  800f2f:	89 ca                	mov    %ecx,%edx
  800f31:	85 d2                	test   %edx,%edx
  800f33:	75 9c                	jne    800ed1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	48                   	dec    %eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f47:	74 3d                	je     800f86 <ltostr+0xe2>
		start = 1 ;
  800f49:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f50:	eb 34                	jmp    800f86 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 c2                	add    %eax,%edx
  800f67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c8                	add    %ecx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	01 c2                	add    %eax,%edx
  800f7b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f80:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f83:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8c:	7c c4                	jl     800f52 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 54 fa ff ff       	call   8009fe <strlen>
  800faa:	83 c4 04             	add    $0x4,%esp
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	e8 46 fa ff ff       	call   8009fe <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcc:	eb 17                	jmp    800fe5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe2:	ff 45 fc             	incl   -0x4(%ebp)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	7c e1                	jl     800fce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 c8                	add    %ecx,%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801019:	ff 45 f8             	incl   -0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801022:	7c d9                	jl     800ffd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c6 00 00             	movb   $0x0,(%eax)
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801055:	eb 0c                	jmp    801063 <strsplit+0x31>
			*string++ = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 08             	mov    %edx,0x8(%ebp)
  801060:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 18                	je     801084 <strsplit+0x52>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f be c0             	movsbl %al,%eax
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	e8 13 fb ff ff       	call   800b90 <strchr>
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	75 d3                	jne    801057 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	74 5a                	je     8010e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	83 f8 0f             	cmp    $0xf,%eax
  801095:	75 07                	jne    80109e <strsplit+0x6c>
		{
			return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	eb 66                	jmp    801104 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a9:	89 0a                	mov    %ecx,(%edx)
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bc:	eb 03                	jmp    8010c1 <strsplit+0x8f>
			string++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 8b                	je     801055 <strsplit+0x23>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	e8 b5 fa ff ff       	call   800b90 <strchr>
  8010db:	83 c4 08             	add    $0x8,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	74 dc                	je     8010be <strsplit+0x8c>
			string++;
	}
  8010e2:	e9 6e ff ff ff       	jmp    801055 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110c:	a1 04 40 80 00       	mov    0x804004,%eax
  801111:	85 c0                	test   %eax,%eax
  801113:	74 1f                	je     801134 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801115:	e8 1d 00 00 00       	call   801137 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	68 30 38 80 00       	push   $0x803830
  801122:	e8 55 f2 ff ff       	call   80037c <cprintf>
  801127:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80112a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801131:	00 00 00 
	}
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80113d:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801144:	00 00 00 
  801147:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114e:	00 00 00 
  801151:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801158:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80115b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801162:	00 00 00 
  801165:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116c:	00 00 00 
  80116f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801176:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801179:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801180:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801183:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80118a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801194:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801199:	2d 00 10 00 00       	sub    $0x1000,%eax
  80119e:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8011a3:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8011aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011b7:	83 ec 04             	sub    $0x4,%esp
  8011ba:	6a 06                	push   $0x6
  8011bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bf:	50                   	push   %eax
  8011c0:	e8 ee 05 00 00       	call   8017b3 <sys_allocate_chunk>
  8011c5:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011c8:	a1 20 41 80 00       	mov    0x804120,%eax
  8011cd:	83 ec 0c             	sub    $0xc,%esp
  8011d0:	50                   	push   %eax
  8011d1:	e8 63 0c 00 00       	call   801e39 <initialize_MemBlocksList>
  8011d6:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8011d9:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8011de:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8011e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011e4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8011eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8011f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011fc:	89 c2                	mov    %eax,%edx
  8011fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801201:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801207:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80120e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801218:	8b 50 08             	mov    0x8(%eax),%edx
  80121b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121e:	01 d0                	add    %edx,%eax
  801220:	48                   	dec    %eax
  801221:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801224:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801227:	ba 00 00 00 00       	mov    $0x0,%edx
  80122c:	f7 75 e0             	divl   -0x20(%ebp)
  80122f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801232:	29 d0                	sub    %edx,%eax
  801234:	89 c2                	mov    %eax,%edx
  801236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801239:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80123c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801240:	75 14                	jne    801256 <initialize_dyn_block_system+0x11f>
  801242:	83 ec 04             	sub    $0x4,%esp
  801245:	68 55 38 80 00       	push   $0x803855
  80124a:	6a 34                	push   $0x34
  80124c:	68 73 38 80 00       	push   $0x803873
  801251:	e8 fb 1c 00 00       	call   802f51 <_panic>
  801256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801259:	8b 00                	mov    (%eax),%eax
  80125b:	85 c0                	test   %eax,%eax
  80125d:	74 10                	je     80126f <initialize_dyn_block_system+0x138>
  80125f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801267:	8b 52 04             	mov    0x4(%edx),%edx
  80126a:	89 50 04             	mov    %edx,0x4(%eax)
  80126d:	eb 0b                	jmp    80127a <initialize_dyn_block_system+0x143>
  80126f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801272:	8b 40 04             	mov    0x4(%eax),%eax
  801275:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80127a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80127d:	8b 40 04             	mov    0x4(%eax),%eax
  801280:	85 c0                	test   %eax,%eax
  801282:	74 0f                	je     801293 <initialize_dyn_block_system+0x15c>
  801284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801287:	8b 40 04             	mov    0x4(%eax),%eax
  80128a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80128d:	8b 12                	mov    (%edx),%edx
  80128f:	89 10                	mov    %edx,(%eax)
  801291:	eb 0a                	jmp    80129d <initialize_dyn_block_system+0x166>
  801293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	a3 48 41 80 00       	mov    %eax,0x804148
  80129d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8012a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012b0:	a1 54 41 80 00       	mov    0x804154,%eax
  8012b5:	48                   	dec    %eax
  8012b6:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	ff 75 e8             	pushl  -0x18(%ebp)
  8012c1:	e8 c4 13 00 00       	call   80268a <insert_sorted_with_merge_freeList>
  8012c6:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8012c9:	90                   	nop
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <malloc>:
//=================================



void* malloc(uint32 size)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012d2:	e8 2f fe ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012db:	75 07                	jne    8012e4 <malloc+0x18>
  8012dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e2:	eb 71                	jmp    801355 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8012e4:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8012eb:	76 07                	jbe    8012f4 <malloc+0x28>
	return NULL;
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f2:	eb 61                	jmp    801355 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012f4:	e8 88 08 00 00       	call   801b81 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	74 53                	je     801350 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8012fd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801304:	8b 55 08             	mov    0x8(%ebp),%edx
  801307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130a:	01 d0                	add    %edx,%eax
  80130c:	48                   	dec    %eax
  80130d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801313:	ba 00 00 00 00       	mov    $0x0,%edx
  801318:	f7 75 f4             	divl   -0xc(%ebp)
  80131b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131e:	29 d0                	sub    %edx,%eax
  801320:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	ff 75 ec             	pushl  -0x14(%ebp)
  801329:	e8 d2 0d 00 00       	call   802100 <alloc_block_FF>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801334:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801338:	74 16                	je     801350 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  80133a:	83 ec 0c             	sub    $0xc,%esp
  80133d:	ff 75 e8             	pushl  -0x18(%ebp)
  801340:	e8 0c 0c 00 00       	call   801f51 <insert_sorted_allocList>
  801345:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80134b:	8b 40 08             	mov    0x8(%eax),%eax
  80134e:	eb 05                	jmp    801355 <malloc+0x89>
    }

			}


	return NULL;
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801366:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	ff 75 f0             	pushl  -0x10(%ebp)
  801374:	68 40 40 80 00       	push   $0x804040
  801379:	e8 a0 0b 00 00       	call   801f1e <find_block>
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801387:	8b 50 0c             	mov    0xc(%eax),%edx
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	52                   	push   %edx
  801391:	50                   	push   %eax
  801392:	e8 e4 03 00 00       	call   80177b <sys_free_user_mem>
  801397:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80139a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80139e:	75 17                	jne    8013b7 <free+0x60>
  8013a0:	83 ec 04             	sub    $0x4,%esp
  8013a3:	68 55 38 80 00       	push   $0x803855
  8013a8:	68 84 00 00 00       	push   $0x84
  8013ad:	68 73 38 80 00       	push   $0x803873
  8013b2:	e8 9a 1b 00 00       	call   802f51 <_panic>
  8013b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ba:	8b 00                	mov    (%eax),%eax
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	74 10                	je     8013d0 <free+0x79>
  8013c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c3:	8b 00                	mov    (%eax),%eax
  8013c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c8:	8b 52 04             	mov    0x4(%edx),%edx
  8013cb:	89 50 04             	mov    %edx,0x4(%eax)
  8013ce:	eb 0b                	jmp    8013db <free+0x84>
  8013d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d3:	8b 40 04             	mov    0x4(%eax),%eax
  8013d6:	a3 44 40 80 00       	mov    %eax,0x804044
  8013db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013de:	8b 40 04             	mov    0x4(%eax),%eax
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	74 0f                	je     8013f4 <free+0x9d>
  8013e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e8:	8b 40 04             	mov    0x4(%eax),%eax
  8013eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ee:	8b 12                	mov    (%edx),%edx
  8013f0:	89 10                	mov    %edx,(%eax)
  8013f2:	eb 0a                	jmp    8013fe <free+0xa7>
  8013f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f7:	8b 00                	mov    (%eax),%eax
  8013f9:	a3 40 40 80 00       	mov    %eax,0x804040
  8013fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801407:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80140a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801411:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801416:	48                   	dec    %eax
  801417:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	ff 75 ec             	pushl  -0x14(%ebp)
  801422:	e8 63 12 00 00       	call   80268a <insert_sorted_with_merge_freeList>
  801427:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80142a:	90                   	nop
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 38             	sub    $0x38,%esp
  801433:	8b 45 10             	mov    0x10(%ebp),%eax
  801436:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801439:	e8 c8 fc ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  80143e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801442:	75 0a                	jne    80144e <smalloc+0x21>
  801444:	b8 00 00 00 00       	mov    $0x0,%eax
  801449:	e9 a0 00 00 00       	jmp    8014ee <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80144e:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801455:	76 0a                	jbe    801461 <smalloc+0x34>
		return NULL;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
  80145c:	e9 8d 00 00 00       	jmp    8014ee <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801461:	e8 1b 07 00 00       	call   801b81 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801466:	85 c0                	test   %eax,%eax
  801468:	74 7f                	je     8014e9 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80146a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801471:	8b 55 0c             	mov    0xc(%ebp),%edx
  801474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	48                   	dec    %eax
  80147a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801480:	ba 00 00 00 00       	mov    $0x0,%edx
  801485:	f7 75 f4             	divl   -0xc(%ebp)
  801488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148b:	29 d0                	sub    %edx,%eax
  80148d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801490:	83 ec 0c             	sub    $0xc,%esp
  801493:	ff 75 ec             	pushl  -0x14(%ebp)
  801496:	e8 65 0c 00 00       	call   802100 <alloc_block_FF>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8014a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014a5:	74 42                	je     8014e9 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ad:	e8 9f 0a 00 00       	call   801f51 <insert_sorted_allocList>
  8014b2:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8014b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b8:	8b 40 08             	mov    0x8(%eax),%eax
  8014bb:	89 c2                	mov    %eax,%edx
  8014bd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014c1:	52                   	push   %edx
  8014c2:	50                   	push   %eax
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	ff 75 08             	pushl  0x8(%ebp)
  8014c9:	e8 38 04 00 00       	call   801906 <sys_createSharedObject>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8014d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d8:	79 07                	jns    8014e1 <smalloc+0xb4>
	    		  return NULL;
  8014da:	b8 00 00 00 00       	mov    $0x0,%eax
  8014df:	eb 0d                	jmp    8014ee <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8014e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014e4:	8b 40 08             	mov    0x8(%eax),%eax
  8014e7:	eb 05                	jmp    8014ee <smalloc+0xc1>


				}


		return NULL;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f6:	e8 0b fc ff ff       	call   801106 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014fb:	e8 81 06 00 00       	call   801b81 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801500:	85 c0                	test   %eax,%eax
  801502:	0f 84 9f 00 00 00    	je     8015a7 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	ff 75 08             	pushl  0x8(%ebp)
  801511:	e8 1a 04 00 00       	call   801930 <sys_getSizeOfSharedObject>
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80151c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801520:	79 0a                	jns    80152c <sget+0x3c>
		return NULL;
  801522:	b8 00 00 00 00       	mov    $0x0,%eax
  801527:	e9 80 00 00 00       	jmp    8015ac <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80152c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801533:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801539:	01 d0                	add    %edx,%eax
  80153b:	48                   	dec    %eax
  80153c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80153f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801542:	ba 00 00 00 00       	mov    $0x0,%edx
  801547:	f7 75 f0             	divl   -0x10(%ebp)
  80154a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154d:	29 d0                	sub    %edx,%eax
  80154f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	ff 75 e8             	pushl  -0x18(%ebp)
  801558:	e8 a3 0b 00 00       	call   802100 <alloc_block_FF>
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801563:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801567:	74 3e                	je     8015a7 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801569:	83 ec 0c             	sub    $0xc,%esp
  80156c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80156f:	e8 dd 09 00 00       	call   801f51 <insert_sorted_allocList>
  801574:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80157a:	8b 40 08             	mov    0x8(%eax),%eax
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	50                   	push   %eax
  801581:	ff 75 0c             	pushl  0xc(%ebp)
  801584:	ff 75 08             	pushl  0x8(%ebp)
  801587:	e8 c1 03 00 00       	call   80194d <sys_getSharedObject>
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801592:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801596:	79 07                	jns    80159f <sget+0xaf>
	    		  return NULL;
  801598:	b8 00 00 00 00       	mov    $0x0,%eax
  80159d:	eb 0d                	jmp    8015ac <sget+0xbc>
	  	return(void*) returned_block->sva;
  80159f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a2:	8b 40 08             	mov    0x8(%eax),%eax
  8015a5:	eb 05                	jmp    8015ac <sget+0xbc>
	      }
	}
	   return NULL;
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b4:	e8 4d fb ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015b9:	83 ec 04             	sub    $0x4,%esp
  8015bc:	68 80 38 80 00       	push   $0x803880
  8015c1:	68 12 01 00 00       	push   $0x112
  8015c6:	68 73 38 80 00       	push   $0x803873
  8015cb:	e8 81 19 00 00       	call   802f51 <_panic>

008015d0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015d6:	83 ec 04             	sub    $0x4,%esp
  8015d9:	68 a8 38 80 00       	push   $0x8038a8
  8015de:	68 26 01 00 00       	push   $0x126
  8015e3:	68 73 38 80 00       	push   $0x803873
  8015e8:	e8 64 19 00 00       	call   802f51 <_panic>

008015ed <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f3:	83 ec 04             	sub    $0x4,%esp
  8015f6:	68 cc 38 80 00       	push   $0x8038cc
  8015fb:	68 31 01 00 00       	push   $0x131
  801600:	68 73 38 80 00       	push   $0x803873
  801605:	e8 47 19 00 00       	call   802f51 <_panic>

0080160a <shrink>:

}
void shrink(uint32 newSize)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	68 cc 38 80 00       	push   $0x8038cc
  801618:	68 36 01 00 00       	push   $0x136
  80161d:	68 73 38 80 00       	push   $0x803873
  801622:	e8 2a 19 00 00       	call   802f51 <_panic>

00801627 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	68 cc 38 80 00       	push   $0x8038cc
  801635:	68 3b 01 00 00       	push   $0x13b
  80163a:	68 73 38 80 00       	push   $0x803873
  80163f:	e8 0d 19 00 00       	call   802f51 <_panic>

00801644 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	57                   	push   %edi
  801648:	56                   	push   %esi
  801649:	53                   	push   %ebx
  80164a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	8b 55 0c             	mov    0xc(%ebp),%edx
  801653:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801656:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801659:	8b 7d 18             	mov    0x18(%ebp),%edi
  80165c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80165f:	cd 30                	int    $0x30
  801661:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5f                   	pop    %edi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    

0080166f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	8b 45 10             	mov    0x10(%ebp),%eax
  801678:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80167b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	52                   	push   %edx
  801687:	ff 75 0c             	pushl  0xc(%ebp)
  80168a:	50                   	push   %eax
  80168b:	6a 00                	push   $0x0
  80168d:	e8 b2 ff ff ff       	call   801644 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	90                   	nop
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_cgetc>:

int
sys_cgetc(void)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 01                	push   $0x1
  8016a7:	e8 98 ff ff ff       	call   801644 <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	52                   	push   %edx
  8016c1:	50                   	push   %eax
  8016c2:	6a 05                	push   $0x5
  8016c4:	e8 7b ff ff ff       	call   801644 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	56                   	push   %esi
  8016d2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8016d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	56                   	push   %esi
  8016e3:	53                   	push   %ebx
  8016e4:	51                   	push   %ecx
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	6a 06                	push   $0x6
  8016e9:	e8 56 ff ff ff       	call   801644 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    

008016f8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	52                   	push   %edx
  801708:	50                   	push   %eax
  801709:	6a 07                	push   $0x7
  80170b:	e8 34 ff ff ff       	call   801644 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	ff 75 08             	pushl  0x8(%ebp)
  801724:	6a 08                	push   $0x8
  801726:	e8 19 ff ff ff       	call   801644 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 09                	push   $0x9
  80173f:	e8 00 ff ff ff       	call   801644 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 0a                	push   $0xa
  801758:	e8 e7 fe ff ff       	call   801644 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 0b                	push   $0xb
  801771:	e8 ce fe ff ff       	call   801644 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	ff 75 08             	pushl  0x8(%ebp)
  80178a:	6a 0f                	push   $0xf
  80178c:	e8 b3 fe ff ff       	call   801644 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
	return;
  801794:	90                   	nop
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	6a 10                	push   $0x10
  8017a8:	e8 97 fe ff ff       	call   801644 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b0:	90                   	nop
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	ff 75 10             	pushl  0x10(%ebp)
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	6a 11                	push   $0x11
  8017c5:	e8 7a fe ff ff       	call   801644 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cd:	90                   	nop
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 0c                	push   $0xc
  8017df:	e8 60 fe ff ff       	call   801644 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 0d                	push   $0xd
  8017f9:	e8 46 fe ff ff       	call   801644 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 0e                	push   $0xe
  801812:	e8 2d fe ff ff       	call   801644 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	90                   	nop
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 13                	push   $0x13
  80182c:	e8 13 fe ff ff       	call   801644 <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	90                   	nop
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 14                	push   $0x14
  801846:	e8 f9 fd ff ff       	call   801644 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	90                   	nop
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_cputc>:


void
sys_cputc(const char c)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80185d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	50                   	push   %eax
  80186a:	6a 15                	push   $0x15
  80186c:	e8 d3 fd ff ff       	call   801644 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 16                	push   $0x16
  801886:	e8 b9 fd ff ff       	call   801644 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	90                   	nop
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	ff 75 0c             	pushl  0xc(%ebp)
  8018a0:	50                   	push   %eax
  8018a1:	6a 17                	push   $0x17
  8018a3:	e8 9c fd ff ff       	call   801644 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	52                   	push   %edx
  8018bd:	50                   	push   %eax
  8018be:	6a 1a                	push   $0x1a
  8018c0:	e8 7f fd ff ff       	call   801644 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	6a 18                	push   $0x18
  8018dd:	e8 62 fd ff ff       	call   801644 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	90                   	nop
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 19                	push   $0x19
  8018fb:	e8 44 fd ff ff       	call   801644 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 04             	sub    $0x4,%esp
  80190c:	8b 45 10             	mov    0x10(%ebp),%eax
  80190f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801912:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801915:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	51                   	push   %ecx
  80191f:	52                   	push   %edx
  801920:	ff 75 0c             	pushl  0xc(%ebp)
  801923:	50                   	push   %eax
  801924:	6a 1b                	push   $0x1b
  801926:	e8 19 fd ff ff       	call   801644 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801933:	8b 55 0c             	mov    0xc(%ebp),%edx
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	52                   	push   %edx
  801940:	50                   	push   %eax
  801941:	6a 1c                	push   $0x1c
  801943:	e8 fc fc ff ff       	call   801644 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801950:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	51                   	push   %ecx
  80195e:	52                   	push   %edx
  80195f:	50                   	push   %eax
  801960:	6a 1d                	push   $0x1d
  801962:	e8 dd fc ff ff       	call   801644 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 1e                	push   $0x1e
  80197f:	e8 c0 fc ff ff       	call   801644 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 1f                	push   $0x1f
  801998:	e8 a7 fc ff ff       	call   801644 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	ff 75 14             	pushl  0x14(%ebp)
  8019ad:	ff 75 10             	pushl  0x10(%ebp)
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	50                   	push   %eax
  8019b4:	6a 20                	push   $0x20
  8019b6:	e8 89 fc ff ff       	call   801644 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	50                   	push   %eax
  8019cf:	6a 21                	push   $0x21
  8019d1:	e8 6e fc ff ff       	call   801644 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	90                   	nop
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	50                   	push   %eax
  8019eb:	6a 22                	push   $0x22
  8019ed:	e8 52 fc ff ff       	call   801644 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 02                	push   $0x2
  801a06:	e8 39 fc ff ff       	call   801644 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 03                	push   $0x3
  801a1f:	e8 20 fc ff ff       	call   801644 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 04                	push   $0x4
  801a38:	e8 07 fc ff ff       	call   801644 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_exit_env>:


void sys_exit_env(void)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 23                	push   $0x23
  801a51:	e8 ee fb ff ff       	call   801644 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	90                   	nop
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a62:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a65:	8d 50 04             	lea    0x4(%eax),%edx
  801a68:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 24                	push   $0x24
  801a75:	e8 ca fb ff ff       	call   801644 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
	return result;
  801a7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a86:	89 01                	mov    %eax,(%ecx)
  801a88:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	c9                   	leave  
  801a8f:	c2 04 00             	ret    $0x4

00801a92 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	ff 75 10             	pushl  0x10(%ebp)
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	ff 75 08             	pushl  0x8(%ebp)
  801aa2:	6a 12                	push   $0x12
  801aa4:	e8 9b fb ff ff       	call   801644 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aac:	90                   	nop
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_rcr2>:
uint32 sys_rcr2()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 25                	push   $0x25
  801abe:	e8 81 fb ff ff       	call   801644 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ad4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	50                   	push   %eax
  801ae1:	6a 26                	push   $0x26
  801ae3:	e8 5c fb ff ff       	call   801644 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aeb:	90                   	nop
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <rsttst>:
void rsttst()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 28                	push   $0x28
  801afd:	e8 42 fb ff ff       	call   801644 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
	return ;
  801b05:	90                   	nop
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b14:	8b 55 18             	mov    0x18(%ebp),%edx
  801b17:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1b:	52                   	push   %edx
  801b1c:	50                   	push   %eax
  801b1d:	ff 75 10             	pushl  0x10(%ebp)
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	ff 75 08             	pushl  0x8(%ebp)
  801b26:	6a 27                	push   $0x27
  801b28:	e8 17 fb ff ff       	call   801644 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b30:	90                   	nop
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <chktst>:
void chktst(uint32 n)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	ff 75 08             	pushl  0x8(%ebp)
  801b41:	6a 29                	push   $0x29
  801b43:	e8 fc fa ff ff       	call   801644 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4b:	90                   	nop
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <inctst>:

void inctst()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 2a                	push   $0x2a
  801b5d:	e8 e2 fa ff ff       	call   801644 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return ;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <gettst>:
uint32 gettst()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 2b                	push   $0x2b
  801b77:	e8 c8 fa ff ff       	call   801644 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 2c                	push   $0x2c
  801b93:	e8 ac fa ff ff       	call   801644 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
  801b9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b9e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ba2:	75 07                	jne    801bab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ba4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba9:	eb 05                	jmp    801bb0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 2c                	push   $0x2c
  801bc4:	e8 7b fa ff ff       	call   801644 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
  801bcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bcf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bd3:	75 07                	jne    801bdc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bda:	eb 05                	jmp    801be1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 2c                	push   $0x2c
  801bf5:	e8 4a fa ff ff       	call   801644 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
  801bfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c00:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c04:	75 07                	jne    801c0d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c06:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0b:	eb 05                	jmp    801c12 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 2c                	push   $0x2c
  801c26:	e8 19 fa ff ff       	call   801644 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
  801c2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c31:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c35:	75 07                	jne    801c3e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c37:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3c:	eb 05                	jmp    801c43 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	ff 75 08             	pushl  0x8(%ebp)
  801c53:	6a 2d                	push   $0x2d
  801c55:	e8 ea f9 ff ff       	call   801644 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5d:	90                   	nop
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c64:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	53                   	push   %ebx
  801c73:	51                   	push   %ecx
  801c74:	52                   	push   %edx
  801c75:	50                   	push   %eax
  801c76:	6a 2e                	push   $0x2e
  801c78:	e8 c7 f9 ff ff       	call   801644 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	52                   	push   %edx
  801c95:	50                   	push   %eax
  801c96:	6a 2f                	push   $0x2f
  801c98:	e8 a7 f9 ff ff       	call   801644 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	68 dc 38 80 00       	push   $0x8038dc
  801cb0:	e8 c7 e6 ff ff       	call   80037c <cprintf>
  801cb5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cb8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cbf:	83 ec 0c             	sub    $0xc,%esp
  801cc2:	68 08 39 80 00       	push   $0x803908
  801cc7:	e8 b0 e6 ff ff       	call   80037c <cprintf>
  801ccc:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ccf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd3:	a1 38 41 80 00       	mov    0x804138,%eax
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cdb:	eb 56                	jmp    801d33 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ce1:	74 1c                	je     801cff <print_mem_block_lists+0x5d>
  801ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce6:	8b 50 08             	mov    0x8(%eax),%edx
  801ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cec:	8b 48 08             	mov    0x8(%eax),%ecx
  801cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf5:	01 c8                	add    %ecx,%eax
  801cf7:	39 c2                	cmp    %eax,%edx
  801cf9:	73 04                	jae    801cff <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cfb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d02:	8b 50 08             	mov    0x8(%eax),%edx
  801d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d08:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0b:	01 c2                	add    %eax,%edx
  801d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d10:	8b 40 08             	mov    0x8(%eax),%eax
  801d13:	83 ec 04             	sub    $0x4,%esp
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	68 1d 39 80 00       	push   $0x80391d
  801d1d:	e8 5a e6 ff ff       	call   80037c <cprintf>
  801d22:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d2b:	a1 40 41 80 00       	mov    0x804140,%eax
  801d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d37:	74 07                	je     801d40 <print_mem_block_lists+0x9e>
  801d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3c:	8b 00                	mov    (%eax),%eax
  801d3e:	eb 05                	jmp    801d45 <print_mem_block_lists+0xa3>
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
  801d45:	a3 40 41 80 00       	mov    %eax,0x804140
  801d4a:	a1 40 41 80 00       	mov    0x804140,%eax
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	75 8a                	jne    801cdd <print_mem_block_lists+0x3b>
  801d53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d57:	75 84                	jne    801cdd <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d59:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d5d:	75 10                	jne    801d6f <print_mem_block_lists+0xcd>
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	68 2c 39 80 00       	push   $0x80392c
  801d67:	e8 10 e6 ff ff       	call   80037c <cprintf>
  801d6c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	68 50 39 80 00       	push   $0x803950
  801d7e:	e8 f9 e5 ff ff       	call   80037c <cprintf>
  801d83:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d86:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d8a:	a1 40 40 80 00       	mov    0x804040,%eax
  801d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d92:	eb 56                	jmp    801dea <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d98:	74 1c                	je     801db6 <print_mem_block_lists+0x114>
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	8b 50 08             	mov    0x8(%eax),%edx
  801da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da3:	8b 48 08             	mov    0x8(%eax),%ecx
  801da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dac:	01 c8                	add    %ecx,%eax
  801dae:	39 c2                	cmp    %eax,%edx
  801db0:	73 04                	jae    801db6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801db2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db9:	8b 50 08             	mov    0x8(%eax),%edx
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc2:	01 c2                	add    %eax,%edx
  801dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc7:	8b 40 08             	mov    0x8(%eax),%eax
  801dca:	83 ec 04             	sub    $0x4,%esp
  801dcd:	52                   	push   %edx
  801dce:	50                   	push   %eax
  801dcf:	68 1d 39 80 00       	push   $0x80391d
  801dd4:	e8 a3 e5 ff ff       	call   80037c <cprintf>
  801dd9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801de2:	a1 48 40 80 00       	mov    0x804048,%eax
  801de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dee:	74 07                	je     801df7 <print_mem_block_lists+0x155>
  801df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df3:	8b 00                	mov    (%eax),%eax
  801df5:	eb 05                	jmp    801dfc <print_mem_block_lists+0x15a>
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	a3 48 40 80 00       	mov    %eax,0x804048
  801e01:	a1 48 40 80 00       	mov    0x804048,%eax
  801e06:	85 c0                	test   %eax,%eax
  801e08:	75 8a                	jne    801d94 <print_mem_block_lists+0xf2>
  801e0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e0e:	75 84                	jne    801d94 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e10:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e14:	75 10                	jne    801e26 <print_mem_block_lists+0x184>
  801e16:	83 ec 0c             	sub    $0xc,%esp
  801e19:	68 68 39 80 00       	push   $0x803968
  801e1e:	e8 59 e5 ff ff       	call   80037c <cprintf>
  801e23:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	68 dc 38 80 00       	push   $0x8038dc
  801e2e:	e8 49 e5 ff ff       	call   80037c <cprintf>
  801e33:	83 c4 10             	add    $0x10,%esp

}
  801e36:	90                   	nop
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801e3f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e46:	00 00 00 
  801e49:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e50:	00 00 00 
  801e53:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e5a:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  801e5d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  801e65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e6c:	e9 9e 00 00 00       	jmp    801f0f <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801e71:	a1 50 40 80 00       	mov    0x804050,%eax
  801e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e79:	c1 e2 04             	shl    $0x4,%edx
  801e7c:	01 d0                	add    %edx,%eax
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	75 14                	jne    801e96 <initialize_MemBlocksList+0x5d>
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	68 90 39 80 00       	push   $0x803990
  801e8a:	6a 48                	push   $0x48
  801e8c:	68 b3 39 80 00       	push   $0x8039b3
  801e91:	e8 bb 10 00 00       	call   802f51 <_panic>
  801e96:	a1 50 40 80 00       	mov    0x804050,%eax
  801e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9e:	c1 e2 04             	shl    $0x4,%edx
  801ea1:	01 d0                	add    %edx,%eax
  801ea3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ea9:	89 10                	mov    %edx,(%eax)
  801eab:	8b 00                	mov    (%eax),%eax
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	74 18                	je     801ec9 <initialize_MemBlocksList+0x90>
  801eb1:	a1 48 41 80 00       	mov    0x804148,%eax
  801eb6:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ebc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ebf:	c1 e1 04             	shl    $0x4,%ecx
  801ec2:	01 ca                	add    %ecx,%edx
  801ec4:	89 50 04             	mov    %edx,0x4(%eax)
  801ec7:	eb 12                	jmp    801edb <initialize_MemBlocksList+0xa2>
  801ec9:	a1 50 40 80 00       	mov    0x804050,%eax
  801ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed1:	c1 e2 04             	shl    $0x4,%edx
  801ed4:	01 d0                	add    %edx,%eax
  801ed6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801edb:	a1 50 40 80 00       	mov    0x804050,%eax
  801ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee3:	c1 e2 04             	shl    $0x4,%edx
  801ee6:	01 d0                	add    %edx,%eax
  801ee8:	a3 48 41 80 00       	mov    %eax,0x804148
  801eed:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef5:	c1 e2 04             	shl    $0x4,%edx
  801ef8:	01 d0                	add    %edx,%eax
  801efa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f01:	a1 54 41 80 00       	mov    0x804154,%eax
  801f06:	40                   	inc    %eax
  801f07:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  801f0c:	ff 45 f4             	incl   -0xc(%ebp)
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f15:	0f 82 56 ff ff ff    	jb     801e71 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  801f1b:	90                   	nop
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8b 00                	mov    (%eax),%eax
  801f29:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  801f2c:	eb 18                	jmp    801f46 <find_block+0x28>
		{
			if(tmp->sva==va)
  801f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f31:	8b 40 08             	mov    0x8(%eax),%eax
  801f34:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f37:	75 05                	jne    801f3e <find_block+0x20>
			{
				return tmp;
  801f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3c:	eb 11                	jmp    801f4f <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  801f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  801f46:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f4a:	75 e2                	jne    801f2e <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  801f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  801f57:	a1 40 40 80 00       	mov    0x804040,%eax
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	0f 85 83 00 00 00    	jne    801fe7 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  801f64:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801f6b:	00 00 00 
  801f6e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801f75:	00 00 00 
  801f78:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801f7f:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f86:	75 14                	jne    801f9c <insert_sorted_allocList+0x4b>
  801f88:	83 ec 04             	sub    $0x4,%esp
  801f8b:	68 90 39 80 00       	push   $0x803990
  801f90:	6a 7f                	push   $0x7f
  801f92:	68 b3 39 80 00       	push   $0x8039b3
  801f97:	e8 b5 0f 00 00       	call   802f51 <_panic>
  801f9c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	89 10                	mov    %edx,(%eax)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	8b 00                	mov    (%eax),%eax
  801fac:	85 c0                	test   %eax,%eax
  801fae:	74 0d                	je     801fbd <insert_sorted_allocList+0x6c>
  801fb0:	a1 40 40 80 00       	mov    0x804040,%eax
  801fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb8:	89 50 04             	mov    %edx,0x4(%eax)
  801fbb:	eb 08                	jmp    801fc5 <insert_sorted_allocList+0x74>
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	a3 44 40 80 00       	mov    %eax,0x804044
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	a3 40 40 80 00       	mov    %eax,0x804040
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fdc:	40                   	inc    %eax
  801fdd:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  801fe2:	e9 16 01 00 00       	jmp    8020fd <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	8b 50 08             	mov    0x8(%eax),%edx
  801fed:	a1 44 40 80 00       	mov    0x804044,%eax
  801ff2:	8b 40 08             	mov    0x8(%eax),%eax
  801ff5:	39 c2                	cmp    %eax,%edx
  801ff7:	76 68                	jbe    802061 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  801ff9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ffd:	75 17                	jne    802016 <insert_sorted_allocList+0xc5>
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	68 cc 39 80 00       	push   $0x8039cc
  802007:	68 85 00 00 00       	push   $0x85
  80200c:	68 b3 39 80 00       	push   $0x8039b3
  802011:	e8 3b 0f 00 00       	call   802f51 <_panic>
  802016:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	89 50 04             	mov    %edx,0x4(%eax)
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	8b 40 04             	mov    0x4(%eax),%eax
  802028:	85 c0                	test   %eax,%eax
  80202a:	74 0c                	je     802038 <insert_sorted_allocList+0xe7>
  80202c:	a1 44 40 80 00       	mov    0x804044,%eax
  802031:	8b 55 08             	mov    0x8(%ebp),%edx
  802034:	89 10                	mov    %edx,(%eax)
  802036:	eb 08                	jmp    802040 <insert_sorted_allocList+0xef>
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	a3 40 40 80 00       	mov    %eax,0x804040
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	a3 44 40 80 00       	mov    %eax,0x804044
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802051:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802056:	40                   	inc    %eax
  802057:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80205c:	e9 9c 00 00 00       	jmp    8020fd <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802061:	a1 40 40 80 00       	mov    0x804040,%eax
  802066:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802069:	e9 85 00 00 00       	jmp    8020f3 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	8b 50 08             	mov    0x8(%eax),%edx
  802074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802077:	8b 40 08             	mov    0x8(%eax),%eax
  80207a:	39 c2                	cmp    %eax,%edx
  80207c:	73 6d                	jae    8020eb <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80207e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802082:	74 06                	je     80208a <insert_sorted_allocList+0x139>
  802084:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802088:	75 17                	jne    8020a1 <insert_sorted_allocList+0x150>
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	68 f0 39 80 00       	push   $0x8039f0
  802092:	68 90 00 00 00       	push   $0x90
  802097:	68 b3 39 80 00       	push   $0x8039b3
  80209c:	e8 b0 0e 00 00       	call   802f51 <_panic>
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	8b 50 04             	mov    0x4(%eax),%edx
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	89 50 04             	mov    %edx,0x4(%eax)
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b3:	89 10                	mov    %edx,(%eax)
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	8b 40 04             	mov    0x4(%eax),%eax
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	74 0d                	je     8020cc <insert_sorted_allocList+0x17b>
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 40 04             	mov    0x4(%eax),%eax
  8020c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c8:	89 10                	mov    %edx,(%eax)
  8020ca:	eb 08                	jmp    8020d4 <insert_sorted_allocList+0x183>
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	a3 40 40 80 00       	mov    %eax,0x804040
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020da:	89 50 04             	mov    %edx,0x4(%eax)
  8020dd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020e2:	40                   	inc    %eax
  8020e3:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8020e8:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8020e9:	eb 12                	jmp    8020fd <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 00                	mov    (%eax),%eax
  8020f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8020f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f7:	0f 85 71 ff ff ff    	jne    80206e <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8020fd:	90                   	nop
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802106:	a1 38 41 80 00       	mov    0x804138,%eax
  80210b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80210e:	e9 76 01 00 00       	jmp    802289 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 40 0c             	mov    0xc(%eax),%eax
  802119:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211c:	0f 85 8a 00 00 00    	jne    8021ac <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802126:	75 17                	jne    80213f <alloc_block_FF+0x3f>
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	68 25 3a 80 00       	push   $0x803a25
  802130:	68 a8 00 00 00       	push   $0xa8
  802135:	68 b3 39 80 00       	push   $0x8039b3
  80213a:	e8 12 0e 00 00       	call   802f51 <_panic>
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	8b 00                	mov    (%eax),%eax
  802144:	85 c0                	test   %eax,%eax
  802146:	74 10                	je     802158 <alloc_block_FF+0x58>
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	8b 00                	mov    (%eax),%eax
  80214d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802150:	8b 52 04             	mov    0x4(%edx),%edx
  802153:	89 50 04             	mov    %edx,0x4(%eax)
  802156:	eb 0b                	jmp    802163 <alloc_block_FF+0x63>
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	8b 40 04             	mov    0x4(%eax),%eax
  80215e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	8b 40 04             	mov    0x4(%eax),%eax
  802169:	85 c0                	test   %eax,%eax
  80216b:	74 0f                	je     80217c <alloc_block_FF+0x7c>
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 40 04             	mov    0x4(%eax),%eax
  802173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802176:	8b 12                	mov    (%edx),%edx
  802178:	89 10                	mov    %edx,(%eax)
  80217a:	eb 0a                	jmp    802186 <alloc_block_FF+0x86>
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	8b 00                	mov    (%eax),%eax
  802181:	a3 38 41 80 00       	mov    %eax,0x804138
  802186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802199:	a1 44 41 80 00       	mov    0x804144,%eax
  80219e:	48                   	dec    %eax
  80219f:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	e9 ea 00 00 00       	jmp    802296 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b5:	0f 86 c6 00 00 00    	jbe    802281 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8021bb:	a1 48 41 80 00       	mov    0x804148,%eax
  8021c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8021c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c9:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	8b 50 08             	mov    0x8(%eax),%edx
  8021d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d5:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	8b 40 0c             	mov    0xc(%eax),%eax
  8021de:	2b 45 08             	sub    0x8(%ebp),%eax
  8021e1:	89 c2                	mov    %eax,%edx
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	8b 50 08             	mov    0x8(%eax),%edx
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	01 c2                	add    %eax,%edx
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8021fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021fe:	75 17                	jne    802217 <alloc_block_FF+0x117>
  802200:	83 ec 04             	sub    $0x4,%esp
  802203:	68 25 3a 80 00       	push   $0x803a25
  802208:	68 b6 00 00 00       	push   $0xb6
  80220d:	68 b3 39 80 00       	push   $0x8039b3
  802212:	e8 3a 0d 00 00       	call   802f51 <_panic>
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	8b 00                	mov    (%eax),%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	74 10                	je     802230 <alloc_block_FF+0x130>
  802220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802228:	8b 52 04             	mov    0x4(%edx),%edx
  80222b:	89 50 04             	mov    %edx,0x4(%eax)
  80222e:	eb 0b                	jmp    80223b <alloc_block_FF+0x13b>
  802230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802233:	8b 40 04             	mov    0x4(%eax),%eax
  802236:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80223b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223e:	8b 40 04             	mov    0x4(%eax),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	74 0f                	je     802254 <alloc_block_FF+0x154>
  802245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802248:	8b 40 04             	mov    0x4(%eax),%eax
  80224b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224e:	8b 12                	mov    (%edx),%edx
  802250:	89 10                	mov    %edx,(%eax)
  802252:	eb 0a                	jmp    80225e <alloc_block_FF+0x15e>
  802254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	a3 48 41 80 00       	mov    %eax,0x804148
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802271:	a1 54 41 80 00       	mov    0x804154,%eax
  802276:	48                   	dec    %eax
  802277:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80227c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227f:	eb 15                	jmp    802296 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 00                	mov    (%eax),%eax
  802286:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228d:	0f 85 80 fe ff ff    	jne    802113 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80229e:	a1 38 41 80 00       	mov    0x804138,%eax
  8022a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8022a6:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8022ad:	e9 c0 00 00 00       	jmp    802372 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022bb:	0f 85 8a 00 00 00    	jne    80234b <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8022c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c5:	75 17                	jne    8022de <alloc_block_BF+0x46>
  8022c7:	83 ec 04             	sub    $0x4,%esp
  8022ca:	68 25 3a 80 00       	push   $0x803a25
  8022cf:	68 cf 00 00 00       	push   $0xcf
  8022d4:	68 b3 39 80 00       	push   $0x8039b3
  8022d9:	e8 73 0c 00 00       	call   802f51 <_panic>
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	74 10                	je     8022f7 <alloc_block_BF+0x5f>
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ef:	8b 52 04             	mov    0x4(%edx),%edx
  8022f2:	89 50 04             	mov    %edx,0x4(%eax)
  8022f5:	eb 0b                	jmp    802302 <alloc_block_BF+0x6a>
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 40 04             	mov    0x4(%eax),%eax
  8022fd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 40 04             	mov    0x4(%eax),%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	74 0f                	je     80231b <alloc_block_BF+0x83>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802315:	8b 12                	mov    (%edx),%edx
  802317:	89 10                	mov    %edx,(%eax)
  802319:	eb 0a                	jmp    802325 <alloc_block_BF+0x8d>
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	a3 38 41 80 00       	mov    %eax,0x804138
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802338:	a1 44 41 80 00       	mov    0x804144,%eax
  80233d:	48                   	dec    %eax
  80233e:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	e9 2a 01 00 00       	jmp    802475 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	8b 40 0c             	mov    0xc(%eax),%eax
  802351:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802354:	73 14                	jae    80236a <alloc_block_BF+0xd2>
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 40 0c             	mov    0xc(%eax),%eax
  80235c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80235f:	76 09                	jbe    80236a <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 0c             	mov    0xc(%eax),%eax
  802367:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802376:	0f 85 36 ff ff ff    	jne    8022b2 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80237c:	a1 38 41 80 00       	mov    0x804138,%eax
  802381:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802384:	e9 dd 00 00 00       	jmp    802466 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 40 0c             	mov    0xc(%eax),%eax
  80238f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802392:	0f 85 c6 00 00 00    	jne    80245e <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802398:	a1 48 41 80 00       	mov    0x804148,%eax
  80239d:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 50 08             	mov    0x8(%eax),%edx
  8023a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a9:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8023ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023af:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b2:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 50 08             	mov    0x8(%eax),%edx
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	01 c2                	add    %eax,%edx
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cc:	2b 45 08             	sub    0x8(%ebp),%eax
  8023cf:	89 c2                	mov    %eax,%edx
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023db:	75 17                	jne    8023f4 <alloc_block_BF+0x15c>
  8023dd:	83 ec 04             	sub    $0x4,%esp
  8023e0:	68 25 3a 80 00       	push   $0x803a25
  8023e5:	68 eb 00 00 00       	push   $0xeb
  8023ea:	68 b3 39 80 00       	push   $0x8039b3
  8023ef:	e8 5d 0b 00 00       	call   802f51 <_panic>
  8023f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 10                	je     80240d <alloc_block_BF+0x175>
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802405:	8b 52 04             	mov    0x4(%edx),%edx
  802408:	89 50 04             	mov    %edx,0x4(%eax)
  80240b:	eb 0b                	jmp    802418 <alloc_block_BF+0x180>
  80240d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241b:	8b 40 04             	mov    0x4(%eax),%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 0f                	je     802431 <alloc_block_BF+0x199>
  802422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80242b:	8b 12                	mov    (%edx),%edx
  80242d:	89 10                	mov    %edx,(%eax)
  80242f:	eb 0a                	jmp    80243b <alloc_block_BF+0x1a3>
  802431:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	a3 48 41 80 00       	mov    %eax,0x804148
  80243b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244e:	a1 54 41 80 00       	mov    0x804154,%eax
  802453:	48                   	dec    %eax
  802454:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245c:	eb 17                	jmp    802475 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246a:	0f 85 19 ff ff ff    	jne    802389 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80247d:	a1 40 40 80 00       	mov    0x804040,%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	75 19                	jne    80249f <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802486:	83 ec 0c             	sub    $0xc,%esp
  802489:	ff 75 08             	pushl  0x8(%ebp)
  80248c:	e8 6f fc ff ff       	call   802100 <alloc_block_FF>
  802491:	83 c4 10             	add    $0x10,%esp
  802494:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	e9 e9 01 00 00       	jmp    802688 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80249f:	a1 44 40 80 00       	mov    0x804044,%eax
  8024a4:	8b 40 08             	mov    0x8(%eax),%eax
  8024a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8024aa:	a1 44 40 80 00       	mov    0x804044,%eax
  8024af:	8b 50 0c             	mov    0xc(%eax),%edx
  8024b2:	a1 44 40 80 00       	mov    0x804044,%eax
  8024b7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ba:	01 d0                	add    %edx,%eax
  8024bc:	83 ec 08             	sub    $0x8,%esp
  8024bf:	50                   	push   %eax
  8024c0:	68 38 41 80 00       	push   $0x804138
  8024c5:	e8 54 fa ff ff       	call   801f1e <find_block>
  8024ca:	83 c4 10             	add    $0x10,%esp
  8024cd:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d9:	0f 85 9b 00 00 00    	jne    80257a <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 08             	mov    0x8(%eax),%eax
  8024eb:	01 d0                	add    %edx,%eax
  8024ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8024f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f4:	75 17                	jne    80250d <alloc_block_NF+0x96>
  8024f6:	83 ec 04             	sub    $0x4,%esp
  8024f9:	68 25 3a 80 00       	push   $0x803a25
  8024fe:	68 1a 01 00 00       	push   $0x11a
  802503:	68 b3 39 80 00       	push   $0x8039b3
  802508:	e8 44 0a 00 00       	call   802f51 <_panic>
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 00                	mov    (%eax),%eax
  802512:	85 c0                	test   %eax,%eax
  802514:	74 10                	je     802526 <alloc_block_NF+0xaf>
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 00                	mov    (%eax),%eax
  80251b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251e:	8b 52 04             	mov    0x4(%edx),%edx
  802521:	89 50 04             	mov    %edx,0x4(%eax)
  802524:	eb 0b                	jmp    802531 <alloc_block_NF+0xba>
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 40 04             	mov    0x4(%eax),%eax
  80252c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 40 04             	mov    0x4(%eax),%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	74 0f                	je     80254a <alloc_block_NF+0xd3>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 40 04             	mov    0x4(%eax),%eax
  802541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802544:	8b 12                	mov    (%edx),%edx
  802546:	89 10                	mov    %edx,(%eax)
  802548:	eb 0a                	jmp    802554 <alloc_block_NF+0xdd>
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 00                	mov    (%eax),%eax
  80254f:	a3 38 41 80 00       	mov    %eax,0x804138
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802567:	a1 44 41 80 00       	mov    0x804144,%eax
  80256c:	48                   	dec    %eax
  80256d:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	e9 0e 01 00 00       	jmp    802688 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 0c             	mov    0xc(%eax),%eax
  802580:	3b 45 08             	cmp    0x8(%ebp),%eax
  802583:	0f 86 cf 00 00 00    	jbe    802658 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802589:	a1 48 41 80 00       	mov    0x804148,%eax
  80258e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802591:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802594:	8b 55 08             	mov    0x8(%ebp),%edx
  802597:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 50 08             	mov    0x8(%eax),%edx
  8025a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a3:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 50 08             	mov    0x8(%eax),%edx
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	01 c2                	add    %eax,%edx
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c0:	89 c2                	mov    %eax,%edx
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 40 08             	mov    0x8(%eax),%eax
  8025ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025d5:	75 17                	jne    8025ee <alloc_block_NF+0x177>
  8025d7:	83 ec 04             	sub    $0x4,%esp
  8025da:	68 25 3a 80 00       	push   $0x803a25
  8025df:	68 28 01 00 00       	push   $0x128
  8025e4:	68 b3 39 80 00       	push   $0x8039b3
  8025e9:	e8 63 09 00 00       	call   802f51 <_panic>
  8025ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	74 10                	je     802607 <alloc_block_NF+0x190>
  8025f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ff:	8b 52 04             	mov    0x4(%edx),%edx
  802602:	89 50 04             	mov    %edx,0x4(%eax)
  802605:	eb 0b                	jmp    802612 <alloc_block_NF+0x19b>
  802607:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260a:	8b 40 04             	mov    0x4(%eax),%eax
  80260d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802615:	8b 40 04             	mov    0x4(%eax),%eax
  802618:	85 c0                	test   %eax,%eax
  80261a:	74 0f                	je     80262b <alloc_block_NF+0x1b4>
  80261c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261f:	8b 40 04             	mov    0x4(%eax),%eax
  802622:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802625:	8b 12                	mov    (%edx),%edx
  802627:	89 10                	mov    %edx,(%eax)
  802629:	eb 0a                	jmp    802635 <alloc_block_NF+0x1be>
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	8b 00                	mov    (%eax),%eax
  802630:	a3 48 41 80 00       	mov    %eax,0x804148
  802635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802638:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802641:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802648:	a1 54 41 80 00       	mov    0x804154,%eax
  80264d:	48                   	dec    %eax
  80264e:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802656:	eb 30                	jmp    802688 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802658:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80265d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802660:	75 0a                	jne    80266c <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802662:	a1 38 41 80 00       	mov    0x804138,%eax
  802667:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266a:	eb 08                	jmp    802674 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 08             	mov    0x8(%eax),%eax
  80267a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80267d:	0f 85 4d fe ff ff    	jne    8024d0 <alloc_block_NF+0x59>

			return NULL;
  802683:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	53                   	push   %ebx
  80268e:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802691:	a1 38 41 80 00       	mov    0x804138,%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	0f 85 86 00 00 00    	jne    802724 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80269e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8026a5:	00 00 00 
  8026a8:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8026af:	00 00 00 
  8026b2:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8026b9:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8026bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026c0:	75 17                	jne    8026d9 <insert_sorted_with_merge_freeList+0x4f>
  8026c2:	83 ec 04             	sub    $0x4,%esp
  8026c5:	68 90 39 80 00       	push   $0x803990
  8026ca:	68 48 01 00 00       	push   $0x148
  8026cf:	68 b3 39 80 00       	push   $0x8039b3
  8026d4:	e8 78 08 00 00       	call   802f51 <_panic>
  8026d9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	89 10                	mov    %edx,(%eax)
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	74 0d                	je     8026fa <insert_sorted_with_merge_freeList+0x70>
  8026ed:	a1 38 41 80 00       	mov    0x804138,%eax
  8026f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f5:	89 50 04             	mov    %edx,0x4(%eax)
  8026f8:	eb 08                	jmp    802702 <insert_sorted_with_merge_freeList+0x78>
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	a3 38 41 80 00       	mov    %eax,0x804138
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802714:	a1 44 41 80 00       	mov    0x804144,%eax
  802719:	40                   	inc    %eax
  80271a:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80271f:	e9 73 07 00 00       	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	8b 50 08             	mov    0x8(%eax),%edx
  80272a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80272f:	8b 40 08             	mov    0x8(%eax),%eax
  802732:	39 c2                	cmp    %eax,%edx
  802734:	0f 86 84 00 00 00    	jbe    8027be <insert_sorted_with_merge_freeList+0x134>
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	8b 50 08             	mov    0x8(%eax),%edx
  802740:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802745:	8b 48 0c             	mov    0xc(%eax),%ecx
  802748:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80274d:	8b 40 08             	mov    0x8(%eax),%eax
  802750:	01 c8                	add    %ecx,%eax
  802752:	39 c2                	cmp    %eax,%edx
  802754:	74 68                	je     8027be <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802756:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275a:	75 17                	jne    802773 <insert_sorted_with_merge_freeList+0xe9>
  80275c:	83 ec 04             	sub    $0x4,%esp
  80275f:	68 cc 39 80 00       	push   $0x8039cc
  802764:	68 4c 01 00 00       	push   $0x14c
  802769:	68 b3 39 80 00       	push   $0x8039b3
  80276e:	e8 de 07 00 00       	call   802f51 <_panic>
  802773:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	89 50 04             	mov    %edx,0x4(%eax)
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 0c                	je     802795 <insert_sorted_with_merge_freeList+0x10b>
  802789:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
  802791:	89 10                	mov    %edx,(%eax)
  802793:	eb 08                	jmp    80279d <insert_sorted_with_merge_freeList+0x113>
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	a3 38 41 80 00       	mov    %eax,0x804138
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ae:	a1 44 41 80 00       	mov    0x804144,%eax
  8027b3:	40                   	inc    %eax
  8027b4:	a3 44 41 80 00       	mov    %eax,0x804144
  8027b9:	e9 d9 06 00 00       	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	8b 50 08             	mov    0x8(%eax),%edx
  8027c4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027c9:	8b 40 08             	mov    0x8(%eax),%eax
  8027cc:	39 c2                	cmp    %eax,%edx
  8027ce:	0f 86 b5 00 00 00    	jbe    802889 <insert_sorted_with_merge_freeList+0x1ff>
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	8b 50 08             	mov    0x8(%eax),%edx
  8027da:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027df:	8b 48 0c             	mov    0xc(%eax),%ecx
  8027e2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027e7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ea:	01 c8                	add    %ecx,%eax
  8027ec:	39 c2                	cmp    %eax,%edx
  8027ee:	0f 85 95 00 00 00    	jne    802889 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8027f4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027f9:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8027ff:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802802:	8b 55 08             	mov    0x8(%ebp),%edx
  802805:	8b 52 0c             	mov    0xc(%edx),%edx
  802808:	01 ca                	add    %ecx,%edx
  80280a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802821:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802825:	75 17                	jne    80283e <insert_sorted_with_merge_freeList+0x1b4>
  802827:	83 ec 04             	sub    $0x4,%esp
  80282a:	68 90 39 80 00       	push   $0x803990
  80282f:	68 54 01 00 00       	push   $0x154
  802834:	68 b3 39 80 00       	push   $0x8039b3
  802839:	e8 13 07 00 00       	call   802f51 <_panic>
  80283e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	89 10                	mov    %edx,(%eax)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	74 0d                	je     80285f <insert_sorted_with_merge_freeList+0x1d5>
  802852:	a1 48 41 80 00       	mov    0x804148,%eax
  802857:	8b 55 08             	mov    0x8(%ebp),%edx
  80285a:	89 50 04             	mov    %edx,0x4(%eax)
  80285d:	eb 08                	jmp    802867 <insert_sorted_with_merge_freeList+0x1dd>
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	a3 48 41 80 00       	mov    %eax,0x804148
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802879:	a1 54 41 80 00       	mov    0x804154,%eax
  80287e:	40                   	inc    %eax
  80287f:	a3 54 41 80 00       	mov    %eax,0x804154
  802884:	e9 0e 06 00 00       	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	8b 50 08             	mov    0x8(%eax),%edx
  80288f:	a1 38 41 80 00       	mov    0x804138,%eax
  802894:	8b 40 08             	mov    0x8(%eax),%eax
  802897:	39 c2                	cmp    %eax,%edx
  802899:	0f 83 c1 00 00 00    	jae    802960 <insert_sorted_with_merge_freeList+0x2d6>
  80289f:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a4:	8b 50 08             	mov    0x8(%eax),%edx
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	8b 48 08             	mov    0x8(%eax),%ecx
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b3:	01 c8                	add    %ecx,%eax
  8028b5:	39 c2                	cmp    %eax,%edx
  8028b7:	0f 85 a3 00 00 00    	jne    802960 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8028bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8028c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c5:	8b 52 08             	mov    0x8(%edx),%edx
  8028c8:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8028cb:	a1 38 41 80 00       	mov    0x804138,%eax
  8028d0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028d6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8028d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8028df:	01 ca                	add    %ecx,%edx
  8028e1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8028f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028fc:	75 17                	jne    802915 <insert_sorted_with_merge_freeList+0x28b>
  8028fe:	83 ec 04             	sub    $0x4,%esp
  802901:	68 90 39 80 00       	push   $0x803990
  802906:	68 5d 01 00 00       	push   $0x15d
  80290b:	68 b3 39 80 00       	push   $0x8039b3
  802910:	e8 3c 06 00 00       	call   802f51 <_panic>
  802915:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	89 10                	mov    %edx,(%eax)
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	74 0d                	je     802936 <insert_sorted_with_merge_freeList+0x2ac>
  802929:	a1 48 41 80 00       	mov    0x804148,%eax
  80292e:	8b 55 08             	mov    0x8(%ebp),%edx
  802931:	89 50 04             	mov    %edx,0x4(%eax)
  802934:	eb 08                	jmp    80293e <insert_sorted_with_merge_freeList+0x2b4>
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	a3 48 41 80 00       	mov    %eax,0x804148
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802950:	a1 54 41 80 00       	mov    0x804154,%eax
  802955:	40                   	inc    %eax
  802956:	a3 54 41 80 00       	mov    %eax,0x804154
  80295b:	e9 37 05 00 00       	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	8b 50 08             	mov    0x8(%eax),%edx
  802966:	a1 38 41 80 00       	mov    0x804138,%eax
  80296b:	8b 40 08             	mov    0x8(%eax),%eax
  80296e:	39 c2                	cmp    %eax,%edx
  802970:	0f 83 82 00 00 00    	jae    8029f8 <insert_sorted_with_merge_freeList+0x36e>
  802976:	a1 38 41 80 00       	mov    0x804138,%eax
  80297b:	8b 50 08             	mov    0x8(%eax),%edx
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	8b 48 08             	mov    0x8(%eax),%ecx
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	8b 40 0c             	mov    0xc(%eax),%eax
  80298a:	01 c8                	add    %ecx,%eax
  80298c:	39 c2                	cmp    %eax,%edx
  80298e:	74 68                	je     8029f8 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802990:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802994:	75 17                	jne    8029ad <insert_sorted_with_merge_freeList+0x323>
  802996:	83 ec 04             	sub    $0x4,%esp
  802999:	68 90 39 80 00       	push   $0x803990
  80299e:	68 62 01 00 00       	push   $0x162
  8029a3:	68 b3 39 80 00       	push   $0x8039b3
  8029a8:	e8 a4 05 00 00       	call   802f51 <_panic>
  8029ad:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	89 10                	mov    %edx,(%eax)
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	74 0d                	je     8029ce <insert_sorted_with_merge_freeList+0x344>
  8029c1:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c9:	89 50 04             	mov    %edx,0x4(%eax)
  8029cc:	eb 08                	jmp    8029d6 <insert_sorted_with_merge_freeList+0x34c>
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	a3 38 41 80 00       	mov    %eax,0x804138
  8029de:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e8:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ed:	40                   	inc    %eax
  8029ee:	a3 44 41 80 00       	mov    %eax,0x804144
  8029f3:	e9 9f 04 00 00       	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8029f8:	a1 38 41 80 00       	mov    0x804138,%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802a02:	e9 84 04 00 00       	jmp    802e8b <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 50 08             	mov    0x8(%eax),%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	8b 40 08             	mov    0x8(%eax),%eax
  802a13:	39 c2                	cmp    %eax,%edx
  802a15:	0f 86 a9 00 00 00    	jbe    802ac4 <insert_sorted_with_merge_freeList+0x43a>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 50 08             	mov    0x8(%eax),%edx
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 48 08             	mov    0x8(%eax),%ecx
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	01 c8                	add    %ecx,%eax
  802a2f:	39 c2                	cmp    %eax,%edx
  802a31:	0f 84 8d 00 00 00    	je     802ac4 <insert_sorted_with_merge_freeList+0x43a>
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 50 08             	mov    0x8(%eax),%edx
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 40 04             	mov    0x4(%eax),%eax
  802a43:	8b 48 08             	mov    0x8(%eax),%ecx
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4f:	01 c8                	add    %ecx,%eax
  802a51:	39 c2                	cmp    %eax,%edx
  802a53:	74 6f                	je     802ac4 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802a55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a59:	74 06                	je     802a61 <insert_sorted_with_merge_freeList+0x3d7>
  802a5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5f:	75 17                	jne    802a78 <insert_sorted_with_merge_freeList+0x3ee>
  802a61:	83 ec 04             	sub    $0x4,%esp
  802a64:	68 f0 39 80 00       	push   $0x8039f0
  802a69:	68 6b 01 00 00       	push   $0x16b
  802a6e:	68 b3 39 80 00       	push   $0x8039b3
  802a73:	e8 d9 04 00 00       	call   802f51 <_panic>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 50 04             	mov    0x4(%eax),%edx
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	89 50 04             	mov    %edx,0x4(%eax)
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8a:	89 10                	mov    %edx,(%eax)
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 04             	mov    0x4(%eax),%eax
  802a92:	85 c0                	test   %eax,%eax
  802a94:	74 0d                	je     802aa3 <insert_sorted_with_merge_freeList+0x419>
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 40 04             	mov    0x4(%eax),%eax
  802a9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9f:	89 10                	mov    %edx,(%eax)
  802aa1:	eb 08                	jmp    802aab <insert_sorted_with_merge_freeList+0x421>
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	a3 38 41 80 00       	mov    %eax,0x804138
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab1:	89 50 04             	mov    %edx,0x4(%eax)
  802ab4:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab9:	40                   	inc    %eax
  802aba:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802abf:	e9 d3 03 00 00       	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 50 08             	mov    0x8(%eax),%edx
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	8b 40 08             	mov    0x8(%eax),%eax
  802ad0:	39 c2                	cmp    %eax,%edx
  802ad2:	0f 86 da 00 00 00    	jbe    802bb2 <insert_sorted_with_merge_freeList+0x528>
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 50 08             	mov    0x8(%eax),%edx
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	8b 48 08             	mov    0x8(%eax),%ecx
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aea:	01 c8                	add    %ecx,%eax
  802aec:	39 c2                	cmp    %eax,%edx
  802aee:	0f 85 be 00 00 00    	jne    802bb2 <insert_sorted_with_merge_freeList+0x528>
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 04             	mov    0x4(%eax),%eax
  802b00:	8b 48 08             	mov    0x8(%eax),%ecx
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0c:	01 c8                	add    %ecx,%eax
  802b0e:	39 c2                	cmp    %eax,%edx
  802b10:	0f 84 9c 00 00 00    	je     802bb2 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	8b 50 08             	mov    0x8(%eax),%edx
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 50 0c             	mov    0xc(%eax),%edx
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2e:	01 c2                	add    %eax,%edx
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4e:	75 17                	jne    802b67 <insert_sorted_with_merge_freeList+0x4dd>
  802b50:	83 ec 04             	sub    $0x4,%esp
  802b53:	68 90 39 80 00       	push   $0x803990
  802b58:	68 74 01 00 00       	push   $0x174
  802b5d:	68 b3 39 80 00       	push   $0x8039b3
  802b62:	e8 ea 03 00 00       	call   802f51 <_panic>
  802b67:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	89 10                	mov    %edx,(%eax)
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 0d                	je     802b88 <insert_sorted_with_merge_freeList+0x4fe>
  802b7b:	a1 48 41 80 00       	mov    0x804148,%eax
  802b80:	8b 55 08             	mov    0x8(%ebp),%edx
  802b83:	89 50 04             	mov    %edx,0x4(%eax)
  802b86:	eb 08                	jmp    802b90 <insert_sorted_with_merge_freeList+0x506>
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	a3 48 41 80 00       	mov    %eax,0x804148
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ba7:	40                   	inc    %eax
  802ba8:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802bad:	e9 e5 02 00 00       	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 50 08             	mov    0x8(%eax),%edx
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	8b 40 08             	mov    0x8(%eax),%eax
  802bbe:	39 c2                	cmp    %eax,%edx
  802bc0:	0f 86 d7 00 00 00    	jbe    802c9d <insert_sorted_with_merge_freeList+0x613>
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 50 08             	mov    0x8(%eax),%edx
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	8b 48 08             	mov    0x8(%eax),%ecx
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd8:	01 c8                	add    %ecx,%eax
  802bda:	39 c2                	cmp    %eax,%edx
  802bdc:	0f 84 bb 00 00 00    	je     802c9d <insert_sorted_with_merge_freeList+0x613>
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 04             	mov    0x4(%eax),%eax
  802bee:	8b 48 08             	mov    0x8(%eax),%ecx
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 40 04             	mov    0x4(%eax),%eax
  802bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfa:	01 c8                	add    %ecx,%eax
  802bfc:	39 c2                	cmp    %eax,%edx
  802bfe:	0f 85 99 00 00 00    	jne    802c9d <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c10:	8b 50 0c             	mov    0xc(%eax),%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	8b 40 0c             	mov    0xc(%eax),%eax
  802c19:	01 c2                	add    %eax,%edx
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c39:	75 17                	jne    802c52 <insert_sorted_with_merge_freeList+0x5c8>
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	68 90 39 80 00       	push   $0x803990
  802c43:	68 7d 01 00 00       	push   $0x17d
  802c48:	68 b3 39 80 00       	push   $0x8039b3
  802c4d:	e8 ff 02 00 00       	call   802f51 <_panic>
  802c52:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	89 10                	mov    %edx,(%eax)
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	74 0d                	je     802c73 <insert_sorted_with_merge_freeList+0x5e9>
  802c66:	a1 48 41 80 00       	mov    0x804148,%eax
  802c6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6e:	89 50 04             	mov    %edx,0x4(%eax)
  802c71:	eb 08                	jmp    802c7b <insert_sorted_with_merge_freeList+0x5f1>
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	a3 48 41 80 00       	mov    %eax,0x804148
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8d:	a1 54 41 80 00       	mov    0x804154,%eax
  802c92:	40                   	inc    %eax
  802c93:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802c98:	e9 fa 01 00 00       	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 50 08             	mov    0x8(%eax),%edx
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 40 08             	mov    0x8(%eax),%eax
  802ca9:	39 c2                	cmp    %eax,%edx
  802cab:	0f 86 d2 01 00 00    	jbe    802e83 <insert_sorted_with_merge_freeList+0x7f9>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 50 08             	mov    0x8(%eax),%edx
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 48 08             	mov    0x8(%eax),%ecx
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc3:	01 c8                	add    %ecx,%eax
  802cc5:	39 c2                	cmp    %eax,%edx
  802cc7:	0f 85 b6 01 00 00    	jne    802e83 <insert_sorted_with_merge_freeList+0x7f9>
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 40 04             	mov    0x4(%eax),%eax
  802cd9:	8b 48 08             	mov    0x8(%eax),%ecx
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce5:	01 c8                	add    %ecx,%eax
  802ce7:	39 c2                	cmp    %eax,%edx
  802ce9:	0f 85 94 01 00 00    	jne    802e83 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf8:	8b 52 04             	mov    0x4(%edx),%edx
  802cfb:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  802d01:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802d04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d07:	8b 52 0c             	mov    0xc(%edx),%edx
  802d0a:	01 da                	add    %ebx,%edx
  802d0c:	01 ca                	add    %ecx,%edx
  802d0e:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802d25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d29:	75 17                	jne    802d42 <insert_sorted_with_merge_freeList+0x6b8>
  802d2b:	83 ec 04             	sub    $0x4,%esp
  802d2e:	68 25 3a 80 00       	push   $0x803a25
  802d33:	68 86 01 00 00       	push   $0x186
  802d38:	68 b3 39 80 00       	push   $0x8039b3
  802d3d:	e8 0f 02 00 00       	call   802f51 <_panic>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 10                	je     802d5b <insert_sorted_with_merge_freeList+0x6d1>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d53:	8b 52 04             	mov    0x4(%edx),%edx
  802d56:	89 50 04             	mov    %edx,0x4(%eax)
  802d59:	eb 0b                	jmp    802d66 <insert_sorted_with_merge_freeList+0x6dc>
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 0f                	je     802d7f <insert_sorted_with_merge_freeList+0x6f5>
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 40 04             	mov    0x4(%eax),%eax
  802d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d79:	8b 12                	mov    (%edx),%edx
  802d7b:	89 10                	mov    %edx,(%eax)
  802d7d:	eb 0a                	jmp    802d89 <insert_sorted_with_merge_freeList+0x6ff>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	a3 38 41 80 00       	mov    %eax,0x804138
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9c:	a1 44 41 80 00       	mov    0x804144,%eax
  802da1:	48                   	dec    %eax
  802da2:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dab:	75 17                	jne    802dc4 <insert_sorted_with_merge_freeList+0x73a>
  802dad:	83 ec 04             	sub    $0x4,%esp
  802db0:	68 90 39 80 00       	push   $0x803990
  802db5:	68 87 01 00 00       	push   $0x187
  802dba:	68 b3 39 80 00       	push   $0x8039b3
  802dbf:	e8 8d 01 00 00       	call   802f51 <_panic>
  802dc4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	89 10                	mov    %edx,(%eax)
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 00                	mov    (%eax),%eax
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	74 0d                	je     802de5 <insert_sorted_with_merge_freeList+0x75b>
  802dd8:	a1 48 41 80 00       	mov    0x804148,%eax
  802ddd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de0:	89 50 04             	mov    %edx,0x4(%eax)
  802de3:	eb 08                	jmp    802ded <insert_sorted_with_merge_freeList+0x763>
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	a3 48 41 80 00       	mov    %eax,0x804148
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dff:	a1 54 41 80 00       	mov    0x804154,%eax
  802e04:	40                   	inc    %eax
  802e05:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e22:	75 17                	jne    802e3b <insert_sorted_with_merge_freeList+0x7b1>
  802e24:	83 ec 04             	sub    $0x4,%esp
  802e27:	68 90 39 80 00       	push   $0x803990
  802e2c:	68 8a 01 00 00       	push   $0x18a
  802e31:	68 b3 39 80 00       	push   $0x8039b3
  802e36:	e8 16 01 00 00       	call   802f51 <_panic>
  802e3b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	89 10                	mov    %edx,(%eax)
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 0d                	je     802e5c <insert_sorted_with_merge_freeList+0x7d2>
  802e4f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e54:	8b 55 08             	mov    0x8(%ebp),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	eb 08                	jmp    802e64 <insert_sorted_with_merge_freeList+0x7da>
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e76:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7b:	40                   	inc    %eax
  802e7c:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  802e81:	eb 14                	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  802e8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8f:	0f 85 72 fb ff ff    	jne    802a07 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802e95:	eb 00                	jmp    802e97 <insert_sorted_with_merge_freeList+0x80d>
  802e97:	90                   	nop
  802e98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e9b:	c9                   	leave  
  802e9c:	c3                   	ret    

00802e9d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e9d:	55                   	push   %ebp
  802e9e:	89 e5                	mov    %esp,%ebp
  802ea0:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea6:	89 d0                	mov    %edx,%eax
  802ea8:	c1 e0 02             	shl    $0x2,%eax
  802eab:	01 d0                	add    %edx,%eax
  802ead:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802eb4:	01 d0                	add    %edx,%eax
  802eb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ebd:	01 d0                	add    %edx,%eax
  802ebf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ec6:	01 d0                	add    %edx,%eax
  802ec8:	c1 e0 04             	shl    $0x4,%eax
  802ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802ece:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ed5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ed8:	83 ec 0c             	sub    $0xc,%esp
  802edb:	50                   	push   %eax
  802edc:	e8 7b eb ff ff       	call   801a5c <sys_get_virtual_time>
  802ee1:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ee4:	eb 41                	jmp    802f27 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ee6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ee9:	83 ec 0c             	sub    $0xc,%esp
  802eec:	50                   	push   %eax
  802eed:	e8 6a eb ff ff       	call   801a5c <sys_get_virtual_time>
  802ef2:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ef5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efb:	29 c2                	sub    %eax,%edx
  802efd:	89 d0                	mov    %edx,%eax
  802eff:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802f02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f08:	89 d1                	mov    %edx,%ecx
  802f0a:	29 c1                	sub    %eax,%ecx
  802f0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f12:	39 c2                	cmp    %eax,%edx
  802f14:	0f 97 c0             	seta   %al
  802f17:	0f b6 c0             	movzbl %al,%eax
  802f1a:	29 c1                	sub    %eax,%ecx
  802f1c:	89 c8                	mov    %ecx,%eax
  802f1e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f2d:	72 b7                	jb     802ee6 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f2f:	90                   	nop
  802f30:	c9                   	leave  
  802f31:	c3                   	ret    

00802f32 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f32:	55                   	push   %ebp
  802f33:	89 e5                	mov    %esp,%ebp
  802f35:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f3f:	eb 03                	jmp    802f44 <busy_wait+0x12>
  802f41:	ff 45 fc             	incl   -0x4(%ebp)
  802f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4a:	72 f5                	jb     802f41 <busy_wait+0xf>
	return i;
  802f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f4f:	c9                   	leave  
  802f50:	c3                   	ret    

00802f51 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f51:	55                   	push   %ebp
  802f52:	89 e5                	mov    %esp,%ebp
  802f54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f57:	8d 45 10             	lea    0x10(%ebp),%eax
  802f5a:	83 c0 04             	add    $0x4,%eax
  802f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f60:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	74 16                	je     802f7f <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f69:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f6e:	83 ec 08             	sub    $0x8,%esp
  802f71:	50                   	push   %eax
  802f72:	68 44 3a 80 00       	push   $0x803a44
  802f77:	e8 00 d4 ff ff       	call   80037c <cprintf>
  802f7c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f7f:	a1 00 40 80 00       	mov    0x804000,%eax
  802f84:	ff 75 0c             	pushl  0xc(%ebp)
  802f87:	ff 75 08             	pushl  0x8(%ebp)
  802f8a:	50                   	push   %eax
  802f8b:	68 49 3a 80 00       	push   $0x803a49
  802f90:	e8 e7 d3 ff ff       	call   80037c <cprintf>
  802f95:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f98:	8b 45 10             	mov    0x10(%ebp),%eax
  802f9b:	83 ec 08             	sub    $0x8,%esp
  802f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa1:	50                   	push   %eax
  802fa2:	e8 6a d3 ff ff       	call   800311 <vcprintf>
  802fa7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802faa:	83 ec 08             	sub    $0x8,%esp
  802fad:	6a 00                	push   $0x0
  802faf:	68 65 3a 80 00       	push   $0x803a65
  802fb4:	e8 58 d3 ff ff       	call   800311 <vcprintf>
  802fb9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802fbc:	e8 d9 d2 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  802fc1:	eb fe                	jmp    802fc1 <_panic+0x70>

00802fc3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802fc3:	55                   	push   %ebp
  802fc4:	89 e5                	mov    %esp,%ebp
  802fc6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802fc9:	a1 20 40 80 00       	mov    0x804020,%eax
  802fce:	8b 50 74             	mov    0x74(%eax),%edx
  802fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd4:	39 c2                	cmp    %eax,%edx
  802fd6:	74 14                	je     802fec <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 68 3a 80 00       	push   $0x803a68
  802fe0:	6a 26                	push   $0x26
  802fe2:	68 b4 3a 80 00       	push   $0x803ab4
  802fe7:	e8 65 ff ff ff       	call   802f51 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802ff3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ffa:	e9 c2 00 00 00       	jmp    8030c1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803002:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	01 d0                	add    %edx,%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	75 08                	jne    80301c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803014:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803017:	e9 a2 00 00 00       	jmp    8030be <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80301c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803023:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80302a:	eb 69                	jmp    803095 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80302c:	a1 20 40 80 00       	mov    0x804020,%eax
  803031:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803037:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303a:	89 d0                	mov    %edx,%eax
  80303c:	01 c0                	add    %eax,%eax
  80303e:	01 d0                	add    %edx,%eax
  803040:	c1 e0 03             	shl    $0x3,%eax
  803043:	01 c8                	add    %ecx,%eax
  803045:	8a 40 04             	mov    0x4(%eax),%al
  803048:	84 c0                	test   %al,%al
  80304a:	75 46                	jne    803092 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80304c:	a1 20 40 80 00       	mov    0x804020,%eax
  803051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803057:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305a:	89 d0                	mov    %edx,%eax
  80305c:	01 c0                	add    %eax,%eax
  80305e:	01 d0                	add    %edx,%eax
  803060:	c1 e0 03             	shl    $0x3,%eax
  803063:	01 c8                	add    %ecx,%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80306a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803072:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803077:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	01 c8                	add    %ecx,%eax
  803083:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803085:	39 c2                	cmp    %eax,%edx
  803087:	75 09                	jne    803092 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803089:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803090:	eb 12                	jmp    8030a4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803092:	ff 45 e8             	incl   -0x18(%ebp)
  803095:	a1 20 40 80 00       	mov    0x804020,%eax
  80309a:	8b 50 74             	mov    0x74(%eax),%edx
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	39 c2                	cmp    %eax,%edx
  8030a2:	77 88                	ja     80302c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8030a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a8:	75 14                	jne    8030be <CheckWSWithoutLastIndex+0xfb>
			panic(
  8030aa:	83 ec 04             	sub    $0x4,%esp
  8030ad:	68 c0 3a 80 00       	push   $0x803ac0
  8030b2:	6a 3a                	push   $0x3a
  8030b4:	68 b4 3a 80 00       	push   $0x803ab4
  8030b9:	e8 93 fe ff ff       	call   802f51 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8030be:	ff 45 f0             	incl   -0x10(%ebp)
  8030c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030c7:	0f 8c 32 ff ff ff    	jl     802fff <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8030cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030db:	eb 26                	jmp    803103 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8030e2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030eb:	89 d0                	mov    %edx,%eax
  8030ed:	01 c0                	add    %eax,%eax
  8030ef:	01 d0                	add    %edx,%eax
  8030f1:	c1 e0 03             	shl    $0x3,%eax
  8030f4:	01 c8                	add    %ecx,%eax
  8030f6:	8a 40 04             	mov    0x4(%eax),%al
  8030f9:	3c 01                	cmp    $0x1,%al
  8030fb:	75 03                	jne    803100 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8030fd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803100:	ff 45 e0             	incl   -0x20(%ebp)
  803103:	a1 20 40 80 00       	mov    0x804020,%eax
  803108:	8b 50 74             	mov    0x74(%eax),%edx
  80310b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310e:	39 c2                	cmp    %eax,%edx
  803110:	77 cb                	ja     8030dd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803118:	74 14                	je     80312e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	68 14 3b 80 00       	push   $0x803b14
  803122:	6a 44                	push   $0x44
  803124:	68 b4 3a 80 00       	push   $0x803ab4
  803129:	e8 23 fe ff ff       	call   802f51 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80312e:	90                   	nop
  80312f:	c9                   	leave  
  803130:	c3                   	ret    
  803131:	66 90                	xchg   %ax,%ax
  803133:	90                   	nop

00803134 <__udivdi3>:
  803134:	55                   	push   %ebp
  803135:	57                   	push   %edi
  803136:	56                   	push   %esi
  803137:	53                   	push   %ebx
  803138:	83 ec 1c             	sub    $0x1c,%esp
  80313b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80313f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803143:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803147:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80314b:	89 ca                	mov    %ecx,%edx
  80314d:	89 f8                	mov    %edi,%eax
  80314f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803153:	85 f6                	test   %esi,%esi
  803155:	75 2d                	jne    803184 <__udivdi3+0x50>
  803157:	39 cf                	cmp    %ecx,%edi
  803159:	77 65                	ja     8031c0 <__udivdi3+0x8c>
  80315b:	89 fd                	mov    %edi,%ebp
  80315d:	85 ff                	test   %edi,%edi
  80315f:	75 0b                	jne    80316c <__udivdi3+0x38>
  803161:	b8 01 00 00 00       	mov    $0x1,%eax
  803166:	31 d2                	xor    %edx,%edx
  803168:	f7 f7                	div    %edi
  80316a:	89 c5                	mov    %eax,%ebp
  80316c:	31 d2                	xor    %edx,%edx
  80316e:	89 c8                	mov    %ecx,%eax
  803170:	f7 f5                	div    %ebp
  803172:	89 c1                	mov    %eax,%ecx
  803174:	89 d8                	mov    %ebx,%eax
  803176:	f7 f5                	div    %ebp
  803178:	89 cf                	mov    %ecx,%edi
  80317a:	89 fa                	mov    %edi,%edx
  80317c:	83 c4 1c             	add    $0x1c,%esp
  80317f:	5b                   	pop    %ebx
  803180:	5e                   	pop    %esi
  803181:	5f                   	pop    %edi
  803182:	5d                   	pop    %ebp
  803183:	c3                   	ret    
  803184:	39 ce                	cmp    %ecx,%esi
  803186:	77 28                	ja     8031b0 <__udivdi3+0x7c>
  803188:	0f bd fe             	bsr    %esi,%edi
  80318b:	83 f7 1f             	xor    $0x1f,%edi
  80318e:	75 40                	jne    8031d0 <__udivdi3+0x9c>
  803190:	39 ce                	cmp    %ecx,%esi
  803192:	72 0a                	jb     80319e <__udivdi3+0x6a>
  803194:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803198:	0f 87 9e 00 00 00    	ja     80323c <__udivdi3+0x108>
  80319e:	b8 01 00 00 00       	mov    $0x1,%eax
  8031a3:	89 fa                	mov    %edi,%edx
  8031a5:	83 c4 1c             	add    $0x1c,%esp
  8031a8:	5b                   	pop    %ebx
  8031a9:	5e                   	pop    %esi
  8031aa:	5f                   	pop    %edi
  8031ab:	5d                   	pop    %ebp
  8031ac:	c3                   	ret    
  8031ad:	8d 76 00             	lea    0x0(%esi),%esi
  8031b0:	31 ff                	xor    %edi,%edi
  8031b2:	31 c0                	xor    %eax,%eax
  8031b4:	89 fa                	mov    %edi,%edx
  8031b6:	83 c4 1c             	add    $0x1c,%esp
  8031b9:	5b                   	pop    %ebx
  8031ba:	5e                   	pop    %esi
  8031bb:	5f                   	pop    %edi
  8031bc:	5d                   	pop    %ebp
  8031bd:	c3                   	ret    
  8031be:	66 90                	xchg   %ax,%ax
  8031c0:	89 d8                	mov    %ebx,%eax
  8031c2:	f7 f7                	div    %edi
  8031c4:	31 ff                	xor    %edi,%edi
  8031c6:	89 fa                	mov    %edi,%edx
  8031c8:	83 c4 1c             	add    $0x1c,%esp
  8031cb:	5b                   	pop    %ebx
  8031cc:	5e                   	pop    %esi
  8031cd:	5f                   	pop    %edi
  8031ce:	5d                   	pop    %ebp
  8031cf:	c3                   	ret    
  8031d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031d5:	89 eb                	mov    %ebp,%ebx
  8031d7:	29 fb                	sub    %edi,%ebx
  8031d9:	89 f9                	mov    %edi,%ecx
  8031db:	d3 e6                	shl    %cl,%esi
  8031dd:	89 c5                	mov    %eax,%ebp
  8031df:	88 d9                	mov    %bl,%cl
  8031e1:	d3 ed                	shr    %cl,%ebp
  8031e3:	89 e9                	mov    %ebp,%ecx
  8031e5:	09 f1                	or     %esi,%ecx
  8031e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031eb:	89 f9                	mov    %edi,%ecx
  8031ed:	d3 e0                	shl    %cl,%eax
  8031ef:	89 c5                	mov    %eax,%ebp
  8031f1:	89 d6                	mov    %edx,%esi
  8031f3:	88 d9                	mov    %bl,%cl
  8031f5:	d3 ee                	shr    %cl,%esi
  8031f7:	89 f9                	mov    %edi,%ecx
  8031f9:	d3 e2                	shl    %cl,%edx
  8031fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ff:	88 d9                	mov    %bl,%cl
  803201:	d3 e8                	shr    %cl,%eax
  803203:	09 c2                	or     %eax,%edx
  803205:	89 d0                	mov    %edx,%eax
  803207:	89 f2                	mov    %esi,%edx
  803209:	f7 74 24 0c          	divl   0xc(%esp)
  80320d:	89 d6                	mov    %edx,%esi
  80320f:	89 c3                	mov    %eax,%ebx
  803211:	f7 e5                	mul    %ebp
  803213:	39 d6                	cmp    %edx,%esi
  803215:	72 19                	jb     803230 <__udivdi3+0xfc>
  803217:	74 0b                	je     803224 <__udivdi3+0xf0>
  803219:	89 d8                	mov    %ebx,%eax
  80321b:	31 ff                	xor    %edi,%edi
  80321d:	e9 58 ff ff ff       	jmp    80317a <__udivdi3+0x46>
  803222:	66 90                	xchg   %ax,%ax
  803224:	8b 54 24 08          	mov    0x8(%esp),%edx
  803228:	89 f9                	mov    %edi,%ecx
  80322a:	d3 e2                	shl    %cl,%edx
  80322c:	39 c2                	cmp    %eax,%edx
  80322e:	73 e9                	jae    803219 <__udivdi3+0xe5>
  803230:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803233:	31 ff                	xor    %edi,%edi
  803235:	e9 40 ff ff ff       	jmp    80317a <__udivdi3+0x46>
  80323a:	66 90                	xchg   %ax,%ax
  80323c:	31 c0                	xor    %eax,%eax
  80323e:	e9 37 ff ff ff       	jmp    80317a <__udivdi3+0x46>
  803243:	90                   	nop

00803244 <__umoddi3>:
  803244:	55                   	push   %ebp
  803245:	57                   	push   %edi
  803246:	56                   	push   %esi
  803247:	53                   	push   %ebx
  803248:	83 ec 1c             	sub    $0x1c,%esp
  80324b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80324f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803253:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803257:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80325b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80325f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803263:	89 f3                	mov    %esi,%ebx
  803265:	89 fa                	mov    %edi,%edx
  803267:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80326b:	89 34 24             	mov    %esi,(%esp)
  80326e:	85 c0                	test   %eax,%eax
  803270:	75 1a                	jne    80328c <__umoddi3+0x48>
  803272:	39 f7                	cmp    %esi,%edi
  803274:	0f 86 a2 00 00 00    	jbe    80331c <__umoddi3+0xd8>
  80327a:	89 c8                	mov    %ecx,%eax
  80327c:	89 f2                	mov    %esi,%edx
  80327e:	f7 f7                	div    %edi
  803280:	89 d0                	mov    %edx,%eax
  803282:	31 d2                	xor    %edx,%edx
  803284:	83 c4 1c             	add    $0x1c,%esp
  803287:	5b                   	pop    %ebx
  803288:	5e                   	pop    %esi
  803289:	5f                   	pop    %edi
  80328a:	5d                   	pop    %ebp
  80328b:	c3                   	ret    
  80328c:	39 f0                	cmp    %esi,%eax
  80328e:	0f 87 ac 00 00 00    	ja     803340 <__umoddi3+0xfc>
  803294:	0f bd e8             	bsr    %eax,%ebp
  803297:	83 f5 1f             	xor    $0x1f,%ebp
  80329a:	0f 84 ac 00 00 00    	je     80334c <__umoddi3+0x108>
  8032a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8032a5:	29 ef                	sub    %ebp,%edi
  8032a7:	89 fe                	mov    %edi,%esi
  8032a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032ad:	89 e9                	mov    %ebp,%ecx
  8032af:	d3 e0                	shl    %cl,%eax
  8032b1:	89 d7                	mov    %edx,%edi
  8032b3:	89 f1                	mov    %esi,%ecx
  8032b5:	d3 ef                	shr    %cl,%edi
  8032b7:	09 c7                	or     %eax,%edi
  8032b9:	89 e9                	mov    %ebp,%ecx
  8032bb:	d3 e2                	shl    %cl,%edx
  8032bd:	89 14 24             	mov    %edx,(%esp)
  8032c0:	89 d8                	mov    %ebx,%eax
  8032c2:	d3 e0                	shl    %cl,%eax
  8032c4:	89 c2                	mov    %eax,%edx
  8032c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ca:	d3 e0                	shl    %cl,%eax
  8032cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d4:	89 f1                	mov    %esi,%ecx
  8032d6:	d3 e8                	shr    %cl,%eax
  8032d8:	09 d0                	or     %edx,%eax
  8032da:	d3 eb                	shr    %cl,%ebx
  8032dc:	89 da                	mov    %ebx,%edx
  8032de:	f7 f7                	div    %edi
  8032e0:	89 d3                	mov    %edx,%ebx
  8032e2:	f7 24 24             	mull   (%esp)
  8032e5:	89 c6                	mov    %eax,%esi
  8032e7:	89 d1                	mov    %edx,%ecx
  8032e9:	39 d3                	cmp    %edx,%ebx
  8032eb:	0f 82 87 00 00 00    	jb     803378 <__umoddi3+0x134>
  8032f1:	0f 84 91 00 00 00    	je     803388 <__umoddi3+0x144>
  8032f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032fb:	29 f2                	sub    %esi,%edx
  8032fd:	19 cb                	sbb    %ecx,%ebx
  8032ff:	89 d8                	mov    %ebx,%eax
  803301:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803305:	d3 e0                	shl    %cl,%eax
  803307:	89 e9                	mov    %ebp,%ecx
  803309:	d3 ea                	shr    %cl,%edx
  80330b:	09 d0                	or     %edx,%eax
  80330d:	89 e9                	mov    %ebp,%ecx
  80330f:	d3 eb                	shr    %cl,%ebx
  803311:	89 da                	mov    %ebx,%edx
  803313:	83 c4 1c             	add    $0x1c,%esp
  803316:	5b                   	pop    %ebx
  803317:	5e                   	pop    %esi
  803318:	5f                   	pop    %edi
  803319:	5d                   	pop    %ebp
  80331a:	c3                   	ret    
  80331b:	90                   	nop
  80331c:	89 fd                	mov    %edi,%ebp
  80331e:	85 ff                	test   %edi,%edi
  803320:	75 0b                	jne    80332d <__umoddi3+0xe9>
  803322:	b8 01 00 00 00       	mov    $0x1,%eax
  803327:	31 d2                	xor    %edx,%edx
  803329:	f7 f7                	div    %edi
  80332b:	89 c5                	mov    %eax,%ebp
  80332d:	89 f0                	mov    %esi,%eax
  80332f:	31 d2                	xor    %edx,%edx
  803331:	f7 f5                	div    %ebp
  803333:	89 c8                	mov    %ecx,%eax
  803335:	f7 f5                	div    %ebp
  803337:	89 d0                	mov    %edx,%eax
  803339:	e9 44 ff ff ff       	jmp    803282 <__umoddi3+0x3e>
  80333e:	66 90                	xchg   %ax,%ax
  803340:	89 c8                	mov    %ecx,%eax
  803342:	89 f2                	mov    %esi,%edx
  803344:	83 c4 1c             	add    $0x1c,%esp
  803347:	5b                   	pop    %ebx
  803348:	5e                   	pop    %esi
  803349:	5f                   	pop    %edi
  80334a:	5d                   	pop    %ebp
  80334b:	c3                   	ret    
  80334c:	3b 04 24             	cmp    (%esp),%eax
  80334f:	72 06                	jb     803357 <__umoddi3+0x113>
  803351:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803355:	77 0f                	ja     803366 <__umoddi3+0x122>
  803357:	89 f2                	mov    %esi,%edx
  803359:	29 f9                	sub    %edi,%ecx
  80335b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80335f:	89 14 24             	mov    %edx,(%esp)
  803362:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803366:	8b 44 24 04          	mov    0x4(%esp),%eax
  80336a:	8b 14 24             	mov    (%esp),%edx
  80336d:	83 c4 1c             	add    $0x1c,%esp
  803370:	5b                   	pop    %ebx
  803371:	5e                   	pop    %esi
  803372:	5f                   	pop    %edi
  803373:	5d                   	pop    %ebp
  803374:	c3                   	ret    
  803375:	8d 76 00             	lea    0x0(%esi),%esi
  803378:	2b 04 24             	sub    (%esp),%eax
  80337b:	19 fa                	sbb    %edi,%edx
  80337d:	89 d1                	mov    %edx,%ecx
  80337f:	89 c6                	mov    %eax,%esi
  803381:	e9 71 ff ff ff       	jmp    8032f7 <__umoddi3+0xb3>
  803386:	66 90                	xchg   %ax,%ax
  803388:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80338c:	72 ea                	jb     803378 <__umoddi3+0x134>
  80338e:	89 d9                	mov    %ebx,%ecx
  803390:	e9 62 ff ff ff       	jmp    8032f7 <__umoddi3+0xb3>
