
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 5f 01 00 00       	call   800195 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 3: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 33 80 00       	push   $0x8033c0
  80004a:	e8 e7 15 00 00       	call   801636 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 d6 18 00 00       	call   801939 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 6e 19 00 00       	call   8019d9 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 33 80 00       	push   $0x8033d0
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 03 34 80 00       	push   $0x803403
  800099:	e8 0d 1b 00 00       	call   801bab <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 0c 34 80 00       	push   $0x80340c
  8000bc:	e8 ea 1a 00 00       	call   801bab <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 f7 1a 00 00       	call   801bc9 <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 c4 2f 00 00       	call   8030a6 <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 d9 1a 00 00       	call   801bc9 <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 36 18 00 00       	call   801939 <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 18 34 80 00       	push   $0x803418
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 c6 1a 00 00       	call   801be5 <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 b8 1a 00 00       	call   801be5 <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 04 18 00 00       	call   801939 <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 9c 18 00 00       	call   8019d9 <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 4c 34 80 00       	push   $0x80344c
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 9c 34 80 00       	push   $0x80349c
  800163:	6a 23                	push   $0x23
  800165:	68 d2 34 80 00       	push   $0x8034d2
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 e8 34 80 00       	push   $0x8034e8
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 48 35 80 00       	push   $0x803548
  80018a:	e8 f6 03 00 00       	call   800585 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	return;
  800192:	90                   	nop
}
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80019b:	e8 79 1a 00 00       	call   801c19 <sys_getenvindex>
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a6:	89 d0                	mov    %edx,%eax
  8001a8:	c1 e0 03             	shl    $0x3,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	01 c0                	add    %eax,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	c1 e0 04             	shl    $0x4,%eax
  8001bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001d2:	84 c0                	test   %al,%al
  8001d4:	74 0f                	je     8001e5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001db:	05 5c 05 00 00       	add    $0x55c,%eax
  8001e0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x60>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800206:	e8 1b 18 00 00       	call   801a26 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 ac 35 80 00       	push   $0x8035ac
  800213:	e8 6d 03 00 00       	call   800585 <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021b:	a1 20 40 80 00       	mov    0x804020,%eax
  800220:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800226:	a1 20 40 80 00       	mov    0x804020,%eax
  80022b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 d4 35 80 00       	push   $0x8035d4
  80023b:	e8 45 03 00 00       	call   800585 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800243:	a1 20 40 80 00       	mov    0x804020,%eax
  800248:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024e:	a1 20 40 80 00       	mov    0x804020,%eax
  800253:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 fc 35 80 00       	push   $0x8035fc
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 54 36 80 00       	push   $0x803654
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 ac 35 80 00       	push   $0x8035ac
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 9b 17 00 00       	call   801a40 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a5:	e8 19 00 00 00       	call   8002c3 <exit>
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	6a 00                	push   $0x0
  8002b8:	e8 28 19 00 00       	call   801be5 <sys_destroy_env>
  8002bd:	83 c4 10             	add    $0x10,%esp
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <exit>:

void
exit(void)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c9:	e8 7d 19 00 00       	call   801c4b <sys_exit_env>
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002da:	83 c0 04             	add    $0x4,%eax
  8002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 16                	je     8002ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 68 36 80 00       	push   $0x803668
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 40 80 00       	mov    0x804000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 6d 36 80 00       	push   $0x80366d
  800310:	e8 70 02 00 00       	call   800585 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800318:	8b 45 10             	mov    0x10(%ebp),%eax
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 f4             	pushl  -0xc(%ebp)
  800321:	50                   	push   %eax
  800322:	e8 f3 01 00 00       	call   80051a <vcprintf>
  800327:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	6a 00                	push   $0x0
  80032f:	68 89 36 80 00       	push   $0x803689
  800334:	e8 e1 01 00 00       	call   80051a <vcprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033c:	e8 82 ff ff ff       	call   8002c3 <exit>

	// should not return here
	while (1) ;
  800341:	eb fe                	jmp    800341 <_panic+0x70>

00800343 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 50 74             	mov    0x74(%eax),%edx
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	39 c2                	cmp    %eax,%edx
  800356:	74 14                	je     80036c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 8c 36 80 00       	push   $0x80368c
  800360:	6a 26                	push   $0x26
  800362:	68 d8 36 80 00       	push   $0x8036d8
  800367:	e8 65 ff ff ff       	call   8002d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80037a:	e9 c2 00 00 00       	jmp    800441 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	75 08                	jne    80039c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800394:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800397:	e9 a2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80039c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003aa:	eb 69                	jmp    800415 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ba:	89 d0                	mov    %edx,%eax
  8003bc:	01 c0                	add    %eax,%eax
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	c1 e0 03             	shl    $0x3,%eax
  8003c3:	01 c8                	add    %ecx,%eax
  8003c5:	8a 40 04             	mov    0x4(%eax),%al
  8003c8:	84 c0                	test   %al,%al
  8003ca:	75 46                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	c1 e0 03             	shl    $0x3,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	01 c8                	add    %ecx,%eax
  800403:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800405:	39 c2                	cmp    %eax,%edx
  800407:	75 09                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800409:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800410:	eb 12                	jmp    800424 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800412:	ff 45 e8             	incl   -0x18(%ebp)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	77 88                	ja     8003ac <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800428:	75 14                	jne    80043e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 e4 36 80 00       	push   $0x8036e4
  800432:	6a 3a                	push   $0x3a
  800434:	68 d8 36 80 00       	push   $0x8036d8
  800439:	e8 93 fe ff ff       	call   8002d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043e:	ff 45 f0             	incl   -0x10(%ebp)
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800447:	0f 8c 32 ff ff ff    	jl     80037f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800454:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80045b:	eb 26                	jmp    800483 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045d:	a1 20 40 80 00       	mov    0x804020,%eax
  800462:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800468:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046b:	89 d0                	mov    %edx,%eax
  80046d:	01 c0                	add    %eax,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	c1 e0 03             	shl    $0x3,%eax
  800474:	01 c8                	add    %ecx,%eax
  800476:	8a 40 04             	mov    0x4(%eax),%al
  800479:	3c 01                	cmp    $0x1,%al
  80047b:	75 03                	jne    800480 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	ff 45 e0             	incl   -0x20(%ebp)
  800483:	a1 20 40 80 00       	mov    0x804020,%eax
  800488:	8b 50 74             	mov    0x74(%eax),%edx
  80048b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	77 cb                	ja     80045d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800498:	74 14                	je     8004ae <CheckWSWithoutLastIndex+0x16b>
		panic(
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 38 37 80 00       	push   $0x803738
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 d8 36 80 00       	push   $0x8036d8
  8004a9:	e8 23 fe ff ff       	call   8002d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 2c                	jne    800508 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004dc:	a0 24 40 80 00       	mov    0x804024,%al
  8004e1:	0f b6 c0             	movzbl %al,%eax
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	8b 12                	mov    (%edx),%edx
  8004e9:	89 d1                	mov    %edx,%ecx
  8004eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ee:	83 c2 08             	add    $0x8,%edx
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	50                   	push   %eax
  8004f5:	51                   	push   %ecx
  8004f6:	52                   	push   %edx
  8004f7:	e8 7c 13 00 00       	call   801878 <sys_cputs>
  8004fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	8b 40 04             	mov    0x4(%eax),%eax
  80050e:	8d 50 01             	lea    0x1(%eax),%edx
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	89 50 04             	mov    %edx,0x4(%eax)
}
  800517:	90                   	nop
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800523:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052a:	00 00 00 
	b.cnt = 0;
  80052d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800534:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	50                   	push   %eax
  800544:	68 b1 04 80 00       	push   $0x8004b1
  800549:	e8 11 02 00 00       	call   80075f <vprintfmt>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800551:	a0 24 40 80 00       	mov    0x804024,%al
  800556:	0f b6 c0             	movzbl %al,%eax
  800559:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	50                   	push   %eax
  800563:	52                   	push   %edx
  800564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	50                   	push   %eax
  80056e:	e8 05 13 00 00       	call   801878 <sys_cputs>
  800573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800576:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <cprintf>:

int cprintf(const char *fmt, ...) {
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800592:	8d 45 0c             	lea    0xc(%ebp),%eax
  800595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 73 ff ff ff       	call   80051a <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b8:	e8 69 14 00 00       	call   801a26 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 48 ff ff ff       	call   80051a <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d8:	e8 63 14 00 00       	call   801a40 <sys_enable_interrupt>
	return cnt;
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 14             	sub    $0x14,%esp
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800600:	77 55                	ja     800657 <printnum+0x75>
  800602:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800605:	72 05                	jb     80060c <printnum+0x2a>
  800607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80060a:	77 4b                	ja     800657 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800612:	8b 45 18             	mov    0x18(%ebp),%eax
  800615:	ba 00 00 00 00       	mov    $0x0,%edx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	ff 75 f4             	pushl  -0xc(%ebp)
  80061f:	ff 75 f0             	pushl  -0x10(%ebp)
  800622:	e8 35 2b 00 00       	call   80315c <__udivdi3>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	53                   	push   %ebx
  800631:	ff 75 18             	pushl  0x18(%ebp)
  800634:	52                   	push   %edx
  800635:	50                   	push   %eax
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 a1 ff ff ff       	call   8005e2 <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 1a                	jmp    800660 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 20             	pushl  0x20(%ebp)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	ff 4d 1c             	decl   0x1c(%ebp)
  80065a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065e:	7f e6                	jg     800646 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800660:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066e:	53                   	push   %ebx
  80066f:	51                   	push   %ecx
  800670:	52                   	push   %edx
  800671:	50                   	push   %eax
  800672:	e8 f5 2b 00 00       	call   80326c <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 b4 39 80 00       	add    $0x8039b4,%eax
  80067f:	8a 00                	mov    (%eax),%al
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	50                   	push   %eax
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	ff d0                	call   *%eax
  800690:	83 c4 10             	add    $0x10,%esp
}
  800693:	90                   	nop
  800694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a0:	7e 1c                	jle    8006be <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 08             	lea    0x8(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 08             	sub    $0x8,%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	eb 40                	jmp    8006fe <getuint+0x65>
	else if (lflag)
  8006be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c2:	74 1e                	je     8006e2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	eb 1c                	jmp    8006fe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800703:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800707:	7e 1c                	jle    800725 <getint+0x25>
		return va_arg(*ap, long long);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 08             	lea    0x8(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 08             	sub    $0x8,%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	eb 38                	jmp    80075d <getint+0x5d>
	else if (lflag)
  800725:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800729:	74 1a                	je     800745 <getint+0x45>
		return va_arg(*ap, long);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	99                   	cltd   
  800743:	eb 18                	jmp    80075d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	89 10                	mov    %edx,(%eax)
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	99                   	cltd   
}
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	eb 17                	jmp    800780 <vprintfmt+0x21>
			if (ch == '\0')
  800769:	85 db                	test   %ebx,%ebx
  80076b:	0f 84 af 03 00 00    	je     800b20 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	8d 50 01             	lea    0x1(%eax),%edx
  800786:	89 55 10             	mov    %edx,0x10(%ebp)
  800789:	8a 00                	mov    (%eax),%al
  80078b:	0f b6 d8             	movzbl %al,%ebx
  80078e:	83 fb 25             	cmp    $0x25,%ebx
  800791:	75 d6                	jne    800769 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800793:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800797:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	8d 50 01             	lea    0x1(%eax),%edx
  8007b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bc:	8a 00                	mov    (%eax),%al
  8007be:	0f b6 d8             	movzbl %al,%ebx
  8007c1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c4:	83 f8 55             	cmp    $0x55,%eax
  8007c7:	0f 87 2b 03 00 00    	ja     800af8 <vprintfmt+0x399>
  8007cd:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  8007d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007da:	eb d7                	jmp    8007b3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e0:	eb d1                	jmp    8007b3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	c1 e0 02             	shl    $0x2,%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	01 c0                	add    %eax,%eax
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	83 e8 30             	sub    $0x30,%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800805:	83 fb 2f             	cmp    $0x2f,%ebx
  800808:	7e 3e                	jle    800848 <vprintfmt+0xe9>
  80080a:	83 fb 39             	cmp    $0x39,%ebx
  80080d:	7f 39                	jg     800848 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800812:	eb d5                	jmp    8007e9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 c0 04             	add    $0x4,%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 e8 04             	sub    $0x4,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800828:	eb 1f                	jmp    800849 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	79 83                	jns    8007b3 <vprintfmt+0x54>
				width = 0;
  800830:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800837:	e9 77 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80083c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800843:	e9 6b ff ff ff       	jmp    8007b3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800848:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084d:	0f 89 60 ff ff ff    	jns    8007b3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800859:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800860:	e9 4e ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800865:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800868:	e9 46 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 c0 04             	add    $0x4,%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 e8 04             	sub    $0x4,%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	50                   	push   %eax
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 89 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	79 02                	jns    8008a9 <vprintfmt+0x14a>
				err = -err;
  8008a7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a9:	83 fb 64             	cmp    $0x64,%ebx
  8008ac:	7f 0b                	jg     8008b9 <vprintfmt+0x15a>
  8008ae:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 c5 39 80 00       	push   $0x8039c5
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 5e 02 00 00       	call   800b28 <printfmt>
  8008ca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cd:	e9 49 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d2:	56                   	push   %esi
  8008d3:	68 ce 39 80 00       	push   $0x8039ce
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 45 02 00 00       	call   800b28 <printfmt>
  8008e3:	83 c4 10             	add    $0x10,%esp
			break;
  8008e6:	e9 30 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 c0 04             	add    $0x4,%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 30                	mov    (%eax),%esi
  8008fc:	85 f6                	test   %esi,%esi
  8008fe:	75 05                	jne    800905 <vprintfmt+0x1a6>
				p = "(null)";
  800900:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	7e 6d                	jle    800978 <vprintfmt+0x219>
  80090b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090f:	74 67                	je     800978 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	50                   	push   %eax
  800918:	56                   	push   %esi
  800919:	e8 0c 03 00 00       	call   800c2a <strnlen>
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800924:	eb 16                	jmp    80093c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800926:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800939:	ff 4d e4             	decl   -0x1c(%ebp)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	7f e4                	jg     800926 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800942:	eb 34                	jmp    800978 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800944:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800948:	74 1c                	je     800966 <vprintfmt+0x207>
  80094a:	83 fb 1f             	cmp    $0x1f,%ebx
  80094d:	7e 05                	jle    800954 <vprintfmt+0x1f5>
  80094f:	83 fb 7e             	cmp    $0x7e,%ebx
  800952:	7e 12                	jle    800966 <vprintfmt+0x207>
					putch('?', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	6a 3f                	push   $0x3f
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	eb 0f                	jmp    800975 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	ff d0                	call   *%eax
  800972:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	ff 4d e4             	decl   -0x1c(%ebp)
  800978:	89 f0                	mov    %esi,%eax
  80097a:	8d 70 01             	lea    0x1(%eax),%esi
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f be d8             	movsbl %al,%ebx
  800982:	85 db                	test   %ebx,%ebx
  800984:	74 24                	je     8009aa <vprintfmt+0x24b>
  800986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098a:	78 b8                	js     800944 <vprintfmt+0x1e5>
  80098c:	ff 4d e0             	decl   -0x20(%ebp)
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	79 af                	jns    800944 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800995:	eb 13                	jmp    8009aa <vprintfmt+0x24b>
				putch(' ', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 20                	push   $0x20
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ae:	7f e7                	jg     800997 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b0:	e9 66 01 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 3c fd ff ff       	call   800700 <getint>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	79 23                	jns    8009fa <vprintfmt+0x29b>
				putch('-', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 2d                	push   $0x2d
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ed:	f7 d8                	neg    %eax
  8009ef:	83 d2 00             	adc    $0x0,%edx
  8009f2:	f7 da                	neg    %edx
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a01:	e9 bc 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	e8 84 fc ff ff       	call   800699 <getuint>
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a25:	e9 98 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 58                	push   $0x58
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	6a 58                	push   $0x58
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	6a 58                	push   $0x58
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
			break;
  800a5a:	e9 bc 00 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 30                	push   $0x30
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 78                	push   $0x78
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 e8 04             	sub    $0x4,%eax
  800a8e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 e7 fb ff ff       	call   800699 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	52                   	push   %edx
  800acd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad0:	50                   	push   %eax
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 00 fb ff ff       	call   8005e2 <printnum>
  800ae2:	83 c4 20             	add    $0x20,%esp
			break;
  800ae5:	eb 34                	jmp    800b1b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	eb 23                	jmp    800b1b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 25                	push   $0x25
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b08:	ff 4d 10             	decl   0x10(%ebp)
  800b0b:	eb 03                	jmp    800b10 <vprintfmt+0x3b1>
  800b0d:	ff 4d 10             	decl   0x10(%ebp)
  800b10:	8b 45 10             	mov    0x10(%ebp),%eax
  800b13:	48                   	dec    %eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3c 25                	cmp    $0x25,%al
  800b18:	75 f3                	jne    800b0d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b1a:	90                   	nop
		}
	}
  800b1b:	e9 47 fc ff ff       	jmp    800767 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b31:	83 c0 04             	add    $0x4,%eax
  800b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 16 fc ff ff       	call   80075f <vprintfmt>
  800b49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4c:	90                   	nop
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 08             	mov    0x8(%eax),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8b 10                	mov    (%eax),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	39 c2                	cmp    %eax,%edx
  800b6e:	73 12                	jae    800b82 <sprintputch+0x33>
		*b->buf++ = ch;
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	8d 48 01             	lea    0x1(%eax),%ecx
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	89 0a                	mov    %ecx,(%edx)
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	88 10                	mov    %dl,(%eax)
}
  800b82:	90                   	nop
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	01 d0                	add    %edx,%eax
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800baa:	74 06                	je     800bb2 <vsnprintf+0x2d>
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	7f 07                	jg     800bb9 <vsnprintf+0x34>
		return -E_INVAL;
  800bb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb7:	eb 20                	jmp    800bd9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb9:	ff 75 14             	pushl  0x14(%ebp)
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	68 4f 0b 80 00       	push   $0x800b4f
  800bc8:	e8 92 fb ff ff       	call   80075f <vprintfmt>
  800bcd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be1:	8d 45 10             	lea    0x10(%ebp),%eax
  800be4:	83 c0 04             	add    $0x4,%eax
  800be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 89 ff ff ff       	call   800b85 <vsnprintf>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c14:	eb 06                	jmp    800c1c <strlen+0x15>
		n++;
  800c16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c19:	ff 45 08             	incl   0x8(%ebp)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 f1                	jne    800c16 <strlen+0xf>
		n++;
	return n;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 09                	jmp    800c42 <strnlen+0x18>
		n++;
  800c39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 4d 0c             	decl   0xc(%ebp)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 09                	je     800c51 <strnlen+0x27>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 e8                	jne    800c39 <strnlen+0xf>
		n++;
	return n;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c62:	90                   	nop
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 e4                	jne    800c63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c97:	eb 1f                	jmp    800cb8 <strncpy+0x34>
		*dst++ = *src;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	74 03                	je     800cb5 <strncpy+0x31>
			src++;
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	ff 45 fc             	incl   -0x4(%ebp)
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbe:	72 d9                	jb     800c99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	74 30                	je     800d07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd7:	eb 16                	jmp    800cef <strlcpy+0x2a>
			*dst++ = *src++;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8d 50 01             	lea    0x1(%eax),%edx
  800cdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	74 09                	je     800d01 <strlcpy+0x3c>
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 d8                	jne    800cd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	29 c2                	sub    %eax,%edx
  800d0f:	89 d0                	mov    %edx,%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d16:	eb 06                	jmp    800d1e <strcmp+0xb>
		p++, q++;
  800d18:	ff 45 08             	incl   0x8(%ebp)
  800d1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strcmp+0x22>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 e3                	je     800d18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d0             	movzbl %al,%edx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
}
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4e:	eb 09                	jmp    800d59 <strncmp+0xe>
		n--, p++, q++;
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 17                	je     800d76 <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	74 0e                	je     800d76 <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 da                	je     800d50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	75 07                	jne    800d83 <strncmp+0x38>
		return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	eb 14                	jmp    800d97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 d0             	movzbl %al,%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f b6 c0             	movzbl %al,%eax
  800d93:	29 c2                	sub    %eax,%edx
  800d95:	89 d0                	mov    %edx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 12                	jmp    800db9 <strchr+0x20>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	75 05                	jne    800db6 <strchr+0x1d>
			return (char *) s;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	eb 11                	jmp    800dc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e5                	jne    800da7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd5:	eb 0d                	jmp    800de4 <strfind+0x1b>
		if (*s == c)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddf:	74 0e                	je     800def <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 ea                	jne    800dd7 <strfind+0xe>
  800ded:	eb 01                	jmp    800df0 <strfind+0x27>
		if (*s == c)
			break;
  800def:	90                   	nop
	return (char *) s;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e07:	eb 0e                	jmp    800e17 <memset+0x22>
		*p++ = c;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1e:	79 e9                	jns    800e09 <memset+0x14>
		*p++ = c;

	return v;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e37:	eb 16                	jmp    800e4f <memcpy+0x2a>
		*d++ = *s++;
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 dd                	jne    800e39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e79:	73 50                	jae    800ecb <memmove+0x6a>
  800e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e86:	76 43                	jbe    800ecb <memmove+0x6a>
		s += n;
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e94:	eb 10                	jmp    800ea6 <memmove+0x45>
			*--d = *--s;
  800e96:	ff 4d f8             	decl   -0x8(%ebp)
  800e99:	ff 4d fc             	decl   -0x4(%ebp)
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	8a 10                	mov    (%eax),%dl
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 e3                	jne    800e96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb3:	eb 23                	jmp    800ed8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8d 50 01             	lea    0x1(%eax),%edx
  800ebb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 dd                	jne    800eb5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eef:	eb 2a                	jmp    800f1b <memcmp+0x3e>
		if (*s1 != *s2)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	38 c2                	cmp    %al,%dl
  800efd:	74 16                	je     800f15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
  800f13:	eb 18                	jmp    800f2d <memcmp+0x50>
		s1++, s2++;
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 c9                	jne    800ef1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f40:	eb 15                	jmp    800f57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 d0             	movzbl %al,%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	0f b6 c0             	movzbl %al,%eax
  800f50:	39 c2                	cmp    %eax,%edx
  800f52:	74 0d                	je     800f61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5d:	72 e3                	jb     800f42 <memfind+0x13>
  800f5f:	eb 01                	jmp    800f62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f61:	90                   	nop
	return (void *) s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7b:	eb 03                	jmp    800f80 <strtol+0x19>
		s++;
  800f7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 20                	cmp    $0x20,%al
  800f87:	74 f4                	je     800f7d <strtol+0x16>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 09                	cmp    $0x9,%al
  800f90:	74 eb                	je     800f7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 2b                	cmp    $0x2b,%al
  800f99:	75 05                	jne    800fa0 <strtol+0x39>
		s++;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	eb 13                	jmp    800fb3 <strtol+0x4c>
	else if (*s == '-')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 2d                	cmp    $0x2d,%al
  800fa7:	75 0a                	jne    800fb3 <strtol+0x4c>
		s++, neg = 1;
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 06                	je     800fbf <strtol+0x58>
  800fb9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fbd:	75 20                	jne    800fdf <strtol+0x78>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 30                	cmp    $0x30,%al
  800fc6:	75 17                	jne    800fdf <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	40                   	inc    %eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 78                	cmp    $0x78,%al
  800fd0:	75 0d                	jne    800fdf <strtol+0x78>
		s += 2, base = 16;
  800fd2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fdd:	eb 28                	jmp    801007 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 15                	jne    800ffa <strtol+0x93>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 30                	cmp    $0x30,%al
  800fec:	75 0c                	jne    800ffa <strtol+0x93>
		s++, base = 8;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff8:	eb 0d                	jmp    801007 <strtol+0xa0>
	else if (base == 0)
  800ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffe:	75 07                	jne    801007 <strtol+0xa0>
		base = 10;
  801000:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 2f                	cmp    $0x2f,%al
  80100e:	7e 19                	jle    801029 <strtol+0xc2>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 39                	cmp    $0x39,%al
  801017:	7f 10                	jg     801029 <strtol+0xc2>
			dig = *s - '0';
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f be c0             	movsbl %al,%eax
  801021:	83 e8 30             	sub    $0x30,%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801027:	eb 42                	jmp    80106b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 60                	cmp    $0x60,%al
  801030:	7e 19                	jle    80104b <strtol+0xe4>
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 7a                	cmp    $0x7a,%al
  801039:	7f 10                	jg     80104b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f be c0             	movsbl %al,%eax
  801043:	83 e8 57             	sub    $0x57,%eax
  801046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801049:	eb 20                	jmp    80106b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 40                	cmp    $0x40,%al
  801052:	7e 39                	jle    80108d <strtol+0x126>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 5a                	cmp    $0x5a,%al
  80105b:	7f 30                	jg     80108d <strtol+0x126>
			dig = *s - 'A' + 10;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 37             	sub    $0x37,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801071:	7d 19                	jge    80108c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801087:	e9 7b ff ff ff       	jmp    801007 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80108c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 08                	je     80109b <strtol+0x134>
		*endptr = (char *) s;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109f:	74 07                	je     8010a8 <strtol+0x141>
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	f7 d8                	neg    %eax
  8010a6:	eb 03                	jmp    8010ab <strtol+0x144>
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <ltostr>:

void
ltostr(long value, char *str)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c5:	79 13                	jns    8010da <ltostr+0x2d>
	{
		neg = 1;
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e2:	99                   	cltd   
  8010e3:	f7 f9                	idiv   %ecx
  8010e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010fb:	83 c2 30             	add    $0x30,%edx
  8010fe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801108:	f7 e9                	imul   %ecx
  80110a:	c1 fa 02             	sar    $0x2,%edx
  80110d:	89 c8                	mov    %ecx,%eax
  80110f:	c1 f8 1f             	sar    $0x1f,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801121:	f7 e9                	imul   %ecx
  801123:	c1 fa 02             	sar    $0x2,%edx
  801126:	89 c8                	mov    %ecx,%eax
  801128:	c1 f8 1f             	sar    $0x1f,%eax
  80112b:	29 c2                	sub    %eax,%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	c1 e0 02             	shl    $0x2,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	01 c0                	add    %eax,%eax
  801136:	29 c1                	sub    %eax,%ecx
  801138:	89 ca                	mov    %ecx,%edx
  80113a:	85 d2                	test   %edx,%edx
  80113c:	75 9c                	jne    8010da <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 3d                	je     80118f <ltostr+0xe2>
		start = 1 ;
  801152:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801159:	eb 34                	jmp    80118f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80115b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8a 45 eb             	mov    -0x15(%ebp),%al
  801187:	88 02                	mov    %al,(%edx)
		start++ ;
  801189:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c c4                	jl     80115b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801197:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 54 fa ff ff       	call   800c07 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	e8 46 fa ff ff       	call   800c07 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d5:	eb 17                	jmp    8011ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	01 c8                	add    %ecx,%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f4:	7c e1                	jl     8011d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801204:	eb 1f                	jmp    801225 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801222:	ff 45 f8             	incl   -0x8(%ebp)
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122b:	7c d9                	jl     801206 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c6 00 00             	movb   $0x0,(%eax)
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	eb 0c                	jmp    80126c <strsplit+0x31>
			*string++ = 0;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 08             	mov    %edx,0x8(%ebp)
  801269:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 18                	je     80128d <strsplit+0x52>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 13 fb ff ff       	call   800d99 <strchr>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 d3                	jne    801260 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 5a                	je     8012f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 f8 0f             	cmp    $0xf,%eax
  80129e:	75 07                	jne    8012a7 <strsplit+0x6c>
		{
			return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	eb 66                	jmp    80130d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 c2                	add    %eax,%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c5:	eb 03                	jmp    8012ca <strsplit+0x8f>
			string++;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	84 c0                	test   %al,%al
  8012d1:	74 8b                	je     80125e <strsplit+0x23>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 b5 fa ff ff       	call   800d99 <strchr>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 dc                	je     8012c7 <strsplit+0x8c>
			string++;
	}
  8012eb:	e9 6e ff ff ff       	jmp    80125e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801308:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801315:	a1 04 40 80 00       	mov    0x804004,%eax
  80131a:	85 c0                	test   %eax,%eax
  80131c:	74 1f                	je     80133d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131e:	e8 1d 00 00 00       	call   801340 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 30 3b 80 00       	push   $0x803b30
  80132b:	e8 55 f2 ff ff       	call   800585 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801333:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80133a:	00 00 00 
	}
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801346:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134d:	00 00 00 
  801350:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801357:	00 00 00 
  80135a:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801361:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801364:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80136b:	00 00 00 
  80136e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801375:	00 00 00 
  801378:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80137f:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801382:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801389:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80138c:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801393:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80139a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a7:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8013ac:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8013b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013bb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	6a 06                	push   $0x6
  8013c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c8:	50                   	push   %eax
  8013c9:	e8 ee 05 00 00       	call   8019bc <sys_allocate_chunk>
  8013ce:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013d1:	a1 20 41 80 00       	mov    0x804120,%eax
  8013d6:	83 ec 0c             	sub    $0xc,%esp
  8013d9:	50                   	push   %eax
  8013da:	e8 63 0c 00 00       	call   802042 <initialize_MemBlocksList>
  8013df:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8013e2:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8013ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ed:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8013f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8013fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801400:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801405:	89 c2                	mov    %eax,%edx
  801407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140a:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  80140d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801410:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801417:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80141e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801421:	8b 50 08             	mov    0x8(%eax),%edx
  801424:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801427:	01 d0                	add    %edx,%eax
  801429:	48                   	dec    %eax
  80142a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80142d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801430:	ba 00 00 00 00       	mov    $0x0,%edx
  801435:	f7 75 e0             	divl   -0x20(%ebp)
  801438:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143b:	29 d0                	sub    %edx,%eax
  80143d:	89 c2                	mov    %eax,%edx
  80143f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801442:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801445:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801449:	75 14                	jne    80145f <initialize_dyn_block_system+0x11f>
  80144b:	83 ec 04             	sub    $0x4,%esp
  80144e:	68 55 3b 80 00       	push   $0x803b55
  801453:	6a 34                	push   $0x34
  801455:	68 73 3b 80 00       	push   $0x803b73
  80145a:	e8 72 ee ff ff       	call   8002d1 <_panic>
  80145f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	85 c0                	test   %eax,%eax
  801466:	74 10                	je     801478 <initialize_dyn_block_system+0x138>
  801468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801470:	8b 52 04             	mov    0x4(%edx),%edx
  801473:	89 50 04             	mov    %edx,0x4(%eax)
  801476:	eb 0b                	jmp    801483 <initialize_dyn_block_system+0x143>
  801478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80147b:	8b 40 04             	mov    0x4(%eax),%eax
  80147e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801486:	8b 40 04             	mov    0x4(%eax),%eax
  801489:	85 c0                	test   %eax,%eax
  80148b:	74 0f                	je     80149c <initialize_dyn_block_system+0x15c>
  80148d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801490:	8b 40 04             	mov    0x4(%eax),%eax
  801493:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801496:	8b 12                	mov    (%edx),%edx
  801498:	89 10                	mov    %edx,(%eax)
  80149a:	eb 0a                	jmp    8014a6 <initialize_dyn_block_system+0x166>
  80149c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80149f:	8b 00                	mov    (%eax),%eax
  8014a1:	a3 48 41 80 00       	mov    %eax,0x804148
  8014a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014b9:	a1 54 41 80 00       	mov    0x804154,%eax
  8014be:	48                   	dec    %eax
  8014bf:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ca:	e8 c4 13 00 00       	call   802893 <insert_sorted_with_merge_freeList>
  8014cf:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014db:	e8 2f fe ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  8014e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e4:	75 07                	jne    8014ed <malloc+0x18>
  8014e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014eb:	eb 71                	jmp    80155e <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8014ed:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8014f4:	76 07                	jbe    8014fd <malloc+0x28>
	return NULL;
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 61                	jmp    80155e <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014fd:	e8 88 08 00 00       	call   801d8a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801502:	85 c0                	test   %eax,%eax
  801504:	74 53                	je     801559 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801506:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80150d:	8b 55 08             	mov    0x8(%ebp),%edx
  801510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801513:	01 d0                	add    %edx,%eax
  801515:	48                   	dec    %eax
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151c:	ba 00 00 00 00       	mov    $0x0,%edx
  801521:	f7 75 f4             	divl   -0xc(%ebp)
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801527:	29 d0                	sub    %edx,%eax
  801529:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	ff 75 ec             	pushl  -0x14(%ebp)
  801532:	e8 d2 0d 00 00       	call   802309 <alloc_block_FF>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80153d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801541:	74 16                	je     801559 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801543:	83 ec 0c             	sub    $0xc,%esp
  801546:	ff 75 e8             	pushl  -0x18(%ebp)
  801549:	e8 0c 0c 00 00       	call   80215a <insert_sorted_allocList>
  80154e:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801551:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801554:	8b 40 08             	mov    0x8(%eax),%eax
  801557:	eb 05                	jmp    80155e <malloc+0x89>
    }

			}


	return NULL;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80156c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801574:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801577:	83 ec 08             	sub    $0x8,%esp
  80157a:	ff 75 f0             	pushl  -0x10(%ebp)
  80157d:	68 40 40 80 00       	push   $0x804040
  801582:	e8 a0 0b 00 00       	call   802127 <find_block>
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80158d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801590:	8b 50 0c             	mov    0xc(%eax),%edx
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	52                   	push   %edx
  80159a:	50                   	push   %eax
  80159b:	e8 e4 03 00 00       	call   801984 <sys_free_user_mem>
  8015a0:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8015a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015a7:	75 17                	jne    8015c0 <free+0x60>
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	68 55 3b 80 00       	push   $0x803b55
  8015b1:	68 84 00 00 00       	push   $0x84
  8015b6:	68 73 3b 80 00       	push   $0x803b73
  8015bb:	e8 11 ed ff ff       	call   8002d1 <_panic>
  8015c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c3:	8b 00                	mov    (%eax),%eax
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 10                	je     8015d9 <free+0x79>
  8015c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cc:	8b 00                	mov    (%eax),%eax
  8015ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015d1:	8b 52 04             	mov    0x4(%edx),%edx
  8015d4:	89 50 04             	mov    %edx,0x4(%eax)
  8015d7:	eb 0b                	jmp    8015e4 <free+0x84>
  8015d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015dc:	8b 40 04             	mov    0x4(%eax),%eax
  8015df:	a3 44 40 80 00       	mov    %eax,0x804044
  8015e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e7:	8b 40 04             	mov    0x4(%eax),%eax
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	74 0f                	je     8015fd <free+0x9d>
  8015ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f1:	8b 40 04             	mov    0x4(%eax),%eax
  8015f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015f7:	8b 12                	mov    (%edx),%edx
  8015f9:	89 10                	mov    %edx,(%eax)
  8015fb:	eb 0a                	jmp    801607 <free+0xa7>
  8015fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	a3 40 40 80 00       	mov    %eax,0x804040
  801607:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801613:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80161a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80161f:	48                   	dec    %eax
  801620:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801625:	83 ec 0c             	sub    $0xc,%esp
  801628:	ff 75 ec             	pushl  -0x14(%ebp)
  80162b:	e8 63 12 00 00       	call   802893 <insert_sorted_with_merge_freeList>
  801630:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801633:	90                   	nop
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 38             	sub    $0x38,%esp
  80163c:	8b 45 10             	mov    0x10(%ebp),%eax
  80163f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801642:	e8 c8 fc ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801647:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80164b:	75 0a                	jne    801657 <smalloc+0x21>
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
  801652:	e9 a0 00 00 00       	jmp    8016f7 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801657:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80165e:	76 0a                	jbe    80166a <smalloc+0x34>
		return NULL;
  801660:	b8 00 00 00 00       	mov    $0x0,%eax
  801665:	e9 8d 00 00 00       	jmp    8016f7 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80166a:	e8 1b 07 00 00       	call   801d8a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80166f:	85 c0                	test   %eax,%eax
  801671:	74 7f                	je     8016f2 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801673:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80167a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	48                   	dec    %eax
  801683:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	ba 00 00 00 00       	mov    $0x0,%edx
  80168e:	f7 75 f4             	divl   -0xc(%ebp)
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	29 d0                	sub    %edx,%eax
  801696:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801699:	83 ec 0c             	sub    $0xc,%esp
  80169c:	ff 75 ec             	pushl  -0x14(%ebp)
  80169f:	e8 65 0c 00 00       	call   802309 <alloc_block_FF>
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8016aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016ae:	74 42                	je     8016f2 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b6:	e8 9f 0a 00 00       	call   80215a <insert_sorted_allocList>
  8016bb:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8016be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016c1:	8b 40 08             	mov    0x8(%eax),%eax
  8016c4:	89 c2                	mov    %eax,%edx
  8016c6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016ca:	52                   	push   %edx
  8016cb:	50                   	push   %eax
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	e8 38 04 00 00       	call   801b0f <sys_createSharedObject>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8016dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016e1:	79 07                	jns    8016ea <smalloc+0xb4>
	    		  return NULL;
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	eb 0d                	jmp    8016f7 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8016ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ed:	8b 40 08             	mov    0x8(%eax),%eax
  8016f0:	eb 05                	jmp    8016f7 <smalloc+0xc1>


				}


		return NULL;
  8016f2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ff:	e8 0b fc ff ff       	call   80130f <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801704:	e8 81 06 00 00       	call   801d8a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801709:	85 c0                	test   %eax,%eax
  80170b:	0f 84 9f 00 00 00    	je     8017b0 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	ff 75 0c             	pushl  0xc(%ebp)
  801717:	ff 75 08             	pushl  0x8(%ebp)
  80171a:	e8 1a 04 00 00       	call   801b39 <sys_getSizeOfSharedObject>
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801725:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801729:	79 0a                	jns    801735 <sget+0x3c>
		return NULL;
  80172b:	b8 00 00 00 00       	mov    $0x0,%eax
  801730:	e9 80 00 00 00       	jmp    8017b5 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801735:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80173c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	48                   	dec    %eax
  801745:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174b:	ba 00 00 00 00       	mov    $0x0,%edx
  801750:	f7 75 f0             	divl   -0x10(%ebp)
  801753:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801756:	29 d0                	sub    %edx,%eax
  801758:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80175b:	83 ec 0c             	sub    $0xc,%esp
  80175e:	ff 75 e8             	pushl  -0x18(%ebp)
  801761:	e8 a3 0b 00 00       	call   802309 <alloc_block_FF>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80176c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801770:	74 3e                	je     8017b0 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801772:	83 ec 0c             	sub    $0xc,%esp
  801775:	ff 75 e4             	pushl  -0x1c(%ebp)
  801778:	e8 dd 09 00 00       	call   80215a <insert_sorted_allocList>
  80177d:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801783:	8b 40 08             	mov    0x8(%eax),%eax
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	50                   	push   %eax
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	ff 75 08             	pushl  0x8(%ebp)
  801790:	e8 c1 03 00 00       	call   801b56 <sys_getSharedObject>
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80179b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80179f:	79 07                	jns    8017a8 <sget+0xaf>
	    		  return NULL;
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a6:	eb 0d                	jmp    8017b5 <sget+0xbc>
	  	return(void*) returned_block->sva;
  8017a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ab:	8b 40 08             	mov    0x8(%eax),%eax
  8017ae:	eb 05                	jmp    8017b5 <sget+0xbc>
	      }
	}
	   return NULL;
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017bd:	e8 4d fb ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	68 80 3b 80 00       	push   $0x803b80
  8017ca:	68 12 01 00 00       	push   $0x112
  8017cf:	68 73 3b 80 00       	push   $0x803b73
  8017d4:	e8 f8 ea ff ff       	call   8002d1 <_panic>

008017d9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	68 a8 3b 80 00       	push   $0x803ba8
  8017e7:	68 26 01 00 00       	push   $0x126
  8017ec:	68 73 3b 80 00       	push   $0x803b73
  8017f1:	e8 db ea ff ff       	call   8002d1 <_panic>

008017f6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	68 cc 3b 80 00       	push   $0x803bcc
  801804:	68 31 01 00 00       	push   $0x131
  801809:	68 73 3b 80 00       	push   $0x803b73
  80180e:	e8 be ea ff ff       	call   8002d1 <_panic>

00801813 <shrink>:

}
void shrink(uint32 newSize)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	68 cc 3b 80 00       	push   $0x803bcc
  801821:	68 36 01 00 00       	push   $0x136
  801826:	68 73 3b 80 00       	push   $0x803b73
  80182b:	e8 a1 ea ff ff       	call   8002d1 <_panic>

00801830 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	68 cc 3b 80 00       	push   $0x803bcc
  80183e:	68 3b 01 00 00       	push   $0x13b
  801843:	68 73 3b 80 00       	push   $0x803b73
  801848:	e8 84 ea ff ff       	call   8002d1 <_panic>

0080184d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	57                   	push   %edi
  801851:	56                   	push   %esi
  801852:	53                   	push   %ebx
  801853:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801862:	8b 7d 18             	mov    0x18(%ebp),%edi
  801865:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801868:	cd 30                	int    $0x30
  80186a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5f                   	pop    %edi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    

00801878 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	8b 45 10             	mov    0x10(%ebp),%eax
  801881:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801884:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	52                   	push   %edx
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	50                   	push   %eax
  801894:	6a 00                	push   $0x0
  801896:	e8 b2 ff ff ff       	call   80184d <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	90                   	nop
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 01                	push   $0x1
  8018b0:	e8 98 ff ff ff       	call   80184d <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	52                   	push   %edx
  8018ca:	50                   	push   %eax
  8018cb:	6a 05                	push   $0x5
  8018cd:	e8 7b ff ff ff       	call   80184d <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8018df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
  8018ed:	51                   	push   %ecx
  8018ee:	52                   	push   %edx
  8018ef:	50                   	push   %eax
  8018f0:	6a 06                	push   $0x6
  8018f2:	e8 56 ff ff ff       	call   80184d <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    

00801901 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	52                   	push   %edx
  801911:	50                   	push   %eax
  801912:	6a 07                	push   $0x7
  801914:	e8 34 ff ff ff       	call   80184d <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	6a 08                	push   $0x8
  80192f:	e8 19 ff ff ff       	call   80184d <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 09                	push   $0x9
  801948:	e8 00 ff ff ff       	call   80184d <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0a                	push   $0xa
  801961:	e8 e7 fe ff ff       	call   80184d <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 0b                	push   $0xb
  80197a:	e8 ce fe ff ff       	call   80184d <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	6a 0f                	push   $0xf
  801995:	e8 b3 fe ff ff       	call   80184d <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
	return;
  80199d:	90                   	nop
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ac:	ff 75 08             	pushl  0x8(%ebp)
  8019af:	6a 10                	push   $0x10
  8019b1:	e8 97 fe ff ff       	call   80184d <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b9:	90                   	nop
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 11                	push   $0x11
  8019ce:	e8 7a fe ff ff       	call   80184d <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 0c                	push   $0xc
  8019e8:	e8 60 fe ff ff       	call   80184d <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	ff 75 08             	pushl  0x8(%ebp)
  801a00:	6a 0d                	push   $0xd
  801a02:	e8 46 fe ff ff       	call   80184d <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 0e                	push   $0xe
  801a1b:	e8 2d fe ff ff       	call   80184d <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 13                	push   $0x13
  801a35:	e8 13 fe ff ff       	call   80184d <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 14                	push   $0x14
  801a4f:	e8 f9 fd ff ff       	call   80184d <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	90                   	nop
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_cputc>:


void
sys_cputc(const char c)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	50                   	push   %eax
  801a73:	6a 15                	push   $0x15
  801a75:	e8 d3 fd ff ff       	call   80184d <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	90                   	nop
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 16                	push   $0x16
  801a8f:	e8 b9 fd ff ff       	call   80184d <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	90                   	nop
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	6a 17                	push   $0x17
  801aac:	e8 9c fd ff ff       	call   80184d <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	52                   	push   %edx
  801ac6:	50                   	push   %eax
  801ac7:	6a 1a                	push   $0x1a
  801ac9:	e8 7f fd ff ff       	call   80184d <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 18                	push   $0x18
  801ae6:	e8 62 fd ff ff       	call   80184d <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	52                   	push   %edx
  801b01:	50                   	push   %eax
  801b02:	6a 19                	push   $0x19
  801b04:	e8 44 fd ff ff       	call   80184d <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	90                   	nop
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b1b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	51                   	push   %ecx
  801b28:	52                   	push   %edx
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	50                   	push   %eax
  801b2d:	6a 1b                	push   $0x1b
  801b2f:	e8 19 fd ff ff       	call   80184d <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 1c                	push   $0x1c
  801b4c:	e8 fc fc ff ff       	call   80184d <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	51                   	push   %ecx
  801b67:	52                   	push   %edx
  801b68:	50                   	push   %eax
  801b69:	6a 1d                	push   $0x1d
  801b6b:	e8 dd fc ff ff       	call   80184d <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	52                   	push   %edx
  801b85:	50                   	push   %eax
  801b86:	6a 1e                	push   $0x1e
  801b88:	e8 c0 fc ff ff       	call   80184d <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 1f                	push   $0x1f
  801ba1:	e8 a7 fc ff ff       	call   80184d <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	ff 75 14             	pushl  0x14(%ebp)
  801bb6:	ff 75 10             	pushl  0x10(%ebp)
  801bb9:	ff 75 0c             	pushl  0xc(%ebp)
  801bbc:	50                   	push   %eax
  801bbd:	6a 20                	push   $0x20
  801bbf:	e8 89 fc ff ff       	call   80184d <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	50                   	push   %eax
  801bd8:	6a 21                	push   $0x21
  801bda:	e8 6e fc ff ff       	call   80184d <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	90                   	nop
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	50                   	push   %eax
  801bf4:	6a 22                	push   $0x22
  801bf6:	e8 52 fc ff ff       	call   80184d <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 02                	push   $0x2
  801c0f:	e8 39 fc ff ff       	call   80184d <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 03                	push   $0x3
  801c28:	e8 20 fc ff ff       	call   80184d <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 04                	push   $0x4
  801c41:	e8 07 fc ff ff       	call   80184d <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_exit_env>:


void sys_exit_env(void)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 23                	push   $0x23
  801c5a:	e8 ee fb ff ff       	call   80184d <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	90                   	nop
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6e:	8d 50 04             	lea    0x4(%eax),%edx
  801c71:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	52                   	push   %edx
  801c7b:	50                   	push   %eax
  801c7c:	6a 24                	push   $0x24
  801c7e:	e8 ca fb ff ff       	call   80184d <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
	return result;
  801c86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c8f:	89 01                	mov    %eax,(%ecx)
  801c91:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	c9                   	leave  
  801c98:	c2 04 00             	ret    $0x4

00801c9b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 10             	pushl  0x10(%ebp)
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	6a 12                	push   $0x12
  801cad:	e8 9b fb ff ff       	call   80184d <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 25                	push   $0x25
  801cc7:	e8 81 fb ff ff       	call   80184d <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cdd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	50                   	push   %eax
  801cea:	6a 26                	push   $0x26
  801cec:	e8 5c fb ff ff       	call   80184d <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <rsttst>:
void rsttst()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 28                	push   $0x28
  801d06:	e8 42 fb ff ff       	call   80184d <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0e:	90                   	nop
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d1d:	8b 55 18             	mov    0x18(%ebp),%edx
  801d20:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	ff 75 10             	pushl  0x10(%ebp)
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	6a 27                	push   $0x27
  801d31:	e8 17 fb ff ff       	call   80184d <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return ;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <chktst>:
void chktst(uint32 n)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	ff 75 08             	pushl  0x8(%ebp)
  801d4a:	6a 29                	push   $0x29
  801d4c:	e8 fc fa ff ff       	call   80184d <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return ;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <inctst>:

void inctst()
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 2a                	push   $0x2a
  801d66:	e8 e2 fa ff ff       	call   80184d <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6e:	90                   	nop
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <gettst>:
uint32 gettst()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 2b                	push   $0x2b
  801d80:	e8 c8 fa ff ff       	call   80184d <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 2c                	push   $0x2c
  801d9c:	e8 ac fa ff ff       	call   80184d <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
  801da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dab:	75 07                	jne    801db4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dad:	b8 01 00 00 00       	mov    $0x1,%eax
  801db2:	eb 05                	jmp    801db9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 2c                	push   $0x2c
  801dcd:	e8 7b fa ff ff       	call   80184d <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
  801dd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dd8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ddc:	75 07                	jne    801de5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dde:	b8 01 00 00 00       	mov    $0x1,%eax
  801de3:	eb 05                	jmp    801dea <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 2c                	push   $0x2c
  801dfe:	e8 4a fa ff ff       	call   80184d <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
  801e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e09:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e0d:	75 07                	jne    801e16 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e14:	eb 05                	jmp    801e1b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 2c                	push   $0x2c
  801e2f:	e8 19 fa ff ff       	call   80184d <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
  801e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e3a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e3e:	75 07                	jne    801e47 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e40:	b8 01 00 00 00       	mov    $0x1,%eax
  801e45:	eb 05                	jmp    801e4c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	6a 2d                	push   $0x2d
  801e5e:	e8 ea f9 ff ff       	call   80184d <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
	return ;
  801e66:	90                   	nop
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e6d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	53                   	push   %ebx
  801e7c:	51                   	push   %ecx
  801e7d:	52                   	push   %edx
  801e7e:	50                   	push   %eax
  801e7f:	6a 2e                	push   $0x2e
  801e81:	e8 c7 f9 ff ff       	call   80184d <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	52                   	push   %edx
  801e9e:	50                   	push   %eax
  801e9f:	6a 2f                	push   $0x2f
  801ea1:	e8 a7 f9 ff ff       	call   80184d <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eb1:	83 ec 0c             	sub    $0xc,%esp
  801eb4:	68 dc 3b 80 00       	push   $0x803bdc
  801eb9:	e8 c7 e6 ff ff       	call   800585 <cprintf>
  801ebe:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	68 08 3c 80 00       	push   $0x803c08
  801ed0:	e8 b0 e6 ff ff       	call   800585 <cprintf>
  801ed5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ed8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801edc:	a1 38 41 80 00       	mov    0x804138,%eax
  801ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee4:	eb 56                	jmp    801f3c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eea:	74 1c                	je     801f08 <print_mem_block_lists+0x5d>
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 50 08             	mov    0x8(%eax),%edx
  801ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef5:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efb:	8b 40 0c             	mov    0xc(%eax),%eax
  801efe:	01 c8                	add    %ecx,%eax
  801f00:	39 c2                	cmp    %eax,%edx
  801f02:	73 04                	jae    801f08 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f04:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	8b 50 08             	mov    0x8(%eax),%edx
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	8b 40 0c             	mov    0xc(%eax),%eax
  801f14:	01 c2                	add    %eax,%edx
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	8b 40 08             	mov    0x8(%eax),%eax
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	52                   	push   %edx
  801f20:	50                   	push   %eax
  801f21:	68 1d 3c 80 00       	push   $0x803c1d
  801f26:	e8 5a e6 ff ff       	call   800585 <cprintf>
  801f2b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f34:	a1 40 41 80 00       	mov    0x804140,%eax
  801f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f40:	74 07                	je     801f49 <print_mem_block_lists+0x9e>
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 00                	mov    (%eax),%eax
  801f47:	eb 05                	jmp    801f4e <print_mem_block_lists+0xa3>
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	a3 40 41 80 00       	mov    %eax,0x804140
  801f53:	a1 40 41 80 00       	mov    0x804140,%eax
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	75 8a                	jne    801ee6 <print_mem_block_lists+0x3b>
  801f5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f60:	75 84                	jne    801ee6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f62:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f66:	75 10                	jne    801f78 <print_mem_block_lists+0xcd>
  801f68:	83 ec 0c             	sub    $0xc,%esp
  801f6b:	68 2c 3c 80 00       	push   $0x803c2c
  801f70:	e8 10 e6 ff ff       	call   800585 <cprintf>
  801f75:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	68 50 3c 80 00       	push   $0x803c50
  801f87:	e8 f9 e5 ff ff       	call   800585 <cprintf>
  801f8c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f8f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f93:	a1 40 40 80 00       	mov    0x804040,%eax
  801f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9b:	eb 56                	jmp    801ff3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa1:	74 1c                	je     801fbf <print_mem_block_lists+0x114>
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 50 08             	mov    0x8(%eax),%edx
  801fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fac:	8b 48 08             	mov    0x8(%eax),%ecx
  801faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb5:	01 c8                	add    %ecx,%eax
  801fb7:	39 c2                	cmp    %eax,%edx
  801fb9:	73 04                	jae    801fbf <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fbb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 50 08             	mov    0x8(%eax),%edx
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcb:	01 c2                	add    %eax,%edx
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 40 08             	mov    0x8(%eax),%eax
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	68 1d 3c 80 00       	push   $0x803c1d
  801fdd:	e8 a3 e5 ff ff       	call   800585 <cprintf>
  801fe2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801feb:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff7:	74 07                	je     802000 <print_mem_block_lists+0x155>
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 00                	mov    (%eax),%eax
  801ffe:	eb 05                	jmp    802005 <print_mem_block_lists+0x15a>
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	a3 48 40 80 00       	mov    %eax,0x804048
  80200a:	a1 48 40 80 00       	mov    0x804048,%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	75 8a                	jne    801f9d <print_mem_block_lists+0xf2>
  802013:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802017:	75 84                	jne    801f9d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802019:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80201d:	75 10                	jne    80202f <print_mem_block_lists+0x184>
  80201f:	83 ec 0c             	sub    $0xc,%esp
  802022:	68 68 3c 80 00       	push   $0x803c68
  802027:	e8 59 e5 ff ff       	call   800585 <cprintf>
  80202c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	68 dc 3b 80 00       	push   $0x803bdc
  802037:	e8 49 e5 ff ff       	call   800585 <cprintf>
  80203c:	83 c4 10             	add    $0x10,%esp

}
  80203f:	90                   	nop
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802048:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80204f:	00 00 00 
  802052:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802059:	00 00 00 
  80205c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802063:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802066:	a1 50 40 80 00       	mov    0x804050,%eax
  80206b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80206e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802075:	e9 9e 00 00 00       	jmp    802118 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80207a:	a1 50 40 80 00       	mov    0x804050,%eax
  80207f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802082:	c1 e2 04             	shl    $0x4,%edx
  802085:	01 d0                	add    %edx,%eax
  802087:	85 c0                	test   %eax,%eax
  802089:	75 14                	jne    80209f <initialize_MemBlocksList+0x5d>
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	68 90 3c 80 00       	push   $0x803c90
  802093:	6a 48                	push   $0x48
  802095:	68 b3 3c 80 00       	push   $0x803cb3
  80209a:	e8 32 e2 ff ff       	call   8002d1 <_panic>
  80209f:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a7:	c1 e2 04             	shl    $0x4,%edx
  8020aa:	01 d0                	add    %edx,%eax
  8020ac:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020b2:	89 10                	mov    %edx,(%eax)
  8020b4:	8b 00                	mov    (%eax),%eax
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	74 18                	je     8020d2 <initialize_MemBlocksList+0x90>
  8020ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8020bf:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c8:	c1 e1 04             	shl    $0x4,%ecx
  8020cb:	01 ca                	add    %ecx,%edx
  8020cd:	89 50 04             	mov    %edx,0x4(%eax)
  8020d0:	eb 12                	jmp    8020e4 <initialize_MemBlocksList+0xa2>
  8020d2:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020da:	c1 e2 04             	shl    $0x4,%edx
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020e4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ec:	c1 e2 04             	shl    $0x4,%edx
  8020ef:	01 d0                	add    %edx,%eax
  8020f1:	a3 48 41 80 00       	mov    %eax,0x804148
  8020f6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fe:	c1 e2 04             	shl    $0x4,%edx
  802101:	01 d0                	add    %edx,%eax
  802103:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80210a:	a1 54 41 80 00       	mov    0x804154,%eax
  80210f:	40                   	inc    %eax
  802110:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802115:	ff 45 f4             	incl   -0xc(%ebp)
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211e:	0f 82 56 ff ff ff    	jb     80207a <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802124:	90                   	nop
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	8b 00                	mov    (%eax),%eax
  802132:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802135:	eb 18                	jmp    80214f <find_block+0x28>
		{
			if(tmp->sva==va)
  802137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213a:	8b 40 08             	mov    0x8(%eax),%eax
  80213d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802140:	75 05                	jne    802147 <find_block+0x20>
			{
				return tmp;
  802142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802145:	eb 11                	jmp    802158 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80214a:	8b 00                	mov    (%eax),%eax
  80214c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80214f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802153:	75 e2                	jne    802137 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802155:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802160:	a1 40 40 80 00       	mov    0x804040,%eax
  802165:	85 c0                	test   %eax,%eax
  802167:	0f 85 83 00 00 00    	jne    8021f0 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80216d:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802174:	00 00 00 
  802177:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80217e:	00 00 00 
  802181:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802188:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80218b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218f:	75 14                	jne    8021a5 <insert_sorted_allocList+0x4b>
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	68 90 3c 80 00       	push   $0x803c90
  802199:	6a 7f                	push   $0x7f
  80219b:	68 b3 3c 80 00       	push   $0x803cb3
  8021a0:	e8 2c e1 ff ff       	call   8002d1 <_panic>
  8021a5:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	89 10                	mov    %edx,(%eax)
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	8b 00                	mov    (%eax),%eax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	74 0d                	je     8021c6 <insert_sorted_allocList+0x6c>
  8021b9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021be:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c1:	89 50 04             	mov    %edx,0x4(%eax)
  8021c4:	eb 08                	jmp    8021ce <insert_sorted_allocList+0x74>
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	a3 40 40 80 00       	mov    %eax,0x804040
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e5:	40                   	inc    %eax
  8021e6:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021eb:	e9 16 01 00 00       	jmp    802306 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 50 08             	mov    0x8(%eax),%edx
  8021f6:	a1 44 40 80 00       	mov    0x804044,%eax
  8021fb:	8b 40 08             	mov    0x8(%eax),%eax
  8021fe:	39 c2                	cmp    %eax,%edx
  802200:	76 68                	jbe    80226a <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802206:	75 17                	jne    80221f <insert_sorted_allocList+0xc5>
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 cc 3c 80 00       	push   $0x803ccc
  802210:	68 85 00 00 00       	push   $0x85
  802215:	68 b3 3c 80 00       	push   $0x803cb3
  80221a:	e8 b2 e0 ff ff       	call   8002d1 <_panic>
  80221f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	89 50 04             	mov    %edx,0x4(%eax)
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8b 40 04             	mov    0x4(%eax),%eax
  802231:	85 c0                	test   %eax,%eax
  802233:	74 0c                	je     802241 <insert_sorted_allocList+0xe7>
  802235:	a1 44 40 80 00       	mov    0x804044,%eax
  80223a:	8b 55 08             	mov    0x8(%ebp),%edx
  80223d:	89 10                	mov    %edx,(%eax)
  80223f:	eb 08                	jmp    802249 <insert_sorted_allocList+0xef>
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	a3 40 40 80 00       	mov    %eax,0x804040
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	a3 44 40 80 00       	mov    %eax,0x804044
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225f:	40                   	inc    %eax
  802260:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802265:	e9 9c 00 00 00       	jmp    802306 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80226a:	a1 40 40 80 00       	mov    0x804040,%eax
  80226f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802272:	e9 85 00 00 00       	jmp    8022fc <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	8b 50 08             	mov    0x8(%eax),%edx
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 40 08             	mov    0x8(%eax),%eax
  802283:	39 c2                	cmp    %eax,%edx
  802285:	73 6d                	jae    8022f4 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802287:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228b:	74 06                	je     802293 <insert_sorted_allocList+0x139>
  80228d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802291:	75 17                	jne    8022aa <insert_sorted_allocList+0x150>
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 f0 3c 80 00       	push   $0x803cf0
  80229b:	68 90 00 00 00       	push   $0x90
  8022a0:	68 b3 3c 80 00       	push   $0x803cb3
  8022a5:	e8 27 e0 ff ff       	call   8002d1 <_panic>
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 50 04             	mov    0x4(%eax),%edx
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	89 50 04             	mov    %edx,0x4(%eax)
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bc:	89 10                	mov    %edx,(%eax)
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 40 04             	mov    0x4(%eax),%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	74 0d                	je     8022d5 <insert_sorted_allocList+0x17b>
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d1:	89 10                	mov    %edx,(%eax)
  8022d3:	eb 08                	jmp    8022dd <insert_sorted_allocList+0x183>
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	a3 40 40 80 00       	mov    %eax,0x804040
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e3:	89 50 04             	mov    %edx,0x4(%eax)
  8022e6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022eb:	40                   	inc    %eax
  8022ec:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022f1:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022f2:	eb 12                	jmp    802306 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 00                	mov    (%eax),%eax
  8022f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802300:	0f 85 71 ff ff ff    	jne    802277 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802306:	90                   	nop
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80230f:	a1 38 41 80 00       	mov    0x804138,%eax
  802314:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802317:	e9 76 01 00 00       	jmp    802492 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 0c             	mov    0xc(%eax),%eax
  802322:	3b 45 08             	cmp    0x8(%ebp),%eax
  802325:	0f 85 8a 00 00 00    	jne    8023b5 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80232b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232f:	75 17                	jne    802348 <alloc_block_FF+0x3f>
  802331:	83 ec 04             	sub    $0x4,%esp
  802334:	68 25 3d 80 00       	push   $0x803d25
  802339:	68 a8 00 00 00       	push   $0xa8
  80233e:	68 b3 3c 80 00       	push   $0x803cb3
  802343:	e8 89 df ff ff       	call   8002d1 <_panic>
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 10                	je     802361 <alloc_block_FF+0x58>
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802359:	8b 52 04             	mov    0x4(%edx),%edx
  80235c:	89 50 04             	mov    %edx,0x4(%eax)
  80235f:	eb 0b                	jmp    80236c <alloc_block_FF+0x63>
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 04             	mov    0x4(%eax),%eax
  802367:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	74 0f                	je     802385 <alloc_block_FF+0x7c>
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 40 04             	mov    0x4(%eax),%eax
  80237c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237f:	8b 12                	mov    (%edx),%edx
  802381:	89 10                	mov    %edx,(%eax)
  802383:	eb 0a                	jmp    80238f <alloc_block_FF+0x86>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 00                	mov    (%eax),%eax
  80238a:	a3 38 41 80 00       	mov    %eax,0x804138
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a2:	a1 44 41 80 00       	mov    0x804144,%eax
  8023a7:	48                   	dec    %eax
  8023a8:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	e9 ea 00 00 00       	jmp    80249f <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023be:	0f 86 c6 00 00 00    	jbe    80248a <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8023c4:	a1 48 41 80 00       	mov    0x804148,%eax
  8023c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8023cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d2:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 50 08             	mov    0x8(%eax),%edx
  8023db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023de:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e7:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ea:	89 c2                	mov    %eax,%edx
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 50 08             	mov    0x8(%eax),%edx
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	01 c2                	add    %eax,%edx
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802403:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802407:	75 17                	jne    802420 <alloc_block_FF+0x117>
  802409:	83 ec 04             	sub    $0x4,%esp
  80240c:	68 25 3d 80 00       	push   $0x803d25
  802411:	68 b6 00 00 00       	push   $0xb6
  802416:	68 b3 3c 80 00       	push   $0x803cb3
  80241b:	e8 b1 de ff ff       	call   8002d1 <_panic>
  802420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	74 10                	je     802439 <alloc_block_FF+0x130>
  802429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242c:	8b 00                	mov    (%eax),%eax
  80242e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802431:	8b 52 04             	mov    0x4(%edx),%edx
  802434:	89 50 04             	mov    %edx,0x4(%eax)
  802437:	eb 0b                	jmp    802444 <alloc_block_FF+0x13b>
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	8b 40 04             	mov    0x4(%eax),%eax
  80243f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	8b 40 04             	mov    0x4(%eax),%eax
  80244a:	85 c0                	test   %eax,%eax
  80244c:	74 0f                	je     80245d <alloc_block_FF+0x154>
  80244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802451:	8b 40 04             	mov    0x4(%eax),%eax
  802454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802457:	8b 12                	mov    (%edx),%edx
  802459:	89 10                	mov    %edx,(%eax)
  80245b:	eb 0a                	jmp    802467 <alloc_block_FF+0x15e>
  80245d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802460:	8b 00                	mov    (%eax),%eax
  802462:	a3 48 41 80 00       	mov    %eax,0x804148
  802467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802473:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247a:	a1 54 41 80 00       	mov    0x804154,%eax
  80247f:	48                   	dec    %eax
  802480:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	eb 15                	jmp    80249f <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802496:	0f 85 80 fe ff ff    	jne    80231c <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
  8024a4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024a7:	a1 38 41 80 00       	mov    0x804138,%eax
  8024ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8024af:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8024b6:	e9 c0 00 00 00       	jmp    80257b <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c4:	0f 85 8a 00 00 00    	jne    802554 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8024ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ce:	75 17                	jne    8024e7 <alloc_block_BF+0x46>
  8024d0:	83 ec 04             	sub    $0x4,%esp
  8024d3:	68 25 3d 80 00       	push   $0x803d25
  8024d8:	68 cf 00 00 00       	push   $0xcf
  8024dd:	68 b3 3c 80 00       	push   $0x803cb3
  8024e2:	e8 ea dd ff ff       	call   8002d1 <_panic>
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	74 10                	je     802500 <alloc_block_BF+0x5f>
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 00                	mov    (%eax),%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	8b 52 04             	mov    0x4(%edx),%edx
  8024fb:	89 50 04             	mov    %edx,0x4(%eax)
  8024fe:	eb 0b                	jmp    80250b <alloc_block_BF+0x6a>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 40 04             	mov    0x4(%eax),%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	74 0f                	je     802524 <alloc_block_BF+0x83>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 04             	mov    0x4(%eax),%eax
  80251b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251e:	8b 12                	mov    (%edx),%edx
  802520:	89 10                	mov    %edx,(%eax)
  802522:	eb 0a                	jmp    80252e <alloc_block_BF+0x8d>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	a3 38 41 80 00       	mov    %eax,0x804138
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802541:	a1 44 41 80 00       	mov    0x804144,%eax
  802546:	48                   	dec    %eax
  802547:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	e9 2a 01 00 00       	jmp    80267e <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 40 0c             	mov    0xc(%eax),%eax
  80255a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80255d:	73 14                	jae    802573 <alloc_block_BF+0xd2>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 40 0c             	mov    0xc(%eax),%eax
  802565:	3b 45 08             	cmp    0x8(%ebp),%eax
  802568:	76 09                	jbe    802573 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 0c             	mov    0xc(%eax),%eax
  802570:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	0f 85 36 ff ff ff    	jne    8024bb <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802585:	a1 38 41 80 00       	mov    0x804138,%eax
  80258a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80258d:	e9 dd 00 00 00       	jmp    80266f <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 0c             	mov    0xc(%eax),%eax
  802598:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80259b:	0f 85 c6 00 00 00    	jne    802667 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8025a1:	a1 48 41 80 00       	mov    0x804148,%eax
  8025a6:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 50 08             	mov    0x8(%eax),%edx
  8025af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b2:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8025b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025bb:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	8b 50 08             	mov    0x8(%eax),%edx
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	01 c2                	add    %eax,%edx
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d8:	89 c2                	mov    %eax,%edx
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025e4:	75 17                	jne    8025fd <alloc_block_BF+0x15c>
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	68 25 3d 80 00       	push   $0x803d25
  8025ee:	68 eb 00 00 00       	push   $0xeb
  8025f3:	68 b3 3c 80 00       	push   $0x803cb3
  8025f8:	e8 d4 dc ff ff       	call   8002d1 <_panic>
  8025fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802600:	8b 00                	mov    (%eax),%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	74 10                	je     802616 <alloc_block_BF+0x175>
  802606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80260e:	8b 52 04             	mov    0x4(%edx),%edx
  802611:	89 50 04             	mov    %edx,0x4(%eax)
  802614:	eb 0b                	jmp    802621 <alloc_block_BF+0x180>
  802616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802619:	8b 40 04             	mov    0x4(%eax),%eax
  80261c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802624:	8b 40 04             	mov    0x4(%eax),%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	74 0f                	je     80263a <alloc_block_BF+0x199>
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	8b 40 04             	mov    0x4(%eax),%eax
  802631:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802634:	8b 12                	mov    (%edx),%edx
  802636:	89 10                	mov    %edx,(%eax)
  802638:	eb 0a                	jmp    802644 <alloc_block_BF+0x1a3>
  80263a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	a3 48 41 80 00       	mov    %eax,0x804148
  802644:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802647:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802650:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802657:	a1 54 41 80 00       	mov    0x804154,%eax
  80265c:	48                   	dec    %eax
  80265d:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802665:	eb 17                	jmp    80267e <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80266f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802673:	0f 85 19 ff ff ff    	jne    802592 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802686:	a1 40 40 80 00       	mov    0x804040,%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	75 19                	jne    8026a8 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80268f:	83 ec 0c             	sub    $0xc,%esp
  802692:	ff 75 08             	pushl  0x8(%ebp)
  802695:	e8 6f fc ff ff       	call   802309 <alloc_block_FF>
  80269a:	83 c4 10             	add    $0x10,%esp
  80269d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	e9 e9 01 00 00       	jmp    802891 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8026a8:	a1 44 40 80 00       	mov    0x804044,%eax
  8026ad:	8b 40 08             	mov    0x8(%eax),%eax
  8026b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8026b3:	a1 44 40 80 00       	mov    0x804044,%eax
  8026b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8026bb:	a1 44 40 80 00       	mov    0x804044,%eax
  8026c0:	8b 40 08             	mov    0x8(%eax),%eax
  8026c3:	01 d0                	add    %edx,%eax
  8026c5:	83 ec 08             	sub    $0x8,%esp
  8026c8:	50                   	push   %eax
  8026c9:	68 38 41 80 00       	push   $0x804138
  8026ce:	e8 54 fa ff ff       	call   802127 <find_block>
  8026d3:	83 c4 10             	add    $0x10,%esp
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e2:	0f 85 9b 00 00 00    	jne    802783 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 08             	mov    0x8(%eax),%eax
  8026f4:	01 d0                	add    %edx,%eax
  8026f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8026f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fd:	75 17                	jne    802716 <alloc_block_NF+0x96>
  8026ff:	83 ec 04             	sub    $0x4,%esp
  802702:	68 25 3d 80 00       	push   $0x803d25
  802707:	68 1a 01 00 00       	push   $0x11a
  80270c:	68 b3 3c 80 00       	push   $0x803cb3
  802711:	e8 bb db ff ff       	call   8002d1 <_panic>
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	74 10                	je     80272f <alloc_block_NF+0xaf>
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802727:	8b 52 04             	mov    0x4(%edx),%edx
  80272a:	89 50 04             	mov    %edx,0x4(%eax)
  80272d:	eb 0b                	jmp    80273a <alloc_block_NF+0xba>
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 04             	mov    0x4(%eax),%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	74 0f                	je     802753 <alloc_block_NF+0xd3>
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 40 04             	mov    0x4(%eax),%eax
  80274a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274d:	8b 12                	mov    (%edx),%edx
  80274f:	89 10                	mov    %edx,(%eax)
  802751:	eb 0a                	jmp    80275d <alloc_block_NF+0xdd>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	a3 38 41 80 00       	mov    %eax,0x804138
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802770:	a1 44 41 80 00       	mov    0x804144,%eax
  802775:	48                   	dec    %eax
  802776:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	e9 0e 01 00 00       	jmp    802891 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 0c             	mov    0xc(%eax),%eax
  802789:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278c:	0f 86 cf 00 00 00    	jbe    802861 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802792:	a1 48 41 80 00       	mov    0x804148,%eax
  802797:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80279a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279d:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a0:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 50 08             	mov    0x8(%eax),%edx
  8027a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ac:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 50 08             	mov    0x8(%eax),%edx
  8027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b8:	01 c2                	add    %eax,%edx
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c9:	89 c2                	mov    %eax,%edx
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 08             	mov    0x8(%eax),%eax
  8027d7:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027de:	75 17                	jne    8027f7 <alloc_block_NF+0x177>
  8027e0:	83 ec 04             	sub    $0x4,%esp
  8027e3:	68 25 3d 80 00       	push   $0x803d25
  8027e8:	68 28 01 00 00       	push   $0x128
  8027ed:	68 b3 3c 80 00       	push   $0x803cb3
  8027f2:	e8 da da ff ff       	call   8002d1 <_panic>
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	74 10                	je     802810 <alloc_block_NF+0x190>
  802800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802808:	8b 52 04             	mov    0x4(%edx),%edx
  80280b:	89 50 04             	mov    %edx,0x4(%eax)
  80280e:	eb 0b                	jmp    80281b <alloc_block_NF+0x19b>
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	8b 40 04             	mov    0x4(%eax),%eax
  802816:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	85 c0                	test   %eax,%eax
  802823:	74 0f                	je     802834 <alloc_block_NF+0x1b4>
  802825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802828:	8b 40 04             	mov    0x4(%eax),%eax
  80282b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80282e:	8b 12                	mov    (%edx),%edx
  802830:	89 10                	mov    %edx,(%eax)
  802832:	eb 0a                	jmp    80283e <alloc_block_NF+0x1be>
  802834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802837:	8b 00                	mov    (%eax),%eax
  802839:	a3 48 41 80 00       	mov    %eax,0x804148
  80283e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802841:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802851:	a1 54 41 80 00       	mov    0x804154,%eax
  802856:	48                   	dec    %eax
  802857:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80285c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285f:	eb 30                	jmp    802891 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802861:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802866:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802869:	75 0a                	jne    802875 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80286b:	a1 38 41 80 00       	mov    0x804138,%eax
  802870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802873:	eb 08                	jmp    80287d <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 08             	mov    0x8(%eax),%eax
  802883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802886:	0f 85 4d fe ff ff    	jne    8026d9 <alloc_block_NF+0x59>

			return NULL;
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
  802896:	53                   	push   %ebx
  802897:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80289a:	a1 38 41 80 00       	mov    0x804138,%eax
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	0f 85 86 00 00 00    	jne    80292d <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8028a7:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8028ae:	00 00 00 
  8028b1:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8028b8:	00 00 00 
  8028bb:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8028c2:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028c9:	75 17                	jne    8028e2 <insert_sorted_with_merge_freeList+0x4f>
  8028cb:	83 ec 04             	sub    $0x4,%esp
  8028ce:	68 90 3c 80 00       	push   $0x803c90
  8028d3:	68 48 01 00 00       	push   $0x148
  8028d8:	68 b3 3c 80 00       	push   $0x803cb3
  8028dd:	e8 ef d9 ff ff       	call   8002d1 <_panic>
  8028e2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	89 10                	mov    %edx,(%eax)
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 0d                	je     802903 <insert_sorted_with_merge_freeList+0x70>
  8028f6:	a1 38 41 80 00       	mov    0x804138,%eax
  8028fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fe:	89 50 04             	mov    %edx,0x4(%eax)
  802901:	eb 08                	jmp    80290b <insert_sorted_with_merge_freeList+0x78>
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	a3 38 41 80 00       	mov    %eax,0x804138
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291d:	a1 44 41 80 00       	mov    0x804144,%eax
  802922:	40                   	inc    %eax
  802923:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802928:	e9 73 07 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	8b 50 08             	mov    0x8(%eax),%edx
  802933:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802938:	8b 40 08             	mov    0x8(%eax),%eax
  80293b:	39 c2                	cmp    %eax,%edx
  80293d:	0f 86 84 00 00 00    	jbe    8029c7 <insert_sorted_with_merge_freeList+0x134>
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	8b 50 08             	mov    0x8(%eax),%edx
  802949:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80294e:	8b 48 0c             	mov    0xc(%eax),%ecx
  802951:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802956:	8b 40 08             	mov    0x8(%eax),%eax
  802959:	01 c8                	add    %ecx,%eax
  80295b:	39 c2                	cmp    %eax,%edx
  80295d:	74 68                	je     8029c7 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  80295f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802963:	75 17                	jne    80297c <insert_sorted_with_merge_freeList+0xe9>
  802965:	83 ec 04             	sub    $0x4,%esp
  802968:	68 cc 3c 80 00       	push   $0x803ccc
  80296d:	68 4c 01 00 00       	push   $0x14c
  802972:	68 b3 3c 80 00       	push   $0x803cb3
  802977:	e8 55 d9 ff ff       	call   8002d1 <_panic>
  80297c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	89 50 04             	mov    %edx,0x4(%eax)
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	85 c0                	test   %eax,%eax
  802990:	74 0c                	je     80299e <insert_sorted_with_merge_freeList+0x10b>
  802992:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802997:	8b 55 08             	mov    0x8(%ebp),%edx
  80299a:	89 10                	mov    %edx,(%eax)
  80299c:	eb 08                	jmp    8029a6 <insert_sorted_with_merge_freeList+0x113>
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8029bc:	40                   	inc    %eax
  8029bd:	a3 44 41 80 00       	mov    %eax,0x804144
  8029c2:	e9 d9 06 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	8b 50 08             	mov    0x8(%eax),%edx
  8029cd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029d2:	8b 40 08             	mov    0x8(%eax),%eax
  8029d5:	39 c2                	cmp    %eax,%edx
  8029d7:	0f 86 b5 00 00 00    	jbe    802a92 <insert_sorted_with_merge_freeList+0x1ff>
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	8b 50 08             	mov    0x8(%eax),%edx
  8029e3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e8:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029eb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029f0:	8b 40 08             	mov    0x8(%eax),%eax
  8029f3:	01 c8                	add    %ecx,%eax
  8029f5:	39 c2                	cmp    %eax,%edx
  8029f7:	0f 85 95 00 00 00    	jne    802a92 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029fd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a02:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a08:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0e:	8b 52 0c             	mov    0xc(%edx),%edx
  802a11:	01 ca                	add    %ecx,%edx
  802a13:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2e:	75 17                	jne    802a47 <insert_sorted_with_merge_freeList+0x1b4>
  802a30:	83 ec 04             	sub    $0x4,%esp
  802a33:	68 90 3c 80 00       	push   $0x803c90
  802a38:	68 54 01 00 00       	push   $0x154
  802a3d:	68 b3 3c 80 00       	push   $0x803cb3
  802a42:	e8 8a d8 ff ff       	call   8002d1 <_panic>
  802a47:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	89 10                	mov    %edx,(%eax)
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 0d                	je     802a68 <insert_sorted_with_merge_freeList+0x1d5>
  802a5b:	a1 48 41 80 00       	mov    0x804148,%eax
  802a60:	8b 55 08             	mov    0x8(%ebp),%edx
  802a63:	89 50 04             	mov    %edx,0x4(%eax)
  802a66:	eb 08                	jmp    802a70 <insert_sorted_with_merge_freeList+0x1dd>
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	a3 48 41 80 00       	mov    %eax,0x804148
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a82:	a1 54 41 80 00       	mov    0x804154,%eax
  802a87:	40                   	inc    %eax
  802a88:	a3 54 41 80 00       	mov    %eax,0x804154
  802a8d:	e9 0e 06 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	8b 50 08             	mov    0x8(%eax),%edx
  802a98:	a1 38 41 80 00       	mov    0x804138,%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	39 c2                	cmp    %eax,%edx
  802aa2:	0f 83 c1 00 00 00    	jae    802b69 <insert_sorted_with_merge_freeList+0x2d6>
  802aa8:	a1 38 41 80 00       	mov    0x804138,%eax
  802aad:	8b 50 08             	mov    0x8(%eax),%edx
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	8b 48 08             	mov    0x8(%eax),%ecx
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  802abc:	01 c8                	add    %ecx,%eax
  802abe:	39 c2                	cmp    %eax,%edx
  802ac0:	0f 85 a3 00 00 00    	jne    802b69 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ac6:	a1 38 41 80 00       	mov    0x804138,%eax
  802acb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ace:	8b 52 08             	mov    0x8(%edx),%edx
  802ad1:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ad4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ad9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802adf:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae5:	8b 52 0c             	mov    0xc(%edx),%edx
  802ae8:	01 ca                	add    %ecx,%edx
  802aea:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b05:	75 17                	jne    802b1e <insert_sorted_with_merge_freeList+0x28b>
  802b07:	83 ec 04             	sub    $0x4,%esp
  802b0a:	68 90 3c 80 00       	push   $0x803c90
  802b0f:	68 5d 01 00 00       	push   $0x15d
  802b14:	68 b3 3c 80 00       	push   $0x803cb3
  802b19:	e8 b3 d7 ff ff       	call   8002d1 <_panic>
  802b1e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	89 10                	mov    %edx,(%eax)
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	74 0d                	je     802b3f <insert_sorted_with_merge_freeList+0x2ac>
  802b32:	a1 48 41 80 00       	mov    0x804148,%eax
  802b37:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3a:	89 50 04             	mov    %edx,0x4(%eax)
  802b3d:	eb 08                	jmp    802b47 <insert_sorted_with_merge_freeList+0x2b4>
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	a3 48 41 80 00       	mov    %eax,0x804148
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b59:	a1 54 41 80 00       	mov    0x804154,%eax
  802b5e:	40                   	inc    %eax
  802b5f:	a3 54 41 80 00       	mov    %eax,0x804154
  802b64:	e9 37 05 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	8b 50 08             	mov    0x8(%eax),%edx
  802b6f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b74:	8b 40 08             	mov    0x8(%eax),%eax
  802b77:	39 c2                	cmp    %eax,%edx
  802b79:	0f 83 82 00 00 00    	jae    802c01 <insert_sorted_with_merge_freeList+0x36e>
  802b7f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b84:	8b 50 08             	mov    0x8(%eax),%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	8b 48 08             	mov    0x8(%eax),%ecx
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	8b 40 0c             	mov    0xc(%eax),%eax
  802b93:	01 c8                	add    %ecx,%eax
  802b95:	39 c2                	cmp    %eax,%edx
  802b97:	74 68                	je     802c01 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9d:	75 17                	jne    802bb6 <insert_sorted_with_merge_freeList+0x323>
  802b9f:	83 ec 04             	sub    $0x4,%esp
  802ba2:	68 90 3c 80 00       	push   $0x803c90
  802ba7:	68 62 01 00 00       	push   $0x162
  802bac:	68 b3 3c 80 00       	push   $0x803cb3
  802bb1:	e8 1b d7 ff ff       	call   8002d1 <_panic>
  802bb6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	89 10                	mov    %edx,(%eax)
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 0d                	je     802bd7 <insert_sorted_with_merge_freeList+0x344>
  802bca:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd2:	89 50 04             	mov    %edx,0x4(%eax)
  802bd5:	eb 08                	jmp    802bdf <insert_sorted_with_merge_freeList+0x34c>
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	a3 38 41 80 00       	mov    %eax,0x804138
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf1:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf6:	40                   	inc    %eax
  802bf7:	a3 44 41 80 00       	mov    %eax,0x804144
  802bfc:	e9 9f 04 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802c01:	a1 38 41 80 00       	mov    0x804138,%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802c0b:	e9 84 04 00 00       	jmp    803094 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 50 08             	mov    0x8(%eax),%edx
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 40 08             	mov    0x8(%eax),%eax
  802c1c:	39 c2                	cmp    %eax,%edx
  802c1e:	0f 86 a9 00 00 00    	jbe    802ccd <insert_sorted_with_merge_freeList+0x43a>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 50 08             	mov    0x8(%eax),%edx
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	8b 48 08             	mov    0x8(%eax),%ecx
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	8b 40 0c             	mov    0xc(%eax),%eax
  802c36:	01 c8                	add    %ecx,%eax
  802c38:	39 c2                	cmp    %eax,%edx
  802c3a:	0f 84 8d 00 00 00    	je     802ccd <insert_sorted_with_merge_freeList+0x43a>
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	8b 50 08             	mov    0x8(%eax),%edx
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 40 04             	mov    0x4(%eax),%eax
  802c4c:	8b 48 08             	mov    0x8(%eax),%ecx
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	8b 40 0c             	mov    0xc(%eax),%eax
  802c58:	01 c8                	add    %ecx,%eax
  802c5a:	39 c2                	cmp    %eax,%edx
  802c5c:	74 6f                	je     802ccd <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	74 06                	je     802c6a <insert_sorted_with_merge_freeList+0x3d7>
  802c64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c68:	75 17                	jne    802c81 <insert_sorted_with_merge_freeList+0x3ee>
  802c6a:	83 ec 04             	sub    $0x4,%esp
  802c6d:	68 f0 3c 80 00       	push   $0x803cf0
  802c72:	68 6b 01 00 00       	push   $0x16b
  802c77:	68 b3 3c 80 00       	push   $0x803cb3
  802c7c:	e8 50 d6 ff ff       	call   8002d1 <_panic>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 50 04             	mov    0x4(%eax),%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	89 50 04             	mov    %edx,0x4(%eax)
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c93:	89 10                	mov    %edx,(%eax)
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	8b 40 04             	mov    0x4(%eax),%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	74 0d                	je     802cac <insert_sorted_with_merge_freeList+0x419>
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	eb 08                	jmp    802cb4 <insert_sorted_with_merge_freeList+0x421>
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	a3 38 41 80 00       	mov    %eax,0x804138
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cba:	89 50 04             	mov    %edx,0x4(%eax)
  802cbd:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc2:	40                   	inc    %eax
  802cc3:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802cc8:	e9 d3 03 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 40 08             	mov    0x8(%eax),%eax
  802cd9:	39 c2                	cmp    %eax,%edx
  802cdb:	0f 86 da 00 00 00    	jbe    802dbb <insert_sorted_with_merge_freeList+0x528>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 50 08             	mov    0x8(%eax),%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	8b 48 08             	mov    0x8(%eax),%ecx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf3:	01 c8                	add    %ecx,%eax
  802cf5:	39 c2                	cmp    %eax,%edx
  802cf7:	0f 85 be 00 00 00    	jne    802dbb <insert_sorted_with_merge_freeList+0x528>
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	8b 50 08             	mov    0x8(%eax),%edx
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	8b 48 08             	mov    0x8(%eax),%ecx
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 04             	mov    0x4(%eax),%eax
  802d12:	8b 40 0c             	mov    0xc(%eax),%eax
  802d15:	01 c8                	add    %ecx,%eax
  802d17:	39 c2                	cmp    %eax,%edx
  802d19:	0f 84 9c 00 00 00    	je     802dbb <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c2                	add    %eax,%edx
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d57:	75 17                	jne    802d70 <insert_sorted_with_merge_freeList+0x4dd>
  802d59:	83 ec 04             	sub    $0x4,%esp
  802d5c:	68 90 3c 80 00       	push   $0x803c90
  802d61:	68 74 01 00 00       	push   $0x174
  802d66:	68 b3 3c 80 00       	push   $0x803cb3
  802d6b:	e8 61 d5 ff ff       	call   8002d1 <_panic>
  802d70:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	89 10                	mov    %edx,(%eax)
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 0d                	je     802d91 <insert_sorted_with_merge_freeList+0x4fe>
  802d84:	a1 48 41 80 00       	mov    0x804148,%eax
  802d89:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8c:	89 50 04             	mov    %edx,0x4(%eax)
  802d8f:	eb 08                	jmp    802d99 <insert_sorted_with_merge_freeList+0x506>
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	a3 48 41 80 00       	mov    %eax,0x804148
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dab:	a1 54 41 80 00       	mov    0x804154,%eax
  802db0:	40                   	inc    %eax
  802db1:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802db6:	e9 e5 02 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 50 08             	mov    0x8(%eax),%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 40 08             	mov    0x8(%eax),%eax
  802dc7:	39 c2                	cmp    %eax,%edx
  802dc9:	0f 86 d7 00 00 00    	jbe    802ea6 <insert_sorted_with_merge_freeList+0x613>
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 50 08             	mov    0x8(%eax),%edx
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	8b 48 08             	mov    0x8(%eax),%ecx
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	8b 40 0c             	mov    0xc(%eax),%eax
  802de1:	01 c8                	add    %ecx,%eax
  802de3:	39 c2                	cmp    %eax,%edx
  802de5:	0f 84 bb 00 00 00    	je     802ea6 <insert_sorted_with_merge_freeList+0x613>
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 50 08             	mov    0x8(%eax),%edx
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 04             	mov    0x4(%eax),%eax
  802df7:	8b 48 08             	mov    0x8(%eax),%ecx
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	8b 40 0c             	mov    0xc(%eax),%eax
  802e03:	01 c8                	add    %ecx,%eax
  802e05:	39 c2                	cmp    %eax,%edx
  802e07:	0f 85 99 00 00 00    	jne    802ea6 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 40 04             	mov    0x4(%eax),%eax
  802e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e19:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e22:	01 c2                	add    %eax,%edx
  802e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e27:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e42:	75 17                	jne    802e5b <insert_sorted_with_merge_freeList+0x5c8>
  802e44:	83 ec 04             	sub    $0x4,%esp
  802e47:	68 90 3c 80 00       	push   $0x803c90
  802e4c:	68 7d 01 00 00       	push   $0x17d
  802e51:	68 b3 3c 80 00       	push   $0x803cb3
  802e56:	e8 76 d4 ff ff       	call   8002d1 <_panic>
  802e5b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	89 10                	mov    %edx,(%eax)
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	74 0d                	je     802e7c <insert_sorted_with_merge_freeList+0x5e9>
  802e6f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e74:	8b 55 08             	mov    0x8(%ebp),%edx
  802e77:	89 50 04             	mov    %edx,0x4(%eax)
  802e7a:	eb 08                	jmp    802e84 <insert_sorted_with_merge_freeList+0x5f1>
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	a3 48 41 80 00       	mov    %eax,0x804148
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e96:	a1 54 41 80 00       	mov    0x804154,%eax
  802e9b:	40                   	inc    %eax
  802e9c:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802ea1:	e9 fa 01 00 00       	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 50 08             	mov    0x8(%eax),%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 40 08             	mov    0x8(%eax),%eax
  802eb2:	39 c2                	cmp    %eax,%edx
  802eb4:	0f 86 d2 01 00 00    	jbe    80308c <insert_sorted_with_merge_freeList+0x7f9>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 50 08             	mov    0x8(%eax),%edx
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	01 c8                	add    %ecx,%eax
  802ece:	39 c2                	cmp    %eax,%edx
  802ed0:	0f 85 b6 01 00 00    	jne    80308c <insert_sorted_with_merge_freeList+0x7f9>
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 50 08             	mov    0x8(%eax),%edx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 04             	mov    0x4(%eax),%eax
  802ee2:	8b 48 08             	mov    0x8(%eax),%ecx
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 40 04             	mov    0x4(%eax),%eax
  802eeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802eee:	01 c8                	add    %ecx,%eax
  802ef0:	39 c2                	cmp    %eax,%edx
  802ef2:	0f 85 94 01 00 00    	jne    80308c <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f01:	8b 52 04             	mov    0x4(%edx),%edx
  802f04:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f07:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0a:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f10:	8b 52 0c             	mov    0xc(%edx),%edx
  802f13:	01 da                	add    %ebx,%edx
  802f15:	01 ca                	add    %ecx,%edx
  802f17:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f32:	75 17                	jne    802f4b <insert_sorted_with_merge_freeList+0x6b8>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 25 3d 80 00       	push   $0x803d25
  802f3c:	68 86 01 00 00       	push   $0x186
  802f41:	68 b3 3c 80 00       	push   $0x803cb3
  802f46:	e8 86 d3 ff ff       	call   8002d1 <_panic>
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 10                	je     802f64 <insert_sorted_with_merge_freeList+0x6d1>
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5c:	8b 52 04             	mov    0x4(%edx),%edx
  802f5f:	89 50 04             	mov    %edx,0x4(%eax)
  802f62:	eb 0b                	jmp    802f6f <insert_sorted_with_merge_freeList+0x6dc>
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0f                	je     802f88 <insert_sorted_with_merge_freeList+0x6f5>
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f82:	8b 12                	mov    (%edx),%edx
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	eb 0a                	jmp    802f92 <insert_sorted_with_merge_freeList+0x6ff>
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	a3 38 41 80 00       	mov    %eax,0x804138
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa5:	a1 44 41 80 00       	mov    0x804144,%eax
  802faa:	48                   	dec    %eax
  802fab:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802fb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb4:	75 17                	jne    802fcd <insert_sorted_with_merge_freeList+0x73a>
  802fb6:	83 ec 04             	sub    $0x4,%esp
  802fb9:	68 90 3c 80 00       	push   $0x803c90
  802fbe:	68 87 01 00 00       	push   $0x187
  802fc3:	68 b3 3c 80 00       	push   $0x803cb3
  802fc8:	e8 04 d3 ff ff       	call   8002d1 <_panic>
  802fcd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	89 10                	mov    %edx,(%eax)
  802fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0d                	je     802fee <insert_sorted_with_merge_freeList+0x75b>
  802fe1:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
  802fec:	eb 08                	jmp    802ff6 <insert_sorted_with_merge_freeList+0x763>
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	a3 48 41 80 00       	mov    %eax,0x804148
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803008:	a1 54 41 80 00       	mov    0x804154,%eax
  80300d:	40                   	inc    %eax
  80300e:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803027:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302b:	75 17                	jne    803044 <insert_sorted_with_merge_freeList+0x7b1>
  80302d:	83 ec 04             	sub    $0x4,%esp
  803030:	68 90 3c 80 00       	push   $0x803c90
  803035:	68 8a 01 00 00       	push   $0x18a
  80303a:	68 b3 3c 80 00       	push   $0x803cb3
  80303f:	e8 8d d2 ff ff       	call   8002d1 <_panic>
  803044:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	89 10                	mov    %edx,(%eax)
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 0d                	je     803065 <insert_sorted_with_merge_freeList+0x7d2>
  803058:	a1 48 41 80 00       	mov    0x804148,%eax
  80305d:	8b 55 08             	mov    0x8(%ebp),%edx
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	eb 08                	jmp    80306d <insert_sorted_with_merge_freeList+0x7da>
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	a3 48 41 80 00       	mov    %eax,0x804148
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307f:	a1 54 41 80 00       	mov    0x804154,%eax
  803084:	40                   	inc    %eax
  803085:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  80308a:	eb 14                	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803098:	0f 85 72 fb ff ff    	jne    802c10 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80309e:	eb 00                	jmp    8030a0 <insert_sorted_with_merge_freeList+0x80d>
  8030a0:	90                   	nop
  8030a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030a4:	c9                   	leave  
  8030a5:	c3                   	ret    

008030a6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030a6:	55                   	push   %ebp
  8030a7:	89 e5                	mov    %esp,%ebp
  8030a9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8030ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8030af:	89 d0                	mov    %edx,%eax
  8030b1:	c1 e0 02             	shl    $0x2,%eax
  8030b4:	01 d0                	add    %edx,%eax
  8030b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030bd:	01 d0                	add    %edx,%eax
  8030bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030c6:	01 d0                	add    %edx,%eax
  8030c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030cf:	01 d0                	add    %edx,%eax
  8030d1:	c1 e0 04             	shl    $0x4,%eax
  8030d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030de:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030e1:	83 ec 0c             	sub    $0xc,%esp
  8030e4:	50                   	push   %eax
  8030e5:	e8 7b eb ff ff       	call   801c65 <sys_get_virtual_time>
  8030ea:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030ed:	eb 41                	jmp    803130 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030f2:	83 ec 0c             	sub    $0xc,%esp
  8030f5:	50                   	push   %eax
  8030f6:	e8 6a eb ff ff       	call   801c65 <sys_get_virtual_time>
  8030fb:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803104:	29 c2                	sub    %eax,%edx
  803106:	89 d0                	mov    %edx,%eax
  803108:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80310b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80310e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803111:	89 d1                	mov    %edx,%ecx
  803113:	29 c1                	sub    %eax,%ecx
  803115:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803118:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311b:	39 c2                	cmp    %eax,%edx
  80311d:	0f 97 c0             	seta   %al
  803120:	0f b6 c0             	movzbl %al,%eax
  803123:	29 c1                	sub    %eax,%ecx
  803125:	89 c8                	mov    %ecx,%eax
  803127:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80312a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80312d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803136:	72 b7                	jb     8030ef <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803138:	90                   	nop
  803139:	c9                   	leave  
  80313a:	c3                   	ret    

0080313b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80313b:	55                   	push   %ebp
  80313c:	89 e5                	mov    %esp,%ebp
  80313e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803148:	eb 03                	jmp    80314d <busy_wait+0x12>
  80314a:	ff 45 fc             	incl   -0x4(%ebp)
  80314d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803150:	3b 45 08             	cmp    0x8(%ebp),%eax
  803153:	72 f5                	jb     80314a <busy_wait+0xf>
	return i;
  803155:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803158:	c9                   	leave  
  803159:	c3                   	ret    
  80315a:	66 90                	xchg   %ax,%ax

0080315c <__udivdi3>:
  80315c:	55                   	push   %ebp
  80315d:	57                   	push   %edi
  80315e:	56                   	push   %esi
  80315f:	53                   	push   %ebx
  803160:	83 ec 1c             	sub    $0x1c,%esp
  803163:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803167:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80316b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80316f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803173:	89 ca                	mov    %ecx,%edx
  803175:	89 f8                	mov    %edi,%eax
  803177:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80317b:	85 f6                	test   %esi,%esi
  80317d:	75 2d                	jne    8031ac <__udivdi3+0x50>
  80317f:	39 cf                	cmp    %ecx,%edi
  803181:	77 65                	ja     8031e8 <__udivdi3+0x8c>
  803183:	89 fd                	mov    %edi,%ebp
  803185:	85 ff                	test   %edi,%edi
  803187:	75 0b                	jne    803194 <__udivdi3+0x38>
  803189:	b8 01 00 00 00       	mov    $0x1,%eax
  80318e:	31 d2                	xor    %edx,%edx
  803190:	f7 f7                	div    %edi
  803192:	89 c5                	mov    %eax,%ebp
  803194:	31 d2                	xor    %edx,%edx
  803196:	89 c8                	mov    %ecx,%eax
  803198:	f7 f5                	div    %ebp
  80319a:	89 c1                	mov    %eax,%ecx
  80319c:	89 d8                	mov    %ebx,%eax
  80319e:	f7 f5                	div    %ebp
  8031a0:	89 cf                	mov    %ecx,%edi
  8031a2:	89 fa                	mov    %edi,%edx
  8031a4:	83 c4 1c             	add    $0x1c,%esp
  8031a7:	5b                   	pop    %ebx
  8031a8:	5e                   	pop    %esi
  8031a9:	5f                   	pop    %edi
  8031aa:	5d                   	pop    %ebp
  8031ab:	c3                   	ret    
  8031ac:	39 ce                	cmp    %ecx,%esi
  8031ae:	77 28                	ja     8031d8 <__udivdi3+0x7c>
  8031b0:	0f bd fe             	bsr    %esi,%edi
  8031b3:	83 f7 1f             	xor    $0x1f,%edi
  8031b6:	75 40                	jne    8031f8 <__udivdi3+0x9c>
  8031b8:	39 ce                	cmp    %ecx,%esi
  8031ba:	72 0a                	jb     8031c6 <__udivdi3+0x6a>
  8031bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031c0:	0f 87 9e 00 00 00    	ja     803264 <__udivdi3+0x108>
  8031c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031cb:	89 fa                	mov    %edi,%edx
  8031cd:	83 c4 1c             	add    $0x1c,%esp
  8031d0:	5b                   	pop    %ebx
  8031d1:	5e                   	pop    %esi
  8031d2:	5f                   	pop    %edi
  8031d3:	5d                   	pop    %ebp
  8031d4:	c3                   	ret    
  8031d5:	8d 76 00             	lea    0x0(%esi),%esi
  8031d8:	31 ff                	xor    %edi,%edi
  8031da:	31 c0                	xor    %eax,%eax
  8031dc:	89 fa                	mov    %edi,%edx
  8031de:	83 c4 1c             	add    $0x1c,%esp
  8031e1:	5b                   	pop    %ebx
  8031e2:	5e                   	pop    %esi
  8031e3:	5f                   	pop    %edi
  8031e4:	5d                   	pop    %ebp
  8031e5:	c3                   	ret    
  8031e6:	66 90                	xchg   %ax,%ax
  8031e8:	89 d8                	mov    %ebx,%eax
  8031ea:	f7 f7                	div    %edi
  8031ec:	31 ff                	xor    %edi,%edi
  8031ee:	89 fa                	mov    %edi,%edx
  8031f0:	83 c4 1c             	add    $0x1c,%esp
  8031f3:	5b                   	pop    %ebx
  8031f4:	5e                   	pop    %esi
  8031f5:	5f                   	pop    %edi
  8031f6:	5d                   	pop    %ebp
  8031f7:	c3                   	ret    
  8031f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031fd:	89 eb                	mov    %ebp,%ebx
  8031ff:	29 fb                	sub    %edi,%ebx
  803201:	89 f9                	mov    %edi,%ecx
  803203:	d3 e6                	shl    %cl,%esi
  803205:	89 c5                	mov    %eax,%ebp
  803207:	88 d9                	mov    %bl,%cl
  803209:	d3 ed                	shr    %cl,%ebp
  80320b:	89 e9                	mov    %ebp,%ecx
  80320d:	09 f1                	or     %esi,%ecx
  80320f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803213:	89 f9                	mov    %edi,%ecx
  803215:	d3 e0                	shl    %cl,%eax
  803217:	89 c5                	mov    %eax,%ebp
  803219:	89 d6                	mov    %edx,%esi
  80321b:	88 d9                	mov    %bl,%cl
  80321d:	d3 ee                	shr    %cl,%esi
  80321f:	89 f9                	mov    %edi,%ecx
  803221:	d3 e2                	shl    %cl,%edx
  803223:	8b 44 24 08          	mov    0x8(%esp),%eax
  803227:	88 d9                	mov    %bl,%cl
  803229:	d3 e8                	shr    %cl,%eax
  80322b:	09 c2                	or     %eax,%edx
  80322d:	89 d0                	mov    %edx,%eax
  80322f:	89 f2                	mov    %esi,%edx
  803231:	f7 74 24 0c          	divl   0xc(%esp)
  803235:	89 d6                	mov    %edx,%esi
  803237:	89 c3                	mov    %eax,%ebx
  803239:	f7 e5                	mul    %ebp
  80323b:	39 d6                	cmp    %edx,%esi
  80323d:	72 19                	jb     803258 <__udivdi3+0xfc>
  80323f:	74 0b                	je     80324c <__udivdi3+0xf0>
  803241:	89 d8                	mov    %ebx,%eax
  803243:	31 ff                	xor    %edi,%edi
  803245:	e9 58 ff ff ff       	jmp    8031a2 <__udivdi3+0x46>
  80324a:	66 90                	xchg   %ax,%ax
  80324c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803250:	89 f9                	mov    %edi,%ecx
  803252:	d3 e2                	shl    %cl,%edx
  803254:	39 c2                	cmp    %eax,%edx
  803256:	73 e9                	jae    803241 <__udivdi3+0xe5>
  803258:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80325b:	31 ff                	xor    %edi,%edi
  80325d:	e9 40 ff ff ff       	jmp    8031a2 <__udivdi3+0x46>
  803262:	66 90                	xchg   %ax,%ax
  803264:	31 c0                	xor    %eax,%eax
  803266:	e9 37 ff ff ff       	jmp    8031a2 <__udivdi3+0x46>
  80326b:	90                   	nop

0080326c <__umoddi3>:
  80326c:	55                   	push   %ebp
  80326d:	57                   	push   %edi
  80326e:	56                   	push   %esi
  80326f:	53                   	push   %ebx
  803270:	83 ec 1c             	sub    $0x1c,%esp
  803273:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803277:	8b 74 24 34          	mov    0x34(%esp),%esi
  80327b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80327f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803283:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803287:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80328b:	89 f3                	mov    %esi,%ebx
  80328d:	89 fa                	mov    %edi,%edx
  80328f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803293:	89 34 24             	mov    %esi,(%esp)
  803296:	85 c0                	test   %eax,%eax
  803298:	75 1a                	jne    8032b4 <__umoddi3+0x48>
  80329a:	39 f7                	cmp    %esi,%edi
  80329c:	0f 86 a2 00 00 00    	jbe    803344 <__umoddi3+0xd8>
  8032a2:	89 c8                	mov    %ecx,%eax
  8032a4:	89 f2                	mov    %esi,%edx
  8032a6:	f7 f7                	div    %edi
  8032a8:	89 d0                	mov    %edx,%eax
  8032aa:	31 d2                	xor    %edx,%edx
  8032ac:	83 c4 1c             	add    $0x1c,%esp
  8032af:	5b                   	pop    %ebx
  8032b0:	5e                   	pop    %esi
  8032b1:	5f                   	pop    %edi
  8032b2:	5d                   	pop    %ebp
  8032b3:	c3                   	ret    
  8032b4:	39 f0                	cmp    %esi,%eax
  8032b6:	0f 87 ac 00 00 00    	ja     803368 <__umoddi3+0xfc>
  8032bc:	0f bd e8             	bsr    %eax,%ebp
  8032bf:	83 f5 1f             	xor    $0x1f,%ebp
  8032c2:	0f 84 ac 00 00 00    	je     803374 <__umoddi3+0x108>
  8032c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8032cd:	29 ef                	sub    %ebp,%edi
  8032cf:	89 fe                	mov    %edi,%esi
  8032d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032d5:	89 e9                	mov    %ebp,%ecx
  8032d7:	d3 e0                	shl    %cl,%eax
  8032d9:	89 d7                	mov    %edx,%edi
  8032db:	89 f1                	mov    %esi,%ecx
  8032dd:	d3 ef                	shr    %cl,%edi
  8032df:	09 c7                	or     %eax,%edi
  8032e1:	89 e9                	mov    %ebp,%ecx
  8032e3:	d3 e2                	shl    %cl,%edx
  8032e5:	89 14 24             	mov    %edx,(%esp)
  8032e8:	89 d8                	mov    %ebx,%eax
  8032ea:	d3 e0                	shl    %cl,%eax
  8032ec:	89 c2                	mov    %eax,%edx
  8032ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032f2:	d3 e0                	shl    %cl,%eax
  8032f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032fc:	89 f1                	mov    %esi,%ecx
  8032fe:	d3 e8                	shr    %cl,%eax
  803300:	09 d0                	or     %edx,%eax
  803302:	d3 eb                	shr    %cl,%ebx
  803304:	89 da                	mov    %ebx,%edx
  803306:	f7 f7                	div    %edi
  803308:	89 d3                	mov    %edx,%ebx
  80330a:	f7 24 24             	mull   (%esp)
  80330d:	89 c6                	mov    %eax,%esi
  80330f:	89 d1                	mov    %edx,%ecx
  803311:	39 d3                	cmp    %edx,%ebx
  803313:	0f 82 87 00 00 00    	jb     8033a0 <__umoddi3+0x134>
  803319:	0f 84 91 00 00 00    	je     8033b0 <__umoddi3+0x144>
  80331f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803323:	29 f2                	sub    %esi,%edx
  803325:	19 cb                	sbb    %ecx,%ebx
  803327:	89 d8                	mov    %ebx,%eax
  803329:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80332d:	d3 e0                	shl    %cl,%eax
  80332f:	89 e9                	mov    %ebp,%ecx
  803331:	d3 ea                	shr    %cl,%edx
  803333:	09 d0                	or     %edx,%eax
  803335:	89 e9                	mov    %ebp,%ecx
  803337:	d3 eb                	shr    %cl,%ebx
  803339:	89 da                	mov    %ebx,%edx
  80333b:	83 c4 1c             	add    $0x1c,%esp
  80333e:	5b                   	pop    %ebx
  80333f:	5e                   	pop    %esi
  803340:	5f                   	pop    %edi
  803341:	5d                   	pop    %ebp
  803342:	c3                   	ret    
  803343:	90                   	nop
  803344:	89 fd                	mov    %edi,%ebp
  803346:	85 ff                	test   %edi,%edi
  803348:	75 0b                	jne    803355 <__umoddi3+0xe9>
  80334a:	b8 01 00 00 00       	mov    $0x1,%eax
  80334f:	31 d2                	xor    %edx,%edx
  803351:	f7 f7                	div    %edi
  803353:	89 c5                	mov    %eax,%ebp
  803355:	89 f0                	mov    %esi,%eax
  803357:	31 d2                	xor    %edx,%edx
  803359:	f7 f5                	div    %ebp
  80335b:	89 c8                	mov    %ecx,%eax
  80335d:	f7 f5                	div    %ebp
  80335f:	89 d0                	mov    %edx,%eax
  803361:	e9 44 ff ff ff       	jmp    8032aa <__umoddi3+0x3e>
  803366:	66 90                	xchg   %ax,%ax
  803368:	89 c8                	mov    %ecx,%eax
  80336a:	89 f2                	mov    %esi,%edx
  80336c:	83 c4 1c             	add    $0x1c,%esp
  80336f:	5b                   	pop    %ebx
  803370:	5e                   	pop    %esi
  803371:	5f                   	pop    %edi
  803372:	5d                   	pop    %ebp
  803373:	c3                   	ret    
  803374:	3b 04 24             	cmp    (%esp),%eax
  803377:	72 06                	jb     80337f <__umoddi3+0x113>
  803379:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80337d:	77 0f                	ja     80338e <__umoddi3+0x122>
  80337f:	89 f2                	mov    %esi,%edx
  803381:	29 f9                	sub    %edi,%ecx
  803383:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803387:	89 14 24             	mov    %edx,(%esp)
  80338a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80338e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803392:	8b 14 24             	mov    (%esp),%edx
  803395:	83 c4 1c             	add    $0x1c,%esp
  803398:	5b                   	pop    %ebx
  803399:	5e                   	pop    %esi
  80339a:	5f                   	pop    %edi
  80339b:	5d                   	pop    %ebp
  80339c:	c3                   	ret    
  80339d:	8d 76 00             	lea    0x0(%esi),%esi
  8033a0:	2b 04 24             	sub    (%esp),%eax
  8033a3:	19 fa                	sbb    %edi,%edx
  8033a5:	89 d1                	mov    %edx,%ecx
  8033a7:	89 c6                	mov    %eax,%esi
  8033a9:	e9 71 ff ff ff       	jmp    80331f <__umoddi3+0xb3>
  8033ae:	66 90                	xchg   %ax,%ax
  8033b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033b4:	72 ea                	jb     8033a0 <__umoddi3+0x134>
  8033b6:	89 d9                	mov    %ebx,%ecx
  8033b8:	e9 62 ff ff ff       	jmp    80331f <__umoddi3+0xb3>
