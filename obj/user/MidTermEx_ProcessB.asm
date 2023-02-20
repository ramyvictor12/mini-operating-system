
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
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
  80003e:	e8 e5 19 00 00       	call   801a28 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 33 80 00       	push   $0x8033a0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 99 14 00 00       	call   8014ef <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 33 80 00       	push   $0x8033a2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 83 14 00 00       	call   8014ef <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 33 80 00       	push   $0x8033a9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 6d 14 00 00       	call   8014ef <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 b7 33 80 00       	push   $0x8033b7
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 27 18 00 00       	call   8018c9 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 aa 19 00 00       	call   801a5b <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 c3 2d 00 00       	call   802e9c <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 6a 19 00 00       	call   801a5b <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 83 2d 00 00       	call   802e9c <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 2b 19 00 00       	call   801a5b <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 44 2d 00 00       	call   802e9c <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 99 18 00 00       	call   801a0f <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	01 d0                	add    %edx,%eax
  800190:	c1 e0 04             	shl    $0x4,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019d:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 0f                	je     8001bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001bf:	7e 0a                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 5f fe ff ff       	call   800038 <_main>
  8001d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dc:	e8 3b 16 00 00       	call   80181c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 d4 33 80 00       	push   $0x8033d4
  8001e9:	e8 8d 01 00 00       	call   80037b <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 fc 33 80 00       	push   $0x8033fc
  800211:	e8 65 01 00 00       	call   80037b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 40 80 00       	mov    0x804020,%eax
  80021e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 24 34 80 00       	push   $0x803424
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 7c 34 80 00       	push   $0x80347c
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 d4 33 80 00       	push   $0x8033d4
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 bb 15 00 00       	call   801836 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027b:	e8 19 00 00 00       	call   800299 <exit>
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	6a 00                	push   $0x0
  80028e:	e8 48 17 00 00       	call   8019db <sys_destroy_env>
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <exit>:

void
exit(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029f:	e8 9d 17 00 00       	call   801a41 <sys_exit_env>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 0a                	mov    %ecx,(%edx)
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	88 d1                	mov    %dl,%cl
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 2c                	jne    8002fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d2:	a0 24 40 80 00       	mov    0x804024,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	8b 12                	mov    (%edx),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	83 c2 08             	add    $0x8,%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	e8 7c 13 00 00       	call   80166e <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 40 04             	mov    0x4(%eax),%eax
  800304:	8d 50 01             	lea    0x1(%eax),%edx
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800320:	00 00 00 
	b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	68 a7 02 80 00       	push   $0x8002a7
  80033f:	e8 11 02 00 00       	call   800555 <vprintfmt>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800347:	a0 24 40 80 00       	mov    0x804024,%al
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	50                   	push   %eax
  800359:	52                   	push   %edx
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	50                   	push   %eax
  800364:	e8 05 13 00 00       	call   80166e <sys_cputs>
  800369:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800381:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 f4             	pushl  -0xc(%ebp)
  800397:	50                   	push   %eax
  800398:	e8 73 ff ff ff       	call   800310 <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ae:	e8 69 14 00 00       	call   80181c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 48 ff ff ff       	call   800310 <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ce:	e8 63 14 00 00       	call   801836 <sys_enable_interrupt>
	return cnt;
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 14             	sub    $0x14,%esp
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f6:	77 55                	ja     80044d <printnum+0x75>
  8003f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fb:	72 05                	jb     800402 <printnum+0x2a>
  8003fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800400:	77 4b                	ja     80044d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800405:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	ff 75 f0             	pushl  -0x10(%ebp)
  800418:	e8 13 2d 00 00       	call   803130 <__udivdi3>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	53                   	push   %ebx
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 a1 ff ff ff       	call   8003d8 <printnum>
  800437:	83 c4 20             	add    $0x20,%esp
  80043a:	eb 1a                	jmp    800456 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 20             	pushl  0x20(%ebp)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	ff d0                	call   *%eax
  80044a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044d:	ff 4d 1c             	decl   0x1c(%ebp)
  800450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800454:	7f e6                	jg     80043c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	53                   	push   %ebx
  800465:	51                   	push   %ecx
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	e8 d3 2d 00 00       	call   803240 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 b4 36 80 00       	add    $0x8036b4,%eax
  800475:	8a 00                	mov    (%eax),%al
  800477:	0f be c0             	movsbl %al,%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800496:	7e 1c                	jle    8004b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 08             	lea    0x8(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 08             	sub    $0x8,%eax
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 40                	jmp    8004f4 <getuint+0x65>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 1e                	je     8004d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1c                	jmp    8004f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fd:	7e 1c                	jle    80051b <getint+0x25>
		return va_arg(*ap, long long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 08             	lea    0x8(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	8b 50 04             	mov    0x4(%eax),%edx
  800517:	8b 00                	mov    (%eax),%eax
  800519:	eb 38                	jmp    800553 <getint+0x5d>
	else if (lflag)
  80051b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051f:	74 1a                	je     80053b <getint+0x45>
		return va_arg(*ap, long);
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	99                   	cltd   
  800539:	eb 18                	jmp    800553 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x21>
			if (ch == '\0')
  80055f:	85 db                	test   %ebx,%ebx
  800561:	0f 84 af 03 00 00    	je     800916 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	83 fb 25             	cmp    $0x25,%ebx
  800587:	75 d6                	jne    80055f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800589:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800594:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	8d 50 01             	lea    0x1(%eax),%edx
  8005af:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b2:	8a 00                	mov    (%eax),%al
  8005b4:	0f b6 d8             	movzbl %al,%ebx
  8005b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ba:	83 f8 55             	cmp    $0x55,%eax
  8005bd:	0f 87 2b 03 00 00    	ja     8008ee <vprintfmt+0x399>
  8005c3:	8b 04 85 d8 36 80 00 	mov    0x8036d8(,%eax,4),%eax
  8005ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d0:	eb d7                	jmp    8005a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d6:	eb d1                	jmp    8005a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	01 c0                	add    %eax,%eax
  8005eb:	01 d8                	add    %ebx,%eax
  8005ed:	83 e8 30             	sub    $0x30,%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8a 00                	mov    (%eax),%al
  8005f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fe:	7e 3e                	jle    80063e <vprintfmt+0xe9>
  800600:	83 fb 39             	cmp    $0x39,%ebx
  800603:	7f 39                	jg     80063e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800605:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800608:	eb d5                	jmp    8005df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061e:	eb 1f                	jmp    80063f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	79 83                	jns    8005a9 <vprintfmt+0x54>
				width = 0;
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800632:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800639:	e9 6b ff ff ff       	jmp    8005a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	0f 89 60 ff ff ff    	jns    8005a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800656:	e9 4e ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065e:	e9 46 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 c0 04             	add    $0x4,%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			break;
  800683:	e9 89 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800699:	85 db                	test   %ebx,%ebx
  80069b:	79 02                	jns    80069f <vprintfmt+0x14a>
				err = -err;
  80069d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069f:	83 fb 64             	cmp    $0x64,%ebx
  8006a2:	7f 0b                	jg     8006af <vprintfmt+0x15a>
  8006a4:	8b 34 9d 20 35 80 00 	mov    0x803520(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 c5 36 80 00       	push   $0x8036c5
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 5e 02 00 00       	call   80091e <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c3:	e9 49 02 00 00       	jmp    800911 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c8:	56                   	push   %esi
  8006c9:	68 ce 36 80 00       	push   $0x8036ce
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 45 02 00 00       	call   80091e <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			break;
  8006dc:	e9 30 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 30                	mov    (%eax),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 05                	jne    8006fb <vprintfmt+0x1a6>
				p = "(null)";
  8006f6:	be d1 36 80 00       	mov    $0x8036d1,%esi
			if (width > 0 && padc != '-')
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7e 6d                	jle    80076e <vprintfmt+0x219>
  800701:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800705:	74 67                	je     80076e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	e8 0c 03 00 00       	call   800a20 <strnlen>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071a:	eb 16                	jmp    800732 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e4                	jg     80071c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	eb 34                	jmp    80076e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073e:	74 1c                	je     80075c <vprintfmt+0x207>
  800740:	83 fb 1f             	cmp    $0x1f,%ebx
  800743:	7e 05                	jle    80074a <vprintfmt+0x1f5>
  800745:	83 fb 7e             	cmp    $0x7e,%ebx
  800748:	7e 12                	jle    80075c <vprintfmt+0x207>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 3f                	push   $0x3f
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	89 f0                	mov    %esi,%eax
  800770:	8d 70 01             	lea    0x1(%eax),%esi
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be d8             	movsbl %al,%ebx
  800778:	85 db                	test   %ebx,%ebx
  80077a:	74 24                	je     8007a0 <vprintfmt+0x24b>
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	78 b8                	js     80073a <vprintfmt+0x1e5>
  800782:	ff 4d e0             	decl   -0x20(%ebp)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 af                	jns    80073a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 20                	push   $0x20
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079d:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a4:	7f e7                	jg     80078d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a6:	e9 66 01 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	e8 3c fd ff ff       	call   8004f6 <getint>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 23                	jns    8007f0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	f7 d8                	neg    %eax
  8007e5:	83 d2 00             	adc    $0x0,%edx
  8007e8:	f7 da                	neg    %edx
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f7:	e9 bc 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 84 fc ff ff       	call   80048f <getuint>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 98 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 58                	push   $0x58
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 58                	push   $0x58
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			break;
  800850:	e9 bc 00 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 30                	push   $0x30
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 78                	push   $0x78
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800890:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800897:	eb 1f                	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 e7 fb ff ff       	call   80048f <getuint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	52                   	push   %edx
  8008c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 00 fb ff ff       	call   8003d8 <printnum>
  8008d8:	83 c4 20             	add    $0x20,%esp
			break;
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	53                   	push   %ebx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ec:	eb 23                	jmp    800911 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 25                	push   $0x25
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fe:	ff 4d 10             	decl   0x10(%ebp)
  800901:	eb 03                	jmp    800906 <vprintfmt+0x3b1>
  800903:	ff 4d 10             	decl   0x10(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	48                   	dec    %eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	3c 25                	cmp    $0x25,%al
  80090e:	75 f3                	jne    800903 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800910:	90                   	nop
		}
	}
  800911:	e9 47 fc ff ff       	jmp    80055d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800916:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 16 fc ff ff       	call   800555 <vprintfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800942:	90                   	nop
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 40 08             	mov    0x8(%eax),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8b 40 04             	mov    0x4(%eax),%eax
  800962:	39 c2                	cmp    %eax,%edx
  800964:	73 12                	jae    800978 <sprintputch+0x33>
		*b->buf++ = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 10                	mov    %dl,(%eax)
}
  800978:	90                   	nop
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a0:	74 06                	je     8009a8 <vsnprintf+0x2d>
  8009a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a6:	7f 07                	jg     8009af <vsnprintf+0x34>
		return -E_INVAL;
  8009a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ad:	eb 20                	jmp    8009cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009af:	ff 75 14             	pushl  0x14(%ebp)
  8009b2:	ff 75 10             	pushl  0x10(%ebp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 45 09 80 00       	push   $0x800945
  8009be:	e8 92 fb ff ff       	call   800555 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 89 ff ff ff       	call   80097b <vsnprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 06                	jmp    800a12 <strlen+0x15>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 f1                	jne    800a0c <strlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2d:	eb 09                	jmp    800a38 <strnlen+0x18>
		n++;
  800a2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 4d 0c             	decl   0xc(%ebp)
  800a38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3c:	74 09                	je     800a47 <strnlen+0x27>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e8                	jne    800a2f <strnlen+0xf>
		n++;
	return n;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a58:	90                   	nop
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8d 50 01             	lea    0x1(%eax),%edx
  800a5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6b:	8a 12                	mov    (%edx),%dl
  800a6d:	88 10                	mov    %dl,(%eax)
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8d:	eb 1f                	jmp    800aae <strncpy+0x34>
		*dst++ = *src;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8a 12                	mov    (%edx),%dl
  800a9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 03                	je     800aab <strncpy+0x31>
			src++;
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aab:	ff 45 fc             	incl   -0x4(%ebp)
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab4:	72 d9                	jb     800a8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acb:	74 30                	je     800afd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acd:	eb 16                	jmp    800ae5 <strlcpy+0x2a>
			*dst++ = *src++;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ade:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae1:	8a 12                	mov    (%edx),%dl
  800ae3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae5:	ff 4d 10             	decl   0x10(%ebp)
  800ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aec:	74 09                	je     800af7 <strlcpy+0x3c>
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 d8                	jne    800acf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strcmp+0xb>
		p++, q++;
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strcmp+0x22>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 e3                	je     800b0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f b6 d0             	movzbl %al,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	29 c2                	sub    %eax,%edx
  800b3d:	89 d0                	mov    %edx,%eax
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b44:	eb 09                	jmp    800b4f <strncmp+0xe>
		n--, p++, q++;
  800b46:	ff 4d 10             	decl   0x10(%ebp)
  800b49:	ff 45 08             	incl   0x8(%ebp)
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b53:	74 17                	je     800b6c <strncmp+0x2b>
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 0e                	je     800b6c <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 10                	mov    (%eax),%dl
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	38 c2                	cmp    %al,%dl
  800b6a:	74 da                	je     800b46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	75 07                	jne    800b79 <strncmp+0x38>
		return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	eb 14                	jmp    800b8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9b:	eb 12                	jmp    800baf <strchr+0x20>
		if (*s == c)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba5:	75 05                	jne    800bac <strchr+0x1d>
			return (char *) s;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	eb 11                	jmp    800bbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e5                	jne    800b9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcb:	eb 0d                	jmp    800bda <strfind+0x1b>
		if (*s == c)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd5:	74 0e                	je     800be5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 ea                	jne    800bcd <strfind+0xe>
  800be3:	eb 01                	jmp    800be6 <strfind+0x27>
		if (*s == c)
			break;
  800be5:	90                   	nop
	return (char *) s;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfd:	eb 0e                	jmp    800c0d <memset+0x22>
		*p++ = c;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c14:	79 e9                	jns    800bff <memset+0x14>
		*p++ = c;

	return v;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2d:	eb 16                	jmp    800c45 <memcpy+0x2a>
		*d++ = *s++;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 dd                	jne    800c2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6f:	73 50                	jae    800cc1 <memmove+0x6a>
  800c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7c:	76 43                	jbe    800cc1 <memmove+0x6a>
		s += n;
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8a:	eb 10                	jmp    800c9c <memmove+0x45>
			*--d = *--s;
  800c8c:	ff 4d f8             	decl   -0x8(%ebp)
  800c8f:	ff 4d fc             	decl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	8a 10                	mov    (%eax),%dl
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 e3                	jne    800c8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca9:	eb 23                	jmp    800cce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 dd                	jne    800cab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce5:	eb 2a                	jmp    800d11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 16                	je     800d0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
  800d09:	eb 18                	jmp    800d23 <memcmp+0x50>
		s1++, s2++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
  800d0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 c9                	jne    800ce7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d36:	eb 15                	jmp    800d4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	74 0d                	je     800d57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d53:	72 e3                	jb     800d38 <memfind+0x13>
  800d55:	eb 01                	jmp    800d58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d57:	90                   	nop
	return (void *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	eb 03                	jmp    800d76 <strtol+0x19>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 20                	cmp    $0x20,%al
  800d7d:	74 f4                	je     800d73 <strtol+0x16>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 09                	cmp    $0x9,%al
  800d86:	74 eb                	je     800d73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 2b                	cmp    $0x2b,%al
  800d8f:	75 05                	jne    800d96 <strtol+0x39>
		s++;
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	eb 13                	jmp    800da9 <strtol+0x4c>
	else if (*s == '-')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 2d                	cmp    $0x2d,%al
  800d9d:	75 0a                	jne    800da9 <strtol+0x4c>
		s++, neg = 1;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 06                	je     800db5 <strtol+0x58>
  800daf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db3:	75 20                	jne    800dd5 <strtol+0x78>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 17                	jne    800dd5 <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	40                   	inc    %eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x78>
		s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 28                	jmp    800dfd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 15                	jne    800df0 <strtol+0x93>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3c 30                	cmp    $0x30,%al
  800de2:	75 0c                	jne    800df0 <strtol+0x93>
		s++, base = 8;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dee:	eb 0d                	jmp    800dfd <strtol+0xa0>
	else if (base == 0)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	75 07                	jne    800dfd <strtol+0xa0>
		base = 10;
  800df6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2f                	cmp    $0x2f,%al
  800e04:	7e 19                	jle    800e1f <strtol+0xc2>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 39                	cmp    $0x39,%al
  800e0d:	7f 10                	jg     800e1f <strtol+0xc2>
			dig = *s - '0';
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f be c0             	movsbl %al,%eax
  800e17:	83 e8 30             	sub    $0x30,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1d:	eb 42                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 60                	cmp    $0x60,%al
  800e26:	7e 19                	jle    800e41 <strtol+0xe4>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 7a                	cmp    $0x7a,%al
  800e2f:	7f 10                	jg     800e41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be c0             	movsbl %al,%eax
  800e39:	83 e8 57             	sub    $0x57,%eax
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3f:	eb 20                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 40                	cmp    $0x40,%al
  800e48:	7e 39                	jle    800e83 <strtol+0x126>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 5a                	cmp    $0x5a,%al
  800e51:	7f 30                	jg     800e83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	83 e8 37             	sub    $0x37,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	7d 19                	jge    800e82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7d:	e9 7b ff ff ff       	jmp    800dfd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e87:	74 08                	je     800e91 <strtol+0x134>
		*endptr = (char *) s;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e95:	74 07                	je     800e9e <strtol+0x141>
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	f7 d8                	neg    %eax
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x144>
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebb:	79 13                	jns    800ed0 <ltostr+0x2d>
	{
		neg = 1;
  800ebd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed8:	99                   	cltd   
  800ed9:	f7 f9                	idiv   %ecx
  800edb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	83 c2 30             	add    $0x30,%edx
  800ef4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efe:	f7 e9                	imul   %ecx
  800f00:	c1 fa 02             	sar    $0x2,%edx
  800f03:	89 c8                	mov    %ecx,%eax
  800f05:	c1 f8 1f             	sar    $0x1f,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
  800f0c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f12:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f17:	f7 e9                	imul   %ecx
  800f19:	c1 fa 02             	sar    $0x2,%edx
  800f1c:	89 c8                	mov    %ecx,%eax
  800f1e:	c1 f8 1f             	sar    $0x1f,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	29 c1                	sub    %eax,%ecx
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	85 d2                	test   %edx,%edx
  800f32:	75 9c                	jne    800ed0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xe2>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 54 fa ff ff       	call   8009fd <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 46 fa ff ff       	call   8009fd <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 13 fb ff ff       	call   800b8f <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 b5 fa ff ff       	call   800b8f <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110b:	a1 04 40 80 00       	mov    0x804004,%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	74 1f                	je     801133 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801114:	e8 1d 00 00 00       	call   801136 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 30 38 80 00       	push   $0x803830
  801121:	e8 55 f2 ff ff       	call   80037b <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801129:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801130:	00 00 00 
	}
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80113c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801143:	00 00 00 
  801146:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114d:	00 00 00 
  801150:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801157:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80115a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801161:	00 00 00 
  801164:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116b:	00 00 00 
  80116e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801175:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801178:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80117f:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801182:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801189:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801193:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801198:	2d 00 10 00 00       	sub    $0x1000,%eax
  80119d:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8011a2:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8011a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011b6:	83 ec 04             	sub    $0x4,%esp
  8011b9:	6a 06                	push   $0x6
  8011bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8011be:	50                   	push   %eax
  8011bf:	e8 ee 05 00 00       	call   8017b2 <sys_allocate_chunk>
  8011c4:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011c7:	a1 20 41 80 00       	mov    0x804120,%eax
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	50                   	push   %eax
  8011d0:	e8 63 0c 00 00       	call   801e38 <initialize_MemBlocksList>
  8011d5:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8011d8:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8011dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8011e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011e3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8011ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8011f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801200:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801206:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80120d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801217:	8b 50 08             	mov    0x8(%eax),%edx
  80121a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121d:	01 d0                	add    %edx,%eax
  80121f:	48                   	dec    %eax
  801220:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801223:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801226:	ba 00 00 00 00       	mov    $0x0,%edx
  80122b:	f7 75 e0             	divl   -0x20(%ebp)
  80122e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801231:	29 d0                	sub    %edx,%eax
  801233:	89 c2                	mov    %eax,%edx
  801235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801238:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80123b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80123f:	75 14                	jne    801255 <initialize_dyn_block_system+0x11f>
  801241:	83 ec 04             	sub    $0x4,%esp
  801244:	68 55 38 80 00       	push   $0x803855
  801249:	6a 34                	push   $0x34
  80124b:	68 73 38 80 00       	push   $0x803873
  801250:	e8 fb 1c 00 00       	call   802f50 <_panic>
  801255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	85 c0                	test   %eax,%eax
  80125c:	74 10                	je     80126e <initialize_dyn_block_system+0x138>
  80125e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801261:	8b 00                	mov    (%eax),%eax
  801263:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801266:	8b 52 04             	mov    0x4(%edx),%edx
  801269:	89 50 04             	mov    %edx,0x4(%eax)
  80126c:	eb 0b                	jmp    801279 <initialize_dyn_block_system+0x143>
  80126e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801271:	8b 40 04             	mov    0x4(%eax),%eax
  801274:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80127c:	8b 40 04             	mov    0x4(%eax),%eax
  80127f:	85 c0                	test   %eax,%eax
  801281:	74 0f                	je     801292 <initialize_dyn_block_system+0x15c>
  801283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801286:	8b 40 04             	mov    0x4(%eax),%eax
  801289:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80128c:	8b 12                	mov    (%edx),%edx
  80128e:	89 10                	mov    %edx,(%eax)
  801290:	eb 0a                	jmp    80129c <initialize_dyn_block_system+0x166>
  801292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801295:	8b 00                	mov    (%eax),%eax
  801297:	a3 48 41 80 00       	mov    %eax,0x804148
  80129c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80129f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8012a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012af:	a1 54 41 80 00       	mov    0x804154,%eax
  8012b4:	48                   	dec    %eax
  8012b5:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8012ba:	83 ec 0c             	sub    $0xc,%esp
  8012bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8012c0:	e8 c4 13 00 00       	call   802689 <insert_sorted_with_merge_freeList>
  8012c5:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8012c8:	90                   	nop
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <malloc>:
//=================================



void* malloc(uint32 size)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012d1:	e8 2f fe ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012da:	75 07                	jne    8012e3 <malloc+0x18>
  8012dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e1:	eb 71                	jmp    801354 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8012e3:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8012ea:	76 07                	jbe    8012f3 <malloc+0x28>
	return NULL;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	eb 61                	jmp    801354 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012f3:	e8 88 08 00 00       	call   801b80 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	74 53                	je     80134f <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8012fc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801303:	8b 55 08             	mov    0x8(%ebp),%edx
  801306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	48                   	dec    %eax
  80130c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80130f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801312:	ba 00 00 00 00       	mov    $0x0,%edx
  801317:	f7 75 f4             	divl   -0xc(%ebp)
  80131a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131d:	29 d0                	sub    %edx,%eax
  80131f:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801322:	83 ec 0c             	sub    $0xc,%esp
  801325:	ff 75 ec             	pushl  -0x14(%ebp)
  801328:	e8 d2 0d 00 00       	call   8020ff <alloc_block_FF>
  80132d:	83 c4 10             	add    $0x10,%esp
  801330:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801333:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801337:	74 16                	je     80134f <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801339:	83 ec 0c             	sub    $0xc,%esp
  80133c:	ff 75 e8             	pushl  -0x18(%ebp)
  80133f:	e8 0c 0c 00 00       	call   801f50 <insert_sorted_allocList>
  801344:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80134a:	8b 40 08             	mov    0x8(%eax),%eax
  80134d:	eb 05                	jmp    801354 <malloc+0x89>
    }

			}


	return NULL;
  80134f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80136d:	83 ec 08             	sub    $0x8,%esp
  801370:	ff 75 f0             	pushl  -0x10(%ebp)
  801373:	68 40 40 80 00       	push   $0x804040
  801378:	e8 a0 0b 00 00       	call   801f1d <find_block>
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801383:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801386:	8b 50 0c             	mov    0xc(%eax),%edx
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	52                   	push   %edx
  801390:	50                   	push   %eax
  801391:	e8 e4 03 00 00       	call   80177a <sys_free_user_mem>
  801396:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801399:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80139d:	75 17                	jne    8013b6 <free+0x60>
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	68 55 38 80 00       	push   $0x803855
  8013a7:	68 84 00 00 00       	push   $0x84
  8013ac:	68 73 38 80 00       	push   $0x803873
  8013b1:	e8 9a 1b 00 00       	call   802f50 <_panic>
  8013b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b9:	8b 00                	mov    (%eax),%eax
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	74 10                	je     8013cf <free+0x79>
  8013bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c2:	8b 00                	mov    (%eax),%eax
  8013c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c7:	8b 52 04             	mov    0x4(%edx),%edx
  8013ca:	89 50 04             	mov    %edx,0x4(%eax)
  8013cd:	eb 0b                	jmp    8013da <free+0x84>
  8013cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d2:	8b 40 04             	mov    0x4(%eax),%eax
  8013d5:	a3 44 40 80 00       	mov    %eax,0x804044
  8013da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013dd:	8b 40 04             	mov    0x4(%eax),%eax
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	74 0f                	je     8013f3 <free+0x9d>
  8013e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e7:	8b 40 04             	mov    0x4(%eax),%eax
  8013ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ed:	8b 12                	mov    (%edx),%edx
  8013ef:	89 10                	mov    %edx,(%eax)
  8013f1:	eb 0a                	jmp    8013fd <free+0xa7>
  8013f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f6:	8b 00                	mov    (%eax),%eax
  8013f8:	a3 40 40 80 00       	mov    %eax,0x804040
  8013fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801409:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801410:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801415:	48                   	dec    %eax
  801416:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	ff 75 ec             	pushl  -0x14(%ebp)
  801421:	e8 63 12 00 00       	call   802689 <insert_sorted_with_merge_freeList>
  801426:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801429:	90                   	nop
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 38             	sub    $0x38,%esp
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801438:	e8 c8 fc ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  80143d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801441:	75 0a                	jne    80144d <smalloc+0x21>
  801443:	b8 00 00 00 00       	mov    $0x0,%eax
  801448:	e9 a0 00 00 00       	jmp    8014ed <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80144d:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801454:	76 0a                	jbe    801460 <smalloc+0x34>
		return NULL;
  801456:	b8 00 00 00 00       	mov    $0x0,%eax
  80145b:	e9 8d 00 00 00       	jmp    8014ed <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801460:	e8 1b 07 00 00       	call   801b80 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801465:	85 c0                	test   %eax,%eax
  801467:	74 7f                	je     8014e8 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801469:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	48                   	dec    %eax
  801479:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80147c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147f:	ba 00 00 00 00       	mov    $0x0,%edx
  801484:	f7 75 f4             	divl   -0xc(%ebp)
  801487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148a:	29 d0                	sub    %edx,%eax
  80148c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80148f:	83 ec 0c             	sub    $0xc,%esp
  801492:	ff 75 ec             	pushl  -0x14(%ebp)
  801495:	e8 65 0c 00 00       	call   8020ff <alloc_block_FF>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8014a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014a4:	74 42                	je     8014e8 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ac:	e8 9f 0a 00 00       	call   801f50 <insert_sorted_allocList>
  8014b1:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8014b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b7:	8b 40 08             	mov    0x8(%eax),%eax
  8014ba:	89 c2                	mov    %eax,%edx
  8014bc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014c0:	52                   	push   %edx
  8014c1:	50                   	push   %eax
  8014c2:	ff 75 0c             	pushl  0xc(%ebp)
  8014c5:	ff 75 08             	pushl  0x8(%ebp)
  8014c8:	e8 38 04 00 00       	call   801905 <sys_createSharedObject>
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8014d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d7:	79 07                	jns    8014e0 <smalloc+0xb4>
	    		  return NULL;
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014de:	eb 0d                	jmp    8014ed <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8014e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014e3:	8b 40 08             	mov    0x8(%eax),%eax
  8014e6:	eb 05                	jmp    8014ed <smalloc+0xc1>


				}


		return NULL;
  8014e8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f5:	e8 0b fc ff ff       	call   801105 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014fa:	e8 81 06 00 00       	call   801b80 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ff:	85 c0                	test   %eax,%eax
  801501:	0f 84 9f 00 00 00    	je     8015a6 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	ff 75 0c             	pushl  0xc(%ebp)
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	e8 1a 04 00 00       	call   80192f <sys_getSizeOfSharedObject>
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80151b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80151f:	79 0a                	jns    80152b <sget+0x3c>
		return NULL;
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
  801526:	e9 80 00 00 00       	jmp    8015ab <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80152b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801538:	01 d0                	add    %edx,%eax
  80153a:	48                   	dec    %eax
  80153b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80153e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801541:	ba 00 00 00 00       	mov    $0x0,%edx
  801546:	f7 75 f0             	divl   -0x10(%ebp)
  801549:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154c:	29 d0                	sub    %edx,%eax
  80154e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801551:	83 ec 0c             	sub    $0xc,%esp
  801554:	ff 75 e8             	pushl  -0x18(%ebp)
  801557:	e8 a3 0b 00 00       	call   8020ff <alloc_block_FF>
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801562:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801566:	74 3e                	je     8015a6 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801568:	83 ec 0c             	sub    $0xc,%esp
  80156b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80156e:	e8 dd 09 00 00       	call   801f50 <insert_sorted_allocList>
  801573:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801579:	8b 40 08             	mov    0x8(%eax),%eax
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	50                   	push   %eax
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	e8 c1 03 00 00       	call   80194c <sys_getSharedObject>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801591:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801595:	79 07                	jns    80159e <sget+0xaf>
	    		  return NULL;
  801597:	b8 00 00 00 00       	mov    $0x0,%eax
  80159c:	eb 0d                	jmp    8015ab <sget+0xbc>
	  	return(void*) returned_block->sva;
  80159e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a1:	8b 40 08             	mov    0x8(%eax),%eax
  8015a4:	eb 05                	jmp    8015ab <sget+0xbc>
	      }
	}
	   return NULL;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b3:	e8 4d fb ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	68 80 38 80 00       	push   $0x803880
  8015c0:	68 12 01 00 00       	push   $0x112
  8015c5:	68 73 38 80 00       	push   $0x803873
  8015ca:	e8 81 19 00 00       	call   802f50 <_panic>

008015cf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	68 a8 38 80 00       	push   $0x8038a8
  8015dd:	68 26 01 00 00       	push   $0x126
  8015e2:	68 73 38 80 00       	push   $0x803873
  8015e7:	e8 64 19 00 00       	call   802f50 <_panic>

008015ec <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 cc 38 80 00       	push   $0x8038cc
  8015fa:	68 31 01 00 00       	push   $0x131
  8015ff:	68 73 38 80 00       	push   $0x803873
  801604:	e8 47 19 00 00       	call   802f50 <_panic>

00801609 <shrink>:

}
void shrink(uint32 newSize)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	68 cc 38 80 00       	push   $0x8038cc
  801617:	68 36 01 00 00       	push   $0x136
  80161c:	68 73 38 80 00       	push   $0x803873
  801621:	e8 2a 19 00 00       	call   802f50 <_panic>

00801626 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162c:	83 ec 04             	sub    $0x4,%esp
  80162f:	68 cc 38 80 00       	push   $0x8038cc
  801634:	68 3b 01 00 00       	push   $0x13b
  801639:	68 73 38 80 00       	push   $0x803873
  80163e:	e8 0d 19 00 00       	call   802f50 <_panic>

00801643 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	57                   	push   %edi
  801647:	56                   	push   %esi
  801648:	53                   	push   %ebx
  801649:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801652:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801655:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801658:	8b 7d 18             	mov    0x18(%ebp),%edi
  80165b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80165e:	cd 30                	int    $0x30
  801660:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801663:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	5b                   	pop    %ebx
  80166a:	5e                   	pop    %esi
  80166b:	5f                   	pop    %edi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80167a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	52                   	push   %edx
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	50                   	push   %eax
  80168a:	6a 00                	push   $0x0
  80168c:	e8 b2 ff ff ff       	call   801643 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	90                   	nop
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_cgetc>:

int
sys_cgetc(void)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 01                	push   $0x1
  8016a6:	e8 98 ff ff ff       	call   801643 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	52                   	push   %edx
  8016c0:	50                   	push   %eax
  8016c1:	6a 05                	push   $0x5
  8016c3:	e8 7b ff ff ff       	call   801643 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	56                   	push   %esi
  8016d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8016d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
  8016e3:	51                   	push   %ecx
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	6a 06                	push   $0x6
  8016e8:	e8 56 ff ff ff       	call   801643 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	52                   	push   %edx
  801707:	50                   	push   %eax
  801708:	6a 07                	push   $0x7
  80170a:	e8 34 ff ff ff       	call   801643 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	ff 75 0c             	pushl  0xc(%ebp)
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	6a 08                	push   $0x8
  801725:	e8 19 ff ff ff       	call   801643 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 09                	push   $0x9
  80173e:	e8 00 ff ff ff       	call   801643 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 0a                	push   $0xa
  801757:	e8 e7 fe ff ff       	call   801643 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 0b                	push   $0xb
  801770:	e8 ce fe ff ff       	call   801643 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	ff 75 08             	pushl  0x8(%ebp)
  801789:	6a 0f                	push   $0xf
  80178b:	e8 b3 fe ff ff       	call   801643 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
	return;
  801793:	90                   	nop
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	ff 75 0c             	pushl  0xc(%ebp)
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	6a 10                	push   $0x10
  8017a7:	e8 97 fe ff ff       	call   801643 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8017af:	90                   	nop
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	ff 75 10             	pushl  0x10(%ebp)
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	ff 75 08             	pushl  0x8(%ebp)
  8017c2:	6a 11                	push   $0x11
  8017c4:	e8 7a fe ff ff       	call   801643 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cc:	90                   	nop
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 0c                	push   $0xc
  8017de:	e8 60 fe ff ff       	call   801643 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	ff 75 08             	pushl  0x8(%ebp)
  8017f6:	6a 0d                	push   $0xd
  8017f8:	e8 46 fe ff ff       	call   801643 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 0e                	push   $0xe
  801811:	e8 2d fe ff ff       	call   801643 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	90                   	nop
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 13                	push   $0x13
  80182b:	e8 13 fe ff ff       	call   801643 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	90                   	nop
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 14                	push   $0x14
  801845:	e8 f9 fd ff ff       	call   801643 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	90                   	nop
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_cputc>:


void
sys_cputc(const char c)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80185c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	50                   	push   %eax
  801869:	6a 15                	push   $0x15
  80186b:	e8 d3 fd ff ff       	call   801643 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	90                   	nop
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 16                	push   $0x16
  801885:	e8 b9 fd ff ff       	call   801643 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	90                   	nop
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	50                   	push   %eax
  8018a0:	6a 17                	push   $0x17
  8018a2:	e8 9c fd ff ff       	call   801643 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	52                   	push   %edx
  8018bc:	50                   	push   %eax
  8018bd:	6a 1a                	push   $0x1a
  8018bf:	e8 7f fd ff ff       	call   801643 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 18                	push   $0x18
  8018dc:	e8 62 fd ff ff       	call   801643 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	90                   	nop
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	52                   	push   %edx
  8018f7:	50                   	push   %eax
  8018f8:	6a 19                	push   $0x19
  8018fa:	e8 44 fd ff ff       	call   801643 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801911:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801914:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	51                   	push   %ecx
  80191e:	52                   	push   %edx
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	50                   	push   %eax
  801923:	6a 1b                	push   $0x1b
  801925:	e8 19 fd ff ff       	call   801643 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801932:	8b 55 0c             	mov    0xc(%ebp),%edx
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	52                   	push   %edx
  80193f:	50                   	push   %eax
  801940:	6a 1c                	push   $0x1c
  801942:	e8 fc fc ff ff       	call   801643 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80194f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801952:	8b 55 0c             	mov    0xc(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	51                   	push   %ecx
  80195d:	52                   	push   %edx
  80195e:	50                   	push   %eax
  80195f:	6a 1d                	push   $0x1d
  801961:	e8 dd fc ff ff       	call   801643 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	52                   	push   %edx
  80197b:	50                   	push   %eax
  80197c:	6a 1e                	push   $0x1e
  80197e:	e8 c0 fc ff ff       	call   801643 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 1f                	push   $0x1f
  801997:	e8 a7 fc ff ff       	call   801643 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 14             	pushl  0x14(%ebp)
  8019ac:	ff 75 10             	pushl  0x10(%ebp)
  8019af:	ff 75 0c             	pushl  0xc(%ebp)
  8019b2:	50                   	push   %eax
  8019b3:	6a 20                	push   $0x20
  8019b5:	e8 89 fc ff ff       	call   801643 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	50                   	push   %eax
  8019ce:	6a 21                	push   $0x21
  8019d0:	e8 6e fc ff ff       	call   801643 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	50                   	push   %eax
  8019ea:	6a 22                	push   $0x22
  8019ec:	e8 52 fc ff ff       	call   801643 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 02                	push   $0x2
  801a05:	e8 39 fc ff ff       	call   801643 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 03                	push   $0x3
  801a1e:	e8 20 fc ff ff       	call   801643 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 04                	push   $0x4
  801a37:	e8 07 fc ff ff       	call   801643 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_exit_env>:


void sys_exit_env(void)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 23                	push   $0x23
  801a50:	e8 ee fb ff ff       	call   801643 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	90                   	nop
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a61:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a64:	8d 50 04             	lea    0x4(%eax),%edx
  801a67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 24                	push   $0x24
  801a74:	e8 ca fb ff ff       	call   801643 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
	return result;
  801a7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a85:	89 01                	mov    %eax,(%ecx)
  801a87:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	c9                   	leave  
  801a8e:	c2 04 00             	ret    $0x4

00801a91 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	ff 75 10             	pushl  0x10(%ebp)
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	6a 12                	push   $0x12
  801aa3:	e8 9b fb ff ff       	call   801643 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aab:	90                   	nop
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_rcr2>:
uint32 sys_rcr2()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 25                	push   $0x25
  801abd:	e8 81 fb ff ff       	call   801643 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ad3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	50                   	push   %eax
  801ae0:	6a 26                	push   $0x26
  801ae2:	e8 5c fb ff ff       	call   801643 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aea:	90                   	nop
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <rsttst>:
void rsttst()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 28                	push   $0x28
  801afc:	e8 42 fb ff ff       	call   801643 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
	return ;
  801b04:	90                   	nop
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 04             	sub    $0x4,%esp
  801b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b13:	8b 55 18             	mov    0x18(%ebp),%edx
  801b16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	ff 75 10             	pushl  0x10(%ebp)
  801b1f:	ff 75 0c             	pushl  0xc(%ebp)
  801b22:	ff 75 08             	pushl  0x8(%ebp)
  801b25:	6a 27                	push   $0x27
  801b27:	e8 17 fb ff ff       	call   801643 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2f:	90                   	nop
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <chktst>:
void chktst(uint32 n)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 08             	pushl  0x8(%ebp)
  801b40:	6a 29                	push   $0x29
  801b42:	e8 fc fa ff ff       	call   801643 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4a:	90                   	nop
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <inctst>:

void inctst()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 2a                	push   $0x2a
  801b5c:	e8 e2 fa ff ff       	call   801643 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
	return ;
  801b64:	90                   	nop
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <gettst>:
uint32 gettst()
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 2b                	push   $0x2b
  801b76:	e8 c8 fa ff ff       	call   801643 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 2c                	push   $0x2c
  801b92:	e8 ac fa ff ff       	call   801643 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
  801b9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b9d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ba1:	75 07                	jne    801baa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ba3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba8:	eb 05                	jmp    801baf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801baa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 2c                	push   $0x2c
  801bc3:	e8 7b fa ff ff       	call   801643 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
  801bcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bd2:	75 07                	jne    801bdb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bd4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd9:	eb 05                	jmp    801be0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 2c                	push   $0x2c
  801bf4:	e8 4a fa ff ff       	call   801643 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
  801bfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c03:	75 07                	jne    801c0c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c05:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0a:	eb 05                	jmp    801c11 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 2c                	push   $0x2c
  801c25:	e8 19 fa ff ff       	call   801643 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
  801c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c30:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c34:	75 07                	jne    801c3d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c36:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3b:	eb 05                	jmp    801c42 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	6a 2d                	push   $0x2d
  801c54:	e8 ea f9 ff ff       	call   801643 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5c:	90                   	nop
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	6a 00                	push   $0x0
  801c71:	53                   	push   %ebx
  801c72:	51                   	push   %ecx
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	6a 2e                	push   $0x2e
  801c77:	e8 c7 f9 ff ff       	call   801643 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	52                   	push   %edx
  801c94:	50                   	push   %eax
  801c95:	6a 2f                	push   $0x2f
  801c97:	e8 a7 f9 ff ff       	call   801643 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	68 dc 38 80 00       	push   $0x8038dc
  801caf:	e8 c7 e6 ff ff       	call   80037b <cprintf>
  801cb4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cbe:	83 ec 0c             	sub    $0xc,%esp
  801cc1:	68 08 39 80 00       	push   $0x803908
  801cc6:	e8 b0 e6 ff ff       	call   80037b <cprintf>
  801ccb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd2:	a1 38 41 80 00       	mov    0x804138,%eax
  801cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cda:	eb 56                	jmp    801d32 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ce0:	74 1c                	je     801cfe <print_mem_block_lists+0x5d>
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	8b 50 08             	mov    0x8(%eax),%edx
  801ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ceb:	8b 48 08             	mov    0x8(%eax),%ecx
  801cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf4:	01 c8                	add    %ecx,%eax
  801cf6:	39 c2                	cmp    %eax,%edx
  801cf8:	73 04                	jae    801cfe <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cfa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d01:	8b 50 08             	mov    0x8(%eax),%edx
  801d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d07:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0a:	01 c2                	add    %eax,%edx
  801d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0f:	8b 40 08             	mov    0x8(%eax),%eax
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	52                   	push   %edx
  801d16:	50                   	push   %eax
  801d17:	68 1d 39 80 00       	push   $0x80391d
  801d1c:	e8 5a e6 ff ff       	call   80037b <cprintf>
  801d21:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d2a:	a1 40 41 80 00       	mov    0x804140,%eax
  801d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d36:	74 07                	je     801d3f <print_mem_block_lists+0x9e>
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	8b 00                	mov    (%eax),%eax
  801d3d:	eb 05                	jmp    801d44 <print_mem_block_lists+0xa3>
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d44:	a3 40 41 80 00       	mov    %eax,0x804140
  801d49:	a1 40 41 80 00       	mov    0x804140,%eax
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	75 8a                	jne    801cdc <print_mem_block_lists+0x3b>
  801d52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d56:	75 84                	jne    801cdc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d58:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d5c:	75 10                	jne    801d6e <print_mem_block_lists+0xcd>
  801d5e:	83 ec 0c             	sub    $0xc,%esp
  801d61:	68 2c 39 80 00       	push   $0x80392c
  801d66:	e8 10 e6 ff ff       	call   80037b <cprintf>
  801d6b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d75:	83 ec 0c             	sub    $0xc,%esp
  801d78:	68 50 39 80 00       	push   $0x803950
  801d7d:	e8 f9 e5 ff ff       	call   80037b <cprintf>
  801d82:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d85:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d89:	a1 40 40 80 00       	mov    0x804040,%eax
  801d8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d91:	eb 56                	jmp    801de9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d97:	74 1c                	je     801db5 <print_mem_block_lists+0x114>
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	8b 50 08             	mov    0x8(%eax),%edx
  801d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da2:	8b 48 08             	mov    0x8(%eax),%ecx
  801da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da8:	8b 40 0c             	mov    0xc(%eax),%eax
  801dab:	01 c8                	add    %ecx,%eax
  801dad:	39 c2                	cmp    %eax,%edx
  801daf:	73 04                	jae    801db5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801db1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db8:	8b 50 08             	mov    0x8(%eax),%edx
  801dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc1:	01 c2                	add    %eax,%edx
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	8b 40 08             	mov    0x8(%eax),%eax
  801dc9:	83 ec 04             	sub    $0x4,%esp
  801dcc:	52                   	push   %edx
  801dcd:	50                   	push   %eax
  801dce:	68 1d 39 80 00       	push   $0x80391d
  801dd3:	e8 a3 e5 ff ff       	call   80037b <cprintf>
  801dd8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801de1:	a1 48 40 80 00       	mov    0x804048,%eax
  801de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ded:	74 07                	je     801df6 <print_mem_block_lists+0x155>
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	8b 00                	mov    (%eax),%eax
  801df4:	eb 05                	jmp    801dfb <print_mem_block_lists+0x15a>
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfb:	a3 48 40 80 00       	mov    %eax,0x804048
  801e00:	a1 48 40 80 00       	mov    0x804048,%eax
  801e05:	85 c0                	test   %eax,%eax
  801e07:	75 8a                	jne    801d93 <print_mem_block_lists+0xf2>
  801e09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e0d:	75 84                	jne    801d93 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e0f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e13:	75 10                	jne    801e25 <print_mem_block_lists+0x184>
  801e15:	83 ec 0c             	sub    $0xc,%esp
  801e18:	68 68 39 80 00       	push   $0x803968
  801e1d:	e8 59 e5 ff ff       	call   80037b <cprintf>
  801e22:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	68 dc 38 80 00       	push   $0x8038dc
  801e2d:	e8 49 e5 ff ff       	call   80037b <cprintf>
  801e32:	83 c4 10             	add    $0x10,%esp

}
  801e35:	90                   	nop
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801e3e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e45:	00 00 00 
  801e48:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e4f:	00 00 00 
  801e52:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e59:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  801e5c:	a1 50 40 80 00       	mov    0x804050,%eax
  801e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  801e64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e6b:	e9 9e 00 00 00       	jmp    801f0e <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801e70:	a1 50 40 80 00       	mov    0x804050,%eax
  801e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e78:	c1 e2 04             	shl    $0x4,%edx
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	75 14                	jne    801e95 <initialize_MemBlocksList+0x5d>
  801e81:	83 ec 04             	sub    $0x4,%esp
  801e84:	68 90 39 80 00       	push   $0x803990
  801e89:	6a 48                	push   $0x48
  801e8b:	68 b3 39 80 00       	push   $0x8039b3
  801e90:	e8 bb 10 00 00       	call   802f50 <_panic>
  801e95:	a1 50 40 80 00       	mov    0x804050,%eax
  801e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9d:	c1 e2 04             	shl    $0x4,%edx
  801ea0:	01 d0                	add    %edx,%eax
  801ea2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ea8:	89 10                	mov    %edx,(%eax)
  801eaa:	8b 00                	mov    (%eax),%eax
  801eac:	85 c0                	test   %eax,%eax
  801eae:	74 18                	je     801ec8 <initialize_MemBlocksList+0x90>
  801eb0:	a1 48 41 80 00       	mov    0x804148,%eax
  801eb5:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ebb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ebe:	c1 e1 04             	shl    $0x4,%ecx
  801ec1:	01 ca                	add    %ecx,%edx
  801ec3:	89 50 04             	mov    %edx,0x4(%eax)
  801ec6:	eb 12                	jmp    801eda <initialize_MemBlocksList+0xa2>
  801ec8:	a1 50 40 80 00       	mov    0x804050,%eax
  801ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed0:	c1 e2 04             	shl    $0x4,%edx
  801ed3:	01 d0                	add    %edx,%eax
  801ed5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801eda:	a1 50 40 80 00       	mov    0x804050,%eax
  801edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee2:	c1 e2 04             	shl    $0x4,%edx
  801ee5:	01 d0                	add    %edx,%eax
  801ee7:	a3 48 41 80 00       	mov    %eax,0x804148
  801eec:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef4:	c1 e2 04             	shl    $0x4,%edx
  801ef7:	01 d0                	add    %edx,%eax
  801ef9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f00:	a1 54 41 80 00       	mov    0x804154,%eax
  801f05:	40                   	inc    %eax
  801f06:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  801f0b:	ff 45 f4             	incl   -0xc(%ebp)
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f14:	0f 82 56 ff ff ff    	jb     801e70 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  801f1a:	90                   	nop
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	8b 00                	mov    (%eax),%eax
  801f28:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  801f2b:	eb 18                	jmp    801f45 <find_block+0x28>
		{
			if(tmp->sva==va)
  801f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f30:	8b 40 08             	mov    0x8(%eax),%eax
  801f33:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f36:	75 05                	jne    801f3d <find_block+0x20>
			{
				return tmp;
  801f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3b:	eb 11                	jmp    801f4e <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  801f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f40:	8b 00                	mov    (%eax),%eax
  801f42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  801f45:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f49:	75 e2                	jne    801f2d <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  801f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  801f56:	a1 40 40 80 00       	mov    0x804040,%eax
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	0f 85 83 00 00 00    	jne    801fe6 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  801f63:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801f6a:	00 00 00 
  801f6d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801f74:	00 00 00 
  801f77:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801f7e:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f85:	75 14                	jne    801f9b <insert_sorted_allocList+0x4b>
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	68 90 39 80 00       	push   $0x803990
  801f8f:	6a 7f                	push   $0x7f
  801f91:	68 b3 39 80 00       	push   $0x8039b3
  801f96:	e8 b5 0f 00 00       	call   802f50 <_panic>
  801f9b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	89 10                	mov    %edx,(%eax)
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	8b 00                	mov    (%eax),%eax
  801fab:	85 c0                	test   %eax,%eax
  801fad:	74 0d                	je     801fbc <insert_sorted_allocList+0x6c>
  801faf:	a1 40 40 80 00       	mov    0x804040,%eax
  801fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb7:	89 50 04             	mov    %edx,0x4(%eax)
  801fba:	eb 08                	jmp    801fc4 <insert_sorted_allocList+0x74>
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	a3 44 40 80 00       	mov    %eax,0x804044
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 40 40 80 00       	mov    %eax,0x804040
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fdb:	40                   	inc    %eax
  801fdc:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  801fe1:	e9 16 01 00 00       	jmp    8020fc <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	8b 50 08             	mov    0x8(%eax),%edx
  801fec:	a1 44 40 80 00       	mov    0x804044,%eax
  801ff1:	8b 40 08             	mov    0x8(%eax),%eax
  801ff4:	39 c2                	cmp    %eax,%edx
  801ff6:	76 68                	jbe    802060 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  801ff8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ffc:	75 17                	jne    802015 <insert_sorted_allocList+0xc5>
  801ffe:	83 ec 04             	sub    $0x4,%esp
  802001:	68 cc 39 80 00       	push   $0x8039cc
  802006:	68 85 00 00 00       	push   $0x85
  80200b:	68 b3 39 80 00       	push   $0x8039b3
  802010:	e8 3b 0f 00 00       	call   802f50 <_panic>
  802015:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	89 50 04             	mov    %edx,0x4(%eax)
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	8b 40 04             	mov    0x4(%eax),%eax
  802027:	85 c0                	test   %eax,%eax
  802029:	74 0c                	je     802037 <insert_sorted_allocList+0xe7>
  80202b:	a1 44 40 80 00       	mov    0x804044,%eax
  802030:	8b 55 08             	mov    0x8(%ebp),%edx
  802033:	89 10                	mov    %edx,(%eax)
  802035:	eb 08                	jmp    80203f <insert_sorted_allocList+0xef>
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	a3 40 40 80 00       	mov    %eax,0x804040
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	a3 44 40 80 00       	mov    %eax,0x804044
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802050:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802055:	40                   	inc    %eax
  802056:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80205b:	e9 9c 00 00 00       	jmp    8020fc <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802060:	a1 40 40 80 00       	mov    0x804040,%eax
  802065:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802068:	e9 85 00 00 00       	jmp    8020f2 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 50 08             	mov    0x8(%eax),%edx
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 40 08             	mov    0x8(%eax),%eax
  802079:	39 c2                	cmp    %eax,%edx
  80207b:	73 6d                	jae    8020ea <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80207d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802081:	74 06                	je     802089 <insert_sorted_allocList+0x139>
  802083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802087:	75 17                	jne    8020a0 <insert_sorted_allocList+0x150>
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	68 f0 39 80 00       	push   $0x8039f0
  802091:	68 90 00 00 00       	push   $0x90
  802096:	68 b3 39 80 00       	push   $0x8039b3
  80209b:	e8 b0 0e 00 00       	call   802f50 <_panic>
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 50 04             	mov    0x4(%eax),%edx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	89 50 04             	mov    %edx,0x4(%eax)
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b2:	89 10                	mov    %edx,(%eax)
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	8b 40 04             	mov    0x4(%eax),%eax
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	74 0d                	je     8020cb <insert_sorted_allocList+0x17b>
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	8b 40 04             	mov    0x4(%eax),%eax
  8020c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c7:	89 10                	mov    %edx,(%eax)
  8020c9:	eb 08                	jmp    8020d3 <insert_sorted_allocList+0x183>
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	a3 40 40 80 00       	mov    %eax,0x804040
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d9:	89 50 04             	mov    %edx,0x4(%eax)
  8020dc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020e1:	40                   	inc    %eax
  8020e2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8020e7:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8020e8:	eb 12                	jmp    8020fc <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8020f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f6:	0f 85 71 ff ff ff    	jne    80206d <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8020fc:	90                   	nop
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802105:	a1 38 41 80 00       	mov    0x804138,%eax
  80210a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80210d:	e9 76 01 00 00       	jmp    802288 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 40 0c             	mov    0xc(%eax),%eax
  802118:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211b:	0f 85 8a 00 00 00    	jne    8021ab <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802121:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802125:	75 17                	jne    80213e <alloc_block_FF+0x3f>
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	68 25 3a 80 00       	push   $0x803a25
  80212f:	68 a8 00 00 00       	push   $0xa8
  802134:	68 b3 39 80 00       	push   $0x8039b3
  802139:	e8 12 0e 00 00       	call   802f50 <_panic>
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	8b 00                	mov    (%eax),%eax
  802143:	85 c0                	test   %eax,%eax
  802145:	74 10                	je     802157 <alloc_block_FF+0x58>
  802147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214a:	8b 00                	mov    (%eax),%eax
  80214c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214f:	8b 52 04             	mov    0x4(%edx),%edx
  802152:	89 50 04             	mov    %edx,0x4(%eax)
  802155:	eb 0b                	jmp    802162 <alloc_block_FF+0x63>
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 40 04             	mov    0x4(%eax),%eax
  80215d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	8b 40 04             	mov    0x4(%eax),%eax
  802168:	85 c0                	test   %eax,%eax
  80216a:	74 0f                	je     80217b <alloc_block_FF+0x7c>
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	8b 40 04             	mov    0x4(%eax),%eax
  802172:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802175:	8b 12                	mov    (%edx),%edx
  802177:	89 10                	mov    %edx,(%eax)
  802179:	eb 0a                	jmp    802185 <alloc_block_FF+0x86>
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	8b 00                	mov    (%eax),%eax
  802180:	a3 38 41 80 00       	mov    %eax,0x804138
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802198:	a1 44 41 80 00       	mov    0x804144,%eax
  80219d:	48                   	dec    %eax
  80219e:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	e9 ea 00 00 00       	jmp    802295 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b4:	0f 86 c6 00 00 00    	jbe    802280 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8021ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8021bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c8:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 50 08             	mov    0x8(%eax),%edx
  8021d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d4:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 40 0c             	mov    0xc(%eax),%eax
  8021dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8021e0:	89 c2                	mov    %eax,%edx
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 50 08             	mov    0x8(%eax),%edx
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	01 c2                	add    %eax,%edx
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8021f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021fd:	75 17                	jne    802216 <alloc_block_FF+0x117>
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	68 25 3a 80 00       	push   $0x803a25
  802207:	68 b6 00 00 00       	push   $0xb6
  80220c:	68 b3 39 80 00       	push   $0x8039b3
  802211:	e8 3a 0d 00 00       	call   802f50 <_panic>
  802216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802219:	8b 00                	mov    (%eax),%eax
  80221b:	85 c0                	test   %eax,%eax
  80221d:	74 10                	je     80222f <alloc_block_FF+0x130>
  80221f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802227:	8b 52 04             	mov    0x4(%edx),%edx
  80222a:	89 50 04             	mov    %edx,0x4(%eax)
  80222d:	eb 0b                	jmp    80223a <alloc_block_FF+0x13b>
  80222f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802232:	8b 40 04             	mov    0x4(%eax),%eax
  802235:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80223a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223d:	8b 40 04             	mov    0x4(%eax),%eax
  802240:	85 c0                	test   %eax,%eax
  802242:	74 0f                	je     802253 <alloc_block_FF+0x154>
  802244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802247:	8b 40 04             	mov    0x4(%eax),%eax
  80224a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224d:	8b 12                	mov    (%edx),%edx
  80224f:	89 10                	mov    %edx,(%eax)
  802251:	eb 0a                	jmp    80225d <alloc_block_FF+0x15e>
  802253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	a3 48 41 80 00       	mov    %eax,0x804148
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802269:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802270:	a1 54 41 80 00       	mov    0x804154,%eax
  802275:	48                   	dec    %eax
  802276:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80227b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227e:	eb 15                	jmp    802295 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228c:	0f 85 80 fe ff ff    	jne    802112 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80229d:	a1 38 41 80 00       	mov    0x804138,%eax
  8022a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8022a5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8022ac:	e9 c0 00 00 00       	jmp    802371 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ba:	0f 85 8a 00 00 00    	jne    80234a <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8022c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c4:	75 17                	jne    8022dd <alloc_block_BF+0x46>
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	68 25 3a 80 00       	push   $0x803a25
  8022ce:	68 cf 00 00 00       	push   $0xcf
  8022d3:	68 b3 39 80 00       	push   $0x8039b3
  8022d8:	e8 73 0c 00 00       	call   802f50 <_panic>
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	74 10                	je     8022f6 <alloc_block_BF+0x5f>
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ee:	8b 52 04             	mov    0x4(%edx),%edx
  8022f1:	89 50 04             	mov    %edx,0x4(%eax)
  8022f4:	eb 0b                	jmp    802301 <alloc_block_BF+0x6a>
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 40 04             	mov    0x4(%eax),%eax
  8022fc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	85 c0                	test   %eax,%eax
  802309:	74 0f                	je     80231a <alloc_block_BF+0x83>
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 04             	mov    0x4(%eax),%eax
  802311:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802314:	8b 12                	mov    (%edx),%edx
  802316:	89 10                	mov    %edx,(%eax)
  802318:	eb 0a                	jmp    802324 <alloc_block_BF+0x8d>
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	8b 00                	mov    (%eax),%eax
  80231f:	a3 38 41 80 00       	mov    %eax,0x804138
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802337:	a1 44 41 80 00       	mov    0x804144,%eax
  80233c:	48                   	dec    %eax
  80233d:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	e9 2a 01 00 00       	jmp    802474 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	8b 40 0c             	mov    0xc(%eax),%eax
  802350:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802353:	73 14                	jae    802369 <alloc_block_BF+0xd2>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 40 0c             	mov    0xc(%eax),%eax
  80235b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80235e:	76 09                	jbe    802369 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 40 0c             	mov    0xc(%eax),%eax
  802366:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 00                	mov    (%eax),%eax
  80236e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802375:	0f 85 36 ff ff ff    	jne    8022b1 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80237b:	a1 38 41 80 00       	mov    0x804138,%eax
  802380:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802383:	e9 dd 00 00 00       	jmp    802465 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 40 0c             	mov    0xc(%eax),%eax
  80238e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802391:	0f 85 c6 00 00 00    	jne    80245d <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802397:	a1 48 41 80 00       	mov    0x804148,%eax
  80239c:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 50 08             	mov    0x8(%eax),%edx
  8023a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a8:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8023ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b1:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	01 c2                	add    %eax,%edx
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ce:	89 c2                	mov    %eax,%edx
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023da:	75 17                	jne    8023f3 <alloc_block_BF+0x15c>
  8023dc:	83 ec 04             	sub    $0x4,%esp
  8023df:	68 25 3a 80 00       	push   $0x803a25
  8023e4:	68 eb 00 00 00       	push   $0xeb
  8023e9:	68 b3 39 80 00       	push   $0x8039b3
  8023ee:	e8 5d 0b 00 00       	call   802f50 <_panic>
  8023f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 10                	je     80240c <alloc_block_BF+0x175>
  8023fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802404:	8b 52 04             	mov    0x4(%edx),%edx
  802407:	89 50 04             	mov    %edx,0x4(%eax)
  80240a:	eb 0b                	jmp    802417 <alloc_block_BF+0x180>
  80240c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240f:	8b 40 04             	mov    0x4(%eax),%eax
  802412:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241a:	8b 40 04             	mov    0x4(%eax),%eax
  80241d:	85 c0                	test   %eax,%eax
  80241f:	74 0f                	je     802430 <alloc_block_BF+0x199>
  802421:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802424:	8b 40 04             	mov    0x4(%eax),%eax
  802427:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80242a:	8b 12                	mov    (%edx),%edx
  80242c:	89 10                	mov    %edx,(%eax)
  80242e:	eb 0a                	jmp    80243a <alloc_block_BF+0x1a3>
  802430:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	a3 48 41 80 00       	mov    %eax,0x804148
  80243a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802443:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802446:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244d:	a1 54 41 80 00       	mov    0x804154,%eax
  802452:	48                   	dec    %eax
  802453:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245b:	eb 17                	jmp    802474 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 00                	mov    (%eax),%eax
  802462:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802469:	0f 85 19 ff ff ff    	jne    802388 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
  802479:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80247c:	a1 40 40 80 00       	mov    0x804040,%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	75 19                	jne    80249e <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802485:	83 ec 0c             	sub    $0xc,%esp
  802488:	ff 75 08             	pushl  0x8(%ebp)
  80248b:	e8 6f fc ff ff       	call   8020ff <alloc_block_FF>
  802490:	83 c4 10             	add    $0x10,%esp
  802493:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	e9 e9 01 00 00       	jmp    802687 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80249e:	a1 44 40 80 00       	mov    0x804044,%eax
  8024a3:	8b 40 08             	mov    0x8(%eax),%eax
  8024a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8024a9:	a1 44 40 80 00       	mov    0x804044,%eax
  8024ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8024b1:	a1 44 40 80 00       	mov    0x804044,%eax
  8024b6:	8b 40 08             	mov    0x8(%eax),%eax
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	83 ec 08             	sub    $0x8,%esp
  8024be:	50                   	push   %eax
  8024bf:	68 38 41 80 00       	push   $0x804138
  8024c4:	e8 54 fa ff ff       	call   801f1d <find_block>
  8024c9:	83 c4 10             	add    $0x10,%esp
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d8:	0f 85 9b 00 00 00    	jne    802579 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ea:	01 d0                	add    %edx,%eax
  8024ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8024ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f3:	75 17                	jne    80250c <alloc_block_NF+0x96>
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 25 3a 80 00       	push   $0x803a25
  8024fd:	68 1a 01 00 00       	push   $0x11a
  802502:	68 b3 39 80 00       	push   $0x8039b3
  802507:	e8 44 0a 00 00       	call   802f50 <_panic>
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	74 10                	je     802525 <alloc_block_NF+0xaf>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	8b 52 04             	mov    0x4(%edx),%edx
  802520:	89 50 04             	mov    %edx,0x4(%eax)
  802523:	eb 0b                	jmp    802530 <alloc_block_NF+0xba>
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 04             	mov    0x4(%eax),%eax
  802536:	85 c0                	test   %eax,%eax
  802538:	74 0f                	je     802549 <alloc_block_NF+0xd3>
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 04             	mov    0x4(%eax),%eax
  802540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802543:	8b 12                	mov    (%edx),%edx
  802545:	89 10                	mov    %edx,(%eax)
  802547:	eb 0a                	jmp    802553 <alloc_block_NF+0xdd>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	a3 38 41 80 00       	mov    %eax,0x804138
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802566:	a1 44 41 80 00       	mov    0x804144,%eax
  80256b:	48                   	dec    %eax
  80256c:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	e9 0e 01 00 00       	jmp    802687 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 0c             	mov    0xc(%eax),%eax
  80257f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802582:	0f 86 cf 00 00 00    	jbe    802657 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802588:	a1 48 41 80 00       	mov    0x804148,%eax
  80258d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802593:	8b 55 08             	mov    0x8(%ebp),%edx
  802596:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 50 08             	mov    0x8(%eax),%edx
  80259f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a2:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 50 08             	mov    0x8(%eax),%edx
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	01 c2                	add    %eax,%edx
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8025bf:	89 c2                	mov    %eax,%edx
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 08             	mov    0x8(%eax),%eax
  8025cd:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025d4:	75 17                	jne    8025ed <alloc_block_NF+0x177>
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	68 25 3a 80 00       	push   $0x803a25
  8025de:	68 28 01 00 00       	push   $0x128
  8025e3:	68 b3 39 80 00       	push   $0x8039b3
  8025e8:	e8 63 09 00 00       	call   802f50 <_panic>
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	8b 00                	mov    (%eax),%eax
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	74 10                	je     802606 <alloc_block_NF+0x190>
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	8b 00                	mov    (%eax),%eax
  8025fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025fe:	8b 52 04             	mov    0x4(%edx),%edx
  802601:	89 50 04             	mov    %edx,0x4(%eax)
  802604:	eb 0b                	jmp    802611 <alloc_block_NF+0x19b>
  802606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802611:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802614:	8b 40 04             	mov    0x4(%eax),%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	74 0f                	je     80262a <alloc_block_NF+0x1b4>
  80261b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802624:	8b 12                	mov    (%edx),%edx
  802626:	89 10                	mov    %edx,(%eax)
  802628:	eb 0a                	jmp    802634 <alloc_block_NF+0x1be>
  80262a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	a3 48 41 80 00       	mov    %eax,0x804148
  802634:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802637:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802640:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802647:	a1 54 41 80 00       	mov    0x804154,%eax
  80264c:	48                   	dec    %eax
  80264d:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802655:	eb 30                	jmp    802687 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802657:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80265c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80265f:	75 0a                	jne    80266b <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802661:	a1 38 41 80 00       	mov    0x804138,%eax
  802666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802669:	eb 08                	jmp    802673 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 08             	mov    0x8(%eax),%eax
  802679:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80267c:	0f 85 4d fe ff ff    	jne    8024cf <alloc_block_NF+0x59>

			return NULL;
  802682:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
  80268c:	53                   	push   %ebx
  80268d:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802690:	a1 38 41 80 00       	mov    0x804138,%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	0f 85 86 00 00 00    	jne    802723 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80269d:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8026a4:	00 00 00 
  8026a7:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8026ae:	00 00 00 
  8026b1:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8026b8:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8026bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026bf:	75 17                	jne    8026d8 <insert_sorted_with_merge_freeList+0x4f>
  8026c1:	83 ec 04             	sub    $0x4,%esp
  8026c4:	68 90 39 80 00       	push   $0x803990
  8026c9:	68 48 01 00 00       	push   $0x148
  8026ce:	68 b3 39 80 00       	push   $0x8039b3
  8026d3:	e8 78 08 00 00       	call   802f50 <_panic>
  8026d8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	89 10                	mov    %edx,(%eax)
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 0d                	je     8026f9 <insert_sorted_with_merge_freeList+0x70>
  8026ec:	a1 38 41 80 00       	mov    0x804138,%eax
  8026f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f4:	89 50 04             	mov    %edx,0x4(%eax)
  8026f7:	eb 08                	jmp    802701 <insert_sorted_with_merge_freeList+0x78>
  8026f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	a3 38 41 80 00       	mov    %eax,0x804138
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802713:	a1 44 41 80 00       	mov    0x804144,%eax
  802718:	40                   	inc    %eax
  802719:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80271e:	e9 73 07 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802723:	8b 45 08             	mov    0x8(%ebp),%eax
  802726:	8b 50 08             	mov    0x8(%eax),%edx
  802729:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80272e:	8b 40 08             	mov    0x8(%eax),%eax
  802731:	39 c2                	cmp    %eax,%edx
  802733:	0f 86 84 00 00 00    	jbe    8027bd <insert_sorted_with_merge_freeList+0x134>
  802739:	8b 45 08             	mov    0x8(%ebp),%eax
  80273c:	8b 50 08             	mov    0x8(%eax),%edx
  80273f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802744:	8b 48 0c             	mov    0xc(%eax),%ecx
  802747:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80274c:	8b 40 08             	mov    0x8(%eax),%eax
  80274f:	01 c8                	add    %ecx,%eax
  802751:	39 c2                	cmp    %eax,%edx
  802753:	74 68                	je     8027bd <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802755:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802759:	75 17                	jne    802772 <insert_sorted_with_merge_freeList+0xe9>
  80275b:	83 ec 04             	sub    $0x4,%esp
  80275e:	68 cc 39 80 00       	push   $0x8039cc
  802763:	68 4c 01 00 00       	push   $0x14c
  802768:	68 b3 39 80 00       	push   $0x8039b3
  80276d:	e8 de 07 00 00       	call   802f50 <_panic>
  802772:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	89 50 04             	mov    %edx,0x4(%eax)
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	8b 40 04             	mov    0x4(%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 0c                	je     802794 <insert_sorted_with_merge_freeList+0x10b>
  802788:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80278d:	8b 55 08             	mov    0x8(%ebp),%edx
  802790:	89 10                	mov    %edx,(%eax)
  802792:	eb 08                	jmp    80279c <insert_sorted_with_merge_freeList+0x113>
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	a3 38 41 80 00       	mov    %eax,0x804138
  80279c:	8b 45 08             	mov    0x8(%ebp),%eax
  80279f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ad:	a1 44 41 80 00       	mov    0x804144,%eax
  8027b2:	40                   	inc    %eax
  8027b3:	a3 44 41 80 00       	mov    %eax,0x804144
  8027b8:	e9 d9 06 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	8b 50 08             	mov    0x8(%eax),%edx
  8027c3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027c8:	8b 40 08             	mov    0x8(%eax),%eax
  8027cb:	39 c2                	cmp    %eax,%edx
  8027cd:	0f 86 b5 00 00 00    	jbe    802888 <insert_sorted_with_merge_freeList+0x1ff>
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	8b 50 08             	mov    0x8(%eax),%edx
  8027d9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027de:	8b 48 0c             	mov    0xc(%eax),%ecx
  8027e1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027e6:	8b 40 08             	mov    0x8(%eax),%eax
  8027e9:	01 c8                	add    %ecx,%eax
  8027eb:	39 c2                	cmp    %eax,%edx
  8027ed:	0f 85 95 00 00 00    	jne    802888 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8027f3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027f8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8027fe:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802801:	8b 55 08             	mov    0x8(%ebp),%edx
  802804:	8b 52 0c             	mov    0xc(%edx),%edx
  802807:	01 ca                	add    %ecx,%edx
  802809:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802824:	75 17                	jne    80283d <insert_sorted_with_merge_freeList+0x1b4>
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 90 39 80 00       	push   $0x803990
  80282e:	68 54 01 00 00       	push   $0x154
  802833:	68 b3 39 80 00       	push   $0x8039b3
  802838:	e8 13 07 00 00       	call   802f50 <_panic>
  80283d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	89 10                	mov    %edx,(%eax)
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 0d                	je     80285e <insert_sorted_with_merge_freeList+0x1d5>
  802851:	a1 48 41 80 00       	mov    0x804148,%eax
  802856:	8b 55 08             	mov    0x8(%ebp),%edx
  802859:	89 50 04             	mov    %edx,0x4(%eax)
  80285c:	eb 08                	jmp    802866 <insert_sorted_with_merge_freeList+0x1dd>
  80285e:	8b 45 08             	mov    0x8(%ebp),%eax
  802861:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	a3 48 41 80 00       	mov    %eax,0x804148
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802878:	a1 54 41 80 00       	mov    0x804154,%eax
  80287d:	40                   	inc    %eax
  80287e:	a3 54 41 80 00       	mov    %eax,0x804154
  802883:	e9 0e 06 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	8b 50 08             	mov    0x8(%eax),%edx
  80288e:	a1 38 41 80 00       	mov    0x804138,%eax
  802893:	8b 40 08             	mov    0x8(%eax),%eax
  802896:	39 c2                	cmp    %eax,%edx
  802898:	0f 83 c1 00 00 00    	jae    80295f <insert_sorted_with_merge_freeList+0x2d6>
  80289e:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a3:	8b 50 08             	mov    0x8(%eax),%edx
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	8b 48 08             	mov    0x8(%eax),%ecx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b2:	01 c8                	add    %ecx,%eax
  8028b4:	39 c2                	cmp    %eax,%edx
  8028b6:	0f 85 a3 00 00 00    	jne    80295f <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8028bc:	a1 38 41 80 00       	mov    0x804138,%eax
  8028c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c4:	8b 52 08             	mov    0x8(%edx),%edx
  8028c7:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8028ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8028cf:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028d5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8028d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028db:	8b 52 0c             	mov    0xc(%edx),%edx
  8028de:	01 ca                	add    %ecx,%edx
  8028e0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8028f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028fb:	75 17                	jne    802914 <insert_sorted_with_merge_freeList+0x28b>
  8028fd:	83 ec 04             	sub    $0x4,%esp
  802900:	68 90 39 80 00       	push   $0x803990
  802905:	68 5d 01 00 00       	push   $0x15d
  80290a:	68 b3 39 80 00       	push   $0x8039b3
  80290f:	e8 3c 06 00 00       	call   802f50 <_panic>
  802914:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	89 10                	mov    %edx,(%eax)
  80291f:	8b 45 08             	mov    0x8(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 0d                	je     802935 <insert_sorted_with_merge_freeList+0x2ac>
  802928:	a1 48 41 80 00       	mov    0x804148,%eax
  80292d:	8b 55 08             	mov    0x8(%ebp),%edx
  802930:	89 50 04             	mov    %edx,0x4(%eax)
  802933:	eb 08                	jmp    80293d <insert_sorted_with_merge_freeList+0x2b4>
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	a3 48 41 80 00       	mov    %eax,0x804148
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294f:	a1 54 41 80 00       	mov    0x804154,%eax
  802954:	40                   	inc    %eax
  802955:	a3 54 41 80 00       	mov    %eax,0x804154
  80295a:	e9 37 05 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	8b 50 08             	mov    0x8(%eax),%edx
  802965:	a1 38 41 80 00       	mov    0x804138,%eax
  80296a:	8b 40 08             	mov    0x8(%eax),%eax
  80296d:	39 c2                	cmp    %eax,%edx
  80296f:	0f 83 82 00 00 00    	jae    8029f7 <insert_sorted_with_merge_freeList+0x36e>
  802975:	a1 38 41 80 00       	mov    0x804138,%eax
  80297a:	8b 50 08             	mov    0x8(%eax),%edx
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	8b 48 08             	mov    0x8(%eax),%ecx
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	8b 40 0c             	mov    0xc(%eax),%eax
  802989:	01 c8                	add    %ecx,%eax
  80298b:	39 c2                	cmp    %eax,%edx
  80298d:	74 68                	je     8029f7 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80298f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802993:	75 17                	jne    8029ac <insert_sorted_with_merge_freeList+0x323>
  802995:	83 ec 04             	sub    $0x4,%esp
  802998:	68 90 39 80 00       	push   $0x803990
  80299d:	68 62 01 00 00       	push   $0x162
  8029a2:	68 b3 39 80 00       	push   $0x8039b3
  8029a7:	e8 a4 05 00 00       	call   802f50 <_panic>
  8029ac:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	89 10                	mov    %edx,(%eax)
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	85 c0                	test   %eax,%eax
  8029be:	74 0d                	je     8029cd <insert_sorted_with_merge_freeList+0x344>
  8029c0:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c8:	89 50 04             	mov    %edx,0x4(%eax)
  8029cb:	eb 08                	jmp    8029d5 <insert_sorted_with_merge_freeList+0x34c>
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	a3 38 41 80 00       	mov    %eax,0x804138
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e7:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ec:	40                   	inc    %eax
  8029ed:	a3 44 41 80 00       	mov    %eax,0x804144
  8029f2:	e9 9f 04 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8029f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802a01:	e9 84 04 00 00       	jmp    802e8a <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 50 08             	mov    0x8(%eax),%edx
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	8b 40 08             	mov    0x8(%eax),%eax
  802a12:	39 c2                	cmp    %eax,%edx
  802a14:	0f 86 a9 00 00 00    	jbe    802ac3 <insert_sorted_with_merge_freeList+0x43a>
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 50 08             	mov    0x8(%eax),%edx
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	8b 48 08             	mov    0x8(%eax),%ecx
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	01 c8                	add    %ecx,%eax
  802a2e:	39 c2                	cmp    %eax,%edx
  802a30:	0f 84 8d 00 00 00    	je     802ac3 <insert_sorted_with_merge_freeList+0x43a>
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	8b 50 08             	mov    0x8(%eax),%edx
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	8b 48 08             	mov    0x8(%eax),%ecx
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 40 04             	mov    0x4(%eax),%eax
  802a4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4e:	01 c8                	add    %ecx,%eax
  802a50:	39 c2                	cmp    %eax,%edx
  802a52:	74 6f                	je     802ac3 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a58:	74 06                	je     802a60 <insert_sorted_with_merge_freeList+0x3d7>
  802a5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5e:	75 17                	jne    802a77 <insert_sorted_with_merge_freeList+0x3ee>
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	68 f0 39 80 00       	push   $0x8039f0
  802a68:	68 6b 01 00 00       	push   $0x16b
  802a6d:	68 b3 39 80 00       	push   $0x8039b3
  802a72:	e8 d9 04 00 00       	call   802f50 <_panic>
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 50 04             	mov    0x4(%eax),%edx
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	89 50 04             	mov    %edx,0x4(%eax)
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a89:	89 10                	mov    %edx,(%eax)
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 0d                	je     802aa2 <insert_sorted_with_merge_freeList+0x419>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9e:	89 10                	mov    %edx,(%eax)
  802aa0:	eb 08                	jmp    802aaa <insert_sorted_with_merge_freeList+0x421>
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	a3 38 41 80 00       	mov    %eax,0x804138
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab0:	89 50 04             	mov    %edx,0x4(%eax)
  802ab3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab8:	40                   	inc    %eax
  802ab9:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802abe:	e9 d3 03 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 50 08             	mov    0x8(%eax),%edx
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	8b 40 08             	mov    0x8(%eax),%eax
  802acf:	39 c2                	cmp    %eax,%edx
  802ad1:	0f 86 da 00 00 00    	jbe    802bb1 <insert_sorted_with_merge_freeList+0x528>
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 50 08             	mov    0x8(%eax),%edx
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8b 48 08             	mov    0x8(%eax),%ecx
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae9:	01 c8                	add    %ecx,%eax
  802aeb:	39 c2                	cmp    %eax,%edx
  802aed:	0f 85 be 00 00 00    	jne    802bb1 <insert_sorted_with_merge_freeList+0x528>
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	8b 50 08             	mov    0x8(%eax),%edx
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	8b 48 08             	mov    0x8(%eax),%ecx
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	01 c8                	add    %ecx,%eax
  802b0d:	39 c2                	cmp    %eax,%edx
  802b0f:	0f 84 9c 00 00 00    	je     802bb1 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8b 50 08             	mov    0x8(%eax),%edx
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 50 0c             	mov    0xc(%eax),%edx
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2d:	01 c2                	add    %eax,%edx
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4d:	75 17                	jne    802b66 <insert_sorted_with_merge_freeList+0x4dd>
  802b4f:	83 ec 04             	sub    $0x4,%esp
  802b52:	68 90 39 80 00       	push   $0x803990
  802b57:	68 74 01 00 00       	push   $0x174
  802b5c:	68 b3 39 80 00       	push   $0x8039b3
  802b61:	e8 ea 03 00 00       	call   802f50 <_panic>
  802b66:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	89 10                	mov    %edx,(%eax)
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	74 0d                	je     802b87 <insert_sorted_with_merge_freeList+0x4fe>
  802b7a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b82:	89 50 04             	mov    %edx,0x4(%eax)
  802b85:	eb 08                	jmp    802b8f <insert_sorted_with_merge_freeList+0x506>
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	a3 48 41 80 00       	mov    %eax,0x804148
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba1:	a1 54 41 80 00       	mov    0x804154,%eax
  802ba6:	40                   	inc    %eax
  802ba7:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802bac:	e9 e5 02 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 50 08             	mov    0x8(%eax),%edx
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	8b 40 08             	mov    0x8(%eax),%eax
  802bbd:	39 c2                	cmp    %eax,%edx
  802bbf:	0f 86 d7 00 00 00    	jbe    802c9c <insert_sorted_with_merge_freeList+0x613>
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 50 08             	mov    0x8(%eax),%edx
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	8b 48 08             	mov    0x8(%eax),%ecx
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd7:	01 c8                	add    %ecx,%eax
  802bd9:	39 c2                	cmp    %eax,%edx
  802bdb:	0f 84 bb 00 00 00    	je     802c9c <insert_sorted_with_merge_freeList+0x613>
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 50 08             	mov    0x8(%eax),%edx
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	8b 48 08             	mov    0x8(%eax),%ecx
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf9:	01 c8                	add    %ecx,%eax
  802bfb:	39 c2                	cmp    %eax,%edx
  802bfd:	0f 85 99 00 00 00    	jne    802c9c <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 04             	mov    0x4(%eax),%eax
  802c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	8b 40 0c             	mov    0xc(%eax),%eax
  802c18:	01 c2                	add    %eax,%edx
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c38:	75 17                	jne    802c51 <insert_sorted_with_merge_freeList+0x5c8>
  802c3a:	83 ec 04             	sub    $0x4,%esp
  802c3d:	68 90 39 80 00       	push   $0x803990
  802c42:	68 7d 01 00 00       	push   $0x17d
  802c47:	68 b3 39 80 00       	push   $0x8039b3
  802c4c:	e8 ff 02 00 00       	call   802f50 <_panic>
  802c51:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	85 c0                	test   %eax,%eax
  802c63:	74 0d                	je     802c72 <insert_sorted_with_merge_freeList+0x5e9>
  802c65:	a1 48 41 80 00       	mov    0x804148,%eax
  802c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6d:	89 50 04             	mov    %edx,0x4(%eax)
  802c70:	eb 08                	jmp    802c7a <insert_sorted_with_merge_freeList+0x5f1>
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	a3 48 41 80 00       	mov    %eax,0x804148
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8c:	a1 54 41 80 00       	mov    0x804154,%eax
  802c91:	40                   	inc    %eax
  802c92:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802c97:	e9 fa 01 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 40 08             	mov    0x8(%eax),%eax
  802ca8:	39 c2                	cmp    %eax,%edx
  802caa:	0f 86 d2 01 00 00    	jbe    802e82 <insert_sorted_with_merge_freeList+0x7f9>
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 50 08             	mov    0x8(%eax),%edx
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	8b 48 08             	mov    0x8(%eax),%ecx
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc2:	01 c8                	add    %ecx,%eax
  802cc4:	39 c2                	cmp    %eax,%edx
  802cc6:	0f 85 b6 01 00 00    	jne    802e82 <insert_sorted_with_merge_freeList+0x7f9>
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	8b 50 08             	mov    0x8(%eax),%edx
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	8b 48 08             	mov    0x8(%eax),%ecx
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	01 c8                	add    %ecx,%eax
  802ce6:	39 c2                	cmp    %eax,%edx
  802ce8:	0f 85 94 01 00 00    	jne    802e82 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf7:	8b 52 04             	mov    0x4(%edx),%edx
  802cfa:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802d00:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d06:	8b 52 0c             	mov    0xc(%edx),%edx
  802d09:	01 da                	add    %ebx,%edx
  802d0b:	01 ca                	add    %ecx,%edx
  802d0d:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d28:	75 17                	jne    802d41 <insert_sorted_with_merge_freeList+0x6b8>
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	68 25 3a 80 00       	push   $0x803a25
  802d32:	68 86 01 00 00       	push   $0x186
  802d37:	68 b3 39 80 00       	push   $0x8039b3
  802d3c:	e8 0f 02 00 00       	call   802f50 <_panic>
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	85 c0                	test   %eax,%eax
  802d48:	74 10                	je     802d5a <insert_sorted_with_merge_freeList+0x6d1>
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d52:	8b 52 04             	mov    0x4(%edx),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%eax)
  802d58:	eb 0b                	jmp    802d65 <insert_sorted_with_merge_freeList+0x6dc>
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 40 04             	mov    0x4(%eax),%eax
  802d60:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	74 0f                	je     802d7e <insert_sorted_with_merge_freeList+0x6f5>
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 04             	mov    0x4(%eax),%eax
  802d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d78:	8b 12                	mov    (%edx),%edx
  802d7a:	89 10                	mov    %edx,(%eax)
  802d7c:	eb 0a                	jmp    802d88 <insert_sorted_with_merge_freeList+0x6ff>
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 00                	mov    (%eax),%eax
  802d83:	a3 38 41 80 00       	mov    %eax,0x804138
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9b:	a1 44 41 80 00       	mov    0x804144,%eax
  802da0:	48                   	dec    %eax
  802da1:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802da6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802daa:	75 17                	jne    802dc3 <insert_sorted_with_merge_freeList+0x73a>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 90 39 80 00       	push   $0x803990
  802db4:	68 87 01 00 00       	push   $0x187
  802db9:	68 b3 39 80 00       	push   $0x8039b3
  802dbe:	e8 8d 01 00 00       	call   802f50 <_panic>
  802dc3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	89 10                	mov    %edx,(%eax)
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 0d                	je     802de4 <insert_sorted_with_merge_freeList+0x75b>
  802dd7:	a1 48 41 80 00       	mov    0x804148,%eax
  802ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddf:	89 50 04             	mov    %edx,0x4(%eax)
  802de2:	eb 08                	jmp    802dec <insert_sorted_with_merge_freeList+0x763>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	a3 48 41 80 00       	mov    %eax,0x804148
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfe:	a1 54 41 80 00       	mov    0x804154,%eax
  802e03:	40                   	inc    %eax
  802e04:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e21:	75 17                	jne    802e3a <insert_sorted_with_merge_freeList+0x7b1>
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 90 39 80 00       	push   $0x803990
  802e2b:	68 8a 01 00 00       	push   $0x18a
  802e30:	68 b3 39 80 00       	push   $0x8039b3
  802e35:	e8 16 01 00 00       	call   802f50 <_panic>
  802e3a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	89 10                	mov    %edx,(%eax)
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 0d                	je     802e5b <insert_sorted_with_merge_freeList+0x7d2>
  802e4e:	a1 48 41 80 00       	mov    0x804148,%eax
  802e53:	8b 55 08             	mov    0x8(%ebp),%edx
  802e56:	89 50 04             	mov    %edx,0x4(%eax)
  802e59:	eb 08                	jmp    802e63 <insert_sorted_with_merge_freeList+0x7da>
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e75:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7a:	40                   	inc    %eax
  802e7b:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  802e80:	eb 14                	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  802e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8e:	0f 85 72 fb ff ff    	jne    802a06 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802e94:	eb 00                	jmp    802e96 <insert_sorted_with_merge_freeList+0x80d>
  802e96:	90                   	nop
  802e97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e9a:	c9                   	leave  
  802e9b:	c3                   	ret    

00802e9c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e9c:	55                   	push   %ebp
  802e9d:	89 e5                	mov    %esp,%ebp
  802e9f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea5:	89 d0                	mov    %edx,%eax
  802ea7:	c1 e0 02             	shl    $0x2,%eax
  802eaa:	01 d0                	add    %edx,%eax
  802eac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802eb3:	01 d0                	add    %edx,%eax
  802eb5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ebc:	01 d0                	add    %edx,%eax
  802ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ec5:	01 d0                	add    %edx,%eax
  802ec7:	c1 e0 04             	shl    $0x4,%eax
  802eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802ecd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ed4:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ed7:	83 ec 0c             	sub    $0xc,%esp
  802eda:	50                   	push   %eax
  802edb:	e8 7b eb ff ff       	call   801a5b <sys_get_virtual_time>
  802ee0:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ee3:	eb 41                	jmp    802f26 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ee5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ee8:	83 ec 0c             	sub    $0xc,%esp
  802eeb:	50                   	push   %eax
  802eec:	e8 6a eb ff ff       	call   801a5b <sys_get_virtual_time>
  802ef1:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ef4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efa:	29 c2                	sub    %eax,%edx
  802efc:	89 d0                	mov    %edx,%eax
  802efe:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802f01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f07:	89 d1                	mov    %edx,%ecx
  802f09:	29 c1                	sub    %eax,%ecx
  802f0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f11:	39 c2                	cmp    %eax,%edx
  802f13:	0f 97 c0             	seta   %al
  802f16:	0f b6 c0             	movzbl %al,%eax
  802f19:	29 c1                	sub    %eax,%ecx
  802f1b:	89 c8                	mov    %ecx,%eax
  802f1d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f20:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f2c:	72 b7                	jb     802ee5 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f2e:	90                   	nop
  802f2f:	c9                   	leave  
  802f30:	c3                   	ret    

00802f31 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f31:	55                   	push   %ebp
  802f32:	89 e5                	mov    %esp,%ebp
  802f34:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f3e:	eb 03                	jmp    802f43 <busy_wait+0x12>
  802f40:	ff 45 fc             	incl   -0x4(%ebp)
  802f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f49:	72 f5                	jb     802f40 <busy_wait+0xf>
	return i;
  802f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f4e:	c9                   	leave  
  802f4f:	c3                   	ret    

00802f50 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f50:	55                   	push   %ebp
  802f51:	89 e5                	mov    %esp,%ebp
  802f53:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f56:	8d 45 10             	lea    0x10(%ebp),%eax
  802f59:	83 c0 04             	add    $0x4,%eax
  802f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f5f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f64:	85 c0                	test   %eax,%eax
  802f66:	74 16                	je     802f7e <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f68:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f6d:	83 ec 08             	sub    $0x8,%esp
  802f70:	50                   	push   %eax
  802f71:	68 44 3a 80 00       	push   $0x803a44
  802f76:	e8 00 d4 ff ff       	call   80037b <cprintf>
  802f7b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f7e:	a1 00 40 80 00       	mov    0x804000,%eax
  802f83:	ff 75 0c             	pushl  0xc(%ebp)
  802f86:	ff 75 08             	pushl  0x8(%ebp)
  802f89:	50                   	push   %eax
  802f8a:	68 49 3a 80 00       	push   $0x803a49
  802f8f:	e8 e7 d3 ff ff       	call   80037b <cprintf>
  802f94:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f97:	8b 45 10             	mov    0x10(%ebp),%eax
  802f9a:	83 ec 08             	sub    $0x8,%esp
  802f9d:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa0:	50                   	push   %eax
  802fa1:	e8 6a d3 ff ff       	call   800310 <vcprintf>
  802fa6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802fa9:	83 ec 08             	sub    $0x8,%esp
  802fac:	6a 00                	push   $0x0
  802fae:	68 65 3a 80 00       	push   $0x803a65
  802fb3:	e8 58 d3 ff ff       	call   800310 <vcprintf>
  802fb8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802fbb:	e8 d9 d2 ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  802fc0:	eb fe                	jmp    802fc0 <_panic+0x70>

00802fc2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
  802fc5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802fc8:	a1 20 40 80 00       	mov    0x804020,%eax
  802fcd:	8b 50 74             	mov    0x74(%eax),%edx
  802fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd3:	39 c2                	cmp    %eax,%edx
  802fd5:	74 14                	je     802feb <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	68 68 3a 80 00       	push   $0x803a68
  802fdf:	6a 26                	push   $0x26
  802fe1:	68 b4 3a 80 00       	push   $0x803ab4
  802fe6:	e8 65 ff ff ff       	call   802f50 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802feb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802ff2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ff9:	e9 c2 00 00 00       	jmp    8030c0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803001:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	01 d0                	add    %edx,%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	75 08                	jne    80301b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803013:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803016:	e9 a2 00 00 00       	jmp    8030bd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80301b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803022:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803029:	eb 69                	jmp    803094 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80302b:	a1 20 40 80 00       	mov    0x804020,%eax
  803030:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803036:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803039:	89 d0                	mov    %edx,%eax
  80303b:	01 c0                	add    %eax,%eax
  80303d:	01 d0                	add    %edx,%eax
  80303f:	c1 e0 03             	shl    $0x3,%eax
  803042:	01 c8                	add    %ecx,%eax
  803044:	8a 40 04             	mov    0x4(%eax),%al
  803047:	84 c0                	test   %al,%al
  803049:	75 46                	jne    803091 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80304b:	a1 20 40 80 00       	mov    0x804020,%eax
  803050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803056:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803059:	89 d0                	mov    %edx,%eax
  80305b:	01 c0                	add    %eax,%eax
  80305d:	01 d0                	add    %edx,%eax
  80305f:	c1 e0 03             	shl    $0x3,%eax
  803062:	01 c8                	add    %ecx,%eax
  803064:	8b 00                	mov    (%eax),%eax
  803066:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803069:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803071:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803076:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	01 c8                	add    %ecx,%eax
  803082:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803084:	39 c2                	cmp    %eax,%edx
  803086:	75 09                	jne    803091 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803088:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80308f:	eb 12                	jmp    8030a3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803091:	ff 45 e8             	incl   -0x18(%ebp)
  803094:	a1 20 40 80 00       	mov    0x804020,%eax
  803099:	8b 50 74             	mov    0x74(%eax),%edx
  80309c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309f:	39 c2                	cmp    %eax,%edx
  8030a1:	77 88                	ja     80302b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8030a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a7:	75 14                	jne    8030bd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	68 c0 3a 80 00       	push   $0x803ac0
  8030b1:	6a 3a                	push   $0x3a
  8030b3:	68 b4 3a 80 00       	push   $0x803ab4
  8030b8:	e8 93 fe ff ff       	call   802f50 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8030bd:	ff 45 f0             	incl   -0x10(%ebp)
  8030c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030c6:	0f 8c 32 ff ff ff    	jl     802ffe <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8030cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030da:	eb 26                	jmp    803102 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8030e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ea:	89 d0                	mov    %edx,%eax
  8030ec:	01 c0                	add    %eax,%eax
  8030ee:	01 d0                	add    %edx,%eax
  8030f0:	c1 e0 03             	shl    $0x3,%eax
  8030f3:	01 c8                	add    %ecx,%eax
  8030f5:	8a 40 04             	mov    0x4(%eax),%al
  8030f8:	3c 01                	cmp    $0x1,%al
  8030fa:	75 03                	jne    8030ff <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8030fc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030ff:	ff 45 e0             	incl   -0x20(%ebp)
  803102:	a1 20 40 80 00       	mov    0x804020,%eax
  803107:	8b 50 74             	mov    0x74(%eax),%edx
  80310a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310d:	39 c2                	cmp    %eax,%edx
  80310f:	77 cb                	ja     8030dc <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803117:	74 14                	je     80312d <CheckWSWithoutLastIndex+0x16b>
		panic(
  803119:	83 ec 04             	sub    $0x4,%esp
  80311c:	68 14 3b 80 00       	push   $0x803b14
  803121:	6a 44                	push   $0x44
  803123:	68 b4 3a 80 00       	push   $0x803ab4
  803128:	e8 23 fe ff ff       	call   802f50 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80312d:	90                   	nop
  80312e:	c9                   	leave  
  80312f:	c3                   	ret    

00803130 <__udivdi3>:
  803130:	55                   	push   %ebp
  803131:	57                   	push   %edi
  803132:	56                   	push   %esi
  803133:	53                   	push   %ebx
  803134:	83 ec 1c             	sub    $0x1c,%esp
  803137:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80313b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80313f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803143:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803147:	89 ca                	mov    %ecx,%edx
  803149:	89 f8                	mov    %edi,%eax
  80314b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80314f:	85 f6                	test   %esi,%esi
  803151:	75 2d                	jne    803180 <__udivdi3+0x50>
  803153:	39 cf                	cmp    %ecx,%edi
  803155:	77 65                	ja     8031bc <__udivdi3+0x8c>
  803157:	89 fd                	mov    %edi,%ebp
  803159:	85 ff                	test   %edi,%edi
  80315b:	75 0b                	jne    803168 <__udivdi3+0x38>
  80315d:	b8 01 00 00 00       	mov    $0x1,%eax
  803162:	31 d2                	xor    %edx,%edx
  803164:	f7 f7                	div    %edi
  803166:	89 c5                	mov    %eax,%ebp
  803168:	31 d2                	xor    %edx,%edx
  80316a:	89 c8                	mov    %ecx,%eax
  80316c:	f7 f5                	div    %ebp
  80316e:	89 c1                	mov    %eax,%ecx
  803170:	89 d8                	mov    %ebx,%eax
  803172:	f7 f5                	div    %ebp
  803174:	89 cf                	mov    %ecx,%edi
  803176:	89 fa                	mov    %edi,%edx
  803178:	83 c4 1c             	add    $0x1c,%esp
  80317b:	5b                   	pop    %ebx
  80317c:	5e                   	pop    %esi
  80317d:	5f                   	pop    %edi
  80317e:	5d                   	pop    %ebp
  80317f:	c3                   	ret    
  803180:	39 ce                	cmp    %ecx,%esi
  803182:	77 28                	ja     8031ac <__udivdi3+0x7c>
  803184:	0f bd fe             	bsr    %esi,%edi
  803187:	83 f7 1f             	xor    $0x1f,%edi
  80318a:	75 40                	jne    8031cc <__udivdi3+0x9c>
  80318c:	39 ce                	cmp    %ecx,%esi
  80318e:	72 0a                	jb     80319a <__udivdi3+0x6a>
  803190:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803194:	0f 87 9e 00 00 00    	ja     803238 <__udivdi3+0x108>
  80319a:	b8 01 00 00 00       	mov    $0x1,%eax
  80319f:	89 fa                	mov    %edi,%edx
  8031a1:	83 c4 1c             	add    $0x1c,%esp
  8031a4:	5b                   	pop    %ebx
  8031a5:	5e                   	pop    %esi
  8031a6:	5f                   	pop    %edi
  8031a7:	5d                   	pop    %ebp
  8031a8:	c3                   	ret    
  8031a9:	8d 76 00             	lea    0x0(%esi),%esi
  8031ac:	31 ff                	xor    %edi,%edi
  8031ae:	31 c0                	xor    %eax,%eax
  8031b0:	89 fa                	mov    %edi,%edx
  8031b2:	83 c4 1c             	add    $0x1c,%esp
  8031b5:	5b                   	pop    %ebx
  8031b6:	5e                   	pop    %esi
  8031b7:	5f                   	pop    %edi
  8031b8:	5d                   	pop    %ebp
  8031b9:	c3                   	ret    
  8031ba:	66 90                	xchg   %ax,%ax
  8031bc:	89 d8                	mov    %ebx,%eax
  8031be:	f7 f7                	div    %edi
  8031c0:	31 ff                	xor    %edi,%edi
  8031c2:	89 fa                	mov    %edi,%edx
  8031c4:	83 c4 1c             	add    $0x1c,%esp
  8031c7:	5b                   	pop    %ebx
  8031c8:	5e                   	pop    %esi
  8031c9:	5f                   	pop    %edi
  8031ca:	5d                   	pop    %ebp
  8031cb:	c3                   	ret    
  8031cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031d1:	89 eb                	mov    %ebp,%ebx
  8031d3:	29 fb                	sub    %edi,%ebx
  8031d5:	89 f9                	mov    %edi,%ecx
  8031d7:	d3 e6                	shl    %cl,%esi
  8031d9:	89 c5                	mov    %eax,%ebp
  8031db:	88 d9                	mov    %bl,%cl
  8031dd:	d3 ed                	shr    %cl,%ebp
  8031df:	89 e9                	mov    %ebp,%ecx
  8031e1:	09 f1                	or     %esi,%ecx
  8031e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031e7:	89 f9                	mov    %edi,%ecx
  8031e9:	d3 e0                	shl    %cl,%eax
  8031eb:	89 c5                	mov    %eax,%ebp
  8031ed:	89 d6                	mov    %edx,%esi
  8031ef:	88 d9                	mov    %bl,%cl
  8031f1:	d3 ee                	shr    %cl,%esi
  8031f3:	89 f9                	mov    %edi,%ecx
  8031f5:	d3 e2                	shl    %cl,%edx
  8031f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031fb:	88 d9                	mov    %bl,%cl
  8031fd:	d3 e8                	shr    %cl,%eax
  8031ff:	09 c2                	or     %eax,%edx
  803201:	89 d0                	mov    %edx,%eax
  803203:	89 f2                	mov    %esi,%edx
  803205:	f7 74 24 0c          	divl   0xc(%esp)
  803209:	89 d6                	mov    %edx,%esi
  80320b:	89 c3                	mov    %eax,%ebx
  80320d:	f7 e5                	mul    %ebp
  80320f:	39 d6                	cmp    %edx,%esi
  803211:	72 19                	jb     80322c <__udivdi3+0xfc>
  803213:	74 0b                	je     803220 <__udivdi3+0xf0>
  803215:	89 d8                	mov    %ebx,%eax
  803217:	31 ff                	xor    %edi,%edi
  803219:	e9 58 ff ff ff       	jmp    803176 <__udivdi3+0x46>
  80321e:	66 90                	xchg   %ax,%ax
  803220:	8b 54 24 08          	mov    0x8(%esp),%edx
  803224:	89 f9                	mov    %edi,%ecx
  803226:	d3 e2                	shl    %cl,%edx
  803228:	39 c2                	cmp    %eax,%edx
  80322a:	73 e9                	jae    803215 <__udivdi3+0xe5>
  80322c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80322f:	31 ff                	xor    %edi,%edi
  803231:	e9 40 ff ff ff       	jmp    803176 <__udivdi3+0x46>
  803236:	66 90                	xchg   %ax,%ax
  803238:	31 c0                	xor    %eax,%eax
  80323a:	e9 37 ff ff ff       	jmp    803176 <__udivdi3+0x46>
  80323f:	90                   	nop

00803240 <__umoddi3>:
  803240:	55                   	push   %ebp
  803241:	57                   	push   %edi
  803242:	56                   	push   %esi
  803243:	53                   	push   %ebx
  803244:	83 ec 1c             	sub    $0x1c,%esp
  803247:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80324b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80324f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803253:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803257:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80325b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80325f:	89 f3                	mov    %esi,%ebx
  803261:	89 fa                	mov    %edi,%edx
  803263:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803267:	89 34 24             	mov    %esi,(%esp)
  80326a:	85 c0                	test   %eax,%eax
  80326c:	75 1a                	jne    803288 <__umoddi3+0x48>
  80326e:	39 f7                	cmp    %esi,%edi
  803270:	0f 86 a2 00 00 00    	jbe    803318 <__umoddi3+0xd8>
  803276:	89 c8                	mov    %ecx,%eax
  803278:	89 f2                	mov    %esi,%edx
  80327a:	f7 f7                	div    %edi
  80327c:	89 d0                	mov    %edx,%eax
  80327e:	31 d2                	xor    %edx,%edx
  803280:	83 c4 1c             	add    $0x1c,%esp
  803283:	5b                   	pop    %ebx
  803284:	5e                   	pop    %esi
  803285:	5f                   	pop    %edi
  803286:	5d                   	pop    %ebp
  803287:	c3                   	ret    
  803288:	39 f0                	cmp    %esi,%eax
  80328a:	0f 87 ac 00 00 00    	ja     80333c <__umoddi3+0xfc>
  803290:	0f bd e8             	bsr    %eax,%ebp
  803293:	83 f5 1f             	xor    $0x1f,%ebp
  803296:	0f 84 ac 00 00 00    	je     803348 <__umoddi3+0x108>
  80329c:	bf 20 00 00 00       	mov    $0x20,%edi
  8032a1:	29 ef                	sub    %ebp,%edi
  8032a3:	89 fe                	mov    %edi,%esi
  8032a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032a9:	89 e9                	mov    %ebp,%ecx
  8032ab:	d3 e0                	shl    %cl,%eax
  8032ad:	89 d7                	mov    %edx,%edi
  8032af:	89 f1                	mov    %esi,%ecx
  8032b1:	d3 ef                	shr    %cl,%edi
  8032b3:	09 c7                	or     %eax,%edi
  8032b5:	89 e9                	mov    %ebp,%ecx
  8032b7:	d3 e2                	shl    %cl,%edx
  8032b9:	89 14 24             	mov    %edx,(%esp)
  8032bc:	89 d8                	mov    %ebx,%eax
  8032be:	d3 e0                	shl    %cl,%eax
  8032c0:	89 c2                	mov    %eax,%edx
  8032c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c6:	d3 e0                	shl    %cl,%eax
  8032c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d0:	89 f1                	mov    %esi,%ecx
  8032d2:	d3 e8                	shr    %cl,%eax
  8032d4:	09 d0                	or     %edx,%eax
  8032d6:	d3 eb                	shr    %cl,%ebx
  8032d8:	89 da                	mov    %ebx,%edx
  8032da:	f7 f7                	div    %edi
  8032dc:	89 d3                	mov    %edx,%ebx
  8032de:	f7 24 24             	mull   (%esp)
  8032e1:	89 c6                	mov    %eax,%esi
  8032e3:	89 d1                	mov    %edx,%ecx
  8032e5:	39 d3                	cmp    %edx,%ebx
  8032e7:	0f 82 87 00 00 00    	jb     803374 <__umoddi3+0x134>
  8032ed:	0f 84 91 00 00 00    	je     803384 <__umoddi3+0x144>
  8032f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032f7:	29 f2                	sub    %esi,%edx
  8032f9:	19 cb                	sbb    %ecx,%ebx
  8032fb:	89 d8                	mov    %ebx,%eax
  8032fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803301:	d3 e0                	shl    %cl,%eax
  803303:	89 e9                	mov    %ebp,%ecx
  803305:	d3 ea                	shr    %cl,%edx
  803307:	09 d0                	or     %edx,%eax
  803309:	89 e9                	mov    %ebp,%ecx
  80330b:	d3 eb                	shr    %cl,%ebx
  80330d:	89 da                	mov    %ebx,%edx
  80330f:	83 c4 1c             	add    $0x1c,%esp
  803312:	5b                   	pop    %ebx
  803313:	5e                   	pop    %esi
  803314:	5f                   	pop    %edi
  803315:	5d                   	pop    %ebp
  803316:	c3                   	ret    
  803317:	90                   	nop
  803318:	89 fd                	mov    %edi,%ebp
  80331a:	85 ff                	test   %edi,%edi
  80331c:	75 0b                	jne    803329 <__umoddi3+0xe9>
  80331e:	b8 01 00 00 00       	mov    $0x1,%eax
  803323:	31 d2                	xor    %edx,%edx
  803325:	f7 f7                	div    %edi
  803327:	89 c5                	mov    %eax,%ebp
  803329:	89 f0                	mov    %esi,%eax
  80332b:	31 d2                	xor    %edx,%edx
  80332d:	f7 f5                	div    %ebp
  80332f:	89 c8                	mov    %ecx,%eax
  803331:	f7 f5                	div    %ebp
  803333:	89 d0                	mov    %edx,%eax
  803335:	e9 44 ff ff ff       	jmp    80327e <__umoddi3+0x3e>
  80333a:	66 90                	xchg   %ax,%ax
  80333c:	89 c8                	mov    %ecx,%eax
  80333e:	89 f2                	mov    %esi,%edx
  803340:	83 c4 1c             	add    $0x1c,%esp
  803343:	5b                   	pop    %ebx
  803344:	5e                   	pop    %esi
  803345:	5f                   	pop    %edi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    
  803348:	3b 04 24             	cmp    (%esp),%eax
  80334b:	72 06                	jb     803353 <__umoddi3+0x113>
  80334d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803351:	77 0f                	ja     803362 <__umoddi3+0x122>
  803353:	89 f2                	mov    %esi,%edx
  803355:	29 f9                	sub    %edi,%ecx
  803357:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80335b:	89 14 24             	mov    %edx,(%esp)
  80335e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803362:	8b 44 24 04          	mov    0x4(%esp),%eax
  803366:	8b 14 24             	mov    (%esp),%edx
  803369:	83 c4 1c             	add    $0x1c,%esp
  80336c:	5b                   	pop    %ebx
  80336d:	5e                   	pop    %esi
  80336e:	5f                   	pop    %edi
  80336f:	5d                   	pop    %ebp
  803370:	c3                   	ret    
  803371:	8d 76 00             	lea    0x0(%esi),%esi
  803374:	2b 04 24             	sub    (%esp),%eax
  803377:	19 fa                	sbb    %edi,%edx
  803379:	89 d1                	mov    %edx,%ecx
  80337b:	89 c6                	mov    %eax,%esi
  80337d:	e9 71 ff ff ff       	jmp    8032f3 <__umoddi3+0xb3>
  803382:	66 90                	xchg   %ax,%ax
  803384:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803388:	72 ea                	jb     803374 <__umoddi3+0x134>
  80338a:	89 d9                	mov    %ebx,%ecx
  80338c:	e9 62 ff ff ff       	jmp    8032f3 <__umoddi3+0xb3>
