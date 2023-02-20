
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 33 80 00       	push   $0x8033c0
  80004a:	e8 d3 15 00 00       	call   801622 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 c2 18 00 00       	call   801925 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 5a 19 00 00       	call   8019c5 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 33 80 00       	push   $0x8033d0
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 03 34 80 00       	push   $0x803403
  80008f:	e8 03 1b 00 00       	call   801b97 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 0c 34 80 00       	push   $0x80340c
  8000a8:	e8 ea 1a 00 00       	call   801b97 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 f7 1a 00 00       	call   801bb5 <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 c4 2f 00 00       	call   803092 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 d9 1a 00 00       	call   801bb5 <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 36 18 00 00       	call   801925 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 18 34 80 00       	push   $0x803418
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 c6 1a 00 00       	call   801bd1 <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 b8 1a 00 00       	call   801bd1 <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 04 18 00 00       	call   801925 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 9c 18 00 00       	call   8019c5 <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 4c 34 80 00       	push   $0x80344c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 9c 34 80 00       	push   $0x80349c
  80014f:	6a 23                	push   $0x23
  800151:	68 d2 34 80 00       	push   $0x8034d2
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 e8 34 80 00       	push   $0x8034e8
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 48 35 80 00       	push   $0x803548
  800176:	e8 f6 03 00 00       	call   800571 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 79 1a 00 00       	call   801c05 <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	c1 e0 04             	shl    $0x4,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b8:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001be:	84 c0                	test   %al,%al
  8001c0:	74 0f                	je     8001d1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c7:	05 5c 05 00 00       	add    $0x55c,%eax
  8001cc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x60>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f2:	e8 1b 18 00 00       	call   801a12 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 ac 35 80 00       	push   $0x8035ac
  8001ff:	e8 6d 03 00 00       	call   800571 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 d4 35 80 00       	push   $0x8035d4
  800227:	e8 45 03 00 00       	call   800571 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800245:	a1 20 40 80 00       	mov    0x804020,%eax
  80024a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 fc 35 80 00       	push   $0x8035fc
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 54 36 80 00       	push   $0x803654
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 ac 35 80 00       	push   $0x8035ac
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 9b 17 00 00       	call   801a2c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 28 19 00 00       	call   801bd1 <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 7d 19 00 00       	call   801c37 <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c6:	83 c0 04             	add    $0x4,%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002cc:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	74 16                	je     8002eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 68 36 80 00       	push   $0x803668
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 40 80 00       	mov    0x804000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 6d 36 80 00       	push   $0x80366d
  8002fc:	e8 70 02 00 00       	call   800571 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800304:	8b 45 10             	mov    0x10(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 f3 01 00 00       	call   800506 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 89 36 80 00       	push   $0x803689
  800320:	e8 e1 01 00 00       	call   800506 <vcprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800328:	e8 82 ff ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80032d:	eb fe                	jmp    80032d <_panic+0x70>

0080032f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800335:	a1 20 40 80 00       	mov    0x804020,%eax
  80033a:	8b 50 74             	mov    0x74(%eax),%edx
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	39 c2                	cmp    %eax,%edx
  800342:	74 14                	je     800358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	68 8c 36 80 00       	push   $0x80368c
  80034c:	6a 26                	push   $0x26
  80034e:	68 d8 36 80 00       	push   $0x8036d8
  800353:	e8 65 ff ff ff       	call   8002bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80035f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800366:	e9 c2 00 00 00       	jmp    80042d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	75 08                	jne    800388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800383:	e9 a2 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800396:	eb 69                	jmp    800401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800398:	a1 20 40 80 00       	mov    0x804020,%eax
  80039d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a6:	89 d0                	mov    %edx,%eax
  8003a8:	01 c0                	add    %eax,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	c1 e0 03             	shl    $0x3,%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8a 40 04             	mov    0x4(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	75 46                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f1:	39 c2                	cmp    %eax,%edx
  8003f3:	75 09                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fc:	eb 12                	jmp    800410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	ff 45 e8             	incl   -0x18(%ebp)
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 50 74             	mov    0x74(%eax),%edx
  800409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	77 88                	ja     800398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800414:	75 14                	jne    80042a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 e4 36 80 00       	push   $0x8036e4
  80041e:	6a 3a                	push   $0x3a
  800420:	68 d8 36 80 00       	push   $0x8036d8
  800425:	e8 93 fe ff ff       	call   8002bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042a:	ff 45 f0             	incl   -0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800433:	0f 8c 32 ff ff ff    	jl     80036b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800447:	eb 26                	jmp    80046f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800449:	a1 20 40 80 00       	mov    0x804020,%eax
  80044e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8a 40 04             	mov    0x4(%eax),%al
  800465:	3c 01                	cmp    $0x1,%al
  800467:	75 03                	jne    80046c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e0             	incl   -0x20(%ebp)
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 cb                	ja     800449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 38 37 80 00       	push   $0x803738
  80048e:	6a 44                	push   $0x44
  800490:	68 d8 36 80 00       	push   $0x8036d8
  800495:	e8 23 fe ff ff       	call   8002bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 0a                	mov    %ecx,(%edx)
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	88 d1                	mov    %dl,%cl
  8004b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c8:	a0 24 40 80 00       	mov    0x804024,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	8b 12                	mov    (%edx),%edx
  8004d5:	89 d1                	mov    %edx,%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	83 c2 08             	add    $0x8,%edx
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	50                   	push   %eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	e8 7c 13 00 00       	call   801864 <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800516:	00 00 00 
	b.cnt = 0;
  800519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	68 9d 04 80 00       	push   $0x80049d
  800535:	e8 11 02 00 00       	call   80074b <vprintfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053d:	a0 24 40 80 00       	mov    0x804024,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	52                   	push   %edx
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	83 c0 08             	add    $0x8,%eax
  800559:	50                   	push   %eax
  80055a:	e8 05 13 00 00       	call   801864 <sys_cputs>
  80055f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800562:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <cprintf>:

int cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800577:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	50                   	push   %eax
  80058e:	e8 73 ff ff ff       	call   800506 <vcprintf>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a4:	e8 69 14 00 00       	call   801a12 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 48 ff ff ff       	call   800506 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c4:	e8 63 14 00 00       	call   801a2c <sys_enable_interrupt>
	return cnt;
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 14             	sub    $0x14,%esp
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ec:	77 55                	ja     800643 <printnum+0x75>
  8005ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f1:	72 05                	jb     8005f8 <printnum+0x2a>
  8005f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f6:	77 4b                	ja     800643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	ff 75 f0             	pushl  -0x10(%ebp)
  80060e:	e8 35 2b 00 00       	call   803148 <__udivdi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 20             	pushl  0x20(%ebp)
  80061c:	53                   	push   %ebx
  80061d:	ff 75 18             	pushl  0x18(%ebp)
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 a1 ff ff ff       	call   8005ce <printnum>
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	eb 1a                	jmp    80064c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 20             	pushl  0x20(%ebp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800643:	ff 4d 1c             	decl   0x1c(%ebp)
  800646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064a:	7f e6                	jg     800632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	52                   	push   %edx
  80065d:	50                   	push   %eax
  80065e:	e8 f5 2b 00 00       	call   803258 <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 b4 39 80 00       	add    $0x8039b4,%eax
  80066b:	8a 00                	mov    (%eax),%al
  80066d:	0f be c0             	movsbl %al,%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	ff d0                	call   *%eax
  80067c:	83 c4 10             	add    $0x10,%esp
}
  80067f:	90                   	nop
  800680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 40                	jmp    8006ea <getuint+0x65>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1e                	je     8006ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	eb 1c                	jmp    8006ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 04             	sub    $0x4,%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f3:	7e 1c                	jle    800711 <getint+0x25>
		return va_arg(*ap, long long);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 08             	lea    0x8(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 08             	sub    $0x8,%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	eb 38                	jmp    800749 <getint+0x5d>
	else if (lflag)
  800711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800715:	74 1a                	je     800731 <getint+0x45>
		return va_arg(*ap, long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 04             	lea    0x4(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	99                   	cltd   
  80072f:	eb 18                	jmp    800749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	99                   	cltd   
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	eb 17                	jmp    80076c <vprintfmt+0x21>
			if (ch == '\0')
  800755:	85 db                	test   %ebx,%ebx
  800757:	0f 84 af 03 00 00    	je     800b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	83 fb 25             	cmp    $0x25,%ebx
  80077d:	75 d6                	jne    800755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a2:	8d 50 01             	lea    0x1(%eax),%edx
  8007a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b0:	83 f8 55             	cmp    $0x55,%eax
  8007b3:	0f 87 2b 03 00 00    	ja     800ae4 <vprintfmt+0x399>
  8007b9:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  8007c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c6:	eb d7                	jmp    80079f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d1                	jmp    80079f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	c1 e0 02             	shl    $0x2,%eax
  8007dd:	01 d0                	add    %edx,%eax
  8007df:	01 c0                	add    %eax,%eax
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	83 e8 30             	sub    $0x30,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f4:	7e 3e                	jle    800834 <vprintfmt+0xe9>
  8007f6:	83 fb 39             	cmp    $0x39,%ebx
  8007f9:	7f 39                	jg     800834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007fe:	eb d5                	jmp    8007d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	79 83                	jns    80079f <vprintfmt+0x54>
				width = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800823:	e9 77 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80082f:	e9 6b ff ff ff       	jmp    80079f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800839:	0f 89 60 ff ff ff    	jns    80079f <vprintfmt+0x54>
				width = precision, precision = -1;
  80083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084c:	e9 4e ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800854:	e9 46 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 89 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80088f:	85 db                	test   %ebx,%ebx
  800891:	79 02                	jns    800895 <vprintfmt+0x14a>
				err = -err;
  800893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800895:	83 fb 64             	cmp    $0x64,%ebx
  800898:	7f 0b                	jg     8008a5 <vprintfmt+0x15a>
  80089a:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 c5 39 80 00       	push   $0x8039c5
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 5e 02 00 00       	call   800b14 <printfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 49 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	56                   	push   %esi
  8008bf:	68 ce 39 80 00       	push   $0x8039ce
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 45 02 00 00       	call   800b14 <printfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 30 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 30                	mov    (%eax),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 05                	jne    8008f1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ec:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7e 6d                	jle    800964 <vprintfmt+0x219>
  8008f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fb:	74 67                	je     800964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	50                   	push   %eax
  800904:	56                   	push   %esi
  800905:	e8 0c 03 00 00       	call   800c16 <strnlen>
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800910:	eb 16                	jmp    800928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	7f e4                	jg     800912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 34                	jmp    800964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800934:	74 1c                	je     800952 <vprintfmt+0x207>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x1f5>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 12                	jle    800952 <vprintfmt+0x207>
					putch('?', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 3f                	push   $0x3f
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb 0f                	jmp    800961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	89 f0                	mov    %esi,%eax
  800966:	8d 70 01             	lea    0x1(%eax),%esi
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be d8             	movsbl %al,%ebx
  80096e:	85 db                	test   %ebx,%ebx
  800970:	74 24                	je     800996 <vprintfmt+0x24b>
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	78 b8                	js     800930 <vprintfmt+0x1e5>
  800978:	ff 4d e0             	decl   -0x20(%ebp)
  80097b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097f:	79 af                	jns    800930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 13                	jmp    800996 <vprintfmt+0x24b>
				putch(' ', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 20                	push   $0x20
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e7                	jg     800983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099c:	e9 66 01 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 3c fd ff ff       	call   8006ec <getint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	79 23                	jns    8009e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 2d                	push   $0x2d
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	f7 d8                	neg    %eax
  8009db:	83 d2 00             	adc    $0x0,%edx
  8009de:	f7 da                	neg    %edx
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ed:	e9 bc 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 84 fc ff ff       	call   800685 <getuint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a11:	e9 98 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	6a 58                	push   $0x58
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 30                	push   $0x30
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 78                	push   $0x78
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 e8 04             	sub    $0x4,%eax
  800a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 e8             	pushl  -0x18(%ebp)
  800a95:	8d 45 14             	lea    0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	e8 e7 fb ff ff       	call   800685 <getuint>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	52                   	push   %edx
  800ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 00 fb ff ff       	call   8005ce <printnum>
  800ace:	83 c4 20             	add    $0x20,%esp
			break;
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	eb 23                	jmp    800b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 25                	push   $0x25
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	eb 03                	jmp    800afc <vprintfmt+0x3b1>
  800af9:	ff 4d 10             	decl   0x10(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	48                   	dec    %eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3c 25                	cmp    $0x25,%al
  800b04:	75 f3                	jne    800af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b06:	90                   	nop
		}
	}
  800b07:	e9 47 fc ff ff       	jmp    800753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 16 fc ff ff       	call   80074b <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8b 40 08             	mov    0x8(%eax),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 10                	mov    (%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 04             	mov    0x4(%eax),%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	73 12                	jae    800b6e <sprintputch+0x33>
		*b->buf++ = ch;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 48 01             	lea    0x1(%eax),%ecx
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 0a                	mov    %ecx,(%edx)
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	88 10                	mov    %dl,(%eax)
}
  800b6e:	90                   	nop
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b96:	74 06                	je     800b9e <vsnprintf+0x2d>
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	7f 07                	jg     800ba5 <vsnprintf+0x34>
		return -E_INVAL;
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	eb 20                	jmp    800bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba5:	ff 75 14             	pushl  0x14(%ebp)
  800ba8:	ff 75 10             	pushl  0x10(%ebp)
  800bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	68 3b 0b 80 00       	push   $0x800b3b
  800bb4:	e8 92 fb ff ff       	call   80074b <vprintfmt>
  800bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 89 ff ff ff       	call   800b71 <vsnprintf>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c00:	eb 06                	jmp    800c08 <strlen+0x15>
		n++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 f1                	jne    800c02 <strlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c23:	eb 09                	jmp    800c2e <strnlen+0x18>
		n++;
  800c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 4d 0c             	decl   0xc(%ebp)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 09                	je     800c3d <strnlen+0x27>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e8                	jne    800c25 <strnlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4e:	90                   	nop
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 08             	mov    %edx,0x8(%ebp)
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 e4                	jne    800c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 1f                	jmp    800ca4 <strncpy+0x34>
		*dst++ = *src;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 03                	je     800ca1 <strncpy+0x31>
			src++;
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca1:	ff 45 fc             	incl   -0x4(%ebp)
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800caa:	72 d9                	jb     800c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 30                	je     800cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc3:	eb 16                	jmp    800cdb <strlcpy+0x2a>
			*dst++ = *src++;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdb:	ff 4d 10             	decl   0x10(%ebp)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 09                	je     800ced <strlcpy+0x3c>
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 d8                	jne    800cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	29 c2                	sub    %eax,%edx
  800cfb:	89 d0                	mov    %edx,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d02:	eb 06                	jmp    800d0a <strcmp+0xb>
		p++, q++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strcmp+0x22>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 e3                	je     800d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3a:	eb 09                	jmp    800d45 <strncmp+0xe>
		n--, p++, q++;
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 17                	je     800d62 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 da                	je     800d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	75 07                	jne    800d6f <strncmp+0x38>
		return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb 14                	jmp    800d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 d0             	movzbl %al,%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 c0             	movzbl %al,%eax
  800d7f:	29 c2                	sub    %eax,%edx
  800d81:	89 d0                	mov    %edx,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 12                	jmp    800da5 <strchr+0x20>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	75 05                	jne    800da2 <strchr+0x1d>
			return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	eb 11                	jmp    800db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 e5                	jne    800d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc1:	eb 0d                	jmp    800dd0 <strfind+0x1b>
		if (*s == c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcb:	74 0e                	je     800ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 ea                	jne    800dc3 <strfind+0xe>
  800dd9:	eb 01                	jmp    800ddc <strfind+0x27>
		if (*s == c)
			break;
  800ddb:	90                   	nop
	return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df3:	eb 0e                	jmp    800e03 <memset+0x22>
		*p++ = c;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0a:	79 e9                	jns    800df5 <memset+0x14>
		*p++ = c;

	return v;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e23:	eb 16                	jmp    800e3b <memcpy+0x2a>
		*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	73 50                	jae    800eb7 <memmove+0x6a>
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e72:	76 43                	jbe    800eb7 <memmove+0x6a>
		s += n;
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 10                	jmp    800e92 <memmove+0x45>
			*--d = *--s;
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	ff 4d fc             	decl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 e3                	jne    800e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9f:	eb 23                	jmp    800ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 dd                	jne    800ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edb:	eb 2a                	jmp    800f07 <memcmp+0x3e>
		if (*s1 != *s2)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8a 10                	mov    (%eax),%dl
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	38 c2                	cmp    %al,%dl
  800ee9:	74 16                	je     800f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 c0             	movzbl %al,%eax
  800efb:	29 c2                	sub    %eax,%edx
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	eb 18                	jmp    800f19 <memcmp+0x50>
		s1++, s2++;
  800f01:	ff 45 fc             	incl   -0x4(%ebp)
  800f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 c9                	jne    800edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2c:	eb 15                	jmp    800f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	39 c2                	cmp    %eax,%edx
  800f3e:	74 0d                	je     800f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f49:	72 e3                	jb     800f2e <memfind+0x13>
  800f4b:	eb 01                	jmp    800f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4d:	90                   	nop
	return (void *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	eb 03                	jmp    800f6c <strtol+0x19>
		s++;
  800f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 20                	cmp    $0x20,%al
  800f73:	74 f4                	je     800f69 <strtol+0x16>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 09                	cmp    $0x9,%al
  800f7c:	74 eb                	je     800f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 2b                	cmp    $0x2b,%al
  800f85:	75 05                	jne    800f8c <strtol+0x39>
		s++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	eb 13                	jmp    800f9f <strtol+0x4c>
	else if (*s == '-')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2d                	cmp    $0x2d,%al
  800f93:	75 0a                	jne    800f9f <strtol+0x4c>
		s++, neg = 1;
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 06                	je     800fab <strtol+0x58>
  800fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa9:	75 20                	jne    800fcb <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 17                	jne    800fcb <strtol+0x78>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	40                   	inc    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 78                	cmp    $0x78,%al
  800fbc:	75 0d                	jne    800fcb <strtol+0x78>
		s += 2, base = 16;
  800fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc9:	eb 28                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 15                	jne    800fe6 <strtol+0x93>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 30                	cmp    $0x30,%al
  800fd8:	75 0c                	jne    800fe6 <strtol+0x93>
		s++, base = 8;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe4:	eb 0d                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strtol+0xa0>
		base = 10;
  800fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 2f                	cmp    $0x2f,%al
  800ffa:	7e 19                	jle    801015 <strtol+0xc2>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 39                	cmp    $0x39,%al
  801003:	7f 10                	jg     801015 <strtol+0xc2>
			dig = *s - '0';
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 30             	sub    $0x30,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801013:	eb 42                	jmp    801057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 60                	cmp    $0x60,%al
  80101c:	7e 19                	jle    801037 <strtol+0xe4>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 7a                	cmp    $0x7a,%al
  801025:	7f 10                	jg     801037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	83 e8 57             	sub    $0x57,%eax
  801032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801035:	eb 20                	jmp    801057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 40                	cmp    $0x40,%al
  80103e:	7e 39                	jle    801079 <strtol+0x126>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 5a                	cmp    $0x5a,%al
  801047:	7f 30                	jg     801079 <strtol+0x126>
			dig = *s - 'A' + 10;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be c0             	movsbl %al,%eax
  801051:	83 e8 37             	sub    $0x37,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105d:	7d 19                	jge    801078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801073:	e9 7b ff ff ff       	jmp    800ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 08                	je     801087 <strtol+0x134>
		*endptr = (char *) s;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108b:	74 07                	je     801094 <strtol+0x141>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	f7 d8                	neg    %eax
  801092:	eb 03                	jmp    801097 <strtol+0x144>
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <ltostr>:

void
ltostr(long value, char *str)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	79 13                	jns    8010c6 <ltostr+0x2d>
	{
		neg = 1;
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ce:	99                   	cltd   
  8010cf:	f7 f9                	idiv   %ecx
  8010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e7:	83 c2 30             	add    $0x30,%edx
  8010ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f4:	f7 e9                	imul   %ecx
  8010f6:	c1 fa 02             	sar    $0x2,%edx
  8010f9:	89 c8                	mov    %ecx,%eax
  8010fb:	c1 f8 1f             	sar    $0x1f,%eax
  8010fe:	29 c2                	sub    %eax,%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110d:	f7 e9                	imul   %ecx
  80110f:	c1 fa 02             	sar    $0x2,%edx
  801112:	89 c8                	mov    %ecx,%eax
  801114:	c1 f8 1f             	sar    $0x1f,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 02             	shl    $0x2,%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	01 c0                	add    %eax,%eax
  801122:	29 c1                	sub    %eax,%ecx
  801124:	89 ca                	mov    %ecx,%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	75 9c                	jne    8010c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	48                   	dec    %eax
  801135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 3d                	je     80117b <ltostr+0xe2>
		start = 1 ;
  80113e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801145:	eb 34                	jmp    80117b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8a 45 eb             	mov    -0x15(%ebp),%al
  801173:	88 02                	mov    %al,(%edx)
		start++ ;
  801175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801181:	7c c4                	jl     801147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 54 fa ff ff       	call   800bf3 <strlen>
  80119f:	83 c4 04             	add    $0x4,%esp
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 46 fa ff ff       	call   800bf3 <strlen>
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c1:	eb 17                	jmp    8011da <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d7:	ff 45 fc             	incl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e0:	7c e1                	jl     8011c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f0:	eb 1f                	jmp    801211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801217:	7c d9                	jl     8011f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)
}
  801224:	90                   	nop
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124a:	eb 0c                	jmp    801258 <strsplit+0x31>
			*string++ = 0;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 18                	je     801279 <strsplit+0x52>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 13 fb ff ff       	call   800d85 <strchr>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	75 d3                	jne    80124c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 5a                	je     8012dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	83 f8 0f             	cmp    $0xf,%eax
  80128a:	75 07                	jne    801293 <strsplit+0x6c>
		{
			return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
  801291:	eb 66                	jmp    8012f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 48 01             	lea    0x1(%eax),%ecx
  80129b:	8b 55 14             	mov    0x14(%ebp),%edx
  80129e:	89 0a                	mov    %ecx,(%edx)
  8012a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b1:	eb 03                	jmp    8012b6 <strsplit+0x8f>
			string++;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 8b                	je     80124a <strsplit+0x23>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b5 fa ff ff       	call   800d85 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	74 dc                	je     8012b3 <strsplit+0x8c>
			string++;
	}
  8012d7:	e9 6e ff ff ff       	jmp    80124a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801301:	a1 04 40 80 00       	mov    0x804004,%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1f                	je     801329 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80130a:	e8 1d 00 00 00       	call   80132c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	68 30 3b 80 00       	push   $0x803b30
  801317:	e8 55 f2 ff ff       	call   800571 <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131f:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801326:	00 00 00 
	}
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801332:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801339:	00 00 00 
  80133c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801343:	00 00 00 
  801346:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80134d:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801350:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801357:	00 00 00 
  80135a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801361:	00 00 00 
  801364:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80136b:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80136e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801375:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801378:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80137f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801393:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801398:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80139f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	6a 06                	push   $0x6
  8013b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013b4:	50                   	push   %eax
  8013b5:	e8 ee 05 00 00       	call   8019a8 <sys_allocate_chunk>
  8013ba:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013bd:	a1 20 41 80 00       	mov    0x804120,%eax
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	50                   	push   %eax
  8013c6:	e8 63 0c 00 00       	call   80202e <initialize_MemBlocksList>
  8013cb:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8013ce:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8013d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013d9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8013e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f1:	89 c2                	mov    %eax,%edx
  8013f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f6:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8013f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013fc:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801403:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80140a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140d:	8b 50 08             	mov    0x8(%eax),%edx
  801410:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	48                   	dec    %eax
  801416:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801419:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141c:	ba 00 00 00 00       	mov    $0x0,%edx
  801421:	f7 75 e0             	divl   -0x20(%ebp)
  801424:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801427:	29 d0                	sub    %edx,%eax
  801429:	89 c2                	mov    %eax,%edx
  80142b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80142e:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801431:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801435:	75 14                	jne    80144b <initialize_dyn_block_system+0x11f>
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	68 55 3b 80 00       	push   $0x803b55
  80143f:	6a 34                	push   $0x34
  801441:	68 73 3b 80 00       	push   $0x803b73
  801446:	e8 72 ee ff ff       	call   8002bd <_panic>
  80144b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144e:	8b 00                	mov    (%eax),%eax
  801450:	85 c0                	test   %eax,%eax
  801452:	74 10                	je     801464 <initialize_dyn_block_system+0x138>
  801454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801457:	8b 00                	mov    (%eax),%eax
  801459:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80145c:	8b 52 04             	mov    0x4(%edx),%edx
  80145f:	89 50 04             	mov    %edx,0x4(%eax)
  801462:	eb 0b                	jmp    80146f <initialize_dyn_block_system+0x143>
  801464:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801467:	8b 40 04             	mov    0x4(%eax),%eax
  80146a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80146f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801472:	8b 40 04             	mov    0x4(%eax),%eax
  801475:	85 c0                	test   %eax,%eax
  801477:	74 0f                	je     801488 <initialize_dyn_block_system+0x15c>
  801479:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80147c:	8b 40 04             	mov    0x4(%eax),%eax
  80147f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801482:	8b 12                	mov    (%edx),%edx
  801484:	89 10                	mov    %edx,(%eax)
  801486:	eb 0a                	jmp    801492 <initialize_dyn_block_system+0x166>
  801488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148b:	8b 00                	mov    (%eax),%eax
  80148d:	a3 48 41 80 00       	mov    %eax,0x804148
  801492:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801495:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80149b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80149e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014a5:	a1 54 41 80 00       	mov    0x804154,%eax
  8014aa:	48                   	dec    %eax
  8014ab:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8014b6:	e8 c4 13 00 00       	call   80287f <insert_sorted_with_merge_freeList>
  8014bb:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014be:	90                   	nop
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c7:	e8 2f fe ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  8014cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d0:	75 07                	jne    8014d9 <malloc+0x18>
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 71                	jmp    80154a <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8014d9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8014e0:	76 07                	jbe    8014e9 <malloc+0x28>
	return NULL;
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e7:	eb 61                	jmp    80154a <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014e9:	e8 88 08 00 00       	call   801d76 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	74 53                	je     801545 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014f2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ff:	01 d0                	add    %edx,%eax
  801501:	48                   	dec    %eax
  801502:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	ba 00 00 00 00       	mov    $0x0,%edx
  80150d:	f7 75 f4             	divl   -0xc(%ebp)
  801510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801513:	29 d0                	sub    %edx,%eax
  801515:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801518:	83 ec 0c             	sub    $0xc,%esp
  80151b:	ff 75 ec             	pushl  -0x14(%ebp)
  80151e:	e8 d2 0d 00 00       	call   8022f5 <alloc_block_FF>
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801529:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80152d:	74 16                	je     801545 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  80152f:	83 ec 0c             	sub    $0xc,%esp
  801532:	ff 75 e8             	pushl  -0x18(%ebp)
  801535:	e8 0c 0c 00 00       	call   802146 <insert_sorted_allocList>
  80153a:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80153d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801540:	8b 40 08             	mov    0x8(%eax),%eax
  801543:	eb 05                	jmp    80154a <malloc+0x89>
    }

			}


	return NULL;
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801560:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	ff 75 f0             	pushl  -0x10(%ebp)
  801569:	68 40 40 80 00       	push   $0x804040
  80156e:	e8 a0 0b 00 00       	call   802113 <find_block>
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157c:	8b 50 0c             	mov    0xc(%eax),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	52                   	push   %edx
  801586:	50                   	push   %eax
  801587:	e8 e4 03 00 00       	call   801970 <sys_free_user_mem>
  80158c:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80158f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801593:	75 17                	jne    8015ac <free+0x60>
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	68 55 3b 80 00       	push   $0x803b55
  80159d:	68 84 00 00 00       	push   $0x84
  8015a2:	68 73 3b 80 00       	push   $0x803b73
  8015a7:	e8 11 ed ff ff       	call   8002bd <_panic>
  8015ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015af:	8b 00                	mov    (%eax),%eax
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	74 10                	je     8015c5 <free+0x79>
  8015b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b8:	8b 00                	mov    (%eax),%eax
  8015ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015bd:	8b 52 04             	mov    0x4(%edx),%edx
  8015c0:	89 50 04             	mov    %edx,0x4(%eax)
  8015c3:	eb 0b                	jmp    8015d0 <free+0x84>
  8015c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c8:	8b 40 04             	mov    0x4(%eax),%eax
  8015cb:	a3 44 40 80 00       	mov    %eax,0x804044
  8015d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d3:	8b 40 04             	mov    0x4(%eax),%eax
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 0f                	je     8015e9 <free+0x9d>
  8015da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015dd:	8b 40 04             	mov    0x4(%eax),%eax
  8015e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e3:	8b 12                	mov    (%edx),%edx
  8015e5:	89 10                	mov    %edx,(%eax)
  8015e7:	eb 0a                	jmp    8015f3 <free+0xa7>
  8015e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ec:	8b 00                	mov    (%eax),%eax
  8015ee:	a3 40 40 80 00       	mov    %eax,0x804040
  8015f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801606:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80160b:	48                   	dec    %eax
  80160c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801611:	83 ec 0c             	sub    $0xc,%esp
  801614:	ff 75 ec             	pushl  -0x14(%ebp)
  801617:	e8 63 12 00 00       	call   80287f <insert_sorted_with_merge_freeList>
  80161c:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80161f:	90                   	nop
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 38             	sub    $0x38,%esp
  801628:	8b 45 10             	mov    0x10(%ebp),%eax
  80162b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162e:	e8 c8 fc ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801633:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801637:	75 0a                	jne    801643 <smalloc+0x21>
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
  80163e:	e9 a0 00 00 00       	jmp    8016e3 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801643:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80164a:	76 0a                	jbe    801656 <smalloc+0x34>
		return NULL;
  80164c:	b8 00 00 00 00       	mov    $0x0,%eax
  801651:	e9 8d 00 00 00       	jmp    8016e3 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801656:	e8 1b 07 00 00       	call   801d76 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80165b:	85 c0                	test   %eax,%eax
  80165d:	74 7f                	je     8016de <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80165f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166c:	01 d0                	add    %edx,%eax
  80166e:	48                   	dec    %eax
  80166f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801675:	ba 00 00 00 00       	mov    $0x0,%edx
  80167a:	f7 75 f4             	divl   -0xc(%ebp)
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	29 d0                	sub    %edx,%eax
  801682:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	ff 75 ec             	pushl  -0x14(%ebp)
  80168b:	e8 65 0c 00 00       	call   8022f5 <alloc_block_FF>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801696:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80169a:	74 42                	je     8016de <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a2:	e8 9f 0a 00 00       	call   802146 <insert_sorted_allocList>
  8016a7:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8016aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ad:	8b 40 08             	mov    0x8(%eax),%eax
  8016b0:	89 c2                	mov    %eax,%edx
  8016b2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016b6:	52                   	push   %edx
  8016b7:	50                   	push   %eax
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	e8 38 04 00 00       	call   801afb <sys_createSharedObject>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8016c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016cd:	79 07                	jns    8016d6 <smalloc+0xb4>
	    		  return NULL;
  8016cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d4:	eb 0d                	jmp    8016e3 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8016d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d9:	8b 40 08             	mov    0x8(%eax),%eax
  8016dc:	eb 05                	jmp    8016e3 <smalloc+0xc1>


				}


		return NULL;
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016eb:	e8 0b fc ff ff       	call   8012fb <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016f0:	e8 81 06 00 00       	call   801d76 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	0f 84 9f 00 00 00    	je     80179c <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	e8 1a 04 00 00       	call   801b25 <sys_getSizeOfSharedObject>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801715:	79 0a                	jns    801721 <sget+0x3c>
		return NULL;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	e9 80 00 00 00       	jmp    8017a1 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801721:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801728:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172e:	01 d0                	add    %edx,%eax
  801730:	48                   	dec    %eax
  801731:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801737:	ba 00 00 00 00       	mov    $0x0,%edx
  80173c:	f7 75 f0             	divl   -0x10(%ebp)
  80173f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801742:	29 d0                	sub    %edx,%eax
  801744:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801747:	83 ec 0c             	sub    $0xc,%esp
  80174a:	ff 75 e8             	pushl  -0x18(%ebp)
  80174d:	e8 a3 0b 00 00       	call   8022f5 <alloc_block_FF>
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801758:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80175c:	74 3e                	je     80179c <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80175e:	83 ec 0c             	sub    $0xc,%esp
  801761:	ff 75 e4             	pushl  -0x1c(%ebp)
  801764:	e8 dd 09 00 00       	call   802146 <insert_sorted_allocList>
  801769:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80176c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80176f:	8b 40 08             	mov    0x8(%eax),%eax
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	50                   	push   %eax
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	ff 75 08             	pushl  0x8(%ebp)
  80177c:	e8 c1 03 00 00       	call   801b42 <sys_getSharedObject>
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801787:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80178b:	79 07                	jns    801794 <sget+0xaf>
	    		  return NULL;
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	eb 0d                	jmp    8017a1 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801797:	8b 40 08             	mov    0x8(%eax),%eax
  80179a:	eb 05                	jmp    8017a1 <sget+0xbc>
	      }
	}
	   return NULL;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a9:	e8 4d fb ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	68 80 3b 80 00       	push   $0x803b80
  8017b6:	68 12 01 00 00       	push   $0x112
  8017bb:	68 73 3b 80 00       	push   $0x803b73
  8017c0:	e8 f8 ea ff ff       	call   8002bd <_panic>

008017c5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	68 a8 3b 80 00       	push   $0x803ba8
  8017d3:	68 26 01 00 00       	push   $0x126
  8017d8:	68 73 3b 80 00       	push   $0x803b73
  8017dd:	e8 db ea ff ff       	call   8002bd <_panic>

008017e2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e8:	83 ec 04             	sub    $0x4,%esp
  8017eb:	68 cc 3b 80 00       	push   $0x803bcc
  8017f0:	68 31 01 00 00       	push   $0x131
  8017f5:	68 73 3b 80 00       	push   $0x803b73
  8017fa:	e8 be ea ff ff       	call   8002bd <_panic>

008017ff <shrink>:

}
void shrink(uint32 newSize)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	68 cc 3b 80 00       	push   $0x803bcc
  80180d:	68 36 01 00 00       	push   $0x136
  801812:	68 73 3b 80 00       	push   $0x803b73
  801817:	e8 a1 ea ff ff       	call   8002bd <_panic>

0080181c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 cc 3b 80 00       	push   $0x803bcc
  80182a:	68 3b 01 00 00       	push   $0x13b
  80182f:	68 73 3b 80 00       	push   $0x803b73
  801834:	e8 84 ea ff ff       	call   8002bd <_panic>

00801839 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	57                   	push   %edi
  80183d:	56                   	push   %esi
  80183e:	53                   	push   %ebx
  80183f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8b 55 0c             	mov    0xc(%ebp),%edx
  801848:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801851:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801854:	cd 30                	int    $0x30
  801856:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801859:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	5b                   	pop    %ebx
  801860:	5e                   	pop    %esi
  801861:	5f                   	pop    %edi
  801862:	5d                   	pop    %ebp
  801863:	c3                   	ret    

00801864 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	8b 45 10             	mov    0x10(%ebp),%eax
  80186d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801870:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	52                   	push   %edx
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	50                   	push   %eax
  801880:	6a 00                	push   $0x0
  801882:	e8 b2 ff ff ff       	call   801839 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_cgetc>:

int
sys_cgetc(void)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 01                	push   $0x1
  80189c:	e8 98 ff ff ff       	call   801839 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	52                   	push   %edx
  8018b6:	50                   	push   %eax
  8018b7:	6a 05                	push   $0x5
  8018b9:	e8 7b ff ff ff       	call   801839 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8018cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
  8018d9:	51                   	push   %ecx
  8018da:	52                   	push   %edx
  8018db:	50                   	push   %eax
  8018dc:	6a 06                	push   $0x6
  8018de:	e8 56 ff ff ff       	call   801839 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5e                   	pop    %esi
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    

008018ed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	52                   	push   %edx
  8018fd:	50                   	push   %eax
  8018fe:	6a 07                	push   $0x7
  801900:	e8 34 ff ff ff       	call   801839 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	6a 08                	push   $0x8
  80191b:	e8 19 ff ff ff       	call   801839 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 09                	push   $0x9
  801934:	e8 00 ff ff ff       	call   801839 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 0a                	push   $0xa
  80194d:	e8 e7 fe ff ff       	call   801839 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 0b                	push   $0xb
  801966:	e8 ce fe ff ff       	call   801839 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	ff 75 0c             	pushl  0xc(%ebp)
  80197c:	ff 75 08             	pushl  0x8(%ebp)
  80197f:	6a 0f                	push   $0xf
  801981:	e8 b3 fe ff ff       	call   801839 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
	return;
  801989:	90                   	nop
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	6a 10                	push   $0x10
  80199d:	e8 97 fe ff ff       	call   801839 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a5:	90                   	nop
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 10             	pushl  0x10(%ebp)
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 11                	push   $0x11
  8019ba:	e8 7a fe ff ff       	call   801839 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 0c                	push   $0xc
  8019d4:	e8 60 fe ff ff       	call   801839 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	6a 0d                	push   $0xd
  8019ee:	e8 46 fe ff ff       	call   801839 <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 0e                	push   $0xe
  801a07:	e8 2d fe ff ff       	call   801839 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 13                	push   $0x13
  801a21:	e8 13 fe ff ff       	call   801839 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 14                	push   $0x14
  801a3b:	e8 f9 fd ff ff       	call   801839 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	90                   	nop
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a52:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	50                   	push   %eax
  801a5f:	6a 15                	push   $0x15
  801a61:	e8 d3 fd ff ff       	call   801839 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 16                	push   $0x16
  801a7b:	e8 b9 fd ff ff       	call   801839 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	50                   	push   %eax
  801a96:	6a 17                	push   $0x17
  801a98:	e8 9c fd ff ff       	call   801839 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	52                   	push   %edx
  801ab2:	50                   	push   %eax
  801ab3:	6a 1a                	push   $0x1a
  801ab5:	e8 7f fd ff ff       	call   801839 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	52                   	push   %edx
  801acf:	50                   	push   %eax
  801ad0:	6a 18                	push   $0x18
  801ad2:	e8 62 fd ff ff       	call   801839 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	90                   	nop
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	6a 19                	push   $0x19
  801af0:	e8 44 fd ff ff       	call   801839 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 04             	sub    $0x4,%esp
  801b01:	8b 45 10             	mov    0x10(%ebp),%eax
  801b04:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b07:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b0a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	51                   	push   %ecx
  801b14:	52                   	push   %edx
  801b15:	ff 75 0c             	pushl  0xc(%ebp)
  801b18:	50                   	push   %eax
  801b19:	6a 1b                	push   $0x1b
  801b1b:	e8 19 fd ff ff       	call   801839 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	52                   	push   %edx
  801b35:	50                   	push   %eax
  801b36:	6a 1c                	push   $0x1c
  801b38:	e8 fc fc ff ff       	call   801839 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	51                   	push   %ecx
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 1d                	push   $0x1d
  801b57:	e8 dd fc ff ff       	call   801839 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 1e                	push   $0x1e
  801b74:	e8 c0 fc ff ff       	call   801839 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 1f                	push   $0x1f
  801b8d:	e8 a7 fc ff ff       	call   801839 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	6a 00                	push   $0x0
  801b9f:	ff 75 14             	pushl  0x14(%ebp)
  801ba2:	ff 75 10             	pushl  0x10(%ebp)
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	50                   	push   %eax
  801ba9:	6a 20                	push   $0x20
  801bab:	e8 89 fc ff ff       	call   801839 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	50                   	push   %eax
  801bc4:	6a 21                	push   $0x21
  801bc6:	e8 6e fc ff ff       	call   801839 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	90                   	nop
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	50                   	push   %eax
  801be0:	6a 22                	push   $0x22
  801be2:	e8 52 fc ff ff       	call   801839 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 02                	push   $0x2
  801bfb:	e8 39 fc ff ff       	call   801839 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 03                	push   $0x3
  801c14:	e8 20 fc ff ff       	call   801839 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 04                	push   $0x4
  801c2d:	e8 07 fc ff ff       	call   801839 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_exit_env>:


void sys_exit_env(void)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 23                	push   $0x23
  801c46:	e8 ee fb ff ff       	call   801839 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	90                   	nop
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5a:	8d 50 04             	lea    0x4(%eax),%edx
  801c5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	52                   	push   %edx
  801c67:	50                   	push   %eax
  801c68:	6a 24                	push   $0x24
  801c6a:	e8 ca fb ff ff       	call   801839 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
	return result;
  801c72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7b:	89 01                	mov    %eax,(%ecx)
  801c7d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	c9                   	leave  
  801c84:	c2 04 00             	ret    $0x4

00801c87 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	ff 75 10             	pushl  0x10(%ebp)
  801c91:	ff 75 0c             	pushl  0xc(%ebp)
  801c94:	ff 75 08             	pushl  0x8(%ebp)
  801c97:	6a 12                	push   $0x12
  801c99:	e8 9b fb ff ff       	call   801839 <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca1:	90                   	nop
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 25                	push   $0x25
  801cb3:	e8 81 fb ff ff       	call   801839 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	50                   	push   %eax
  801cd6:	6a 26                	push   $0x26
  801cd8:	e8 5c fb ff ff       	call   801839 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce0:	90                   	nop
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <rsttst>:
void rsttst()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 28                	push   $0x28
  801cf2:	e8 42 fb ff ff       	call   801839 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfa:	90                   	nop
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 04             	sub    $0x4,%esp
  801d03:	8b 45 14             	mov    0x14(%ebp),%eax
  801d06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d09:	8b 55 18             	mov    0x18(%ebp),%edx
  801d0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	ff 75 10             	pushl  0x10(%ebp)
  801d15:	ff 75 0c             	pushl  0xc(%ebp)
  801d18:	ff 75 08             	pushl  0x8(%ebp)
  801d1b:	6a 27                	push   $0x27
  801d1d:	e8 17 fb ff ff       	call   801839 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
	return ;
  801d25:	90                   	nop
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <chktst>:
void chktst(uint32 n)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	ff 75 08             	pushl  0x8(%ebp)
  801d36:	6a 29                	push   $0x29
  801d38:	e8 fc fa ff ff       	call   801839 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d40:	90                   	nop
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <inctst>:

void inctst()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 2a                	push   $0x2a
  801d52:	e8 e2 fa ff ff       	call   801839 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5a:	90                   	nop
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <gettst>:
uint32 gettst()
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 2b                	push   $0x2b
  801d6c:	e8 c8 fa ff ff       	call   801839 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 2c                	push   $0x2c
  801d88:	e8 ac fa ff ff       	call   801839 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
  801d90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d93:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d97:	75 07                	jne    801da0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d99:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9e:	eb 05                	jmp    801da5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 2c                	push   $0x2c
  801db9:	e8 7b fa ff ff       	call   801839 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
  801dc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc8:	75 07                	jne    801dd1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dca:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcf:	eb 05                	jmp    801dd6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 2c                	push   $0x2c
  801dea:	e8 4a fa ff ff       	call   801839 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
  801df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df9:	75 07                	jne    801e02 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dfb:	b8 01 00 00 00       	mov    $0x1,%eax
  801e00:	eb 05                	jmp    801e07 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 2c                	push   $0x2c
  801e1b:	e8 19 fa ff ff       	call   801839 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
  801e23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e26:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e2a:	75 07                	jne    801e33 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e31:	eb 05                	jmp    801e38 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	6a 2d                	push   $0x2d
  801e4a:	e8 ea f9 ff ff       	call   801839 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e52:	90                   	nop
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	6a 00                	push   $0x0
  801e67:	53                   	push   %ebx
  801e68:	51                   	push   %ecx
  801e69:	52                   	push   %edx
  801e6a:	50                   	push   %eax
  801e6b:	6a 2e                	push   $0x2e
  801e6d:	e8 c7 f9 ff ff       	call   801839 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	52                   	push   %edx
  801e8a:	50                   	push   %eax
  801e8b:	6a 2f                	push   $0x2f
  801e8d:	e8 a7 f9 ff ff       	call   801839 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	68 dc 3b 80 00       	push   $0x803bdc
  801ea5:	e8 c7 e6 ff ff       	call   800571 <cprintf>
  801eaa:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ead:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	68 08 3c 80 00       	push   $0x803c08
  801ebc:	e8 b0 e6 ff ff       	call   800571 <cprintf>
  801ec1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec8:	a1 38 41 80 00       	mov    0x804138,%eax
  801ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed0:	eb 56                	jmp    801f28 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ed2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed6:	74 1c                	je     801ef4 <print_mem_block_lists+0x5d>
  801ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edb:	8b 50 08             	mov    0x8(%eax),%edx
  801ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee1:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eea:	01 c8                	add    %ecx,%eax
  801eec:	39 c2                	cmp    %eax,%edx
  801eee:	73 04                	jae    801ef4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ef0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	8b 50 08             	mov    0x8(%eax),%edx
  801efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efd:	8b 40 0c             	mov    0xc(%eax),%eax
  801f00:	01 c2                	add    %eax,%edx
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	8b 40 08             	mov    0x8(%eax),%eax
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	68 1d 3c 80 00       	push   $0x803c1d
  801f12:	e8 5a e6 ff ff       	call   800571 <cprintf>
  801f17:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f20:	a1 40 41 80 00       	mov    0x804140,%eax
  801f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2c:	74 07                	je     801f35 <print_mem_block_lists+0x9e>
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	8b 00                	mov    (%eax),%eax
  801f33:	eb 05                	jmp    801f3a <print_mem_block_lists+0xa3>
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	a3 40 41 80 00       	mov    %eax,0x804140
  801f3f:	a1 40 41 80 00       	mov    0x804140,%eax
  801f44:	85 c0                	test   %eax,%eax
  801f46:	75 8a                	jne    801ed2 <print_mem_block_lists+0x3b>
  801f48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4c:	75 84                	jne    801ed2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f4e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f52:	75 10                	jne    801f64 <print_mem_block_lists+0xcd>
  801f54:	83 ec 0c             	sub    $0xc,%esp
  801f57:	68 2c 3c 80 00       	push   $0x803c2c
  801f5c:	e8 10 e6 ff ff       	call   800571 <cprintf>
  801f61:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	68 50 3c 80 00       	push   $0x803c50
  801f73:	e8 f9 e5 ff ff       	call   800571 <cprintf>
  801f78:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f7b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7f:	a1 40 40 80 00       	mov    0x804040,%eax
  801f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f87:	eb 56                	jmp    801fdf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8d:	74 1c                	je     801fab <print_mem_block_lists+0x114>
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	8b 50 08             	mov    0x8(%eax),%edx
  801f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f98:	8b 48 08             	mov    0x8(%eax),%ecx
  801f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa1:	01 c8                	add    %ecx,%eax
  801fa3:	39 c2                	cmp    %eax,%edx
  801fa5:	73 04                	jae    801fab <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 50 08             	mov    0x8(%eax),%edx
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb7:	01 c2                	add    %eax,%edx
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 40 08             	mov    0x8(%eax),%eax
  801fbf:	83 ec 04             	sub    $0x4,%esp
  801fc2:	52                   	push   %edx
  801fc3:	50                   	push   %eax
  801fc4:	68 1d 3c 80 00       	push   $0x803c1d
  801fc9:	e8 a3 e5 ff ff       	call   800571 <cprintf>
  801fce:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd7:	a1 48 40 80 00       	mov    0x804048,%eax
  801fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe3:	74 07                	je     801fec <print_mem_block_lists+0x155>
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	8b 00                	mov    (%eax),%eax
  801fea:	eb 05                	jmp    801ff1 <print_mem_block_lists+0x15a>
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff1:	a3 48 40 80 00       	mov    %eax,0x804048
  801ff6:	a1 48 40 80 00       	mov    0x804048,%eax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	75 8a                	jne    801f89 <print_mem_block_lists+0xf2>
  801fff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802003:	75 84                	jne    801f89 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802005:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802009:	75 10                	jne    80201b <print_mem_block_lists+0x184>
  80200b:	83 ec 0c             	sub    $0xc,%esp
  80200e:	68 68 3c 80 00       	push   $0x803c68
  802013:	e8 59 e5 ff ff       	call   800571 <cprintf>
  802018:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	68 dc 3b 80 00       	push   $0x803bdc
  802023:	e8 49 e5 ff ff       	call   800571 <cprintf>
  802028:	83 c4 10             	add    $0x10,%esp

}
  80202b:	90                   	nop
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802034:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80203b:	00 00 00 
  80203e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802045:	00 00 00 
  802048:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80204f:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802052:	a1 50 40 80 00       	mov    0x804050,%eax
  802057:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80205a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802061:	e9 9e 00 00 00       	jmp    802104 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802066:	a1 50 40 80 00       	mov    0x804050,%eax
  80206b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206e:	c1 e2 04             	shl    $0x4,%edx
  802071:	01 d0                	add    %edx,%eax
  802073:	85 c0                	test   %eax,%eax
  802075:	75 14                	jne    80208b <initialize_MemBlocksList+0x5d>
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	68 90 3c 80 00       	push   $0x803c90
  80207f:	6a 48                	push   $0x48
  802081:	68 b3 3c 80 00       	push   $0x803cb3
  802086:	e8 32 e2 ff ff       	call   8002bd <_panic>
  80208b:	a1 50 40 80 00       	mov    0x804050,%eax
  802090:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802093:	c1 e2 04             	shl    $0x4,%edx
  802096:	01 d0                	add    %edx,%eax
  802098:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80209e:	89 10                	mov    %edx,(%eax)
  8020a0:	8b 00                	mov    (%eax),%eax
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	74 18                	je     8020be <initialize_MemBlocksList+0x90>
  8020a6:	a1 48 41 80 00       	mov    0x804148,%eax
  8020ab:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020b1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020b4:	c1 e1 04             	shl    $0x4,%ecx
  8020b7:	01 ca                	add    %ecx,%edx
  8020b9:	89 50 04             	mov    %edx,0x4(%eax)
  8020bc:	eb 12                	jmp    8020d0 <initialize_MemBlocksList+0xa2>
  8020be:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c6:	c1 e2 04             	shl    $0x4,%edx
  8020c9:	01 d0                	add    %edx,%eax
  8020cb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020d0:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d8:	c1 e2 04             	shl    $0x4,%edx
  8020db:	01 d0                	add    %edx,%eax
  8020dd:	a3 48 41 80 00       	mov    %eax,0x804148
  8020e2:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ea:	c1 e2 04             	shl    $0x4,%edx
  8020ed:	01 d0                	add    %edx,%eax
  8020ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f6:	a1 54 41 80 00       	mov    0x804154,%eax
  8020fb:	40                   	inc    %eax
  8020fc:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802101:	ff 45 f4             	incl   -0xc(%ebp)
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	3b 45 08             	cmp    0x8(%ebp),%eax
  80210a:	0f 82 56 ff ff ff    	jb     802066 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802110:	90                   	nop
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802121:	eb 18                	jmp    80213b <find_block+0x28>
		{
			if(tmp->sva==va)
  802123:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802126:	8b 40 08             	mov    0x8(%eax),%eax
  802129:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80212c:	75 05                	jne    802133 <find_block+0x20>
			{
				return tmp;
  80212e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802131:	eb 11                	jmp    802144 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80213b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213f:	75 e2                	jne    802123 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802141:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80214c:	a1 40 40 80 00       	mov    0x804040,%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	0f 85 83 00 00 00    	jne    8021dc <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802159:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802160:	00 00 00 
  802163:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80216a:	00 00 00 
  80216d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802174:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802177:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217b:	75 14                	jne    802191 <insert_sorted_allocList+0x4b>
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	68 90 3c 80 00       	push   $0x803c90
  802185:	6a 7f                	push   $0x7f
  802187:	68 b3 3c 80 00       	push   $0x803cb3
  80218c:	e8 2c e1 ff ff       	call   8002bd <_panic>
  802191:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	89 10                	mov    %edx,(%eax)
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	8b 00                	mov    (%eax),%eax
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	74 0d                	je     8021b2 <insert_sorted_allocList+0x6c>
  8021a5:	a1 40 40 80 00       	mov    0x804040,%eax
  8021aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ad:	89 50 04             	mov    %edx,0x4(%eax)
  8021b0:	eb 08                	jmp    8021ba <insert_sorted_allocList+0x74>
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	a3 40 40 80 00       	mov    %eax,0x804040
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021cc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d1:	40                   	inc    %eax
  8021d2:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021d7:	e9 16 01 00 00       	jmp    8022f2 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 50 08             	mov    0x8(%eax),%edx
  8021e2:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ea:	39 c2                	cmp    %eax,%edx
  8021ec:	76 68                	jbe    802256 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f2:	75 17                	jne    80220b <insert_sorted_allocList+0xc5>
  8021f4:	83 ec 04             	sub    $0x4,%esp
  8021f7:	68 cc 3c 80 00       	push   $0x803ccc
  8021fc:	68 85 00 00 00       	push   $0x85
  802201:	68 b3 3c 80 00       	push   $0x803cb3
  802206:	e8 b2 e0 ff ff       	call   8002bd <_panic>
  80220b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	89 50 04             	mov    %edx,0x4(%eax)
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8b 40 04             	mov    0x4(%eax),%eax
  80221d:	85 c0                	test   %eax,%eax
  80221f:	74 0c                	je     80222d <insert_sorted_allocList+0xe7>
  802221:	a1 44 40 80 00       	mov    0x804044,%eax
  802226:	8b 55 08             	mov    0x8(%ebp),%edx
  802229:	89 10                	mov    %edx,(%eax)
  80222b:	eb 08                	jmp    802235 <insert_sorted_allocList+0xef>
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	a3 40 40 80 00       	mov    %eax,0x804040
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	a3 44 40 80 00       	mov    %eax,0x804044
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802246:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80224b:	40                   	inc    %eax
  80224c:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802251:	e9 9c 00 00 00       	jmp    8022f2 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802256:	a1 40 40 80 00       	mov    0x804040,%eax
  80225b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80225e:	e9 85 00 00 00       	jmp    8022e8 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8b 50 08             	mov    0x8(%eax),%edx
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 40 08             	mov    0x8(%eax),%eax
  80226f:	39 c2                	cmp    %eax,%edx
  802271:	73 6d                	jae    8022e0 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802273:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802277:	74 06                	je     80227f <insert_sorted_allocList+0x139>
  802279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227d:	75 17                	jne    802296 <insert_sorted_allocList+0x150>
  80227f:	83 ec 04             	sub    $0x4,%esp
  802282:	68 f0 3c 80 00       	push   $0x803cf0
  802287:	68 90 00 00 00       	push   $0x90
  80228c:	68 b3 3c 80 00       	push   $0x803cb3
  802291:	e8 27 e0 ff ff       	call   8002bd <_panic>
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 50 04             	mov    0x4(%eax),%edx
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	89 50 04             	mov    %edx,0x4(%eax)
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a8:	89 10                	mov    %edx,(%eax)
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 04             	mov    0x4(%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 0d                	je     8022c1 <insert_sorted_allocList+0x17b>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bd:	89 10                	mov    %edx,(%eax)
  8022bf:	eb 08                	jmp    8022c9 <insert_sorted_allocList+0x183>
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	a3 40 40 80 00       	mov    %eax,0x804040
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d7:	40                   	inc    %eax
  8022d8:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022dd:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022de:	eb 12                	jmp    8022f2 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	8b 00                	mov    (%eax),%eax
  8022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ec:	0f 85 71 ff ff ff    	jne    802263 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022f2:	90                   	nop
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8022fb:	a1 38 41 80 00       	mov    0x804138,%eax
  802300:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802303:	e9 76 01 00 00       	jmp    80247e <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 0c             	mov    0xc(%eax),%eax
  80230e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802311:	0f 85 8a 00 00 00    	jne    8023a1 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231b:	75 17                	jne    802334 <alloc_block_FF+0x3f>
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	68 25 3d 80 00       	push   $0x803d25
  802325:	68 a8 00 00 00       	push   $0xa8
  80232a:	68 b3 3c 80 00       	push   $0x803cb3
  80232f:	e8 89 df ff ff       	call   8002bd <_panic>
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	74 10                	je     80234d <alloc_block_FF+0x58>
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 00                	mov    (%eax),%eax
  802342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802345:	8b 52 04             	mov    0x4(%edx),%edx
  802348:	89 50 04             	mov    %edx,0x4(%eax)
  80234b:	eb 0b                	jmp    802358 <alloc_block_FF+0x63>
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 04             	mov    0x4(%eax),%eax
  802353:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 40 04             	mov    0x4(%eax),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	74 0f                	je     802371 <alloc_block_FF+0x7c>
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236b:	8b 12                	mov    (%edx),%edx
  80236d:	89 10                	mov    %edx,(%eax)
  80236f:	eb 0a                	jmp    80237b <alloc_block_FF+0x86>
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	a3 38 41 80 00       	mov    %eax,0x804138
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80238e:	a1 44 41 80 00       	mov    0x804144,%eax
  802393:	48                   	dec    %eax
  802394:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	e9 ea 00 00 00       	jmp    80248b <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023aa:	0f 86 c6 00 00 00    	jbe    802476 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8023b0:	a1 48 41 80 00       	mov    0x804148,%eax
  8023b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8023b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023be:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 50 08             	mov    0x8(%eax),%edx
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8023d6:	89 c2                	mov    %eax,%edx
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 50 08             	mov    0x8(%eax),%edx
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	01 c2                	add    %eax,%edx
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f3:	75 17                	jne    80240c <alloc_block_FF+0x117>
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	68 25 3d 80 00       	push   $0x803d25
  8023fd:	68 b6 00 00 00       	push   $0xb6
  802402:	68 b3 3c 80 00       	push   $0x803cb3
  802407:	e8 b1 de ff ff       	call   8002bd <_panic>
  80240c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	74 10                	je     802425 <alloc_block_FF+0x130>
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80241d:	8b 52 04             	mov    0x4(%edx),%edx
  802420:	89 50 04             	mov    %edx,0x4(%eax)
  802423:	eb 0b                	jmp    802430 <alloc_block_FF+0x13b>
  802425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 0f                	je     802449 <alloc_block_FF+0x154>
  80243a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243d:	8b 40 04             	mov    0x4(%eax),%eax
  802440:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802443:	8b 12                	mov    (%edx),%edx
  802445:	89 10                	mov    %edx,(%eax)
  802447:	eb 0a                	jmp    802453 <alloc_block_FF+0x15e>
  802449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	a3 48 41 80 00       	mov    %eax,0x804148
  802453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802456:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802466:	a1 54 41 80 00       	mov    0x804154,%eax
  80246b:	48                   	dec    %eax
  80246c:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802474:	eb 15                	jmp    80248b <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80247e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802482:	0f 85 80 fe ff ff    	jne    802308 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802493:	a1 38 41 80 00       	mov    0x804138,%eax
  802498:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80249b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8024a2:	e9 c0 00 00 00       	jmp    802567 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b0:	0f 85 8a 00 00 00    	jne    802540 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8024b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ba:	75 17                	jne    8024d3 <alloc_block_BF+0x46>
  8024bc:	83 ec 04             	sub    $0x4,%esp
  8024bf:	68 25 3d 80 00       	push   $0x803d25
  8024c4:	68 cf 00 00 00       	push   $0xcf
  8024c9:	68 b3 3c 80 00       	push   $0x803cb3
  8024ce:	e8 ea dd ff ff       	call   8002bd <_panic>
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	74 10                	je     8024ec <alloc_block_BF+0x5f>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e4:	8b 52 04             	mov    0x4(%edx),%edx
  8024e7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ea:	eb 0b                	jmp    8024f7 <alloc_block_BF+0x6a>
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 04             	mov    0x4(%eax),%eax
  8024f2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 40 04             	mov    0x4(%eax),%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	74 0f                	je     802510 <alloc_block_BF+0x83>
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 40 04             	mov    0x4(%eax),%eax
  802507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250a:	8b 12                	mov    (%edx),%edx
  80250c:	89 10                	mov    %edx,(%eax)
  80250e:	eb 0a                	jmp    80251a <alloc_block_BF+0x8d>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	a3 38 41 80 00       	mov    %eax,0x804138
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252d:	a1 44 41 80 00       	mov    0x804144,%eax
  802532:	48                   	dec    %eax
  802533:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	e9 2a 01 00 00       	jmp    80266a <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 0c             	mov    0xc(%eax),%eax
  802546:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802549:	73 14                	jae    80255f <alloc_block_BF+0xd2>
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 40 0c             	mov    0xc(%eax),%eax
  802551:	3b 45 08             	cmp    0x8(%ebp),%eax
  802554:	76 09                	jbe    80255f <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 0c             	mov    0xc(%eax),%eax
  80255c:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256b:	0f 85 36 ff ff ff    	jne    8024a7 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802571:	a1 38 41 80 00       	mov    0x804138,%eax
  802576:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802579:	e9 dd 00 00 00       	jmp    80265b <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 40 0c             	mov    0xc(%eax),%eax
  802584:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802587:	0f 85 c6 00 00 00    	jne    802653 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80258d:	a1 48 41 80 00       	mov    0x804148,%eax
  802592:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 50 08             	mov    0x8(%eax),%edx
  80259b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259e:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8025a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a7:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 50 08             	mov    0x8(%eax),%edx
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	01 c2                	add    %eax,%edx
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c4:	89 c2                	mov    %eax,%edx
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025d0:	75 17                	jne    8025e9 <alloc_block_BF+0x15c>
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	68 25 3d 80 00       	push   $0x803d25
  8025da:	68 eb 00 00 00       	push   $0xeb
  8025df:	68 b3 3c 80 00       	push   $0x803cb3
  8025e4:	e8 d4 dc ff ff       	call   8002bd <_panic>
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	8b 00                	mov    (%eax),%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	74 10                	je     802602 <alloc_block_BF+0x175>
  8025f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f5:	8b 00                	mov    (%eax),%eax
  8025f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025fa:	8b 52 04             	mov    0x4(%edx),%edx
  8025fd:	89 50 04             	mov    %edx,0x4(%eax)
  802600:	eb 0b                	jmp    80260d <alloc_block_BF+0x180>
  802602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802605:	8b 40 04             	mov    0x4(%eax),%eax
  802608:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80260d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802610:	8b 40 04             	mov    0x4(%eax),%eax
  802613:	85 c0                	test   %eax,%eax
  802615:	74 0f                	je     802626 <alloc_block_BF+0x199>
  802617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261a:	8b 40 04             	mov    0x4(%eax),%eax
  80261d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802620:	8b 12                	mov    (%edx),%edx
  802622:	89 10                	mov    %edx,(%eax)
  802624:	eb 0a                	jmp    802630 <alloc_block_BF+0x1a3>
  802626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	a3 48 41 80 00       	mov    %eax,0x804148
  802630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802633:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802643:	a1 54 41 80 00       	mov    0x804154,%eax
  802648:	48                   	dec    %eax
  802649:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	eb 17                	jmp    80266a <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80265b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265f:	0f 85 19 ff ff ff    	jne    80257e <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802672:	a1 40 40 80 00       	mov    0x804040,%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	75 19                	jne    802694 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80267b:	83 ec 0c             	sub    $0xc,%esp
  80267e:	ff 75 08             	pushl  0x8(%ebp)
  802681:	e8 6f fc ff ff       	call   8022f5 <alloc_block_FF>
  802686:	83 c4 10             	add    $0x10,%esp
  802689:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	e9 e9 01 00 00       	jmp    80287d <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802694:	a1 44 40 80 00       	mov    0x804044,%eax
  802699:	8b 40 08             	mov    0x8(%eax),%eax
  80269c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80269f:	a1 44 40 80 00       	mov    0x804044,%eax
  8026a4:	8b 50 0c             	mov    0xc(%eax),%edx
  8026a7:	a1 44 40 80 00       	mov    0x804044,%eax
  8026ac:	8b 40 08             	mov    0x8(%eax),%eax
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	83 ec 08             	sub    $0x8,%esp
  8026b4:	50                   	push   %eax
  8026b5:	68 38 41 80 00       	push   $0x804138
  8026ba:	e8 54 fa ff ff       	call   802113 <find_block>
  8026bf:	83 c4 10             	add    $0x10,%esp
  8026c2:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ce:	0f 85 9b 00 00 00    	jne    80276f <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 08             	mov    0x8(%eax),%eax
  8026e0:	01 d0                	add    %edx,%eax
  8026e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8026e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e9:	75 17                	jne    802702 <alloc_block_NF+0x96>
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	68 25 3d 80 00       	push   $0x803d25
  8026f3:	68 1a 01 00 00       	push   $0x11a
  8026f8:	68 b3 3c 80 00       	push   $0x803cb3
  8026fd:	e8 bb db ff ff       	call   8002bd <_panic>
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 10                	je     80271b <alloc_block_NF+0xaf>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	8b 52 04             	mov    0x4(%edx),%edx
  802716:	89 50 04             	mov    %edx,0x4(%eax)
  802719:	eb 0b                	jmp    802726 <alloc_block_NF+0xba>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	74 0f                	je     80273f <alloc_block_NF+0xd3>
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 04             	mov    0x4(%eax),%eax
  802736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802739:	8b 12                	mov    (%edx),%edx
  80273b:	89 10                	mov    %edx,(%eax)
  80273d:	eb 0a                	jmp    802749 <alloc_block_NF+0xdd>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	a3 38 41 80 00       	mov    %eax,0x804138
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275c:	a1 44 41 80 00       	mov    0x804144,%eax
  802761:	48                   	dec    %eax
  802762:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	e9 0e 01 00 00       	jmp    80287d <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 0c             	mov    0xc(%eax),%eax
  802775:	3b 45 08             	cmp    0x8(%ebp),%eax
  802778:	0f 86 cf 00 00 00    	jbe    80284d <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80277e:	a1 48 41 80 00       	mov    0x804148,%eax
  802783:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802789:	8b 55 08             	mov    0x8(%ebp),%edx
  80278c:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 50 08             	mov    0x8(%eax),%edx
  802795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802798:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 50 08             	mov    0x8(%eax),%edx
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	01 c2                	add    %eax,%edx
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b2:	2b 45 08             	sub    0x8(%ebp),%eax
  8027b5:	89 c2                	mov    %eax,%edx
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 40 08             	mov    0x8(%eax),%eax
  8027c3:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ca:	75 17                	jne    8027e3 <alloc_block_NF+0x177>
  8027cc:	83 ec 04             	sub    $0x4,%esp
  8027cf:	68 25 3d 80 00       	push   $0x803d25
  8027d4:	68 28 01 00 00       	push   $0x128
  8027d9:	68 b3 3c 80 00       	push   $0x803cb3
  8027de:	e8 da da ff ff       	call   8002bd <_panic>
  8027e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	74 10                	je     8027fc <alloc_block_NF+0x190>
  8027ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027f4:	8b 52 04             	mov    0x4(%edx),%edx
  8027f7:	89 50 04             	mov    %edx,0x4(%eax)
  8027fa:	eb 0b                	jmp    802807 <alloc_block_NF+0x19b>
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	8b 40 04             	mov    0x4(%eax),%eax
  802802:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280a:	8b 40 04             	mov    0x4(%eax),%eax
  80280d:	85 c0                	test   %eax,%eax
  80280f:	74 0f                	je     802820 <alloc_block_NF+0x1b4>
  802811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80281a:	8b 12                	mov    (%edx),%edx
  80281c:	89 10                	mov    %edx,(%eax)
  80281e:	eb 0a                	jmp    80282a <alloc_block_NF+0x1be>
  802820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802823:	8b 00                	mov    (%eax),%eax
  802825:	a3 48 41 80 00       	mov    %eax,0x804148
  80282a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802836:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283d:	a1 54 41 80 00       	mov    0x804154,%eax
  802842:	48                   	dec    %eax
  802843:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284b:	eb 30                	jmp    80287d <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80284d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802852:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802855:	75 0a                	jne    802861 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802857:	a1 38 41 80 00       	mov    0x804138,%eax
  80285c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285f:	eb 08                	jmp    802869 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 08             	mov    0x8(%eax),%eax
  80286f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802872:	0f 85 4d fe ff ff    	jne    8026c5 <alloc_block_NF+0x59>

			return NULL;
  802878:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	53                   	push   %ebx
  802883:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802886:	a1 38 41 80 00       	mov    0x804138,%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	0f 85 86 00 00 00    	jne    802919 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802893:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80289a:	00 00 00 
  80289d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8028a4:	00 00 00 
  8028a7:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8028ae:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b5:	75 17                	jne    8028ce <insert_sorted_with_merge_freeList+0x4f>
  8028b7:	83 ec 04             	sub    $0x4,%esp
  8028ba:	68 90 3c 80 00       	push   $0x803c90
  8028bf:	68 48 01 00 00       	push   $0x148
  8028c4:	68 b3 3c 80 00       	push   $0x803cb3
  8028c9:	e8 ef d9 ff ff       	call   8002bd <_panic>
  8028ce:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	89 10                	mov    %edx,(%eax)
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	74 0d                	je     8028ef <insert_sorted_with_merge_freeList+0x70>
  8028e2:	a1 38 41 80 00       	mov    0x804138,%eax
  8028e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	eb 08                	jmp    8028f7 <insert_sorted_with_merge_freeList+0x78>
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802909:	a1 44 41 80 00       	mov    0x804144,%eax
  80290e:	40                   	inc    %eax
  80290f:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802914:	e9 73 07 00 00       	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	8b 50 08             	mov    0x8(%eax),%edx
  80291f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802924:	8b 40 08             	mov    0x8(%eax),%eax
  802927:	39 c2                	cmp    %eax,%edx
  802929:	0f 86 84 00 00 00    	jbe    8029b3 <insert_sorted_with_merge_freeList+0x134>
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	8b 50 08             	mov    0x8(%eax),%edx
  802935:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80293a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80293d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802942:	8b 40 08             	mov    0x8(%eax),%eax
  802945:	01 c8                	add    %ecx,%eax
  802947:	39 c2                	cmp    %eax,%edx
  802949:	74 68                	je     8029b3 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  80294b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294f:	75 17                	jne    802968 <insert_sorted_with_merge_freeList+0xe9>
  802951:	83 ec 04             	sub    $0x4,%esp
  802954:	68 cc 3c 80 00       	push   $0x803ccc
  802959:	68 4c 01 00 00       	push   $0x14c
  80295e:	68 b3 3c 80 00       	push   $0x803cb3
  802963:	e8 55 d9 ff ff       	call   8002bd <_panic>
  802968:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	89 50 04             	mov    %edx,0x4(%eax)
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	8b 40 04             	mov    0x4(%eax),%eax
  80297a:	85 c0                	test   %eax,%eax
  80297c:	74 0c                	je     80298a <insert_sorted_with_merge_freeList+0x10b>
  80297e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802983:	8b 55 08             	mov    0x8(%ebp),%edx
  802986:	89 10                	mov    %edx,(%eax)
  802988:	eb 08                	jmp    802992 <insert_sorted_with_merge_freeList+0x113>
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	a3 38 41 80 00       	mov    %eax,0x804138
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8029a8:	40                   	inc    %eax
  8029a9:	a3 44 41 80 00       	mov    %eax,0x804144
  8029ae:	e9 d9 06 00 00       	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8b 50 08             	mov    0x8(%eax),%edx
  8029b9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029be:	8b 40 08             	mov    0x8(%eax),%eax
  8029c1:	39 c2                	cmp    %eax,%edx
  8029c3:	0f 86 b5 00 00 00    	jbe    802a7e <insert_sorted_with_merge_freeList+0x1ff>
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	8b 50 08             	mov    0x8(%eax),%edx
  8029cf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029d4:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029d7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029dc:	8b 40 08             	mov    0x8(%eax),%eax
  8029df:	01 c8                	add    %ecx,%eax
  8029e1:	39 c2                	cmp    %eax,%edx
  8029e3:	0f 85 95 00 00 00    	jne    802a7e <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029e9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ee:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029f4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fa:	8b 52 0c             	mov    0xc(%edx),%edx
  8029fd:	01 ca                	add    %ecx,%edx
  8029ff:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1a:	75 17                	jne    802a33 <insert_sorted_with_merge_freeList+0x1b4>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 90 3c 80 00       	push   $0x803c90
  802a24:	68 54 01 00 00       	push   $0x154
  802a29:	68 b3 3c 80 00       	push   $0x803cb3
  802a2e:	e8 8a d8 ff ff       	call   8002bd <_panic>
  802a33:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	89 10                	mov    %edx,(%eax)
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 0d                	je     802a54 <insert_sorted_with_merge_freeList+0x1d5>
  802a47:	a1 48 41 80 00       	mov    0x804148,%eax
  802a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4f:	89 50 04             	mov    %edx,0x4(%eax)
  802a52:	eb 08                	jmp    802a5c <insert_sorted_with_merge_freeList+0x1dd>
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6e:	a1 54 41 80 00       	mov    0x804154,%eax
  802a73:	40                   	inc    %eax
  802a74:	a3 54 41 80 00       	mov    %eax,0x804154
  802a79:	e9 0e 06 00 00       	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	8b 50 08             	mov    0x8(%eax),%edx
  802a84:	a1 38 41 80 00       	mov    0x804138,%eax
  802a89:	8b 40 08             	mov    0x8(%eax),%eax
  802a8c:	39 c2                	cmp    %eax,%edx
  802a8e:	0f 83 c1 00 00 00    	jae    802b55 <insert_sorted_with_merge_freeList+0x2d6>
  802a94:	a1 38 41 80 00       	mov    0x804138,%eax
  802a99:	8b 50 08             	mov    0x8(%eax),%edx
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	8b 48 08             	mov    0x8(%eax),%ecx
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa8:	01 c8                	add    %ecx,%eax
  802aaa:	39 c2                	cmp    %eax,%edx
  802aac:	0f 85 a3 00 00 00    	jne    802b55 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ab2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aba:	8b 52 08             	mov    0x8(%edx),%edx
  802abd:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ac0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802acb:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ace:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad1:	8b 52 0c             	mov    0xc(%edx),%edx
  802ad4:	01 ca                	add    %ecx,%edx
  802ad6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802aed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af1:	75 17                	jne    802b0a <insert_sorted_with_merge_freeList+0x28b>
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 90 3c 80 00       	push   $0x803c90
  802afb:	68 5d 01 00 00       	push   $0x15d
  802b00:	68 b3 3c 80 00       	push   $0x803cb3
  802b05:	e8 b3 d7 ff ff       	call   8002bd <_panic>
  802b0a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	89 10                	mov    %edx,(%eax)
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	85 c0                	test   %eax,%eax
  802b1c:	74 0d                	je     802b2b <insert_sorted_with_merge_freeList+0x2ac>
  802b1e:	a1 48 41 80 00       	mov    0x804148,%eax
  802b23:	8b 55 08             	mov    0x8(%ebp),%edx
  802b26:	89 50 04             	mov    %edx,0x4(%eax)
  802b29:	eb 08                	jmp    802b33 <insert_sorted_with_merge_freeList+0x2b4>
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	a3 48 41 80 00       	mov    %eax,0x804148
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b45:	a1 54 41 80 00       	mov    0x804154,%eax
  802b4a:	40                   	inc    %eax
  802b4b:	a3 54 41 80 00       	mov    %eax,0x804154
  802b50:	e9 37 05 00 00       	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	8b 50 08             	mov    0x8(%eax),%edx
  802b5b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b60:	8b 40 08             	mov    0x8(%eax),%eax
  802b63:	39 c2                	cmp    %eax,%edx
  802b65:	0f 83 82 00 00 00    	jae    802bed <insert_sorted_with_merge_freeList+0x36e>
  802b6b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b70:	8b 50 08             	mov    0x8(%eax),%edx
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	8b 48 08             	mov    0x8(%eax),%ecx
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7f:	01 c8                	add    %ecx,%eax
  802b81:	39 c2                	cmp    %eax,%edx
  802b83:	74 68                	je     802bed <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b89:	75 17                	jne    802ba2 <insert_sorted_with_merge_freeList+0x323>
  802b8b:	83 ec 04             	sub    $0x4,%esp
  802b8e:	68 90 3c 80 00       	push   $0x803c90
  802b93:	68 62 01 00 00       	push   $0x162
  802b98:	68 b3 3c 80 00       	push   $0x803cb3
  802b9d:	e8 1b d7 ff ff       	call   8002bd <_panic>
  802ba2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	89 10                	mov    %edx,(%eax)
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	74 0d                	je     802bc3 <insert_sorted_with_merge_freeList+0x344>
  802bb6:	a1 38 41 80 00       	mov    0x804138,%eax
  802bbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbe:	89 50 04             	mov    %edx,0x4(%eax)
  802bc1:	eb 08                	jmp    802bcb <insert_sorted_with_merge_freeList+0x34c>
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	a3 38 41 80 00       	mov    %eax,0x804138
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdd:	a1 44 41 80 00       	mov    0x804144,%eax
  802be2:	40                   	inc    %eax
  802be3:	a3 44 41 80 00       	mov    %eax,0x804144
  802be8:	e9 9f 04 00 00       	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802bed:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802bf7:	e9 84 04 00 00       	jmp    803080 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 50 08             	mov    0x8(%eax),%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	8b 40 08             	mov    0x8(%eax),%eax
  802c08:	39 c2                	cmp    %eax,%edx
  802c0a:	0f 86 a9 00 00 00    	jbe    802cb9 <insert_sorted_with_merge_freeList+0x43a>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 50 08             	mov    0x8(%eax),%edx
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 48 08             	mov    0x8(%eax),%ecx
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c22:	01 c8                	add    %ecx,%eax
  802c24:	39 c2                	cmp    %eax,%edx
  802c26:	0f 84 8d 00 00 00    	je     802cb9 <insert_sorted_with_merge_freeList+0x43a>
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	8b 50 08             	mov    0x8(%eax),%edx
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 40 04             	mov    0x4(%eax),%eax
  802c38:	8b 48 08             	mov    0x8(%eax),%ecx
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 40 04             	mov    0x4(%eax),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	01 c8                	add    %ecx,%eax
  802c46:	39 c2                	cmp    %eax,%edx
  802c48:	74 6f                	je     802cb9 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4e:	74 06                	je     802c56 <insert_sorted_with_merge_freeList+0x3d7>
  802c50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c54:	75 17                	jne    802c6d <insert_sorted_with_merge_freeList+0x3ee>
  802c56:	83 ec 04             	sub    $0x4,%esp
  802c59:	68 f0 3c 80 00       	push   $0x803cf0
  802c5e:	68 6b 01 00 00       	push   $0x16b
  802c63:	68 b3 3c 80 00       	push   $0x803cb3
  802c68:	e8 50 d6 ff ff       	call   8002bd <_panic>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 50 04             	mov    0x4(%eax),%edx
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	89 50 04             	mov    %edx,0x4(%eax)
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7f:	89 10                	mov    %edx,(%eax)
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 0d                	je     802c98 <insert_sorted_with_merge_freeList+0x419>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	8b 55 08             	mov    0x8(%ebp),%edx
  802c94:	89 10                	mov    %edx,(%eax)
  802c96:	eb 08                	jmp    802ca0 <insert_sorted_with_merge_freeList+0x421>
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	a3 38 41 80 00       	mov    %eax,0x804138
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca6:	89 50 04             	mov    %edx,0x4(%eax)
  802ca9:	a1 44 41 80 00       	mov    0x804144,%eax
  802cae:	40                   	inc    %eax
  802caf:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802cb4:	e9 d3 03 00 00       	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 50 08             	mov    0x8(%eax),%edx
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	8b 40 08             	mov    0x8(%eax),%eax
  802cc5:	39 c2                	cmp    %eax,%edx
  802cc7:	0f 86 da 00 00 00    	jbe    802da7 <insert_sorted_with_merge_freeList+0x528>
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 48 08             	mov    0x8(%eax),%ecx
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdf:	01 c8                	add    %ecx,%eax
  802ce1:	39 c2                	cmp    %eax,%edx
  802ce3:	0f 85 be 00 00 00    	jne    802da7 <insert_sorted_with_merge_freeList+0x528>
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 50 08             	mov    0x8(%eax),%edx
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	8b 48 08             	mov    0x8(%eax),%ecx
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	01 c8                	add    %ecx,%eax
  802d03:	39 c2                	cmp    %eax,%edx
  802d05:	0f 84 9c 00 00 00    	je     802da7 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	8b 50 08             	mov    0x8(%eax),%edx
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	8b 40 0c             	mov    0xc(%eax),%eax
  802d23:	01 c2                	add    %eax,%edx
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d43:	75 17                	jne    802d5c <insert_sorted_with_merge_freeList+0x4dd>
  802d45:	83 ec 04             	sub    $0x4,%esp
  802d48:	68 90 3c 80 00       	push   $0x803c90
  802d4d:	68 74 01 00 00       	push   $0x174
  802d52:	68 b3 3c 80 00       	push   $0x803cb3
  802d57:	e8 61 d5 ff ff       	call   8002bd <_panic>
  802d5c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	89 10                	mov    %edx,(%eax)
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 0d                	je     802d7d <insert_sorted_with_merge_freeList+0x4fe>
  802d70:	a1 48 41 80 00       	mov    0x804148,%eax
  802d75:	8b 55 08             	mov    0x8(%ebp),%edx
  802d78:	89 50 04             	mov    %edx,0x4(%eax)
  802d7b:	eb 08                	jmp    802d85 <insert_sorted_with_merge_freeList+0x506>
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	a3 48 41 80 00       	mov    %eax,0x804148
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d97:	a1 54 41 80 00       	mov    0x804154,%eax
  802d9c:	40                   	inc    %eax
  802d9d:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802da2:	e9 e5 02 00 00       	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 50 08             	mov    0x8(%eax),%edx
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 40 08             	mov    0x8(%eax),%eax
  802db3:	39 c2                	cmp    %eax,%edx
  802db5:	0f 86 d7 00 00 00    	jbe    802e92 <insert_sorted_with_merge_freeList+0x613>
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 50 08             	mov    0x8(%eax),%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 48 08             	mov    0x8(%eax),%ecx
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	01 c8                	add    %ecx,%eax
  802dcf:	39 c2                	cmp    %eax,%edx
  802dd1:	0f 84 bb 00 00 00    	je     802e92 <insert_sorted_with_merge_freeList+0x613>
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 50 08             	mov    0x8(%eax),%edx
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 40 04             	mov    0x4(%eax),%eax
  802de3:	8b 48 08             	mov    0x8(%eax),%ecx
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 40 04             	mov    0x4(%eax),%eax
  802dec:	8b 40 0c             	mov    0xc(%eax),%eax
  802def:	01 c8                	add    %ecx,%eax
  802df1:	39 c2                	cmp    %eax,%edx
  802df3:	0f 85 99 00 00 00    	jne    802e92 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 40 04             	mov    0x4(%eax),%eax
  802dff:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 50 0c             	mov    0xc(%eax),%edx
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0e:	01 c2                	add    %eax,%edx
  802e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e13:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2e:	75 17                	jne    802e47 <insert_sorted_with_merge_freeList+0x5c8>
  802e30:	83 ec 04             	sub    $0x4,%esp
  802e33:	68 90 3c 80 00       	push   $0x803c90
  802e38:	68 7d 01 00 00       	push   $0x17d
  802e3d:	68 b3 3c 80 00       	push   $0x803cb3
  802e42:	e8 76 d4 ff ff       	call   8002bd <_panic>
  802e47:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	89 10                	mov    %edx,(%eax)
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	74 0d                	je     802e68 <insert_sorted_with_merge_freeList+0x5e9>
  802e5b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e60:	8b 55 08             	mov    0x8(%ebp),%edx
  802e63:	89 50 04             	mov    %edx,0x4(%eax)
  802e66:	eb 08                	jmp    802e70 <insert_sorted_with_merge_freeList+0x5f1>
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	a3 48 41 80 00       	mov    %eax,0x804148
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e82:	a1 54 41 80 00       	mov    0x804154,%eax
  802e87:	40                   	inc    %eax
  802e88:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e8d:	e9 fa 01 00 00       	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 50 08             	mov    0x8(%eax),%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 40 08             	mov    0x8(%eax),%eax
  802e9e:	39 c2                	cmp    %eax,%edx
  802ea0:	0f 86 d2 01 00 00    	jbe    803078 <insert_sorted_with_merge_freeList+0x7f9>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 50 08             	mov    0x8(%eax),%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 48 08             	mov    0x8(%eax),%ecx
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb8:	01 c8                	add    %ecx,%eax
  802eba:	39 c2                	cmp    %eax,%edx
  802ebc:	0f 85 b6 01 00 00    	jne    803078 <insert_sorted_with_merge_freeList+0x7f9>
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 50 08             	mov    0x8(%eax),%edx
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 04             	mov    0x4(%eax),%eax
  802ece:	8b 48 08             	mov    0x8(%eax),%ecx
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eda:	01 c8                	add    %ecx,%eax
  802edc:	39 c2                	cmp    %eax,%edx
  802ede:	0f 85 94 01 00 00    	jne    803078 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eed:	8b 52 04             	mov    0x4(%edx),%edx
  802ef0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef6:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efc:	8b 52 0c             	mov    0xc(%edx),%edx
  802eff:	01 da                	add    %ebx,%edx
  802f01:	01 ca                	add    %ecx,%edx
  802f03:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1e:	75 17                	jne    802f37 <insert_sorted_with_merge_freeList+0x6b8>
  802f20:	83 ec 04             	sub    $0x4,%esp
  802f23:	68 25 3d 80 00       	push   $0x803d25
  802f28:	68 86 01 00 00       	push   $0x186
  802f2d:	68 b3 3c 80 00       	push   $0x803cb3
  802f32:	e8 86 d3 ff ff       	call   8002bd <_panic>
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	85 c0                	test   %eax,%eax
  802f3e:	74 10                	je     802f50 <insert_sorted_with_merge_freeList+0x6d1>
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f48:	8b 52 04             	mov    0x4(%edx),%edx
  802f4b:	89 50 04             	mov    %edx,0x4(%eax)
  802f4e:	eb 0b                	jmp    802f5b <insert_sorted_with_merge_freeList+0x6dc>
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	74 0f                	je     802f74 <insert_sorted_with_merge_freeList+0x6f5>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f6e:	8b 12                	mov    (%edx),%edx
  802f70:	89 10                	mov    %edx,(%eax)
  802f72:	eb 0a                	jmp    802f7e <insert_sorted_with_merge_freeList+0x6ff>
  802f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f77:	8b 00                	mov    (%eax),%eax
  802f79:	a3 38 41 80 00       	mov    %eax,0x804138
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f91:	a1 44 41 80 00       	mov    0x804144,%eax
  802f96:	48                   	dec    %eax
  802f97:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa0:	75 17                	jne    802fb9 <insert_sorted_with_merge_freeList+0x73a>
  802fa2:	83 ec 04             	sub    $0x4,%esp
  802fa5:	68 90 3c 80 00       	push   $0x803c90
  802faa:	68 87 01 00 00       	push   $0x187
  802faf:	68 b3 3c 80 00       	push   $0x803cb3
  802fb4:	e8 04 d3 ff ff       	call   8002bd <_panic>
  802fb9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	89 10                	mov    %edx,(%eax)
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 00                	mov    (%eax),%eax
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	74 0d                	je     802fda <insert_sorted_with_merge_freeList+0x75b>
  802fcd:	a1 48 41 80 00       	mov    0x804148,%eax
  802fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd5:	89 50 04             	mov    %edx,0x4(%eax)
  802fd8:	eb 08                	jmp    802fe2 <insert_sorted_with_merge_freeList+0x763>
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	a3 48 41 80 00       	mov    %eax,0x804148
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff4:	a1 54 41 80 00       	mov    0x804154,%eax
  802ff9:	40                   	inc    %eax
  802ffa:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803013:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803017:	75 17                	jne    803030 <insert_sorted_with_merge_freeList+0x7b1>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 90 3c 80 00       	push   $0x803c90
  803021:	68 8a 01 00 00       	push   $0x18a
  803026:	68 b3 3c 80 00       	push   $0x803cb3
  80302b:	e8 8d d2 ff ff       	call   8002bd <_panic>
  803030:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 0d                	je     803051 <insert_sorted_with_merge_freeList+0x7d2>
  803044:	a1 48 41 80 00       	mov    0x804148,%eax
  803049:	8b 55 08             	mov    0x8(%ebp),%edx
  80304c:	89 50 04             	mov    %edx,0x4(%eax)
  80304f:	eb 08                	jmp    803059 <insert_sorted_with_merge_freeList+0x7da>
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	a3 48 41 80 00       	mov    %eax,0x804148
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306b:	a1 54 41 80 00       	mov    0x804154,%eax
  803070:	40                   	inc    %eax
  803071:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803076:	eb 14                	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803080:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803084:	0f 85 72 fb ff ff    	jne    802bfc <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80308a:	eb 00                	jmp    80308c <insert_sorted_with_merge_freeList+0x80d>
  80308c:	90                   	nop
  80308d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
  803095:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803098:	8b 55 08             	mov    0x8(%ebp),%edx
  80309b:	89 d0                	mov    %edx,%eax
  80309d:	c1 e0 02             	shl    $0x2,%eax
  8030a0:	01 d0                	add    %edx,%eax
  8030a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030a9:	01 d0                	add    %edx,%eax
  8030ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030b2:	01 d0                	add    %edx,%eax
  8030b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030bb:	01 d0                	add    %edx,%eax
  8030bd:	c1 e0 04             	shl    $0x4,%eax
  8030c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030ca:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030cd:	83 ec 0c             	sub    $0xc,%esp
  8030d0:	50                   	push   %eax
  8030d1:	e8 7b eb ff ff       	call   801c51 <sys_get_virtual_time>
  8030d6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030d9:	eb 41                	jmp    80311c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030db:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030de:	83 ec 0c             	sub    $0xc,%esp
  8030e1:	50                   	push   %eax
  8030e2:	e8 6a eb ff ff       	call   801c51 <sys_get_virtual_time>
  8030e7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f0:	29 c2                	sub    %eax,%edx
  8030f2:	89 d0                	mov    %edx,%eax
  8030f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fd:	89 d1                	mov    %edx,%ecx
  8030ff:	29 c1                	sub    %eax,%ecx
  803101:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803107:	39 c2                	cmp    %eax,%edx
  803109:	0f 97 c0             	seta   %al
  80310c:	0f b6 c0             	movzbl %al,%eax
  80310f:	29 c1                	sub    %eax,%ecx
  803111:	89 c8                	mov    %ecx,%eax
  803113:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803116:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803119:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803122:	72 b7                	jb     8030db <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803124:	90                   	nop
  803125:	c9                   	leave  
  803126:	c3                   	ret    

00803127 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803127:	55                   	push   %ebp
  803128:	89 e5                	mov    %esp,%ebp
  80312a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80312d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803134:	eb 03                	jmp    803139 <busy_wait+0x12>
  803136:	ff 45 fc             	incl   -0x4(%ebp)
  803139:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80313c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313f:	72 f5                	jb     803136 <busy_wait+0xf>
	return i;
  803141:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803144:	c9                   	leave  
  803145:	c3                   	ret    
  803146:	66 90                	xchg   %ax,%ax

00803148 <__udivdi3>:
  803148:	55                   	push   %ebp
  803149:	57                   	push   %edi
  80314a:	56                   	push   %esi
  80314b:	53                   	push   %ebx
  80314c:	83 ec 1c             	sub    $0x1c,%esp
  80314f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803153:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803157:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80315b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80315f:	89 ca                	mov    %ecx,%edx
  803161:	89 f8                	mov    %edi,%eax
  803163:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803167:	85 f6                	test   %esi,%esi
  803169:	75 2d                	jne    803198 <__udivdi3+0x50>
  80316b:	39 cf                	cmp    %ecx,%edi
  80316d:	77 65                	ja     8031d4 <__udivdi3+0x8c>
  80316f:	89 fd                	mov    %edi,%ebp
  803171:	85 ff                	test   %edi,%edi
  803173:	75 0b                	jne    803180 <__udivdi3+0x38>
  803175:	b8 01 00 00 00       	mov    $0x1,%eax
  80317a:	31 d2                	xor    %edx,%edx
  80317c:	f7 f7                	div    %edi
  80317e:	89 c5                	mov    %eax,%ebp
  803180:	31 d2                	xor    %edx,%edx
  803182:	89 c8                	mov    %ecx,%eax
  803184:	f7 f5                	div    %ebp
  803186:	89 c1                	mov    %eax,%ecx
  803188:	89 d8                	mov    %ebx,%eax
  80318a:	f7 f5                	div    %ebp
  80318c:	89 cf                	mov    %ecx,%edi
  80318e:	89 fa                	mov    %edi,%edx
  803190:	83 c4 1c             	add    $0x1c,%esp
  803193:	5b                   	pop    %ebx
  803194:	5e                   	pop    %esi
  803195:	5f                   	pop    %edi
  803196:	5d                   	pop    %ebp
  803197:	c3                   	ret    
  803198:	39 ce                	cmp    %ecx,%esi
  80319a:	77 28                	ja     8031c4 <__udivdi3+0x7c>
  80319c:	0f bd fe             	bsr    %esi,%edi
  80319f:	83 f7 1f             	xor    $0x1f,%edi
  8031a2:	75 40                	jne    8031e4 <__udivdi3+0x9c>
  8031a4:	39 ce                	cmp    %ecx,%esi
  8031a6:	72 0a                	jb     8031b2 <__udivdi3+0x6a>
  8031a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031ac:	0f 87 9e 00 00 00    	ja     803250 <__udivdi3+0x108>
  8031b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031b7:	89 fa                	mov    %edi,%edx
  8031b9:	83 c4 1c             	add    $0x1c,%esp
  8031bc:	5b                   	pop    %ebx
  8031bd:	5e                   	pop    %esi
  8031be:	5f                   	pop    %edi
  8031bf:	5d                   	pop    %ebp
  8031c0:	c3                   	ret    
  8031c1:	8d 76 00             	lea    0x0(%esi),%esi
  8031c4:	31 ff                	xor    %edi,%edi
  8031c6:	31 c0                	xor    %eax,%eax
  8031c8:	89 fa                	mov    %edi,%edx
  8031ca:	83 c4 1c             	add    $0x1c,%esp
  8031cd:	5b                   	pop    %ebx
  8031ce:	5e                   	pop    %esi
  8031cf:	5f                   	pop    %edi
  8031d0:	5d                   	pop    %ebp
  8031d1:	c3                   	ret    
  8031d2:	66 90                	xchg   %ax,%ax
  8031d4:	89 d8                	mov    %ebx,%eax
  8031d6:	f7 f7                	div    %edi
  8031d8:	31 ff                	xor    %edi,%edi
  8031da:	89 fa                	mov    %edi,%edx
  8031dc:	83 c4 1c             	add    $0x1c,%esp
  8031df:	5b                   	pop    %ebx
  8031e0:	5e                   	pop    %esi
  8031e1:	5f                   	pop    %edi
  8031e2:	5d                   	pop    %ebp
  8031e3:	c3                   	ret    
  8031e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031e9:	89 eb                	mov    %ebp,%ebx
  8031eb:	29 fb                	sub    %edi,%ebx
  8031ed:	89 f9                	mov    %edi,%ecx
  8031ef:	d3 e6                	shl    %cl,%esi
  8031f1:	89 c5                	mov    %eax,%ebp
  8031f3:	88 d9                	mov    %bl,%cl
  8031f5:	d3 ed                	shr    %cl,%ebp
  8031f7:	89 e9                	mov    %ebp,%ecx
  8031f9:	09 f1                	or     %esi,%ecx
  8031fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031ff:	89 f9                	mov    %edi,%ecx
  803201:	d3 e0                	shl    %cl,%eax
  803203:	89 c5                	mov    %eax,%ebp
  803205:	89 d6                	mov    %edx,%esi
  803207:	88 d9                	mov    %bl,%cl
  803209:	d3 ee                	shr    %cl,%esi
  80320b:	89 f9                	mov    %edi,%ecx
  80320d:	d3 e2                	shl    %cl,%edx
  80320f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803213:	88 d9                	mov    %bl,%cl
  803215:	d3 e8                	shr    %cl,%eax
  803217:	09 c2                	or     %eax,%edx
  803219:	89 d0                	mov    %edx,%eax
  80321b:	89 f2                	mov    %esi,%edx
  80321d:	f7 74 24 0c          	divl   0xc(%esp)
  803221:	89 d6                	mov    %edx,%esi
  803223:	89 c3                	mov    %eax,%ebx
  803225:	f7 e5                	mul    %ebp
  803227:	39 d6                	cmp    %edx,%esi
  803229:	72 19                	jb     803244 <__udivdi3+0xfc>
  80322b:	74 0b                	je     803238 <__udivdi3+0xf0>
  80322d:	89 d8                	mov    %ebx,%eax
  80322f:	31 ff                	xor    %edi,%edi
  803231:	e9 58 ff ff ff       	jmp    80318e <__udivdi3+0x46>
  803236:	66 90                	xchg   %ax,%ax
  803238:	8b 54 24 08          	mov    0x8(%esp),%edx
  80323c:	89 f9                	mov    %edi,%ecx
  80323e:	d3 e2                	shl    %cl,%edx
  803240:	39 c2                	cmp    %eax,%edx
  803242:	73 e9                	jae    80322d <__udivdi3+0xe5>
  803244:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803247:	31 ff                	xor    %edi,%edi
  803249:	e9 40 ff ff ff       	jmp    80318e <__udivdi3+0x46>
  80324e:	66 90                	xchg   %ax,%ax
  803250:	31 c0                	xor    %eax,%eax
  803252:	e9 37 ff ff ff       	jmp    80318e <__udivdi3+0x46>
  803257:	90                   	nop

00803258 <__umoddi3>:
  803258:	55                   	push   %ebp
  803259:	57                   	push   %edi
  80325a:	56                   	push   %esi
  80325b:	53                   	push   %ebx
  80325c:	83 ec 1c             	sub    $0x1c,%esp
  80325f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803263:	8b 74 24 34          	mov    0x34(%esp),%esi
  803267:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80326b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80326f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803273:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803277:	89 f3                	mov    %esi,%ebx
  803279:	89 fa                	mov    %edi,%edx
  80327b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80327f:	89 34 24             	mov    %esi,(%esp)
  803282:	85 c0                	test   %eax,%eax
  803284:	75 1a                	jne    8032a0 <__umoddi3+0x48>
  803286:	39 f7                	cmp    %esi,%edi
  803288:	0f 86 a2 00 00 00    	jbe    803330 <__umoddi3+0xd8>
  80328e:	89 c8                	mov    %ecx,%eax
  803290:	89 f2                	mov    %esi,%edx
  803292:	f7 f7                	div    %edi
  803294:	89 d0                	mov    %edx,%eax
  803296:	31 d2                	xor    %edx,%edx
  803298:	83 c4 1c             	add    $0x1c,%esp
  80329b:	5b                   	pop    %ebx
  80329c:	5e                   	pop    %esi
  80329d:	5f                   	pop    %edi
  80329e:	5d                   	pop    %ebp
  80329f:	c3                   	ret    
  8032a0:	39 f0                	cmp    %esi,%eax
  8032a2:	0f 87 ac 00 00 00    	ja     803354 <__umoddi3+0xfc>
  8032a8:	0f bd e8             	bsr    %eax,%ebp
  8032ab:	83 f5 1f             	xor    $0x1f,%ebp
  8032ae:	0f 84 ac 00 00 00    	je     803360 <__umoddi3+0x108>
  8032b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8032b9:	29 ef                	sub    %ebp,%edi
  8032bb:	89 fe                	mov    %edi,%esi
  8032bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032c1:	89 e9                	mov    %ebp,%ecx
  8032c3:	d3 e0                	shl    %cl,%eax
  8032c5:	89 d7                	mov    %edx,%edi
  8032c7:	89 f1                	mov    %esi,%ecx
  8032c9:	d3 ef                	shr    %cl,%edi
  8032cb:	09 c7                	or     %eax,%edi
  8032cd:	89 e9                	mov    %ebp,%ecx
  8032cf:	d3 e2                	shl    %cl,%edx
  8032d1:	89 14 24             	mov    %edx,(%esp)
  8032d4:	89 d8                	mov    %ebx,%eax
  8032d6:	d3 e0                	shl    %cl,%eax
  8032d8:	89 c2                	mov    %eax,%edx
  8032da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032de:	d3 e0                	shl    %cl,%eax
  8032e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032e8:	89 f1                	mov    %esi,%ecx
  8032ea:	d3 e8                	shr    %cl,%eax
  8032ec:	09 d0                	or     %edx,%eax
  8032ee:	d3 eb                	shr    %cl,%ebx
  8032f0:	89 da                	mov    %ebx,%edx
  8032f2:	f7 f7                	div    %edi
  8032f4:	89 d3                	mov    %edx,%ebx
  8032f6:	f7 24 24             	mull   (%esp)
  8032f9:	89 c6                	mov    %eax,%esi
  8032fb:	89 d1                	mov    %edx,%ecx
  8032fd:	39 d3                	cmp    %edx,%ebx
  8032ff:	0f 82 87 00 00 00    	jb     80338c <__umoddi3+0x134>
  803305:	0f 84 91 00 00 00    	je     80339c <__umoddi3+0x144>
  80330b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80330f:	29 f2                	sub    %esi,%edx
  803311:	19 cb                	sbb    %ecx,%ebx
  803313:	89 d8                	mov    %ebx,%eax
  803315:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803319:	d3 e0                	shl    %cl,%eax
  80331b:	89 e9                	mov    %ebp,%ecx
  80331d:	d3 ea                	shr    %cl,%edx
  80331f:	09 d0                	or     %edx,%eax
  803321:	89 e9                	mov    %ebp,%ecx
  803323:	d3 eb                	shr    %cl,%ebx
  803325:	89 da                	mov    %ebx,%edx
  803327:	83 c4 1c             	add    $0x1c,%esp
  80332a:	5b                   	pop    %ebx
  80332b:	5e                   	pop    %esi
  80332c:	5f                   	pop    %edi
  80332d:	5d                   	pop    %ebp
  80332e:	c3                   	ret    
  80332f:	90                   	nop
  803330:	89 fd                	mov    %edi,%ebp
  803332:	85 ff                	test   %edi,%edi
  803334:	75 0b                	jne    803341 <__umoddi3+0xe9>
  803336:	b8 01 00 00 00       	mov    $0x1,%eax
  80333b:	31 d2                	xor    %edx,%edx
  80333d:	f7 f7                	div    %edi
  80333f:	89 c5                	mov    %eax,%ebp
  803341:	89 f0                	mov    %esi,%eax
  803343:	31 d2                	xor    %edx,%edx
  803345:	f7 f5                	div    %ebp
  803347:	89 c8                	mov    %ecx,%eax
  803349:	f7 f5                	div    %ebp
  80334b:	89 d0                	mov    %edx,%eax
  80334d:	e9 44 ff ff ff       	jmp    803296 <__umoddi3+0x3e>
  803352:	66 90                	xchg   %ax,%ax
  803354:	89 c8                	mov    %ecx,%eax
  803356:	89 f2                	mov    %esi,%edx
  803358:	83 c4 1c             	add    $0x1c,%esp
  80335b:	5b                   	pop    %ebx
  80335c:	5e                   	pop    %esi
  80335d:	5f                   	pop    %edi
  80335e:	5d                   	pop    %ebp
  80335f:	c3                   	ret    
  803360:	3b 04 24             	cmp    (%esp),%eax
  803363:	72 06                	jb     80336b <__umoddi3+0x113>
  803365:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803369:	77 0f                	ja     80337a <__umoddi3+0x122>
  80336b:	89 f2                	mov    %esi,%edx
  80336d:	29 f9                	sub    %edi,%ecx
  80336f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803373:	89 14 24             	mov    %edx,(%esp)
  803376:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80337a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80337e:	8b 14 24             	mov    (%esp),%edx
  803381:	83 c4 1c             	add    $0x1c,%esp
  803384:	5b                   	pop    %ebx
  803385:	5e                   	pop    %esi
  803386:	5f                   	pop    %edi
  803387:	5d                   	pop    %ebp
  803388:	c3                   	ret    
  803389:	8d 76 00             	lea    0x0(%esi),%esi
  80338c:	2b 04 24             	sub    (%esp),%eax
  80338f:	19 fa                	sbb    %edi,%edx
  803391:	89 d1                	mov    %edx,%ecx
  803393:	89 c6                	mov    %eax,%esi
  803395:	e9 71 ff ff ff       	jmp    80330b <__umoddi3+0xb3>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033a0:	72 ea                	jb     80338c <__umoddi3+0x134>
  8033a2:	89 d9                	mov    %ebx,%ecx
  8033a4:	e9 62 ff ff ff       	jmp    80330b <__umoddi3+0xb3>
