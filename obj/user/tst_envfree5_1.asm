
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
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
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 32 80 00       	push   $0x8032c0
  80004a:	e8 98 15 00 00       	call   8015e7 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 87 18 00 00       	call   8018ea <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 1f 19 00 00       	call   80198a <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 32 80 00       	push   $0x8032d0
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 03 33 80 00       	push   $0x803303
  800099:	e8 be 1a 00 00       	call   801b5c <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 cb 1a 00 00       	call   801b7a <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 28 18 00 00       	call   8018ea <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 0c 33 80 00       	push   $0x80330c
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 b8 1a 00 00       	call   801b96 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 04 18 00 00       	call   8018ea <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 9c 18 00 00       	call   80198a <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 40 33 80 00       	push   $0x803340
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 90 33 80 00       	push   $0x803390
  800114:	6a 1e                	push   $0x1e
  800116:	68 c6 33 80 00       	push   $0x8033c6
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 dc 33 80 00       	push   $0x8033dc
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 3c 34 80 00       	push   $0x80343c
  80013b:	e8 f6 03 00 00       	call   800536 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 79 1a 00 00       	call   801bca <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 1b 18 00 00       	call   8019d7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 a0 34 80 00       	push   $0x8034a0
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 c8 34 80 00       	push   $0x8034c8
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 40 80 00       	mov    0x804020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 f0 34 80 00       	push   $0x8034f0
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 48 35 80 00       	push   $0x803548
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 a0 34 80 00       	push   $0x8034a0
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 9b 17 00 00       	call   8019f1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 28 19 00 00       	call   801b96 <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 7d 19 00 00       	call   801bfc <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 5c 35 80 00       	push   $0x80355c
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 61 35 80 00       	push   $0x803561
  8002c1:	e8 70 02 00 00       	call   800536 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 f3 01 00 00       	call   8004cb <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 7d 35 80 00       	push   $0x80357d
  8002e5:	e8 e1 01 00 00       	call   8004cb <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 80 35 80 00       	push   $0x803580
  800311:	6a 26                	push   $0x26
  800313:	68 cc 35 80 00       	push   $0x8035cc
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 c2 00 00 00       	jmp    8003f2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 a2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 69                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
  800362:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 46                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	89 d0                	mov    %edx,%eax
  80038d:	01 c0                	add    %eax,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 03             	shl    $0x3,%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	75 09                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c1:	eb 12                	jmp    8003d5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	ff 45 e8             	incl   -0x18(%ebp)
  8003c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cb:	8b 50 74             	mov    0x74(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 88                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 d8 35 80 00       	push   $0x8035d8
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 cc 35 80 00       	push   $0x8035cc
  8003ea:	e8 93 fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 32 ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
  800439:	8b 50 74             	mov    0x74(%eax),%edx
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	77 cb                	ja     80040e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800449:	74 14                	je     80045f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	68 2c 36 80 00       	push   $0x80362c
  800453:	6a 44                	push   $0x44
  800455:	68 cc 35 80 00       	push   $0x8035cc
  80045a:	e8 23 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 48 01             	lea    0x1(%eax),%ecx
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	89 0a                	mov    %ecx,(%edx)
  800475:	8b 55 08             	mov    0x8(%ebp),%edx
  800478:	88 d1                	mov    %dl,%cl
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048b:	75 2c                	jne    8004b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048d:	a0 24 40 80 00       	mov    0x804024,%al
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	8b 55 0c             	mov    0xc(%ebp),%edx
  800498:	8b 12                	mov    (%edx),%edx
  80049a:	89 d1                	mov    %edx,%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	83 c2 08             	add    $0x8,%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	51                   	push   %ecx
  8004a7:	52                   	push   %edx
  8004a8:	e8 7c 13 00 00       	call   801829 <sys_cputs>
  8004ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	8b 40 04             	mov    0x4(%eax),%eax
  8004bf:	8d 50 01             	lea    0x1(%eax),%edx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	50                   	push   %eax
  8004f5:	68 62 04 80 00       	push   $0x800462
  8004fa:	e8 11 02 00 00       	call   800710 <vprintfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800502:	a0 24 40 80 00       	mov    0x804024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 05 13 00 00       	call   801829 <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cprintf>:

int cprintf(const char *fmt, ...) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800543:	8d 45 0c             	lea    0xc(%ebp),%eax
  800546:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 f4             	pushl  -0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	e8 73 ff ff ff       	call   8004cb <vcprintf>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800569:	e8 69 14 00 00       	call   8019d7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 48 ff ff ff       	call   8004cb <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800589:	e8 63 14 00 00       	call   8019f1 <sys_enable_interrupt>
	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	53                   	push   %ebx
  800597:	83 ec 14             	sub    $0x14,%esp
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	77 55                	ja     800608 <printnum+0x75>
  8005b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b6:	72 05                	jb     8005bd <printnum+0x2a>
  8005b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bb:	77 4b                	ja     800608 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d3:	e8 80 2a 00 00       	call   803058 <__udivdi3>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	ff 75 20             	pushl  0x20(%ebp)
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 18             	pushl  0x18(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 a1 ff ff ff       	call   800593 <printnum>
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	eb 1a                	jmp    800611 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	ff 4d 1c             	decl   0x1c(%ebp)
  80060b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060f:	7f e6                	jg     8005f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800614:	bb 00 00 00 00       	mov    $0x0,%ebx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	53                   	push   %ebx
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	e8 40 2b 00 00       	call   803168 <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 94 38 80 00       	add    $0x803894,%eax
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
}
  800644:	90                   	nop
  800645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800651:	7e 1c                	jle    80066f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 08             	sub    $0x8,%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	eb 40                	jmp    8006af <getuint+0x65>
	else if (lflag)
  80066f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800673:	74 1e                	je     800693 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	eb 1c                	jmp    8006af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 04             	sub    $0x4,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getint+0x25>
		return va_arg(*ap, long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 38                	jmp    80070e <getint+0x5d>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1a                	je     8006f6 <getint+0x45>
		return va_arg(*ap, long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
  8006f4:	eb 18                	jmp    80070e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	56                   	push   %esi
  800714:	53                   	push   %ebx
  800715:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800718:	eb 17                	jmp    800731 <vprintfmt+0x21>
			if (ch == '\0')
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	0f 84 af 03 00 00    	je     800ad1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	53                   	push   %ebx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	89 55 10             	mov    %edx,0x10(%ebp)
  80073a:	8a 00                	mov    (%eax),%al
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d6                	jne    80071a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800756:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 2b 03 00 00    	ja     800aa9 <vprintfmt+0x399>
  80077e:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  800785:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800787:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078b:	eb d7                	jmp    800764 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800791:	eb d1                	jmp    800764 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	89 d0                	mov    %edx,%eax
  80079f:	c1 e0 02             	shl    $0x2,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d8                	add    %ebx,%eax
  8007a8:	83 e8 30             	sub    $0x30,%eax
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b9:	7e 3e                	jle    8007f9 <vprintfmt+0xe9>
  8007bb:	83 fb 39             	cmp    $0x39,%ebx
  8007be:	7f 39                	jg     8007f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c3:	eb d5                	jmp    80079a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d9:	eb 1f                	jmp    8007fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	79 83                	jns    800764 <vprintfmt+0x54>
				width = 0;
  8007e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e8:	e9 77 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f4:	e9 6b ff ff ff       	jmp    800764 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	0f 89 60 ff ff ff    	jns    800764 <vprintfmt+0x54>
				width = precision, precision = -1;
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800811:	e9 4e ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800816:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800819:	e9 46 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 c0 04             	add    $0x4,%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	e9 89 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800854:	85 db                	test   %ebx,%ebx
  800856:	79 02                	jns    80085a <vprintfmt+0x14a>
				err = -err;
  800858:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085a:	83 fb 64             	cmp    $0x64,%ebx
  80085d:	7f 0b                	jg     80086a <vprintfmt+0x15a>
  80085f:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 a5 38 80 00       	push   $0x8038a5
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 5e 02 00 00       	call   800ad9 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 49 02 00 00       	jmp    800acc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	56                   	push   %esi
  800884:	68 ae 38 80 00       	push   $0x8038ae
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 45 02 00 00       	call   800ad9 <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 30 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 30                	mov    (%eax),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 05                	jne    8008b6 <vprintfmt+0x1a6>
				p = "(null)";
  8008b1:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7e 6d                	jle    800929 <vprintfmt+0x219>
  8008bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c0:	74 67                	je     800929 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	50                   	push   %eax
  8008c9:	56                   	push   %esi
  8008ca:	e8 0c 03 00 00       	call   800bdb <strnlen>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e4                	jg     8008d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f3:	eb 34                	jmp    800929 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f9:	74 1c                	je     800917 <vprintfmt+0x207>
  8008fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fe:	7e 05                	jle    800905 <vprintfmt+0x1f5>
  800900:	83 fb 7e             	cmp    $0x7e,%ebx
  800903:	7e 12                	jle    800917 <vprintfmt+0x207>
					putch('?', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 3f                	push   $0x3f
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb 0f                	jmp    800926 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	89 f0                	mov    %esi,%eax
  80092b:	8d 70 01             	lea    0x1(%eax),%esi
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 24                	je     80095b <vprintfmt+0x24b>
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	78 b8                	js     8008f5 <vprintfmt+0x1e5>
  80093d:	ff 4d e0             	decl   -0x20(%ebp)
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	79 af                	jns    8008f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	eb 13                	jmp    80095b <vprintfmt+0x24b>
				putch(' ', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 20                	push   $0x20
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7f e7                	jg     800948 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800961:	e9 66 01 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 e8             	pushl  -0x18(%ebp)
  80096c:	8d 45 14             	lea    0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 3c fd ff ff       	call   8006b1 <getint>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	79 23                	jns    8009ab <vprintfmt+0x29b>
				putch('-', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 2d                	push   $0x2d
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 bc 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 84 fc ff ff       	call   80064a <getuint>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 98 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 58                	push   $0x58
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 58                	push   $0x58
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 58                	push   $0x58
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			break;
  800a0b:	e9 bc 00 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 30                	push   $0x30
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 78                	push   $0x78
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 e7 fb ff ff       	call   80064a <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	52                   	push   %edx
  800a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a81:	50                   	push   %eax
  800a82:	ff 75 f4             	pushl  -0xc(%ebp)
  800a85:	ff 75 f0             	pushl  -0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 00 fb ff ff       	call   800593 <printnum>
  800a93:	83 c4 20             	add    $0x20,%esp
			break;
  800a96:	eb 34                	jmp    800acc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3b1>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 47 fc ff ff       	jmp    800718 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 16 fc ff ff       	call   800710 <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 92 fb ff ff       	call   800710 <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d2:	f7 e9                	imul   %ecx
  8010d4:	c1 fa 02             	sar    $0x2,%edx
  8010d7:	89 c8                	mov    %ecx,%eax
  8010d9:	c1 f8 1f             	sar    $0x1f,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e0 02             	shl    $0x2,%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	01 c0                	add    %eax,%eax
  8010e7:	29 c1                	sub    %eax,%ecx
  8010e9:	89 ca                	mov    %ecx,%edx
  8010eb:	85 d2                	test   %edx,%edx
  8010ed:	75 9c                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xe2>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 54 fa ff ff       	call   800bb8 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 46 fa ff ff       	call   800bb8 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 13 fb ff ff       	call   800d4a <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 b5 fa ff ff       	call   800d4a <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 10 3a 80 00       	push   $0x803a10
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012eb:	00 00 00 
	}
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8012f7:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fe:	00 00 00 
  801301:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801308:	00 00 00 
  80130b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801312:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801315:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80131c:	00 00 00 
  80131f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801326:	00 00 00 
  801329:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801330:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801333:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80133a:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80133d:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801344:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80134b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801353:	2d 00 10 00 00       	sub    $0x1000,%eax
  801358:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80135d:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801367:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801371:	83 ec 04             	sub    $0x4,%esp
  801374:	6a 06                	push   $0x6
  801376:	ff 75 f4             	pushl  -0xc(%ebp)
  801379:	50                   	push   %eax
  80137a:	e8 ee 05 00 00       	call   80196d <sys_allocate_chunk>
  80137f:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801382:	a1 20 41 80 00       	mov    0x804120,%eax
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	50                   	push   %eax
  80138b:	e8 63 0c 00 00       	call   801ff3 <initialize_MemBlocksList>
  801390:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801393:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801398:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  80139b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8013a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8013ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b6:	89 c2                	mov    %eax,%edx
  8013b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013bb:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8013be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8013c8:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013d2:	8b 50 08             	mov    0x8(%eax),%edx
  8013d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	48                   	dec    %eax
  8013db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e6:	f7 75 e0             	divl   -0x20(%ebp)
  8013e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ec:	29 d0                	sub    %edx,%eax
  8013ee:	89 c2                	mov    %eax,%edx
  8013f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f3:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8013f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8013fa:	75 14                	jne    801410 <initialize_dyn_block_system+0x11f>
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	68 35 3a 80 00       	push   $0x803a35
  801404:	6a 34                	push   $0x34
  801406:	68 53 3a 80 00       	push   $0x803a53
  80140b:	e8 72 ee ff ff       	call   800282 <_panic>
  801410:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	85 c0                	test   %eax,%eax
  801417:	74 10                	je     801429 <initialize_dyn_block_system+0x138>
  801419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80141c:	8b 00                	mov    (%eax),%eax
  80141e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801421:	8b 52 04             	mov    0x4(%edx),%edx
  801424:	89 50 04             	mov    %edx,0x4(%eax)
  801427:	eb 0b                	jmp    801434 <initialize_dyn_block_system+0x143>
  801429:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80142c:	8b 40 04             	mov    0x4(%eax),%eax
  80142f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801437:	8b 40 04             	mov    0x4(%eax),%eax
  80143a:	85 c0                	test   %eax,%eax
  80143c:	74 0f                	je     80144d <initialize_dyn_block_system+0x15c>
  80143e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801441:	8b 40 04             	mov    0x4(%eax),%eax
  801444:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801447:	8b 12                	mov    (%edx),%edx
  801449:	89 10                	mov    %edx,(%eax)
  80144b:	eb 0a                	jmp    801457 <initialize_dyn_block_system+0x166>
  80144d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	a3 48 41 80 00       	mov    %eax,0x804148
  801457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801463:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80146a:	a1 54 41 80 00       	mov    0x804154,%eax
  80146f:	48                   	dec    %eax
  801470:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801475:	83 ec 0c             	sub    $0xc,%esp
  801478:	ff 75 e8             	pushl  -0x18(%ebp)
  80147b:	e8 c4 13 00 00       	call   802844 <insert_sorted_with_merge_freeList>
  801480:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801483:	90                   	nop
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80148c:	e8 2f fe ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801491:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801495:	75 07                	jne    80149e <malloc+0x18>
  801497:	b8 00 00 00 00       	mov    $0x0,%eax
  80149c:	eb 71                	jmp    80150f <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80149e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8014a5:	76 07                	jbe    8014ae <malloc+0x28>
	return NULL;
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	eb 61                	jmp    80150f <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014ae:	e8 88 08 00 00       	call   801d3b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	74 53                	je     80150a <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014b7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014be:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	48                   	dec    %eax
  8014c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d2:	f7 75 f4             	divl   -0xc(%ebp)
  8014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d8:	29 d0                	sub    %edx,%eax
  8014da:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8014dd:	83 ec 0c             	sub    $0xc,%esp
  8014e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e3:	e8 d2 0d 00 00       	call   8022ba <alloc_block_FF>
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8014ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014f2:	74 16                	je     80150a <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8014fa:	e8 0c 0c 00 00       	call   80210b <insert_sorted_allocList>
  8014ff:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801502:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801505:	8b 40 08             	mov    0x8(%eax),%eax
  801508:	eb 05                	jmp    80150f <malloc+0x89>
    }

			}


	return NULL;
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801520:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801525:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	68 40 40 80 00       	push   $0x804040
  801533:	e8 a0 0b 00 00       	call   8020d8 <find_block>
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80153e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801541:	8b 50 0c             	mov    0xc(%eax),%edx
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	52                   	push   %edx
  80154b:	50                   	push   %eax
  80154c:	e8 e4 03 00 00       	call   801935 <sys_free_user_mem>
  801551:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801554:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801558:	75 17                	jne    801571 <free+0x60>
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	68 35 3a 80 00       	push   $0x803a35
  801562:	68 84 00 00 00       	push   $0x84
  801567:	68 53 3a 80 00       	push   $0x803a53
  80156c:	e8 11 ed ff ff       	call   800282 <_panic>
  801571:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801574:	8b 00                	mov    (%eax),%eax
  801576:	85 c0                	test   %eax,%eax
  801578:	74 10                	je     80158a <free+0x79>
  80157a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157d:	8b 00                	mov    (%eax),%eax
  80157f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801582:	8b 52 04             	mov    0x4(%edx),%edx
  801585:	89 50 04             	mov    %edx,0x4(%eax)
  801588:	eb 0b                	jmp    801595 <free+0x84>
  80158a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158d:	8b 40 04             	mov    0x4(%eax),%eax
  801590:	a3 44 40 80 00       	mov    %eax,0x804044
  801595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801598:	8b 40 04             	mov    0x4(%eax),%eax
  80159b:	85 c0                	test   %eax,%eax
  80159d:	74 0f                	je     8015ae <free+0x9d>
  80159f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a2:	8b 40 04             	mov    0x4(%eax),%eax
  8015a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015a8:	8b 12                	mov    (%edx),%edx
  8015aa:	89 10                	mov    %edx,(%eax)
  8015ac:	eb 0a                	jmp    8015b8 <free+0xa7>
  8015ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b1:	8b 00                	mov    (%eax),%eax
  8015b3:	a3 40 40 80 00       	mov    %eax,0x804040
  8015b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015d0:	48                   	dec    %eax
  8015d1:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8015d6:	83 ec 0c             	sub    $0xc,%esp
  8015d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8015dc:	e8 63 12 00 00       	call   802844 <insert_sorted_with_merge_freeList>
  8015e1:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8015e4:	90                   	nop
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 38             	sub    $0x38,%esp
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f3:	e8 c8 fc ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fc:	75 0a                	jne    801608 <smalloc+0x21>
  8015fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801603:	e9 a0 00 00 00       	jmp    8016a8 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801608:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80160f:	76 0a                	jbe    80161b <smalloc+0x34>
		return NULL;
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
  801616:	e9 8d 00 00 00       	jmp    8016a8 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80161b:	e8 1b 07 00 00       	call   801d3b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801620:	85 c0                	test   %eax,%eax
  801622:	74 7f                	je     8016a3 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801624:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80162b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	48                   	dec    %eax
  801634:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	f7 75 f4             	divl   -0xc(%ebp)
  801642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801645:	29 d0                	sub    %edx,%eax
  801647:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80164a:	83 ec 0c             	sub    $0xc,%esp
  80164d:	ff 75 ec             	pushl  -0x14(%ebp)
  801650:	e8 65 0c 00 00       	call   8022ba <alloc_block_FF>
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80165b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80165f:	74 42                	je     8016a3 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 e8             	pushl  -0x18(%ebp)
  801667:	e8 9f 0a 00 00       	call   80210b <insert_sorted_allocList>
  80166c:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80166f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801672:	8b 40 08             	mov    0x8(%eax),%eax
  801675:	89 c2                	mov    %eax,%edx
  801677:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80167b:	52                   	push   %edx
  80167c:	50                   	push   %eax
  80167d:	ff 75 0c             	pushl  0xc(%ebp)
  801680:	ff 75 08             	pushl  0x8(%ebp)
  801683:	e8 38 04 00 00       	call   801ac0 <sys_createSharedObject>
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  80168e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801692:	79 07                	jns    80169b <smalloc+0xb4>
	    		  return NULL;
  801694:	b8 00 00 00 00       	mov    $0x0,%eax
  801699:	eb 0d                	jmp    8016a8 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80169b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80169e:	8b 40 08             	mov    0x8(%eax),%eax
  8016a1:	eb 05                	jmp    8016a8 <smalloc+0xc1>


				}


		return NULL;
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b0:	e8 0b fc ff ff       	call   8012c0 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016b5:	e8 81 06 00 00       	call   801d3b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	0f 84 9f 00 00 00    	je     801761 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016c2:	83 ec 08             	sub    $0x8,%esp
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	ff 75 08             	pushl  0x8(%ebp)
  8016cb:	e8 1a 04 00 00       	call   801aea <sys_getSizeOfSharedObject>
  8016d0:	83 c4 10             	add    $0x10,%esp
  8016d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8016d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016da:	79 0a                	jns    8016e6 <sget+0x3c>
		return NULL;
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e1:	e9 80 00 00 00       	jmp    801766 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016e6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	01 d0                	add    %edx,%eax
  8016f5:	48                   	dec    %eax
  8016f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801701:	f7 75 f0             	divl   -0x10(%ebp)
  801704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801707:	29 d0                	sub    %edx,%eax
  801709:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80170c:	83 ec 0c             	sub    $0xc,%esp
  80170f:	ff 75 e8             	pushl  -0x18(%ebp)
  801712:	e8 a3 0b 00 00       	call   8022ba <alloc_block_FF>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80171d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801721:	74 3e                	je     801761 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801723:	83 ec 0c             	sub    $0xc,%esp
  801726:	ff 75 e4             	pushl  -0x1c(%ebp)
  801729:	e8 dd 09 00 00       	call   80210b <insert_sorted_allocList>
  80172e:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801734:	8b 40 08             	mov    0x8(%eax),%eax
  801737:	83 ec 04             	sub    $0x4,%esp
  80173a:	50                   	push   %eax
  80173b:	ff 75 0c             	pushl  0xc(%ebp)
  80173e:	ff 75 08             	pushl  0x8(%ebp)
  801741:	e8 c1 03 00 00       	call   801b07 <sys_getSharedObject>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80174c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801750:	79 07                	jns    801759 <sget+0xaf>
	    		  return NULL;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	eb 0d                	jmp    801766 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80175c:	8b 40 08             	mov    0x8(%eax),%eax
  80175f:	eb 05                	jmp    801766 <sget+0xbc>
	      }
	}
	   return NULL;
  801761:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176e:	e8 4d fb ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	68 60 3a 80 00       	push   $0x803a60
  80177b:	68 12 01 00 00       	push   $0x112
  801780:	68 53 3a 80 00       	push   $0x803a53
  801785:	e8 f8 ea ff ff       	call   800282 <_panic>

0080178a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801790:	83 ec 04             	sub    $0x4,%esp
  801793:	68 88 3a 80 00       	push   $0x803a88
  801798:	68 26 01 00 00       	push   $0x126
  80179d:	68 53 3a 80 00       	push   $0x803a53
  8017a2:	e8 db ea ff ff       	call   800282 <_panic>

008017a7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	68 ac 3a 80 00       	push   $0x803aac
  8017b5:	68 31 01 00 00       	push   $0x131
  8017ba:	68 53 3a 80 00       	push   $0x803a53
  8017bf:	e8 be ea ff ff       	call   800282 <_panic>

008017c4 <shrink>:

}
void shrink(uint32 newSize)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ca:	83 ec 04             	sub    $0x4,%esp
  8017cd:	68 ac 3a 80 00       	push   $0x803aac
  8017d2:	68 36 01 00 00       	push   $0x136
  8017d7:	68 53 3a 80 00       	push   $0x803a53
  8017dc:	e8 a1 ea ff ff       	call   800282 <_panic>

008017e1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e7:	83 ec 04             	sub    $0x4,%esp
  8017ea:	68 ac 3a 80 00       	push   $0x803aac
  8017ef:	68 3b 01 00 00       	push   $0x13b
  8017f4:	68 53 3a 80 00       	push   $0x803a53
  8017f9:	e8 84 ea ff ff       	call   800282 <_panic>

008017fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	57                   	push   %edi
  801802:	56                   	push   %esi
  801803:	53                   	push   %ebx
  801804:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801810:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801813:	8b 7d 18             	mov    0x18(%ebp),%edi
  801816:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801819:	cd 30                	int    $0x30
  80181b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	5b                   	pop    %ebx
  801825:	5e                   	pop    %esi
  801826:	5f                   	pop    %edi
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    

00801829 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	8b 45 10             	mov    0x10(%ebp),%eax
  801832:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801835:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	52                   	push   %edx
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	50                   	push   %eax
  801845:	6a 00                	push   $0x0
  801847:	e8 b2 ff ff ff       	call   8017fe <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	90                   	nop
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_cgetc>:

int
sys_cgetc(void)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 01                	push   $0x1
  801861:	e8 98 ff ff ff       	call   8017fe <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80186e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	52                   	push   %edx
  80187b:	50                   	push   %eax
  80187c:	6a 05                	push   $0x5
  80187e:	e8 7b ff ff ff       	call   8017fe <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	56                   	push   %esi
  80188c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80188d:	8b 75 18             	mov    0x18(%ebp),%esi
  801890:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801893:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	56                   	push   %esi
  80189d:	53                   	push   %ebx
  80189e:	51                   	push   %ecx
  80189f:	52                   	push   %edx
  8018a0:	50                   	push   %eax
  8018a1:	6a 06                	push   $0x6
  8018a3:	e8 56 ff ff ff       	call   8017fe <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ae:	5b                   	pop    %ebx
  8018af:	5e                   	pop    %esi
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    

008018b2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	52                   	push   %edx
  8018c2:	50                   	push   %eax
  8018c3:	6a 07                	push   $0x7
  8018c5:	e8 34 ff ff ff       	call   8017fe <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	ff 75 08             	pushl  0x8(%ebp)
  8018de:	6a 08                	push   $0x8
  8018e0:	e8 19 ff ff ff       	call   8017fe <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 09                	push   $0x9
  8018f9:	e8 00 ff ff ff       	call   8017fe <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 0a                	push   $0xa
  801912:	e8 e7 fe ff ff       	call   8017fe <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 0b                	push   $0xb
  80192b:	e8 ce fe ff ff       	call   8017fe <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	ff 75 08             	pushl  0x8(%ebp)
  801944:	6a 0f                	push   $0xf
  801946:	e8 b3 fe ff ff       	call   8017fe <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
	return;
  80194e:	90                   	nop
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	6a 10                	push   $0x10
  801962:	e8 97 fe ff ff       	call   8017fe <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
	return ;
  80196a:	90                   	nop
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	ff 75 10             	pushl  0x10(%ebp)
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	ff 75 08             	pushl  0x8(%ebp)
  80197d:	6a 11                	push   $0x11
  80197f:	e8 7a fe ff ff       	call   8017fe <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
	return ;
  801987:	90                   	nop
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 0c                	push   $0xc
  801999:	e8 60 fe ff ff       	call   8017fe <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	6a 0d                	push   $0xd
  8019b3:	e8 46 fe ff ff       	call   8017fe <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 0e                	push   $0xe
  8019cc:	e8 2d fe ff ff       	call   8017fe <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	90                   	nop
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 13                	push   $0x13
  8019e6:	e8 13 fe ff ff       	call   8017fe <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 14                	push   $0x14
  801a00:	e8 f9 fd ff ff       	call   8017fe <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_cputc>:


void
sys_cputc(const char c)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 04             	sub    $0x4,%esp
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a17:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	50                   	push   %eax
  801a24:	6a 15                	push   $0x15
  801a26:	e8 d3 fd ff ff       	call   8017fe <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 16                	push   $0x16
  801a40:	e8 b9 fd ff ff       	call   8017fe <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	50                   	push   %eax
  801a5b:	6a 17                	push   $0x17
  801a5d:	e8 9c fd ff ff       	call   8017fe <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	52                   	push   %edx
  801a77:	50                   	push   %eax
  801a78:	6a 1a                	push   $0x1a
  801a7a:	e8 7f fd ff ff       	call   8017fe <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	52                   	push   %edx
  801a94:	50                   	push   %eax
  801a95:	6a 18                	push   $0x18
  801a97:	e8 62 fd ff ff       	call   8017fe <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	90                   	nop
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	52                   	push   %edx
  801ab2:	50                   	push   %eax
  801ab3:	6a 19                	push   $0x19
  801ab5:	e8 44 fd ff ff       	call   8017fe <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	90                   	nop
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801acc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801acf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	6a 00                	push   $0x0
  801ad8:	51                   	push   %ecx
  801ad9:	52                   	push   %edx
  801ada:	ff 75 0c             	pushl  0xc(%ebp)
  801add:	50                   	push   %eax
  801ade:	6a 1b                	push   $0x1b
  801ae0:	e8 19 fd ff ff       	call   8017fe <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	6a 1c                	push   $0x1c
  801afd:	e8 fc fc ff ff       	call   8017fe <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	51                   	push   %ecx
  801b18:	52                   	push   %edx
  801b19:	50                   	push   %eax
  801b1a:	6a 1d                	push   $0x1d
  801b1c:	e8 dd fc ff ff       	call   8017fe <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 1e                	push   $0x1e
  801b39:	e8 c0 fc ff ff       	call   8017fe <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 1f                	push   $0x1f
  801b52:	e8 a7 fc ff ff       	call   8017fe <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	ff 75 14             	pushl  0x14(%ebp)
  801b67:	ff 75 10             	pushl  0x10(%ebp)
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	50                   	push   %eax
  801b6e:	6a 20                	push   $0x20
  801b70:	e8 89 fc ff ff       	call   8017fe <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	50                   	push   %eax
  801b89:	6a 21                	push   $0x21
  801b8b:	e8 6e fc ff ff       	call   8017fe <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	90                   	nop
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	50                   	push   %eax
  801ba5:	6a 22                	push   $0x22
  801ba7:	e8 52 fc ff ff       	call   8017fe <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 02                	push   $0x2
  801bc0:	e8 39 fc ff ff       	call   8017fe <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 03                	push   $0x3
  801bd9:	e8 20 fc ff ff       	call   8017fe <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 04                	push   $0x4
  801bf2:	e8 07 fc ff ff       	call   8017fe <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_exit_env>:


void sys_exit_env(void)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 23                	push   $0x23
  801c0b:	e8 ee fb ff ff       	call   8017fe <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1f:	8d 50 04             	lea    0x4(%eax),%edx
  801c22:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	52                   	push   %edx
  801c2c:	50                   	push   %eax
  801c2d:	6a 24                	push   $0x24
  801c2f:	e8 ca fb ff ff       	call   8017fe <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
	return result;
  801c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c40:	89 01                	mov    %eax,(%ecx)
  801c42:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	c9                   	leave  
  801c49:	c2 04 00             	ret    $0x4

00801c4c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	ff 75 10             	pushl  0x10(%ebp)
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	ff 75 08             	pushl  0x8(%ebp)
  801c5c:	6a 12                	push   $0x12
  801c5e:	e8 9b fb ff ff       	call   8017fe <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
	return ;
  801c66:	90                   	nop
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 25                	push   $0x25
  801c78:	e8 81 fb ff ff       	call   8017fe <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c8e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	50                   	push   %eax
  801c9b:	6a 26                	push   $0x26
  801c9d:	e8 5c fb ff ff       	call   8017fe <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca5:	90                   	nop
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <rsttst>:
void rsttst()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 28                	push   $0x28
  801cb7:	e8 42 fb ff ff       	call   8017fe <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbf:	90                   	nop
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cce:	8b 55 18             	mov    0x18(%ebp),%edx
  801cd1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd5:	52                   	push   %edx
  801cd6:	50                   	push   %eax
  801cd7:	ff 75 10             	pushl  0x10(%ebp)
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	ff 75 08             	pushl  0x8(%ebp)
  801ce0:	6a 27                	push   $0x27
  801ce2:	e8 17 fb ff ff       	call   8017fe <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cea:	90                   	nop
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <chktst>:
void chktst(uint32 n)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	ff 75 08             	pushl  0x8(%ebp)
  801cfb:	6a 29                	push   $0x29
  801cfd:	e8 fc fa ff ff       	call   8017fe <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return ;
  801d05:	90                   	nop
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <inctst>:

void inctst()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 2a                	push   $0x2a
  801d17:	e8 e2 fa ff ff       	call   8017fe <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1f:	90                   	nop
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <gettst>:
uint32 gettst()
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 2b                	push   $0x2b
  801d31:	e8 c8 fa ff ff       	call   8017fe <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 2c                	push   $0x2c
  801d4d:	e8 ac fa ff ff       	call   8017fe <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
  801d55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d58:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d5c:	75 07                	jne    801d65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	eb 05                	jmp    801d6a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 2c                	push   $0x2c
  801d7e:	e8 7b fa ff ff       	call   8017fe <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
  801d86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d89:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d8d:	75 07                	jne    801d96 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d94:	eb 05                	jmp    801d9b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 2c                	push   $0x2c
  801daf:	e8 4a fa ff ff       	call   8017fe <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dba:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dbe:	75 07                	jne    801dc7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dc0:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc5:	eb 05                	jmp    801dcc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 2c                	push   $0x2c
  801de0:	e8 19 fa ff ff       	call   8017fe <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
  801de8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801deb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801def:	75 07                	jne    801df8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801df1:	b8 01 00 00 00       	mov    $0x1,%eax
  801df6:	eb 05                	jmp    801dfd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	ff 75 08             	pushl  0x8(%ebp)
  801e0d:	6a 2d                	push   $0x2d
  801e0f:	e8 ea f9 ff ff       	call   8017fe <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
	return ;
  801e17:	90                   	nop
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e1e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	6a 00                	push   $0x0
  801e2c:	53                   	push   %ebx
  801e2d:	51                   	push   %ecx
  801e2e:	52                   	push   %edx
  801e2f:	50                   	push   %eax
  801e30:	6a 2e                	push   $0x2e
  801e32:	e8 c7 f9 ff ff       	call   8017fe <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	52                   	push   %edx
  801e4f:	50                   	push   %eax
  801e50:	6a 2f                	push   $0x2f
  801e52:	e8 a7 f9 ff ff       	call   8017fe <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	68 bc 3a 80 00       	push   $0x803abc
  801e6a:	e8 c7 e6 ff ff       	call   800536 <cprintf>
  801e6f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	68 e8 3a 80 00       	push   $0x803ae8
  801e81:	e8 b0 e6 ff ff       	call   800536 <cprintf>
  801e86:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e89:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e8d:	a1 38 41 80 00       	mov    0x804138,%eax
  801e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e95:	eb 56                	jmp    801eed <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e9b:	74 1c                	je     801eb9 <print_mem_block_lists+0x5d>
  801e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea0:	8b 50 08             	mov    0x8(%eax),%edx
  801ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	01 c8                	add    %ecx,%eax
  801eb1:	39 c2                	cmp    %eax,%edx
  801eb3:	73 04                	jae    801eb9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eb5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	8b 50 08             	mov    0x8(%eax),%edx
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec5:	01 c2                	add    %eax,%edx
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	8b 40 08             	mov    0x8(%eax),%eax
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	68 fd 3a 80 00       	push   $0x803afd
  801ed7:	e8 5a e6 ff ff       	call   800536 <cprintf>
  801edc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee5:	a1 40 41 80 00       	mov    0x804140,%eax
  801eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef1:	74 07                	je     801efa <print_mem_block_lists+0x9e>
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 00                	mov    (%eax),%eax
  801ef8:	eb 05                	jmp    801eff <print_mem_block_lists+0xa3>
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	a3 40 41 80 00       	mov    %eax,0x804140
  801f04:	a1 40 41 80 00       	mov    0x804140,%eax
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	75 8a                	jne    801e97 <print_mem_block_lists+0x3b>
  801f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f11:	75 84                	jne    801e97 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f13:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f17:	75 10                	jne    801f29 <print_mem_block_lists+0xcd>
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	68 0c 3b 80 00       	push   $0x803b0c
  801f21:	e8 10 e6 ff ff       	call   800536 <cprintf>
  801f26:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	68 30 3b 80 00       	push   $0x803b30
  801f38:	e8 f9 e5 ff ff       	call   800536 <cprintf>
  801f3d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f40:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f44:	a1 40 40 80 00       	mov    0x804040,%eax
  801f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4c:	eb 56                	jmp    801fa4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f52:	74 1c                	je     801f70 <print_mem_block_lists+0x114>
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 50 08             	mov    0x8(%eax),%edx
  801f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5d:	8b 48 08             	mov    0x8(%eax),%ecx
  801f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f63:	8b 40 0c             	mov    0xc(%eax),%eax
  801f66:	01 c8                	add    %ecx,%eax
  801f68:	39 c2                	cmp    %eax,%edx
  801f6a:	73 04                	jae    801f70 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f6c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	8b 50 08             	mov    0x8(%eax),%edx
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7c:	01 c2                	add    %eax,%edx
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	8b 40 08             	mov    0x8(%eax),%eax
  801f84:	83 ec 04             	sub    $0x4,%esp
  801f87:	52                   	push   %edx
  801f88:	50                   	push   %eax
  801f89:	68 fd 3a 80 00       	push   $0x803afd
  801f8e:	e8 a3 e5 ff ff       	call   800536 <cprintf>
  801f93:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f9c:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa8:	74 07                	je     801fb1 <print_mem_block_lists+0x155>
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 00                	mov    (%eax),%eax
  801faf:	eb 05                	jmp    801fb6 <print_mem_block_lists+0x15a>
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	a3 48 40 80 00       	mov    %eax,0x804048
  801fbb:	a1 48 40 80 00       	mov    0x804048,%eax
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	75 8a                	jne    801f4e <print_mem_block_lists+0xf2>
  801fc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc8:	75 84                	jne    801f4e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fca:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fce:	75 10                	jne    801fe0 <print_mem_block_lists+0x184>
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	68 48 3b 80 00       	push   $0x803b48
  801fd8:	e8 59 e5 ff ff       	call   800536 <cprintf>
  801fdd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	68 bc 3a 80 00       	push   $0x803abc
  801fe8:	e8 49 e5 ff ff       	call   800536 <cprintf>
  801fed:	83 c4 10             	add    $0x10,%esp

}
  801ff0:	90                   	nop
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801ff9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802000:	00 00 00 
  802003:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80200a:	00 00 00 
  80200d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802014:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802017:	a1 50 40 80 00       	mov    0x804050,%eax
  80201c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80201f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802026:	e9 9e 00 00 00       	jmp    8020c9 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80202b:	a1 50 40 80 00       	mov    0x804050,%eax
  802030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802033:	c1 e2 04             	shl    $0x4,%edx
  802036:	01 d0                	add    %edx,%eax
  802038:	85 c0                	test   %eax,%eax
  80203a:	75 14                	jne    802050 <initialize_MemBlocksList+0x5d>
  80203c:	83 ec 04             	sub    $0x4,%esp
  80203f:	68 70 3b 80 00       	push   $0x803b70
  802044:	6a 48                	push   $0x48
  802046:	68 93 3b 80 00       	push   $0x803b93
  80204b:	e8 32 e2 ff ff       	call   800282 <_panic>
  802050:	a1 50 40 80 00       	mov    0x804050,%eax
  802055:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802058:	c1 e2 04             	shl    $0x4,%edx
  80205b:	01 d0                	add    %edx,%eax
  80205d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802063:	89 10                	mov    %edx,(%eax)
  802065:	8b 00                	mov    (%eax),%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	74 18                	je     802083 <initialize_MemBlocksList+0x90>
  80206b:	a1 48 41 80 00       	mov    0x804148,%eax
  802070:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802076:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802079:	c1 e1 04             	shl    $0x4,%ecx
  80207c:	01 ca                	add    %ecx,%edx
  80207e:	89 50 04             	mov    %edx,0x4(%eax)
  802081:	eb 12                	jmp    802095 <initialize_MemBlocksList+0xa2>
  802083:	a1 50 40 80 00       	mov    0x804050,%eax
  802088:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208b:	c1 e2 04             	shl    $0x4,%edx
  80208e:	01 d0                	add    %edx,%eax
  802090:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802095:	a1 50 40 80 00       	mov    0x804050,%eax
  80209a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209d:	c1 e2 04             	shl    $0x4,%edx
  8020a0:	01 d0                	add    %edx,%eax
  8020a2:	a3 48 41 80 00       	mov    %eax,0x804148
  8020a7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020af:	c1 e2 04             	shl    $0x4,%edx
  8020b2:	01 d0                	add    %edx,%eax
  8020b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020bb:	a1 54 41 80 00       	mov    0x804154,%eax
  8020c0:	40                   	inc    %eax
  8020c1:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8020c6:	ff 45 f4             	incl   -0xc(%ebp)
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020cf:	0f 82 56 ff ff ff    	jb     80202b <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8020d5:	90                   	nop
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	8b 00                	mov    (%eax),%eax
  8020e3:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8020e6:	eb 18                	jmp    802100 <find_block+0x28>
		{
			if(tmp->sva==va)
  8020e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020eb:	8b 40 08             	mov    0x8(%eax),%eax
  8020ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020f1:	75 05                	jne    8020f8 <find_block+0x20>
			{
				return tmp;
  8020f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f6:	eb 11                	jmp    802109 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8020f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fb:	8b 00                	mov    (%eax),%eax
  8020fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802100:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802104:	75 e2                	jne    8020e8 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802106:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802111:	a1 40 40 80 00       	mov    0x804040,%eax
  802116:	85 c0                	test   %eax,%eax
  802118:	0f 85 83 00 00 00    	jne    8021a1 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80211e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802125:	00 00 00 
  802128:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80212f:	00 00 00 
  802132:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802139:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80213c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802140:	75 14                	jne    802156 <insert_sorted_allocList+0x4b>
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	68 70 3b 80 00       	push   $0x803b70
  80214a:	6a 7f                	push   $0x7f
  80214c:	68 93 3b 80 00       	push   $0x803b93
  802151:	e8 2c e1 ff ff       	call   800282 <_panic>
  802156:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	89 10                	mov    %edx,(%eax)
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	8b 00                	mov    (%eax),%eax
  802166:	85 c0                	test   %eax,%eax
  802168:	74 0d                	je     802177 <insert_sorted_allocList+0x6c>
  80216a:	a1 40 40 80 00       	mov    0x804040,%eax
  80216f:	8b 55 08             	mov    0x8(%ebp),%edx
  802172:	89 50 04             	mov    %edx,0x4(%eax)
  802175:	eb 08                	jmp    80217f <insert_sorted_allocList+0x74>
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	a3 44 40 80 00       	mov    %eax,0x804044
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	a3 40 40 80 00       	mov    %eax,0x804040
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802191:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802196:	40                   	inc    %eax
  802197:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80219c:	e9 16 01 00 00       	jmp    8022b7 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	8b 50 08             	mov    0x8(%eax),%edx
  8021a7:	a1 44 40 80 00       	mov    0x804044,%eax
  8021ac:	8b 40 08             	mov    0x8(%eax),%eax
  8021af:	39 c2                	cmp    %eax,%edx
  8021b1:	76 68                	jbe    80221b <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b7:	75 17                	jne    8021d0 <insert_sorted_allocList+0xc5>
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	68 ac 3b 80 00       	push   $0x803bac
  8021c1:	68 85 00 00 00       	push   $0x85
  8021c6:	68 93 3b 80 00       	push   $0x803b93
  8021cb:	e8 b2 e0 ff ff       	call   800282 <_panic>
  8021d0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	89 50 04             	mov    %edx,0x4(%eax)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 40 04             	mov    0x4(%eax),%eax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	74 0c                	je     8021f2 <insert_sorted_allocList+0xe7>
  8021e6:	a1 44 40 80 00       	mov    0x804044,%eax
  8021eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ee:	89 10                	mov    %edx,(%eax)
  8021f0:	eb 08                	jmp    8021fa <insert_sorted_allocList+0xef>
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	a3 40 40 80 00       	mov    %eax,0x804040
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	a3 44 40 80 00       	mov    %eax,0x804044
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80220b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802210:	40                   	inc    %eax
  802211:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802216:	e9 9c 00 00 00       	jmp    8022b7 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80221b:	a1 40 40 80 00       	mov    0x804040,%eax
  802220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802223:	e9 85 00 00 00       	jmp    8022ad <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 50 08             	mov    0x8(%eax),%edx
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 40 08             	mov    0x8(%eax),%eax
  802234:	39 c2                	cmp    %eax,%edx
  802236:	73 6d                	jae    8022a5 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223c:	74 06                	je     802244 <insert_sorted_allocList+0x139>
  80223e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802242:	75 17                	jne    80225b <insert_sorted_allocList+0x150>
  802244:	83 ec 04             	sub    $0x4,%esp
  802247:	68 d0 3b 80 00       	push   $0x803bd0
  80224c:	68 90 00 00 00       	push   $0x90
  802251:	68 93 3b 80 00       	push   $0x803b93
  802256:	e8 27 e0 ff ff       	call   800282 <_panic>
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 50 04             	mov    0x4(%eax),%edx
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	89 50 04             	mov    %edx,0x4(%eax)
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226d:	89 10                	mov    %edx,(%eax)
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 04             	mov    0x4(%eax),%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	74 0d                	je     802286 <insert_sorted_allocList+0x17b>
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 40 04             	mov    0x4(%eax),%eax
  80227f:	8b 55 08             	mov    0x8(%ebp),%edx
  802282:	89 10                	mov    %edx,(%eax)
  802284:	eb 08                	jmp    80228e <insert_sorted_allocList+0x183>
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	a3 40 40 80 00       	mov    %eax,0x804040
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 55 08             	mov    0x8(%ebp),%edx
  802294:	89 50 04             	mov    %edx,0x4(%eax)
  802297:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80229c:	40                   	inc    %eax
  80229d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022a2:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022a3:	eb 12                	jmp    8022b7 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 00                	mov    (%eax),%eax
  8022aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b1:	0f 85 71 ff ff ff    	jne    802228 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022b7:	90                   	nop
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8022c0:	a1 38 41 80 00       	mov    0x804138,%eax
  8022c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8022c8:	e9 76 01 00 00       	jmp    802443 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d6:	0f 85 8a 00 00 00    	jne    802366 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8022dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e0:	75 17                	jne    8022f9 <alloc_block_FF+0x3f>
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 05 3c 80 00       	push   $0x803c05
  8022ea:	68 a8 00 00 00       	push   $0xa8
  8022ef:	68 93 3b 80 00       	push   $0x803b93
  8022f4:	e8 89 df ff ff       	call   800282 <_panic>
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	74 10                	je     802312 <alloc_block_FF+0x58>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230a:	8b 52 04             	mov    0x4(%edx),%edx
  80230d:	89 50 04             	mov    %edx,0x4(%eax)
  802310:	eb 0b                	jmp    80231d <alloc_block_FF+0x63>
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 40 04             	mov    0x4(%eax),%eax
  802318:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	74 0f                	je     802336 <alloc_block_FF+0x7c>
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 40 04             	mov    0x4(%eax),%eax
  80232d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802330:	8b 12                	mov    (%edx),%edx
  802332:	89 10                	mov    %edx,(%eax)
  802334:	eb 0a                	jmp    802340 <alloc_block_FF+0x86>
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	a3 38 41 80 00       	mov    %eax,0x804138
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802353:	a1 44 41 80 00       	mov    0x804144,%eax
  802358:	48                   	dec    %eax
  802359:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	e9 ea 00 00 00       	jmp    802450 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 40 0c             	mov    0xc(%eax),%eax
  80236c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80236f:	0f 86 c6 00 00 00    	jbe    80243b <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802375:	a1 48 41 80 00       	mov    0x804148,%eax
  80237a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  80237d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802380:	8b 55 08             	mov    0x8(%ebp),%edx
  802383:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 50 08             	mov    0x8(%eax),%edx
  80238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238f:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 40 0c             	mov    0xc(%eax),%eax
  802398:	2b 45 08             	sub    0x8(%ebp),%eax
  80239b:	89 c2                	mov    %eax,%edx
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	8b 50 08             	mov    0x8(%eax),%edx
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	01 c2                	add    %eax,%edx
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b8:	75 17                	jne    8023d1 <alloc_block_FF+0x117>
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	68 05 3c 80 00       	push   $0x803c05
  8023c2:	68 b6 00 00 00       	push   $0xb6
  8023c7:	68 93 3b 80 00       	push   $0x803b93
  8023cc:	e8 b1 de ff ff       	call   800282 <_panic>
  8023d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	74 10                	je     8023ea <alloc_block_FF+0x130>
  8023da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e2:	8b 52 04             	mov    0x4(%edx),%edx
  8023e5:	89 50 04             	mov    %edx,0x4(%eax)
  8023e8:	eb 0b                	jmp    8023f5 <alloc_block_FF+0x13b>
  8023ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ed:	8b 40 04             	mov    0x4(%eax),%eax
  8023f0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f8:	8b 40 04             	mov    0x4(%eax),%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 0f                	je     80240e <alloc_block_FF+0x154>
  8023ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802402:	8b 40 04             	mov    0x4(%eax),%eax
  802405:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802408:	8b 12                	mov    (%edx),%edx
  80240a:	89 10                	mov    %edx,(%eax)
  80240c:	eb 0a                	jmp    802418 <alloc_block_FF+0x15e>
  80240e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802411:	8b 00                	mov    (%eax),%eax
  802413:	a3 48 41 80 00       	mov    %eax,0x804148
  802418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802424:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80242b:	a1 54 41 80 00       	mov    0x804154,%eax
  802430:	48                   	dec    %eax
  802431:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	eb 15                	jmp    802450 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802443:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802447:	0f 85 80 fe ff ff    	jne    8022cd <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802458:	a1 38 41 80 00       	mov    0x804138,%eax
  80245d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802460:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802467:	e9 c0 00 00 00       	jmp    80252c <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	3b 45 08             	cmp    0x8(%ebp),%eax
  802475:	0f 85 8a 00 00 00    	jne    802505 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80247b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247f:	75 17                	jne    802498 <alloc_block_BF+0x46>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 05 3c 80 00       	push   $0x803c05
  802489:	68 cf 00 00 00       	push   $0xcf
  80248e:	68 93 3b 80 00       	push   $0x803b93
  802493:	e8 ea dd ff ff       	call   800282 <_panic>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 10                	je     8024b1 <alloc_block_BF+0x5f>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ac:	89 50 04             	mov    %edx,0x4(%eax)
  8024af:	eb 0b                	jmp    8024bc <alloc_block_BF+0x6a>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 0f                	je     8024d5 <alloc_block_BF+0x83>
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 04             	mov    0x4(%eax),%eax
  8024cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cf:	8b 12                	mov    (%edx),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
  8024d3:	eb 0a                	jmp    8024df <alloc_block_BF+0x8d>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	a3 38 41 80 00       	mov    %eax,0x804138
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f2:	a1 44 41 80 00       	mov    0x804144,%eax
  8024f7:	48                   	dec    %eax
  8024f8:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	e9 2a 01 00 00       	jmp    80262f <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 0c             	mov    0xc(%eax),%eax
  80250b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80250e:	73 14                	jae    802524 <alloc_block_BF+0xd2>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 40 0c             	mov    0xc(%eax),%eax
  802516:	3b 45 08             	cmp    0x8(%ebp),%eax
  802519:	76 09                	jbe    802524 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 40 0c             	mov    0xc(%eax),%eax
  802521:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	0f 85 36 ff ff ff    	jne    80246c <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802536:	a1 38 41 80 00       	mov    0x804138,%eax
  80253b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80253e:	e9 dd 00 00 00       	jmp    802620 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 40 0c             	mov    0xc(%eax),%eax
  802549:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80254c:	0f 85 c6 00 00 00    	jne    802618 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802552:	a1 48 41 80 00       	mov    0x804148,%eax
  802557:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 50 08             	mov    0x8(%eax),%edx
  802560:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802563:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802566:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802569:	8b 55 08             	mov    0x8(%ebp),%edx
  80256c:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 50 08             	mov    0x8(%eax),%edx
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	01 c2                	add    %eax,%edx
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 0c             	mov    0xc(%eax),%eax
  802586:	2b 45 08             	sub    0x8(%ebp),%eax
  802589:	89 c2                	mov    %eax,%edx
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802591:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802595:	75 17                	jne    8025ae <alloc_block_BF+0x15c>
  802597:	83 ec 04             	sub    $0x4,%esp
  80259a:	68 05 3c 80 00       	push   $0x803c05
  80259f:	68 eb 00 00 00       	push   $0xeb
  8025a4:	68 93 3b 80 00       	push   $0x803b93
  8025a9:	e8 d4 dc ff ff       	call   800282 <_panic>
  8025ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 10                	je     8025c7 <alloc_block_BF+0x175>
  8025b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025bf:	8b 52 04             	mov    0x4(%edx),%edx
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	eb 0b                	jmp    8025d2 <alloc_block_BF+0x180>
  8025c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d5:	8b 40 04             	mov    0x4(%eax),%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 0f                	je     8025eb <alloc_block_BF+0x199>
  8025dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e5:	8b 12                	mov    (%edx),%edx
  8025e7:	89 10                	mov    %edx,(%eax)
  8025e9:	eb 0a                	jmp    8025f5 <alloc_block_BF+0x1a3>
  8025eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	a3 48 41 80 00       	mov    %eax,0x804148
  8025f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802601:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802608:	a1 54 41 80 00       	mov    0x804154,%eax
  80260d:	48                   	dec    %eax
  80260e:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802616:	eb 17                	jmp    80262f <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802624:	0f 85 19 ff ff ff    	jne    802543 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802637:	a1 40 40 80 00       	mov    0x804040,%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	75 19                	jne    802659 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802640:	83 ec 0c             	sub    $0xc,%esp
  802643:	ff 75 08             	pushl  0x8(%ebp)
  802646:	e8 6f fc ff ff       	call   8022ba <alloc_block_FF>
  80264b:	83 c4 10             	add    $0x10,%esp
  80264e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	e9 e9 01 00 00       	jmp    802842 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802659:	a1 44 40 80 00       	mov    0x804044,%eax
  80265e:	8b 40 08             	mov    0x8(%eax),%eax
  802661:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802664:	a1 44 40 80 00       	mov    0x804044,%eax
  802669:	8b 50 0c             	mov    0xc(%eax),%edx
  80266c:	a1 44 40 80 00       	mov    0x804044,%eax
  802671:	8b 40 08             	mov    0x8(%eax),%eax
  802674:	01 d0                	add    %edx,%eax
  802676:	83 ec 08             	sub    $0x8,%esp
  802679:	50                   	push   %eax
  80267a:	68 38 41 80 00       	push   $0x804138
  80267f:	e8 54 fa ff ff       	call   8020d8 <find_block>
  802684:	83 c4 10             	add    $0x10,%esp
  802687:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 40 0c             	mov    0xc(%eax),%eax
  802690:	3b 45 08             	cmp    0x8(%ebp),%eax
  802693:	0f 85 9b 00 00 00    	jne    802734 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 50 0c             	mov    0xc(%eax),%edx
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 08             	mov    0x8(%eax),%eax
  8026a5:	01 d0                	add    %edx,%eax
  8026a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8026aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ae:	75 17                	jne    8026c7 <alloc_block_NF+0x96>
  8026b0:	83 ec 04             	sub    $0x4,%esp
  8026b3:	68 05 3c 80 00       	push   $0x803c05
  8026b8:	68 1a 01 00 00       	push   $0x11a
  8026bd:	68 93 3b 80 00       	push   $0x803b93
  8026c2:	e8 bb db ff ff       	call   800282 <_panic>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	74 10                	je     8026e0 <alloc_block_NF+0xaf>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d8:	8b 52 04             	mov    0x4(%edx),%edx
  8026db:	89 50 04             	mov    %edx,0x4(%eax)
  8026de:	eb 0b                	jmp    8026eb <alloc_block_NF+0xba>
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 04             	mov    0x4(%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 0f                	je     802704 <alloc_block_NF+0xd3>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 04             	mov    0x4(%eax),%eax
  8026fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fe:	8b 12                	mov    (%edx),%edx
  802700:	89 10                	mov    %edx,(%eax)
  802702:	eb 0a                	jmp    80270e <alloc_block_NF+0xdd>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	a3 38 41 80 00       	mov    %eax,0x804138
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802721:	a1 44 41 80 00       	mov    0x804144,%eax
  802726:	48                   	dec    %eax
  802727:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	e9 0e 01 00 00       	jmp    802842 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 0c             	mov    0xc(%eax),%eax
  80273a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273d:	0f 86 cf 00 00 00    	jbe    802812 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802743:	a1 48 41 80 00       	mov    0x804148,%eax
  802748:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80274b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274e:	8b 55 08             	mov    0x8(%ebp),%edx
  802751:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 50 08             	mov    0x8(%eax),%edx
  80275a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275d:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 50 08             	mov    0x8(%eax),%edx
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	01 c2                	add    %eax,%edx
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 0c             	mov    0xc(%eax),%eax
  802777:	2b 45 08             	sub    0x8(%ebp),%eax
  80277a:	89 c2                	mov    %eax,%edx
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 40 08             	mov    0x8(%eax),%eax
  802788:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80278b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80278f:	75 17                	jne    8027a8 <alloc_block_NF+0x177>
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	68 05 3c 80 00       	push   $0x803c05
  802799:	68 28 01 00 00       	push   $0x128
  80279e:	68 93 3b 80 00       	push   $0x803b93
  8027a3:	e8 da da ff ff       	call   800282 <_panic>
  8027a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 10                	je     8027c1 <alloc_block_NF+0x190>
  8027b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b9:	8b 52 04             	mov    0x4(%edx),%edx
  8027bc:	89 50 04             	mov    %edx,0x4(%eax)
  8027bf:	eb 0b                	jmp    8027cc <alloc_block_NF+0x19b>
  8027c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cf:	8b 40 04             	mov    0x4(%eax),%eax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	74 0f                	je     8027e5 <alloc_block_NF+0x1b4>
  8027d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027df:	8b 12                	mov    (%edx),%edx
  8027e1:	89 10                	mov    %edx,(%eax)
  8027e3:	eb 0a                	jmp    8027ef <alloc_block_NF+0x1be>
  8027e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	a3 48 41 80 00       	mov    %eax,0x804148
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802802:	a1 54 41 80 00       	mov    0x804154,%eax
  802807:	48                   	dec    %eax
  802808:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80280d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802810:	eb 30                	jmp    802842 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802812:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802817:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80281a:	75 0a                	jne    802826 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80281c:	a1 38 41 80 00       	mov    0x804138,%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802824:	eb 08                	jmp    80282e <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 40 08             	mov    0x8(%eax),%eax
  802834:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802837:	0f 85 4d fe ff ff    	jne    80268a <alloc_block_NF+0x59>

			return NULL;
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802842:	c9                   	leave  
  802843:	c3                   	ret    

00802844 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802844:	55                   	push   %ebp
  802845:	89 e5                	mov    %esp,%ebp
  802847:	53                   	push   %ebx
  802848:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80284b:	a1 38 41 80 00       	mov    0x804138,%eax
  802850:	85 c0                	test   %eax,%eax
  802852:	0f 85 86 00 00 00    	jne    8028de <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802858:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80285f:	00 00 00 
  802862:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802869:	00 00 00 
  80286c:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802873:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802876:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80287a:	75 17                	jne    802893 <insert_sorted_with_merge_freeList+0x4f>
  80287c:	83 ec 04             	sub    $0x4,%esp
  80287f:	68 70 3b 80 00       	push   $0x803b70
  802884:	68 48 01 00 00       	push   $0x148
  802889:	68 93 3b 80 00       	push   $0x803b93
  80288e:	e8 ef d9 ff ff       	call   800282 <_panic>
  802893:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	89 10                	mov    %edx,(%eax)
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	74 0d                	je     8028b4 <insert_sorted_with_merge_freeList+0x70>
  8028a7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8028af:	89 50 04             	mov    %edx,0x4(%eax)
  8028b2:	eb 08                	jmp    8028bc <insert_sorted_with_merge_freeList+0x78>
  8028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	a3 38 41 80 00       	mov    %eax,0x804138
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ce:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d3:	40                   	inc    %eax
  8028d4:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8028d9:	e9 73 07 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	8b 50 08             	mov    0x8(%eax),%edx
  8028e4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028e9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ec:	39 c2                	cmp    %eax,%edx
  8028ee:	0f 86 84 00 00 00    	jbe    802978 <insert_sorted_with_merge_freeList+0x134>
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8b 50 08             	mov    0x8(%eax),%edx
  8028fa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028ff:	8b 48 0c             	mov    0xc(%eax),%ecx
  802902:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802907:	8b 40 08             	mov    0x8(%eax),%eax
  80290a:	01 c8                	add    %ecx,%eax
  80290c:	39 c2                	cmp    %eax,%edx
  80290e:	74 68                	je     802978 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802910:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802914:	75 17                	jne    80292d <insert_sorted_with_merge_freeList+0xe9>
  802916:	83 ec 04             	sub    $0x4,%esp
  802919:	68 ac 3b 80 00       	push   $0x803bac
  80291e:	68 4c 01 00 00       	push   $0x14c
  802923:	68 93 3b 80 00       	push   $0x803b93
  802928:	e8 55 d9 ff ff       	call   800282 <_panic>
  80292d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	89 50 04             	mov    %edx,0x4(%eax)
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 0c                	je     80294f <insert_sorted_with_merge_freeList+0x10b>
  802943:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802948:	8b 55 08             	mov    0x8(%ebp),%edx
  80294b:	89 10                	mov    %edx,(%eax)
  80294d:	eb 08                	jmp    802957 <insert_sorted_with_merge_freeList+0x113>
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	a3 38 41 80 00       	mov    %eax,0x804138
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802968:	a1 44 41 80 00       	mov    0x804144,%eax
  80296d:	40                   	inc    %eax
  80296e:	a3 44 41 80 00       	mov    %eax,0x804144
  802973:	e9 d9 06 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	8b 50 08             	mov    0x8(%eax),%edx
  80297e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802983:	8b 40 08             	mov    0x8(%eax),%eax
  802986:	39 c2                	cmp    %eax,%edx
  802988:	0f 86 b5 00 00 00    	jbe    802a43 <insert_sorted_with_merge_freeList+0x1ff>
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	8b 50 08             	mov    0x8(%eax),%edx
  802994:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802999:	8b 48 0c             	mov    0xc(%eax),%ecx
  80299c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029a1:	8b 40 08             	mov    0x8(%eax),%eax
  8029a4:	01 c8                	add    %ecx,%eax
  8029a6:	39 c2                	cmp    %eax,%edx
  8029a8:	0f 85 95 00 00 00    	jne    802a43 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029ae:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029b3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029b9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bf:	8b 52 0c             	mov    0xc(%edx),%edx
  8029c2:	01 ca                	add    %ecx,%edx
  8029c4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029df:	75 17                	jne    8029f8 <insert_sorted_with_merge_freeList+0x1b4>
  8029e1:	83 ec 04             	sub    $0x4,%esp
  8029e4:	68 70 3b 80 00       	push   $0x803b70
  8029e9:	68 54 01 00 00       	push   $0x154
  8029ee:	68 93 3b 80 00       	push   $0x803b93
  8029f3:	e8 8a d8 ff ff       	call   800282 <_panic>
  8029f8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	89 10                	mov    %edx,(%eax)
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	74 0d                	je     802a19 <insert_sorted_with_merge_freeList+0x1d5>
  802a0c:	a1 48 41 80 00       	mov    0x804148,%eax
  802a11:	8b 55 08             	mov    0x8(%ebp),%edx
  802a14:	89 50 04             	mov    %edx,0x4(%eax)
  802a17:	eb 08                	jmp    802a21 <insert_sorted_with_merge_freeList+0x1dd>
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	a3 48 41 80 00       	mov    %eax,0x804148
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a33:	a1 54 41 80 00       	mov    0x804154,%eax
  802a38:	40                   	inc    %eax
  802a39:	a3 54 41 80 00       	mov    %eax,0x804154
  802a3e:	e9 0e 06 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	8b 50 08             	mov    0x8(%eax),%edx
  802a49:	a1 38 41 80 00       	mov    0x804138,%eax
  802a4e:	8b 40 08             	mov    0x8(%eax),%eax
  802a51:	39 c2                	cmp    %eax,%edx
  802a53:	0f 83 c1 00 00 00    	jae    802b1a <insert_sorted_with_merge_freeList+0x2d6>
  802a59:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5e:	8b 50 08             	mov    0x8(%eax),%edx
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	8b 48 08             	mov    0x8(%eax),%ecx
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6d:	01 c8                	add    %ecx,%eax
  802a6f:	39 c2                	cmp    %eax,%edx
  802a71:	0f 85 a3 00 00 00    	jne    802b1a <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802a77:	a1 38 41 80 00       	mov    0x804138,%eax
  802a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7f:	8b 52 08             	mov    0x8(%edx),%edx
  802a82:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802a85:	a1 38 41 80 00       	mov    0x804138,%eax
  802a8a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a90:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a93:	8b 55 08             	mov    0x8(%ebp),%edx
  802a96:	8b 52 0c             	mov    0xc(%edx),%edx
  802a99:	01 ca                	add    %ecx,%edx
  802a9b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ab2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab6:	75 17                	jne    802acf <insert_sorted_with_merge_freeList+0x28b>
  802ab8:	83 ec 04             	sub    $0x4,%esp
  802abb:	68 70 3b 80 00       	push   $0x803b70
  802ac0:	68 5d 01 00 00       	push   $0x15d
  802ac5:	68 93 3b 80 00       	push   $0x803b93
  802aca:	e8 b3 d7 ff ff       	call   800282 <_panic>
  802acf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	89 10                	mov    %edx,(%eax)
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	8b 00                	mov    (%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	74 0d                	je     802af0 <insert_sorted_with_merge_freeList+0x2ac>
  802ae3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ae8:	8b 55 08             	mov    0x8(%ebp),%edx
  802aeb:	89 50 04             	mov    %edx,0x4(%eax)
  802aee:	eb 08                	jmp    802af8 <insert_sorted_with_merge_freeList+0x2b4>
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	a3 48 41 80 00       	mov    %eax,0x804148
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0a:	a1 54 41 80 00       	mov    0x804154,%eax
  802b0f:	40                   	inc    %eax
  802b10:	a3 54 41 80 00       	mov    %eax,0x804154
  802b15:	e9 37 05 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	8b 50 08             	mov    0x8(%eax),%edx
  802b20:	a1 38 41 80 00       	mov    0x804138,%eax
  802b25:	8b 40 08             	mov    0x8(%eax),%eax
  802b28:	39 c2                	cmp    %eax,%edx
  802b2a:	0f 83 82 00 00 00    	jae    802bb2 <insert_sorted_with_merge_freeList+0x36e>
  802b30:	a1 38 41 80 00       	mov    0x804138,%eax
  802b35:	8b 50 08             	mov    0x8(%eax),%edx
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8b 48 08             	mov    0x8(%eax),%ecx
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	8b 40 0c             	mov    0xc(%eax),%eax
  802b44:	01 c8                	add    %ecx,%eax
  802b46:	39 c2                	cmp    %eax,%edx
  802b48:	74 68                	je     802bb2 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4e:	75 17                	jne    802b67 <insert_sorted_with_merge_freeList+0x323>
  802b50:	83 ec 04             	sub    $0x4,%esp
  802b53:	68 70 3b 80 00       	push   $0x803b70
  802b58:	68 62 01 00 00       	push   $0x162
  802b5d:	68 93 3b 80 00       	push   $0x803b93
  802b62:	e8 1b d7 ff ff       	call   800282 <_panic>
  802b67:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	89 10                	mov    %edx,(%eax)
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 0d                	je     802b88 <insert_sorted_with_merge_freeList+0x344>
  802b7b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b80:	8b 55 08             	mov    0x8(%ebp),%edx
  802b83:	89 50 04             	mov    %edx,0x4(%eax)
  802b86:	eb 08                	jmp    802b90 <insert_sorted_with_merge_freeList+0x34c>
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	a3 38 41 80 00       	mov    %eax,0x804138
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 44 41 80 00       	mov    0x804144,%eax
  802ba7:	40                   	inc    %eax
  802ba8:	a3 44 41 80 00       	mov    %eax,0x804144
  802bad:	e9 9f 04 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802bb2:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802bbc:	e9 84 04 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 50 08             	mov    0x8(%eax),%edx
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	8b 40 08             	mov    0x8(%eax),%eax
  802bcd:	39 c2                	cmp    %eax,%edx
  802bcf:	0f 86 a9 00 00 00    	jbe    802c7e <insert_sorted_with_merge_freeList+0x43a>
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	8b 48 08             	mov    0x8(%eax),%ecx
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 40 0c             	mov    0xc(%eax),%eax
  802be7:	01 c8                	add    %ecx,%eax
  802be9:	39 c2                	cmp    %eax,%edx
  802beb:	0f 84 8d 00 00 00    	je     802c7e <insert_sorted_with_merge_freeList+0x43a>
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 50 08             	mov    0x8(%eax),%edx
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	8b 48 08             	mov    0x8(%eax),%ecx
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	01 c8                	add    %ecx,%eax
  802c0b:	39 c2                	cmp    %eax,%edx
  802c0d:	74 6f                	je     802c7e <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c13:	74 06                	je     802c1b <insert_sorted_with_merge_freeList+0x3d7>
  802c15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c19:	75 17                	jne    802c32 <insert_sorted_with_merge_freeList+0x3ee>
  802c1b:	83 ec 04             	sub    $0x4,%esp
  802c1e:	68 d0 3b 80 00       	push   $0x803bd0
  802c23:	68 6b 01 00 00       	push   $0x16b
  802c28:	68 93 3b 80 00       	push   $0x803b93
  802c2d:	e8 50 d6 ff ff       	call   800282 <_panic>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 50 04             	mov    0x4(%eax),%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	89 50 04             	mov    %edx,0x4(%eax)
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c44:	89 10                	mov    %edx,(%eax)
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 40 04             	mov    0x4(%eax),%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	74 0d                	je     802c5d <insert_sorted_with_merge_freeList+0x419>
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	8b 55 08             	mov    0x8(%ebp),%edx
  802c59:	89 10                	mov    %edx,(%eax)
  802c5b:	eb 08                	jmp    802c65 <insert_sorted_with_merge_freeList+0x421>
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	a3 38 41 80 00       	mov    %eax,0x804138
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6b:	89 50 04             	mov    %edx,0x4(%eax)
  802c6e:	a1 44 41 80 00       	mov    0x804144,%eax
  802c73:	40                   	inc    %eax
  802c74:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802c79:	e9 d3 03 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 50 08             	mov    0x8(%eax),%edx
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	8b 40 08             	mov    0x8(%eax),%eax
  802c8a:	39 c2                	cmp    %eax,%edx
  802c8c:	0f 86 da 00 00 00    	jbe    802d6c <insert_sorted_with_merge_freeList+0x528>
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 50 08             	mov    0x8(%eax),%edx
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	8b 48 08             	mov    0x8(%eax),%ecx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	01 c8                	add    %ecx,%eax
  802ca6:	39 c2                	cmp    %eax,%edx
  802ca8:	0f 85 be 00 00 00    	jne    802d6c <insert_sorted_with_merge_freeList+0x528>
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 50 08             	mov    0x8(%eax),%edx
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 40 04             	mov    0x4(%eax),%eax
  802cba:	8b 48 08             	mov    0x8(%eax),%ecx
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 40 04             	mov    0x4(%eax),%eax
  802cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc6:	01 c8                	add    %ecx,%eax
  802cc8:	39 c2                	cmp    %eax,%edx
  802cca:	0f 84 9c 00 00 00    	je     802d6c <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 50 08             	mov    0x8(%eax),%edx
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce8:	01 c2                	add    %eax,%edx
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d08:	75 17                	jne    802d21 <insert_sorted_with_merge_freeList+0x4dd>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 70 3b 80 00       	push   $0x803b70
  802d12:	68 74 01 00 00       	push   $0x174
  802d17:	68 93 3b 80 00       	push   $0x803b93
  802d1c:	e8 61 d5 ff ff       	call   800282 <_panic>
  802d21:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	89 10                	mov    %edx,(%eax)
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	85 c0                	test   %eax,%eax
  802d33:	74 0d                	je     802d42 <insert_sorted_with_merge_freeList+0x4fe>
  802d35:	a1 48 41 80 00       	mov    0x804148,%eax
  802d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3d:	89 50 04             	mov    %edx,0x4(%eax)
  802d40:	eb 08                	jmp    802d4a <insert_sorted_with_merge_freeList+0x506>
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	a3 48 41 80 00       	mov    %eax,0x804148
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5c:	a1 54 41 80 00       	mov    0x804154,%eax
  802d61:	40                   	inc    %eax
  802d62:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d67:	e9 e5 02 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 50 08             	mov    0x8(%eax),%edx
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	39 c2                	cmp    %eax,%edx
  802d7a:	0f 86 d7 00 00 00    	jbe    802e57 <insert_sorted_with_merge_freeList+0x613>
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 50 08             	mov    0x8(%eax),%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 48 08             	mov    0x8(%eax),%ecx
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d92:	01 c8                	add    %ecx,%eax
  802d94:	39 c2                	cmp    %eax,%edx
  802d96:	0f 84 bb 00 00 00    	je     802e57 <insert_sorted_with_merge_freeList+0x613>
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	8b 50 08             	mov    0x8(%eax),%edx
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 04             	mov    0x4(%eax),%eax
  802da8:	8b 48 08             	mov    0x8(%eax),%ecx
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 40 04             	mov    0x4(%eax),%eax
  802db1:	8b 40 0c             	mov    0xc(%eax),%eax
  802db4:	01 c8                	add    %ecx,%eax
  802db6:	39 c2                	cmp    %eax,%edx
  802db8:	0f 85 99 00 00 00    	jne    802e57 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	8b 50 0c             	mov    0xc(%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd3:	01 c2                	add    %eax,%edx
  802dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd8:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802def:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df3:	75 17                	jne    802e0c <insert_sorted_with_merge_freeList+0x5c8>
  802df5:	83 ec 04             	sub    $0x4,%esp
  802df8:	68 70 3b 80 00       	push   $0x803b70
  802dfd:	68 7d 01 00 00       	push   $0x17d
  802e02:	68 93 3b 80 00       	push   $0x803b93
  802e07:	e8 76 d4 ff ff       	call   800282 <_panic>
  802e0c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	89 10                	mov    %edx,(%eax)
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	8b 00                	mov    (%eax),%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	74 0d                	je     802e2d <insert_sorted_with_merge_freeList+0x5e9>
  802e20:	a1 48 41 80 00       	mov    0x804148,%eax
  802e25:	8b 55 08             	mov    0x8(%ebp),%edx
  802e28:	89 50 04             	mov    %edx,0x4(%eax)
  802e2b:	eb 08                	jmp    802e35 <insert_sorted_with_merge_freeList+0x5f1>
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	a3 48 41 80 00       	mov    %eax,0x804148
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e47:	a1 54 41 80 00       	mov    0x804154,%eax
  802e4c:	40                   	inc    %eax
  802e4d:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e52:	e9 fa 01 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 50 08             	mov    0x8(%eax),%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	8b 40 08             	mov    0x8(%eax),%eax
  802e63:	39 c2                	cmp    %eax,%edx
  802e65:	0f 86 d2 01 00 00    	jbe    80303d <insert_sorted_with_merge_freeList+0x7f9>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 50 08             	mov    0x8(%eax),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 48 08             	mov    0x8(%eax),%ecx
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7d:	01 c8                	add    %ecx,%eax
  802e7f:	39 c2                	cmp    %eax,%edx
  802e81:	0f 85 b6 01 00 00    	jne    80303d <insert_sorted_with_merge_freeList+0x7f9>
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	8b 48 08             	mov    0x8(%eax),%ecx
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9f:	01 c8                	add    %ecx,%eax
  802ea1:	39 c2                	cmp    %eax,%edx
  802ea3:	0f 85 94 01 00 00    	jne    80303d <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 04             	mov    0x4(%eax),%eax
  802eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb2:	8b 52 04             	mov    0x4(%edx),%edx
  802eb5:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebb:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec1:	8b 52 0c             	mov    0xc(%edx),%edx
  802ec4:	01 da                	add    %ebx,%edx
  802ec6:	01 ca                	add    %ecx,%edx
  802ec8:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802edf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee3:	75 17                	jne    802efc <insert_sorted_with_merge_freeList+0x6b8>
  802ee5:	83 ec 04             	sub    $0x4,%esp
  802ee8:	68 05 3c 80 00       	push   $0x803c05
  802eed:	68 86 01 00 00       	push   $0x186
  802ef2:	68 93 3b 80 00       	push   $0x803b93
  802ef7:	e8 86 d3 ff ff       	call   800282 <_panic>
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 00                	mov    (%eax),%eax
  802f01:	85 c0                	test   %eax,%eax
  802f03:	74 10                	je     802f15 <insert_sorted_with_merge_freeList+0x6d1>
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 00                	mov    (%eax),%eax
  802f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0d:	8b 52 04             	mov    0x4(%edx),%edx
  802f10:	89 50 04             	mov    %edx,0x4(%eax)
  802f13:	eb 0b                	jmp    802f20 <insert_sorted_with_merge_freeList+0x6dc>
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 40 04             	mov    0x4(%eax),%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	74 0f                	je     802f39 <insert_sorted_with_merge_freeList+0x6f5>
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 40 04             	mov    0x4(%eax),%eax
  802f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f33:	8b 12                	mov    (%edx),%edx
  802f35:	89 10                	mov    %edx,(%eax)
  802f37:	eb 0a                	jmp    802f43 <insert_sorted_with_merge_freeList+0x6ff>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	a3 38 41 80 00       	mov    %eax,0x804138
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f56:	a1 44 41 80 00       	mov    0x804144,%eax
  802f5b:	48                   	dec    %eax
  802f5c:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f65:	75 17                	jne    802f7e <insert_sorted_with_merge_freeList+0x73a>
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	68 70 3b 80 00       	push   $0x803b70
  802f6f:	68 87 01 00 00       	push   $0x187
  802f74:	68 93 3b 80 00       	push   $0x803b93
  802f79:	e8 04 d3 ff ff       	call   800282 <_panic>
  802f7e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	89 10                	mov    %edx,(%eax)
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 00                	mov    (%eax),%eax
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	74 0d                	je     802f9f <insert_sorted_with_merge_freeList+0x75b>
  802f92:	a1 48 41 80 00       	mov    0x804148,%eax
  802f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9a:	89 50 04             	mov    %edx,0x4(%eax)
  802f9d:	eb 08                	jmp    802fa7 <insert_sorted_with_merge_freeList+0x763>
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	a3 48 41 80 00       	mov    %eax,0x804148
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb9:	a1 54 41 80 00       	mov    0x804154,%eax
  802fbe:	40                   	inc    %eax
  802fbf:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdc:	75 17                	jne    802ff5 <insert_sorted_with_merge_freeList+0x7b1>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 70 3b 80 00       	push   $0x803b70
  802fe6:	68 8a 01 00 00       	push   $0x18a
  802feb:	68 93 3b 80 00       	push   $0x803b93
  802ff0:	e8 8d d2 ff ff       	call   800282 <_panic>
  802ff5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	89 10                	mov    %edx,(%eax)
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 0d                	je     803016 <insert_sorted_with_merge_freeList+0x7d2>
  803009:	a1 48 41 80 00       	mov    0x804148,%eax
  80300e:	8b 55 08             	mov    0x8(%ebp),%edx
  803011:	89 50 04             	mov    %edx,0x4(%eax)
  803014:	eb 08                	jmp    80301e <insert_sorted_with_merge_freeList+0x7da>
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	a3 48 41 80 00       	mov    %eax,0x804148
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 54 41 80 00       	mov    0x804154,%eax
  803035:	40                   	inc    %eax
  803036:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  80303b:	eb 14                	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803045:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803049:	0f 85 72 fb ff ff    	jne    802bc1 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80304f:	eb 00                	jmp    803051 <insert_sorted_with_merge_freeList+0x80d>
  803051:	90                   	nop
  803052:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803055:	c9                   	leave  
  803056:	c3                   	ret    
  803057:	90                   	nop

00803058 <__udivdi3>:
  803058:	55                   	push   %ebp
  803059:	57                   	push   %edi
  80305a:	56                   	push   %esi
  80305b:	53                   	push   %ebx
  80305c:	83 ec 1c             	sub    $0x1c,%esp
  80305f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803063:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803067:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80306b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80306f:	89 ca                	mov    %ecx,%edx
  803071:	89 f8                	mov    %edi,%eax
  803073:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803077:	85 f6                	test   %esi,%esi
  803079:	75 2d                	jne    8030a8 <__udivdi3+0x50>
  80307b:	39 cf                	cmp    %ecx,%edi
  80307d:	77 65                	ja     8030e4 <__udivdi3+0x8c>
  80307f:	89 fd                	mov    %edi,%ebp
  803081:	85 ff                	test   %edi,%edi
  803083:	75 0b                	jne    803090 <__udivdi3+0x38>
  803085:	b8 01 00 00 00       	mov    $0x1,%eax
  80308a:	31 d2                	xor    %edx,%edx
  80308c:	f7 f7                	div    %edi
  80308e:	89 c5                	mov    %eax,%ebp
  803090:	31 d2                	xor    %edx,%edx
  803092:	89 c8                	mov    %ecx,%eax
  803094:	f7 f5                	div    %ebp
  803096:	89 c1                	mov    %eax,%ecx
  803098:	89 d8                	mov    %ebx,%eax
  80309a:	f7 f5                	div    %ebp
  80309c:	89 cf                	mov    %ecx,%edi
  80309e:	89 fa                	mov    %edi,%edx
  8030a0:	83 c4 1c             	add    $0x1c,%esp
  8030a3:	5b                   	pop    %ebx
  8030a4:	5e                   	pop    %esi
  8030a5:	5f                   	pop    %edi
  8030a6:	5d                   	pop    %ebp
  8030a7:	c3                   	ret    
  8030a8:	39 ce                	cmp    %ecx,%esi
  8030aa:	77 28                	ja     8030d4 <__udivdi3+0x7c>
  8030ac:	0f bd fe             	bsr    %esi,%edi
  8030af:	83 f7 1f             	xor    $0x1f,%edi
  8030b2:	75 40                	jne    8030f4 <__udivdi3+0x9c>
  8030b4:	39 ce                	cmp    %ecx,%esi
  8030b6:	72 0a                	jb     8030c2 <__udivdi3+0x6a>
  8030b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030bc:	0f 87 9e 00 00 00    	ja     803160 <__udivdi3+0x108>
  8030c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c7:	89 fa                	mov    %edi,%edx
  8030c9:	83 c4 1c             	add    $0x1c,%esp
  8030cc:	5b                   	pop    %ebx
  8030cd:	5e                   	pop    %esi
  8030ce:	5f                   	pop    %edi
  8030cf:	5d                   	pop    %ebp
  8030d0:	c3                   	ret    
  8030d1:	8d 76 00             	lea    0x0(%esi),%esi
  8030d4:	31 ff                	xor    %edi,%edi
  8030d6:	31 c0                	xor    %eax,%eax
  8030d8:	89 fa                	mov    %edi,%edx
  8030da:	83 c4 1c             	add    $0x1c,%esp
  8030dd:	5b                   	pop    %ebx
  8030de:	5e                   	pop    %esi
  8030df:	5f                   	pop    %edi
  8030e0:	5d                   	pop    %ebp
  8030e1:	c3                   	ret    
  8030e2:	66 90                	xchg   %ax,%ax
  8030e4:	89 d8                	mov    %ebx,%eax
  8030e6:	f7 f7                	div    %edi
  8030e8:	31 ff                	xor    %edi,%edi
  8030ea:	89 fa                	mov    %edi,%edx
  8030ec:	83 c4 1c             	add    $0x1c,%esp
  8030ef:	5b                   	pop    %ebx
  8030f0:	5e                   	pop    %esi
  8030f1:	5f                   	pop    %edi
  8030f2:	5d                   	pop    %ebp
  8030f3:	c3                   	ret    
  8030f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030f9:	89 eb                	mov    %ebp,%ebx
  8030fb:	29 fb                	sub    %edi,%ebx
  8030fd:	89 f9                	mov    %edi,%ecx
  8030ff:	d3 e6                	shl    %cl,%esi
  803101:	89 c5                	mov    %eax,%ebp
  803103:	88 d9                	mov    %bl,%cl
  803105:	d3 ed                	shr    %cl,%ebp
  803107:	89 e9                	mov    %ebp,%ecx
  803109:	09 f1                	or     %esi,%ecx
  80310b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80310f:	89 f9                	mov    %edi,%ecx
  803111:	d3 e0                	shl    %cl,%eax
  803113:	89 c5                	mov    %eax,%ebp
  803115:	89 d6                	mov    %edx,%esi
  803117:	88 d9                	mov    %bl,%cl
  803119:	d3 ee                	shr    %cl,%esi
  80311b:	89 f9                	mov    %edi,%ecx
  80311d:	d3 e2                	shl    %cl,%edx
  80311f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803123:	88 d9                	mov    %bl,%cl
  803125:	d3 e8                	shr    %cl,%eax
  803127:	09 c2                	or     %eax,%edx
  803129:	89 d0                	mov    %edx,%eax
  80312b:	89 f2                	mov    %esi,%edx
  80312d:	f7 74 24 0c          	divl   0xc(%esp)
  803131:	89 d6                	mov    %edx,%esi
  803133:	89 c3                	mov    %eax,%ebx
  803135:	f7 e5                	mul    %ebp
  803137:	39 d6                	cmp    %edx,%esi
  803139:	72 19                	jb     803154 <__udivdi3+0xfc>
  80313b:	74 0b                	je     803148 <__udivdi3+0xf0>
  80313d:	89 d8                	mov    %ebx,%eax
  80313f:	31 ff                	xor    %edi,%edi
  803141:	e9 58 ff ff ff       	jmp    80309e <__udivdi3+0x46>
  803146:	66 90                	xchg   %ax,%ax
  803148:	8b 54 24 08          	mov    0x8(%esp),%edx
  80314c:	89 f9                	mov    %edi,%ecx
  80314e:	d3 e2                	shl    %cl,%edx
  803150:	39 c2                	cmp    %eax,%edx
  803152:	73 e9                	jae    80313d <__udivdi3+0xe5>
  803154:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803157:	31 ff                	xor    %edi,%edi
  803159:	e9 40 ff ff ff       	jmp    80309e <__udivdi3+0x46>
  80315e:	66 90                	xchg   %ax,%ax
  803160:	31 c0                	xor    %eax,%eax
  803162:	e9 37 ff ff ff       	jmp    80309e <__udivdi3+0x46>
  803167:	90                   	nop

00803168 <__umoddi3>:
  803168:	55                   	push   %ebp
  803169:	57                   	push   %edi
  80316a:	56                   	push   %esi
  80316b:	53                   	push   %ebx
  80316c:	83 ec 1c             	sub    $0x1c,%esp
  80316f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803173:	8b 74 24 34          	mov    0x34(%esp),%esi
  803177:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80317b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80317f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803183:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803187:	89 f3                	mov    %esi,%ebx
  803189:	89 fa                	mov    %edi,%edx
  80318b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80318f:	89 34 24             	mov    %esi,(%esp)
  803192:	85 c0                	test   %eax,%eax
  803194:	75 1a                	jne    8031b0 <__umoddi3+0x48>
  803196:	39 f7                	cmp    %esi,%edi
  803198:	0f 86 a2 00 00 00    	jbe    803240 <__umoddi3+0xd8>
  80319e:	89 c8                	mov    %ecx,%eax
  8031a0:	89 f2                	mov    %esi,%edx
  8031a2:	f7 f7                	div    %edi
  8031a4:	89 d0                	mov    %edx,%eax
  8031a6:	31 d2                	xor    %edx,%edx
  8031a8:	83 c4 1c             	add    $0x1c,%esp
  8031ab:	5b                   	pop    %ebx
  8031ac:	5e                   	pop    %esi
  8031ad:	5f                   	pop    %edi
  8031ae:	5d                   	pop    %ebp
  8031af:	c3                   	ret    
  8031b0:	39 f0                	cmp    %esi,%eax
  8031b2:	0f 87 ac 00 00 00    	ja     803264 <__umoddi3+0xfc>
  8031b8:	0f bd e8             	bsr    %eax,%ebp
  8031bb:	83 f5 1f             	xor    $0x1f,%ebp
  8031be:	0f 84 ac 00 00 00    	je     803270 <__umoddi3+0x108>
  8031c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8031c9:	29 ef                	sub    %ebp,%edi
  8031cb:	89 fe                	mov    %edi,%esi
  8031cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031d1:	89 e9                	mov    %ebp,%ecx
  8031d3:	d3 e0                	shl    %cl,%eax
  8031d5:	89 d7                	mov    %edx,%edi
  8031d7:	89 f1                	mov    %esi,%ecx
  8031d9:	d3 ef                	shr    %cl,%edi
  8031db:	09 c7                	or     %eax,%edi
  8031dd:	89 e9                	mov    %ebp,%ecx
  8031df:	d3 e2                	shl    %cl,%edx
  8031e1:	89 14 24             	mov    %edx,(%esp)
  8031e4:	89 d8                	mov    %ebx,%eax
  8031e6:	d3 e0                	shl    %cl,%eax
  8031e8:	89 c2                	mov    %eax,%edx
  8031ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ee:	d3 e0                	shl    %cl,%eax
  8031f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f8:	89 f1                	mov    %esi,%ecx
  8031fa:	d3 e8                	shr    %cl,%eax
  8031fc:	09 d0                	or     %edx,%eax
  8031fe:	d3 eb                	shr    %cl,%ebx
  803200:	89 da                	mov    %ebx,%edx
  803202:	f7 f7                	div    %edi
  803204:	89 d3                	mov    %edx,%ebx
  803206:	f7 24 24             	mull   (%esp)
  803209:	89 c6                	mov    %eax,%esi
  80320b:	89 d1                	mov    %edx,%ecx
  80320d:	39 d3                	cmp    %edx,%ebx
  80320f:	0f 82 87 00 00 00    	jb     80329c <__umoddi3+0x134>
  803215:	0f 84 91 00 00 00    	je     8032ac <__umoddi3+0x144>
  80321b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80321f:	29 f2                	sub    %esi,%edx
  803221:	19 cb                	sbb    %ecx,%ebx
  803223:	89 d8                	mov    %ebx,%eax
  803225:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803229:	d3 e0                	shl    %cl,%eax
  80322b:	89 e9                	mov    %ebp,%ecx
  80322d:	d3 ea                	shr    %cl,%edx
  80322f:	09 d0                	or     %edx,%eax
  803231:	89 e9                	mov    %ebp,%ecx
  803233:	d3 eb                	shr    %cl,%ebx
  803235:	89 da                	mov    %ebx,%edx
  803237:	83 c4 1c             	add    $0x1c,%esp
  80323a:	5b                   	pop    %ebx
  80323b:	5e                   	pop    %esi
  80323c:	5f                   	pop    %edi
  80323d:	5d                   	pop    %ebp
  80323e:	c3                   	ret    
  80323f:	90                   	nop
  803240:	89 fd                	mov    %edi,%ebp
  803242:	85 ff                	test   %edi,%edi
  803244:	75 0b                	jne    803251 <__umoddi3+0xe9>
  803246:	b8 01 00 00 00       	mov    $0x1,%eax
  80324b:	31 d2                	xor    %edx,%edx
  80324d:	f7 f7                	div    %edi
  80324f:	89 c5                	mov    %eax,%ebp
  803251:	89 f0                	mov    %esi,%eax
  803253:	31 d2                	xor    %edx,%edx
  803255:	f7 f5                	div    %ebp
  803257:	89 c8                	mov    %ecx,%eax
  803259:	f7 f5                	div    %ebp
  80325b:	89 d0                	mov    %edx,%eax
  80325d:	e9 44 ff ff ff       	jmp    8031a6 <__umoddi3+0x3e>
  803262:	66 90                	xchg   %ax,%ax
  803264:	89 c8                	mov    %ecx,%eax
  803266:	89 f2                	mov    %esi,%edx
  803268:	83 c4 1c             	add    $0x1c,%esp
  80326b:	5b                   	pop    %ebx
  80326c:	5e                   	pop    %esi
  80326d:	5f                   	pop    %edi
  80326e:	5d                   	pop    %ebp
  80326f:	c3                   	ret    
  803270:	3b 04 24             	cmp    (%esp),%eax
  803273:	72 06                	jb     80327b <__umoddi3+0x113>
  803275:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803279:	77 0f                	ja     80328a <__umoddi3+0x122>
  80327b:	89 f2                	mov    %esi,%edx
  80327d:	29 f9                	sub    %edi,%ecx
  80327f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803283:	89 14 24             	mov    %edx,(%esp)
  803286:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80328a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80328e:	8b 14 24             	mov    (%esp),%edx
  803291:	83 c4 1c             	add    $0x1c,%esp
  803294:	5b                   	pop    %ebx
  803295:	5e                   	pop    %esi
  803296:	5f                   	pop    %edi
  803297:	5d                   	pop    %ebp
  803298:	c3                   	ret    
  803299:	8d 76 00             	lea    0x0(%esi),%esi
  80329c:	2b 04 24             	sub    (%esp),%eax
  80329f:	19 fa                	sbb    %edi,%edx
  8032a1:	89 d1                	mov    %edx,%ecx
  8032a3:	89 c6                	mov    %eax,%esi
  8032a5:	e9 71 ff ff ff       	jmp    80321b <__umoddi3+0xb3>
  8032aa:	66 90                	xchg   %ax,%ax
  8032ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032b0:	72 ea                	jb     80329c <__umoddi3+0x134>
  8032b2:	89 d9                	mov    %ebx,%ecx
  8032b4:	e9 62 ff ff ff       	jmp    80321b <__umoddi3+0xb3>
