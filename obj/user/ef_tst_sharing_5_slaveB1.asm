
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 05 01 00 00       	call   80013b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 80 33 80 00       	push   $0x803380
  800091:	6a 12                	push   $0x12
  800093:	68 9c 33 80 00       	push   $0x80339c
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 36 1b 00 00       	call   801bd8 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 bc 33 80 00       	push   $0x8033bc
  8000aa:	50                   	push   %eax
  8000ab:	e8 ef 15 00 00       	call   80169f <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 c0 33 80 00       	push   $0x8033c0
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 e8 33 80 00       	push   $0x8033e8
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 69 2f 00 00       	call   80304c <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 f4 17 00 00       	call   8018df <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 86 16 00 00       	call   80177f <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 08 34 80 00       	push   $0x803408
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 ce 17 00 00       	call   8018df <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 20 34 80 00       	push   $0x803420
  800127:	6a 20                	push   $0x20
  800129:	68 9c 33 80 00       	push   $0x80339c
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 c5 1b 00 00       	call   801cfd <inctst>
	return;
  800138:	90                   	nop
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800141:	e8 79 1a 00 00       	call   801bbf <sys_getenvindex>
  800146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015e:	01 d0                	add    %edx,%eax
  800160:	c1 e0 04             	shl    $0x4,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016d:	a1 20 40 80 00       	mov    0x804020,%eax
  800172:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800178:	84 c0                	test   %al,%al
  80017a:	74 0f                	je     80018b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80017c:	a1 20 40 80 00       	mov    0x804020,%eax
  800181:	05 5c 05 00 00       	add    $0x55c,%eax
  800186:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x60>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ac:	e8 1b 18 00 00       	call   8019cc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 e0 34 80 00       	push   $0x8034e0
  8001b9:	e8 6d 03 00 00       	call   80052b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 08 35 80 00       	push   $0x803508
  8001e1:	e8 45 03 00 00       	call   80052b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ee:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 30 35 80 00       	push   $0x803530
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 88 35 80 00       	push   $0x803588
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 e0 34 80 00       	push   $0x8034e0
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 9b 17 00 00       	call   8019e6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024b:	e8 19 00 00 00       	call   800269 <exit>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	e8 28 19 00 00       	call   801b8b <sys_destroy_env>
  800263:	83 c4 10             	add    $0x10,%esp
}
  800266:	90                   	nop
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <exit>:

void
exit(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026f:	e8 7d 19 00 00       	call   801bf1 <sys_exit_env>
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027d:	8d 45 10             	lea    0x10(%ebp),%eax
  800280:	83 c0 04             	add    $0x4,%eax
  800283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800286:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	74 16                	je     8002a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 9c 35 80 00       	push   $0x80359c
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 a1 35 80 00       	push   $0x8035a1
  8002b6:	e8 70 02 00 00       	call   80052b <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002be:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 f3 01 00 00       	call   8004c0 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	6a 00                	push   $0x0
  8002d5:	68 bd 35 80 00       	push   $0x8035bd
  8002da:	e8 e1 01 00 00       	call   8004c0 <vcprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e2:	e8 82 ff ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8002e7:	eb fe                	jmp    8002e7 <_panic+0x70>

008002e9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f4:	8b 50 74             	mov    0x74(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 c0 35 80 00       	push   $0x8035c0
  800306:	6a 26                	push   $0x26
  800308:	68 0c 36 80 00       	push   $0x80360c
  80030d:	e8 65 ff ff ff       	call   800277 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c2 00 00 00       	jmp    8003e7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a2 00 00 00       	jmp    8003e4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 20 40 80 00       	mov    0x804020,%eax
  800357:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 20 40 80 00       	mov    0x804020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 12                	jmp    8003ca <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c0:	8b 50 74             	mov    0x74(%eax),%edx
  8003c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	77 88                	ja     800352 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	75 14                	jne    8003e4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	68 18 36 80 00       	push   $0x803618
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 0c 36 80 00       	push   $0x80360c
  8003df:	e8 93 fe ff ff       	call   800277 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e4:	ff 45 f0             	incl   -0x10(%ebp)
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ed:	0f 8c 32 ff ff ff    	jl     800325 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800401:	eb 26                	jmp    800429 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800403:	a1 20 40 80 00       	mov    0x804020,%eax
  800408:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800411:	89 d0                	mov    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 03             	shl    $0x3,%eax
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	8a 40 04             	mov    0x4(%eax),%al
  80041f:	3c 01                	cmp    $0x1,%al
  800421:	75 03                	jne    800426 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800423:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800426:	ff 45 e0             	incl   -0x20(%ebp)
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
  80042e:	8b 50 74             	mov    0x74(%eax),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	77 cb                	ja     800403 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043e:	74 14                	je     800454 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 6c 36 80 00       	push   $0x80366c
  800448:	6a 44                	push   $0x44
  80044a:	68 0c 36 80 00       	push   $0x80360c
  80044f:	e8 23 fe ff ff       	call   800277 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 01             	lea    0x1(%eax),%ecx
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 55 08             	mov    0x8(%ebp),%edx
  80046d:	88 d1                	mov    %dl,%cl
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 2c                	jne    8004ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800482:	a0 24 40 80 00       	mov    0x804024,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	8b 12                	mov    (%edx),%edx
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	83 c2 08             	add    $0x8,%edx
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	50                   	push   %eax
  80049b:	51                   	push   %ecx
  80049c:	52                   	push   %edx
  80049d:	e8 7c 13 00 00       	call   80181e <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 40 04             	mov    0x4(%eax),%eax
  8004b4:	8d 50 01             	lea    0x1(%eax),%edx
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e9:	50                   	push   %eax
  8004ea:	68 57 04 80 00       	push   $0x800457
  8004ef:	e8 11 02 00 00       	call   800705 <vprintfmt>
  8004f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f7:	a0 24 40 80 00       	mov    0x804024,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 05 13 00 00       	call   80181e <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <cprintf>:

int cprintf(const char *fmt, ...) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800531:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 73 ff ff ff       	call   8004c0 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055e:	e8 69 14 00 00       	call   8019cc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800563:	8d 45 0c             	lea    0xc(%ebp),%eax
  800566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	50                   	push   %eax
  800573:	e8 48 ff ff ff       	call   8004c0 <vcprintf>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80057e:	e8 63 14 00 00       	call   8019e6 <sys_enable_interrupt>
	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 14             	sub    $0x14,%esp
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059b:	8b 45 18             	mov    0x18(%ebp),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a6:	77 55                	ja     8005fd <printnum+0x75>
  8005a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ab:	72 05                	jb     8005b2 <printnum+0x2a>
  8005ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b0:	77 4b                	ja     8005fd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	52                   	push   %edx
  8005c1:	50                   	push   %eax
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c8:	e8 33 2b 00 00       	call   803100 <__udivdi3>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 20             	pushl  0x20(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 18             	pushl  0x18(%ebp)
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 a1 ff ff ff       	call   800588 <printnum>
  8005e7:	83 c4 20             	add    $0x20,%esp
  8005ea:	eb 1a                	jmp    800606 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	ff 4d 1c             	decl   0x1c(%ebp)
  800600:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800604:	7f e6                	jg     8005ec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800609:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	53                   	push   %ebx
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	e8 f3 2b 00 00       	call   803210 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 d4 38 80 00       	add    $0x8038d4,%eax
  800625:	8a 00                	mov    (%eax),%al
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
}
  800639:	90                   	nop
  80063a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800642:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800646:	7e 1c                	jle    800664 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 50 08             	lea    0x8(%eax),%edx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	89 10                	mov    %edx,(%eax)
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 e8 08             	sub    $0x8,%eax
  80065d:	8b 50 04             	mov    0x4(%eax),%edx
  800660:	8b 00                	mov    (%eax),%eax
  800662:	eb 40                	jmp    8006a4 <getuint+0x65>
	else if (lflag)
  800664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800668:	74 1e                	je     800688 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1c                	jmp    8006a4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ad:	7e 1c                	jle    8006cb <getint+0x25>
		return va_arg(*ap, long long);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	8d 50 08             	lea    0x8(%eax),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 10                	mov    %edx,(%eax)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 e8 08             	sub    $0x8,%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	eb 38                	jmp    800703 <getint+0x5d>
	else if (lflag)
  8006cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cf:	74 1a                	je     8006eb <getint+0x45>
		return va_arg(*ap, long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 04             	lea    0x4(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 04             	sub    $0x4,%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	99                   	cltd   
  8006e9:	eb 18                	jmp    800703 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x21>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 af 03 00 00    	je     800ac6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	53                   	push   %ebx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	8d 50 01             	lea    0x1(%eax),%edx
  80072c:	89 55 10             	mov    %edx,0x10(%ebp)
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f b6 d8             	movzbl %al,%ebx
  800734:	83 fb 25             	cmp    $0x25,%ebx
  800737:	75 d6                	jne    80070f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800739:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076a:	83 f8 55             	cmp    $0x55,%eax
  80076d:	0f 87 2b 03 00 00    	ja     800a9e <vprintfmt+0x399>
  800773:	8b 04 85 f8 38 80 00 	mov    0x8038f8(,%eax,4),%eax
  80077a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800780:	eb d7                	jmp    800759 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800782:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800786:	eb d1                	jmp    800759 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800788:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d8                	add    %ebx,%eax
  80079d:	83 e8 30             	sub    $0x30,%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8a 00                	mov    (%eax),%al
  8007a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ae:	7e 3e                	jle    8007ee <vprintfmt+0xe9>
  8007b0:	83 fb 39             	cmp    $0x39,%ebx
  8007b3:	7f 39                	jg     8007ee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b8:	eb d5                	jmp    80078f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d4:	79 83                	jns    800759 <vprintfmt+0x54>
				width = 0;
  8007d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dd:	e9 77 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e9:	e9 6b ff ff ff       	jmp    800759 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	0f 89 60 ff ff ff    	jns    800759 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800806:	e9 4e ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080e:	e9 46 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	e9 89 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800849:	85 db                	test   %ebx,%ebx
  80084b:	79 02                	jns    80084f <vprintfmt+0x14a>
				err = -err;
  80084d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084f:	83 fb 64             	cmp    $0x64,%ebx
  800852:	7f 0b                	jg     80085f <vprintfmt+0x15a>
  800854:	8b 34 9d 40 37 80 00 	mov    0x803740(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 e5 38 80 00       	push   $0x8038e5
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 5e 02 00 00       	call   800ace <printfmt>
  800870:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800873:	e9 49 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800878:	56                   	push   %esi
  800879:	68 ee 38 80 00       	push   $0x8038ee
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 45 02 00 00       	call   800ace <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 30 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 30                	mov    (%eax),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 05                	jne    8008ab <vprintfmt+0x1a6>
				p = "(null)";
  8008a6:	be f1 38 80 00       	mov    $0x8038f1,%esi
			if (width > 0 && padc != '-')
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7e 6d                	jle    80091e <vprintfmt+0x219>
  8008b1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b5:	74 67                	je     80091e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	56                   	push   %esi
  8008bf:	e8 0c 03 00 00       	call   800bd0 <strnlen>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ca:	eb 16                	jmp    8008e2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008df:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	7f e4                	jg     8008cc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e8:	eb 34                	jmp    80091e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ee:	74 1c                	je     80090c <vprintfmt+0x207>
  8008f0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f3:	7e 05                	jle    8008fa <vprintfmt+0x1f5>
  8008f5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f8:	7e 12                	jle    80090c <vprintfmt+0x207>
					putch('?', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	6a 3f                	push   $0x3f
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	89 f0                	mov    %esi,%eax
  800920:	8d 70 01             	lea    0x1(%eax),%esi
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
  800928:	85 db                	test   %ebx,%ebx
  80092a:	74 24                	je     800950 <vprintfmt+0x24b>
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	78 b8                	js     8008ea <vprintfmt+0x1e5>
  800932:	ff 4d e0             	decl   -0x20(%ebp)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 af                	jns    8008ea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093b:	eb 13                	jmp    800950 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 20                	push   $0x20
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	7f e7                	jg     80093d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800956:	e9 66 01 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 e8             	pushl  -0x18(%ebp)
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 3c fd ff ff       	call   8006a6 <getint>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800979:	85 d2                	test   %edx,%edx
  80097b:	79 23                	jns    8009a0 <vprintfmt+0x29b>
				putch('-', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 2d                	push   $0x2d
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	f7 d8                	neg    %eax
  800995:	83 d2 00             	adc    $0x0,%edx
  800998:	f7 da                	neg    %edx
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a7:	e9 bc 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 84 fc ff ff       	call   80063f <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cb:	e9 98 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 58                	push   $0x58
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 58                	push   $0x58
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 58                	push   $0x58
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 bc 00 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 30                	push   $0x30
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 78                	push   $0x78
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 e7 fb ff ff       	call   80063f <getuint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	52                   	push   %edx
  800a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 00 fb ff ff       	call   800588 <printnum>
  800a88:	83 c4 20             	add    $0x20,%esp
			break;
  800a8b:	eb 34                	jmp    800ac1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 25                	push   $0x25
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	eb 03                	jmp    800ab6 <vprintfmt+0x3b1>
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	48                   	dec    %eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	3c 25                	cmp    $0x25,%al
  800abe:	75 f3                	jne    800ab3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac0:	90                   	nop
		}
	}
  800ac1:	e9 47 fc ff ff       	jmp    80070d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800add:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 16 fc ff ff       	call   800705 <vprintfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 40 08             	mov    0x8(%eax),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 10                	mov    (%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 40 04             	mov    0x4(%eax),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	73 12                	jae    800b28 <sprintputch+0x33>
		*b->buf++ = ch;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 0a                	mov    %ecx,(%edx)
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	88 10                	mov    %dl,(%eax)
}
  800b28:	90                   	nop
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b50:	74 06                	je     800b58 <vsnprintf+0x2d>
  800b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b56:	7f 07                	jg     800b5f <vsnprintf+0x34>
		return -E_INVAL;
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	eb 20                	jmp    800b7f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5f:	ff 75 14             	pushl  0x14(%ebp)
  800b62:	ff 75 10             	pushl  0x10(%ebp)
  800b65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b68:	50                   	push   %eax
  800b69:	68 f5 0a 80 00       	push   $0x800af5
  800b6e:	e8 92 fb ff ff       	call   800705 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b87:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8a:	83 c0 04             	add    $0x4,%eax
  800b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	ff 75 f4             	pushl  -0xc(%ebp)
  800b96:	50                   	push   %eax
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 89 ff ff ff       	call   800b2b <vsnprintf>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bba:	eb 06                	jmp    800bc2 <strlen+0x15>
		n++;
  800bbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 f1                	jne    800bbc <strlen+0xf>
		n++;
	return n;
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdd:	eb 09                	jmp    800be8 <strnlen+0x18>
		n++;
  800bdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be2:	ff 45 08             	incl   0x8(%ebp)
  800be5:	ff 4d 0c             	decl   0xc(%ebp)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 09                	je     800bf7 <strnlen+0x27>
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 e8                	jne    800bdf <strnlen+0xf>
		n++;
	return n;
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c08:	90                   	nop
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1b:	8a 12                	mov    (%edx),%dl
  800c1d:	88 10                	mov    %dl,(%eax)
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 e4                	jne    800c09 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3d:	eb 1f                	jmp    800c5e <strncpy+0x34>
		*dst++ = *src;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	89 55 08             	mov    %edx,0x8(%ebp)
  800c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4b:	8a 12                	mov    (%edx),%dl
  800c4d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 03                	je     800c5b <strncpy+0x31>
			src++;
  800c58:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c64:	72 d9                	jb     800c3f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 30                	je     800cad <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7d:	eb 16                	jmp    800c95 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8d 50 01             	lea    0x1(%eax),%edx
  800c85:	89 55 08             	mov    %edx,0x8(%ebp)
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c95:	ff 4d 10             	decl   0x10(%ebp)
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 09                	je     800ca7 <strlcpy+0x3c>
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	75 d8                	jne    800c7f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb3:	29 c2                	sub    %eax,%edx
  800cb5:	89 d0                	mov    %edx,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbc:	eb 06                	jmp    800cc4 <strcmp+0xb>
		p++, q++;
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 0e                	je     800cdb <strcmp+0x22>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 10                	mov    (%eax),%dl
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	38 c2                	cmp    %al,%dl
  800cd9:	74 e3                	je     800cbe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d0             	movzbl %al,%edx
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 c0             	movzbl %al,%eax
  800ceb:	29 c2                	sub    %eax,%edx
  800ced:	89 d0                	mov    %edx,%eax
}
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf4:	eb 09                	jmp    800cff <strncmp+0xe>
		n--, p++, q++;
  800cf6:	ff 4d 10             	decl   0x10(%ebp)
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	74 17                	je     800d1c <strncmp+0x2b>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 0e                	je     800d1c <strncmp+0x2b>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 da                	je     800cf6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	75 07                	jne    800d29 <strncmp+0x38>
		return 0;
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	eb 14                	jmp    800d3d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 d0             	movzbl %al,%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 c0             	movzbl %al,%eax
  800d39:	29 c2                	sub    %eax,%edx
  800d3b:	89 d0                	mov    %edx,%eax
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4b:	eb 12                	jmp    800d5f <strchr+0x20>
		if (*s == c)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d55:	75 05                	jne    800d5c <strchr+0x1d>
			return (char *) s;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	eb 11                	jmp    800d6d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 e5                	jne    800d4d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7b:	eb 0d                	jmp    800d8a <strfind+0x1b>
		if (*s == c)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d85:	74 0e                	je     800d95 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 ea                	jne    800d7d <strfind+0xe>
  800d93:	eb 01                	jmp    800d96 <strfind+0x27>
		if (*s == c)
			break;
  800d95:	90                   	nop
	return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dad:	eb 0e                	jmp    800dbd <memset+0x22>
		*p++ = c;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbd:	ff 4d f8             	decl   -0x8(%ebp)
  800dc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc4:	79 e9                	jns    800daf <memset+0x14>
		*p++ = c;

	return v;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddd:	eb 16                	jmp    800df5 <memcpy+0x2a>
		*d++ = *s++;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 dd                	jne    800ddf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1f:	73 50                	jae    800e71 <memmove+0x6a>
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2c:	76 43                	jbe    800e71 <memmove+0x6a>
		s += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3a:	eb 10                	jmp    800e4c <memmove+0x45>
			*--d = *--s;
  800e3c:	ff 4d f8             	decl   -0x8(%ebp)
  800e3f:	ff 4d fc             	decl   -0x4(%ebp)
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 e3                	jne    800e3c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e59:	eb 23                	jmp    800e7e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e77:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	75 dd                	jne    800e5b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e95:	eb 2a                	jmp    800ec1 <memcmp+0x3e>
		if (*s1 != *s2)
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9a:	8a 10                	mov    (%eax),%dl
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	38 c2                	cmp    %al,%dl
  800ea3:	74 16                	je     800ebb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f b6 d0             	movzbl %al,%edx
  800ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 c0             	movzbl %al,%eax
  800eb5:	29 c2                	sub    %eax,%edx
  800eb7:	89 d0                	mov    %edx,%eax
  800eb9:	eb 18                	jmp    800ed3 <memcmp+0x50>
		s1++, s2++;
  800ebb:	ff 45 fc             	incl   -0x4(%ebp)
  800ebe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 c9                	jne    800e97 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee6:	eb 15                	jmp    800efd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 d0             	movzbl %al,%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	0f b6 c0             	movzbl %al,%eax
  800ef6:	39 c2                	cmp    %eax,%edx
  800ef8:	74 0d                	je     800f07 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f03:	72 e3                	jb     800ee8 <memfind+0x13>
  800f05:	eb 01                	jmp    800f08 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f07:	90                   	nop
	return (void *) s;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f21:	eb 03                	jmp    800f26 <strtol+0x19>
		s++;
  800f23:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 20                	cmp    $0x20,%al
  800f2d:	74 f4                	je     800f23 <strtol+0x16>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 09                	cmp    $0x9,%al
  800f36:	74 eb                	je     800f23 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 2b                	cmp    $0x2b,%al
  800f3f:	75 05                	jne    800f46 <strtol+0x39>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	eb 13                	jmp    800f59 <strtol+0x4c>
	else if (*s == '-')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 2d                	cmp    $0x2d,%al
  800f4d:	75 0a                	jne    800f59 <strtol+0x4c>
		s++, neg = 1;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5d:	74 06                	je     800f65 <strtol+0x58>
  800f5f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f63:	75 20                	jne    800f85 <strtol+0x78>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 30                	cmp    $0x30,%al
  800f6c:	75 17                	jne    800f85 <strtol+0x78>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	40                   	inc    %eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 78                	cmp    $0x78,%al
  800f76:	75 0d                	jne    800f85 <strtol+0x78>
		s += 2, base = 16;
  800f78:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f83:	eb 28                	jmp    800fad <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f89:	75 15                	jne    800fa0 <strtol+0x93>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 0c                	jne    800fa0 <strtol+0x93>
		s++, base = 8;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9e:	eb 0d                	jmp    800fad <strtol+0xa0>
	else if (base == 0)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	75 07                	jne    800fad <strtol+0xa0>
		base = 10;
  800fa6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 2f                	cmp    $0x2f,%al
  800fb4:	7e 19                	jle    800fcf <strtol+0xc2>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 39                	cmp    $0x39,%al
  800fbd:	7f 10                	jg     800fcf <strtol+0xc2>
			dig = *s - '0';
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f be c0             	movsbl %al,%eax
  800fc7:	83 e8 30             	sub    $0x30,%eax
  800fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcd:	eb 42                	jmp    801011 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 60                	cmp    $0x60,%al
  800fd6:	7e 19                	jle    800ff1 <strtol+0xe4>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 7a                	cmp    $0x7a,%al
  800fdf:	7f 10                	jg     800ff1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be c0             	movsbl %al,%eax
  800fe9:	83 e8 57             	sub    $0x57,%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fef:	eb 20                	jmp    801011 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 40                	cmp    $0x40,%al
  800ff8:	7e 39                	jle    801033 <strtol+0x126>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 5a                	cmp    $0x5a,%al
  801001:	7f 30                	jg     801033 <strtol+0x126>
			dig = *s - 'A' + 10;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 37             	sub    $0x37,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801014:	3b 45 10             	cmp    0x10(%ebp),%eax
  801017:	7d 19                	jge    801032 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801023:	89 c2                	mov    %eax,%edx
  801025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102d:	e9 7b ff ff ff       	jmp    800fad <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801032:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801037:	74 08                	je     801041 <strtol+0x134>
		*endptr = (char *) s;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801041:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801045:	74 07                	je     80104e <strtol+0x141>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	f7 d8                	neg    %eax
  80104c:	eb 03                	jmp    801051 <strtol+0x144>
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <ltostr>:

void
ltostr(long value, char *str)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801060:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106b:	79 13                	jns    801080 <ltostr+0x2d>
	{
		neg = 1;
  80106d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801088:	99                   	cltd   
  801089:	f7 f9                	idiv   %ecx
  80108b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801097:	89 c2                	mov    %eax,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a1:	83 c2 30             	add    $0x30,%edx
  8010a4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ae:	f7 e9                	imul   %ecx
  8010b0:	c1 fa 02             	sar    $0x2,%edx
  8010b3:	89 c8                	mov    %ecx,%eax
  8010b5:	c1 f8 1f             	sar    $0x1f,%eax
  8010b8:	29 c2                	sub    %eax,%edx
  8010ba:	89 d0                	mov    %edx,%eax
  8010bc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	c1 e0 02             	shl    $0x2,%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	01 c0                	add    %eax,%eax
  8010dc:	29 c1                	sub    %eax,%ecx
  8010de:	89 ca                	mov    %ecx,%edx
  8010e0:	85 d2                	test   %edx,%edx
  8010e2:	75 9c                	jne    801080 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ee:	48                   	dec    %eax
  8010ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 3d                	je     801135 <ltostr+0xe2>
		start = 1 ;
  8010f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ff:	eb 34                	jmp    801135 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c2                	add    %eax,%edx
  801116:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c8                	add    %ecx,%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 c2                	add    %eax,%edx
  80112a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112d:	88 02                	mov    %al,(%edx)
		start++ ;
  80112f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801132:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801138:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113b:	7c c4                	jl     801101 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801148:	90                   	nop
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801151:	ff 75 08             	pushl  0x8(%ebp)
  801154:	e8 54 fa ff ff       	call   800bad <strlen>
  801159:	83 c4 04             	add    $0x4,%esp
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 46 fa ff ff       	call   800bad <strlen>
  801167:	83 c4 04             	add    $0x4,%esp
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117b:	eb 17                	jmp    801194 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801191:	ff 45 fc             	incl   -0x4(%ebp)
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119a:	7c e1                	jl     80117d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011aa:	eb 1f                	jmp    8011cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8d 50 01             	lea    0x1(%eax),%edx
  8011b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d1:	7c d9                	jl     8011ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801204:	eb 0c                	jmp    801212 <strsplit+0x31>
			*string++ = 0;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 08             	mov    %edx,0x8(%ebp)
  80120f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 18                	je     801233 <strsplit+0x52>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f be c0             	movsbl %al,%eax
  801223:	50                   	push   %eax
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 13 fb ff ff       	call   800d3f <strchr>
  80122c:	83 c4 08             	add    $0x8,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 d3                	jne    801206 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	84 c0                	test   %al,%al
  80123a:	74 5a                	je     801296 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	83 f8 0f             	cmp    $0xf,%eax
  801244:	75 07                	jne    80124d <strsplit+0x6c>
		{
			return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 66                	jmp    8012b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 48 01             	lea    0x1(%eax),%ecx
  801255:	8b 55 14             	mov    0x14(%ebp),%edx
  801258:	89 0a                	mov    %ecx,(%edx)
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126b:	eb 03                	jmp    801270 <strsplit+0x8f>
			string++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	74 8b                	je     801204 <strsplit+0x23>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	50                   	push   %eax
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	e8 b5 fa ff ff       	call   800d3f <strchr>
  80128a:	83 c4 08             	add    $0x8,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	74 dc                	je     80126d <strsplit+0x8c>
			string++;
	}
  801291:	e9 6e ff ff ff       	jmp    801204 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801296:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 1f                	je     8012e3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012c4:	e8 1d 00 00 00       	call   8012e6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	68 50 3a 80 00       	push   $0x803a50
  8012d1:	e8 55 f2 ff ff       	call   80052b <cprintf>
  8012d6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d9:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e0:	00 00 00 
	}
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8012ec:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012f3:	00 00 00 
  8012f6:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012fd:	00 00 00 
  801300:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801307:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80130a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801311:	00 00 00 
  801314:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80131b:	00 00 00 
  80131e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801325:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801328:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80132f:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801332:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801339:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801348:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134d:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801352:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80135c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801361:	2d 00 10 00 00       	sub    $0x1000,%eax
  801366:	83 ec 04             	sub    $0x4,%esp
  801369:	6a 06                	push   $0x6
  80136b:	ff 75 f4             	pushl  -0xc(%ebp)
  80136e:	50                   	push   %eax
  80136f:	e8 ee 05 00 00       	call   801962 <sys_allocate_chunk>
  801374:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801377:	a1 20 41 80 00       	mov    0x804120,%eax
  80137c:	83 ec 0c             	sub    $0xc,%esp
  80137f:	50                   	push   %eax
  801380:	e8 63 0c 00 00       	call   801fe8 <initialize_MemBlocksList>
  801385:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801388:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80138d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801393:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80139a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139d:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ab:	89 c2                	mov    %eax,%edx
  8013ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b0:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8013b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8013bd:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c7:	8b 50 08             	mov    0x8(%eax),%edx
  8013ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cd:	01 d0                	add    %edx,%eax
  8013cf:	48                   	dec    %eax
  8013d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013db:	f7 75 e0             	divl   -0x20(%ebp)
  8013de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013e1:	29 d0                	sub    %edx,%eax
  8013e3:	89 c2                	mov    %eax,%edx
  8013e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e8:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8013eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8013ef:	75 14                	jne    801405 <initialize_dyn_block_system+0x11f>
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	68 75 3a 80 00       	push   $0x803a75
  8013f9:	6a 34                	push   $0x34
  8013fb:	68 93 3a 80 00       	push   $0x803a93
  801400:	e8 72 ee ff ff       	call   800277 <_panic>
  801405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801408:	8b 00                	mov    (%eax),%eax
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 10                	je     80141e <initialize_dyn_block_system+0x138>
  80140e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801411:	8b 00                	mov    (%eax),%eax
  801413:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801416:	8b 52 04             	mov    0x4(%edx),%edx
  801419:	89 50 04             	mov    %edx,0x4(%eax)
  80141c:	eb 0b                	jmp    801429 <initialize_dyn_block_system+0x143>
  80141e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801421:	8b 40 04             	mov    0x4(%eax),%eax
  801424:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801429:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80142c:	8b 40 04             	mov    0x4(%eax),%eax
  80142f:	85 c0                	test   %eax,%eax
  801431:	74 0f                	je     801442 <initialize_dyn_block_system+0x15c>
  801433:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801436:	8b 40 04             	mov    0x4(%eax),%eax
  801439:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80143c:	8b 12                	mov    (%edx),%edx
  80143e:	89 10                	mov    %edx,(%eax)
  801440:	eb 0a                	jmp    80144c <initialize_dyn_block_system+0x166>
  801442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801445:	8b 00                	mov    (%eax),%eax
  801447:	a3 48 41 80 00       	mov    %eax,0x804148
  80144c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801458:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80145f:	a1 54 41 80 00       	mov    0x804154,%eax
  801464:	48                   	dec    %eax
  801465:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  80146a:	83 ec 0c             	sub    $0xc,%esp
  80146d:	ff 75 e8             	pushl  -0x18(%ebp)
  801470:	e8 c4 13 00 00       	call   802839 <insert_sorted_with_merge_freeList>
  801475:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801478:	90                   	nop
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <malloc>:
//=================================



void* malloc(uint32 size)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801481:	e8 2f fe ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801486:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80148a:	75 07                	jne    801493 <malloc+0x18>
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
  801491:	eb 71                	jmp    801504 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801493:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80149a:	76 07                	jbe    8014a3 <malloc+0x28>
	return NULL;
  80149c:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a1:	eb 61                	jmp    801504 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014a3:	e8 88 08 00 00       	call   801d30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	74 53                	je     8014ff <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014ac:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	01 d0                	add    %edx,%eax
  8014bb:	48                   	dec    %eax
  8014bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c7:	f7 75 f4             	divl   -0xc(%ebp)
  8014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cd:	29 d0                	sub    %edx,%eax
  8014cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8014d2:	83 ec 0c             	sub    $0xc,%esp
  8014d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8014d8:	e8 d2 0d 00 00       	call   8022af <alloc_block_FF>
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8014e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014e7:	74 16                	je     8014ff <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8014e9:	83 ec 0c             	sub    $0xc,%esp
  8014ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ef:	e8 0c 0c 00 00       	call   802100 <insert_sorted_allocList>
  8014f4:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8014f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014fa:	8b 40 08             	mov    0x8(%eax),%eax
  8014fd:	eb 05                	jmp    801504 <malloc+0x89>
    }

			}


	return NULL;
  8014ff:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801515:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80151a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80151d:	83 ec 08             	sub    $0x8,%esp
  801520:	ff 75 f0             	pushl  -0x10(%ebp)
  801523:	68 40 40 80 00       	push   $0x804040
  801528:	e8 a0 0b 00 00       	call   8020cd <find_block>
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801536:	8b 50 0c             	mov    0xc(%eax),%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	52                   	push   %edx
  801540:	50                   	push   %eax
  801541:	e8 e4 03 00 00       	call   80192a <sys_free_user_mem>
  801546:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801549:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80154d:	75 17                	jne    801566 <free+0x60>
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	68 75 3a 80 00       	push   $0x803a75
  801557:	68 84 00 00 00       	push   $0x84
  80155c:	68 93 3a 80 00       	push   $0x803a93
  801561:	e8 11 ed ff ff       	call   800277 <_panic>
  801566:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801569:	8b 00                	mov    (%eax),%eax
  80156b:	85 c0                	test   %eax,%eax
  80156d:	74 10                	je     80157f <free+0x79>
  80156f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801572:	8b 00                	mov    (%eax),%eax
  801574:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801577:	8b 52 04             	mov    0x4(%edx),%edx
  80157a:	89 50 04             	mov    %edx,0x4(%eax)
  80157d:	eb 0b                	jmp    80158a <free+0x84>
  80157f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801582:	8b 40 04             	mov    0x4(%eax),%eax
  801585:	a3 44 40 80 00       	mov    %eax,0x804044
  80158a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158d:	8b 40 04             	mov    0x4(%eax),%eax
  801590:	85 c0                	test   %eax,%eax
  801592:	74 0f                	je     8015a3 <free+0x9d>
  801594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801597:	8b 40 04             	mov    0x4(%eax),%eax
  80159a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80159d:	8b 12                	mov    (%edx),%edx
  80159f:	89 10                	mov    %edx,(%eax)
  8015a1:	eb 0a                	jmp    8015ad <free+0xa7>
  8015a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	a3 40 40 80 00       	mov    %eax,0x804040
  8015ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015c5:	48                   	dec    %eax
  8015c6:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8015d1:	e8 63 12 00 00       	call   802839 <insert_sorted_with_merge_freeList>
  8015d6:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8015d9:	90                   	nop
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 38             	sub    $0x38,%esp
  8015e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e8:	e8 c8 fc ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015f1:	75 0a                	jne    8015fd <smalloc+0x21>
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f8:	e9 a0 00 00 00       	jmp    80169d <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8015fd:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801604:	76 0a                	jbe    801610 <smalloc+0x34>
		return NULL;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	e9 8d 00 00 00       	jmp    80169d <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801610:	e8 1b 07 00 00       	call   801d30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801615:	85 c0                	test   %eax,%eax
  801617:	74 7f                	je     801698 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801619:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	48                   	dec    %eax
  801629:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162f:	ba 00 00 00 00       	mov    $0x0,%edx
  801634:	f7 75 f4             	divl   -0xc(%ebp)
  801637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163a:	29 d0                	sub    %edx,%eax
  80163c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80163f:	83 ec 0c             	sub    $0xc,%esp
  801642:	ff 75 ec             	pushl  -0x14(%ebp)
  801645:	e8 65 0c 00 00       	call   8022af <alloc_block_FF>
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801650:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801654:	74 42                	je     801698 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 e8             	pushl  -0x18(%ebp)
  80165c:	e8 9f 0a 00 00       	call   802100 <insert_sorted_allocList>
  801661:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801667:	8b 40 08             	mov    0x8(%eax),%eax
  80166a:	89 c2                	mov    %eax,%edx
  80166c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801670:	52                   	push   %edx
  801671:	50                   	push   %eax
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 38 04 00 00       	call   801ab5 <sys_createSharedObject>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801683:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801687:	79 07                	jns    801690 <smalloc+0xb4>
	    		  return NULL;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
  80168e:	eb 0d                	jmp    80169d <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801693:	8b 40 08             	mov    0x8(%eax),%eax
  801696:	eb 05                	jmp    80169d <smalloc+0xc1>


				}


		return NULL;
  801698:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a5:	e8 0b fc ff ff       	call   8012b5 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016aa:	e8 81 06 00 00       	call   801d30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	0f 84 9f 00 00 00    	je     801756 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 1a 04 00 00       	call   801adf <sys_getSizeOfSharedObject>
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8016cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016cf:	79 0a                	jns    8016db <sget+0x3c>
		return NULL;
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d6:	e9 80 00 00 00       	jmp    80175b <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016db:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	48                   	dec    %eax
  8016eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f6:	f7 75 f0             	divl   -0x10(%ebp)
  8016f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fc:	29 d0                	sub    %edx,%eax
  8016fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801701:	83 ec 0c             	sub    $0xc,%esp
  801704:	ff 75 e8             	pushl  -0x18(%ebp)
  801707:	e8 a3 0b 00 00       	call   8022af <alloc_block_FF>
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801712:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801716:	74 3e                	je     801756 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801718:	83 ec 0c             	sub    $0xc,%esp
  80171b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80171e:	e8 dd 09 00 00       	call   802100 <insert_sorted_allocList>
  801723:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801729:	8b 40 08             	mov    0x8(%eax),%eax
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	50                   	push   %eax
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	e8 c1 03 00 00       	call   801afc <sys_getSharedObject>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801741:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801745:	79 07                	jns    80174e <sget+0xaf>
	    		  return NULL;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	eb 0d                	jmp    80175b <sget+0xbc>
	  	return(void*) returned_block->sva;
  80174e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801751:	8b 40 08             	mov    0x8(%eax),%eax
  801754:	eb 05                	jmp    80175b <sget+0xbc>
	      }
	}
	   return NULL;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801763:	e8 4d fb ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	68 a0 3a 80 00       	push   $0x803aa0
  801770:	68 12 01 00 00       	push   $0x112
  801775:	68 93 3a 80 00       	push   $0x803a93
  80177a:	e8 f8 ea ff ff       	call   800277 <_panic>

0080177f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 c8 3a 80 00       	push   $0x803ac8
  80178d:	68 26 01 00 00       	push   $0x126
  801792:	68 93 3a 80 00       	push   $0x803a93
  801797:	e8 db ea ff ff       	call   800277 <_panic>

0080179c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	68 ec 3a 80 00       	push   $0x803aec
  8017aa:	68 31 01 00 00       	push   $0x131
  8017af:	68 93 3a 80 00       	push   $0x803a93
  8017b4:	e8 be ea ff ff       	call   800277 <_panic>

008017b9 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 ec 3a 80 00       	push   $0x803aec
  8017c7:	68 36 01 00 00       	push   $0x136
  8017cc:	68 93 3a 80 00       	push   $0x803a93
  8017d1:	e8 a1 ea ff ff       	call   800277 <_panic>

008017d6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 ec 3a 80 00       	push   $0x803aec
  8017e4:	68 3b 01 00 00       	push   $0x13b
  8017e9:	68 93 3a 80 00       	push   $0x803a93
  8017ee:	e8 84 ea ff ff       	call   800277 <_panic>

008017f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801805:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801808:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180e:	cd 30                	int    $0x30
  801810:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5f                   	pop    %edi
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    

0080181e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	8b 45 10             	mov    0x10(%ebp),%eax
  801827:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80182a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	52                   	push   %edx
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	50                   	push   %eax
  80183a:	6a 00                	push   $0x0
  80183c:	e8 b2 ff ff ff       	call   8017f3 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_cgetc>:

int
sys_cgetc(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 01                	push   $0x1
  801856:	e8 98 ff ff ff       	call   8017f3 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	52                   	push   %edx
  801870:	50                   	push   %eax
  801871:	6a 05                	push   $0x5
  801873:	e8 7b ff ff ff       	call   8017f3 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801882:	8b 75 18             	mov    0x18(%ebp),%esi
  801885:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801888:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	56                   	push   %esi
  801892:	53                   	push   %ebx
  801893:	51                   	push   %ecx
  801894:	52                   	push   %edx
  801895:	50                   	push   %eax
  801896:	6a 06                	push   $0x6
  801898:	e8 56 ff ff ff       	call   8017f3 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a3:	5b                   	pop    %ebx
  8018a4:	5e                   	pop    %esi
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 07                	push   $0x7
  8018ba:	e8 34 ff ff ff       	call   8017f3 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	ff 75 0c             	pushl  0xc(%ebp)
  8018d0:	ff 75 08             	pushl  0x8(%ebp)
  8018d3:	6a 08                	push   $0x8
  8018d5:	e8 19 ff ff ff       	call   8017f3 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 09                	push   $0x9
  8018ee:	e8 00 ff ff ff       	call   8017f3 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 0a                	push   $0xa
  801907:	e8 e7 fe ff ff       	call   8017f3 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 0b                	push   $0xb
  801920:	e8 ce fe ff ff       	call   8017f3 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 0f                	push   $0xf
  80193b:	e8 b3 fe ff ff       	call   8017f3 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	ff 75 08             	pushl  0x8(%ebp)
  801955:	6a 10                	push   $0x10
  801957:	e8 97 fe ff ff       	call   8017f3 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return ;
  80195f:	90                   	nop
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 11                	push   $0x11
  801974:	e8 7a fe ff ff       	call   8017f3 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return ;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 0c                	push   $0xc
  80198e:	e8 60 fe ff ff       	call   8017f3 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 0d                	push   $0xd
  8019a8:	e8 46 fe ff ff       	call   8017f3 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 0e                	push   $0xe
  8019c1:	e8 2d fe ff ff       	call   8017f3 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 13                	push   $0x13
  8019db:	e8 13 fe ff ff       	call   8017f3 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	90                   	nop
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 14                	push   $0x14
  8019f5:	e8 f9 fd ff ff       	call   8017f3 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	50                   	push   %eax
  801a19:	6a 15                	push   $0x15
  801a1b:	e8 d3 fd ff ff       	call   8017f3 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 16                	push   $0x16
  801a35:	e8 b9 fd ff ff       	call   8017f3 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	50                   	push   %eax
  801a50:	6a 17                	push   $0x17
  801a52:	e8 9c fd ff ff       	call   8017f3 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	52                   	push   %edx
  801a6c:	50                   	push   %eax
  801a6d:	6a 1a                	push   $0x1a
  801a6f:	e8 7f fd ff ff       	call   8017f3 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 18                	push   $0x18
  801a8c:	e8 62 fd ff ff       	call   8017f3 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 19                	push   $0x19
  801aaa:	e8 44 fd ff ff       	call   8017f3 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	8b 45 10             	mov    0x10(%ebp),%eax
  801abe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	51                   	push   %ecx
  801ace:	52                   	push   %edx
  801acf:	ff 75 0c             	pushl  0xc(%ebp)
  801ad2:	50                   	push   %eax
  801ad3:	6a 1b                	push   $0x1b
  801ad5:	e8 19 fd ff ff       	call   8017f3 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 1c                	push   $0x1c
  801af2:	e8 fc fc ff ff       	call   8017f3 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	51                   	push   %ecx
  801b0d:	52                   	push   %edx
  801b0e:	50                   	push   %eax
  801b0f:	6a 1d                	push   $0x1d
  801b11:	e8 dd fc ff ff       	call   8017f3 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 1e                	push   $0x1e
  801b2e:	e8 c0 fc ff ff       	call   8017f3 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 1f                	push   $0x1f
  801b47:	e8 a7 fc ff ff       	call   8017f3 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	ff 75 14             	pushl  0x14(%ebp)
  801b5c:	ff 75 10             	pushl  0x10(%ebp)
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	50                   	push   %eax
  801b63:	6a 20                	push   $0x20
  801b65:	e8 89 fc ff ff       	call   8017f3 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	50                   	push   %eax
  801b7e:	6a 21                	push   $0x21
  801b80:	e8 6e fc ff ff       	call   8017f3 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	90                   	nop
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	50                   	push   %eax
  801b9a:	6a 22                	push   $0x22
  801b9c:	e8 52 fc ff ff       	call   8017f3 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 02                	push   $0x2
  801bb5:	e8 39 fc ff ff       	call   8017f3 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 03                	push   $0x3
  801bce:	e8 20 fc ff ff       	call   8017f3 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 04                	push   $0x4
  801be7:	e8 07 fc ff ff       	call   8017f3 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 23                	push   $0x23
  801c00:	e8 ee fb ff ff       	call   8017f3 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	90                   	nop
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c14:	8d 50 04             	lea    0x4(%eax),%edx
  801c17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	52                   	push   %edx
  801c21:	50                   	push   %eax
  801c22:	6a 24                	push   $0x24
  801c24:	e8 ca fb ff ff       	call   8017f3 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c35:	89 01                	mov    %eax,(%ecx)
  801c37:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	c9                   	leave  
  801c3e:	c2 04 00             	ret    $0x4

00801c41 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	ff 75 10             	pushl  0x10(%ebp)
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	6a 12                	push   $0x12
  801c53:	e8 9b fb ff ff       	call   8017f3 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5b:	90                   	nop
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 25                	push   $0x25
  801c6d:	e8 81 fb ff ff       	call   8017f3 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 04             	sub    $0x4,%esp
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c83:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	50                   	push   %eax
  801c90:	6a 26                	push   $0x26
  801c92:	e8 5c fb ff ff       	call   8017f3 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <rsttst>:
void rsttst()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 28                	push   $0x28
  801cac:	e8 42 fb ff ff       	call   8017f3 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb4:	90                   	nop
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc3:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cca:	52                   	push   %edx
  801ccb:	50                   	push   %eax
  801ccc:	ff 75 10             	pushl  0x10(%ebp)
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	6a 27                	push   $0x27
  801cd7:	e8 17 fb ff ff       	call   8017f3 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdf:	90                   	nop
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <chktst>:
void chktst(uint32 n)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	6a 29                	push   $0x29
  801cf2:	e8 fc fa ff ff       	call   8017f3 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfa:	90                   	nop
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <inctst>:

void inctst()
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 2a                	push   $0x2a
  801d0c:	e8 e2 fa ff ff       	call   8017f3 <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
	return ;
  801d14:	90                   	nop
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <gettst>:
uint32 gettst()
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 2b                	push   $0x2b
  801d26:	e8 c8 fa ff ff       	call   8017f3 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 2c                	push   $0x2c
  801d42:	e8 ac fa ff ff       	call   8017f3 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
  801d4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d4d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d51:	75 07                	jne    801d5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d53:	b8 01 00 00 00       	mov    $0x1,%eax
  801d58:	eb 05                	jmp    801d5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 2c                	push   $0x2c
  801d73:	e8 7b fa ff ff       	call   8017f3 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
  801d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d82:	75 07                	jne    801d8b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d84:	b8 01 00 00 00       	mov    $0x1,%eax
  801d89:	eb 05                	jmp    801d90 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 2c                	push   $0x2c
  801da4:	e8 4a fa ff ff       	call   8017f3 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
  801dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801daf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db3:	75 07                	jne    801dbc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dba:	eb 05                	jmp    801dc1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 2c                	push   $0x2c
  801dd5:	e8 19 fa ff ff       	call   8017f3 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
  801ddd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de4:	75 07                	jne    801ded <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	eb 05                	jmp    801df2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	6a 2d                	push   $0x2d
  801e04:	e8 ea f9 ff ff       	call   8017f3 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0c:	90                   	nop
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e16:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	6a 00                	push   $0x0
  801e21:	53                   	push   %ebx
  801e22:	51                   	push   %ecx
  801e23:	52                   	push   %edx
  801e24:	50                   	push   %eax
  801e25:	6a 2e                	push   $0x2e
  801e27:	e8 c7 f9 ff ff       	call   8017f3 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	52                   	push   %edx
  801e44:	50                   	push   %eax
  801e45:	6a 2f                	push   $0x2f
  801e47:	e8 a7 f9 ff ff       	call   8017f3 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e57:	83 ec 0c             	sub    $0xc,%esp
  801e5a:	68 fc 3a 80 00       	push   $0x803afc
  801e5f:	e8 c7 e6 ff ff       	call   80052b <cprintf>
  801e64:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e6e:	83 ec 0c             	sub    $0xc,%esp
  801e71:	68 28 3b 80 00       	push   $0x803b28
  801e76:	e8 b0 e6 ff ff       	call   80052b <cprintf>
  801e7b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e7e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e82:	a1 38 41 80 00       	mov    0x804138,%eax
  801e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8a:	eb 56                	jmp    801ee2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e90:	74 1c                	je     801eae <print_mem_block_lists+0x5d>
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 50 08             	mov    0x8(%eax),%edx
  801e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9b:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea4:	01 c8                	add    %ecx,%eax
  801ea6:	39 c2                	cmp    %eax,%edx
  801ea8:	73 04                	jae    801eae <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eaa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	8b 50 08             	mov    0x8(%eax),%edx
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eba:	01 c2                	add    %eax,%edx
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	8b 40 08             	mov    0x8(%eax),%eax
  801ec2:	83 ec 04             	sub    $0x4,%esp
  801ec5:	52                   	push   %edx
  801ec6:	50                   	push   %eax
  801ec7:	68 3d 3b 80 00       	push   $0x803b3d
  801ecc:	e8 5a e6 ff ff       	call   80052b <cprintf>
  801ed1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eda:	a1 40 41 80 00       	mov    0x804140,%eax
  801edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee6:	74 07                	je     801eef <print_mem_block_lists+0x9e>
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 00                	mov    (%eax),%eax
  801eed:	eb 05                	jmp    801ef4 <print_mem_block_lists+0xa3>
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	a3 40 41 80 00       	mov    %eax,0x804140
  801ef9:	a1 40 41 80 00       	mov    0x804140,%eax
  801efe:	85 c0                	test   %eax,%eax
  801f00:	75 8a                	jne    801e8c <print_mem_block_lists+0x3b>
  801f02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f06:	75 84                	jne    801e8c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f08:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0c:	75 10                	jne    801f1e <print_mem_block_lists+0xcd>
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	68 4c 3b 80 00       	push   $0x803b4c
  801f16:	e8 10 e6 ff ff       	call   80052b <cprintf>
  801f1b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f1e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	68 70 3b 80 00       	push   $0x803b70
  801f2d:	e8 f9 e5 ff ff       	call   80052b <cprintf>
  801f32:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f35:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f39:	a1 40 40 80 00       	mov    0x804040,%eax
  801f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f41:	eb 56                	jmp    801f99 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f47:	74 1c                	je     801f65 <print_mem_block_lists+0x114>
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4c:	8b 50 08             	mov    0x8(%eax),%edx
  801f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f52:	8b 48 08             	mov    0x8(%eax),%ecx
  801f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f58:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5b:	01 c8                	add    %ecx,%eax
  801f5d:	39 c2                	cmp    %eax,%edx
  801f5f:	73 04                	jae    801f65 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f61:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 50 08             	mov    0x8(%eax),%edx
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f71:	01 c2                	add    %eax,%edx
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 40 08             	mov    0x8(%eax),%eax
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	68 3d 3b 80 00       	push   $0x803b3d
  801f83:	e8 a3 e5 ff ff       	call   80052b <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f91:	a1 48 40 80 00       	mov    0x804048,%eax
  801f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9d:	74 07                	je     801fa6 <print_mem_block_lists+0x155>
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	8b 00                	mov    (%eax),%eax
  801fa4:	eb 05                	jmp    801fab <print_mem_block_lists+0x15a>
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fab:	a3 48 40 80 00       	mov    %eax,0x804048
  801fb0:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	75 8a                	jne    801f43 <print_mem_block_lists+0xf2>
  801fb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbd:	75 84                	jne    801f43 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fbf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc3:	75 10                	jne    801fd5 <print_mem_block_lists+0x184>
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	68 88 3b 80 00       	push   $0x803b88
  801fcd:	e8 59 e5 ff ff       	call   80052b <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	68 fc 3a 80 00       	push   $0x803afc
  801fdd:	e8 49 e5 ff ff       	call   80052b <cprintf>
  801fe2:	83 c4 10             	add    $0x10,%esp

}
  801fe5:	90                   	nop
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801fee:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ff5:	00 00 00 
  801ff8:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fff:	00 00 00 
  802002:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802009:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80200c:	a1 50 40 80 00       	mov    0x804050,%eax
  802011:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80201b:	e9 9e 00 00 00       	jmp    8020be <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802020:	a1 50 40 80 00       	mov    0x804050,%eax
  802025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802028:	c1 e2 04             	shl    $0x4,%edx
  80202b:	01 d0                	add    %edx,%eax
  80202d:	85 c0                	test   %eax,%eax
  80202f:	75 14                	jne    802045 <initialize_MemBlocksList+0x5d>
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	68 b0 3b 80 00       	push   $0x803bb0
  802039:	6a 48                	push   $0x48
  80203b:	68 d3 3b 80 00       	push   $0x803bd3
  802040:	e8 32 e2 ff ff       	call   800277 <_panic>
  802045:	a1 50 40 80 00       	mov    0x804050,%eax
  80204a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204d:	c1 e2 04             	shl    $0x4,%edx
  802050:	01 d0                	add    %edx,%eax
  802052:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802058:	89 10                	mov    %edx,(%eax)
  80205a:	8b 00                	mov    (%eax),%eax
  80205c:	85 c0                	test   %eax,%eax
  80205e:	74 18                	je     802078 <initialize_MemBlocksList+0x90>
  802060:	a1 48 41 80 00       	mov    0x804148,%eax
  802065:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80206b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80206e:	c1 e1 04             	shl    $0x4,%ecx
  802071:	01 ca                	add    %ecx,%edx
  802073:	89 50 04             	mov    %edx,0x4(%eax)
  802076:	eb 12                	jmp    80208a <initialize_MemBlocksList+0xa2>
  802078:	a1 50 40 80 00       	mov    0x804050,%eax
  80207d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802080:	c1 e2 04             	shl    $0x4,%edx
  802083:	01 d0                	add    %edx,%eax
  802085:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80208a:	a1 50 40 80 00       	mov    0x804050,%eax
  80208f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802092:	c1 e2 04             	shl    $0x4,%edx
  802095:	01 d0                	add    %edx,%eax
  802097:	a3 48 41 80 00       	mov    %eax,0x804148
  80209c:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a4:	c1 e2 04             	shl    $0x4,%edx
  8020a7:	01 d0                	add    %edx,%eax
  8020a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b0:	a1 54 41 80 00       	mov    0x804154,%eax
  8020b5:	40                   	inc    %eax
  8020b6:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8020bb:	ff 45 f4             	incl   -0xc(%ebp)
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c4:	0f 82 56 ff ff ff    	jb     802020 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8020ca:	90                   	nop
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	8b 00                	mov    (%eax),%eax
  8020d8:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8020db:	eb 18                	jmp    8020f5 <find_block+0x28>
		{
			if(tmp->sva==va)
  8020dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e0:	8b 40 08             	mov    0x8(%eax),%eax
  8020e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020e6:	75 05                	jne    8020ed <find_block+0x20>
			{
				return tmp;
  8020e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020eb:	eb 11                	jmp    8020fe <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8020ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f0:	8b 00                	mov    (%eax),%eax
  8020f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8020f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f9:	75 e2                	jne    8020dd <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8020fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802106:	a1 40 40 80 00       	mov    0x804040,%eax
  80210b:	85 c0                	test   %eax,%eax
  80210d:	0f 85 83 00 00 00    	jne    802196 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802113:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80211a:	00 00 00 
  80211d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  802124:	00 00 00 
  802127:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80212e:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802135:	75 14                	jne    80214b <insert_sorted_allocList+0x4b>
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	68 b0 3b 80 00       	push   $0x803bb0
  80213f:	6a 7f                	push   $0x7f
  802141:	68 d3 3b 80 00       	push   $0x803bd3
  802146:	e8 2c e1 ff ff       	call   800277 <_panic>
  80214b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	89 10                	mov    %edx,(%eax)
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	8b 00                	mov    (%eax),%eax
  80215b:	85 c0                	test   %eax,%eax
  80215d:	74 0d                	je     80216c <insert_sorted_allocList+0x6c>
  80215f:	a1 40 40 80 00       	mov    0x804040,%eax
  802164:	8b 55 08             	mov    0x8(%ebp),%edx
  802167:	89 50 04             	mov    %edx,0x4(%eax)
  80216a:	eb 08                	jmp    802174 <insert_sorted_allocList+0x74>
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	a3 44 40 80 00       	mov    %eax,0x804044
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	a3 40 40 80 00       	mov    %eax,0x804040
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802186:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80218b:	40                   	inc    %eax
  80218c:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802191:	e9 16 01 00 00       	jmp    8022ac <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	8b 50 08             	mov    0x8(%eax),%edx
  80219c:	a1 44 40 80 00       	mov    0x804044,%eax
  8021a1:	8b 40 08             	mov    0x8(%eax),%eax
  8021a4:	39 c2                	cmp    %eax,%edx
  8021a6:	76 68                	jbe    802210 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ac:	75 17                	jne    8021c5 <insert_sorted_allocList+0xc5>
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 ec 3b 80 00       	push   $0x803bec
  8021b6:	68 85 00 00 00       	push   $0x85
  8021bb:	68 d3 3b 80 00       	push   $0x803bd3
  8021c0:	e8 b2 e0 ff ff       	call   800277 <_panic>
  8021c5:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	89 50 04             	mov    %edx,0x4(%eax)
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8b 40 04             	mov    0x4(%eax),%eax
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	74 0c                	je     8021e7 <insert_sorted_allocList+0xe7>
  8021db:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e3:	89 10                	mov    %edx,(%eax)
  8021e5:	eb 08                	jmp    8021ef <insert_sorted_allocList+0xef>
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	a3 40 40 80 00       	mov    %eax,0x804040
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	a3 44 40 80 00       	mov    %eax,0x804044
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802200:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802205:	40                   	inc    %eax
  802206:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80220b:	e9 9c 00 00 00       	jmp    8022ac <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802210:	a1 40 40 80 00       	mov    0x804040,%eax
  802215:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802218:	e9 85 00 00 00       	jmp    8022a2 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	8b 50 08             	mov    0x8(%eax),%edx
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	8b 40 08             	mov    0x8(%eax),%eax
  802229:	39 c2                	cmp    %eax,%edx
  80222b:	73 6d                	jae    80229a <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80222d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802231:	74 06                	je     802239 <insert_sorted_allocList+0x139>
  802233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802237:	75 17                	jne    802250 <insert_sorted_allocList+0x150>
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	68 10 3c 80 00       	push   $0x803c10
  802241:	68 90 00 00 00       	push   $0x90
  802246:	68 d3 3b 80 00       	push   $0x803bd3
  80224b:	e8 27 e0 ff ff       	call   800277 <_panic>
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 50 04             	mov    0x4(%eax),%edx
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	89 50 04             	mov    %edx,0x4(%eax)
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802262:	89 10                	mov    %edx,(%eax)
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 40 04             	mov    0x4(%eax),%eax
  80226a:	85 c0                	test   %eax,%eax
  80226c:	74 0d                	je     80227b <insert_sorted_allocList+0x17b>
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	8b 40 04             	mov    0x4(%eax),%eax
  802274:	8b 55 08             	mov    0x8(%ebp),%edx
  802277:	89 10                	mov    %edx,(%eax)
  802279:	eb 08                	jmp    802283 <insert_sorted_allocList+0x183>
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	a3 40 40 80 00       	mov    %eax,0x804040
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8b 55 08             	mov    0x8(%ebp),%edx
  802289:	89 50 04             	mov    %edx,0x4(%eax)
  80228c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802291:	40                   	inc    %eax
  802292:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802297:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802298:	eb 12                	jmp    8022ac <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 00                	mov    (%eax),%eax
  80229f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a6:	0f 85 71 ff ff ff    	jne    80221d <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022ac:	90                   	nop
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8022b5:	a1 38 41 80 00       	mov    0x804138,%eax
  8022ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8022bd:	e9 76 01 00 00       	jmp    802438 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022cb:	0f 85 8a 00 00 00    	jne    80235b <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8022d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d5:	75 17                	jne    8022ee <alloc_block_FF+0x3f>
  8022d7:	83 ec 04             	sub    $0x4,%esp
  8022da:	68 45 3c 80 00       	push   $0x803c45
  8022df:	68 a8 00 00 00       	push   $0xa8
  8022e4:	68 d3 3b 80 00       	push   $0x803bd3
  8022e9:	e8 89 df ff ff       	call   800277 <_panic>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 00                	mov    (%eax),%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 10                	je     802307 <alloc_block_FF+0x58>
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ff:	8b 52 04             	mov    0x4(%edx),%edx
  802302:	89 50 04             	mov    %edx,0x4(%eax)
  802305:	eb 0b                	jmp    802312 <alloc_block_FF+0x63>
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 40 04             	mov    0x4(%eax),%eax
  80230d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 40 04             	mov    0x4(%eax),%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	74 0f                	je     80232b <alloc_block_FF+0x7c>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 04             	mov    0x4(%eax),%eax
  802322:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802325:	8b 12                	mov    (%edx),%edx
  802327:	89 10                	mov    %edx,(%eax)
  802329:	eb 0a                	jmp    802335 <alloc_block_FF+0x86>
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 00                	mov    (%eax),%eax
  802330:	a3 38 41 80 00       	mov    %eax,0x804138
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802348:	a1 44 41 80 00       	mov    0x804144,%eax
  80234d:	48                   	dec    %eax
  80234e:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	e9 ea 00 00 00       	jmp    802445 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 40 0c             	mov    0xc(%eax),%eax
  802361:	3b 45 08             	cmp    0x8(%ebp),%eax
  802364:	0f 86 c6 00 00 00    	jbe    802430 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80236a:	a1 48 41 80 00       	mov    0x804148,%eax
  80236f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802375:	8b 55 08             	mov    0x8(%ebp),%edx
  802378:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 50 08             	mov    0x8(%eax),%edx
  802381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802384:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 0c             	mov    0xc(%eax),%eax
  80238d:	2b 45 08             	sub    0x8(%ebp),%eax
  802390:	89 c2                	mov    %eax,%edx
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 50 08             	mov    0x8(%eax),%edx
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	01 c2                	add    %eax,%edx
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ad:	75 17                	jne    8023c6 <alloc_block_FF+0x117>
  8023af:	83 ec 04             	sub    $0x4,%esp
  8023b2:	68 45 3c 80 00       	push   $0x803c45
  8023b7:	68 b6 00 00 00       	push   $0xb6
  8023bc:	68 d3 3b 80 00       	push   $0x803bd3
  8023c1:	e8 b1 de ff ff       	call   800277 <_panic>
  8023c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	74 10                	je     8023df <alloc_block_FF+0x130>
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d7:	8b 52 04             	mov    0x4(%edx),%edx
  8023da:	89 50 04             	mov    %edx,0x4(%eax)
  8023dd:	eb 0b                	jmp    8023ea <alloc_block_FF+0x13b>
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e2:	8b 40 04             	mov    0x4(%eax),%eax
  8023e5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ed:	8b 40 04             	mov    0x4(%eax),%eax
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	74 0f                	je     802403 <alloc_block_FF+0x154>
  8023f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f7:	8b 40 04             	mov    0x4(%eax),%eax
  8023fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fd:	8b 12                	mov    (%edx),%edx
  8023ff:	89 10                	mov    %edx,(%eax)
  802401:	eb 0a                	jmp    80240d <alloc_block_FF+0x15e>
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	8b 00                	mov    (%eax),%eax
  802408:	a3 48 41 80 00       	mov    %eax,0x804148
  80240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802419:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802420:	a1 54 41 80 00       	mov    0x804154,%eax
  802425:	48                   	dec    %eax
  802426:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80242b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242e:	eb 15                	jmp    802445 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243c:	0f 85 80 fe ff ff    	jne    8022c2 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80244d:	a1 38 41 80 00       	mov    0x804138,%eax
  802452:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802455:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80245c:	e9 c0 00 00 00       	jmp    802521 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 40 0c             	mov    0xc(%eax),%eax
  802467:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246a:	0f 85 8a 00 00 00    	jne    8024fa <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802474:	75 17                	jne    80248d <alloc_block_BF+0x46>
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	68 45 3c 80 00       	push   $0x803c45
  80247e:	68 cf 00 00 00       	push   $0xcf
  802483:	68 d3 3b 80 00       	push   $0x803bd3
  802488:	e8 ea dd ff ff       	call   800277 <_panic>
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 00                	mov    (%eax),%eax
  802492:	85 c0                	test   %eax,%eax
  802494:	74 10                	je     8024a6 <alloc_block_BF+0x5f>
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 00                	mov    (%eax),%eax
  80249b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249e:	8b 52 04             	mov    0x4(%edx),%edx
  8024a1:	89 50 04             	mov    %edx,0x4(%eax)
  8024a4:	eb 0b                	jmp    8024b1 <alloc_block_BF+0x6a>
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	74 0f                	je     8024ca <alloc_block_BF+0x83>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 04             	mov    0x4(%eax),%eax
  8024c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c4:	8b 12                	mov    (%edx),%edx
  8024c6:	89 10                	mov    %edx,(%eax)
  8024c8:	eb 0a                	jmp    8024d4 <alloc_block_BF+0x8d>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	a3 38 41 80 00       	mov    %eax,0x804138
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e7:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ec:	48                   	dec    %eax
  8024ed:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	e9 2a 01 00 00       	jmp    802624 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802500:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802503:	73 14                	jae    802519 <alloc_block_BF+0xd2>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 0c             	mov    0xc(%eax),%eax
  80250b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250e:	76 09                	jbe    802519 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 40 0c             	mov    0xc(%eax),%eax
  802516:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802525:	0f 85 36 ff ff ff    	jne    802461 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80252b:	a1 38 41 80 00       	mov    0x804138,%eax
  802530:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802533:	e9 dd 00 00 00       	jmp    802615 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 40 0c             	mov    0xc(%eax),%eax
  80253e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802541:	0f 85 c6 00 00 00    	jne    80260d <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802547:	a1 48 41 80 00       	mov    0x804148,%eax
  80254c:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 50 08             	mov    0x8(%eax),%edx
  802555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802558:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80255b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255e:	8b 55 08             	mov    0x8(%ebp),%edx
  802561:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 50 08             	mov    0x8(%eax),%edx
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	01 c2                	add    %eax,%edx
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 0c             	mov    0xc(%eax),%eax
  80257b:	2b 45 08             	sub    0x8(%ebp),%eax
  80257e:	89 c2                	mov    %eax,%edx
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802586:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80258a:	75 17                	jne    8025a3 <alloc_block_BF+0x15c>
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 45 3c 80 00       	push   $0x803c45
  802594:	68 eb 00 00 00       	push   $0xeb
  802599:	68 d3 3b 80 00       	push   $0x803bd3
  80259e:	e8 d4 dc ff ff       	call   800277 <_panic>
  8025a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 10                	je     8025bc <alloc_block_BF+0x175>
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b4:	8b 52 04             	mov    0x4(%edx),%edx
  8025b7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ba:	eb 0b                	jmp    8025c7 <alloc_block_BF+0x180>
  8025bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	74 0f                	je     8025e0 <alloc_block_BF+0x199>
  8025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025da:	8b 12                	mov    (%edx),%edx
  8025dc:	89 10                	mov    %edx,(%eax)
  8025de:	eb 0a                	jmp    8025ea <alloc_block_BF+0x1a3>
  8025e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	a3 48 41 80 00       	mov    %eax,0x804148
  8025ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fd:	a1 54 41 80 00       	mov    0x804154,%eax
  802602:	48                   	dec    %eax
  802603:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802608:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260b:	eb 17                	jmp    802624 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	0f 85 19 ff ff ff    	jne    802538 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80262c:	a1 40 40 80 00       	mov    0x804040,%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	75 19                	jne    80264e <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	ff 75 08             	pushl  0x8(%ebp)
  80263b:	e8 6f fc ff ff       	call   8022af <alloc_block_FF>
  802640:	83 c4 10             	add    $0x10,%esp
  802643:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	e9 e9 01 00 00       	jmp    802837 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80264e:	a1 44 40 80 00       	mov    0x804044,%eax
  802653:	8b 40 08             	mov    0x8(%eax),%eax
  802656:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802659:	a1 44 40 80 00       	mov    0x804044,%eax
  80265e:	8b 50 0c             	mov    0xc(%eax),%edx
  802661:	a1 44 40 80 00       	mov    0x804044,%eax
  802666:	8b 40 08             	mov    0x8(%eax),%eax
  802669:	01 d0                	add    %edx,%eax
  80266b:	83 ec 08             	sub    $0x8,%esp
  80266e:	50                   	push   %eax
  80266f:	68 38 41 80 00       	push   $0x804138
  802674:	e8 54 fa ff ff       	call   8020cd <find_block>
  802679:	83 c4 10             	add    $0x10,%esp
  80267c:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 40 0c             	mov    0xc(%eax),%eax
  802685:	3b 45 08             	cmp    0x8(%ebp),%eax
  802688:	0f 85 9b 00 00 00    	jne    802729 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 50 0c             	mov    0xc(%eax),%edx
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 40 08             	mov    0x8(%eax),%eax
  80269a:	01 d0                	add    %edx,%eax
  80269c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  80269f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a3:	75 17                	jne    8026bc <alloc_block_NF+0x96>
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 45 3c 80 00       	push   $0x803c45
  8026ad:	68 1a 01 00 00       	push   $0x11a
  8026b2:	68 d3 3b 80 00       	push   $0x803bd3
  8026b7:	e8 bb db ff ff       	call   800277 <_panic>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 10                	je     8026d5 <alloc_block_NF+0xaf>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	8b 52 04             	mov    0x4(%edx),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	eb 0b                	jmp    8026e0 <alloc_block_NF+0xba>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 0f                	je     8026f9 <alloc_block_NF+0xd3>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f3:	8b 12                	mov    (%edx),%edx
  8026f5:	89 10                	mov    %edx,(%eax)
  8026f7:	eb 0a                	jmp    802703 <alloc_block_NF+0xdd>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	a3 38 41 80 00       	mov    %eax,0x804138
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802716:	a1 44 41 80 00       	mov    0x804144,%eax
  80271b:	48                   	dec    %eax
  80271c:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	e9 0e 01 00 00       	jmp    802837 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 0c             	mov    0xc(%eax),%eax
  80272f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802732:	0f 86 cf 00 00 00    	jbe    802807 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802738:	a1 48 41 80 00       	mov    0x804148,%eax
  80273d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802743:	8b 55 08             	mov    0x8(%ebp),%edx
  802746:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 50 08             	mov    0x8(%eax),%edx
  80274f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802752:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 50 08             	mov    0x8(%eax),%edx
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	01 c2                	add    %eax,%edx
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 0c             	mov    0xc(%eax),%eax
  80276c:	2b 45 08             	sub    0x8(%ebp),%eax
  80276f:	89 c2                	mov    %eax,%edx
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 08             	mov    0x8(%eax),%eax
  80277d:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802780:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802784:	75 17                	jne    80279d <alloc_block_NF+0x177>
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	68 45 3c 80 00       	push   $0x803c45
  80278e:	68 28 01 00 00       	push   $0x128
  802793:	68 d3 3b 80 00       	push   $0x803bd3
  802798:	e8 da da ff ff       	call   800277 <_panic>
  80279d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 10                	je     8027b6 <alloc_block_NF+0x190>
  8027a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ae:	8b 52 04             	mov    0x4(%edx),%edx
  8027b1:	89 50 04             	mov    %edx,0x4(%eax)
  8027b4:	eb 0b                	jmp    8027c1 <alloc_block_NF+0x19b>
  8027b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 0f                	je     8027da <alloc_block_NF+0x1b4>
  8027cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027d4:	8b 12                	mov    (%edx),%edx
  8027d6:	89 10                	mov    %edx,(%eax)
  8027d8:	eb 0a                	jmp    8027e4 <alloc_block_NF+0x1be>
  8027da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	a3 48 41 80 00       	mov    %eax,0x804148
  8027e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8027fc:	48                   	dec    %eax
  8027fd:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802805:	eb 30                	jmp    802837 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802807:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80280c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80280f:	75 0a                	jne    80281b <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802811:	a1 38 41 80 00       	mov    0x804138,%eax
  802816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802819:	eb 08                	jmp    802823 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 40 08             	mov    0x8(%eax),%eax
  802829:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80282c:	0f 85 4d fe ff ff    	jne    80267f <alloc_block_NF+0x59>

			return NULL;
  802832:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	53                   	push   %ebx
  80283d:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802840:	a1 38 41 80 00       	mov    0x804138,%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	0f 85 86 00 00 00    	jne    8028d3 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80284d:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802854:	00 00 00 
  802857:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80285e:	00 00 00 
  802861:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802868:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80286b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80286f:	75 17                	jne    802888 <insert_sorted_with_merge_freeList+0x4f>
  802871:	83 ec 04             	sub    $0x4,%esp
  802874:	68 b0 3b 80 00       	push   $0x803bb0
  802879:	68 48 01 00 00       	push   $0x148
  80287e:	68 d3 3b 80 00       	push   $0x803bd3
  802883:	e8 ef d9 ff ff       	call   800277 <_panic>
  802888:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	89 10                	mov    %edx,(%eax)
  802893:	8b 45 08             	mov    0x8(%ebp),%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 0d                	je     8028a9 <insert_sorted_with_merge_freeList+0x70>
  80289c:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	eb 08                	jmp    8028b1 <insert_sorted_with_merge_freeList+0x78>
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	a3 38 41 80 00       	mov    %eax,0x804138
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c3:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c8:	40                   	inc    %eax
  8028c9:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8028ce:	e9 73 07 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	8b 50 08             	mov    0x8(%eax),%edx
  8028d9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028de:	8b 40 08             	mov    0x8(%eax),%eax
  8028e1:	39 c2                	cmp    %eax,%edx
  8028e3:	0f 86 84 00 00 00    	jbe    80296d <insert_sorted_with_merge_freeList+0x134>
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	8b 50 08             	mov    0x8(%eax),%edx
  8028ef:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028f4:	8b 48 0c             	mov    0xc(%eax),%ecx
  8028f7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028fc:	8b 40 08             	mov    0x8(%eax),%eax
  8028ff:	01 c8                	add    %ecx,%eax
  802901:	39 c2                	cmp    %eax,%edx
  802903:	74 68                	je     80296d <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802909:	75 17                	jne    802922 <insert_sorted_with_merge_freeList+0xe9>
  80290b:	83 ec 04             	sub    $0x4,%esp
  80290e:	68 ec 3b 80 00       	push   $0x803bec
  802913:	68 4c 01 00 00       	push   $0x14c
  802918:	68 d3 3b 80 00       	push   $0x803bd3
  80291d:	e8 55 d9 ff ff       	call   800277 <_panic>
  802922:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	89 50 04             	mov    %edx,0x4(%eax)
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	74 0c                	je     802944 <insert_sorted_with_merge_freeList+0x10b>
  802938:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80293d:	8b 55 08             	mov    0x8(%ebp),%edx
  802940:	89 10                	mov    %edx,(%eax)
  802942:	eb 08                	jmp    80294c <insert_sorted_with_merge_freeList+0x113>
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	a3 38 41 80 00       	mov    %eax,0x804138
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295d:	a1 44 41 80 00       	mov    0x804144,%eax
  802962:	40                   	inc    %eax
  802963:	a3 44 41 80 00       	mov    %eax,0x804144
  802968:	e9 d9 06 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	8b 50 08             	mov    0x8(%eax),%edx
  802973:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802978:	8b 40 08             	mov    0x8(%eax),%eax
  80297b:	39 c2                	cmp    %eax,%edx
  80297d:	0f 86 b5 00 00 00    	jbe    802a38 <insert_sorted_with_merge_freeList+0x1ff>
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	8b 50 08             	mov    0x8(%eax),%edx
  802989:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80298e:	8b 48 0c             	mov    0xc(%eax),%ecx
  802991:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802996:	8b 40 08             	mov    0x8(%eax),%eax
  802999:	01 c8                	add    %ecx,%eax
  80299b:	39 c2                	cmp    %eax,%edx
  80299d:	0f 85 95 00 00 00    	jne    802a38 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029a3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029a8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029ae:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b4:	8b 52 0c             	mov    0xc(%edx),%edx
  8029b7:	01 ca                	add    %ecx,%edx
  8029b9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d4:	75 17                	jne    8029ed <insert_sorted_with_merge_freeList+0x1b4>
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	68 b0 3b 80 00       	push   $0x803bb0
  8029de:	68 54 01 00 00       	push   $0x154
  8029e3:	68 d3 3b 80 00       	push   $0x803bd3
  8029e8:	e8 8a d8 ff ff       	call   800277 <_panic>
  8029ed:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	89 10                	mov    %edx,(%eax)
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	74 0d                	je     802a0e <insert_sorted_with_merge_freeList+0x1d5>
  802a01:	a1 48 41 80 00       	mov    0x804148,%eax
  802a06:	8b 55 08             	mov    0x8(%ebp),%edx
  802a09:	89 50 04             	mov    %edx,0x4(%eax)
  802a0c:	eb 08                	jmp    802a16 <insert_sorted_with_merge_freeList+0x1dd>
  802a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a11:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	a3 48 41 80 00       	mov    %eax,0x804148
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a28:	a1 54 41 80 00       	mov    0x804154,%eax
  802a2d:	40                   	inc    %eax
  802a2e:	a3 54 41 80 00       	mov    %eax,0x804154
  802a33:	e9 0e 06 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	8b 50 08             	mov    0x8(%eax),%edx
  802a3e:	a1 38 41 80 00       	mov    0x804138,%eax
  802a43:	8b 40 08             	mov    0x8(%eax),%eax
  802a46:	39 c2                	cmp    %eax,%edx
  802a48:	0f 83 c1 00 00 00    	jae    802b0f <insert_sorted_with_merge_freeList+0x2d6>
  802a4e:	a1 38 41 80 00       	mov    0x804138,%eax
  802a53:	8b 50 08             	mov    0x8(%eax),%edx
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	8b 48 08             	mov    0x8(%eax),%ecx
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	01 c8                	add    %ecx,%eax
  802a64:	39 c2                	cmp    %eax,%edx
  802a66:	0f 85 a3 00 00 00    	jne    802b0f <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802a6c:	a1 38 41 80 00       	mov    0x804138,%eax
  802a71:	8b 55 08             	mov    0x8(%ebp),%edx
  802a74:	8b 52 08             	mov    0x8(%edx),%edx
  802a77:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802a7a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a7f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a85:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a88:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8b:	8b 52 0c             	mov    0xc(%edx),%edx
  802a8e:	01 ca                	add    %ecx,%edx
  802a90:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802aa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aab:	75 17                	jne    802ac4 <insert_sorted_with_merge_freeList+0x28b>
  802aad:	83 ec 04             	sub    $0x4,%esp
  802ab0:	68 b0 3b 80 00       	push   $0x803bb0
  802ab5:	68 5d 01 00 00       	push   $0x15d
  802aba:	68 d3 3b 80 00       	push   $0x803bd3
  802abf:	e8 b3 d7 ff ff       	call   800277 <_panic>
  802ac4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	89 10                	mov    %edx,(%eax)
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	74 0d                	je     802ae5 <insert_sorted_with_merge_freeList+0x2ac>
  802ad8:	a1 48 41 80 00       	mov    0x804148,%eax
  802add:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae0:	89 50 04             	mov    %edx,0x4(%eax)
  802ae3:	eb 08                	jmp    802aed <insert_sorted_with_merge_freeList+0x2b4>
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	a3 48 41 80 00       	mov    %eax,0x804148
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aff:	a1 54 41 80 00       	mov    0x804154,%eax
  802b04:	40                   	inc    %eax
  802b05:	a3 54 41 80 00       	mov    %eax,0x804154
  802b0a:	e9 37 05 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	8b 50 08             	mov    0x8(%eax),%edx
  802b15:	a1 38 41 80 00       	mov    0x804138,%eax
  802b1a:	8b 40 08             	mov    0x8(%eax),%eax
  802b1d:	39 c2                	cmp    %eax,%edx
  802b1f:	0f 83 82 00 00 00    	jae    802ba7 <insert_sorted_with_merge_freeList+0x36e>
  802b25:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 48 08             	mov    0x8(%eax),%ecx
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	01 c8                	add    %ecx,%eax
  802b3b:	39 c2                	cmp    %eax,%edx
  802b3d:	74 68                	je     802ba7 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b43:	75 17                	jne    802b5c <insert_sorted_with_merge_freeList+0x323>
  802b45:	83 ec 04             	sub    $0x4,%esp
  802b48:	68 b0 3b 80 00       	push   $0x803bb0
  802b4d:	68 62 01 00 00       	push   $0x162
  802b52:	68 d3 3b 80 00       	push   $0x803bd3
  802b57:	e8 1b d7 ff ff       	call   800277 <_panic>
  802b5c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	89 10                	mov    %edx,(%eax)
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 0d                	je     802b7d <insert_sorted_with_merge_freeList+0x344>
  802b70:	a1 38 41 80 00       	mov    0x804138,%eax
  802b75:	8b 55 08             	mov    0x8(%ebp),%edx
  802b78:	89 50 04             	mov    %edx,0x4(%eax)
  802b7b:	eb 08                	jmp    802b85 <insert_sorted_with_merge_freeList+0x34c>
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	a3 38 41 80 00       	mov    %eax,0x804138
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b97:	a1 44 41 80 00       	mov    0x804144,%eax
  802b9c:	40                   	inc    %eax
  802b9d:	a3 44 41 80 00       	mov    %eax,0x804144
  802ba2:	e9 9f 04 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802ba7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802bb1:	e9 84 04 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	39 c2                	cmp    %eax,%edx
  802bc4:	0f 86 a9 00 00 00    	jbe    802c73 <insert_sorted_with_merge_freeList+0x43a>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 50 08             	mov    0x8(%eax),%edx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 48 08             	mov    0x8(%eax),%ecx
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdc:	01 c8                	add    %ecx,%eax
  802bde:	39 c2                	cmp    %eax,%edx
  802be0:	0f 84 8d 00 00 00    	je     802c73 <insert_sorted_with_merge_freeList+0x43a>
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	8b 50 08             	mov    0x8(%eax),%edx
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 40 04             	mov    0x4(%eax),%eax
  802bf2:	8b 48 08             	mov    0x8(%eax),%ecx
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfe:	01 c8                	add    %ecx,%eax
  802c00:	39 c2                	cmp    %eax,%edx
  802c02:	74 6f                	je     802c73 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	74 06                	je     802c10 <insert_sorted_with_merge_freeList+0x3d7>
  802c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c0e:	75 17                	jne    802c27 <insert_sorted_with_merge_freeList+0x3ee>
  802c10:	83 ec 04             	sub    $0x4,%esp
  802c13:	68 10 3c 80 00       	push   $0x803c10
  802c18:	68 6b 01 00 00       	push   $0x16b
  802c1d:	68 d3 3b 80 00       	push   $0x803bd3
  802c22:	e8 50 d6 ff ff       	call   800277 <_panic>
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 50 04             	mov    0x4(%eax),%edx
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	89 50 04             	mov    %edx,0x4(%eax)
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c39:	89 10                	mov    %edx,(%eax)
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 40 04             	mov    0x4(%eax),%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 0d                	je     802c52 <insert_sorted_with_merge_freeList+0x419>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4e:	89 10                	mov    %edx,(%eax)
  802c50:	eb 08                	jmp    802c5a <insert_sorted_with_merge_freeList+0x421>
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	a3 38 41 80 00       	mov    %eax,0x804138
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c60:	89 50 04             	mov    %edx,0x4(%eax)
  802c63:	a1 44 41 80 00       	mov    0x804144,%eax
  802c68:	40                   	inc    %eax
  802c69:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802c6e:	e9 d3 03 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 50 08             	mov    0x8(%eax),%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	8b 40 08             	mov    0x8(%eax),%eax
  802c7f:	39 c2                	cmp    %eax,%edx
  802c81:	0f 86 da 00 00 00    	jbe    802d61 <insert_sorted_with_merge_freeList+0x528>
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 50 08             	mov    0x8(%eax),%edx
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 48 08             	mov    0x8(%eax),%ecx
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	8b 40 0c             	mov    0xc(%eax),%eax
  802c99:	01 c8                	add    %ecx,%eax
  802c9b:	39 c2                	cmp    %eax,%edx
  802c9d:	0f 85 be 00 00 00    	jne    802d61 <insert_sorted_with_merge_freeList+0x528>
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 50 08             	mov    0x8(%eax),%edx
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	8b 48 08             	mov    0x8(%eax),%ecx
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbb:	01 c8                	add    %ecx,%eax
  802cbd:	39 c2                	cmp    %eax,%edx
  802cbf:	0f 84 9c 00 00 00    	je     802d61 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	8b 50 08             	mov    0x8(%eax),%edx
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	01 c2                	add    %eax,%edx
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802cf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cfd:	75 17                	jne    802d16 <insert_sorted_with_merge_freeList+0x4dd>
  802cff:	83 ec 04             	sub    $0x4,%esp
  802d02:	68 b0 3b 80 00       	push   $0x803bb0
  802d07:	68 74 01 00 00       	push   $0x174
  802d0c:	68 d3 3b 80 00       	push   $0x803bd3
  802d11:	e8 61 d5 ff ff       	call   800277 <_panic>
  802d16:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	89 10                	mov    %edx,(%eax)
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 0d                	je     802d37 <insert_sorted_with_merge_freeList+0x4fe>
  802d2a:	a1 48 41 80 00       	mov    0x804148,%eax
  802d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d32:	89 50 04             	mov    %edx,0x4(%eax)
  802d35:	eb 08                	jmp    802d3f <insert_sorted_with_merge_freeList+0x506>
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	a3 48 41 80 00       	mov    %eax,0x804148
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d51:	a1 54 41 80 00       	mov    0x804154,%eax
  802d56:	40                   	inc    %eax
  802d57:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d5c:	e9 e5 02 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 50 08             	mov    0x8(%eax),%edx
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 40 08             	mov    0x8(%eax),%eax
  802d6d:	39 c2                	cmp    %eax,%edx
  802d6f:	0f 86 d7 00 00 00    	jbe    802e4c <insert_sorted_with_merge_freeList+0x613>
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 50 08             	mov    0x8(%eax),%edx
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 48 08             	mov    0x8(%eax),%ecx
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	8b 40 0c             	mov    0xc(%eax),%eax
  802d87:	01 c8                	add    %ecx,%eax
  802d89:	39 c2                	cmp    %eax,%edx
  802d8b:	0f 84 bb 00 00 00    	je     802e4c <insert_sorted_with_merge_freeList+0x613>
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 50 08             	mov    0x8(%eax),%edx
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 40 04             	mov    0x4(%eax),%eax
  802d9d:	8b 48 08             	mov    0x8(%eax),%ecx
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	8b 40 0c             	mov    0xc(%eax),%eax
  802da9:	01 c8                	add    %ecx,%eax
  802dab:	39 c2                	cmp    %eax,%edx
  802dad:	0f 85 99 00 00 00    	jne    802e4c <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbf:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc8:	01 c2                	add    %eax,%edx
  802dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcd:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802de4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de8:	75 17                	jne    802e01 <insert_sorted_with_merge_freeList+0x5c8>
  802dea:	83 ec 04             	sub    $0x4,%esp
  802ded:	68 b0 3b 80 00       	push   $0x803bb0
  802df2:	68 7d 01 00 00       	push   $0x17d
  802df7:	68 d3 3b 80 00       	push   $0x803bd3
  802dfc:	e8 76 d4 ff ff       	call   800277 <_panic>
  802e01:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	89 10                	mov    %edx,(%eax)
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 0d                	je     802e22 <insert_sorted_with_merge_freeList+0x5e9>
  802e15:	a1 48 41 80 00       	mov    0x804148,%eax
  802e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1d:	89 50 04             	mov    %edx,0x4(%eax)
  802e20:	eb 08                	jmp    802e2a <insert_sorted_with_merge_freeList+0x5f1>
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	a3 48 41 80 00       	mov    %eax,0x804148
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3c:	a1 54 41 80 00       	mov    0x804154,%eax
  802e41:	40                   	inc    %eax
  802e42:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e47:	e9 fa 01 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 50 08             	mov    0x8(%eax),%edx
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 40 08             	mov    0x8(%eax),%eax
  802e58:	39 c2                	cmp    %eax,%edx
  802e5a:	0f 86 d2 01 00 00    	jbe    803032 <insert_sorted_with_merge_freeList+0x7f9>
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 50 08             	mov    0x8(%eax),%edx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 48 08             	mov    0x8(%eax),%ecx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e72:	01 c8                	add    %ecx,%eax
  802e74:	39 c2                	cmp    %eax,%edx
  802e76:	0f 85 b6 01 00 00    	jne    803032 <insert_sorted_with_merge_freeList+0x7f9>
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	8b 50 08             	mov    0x8(%eax),%edx
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	8b 48 08             	mov    0x8(%eax),%ecx
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	8b 40 0c             	mov    0xc(%eax),%eax
  802e94:	01 c8                	add    %ecx,%eax
  802e96:	39 c2                	cmp    %eax,%edx
  802e98:	0f 85 94 01 00 00    	jne    803032 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 04             	mov    0x4(%eax),%eax
  802ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea7:	8b 52 04             	mov    0x4(%edx),%edx
  802eaa:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ead:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb0:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb6:	8b 52 0c             	mov    0xc(%edx),%edx
  802eb9:	01 da                	add    %ebx,%edx
  802ebb:	01 ca                	add    %ecx,%edx
  802ebd:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed8:	75 17                	jne    802ef1 <insert_sorted_with_merge_freeList+0x6b8>
  802eda:	83 ec 04             	sub    $0x4,%esp
  802edd:	68 45 3c 80 00       	push   $0x803c45
  802ee2:	68 86 01 00 00       	push   $0x186
  802ee7:	68 d3 3b 80 00       	push   $0x803bd3
  802eec:	e8 86 d3 ff ff       	call   800277 <_panic>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	74 10                	je     802f0a <insert_sorted_with_merge_freeList+0x6d1>
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f02:	8b 52 04             	mov    0x4(%edx),%edx
  802f05:	89 50 04             	mov    %edx,0x4(%eax)
  802f08:	eb 0b                	jmp    802f15 <insert_sorted_with_merge_freeList+0x6dc>
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 40 04             	mov    0x4(%eax),%eax
  802f10:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 0f                	je     802f2e <insert_sorted_with_merge_freeList+0x6f5>
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 40 04             	mov    0x4(%eax),%eax
  802f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f28:	8b 12                	mov    (%edx),%edx
  802f2a:	89 10                	mov    %edx,(%eax)
  802f2c:	eb 0a                	jmp    802f38 <insert_sorted_with_merge_freeList+0x6ff>
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	a3 38 41 80 00       	mov    %eax,0x804138
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4b:	a1 44 41 80 00       	mov    0x804144,%eax
  802f50:	48                   	dec    %eax
  802f51:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5a:	75 17                	jne    802f73 <insert_sorted_with_merge_freeList+0x73a>
  802f5c:	83 ec 04             	sub    $0x4,%esp
  802f5f:	68 b0 3b 80 00       	push   $0x803bb0
  802f64:	68 87 01 00 00       	push   $0x187
  802f69:	68 d3 3b 80 00       	push   $0x803bd3
  802f6e:	e8 04 d3 ff ff       	call   800277 <_panic>
  802f73:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	89 10                	mov    %edx,(%eax)
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 0d                	je     802f94 <insert_sorted_with_merge_freeList+0x75b>
  802f87:	a1 48 41 80 00       	mov    0x804148,%eax
  802f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f8f:	89 50 04             	mov    %edx,0x4(%eax)
  802f92:	eb 08                	jmp    802f9c <insert_sorted_with_merge_freeList+0x763>
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	a3 48 41 80 00       	mov    %eax,0x804148
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fae:	a1 54 41 80 00       	mov    0x804154,%eax
  802fb3:	40                   	inc    %eax
  802fb4:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd1:	75 17                	jne    802fea <insert_sorted_with_merge_freeList+0x7b1>
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	68 b0 3b 80 00       	push   $0x803bb0
  802fdb:	68 8a 01 00 00       	push   $0x18a
  802fe0:	68 d3 3b 80 00       	push   $0x803bd3
  802fe5:	e8 8d d2 ff ff       	call   800277 <_panic>
  802fea:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	89 10                	mov    %edx,(%eax)
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	74 0d                	je     80300b <insert_sorted_with_merge_freeList+0x7d2>
  802ffe:	a1 48 41 80 00       	mov    0x804148,%eax
  803003:	8b 55 08             	mov    0x8(%ebp),%edx
  803006:	89 50 04             	mov    %edx,0x4(%eax)
  803009:	eb 08                	jmp    803013 <insert_sorted_with_merge_freeList+0x7da>
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	a3 48 41 80 00       	mov    %eax,0x804148
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803025:	a1 54 41 80 00       	mov    0x804154,%eax
  80302a:	40                   	inc    %eax
  80302b:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803030:	eb 14                	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80303a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303e:	0f 85 72 fb ff ff    	jne    802bb6 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803044:	eb 00                	jmp    803046 <insert_sorted_with_merge_freeList+0x80d>
  803046:	90                   	nop
  803047:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80304a:	c9                   	leave  
  80304b:	c3                   	ret    

0080304c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80304c:	55                   	push   %ebp
  80304d:	89 e5                	mov    %esp,%ebp
  80304f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803052:	8b 55 08             	mov    0x8(%ebp),%edx
  803055:	89 d0                	mov    %edx,%eax
  803057:	c1 e0 02             	shl    $0x2,%eax
  80305a:	01 d0                	add    %edx,%eax
  80305c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803063:	01 d0                	add    %edx,%eax
  803065:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80306c:	01 d0                	add    %edx,%eax
  80306e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803075:	01 d0                	add    %edx,%eax
  803077:	c1 e0 04             	shl    $0x4,%eax
  80307a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80307d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803084:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803087:	83 ec 0c             	sub    $0xc,%esp
  80308a:	50                   	push   %eax
  80308b:	e8 7b eb ff ff       	call   801c0b <sys_get_virtual_time>
  803090:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803093:	eb 41                	jmp    8030d6 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803095:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803098:	83 ec 0c             	sub    $0xc,%esp
  80309b:	50                   	push   %eax
  80309c:	e8 6a eb ff ff       	call   801c0b <sys_get_virtual_time>
  8030a1:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	29 c2                	sub    %eax,%edx
  8030ac:	89 d0                	mov    %edx,%eax
  8030ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b7:	89 d1                	mov    %edx,%ecx
  8030b9:	29 c1                	sub    %eax,%ecx
  8030bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c1:	39 c2                	cmp    %eax,%edx
  8030c3:	0f 97 c0             	seta   %al
  8030c6:	0f b6 c0             	movzbl %al,%eax
  8030c9:	29 c1                	sub    %eax,%ecx
  8030cb:	89 c8                	mov    %ecx,%eax
  8030cd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030dc:	72 b7                	jb     803095 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030de:	90                   	nop
  8030df:	c9                   	leave  
  8030e0:	c3                   	ret    

008030e1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030e1:	55                   	push   %ebp
  8030e2:	89 e5                	mov    %esp,%ebp
  8030e4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030ee:	eb 03                	jmp    8030f3 <busy_wait+0x12>
  8030f0:	ff 45 fc             	incl   -0x4(%ebp)
  8030f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f9:	72 f5                	jb     8030f0 <busy_wait+0xf>
	return i;
  8030fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030fe:	c9                   	leave  
  8030ff:	c3                   	ret    

00803100 <__udivdi3>:
  803100:	55                   	push   %ebp
  803101:	57                   	push   %edi
  803102:	56                   	push   %esi
  803103:	53                   	push   %ebx
  803104:	83 ec 1c             	sub    $0x1c,%esp
  803107:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80310b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80310f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803113:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803117:	89 ca                	mov    %ecx,%edx
  803119:	89 f8                	mov    %edi,%eax
  80311b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80311f:	85 f6                	test   %esi,%esi
  803121:	75 2d                	jne    803150 <__udivdi3+0x50>
  803123:	39 cf                	cmp    %ecx,%edi
  803125:	77 65                	ja     80318c <__udivdi3+0x8c>
  803127:	89 fd                	mov    %edi,%ebp
  803129:	85 ff                	test   %edi,%edi
  80312b:	75 0b                	jne    803138 <__udivdi3+0x38>
  80312d:	b8 01 00 00 00       	mov    $0x1,%eax
  803132:	31 d2                	xor    %edx,%edx
  803134:	f7 f7                	div    %edi
  803136:	89 c5                	mov    %eax,%ebp
  803138:	31 d2                	xor    %edx,%edx
  80313a:	89 c8                	mov    %ecx,%eax
  80313c:	f7 f5                	div    %ebp
  80313e:	89 c1                	mov    %eax,%ecx
  803140:	89 d8                	mov    %ebx,%eax
  803142:	f7 f5                	div    %ebp
  803144:	89 cf                	mov    %ecx,%edi
  803146:	89 fa                	mov    %edi,%edx
  803148:	83 c4 1c             	add    $0x1c,%esp
  80314b:	5b                   	pop    %ebx
  80314c:	5e                   	pop    %esi
  80314d:	5f                   	pop    %edi
  80314e:	5d                   	pop    %ebp
  80314f:	c3                   	ret    
  803150:	39 ce                	cmp    %ecx,%esi
  803152:	77 28                	ja     80317c <__udivdi3+0x7c>
  803154:	0f bd fe             	bsr    %esi,%edi
  803157:	83 f7 1f             	xor    $0x1f,%edi
  80315a:	75 40                	jne    80319c <__udivdi3+0x9c>
  80315c:	39 ce                	cmp    %ecx,%esi
  80315e:	72 0a                	jb     80316a <__udivdi3+0x6a>
  803160:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803164:	0f 87 9e 00 00 00    	ja     803208 <__udivdi3+0x108>
  80316a:	b8 01 00 00 00       	mov    $0x1,%eax
  80316f:	89 fa                	mov    %edi,%edx
  803171:	83 c4 1c             	add    $0x1c,%esp
  803174:	5b                   	pop    %ebx
  803175:	5e                   	pop    %esi
  803176:	5f                   	pop    %edi
  803177:	5d                   	pop    %ebp
  803178:	c3                   	ret    
  803179:	8d 76 00             	lea    0x0(%esi),%esi
  80317c:	31 ff                	xor    %edi,%edi
  80317e:	31 c0                	xor    %eax,%eax
  803180:	89 fa                	mov    %edi,%edx
  803182:	83 c4 1c             	add    $0x1c,%esp
  803185:	5b                   	pop    %ebx
  803186:	5e                   	pop    %esi
  803187:	5f                   	pop    %edi
  803188:	5d                   	pop    %ebp
  803189:	c3                   	ret    
  80318a:	66 90                	xchg   %ax,%ax
  80318c:	89 d8                	mov    %ebx,%eax
  80318e:	f7 f7                	div    %edi
  803190:	31 ff                	xor    %edi,%edi
  803192:	89 fa                	mov    %edi,%edx
  803194:	83 c4 1c             	add    $0x1c,%esp
  803197:	5b                   	pop    %ebx
  803198:	5e                   	pop    %esi
  803199:	5f                   	pop    %edi
  80319a:	5d                   	pop    %ebp
  80319b:	c3                   	ret    
  80319c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031a1:	89 eb                	mov    %ebp,%ebx
  8031a3:	29 fb                	sub    %edi,%ebx
  8031a5:	89 f9                	mov    %edi,%ecx
  8031a7:	d3 e6                	shl    %cl,%esi
  8031a9:	89 c5                	mov    %eax,%ebp
  8031ab:	88 d9                	mov    %bl,%cl
  8031ad:	d3 ed                	shr    %cl,%ebp
  8031af:	89 e9                	mov    %ebp,%ecx
  8031b1:	09 f1                	or     %esi,%ecx
  8031b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031b7:	89 f9                	mov    %edi,%ecx
  8031b9:	d3 e0                	shl    %cl,%eax
  8031bb:	89 c5                	mov    %eax,%ebp
  8031bd:	89 d6                	mov    %edx,%esi
  8031bf:	88 d9                	mov    %bl,%cl
  8031c1:	d3 ee                	shr    %cl,%esi
  8031c3:	89 f9                	mov    %edi,%ecx
  8031c5:	d3 e2                	shl    %cl,%edx
  8031c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031cb:	88 d9                	mov    %bl,%cl
  8031cd:	d3 e8                	shr    %cl,%eax
  8031cf:	09 c2                	or     %eax,%edx
  8031d1:	89 d0                	mov    %edx,%eax
  8031d3:	89 f2                	mov    %esi,%edx
  8031d5:	f7 74 24 0c          	divl   0xc(%esp)
  8031d9:	89 d6                	mov    %edx,%esi
  8031db:	89 c3                	mov    %eax,%ebx
  8031dd:	f7 e5                	mul    %ebp
  8031df:	39 d6                	cmp    %edx,%esi
  8031e1:	72 19                	jb     8031fc <__udivdi3+0xfc>
  8031e3:	74 0b                	je     8031f0 <__udivdi3+0xf0>
  8031e5:	89 d8                	mov    %ebx,%eax
  8031e7:	31 ff                	xor    %edi,%edi
  8031e9:	e9 58 ff ff ff       	jmp    803146 <__udivdi3+0x46>
  8031ee:	66 90                	xchg   %ax,%ax
  8031f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031f4:	89 f9                	mov    %edi,%ecx
  8031f6:	d3 e2                	shl    %cl,%edx
  8031f8:	39 c2                	cmp    %eax,%edx
  8031fa:	73 e9                	jae    8031e5 <__udivdi3+0xe5>
  8031fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031ff:	31 ff                	xor    %edi,%edi
  803201:	e9 40 ff ff ff       	jmp    803146 <__udivdi3+0x46>
  803206:	66 90                	xchg   %ax,%ax
  803208:	31 c0                	xor    %eax,%eax
  80320a:	e9 37 ff ff ff       	jmp    803146 <__udivdi3+0x46>
  80320f:	90                   	nop

00803210 <__umoddi3>:
  803210:	55                   	push   %ebp
  803211:	57                   	push   %edi
  803212:	56                   	push   %esi
  803213:	53                   	push   %ebx
  803214:	83 ec 1c             	sub    $0x1c,%esp
  803217:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80321b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80321f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803223:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803227:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80322b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80322f:	89 f3                	mov    %esi,%ebx
  803231:	89 fa                	mov    %edi,%edx
  803233:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803237:	89 34 24             	mov    %esi,(%esp)
  80323a:	85 c0                	test   %eax,%eax
  80323c:	75 1a                	jne    803258 <__umoddi3+0x48>
  80323e:	39 f7                	cmp    %esi,%edi
  803240:	0f 86 a2 00 00 00    	jbe    8032e8 <__umoddi3+0xd8>
  803246:	89 c8                	mov    %ecx,%eax
  803248:	89 f2                	mov    %esi,%edx
  80324a:	f7 f7                	div    %edi
  80324c:	89 d0                	mov    %edx,%eax
  80324e:	31 d2                	xor    %edx,%edx
  803250:	83 c4 1c             	add    $0x1c,%esp
  803253:	5b                   	pop    %ebx
  803254:	5e                   	pop    %esi
  803255:	5f                   	pop    %edi
  803256:	5d                   	pop    %ebp
  803257:	c3                   	ret    
  803258:	39 f0                	cmp    %esi,%eax
  80325a:	0f 87 ac 00 00 00    	ja     80330c <__umoddi3+0xfc>
  803260:	0f bd e8             	bsr    %eax,%ebp
  803263:	83 f5 1f             	xor    $0x1f,%ebp
  803266:	0f 84 ac 00 00 00    	je     803318 <__umoddi3+0x108>
  80326c:	bf 20 00 00 00       	mov    $0x20,%edi
  803271:	29 ef                	sub    %ebp,%edi
  803273:	89 fe                	mov    %edi,%esi
  803275:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803279:	89 e9                	mov    %ebp,%ecx
  80327b:	d3 e0                	shl    %cl,%eax
  80327d:	89 d7                	mov    %edx,%edi
  80327f:	89 f1                	mov    %esi,%ecx
  803281:	d3 ef                	shr    %cl,%edi
  803283:	09 c7                	or     %eax,%edi
  803285:	89 e9                	mov    %ebp,%ecx
  803287:	d3 e2                	shl    %cl,%edx
  803289:	89 14 24             	mov    %edx,(%esp)
  80328c:	89 d8                	mov    %ebx,%eax
  80328e:	d3 e0                	shl    %cl,%eax
  803290:	89 c2                	mov    %eax,%edx
  803292:	8b 44 24 08          	mov    0x8(%esp),%eax
  803296:	d3 e0                	shl    %cl,%eax
  803298:	89 44 24 04          	mov    %eax,0x4(%esp)
  80329c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032a0:	89 f1                	mov    %esi,%ecx
  8032a2:	d3 e8                	shr    %cl,%eax
  8032a4:	09 d0                	or     %edx,%eax
  8032a6:	d3 eb                	shr    %cl,%ebx
  8032a8:	89 da                	mov    %ebx,%edx
  8032aa:	f7 f7                	div    %edi
  8032ac:	89 d3                	mov    %edx,%ebx
  8032ae:	f7 24 24             	mull   (%esp)
  8032b1:	89 c6                	mov    %eax,%esi
  8032b3:	89 d1                	mov    %edx,%ecx
  8032b5:	39 d3                	cmp    %edx,%ebx
  8032b7:	0f 82 87 00 00 00    	jb     803344 <__umoddi3+0x134>
  8032bd:	0f 84 91 00 00 00    	je     803354 <__umoddi3+0x144>
  8032c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032c7:	29 f2                	sub    %esi,%edx
  8032c9:	19 cb                	sbb    %ecx,%ebx
  8032cb:	89 d8                	mov    %ebx,%eax
  8032cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032d1:	d3 e0                	shl    %cl,%eax
  8032d3:	89 e9                	mov    %ebp,%ecx
  8032d5:	d3 ea                	shr    %cl,%edx
  8032d7:	09 d0                	or     %edx,%eax
  8032d9:	89 e9                	mov    %ebp,%ecx
  8032db:	d3 eb                	shr    %cl,%ebx
  8032dd:	89 da                	mov    %ebx,%edx
  8032df:	83 c4 1c             	add    $0x1c,%esp
  8032e2:	5b                   	pop    %ebx
  8032e3:	5e                   	pop    %esi
  8032e4:	5f                   	pop    %edi
  8032e5:	5d                   	pop    %ebp
  8032e6:	c3                   	ret    
  8032e7:	90                   	nop
  8032e8:	89 fd                	mov    %edi,%ebp
  8032ea:	85 ff                	test   %edi,%edi
  8032ec:	75 0b                	jne    8032f9 <__umoddi3+0xe9>
  8032ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8032f3:	31 d2                	xor    %edx,%edx
  8032f5:	f7 f7                	div    %edi
  8032f7:	89 c5                	mov    %eax,%ebp
  8032f9:	89 f0                	mov    %esi,%eax
  8032fb:	31 d2                	xor    %edx,%edx
  8032fd:	f7 f5                	div    %ebp
  8032ff:	89 c8                	mov    %ecx,%eax
  803301:	f7 f5                	div    %ebp
  803303:	89 d0                	mov    %edx,%eax
  803305:	e9 44 ff ff ff       	jmp    80324e <__umoddi3+0x3e>
  80330a:	66 90                	xchg   %ax,%ax
  80330c:	89 c8                	mov    %ecx,%eax
  80330e:	89 f2                	mov    %esi,%edx
  803310:	83 c4 1c             	add    $0x1c,%esp
  803313:	5b                   	pop    %ebx
  803314:	5e                   	pop    %esi
  803315:	5f                   	pop    %edi
  803316:	5d                   	pop    %ebp
  803317:	c3                   	ret    
  803318:	3b 04 24             	cmp    (%esp),%eax
  80331b:	72 06                	jb     803323 <__umoddi3+0x113>
  80331d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803321:	77 0f                	ja     803332 <__umoddi3+0x122>
  803323:	89 f2                	mov    %esi,%edx
  803325:	29 f9                	sub    %edi,%ecx
  803327:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80332b:	89 14 24             	mov    %edx,(%esp)
  80332e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803332:	8b 44 24 04          	mov    0x4(%esp),%eax
  803336:	8b 14 24             	mov    (%esp),%edx
  803339:	83 c4 1c             	add    $0x1c,%esp
  80333c:	5b                   	pop    %ebx
  80333d:	5e                   	pop    %esi
  80333e:	5f                   	pop    %edi
  80333f:	5d                   	pop    %ebp
  803340:	c3                   	ret    
  803341:	8d 76 00             	lea    0x0(%esi),%esi
  803344:	2b 04 24             	sub    (%esp),%eax
  803347:	19 fa                	sbb    %edi,%edx
  803349:	89 d1                	mov    %edx,%ecx
  80334b:	89 c6                	mov    %eax,%esi
  80334d:	e9 71 ff ff ff       	jmp    8032c3 <__umoddi3+0xb3>
  803352:	66 90                	xchg   %ax,%ax
  803354:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803358:	72 ea                	jb     803344 <__umoddi3+0x134>
  80335a:	89 d9                	mov    %ebx,%ecx
  80335c:	e9 62 ff ff ff       	jmp    8032c3 <__umoddi3+0xb3>
