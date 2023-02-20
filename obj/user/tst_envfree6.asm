
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 5c 01 00 00       	call   800192 <libmain>
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
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 33 80 00       	push   $0x8033c0
  80004a:	e8 e4 15 00 00       	call   801633 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 d3 18 00 00       	call   801936 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 6b 19 00 00       	call   8019d6 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 33 80 00       	push   $0x8033d0
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 03 34 80 00       	push   $0x803403
  800099:	e8 0a 1b 00 00       	call   801ba8 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 0c 34 80 00       	push   $0x80340c
  8000b9:	e8 ea 1a 00 00       	call   801ba8 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 f7 1a 00 00       	call   801bc6 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 c4 2f 00 00       	call   8030a3 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 d9 1a 00 00       	call   801bc6 <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 36 18 00 00       	call   801936 <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 18 34 80 00       	push   $0x803418
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 c6 1a 00 00       	call   801be2 <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 b8 1a 00 00       	call   801be2 <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 04 18 00 00       	call   801936 <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 9c 18 00 00       	call   8019d6 <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 4c 34 80 00       	push   $0x80344c
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 9c 34 80 00       	push   $0x80349c
  800160:	6a 23                	push   $0x23
  800162:	68 d2 34 80 00       	push   $0x8034d2
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 e8 34 80 00       	push   $0x8034e8
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 48 35 80 00       	push   $0x803548
  800187:	e8 f6 03 00 00       	call   800582 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	return;
  80018f:	90                   	nop
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800198:	e8 79 1a 00 00       	call   801c16 <sys_getenvindex>
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a3:	89 d0                	mov    %edx,%eax
  8001a5:	c1 e0 03             	shl    $0x3,%eax
  8001a8:	01 d0                	add    %edx,%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	c1 e0 04             	shl    $0x4,%eax
  8001ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bf:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001cf:	84 c0                	test   %al,%al
  8001d1:	74 0f                	je     8001e2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d8:	05 5c 05 00 00       	add    $0x55c,%eax
  8001dd:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e6:	7e 0a                	jle    8001f2 <libmain+0x60>
		binaryname = argv[0];
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	8b 00                	mov    (%eax),%eax
  8001ed:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 38 fe ff ff       	call   800038 <_main>
  800200:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800203:	e8 1b 18 00 00       	call   801a23 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 ac 35 80 00       	push   $0x8035ac
  800210:	e8 6d 03 00 00       	call   800582 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800223:	a1 20 40 80 00       	mov    0x804020,%eax
  800228:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 d4 35 80 00       	push   $0x8035d4
  800238:	e8 45 03 00 00       	call   800582 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800240:	a1 20 40 80 00       	mov    0x804020,%eax
  800245:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800256:	a1 20 40 80 00       	mov    0x804020,%eax
  80025b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 fc 35 80 00       	push   $0x8035fc
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 54 36 80 00       	push   $0x803654
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 ac 35 80 00       	push   $0x8035ac
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 9b 17 00 00       	call   801a3d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a2:	e8 19 00 00 00       	call   8002c0 <exit>
}
  8002a7:	90                   	nop
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	6a 00                	push   $0x0
  8002b5:	e8 28 19 00 00       	call   801be2 <sys_destroy_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <exit>:

void
exit(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c6:	e8 7d 19 00 00       	call   801c48 <sys_exit_env>
}
  8002cb:	90                   	nop
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d7:	83 c0 04             	add    $0x4,%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002dd:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	74 16                	je     8002fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	50                   	push   %eax
  8002ef:	68 68 36 80 00       	push   $0x803668
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 40 80 00       	mov    0x804000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 6d 36 80 00       	push   $0x80366d
  80030d:	e8 70 02 00 00       	call   800582 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 f4             	pushl  -0xc(%ebp)
  80031e:	50                   	push   %eax
  80031f:	e8 f3 01 00 00       	call   800517 <vcprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	68 89 36 80 00       	push   $0x803689
  800331:	e8 e1 01 00 00       	call   800517 <vcprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800339:	e8 82 ff ff ff       	call   8002c0 <exit>

	// should not return here
	while (1) ;
  80033e:	eb fe                	jmp    80033e <_panic+0x70>

00800340 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800346:	a1 20 40 80 00       	mov    0x804020,%eax
  80034b:	8b 50 74             	mov    0x74(%eax),%edx
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	39 c2                	cmp    %eax,%edx
  800353:	74 14                	je     800369 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 8c 36 80 00       	push   $0x80368c
  80035d:	6a 26                	push   $0x26
  80035f:	68 d8 36 80 00       	push   $0x8036d8
  800364:	e8 65 ff ff ff       	call   8002ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800377:	e9 c2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	01 d0                	add    %edx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	85 c0                	test   %eax,%eax
  80038f:	75 08                	jne    800399 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800391:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800394:	e9 a2 00 00 00       	jmp    80043b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800399:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a7:	eb 69                	jmp    800412 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8a 40 04             	mov    0x4(%eax),%al
  8003c5:	84 c0                	test   %al,%al
  8003c7:	75 46                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ce:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	01 c0                	add    %eax,%eax
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800402:	39 c2                	cmp    %eax,%edx
  800404:	75 09                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800406:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80040d:	eb 12                	jmp    800421 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	ff 45 e8             	incl   -0x18(%ebp)
  800412:	a1 20 40 80 00       	mov    0x804020,%eax
  800417:	8b 50 74             	mov    0x74(%eax),%edx
  80041a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	77 88                	ja     8003a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800425:	75 14                	jne    80043b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	68 e4 36 80 00       	push   $0x8036e4
  80042f:	6a 3a                	push   $0x3a
  800431:	68 d8 36 80 00       	push   $0x8036d8
  800436:	e8 93 fe ff ff       	call   8002ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043b:	ff 45 f0             	incl   -0x10(%ebp)
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800444:	0f 8c 32 ff ff ff    	jl     80037c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800458:	eb 26                	jmp    800480 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045a:	a1 20 40 80 00       	mov    0x804020,%eax
  80045f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8a 40 04             	mov    0x4(%eax),%al
  800476:	3c 01                	cmp    $0x1,%al
  800478:	75 03                	jne    80047d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e0             	incl   -0x20(%ebp)
  800480:	a1 20 40 80 00       	mov    0x804020,%eax
  800485:	8b 50 74             	mov    0x74(%eax),%edx
  800488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	77 cb                	ja     80045a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800495:	74 14                	je     8004ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 38 37 80 00       	push   $0x803738
  80049f:	6a 44                	push   $0x44
  8004a1:	68 d8 36 80 00       	push   $0x8036d8
  8004a6:	e8 23 fe ff ff       	call   8002ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bf:	89 0a                	mov    %ecx,(%edx)
  8004c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c4:	88 d1                	mov    %dl,%cl
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004d9:	a0 24 40 80 00       	mov    0x804024,%al
  8004de:	0f b6 c0             	movzbl %al,%eax
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	8b 12                	mov    (%edx),%edx
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	83 c2 08             	add    $0x8,%edx
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	50                   	push   %eax
  8004f2:	51                   	push   %ecx
  8004f3:	52                   	push   %edx
  8004f4:	e8 7c 13 00 00       	call   801875 <sys_cputs>
  8004f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 40 04             	mov    0x4(%eax),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	89 50 04             	mov    %edx,0x4(%eax)
}
  800514:	90                   	nop
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800527:	00 00 00 
	b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800531:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 08             	pushl  0x8(%ebp)
  80053a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800540:	50                   	push   %eax
  800541:	68 ae 04 80 00       	push   $0x8004ae
  800546:	e8 11 02 00 00       	call   80075c <vprintfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80054e:	a0 24 40 80 00       	mov    0x804024,%al
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	50                   	push   %eax
  800560:	52                   	push   %edx
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	83 c0 08             	add    $0x8,%eax
  80056a:	50                   	push   %eax
  80056b:	e8 05 13 00 00       	call   801875 <sys_cputs>
  800570:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800573:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <cprintf>:

int cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800588:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80058f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 f4             	pushl  -0xc(%ebp)
  80059e:	50                   	push   %eax
  80059f:	e8 73 ff ff ff       	call   800517 <vcprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b5:	e8 69 14 00 00       	call   801a23 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 48 ff ff ff       	call   800517 <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d5:	e8 63 14 00 00       	call   801a3d <sys_enable_interrupt>
	return cnt;
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 14             	sub    $0x14,%esp
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fd:	77 55                	ja     800654 <printnum+0x75>
  8005ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800602:	72 05                	jb     800609 <printnum+0x2a>
  800604:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800607:	77 4b                	ja     800654 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800609:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060f:	8b 45 18             	mov    0x18(%ebp),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	ff 75 f0             	pushl  -0x10(%ebp)
  80061f:	e8 34 2b 00 00       	call   803158 <__udivdi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	ff 75 20             	pushl  0x20(%ebp)
  80062d:	53                   	push   %ebx
  80062e:	ff 75 18             	pushl  0x18(%ebp)
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	ff 75 08             	pushl  0x8(%ebp)
  800639:	e8 a1 ff ff ff       	call   8005df <printnum>
  80063e:	83 c4 20             	add    $0x20,%esp
  800641:	eb 1a                	jmp    80065d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	ff 75 20             	pushl  0x20(%ebp)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800654:	ff 4d 1c             	decl   0x1c(%ebp)
  800657:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065b:	7f e6                	jg     800643 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800660:	bb 00 00 00 00       	mov    $0x0,%ebx
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066b:	53                   	push   %ebx
  80066c:	51                   	push   %ecx
  80066d:	52                   	push   %edx
  80066e:	50                   	push   %eax
  80066f:	e8 f4 2b 00 00       	call   803268 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 b4 39 80 00       	add    $0x8039b4,%eax
  80067c:	8a 00                	mov    (%eax),%al
  80067e:	0f be c0             	movsbl %al,%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	90                   	nop
  800691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800699:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069d:	7e 1c                	jle    8006bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8d 50 08             	lea    0x8(%eax),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	89 10                	mov    %edx,(%eax)
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 e8 08             	sub    $0x8,%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	eb 40                	jmp    8006fb <getuint+0x65>
	else if (lflag)
  8006bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bf:	74 1e                	je     8006df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	89 10                	mov    %edx,(%eax)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	83 e8 04             	sub    $0x4,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	eb 1c                	jmp    8006fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getint+0x25>
		return va_arg(*ap, long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 38                	jmp    80075a <getint+0x5d>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1a                	je     800742 <getint+0x45>
		return va_arg(*ap, long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
  800740:	eb 18                	jmp    80075a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 04             	lea    0x4(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	99                   	cltd   
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	eb 17                	jmp    80077d <vprintfmt+0x21>
			if (ch == '\0')
  800766:	85 db                	test   %ebx,%ebx
  800768:	0f 84 af 03 00 00    	je     800b1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	53                   	push   %ebx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077d:	8b 45 10             	mov    0x10(%ebp),%eax
  800780:	8d 50 01             	lea    0x1(%eax),%edx
  800783:	89 55 10             	mov    %edx,0x10(%ebp)
  800786:	8a 00                	mov    (%eax),%al
  800788:	0f b6 d8             	movzbl %al,%ebx
  80078b:	83 fb 25             	cmp    $0x25,%ebx
  80078e:	75 d6                	jne    800766 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800790:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800794:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b3:	8d 50 01             	lea    0x1(%eax),%edx
  8007b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f b6 d8             	movzbl %al,%ebx
  8007be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c1:	83 f8 55             	cmp    $0x55,%eax
  8007c4:	0f 87 2b 03 00 00    	ja     800af5 <vprintfmt+0x399>
  8007ca:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  8007d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d7:	eb d7                	jmp    8007b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007dd:	eb d1                	jmp    8007b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e9:	89 d0                	mov    %edx,%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	01 c0                	add    %eax,%eax
  8007f2:	01 d8                	add    %ebx,%eax
  8007f4:	83 e8 30             	sub    $0x30,%eax
  8007f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	8a 00                	mov    (%eax),%al
  8007ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800802:	83 fb 2f             	cmp    $0x2f,%ebx
  800805:	7e 3e                	jle    800845 <vprintfmt+0xe9>
  800807:	83 fb 39             	cmp    $0x39,%ebx
  80080a:	7f 39                	jg     800845 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080f:	eb d5                	jmp    8007e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800825:	eb 1f                	jmp    800846 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082b:	79 83                	jns    8007b0 <vprintfmt+0x54>
				width = 0;
  80082d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800834:	e9 77 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800839:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800840:	e9 6b ff ff ff       	jmp    8007b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800845:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	0f 89 60 ff ff ff    	jns    8007b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800856:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80085d:	e9 4e ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800862:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800865:	e9 46 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	50                   	push   %eax
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			break;
  80088a:	e9 89 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 e8 04             	sub    $0x4,%eax
  80089e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	79 02                	jns    8008a6 <vprintfmt+0x14a>
				err = -err;
  8008a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a6:	83 fb 64             	cmp    $0x64,%ebx
  8008a9:	7f 0b                	jg     8008b6 <vprintfmt+0x15a>
  8008ab:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 c5 39 80 00       	push   $0x8039c5
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 5e 02 00 00       	call   800b25 <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ca:	e9 49 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cf:	56                   	push   %esi
  8008d0:	68 ce 39 80 00       	push   $0x8039ce
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 45 02 00 00       	call   800b25 <printfmt>
  8008e0:	83 c4 10             	add    $0x10,%esp
			break;
  8008e3:	e9 30 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 30                	mov    (%eax),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 05                	jne    800902 <vprintfmt+0x1a6>
				p = "(null)";
  8008fd:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  800902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800906:	7e 6d                	jle    800975 <vprintfmt+0x219>
  800908:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090c:	74 67                	je     800975 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	50                   	push   %eax
  800915:	56                   	push   %esi
  800916:	e8 0c 03 00 00       	call   800c27 <strnlen>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800921:	eb 16                	jmp    800939 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800923:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800936:	ff 4d e4             	decl   -0x1c(%ebp)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7f e4                	jg     800923 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093f:	eb 34                	jmp    800975 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800941:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800945:	74 1c                	je     800963 <vprintfmt+0x207>
  800947:	83 fb 1f             	cmp    $0x1f,%ebx
  80094a:	7e 05                	jle    800951 <vprintfmt+0x1f5>
  80094c:	83 fb 7e             	cmp    $0x7e,%ebx
  80094f:	7e 12                	jle    800963 <vprintfmt+0x207>
					putch('?', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 3f                	push   $0x3f
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
  80096f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800972:	ff 4d e4             	decl   -0x1c(%ebp)
  800975:	89 f0                	mov    %esi,%eax
  800977:	8d 70 01             	lea    0x1(%eax),%esi
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	0f be d8             	movsbl %al,%ebx
  80097f:	85 db                	test   %ebx,%ebx
  800981:	74 24                	je     8009a7 <vprintfmt+0x24b>
  800983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800987:	78 b8                	js     800941 <vprintfmt+0x1e5>
  800989:	ff 4d e0             	decl   -0x20(%ebp)
  80098c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800990:	79 af                	jns    800941 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800992:	eb 13                	jmp    8009a7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	6a 20                	push   $0x20
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	7f e7                	jg     800994 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ad:	e9 66 01 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 3c fd ff ff       	call   8006fd <getint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	79 23                	jns    8009f7 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 2d                	push   $0x2d
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ea:	f7 d8                	neg    %eax
  8009ec:	83 d2 00             	adc    $0x0,%edx
  8009ef:	f7 da                	neg    %edx
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 bc 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 e8             	pushl  -0x18(%ebp)
  800a09:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0c:	50                   	push   %eax
  800a0d:	e8 84 fc ff ff       	call   800696 <getuint>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 98 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 58                	push   $0x58
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 58                	push   $0x58
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 58                	push   $0x58
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			break;
  800a57:	e9 bc 00 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 30                	push   $0x30
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	6a 78                	push   $0x78
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9e:	eb 1f                	jmp    800abf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa6:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	e8 e7 fb ff ff       	call   800696 <getuint>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	52                   	push   %edx
  800aca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acd:	50                   	push   %eax
  800ace:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 00 fb ff ff       	call   8005df <printnum>
  800adf:	83 c4 20             	add    $0x20,%esp
			break;
  800ae2:	eb 34                	jmp    800b18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	eb 23                	jmp    800b18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 25                	push   $0x25
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	eb 03                	jmp    800b0d <vprintfmt+0x3b1>
  800b0a:	ff 4d 10             	decl   0x10(%ebp)
  800b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b10:	48                   	dec    %eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	3c 25                	cmp    $0x25,%al
  800b15:	75 f3                	jne    800b0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b17:	90                   	nop
		}
	}
  800b18:	e9 47 fc ff ff       	jmp    800764 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b34:	8b 45 10             	mov    0x10(%ebp),%eax
  800b37:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 16 fc ff ff       	call   80075c <vprintfmt>
  800b46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b49:	90                   	nop
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 40 08             	mov    0x8(%eax),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 10                	mov    (%eax),%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8b 40 04             	mov    0x4(%eax),%eax
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	73 12                	jae    800b7f <sprintputch+0x33>
		*b->buf++ = ch;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	8d 48 01             	lea    0x1(%eax),%ecx
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	89 0a                	mov    %ecx,(%edx)
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	88 10                	mov    %dl,(%eax)
}
  800b7f:	90                   	nop
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	01 d0                	add    %edx,%eax
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba7:	74 06                	je     800baf <vsnprintf+0x2d>
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	7f 07                	jg     800bb6 <vsnprintf+0x34>
		return -E_INVAL;
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	eb 20                	jmp    800bd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb6:	ff 75 14             	pushl  0x14(%ebp)
  800bb9:	ff 75 10             	pushl  0x10(%ebp)
  800bbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	68 4c 0b 80 00       	push   $0x800b4c
  800bc5:	e8 92 fb ff ff       	call   80075c <vprintfmt>
  800bca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 89 ff ff ff       	call   800b82 <vsnprintf>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c11:	eb 06                	jmp    800c19 <strlen+0x15>
		n++;
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 f1                	jne    800c13 <strlen+0xf>
		n++;
	return n;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 09                	jmp    800c3f <strnlen+0x18>
		n++;
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 4d 0c             	decl   0xc(%ebp)
  800c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c43:	74 09                	je     800c4e <strnlen+0x27>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	75 e8                	jne    800c36 <strnlen+0xf>
		n++;
	return n;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c5f:	90                   	nop
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c72:	8a 12                	mov    (%edx),%dl
  800c74:	88 10                	mov    %dl,(%eax)
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 e4                	jne    800c60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 1f                	jmp    800cb5 <strncpy+0x34>
		*dst++ = *src;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	74 03                	je     800cb2 <strncpy+0x31>
			src++;
  800caf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	ff 45 fc             	incl   -0x4(%ebp)
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbb:	72 d9                	jb     800c96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	74 30                	je     800d04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd4:	eb 16                	jmp    800cec <strlcpy+0x2a>
			*dst++ = *src++;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce8:	8a 12                	mov    (%edx),%dl
  800cea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf3:	74 09                	je     800cfe <strlcpy+0x3c>
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 d8                	jne    800cd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	29 c2                	sub    %eax,%edx
  800d0c:	89 d0                	mov    %edx,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d13:	eb 06                	jmp    800d1b <strcmp+0xb>
		p++, q++;
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	84 c0                	test   %al,%al
  800d22:	74 0e                	je     800d32 <strcmp+0x22>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	38 c2                	cmp    %al,%dl
  800d30:	74 e3                	je     800d15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 d0             	movzbl %al,%edx
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 c0             	movzbl %al,%eax
  800d42:	29 c2                	sub    %eax,%edx
  800d44:	89 d0                	mov    %edx,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4b:	eb 09                	jmp    800d56 <strncmp+0xe>
		n--, p++, q++;
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 17                	je     800d73 <strncmp+0x2b>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	74 0e                	je     800d73 <strncmp+0x2b>
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 10                	mov    (%eax),%dl
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	38 c2                	cmp    %al,%dl
  800d71:	74 da                	je     800d4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d77:	75 07                	jne    800d80 <strncmp+0x38>
		return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 14                	jmp    800d94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 c0             	movzbl %al,%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
}
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 04             	sub    $0x4,%esp
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da2:	eb 12                	jmp    800db6 <strchr+0x20>
		if (*s == c)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dac:	75 05                	jne    800db3 <strchr+0x1d>
			return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	eb 11                	jmp    800dc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e5                	jne    800da4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 0d                	jmp    800de1 <strfind+0x1b>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	74 0e                	je     800dec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dde:	ff 45 08             	incl   0x8(%ebp)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	75 ea                	jne    800dd4 <strfind+0xe>
  800dea:	eb 01                	jmp    800ded <strfind+0x27>
		if (*s == c)
			break;
  800dec:	90                   	nop
	return (char *) s;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e04:	eb 0e                	jmp    800e14 <memset+0x22>
		*p++ = c;
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e09:	8d 50 01             	lea    0x1(%eax),%edx
  800e0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e14:	ff 4d f8             	decl   -0x8(%ebp)
  800e17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1b:	79 e9                	jns    800e06 <memset+0x14>
		*p++ = c;

	return v;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e34:	eb 16                	jmp    800e4c <memcpy+0x2a>
		*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e76:	73 50                	jae    800ec8 <memmove+0x6a>
  800e78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	01 d0                	add    %edx,%eax
  800e80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e83:	76 43                	jbe    800ec8 <memmove+0x6a>
		s += n;
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e91:	eb 10                	jmp    800ea3 <memmove+0x45>
			*--d = *--s;
  800e93:	ff 4d f8             	decl   -0x8(%ebp)
  800e96:	ff 4d fc             	decl   -0x4(%ebp)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	75 e3                	jne    800e93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb0:	eb 23                	jmp    800ed5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 dd                	jne    800eb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eec:	eb 2a                	jmp    800f18 <memcmp+0x3e>
		if (*s1 != *s2)
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	8a 10                	mov    (%eax),%dl
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	38 c2                	cmp    %al,%dl
  800efa:	74 16                	je     800f12 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d0             	movzbl %al,%edx
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	29 c2                	sub    %eax,%edx
  800f0e:	89 d0                	mov    %edx,%eax
  800f10:	eb 18                	jmp    800f2a <memcmp+0x50>
		s1++, s2++;
  800f12:	ff 45 fc             	incl   -0x4(%ebp)
  800f15:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 c9                	jne    800eee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f3d:	eb 15                	jmp    800f54 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 d0             	movzbl %al,%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	74 0d                	je     800f5e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5a:	72 e3                	jb     800f3f <memfind+0x13>
  800f5c:	eb 01                	jmp    800f5f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f5e:	90                   	nop
	return (void *) s;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f78:	eb 03                	jmp    800f7d <strtol+0x19>
		s++;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 20                	cmp    $0x20,%al
  800f84:	74 f4                	je     800f7a <strtol+0x16>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 09                	cmp    $0x9,%al
  800f8d:	74 eb                	je     800f7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 2b                	cmp    $0x2b,%al
  800f96:	75 05                	jne    800f9d <strtol+0x39>
		s++;
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	eb 13                	jmp    800fb0 <strtol+0x4c>
	else if (*s == '-')
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 2d                	cmp    $0x2d,%al
  800fa4:	75 0a                	jne    800fb0 <strtol+0x4c>
		s++, neg = 1;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb4:	74 06                	je     800fbc <strtol+0x58>
  800fb6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fba:	75 20                	jne    800fdc <strtol+0x78>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 30                	cmp    $0x30,%al
  800fc3:	75 17                	jne    800fdc <strtol+0x78>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	40                   	inc    %eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 78                	cmp    $0x78,%al
  800fcd:	75 0d                	jne    800fdc <strtol+0x78>
		s += 2, base = 16;
  800fcf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fda:	eb 28                	jmp    801004 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 15                	jne    800ff7 <strtol+0x93>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 30                	cmp    $0x30,%al
  800fe9:	75 0c                	jne    800ff7 <strtol+0x93>
		s++, base = 8;
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff5:	eb 0d                	jmp    801004 <strtol+0xa0>
	else if (base == 0)
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 07                	jne    801004 <strtol+0xa0>
		base = 10;
  800ffd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2f                	cmp    $0x2f,%al
  80100b:	7e 19                	jle    801026 <strtol+0xc2>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 39                	cmp    $0x39,%al
  801014:	7f 10                	jg     801026 <strtol+0xc2>
			dig = *s - '0';
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 30             	sub    $0x30,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801024:	eb 42                	jmp    801068 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 60                	cmp    $0x60,%al
  80102d:	7e 19                	jle    801048 <strtol+0xe4>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 7a                	cmp    $0x7a,%al
  801036:	7f 10                	jg     801048 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	83 e8 57             	sub    $0x57,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801046:	eb 20                	jmp    801068 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 40                	cmp    $0x40,%al
  80104f:	7e 39                	jle    80108a <strtol+0x126>
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 5a                	cmp    $0x5a,%al
  801058:	7f 30                	jg     80108a <strtol+0x126>
			dig = *s - 'A' + 10;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f be c0             	movsbl %al,%eax
  801062:	83 e8 37             	sub    $0x37,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80106e:	7d 19                	jge    801089 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801084:	e9 7b ff ff ff       	jmp    801004 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801089:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108e:	74 08                	je     801098 <strtol+0x134>
		*endptr = (char *) s;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801098:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109c:	74 07                	je     8010a5 <strtol+0x141>
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	f7 d8                	neg    %eax
  8010a3:	eb 03                	jmp    8010a8 <strtol+0x144>
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <ltostr>:

void
ltostr(long value, char *str)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c2:	79 13                	jns    8010d7 <ltostr+0x2d>
	{
		neg = 1;
  8010c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010df:	99                   	cltd   
  8010e0:	f7 f9                	idiv   %ecx
  8010e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	83 c2 30             	add    $0x30,%edx
  8010fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801100:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801105:	f7 e9                	imul   %ecx
  801107:	c1 fa 02             	sar    $0x2,%edx
  80110a:	89 c8                	mov    %ecx,%eax
  80110c:	c1 f8 1f             	sar    $0x1f,%eax
  80110f:	29 c2                	sub    %eax,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111e:	f7 e9                	imul   %ecx
  801120:	c1 fa 02             	sar    $0x2,%edx
  801123:	89 c8                	mov    %ecx,%eax
  801125:	c1 f8 1f             	sar    $0x1f,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	c1 e0 02             	shl    $0x2,%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	01 c0                	add    %eax,%eax
  801133:	29 c1                	sub    %eax,%ecx
  801135:	89 ca                	mov    %ecx,%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	75 9c                	jne    8010d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	48                   	dec    %eax
  801146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114d:	74 3d                	je     80118c <ltostr+0xe2>
		start = 1 ;
  80114f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801156:	eb 34                	jmp    80118c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	01 c8                	add    %ecx,%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8a 45 eb             	mov    -0x15(%ebp),%al
  801184:	88 02                	mov    %al,(%edx)
		start++ ;
  801186:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801189:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801192:	7c c4                	jl     801158 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801194:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80119f:	90                   	nop
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	e8 54 fa ff ff       	call   800c04 <strlen>
  8011b0:	83 c4 04             	add    $0x4,%esp
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	e8 46 fa ff ff       	call   800c04 <strlen>
  8011be:	83 c4 04             	add    $0x4,%esp
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d2:	eb 17                	jmp    8011eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 c2                	add    %eax,%edx
  8011dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	01 c8                	add    %ecx,%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e8:	ff 45 fc             	incl   -0x4(%ebp)
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f1:	7c e1                	jl     8011d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801201:	eb 1f                	jmp    801222 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 c2                	add    %eax,%edx
  801213:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 c8                	add    %ecx,%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801228:	7c d9                	jl     801203 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c6 00 00             	movb   $0x0,(%eax)
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125b:	eb 0c                	jmp    801269 <strsplit+0x31>
			*string++ = 0;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 18                	je     80128a <strsplit+0x52>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 13 fb ff ff       	call   800d96 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	75 d3                	jne    80125d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	74 5a                	je     8012ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	83 f8 0f             	cmp    $0xf,%eax
  80129b:	75 07                	jne    8012a4 <strsplit+0x6c>
		{
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb 66                	jmp    80130a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8012af:	89 0a                	mov    %ecx,(%edx)
  8012b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c2:	eb 03                	jmp    8012c7 <strsplit+0x8f>
			string++;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 8b                	je     80125b <strsplit+0x23>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	0f be c0             	movsbl %al,%eax
  8012d8:	50                   	push   %eax
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 b5 fa ff ff       	call   800d96 <strchr>
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	74 dc                	je     8012c4 <strsplit+0x8c>
			string++;
	}
  8012e8:	e9 6e ff ff ff       	jmp    80125b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801305:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801312:	a1 04 40 80 00       	mov    0x804004,%eax
  801317:	85 c0                	test   %eax,%eax
  801319:	74 1f                	je     80133a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131b:	e8 1d 00 00 00       	call   80133d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	68 30 3b 80 00       	push   $0x803b30
  801328:	e8 55 f2 ff ff       	call   800582 <cprintf>
  80132d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801330:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801337:	00 00 00 
	}
}
  80133a:	90                   	nop
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801343:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134a:	00 00 00 
  80134d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801354:	00 00 00 
  801357:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80135e:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801361:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801368:	00 00 00 
  80136b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801372:	00 00 00 
  801375:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80137c:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80137f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801386:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801389:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801390:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a4:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8013a9:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8013b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	6a 06                	push   $0x6
  8013c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c5:	50                   	push   %eax
  8013c6:	e8 ee 05 00 00       	call   8019b9 <sys_allocate_chunk>
  8013cb:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ce:	a1 20 41 80 00       	mov    0x804120,%eax
  8013d3:	83 ec 0c             	sub    $0xc,%esp
  8013d6:	50                   	push   %eax
  8013d7:	e8 63 0c 00 00       	call   80203f <initialize_MemBlocksList>
  8013dc:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8013df:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8013e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ea:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8013f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801402:	89 c2                	mov    %eax,%edx
  801404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801407:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  80140a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801414:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80141b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80141e:	8b 50 08             	mov    0x8(%eax),%edx
  801421:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	48                   	dec    %eax
  801427:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80142a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142d:	ba 00 00 00 00       	mov    $0x0,%edx
  801432:	f7 75 e0             	divl   -0x20(%ebp)
  801435:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801438:	29 d0                	sub    %edx,%eax
  80143a:	89 c2                	mov    %eax,%edx
  80143c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143f:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801442:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801446:	75 14                	jne    80145c <initialize_dyn_block_system+0x11f>
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	68 55 3b 80 00       	push   $0x803b55
  801450:	6a 34                	push   $0x34
  801452:	68 73 3b 80 00       	push   $0x803b73
  801457:	e8 72 ee ff ff       	call   8002ce <_panic>
  80145c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145f:	8b 00                	mov    (%eax),%eax
  801461:	85 c0                	test   %eax,%eax
  801463:	74 10                	je     801475 <initialize_dyn_block_system+0x138>
  801465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801468:	8b 00                	mov    (%eax),%eax
  80146a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80146d:	8b 52 04             	mov    0x4(%edx),%edx
  801470:	89 50 04             	mov    %edx,0x4(%eax)
  801473:	eb 0b                	jmp    801480 <initialize_dyn_block_system+0x143>
  801475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801478:	8b 40 04             	mov    0x4(%eax),%eax
  80147b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801483:	8b 40 04             	mov    0x4(%eax),%eax
  801486:	85 c0                	test   %eax,%eax
  801488:	74 0f                	je     801499 <initialize_dyn_block_system+0x15c>
  80148a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148d:	8b 40 04             	mov    0x4(%eax),%eax
  801490:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801493:	8b 12                	mov    (%edx),%edx
  801495:	89 10                	mov    %edx,(%eax)
  801497:	eb 0a                	jmp    8014a3 <initialize_dyn_block_system+0x166>
  801499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80149c:	8b 00                	mov    (%eax),%eax
  80149e:	a3 48 41 80 00       	mov    %eax,0x804148
  8014a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014b6:	a1 54 41 80 00       	mov    0x804154,%eax
  8014bb:	48                   	dec    %eax
  8014bc:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8014c1:	83 ec 0c             	sub    $0xc,%esp
  8014c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8014c7:	e8 c4 13 00 00       	call   802890 <insert_sorted_with_merge_freeList>
  8014cc:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014d8:	e8 2f fe ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  8014dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e1:	75 07                	jne    8014ea <malloc+0x18>
  8014e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e8:	eb 71                	jmp    80155b <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8014ea:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8014f1:	76 07                	jbe    8014fa <malloc+0x28>
	return NULL;
  8014f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f8:	eb 61                	jmp    80155b <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014fa:	e8 88 08 00 00       	call   801d87 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 53                	je     801556 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801503:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80150a:	8b 55 08             	mov    0x8(%ebp),%edx
  80150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801510:	01 d0                	add    %edx,%eax
  801512:	48                   	dec    %eax
  801513:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801519:	ba 00 00 00 00       	mov    $0x0,%edx
  80151e:	f7 75 f4             	divl   -0xc(%ebp)
  801521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801524:	29 d0                	sub    %edx,%eax
  801526:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801529:	83 ec 0c             	sub    $0xc,%esp
  80152c:	ff 75 ec             	pushl  -0x14(%ebp)
  80152f:	e8 d2 0d 00 00       	call   802306 <alloc_block_FF>
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80153a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80153e:	74 16                	je     801556 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	ff 75 e8             	pushl  -0x18(%ebp)
  801546:	e8 0c 0c 00 00       	call   802157 <insert_sorted_allocList>
  80154b:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80154e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801551:	8b 40 08             	mov    0x8(%eax),%eax
  801554:	eb 05                	jmp    80155b <malloc+0x89>
    }

			}


	return NULL;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801571:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 f0             	pushl  -0x10(%ebp)
  80157a:	68 40 40 80 00       	push   $0x804040
  80157f:	e8 a0 0b 00 00       	call   802124 <find_block>
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80158a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158d:	8b 50 0c             	mov    0xc(%eax),%edx
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	52                   	push   %edx
  801597:	50                   	push   %eax
  801598:	e8 e4 03 00 00       	call   801981 <sys_free_user_mem>
  80159d:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8015a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015a4:	75 17                	jne    8015bd <free+0x60>
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	68 55 3b 80 00       	push   $0x803b55
  8015ae:	68 84 00 00 00       	push   $0x84
  8015b3:	68 73 3b 80 00       	push   $0x803b73
  8015b8:	e8 11 ed ff ff       	call   8002ce <_panic>
  8015bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c0:	8b 00                	mov    (%eax),%eax
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	74 10                	je     8015d6 <free+0x79>
  8015c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c9:	8b 00                	mov    (%eax),%eax
  8015cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015ce:	8b 52 04             	mov    0x4(%edx),%edx
  8015d1:	89 50 04             	mov    %edx,0x4(%eax)
  8015d4:	eb 0b                	jmp    8015e1 <free+0x84>
  8015d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d9:	8b 40 04             	mov    0x4(%eax),%eax
  8015dc:	a3 44 40 80 00       	mov    %eax,0x804044
  8015e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e4:	8b 40 04             	mov    0x4(%eax),%eax
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	74 0f                	je     8015fa <free+0x9d>
  8015eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ee:	8b 40 04             	mov    0x4(%eax),%eax
  8015f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015f4:	8b 12                	mov    (%edx),%edx
  8015f6:	89 10                	mov    %edx,(%eax)
  8015f8:	eb 0a                	jmp    801604 <free+0xa7>
  8015fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fd:	8b 00                	mov    (%eax),%eax
  8015ff:	a3 40 40 80 00       	mov    %eax,0x804040
  801604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801607:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80160d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801610:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801617:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80161c:	48                   	dec    %eax
  80161d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801622:	83 ec 0c             	sub    $0xc,%esp
  801625:	ff 75 ec             	pushl  -0x14(%ebp)
  801628:	e8 63 12 00 00       	call   802890 <insert_sorted_with_merge_freeList>
  80162d:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801630:	90                   	nop
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 38             	sub    $0x38,%esp
  801639:	8b 45 10             	mov    0x10(%ebp),%eax
  80163c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163f:	e8 c8 fc ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801644:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801648:	75 0a                	jne    801654 <smalloc+0x21>
  80164a:	b8 00 00 00 00       	mov    $0x0,%eax
  80164f:	e9 a0 00 00 00       	jmp    8016f4 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801654:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80165b:	76 0a                	jbe    801667 <smalloc+0x34>
		return NULL;
  80165d:	b8 00 00 00 00       	mov    $0x0,%eax
  801662:	e9 8d 00 00 00       	jmp    8016f4 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801667:	e8 1b 07 00 00       	call   801d87 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80166c:	85 c0                	test   %eax,%eax
  80166e:	74 7f                	je     8016ef <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801670:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	01 d0                	add    %edx,%eax
  80167f:	48                   	dec    %eax
  801680:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801686:	ba 00 00 00 00       	mov    $0x0,%edx
  80168b:	f7 75 f4             	divl   -0xc(%ebp)
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	29 d0                	sub    %edx,%eax
  801693:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	ff 75 ec             	pushl  -0x14(%ebp)
  80169c:	e8 65 0c 00 00       	call   802306 <alloc_block_FF>
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8016a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016ab:	74 42                	je     8016ef <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8016ad:	83 ec 0c             	sub    $0xc,%esp
  8016b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b3:	e8 9f 0a 00 00       	call   802157 <insert_sorted_allocList>
  8016b8:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8016bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016be:	8b 40 08             	mov    0x8(%eax),%eax
  8016c1:	89 c2                	mov    %eax,%edx
  8016c3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016c7:	52                   	push   %edx
  8016c8:	50                   	push   %eax
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	ff 75 08             	pushl  0x8(%ebp)
  8016cf:	e8 38 04 00 00       	call   801b0c <sys_createSharedObject>
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8016da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016de:	79 07                	jns    8016e7 <smalloc+0xb4>
	    		  return NULL;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e5:	eb 0d                	jmp    8016f4 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8016e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ea:	8b 40 08             	mov    0x8(%eax),%eax
  8016ed:	eb 05                	jmp    8016f4 <smalloc+0xc1>


				}


		return NULL;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016fc:	e8 0b fc ff ff       	call   80130c <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801701:	e8 81 06 00 00       	call   801d87 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801706:	85 c0                	test   %eax,%eax
  801708:	0f 84 9f 00 00 00    	je     8017ad <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	ff 75 0c             	pushl  0xc(%ebp)
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	e8 1a 04 00 00       	call   801b36 <sys_getSizeOfSharedObject>
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801722:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801726:	79 0a                	jns    801732 <sget+0x3c>
		return NULL;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	e9 80 00 00 00       	jmp    8017b2 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801732:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801739:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173f:	01 d0                	add    %edx,%eax
  801741:	48                   	dec    %eax
  801742:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801748:	ba 00 00 00 00       	mov    $0x0,%edx
  80174d:	f7 75 f0             	divl   -0x10(%ebp)
  801750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801753:	29 d0                	sub    %edx,%eax
  801755:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	ff 75 e8             	pushl  -0x18(%ebp)
  80175e:	e8 a3 0b 00 00       	call   802306 <alloc_block_FF>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801769:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80176d:	74 3e                	je     8017ad <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	ff 75 e4             	pushl  -0x1c(%ebp)
  801775:	e8 dd 09 00 00       	call   802157 <insert_sorted_allocList>
  80177a:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80177d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801780:	8b 40 08             	mov    0x8(%eax),%eax
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	50                   	push   %eax
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	e8 c1 03 00 00       	call   801b53 <sys_getSharedObject>
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801798:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80179c:	79 07                	jns    8017a5 <sget+0xaf>
	    		  return NULL;
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	eb 0d                	jmp    8017b2 <sget+0xbc>
	  	return(void*) returned_block->sva;
  8017a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a8:	8b 40 08             	mov    0x8(%eax),%eax
  8017ab:	eb 05                	jmp    8017b2 <sget+0xbc>
	      }
	}
	   return NULL;
  8017ad:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ba:	e8 4d fb ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 80 3b 80 00       	push   $0x803b80
  8017c7:	68 12 01 00 00       	push   $0x112
  8017cc:	68 73 3b 80 00       	push   $0x803b73
  8017d1:	e8 f8 ea ff ff       	call   8002ce <_panic>

008017d6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 a8 3b 80 00       	push   $0x803ba8
  8017e4:	68 26 01 00 00       	push   $0x126
  8017e9:	68 73 3b 80 00       	push   $0x803b73
  8017ee:	e8 db ea ff ff       	call   8002ce <_panic>

008017f3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	68 cc 3b 80 00       	push   $0x803bcc
  801801:	68 31 01 00 00       	push   $0x131
  801806:	68 73 3b 80 00       	push   $0x803b73
  80180b:	e8 be ea ff ff       	call   8002ce <_panic>

00801810 <shrink>:

}
void shrink(uint32 newSize)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	68 cc 3b 80 00       	push   $0x803bcc
  80181e:	68 36 01 00 00       	push   $0x136
  801823:	68 73 3b 80 00       	push   $0x803b73
  801828:	e8 a1 ea ff ff       	call   8002ce <_panic>

0080182d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	68 cc 3b 80 00       	push   $0x803bcc
  80183b:	68 3b 01 00 00       	push   $0x13b
  801840:	68 73 3b 80 00       	push   $0x803b73
  801845:	e8 84 ea ff ff       	call   8002ce <_panic>

0080184a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	57                   	push   %edi
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
  801850:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801862:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801865:	cd 30                	int    $0x30
  801867:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	5b                   	pop    %ebx
  801871:	5e                   	pop    %esi
  801872:	5f                   	pop    %edi
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    

00801875 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	8b 45 10             	mov    0x10(%ebp),%eax
  80187e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801881:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	52                   	push   %edx
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	50                   	push   %eax
  801891:	6a 00                	push   $0x0
  801893:	e8 b2 ff ff ff       	call   80184a <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	90                   	nop
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_cgetc>:

int
sys_cgetc(void)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 01                	push   $0x1
  8018ad:	e8 98 ff ff ff       	call   80184a <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	6a 05                	push   $0x5
  8018ca:	e8 7b ff ff ff       	call   80184a <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018d9:	8b 75 18             	mov    0x18(%ebp),%esi
  8018dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	56                   	push   %esi
  8018e9:	53                   	push   %ebx
  8018ea:	51                   	push   %ecx
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	6a 06                	push   $0x6
  8018ef:	e8 56 ff ff ff       	call   80184a <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5e                   	pop    %esi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	52                   	push   %edx
  80190e:	50                   	push   %eax
  80190f:	6a 07                	push   $0x7
  801911:	e8 34 ff ff ff       	call   80184a <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	ff 75 08             	pushl  0x8(%ebp)
  80192a:	6a 08                	push   $0x8
  80192c:	e8 19 ff ff ff       	call   80184a <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 09                	push   $0x9
  801945:	e8 00 ff ff ff       	call   80184a <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 0a                	push   $0xa
  80195e:	e8 e7 fe ff ff       	call   80184a <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 0b                	push   $0xb
  801977:	e8 ce fe ff ff       	call   80184a <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	6a 0f                	push   $0xf
  801992:	e8 b3 fe ff ff       	call   80184a <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
	return;
  80199a:	90                   	nop
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 10                	push   $0x10
  8019ae:	e8 97 fe ff ff       	call   80184a <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b6:	90                   	nop
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	ff 75 10             	pushl  0x10(%ebp)
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	ff 75 08             	pushl  0x8(%ebp)
  8019c9:	6a 11                	push   $0x11
  8019cb:	e8 7a fe ff ff       	call   80184a <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d3:	90                   	nop
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 0c                	push   $0xc
  8019e5:	e8 60 fe ff ff       	call   80184a <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	ff 75 08             	pushl  0x8(%ebp)
  8019fd:	6a 0d                	push   $0xd
  8019ff:	e8 46 fe ff ff       	call   80184a <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 0e                	push   $0xe
  801a18:	e8 2d fe ff ff       	call   80184a <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	90                   	nop
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 13                	push   $0x13
  801a32:	e8 13 fe ff ff       	call   80184a <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 14                	push   $0x14
  801a4c:	e8 f9 fd ff ff       	call   80184a <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	90                   	nop
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a63:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	50                   	push   %eax
  801a70:	6a 15                	push   $0x15
  801a72:	e8 d3 fd ff ff       	call   80184a <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	90                   	nop
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 16                	push   $0x16
  801a8c:	e8 b9 fd ff ff       	call   80184a <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	50                   	push   %eax
  801aa7:	6a 17                	push   $0x17
  801aa9:	e8 9c fd ff ff       	call   80184a <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	6a 1a                	push   $0x1a
  801ac6:	e8 7f fd ff ff       	call   80184a <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	52                   	push   %edx
  801ae0:	50                   	push   %eax
  801ae1:	6a 18                	push   $0x18
  801ae3:	e8 62 fd ff ff       	call   80184a <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	52                   	push   %edx
  801afe:	50                   	push   %eax
  801aff:	6a 19                	push   $0x19
  801b01:	e8 44 fd ff ff       	call   80184a <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 04             	sub    $0x4,%esp
  801b12:	8b 45 10             	mov    0x10(%ebp),%eax
  801b15:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b18:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	51                   	push   %ecx
  801b25:	52                   	push   %edx
  801b26:	ff 75 0c             	pushl  0xc(%ebp)
  801b29:	50                   	push   %eax
  801b2a:	6a 1b                	push   $0x1b
  801b2c:	e8 19 fd ff ff       	call   80184a <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	6a 1c                	push   $0x1c
  801b49:	e8 fc fc ff ff       	call   80184a <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	51                   	push   %ecx
  801b64:	52                   	push   %edx
  801b65:	50                   	push   %eax
  801b66:	6a 1d                	push   $0x1d
  801b68:	e8 dd fc ff ff       	call   80184a <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	52                   	push   %edx
  801b82:	50                   	push   %eax
  801b83:	6a 1e                	push   $0x1e
  801b85:	e8 c0 fc ff ff       	call   80184a <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 1f                	push   $0x1f
  801b9e:	e8 a7 fc ff ff       	call   80184a <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	ff 75 14             	pushl  0x14(%ebp)
  801bb3:	ff 75 10             	pushl  0x10(%ebp)
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	50                   	push   %eax
  801bba:	6a 20                	push   $0x20
  801bbc:	e8 89 fc ff ff       	call   80184a <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	50                   	push   %eax
  801bd5:	6a 21                	push   $0x21
  801bd7:	e8 6e fc ff ff       	call   80184a <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	90                   	nop
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	50                   	push   %eax
  801bf1:	6a 22                	push   $0x22
  801bf3:	e8 52 fc ff ff       	call   80184a <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 02                	push   $0x2
  801c0c:	e8 39 fc ff ff       	call   80184a <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 03                	push   $0x3
  801c25:	e8 20 fc ff ff       	call   80184a <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 04                	push   $0x4
  801c3e:	e8 07 fc ff ff       	call   80184a <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_exit_env>:


void sys_exit_env(void)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 23                	push   $0x23
  801c57:	e8 ee fb ff ff       	call   80184a <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	90                   	nop
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c68:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6b:	8d 50 04             	lea    0x4(%eax),%edx
  801c6e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	6a 24                	push   $0x24
  801c7b:	e8 ca fb ff ff       	call   80184a <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
	return result;
  801c83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c8c:	89 01                	mov    %eax,(%ecx)
  801c8e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	c9                   	leave  
  801c95:	c2 04 00             	ret    $0x4

00801c98 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	ff 75 10             	pushl  0x10(%ebp)
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	ff 75 08             	pushl  0x8(%ebp)
  801ca8:	6a 12                	push   $0x12
  801caa:	e8 9b fb ff ff       	call   80184a <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb2:	90                   	nop
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 25                	push   $0x25
  801cc4:	e8 81 fb ff ff       	call   80184a <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cda:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	50                   	push   %eax
  801ce7:	6a 26                	push   $0x26
  801ce9:	e8 5c fb ff ff       	call   80184a <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf1:	90                   	nop
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <rsttst>:
void rsttst()
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 28                	push   $0x28
  801d03:	e8 42 fb ff ff       	call   80184a <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0b:	90                   	nop
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 04             	sub    $0x4,%esp
  801d14:	8b 45 14             	mov    0x14(%ebp),%eax
  801d17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d1a:	8b 55 18             	mov    0x18(%ebp),%edx
  801d1d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d21:	52                   	push   %edx
  801d22:	50                   	push   %eax
  801d23:	ff 75 10             	pushl  0x10(%ebp)
  801d26:	ff 75 0c             	pushl  0xc(%ebp)
  801d29:	ff 75 08             	pushl  0x8(%ebp)
  801d2c:	6a 27                	push   $0x27
  801d2e:	e8 17 fb ff ff       	call   80184a <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
	return ;
  801d36:	90                   	nop
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <chktst>:
void chktst(uint32 n)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	ff 75 08             	pushl  0x8(%ebp)
  801d47:	6a 29                	push   $0x29
  801d49:	e8 fc fa ff ff       	call   80184a <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d51:	90                   	nop
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <inctst>:

void inctst()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 2a                	push   $0x2a
  801d63:	e8 e2 fa ff ff       	call   80184a <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <gettst>:
uint32 gettst()
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 2b                	push   $0x2b
  801d7d:	e8 c8 fa ff ff       	call   80184a <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 2c                	push   $0x2c
  801d99:	e8 ac fa ff ff       	call   80184a <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
  801da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801da8:	75 07                	jne    801db1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801daa:	b8 01 00 00 00       	mov    $0x1,%eax
  801daf:	eb 05                	jmp    801db6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 2c                	push   $0x2c
  801dca:	e8 7b fa ff ff       	call   80184a <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
  801dd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dd5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dd9:	75 07                	jne    801de2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ddb:	b8 01 00 00 00       	mov    $0x1,%eax
  801de0:	eb 05                	jmp    801de7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 2c                	push   $0x2c
  801dfb:	e8 4a fa ff ff       	call   80184a <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
  801e03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e06:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e0a:	75 07                	jne    801e13 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e11:	eb 05                	jmp    801e18 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 2c                	push   $0x2c
  801e2c:	e8 19 fa ff ff       	call   80184a <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
  801e34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e37:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e3b:	75 07                	jne    801e44 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e42:	eb 05                	jmp    801e49 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	ff 75 08             	pushl  0x8(%ebp)
  801e59:	6a 2d                	push   $0x2d
  801e5b:	e8 ea f9 ff ff       	call   80184a <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
	return ;
  801e63:	90                   	nop
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e6a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	6a 00                	push   $0x0
  801e78:	53                   	push   %ebx
  801e79:	51                   	push   %ecx
  801e7a:	52                   	push   %edx
  801e7b:	50                   	push   %eax
  801e7c:	6a 2e                	push   $0x2e
  801e7e:	e8 c7 f9 ff ff       	call   80184a <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	52                   	push   %edx
  801e9b:	50                   	push   %eax
  801e9c:	6a 2f                	push   $0x2f
  801e9e:	e8 a7 f9 ff ff       	call   80184a <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	68 dc 3b 80 00       	push   $0x803bdc
  801eb6:	e8 c7 e6 ff ff       	call   800582 <cprintf>
  801ebb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ebe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	68 08 3c 80 00       	push   $0x803c08
  801ecd:	e8 b0 e6 ff ff       	call   800582 <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ed5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed9:	a1 38 41 80 00       	mov    0x804138,%eax
  801ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee1:	eb 56                	jmp    801f39 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee7:	74 1c                	je     801f05 <print_mem_block_lists+0x5d>
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 50 08             	mov    0x8(%eax),%edx
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef2:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	01 c8                	add    %ecx,%eax
  801efd:	39 c2                	cmp    %eax,%edx
  801eff:	73 04                	jae    801f05 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f01:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 50 08             	mov    0x8(%eax),%edx
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f11:	01 c2                	add    %eax,%edx
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	8b 40 08             	mov    0x8(%eax),%eax
  801f19:	83 ec 04             	sub    $0x4,%esp
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	68 1d 3c 80 00       	push   $0x803c1d
  801f23:	e8 5a e6 ff ff       	call   800582 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f31:	a1 40 41 80 00       	mov    0x804140,%eax
  801f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3d:	74 07                	je     801f46 <print_mem_block_lists+0x9e>
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 00                	mov    (%eax),%eax
  801f44:	eb 05                	jmp    801f4b <print_mem_block_lists+0xa3>
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	a3 40 41 80 00       	mov    %eax,0x804140
  801f50:	a1 40 41 80 00       	mov    0x804140,%eax
  801f55:	85 c0                	test   %eax,%eax
  801f57:	75 8a                	jne    801ee3 <print_mem_block_lists+0x3b>
  801f59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5d:	75 84                	jne    801ee3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f5f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f63:	75 10                	jne    801f75 <print_mem_block_lists+0xcd>
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 2c 3c 80 00       	push   $0x803c2c
  801f6d:	e8 10 e6 ff ff       	call   800582 <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f75:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	68 50 3c 80 00       	push   $0x803c50
  801f84:	e8 f9 e5 ff ff       	call   800582 <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f8c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f90:	a1 40 40 80 00       	mov    0x804040,%eax
  801f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f98:	eb 56                	jmp    801ff0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9e:	74 1c                	je     801fbc <print_mem_block_lists+0x114>
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 50 08             	mov    0x8(%eax),%edx
  801fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa9:	8b 48 08             	mov    0x8(%eax),%ecx
  801fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb2:	01 c8                	add    %ecx,%eax
  801fb4:	39 c2                	cmp    %eax,%edx
  801fb6:	73 04                	jae    801fbc <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fb8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	8b 50 08             	mov    0x8(%eax),%edx
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc8:	01 c2                	add    %eax,%edx
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	8b 40 08             	mov    0x8(%eax),%eax
  801fd0:	83 ec 04             	sub    $0x4,%esp
  801fd3:	52                   	push   %edx
  801fd4:	50                   	push   %eax
  801fd5:	68 1d 3c 80 00       	push   $0x803c1d
  801fda:	e8 a3 e5 ff ff       	call   800582 <cprintf>
  801fdf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fe8:	a1 48 40 80 00       	mov    0x804048,%eax
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff4:	74 07                	je     801ffd <print_mem_block_lists+0x155>
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	eb 05                	jmp    802002 <print_mem_block_lists+0x15a>
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	a3 48 40 80 00       	mov    %eax,0x804048
  802007:	a1 48 40 80 00       	mov    0x804048,%eax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	75 8a                	jne    801f9a <print_mem_block_lists+0xf2>
  802010:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802014:	75 84                	jne    801f9a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802016:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80201a:	75 10                	jne    80202c <print_mem_block_lists+0x184>
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	68 68 3c 80 00       	push   $0x803c68
  802024:	e8 59 e5 ff ff       	call   800582 <cprintf>
  802029:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	68 dc 3b 80 00       	push   $0x803bdc
  802034:	e8 49 e5 ff ff       	call   800582 <cprintf>
  802039:	83 c4 10             	add    $0x10,%esp

}
  80203c:	90                   	nop
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802045:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80204c:	00 00 00 
  80204f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802056:	00 00 00 
  802059:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802060:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802063:	a1 50 40 80 00       	mov    0x804050,%eax
  802068:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80206b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802072:	e9 9e 00 00 00       	jmp    802115 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802077:	a1 50 40 80 00       	mov    0x804050,%eax
  80207c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207f:	c1 e2 04             	shl    $0x4,%edx
  802082:	01 d0                	add    %edx,%eax
  802084:	85 c0                	test   %eax,%eax
  802086:	75 14                	jne    80209c <initialize_MemBlocksList+0x5d>
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	68 90 3c 80 00       	push   $0x803c90
  802090:	6a 48                	push   $0x48
  802092:	68 b3 3c 80 00       	push   $0x803cb3
  802097:	e8 32 e2 ff ff       	call   8002ce <_panic>
  80209c:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a4:	c1 e2 04             	shl    $0x4,%edx
  8020a7:	01 d0                	add    %edx,%eax
  8020a9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020af:	89 10                	mov    %edx,(%eax)
  8020b1:	8b 00                	mov    (%eax),%eax
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	74 18                	je     8020cf <initialize_MemBlocksList+0x90>
  8020b7:	a1 48 41 80 00       	mov    0x804148,%eax
  8020bc:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020c2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c5:	c1 e1 04             	shl    $0x4,%ecx
  8020c8:	01 ca                	add    %ecx,%edx
  8020ca:	89 50 04             	mov    %edx,0x4(%eax)
  8020cd:	eb 12                	jmp    8020e1 <initialize_MemBlocksList+0xa2>
  8020cf:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d7:	c1 e2 04             	shl    $0x4,%edx
  8020da:	01 d0                	add    %edx,%eax
  8020dc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020e1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e9:	c1 e2 04             	shl    $0x4,%edx
  8020ec:	01 d0                	add    %edx,%eax
  8020ee:	a3 48 41 80 00       	mov    %eax,0x804148
  8020f3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fb:	c1 e2 04             	shl    $0x4,%edx
  8020fe:	01 d0                	add    %edx,%eax
  802100:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802107:	a1 54 41 80 00       	mov    0x804154,%eax
  80210c:	40                   	inc    %eax
  80210d:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802112:	ff 45 f4             	incl   -0xc(%ebp)
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211b:	0f 82 56 ff ff ff    	jb     802077 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802121:	90                   	nop
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	8b 00                	mov    (%eax),%eax
  80212f:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802132:	eb 18                	jmp    80214c <find_block+0x28>
		{
			if(tmp->sva==va)
  802134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802137:	8b 40 08             	mov    0x8(%eax),%eax
  80213a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80213d:	75 05                	jne    802144 <find_block+0x20>
			{
				return tmp;
  80213f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802142:	eb 11                	jmp    802155 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802147:	8b 00                	mov    (%eax),%eax
  802149:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80214c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802150:	75 e2                	jne    802134 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802152:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80215d:	a1 40 40 80 00       	mov    0x804040,%eax
  802162:	85 c0                	test   %eax,%eax
  802164:	0f 85 83 00 00 00    	jne    8021ed <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80216a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802171:	00 00 00 
  802174:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80217b:	00 00 00 
  80217e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802185:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218c:	75 14                	jne    8021a2 <insert_sorted_allocList+0x4b>
  80218e:	83 ec 04             	sub    $0x4,%esp
  802191:	68 90 3c 80 00       	push   $0x803c90
  802196:	6a 7f                	push   $0x7f
  802198:	68 b3 3c 80 00       	push   $0x803cb3
  80219d:	e8 2c e1 ff ff       	call   8002ce <_panic>
  8021a2:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	89 10                	mov    %edx,(%eax)
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	8b 00                	mov    (%eax),%eax
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	74 0d                	je     8021c3 <insert_sorted_allocList+0x6c>
  8021b6:	a1 40 40 80 00       	mov    0x804040,%eax
  8021bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021be:	89 50 04             	mov    %edx,0x4(%eax)
  8021c1:	eb 08                	jmp    8021cb <insert_sorted_allocList+0x74>
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	a3 40 40 80 00       	mov    %eax,0x804040
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021dd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e2:	40                   	inc    %eax
  8021e3:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021e8:	e9 16 01 00 00       	jmp    802303 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 50 08             	mov    0x8(%eax),%edx
  8021f3:	a1 44 40 80 00       	mov    0x804044,%eax
  8021f8:	8b 40 08             	mov    0x8(%eax),%eax
  8021fb:	39 c2                	cmp    %eax,%edx
  8021fd:	76 68                	jbe    802267 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802203:	75 17                	jne    80221c <insert_sorted_allocList+0xc5>
  802205:	83 ec 04             	sub    $0x4,%esp
  802208:	68 cc 3c 80 00       	push   $0x803ccc
  80220d:	68 85 00 00 00       	push   $0x85
  802212:	68 b3 3c 80 00       	push   $0x803cb3
  802217:	e8 b2 e0 ff ff       	call   8002ce <_panic>
  80221c:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	89 50 04             	mov    %edx,0x4(%eax)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 40 04             	mov    0x4(%eax),%eax
  80222e:	85 c0                	test   %eax,%eax
  802230:	74 0c                	je     80223e <insert_sorted_allocList+0xe7>
  802232:	a1 44 40 80 00       	mov    0x804044,%eax
  802237:	8b 55 08             	mov    0x8(%ebp),%edx
  80223a:	89 10                	mov    %edx,(%eax)
  80223c:	eb 08                	jmp    802246 <insert_sorted_allocList+0xef>
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	a3 40 40 80 00       	mov    %eax,0x804040
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	a3 44 40 80 00       	mov    %eax,0x804044
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802257:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225c:	40                   	inc    %eax
  80225d:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802262:	e9 9c 00 00 00       	jmp    802303 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802267:	a1 40 40 80 00       	mov    0x804040,%eax
  80226c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80226f:	e9 85 00 00 00       	jmp    8022f9 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	8b 50 08             	mov    0x8(%eax),%edx
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 40 08             	mov    0x8(%eax),%eax
  802280:	39 c2                	cmp    %eax,%edx
  802282:	73 6d                	jae    8022f1 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802288:	74 06                	je     802290 <insert_sorted_allocList+0x139>
  80228a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228e:	75 17                	jne    8022a7 <insert_sorted_allocList+0x150>
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 f0 3c 80 00       	push   $0x803cf0
  802298:	68 90 00 00 00       	push   $0x90
  80229d:	68 b3 3c 80 00       	push   $0x803cb3
  8022a2:	e8 27 e0 ff ff       	call   8002ce <_panic>
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 50 04             	mov    0x4(%eax),%edx
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	89 50 04             	mov    %edx,0x4(%eax)
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b9:	89 10                	mov    %edx,(%eax)
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 40 04             	mov    0x4(%eax),%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	74 0d                	je     8022d2 <insert_sorted_allocList+0x17b>
  8022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c8:	8b 40 04             	mov    0x4(%eax),%eax
  8022cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ce:	89 10                	mov    %edx,(%eax)
  8022d0:	eb 08                	jmp    8022da <insert_sorted_allocList+0x183>
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	a3 40 40 80 00       	mov    %eax,0x804040
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e0:	89 50 04             	mov    %edx,0x4(%eax)
  8022e3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e8:	40                   	inc    %eax
  8022e9:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022ee:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022ef:	eb 12                	jmp    802303 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fd:	0f 85 71 ff ff ff    	jne    802274 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802303:	90                   	nop
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80230c:	a1 38 41 80 00       	mov    0x804138,%eax
  802311:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802314:	e9 76 01 00 00       	jmp    80248f <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	8b 40 0c             	mov    0xc(%eax),%eax
  80231f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802322:	0f 85 8a 00 00 00    	jne    8023b2 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232c:	75 17                	jne    802345 <alloc_block_FF+0x3f>
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	68 25 3d 80 00       	push   $0x803d25
  802336:	68 a8 00 00 00       	push   $0xa8
  80233b:	68 b3 3c 80 00       	push   $0x803cb3
  802340:	e8 89 df ff ff       	call   8002ce <_panic>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 00                	mov    (%eax),%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	74 10                	je     80235e <alloc_block_FF+0x58>
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	8b 00                	mov    (%eax),%eax
  802353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802356:	8b 52 04             	mov    0x4(%edx),%edx
  802359:	89 50 04             	mov    %edx,0x4(%eax)
  80235c:	eb 0b                	jmp    802369 <alloc_block_FF+0x63>
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 40 04             	mov    0x4(%eax),%eax
  802364:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 04             	mov    0x4(%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	74 0f                	je     802382 <alloc_block_FF+0x7c>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 40 04             	mov    0x4(%eax),%eax
  802379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237c:	8b 12                	mov    (%edx),%edx
  80237e:	89 10                	mov    %edx,(%eax)
  802380:	eb 0a                	jmp    80238c <alloc_block_FF+0x86>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	a3 38 41 80 00       	mov    %eax,0x804138
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80239f:	a1 44 41 80 00       	mov    0x804144,%eax
  8023a4:	48                   	dec    %eax
  8023a5:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	e9 ea 00 00 00       	jmp    80249c <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023bb:	0f 86 c6 00 00 00    	jbe    802487 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8023c1:	a1 48 41 80 00       	mov    0x804148,%eax
  8023c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cf:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 50 08             	mov    0x8(%eax),%edx
  8023d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023db:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e4:	2b 45 08             	sub    0x8(%ebp),%eax
  8023e7:	89 c2                	mov    %eax,%edx
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 50 08             	mov    0x8(%eax),%edx
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	01 c2                	add    %eax,%edx
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802400:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802404:	75 17                	jne    80241d <alloc_block_FF+0x117>
  802406:	83 ec 04             	sub    $0x4,%esp
  802409:	68 25 3d 80 00       	push   $0x803d25
  80240e:	68 b6 00 00 00       	push   $0xb6
  802413:	68 b3 3c 80 00       	push   $0x803cb3
  802418:	e8 b1 de ff ff       	call   8002ce <_panic>
  80241d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	85 c0                	test   %eax,%eax
  802424:	74 10                	je     802436 <alloc_block_FF+0x130>
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80242e:	8b 52 04             	mov    0x4(%edx),%edx
  802431:	89 50 04             	mov    %edx,0x4(%eax)
  802434:	eb 0b                	jmp    802441 <alloc_block_FF+0x13b>
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	8b 40 04             	mov    0x4(%eax),%eax
  80243c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802444:	8b 40 04             	mov    0x4(%eax),%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	74 0f                	je     80245a <alloc_block_FF+0x154>
  80244b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244e:	8b 40 04             	mov    0x4(%eax),%eax
  802451:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802454:	8b 12                	mov    (%edx),%edx
  802456:	89 10                	mov    %edx,(%eax)
  802458:	eb 0a                	jmp    802464 <alloc_block_FF+0x15e>
  80245a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	a3 48 41 80 00       	mov    %eax,0x804148
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802477:	a1 54 41 80 00       	mov    0x804154,%eax
  80247c:	48                   	dec    %eax
  80247d:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802485:	eb 15                	jmp    80249c <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80248f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802493:	0f 85 80 fe ff ff    	jne    802319 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024a4:	a1 38 41 80 00       	mov    0x804138,%eax
  8024a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8024ac:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8024b3:	e9 c0 00 00 00       	jmp    802578 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c1:	0f 85 8a 00 00 00    	jne    802551 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8024c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cb:	75 17                	jne    8024e4 <alloc_block_BF+0x46>
  8024cd:	83 ec 04             	sub    $0x4,%esp
  8024d0:	68 25 3d 80 00       	push   $0x803d25
  8024d5:	68 cf 00 00 00       	push   $0xcf
  8024da:	68 b3 3c 80 00       	push   $0x803cb3
  8024df:	e8 ea dd ff ff       	call   8002ce <_panic>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	74 10                	je     8024fd <alloc_block_BF+0x5f>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f5:	8b 52 04             	mov    0x4(%edx),%edx
  8024f8:	89 50 04             	mov    %edx,0x4(%eax)
  8024fb:	eb 0b                	jmp    802508 <alloc_block_BF+0x6a>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 40 04             	mov    0x4(%eax),%eax
  802503:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 40 04             	mov    0x4(%eax),%eax
  80250e:	85 c0                	test   %eax,%eax
  802510:	74 0f                	je     802521 <alloc_block_BF+0x83>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 40 04             	mov    0x4(%eax),%eax
  802518:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251b:	8b 12                	mov    (%edx),%edx
  80251d:	89 10                	mov    %edx,(%eax)
  80251f:	eb 0a                	jmp    80252b <alloc_block_BF+0x8d>
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	a3 38 41 80 00       	mov    %eax,0x804138
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253e:	a1 44 41 80 00       	mov    0x804144,%eax
  802543:	48                   	dec    %eax
  802544:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	e9 2a 01 00 00       	jmp    80267b <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 0c             	mov    0xc(%eax),%eax
  802557:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80255a:	73 14                	jae    802570 <alloc_block_BF+0xd2>
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 40 0c             	mov    0xc(%eax),%eax
  802562:	3b 45 08             	cmp    0x8(%ebp),%eax
  802565:	76 09                	jbe    802570 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 40 0c             	mov    0xc(%eax),%eax
  80256d:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 00                	mov    (%eax),%eax
  802575:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257c:	0f 85 36 ff ff ff    	jne    8024b8 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802582:	a1 38 41 80 00       	mov    0x804138,%eax
  802587:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80258a:	e9 dd 00 00 00       	jmp    80266c <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 0c             	mov    0xc(%eax),%eax
  802595:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802598:	0f 85 c6 00 00 00    	jne    802664 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80259e:	a1 48 41 80 00       	mov    0x804148,%eax
  8025a3:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 50 08             	mov    0x8(%eax),%edx
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8025b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b8:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 50 08             	mov    0x8(%eax),%edx
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	01 c2                	add    %eax,%edx
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d5:	89 c2                	mov    %eax,%edx
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025e1:	75 17                	jne    8025fa <alloc_block_BF+0x15c>
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	68 25 3d 80 00       	push   $0x803d25
  8025eb:	68 eb 00 00 00       	push   $0xeb
  8025f0:	68 b3 3c 80 00       	push   $0x803cb3
  8025f5:	e8 d4 dc ff ff       	call   8002ce <_panic>
  8025fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	74 10                	je     802613 <alloc_block_BF+0x175>
  802603:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80260b:	8b 52 04             	mov    0x4(%edx),%edx
  80260e:	89 50 04             	mov    %edx,0x4(%eax)
  802611:	eb 0b                	jmp    80261e <alloc_block_BF+0x180>
  802613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80261e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 0f                	je     802637 <alloc_block_BF+0x199>
  802628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802631:	8b 12                	mov    (%edx),%edx
  802633:	89 10                	mov    %edx,(%eax)
  802635:	eb 0a                	jmp    802641 <alloc_block_BF+0x1a3>
  802637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	a3 48 41 80 00       	mov    %eax,0x804148
  802641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802654:	a1 54 41 80 00       	mov    0x804154,%eax
  802659:	48                   	dec    %eax
  80265a:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  80265f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802662:	eb 17                	jmp    80267b <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80266c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802670:	0f 85 19 ff ff ff    	jne    80258f <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802683:	a1 40 40 80 00       	mov    0x804040,%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	75 19                	jne    8026a5 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80268c:	83 ec 0c             	sub    $0xc,%esp
  80268f:	ff 75 08             	pushl  0x8(%ebp)
  802692:	e8 6f fc ff ff       	call   802306 <alloc_block_FF>
  802697:	83 c4 10             	add    $0x10,%esp
  80269a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	e9 e9 01 00 00       	jmp    80288e <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8026a5:	a1 44 40 80 00       	mov    0x804044,%eax
  8026aa:	8b 40 08             	mov    0x8(%eax),%eax
  8026ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8026b0:	a1 44 40 80 00       	mov    0x804044,%eax
  8026b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8026b8:	a1 44 40 80 00       	mov    0x804044,%eax
  8026bd:	8b 40 08             	mov    0x8(%eax),%eax
  8026c0:	01 d0                	add    %edx,%eax
  8026c2:	83 ec 08             	sub    $0x8,%esp
  8026c5:	50                   	push   %eax
  8026c6:	68 38 41 80 00       	push   $0x804138
  8026cb:	e8 54 fa ff ff       	call   802124 <find_block>
  8026d0:	83 c4 10             	add    $0x10,%esp
  8026d3:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026df:	0f 85 9b 00 00 00    	jne    802780 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 50 0c             	mov    0xc(%eax),%edx
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 08             	mov    0x8(%eax),%eax
  8026f1:	01 d0                	add    %edx,%eax
  8026f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8026f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fa:	75 17                	jne    802713 <alloc_block_NF+0x96>
  8026fc:	83 ec 04             	sub    $0x4,%esp
  8026ff:	68 25 3d 80 00       	push   $0x803d25
  802704:	68 1a 01 00 00       	push   $0x11a
  802709:	68 b3 3c 80 00       	push   $0x803cb3
  80270e:	e8 bb db ff ff       	call   8002ce <_panic>
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 00                	mov    (%eax),%eax
  802718:	85 c0                	test   %eax,%eax
  80271a:	74 10                	je     80272c <alloc_block_NF+0xaf>
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 00                	mov    (%eax),%eax
  802721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802724:	8b 52 04             	mov    0x4(%edx),%edx
  802727:	89 50 04             	mov    %edx,0x4(%eax)
  80272a:	eb 0b                	jmp    802737 <alloc_block_NF+0xba>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 04             	mov    0x4(%eax),%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	74 0f                	je     802750 <alloc_block_NF+0xd3>
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 40 04             	mov    0x4(%eax),%eax
  802747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274a:	8b 12                	mov    (%edx),%edx
  80274c:	89 10                	mov    %edx,(%eax)
  80274e:	eb 0a                	jmp    80275a <alloc_block_NF+0xdd>
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 00                	mov    (%eax),%eax
  802755:	a3 38 41 80 00       	mov    %eax,0x804138
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276d:	a1 44 41 80 00       	mov    0x804144,%eax
  802772:	48                   	dec    %eax
  802773:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	e9 0e 01 00 00       	jmp    80288e <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 40 0c             	mov    0xc(%eax),%eax
  802786:	3b 45 08             	cmp    0x8(%ebp),%eax
  802789:	0f 86 cf 00 00 00    	jbe    80285e <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80278f:	a1 48 41 80 00       	mov    0x804148,%eax
  802794:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279a:	8b 55 08             	mov    0x8(%ebp),%edx
  80279d:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 50 08             	mov    0x8(%eax),%edx
  8027a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a9:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 50 08             	mov    0x8(%eax),%edx
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	01 c2                	add    %eax,%edx
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c3:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c6:	89 c2                	mov    %eax,%edx
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 40 08             	mov    0x8(%eax),%eax
  8027d4:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027db:	75 17                	jne    8027f4 <alloc_block_NF+0x177>
  8027dd:	83 ec 04             	sub    $0x4,%esp
  8027e0:	68 25 3d 80 00       	push   $0x803d25
  8027e5:	68 28 01 00 00       	push   $0x128
  8027ea:	68 b3 3c 80 00       	push   $0x803cb3
  8027ef:	e8 da da ff ff       	call   8002ce <_panic>
  8027f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f7:	8b 00                	mov    (%eax),%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	74 10                	je     80280d <alloc_block_NF+0x190>
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802805:	8b 52 04             	mov    0x4(%edx),%edx
  802808:	89 50 04             	mov    %edx,0x4(%eax)
  80280b:	eb 0b                	jmp    802818 <alloc_block_NF+0x19b>
  80280d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281b:	8b 40 04             	mov    0x4(%eax),%eax
  80281e:	85 c0                	test   %eax,%eax
  802820:	74 0f                	je     802831 <alloc_block_NF+0x1b4>
  802822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802825:	8b 40 04             	mov    0x4(%eax),%eax
  802828:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80282b:	8b 12                	mov    (%edx),%edx
  80282d:	89 10                	mov    %edx,(%eax)
  80282f:	eb 0a                	jmp    80283b <alloc_block_NF+0x1be>
  802831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	a3 48 41 80 00       	mov    %eax,0x804148
  80283b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284e:	a1 54 41 80 00       	mov    0x804154,%eax
  802853:	48                   	dec    %eax
  802854:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285c:	eb 30                	jmp    80288e <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80285e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802863:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802866:	75 0a                	jne    802872 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802868:	a1 38 41 80 00       	mov    0x804138,%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802870:	eb 08                	jmp    80287a <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 40 08             	mov    0x8(%eax),%eax
  802880:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802883:	0f 85 4d fe ff ff    	jne    8026d6 <alloc_block_NF+0x59>

			return NULL;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	53                   	push   %ebx
  802894:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802897:	a1 38 41 80 00       	mov    0x804138,%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	0f 85 86 00 00 00    	jne    80292a <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8028a4:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8028ab:	00 00 00 
  8028ae:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8028b5:	00 00 00 
  8028b8:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8028bf:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028c6:	75 17                	jne    8028df <insert_sorted_with_merge_freeList+0x4f>
  8028c8:	83 ec 04             	sub    $0x4,%esp
  8028cb:	68 90 3c 80 00       	push   $0x803c90
  8028d0:	68 48 01 00 00       	push   $0x148
  8028d5:	68 b3 3c 80 00       	push   $0x803cb3
  8028da:	e8 ef d9 ff ff       	call   8002ce <_panic>
  8028df:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	89 10                	mov    %edx,(%eax)
  8028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	74 0d                	je     802900 <insert_sorted_with_merge_freeList+0x70>
  8028f3:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fb:	89 50 04             	mov    %edx,0x4(%eax)
  8028fe:	eb 08                	jmp    802908 <insert_sorted_with_merge_freeList+0x78>
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	a3 38 41 80 00       	mov    %eax,0x804138
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291a:	a1 44 41 80 00       	mov    0x804144,%eax
  80291f:	40                   	inc    %eax
  802920:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802925:	e9 73 07 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80292a:	8b 45 08             	mov    0x8(%ebp),%eax
  80292d:	8b 50 08             	mov    0x8(%eax),%edx
  802930:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802935:	8b 40 08             	mov    0x8(%eax),%eax
  802938:	39 c2                	cmp    %eax,%edx
  80293a:	0f 86 84 00 00 00    	jbe    8029c4 <insert_sorted_with_merge_freeList+0x134>
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	8b 50 08             	mov    0x8(%eax),%edx
  802946:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80294b:	8b 48 0c             	mov    0xc(%eax),%ecx
  80294e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802953:	8b 40 08             	mov    0x8(%eax),%eax
  802956:	01 c8                	add    %ecx,%eax
  802958:	39 c2                	cmp    %eax,%edx
  80295a:	74 68                	je     8029c4 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  80295c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802960:	75 17                	jne    802979 <insert_sorted_with_merge_freeList+0xe9>
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 cc 3c 80 00       	push   $0x803ccc
  80296a:	68 4c 01 00 00       	push   $0x14c
  80296f:	68 b3 3c 80 00       	push   $0x803cb3
  802974:	e8 55 d9 ff ff       	call   8002ce <_panic>
  802979:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	89 50 04             	mov    %edx,0x4(%eax)
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	8b 40 04             	mov    0x4(%eax),%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	74 0c                	je     80299b <insert_sorted_with_merge_freeList+0x10b>
  80298f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802994:	8b 55 08             	mov    0x8(%ebp),%edx
  802997:	89 10                	mov    %edx,(%eax)
  802999:	eb 08                	jmp    8029a3 <insert_sorted_with_merge_freeList+0x113>
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	a3 38 41 80 00       	mov    %eax,0x804138
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b4:	a1 44 41 80 00       	mov    0x804144,%eax
  8029b9:	40                   	inc    %eax
  8029ba:	a3 44 41 80 00       	mov    %eax,0x804144
  8029bf:	e9 d9 06 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ca:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029cf:	8b 40 08             	mov    0x8(%eax),%eax
  8029d2:	39 c2                	cmp    %eax,%edx
  8029d4:	0f 86 b5 00 00 00    	jbe    802a8f <insert_sorted_with_merge_freeList+0x1ff>
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e5:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029e8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ed:	8b 40 08             	mov    0x8(%eax),%eax
  8029f0:	01 c8                	add    %ecx,%eax
  8029f2:	39 c2                	cmp    %eax,%edx
  8029f4:	0f 85 95 00 00 00    	jne    802a8f <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029fa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ff:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a05:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a08:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0b:	8b 52 0c             	mov    0xc(%edx),%edx
  802a0e:	01 ca                	add    %ecx,%edx
  802a10:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2b:	75 17                	jne    802a44 <insert_sorted_with_merge_freeList+0x1b4>
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 90 3c 80 00       	push   $0x803c90
  802a35:	68 54 01 00 00       	push   $0x154
  802a3a:	68 b3 3c 80 00       	push   $0x803cb3
  802a3f:	e8 8a d8 ff ff       	call   8002ce <_panic>
  802a44:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	89 10                	mov    %edx,(%eax)
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 0d                	je     802a65 <insert_sorted_with_merge_freeList+0x1d5>
  802a58:	a1 48 41 80 00       	mov    0x804148,%eax
  802a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a60:	89 50 04             	mov    %edx,0x4(%eax)
  802a63:	eb 08                	jmp    802a6d <insert_sorted_with_merge_freeList+0x1dd>
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	a3 48 41 80 00       	mov    %eax,0x804148
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7f:	a1 54 41 80 00       	mov    0x804154,%eax
  802a84:	40                   	inc    %eax
  802a85:	a3 54 41 80 00       	mov    %eax,0x804154
  802a8a:	e9 0e 06 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	8b 50 08             	mov    0x8(%eax),%edx
  802a95:	a1 38 41 80 00       	mov    0x804138,%eax
  802a9a:	8b 40 08             	mov    0x8(%eax),%eax
  802a9d:	39 c2                	cmp    %eax,%edx
  802a9f:	0f 83 c1 00 00 00    	jae    802b66 <insert_sorted_with_merge_freeList+0x2d6>
  802aa5:	a1 38 41 80 00       	mov    0x804138,%eax
  802aaa:	8b 50 08             	mov    0x8(%eax),%edx
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	8b 48 08             	mov    0x8(%eax),%ecx
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab9:	01 c8                	add    %ecx,%eax
  802abb:	39 c2                	cmp    %eax,%edx
  802abd:	0f 85 a3 00 00 00    	jne    802b66 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ac3:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac8:	8b 55 08             	mov    0x8(%ebp),%edx
  802acb:	8b 52 08             	mov    0x8(%edx),%edx
  802ace:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ad1:	a1 38 41 80 00       	mov    0x804138,%eax
  802ad6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802adc:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802adf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae2:	8b 52 0c             	mov    0xc(%edx),%edx
  802ae5:	01 ca                	add    %ecx,%edx
  802ae7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802afe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b02:	75 17                	jne    802b1b <insert_sorted_with_merge_freeList+0x28b>
  802b04:	83 ec 04             	sub    $0x4,%esp
  802b07:	68 90 3c 80 00       	push   $0x803c90
  802b0c:	68 5d 01 00 00       	push   $0x15d
  802b11:	68 b3 3c 80 00       	push   $0x803cb3
  802b16:	e8 b3 d7 ff ff       	call   8002ce <_panic>
  802b1b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	89 10                	mov    %edx,(%eax)
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	74 0d                	je     802b3c <insert_sorted_with_merge_freeList+0x2ac>
  802b2f:	a1 48 41 80 00       	mov    0x804148,%eax
  802b34:	8b 55 08             	mov    0x8(%ebp),%edx
  802b37:	89 50 04             	mov    %edx,0x4(%eax)
  802b3a:	eb 08                	jmp    802b44 <insert_sorted_with_merge_freeList+0x2b4>
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	a3 48 41 80 00       	mov    %eax,0x804148
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b56:	a1 54 41 80 00       	mov    0x804154,%eax
  802b5b:	40                   	inc    %eax
  802b5c:	a3 54 41 80 00       	mov    %eax,0x804154
  802b61:	e9 37 05 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	8b 50 08             	mov    0x8(%eax),%edx
  802b6c:	a1 38 41 80 00       	mov    0x804138,%eax
  802b71:	8b 40 08             	mov    0x8(%eax),%eax
  802b74:	39 c2                	cmp    %eax,%edx
  802b76:	0f 83 82 00 00 00    	jae    802bfe <insert_sorted_with_merge_freeList+0x36e>
  802b7c:	a1 38 41 80 00       	mov    0x804138,%eax
  802b81:	8b 50 08             	mov    0x8(%eax),%edx
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	8b 48 08             	mov    0x8(%eax),%ecx
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b90:	01 c8                	add    %ecx,%eax
  802b92:	39 c2                	cmp    %eax,%edx
  802b94:	74 68                	je     802bfe <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9a:	75 17                	jne    802bb3 <insert_sorted_with_merge_freeList+0x323>
  802b9c:	83 ec 04             	sub    $0x4,%esp
  802b9f:	68 90 3c 80 00       	push   $0x803c90
  802ba4:	68 62 01 00 00       	push   $0x162
  802ba9:	68 b3 3c 80 00       	push   $0x803cb3
  802bae:	e8 1b d7 ff ff       	call   8002ce <_panic>
  802bb3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	89 10                	mov    %edx,(%eax)
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	74 0d                	je     802bd4 <insert_sorted_with_merge_freeList+0x344>
  802bc7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcf:	89 50 04             	mov    %edx,0x4(%eax)
  802bd2:	eb 08                	jmp    802bdc <insert_sorted_with_merge_freeList+0x34c>
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	a3 38 41 80 00       	mov    %eax,0x804138
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bee:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf3:	40                   	inc    %eax
  802bf4:	a3 44 41 80 00       	mov    %eax,0x804144
  802bf9:	e9 9f 04 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802bfe:	a1 38 41 80 00       	mov    0x804138,%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802c08:	e9 84 04 00 00       	jmp    803091 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 50 08             	mov    0x8(%eax),%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	8b 40 08             	mov    0x8(%eax),%eax
  802c19:	39 c2                	cmp    %eax,%edx
  802c1b:	0f 86 a9 00 00 00    	jbe    802cca <insert_sorted_with_merge_freeList+0x43a>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 50 08             	mov    0x8(%eax),%edx
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	8b 48 08             	mov    0x8(%eax),%ecx
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	8b 40 0c             	mov    0xc(%eax),%eax
  802c33:	01 c8                	add    %ecx,%eax
  802c35:	39 c2                	cmp    %eax,%edx
  802c37:	0f 84 8d 00 00 00    	je     802cca <insert_sorted_with_merge_freeList+0x43a>
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	8b 50 08             	mov    0x8(%eax),%edx
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	8b 48 08             	mov    0x8(%eax),%ecx
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 40 04             	mov    0x4(%eax),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	01 c8                	add    %ecx,%eax
  802c57:	39 c2                	cmp    %eax,%edx
  802c59:	74 6f                	je     802cca <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5f:	74 06                	je     802c67 <insert_sorted_with_merge_freeList+0x3d7>
  802c61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c65:	75 17                	jne    802c7e <insert_sorted_with_merge_freeList+0x3ee>
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	68 f0 3c 80 00       	push   $0x803cf0
  802c6f:	68 6b 01 00 00       	push   $0x16b
  802c74:	68 b3 3c 80 00       	push   $0x803cb3
  802c79:	e8 50 d6 ff ff       	call   8002ce <_panic>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 50 04             	mov    0x4(%eax),%edx
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	89 50 04             	mov    %edx,0x4(%eax)
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c90:	89 10                	mov    %edx,(%eax)
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 04             	mov    0x4(%eax),%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	74 0d                	je     802ca9 <insert_sorted_with_merge_freeList+0x419>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca5:	89 10                	mov    %edx,(%eax)
  802ca7:	eb 08                	jmp    802cb1 <insert_sorted_with_merge_freeList+0x421>
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	a3 38 41 80 00       	mov    %eax,0x804138
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb7:	89 50 04             	mov    %edx,0x4(%eax)
  802cba:	a1 44 41 80 00       	mov    0x804144,%eax
  802cbf:	40                   	inc    %eax
  802cc0:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802cc5:	e9 d3 03 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 50 08             	mov    0x8(%eax),%edx
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 40 08             	mov    0x8(%eax),%eax
  802cd6:	39 c2                	cmp    %eax,%edx
  802cd8:	0f 86 da 00 00 00    	jbe    802db8 <insert_sorted_with_merge_freeList+0x528>
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 50 08             	mov    0x8(%eax),%edx
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	8b 48 08             	mov    0x8(%eax),%ecx
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf0:	01 c8                	add    %ecx,%eax
  802cf2:	39 c2                	cmp    %eax,%edx
  802cf4:	0f 85 be 00 00 00    	jne    802db8 <insert_sorted_with_merge_freeList+0x528>
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	8b 50 08             	mov    0x8(%eax),%edx
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 40 04             	mov    0x4(%eax),%eax
  802d06:	8b 48 08             	mov    0x8(%eax),%ecx
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d12:	01 c8                	add    %ecx,%eax
  802d14:	39 c2                	cmp    %eax,%edx
  802d16:	0f 84 9c 00 00 00    	je     802db8 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 50 08             	mov    0x8(%eax),%edx
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	01 c2                	add    %eax,%edx
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d54:	75 17                	jne    802d6d <insert_sorted_with_merge_freeList+0x4dd>
  802d56:	83 ec 04             	sub    $0x4,%esp
  802d59:	68 90 3c 80 00       	push   $0x803c90
  802d5e:	68 74 01 00 00       	push   $0x174
  802d63:	68 b3 3c 80 00       	push   $0x803cb3
  802d68:	e8 61 d5 ff ff       	call   8002ce <_panic>
  802d6d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	89 10                	mov    %edx,(%eax)
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	74 0d                	je     802d8e <insert_sorted_with_merge_freeList+0x4fe>
  802d81:	a1 48 41 80 00       	mov    0x804148,%eax
  802d86:	8b 55 08             	mov    0x8(%ebp),%edx
  802d89:	89 50 04             	mov    %edx,0x4(%eax)
  802d8c:	eb 08                	jmp    802d96 <insert_sorted_with_merge_freeList+0x506>
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	a3 48 41 80 00       	mov    %eax,0x804148
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da8:	a1 54 41 80 00       	mov    0x804154,%eax
  802dad:	40                   	inc    %eax
  802dae:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802db3:	e9 e5 02 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 50 08             	mov    0x8(%eax),%edx
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	8b 40 08             	mov    0x8(%eax),%eax
  802dc4:	39 c2                	cmp    %eax,%edx
  802dc6:	0f 86 d7 00 00 00    	jbe    802ea3 <insert_sorted_with_merge_freeList+0x613>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 50 08             	mov    0x8(%eax),%edx
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	8b 48 08             	mov    0x8(%eax),%ecx
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dde:	01 c8                	add    %ecx,%eax
  802de0:	39 c2                	cmp    %eax,%edx
  802de2:	0f 84 bb 00 00 00    	je     802ea3 <insert_sorted_with_merge_freeList+0x613>
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 50 08             	mov    0x8(%eax),%edx
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	8b 48 08             	mov    0x8(%eax),%ecx
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802e00:	01 c8                	add    %ecx,%eax
  802e02:	39 c2                	cmp    %eax,%edx
  802e04:	0f 85 99 00 00 00    	jne    802ea3 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	8b 50 0c             	mov    0xc(%eax),%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	01 c2                	add    %eax,%edx
  802e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e24:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3f:	75 17                	jne    802e58 <insert_sorted_with_merge_freeList+0x5c8>
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	68 90 3c 80 00       	push   $0x803c90
  802e49:	68 7d 01 00 00       	push   $0x17d
  802e4e:	68 b3 3c 80 00       	push   $0x803cb3
  802e53:	e8 76 d4 ff ff       	call   8002ce <_panic>
  802e58:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	89 10                	mov    %edx,(%eax)
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 0d                	je     802e79 <insert_sorted_with_merge_freeList+0x5e9>
  802e6c:	a1 48 41 80 00       	mov    0x804148,%eax
  802e71:	8b 55 08             	mov    0x8(%ebp),%edx
  802e74:	89 50 04             	mov    %edx,0x4(%eax)
  802e77:	eb 08                	jmp    802e81 <insert_sorted_with_merge_freeList+0x5f1>
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	a3 48 41 80 00       	mov    %eax,0x804148
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e93:	a1 54 41 80 00       	mov    0x804154,%eax
  802e98:	40                   	inc    %eax
  802e99:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e9e:	e9 fa 01 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 50 08             	mov    0x8(%eax),%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	8b 40 08             	mov    0x8(%eax),%eax
  802eaf:	39 c2                	cmp    %eax,%edx
  802eb1:	0f 86 d2 01 00 00    	jbe    803089 <insert_sorted_with_merge_freeList+0x7f9>
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 50 08             	mov    0x8(%eax),%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec9:	01 c8                	add    %ecx,%eax
  802ecb:	39 c2                	cmp    %eax,%edx
  802ecd:	0f 85 b6 01 00 00    	jne    803089 <insert_sorted_with_merge_freeList+0x7f9>
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	8b 48 08             	mov    0x8(%eax),%ecx
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 04             	mov    0x4(%eax),%eax
  802ee8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eeb:	01 c8                	add    %ecx,%eax
  802eed:	39 c2                	cmp    %eax,%edx
  802eef:	0f 85 94 01 00 00    	jne    803089 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efe:	8b 52 04             	mov    0x4(%edx),%edx
  802f01:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f04:	8b 55 08             	mov    0x8(%ebp),%edx
  802f07:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0d:	8b 52 0c             	mov    0xc(%edx),%edx
  802f10:	01 da                	add    %ebx,%edx
  802f12:	01 ca                	add    %ecx,%edx
  802f14:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2f:	75 17                	jne    802f48 <insert_sorted_with_merge_freeList+0x6b8>
  802f31:	83 ec 04             	sub    $0x4,%esp
  802f34:	68 25 3d 80 00       	push   $0x803d25
  802f39:	68 86 01 00 00       	push   $0x186
  802f3e:	68 b3 3c 80 00       	push   $0x803cb3
  802f43:	e8 86 d3 ff ff       	call   8002ce <_panic>
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	74 10                	je     802f61 <insert_sorted_with_merge_freeList+0x6d1>
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f59:	8b 52 04             	mov    0x4(%edx),%edx
  802f5c:	89 50 04             	mov    %edx,0x4(%eax)
  802f5f:	eb 0b                	jmp    802f6c <insert_sorted_with_merge_freeList+0x6dc>
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 40 04             	mov    0x4(%eax),%eax
  802f67:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 40 04             	mov    0x4(%eax),%eax
  802f72:	85 c0                	test   %eax,%eax
  802f74:	74 0f                	je     802f85 <insert_sorted_with_merge_freeList+0x6f5>
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 40 04             	mov    0x4(%eax),%eax
  802f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f7f:	8b 12                	mov    (%edx),%edx
  802f81:	89 10                	mov    %edx,(%eax)
  802f83:	eb 0a                	jmp    802f8f <insert_sorted_with_merge_freeList+0x6ff>
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 00                	mov    (%eax),%eax
  802f8a:	a3 38 41 80 00       	mov    %eax,0x804138
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa2:	a1 44 41 80 00       	mov    0x804144,%eax
  802fa7:	48                   	dec    %eax
  802fa8:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802fad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb1:	75 17                	jne    802fca <insert_sorted_with_merge_freeList+0x73a>
  802fb3:	83 ec 04             	sub    $0x4,%esp
  802fb6:	68 90 3c 80 00       	push   $0x803c90
  802fbb:	68 87 01 00 00       	push   $0x187
  802fc0:	68 b3 3c 80 00       	push   $0x803cb3
  802fc5:	e8 04 d3 ff ff       	call   8002ce <_panic>
  802fca:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	89 10                	mov    %edx,(%eax)
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 0d                	je     802feb <insert_sorted_with_merge_freeList+0x75b>
  802fde:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe6:	89 50 04             	mov    %edx,0x4(%eax)
  802fe9:	eb 08                	jmp    802ff3 <insert_sorted_with_merge_freeList+0x763>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	a3 48 41 80 00       	mov    %eax,0x804148
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803005:	a1 54 41 80 00       	mov    0x804154,%eax
  80300a:	40                   	inc    %eax
  80300b:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803024:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803028:	75 17                	jne    803041 <insert_sorted_with_merge_freeList+0x7b1>
  80302a:	83 ec 04             	sub    $0x4,%esp
  80302d:	68 90 3c 80 00       	push   $0x803c90
  803032:	68 8a 01 00 00       	push   $0x18a
  803037:	68 b3 3c 80 00       	push   $0x803cb3
  80303c:	e8 8d d2 ff ff       	call   8002ce <_panic>
  803041:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	85 c0                	test   %eax,%eax
  803053:	74 0d                	je     803062 <insert_sorted_with_merge_freeList+0x7d2>
  803055:	a1 48 41 80 00       	mov    0x804148,%eax
  80305a:	8b 55 08             	mov    0x8(%ebp),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	eb 08                	jmp    80306a <insert_sorted_with_merge_freeList+0x7da>
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	a3 48 41 80 00       	mov    %eax,0x804148
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307c:	a1 54 41 80 00       	mov    0x804154,%eax
  803081:	40                   	inc    %eax
  803082:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803087:	eb 14                	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803095:	0f 85 72 fb ff ff    	jne    802c0d <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80309b:	eb 00                	jmp    80309d <insert_sorted_with_merge_freeList+0x80d>
  80309d:	90                   	nop
  80309e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
  8030a6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8030a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ac:	89 d0                	mov    %edx,%eax
  8030ae:	c1 e0 02             	shl    $0x2,%eax
  8030b1:	01 d0                	add    %edx,%eax
  8030b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030ba:	01 d0                	add    %edx,%eax
  8030bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030c3:	01 d0                	add    %edx,%eax
  8030c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030cc:	01 d0                	add    %edx,%eax
  8030ce:	c1 e0 04             	shl    $0x4,%eax
  8030d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030db:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030de:	83 ec 0c             	sub    $0xc,%esp
  8030e1:	50                   	push   %eax
  8030e2:	e8 7b eb ff ff       	call   801c62 <sys_get_virtual_time>
  8030e7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030ea:	eb 41                	jmp    80312d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030ef:	83 ec 0c             	sub    $0xc,%esp
  8030f2:	50                   	push   %eax
  8030f3:	e8 6a eb ff ff       	call   801c62 <sys_get_virtual_time>
  8030f8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	29 c2                	sub    %eax,%edx
  803103:	89 d0                	mov    %edx,%eax
  803105:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803108:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80310b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310e:	89 d1                	mov    %edx,%ecx
  803110:	29 c1                	sub    %eax,%ecx
  803112:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803118:	39 c2                	cmp    %eax,%edx
  80311a:	0f 97 c0             	seta   %al
  80311d:	0f b6 c0             	movzbl %al,%eax
  803120:	29 c1                	sub    %eax,%ecx
  803122:	89 c8                	mov    %ecx,%eax
  803124:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803127:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80312a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803133:	72 b7                	jb     8030ec <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803135:	90                   	nop
  803136:	c9                   	leave  
  803137:	c3                   	ret    

00803138 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803138:	55                   	push   %ebp
  803139:	89 e5                	mov    %esp,%ebp
  80313b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80313e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803145:	eb 03                	jmp    80314a <busy_wait+0x12>
  803147:	ff 45 fc             	incl   -0x4(%ebp)
  80314a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80314d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803150:	72 f5                	jb     803147 <busy_wait+0xf>
	return i;
  803152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803155:	c9                   	leave  
  803156:	c3                   	ret    
  803157:	90                   	nop

00803158 <__udivdi3>:
  803158:	55                   	push   %ebp
  803159:	57                   	push   %edi
  80315a:	56                   	push   %esi
  80315b:	53                   	push   %ebx
  80315c:	83 ec 1c             	sub    $0x1c,%esp
  80315f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803163:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803167:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80316b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80316f:	89 ca                	mov    %ecx,%edx
  803171:	89 f8                	mov    %edi,%eax
  803173:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803177:	85 f6                	test   %esi,%esi
  803179:	75 2d                	jne    8031a8 <__udivdi3+0x50>
  80317b:	39 cf                	cmp    %ecx,%edi
  80317d:	77 65                	ja     8031e4 <__udivdi3+0x8c>
  80317f:	89 fd                	mov    %edi,%ebp
  803181:	85 ff                	test   %edi,%edi
  803183:	75 0b                	jne    803190 <__udivdi3+0x38>
  803185:	b8 01 00 00 00       	mov    $0x1,%eax
  80318a:	31 d2                	xor    %edx,%edx
  80318c:	f7 f7                	div    %edi
  80318e:	89 c5                	mov    %eax,%ebp
  803190:	31 d2                	xor    %edx,%edx
  803192:	89 c8                	mov    %ecx,%eax
  803194:	f7 f5                	div    %ebp
  803196:	89 c1                	mov    %eax,%ecx
  803198:	89 d8                	mov    %ebx,%eax
  80319a:	f7 f5                	div    %ebp
  80319c:	89 cf                	mov    %ecx,%edi
  80319e:	89 fa                	mov    %edi,%edx
  8031a0:	83 c4 1c             	add    $0x1c,%esp
  8031a3:	5b                   	pop    %ebx
  8031a4:	5e                   	pop    %esi
  8031a5:	5f                   	pop    %edi
  8031a6:	5d                   	pop    %ebp
  8031a7:	c3                   	ret    
  8031a8:	39 ce                	cmp    %ecx,%esi
  8031aa:	77 28                	ja     8031d4 <__udivdi3+0x7c>
  8031ac:	0f bd fe             	bsr    %esi,%edi
  8031af:	83 f7 1f             	xor    $0x1f,%edi
  8031b2:	75 40                	jne    8031f4 <__udivdi3+0x9c>
  8031b4:	39 ce                	cmp    %ecx,%esi
  8031b6:	72 0a                	jb     8031c2 <__udivdi3+0x6a>
  8031b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031bc:	0f 87 9e 00 00 00    	ja     803260 <__udivdi3+0x108>
  8031c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c7:	89 fa                	mov    %edi,%edx
  8031c9:	83 c4 1c             	add    $0x1c,%esp
  8031cc:	5b                   	pop    %ebx
  8031cd:	5e                   	pop    %esi
  8031ce:	5f                   	pop    %edi
  8031cf:	5d                   	pop    %ebp
  8031d0:	c3                   	ret    
  8031d1:	8d 76 00             	lea    0x0(%esi),%esi
  8031d4:	31 ff                	xor    %edi,%edi
  8031d6:	31 c0                	xor    %eax,%eax
  8031d8:	89 fa                	mov    %edi,%edx
  8031da:	83 c4 1c             	add    $0x1c,%esp
  8031dd:	5b                   	pop    %ebx
  8031de:	5e                   	pop    %esi
  8031df:	5f                   	pop    %edi
  8031e0:	5d                   	pop    %ebp
  8031e1:	c3                   	ret    
  8031e2:	66 90                	xchg   %ax,%ax
  8031e4:	89 d8                	mov    %ebx,%eax
  8031e6:	f7 f7                	div    %edi
  8031e8:	31 ff                	xor    %edi,%edi
  8031ea:	89 fa                	mov    %edi,%edx
  8031ec:	83 c4 1c             	add    $0x1c,%esp
  8031ef:	5b                   	pop    %ebx
  8031f0:	5e                   	pop    %esi
  8031f1:	5f                   	pop    %edi
  8031f2:	5d                   	pop    %ebp
  8031f3:	c3                   	ret    
  8031f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031f9:	89 eb                	mov    %ebp,%ebx
  8031fb:	29 fb                	sub    %edi,%ebx
  8031fd:	89 f9                	mov    %edi,%ecx
  8031ff:	d3 e6                	shl    %cl,%esi
  803201:	89 c5                	mov    %eax,%ebp
  803203:	88 d9                	mov    %bl,%cl
  803205:	d3 ed                	shr    %cl,%ebp
  803207:	89 e9                	mov    %ebp,%ecx
  803209:	09 f1                	or     %esi,%ecx
  80320b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80320f:	89 f9                	mov    %edi,%ecx
  803211:	d3 e0                	shl    %cl,%eax
  803213:	89 c5                	mov    %eax,%ebp
  803215:	89 d6                	mov    %edx,%esi
  803217:	88 d9                	mov    %bl,%cl
  803219:	d3 ee                	shr    %cl,%esi
  80321b:	89 f9                	mov    %edi,%ecx
  80321d:	d3 e2                	shl    %cl,%edx
  80321f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803223:	88 d9                	mov    %bl,%cl
  803225:	d3 e8                	shr    %cl,%eax
  803227:	09 c2                	or     %eax,%edx
  803229:	89 d0                	mov    %edx,%eax
  80322b:	89 f2                	mov    %esi,%edx
  80322d:	f7 74 24 0c          	divl   0xc(%esp)
  803231:	89 d6                	mov    %edx,%esi
  803233:	89 c3                	mov    %eax,%ebx
  803235:	f7 e5                	mul    %ebp
  803237:	39 d6                	cmp    %edx,%esi
  803239:	72 19                	jb     803254 <__udivdi3+0xfc>
  80323b:	74 0b                	je     803248 <__udivdi3+0xf0>
  80323d:	89 d8                	mov    %ebx,%eax
  80323f:	31 ff                	xor    %edi,%edi
  803241:	e9 58 ff ff ff       	jmp    80319e <__udivdi3+0x46>
  803246:	66 90                	xchg   %ax,%ax
  803248:	8b 54 24 08          	mov    0x8(%esp),%edx
  80324c:	89 f9                	mov    %edi,%ecx
  80324e:	d3 e2                	shl    %cl,%edx
  803250:	39 c2                	cmp    %eax,%edx
  803252:	73 e9                	jae    80323d <__udivdi3+0xe5>
  803254:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803257:	31 ff                	xor    %edi,%edi
  803259:	e9 40 ff ff ff       	jmp    80319e <__udivdi3+0x46>
  80325e:	66 90                	xchg   %ax,%ax
  803260:	31 c0                	xor    %eax,%eax
  803262:	e9 37 ff ff ff       	jmp    80319e <__udivdi3+0x46>
  803267:	90                   	nop

00803268 <__umoddi3>:
  803268:	55                   	push   %ebp
  803269:	57                   	push   %edi
  80326a:	56                   	push   %esi
  80326b:	53                   	push   %ebx
  80326c:	83 ec 1c             	sub    $0x1c,%esp
  80326f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803273:	8b 74 24 34          	mov    0x34(%esp),%esi
  803277:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80327b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80327f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803283:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803287:	89 f3                	mov    %esi,%ebx
  803289:	89 fa                	mov    %edi,%edx
  80328b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80328f:	89 34 24             	mov    %esi,(%esp)
  803292:	85 c0                	test   %eax,%eax
  803294:	75 1a                	jne    8032b0 <__umoddi3+0x48>
  803296:	39 f7                	cmp    %esi,%edi
  803298:	0f 86 a2 00 00 00    	jbe    803340 <__umoddi3+0xd8>
  80329e:	89 c8                	mov    %ecx,%eax
  8032a0:	89 f2                	mov    %esi,%edx
  8032a2:	f7 f7                	div    %edi
  8032a4:	89 d0                	mov    %edx,%eax
  8032a6:	31 d2                	xor    %edx,%edx
  8032a8:	83 c4 1c             	add    $0x1c,%esp
  8032ab:	5b                   	pop    %ebx
  8032ac:	5e                   	pop    %esi
  8032ad:	5f                   	pop    %edi
  8032ae:	5d                   	pop    %ebp
  8032af:	c3                   	ret    
  8032b0:	39 f0                	cmp    %esi,%eax
  8032b2:	0f 87 ac 00 00 00    	ja     803364 <__umoddi3+0xfc>
  8032b8:	0f bd e8             	bsr    %eax,%ebp
  8032bb:	83 f5 1f             	xor    $0x1f,%ebp
  8032be:	0f 84 ac 00 00 00    	je     803370 <__umoddi3+0x108>
  8032c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8032c9:	29 ef                	sub    %ebp,%edi
  8032cb:	89 fe                	mov    %edi,%esi
  8032cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032d1:	89 e9                	mov    %ebp,%ecx
  8032d3:	d3 e0                	shl    %cl,%eax
  8032d5:	89 d7                	mov    %edx,%edi
  8032d7:	89 f1                	mov    %esi,%ecx
  8032d9:	d3 ef                	shr    %cl,%edi
  8032db:	09 c7                	or     %eax,%edi
  8032dd:	89 e9                	mov    %ebp,%ecx
  8032df:	d3 e2                	shl    %cl,%edx
  8032e1:	89 14 24             	mov    %edx,(%esp)
  8032e4:	89 d8                	mov    %ebx,%eax
  8032e6:	d3 e0                	shl    %cl,%eax
  8032e8:	89 c2                	mov    %eax,%edx
  8032ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ee:	d3 e0                	shl    %cl,%eax
  8032f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032f8:	89 f1                	mov    %esi,%ecx
  8032fa:	d3 e8                	shr    %cl,%eax
  8032fc:	09 d0                	or     %edx,%eax
  8032fe:	d3 eb                	shr    %cl,%ebx
  803300:	89 da                	mov    %ebx,%edx
  803302:	f7 f7                	div    %edi
  803304:	89 d3                	mov    %edx,%ebx
  803306:	f7 24 24             	mull   (%esp)
  803309:	89 c6                	mov    %eax,%esi
  80330b:	89 d1                	mov    %edx,%ecx
  80330d:	39 d3                	cmp    %edx,%ebx
  80330f:	0f 82 87 00 00 00    	jb     80339c <__umoddi3+0x134>
  803315:	0f 84 91 00 00 00    	je     8033ac <__umoddi3+0x144>
  80331b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80331f:	29 f2                	sub    %esi,%edx
  803321:	19 cb                	sbb    %ecx,%ebx
  803323:	89 d8                	mov    %ebx,%eax
  803325:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803329:	d3 e0                	shl    %cl,%eax
  80332b:	89 e9                	mov    %ebp,%ecx
  80332d:	d3 ea                	shr    %cl,%edx
  80332f:	09 d0                	or     %edx,%eax
  803331:	89 e9                	mov    %ebp,%ecx
  803333:	d3 eb                	shr    %cl,%ebx
  803335:	89 da                	mov    %ebx,%edx
  803337:	83 c4 1c             	add    $0x1c,%esp
  80333a:	5b                   	pop    %ebx
  80333b:	5e                   	pop    %esi
  80333c:	5f                   	pop    %edi
  80333d:	5d                   	pop    %ebp
  80333e:	c3                   	ret    
  80333f:	90                   	nop
  803340:	89 fd                	mov    %edi,%ebp
  803342:	85 ff                	test   %edi,%edi
  803344:	75 0b                	jne    803351 <__umoddi3+0xe9>
  803346:	b8 01 00 00 00       	mov    $0x1,%eax
  80334b:	31 d2                	xor    %edx,%edx
  80334d:	f7 f7                	div    %edi
  80334f:	89 c5                	mov    %eax,%ebp
  803351:	89 f0                	mov    %esi,%eax
  803353:	31 d2                	xor    %edx,%edx
  803355:	f7 f5                	div    %ebp
  803357:	89 c8                	mov    %ecx,%eax
  803359:	f7 f5                	div    %ebp
  80335b:	89 d0                	mov    %edx,%eax
  80335d:	e9 44 ff ff ff       	jmp    8032a6 <__umoddi3+0x3e>
  803362:	66 90                	xchg   %ax,%ax
  803364:	89 c8                	mov    %ecx,%eax
  803366:	89 f2                	mov    %esi,%edx
  803368:	83 c4 1c             	add    $0x1c,%esp
  80336b:	5b                   	pop    %ebx
  80336c:	5e                   	pop    %esi
  80336d:	5f                   	pop    %edi
  80336e:	5d                   	pop    %ebp
  80336f:	c3                   	ret    
  803370:	3b 04 24             	cmp    (%esp),%eax
  803373:	72 06                	jb     80337b <__umoddi3+0x113>
  803375:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803379:	77 0f                	ja     80338a <__umoddi3+0x122>
  80337b:	89 f2                	mov    %esi,%edx
  80337d:	29 f9                	sub    %edi,%ecx
  80337f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803383:	89 14 24             	mov    %edx,(%esp)
  803386:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80338a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80338e:	8b 14 24             	mov    (%esp),%edx
  803391:	83 c4 1c             	add    $0x1c,%esp
  803394:	5b                   	pop    %ebx
  803395:	5e                   	pop    %esi
  803396:	5f                   	pop    %edi
  803397:	5d                   	pop    %ebp
  803398:	c3                   	ret    
  803399:	8d 76 00             	lea    0x0(%esi),%esi
  80339c:	2b 04 24             	sub    (%esp),%eax
  80339f:	19 fa                	sbb    %edi,%edx
  8033a1:	89 d1                	mov    %edx,%ecx
  8033a3:	89 c6                	mov    %eax,%esi
  8033a5:	e9 71 ff ff ff       	jmp    80331b <__umoddi3+0xb3>
  8033aa:	66 90                	xchg   %ax,%ax
  8033ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033b0:	72 ea                	jb     80339c <__umoddi3+0x134>
  8033b2:	89 d9                	mov    %ebx,%ecx
  8033b4:	e9 62 ff ff ff       	jmp    80331b <__umoddi3+0xb3>
