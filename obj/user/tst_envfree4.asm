
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
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
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 32 80 00       	push   $0x8032c0
  80004a:	e8 95 15 00 00       	call   8015e4 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 84 18 00 00       	call   8018e7 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 1c 19 00 00       	call   801987 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 32 80 00       	push   $0x8032d0
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 03 33 80 00       	push   $0x803303
  800096:	e8 be 1a 00 00       	call   801b59 <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 cb 1a 00 00       	call   801b77 <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 28 18 00 00       	call   8018e7 <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 0c 33 80 00       	push   $0x80330c
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 b8 1a 00 00       	call   801b93 <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 04 18 00 00       	call   8018e7 <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 9c 18 00 00       	call   801987 <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 40 33 80 00       	push   $0x803340
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 90 33 80 00       	push   $0x803390
  800111:	6a 1f                	push   $0x1f
  800113:	68 c6 33 80 00       	push   $0x8033c6
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 dc 33 80 00       	push   $0x8033dc
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 3c 34 80 00       	push   $0x80343c
  800138:	e8 f6 03 00 00       	call   800533 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 79 1a 00 00       	call   801bc7 <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 04             	shl    $0x4,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 40 80 00       	mov    0x804020,%eax
  80017a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0f                	je     800193 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	05 5c 05 00 00       	add    $0x55c,%eax
  80018e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x60>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b4:	e8 1b 18 00 00       	call   8019d4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 a0 34 80 00       	push   $0x8034a0
  8001c1:	e8 6d 03 00 00       	call   800533 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	68 c8 34 80 00       	push   $0x8034c8
  8001e9:	e8 45 03 00 00       	call   800533 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800212:	51                   	push   %ecx
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 f0 34 80 00       	push   $0x8034f0
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 48 35 80 00       	push   $0x803548
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 a0 34 80 00       	push   $0x8034a0
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 9b 17 00 00       	call   8019ee <sys_enable_interrupt>

	// exit gracefully
	exit();
  800253:	e8 19 00 00 00       	call   800271 <exit>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 00                	push   $0x0
  800266:	e8 28 19 00 00       	call   801b93 <sys_destroy_env>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <exit>:

void
exit(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800277:	e8 7d 19 00 00       	call   801bf9 <sys_exit_env>
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800285:	8d 45 10             	lea    0x10(%ebp),%eax
  800288:	83 c0 04             	add    $0x4,%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 5c 35 80 00       	push   $0x80355c
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 61 35 80 00       	push   $0x803561
  8002be:	e8 70 02 00 00       	call   800533 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 f3 01 00 00       	call   8004c8 <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	6a 00                	push   $0x0
  8002dd:	68 7d 35 80 00       	push   $0x80357d
  8002e2:	e8 e1 01 00 00       	call   8004c8 <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ea:	e8 82 ff ff ff       	call   800271 <exit>

	// should not return here
	while (1) ;
  8002ef:	eb fe                	jmp    8002ef <_panic+0x70>

008002f1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 80 35 80 00       	push   $0x803580
  80030e:	6a 26                	push   $0x26
  800310:	68 cc 35 80 00       	push   $0x8035cc
  800315:	e8 65 ff ff ff       	call   80027f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 c2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 a2 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 69                	jmp    8003c3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 20 40 80 00       	mov    0x804020,%eax
  80035f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8a 40 04             	mov    0x4(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	75 46                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037a:	a1 20 40 80 00       	mov    0x804020,%eax
  80037f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	c1 e0 03             	shl    $0x3,%eax
  800391:	01 c8                	add    %ecx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 12                	jmp    8003d2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c8:	8b 50 74             	mov    0x74(%eax),%edx
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	77 88                	ja     80035a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d6:	75 14                	jne    8003ec <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 d8 35 80 00       	push   $0x8035d8
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 cc 35 80 00       	push   $0x8035cc
  8003e7:	e8 93 fe ff ff       	call   80027f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ec:	ff 45 f0             	incl   -0x10(%ebp)
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f5:	0f 8c 32 ff ff ff    	jl     80032d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	eb 26                	jmp    800431 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800416:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8a 40 04             	mov    0x4(%eax),%al
  800427:	3c 01                	cmp    $0x1,%al
  800429:	75 03                	jne    80042e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042e:	ff 45 e0             	incl   -0x20(%ebp)
  800431:	a1 20 40 80 00       	mov    0x804020,%eax
  800436:	8b 50 74             	mov    0x74(%eax),%edx
  800439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	77 cb                	ja     80040b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800443:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800446:	74 14                	je     80045c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	68 2c 36 80 00       	push   $0x80362c
  800450:	6a 44                	push   $0x44
  800452:	68 cc 35 80 00       	push   $0x8035cc
  800457:	e8 23 fe ff ff       	call   80027f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045c:	90                   	nop
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 48 01             	lea    0x1(%eax),%ecx
  80046d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800470:	89 0a                	mov    %ecx,(%edx)
  800472:	8b 55 08             	mov    0x8(%ebp),%edx
  800475:	88 d1                	mov    %dl,%cl
  800477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	3d ff 00 00 00       	cmp    $0xff,%eax
  800488:	75 2c                	jne    8004b6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048a:	a0 24 40 80 00       	mov    0x804024,%al
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	8b 12                	mov    (%edx),%edx
  800497:	89 d1                	mov    %edx,%ecx
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	83 c2 08             	add    $0x8,%edx
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	50                   	push   %eax
  8004a3:	51                   	push   %ecx
  8004a4:	52                   	push   %edx
  8004a5:	e8 7c 13 00 00       	call   801826 <sys_cputs>
  8004aa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 40 04             	mov    0x4(%eax),%eax
  8004bc:	8d 50 01             	lea    0x1(%eax),%edx
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d8:	00 00 00 
	b.cnt = 0;
  8004db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	68 5f 04 80 00       	push   $0x80045f
  8004f7:	e8 11 02 00 00       	call   80070d <vprintfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ff:	a0 24 40 80 00       	mov    0x804024,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	50                   	push   %eax
  800511:	52                   	push   %edx
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	83 c0 08             	add    $0x8,%eax
  80051b:	50                   	push   %eax
  80051c:	e8 05 13 00 00       	call   801826 <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800524:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <cprintf>:

int cprintf(const char *fmt, ...) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800539:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800540:	8d 45 0c             	lea    0xc(%ebp),%eax
  800543:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 f4             	pushl  -0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 73 ff ff ff       	call   8004c8 <vcprintf>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800566:	e8 69 14 00 00       	call   8019d4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 48 ff ff ff       	call   8004c8 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800586:	e8 63 14 00 00       	call   8019ee <sys_enable_interrupt>
	return cnt;
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	53                   	push   %ebx
  800594:	83 ec 14             	sub    $0x14,%esp
  800597:	8b 45 10             	mov    0x10(%ebp),%eax
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ae:	77 55                	ja     800605 <printnum+0x75>
  8005b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b3:	72 05                	jb     8005ba <printnum+0x2a>
  8005b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b8:	77 4b                	ja     800605 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d0:	e8 7f 2a 00 00       	call   803054 <__udivdi3>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	53                   	push   %ebx
  8005df:	ff 75 18             	pushl  0x18(%ebp)
  8005e2:	52                   	push   %edx
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	e8 a1 ff ff ff       	call   800590 <printnum>
  8005ef:	83 c4 20             	add    $0x20,%esp
  8005f2:	eb 1a                	jmp    80060e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 20             	pushl  0x20(%ebp)
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	ff d0                	call   *%eax
  800602:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	ff 4d 1c             	decl   0x1c(%ebp)
  800608:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060c:	7f e6                	jg     8005f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800611:	bb 00 00 00 00       	mov    $0x0,%ebx
  800616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061c:	53                   	push   %ebx
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	e8 3f 2b 00 00       	call   803164 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 94 38 80 00       	add    $0x803894,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	0f be c0             	movsbl %al,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	50                   	push   %eax
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
}
  800641:	90                   	nop
  800642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064e:	7e 1c                	jle    80066c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 08             	sub    $0x8,%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	eb 40                	jmp    8006ac <getuint+0x65>
	else if (lflag)
  80066c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800670:	74 1e                	je     800690 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 1c                	jmp    8006ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b5:	7e 1c                	jle    8006d3 <getint+0x25>
		return va_arg(*ap, long long);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 08             	lea    0x8(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 08             	sub    $0x8,%eax
  8006cc:	8b 50 04             	mov    0x4(%eax),%edx
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	eb 38                	jmp    80070b <getint+0x5d>
	else if (lflag)
  8006d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d7:	74 1a                	je     8006f3 <getint+0x45>
		return va_arg(*ap, long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	eb 18                	jmp    80070b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	99                   	cltd   
}
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	eb 17                	jmp    80072e <vprintfmt+0x21>
			if (ch == '\0')
  800717:	85 db                	test   %ebx,%ebx
  800719:	0f 84 af 03 00 00    	je     800ace <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	83 fb 25             	cmp    $0x25,%ebx
  80073f:	75 d6                	jne    800717 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800741:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800745:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800772:	83 f8 55             	cmp    $0x55,%eax
  800775:	0f 87 2b 03 00 00    	ja     800aa6 <vprintfmt+0x399>
  80077b:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  800782:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800784:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800788:	eb d7                	jmp    800761 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d1                	jmp    800761 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	89 d0                	mov    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d8                	add    %ebx,%eax
  8007a5:	83 e8 30             	sub    $0x30,%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b6:	7e 3e                	jle    8007f6 <vprintfmt+0xe9>
  8007b8:	83 fb 39             	cmp    $0x39,%ebx
  8007bb:	7f 39                	jg     8007f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c0:	eb d5                	jmp    800797 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	79 83                	jns    800761 <vprintfmt+0x54>
				width = 0;
  8007de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e5:	e9 77 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f1:	e9 6b ff ff ff       	jmp    800761 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	0f 89 60 ff ff ff    	jns    800761 <vprintfmt+0x54>
				width = precision, precision = -1;
  800801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080e:	e9 4e ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800813:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800816:	e9 46 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 89 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800851:	85 db                	test   %ebx,%ebx
  800853:	79 02                	jns    800857 <vprintfmt+0x14a>
				err = -err;
  800855:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 fb 64             	cmp    $0x64,%ebx
  80085a:	7f 0b                	jg     800867 <vprintfmt+0x15a>
  80085c:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 a5 38 80 00       	push   $0x8038a5
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 5e 02 00 00       	call   800ad6 <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087b:	e9 49 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800880:	56                   	push   %esi
  800881:	68 ae 38 80 00       	push   $0x8038ae
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 45 02 00 00       	call   800ad6 <printfmt>
  800891:	83 c4 10             	add    $0x10,%esp
			break;
  800894:	e9 30 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 30                	mov    (%eax),%esi
  8008aa:	85 f6                	test   %esi,%esi
  8008ac:	75 05                	jne    8008b3 <vprintfmt+0x1a6>
				p = "(null)";
  8008ae:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7e 6d                	jle    800926 <vprintfmt+0x219>
  8008b9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bd:	74 67                	je     800926 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	56                   	push   %esi
  8008c7:	e8 0c 03 00 00       	call   800bd8 <strnlen>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d2:	eb 16                	jmp    8008ea <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7f e4                	jg     8008d4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	eb 34                	jmp    800926 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f6:	74 1c                	je     800914 <vprintfmt+0x207>
  8008f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fb:	7e 05                	jle    800902 <vprintfmt+0x1f5>
  8008fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800900:	7e 12                	jle    800914 <vprintfmt+0x207>
					putch('?', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 3f                	push   $0x3f
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb 0f                	jmp    800923 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	ff 4d e4             	decl   -0x1c(%ebp)
  800926:	89 f0                	mov    %esi,%eax
  800928:	8d 70 01             	lea    0x1(%eax),%esi
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 24                	je     800958 <vprintfmt+0x24b>
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	78 b8                	js     8008f2 <vprintfmt+0x1e5>
  80093a:	ff 4d e0             	decl   -0x20(%ebp)
  80093d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800941:	79 af                	jns    8008f2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	eb 13                	jmp    800958 <vprintfmt+0x24b>
				putch(' ', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 20                	push   $0x20
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	ff 4d e4             	decl   -0x1c(%ebp)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	7f e7                	jg     800945 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095e:	e9 66 01 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 e8             	pushl  -0x18(%ebp)
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	e8 3c fd ff ff       	call   8006ae <getint>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800981:	85 d2                	test   %edx,%edx
  800983:	79 23                	jns    8009a8 <vprintfmt+0x29b>
				putch('-', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 2d                	push   $0x2d
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099b:	f7 d8                	neg    %eax
  80099d:	83 d2 00             	adc    $0x0,%edx
  8009a0:	f7 da                	neg    %edx
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 bc 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 84 fc ff ff       	call   800647 <getuint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d3:	e9 98 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			break;
  800a08:	e9 bc 00 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 30                	push   $0x30
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 78                	push   $0x78
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4f:	eb 1f                	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 e7 fb ff ff       	call   800647 <getuint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	52                   	push   %edx
  800a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a82:	ff 75 f0             	pushl  -0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 00 fb ff ff       	call   800590 <printnum>
  800a90:	83 c4 20             	add    $0x20,%esp
			break;
  800a93:	eb 34                	jmp    800ac9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 25                	push   $0x25
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab6:	ff 4d 10             	decl   0x10(%ebp)
  800ab9:	eb 03                	jmp    800abe <vprintfmt+0x3b1>
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	48                   	dec    %eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	3c 25                	cmp    $0x25,%al
  800ac6:	75 f3                	jne    800abb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac8:	90                   	nop
		}
	}
  800ac9:	e9 47 fc ff ff       	jmp    800715 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ace:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adc:	8d 45 10             	lea    0x10(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 16 fc ff ff       	call   80070d <vprintfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afa:	90                   	nop
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 08             	mov    0x8(%eax),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 10                	mov    (%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8b 40 04             	mov    0x4(%eax),%eax
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	73 12                	jae    800b30 <sprintputch+0x33>
		*b->buf++ = ch;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 48 01             	lea    0x1(%eax),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 0a                	mov    %ecx,(%edx)
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	88 10                	mov    %dl,(%eax)
}
  800b30:	90                   	nop
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b58:	74 06                	je     800b60 <vsnprintf+0x2d>
  800b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5e:	7f 07                	jg     800b67 <vsnprintf+0x34>
		return -E_INVAL;
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	eb 20                	jmp    800b87 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b67:	ff 75 14             	pushl  0x14(%ebp)
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b70:	50                   	push   %eax
  800b71:	68 fd 0a 80 00       	push   $0x800afd
  800b76:	e8 92 fb ff ff       	call   80070d <vprintfmt>
  800b7b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b92:	83 c0 04             	add    $0x4,%eax
  800b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 89 ff ff ff       	call   800b33 <vsnprintf>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc2:	eb 06                	jmp    800bca <strlen+0x15>
		n++;
  800bc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 f1                	jne    800bc4 <strlen+0xf>
		n++;
	return n;
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 09                	jmp    800bf0 <strnlen+0x18>
		n++;
  800be7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	ff 4d 0c             	decl   0xc(%ebp)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 09                	je     800bff <strnlen+0x27>
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 e8                	jne    800be7 <strnlen+0xf>
		n++;
	return n;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c10:	90                   	nop
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c23:	8a 12                	mov    (%edx),%dl
  800c25:	88 10                	mov    %dl,(%eax)
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 e4                	jne    800c11 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c45:	eb 1f                	jmp    800c66 <strncpy+0x34>
		*dst++ = *src;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8d 50 01             	lea    0x1(%eax),%edx
  800c4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c53:	8a 12                	mov    (%edx),%dl
  800c55:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 03                	je     800c63 <strncpy+0x31>
			src++;
  800c60:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6c:	72 d9                	jb     800c47 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 30                	je     800cb5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c85:	eb 16                	jmp    800c9d <strlcpy+0x2a>
			*dst++ = *src++;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c99:	8a 12                	mov    (%edx),%dl
  800c9b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9d:	ff 4d 10             	decl   0x10(%ebp)
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 09                	je     800caf <strlcpy+0x3c>
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 d8                	jne    800c87 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	29 c2                	sub    %eax,%edx
  800cbd:	89 d0                	mov    %edx,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc4:	eb 06                	jmp    800ccc <strcmp+0xb>
		p++, q++;
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	74 0e                	je     800ce3 <strcmp+0x22>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 10                	mov    (%eax),%dl
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	38 c2                	cmp    %al,%dl
  800ce1:	74 e3                	je     800cc6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 d0             	movzbl %al,%edx
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 c0             	movzbl %al,%eax
  800cf3:	29 c2                	sub    %eax,%edx
  800cf5:	89 d0                	mov    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfc:	eb 09                	jmp    800d07 <strncmp+0xe>
		n--, p++, q++;
  800cfe:	ff 4d 10             	decl   0x10(%ebp)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	74 17                	je     800d24 <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 0e                	je     800d24 <strncmp+0x2b>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 10                	mov    (%eax),%dl
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	38 c2                	cmp    %al,%dl
  800d22:	74 da                	je     800cfe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d28:	75 07                	jne    800d31 <strncmp+0x38>
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb 14                	jmp    800d45 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 d0             	movzbl %al,%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	29 c2                	sub    %eax,%edx
  800d43:	89 d0                	mov    %edx,%eax
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 04             	sub    $0x4,%esp
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d53:	eb 12                	jmp    800d67 <strchr+0x20>
		if (*s == c)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5d:	75 05                	jne    800d64 <strchr+0x1d>
			return (char *) s;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	eb 11                	jmp    800d75 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e5                	jne    800d55 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d83:	eb 0d                	jmp    800d92 <strfind+0x1b>
		if (*s == c)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8d:	74 0e                	je     800d9d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	75 ea                	jne    800d85 <strfind+0xe>
  800d9b:	eb 01                	jmp    800d9e <strfind+0x27>
		if (*s == c)
			break;
  800d9d:	90                   	nop
	return (char *) s;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db5:	eb 0e                	jmp    800dc5 <memset+0x22>
		*p++ = c;
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	8d 50 01             	lea    0x1(%eax),%edx
  800dbd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc5:	ff 4d f8             	decl   -0x8(%ebp)
  800dc8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcc:	79 e9                	jns    800db7 <memset+0x14>
		*p++ = c;

	return v;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de5:	eb 16                	jmp    800dfd <memcpy+0x2a>
		*d++ = *s++;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df9:	8a 12                	mov    (%edx),%dl
  800dfb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e03:	89 55 10             	mov    %edx,0x10(%ebp)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 dd                	jne    800de7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e27:	73 50                	jae    800e79 <memmove+0x6a>
  800e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e34:	76 43                	jbe    800e79 <memmove+0x6a>
		s += n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e42:	eb 10                	jmp    800e54 <memmove+0x45>
			*--d = *--s;
  800e44:	ff 4d f8             	decl   -0x8(%ebp)
  800e47:	ff 4d fc             	decl   -0x4(%ebp)
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 e3                	jne    800e44 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e61:	eb 23                	jmp    800e86 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e72:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 dd                	jne    800e63 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9d:	eb 2a                	jmp    800ec9 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 10                	mov    (%eax),%dl
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	38 c2                	cmp    %al,%dl
  800eab:	74 16                	je     800ec3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 d0             	movzbl %al,%edx
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	29 c2                	sub    %eax,%edx
  800ebf:	89 d0                	mov    %edx,%eax
  800ec1:	eb 18                	jmp    800edb <memcmp+0x50>
		s1++, s2++;
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	75 c9                	jne    800e9f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee9:	01 d0                	add    %edx,%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eee:	eb 15                	jmp    800f05 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d0             	movzbl %al,%edx
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	0f b6 c0             	movzbl %al,%eax
  800efe:	39 c2                	cmp    %eax,%edx
  800f00:	74 0d                	je     800f0f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0b:	72 e3                	jb     800ef0 <memfind+0x13>
  800f0d:	eb 01                	jmp    800f10 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0f:	90                   	nop
	return (void *) s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f29:	eb 03                	jmp    800f2e <strtol+0x19>
		s++;
  800f2b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 20                	cmp    $0x20,%al
  800f35:	74 f4                	je     800f2b <strtol+0x16>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 09                	cmp    $0x9,%al
  800f3e:	74 eb                	je     800f2b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2b                	cmp    $0x2b,%al
  800f47:	75 05                	jne    800f4e <strtol+0x39>
		s++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	eb 13                	jmp    800f61 <strtol+0x4c>
	else if (*s == '-')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 2d                	cmp    $0x2d,%al
  800f55:	75 0a                	jne    800f61 <strtol+0x4c>
		s++, neg = 1;
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 06                	je     800f6d <strtol+0x58>
  800f67:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6b:	75 20                	jne    800f8d <strtol+0x78>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 30                	cmp    $0x30,%al
  800f74:	75 17                	jne    800f8d <strtol+0x78>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	40                   	inc    %eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 78                	cmp    $0x78,%al
  800f7e:	75 0d                	jne    800f8d <strtol+0x78>
		s += 2, base = 16;
  800f80:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f84:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8b:	eb 28                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	75 15                	jne    800fa8 <strtol+0x93>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 30                	cmp    $0x30,%al
  800f9a:	75 0c                	jne    800fa8 <strtol+0x93>
		s++, base = 8;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa6:	eb 0d                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	75 07                	jne    800fb5 <strtol+0xa0>
		base = 10;
  800fae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 2f                	cmp    $0x2f,%al
  800fbc:	7e 19                	jle    800fd7 <strtol+0xc2>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 39                	cmp    $0x39,%al
  800fc5:	7f 10                	jg     800fd7 <strtol+0xc2>
			dig = *s - '0';
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f be c0             	movsbl %al,%eax
  800fcf:	83 e8 30             	sub    $0x30,%eax
  800fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd5:	eb 42                	jmp    801019 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 60                	cmp    $0x60,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xe4>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 7a                	cmp    $0x7a,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 57             	sub    $0x57,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 20                	jmp    801019 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 40                	cmp    $0x40,%al
  801000:	7e 39                	jle    80103b <strtol+0x126>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 5a                	cmp    $0x5a,%al
  801009:	7f 30                	jg     80103b <strtol+0x126>
			dig = *s - 'A' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 37             	sub    $0x37,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101f:	7d 19                	jge    80103a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102b:	89 c2                	mov    %eax,%edx
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801035:	e9 7b ff ff ff       	jmp    800fb5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103f:	74 08                	je     801049 <strtol+0x134>
		*endptr = (char *) s;
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104d:	74 07                	je     801056 <strtol+0x141>
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	f7 d8                	neg    %eax
  801054:	eb 03                	jmp    801059 <strtol+0x144>
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <ltostr>:

void
ltostr(long value, char *str)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801073:	79 13                	jns    801088 <ltostr+0x2d>
	{
		neg = 1;
  801075:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801082:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801085:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801090:	99                   	cltd   
  801091:	f7 f9                	idiv   %ecx
  801093:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a9:	83 c2 30             	add    $0x30,%edx
  8010ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b6:	f7 e9                	imul   %ecx
  8010b8:	c1 fa 02             	sar    $0x2,%edx
  8010bb:	89 c8                	mov    %ecx,%eax
  8010bd:	c1 f8 1f             	sar    $0x1f,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
  8010c4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	c1 e0 02             	shl    $0x2,%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	01 c0                	add    %eax,%eax
  8010e4:	29 c1                	sub    %eax,%ecx
  8010e6:	89 ca                	mov    %ecx,%edx
  8010e8:	85 d2                	test   %edx,%edx
  8010ea:	75 9c                	jne    801088 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	48                   	dec    %eax
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 3d                	je     80113d <ltostr+0xe2>
		start = 1 ;
  801100:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801107:	eb 34                	jmp    80113d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	01 c8                	add    %ecx,%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	01 c2                	add    %eax,%edx
  801132:	8a 45 eb             	mov    -0x15(%ebp),%al
  801135:	88 02                	mov    %al,(%edx)
		start++ ;
  801137:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801143:	7c c4                	jl     801109 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801145:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801150:	90                   	nop
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801159:	ff 75 08             	pushl  0x8(%ebp)
  80115c:	e8 54 fa ff ff       	call   800bb5 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	e8 46 fa ff ff       	call   800bb5 <strlen>
  80116f:	83 c4 04             	add    $0x4,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801183:	eb 17                	jmp    80119c <strcconcat+0x49>
		final[s] = str1[s] ;
  801185:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	01 c8                	add    %ecx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801199:	ff 45 fc             	incl   -0x4(%ebp)
  80119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a2:	7c e1                	jl     801185 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b2:	eb 1f                	jmp    8011d3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d0:	ff 45 f8             	incl   -0x8(%ebp)
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c d9                	jl     8011b4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f8:	8b 00                	mov    (%eax),%eax
  8011fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	eb 0c                	jmp    80121a <strsplit+0x31>
			*string++ = 0;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 08             	mov    %edx,0x8(%ebp)
  801217:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	74 18                	je     80123b <strsplit+0x52>
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f be c0             	movsbl %al,%eax
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	e8 13 fb ff ff       	call   800d47 <strchr>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 d3                	jne    80120e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	74 5a                	je     80129e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	83 f8 0f             	cmp    $0xf,%eax
  80124c:	75 07                	jne    801255 <strsplit+0x6c>
		{
			return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 66                	jmp    8012bb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 48 01             	lea    0x1(%eax),%ecx
  80125d:	8b 55 14             	mov    0x14(%ebp),%edx
  801260:	89 0a                	mov    %ecx,(%edx)
  801262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801273:	eb 03                	jmp    801278 <strsplit+0x8f>
			string++;
  801275:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	84 c0                	test   %al,%al
  80127f:	74 8b                	je     80120c <strsplit+0x23>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	50                   	push   %eax
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	e8 b5 fa ff ff       	call   800d47 <strchr>
  801292:	83 c4 08             	add    $0x8,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	74 dc                	je     801275 <strsplit+0x8c>
			string++;
	}
  801299:	e9 6e ff ff ff       	jmp    80120c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 1f                	je     8012eb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cc:	e8 1d 00 00 00       	call   8012ee <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 10 3a 80 00       	push   $0x803a10
  8012d9:	e8 55 f2 ff ff       	call   800533 <cprintf>
  8012de:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e1:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e8:	00 00 00 
	}
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8012f4:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fb:	00 00 00 
  8012fe:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801305:	00 00 00 
  801308:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80130f:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801312:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801319:	00 00 00 
  80131c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801323:	00 00 00 
  801326:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80132d:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801330:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801337:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80133a:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801341:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801350:	2d 00 10 00 00       	sub    $0x1000,%eax
  801355:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80135a:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801361:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801364:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801369:	2d 00 10 00 00       	sub    $0x1000,%eax
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	6a 06                	push   $0x6
  801373:	ff 75 f4             	pushl  -0xc(%ebp)
  801376:	50                   	push   %eax
  801377:	e8 ee 05 00 00       	call   80196a <sys_allocate_chunk>
  80137c:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80137f:	a1 20 41 80 00       	mov    0x804120,%eax
  801384:	83 ec 0c             	sub    $0xc,%esp
  801387:	50                   	push   %eax
  801388:	e8 63 0c 00 00       	call   801ff0 <initialize_MemBlocksList>
  80138d:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801390:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801395:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801398:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8013a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b3:	89 c2                	mov    %eax,%edx
  8013b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b8:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8013bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013be:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8013c5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013cf:	8b 50 08             	mov    0x8(%eax),%edx
  8013d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d5:	01 d0                	add    %edx,%eax
  8013d7:	48                   	dec    %eax
  8013d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013de:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e3:	f7 75 e0             	divl   -0x20(%ebp)
  8013e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013e9:	29 d0                	sub    %edx,%eax
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f0:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8013f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8013f7:	75 14                	jne    80140d <initialize_dyn_block_system+0x11f>
  8013f9:	83 ec 04             	sub    $0x4,%esp
  8013fc:	68 35 3a 80 00       	push   $0x803a35
  801401:	6a 34                	push   $0x34
  801403:	68 53 3a 80 00       	push   $0x803a53
  801408:	e8 72 ee ff ff       	call   80027f <_panic>
  80140d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801410:	8b 00                	mov    (%eax),%eax
  801412:	85 c0                	test   %eax,%eax
  801414:	74 10                	je     801426 <initialize_dyn_block_system+0x138>
  801416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801419:	8b 00                	mov    (%eax),%eax
  80141b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80141e:	8b 52 04             	mov    0x4(%edx),%edx
  801421:	89 50 04             	mov    %edx,0x4(%eax)
  801424:	eb 0b                	jmp    801431 <initialize_dyn_block_system+0x143>
  801426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801429:	8b 40 04             	mov    0x4(%eax),%eax
  80142c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801434:	8b 40 04             	mov    0x4(%eax),%eax
  801437:	85 c0                	test   %eax,%eax
  801439:	74 0f                	je     80144a <initialize_dyn_block_system+0x15c>
  80143b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143e:	8b 40 04             	mov    0x4(%eax),%eax
  801441:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801444:	8b 12                	mov    (%edx),%edx
  801446:	89 10                	mov    %edx,(%eax)
  801448:	eb 0a                	jmp    801454 <initialize_dyn_block_system+0x166>
  80144a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144d:	8b 00                	mov    (%eax),%eax
  80144f:	a3 48 41 80 00       	mov    %eax,0x804148
  801454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80145d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801460:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801467:	a1 54 41 80 00       	mov    0x804154,%eax
  80146c:	48                   	dec    %eax
  80146d:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801472:	83 ec 0c             	sub    $0xc,%esp
  801475:	ff 75 e8             	pushl  -0x18(%ebp)
  801478:	e8 c4 13 00 00       	call   802841 <insert_sorted_with_merge_freeList>
  80147d:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801489:	e8 2f fe ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  80148e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801492:	75 07                	jne    80149b <malloc+0x18>
  801494:	b8 00 00 00 00       	mov    $0x0,%eax
  801499:	eb 71                	jmp    80150c <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80149b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8014a2:	76 07                	jbe    8014ab <malloc+0x28>
	return NULL;
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a9:	eb 61                	jmp    80150c <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014ab:	e8 88 08 00 00       	call   801d38 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	74 53                	je     801507 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014b4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	48                   	dec    %eax
  8014c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cf:	f7 75 f4             	divl   -0xc(%ebp)
  8014d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d5:	29 d0                	sub    %edx,%eax
  8014d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8014da:	83 ec 0c             	sub    $0xc,%esp
  8014dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e0:	e8 d2 0d 00 00       	call   8022b7 <alloc_block_FF>
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8014eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014ef:	74 16                	je     801507 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8014f1:	83 ec 0c             	sub    $0xc,%esp
  8014f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8014f7:	e8 0c 0c 00 00       	call   802108 <insert_sorted_allocList>
  8014fc:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8014ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801502:	8b 40 08             	mov    0x8(%eax),%eax
  801505:	eb 05                	jmp    80150c <malloc+0x89>
    }

			}


	return NULL;
  801507:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801522:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	ff 75 f0             	pushl  -0x10(%ebp)
  80152b:	68 40 40 80 00       	push   $0x804040
  801530:	e8 a0 0b 00 00       	call   8020d5 <find_block>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80153b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153e:	8b 50 0c             	mov    0xc(%eax),%edx
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	52                   	push   %edx
  801548:	50                   	push   %eax
  801549:	e8 e4 03 00 00       	call   801932 <sys_free_user_mem>
  80154e:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801551:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801555:	75 17                	jne    80156e <free+0x60>
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	68 35 3a 80 00       	push   $0x803a35
  80155f:	68 84 00 00 00       	push   $0x84
  801564:	68 53 3a 80 00       	push   $0x803a53
  801569:	e8 11 ed ff ff       	call   80027f <_panic>
  80156e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801571:	8b 00                	mov    (%eax),%eax
  801573:	85 c0                	test   %eax,%eax
  801575:	74 10                	je     801587 <free+0x79>
  801577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157a:	8b 00                	mov    (%eax),%eax
  80157c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80157f:	8b 52 04             	mov    0x4(%edx),%edx
  801582:	89 50 04             	mov    %edx,0x4(%eax)
  801585:	eb 0b                	jmp    801592 <free+0x84>
  801587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158a:	8b 40 04             	mov    0x4(%eax),%eax
  80158d:	a3 44 40 80 00       	mov    %eax,0x804044
  801592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801595:	8b 40 04             	mov    0x4(%eax),%eax
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 0f                	je     8015ab <free+0x9d>
  80159c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159f:	8b 40 04             	mov    0x4(%eax),%eax
  8015a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015a5:	8b 12                	mov    (%edx),%edx
  8015a7:	89 10                	mov    %edx,(%eax)
  8015a9:	eb 0a                	jmp    8015b5 <free+0xa7>
  8015ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	a3 40 40 80 00       	mov    %eax,0x804040
  8015b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015cd:	48                   	dec    %eax
  8015ce:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8015d9:	e8 63 12 00 00       	call   802841 <insert_sorted_with_merge_freeList>
  8015de:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8015e1:	90                   	nop
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 38             	sub    $0x38,%esp
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f0:	e8 c8 fc ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  8015f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015f9:	75 0a                	jne    801605 <smalloc+0x21>
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801600:	e9 a0 00 00 00       	jmp    8016a5 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801605:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80160c:	76 0a                	jbe    801618 <smalloc+0x34>
		return NULL;
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
  801613:	e9 8d 00 00 00       	jmp    8016a5 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801618:	e8 1b 07 00 00       	call   801d38 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80161d:	85 c0                	test   %eax,%eax
  80161f:	74 7f                	je     8016a0 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801621:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162e:	01 d0                	add    %edx,%eax
  801630:	48                   	dec    %eax
  801631:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	ba 00 00 00 00       	mov    $0x0,%edx
  80163c:	f7 75 f4             	divl   -0xc(%ebp)
  80163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801642:	29 d0                	sub    %edx,%eax
  801644:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801647:	83 ec 0c             	sub    $0xc,%esp
  80164a:	ff 75 ec             	pushl  -0x14(%ebp)
  80164d:	e8 65 0c 00 00       	call   8022b7 <alloc_block_FF>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801658:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80165c:	74 42                	je     8016a0 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	ff 75 e8             	pushl  -0x18(%ebp)
  801664:	e8 9f 0a 00 00       	call   802108 <insert_sorted_allocList>
  801669:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80166c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80166f:	8b 40 08             	mov    0x8(%eax),%eax
  801672:	89 c2                	mov    %eax,%edx
  801674:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801678:	52                   	push   %edx
  801679:	50                   	push   %eax
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	ff 75 08             	pushl  0x8(%ebp)
  801680:	e8 38 04 00 00       	call   801abd <sys_createSharedObject>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  80168b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80168f:	79 07                	jns    801698 <smalloc+0xb4>
	    		  return NULL;
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
  801696:	eb 0d                	jmp    8016a5 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801698:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80169b:	8b 40 08             	mov    0x8(%eax),%eax
  80169e:	eb 05                	jmp    8016a5 <smalloc+0xc1>


				}


		return NULL;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ad:	e8 0b fc ff ff       	call   8012bd <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016b2:	e8 81 06 00 00       	call   801d38 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	0f 84 9f 00 00 00    	je     80175e <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	ff 75 08             	pushl  0x8(%ebp)
  8016c8:	e8 1a 04 00 00       	call   801ae7 <sys_getSizeOfSharedObject>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8016d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d7:	79 0a                	jns    8016e3 <sget+0x3c>
		return NULL;
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016de:	e9 80 00 00 00       	jmp    801763 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016e3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	48                   	dec    %eax
  8016f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fe:	f7 75 f0             	divl   -0x10(%ebp)
  801701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801704:	29 d0                	sub    %edx,%eax
  801706:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801709:	83 ec 0c             	sub    $0xc,%esp
  80170c:	ff 75 e8             	pushl  -0x18(%ebp)
  80170f:	e8 a3 0b 00 00       	call   8022b7 <alloc_block_FF>
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80171a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80171e:	74 3e                	je     80175e <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801720:	83 ec 0c             	sub    $0xc,%esp
  801723:	ff 75 e4             	pushl  -0x1c(%ebp)
  801726:	e8 dd 09 00 00       	call   802108 <insert_sorted_allocList>
  80172b:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80172e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801731:	8b 40 08             	mov    0x8(%eax),%eax
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	50                   	push   %eax
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	e8 c1 03 00 00       	call   801b04 <sys_getSharedObject>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80174d:	79 07                	jns    801756 <sget+0xaf>
	    		  return NULL;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
  801754:	eb 0d                	jmp    801763 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801759:	8b 40 08             	mov    0x8(%eax),%eax
  80175c:	eb 05                	jmp    801763 <sget+0xbc>
	      }
	}
	   return NULL;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176b:	e8 4d fb ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	68 60 3a 80 00       	push   $0x803a60
  801778:	68 12 01 00 00       	push   $0x112
  80177d:	68 53 3a 80 00       	push   $0x803a53
  801782:	e8 f8 ea ff ff       	call   80027f <_panic>

00801787 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 88 3a 80 00       	push   $0x803a88
  801795:	68 26 01 00 00       	push   $0x126
  80179a:	68 53 3a 80 00       	push   $0x803a53
  80179f:	e8 db ea ff ff       	call   80027f <_panic>

008017a4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 ac 3a 80 00       	push   $0x803aac
  8017b2:	68 31 01 00 00       	push   $0x131
  8017b7:	68 53 3a 80 00       	push   $0x803a53
  8017bc:	e8 be ea ff ff       	call   80027f <_panic>

008017c1 <shrink>:

}
void shrink(uint32 newSize)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 ac 3a 80 00       	push   $0x803aac
  8017cf:	68 36 01 00 00       	push   $0x136
  8017d4:	68 53 3a 80 00       	push   $0x803a53
  8017d9:	e8 a1 ea ff ff       	call   80027f <_panic>

008017de <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	68 ac 3a 80 00       	push   $0x803aac
  8017ec:	68 3b 01 00 00       	push   $0x13b
  8017f1:	68 53 3a 80 00       	push   $0x803a53
  8017f6:	e8 84 ea ff ff       	call   80027f <_panic>

008017fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	57                   	push   %edi
  8017ff:	56                   	push   %esi
  801800:	53                   	push   %ebx
  801801:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801810:	8b 7d 18             	mov    0x18(%ebp),%edi
  801813:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801816:	cd 30                	int    $0x30
  801818:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80181b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	5b                   	pop    %ebx
  801822:	5e                   	pop    %esi
  801823:	5f                   	pop    %edi
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	8b 45 10             	mov    0x10(%ebp),%eax
  80182f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801832:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	52                   	push   %edx
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	50                   	push   %eax
  801842:	6a 00                	push   $0x0
  801844:	e8 b2 ff ff ff       	call   8017fb <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	90                   	nop
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_cgetc>:

int
sys_cgetc(void)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 01                	push   $0x1
  80185e:	e8 98 ff ff ff       	call   8017fb <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80186b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	52                   	push   %edx
  801878:	50                   	push   %eax
  801879:	6a 05                	push   $0x5
  80187b:	e8 7b ff ff ff       	call   8017fb <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	56                   	push   %esi
  801889:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80188a:	8b 75 18             	mov    0x18(%ebp),%esi
  80188d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801890:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	56                   	push   %esi
  80189a:	53                   	push   %ebx
  80189b:	51                   	push   %ecx
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	6a 06                	push   $0x6
  8018a0:	e8 56 ff ff ff       	call   8017fb <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ab:	5b                   	pop    %ebx
  8018ac:	5e                   	pop    %esi
  8018ad:	5d                   	pop    %ebp
  8018ae:	c3                   	ret    

008018af <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	6a 07                	push   $0x7
  8018c2:	e8 34 ff ff ff       	call   8017fb <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	6a 08                	push   $0x8
  8018dd:	e8 19 ff ff ff       	call   8017fb <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 09                	push   $0x9
  8018f6:	e8 00 ff ff ff       	call   8017fb <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 0a                	push   $0xa
  80190f:	e8 e7 fe ff ff       	call   8017fb <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 0b                	push   $0xb
  801928:	e8 ce fe ff ff       	call   8017fb <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	6a 0f                	push   $0xf
  801943:	e8 b3 fe ff ff       	call   8017fb <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
	return;
  80194b:	90                   	nop
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	6a 10                	push   $0x10
  80195f:	e8 97 fe ff ff       	call   8017fb <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
	return ;
  801967:	90                   	nop
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	ff 75 10             	pushl  0x10(%ebp)
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	6a 11                	push   $0x11
  80197c:	e8 7a fe ff ff       	call   8017fb <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
	return ;
  801984:	90                   	nop
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 0c                	push   $0xc
  801996:	e8 60 fe ff ff       	call   8017fb <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 08             	pushl  0x8(%ebp)
  8019ae:	6a 0d                	push   $0xd
  8019b0:	e8 46 fe ff ff       	call   8017fb <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 0e                	push   $0xe
  8019c9:	e8 2d fe ff ff       	call   8017fb <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 13                	push   $0x13
  8019e3:	e8 13 fe ff ff       	call   8017fb <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	90                   	nop
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 14                	push   $0x14
  8019fd:	e8 f9 fd ff ff       	call   8017fb <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	90                   	nop
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a14:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	50                   	push   %eax
  801a21:	6a 15                	push   $0x15
  801a23:	e8 d3 fd ff ff       	call   8017fb <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 16                	push   $0x16
  801a3d:	e8 b9 fd ff ff       	call   8017fb <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	90                   	nop
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	50                   	push   %eax
  801a58:	6a 17                	push   $0x17
  801a5a:	e8 9c fd ff ff       	call   8017fb <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	52                   	push   %edx
  801a74:	50                   	push   %eax
  801a75:	6a 1a                	push   $0x1a
  801a77:	e8 7f fd ff ff       	call   8017fb <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 18                	push   $0x18
  801a94:	e8 62 fd ff ff       	call   8017fb <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	90                   	nop
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	52                   	push   %edx
  801aaf:	50                   	push   %eax
  801ab0:	6a 19                	push   $0x19
  801ab2:	e8 44 fd ff ff       	call   8017fb <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	90                   	nop
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801acc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	6a 00                	push   $0x0
  801ad5:	51                   	push   %ecx
  801ad6:	52                   	push   %edx
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	50                   	push   %eax
  801adb:	6a 1b                	push   $0x1b
  801add:	e8 19 fd ff ff       	call   8017fb <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	52                   	push   %edx
  801af7:	50                   	push   %eax
  801af8:	6a 1c                	push   $0x1c
  801afa:	e8 fc fc ff ff       	call   8017fb <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	51                   	push   %ecx
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 1d                	push   $0x1d
  801b19:	e8 dd fc ff ff       	call   8017fb <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	52                   	push   %edx
  801b33:	50                   	push   %eax
  801b34:	6a 1e                	push   $0x1e
  801b36:	e8 c0 fc ff ff       	call   8017fb <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 1f                	push   $0x1f
  801b4f:	e8 a7 fc ff ff       	call   8017fb <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	ff 75 14             	pushl  0x14(%ebp)
  801b64:	ff 75 10             	pushl  0x10(%ebp)
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	50                   	push   %eax
  801b6b:	6a 20                	push   $0x20
  801b6d:	e8 89 fc ff ff       	call   8017fb <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	50                   	push   %eax
  801b86:	6a 21                	push   $0x21
  801b88:	e8 6e fc ff ff       	call   8017fb <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	90                   	nop
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	50                   	push   %eax
  801ba2:	6a 22                	push   $0x22
  801ba4:	e8 52 fc ff ff       	call   8017fb <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 02                	push   $0x2
  801bbd:	e8 39 fc ff ff       	call   8017fb <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 03                	push   $0x3
  801bd6:	e8 20 fc ff ff       	call   8017fb <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 04                	push   $0x4
  801bef:	e8 07 fc ff ff       	call   8017fb <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 23                	push   $0x23
  801c08:	e8 ee fb ff ff       	call   8017fb <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	90                   	nop
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c19:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1c:	8d 50 04             	lea    0x4(%eax),%edx
  801c1f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	52                   	push   %edx
  801c29:	50                   	push   %eax
  801c2a:	6a 24                	push   $0x24
  801c2c:	e8 ca fb ff ff       	call   8017fb <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return result;
  801c34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c3d:	89 01                	mov    %eax,(%ecx)
  801c3f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	c9                   	leave  
  801c46:	c2 04 00             	ret    $0x4

00801c49 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	ff 75 10             	pushl  0x10(%ebp)
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	6a 12                	push   $0x12
  801c5b:	e8 9b fb ff ff       	call   8017fb <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
	return ;
  801c63:	90                   	nop
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 25                	push   $0x25
  801c75:	e8 81 fb ff ff       	call   8017fb <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 04             	sub    $0x4,%esp
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c8b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	50                   	push   %eax
  801c98:	6a 26                	push   $0x26
  801c9a:	e8 5c fb ff ff       	call   8017fb <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca2:	90                   	nop
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <rsttst>:
void rsttst()
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 28                	push   $0x28
  801cb4:	e8 42 fb ff ff       	call   8017fb <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbc:	90                   	nop
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ccb:	8b 55 18             	mov    0x18(%ebp),%edx
  801cce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd2:	52                   	push   %edx
  801cd3:	50                   	push   %eax
  801cd4:	ff 75 10             	pushl  0x10(%ebp)
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	ff 75 08             	pushl  0x8(%ebp)
  801cdd:	6a 27                	push   $0x27
  801cdf:	e8 17 fb ff ff       	call   8017fb <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce7:	90                   	nop
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <chktst>:
void chktst(uint32 n)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	ff 75 08             	pushl  0x8(%ebp)
  801cf8:	6a 29                	push   $0x29
  801cfa:	e8 fc fa ff ff       	call   8017fb <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
	return ;
  801d02:	90                   	nop
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <inctst>:

void inctst()
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 2a                	push   $0x2a
  801d14:	e8 e2 fa ff ff       	call   8017fb <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1c:	90                   	nop
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <gettst>:
uint32 gettst()
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 2b                	push   $0x2b
  801d2e:	e8 c8 fa ff ff       	call   8017fb <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 2c                	push   $0x2c
  801d4a:	e8 ac fa ff ff       	call   8017fb <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
  801d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d55:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d59:	75 07                	jne    801d62 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d60:	eb 05                	jmp    801d67 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 2c                	push   $0x2c
  801d7b:	e8 7b fa ff ff       	call   8017fb <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
  801d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d86:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d8a:	75 07                	jne    801d93 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d91:	eb 05                	jmp    801d98 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 2c                	push   $0x2c
  801dac:	e8 4a fa ff ff       	call   8017fb <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
  801db4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dbb:	75 07                	jne    801dc4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc2:	eb 05                	jmp    801dc9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 2c                	push   $0x2c
  801ddd:	e8 19 fa ff ff       	call   8017fb <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
  801de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dec:	75 07                	jne    801df5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	eb 05                	jmp    801dfa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	ff 75 08             	pushl  0x8(%ebp)
  801e0a:	6a 2d                	push   $0x2d
  801e0c:	e8 ea f9 ff ff       	call   8017fb <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
	return ;
  801e14:	90                   	nop
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e1b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	53                   	push   %ebx
  801e2a:	51                   	push   %ecx
  801e2b:	52                   	push   %edx
  801e2c:	50                   	push   %eax
  801e2d:	6a 2e                	push   $0x2e
  801e2f:	e8 c7 f9 ff ff       	call   8017fb <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	52                   	push   %edx
  801e4c:	50                   	push   %eax
  801e4d:	6a 2f                	push   $0x2f
  801e4f:	e8 a7 f9 ff ff       	call   8017fb <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e5f:	83 ec 0c             	sub    $0xc,%esp
  801e62:	68 bc 3a 80 00       	push   $0x803abc
  801e67:	e8 c7 e6 ff ff       	call   800533 <cprintf>
  801e6c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	68 e8 3a 80 00       	push   $0x803ae8
  801e7e:	e8 b0 e6 ff ff       	call   800533 <cprintf>
  801e83:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e86:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e8a:	a1 38 41 80 00       	mov    0x804138,%eax
  801e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e92:	eb 56                	jmp    801eea <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e98:	74 1c                	je     801eb6 <print_mem_block_lists+0x5d>
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	8b 50 08             	mov    0x8(%eax),%edx
  801ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea3:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea9:	8b 40 0c             	mov    0xc(%eax),%eax
  801eac:	01 c8                	add    %ecx,%eax
  801eae:	39 c2                	cmp    %eax,%edx
  801eb0:	73 04                	jae    801eb6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eb2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	8b 50 08             	mov    0x8(%eax),%edx
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec2:	01 c2                	add    %eax,%edx
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	8b 40 08             	mov    0x8(%eax),%eax
  801eca:	83 ec 04             	sub    $0x4,%esp
  801ecd:	52                   	push   %edx
  801ece:	50                   	push   %eax
  801ecf:	68 fd 3a 80 00       	push   $0x803afd
  801ed4:	e8 5a e6 ff ff       	call   800533 <cprintf>
  801ed9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee2:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eee:	74 07                	je     801ef7 <print_mem_block_lists+0x9e>
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	8b 00                	mov    (%eax),%eax
  801ef5:	eb 05                	jmp    801efc <print_mem_block_lists+0xa3>
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	a3 40 41 80 00       	mov    %eax,0x804140
  801f01:	a1 40 41 80 00       	mov    0x804140,%eax
  801f06:	85 c0                	test   %eax,%eax
  801f08:	75 8a                	jne    801e94 <print_mem_block_lists+0x3b>
  801f0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0e:	75 84                	jne    801e94 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f10:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f14:	75 10                	jne    801f26 <print_mem_block_lists+0xcd>
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	68 0c 3b 80 00       	push   $0x803b0c
  801f1e:	e8 10 e6 ff ff       	call   800533 <cprintf>
  801f23:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f2d:	83 ec 0c             	sub    $0xc,%esp
  801f30:	68 30 3b 80 00       	push   $0x803b30
  801f35:	e8 f9 e5 ff ff       	call   800533 <cprintf>
  801f3a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f3d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f41:	a1 40 40 80 00       	mov    0x804040,%eax
  801f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f49:	eb 56                	jmp    801fa1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4f:	74 1c                	je     801f6d <print_mem_block_lists+0x114>
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	8b 50 08             	mov    0x8(%eax),%edx
  801f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	8b 40 0c             	mov    0xc(%eax),%eax
  801f63:	01 c8                	add    %ecx,%eax
  801f65:	39 c2                	cmp    %eax,%edx
  801f67:	73 04                	jae    801f6d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f69:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	8b 50 08             	mov    0x8(%eax),%edx
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 40 0c             	mov    0xc(%eax),%eax
  801f79:	01 c2                	add    %eax,%edx
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	8b 40 08             	mov    0x8(%eax),%eax
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	52                   	push   %edx
  801f85:	50                   	push   %eax
  801f86:	68 fd 3a 80 00       	push   $0x803afd
  801f8b:	e8 a3 e5 ff ff       	call   800533 <cprintf>
  801f90:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f99:	a1 48 40 80 00       	mov    0x804048,%eax
  801f9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa5:	74 07                	je     801fae <print_mem_block_lists+0x155>
  801fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faa:	8b 00                	mov    (%eax),%eax
  801fac:	eb 05                	jmp    801fb3 <print_mem_block_lists+0x15a>
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb3:	a3 48 40 80 00       	mov    %eax,0x804048
  801fb8:	a1 48 40 80 00       	mov    0x804048,%eax
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	75 8a                	jne    801f4b <print_mem_block_lists+0xf2>
  801fc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc5:	75 84                	jne    801f4b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fc7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fcb:	75 10                	jne    801fdd <print_mem_block_lists+0x184>
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	68 48 3b 80 00       	push   $0x803b48
  801fd5:	e8 59 e5 ff ff       	call   800533 <cprintf>
  801fda:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	68 bc 3a 80 00       	push   $0x803abc
  801fe5:	e8 49 e5 ff ff       	call   800533 <cprintf>
  801fea:	83 c4 10             	add    $0x10,%esp

}
  801fed:	90                   	nop
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801ff6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ffd:	00 00 00 
  802000:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802007:	00 00 00 
  80200a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802011:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802014:	a1 50 40 80 00       	mov    0x804050,%eax
  802019:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80201c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802023:	e9 9e 00 00 00       	jmp    8020c6 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802028:	a1 50 40 80 00       	mov    0x804050,%eax
  80202d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802030:	c1 e2 04             	shl    $0x4,%edx
  802033:	01 d0                	add    %edx,%eax
  802035:	85 c0                	test   %eax,%eax
  802037:	75 14                	jne    80204d <initialize_MemBlocksList+0x5d>
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 70 3b 80 00       	push   $0x803b70
  802041:	6a 48                	push   $0x48
  802043:	68 93 3b 80 00       	push   $0x803b93
  802048:	e8 32 e2 ff ff       	call   80027f <_panic>
  80204d:	a1 50 40 80 00       	mov    0x804050,%eax
  802052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802055:	c1 e2 04             	shl    $0x4,%edx
  802058:	01 d0                	add    %edx,%eax
  80205a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802060:	89 10                	mov    %edx,(%eax)
  802062:	8b 00                	mov    (%eax),%eax
  802064:	85 c0                	test   %eax,%eax
  802066:	74 18                	je     802080 <initialize_MemBlocksList+0x90>
  802068:	a1 48 41 80 00       	mov    0x804148,%eax
  80206d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802073:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802076:	c1 e1 04             	shl    $0x4,%ecx
  802079:	01 ca                	add    %ecx,%edx
  80207b:	89 50 04             	mov    %edx,0x4(%eax)
  80207e:	eb 12                	jmp    802092 <initialize_MemBlocksList+0xa2>
  802080:	a1 50 40 80 00       	mov    0x804050,%eax
  802085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802088:	c1 e2 04             	shl    $0x4,%edx
  80208b:	01 d0                	add    %edx,%eax
  80208d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802092:	a1 50 40 80 00       	mov    0x804050,%eax
  802097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209a:	c1 e2 04             	shl    $0x4,%edx
  80209d:	01 d0                	add    %edx,%eax
  80209f:	a3 48 41 80 00       	mov    %eax,0x804148
  8020a4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ac:	c1 e2 04             	shl    $0x4,%edx
  8020af:	01 d0                	add    %edx,%eax
  8020b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b8:	a1 54 41 80 00       	mov    0x804154,%eax
  8020bd:	40                   	inc    %eax
  8020be:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8020c3:	ff 45 f4             	incl   -0xc(%ebp)
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020cc:	0f 82 56 ff ff ff    	jb     802028 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8020e3:	eb 18                	jmp    8020fd <find_block+0x28>
		{
			if(tmp->sva==va)
  8020e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e8:	8b 40 08             	mov    0x8(%eax),%eax
  8020eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020ee:	75 05                	jne    8020f5 <find_block+0x20>
			{
				return tmp;
  8020f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f3:	eb 11                	jmp    802106 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8020f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f8:	8b 00                	mov    (%eax),%eax
  8020fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8020fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802101:	75 e2                	jne    8020e5 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802103:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80210e:	a1 40 40 80 00       	mov    0x804040,%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	0f 85 83 00 00 00    	jne    80219e <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80211b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802122:	00 00 00 
  802125:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80212c:	00 00 00 
  80212f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802136:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802139:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80213d:	75 14                	jne    802153 <insert_sorted_allocList+0x4b>
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	68 70 3b 80 00       	push   $0x803b70
  802147:	6a 7f                	push   $0x7f
  802149:	68 93 3b 80 00       	push   $0x803b93
  80214e:	e8 2c e1 ff ff       	call   80027f <_panic>
  802153:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	89 10                	mov    %edx,(%eax)
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8b 00                	mov    (%eax),%eax
  802163:	85 c0                	test   %eax,%eax
  802165:	74 0d                	je     802174 <insert_sorted_allocList+0x6c>
  802167:	a1 40 40 80 00       	mov    0x804040,%eax
  80216c:	8b 55 08             	mov    0x8(%ebp),%edx
  80216f:	89 50 04             	mov    %edx,0x4(%eax)
  802172:	eb 08                	jmp    80217c <insert_sorted_allocList+0x74>
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	a3 44 40 80 00       	mov    %eax,0x804044
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	a3 40 40 80 00       	mov    %eax,0x804040
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802193:	40                   	inc    %eax
  802194:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802199:	e9 16 01 00 00       	jmp    8022b4 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	8b 50 08             	mov    0x8(%eax),%edx
  8021a4:	a1 44 40 80 00       	mov    0x804044,%eax
  8021a9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ac:	39 c2                	cmp    %eax,%edx
  8021ae:	76 68                	jbe    802218 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b4:	75 17                	jne    8021cd <insert_sorted_allocList+0xc5>
  8021b6:	83 ec 04             	sub    $0x4,%esp
  8021b9:	68 ac 3b 80 00       	push   $0x803bac
  8021be:	68 85 00 00 00       	push   $0x85
  8021c3:	68 93 3b 80 00       	push   $0x803b93
  8021c8:	e8 b2 e0 ff ff       	call   80027f <_panic>
  8021cd:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	89 50 04             	mov    %edx,0x4(%eax)
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	8b 40 04             	mov    0x4(%eax),%eax
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	74 0c                	je     8021ef <insert_sorted_allocList+0xe7>
  8021e3:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021eb:	89 10                	mov    %edx,(%eax)
  8021ed:	eb 08                	jmp    8021f7 <insert_sorted_allocList+0xef>
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802208:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80220d:	40                   	inc    %eax
  80220e:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802213:	e9 9c 00 00 00       	jmp    8022b4 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802218:	a1 40 40 80 00       	mov    0x804040,%eax
  80221d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802220:	e9 85 00 00 00       	jmp    8022aa <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	8b 50 08             	mov    0x8(%eax),%edx
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	8b 40 08             	mov    0x8(%eax),%eax
  802231:	39 c2                	cmp    %eax,%edx
  802233:	73 6d                	jae    8022a2 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802239:	74 06                	je     802241 <insert_sorted_allocList+0x139>
  80223b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223f:	75 17                	jne    802258 <insert_sorted_allocList+0x150>
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	68 d0 3b 80 00       	push   $0x803bd0
  802249:	68 90 00 00 00       	push   $0x90
  80224e:	68 93 3b 80 00       	push   $0x803b93
  802253:	e8 27 e0 ff ff       	call   80027f <_panic>
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 50 04             	mov    0x4(%eax),%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	89 50 04             	mov    %edx,0x4(%eax)
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226a:	89 10                	mov    %edx,(%eax)
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 40 04             	mov    0x4(%eax),%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	74 0d                	je     802283 <insert_sorted_allocList+0x17b>
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 40 04             	mov    0x4(%eax),%eax
  80227c:	8b 55 08             	mov    0x8(%ebp),%edx
  80227f:	89 10                	mov    %edx,(%eax)
  802281:	eb 08                	jmp    80228b <insert_sorted_allocList+0x183>
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	a3 40 40 80 00       	mov    %eax,0x804040
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 55 08             	mov    0x8(%ebp),%edx
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802299:	40                   	inc    %eax
  80229a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80229f:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022a0:	eb 12                	jmp    8022b4 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ae:	0f 85 71 ff ff ff    	jne    802225 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022b4:	90                   	nop
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8022bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8022c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8022c5:	e9 76 01 00 00       	jmp    802440 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d3:	0f 85 8a 00 00 00    	jne    802363 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8022d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022dd:	75 17                	jne    8022f6 <alloc_block_FF+0x3f>
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	68 05 3c 80 00       	push   $0x803c05
  8022e7:	68 a8 00 00 00       	push   $0xa8
  8022ec:	68 93 3b 80 00       	push   $0x803b93
  8022f1:	e8 89 df ff ff       	call   80027f <_panic>
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 00                	mov    (%eax),%eax
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	74 10                	je     80230f <alloc_block_FF+0x58>
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 00                	mov    (%eax),%eax
  802304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802307:	8b 52 04             	mov    0x4(%edx),%edx
  80230a:	89 50 04             	mov    %edx,0x4(%eax)
  80230d:	eb 0b                	jmp    80231a <alloc_block_FF+0x63>
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 40 04             	mov    0x4(%eax),%eax
  802315:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	8b 40 04             	mov    0x4(%eax),%eax
  802320:	85 c0                	test   %eax,%eax
  802322:	74 0f                	je     802333 <alloc_block_FF+0x7c>
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 40 04             	mov    0x4(%eax),%eax
  80232a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232d:	8b 12                	mov    (%edx),%edx
  80232f:	89 10                	mov    %edx,(%eax)
  802331:	eb 0a                	jmp    80233d <alloc_block_FF+0x86>
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 00                	mov    (%eax),%eax
  802338:	a3 38 41 80 00       	mov    %eax,0x804138
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802350:	a1 44 41 80 00       	mov    0x804144,%eax
  802355:	48                   	dec    %eax
  802356:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	e9 ea 00 00 00       	jmp    80244d <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 40 0c             	mov    0xc(%eax),%eax
  802369:	3b 45 08             	cmp    0x8(%ebp),%eax
  80236c:	0f 86 c6 00 00 00    	jbe    802438 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802372:	a1 48 41 80 00       	mov    0x804148,%eax
  802377:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	8b 55 08             	mov    0x8(%ebp),%edx
  802380:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 50 08             	mov    0x8(%eax),%edx
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 40 0c             	mov    0xc(%eax),%eax
  802395:	2b 45 08             	sub    0x8(%ebp),%eax
  802398:	89 c2                	mov    %eax,%edx
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 50 08             	mov    0x8(%eax),%edx
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	01 c2                	add    %eax,%edx
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b5:	75 17                	jne    8023ce <alloc_block_FF+0x117>
  8023b7:	83 ec 04             	sub    $0x4,%esp
  8023ba:	68 05 3c 80 00       	push   $0x803c05
  8023bf:	68 b6 00 00 00       	push   $0xb6
  8023c4:	68 93 3b 80 00       	push   $0x803b93
  8023c9:	e8 b1 de ff ff       	call   80027f <_panic>
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	74 10                	je     8023e7 <alloc_block_FF+0x130>
  8023d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023df:	8b 52 04             	mov    0x4(%edx),%edx
  8023e2:	89 50 04             	mov    %edx,0x4(%eax)
  8023e5:	eb 0b                	jmp    8023f2 <alloc_block_FF+0x13b>
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	8b 40 04             	mov    0x4(%eax),%eax
  8023ed:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 0f                	je     80240b <alloc_block_FF+0x154>
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802405:	8b 12                	mov    (%edx),%edx
  802407:	89 10                	mov    %edx,(%eax)
  802409:	eb 0a                	jmp    802415 <alloc_block_FF+0x15e>
  80240b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	a3 48 41 80 00       	mov    %eax,0x804148
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802421:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802428:	a1 54 41 80 00       	mov    0x804154,%eax
  80242d:	48                   	dec    %eax
  80242e:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802436:	eb 15                	jmp    80244d <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802444:	0f 85 80 fe ff ff    	jne    8022ca <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802455:	a1 38 41 80 00       	mov    0x804138,%eax
  80245a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80245d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802464:	e9 c0 00 00 00       	jmp    802529 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 40 0c             	mov    0xc(%eax),%eax
  80246f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802472:	0f 85 8a 00 00 00    	jne    802502 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247c:	75 17                	jne    802495 <alloc_block_BF+0x46>
  80247e:	83 ec 04             	sub    $0x4,%esp
  802481:	68 05 3c 80 00       	push   $0x803c05
  802486:	68 cf 00 00 00       	push   $0xcf
  80248b:	68 93 3b 80 00       	push   $0x803b93
  802490:	e8 ea dd ff ff       	call   80027f <_panic>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 00                	mov    (%eax),%eax
  80249a:	85 c0                	test   %eax,%eax
  80249c:	74 10                	je     8024ae <alloc_block_BF+0x5f>
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 00                	mov    (%eax),%eax
  8024a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a6:	8b 52 04             	mov    0x4(%edx),%edx
  8024a9:	89 50 04             	mov    %edx,0x4(%eax)
  8024ac:	eb 0b                	jmp    8024b9 <alloc_block_BF+0x6a>
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 40 04             	mov    0x4(%eax),%eax
  8024b4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 04             	mov    0x4(%eax),%eax
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	74 0f                	je     8024d2 <alloc_block_BF+0x83>
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 40 04             	mov    0x4(%eax),%eax
  8024c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cc:	8b 12                	mov    (%edx),%edx
  8024ce:	89 10                	mov    %edx,(%eax)
  8024d0:	eb 0a                	jmp    8024dc <alloc_block_BF+0x8d>
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ef:	a1 44 41 80 00       	mov    0x804144,%eax
  8024f4:	48                   	dec    %eax
  8024f5:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	e9 2a 01 00 00       	jmp    80262c <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 40 0c             	mov    0xc(%eax),%eax
  802508:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80250b:	73 14                	jae    802521 <alloc_block_BF+0xd2>
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 40 0c             	mov    0xc(%eax),%eax
  802513:	3b 45 08             	cmp    0x8(%ebp),%eax
  802516:	76 09                	jbe    802521 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 0c             	mov    0xc(%eax),%eax
  80251e:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252d:	0f 85 36 ff ff ff    	jne    802469 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802533:	a1 38 41 80 00       	mov    0x804138,%eax
  802538:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80253b:	e9 dd 00 00 00       	jmp    80261d <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 0c             	mov    0xc(%eax),%eax
  802546:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802549:	0f 85 c6 00 00 00    	jne    802615 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80254f:	a1 48 41 80 00       	mov    0x804148,%eax
  802554:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 50 08             	mov    0x8(%eax),%edx
  80255d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802560:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802566:	8b 55 08             	mov    0x8(%ebp),%edx
  802569:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 50 08             	mov    0x8(%eax),%edx
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	01 c2                	add    %eax,%edx
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 40 0c             	mov    0xc(%eax),%eax
  802583:	2b 45 08             	sub    0x8(%ebp),%eax
  802586:	89 c2                	mov    %eax,%edx
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80258e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802592:	75 17                	jne    8025ab <alloc_block_BF+0x15c>
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	68 05 3c 80 00       	push   $0x803c05
  80259c:	68 eb 00 00 00       	push   $0xeb
  8025a1:	68 93 3b 80 00       	push   $0x803b93
  8025a6:	e8 d4 dc ff ff       	call   80027f <_panic>
  8025ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	74 10                	je     8025c4 <alloc_block_BF+0x175>
  8025b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b7:	8b 00                	mov    (%eax),%eax
  8025b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025bc:	8b 52 04             	mov    0x4(%edx),%edx
  8025bf:	89 50 04             	mov    %edx,0x4(%eax)
  8025c2:	eb 0b                	jmp    8025cf <alloc_block_BF+0x180>
  8025c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d2:	8b 40 04             	mov    0x4(%eax),%eax
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 0f                	je     8025e8 <alloc_block_BF+0x199>
  8025d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dc:	8b 40 04             	mov    0x4(%eax),%eax
  8025df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e2:	8b 12                	mov    (%edx),%edx
  8025e4:	89 10                	mov    %edx,(%eax)
  8025e6:	eb 0a                	jmp    8025f2 <alloc_block_BF+0x1a3>
  8025e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	a3 48 41 80 00       	mov    %eax,0x804148
  8025f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802605:	a1 54 41 80 00       	mov    0x804154,%eax
  80260a:	48                   	dec    %eax
  80260b:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802613:	eb 17                	jmp    80262c <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80261d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802621:	0f 85 19 ff ff ff    	jne    802540 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802627:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802634:	a1 40 40 80 00       	mov    0x804040,%eax
  802639:	85 c0                	test   %eax,%eax
  80263b:	75 19                	jne    802656 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80263d:	83 ec 0c             	sub    $0xc,%esp
  802640:	ff 75 08             	pushl  0x8(%ebp)
  802643:	e8 6f fc ff ff       	call   8022b7 <alloc_block_FF>
  802648:	83 c4 10             	add    $0x10,%esp
  80264b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	e9 e9 01 00 00       	jmp    80283f <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802656:	a1 44 40 80 00       	mov    0x804044,%eax
  80265b:	8b 40 08             	mov    0x8(%eax),%eax
  80265e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802661:	a1 44 40 80 00       	mov    0x804044,%eax
  802666:	8b 50 0c             	mov    0xc(%eax),%edx
  802669:	a1 44 40 80 00       	mov    0x804044,%eax
  80266e:	8b 40 08             	mov    0x8(%eax),%eax
  802671:	01 d0                	add    %edx,%eax
  802673:	83 ec 08             	sub    $0x8,%esp
  802676:	50                   	push   %eax
  802677:	68 38 41 80 00       	push   $0x804138
  80267c:	e8 54 fa ff ff       	call   8020d5 <find_block>
  802681:	83 c4 10             	add    $0x10,%esp
  802684:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 40 0c             	mov    0xc(%eax),%eax
  80268d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802690:	0f 85 9b 00 00 00    	jne    802731 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 50 0c             	mov    0xc(%eax),%edx
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 40 08             	mov    0x8(%eax),%eax
  8026a2:	01 d0                	add    %edx,%eax
  8026a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8026a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ab:	75 17                	jne    8026c4 <alloc_block_NF+0x96>
  8026ad:	83 ec 04             	sub    $0x4,%esp
  8026b0:	68 05 3c 80 00       	push   $0x803c05
  8026b5:	68 1a 01 00 00       	push   $0x11a
  8026ba:	68 93 3b 80 00       	push   $0x803b93
  8026bf:	e8 bb db ff ff       	call   80027f <_panic>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 10                	je     8026dd <alloc_block_NF+0xaf>
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 00                	mov    (%eax),%eax
  8026d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d5:	8b 52 04             	mov    0x4(%edx),%edx
  8026d8:	89 50 04             	mov    %edx,0x4(%eax)
  8026db:	eb 0b                	jmp    8026e8 <alloc_block_NF+0xba>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 04             	mov    0x4(%eax),%eax
  8026e3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 40 04             	mov    0x4(%eax),%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	74 0f                	je     802701 <alloc_block_NF+0xd3>
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 04             	mov    0x4(%eax),%eax
  8026f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fb:	8b 12                	mov    (%edx),%edx
  8026fd:	89 10                	mov    %edx,(%eax)
  8026ff:	eb 0a                	jmp    80270b <alloc_block_NF+0xdd>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	a3 38 41 80 00       	mov    %eax,0x804138
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271e:	a1 44 41 80 00       	mov    0x804144,%eax
  802723:	48                   	dec    %eax
  802724:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	e9 0e 01 00 00       	jmp    80283f <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 40 0c             	mov    0xc(%eax),%eax
  802737:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273a:	0f 86 cf 00 00 00    	jbe    80280f <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802740:	a1 48 41 80 00       	mov    0x804148,%eax
  802745:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274b:	8b 55 08             	mov    0x8(%ebp),%edx
  80274e:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 50 08             	mov    0x8(%eax),%edx
  802757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275a:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 50 08             	mov    0x8(%eax),%edx
  802763:	8b 45 08             	mov    0x8(%ebp),%eax
  802766:	01 c2                	add    %eax,%edx
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 40 0c             	mov    0xc(%eax),%eax
  802774:	2b 45 08             	sub    0x8(%ebp),%eax
  802777:	89 c2                	mov    %eax,%edx
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 08             	mov    0x8(%eax),%eax
  802785:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802788:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80278c:	75 17                	jne    8027a5 <alloc_block_NF+0x177>
  80278e:	83 ec 04             	sub    $0x4,%esp
  802791:	68 05 3c 80 00       	push   $0x803c05
  802796:	68 28 01 00 00       	push   $0x128
  80279b:	68 93 3b 80 00       	push   $0x803b93
  8027a0:	e8 da da ff ff       	call   80027f <_panic>
  8027a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 10                	je     8027be <alloc_block_NF+0x190>
  8027ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b1:	8b 00                	mov    (%eax),%eax
  8027b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b6:	8b 52 04             	mov    0x4(%edx),%edx
  8027b9:	89 50 04             	mov    %edx,0x4(%eax)
  8027bc:	eb 0b                	jmp    8027c9 <alloc_block_NF+0x19b>
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cc:	8b 40 04             	mov    0x4(%eax),%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	74 0f                	je     8027e2 <alloc_block_NF+0x1b4>
  8027d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027dc:	8b 12                	mov    (%edx),%edx
  8027de:	89 10                	mov    %edx,(%eax)
  8027e0:	eb 0a                	jmp    8027ec <alloc_block_NF+0x1be>
  8027e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	a3 48 41 80 00       	mov    %eax,0x804148
  8027ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ff:	a1 54 41 80 00       	mov    0x804154,%eax
  802804:	48                   	dec    %eax
  802805:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	eb 30                	jmp    80283f <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80280f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802814:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802817:	75 0a                	jne    802823 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802819:	a1 38 41 80 00       	mov    0x804138,%eax
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802821:	eb 08                	jmp    80282b <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 08             	mov    0x8(%eax),%eax
  802831:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802834:	0f 85 4d fe ff ff    	jne    802687 <alloc_block_NF+0x59>

			return NULL;
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	53                   	push   %ebx
  802845:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802848:	a1 38 41 80 00       	mov    0x804138,%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	0f 85 86 00 00 00    	jne    8028db <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802855:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80285c:	00 00 00 
  80285f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802866:	00 00 00 
  802869:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802870:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802873:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802877:	75 17                	jne    802890 <insert_sorted_with_merge_freeList+0x4f>
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 70 3b 80 00       	push   $0x803b70
  802881:	68 48 01 00 00       	push   $0x148
  802886:	68 93 3b 80 00       	push   $0x803b93
  80288b:	e8 ef d9 ff ff       	call   80027f <_panic>
  802890:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	89 10                	mov    %edx,(%eax)
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 0d                	je     8028b1 <insert_sorted_with_merge_freeList+0x70>
  8028a4:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ac:	89 50 04             	mov    %edx,0x4(%eax)
  8028af:	eb 08                	jmp    8028b9 <insert_sorted_with_merge_freeList+0x78>
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	a3 38 41 80 00       	mov    %eax,0x804138
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cb:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d0:	40                   	inc    %eax
  8028d1:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8028d6:	e9 73 07 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8028db:	8b 45 08             	mov    0x8(%ebp),%eax
  8028de:	8b 50 08             	mov    0x8(%eax),%edx
  8028e1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028e6:	8b 40 08             	mov    0x8(%eax),%eax
  8028e9:	39 c2                	cmp    %eax,%edx
  8028eb:	0f 86 84 00 00 00    	jbe    802975 <insert_sorted_with_merge_freeList+0x134>
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 50 08             	mov    0x8(%eax),%edx
  8028f7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028fc:	8b 48 0c             	mov    0xc(%eax),%ecx
  8028ff:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802904:	8b 40 08             	mov    0x8(%eax),%eax
  802907:	01 c8                	add    %ecx,%eax
  802909:	39 c2                	cmp    %eax,%edx
  80290b:	74 68                	je     802975 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  80290d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802911:	75 17                	jne    80292a <insert_sorted_with_merge_freeList+0xe9>
  802913:	83 ec 04             	sub    $0x4,%esp
  802916:	68 ac 3b 80 00       	push   $0x803bac
  80291b:	68 4c 01 00 00       	push   $0x14c
  802920:	68 93 3b 80 00       	push   $0x803b93
  802925:	e8 55 d9 ff ff       	call   80027f <_panic>
  80292a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	89 50 04             	mov    %edx,0x4(%eax)
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	8b 40 04             	mov    0x4(%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 0c                	je     80294c <insert_sorted_with_merge_freeList+0x10b>
  802940:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802945:	8b 55 08             	mov    0x8(%ebp),%edx
  802948:	89 10                	mov    %edx,(%eax)
  80294a:	eb 08                	jmp    802954 <insert_sorted_with_merge_freeList+0x113>
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	a3 38 41 80 00       	mov    %eax,0x804138
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802965:	a1 44 41 80 00       	mov    0x804144,%eax
  80296a:	40                   	inc    %eax
  80296b:	a3 44 41 80 00       	mov    %eax,0x804144
  802970:	e9 d9 06 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	8b 50 08             	mov    0x8(%eax),%edx
  80297b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802980:	8b 40 08             	mov    0x8(%eax),%eax
  802983:	39 c2                	cmp    %eax,%edx
  802985:	0f 86 b5 00 00 00    	jbe    802a40 <insert_sorted_with_merge_freeList+0x1ff>
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	8b 50 08             	mov    0x8(%eax),%edx
  802991:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802996:	8b 48 0c             	mov    0xc(%eax),%ecx
  802999:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80299e:	8b 40 08             	mov    0x8(%eax),%eax
  8029a1:	01 c8                	add    %ecx,%eax
  8029a3:	39 c2                	cmp    %eax,%edx
  8029a5:	0f 85 95 00 00 00    	jne    802a40 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029ab:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029b0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029b6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8029bf:	01 ca                	add    %ecx,%edx
  8029c1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029dc:	75 17                	jne    8029f5 <insert_sorted_with_merge_freeList+0x1b4>
  8029de:	83 ec 04             	sub    $0x4,%esp
  8029e1:	68 70 3b 80 00       	push   $0x803b70
  8029e6:	68 54 01 00 00       	push   $0x154
  8029eb:	68 93 3b 80 00       	push   $0x803b93
  8029f0:	e8 8a d8 ff ff       	call   80027f <_panic>
  8029f5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0d                	je     802a16 <insert_sorted_with_merge_freeList+0x1d5>
  802a09:	a1 48 41 80 00       	mov    0x804148,%eax
  802a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	eb 08                	jmp    802a1e <insert_sorted_with_merge_freeList+0x1dd>
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	a3 48 41 80 00       	mov    %eax,0x804148
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a30:	a1 54 41 80 00       	mov    0x804154,%eax
  802a35:	40                   	inc    %eax
  802a36:	a3 54 41 80 00       	mov    %eax,0x804154
  802a3b:	e9 0e 06 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	8b 50 08             	mov    0x8(%eax),%edx
  802a46:	a1 38 41 80 00       	mov    0x804138,%eax
  802a4b:	8b 40 08             	mov    0x8(%eax),%eax
  802a4e:	39 c2                	cmp    %eax,%edx
  802a50:	0f 83 c1 00 00 00    	jae    802b17 <insert_sorted_with_merge_freeList+0x2d6>
  802a56:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5b:	8b 50 08             	mov    0x8(%eax),%edx
  802a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a61:	8b 48 08             	mov    0x8(%eax),%ecx
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6a:	01 c8                	add    %ecx,%eax
  802a6c:	39 c2                	cmp    %eax,%edx
  802a6e:	0f 85 a3 00 00 00    	jne    802b17 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802a74:	a1 38 41 80 00       	mov    0x804138,%eax
  802a79:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7c:	8b 52 08             	mov    0x8(%edx),%edx
  802a7f:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802a82:	a1 38 41 80 00       	mov    0x804138,%eax
  802a87:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a8d:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a90:	8b 55 08             	mov    0x8(%ebp),%edx
  802a93:	8b 52 0c             	mov    0xc(%edx),%edx
  802a96:	01 ca                	add    %ecx,%edx
  802a98:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802aaf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab3:	75 17                	jne    802acc <insert_sorted_with_merge_freeList+0x28b>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 70 3b 80 00       	push   $0x803b70
  802abd:	68 5d 01 00 00       	push   $0x15d
  802ac2:	68 93 3b 80 00       	push   $0x803b93
  802ac7:	e8 b3 d7 ff ff       	call   80027f <_panic>
  802acc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	89 10                	mov    %edx,(%eax)
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	74 0d                	je     802aed <insert_sorted_with_merge_freeList+0x2ac>
  802ae0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae8:	89 50 04             	mov    %edx,0x4(%eax)
  802aeb:	eb 08                	jmp    802af5 <insert_sorted_with_merge_freeList+0x2b4>
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	a3 48 41 80 00       	mov    %eax,0x804148
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b07:	a1 54 41 80 00       	mov    0x804154,%eax
  802b0c:	40                   	inc    %eax
  802b0d:	a3 54 41 80 00       	mov    %eax,0x804154
  802b12:	e9 37 05 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	8b 50 08             	mov    0x8(%eax),%edx
  802b1d:	a1 38 41 80 00       	mov    0x804138,%eax
  802b22:	8b 40 08             	mov    0x8(%eax),%eax
  802b25:	39 c2                	cmp    %eax,%edx
  802b27:	0f 83 82 00 00 00    	jae    802baf <insert_sorted_with_merge_freeList+0x36e>
  802b2d:	a1 38 41 80 00       	mov    0x804138,%eax
  802b32:	8b 50 08             	mov    0x8(%eax),%edx
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	8b 48 08             	mov    0x8(%eax),%ecx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b41:	01 c8                	add    %ecx,%eax
  802b43:	39 c2                	cmp    %eax,%edx
  802b45:	74 68                	je     802baf <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4b:	75 17                	jne    802b64 <insert_sorted_with_merge_freeList+0x323>
  802b4d:	83 ec 04             	sub    $0x4,%esp
  802b50:	68 70 3b 80 00       	push   $0x803b70
  802b55:	68 62 01 00 00       	push   $0x162
  802b5a:	68 93 3b 80 00       	push   $0x803b93
  802b5f:	e8 1b d7 ff ff       	call   80027f <_panic>
  802b64:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	89 10                	mov    %edx,(%eax)
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	74 0d                	je     802b85 <insert_sorted_with_merge_freeList+0x344>
  802b78:	a1 38 41 80 00       	mov    0x804138,%eax
  802b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b80:	89 50 04             	mov    %edx,0x4(%eax)
  802b83:	eb 08                	jmp    802b8d <insert_sorted_with_merge_freeList+0x34c>
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	a3 38 41 80 00       	mov    %eax,0x804138
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9f:	a1 44 41 80 00       	mov    0x804144,%eax
  802ba4:	40                   	inc    %eax
  802ba5:	a3 44 41 80 00       	mov    %eax,0x804144
  802baa:	e9 9f 04 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802baf:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802bb9:	e9 84 04 00 00       	jmp    803042 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 50 08             	mov    0x8(%eax),%edx
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 40 08             	mov    0x8(%eax),%eax
  802bca:	39 c2                	cmp    %eax,%edx
  802bcc:	0f 86 a9 00 00 00    	jbe    802c7b <insert_sorted_with_merge_freeList+0x43a>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 50 08             	mov    0x8(%eax),%edx
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	8b 48 08             	mov    0x8(%eax),%ecx
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	01 c8                	add    %ecx,%eax
  802be6:	39 c2                	cmp    %eax,%edx
  802be8:	0f 84 8d 00 00 00    	je     802c7b <insert_sorted_with_merge_freeList+0x43a>
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	8b 50 08             	mov    0x8(%eax),%edx
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 40 04             	mov    0x4(%eax),%eax
  802bfa:	8b 48 08             	mov    0x8(%eax),%ecx
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	8b 40 0c             	mov    0xc(%eax),%eax
  802c06:	01 c8                	add    %ecx,%eax
  802c08:	39 c2                	cmp    %eax,%edx
  802c0a:	74 6f                	je     802c7b <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c10:	74 06                	je     802c18 <insert_sorted_with_merge_freeList+0x3d7>
  802c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c16:	75 17                	jne    802c2f <insert_sorted_with_merge_freeList+0x3ee>
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	68 d0 3b 80 00       	push   $0x803bd0
  802c20:	68 6b 01 00 00       	push   $0x16b
  802c25:	68 93 3b 80 00       	push   $0x803b93
  802c2a:	e8 50 d6 ff ff       	call   80027f <_panic>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 50 04             	mov    0x4(%eax),%edx
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	89 50 04             	mov    %edx,0x4(%eax)
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c41:	89 10                	mov    %edx,(%eax)
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 0d                	je     802c5a <insert_sorted_with_merge_freeList+0x419>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	8b 55 08             	mov    0x8(%ebp),%edx
  802c56:	89 10                	mov    %edx,(%eax)
  802c58:	eb 08                	jmp    802c62 <insert_sorted_with_merge_freeList+0x421>
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	a3 38 41 80 00       	mov    %eax,0x804138
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 55 08             	mov    0x8(%ebp),%edx
  802c68:	89 50 04             	mov    %edx,0x4(%eax)
  802c6b:	a1 44 41 80 00       	mov    0x804144,%eax
  802c70:	40                   	inc    %eax
  802c71:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802c76:	e9 d3 03 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 50 08             	mov    0x8(%eax),%edx
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 40 08             	mov    0x8(%eax),%eax
  802c87:	39 c2                	cmp    %eax,%edx
  802c89:	0f 86 da 00 00 00    	jbe    802d69 <insert_sorted_with_merge_freeList+0x528>
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 50 08             	mov    0x8(%eax),%edx
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	8b 48 08             	mov    0x8(%eax),%ecx
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca1:	01 c8                	add    %ecx,%eax
  802ca3:	39 c2                	cmp    %eax,%edx
  802ca5:	0f 85 be 00 00 00    	jne    802d69 <insert_sorted_with_merge_freeList+0x528>
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	8b 50 08             	mov    0x8(%eax),%edx
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	8b 48 08             	mov    0x8(%eax),%ecx
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 40 04             	mov    0x4(%eax),%eax
  802cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc3:	01 c8                	add    %ecx,%eax
  802cc5:	39 c2                	cmp    %eax,%edx
  802cc7:	0f 84 9c 00 00 00    	je     802d69 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 50 0c             	mov    0xc(%eax),%edx
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce5:	01 c2                	add    %eax,%edx
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d05:	75 17                	jne    802d1e <insert_sorted_with_merge_freeList+0x4dd>
  802d07:	83 ec 04             	sub    $0x4,%esp
  802d0a:	68 70 3b 80 00       	push   $0x803b70
  802d0f:	68 74 01 00 00       	push   $0x174
  802d14:	68 93 3b 80 00       	push   $0x803b93
  802d19:	e8 61 d5 ff ff       	call   80027f <_panic>
  802d1e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	89 10                	mov    %edx,(%eax)
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	85 c0                	test   %eax,%eax
  802d30:	74 0d                	je     802d3f <insert_sorted_with_merge_freeList+0x4fe>
  802d32:	a1 48 41 80 00       	mov    0x804148,%eax
  802d37:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3a:	89 50 04             	mov    %edx,0x4(%eax)
  802d3d:	eb 08                	jmp    802d47 <insert_sorted_with_merge_freeList+0x506>
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	a3 48 41 80 00       	mov    %eax,0x804148
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d59:	a1 54 41 80 00       	mov    0x804154,%eax
  802d5e:	40                   	inc    %eax
  802d5f:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d64:	e9 e5 02 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 50 08             	mov    0x8(%eax),%edx
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	8b 40 08             	mov    0x8(%eax),%eax
  802d75:	39 c2                	cmp    %eax,%edx
  802d77:	0f 86 d7 00 00 00    	jbe    802e54 <insert_sorted_with_merge_freeList+0x613>
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 50 08             	mov    0x8(%eax),%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 48 08             	mov    0x8(%eax),%ecx
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8f:	01 c8                	add    %ecx,%eax
  802d91:	39 c2                	cmp    %eax,%edx
  802d93:	0f 84 bb 00 00 00    	je     802e54 <insert_sorted_with_merge_freeList+0x613>
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	8b 50 08             	mov    0x8(%eax),%edx
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 40 04             	mov    0x4(%eax),%eax
  802da5:	8b 48 08             	mov    0x8(%eax),%ecx
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	8b 40 0c             	mov    0xc(%eax),%eax
  802db1:	01 c8                	add    %ecx,%eax
  802db3:	39 c2                	cmp    %eax,%edx
  802db5:	0f 85 99 00 00 00    	jne    802e54 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 40 04             	mov    0x4(%eax),%eax
  802dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	8b 50 0c             	mov    0xc(%eax),%edx
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd0:	01 c2                	add    %eax,%edx
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df0:	75 17                	jne    802e09 <insert_sorted_with_merge_freeList+0x5c8>
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	68 70 3b 80 00       	push   $0x803b70
  802dfa:	68 7d 01 00 00       	push   $0x17d
  802dff:	68 93 3b 80 00       	push   $0x803b93
  802e04:	e8 76 d4 ff ff       	call   80027f <_panic>
  802e09:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	89 10                	mov    %edx,(%eax)
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0d                	je     802e2a <insert_sorted_with_merge_freeList+0x5e9>
  802e1d:	a1 48 41 80 00       	mov    0x804148,%eax
  802e22:	8b 55 08             	mov    0x8(%ebp),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 08                	jmp    802e32 <insert_sorted_with_merge_freeList+0x5f1>
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	a3 48 41 80 00       	mov    %eax,0x804148
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e44:	a1 54 41 80 00       	mov    0x804154,%eax
  802e49:	40                   	inc    %eax
  802e4a:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e4f:	e9 fa 01 00 00       	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 50 08             	mov    0x8(%eax),%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	8b 40 08             	mov    0x8(%eax),%eax
  802e60:	39 c2                	cmp    %eax,%edx
  802e62:	0f 86 d2 01 00 00    	jbe    80303a <insert_sorted_with_merge_freeList+0x7f9>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 50 08             	mov    0x8(%eax),%edx
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	8b 48 08             	mov    0x8(%eax),%ecx
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7a:	01 c8                	add    %ecx,%eax
  802e7c:	39 c2                	cmp    %eax,%edx
  802e7e:	0f 85 b6 01 00 00    	jne    80303a <insert_sorted_with_merge_freeList+0x7f9>
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	8b 50 08             	mov    0x8(%eax),%edx
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	8b 48 08             	mov    0x8(%eax),%ecx
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 40 04             	mov    0x4(%eax),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	01 c8                	add    %ecx,%eax
  802e9e:	39 c2                	cmp    %eax,%edx
  802ea0:	0f 85 94 01 00 00    	jne    80303a <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 40 04             	mov    0x4(%eax),%eax
  802eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eaf:	8b 52 04             	mov    0x4(%edx),%edx
  802eb2:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb8:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebe:	8b 52 0c             	mov    0xc(%edx),%edx
  802ec1:	01 da                	add    %ebx,%edx
  802ec3:	01 ca                	add    %ecx,%edx
  802ec5:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	75 17                	jne    802ef9 <insert_sorted_with_merge_freeList+0x6b8>
  802ee2:	83 ec 04             	sub    $0x4,%esp
  802ee5:	68 05 3c 80 00       	push   $0x803c05
  802eea:	68 86 01 00 00       	push   $0x186
  802eef:	68 93 3b 80 00       	push   $0x803b93
  802ef4:	e8 86 d3 ff ff       	call   80027f <_panic>
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 10                	je     802f12 <insert_sorted_with_merge_freeList+0x6d1>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0a:	8b 52 04             	mov    0x4(%edx),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%eax)
  802f10:	eb 0b                	jmp    802f1d <insert_sorted_with_merge_freeList+0x6dc>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 04             	mov    0x4(%eax),%eax
  802f18:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 04             	mov    0x4(%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 0f                	je     802f36 <insert_sorted_with_merge_freeList+0x6f5>
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f30:	8b 12                	mov    (%edx),%edx
  802f32:	89 10                	mov    %edx,(%eax)
  802f34:	eb 0a                	jmp    802f40 <insert_sorted_with_merge_freeList+0x6ff>
  802f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	a3 38 41 80 00       	mov    %eax,0x804138
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f53:	a1 44 41 80 00       	mov    0x804144,%eax
  802f58:	48                   	dec    %eax
  802f59:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f62:	75 17                	jne    802f7b <insert_sorted_with_merge_freeList+0x73a>
  802f64:	83 ec 04             	sub    $0x4,%esp
  802f67:	68 70 3b 80 00       	push   $0x803b70
  802f6c:	68 87 01 00 00       	push   $0x187
  802f71:	68 93 3b 80 00       	push   $0x803b93
  802f76:	e8 04 d3 ff ff       	call   80027f <_panic>
  802f7b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	74 0d                	je     802f9c <insert_sorted_with_merge_freeList+0x75b>
  802f8f:	a1 48 41 80 00       	mov    0x804148,%eax
  802f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f97:	89 50 04             	mov    %edx,0x4(%eax)
  802f9a:	eb 08                	jmp    802fa4 <insert_sorted_with_merge_freeList+0x763>
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	a3 48 41 80 00       	mov    %eax,0x804148
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb6:	a1 54 41 80 00       	mov    0x804154,%eax
  802fbb:	40                   	inc    %eax
  802fbc:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fd5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd9:	75 17                	jne    802ff2 <insert_sorted_with_merge_freeList+0x7b1>
  802fdb:	83 ec 04             	sub    $0x4,%esp
  802fde:	68 70 3b 80 00       	push   $0x803b70
  802fe3:	68 8a 01 00 00       	push   $0x18a
  802fe8:	68 93 3b 80 00       	push   $0x803b93
  802fed:	e8 8d d2 ff ff       	call   80027f <_panic>
  802ff2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	89 10                	mov    %edx,(%eax)
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	74 0d                	je     803013 <insert_sorted_with_merge_freeList+0x7d2>
  803006:	a1 48 41 80 00       	mov    0x804148,%eax
  80300b:	8b 55 08             	mov    0x8(%ebp),%edx
  80300e:	89 50 04             	mov    %edx,0x4(%eax)
  803011:	eb 08                	jmp    80301b <insert_sorted_with_merge_freeList+0x7da>
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	a3 48 41 80 00       	mov    %eax,0x804148
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302d:	a1 54 41 80 00       	mov    0x804154,%eax
  803032:	40                   	inc    %eax
  803033:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803038:	eb 14                	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803046:	0f 85 72 fb ff ff    	jne    802bbe <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80304c:	eb 00                	jmp    80304e <insert_sorted_with_merge_freeList+0x80d>
  80304e:	90                   	nop
  80304f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803052:	c9                   	leave  
  803053:	c3                   	ret    

00803054 <__udivdi3>:
  803054:	55                   	push   %ebp
  803055:	57                   	push   %edi
  803056:	56                   	push   %esi
  803057:	53                   	push   %ebx
  803058:	83 ec 1c             	sub    $0x1c,%esp
  80305b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80305f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803067:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80306b:	89 ca                	mov    %ecx,%edx
  80306d:	89 f8                	mov    %edi,%eax
  80306f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803073:	85 f6                	test   %esi,%esi
  803075:	75 2d                	jne    8030a4 <__udivdi3+0x50>
  803077:	39 cf                	cmp    %ecx,%edi
  803079:	77 65                	ja     8030e0 <__udivdi3+0x8c>
  80307b:	89 fd                	mov    %edi,%ebp
  80307d:	85 ff                	test   %edi,%edi
  80307f:	75 0b                	jne    80308c <__udivdi3+0x38>
  803081:	b8 01 00 00 00       	mov    $0x1,%eax
  803086:	31 d2                	xor    %edx,%edx
  803088:	f7 f7                	div    %edi
  80308a:	89 c5                	mov    %eax,%ebp
  80308c:	31 d2                	xor    %edx,%edx
  80308e:	89 c8                	mov    %ecx,%eax
  803090:	f7 f5                	div    %ebp
  803092:	89 c1                	mov    %eax,%ecx
  803094:	89 d8                	mov    %ebx,%eax
  803096:	f7 f5                	div    %ebp
  803098:	89 cf                	mov    %ecx,%edi
  80309a:	89 fa                	mov    %edi,%edx
  80309c:	83 c4 1c             	add    $0x1c,%esp
  80309f:	5b                   	pop    %ebx
  8030a0:	5e                   	pop    %esi
  8030a1:	5f                   	pop    %edi
  8030a2:	5d                   	pop    %ebp
  8030a3:	c3                   	ret    
  8030a4:	39 ce                	cmp    %ecx,%esi
  8030a6:	77 28                	ja     8030d0 <__udivdi3+0x7c>
  8030a8:	0f bd fe             	bsr    %esi,%edi
  8030ab:	83 f7 1f             	xor    $0x1f,%edi
  8030ae:	75 40                	jne    8030f0 <__udivdi3+0x9c>
  8030b0:	39 ce                	cmp    %ecx,%esi
  8030b2:	72 0a                	jb     8030be <__udivdi3+0x6a>
  8030b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030b8:	0f 87 9e 00 00 00    	ja     80315c <__udivdi3+0x108>
  8030be:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c3:	89 fa                	mov    %edi,%edx
  8030c5:	83 c4 1c             	add    $0x1c,%esp
  8030c8:	5b                   	pop    %ebx
  8030c9:	5e                   	pop    %esi
  8030ca:	5f                   	pop    %edi
  8030cb:	5d                   	pop    %ebp
  8030cc:	c3                   	ret    
  8030cd:	8d 76 00             	lea    0x0(%esi),%esi
  8030d0:	31 ff                	xor    %edi,%edi
  8030d2:	31 c0                	xor    %eax,%eax
  8030d4:	89 fa                	mov    %edi,%edx
  8030d6:	83 c4 1c             	add    $0x1c,%esp
  8030d9:	5b                   	pop    %ebx
  8030da:	5e                   	pop    %esi
  8030db:	5f                   	pop    %edi
  8030dc:	5d                   	pop    %ebp
  8030dd:	c3                   	ret    
  8030de:	66 90                	xchg   %ax,%ax
  8030e0:	89 d8                	mov    %ebx,%eax
  8030e2:	f7 f7                	div    %edi
  8030e4:	31 ff                	xor    %edi,%edi
  8030e6:	89 fa                	mov    %edi,%edx
  8030e8:	83 c4 1c             	add    $0x1c,%esp
  8030eb:	5b                   	pop    %ebx
  8030ec:	5e                   	pop    %esi
  8030ed:	5f                   	pop    %edi
  8030ee:	5d                   	pop    %ebp
  8030ef:	c3                   	ret    
  8030f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030f5:	89 eb                	mov    %ebp,%ebx
  8030f7:	29 fb                	sub    %edi,%ebx
  8030f9:	89 f9                	mov    %edi,%ecx
  8030fb:	d3 e6                	shl    %cl,%esi
  8030fd:	89 c5                	mov    %eax,%ebp
  8030ff:	88 d9                	mov    %bl,%cl
  803101:	d3 ed                	shr    %cl,%ebp
  803103:	89 e9                	mov    %ebp,%ecx
  803105:	09 f1                	or     %esi,%ecx
  803107:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80310b:	89 f9                	mov    %edi,%ecx
  80310d:	d3 e0                	shl    %cl,%eax
  80310f:	89 c5                	mov    %eax,%ebp
  803111:	89 d6                	mov    %edx,%esi
  803113:	88 d9                	mov    %bl,%cl
  803115:	d3 ee                	shr    %cl,%esi
  803117:	89 f9                	mov    %edi,%ecx
  803119:	d3 e2                	shl    %cl,%edx
  80311b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80311f:	88 d9                	mov    %bl,%cl
  803121:	d3 e8                	shr    %cl,%eax
  803123:	09 c2                	or     %eax,%edx
  803125:	89 d0                	mov    %edx,%eax
  803127:	89 f2                	mov    %esi,%edx
  803129:	f7 74 24 0c          	divl   0xc(%esp)
  80312d:	89 d6                	mov    %edx,%esi
  80312f:	89 c3                	mov    %eax,%ebx
  803131:	f7 e5                	mul    %ebp
  803133:	39 d6                	cmp    %edx,%esi
  803135:	72 19                	jb     803150 <__udivdi3+0xfc>
  803137:	74 0b                	je     803144 <__udivdi3+0xf0>
  803139:	89 d8                	mov    %ebx,%eax
  80313b:	31 ff                	xor    %edi,%edi
  80313d:	e9 58 ff ff ff       	jmp    80309a <__udivdi3+0x46>
  803142:	66 90                	xchg   %ax,%ax
  803144:	8b 54 24 08          	mov    0x8(%esp),%edx
  803148:	89 f9                	mov    %edi,%ecx
  80314a:	d3 e2                	shl    %cl,%edx
  80314c:	39 c2                	cmp    %eax,%edx
  80314e:	73 e9                	jae    803139 <__udivdi3+0xe5>
  803150:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803153:	31 ff                	xor    %edi,%edi
  803155:	e9 40 ff ff ff       	jmp    80309a <__udivdi3+0x46>
  80315a:	66 90                	xchg   %ax,%ax
  80315c:	31 c0                	xor    %eax,%eax
  80315e:	e9 37 ff ff ff       	jmp    80309a <__udivdi3+0x46>
  803163:	90                   	nop

00803164 <__umoddi3>:
  803164:	55                   	push   %ebp
  803165:	57                   	push   %edi
  803166:	56                   	push   %esi
  803167:	53                   	push   %ebx
  803168:	83 ec 1c             	sub    $0x1c,%esp
  80316b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80316f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803173:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803177:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80317b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80317f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803183:	89 f3                	mov    %esi,%ebx
  803185:	89 fa                	mov    %edi,%edx
  803187:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80318b:	89 34 24             	mov    %esi,(%esp)
  80318e:	85 c0                	test   %eax,%eax
  803190:	75 1a                	jne    8031ac <__umoddi3+0x48>
  803192:	39 f7                	cmp    %esi,%edi
  803194:	0f 86 a2 00 00 00    	jbe    80323c <__umoddi3+0xd8>
  80319a:	89 c8                	mov    %ecx,%eax
  80319c:	89 f2                	mov    %esi,%edx
  80319e:	f7 f7                	div    %edi
  8031a0:	89 d0                	mov    %edx,%eax
  8031a2:	31 d2                	xor    %edx,%edx
  8031a4:	83 c4 1c             	add    $0x1c,%esp
  8031a7:	5b                   	pop    %ebx
  8031a8:	5e                   	pop    %esi
  8031a9:	5f                   	pop    %edi
  8031aa:	5d                   	pop    %ebp
  8031ab:	c3                   	ret    
  8031ac:	39 f0                	cmp    %esi,%eax
  8031ae:	0f 87 ac 00 00 00    	ja     803260 <__umoddi3+0xfc>
  8031b4:	0f bd e8             	bsr    %eax,%ebp
  8031b7:	83 f5 1f             	xor    $0x1f,%ebp
  8031ba:	0f 84 ac 00 00 00    	je     80326c <__umoddi3+0x108>
  8031c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8031c5:	29 ef                	sub    %ebp,%edi
  8031c7:	89 fe                	mov    %edi,%esi
  8031c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031cd:	89 e9                	mov    %ebp,%ecx
  8031cf:	d3 e0                	shl    %cl,%eax
  8031d1:	89 d7                	mov    %edx,%edi
  8031d3:	89 f1                	mov    %esi,%ecx
  8031d5:	d3 ef                	shr    %cl,%edi
  8031d7:	09 c7                	or     %eax,%edi
  8031d9:	89 e9                	mov    %ebp,%ecx
  8031db:	d3 e2                	shl    %cl,%edx
  8031dd:	89 14 24             	mov    %edx,(%esp)
  8031e0:	89 d8                	mov    %ebx,%eax
  8031e2:	d3 e0                	shl    %cl,%eax
  8031e4:	89 c2                	mov    %eax,%edx
  8031e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ea:	d3 e0                	shl    %cl,%eax
  8031ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f4:	89 f1                	mov    %esi,%ecx
  8031f6:	d3 e8                	shr    %cl,%eax
  8031f8:	09 d0                	or     %edx,%eax
  8031fa:	d3 eb                	shr    %cl,%ebx
  8031fc:	89 da                	mov    %ebx,%edx
  8031fe:	f7 f7                	div    %edi
  803200:	89 d3                	mov    %edx,%ebx
  803202:	f7 24 24             	mull   (%esp)
  803205:	89 c6                	mov    %eax,%esi
  803207:	89 d1                	mov    %edx,%ecx
  803209:	39 d3                	cmp    %edx,%ebx
  80320b:	0f 82 87 00 00 00    	jb     803298 <__umoddi3+0x134>
  803211:	0f 84 91 00 00 00    	je     8032a8 <__umoddi3+0x144>
  803217:	8b 54 24 04          	mov    0x4(%esp),%edx
  80321b:	29 f2                	sub    %esi,%edx
  80321d:	19 cb                	sbb    %ecx,%ebx
  80321f:	89 d8                	mov    %ebx,%eax
  803221:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803225:	d3 e0                	shl    %cl,%eax
  803227:	89 e9                	mov    %ebp,%ecx
  803229:	d3 ea                	shr    %cl,%edx
  80322b:	09 d0                	or     %edx,%eax
  80322d:	89 e9                	mov    %ebp,%ecx
  80322f:	d3 eb                	shr    %cl,%ebx
  803231:	89 da                	mov    %ebx,%edx
  803233:	83 c4 1c             	add    $0x1c,%esp
  803236:	5b                   	pop    %ebx
  803237:	5e                   	pop    %esi
  803238:	5f                   	pop    %edi
  803239:	5d                   	pop    %ebp
  80323a:	c3                   	ret    
  80323b:	90                   	nop
  80323c:	89 fd                	mov    %edi,%ebp
  80323e:	85 ff                	test   %edi,%edi
  803240:	75 0b                	jne    80324d <__umoddi3+0xe9>
  803242:	b8 01 00 00 00       	mov    $0x1,%eax
  803247:	31 d2                	xor    %edx,%edx
  803249:	f7 f7                	div    %edi
  80324b:	89 c5                	mov    %eax,%ebp
  80324d:	89 f0                	mov    %esi,%eax
  80324f:	31 d2                	xor    %edx,%edx
  803251:	f7 f5                	div    %ebp
  803253:	89 c8                	mov    %ecx,%eax
  803255:	f7 f5                	div    %ebp
  803257:	89 d0                	mov    %edx,%eax
  803259:	e9 44 ff ff ff       	jmp    8031a2 <__umoddi3+0x3e>
  80325e:	66 90                	xchg   %ax,%ax
  803260:	89 c8                	mov    %ecx,%eax
  803262:	89 f2                	mov    %esi,%edx
  803264:	83 c4 1c             	add    $0x1c,%esp
  803267:	5b                   	pop    %ebx
  803268:	5e                   	pop    %esi
  803269:	5f                   	pop    %edi
  80326a:	5d                   	pop    %ebp
  80326b:	c3                   	ret    
  80326c:	3b 04 24             	cmp    (%esp),%eax
  80326f:	72 06                	jb     803277 <__umoddi3+0x113>
  803271:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803275:	77 0f                	ja     803286 <__umoddi3+0x122>
  803277:	89 f2                	mov    %esi,%edx
  803279:	29 f9                	sub    %edi,%ecx
  80327b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80327f:	89 14 24             	mov    %edx,(%esp)
  803282:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803286:	8b 44 24 04          	mov    0x4(%esp),%eax
  80328a:	8b 14 24             	mov    (%esp),%edx
  80328d:	83 c4 1c             	add    $0x1c,%esp
  803290:	5b                   	pop    %ebx
  803291:	5e                   	pop    %esi
  803292:	5f                   	pop    %edi
  803293:	5d                   	pop    %ebp
  803294:	c3                   	ret    
  803295:	8d 76 00             	lea    0x0(%esi),%esi
  803298:	2b 04 24             	sub    (%esp),%eax
  80329b:	19 fa                	sbb    %edi,%edx
  80329d:	89 d1                	mov    %edx,%ecx
  80329f:	89 c6                	mov    %eax,%esi
  8032a1:	e9 71 ff ff ff       	jmp    803217 <__umoddi3+0xb3>
  8032a6:	66 90                	xchg   %ax,%ax
  8032a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032ac:	72 ea                	jb     803298 <__umoddi3+0x134>
  8032ae:	89 d9                	mov    %ebx,%ecx
  8032b0:	e9 62 ff ff ff       	jmp    803217 <__umoddi3+0xb3>
