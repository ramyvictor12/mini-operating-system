
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 1e 01 00 00       	call   800154 <libmain>
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
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  800098:	e8 f3 01 00 00       	call   800290 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 ed 13 00 00       	call   801494 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 42 1b 00 00       	call   801bf1 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 b9 33 80 00       	push   $0x8033b9
  8000b7:	50                   	push   %eax
  8000b8:	e8 fb 15 00 00       	call   8016b8 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 bc 33 80 00       	push   $0x8033bc
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 3e 1c 00 00       	call   801d16 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 e4 33 80 00       	push   $0x8033e4
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 70 2f 00 00       	call   803065 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 fb 17 00 00       	call   8018f8 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 8d 16 00 00       	call   801798 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 04 34 80 00       	push   $0x803404
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 ce 17 00 00       	call   8018f8 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 1c 34 80 00       	push   $0x80341c
  800140:	6a 27                	push   $0x27
  800142:	68 9c 33 80 00       	push   $0x80339c
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 c5 1b 00 00       	call   801d16 <inctst>
	return;
  800151:	90                   	nop
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80015a:	e8 79 1a 00 00       	call   801bd8 <sys_getenvindex>
  80015f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800165:	89 d0                	mov    %edx,%eax
  800167:	c1 e0 03             	shl    $0x3,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	01 c0                	add    %eax,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 04             	shl    $0x4,%eax
  80017c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800181:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800186:	a1 20 40 80 00       	mov    0x804020,%eax
  80018b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800191:	84 c0                	test   %al,%al
  800193:	74 0f                	je     8001a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800195:	a1 20 40 80 00       	mov    0x804020,%eax
  80019a:	05 5c 05 00 00       	add    $0x55c,%eax
  80019f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x60>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c5:	e8 1b 18 00 00       	call   8019e5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 dc 34 80 00       	push   $0x8034dc
  8001d2:	e8 6d 03 00 00       	call   800544 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 40 80 00       	mov    0x804020,%eax
  8001df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 04 35 80 00       	push   $0x803504
  8001fa:	e8 45 03 00 00       	call   800544 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 40 80 00       	mov    0x804020,%eax
  800207:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80020d:	a1 20 40 80 00       	mov    0x804020,%eax
  800212:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 2c 35 80 00       	push   $0x80352c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 84 35 80 00       	push   $0x803584
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 dc 34 80 00       	push   $0x8034dc
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 9b 17 00 00       	call   8019ff <sys_enable_interrupt>

	// exit gracefully
	exit();
  800264:	e8 19 00 00 00       	call   800282 <exit>
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 28 19 00 00       	call   801ba4 <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 7d 19 00 00       	call   801c0a <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 98 35 80 00       	push   $0x803598
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 40 80 00       	mov    0x804000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 9d 35 80 00       	push   $0x80359d
  8002cf:	e8 70 02 00 00       	call   800544 <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	50                   	push   %eax
  8002e1:	e8 f3 01 00 00       	call   8004d9 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	6a 00                	push   $0x0
  8002ee:	68 b9 35 80 00       	push   $0x8035b9
  8002f3:	e8 e1 01 00 00       	call   8004d9 <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fb:	e8 82 ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800300:	eb fe                	jmp    800300 <_panic+0x70>

00800302 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	8b 50 74             	mov    0x74(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	39 c2                	cmp    %eax,%edx
  800315:	74 14                	je     80032b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	68 bc 35 80 00       	push   $0x8035bc
  80031f:	6a 26                	push   $0x26
  800321:	68 08 36 80 00       	push   $0x803608
  800326:	e8 65 ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800332:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800339:	e9 c2 00 00 00       	jmp    800400 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800341:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	85 c0                	test   %eax,%eax
  800351:	75 08                	jne    80035b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800353:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800356:	e9 a2 00 00 00       	jmp    8003fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80035b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800362:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800369:	eb 69                	jmp    8003d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036b:	a1 20 40 80 00       	mov    0x804020,%eax
  800370:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800379:	89 d0                	mov    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	c1 e0 03             	shl    $0x3,%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8a 40 04             	mov    0x4(%eax),%al
  800387:	84 c0                	test   %al,%al
  800389:	75 46                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038b:	a1 20 40 80 00       	mov    0x804020,%eax
  800390:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800399:	89 d0                	mov    %edx,%eax
  80039b:	01 c0                	add    %eax,%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c1 e0 03             	shl    $0x3,%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	75 09                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003cf:	eb 12                	jmp    8003e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d1:	ff 45 e8             	incl   -0x18(%ebp)
  8003d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d9:	8b 50 74             	mov    0x74(%eax),%edx
  8003dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003df:	39 c2                	cmp    %eax,%edx
  8003e1:	77 88                	ja     80036b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e7:	75 14                	jne    8003fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 14 36 80 00       	push   $0x803614
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 08 36 80 00       	push   $0x803608
  8003f8:	e8 93 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fd:	ff 45 f0             	incl   -0x10(%ebp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800406:	0f 8c 32 ff ff ff    	jl     80033e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80040c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800413:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041a:	eb 26                	jmp    800442 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80041c:	a1 20 40 80 00       	mov    0x804020,%eax
  800421:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8a 40 04             	mov    0x4(%eax),%al
  800438:	3c 01                	cmp    $0x1,%al
  80043a:	75 03                	jne    80043f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80043c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043f:	ff 45 e0             	incl   -0x20(%ebp)
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 50 74             	mov    0x74(%eax),%edx
  80044a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	77 cb                	ja     80041c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800457:	74 14                	je     80046d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 68 36 80 00       	push   $0x803668
  800461:	6a 44                	push   $0x44
  800463:	68 08 36 80 00       	push   $0x803608
  800468:	e8 23 fe ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046d:	90                   	nop
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 48 01             	lea    0x1(%eax),%ecx
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 0a                	mov    %ecx,(%edx)
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	88 d1                	mov    %dl,%cl
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	3d ff 00 00 00       	cmp    $0xff,%eax
  800499:	75 2c                	jne    8004c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049b:	a0 24 40 80 00       	mov    0x804024,%al
  8004a0:	0f b6 c0             	movzbl %al,%eax
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	8b 12                	mov    (%edx),%edx
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	83 c2 08             	add    $0x8,%edx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	50                   	push   %eax
  8004b4:	51                   	push   %ecx
  8004b5:	52                   	push   %edx
  8004b6:	e8 7c 13 00 00       	call   801837 <sys_cputs>
  8004bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 40 04             	mov    0x4(%eax),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e9:	00 00 00 
	b.cnt = 0;
  8004ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800502:	50                   	push   %eax
  800503:	68 70 04 80 00       	push   $0x800470
  800508:	e8 11 02 00 00       	call   80071e <vprintfmt>
  80050d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800510:	a0 24 40 80 00       	mov    0x804024,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 05 13 00 00       	call   801837 <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80053c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <cprintf>:

int cprintf(const char *fmt, ...) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800551:	8d 45 0c             	lea    0xc(%ebp),%eax
  800554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 f4             	pushl  -0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	e8 73 ff ff ff       	call   8004d9 <vcprintf>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800577:	e8 69 14 00 00       	call   8019e5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 48 ff ff ff       	call   8004d9 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800597:	e8 63 14 00 00       	call   8019ff <sys_enable_interrupt>
	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 14             	sub    $0x14,%esp
  8005a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	77 55                	ja     800616 <printnum+0x75>
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	72 05                	jb     8005cb <printnum+0x2a>
  8005c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c9:	77 4b                	ja     800616 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e1:	e8 36 2b 00 00       	call   80311c <__udivdi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	53                   	push   %ebx
  8005f0:	ff 75 18             	pushl  0x18(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 a1 ff ff ff       	call   8005a1 <printnum>
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	eb 1a                	jmp    80061f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 20             	pushl  0x20(%ebp)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800616:	ff 4d 1c             	decl   0x1c(%ebp)
  800619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061d:	7f e6                	jg     800605 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800622:	bb 00 00 00 00       	mov    $0x0,%ebx
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	53                   	push   %ebx
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	e8 f6 2b 00 00       	call   80322c <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 d4 38 80 00       	add    $0x8038d4,%eax
  80063e:	8a 00                	mov    (%eax),%al
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
}
  800652:	90                   	nop
  800653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065f:	7e 1c                	jle    80067d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 08             	sub    $0x8,%eax
  800676:	8b 50 04             	mov    0x4(%eax),%edx
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	eb 40                	jmp    8006bd <getuint+0x65>
	else if (lflag)
  80067d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800681:	74 1e                	je     8006a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	eb 1c                	jmp    8006bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 04             	lea    0x4(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 04             	sub    $0x4,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c6:	7e 1c                	jle    8006e4 <getint+0x25>
		return va_arg(*ap, long long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 08             	lea    0x8(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 08             	sub    $0x8,%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	eb 38                	jmp    80071c <getint+0x5d>
	else if (lflag)
  8006e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e8:	74 1a                	je     800704 <getint+0x45>
		return va_arg(*ap, long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	eb 18                	jmp    80071c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
  800723:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	eb 17                	jmp    80073f <vprintfmt+0x21>
			if (ch == '\0')
  800728:	85 db                	test   %ebx,%ebx
  80072a:	0f 84 af 03 00 00    	je     800adf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	89 55 10             	mov    %edx,0x10(%ebp)
  800748:	8a 00                	mov    (%eax),%al
  80074a:	0f b6 d8             	movzbl %al,%ebx
  80074d:	83 fb 25             	cmp    $0x25,%ebx
  800750:	75 d6                	jne    800728 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800752:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800756:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800783:	83 f8 55             	cmp    $0x55,%eax
  800786:	0f 87 2b 03 00 00    	ja     800ab7 <vprintfmt+0x399>
  80078c:	8b 04 85 f8 38 80 00 	mov    0x8038f8(,%eax,4),%eax
  800793:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800799:	eb d7                	jmp    800772 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d1                	jmp    800772 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8a 00                	mov    (%eax),%al
  8007c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c7:	7e 3e                	jle    800807 <vprintfmt+0xe9>
  8007c9:	83 fb 39             	cmp    $0x39,%ebx
  8007cc:	7f 39                	jg     800807 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d5                	jmp    8007a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 c0 04             	add    $0x4,%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 e8 04             	sub    $0x4,%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e7:	eb 1f                	jmp    800808 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	79 83                	jns    800772 <vprintfmt+0x54>
				width = 0;
  8007ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f6:	e9 77 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800802:	e9 6b ff ff ff       	jmp    800772 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800807:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	0f 89 60 ff ff ff    	jns    800772 <vprintfmt+0x54>
				width = precision, precision = -1;
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081f:	e9 4e ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800824:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800827:	e9 46 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	e9 89 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x14a>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 64             	cmp    $0x64,%ebx
  80086b:	7f 0b                	jg     800878 <vprintfmt+0x15a>
  80086d:	8b 34 9d 40 37 80 00 	mov    0x803740(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 e5 38 80 00       	push   $0x8038e5
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 5e 02 00 00       	call   800ae7 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088c:	e9 49 02 00 00       	jmp    800ada <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	56                   	push   %esi
  800892:	68 ee 38 80 00       	push   $0x8038ee
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 45 02 00 00       	call   800ae7 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 30 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 30                	mov    (%eax),%esi
  8008bb:	85 f6                	test   %esi,%esi
  8008bd:	75 05                	jne    8008c4 <vprintfmt+0x1a6>
				p = "(null)";
  8008bf:	be f1 38 80 00       	mov    $0x8038f1,%esi
			if (width > 0 && padc != '-')
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7e 6d                	jle    800937 <vprintfmt+0x219>
  8008ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ce:	74 67                	je     800937 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	56                   	push   %esi
  8008d8:	e8 0c 03 00 00       	call   800be9 <strnlen>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e3:	eb 16                	jmp    8008fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7f e4                	jg     8008e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	eb 34                	jmp    800937 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800903:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800907:	74 1c                	je     800925 <vprintfmt+0x207>
  800909:	83 fb 1f             	cmp    $0x1f,%ebx
  80090c:	7e 05                	jle    800913 <vprintfmt+0x1f5>
  80090e:	83 fb 7e             	cmp    $0x7e,%ebx
  800911:	7e 12                	jle    800925 <vprintfmt+0x207>
					putch('?', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 3f                	push   $0x3f
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	ff 4d e4             	decl   -0x1c(%ebp)
  800937:	89 f0                	mov    %esi,%eax
  800939:	8d 70 01             	lea    0x1(%eax),%esi
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f be d8             	movsbl %al,%ebx
  800941:	85 db                	test   %ebx,%ebx
  800943:	74 24                	je     800969 <vprintfmt+0x24b>
  800945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800949:	78 b8                	js     800903 <vprintfmt+0x1e5>
  80094b:	ff 4d e0             	decl   -0x20(%ebp)
  80094e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800952:	79 af                	jns    800903 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	eb 13                	jmp    800969 <vprintfmt+0x24b>
				putch(' ', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	6a 20                	push   $0x20
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e7                	jg     800956 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096f:	e9 66 01 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 e8             	pushl  -0x18(%ebp)
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	e8 3c fd ff ff       	call   8006bf <getint>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800989:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	79 23                	jns    8009b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 2d                	push   $0x2d
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	f7 d8                	neg    %eax
  8009ae:	83 d2 00             	adc    $0x0,%edx
  8009b1:	f7 da                	neg    %edx
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 bc 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 84 fc ff ff       	call   800658 <getuint>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 98 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			break;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 30                	push   $0x30
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 78                	push   $0x78
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 e7 fb ff ff       	call   800658 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	52                   	push   %edx
  800a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	ff 75 f0             	pushl  -0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 00 fb ff ff       	call   8005a1 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
			break;
  800aa4:	eb 34                	jmp    800ada <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 25                	push   $0x25
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	eb 03                	jmp    800acf <vprintfmt+0x3b1>
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	48                   	dec    %eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	3c 25                	cmp    $0x25,%al
  800ad7:	75 f3                	jne    800acc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad9:	90                   	nop
		}
	}
  800ada:	e9 47 fc ff ff       	jmp    800726 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aed:	8d 45 10             	lea    0x10(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af6:	8b 45 10             	mov    0x10(%ebp),%eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 16 fc ff ff       	call   80071e <vprintfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 08             	mov    0x8(%eax),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 10                	mov    (%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	73 12                	jae    800b41 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 48 01             	lea    0x1(%eax),%ecx
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 0a                	mov    %ecx,(%edx)
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	88 10                	mov    %dl,(%eax)
}
  800b41:	90                   	nop
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b69:	74 06                	je     800b71 <vsnprintf+0x2d>
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	7f 07                	jg     800b78 <vsnprintf+0x34>
		return -E_INVAL;
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	eb 20                	jmp    800b98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b78:	ff 75 14             	pushl  0x14(%ebp)
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	68 0e 0b 80 00       	push   $0x800b0e
  800b87:	e8 92 fb ff ff       	call   80071e <vprintfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 89 ff ff ff       	call   800b44 <vsnprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 06                	jmp    800bdb <strlen+0x15>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 f1                	jne    800bd5 <strlen+0xf>
		n++;
	return n;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 09                	jmp    800c01 <strnlen+0x18>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 4d 0c             	decl   0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 09                	je     800c10 <strnlen+0x27>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e8                	jne    800bf8 <strnlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c21:	90                   	nop
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c34:	8a 12                	mov    (%edx),%dl
  800c36:	88 10                	mov    %dl,(%eax)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e4                	jne    800c22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 1f                	jmp    800c77 <strncpy+0x34>
		*dst++ = *src;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8a 12                	mov    (%edx),%dl
  800c66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	74 03                	je     800c74 <strncpy+0x31>
			src++;
  800c71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7d:	72 d9                	jb     800c58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 30                	je     800cc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c96:	eb 16                	jmp    800cae <strlcpy+0x2a>
			*dst++ = *src++;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caa:	8a 12                	mov    (%edx),%dl
  800cac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb5:	74 09                	je     800cc0 <strlcpy+0x3c>
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 d8                	jne    800c98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd5:	eb 06                	jmp    800cdd <strcmp+0xb>
		p++, q++;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	74 0e                	je     800cf4 <strcmp+0x22>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 10                	mov    (%eax),%dl
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	38 c2                	cmp    %al,%dl
  800cf2:	74 e3                	je     800cd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 d0             	movzbl %al,%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 c0             	movzbl %al,%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0d:	eb 09                	jmp    800d18 <strncmp+0xe>
		n--, p++, q++;
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 17                	je     800d35 <strncmp+0x2b>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strncmp+0x2b>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 da                	je     800d0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 07                	jne    800d42 <strncmp+0x38>
		return 0;
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	eb 14                	jmp    800d56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 c0             	movzbl %al,%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d64:	eb 12                	jmp    800d78 <strchr+0x20>
		if (*s == c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6e:	75 05                	jne    800d75 <strchr+0x1d>
			return (char *) s;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	eb 11                	jmp    800d86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e5                	jne    800d66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d94:	eb 0d                	jmp    800da3 <strfind+0x1b>
		if (*s == c)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9e:	74 0e                	je     800dae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ea                	jne    800d96 <strfind+0xe>
  800dac:	eb 01                	jmp    800daf <strfind+0x27>
		if (*s == c)
			break;
  800dae:	90                   	nop
	return (char *) s;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc6:	eb 0e                	jmp    800dd6 <memset+0x22>
		*p++ = c;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd6:	ff 4d f8             	decl   -0x8(%ebp)
  800dd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddd:	79 e9                	jns    800dc8 <memset+0x14>
		*p++ = c;

	return v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df6:	eb 16                	jmp    800e0e <memcpy+0x2a>
		*d++ = *s++;
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 dd                	jne    800df8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e38:	73 50                	jae    800e8a <memmove+0x6a>
  800e3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	76 43                	jbe    800e8a <memmove+0x6a>
		s += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e53:	eb 10                	jmp    800e65 <memmove+0x45>
			*--d = *--s;
  800e55:	ff 4d f8             	decl   -0x8(%ebp)
  800e58:	ff 4d fc             	decl   -0x4(%ebp)
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 e3                	jne    800e55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	eb 23                	jmp    800e97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 dd                	jne    800e74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eae:	eb 2a                	jmp    800eda <memcmp+0x3e>
		if (*s1 != *s2)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 16                	je     800ed4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	eb 18                	jmp    800eec <memcmp+0x50>
		s1++, s2++;
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 c9                	jne    800eb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eff:	eb 15                	jmp    800f16 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	74 0d                	je     800f20 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1c:	72 e3                	jb     800f01 <memfind+0x13>
  800f1e:	eb 01                	jmp    800f21 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f20:	90                   	nop
	return (void *) s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3a:	eb 03                	jmp    800f3f <strtol+0x19>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 20                	cmp    $0x20,%al
  800f46:	74 f4                	je     800f3c <strtol+0x16>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	74 eb                	je     800f3c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2b                	cmp    $0x2b,%al
  800f58:	75 05                	jne    800f5f <strtol+0x39>
		s++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	eb 13                	jmp    800f72 <strtol+0x4c>
	else if (*s == '-')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 2d                	cmp    $0x2d,%al
  800f66:	75 0a                	jne    800f72 <strtol+0x4c>
		s++, neg = 1;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 06                	je     800f7e <strtol+0x58>
  800f78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7c:	75 20                	jne    800f9e <strtol+0x78>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 30                	cmp    $0x30,%al
  800f85:	75 17                	jne    800f9e <strtol+0x78>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	40                   	inc    %eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 78                	cmp    $0x78,%al
  800f8f:	75 0d                	jne    800f9e <strtol+0x78>
		s += 2, base = 16;
  800f91:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f95:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9c:	eb 28                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 15                	jne    800fb9 <strtol+0x93>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 0c                	jne    800fb9 <strtol+0x93>
		s++, base = 8;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb7:	eb 0d                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 07                	jne    800fc6 <strtol+0xa0>
		base = 10;
  800fbf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 2f                	cmp    $0x2f,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xc2>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 39                	cmp    $0x39,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xc2>
			dig = *s - '0';
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 42                	jmp    80102a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 60                	cmp    $0x60,%al
  800fef:	7e 19                	jle    80100a <strtol+0xe4>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 7a                	cmp    $0x7a,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 57             	sub    $0x57,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 20                	jmp    80102a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 40                	cmp    $0x40,%al
  801011:	7e 39                	jle    80104c <strtol+0x126>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 30                	jg     80104c <strtol+0x126>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 37             	sub    $0x37,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801030:	7d 19                	jge    80104b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801046:	e9 7b ff ff ff       	jmp    800fc6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 08                	je     80105a <strtol+0x134>
		*endptr = (char *) s;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105e:	74 07                	je     801067 <strtol+0x141>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	f7 d8                	neg    %eax
  801065:	eb 03                	jmp    80106a <strtol+0x144>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <ltostr>:

void
ltostr(long value, char *str)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801084:	79 13                	jns    801099 <ltostr+0x2d>
	{
		neg = 1;
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801093:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801096:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a1:	99                   	cltd   
  8010a2:	f7 f9                	idiv   %ecx
  8010a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b0:	89 c2                	mov    %eax,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ba:	83 c2 30             	add    $0x30,%edx
  8010bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e0:	f7 e9                	imul   %ecx
  8010e2:	c1 fa 02             	sar    $0x2,%edx
  8010e5:	89 c8                	mov    %ecx,%eax
  8010e7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	c1 e0 02             	shl    $0x2,%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	01 c0                	add    %eax,%eax
  8010f5:	29 c1                	sub    %eax,%ecx
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	75 9c                	jne    801099 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	48                   	dec    %eax
  801108:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80110b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110f:	74 3d                	je     80114e <ltostr+0xe2>
		start = 1 ;
  801111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801118:	eb 34                	jmp    80114e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 c2                	add    %eax,%edx
  80112f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	01 c8                	add    %ecx,%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80113b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8a 45 eb             	mov    -0x15(%ebp),%al
  801146:	88 02                	mov    %al,(%edx)
		start++ ;
  801148:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80114b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80114e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801151:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801154:	7c c4                	jl     80111a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801156:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801161:	90                   	nop
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 54 fa ff ff       	call   800bc6 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 46 fa ff ff       	call   800bc6 <strlen>
  801180:	83 c4 04             	add    $0x4,%esp
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801194:	eb 17                	jmp    8011ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	01 c8                	add    %ecx,%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011aa:	ff 45 fc             	incl   -0x4(%ebp)
  8011ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b3:	7c e1                	jl     801196 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c3:	eb 1f                	jmp    8011e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 c2                	add    %eax,%edx
  8011d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 c8                	add    %ecx,%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c d9                	jl     8011c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	eb 0c                	jmp    80122b <strsplit+0x31>
			*string++ = 0;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 08             	mov    %edx,0x8(%ebp)
  801228:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	84 c0                	test   %al,%al
  801232:	74 18                	je     80124c <strsplit+0x52>
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	0f be c0             	movsbl %al,%eax
  80123c:	50                   	push   %eax
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	e8 13 fb ff ff       	call   800d58 <strchr>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	75 d3                	jne    80121f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	74 5a                	je     8012af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	83 f8 0f             	cmp    $0xf,%eax
  80125d:	75 07                	jne    801266 <strsplit+0x6c>
		{
			return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	eb 66                	jmp    8012cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 48 01             	lea    0x1(%eax),%ecx
  80126e:	8b 55 14             	mov    0x14(%ebp),%edx
  801271:	89 0a                	mov    %ecx,(%edx)
  801273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801284:	eb 03                	jmp    801289 <strsplit+0x8f>
			string++;
  801286:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	84 c0                	test   %al,%al
  801290:	74 8b                	je     80121d <strsplit+0x23>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	50                   	push   %eax
  80129b:	ff 75 0c             	pushl  0xc(%ebp)
  80129e:	e8 b5 fa ff ff       	call   800d58 <strchr>
  8012a3:	83 c4 08             	add    $0x8,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	74 dc                	je     801286 <strsplit+0x8c>
			string++;
	}
  8012aa:	e9 6e ff ff ff       	jmp    80121d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1f                	je     8012fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012dd:	e8 1d 00 00 00       	call   8012ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 50 3a 80 00       	push   $0x803a50
  8012ea:	e8 55 f2 ff ff       	call   800544 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012f9:	00 00 00 
	}
}
  8012fc:	90                   	nop
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801305:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80130c:	00 00 00 
  80130f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801316:	00 00 00 
  801319:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801320:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801323:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80132a:	00 00 00 
  80132d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801334:	00 00 00 
  801337:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80133e:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801341:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801348:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80134b:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801352:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801361:	2d 00 10 00 00       	sub    $0x1000,%eax
  801366:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80136b:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801375:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	6a 06                	push   $0x6
  801384:	ff 75 f4             	pushl  -0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	e8 ee 05 00 00       	call   80197b <sys_allocate_chunk>
  80138d:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801390:	a1 20 41 80 00       	mov    0x804120,%eax
  801395:	83 ec 0c             	sub    $0xc,%esp
  801398:	50                   	push   %eax
  801399:	e8 63 0c 00 00       	call   802001 <initialize_MemBlocksList>
  80139e:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8013a1:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8013a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ac:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8013b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8013b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c4:	89 c2                	mov    %eax,%edx
  8013c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c9:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8013cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013cf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8013d6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e0:	8b 50 08             	mov    0x8(%eax),%edx
  8013e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e6:	01 d0                	add    %edx,%eax
  8013e8:	48                   	dec    %eax
  8013e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f4:	f7 75 e0             	divl   -0x20(%ebp)
  8013f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013fa:	29 d0                	sub    %edx,%eax
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801401:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801404:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801408:	75 14                	jne    80141e <initialize_dyn_block_system+0x11f>
  80140a:	83 ec 04             	sub    $0x4,%esp
  80140d:	68 75 3a 80 00       	push   $0x803a75
  801412:	6a 34                	push   $0x34
  801414:	68 93 3a 80 00       	push   $0x803a93
  801419:	e8 72 ee ff ff       	call   800290 <_panic>
  80141e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801421:	8b 00                	mov    (%eax),%eax
  801423:	85 c0                	test   %eax,%eax
  801425:	74 10                	je     801437 <initialize_dyn_block_system+0x138>
  801427:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80142a:	8b 00                	mov    (%eax),%eax
  80142c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80142f:	8b 52 04             	mov    0x4(%edx),%edx
  801432:	89 50 04             	mov    %edx,0x4(%eax)
  801435:	eb 0b                	jmp    801442 <initialize_dyn_block_system+0x143>
  801437:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143a:	8b 40 04             	mov    0x4(%eax),%eax
  80143d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801445:	8b 40 04             	mov    0x4(%eax),%eax
  801448:	85 c0                	test   %eax,%eax
  80144a:	74 0f                	je     80145b <initialize_dyn_block_system+0x15c>
  80144c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144f:	8b 40 04             	mov    0x4(%eax),%eax
  801452:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801455:	8b 12                	mov    (%edx),%edx
  801457:	89 10                	mov    %edx,(%eax)
  801459:	eb 0a                	jmp    801465 <initialize_dyn_block_system+0x166>
  80145b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145e:	8b 00                	mov    (%eax),%eax
  801460:	a3 48 41 80 00       	mov    %eax,0x804148
  801465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801468:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80146e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801471:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801478:	a1 54 41 80 00       	mov    0x804154,%eax
  80147d:	48                   	dec    %eax
  80147e:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801483:	83 ec 0c             	sub    $0xc,%esp
  801486:	ff 75 e8             	pushl  -0x18(%ebp)
  801489:	e8 c4 13 00 00       	call   802852 <insert_sorted_with_merge_freeList>
  80148e:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801491:	90                   	nop
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80149a:	e8 2f fe ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80149f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a3:	75 07                	jne    8014ac <malloc+0x18>
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 71                	jmp    80151d <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8014ac:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8014b3:	76 07                	jbe    8014bc <malloc+0x28>
	return NULL;
  8014b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ba:	eb 61                	jmp    80151d <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014bc:	e8 88 08 00 00       	call   801d49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	74 53                	je     801518 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014c5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d2:	01 d0                	add    %edx,%eax
  8014d4:	48                   	dec    %eax
  8014d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014db:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e0:	f7 75 f4             	divl   -0xc(%ebp)
  8014e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e6:	29 d0                	sub    %edx,%eax
  8014e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8014f1:	e8 d2 0d 00 00       	call   8022c8 <alloc_block_FF>
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8014fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801500:	74 16                	je     801518 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	ff 75 e8             	pushl  -0x18(%ebp)
  801508:	e8 0c 0c 00 00       	call   802119 <insert_sorted_allocList>
  80150d:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801510:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801513:	8b 40 08             	mov    0x8(%eax),%eax
  801516:	eb 05                	jmp    80151d <malloc+0x89>
    }

			}


	return NULL;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80152b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801533:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	ff 75 f0             	pushl  -0x10(%ebp)
  80153c:	68 40 40 80 00       	push   $0x804040
  801541:	e8 a0 0b 00 00       	call   8020e6 <find_block>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80154c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154f:	8b 50 0c             	mov    0xc(%eax),%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	52                   	push   %edx
  801559:	50                   	push   %eax
  80155a:	e8 e4 03 00 00       	call   801943 <sys_free_user_mem>
  80155f:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801562:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801566:	75 17                	jne    80157f <free+0x60>
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	68 75 3a 80 00       	push   $0x803a75
  801570:	68 84 00 00 00       	push   $0x84
  801575:	68 93 3a 80 00       	push   $0x803a93
  80157a:	e8 11 ed ff ff       	call   800290 <_panic>
  80157f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801582:	8b 00                	mov    (%eax),%eax
  801584:	85 c0                	test   %eax,%eax
  801586:	74 10                	je     801598 <free+0x79>
  801588:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158b:	8b 00                	mov    (%eax),%eax
  80158d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801590:	8b 52 04             	mov    0x4(%edx),%edx
  801593:	89 50 04             	mov    %edx,0x4(%eax)
  801596:	eb 0b                	jmp    8015a3 <free+0x84>
  801598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159b:	8b 40 04             	mov    0x4(%eax),%eax
  80159e:	a3 44 40 80 00       	mov    %eax,0x804044
  8015a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a6:	8b 40 04             	mov    0x4(%eax),%eax
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	74 0f                	je     8015bc <free+0x9d>
  8015ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b0:	8b 40 04             	mov    0x4(%eax),%eax
  8015b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015b6:	8b 12                	mov    (%edx),%edx
  8015b8:	89 10                	mov    %edx,(%eax)
  8015ba:	eb 0a                	jmp    8015c6 <free+0xa7>
  8015bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bf:	8b 00                	mov    (%eax),%eax
  8015c1:	a3 40 40 80 00       	mov    %eax,0x804040
  8015c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015d9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015de:	48                   	dec    %eax
  8015df:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8015e4:	83 ec 0c             	sub    $0xc,%esp
  8015e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8015ea:	e8 63 12 00 00       	call   802852 <insert_sorted_with_merge_freeList>
  8015ef:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8015f2:	90                   	nop
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 38             	sub    $0x38,%esp
  8015fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fe:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801601:	e8 c8 fc ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801606:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80160a:	75 0a                	jne    801616 <smalloc+0x21>
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
  801611:	e9 a0 00 00 00       	jmp    8016b6 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801616:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80161d:	76 0a                	jbe    801629 <smalloc+0x34>
		return NULL;
  80161f:	b8 00 00 00 00       	mov    $0x0,%eax
  801624:	e9 8d 00 00 00       	jmp    8016b6 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801629:	e8 1b 07 00 00       	call   801d49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162e:	85 c0                	test   %eax,%eax
  801630:	74 7f                	je     8016b1 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801632:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163f:	01 d0                	add    %edx,%eax
  801641:	48                   	dec    %eax
  801642:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801648:	ba 00 00 00 00       	mov    $0x0,%edx
  80164d:	f7 75 f4             	divl   -0xc(%ebp)
  801650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801653:	29 d0                	sub    %edx,%eax
  801655:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	ff 75 ec             	pushl  -0x14(%ebp)
  80165e:	e8 65 0c 00 00       	call   8022c8 <alloc_block_FF>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801669:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80166d:	74 42                	je     8016b1 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	ff 75 e8             	pushl  -0x18(%ebp)
  801675:	e8 9f 0a 00 00       	call   802119 <insert_sorted_allocList>
  80167a:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80167d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801680:	8b 40 08             	mov    0x8(%eax),%eax
  801683:	89 c2                	mov    %eax,%edx
  801685:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801689:	52                   	push   %edx
  80168a:	50                   	push   %eax
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	e8 38 04 00 00       	call   801ace <sys_createSharedObject>
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  80169c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016a0:	79 07                	jns    8016a9 <smalloc+0xb4>
	    		  return NULL;
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a7:	eb 0d                	jmp    8016b6 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8016a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ac:	8b 40 08             	mov    0x8(%eax),%eax
  8016af:	eb 05                	jmp    8016b6 <smalloc+0xc1>


				}


		return NULL;
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016be:	e8 0b fc ff ff       	call   8012ce <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016c3:	e8 81 06 00 00       	call   801d49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c8:	85 c0                	test   %eax,%eax
  8016ca:	0f 84 9f 00 00 00    	je     80176f <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	e8 1a 04 00 00       	call   801af8 <sys_getSizeOfSharedObject>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8016e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e8:	79 0a                	jns    8016f4 <sget+0x3c>
		return NULL;
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ef:	e9 80 00 00 00       	jmp    801774 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016f4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801701:	01 d0                	add    %edx,%eax
  801703:	48                   	dec    %eax
  801704:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170a:	ba 00 00 00 00       	mov    $0x0,%edx
  80170f:	f7 75 f0             	divl   -0x10(%ebp)
  801712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801715:	29 d0                	sub    %edx,%eax
  801717:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80171a:	83 ec 0c             	sub    $0xc,%esp
  80171d:	ff 75 e8             	pushl  -0x18(%ebp)
  801720:	e8 a3 0b 00 00       	call   8022c8 <alloc_block_FF>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80172b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80172f:	74 3e                	je     80176f <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801731:	83 ec 0c             	sub    $0xc,%esp
  801734:	ff 75 e4             	pushl  -0x1c(%ebp)
  801737:	e8 dd 09 00 00       	call   802119 <insert_sorted_allocList>
  80173c:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80173f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801742:	8b 40 08             	mov    0x8(%eax),%eax
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	50                   	push   %eax
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	ff 75 08             	pushl  0x8(%ebp)
  80174f:	e8 c1 03 00 00       	call   801b15 <sys_getSharedObject>
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80175a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80175e:	79 07                	jns    801767 <sget+0xaf>
	    		  return NULL;
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
  801765:	eb 0d                	jmp    801774 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80176a:	8b 40 08             	mov    0x8(%eax),%eax
  80176d:	eb 05                	jmp    801774 <sget+0xbc>
	      }
	}
	   return NULL;
  80176f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80177c:	e8 4d fb ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	68 a0 3a 80 00       	push   $0x803aa0
  801789:	68 12 01 00 00       	push   $0x112
  80178e:	68 93 3a 80 00       	push   $0x803a93
  801793:	e8 f8 ea ff ff       	call   800290 <_panic>

00801798 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	68 c8 3a 80 00       	push   $0x803ac8
  8017a6:	68 26 01 00 00       	push   $0x126
  8017ab:	68 93 3a 80 00       	push   $0x803a93
  8017b0:	e8 db ea ff ff       	call   800290 <_panic>

008017b5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	68 ec 3a 80 00       	push   $0x803aec
  8017c3:	68 31 01 00 00       	push   $0x131
  8017c8:	68 93 3a 80 00       	push   $0x803a93
  8017cd:	e8 be ea ff ff       	call   800290 <_panic>

008017d2 <shrink>:

}
void shrink(uint32 newSize)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	68 ec 3a 80 00       	push   $0x803aec
  8017e0:	68 36 01 00 00       	push   $0x136
  8017e5:	68 93 3a 80 00       	push   $0x803a93
  8017ea:	e8 a1 ea ff ff       	call   800290 <_panic>

008017ef <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f5:	83 ec 04             	sub    $0x4,%esp
  8017f8:	68 ec 3a 80 00       	push   $0x803aec
  8017fd:	68 3b 01 00 00       	push   $0x13b
  801802:	68 93 3a 80 00       	push   $0x803a93
  801807:	e8 84 ea ff ff       	call   800290 <_panic>

0080180c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	57                   	push   %edi
  801810:	56                   	push   %esi
  801811:	53                   	push   %ebx
  801812:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801821:	8b 7d 18             	mov    0x18(%ebp),%edi
  801824:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801827:	cd 30                	int    $0x30
  801829:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80182c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5f                   	pop    %edi
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    

00801837 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 04             	sub    $0x4,%esp
  80183d:	8b 45 10             	mov    0x10(%ebp),%eax
  801840:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801843:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	52                   	push   %edx
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	50                   	push   %eax
  801853:	6a 00                	push   $0x0
  801855:	e8 b2 ff ff ff       	call   80180c <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	90                   	nop
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_cgetc>:

int
sys_cgetc(void)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 01                	push   $0x1
  80186f:	e8 98 ff ff ff       	call   80180c <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	52                   	push   %edx
  801889:	50                   	push   %eax
  80188a:	6a 05                	push   $0x5
  80188c:	e8 7b ff ff ff       	call   80180c <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	56                   	push   %esi
  80189a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80189b:	8b 75 18             	mov    0x18(%ebp),%esi
  80189e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	51                   	push   %ecx
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	6a 06                	push   $0x6
  8018b1:	e8 56 ff ff ff       	call   80180c <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bc:	5b                   	pop    %ebx
  8018bd:	5e                   	pop    %esi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	6a 07                	push   $0x7
  8018d3:	e8 34 ff ff ff       	call   80180c <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	ff 75 08             	pushl  0x8(%ebp)
  8018ec:	6a 08                	push   $0x8
  8018ee:	e8 19 ff ff ff       	call   80180c <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 09                	push   $0x9
  801907:	e8 00 ff ff ff       	call   80180c <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 0a                	push   $0xa
  801920:	e8 e7 fe ff ff       	call   80180c <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 0b                	push   $0xb
  801939:	e8 ce fe ff ff       	call   80180c <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	6a 0f                	push   $0xf
  801954:	e8 b3 fe ff ff       	call   80180c <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
	return;
  80195c:	90                   	nop
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	6a 10                	push   $0x10
  801970:	e8 97 fe ff ff       	call   80180c <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return ;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	ff 75 10             	pushl  0x10(%ebp)
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	6a 11                	push   $0x11
  80198d:	e8 7a fe ff ff       	call   80180c <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
	return ;
  801995:	90                   	nop
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 0c                	push   $0xc
  8019a7:	e8 60 fe ff ff       	call   80180c <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	6a 0d                	push   $0xd
  8019c1:	e8 46 fe ff ff       	call   80180c <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 0e                	push   $0xe
  8019da:	e8 2d fe ff ff       	call   80180c <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	90                   	nop
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 13                	push   $0x13
  8019f4:	e8 13 fe ff ff       	call   80180c <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	90                   	nop
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 14                	push   $0x14
  801a0e:	e8 f9 fd ff ff       	call   80180c <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a25:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	50                   	push   %eax
  801a32:	6a 15                	push   $0x15
  801a34:	e8 d3 fd ff ff       	call   80180c <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	90                   	nop
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 16                	push   $0x16
  801a4e:	e8 b9 fd ff ff       	call   80180c <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	90                   	nop
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	50                   	push   %eax
  801a69:	6a 17                	push   $0x17
  801a6b:	e8 9c fd ff ff       	call   80180c <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	52                   	push   %edx
  801a85:	50                   	push   %eax
  801a86:	6a 1a                	push   $0x1a
  801a88:	e8 7f fd ff ff       	call   80180c <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	52                   	push   %edx
  801aa2:	50                   	push   %eax
  801aa3:	6a 18                	push   $0x18
  801aa5:	e8 62 fd ff ff       	call   80180c <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	90                   	nop
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	52                   	push   %edx
  801ac0:	50                   	push   %eax
  801ac1:	6a 19                	push   $0x19
  801ac3:	e8 44 fd ff ff       	call   80180c <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	90                   	nop
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 04             	sub    $0x4,%esp
  801ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ada:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801add:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	51                   	push   %ecx
  801ae7:	52                   	push   %edx
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	50                   	push   %eax
  801aec:	6a 1b                	push   $0x1b
  801aee:	e8 19 fd ff ff       	call   80180c <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 1c                	push   $0x1c
  801b0b:	e8 fc fc ff ff       	call   80180c <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	51                   	push   %ecx
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	6a 1d                	push   $0x1d
  801b2a:	e8 dd fc ff ff       	call   80180c <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	6a 1e                	push   $0x1e
  801b47:	e8 c0 fc ff ff       	call   80180c <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 1f                	push   $0x1f
  801b60:	e8 a7 fc ff ff       	call   80180c <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	6a 00                	push   $0x0
  801b72:	ff 75 14             	pushl  0x14(%ebp)
  801b75:	ff 75 10             	pushl  0x10(%ebp)
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	50                   	push   %eax
  801b7c:	6a 20                	push   $0x20
  801b7e:	e8 89 fc ff ff       	call   80180c <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	50                   	push   %eax
  801b97:	6a 21                	push   $0x21
  801b99:	e8 6e fc ff ff       	call   80180c <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	90                   	nop
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	50                   	push   %eax
  801bb3:	6a 22                	push   $0x22
  801bb5:	e8 52 fc ff ff       	call   80180c <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 02                	push   $0x2
  801bce:	e8 39 fc ff ff       	call   80180c <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 03                	push   $0x3
  801be7:	e8 20 fc ff ff       	call   80180c <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 04                	push   $0x4
  801c00:	e8 07 fc ff ff       	call   80180c <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_exit_env>:


void sys_exit_env(void)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 23                	push   $0x23
  801c19:	e8 ee fb ff ff       	call   80180c <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	90                   	nop
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c2d:	8d 50 04             	lea    0x4(%eax),%edx
  801c30:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	52                   	push   %edx
  801c3a:	50                   	push   %eax
  801c3b:	6a 24                	push   $0x24
  801c3d:	e8 ca fb ff ff       	call   80180c <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
	return result;
  801c45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c4e:	89 01                	mov    %eax,(%ecx)
  801c50:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	c9                   	leave  
  801c57:	c2 04 00             	ret    $0x4

00801c5a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	ff 75 10             	pushl  0x10(%ebp)
  801c64:	ff 75 0c             	pushl  0xc(%ebp)
  801c67:	ff 75 08             	pushl  0x8(%ebp)
  801c6a:	6a 12                	push   $0x12
  801c6c:	e8 9b fb ff ff       	call   80180c <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
	return ;
  801c74:	90                   	nop
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 25                	push   $0x25
  801c86:	e8 81 fb ff ff       	call   80180c <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c9c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	50                   	push   %eax
  801ca9:	6a 26                	push   $0x26
  801cab:	e8 5c fb ff ff       	call   80180c <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb3:	90                   	nop
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <rsttst>:
void rsttst()
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 28                	push   $0x28
  801cc5:	e8 42 fb ff ff       	call   80180c <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccd:	90                   	nop
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cdc:	8b 55 18             	mov    0x18(%ebp),%edx
  801cdf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	ff 75 10             	pushl  0x10(%ebp)
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	ff 75 08             	pushl  0x8(%ebp)
  801cee:	6a 27                	push   $0x27
  801cf0:	e8 17 fb ff ff       	call   80180c <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <chktst>:
void chktst(uint32 n)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	ff 75 08             	pushl  0x8(%ebp)
  801d09:	6a 29                	push   $0x29
  801d0b:	e8 fc fa ff ff       	call   80180c <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
	return ;
  801d13:	90                   	nop
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <inctst>:

void inctst()
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 2a                	push   $0x2a
  801d25:	e8 e2 fa ff ff       	call   80180c <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2d:	90                   	nop
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <gettst>:
uint32 gettst()
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 2b                	push   $0x2b
  801d3f:	e8 c8 fa ff ff       	call   80180c <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 2c                	push   $0x2c
  801d5b:	e8 ac fa ff ff       	call   80180c <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
  801d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d66:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d6a:	75 07                	jne    801d73 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d71:	eb 05                	jmp    801d78 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 2c                	push   $0x2c
  801d8c:	e8 7b fa ff ff       	call   80180c <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
  801d94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d97:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d9b:	75 07                	jne    801da4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801da2:	eb 05                	jmp    801da9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 2c                	push   $0x2c
  801dbd:	e8 4a fa ff ff       	call   80180c <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
  801dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dc8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dcc:	75 07                	jne    801dd5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dce:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd3:	eb 05                	jmp    801dda <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 2c                	push   $0x2c
  801dee:	e8 19 fa ff ff       	call   80180c <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
  801df6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801df9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dfd:	75 07                	jne    801e06 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dff:	b8 01 00 00 00       	mov    $0x1,%eax
  801e04:	eb 05                	jmp    801e0b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	6a 2d                	push   $0x2d
  801e1d:	e8 ea f9 ff ff       	call   80180c <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
	return ;
  801e25:	90                   	nop
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	6a 00                	push   $0x0
  801e3a:	53                   	push   %ebx
  801e3b:	51                   	push   %ecx
  801e3c:	52                   	push   %edx
  801e3d:	50                   	push   %eax
  801e3e:	6a 2e                	push   $0x2e
  801e40:	e8 c7 f9 ff ff       	call   80180c <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	52                   	push   %edx
  801e5d:	50                   	push   %eax
  801e5e:	6a 2f                	push   $0x2f
  801e60:	e8 a7 f9 ff ff       	call   80180c <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	68 fc 3a 80 00       	push   $0x803afc
  801e78:	e8 c7 e6 ff ff       	call   800544 <cprintf>
  801e7d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	68 28 3b 80 00       	push   $0x803b28
  801e8f:	e8 b0 e6 ff ff       	call   800544 <cprintf>
  801e94:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e97:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e9b:	a1 38 41 80 00       	mov    0x804138,%eax
  801ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea3:	eb 56                	jmp    801efb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ea5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ea9:	74 1c                	je     801ec7 <print_mem_block_lists+0x5d>
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	8b 50 08             	mov    0x8(%eax),%edx
  801eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb4:	8b 48 08             	mov    0x8(%eax),%ecx
  801eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eba:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebd:	01 c8                	add    %ecx,%eax
  801ebf:	39 c2                	cmp    %eax,%edx
  801ec1:	73 04                	jae    801ec7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ec3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	8b 50 08             	mov    0x8(%eax),%edx
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed3:	01 c2                	add    %eax,%edx
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	8b 40 08             	mov    0x8(%eax),%eax
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	52                   	push   %edx
  801edf:	50                   	push   %eax
  801ee0:	68 3d 3b 80 00       	push   $0x803b3d
  801ee5:	e8 5a e6 ff ff       	call   800544 <cprintf>
  801eea:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ef3:	a1 40 41 80 00       	mov    0x804140,%eax
  801ef8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801efb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eff:	74 07                	je     801f08 <print_mem_block_lists+0x9e>
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	8b 00                	mov    (%eax),%eax
  801f06:	eb 05                	jmp    801f0d <print_mem_block_lists+0xa3>
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0d:	a3 40 41 80 00       	mov    %eax,0x804140
  801f12:	a1 40 41 80 00       	mov    0x804140,%eax
  801f17:	85 c0                	test   %eax,%eax
  801f19:	75 8a                	jne    801ea5 <print_mem_block_lists+0x3b>
  801f1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1f:	75 84                	jne    801ea5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f21:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f25:	75 10                	jne    801f37 <print_mem_block_lists+0xcd>
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	68 4c 3b 80 00       	push   $0x803b4c
  801f2f:	e8 10 e6 ff ff       	call   800544 <cprintf>
  801f34:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	68 70 3b 80 00       	push   $0x803b70
  801f46:	e8 f9 e5 ff ff       	call   800544 <cprintf>
  801f4b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f4e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f52:	a1 40 40 80 00       	mov    0x804040,%eax
  801f57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f5a:	eb 56                	jmp    801fb2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f60:	74 1c                	je     801f7e <print_mem_block_lists+0x114>
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	8b 50 08             	mov    0x8(%eax),%edx
  801f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f71:	8b 40 0c             	mov    0xc(%eax),%eax
  801f74:	01 c8                	add    %ecx,%eax
  801f76:	39 c2                	cmp    %eax,%edx
  801f78:	73 04                	jae    801f7e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f7a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	8b 50 08             	mov    0x8(%eax),%edx
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8a:	01 c2                	add    %eax,%edx
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	8b 40 08             	mov    0x8(%eax),%eax
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	52                   	push   %edx
  801f96:	50                   	push   %eax
  801f97:	68 3d 3b 80 00       	push   $0x803b3d
  801f9c:	e8 a3 e5 ff ff       	call   800544 <cprintf>
  801fa1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801faa:	a1 48 40 80 00       	mov    0x804048,%eax
  801faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb6:	74 07                	je     801fbf <print_mem_block_lists+0x155>
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 00                	mov    (%eax),%eax
  801fbd:	eb 05                	jmp    801fc4 <print_mem_block_lists+0x15a>
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc4:	a3 48 40 80 00       	mov    %eax,0x804048
  801fc9:	a1 48 40 80 00       	mov    0x804048,%eax
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	75 8a                	jne    801f5c <print_mem_block_lists+0xf2>
  801fd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd6:	75 84                	jne    801f5c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fd8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fdc:	75 10                	jne    801fee <print_mem_block_lists+0x184>
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	68 88 3b 80 00       	push   $0x803b88
  801fe6:	e8 59 e5 ff ff       	call   800544 <cprintf>
  801feb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	68 fc 3a 80 00       	push   $0x803afc
  801ff6:	e8 49 e5 ff ff       	call   800544 <cprintf>
  801ffb:	83 c4 10             	add    $0x10,%esp

}
  801ffe:	90                   	nop
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802007:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80200e:	00 00 00 
  802011:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802018:	00 00 00 
  80201b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802022:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802025:	a1 50 40 80 00       	mov    0x804050,%eax
  80202a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80202d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802034:	e9 9e 00 00 00       	jmp    8020d7 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802039:	a1 50 40 80 00       	mov    0x804050,%eax
  80203e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802041:	c1 e2 04             	shl    $0x4,%edx
  802044:	01 d0                	add    %edx,%eax
  802046:	85 c0                	test   %eax,%eax
  802048:	75 14                	jne    80205e <initialize_MemBlocksList+0x5d>
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	68 b0 3b 80 00       	push   $0x803bb0
  802052:	6a 48                	push   $0x48
  802054:	68 d3 3b 80 00       	push   $0x803bd3
  802059:	e8 32 e2 ff ff       	call   800290 <_panic>
  80205e:	a1 50 40 80 00       	mov    0x804050,%eax
  802063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802066:	c1 e2 04             	shl    $0x4,%edx
  802069:	01 d0                	add    %edx,%eax
  80206b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802071:	89 10                	mov    %edx,(%eax)
  802073:	8b 00                	mov    (%eax),%eax
  802075:	85 c0                	test   %eax,%eax
  802077:	74 18                	je     802091 <initialize_MemBlocksList+0x90>
  802079:	a1 48 41 80 00       	mov    0x804148,%eax
  80207e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802084:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802087:	c1 e1 04             	shl    $0x4,%ecx
  80208a:	01 ca                	add    %ecx,%edx
  80208c:	89 50 04             	mov    %edx,0x4(%eax)
  80208f:	eb 12                	jmp    8020a3 <initialize_MemBlocksList+0xa2>
  802091:	a1 50 40 80 00       	mov    0x804050,%eax
  802096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802099:	c1 e2 04             	shl    $0x4,%edx
  80209c:	01 d0                	add    %edx,%eax
  80209e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020a3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ab:	c1 e2 04             	shl    $0x4,%edx
  8020ae:	01 d0                	add    %edx,%eax
  8020b0:	a3 48 41 80 00       	mov    %eax,0x804148
  8020b5:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bd:	c1 e2 04             	shl    $0x4,%edx
  8020c0:	01 d0                	add    %edx,%eax
  8020c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c9:	a1 54 41 80 00       	mov    0x804154,%eax
  8020ce:	40                   	inc    %eax
  8020cf:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8020d4:	ff 45 f4             	incl   -0xc(%ebp)
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020dd:	0f 82 56 ff ff ff    	jb     802039 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8020e3:	90                   	nop
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	8b 00                	mov    (%eax),%eax
  8020f1:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8020f4:	eb 18                	jmp    80210e <find_block+0x28>
		{
			if(tmp->sva==va)
  8020f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f9:	8b 40 08             	mov    0x8(%eax),%eax
  8020fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020ff:	75 05                	jne    802106 <find_block+0x20>
			{
				return tmp;
  802101:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802104:	eb 11                	jmp    802117 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802106:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802109:	8b 00                	mov    (%eax),%eax
  80210b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80210e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802112:	75 e2                	jne    8020f6 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802114:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80211f:	a1 40 40 80 00       	mov    0x804040,%eax
  802124:	85 c0                	test   %eax,%eax
  802126:	0f 85 83 00 00 00    	jne    8021af <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80212c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802133:	00 00 00 
  802136:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80213d:	00 00 00 
  802140:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802147:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80214a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214e:	75 14                	jne    802164 <insert_sorted_allocList+0x4b>
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	68 b0 3b 80 00       	push   $0x803bb0
  802158:	6a 7f                	push   $0x7f
  80215a:	68 d3 3b 80 00       	push   $0x803bd3
  80215f:	e8 2c e1 ff ff       	call   800290 <_panic>
  802164:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	89 10                	mov    %edx,(%eax)
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	8b 00                	mov    (%eax),%eax
  802174:	85 c0                	test   %eax,%eax
  802176:	74 0d                	je     802185 <insert_sorted_allocList+0x6c>
  802178:	a1 40 40 80 00       	mov    0x804040,%eax
  80217d:	8b 55 08             	mov    0x8(%ebp),%edx
  802180:	89 50 04             	mov    %edx,0x4(%eax)
  802183:	eb 08                	jmp    80218d <insert_sorted_allocList+0x74>
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	a3 44 40 80 00       	mov    %eax,0x804044
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	a3 40 40 80 00       	mov    %eax,0x804040
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80219f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a4:	40                   	inc    %eax
  8021a5:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021aa:	e9 16 01 00 00       	jmp    8022c5 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8b 50 08             	mov    0x8(%eax),%edx
  8021b5:	a1 44 40 80 00       	mov    0x804044,%eax
  8021ba:	8b 40 08             	mov    0x8(%eax),%eax
  8021bd:	39 c2                	cmp    %eax,%edx
  8021bf:	76 68                	jbe    802229 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c5:	75 17                	jne    8021de <insert_sorted_allocList+0xc5>
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	68 ec 3b 80 00       	push   $0x803bec
  8021cf:	68 85 00 00 00       	push   $0x85
  8021d4:	68 d3 3b 80 00       	push   $0x803bd3
  8021d9:	e8 b2 e0 ff ff       	call   800290 <_panic>
  8021de:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8b 40 04             	mov    0x4(%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 0c                	je     802200 <insert_sorted_allocList+0xe7>
  8021f4:	a1 44 40 80 00       	mov    0x804044,%eax
  8021f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fc:	89 10                	mov    %edx,(%eax)
  8021fe:	eb 08                	jmp    802208 <insert_sorted_allocList+0xef>
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	a3 40 40 80 00       	mov    %eax,0x804040
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	a3 44 40 80 00       	mov    %eax,0x804044
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802219:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80221e:	40                   	inc    %eax
  80221f:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802224:	e9 9c 00 00 00       	jmp    8022c5 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802229:	a1 40 40 80 00       	mov    0x804040,%eax
  80222e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802231:	e9 85 00 00 00       	jmp    8022bb <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	8b 50 08             	mov    0x8(%eax),%edx
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 40 08             	mov    0x8(%eax),%eax
  802242:	39 c2                	cmp    %eax,%edx
  802244:	73 6d                	jae    8022b3 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224a:	74 06                	je     802252 <insert_sorted_allocList+0x139>
  80224c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802250:	75 17                	jne    802269 <insert_sorted_allocList+0x150>
  802252:	83 ec 04             	sub    $0x4,%esp
  802255:	68 10 3c 80 00       	push   $0x803c10
  80225a:	68 90 00 00 00       	push   $0x90
  80225f:	68 d3 3b 80 00       	push   $0x803bd3
  802264:	e8 27 e0 ff ff       	call   800290 <_panic>
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 50 04             	mov    0x4(%eax),%edx
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	89 50 04             	mov    %edx,0x4(%eax)
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227b:	89 10                	mov    %edx,(%eax)
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 40 04             	mov    0x4(%eax),%eax
  802283:	85 c0                	test   %eax,%eax
  802285:	74 0d                	je     802294 <insert_sorted_allocList+0x17b>
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 40 04             	mov    0x4(%eax),%eax
  80228d:	8b 55 08             	mov    0x8(%ebp),%edx
  802290:	89 10                	mov    %edx,(%eax)
  802292:	eb 08                	jmp    80229c <insert_sorted_allocList+0x183>
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 40 40 80 00       	mov    %eax,0x804040
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a2:	89 50 04             	mov    %edx,0x4(%eax)
  8022a5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022aa:	40                   	inc    %eax
  8022ab:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022b0:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022b1:	eb 12                	jmp    8022c5 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bf:	0f 85 71 ff ff ff    	jne    802236 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022c5:	90                   	nop
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8022ce:	a1 38 41 80 00       	mov    0x804138,%eax
  8022d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8022d6:	e9 76 01 00 00       	jmp    802451 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e4:	0f 85 8a 00 00 00    	jne    802374 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8022ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ee:	75 17                	jne    802307 <alloc_block_FF+0x3f>
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	68 45 3c 80 00       	push   $0x803c45
  8022f8:	68 a8 00 00 00       	push   $0xa8
  8022fd:	68 d3 3b 80 00       	push   $0x803bd3
  802302:	e8 89 df ff ff       	call   800290 <_panic>
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 00                	mov    (%eax),%eax
  80230c:	85 c0                	test   %eax,%eax
  80230e:	74 10                	je     802320 <alloc_block_FF+0x58>
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 00                	mov    (%eax),%eax
  802315:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802318:	8b 52 04             	mov    0x4(%edx),%edx
  80231b:	89 50 04             	mov    %edx,0x4(%eax)
  80231e:	eb 0b                	jmp    80232b <alloc_block_FF+0x63>
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 04             	mov    0x4(%eax),%eax
  802326:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 40 04             	mov    0x4(%eax),%eax
  802331:	85 c0                	test   %eax,%eax
  802333:	74 0f                	je     802344 <alloc_block_FF+0x7c>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 40 04             	mov    0x4(%eax),%eax
  80233b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233e:	8b 12                	mov    (%edx),%edx
  802340:	89 10                	mov    %edx,(%eax)
  802342:	eb 0a                	jmp    80234e <alloc_block_FF+0x86>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	a3 38 41 80 00       	mov    %eax,0x804138
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802361:	a1 44 41 80 00       	mov    0x804144,%eax
  802366:	48                   	dec    %eax
  802367:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	e9 ea 00 00 00       	jmp    80245e <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 40 0c             	mov    0xc(%eax),%eax
  80237a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80237d:	0f 86 c6 00 00 00    	jbe    802449 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802383:	a1 48 41 80 00       	mov    0x804148,%eax
  802388:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	8b 55 08             	mov    0x8(%ebp),%edx
  802391:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 50 08             	mov    0x8(%eax),%edx
  80239a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239d:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a9:	89 c2                	mov    %eax,%edx
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 50 08             	mov    0x8(%eax),%edx
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	01 c2                	add    %eax,%edx
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c6:	75 17                	jne    8023df <alloc_block_FF+0x117>
  8023c8:	83 ec 04             	sub    $0x4,%esp
  8023cb:	68 45 3c 80 00       	push   $0x803c45
  8023d0:	68 b6 00 00 00       	push   $0xb6
  8023d5:	68 d3 3b 80 00       	push   $0x803bd3
  8023da:	e8 b1 de ff ff       	call   800290 <_panic>
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	74 10                	je     8023f8 <alloc_block_FF+0x130>
  8023e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f0:	8b 52 04             	mov    0x4(%edx),%edx
  8023f3:	89 50 04             	mov    %edx,0x4(%eax)
  8023f6:	eb 0b                	jmp    802403 <alloc_block_FF+0x13b>
  8023f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fb:	8b 40 04             	mov    0x4(%eax),%eax
  8023fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	8b 40 04             	mov    0x4(%eax),%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	74 0f                	je     80241c <alloc_block_FF+0x154>
  80240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802416:	8b 12                	mov    (%edx),%edx
  802418:	89 10                	mov    %edx,(%eax)
  80241a:	eb 0a                	jmp    802426 <alloc_block_FF+0x15e>
  80241c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	a3 48 41 80 00       	mov    %eax,0x804148
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802439:	a1 54 41 80 00       	mov    0x804154,%eax
  80243e:	48                   	dec    %eax
  80243f:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	eb 15                	jmp    80245e <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802451:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802455:	0f 85 80 fe ff ff    	jne    8022db <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802466:	a1 38 41 80 00       	mov    0x804138,%eax
  80246b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80246e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802475:	e9 c0 00 00 00       	jmp    80253a <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 0c             	mov    0xc(%eax),%eax
  802480:	3b 45 08             	cmp    0x8(%ebp),%eax
  802483:	0f 85 8a 00 00 00    	jne    802513 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248d:	75 17                	jne    8024a6 <alloc_block_BF+0x46>
  80248f:	83 ec 04             	sub    $0x4,%esp
  802492:	68 45 3c 80 00       	push   $0x803c45
  802497:	68 cf 00 00 00       	push   $0xcf
  80249c:	68 d3 3b 80 00       	push   $0x803bd3
  8024a1:	e8 ea dd ff ff       	call   800290 <_panic>
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 00                	mov    (%eax),%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 10                	je     8024bf <alloc_block_BF+0x5f>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b7:	8b 52 04             	mov    0x4(%edx),%edx
  8024ba:	89 50 04             	mov    %edx,0x4(%eax)
  8024bd:	eb 0b                	jmp    8024ca <alloc_block_BF+0x6a>
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 40 04             	mov    0x4(%eax),%eax
  8024c5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 40 04             	mov    0x4(%eax),%eax
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	74 0f                	je     8024e3 <alloc_block_BF+0x83>
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 04             	mov    0x4(%eax),%eax
  8024da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dd:	8b 12                	mov    (%edx),%edx
  8024df:	89 10                	mov    %edx,(%eax)
  8024e1:	eb 0a                	jmp    8024ed <alloc_block_BF+0x8d>
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 00                	mov    (%eax),%eax
  8024e8:	a3 38 41 80 00       	mov    %eax,0x804138
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802500:	a1 44 41 80 00       	mov    0x804144,%eax
  802505:	48                   	dec    %eax
  802506:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	e9 2a 01 00 00       	jmp    80263d <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 40 0c             	mov    0xc(%eax),%eax
  802519:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80251c:	73 14                	jae    802532 <alloc_block_BF+0xd2>
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 40 0c             	mov    0xc(%eax),%eax
  802524:	3b 45 08             	cmp    0x8(%ebp),%eax
  802527:	76 09                	jbe    802532 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 40 0c             	mov    0xc(%eax),%eax
  80252f:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80253a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253e:	0f 85 36 ff ff ff    	jne    80247a <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802544:	a1 38 41 80 00       	mov    0x804138,%eax
  802549:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80254c:	e9 dd 00 00 00       	jmp    80262e <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 0c             	mov    0xc(%eax),%eax
  802557:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80255a:	0f 85 c6 00 00 00    	jne    802626 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802560:	a1 48 41 80 00       	mov    0x804148,%eax
  802565:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 50 08             	mov    0x8(%eax),%edx
  80256e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802571:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802577:	8b 55 08             	mov    0x8(%ebp),%edx
  80257a:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 50 08             	mov    0x8(%eax),%edx
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	01 c2                	add    %eax,%edx
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 40 0c             	mov    0xc(%eax),%eax
  802594:	2b 45 08             	sub    0x8(%ebp),%eax
  802597:	89 c2                	mov    %eax,%edx
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80259f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025a3:	75 17                	jne    8025bc <alloc_block_BF+0x15c>
  8025a5:	83 ec 04             	sub    $0x4,%esp
  8025a8:	68 45 3c 80 00       	push   $0x803c45
  8025ad:	68 eb 00 00 00       	push   $0xeb
  8025b2:	68 d3 3b 80 00       	push   $0x803bd3
  8025b7:	e8 d4 dc ff ff       	call   800290 <_panic>
  8025bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	74 10                	je     8025d5 <alloc_block_BF+0x175>
  8025c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025cd:	8b 52 04             	mov    0x4(%edx),%edx
  8025d0:	89 50 04             	mov    %edx,0x4(%eax)
  8025d3:	eb 0b                	jmp    8025e0 <alloc_block_BF+0x180>
  8025d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d8:	8b 40 04             	mov    0x4(%eax),%eax
  8025db:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e3:	8b 40 04             	mov    0x4(%eax),%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	74 0f                	je     8025f9 <alloc_block_BF+0x199>
  8025ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ed:	8b 40 04             	mov    0x4(%eax),%eax
  8025f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f3:	8b 12                	mov    (%edx),%edx
  8025f5:	89 10                	mov    %edx,(%eax)
  8025f7:	eb 0a                	jmp    802603 <alloc_block_BF+0x1a3>
  8025f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	a3 48 41 80 00       	mov    %eax,0x804148
  802603:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802606:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802616:	a1 54 41 80 00       	mov    0x804154,%eax
  80261b:	48                   	dec    %eax
  80261c:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802624:	eb 17                	jmp    80263d <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80262e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802632:	0f 85 19 ff ff ff    	jne    802551 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802638:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802645:	a1 40 40 80 00       	mov    0x804040,%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	75 19                	jne    802667 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80264e:	83 ec 0c             	sub    $0xc,%esp
  802651:	ff 75 08             	pushl  0x8(%ebp)
  802654:	e8 6f fc ff ff       	call   8022c8 <alloc_block_FF>
  802659:	83 c4 10             	add    $0x10,%esp
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	e9 e9 01 00 00       	jmp    802850 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802667:	a1 44 40 80 00       	mov    0x804044,%eax
  80266c:	8b 40 08             	mov    0x8(%eax),%eax
  80266f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802672:	a1 44 40 80 00       	mov    0x804044,%eax
  802677:	8b 50 0c             	mov    0xc(%eax),%edx
  80267a:	a1 44 40 80 00       	mov    0x804044,%eax
  80267f:	8b 40 08             	mov    0x8(%eax),%eax
  802682:	01 d0                	add    %edx,%eax
  802684:	83 ec 08             	sub    $0x8,%esp
  802687:	50                   	push   %eax
  802688:	68 38 41 80 00       	push   $0x804138
  80268d:	e8 54 fa ff ff       	call   8020e6 <find_block>
  802692:	83 c4 10             	add    $0x10,%esp
  802695:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 40 0c             	mov    0xc(%eax),%eax
  80269e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a1:	0f 85 9b 00 00 00    	jne    802742 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 40 08             	mov    0x8(%eax),%eax
  8026b3:	01 d0                	add    %edx,%eax
  8026b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8026b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bc:	75 17                	jne    8026d5 <alloc_block_NF+0x96>
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	68 45 3c 80 00       	push   $0x803c45
  8026c6:	68 1a 01 00 00       	push   $0x11a
  8026cb:	68 d3 3b 80 00       	push   $0x803bd3
  8026d0:	e8 bb db ff ff       	call   800290 <_panic>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	74 10                	je     8026ee <alloc_block_NF+0xaf>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e6:	8b 52 04             	mov    0x4(%edx),%edx
  8026e9:	89 50 04             	mov    %edx,0x4(%eax)
  8026ec:	eb 0b                	jmp    8026f9 <alloc_block_NF+0xba>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 0f                	je     802712 <alloc_block_NF+0xd3>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	8b 12                	mov    (%edx),%edx
  80270e:	89 10                	mov    %edx,(%eax)
  802710:	eb 0a                	jmp    80271c <alloc_block_NF+0xdd>
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 00                	mov    (%eax),%eax
  802717:	a3 38 41 80 00       	mov    %eax,0x804138
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272f:	a1 44 41 80 00       	mov    0x804144,%eax
  802734:	48                   	dec    %eax
  802735:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	e9 0e 01 00 00       	jmp    802850 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274b:	0f 86 cf 00 00 00    	jbe    802820 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802751:	a1 48 41 80 00       	mov    0x804148,%eax
  802756:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275c:	8b 55 08             	mov    0x8(%ebp),%edx
  80275f:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 50 08             	mov    0x8(%eax),%edx
  802768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276b:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 50 08             	mov    0x8(%eax),%edx
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	01 c2                	add    %eax,%edx
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 0c             	mov    0xc(%eax),%eax
  802785:	2b 45 08             	sub    0x8(%ebp),%eax
  802788:	89 c2                	mov    %eax,%edx
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 40 08             	mov    0x8(%eax),%eax
  802796:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802799:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80279d:	75 17                	jne    8027b6 <alloc_block_NF+0x177>
  80279f:	83 ec 04             	sub    $0x4,%esp
  8027a2:	68 45 3c 80 00       	push   $0x803c45
  8027a7:	68 28 01 00 00       	push   $0x128
  8027ac:	68 d3 3b 80 00       	push   $0x803bd3
  8027b1:	e8 da da ff ff       	call   800290 <_panic>
  8027b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	74 10                	je     8027cf <alloc_block_NF+0x190>
  8027bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027c7:	8b 52 04             	mov    0x4(%edx),%edx
  8027ca:	89 50 04             	mov    %edx,0x4(%eax)
  8027cd:	eb 0b                	jmp    8027da <alloc_block_NF+0x19b>
  8027cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d2:	8b 40 04             	mov    0x4(%eax),%eax
  8027d5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	74 0f                	je     8027f3 <alloc_block_NF+0x1b4>
  8027e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ed:	8b 12                	mov    (%edx),%edx
  8027ef:	89 10                	mov    %edx,(%eax)
  8027f1:	eb 0a                	jmp    8027fd <alloc_block_NF+0x1be>
  8027f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	a3 48 41 80 00       	mov    %eax,0x804148
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802809:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802810:	a1 54 41 80 00       	mov    0x804154,%eax
  802815:	48                   	dec    %eax
  802816:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	eb 30                	jmp    802850 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802820:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802825:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802828:	75 0a                	jne    802834 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80282a:	a1 38 41 80 00       	mov    0x804138,%eax
  80282f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802832:	eb 08                	jmp    80283c <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 00                	mov    (%eax),%eax
  802839:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 08             	mov    0x8(%eax),%eax
  802842:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802845:	0f 85 4d fe ff ff    	jne    802698 <alloc_block_NF+0x59>

			return NULL;
  80284b:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802850:	c9                   	leave  
  802851:	c3                   	ret    

00802852 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
  802855:	53                   	push   %ebx
  802856:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802859:	a1 38 41 80 00       	mov    0x804138,%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	0f 85 86 00 00 00    	jne    8028ec <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802866:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80286d:	00 00 00 
  802870:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802877:	00 00 00 
  80287a:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802881:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802884:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802888:	75 17                	jne    8028a1 <insert_sorted_with_merge_freeList+0x4f>
  80288a:	83 ec 04             	sub    $0x4,%esp
  80288d:	68 b0 3b 80 00       	push   $0x803bb0
  802892:	68 48 01 00 00       	push   $0x148
  802897:	68 d3 3b 80 00       	push   $0x803bd3
  80289c:	e8 ef d9 ff ff       	call   800290 <_panic>
  8028a1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	89 10                	mov    %edx,(%eax)
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 0d                	je     8028c2 <insert_sorted_with_merge_freeList+0x70>
  8028b5:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bd:	89 50 04             	mov    %edx,0x4(%eax)
  8028c0:	eb 08                	jmp    8028ca <insert_sorted_with_merge_freeList+0x78>
  8028c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	a3 38 41 80 00       	mov    %eax,0x804138
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dc:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e1:	40                   	inc    %eax
  8028e2:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8028e7:	e9 73 07 00 00       	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	8b 50 08             	mov    0x8(%eax),%edx
  8028f2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028f7:	8b 40 08             	mov    0x8(%eax),%eax
  8028fa:	39 c2                	cmp    %eax,%edx
  8028fc:	0f 86 84 00 00 00    	jbe    802986 <insert_sorted_with_merge_freeList+0x134>
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	8b 50 08             	mov    0x8(%eax),%edx
  802908:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80290d:	8b 48 0c             	mov    0xc(%eax),%ecx
  802910:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802915:	8b 40 08             	mov    0x8(%eax),%eax
  802918:	01 c8                	add    %ecx,%eax
  80291a:	39 c2                	cmp    %eax,%edx
  80291c:	74 68                	je     802986 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  80291e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802922:	75 17                	jne    80293b <insert_sorted_with_merge_freeList+0xe9>
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	68 ec 3b 80 00       	push   $0x803bec
  80292c:	68 4c 01 00 00       	push   $0x14c
  802931:	68 d3 3b 80 00       	push   $0x803bd3
  802936:	e8 55 d9 ff ff       	call   800290 <_panic>
  80293b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	89 50 04             	mov    %edx,0x4(%eax)
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 0c                	je     80295d <insert_sorted_with_merge_freeList+0x10b>
  802951:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802956:	8b 55 08             	mov    0x8(%ebp),%edx
  802959:	89 10                	mov    %edx,(%eax)
  80295b:	eb 08                	jmp    802965 <insert_sorted_with_merge_freeList+0x113>
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	a3 38 41 80 00       	mov    %eax,0x804138
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802976:	a1 44 41 80 00       	mov    0x804144,%eax
  80297b:	40                   	inc    %eax
  80297c:	a3 44 41 80 00       	mov    %eax,0x804144
  802981:	e9 d9 06 00 00       	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	8b 50 08             	mov    0x8(%eax),%edx
  80298c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802991:	8b 40 08             	mov    0x8(%eax),%eax
  802994:	39 c2                	cmp    %eax,%edx
  802996:	0f 86 b5 00 00 00    	jbe    802a51 <insert_sorted_with_merge_freeList+0x1ff>
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	8b 50 08             	mov    0x8(%eax),%edx
  8029a2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029a7:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029aa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029af:	8b 40 08             	mov    0x8(%eax),%eax
  8029b2:	01 c8                	add    %ecx,%eax
  8029b4:	39 c2                	cmp    %eax,%edx
  8029b6:	0f 85 95 00 00 00    	jne    802a51 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029bc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029c1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029c7:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8029d0:	01 ca                	add    %ecx,%edx
  8029d2:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ed:	75 17                	jne    802a06 <insert_sorted_with_merge_freeList+0x1b4>
  8029ef:	83 ec 04             	sub    $0x4,%esp
  8029f2:	68 b0 3b 80 00       	push   $0x803bb0
  8029f7:	68 54 01 00 00       	push   $0x154
  8029fc:	68 d3 3b 80 00       	push   $0x803bd3
  802a01:	e8 8a d8 ff ff       	call   800290 <_panic>
  802a06:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	89 10                	mov    %edx,(%eax)
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	85 c0                	test   %eax,%eax
  802a18:	74 0d                	je     802a27 <insert_sorted_with_merge_freeList+0x1d5>
  802a1a:	a1 48 41 80 00       	mov    0x804148,%eax
  802a1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	eb 08                	jmp    802a2f <insert_sorted_with_merge_freeList+0x1dd>
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	a3 48 41 80 00       	mov    %eax,0x804148
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a41:	a1 54 41 80 00       	mov    0x804154,%eax
  802a46:	40                   	inc    %eax
  802a47:	a3 54 41 80 00       	mov    %eax,0x804154
  802a4c:	e9 0e 06 00 00       	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	8b 50 08             	mov    0x8(%eax),%edx
  802a57:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5c:	8b 40 08             	mov    0x8(%eax),%eax
  802a5f:	39 c2                	cmp    %eax,%edx
  802a61:	0f 83 c1 00 00 00    	jae    802b28 <insert_sorted_with_merge_freeList+0x2d6>
  802a67:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6c:	8b 50 08             	mov    0x8(%eax),%edx
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	8b 48 08             	mov    0x8(%eax),%ecx
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7b:	01 c8                	add    %ecx,%eax
  802a7d:	39 c2                	cmp    %eax,%edx
  802a7f:	0f 85 a3 00 00 00    	jne    802b28 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802a85:	a1 38 41 80 00       	mov    0x804138,%eax
  802a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8d:	8b 52 08             	mov    0x8(%edx),%edx
  802a90:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802a93:	a1 38 41 80 00       	mov    0x804138,%eax
  802a98:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a9e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa4:	8b 52 0c             	mov    0xc(%edx),%edx
  802aa7:	01 ca                	add    %ecx,%edx
  802aa9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ac0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac4:	75 17                	jne    802add <insert_sorted_with_merge_freeList+0x28b>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 b0 3b 80 00       	push   $0x803bb0
  802ace:	68 5d 01 00 00       	push   $0x15d
  802ad3:	68 d3 3b 80 00       	push   $0x803bd3
  802ad8:	e8 b3 d7 ff ff       	call   800290 <_panic>
  802add:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 0d                	je     802afe <insert_sorted_with_merge_freeList+0x2ac>
  802af1:	a1 48 41 80 00       	mov    0x804148,%eax
  802af6:	8b 55 08             	mov    0x8(%ebp),%edx
  802af9:	89 50 04             	mov    %edx,0x4(%eax)
  802afc:	eb 08                	jmp    802b06 <insert_sorted_with_merge_freeList+0x2b4>
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	a3 48 41 80 00       	mov    %eax,0x804148
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b18:	a1 54 41 80 00       	mov    0x804154,%eax
  802b1d:	40                   	inc    %eax
  802b1e:	a3 54 41 80 00       	mov    %eax,0x804154
  802b23:	e9 37 05 00 00       	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	8b 50 08             	mov    0x8(%eax),%edx
  802b2e:	a1 38 41 80 00       	mov    0x804138,%eax
  802b33:	8b 40 08             	mov    0x8(%eax),%eax
  802b36:	39 c2                	cmp    %eax,%edx
  802b38:	0f 83 82 00 00 00    	jae    802bc0 <insert_sorted_with_merge_freeList+0x36e>
  802b3e:	a1 38 41 80 00       	mov    0x804138,%eax
  802b43:	8b 50 08             	mov    0x8(%eax),%edx
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	8b 48 08             	mov    0x8(%eax),%ecx
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b52:	01 c8                	add    %ecx,%eax
  802b54:	39 c2                	cmp    %eax,%edx
  802b56:	74 68                	je     802bc0 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5c:	75 17                	jne    802b75 <insert_sorted_with_merge_freeList+0x323>
  802b5e:	83 ec 04             	sub    $0x4,%esp
  802b61:	68 b0 3b 80 00       	push   $0x803bb0
  802b66:	68 62 01 00 00       	push   $0x162
  802b6b:	68 d3 3b 80 00       	push   $0x803bd3
  802b70:	e8 1b d7 ff ff       	call   800290 <_panic>
  802b75:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	89 10                	mov    %edx,(%eax)
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8b 00                	mov    (%eax),%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	74 0d                	je     802b96 <insert_sorted_with_merge_freeList+0x344>
  802b89:	a1 38 41 80 00       	mov    0x804138,%eax
  802b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b91:	89 50 04             	mov    %edx,0x4(%eax)
  802b94:	eb 08                	jmp    802b9e <insert_sorted_with_merge_freeList+0x34c>
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	a3 38 41 80 00       	mov    %eax,0x804138
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb0:	a1 44 41 80 00       	mov    0x804144,%eax
  802bb5:	40                   	inc    %eax
  802bb6:	a3 44 41 80 00       	mov    %eax,0x804144
  802bbb:	e9 9f 04 00 00       	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802bc0:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802bca:	e9 84 04 00 00       	jmp    803053 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 50 08             	mov    0x8(%eax),%edx
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	8b 40 08             	mov    0x8(%eax),%eax
  802bdb:	39 c2                	cmp    %eax,%edx
  802bdd:	0f 86 a9 00 00 00    	jbe    802c8c <insert_sorted_with_merge_freeList+0x43a>
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 50 08             	mov    0x8(%eax),%edx
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	8b 48 08             	mov    0x8(%eax),%ecx
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf5:	01 c8                	add    %ecx,%eax
  802bf7:	39 c2                	cmp    %eax,%edx
  802bf9:	0f 84 8d 00 00 00    	je     802c8c <insert_sorted_with_merge_freeList+0x43a>
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	8b 50 08             	mov    0x8(%eax),%edx
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	8b 48 08             	mov    0x8(%eax),%ecx
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	01 c8                	add    %ecx,%eax
  802c19:	39 c2                	cmp    %eax,%edx
  802c1b:	74 6f                	je     802c8c <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c21:	74 06                	je     802c29 <insert_sorted_with_merge_freeList+0x3d7>
  802c23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c27:	75 17                	jne    802c40 <insert_sorted_with_merge_freeList+0x3ee>
  802c29:	83 ec 04             	sub    $0x4,%esp
  802c2c:	68 10 3c 80 00       	push   $0x803c10
  802c31:	68 6b 01 00 00       	push   $0x16b
  802c36:	68 d3 3b 80 00       	push   $0x803bd3
  802c3b:	e8 50 d6 ff ff       	call   800290 <_panic>
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 50 04             	mov    0x4(%eax),%edx
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	89 50 04             	mov    %edx,0x4(%eax)
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c52:	89 10                	mov    %edx,(%eax)
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	85 c0                	test   %eax,%eax
  802c5c:	74 0d                	je     802c6b <insert_sorted_with_merge_freeList+0x419>
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 04             	mov    0x4(%eax),%eax
  802c64:	8b 55 08             	mov    0x8(%ebp),%edx
  802c67:	89 10                	mov    %edx,(%eax)
  802c69:	eb 08                	jmp    802c73 <insert_sorted_with_merge_freeList+0x421>
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	a3 38 41 80 00       	mov    %eax,0x804138
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 55 08             	mov    0x8(%ebp),%edx
  802c79:	89 50 04             	mov    %edx,0x4(%eax)
  802c7c:	a1 44 41 80 00       	mov    0x804144,%eax
  802c81:	40                   	inc    %eax
  802c82:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802c87:	e9 d3 03 00 00       	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 50 08             	mov    0x8(%eax),%edx
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	8b 40 08             	mov    0x8(%eax),%eax
  802c98:	39 c2                	cmp    %eax,%edx
  802c9a:	0f 86 da 00 00 00    	jbe    802d7a <insert_sorted_with_merge_freeList+0x528>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 50 08             	mov    0x8(%eax),%edx
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	8b 48 08             	mov    0x8(%eax),%ecx
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb2:	01 c8                	add    %ecx,%eax
  802cb4:	39 c2                	cmp    %eax,%edx
  802cb6:	0f 85 be 00 00 00    	jne    802d7a <insert_sorted_with_merge_freeList+0x528>
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	8b 50 08             	mov    0x8(%eax),%edx
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	8b 48 08             	mov    0x8(%eax),%ecx
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd4:	01 c8                	add    %ecx,%eax
  802cd6:	39 c2                	cmp    %eax,%edx
  802cd8:	0f 84 9c 00 00 00    	je     802d7a <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	8b 50 08             	mov    0x8(%eax),%edx
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf6:	01 c2                	add    %eax,%edx
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d16:	75 17                	jne    802d2f <insert_sorted_with_merge_freeList+0x4dd>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 b0 3b 80 00       	push   $0x803bb0
  802d20:	68 74 01 00 00       	push   $0x174
  802d25:	68 d3 3b 80 00       	push   $0x803bd3
  802d2a:	e8 61 d5 ff ff       	call   800290 <_panic>
  802d2f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	89 10                	mov    %edx,(%eax)
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 0d                	je     802d50 <insert_sorted_with_merge_freeList+0x4fe>
  802d43:	a1 48 41 80 00       	mov    0x804148,%eax
  802d48:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4b:	89 50 04             	mov    %edx,0x4(%eax)
  802d4e:	eb 08                	jmp    802d58 <insert_sorted_with_merge_freeList+0x506>
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6f:	40                   	inc    %eax
  802d70:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d75:	e9 e5 02 00 00       	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 40 08             	mov    0x8(%eax),%eax
  802d86:	39 c2                	cmp    %eax,%edx
  802d88:	0f 86 d7 00 00 00    	jbe    802e65 <insert_sorted_with_merge_freeList+0x613>
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 50 08             	mov    0x8(%eax),%edx
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 48 08             	mov    0x8(%eax),%ecx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802da0:	01 c8                	add    %ecx,%eax
  802da2:	39 c2                	cmp    %eax,%edx
  802da4:	0f 84 bb 00 00 00    	je     802e65 <insert_sorted_with_merge_freeList+0x613>
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	8b 50 08             	mov    0x8(%eax),%edx
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	8b 48 08             	mov    0x8(%eax),%ecx
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 40 04             	mov    0x4(%eax),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	01 c8                	add    %ecx,%eax
  802dc4:	39 c2                	cmp    %eax,%edx
  802dc6:	0f 85 99 00 00 00    	jne    802e65 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd8:	8b 50 0c             	mov    0xc(%eax),%edx
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	8b 40 0c             	mov    0xc(%eax),%eax
  802de1:	01 c2                	add    %eax,%edx
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e01:	75 17                	jne    802e1a <insert_sorted_with_merge_freeList+0x5c8>
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	68 b0 3b 80 00       	push   $0x803bb0
  802e0b:	68 7d 01 00 00       	push   $0x17d
  802e10:	68 d3 3b 80 00       	push   $0x803bd3
  802e15:	e8 76 d4 ff ff       	call   800290 <_panic>
  802e1a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	89 10                	mov    %edx,(%eax)
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	74 0d                	je     802e3b <insert_sorted_with_merge_freeList+0x5e9>
  802e2e:	a1 48 41 80 00       	mov    0x804148,%eax
  802e33:	8b 55 08             	mov    0x8(%ebp),%edx
  802e36:	89 50 04             	mov    %edx,0x4(%eax)
  802e39:	eb 08                	jmp    802e43 <insert_sorted_with_merge_freeList+0x5f1>
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	a3 48 41 80 00       	mov    %eax,0x804148
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e55:	a1 54 41 80 00       	mov    0x804154,%eax
  802e5a:	40                   	inc    %eax
  802e5b:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e60:	e9 fa 01 00 00       	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 50 08             	mov    0x8(%eax),%edx
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 40 08             	mov    0x8(%eax),%eax
  802e71:	39 c2                	cmp    %eax,%edx
  802e73:	0f 86 d2 01 00 00    	jbe    80304b <insert_sorted_with_merge_freeList+0x7f9>
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 50 08             	mov    0x8(%eax),%edx
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	8b 48 08             	mov    0x8(%eax),%ecx
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8b:	01 c8                	add    %ecx,%eax
  802e8d:	39 c2                	cmp    %eax,%edx
  802e8f:	0f 85 b6 01 00 00    	jne    80304b <insert_sorted_with_merge_freeList+0x7f9>
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	8b 50 08             	mov    0x8(%eax),%edx
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	8b 48 08             	mov    0x8(%eax),%ecx
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 40 04             	mov    0x4(%eax),%eax
  802eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ead:	01 c8                	add    %ecx,%eax
  802eaf:	39 c2                	cmp    %eax,%edx
  802eb1:	0f 85 94 01 00 00    	jne    80304b <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec0:	8b 52 04             	mov    0x4(%edx),%edx
  802ec3:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec9:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecf:	8b 52 0c             	mov    0xc(%edx),%edx
  802ed2:	01 da                	add    %ebx,%edx
  802ed4:	01 ca                	add    %ecx,%edx
  802ed6:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef1:	75 17                	jne    802f0a <insert_sorted_with_merge_freeList+0x6b8>
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	68 45 3c 80 00       	push   $0x803c45
  802efb:	68 86 01 00 00       	push   $0x186
  802f00:	68 d3 3b 80 00       	push   $0x803bd3
  802f05:	e8 86 d3 ff ff       	call   800290 <_panic>
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	74 10                	je     802f23 <insert_sorted_with_merge_freeList+0x6d1>
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1b:	8b 52 04             	mov    0x4(%edx),%edx
  802f1e:	89 50 04             	mov    %edx,0x4(%eax)
  802f21:	eb 0b                	jmp    802f2e <insert_sorted_with_merge_freeList+0x6dc>
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0f                	je     802f47 <insert_sorted_with_merge_freeList+0x6f5>
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f41:	8b 12                	mov    (%edx),%edx
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	eb 0a                	jmp    802f51 <insert_sorted_with_merge_freeList+0x6ff>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	a3 38 41 80 00       	mov    %eax,0x804138
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f64:	a1 44 41 80 00       	mov    0x804144,%eax
  802f69:	48                   	dec    %eax
  802f6a:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f73:	75 17                	jne    802f8c <insert_sorted_with_merge_freeList+0x73a>
  802f75:	83 ec 04             	sub    $0x4,%esp
  802f78:	68 b0 3b 80 00       	push   $0x803bb0
  802f7d:	68 87 01 00 00       	push   $0x187
  802f82:	68 d3 3b 80 00       	push   $0x803bd3
  802f87:	e8 04 d3 ff ff       	call   800290 <_panic>
  802f8c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	89 10                	mov    %edx,(%eax)
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	74 0d                	je     802fad <insert_sorted_with_merge_freeList+0x75b>
  802fa0:	a1 48 41 80 00       	mov    0x804148,%eax
  802fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa8:	89 50 04             	mov    %edx,0x4(%eax)
  802fab:	eb 08                	jmp    802fb5 <insert_sorted_with_merge_freeList+0x763>
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	a3 48 41 80 00       	mov    %eax,0x804148
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc7:	a1 54 41 80 00       	mov    0x804154,%eax
  802fcc:	40                   	inc    %eax
  802fcd:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fe6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fea:	75 17                	jne    803003 <insert_sorted_with_merge_freeList+0x7b1>
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 b0 3b 80 00       	push   $0x803bb0
  802ff4:	68 8a 01 00 00       	push   $0x18a
  802ff9:	68 d3 3b 80 00       	push   $0x803bd3
  802ffe:	e8 8d d2 ff ff       	call   800290 <_panic>
  803003:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 0d                	je     803024 <insert_sorted_with_merge_freeList+0x7d2>
  803017:	a1 48 41 80 00       	mov    0x804148,%eax
  80301c:	8b 55 08             	mov    0x8(%ebp),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 08                	jmp    80302c <insert_sorted_with_merge_freeList+0x7da>
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	a3 48 41 80 00       	mov    %eax,0x804148
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303e:	a1 54 41 80 00       	mov    0x804154,%eax
  803043:	40                   	inc    %eax
  803044:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803049:	eb 14                	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	8b 00                	mov    (%eax),%eax
  803050:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803057:	0f 85 72 fb ff ff    	jne    802bcf <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80305d:	eb 00                	jmp    80305f <insert_sorted_with_merge_freeList+0x80d>
  80305f:	90                   	nop
  803060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803063:	c9                   	leave  
  803064:	c3                   	ret    

00803065 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803065:	55                   	push   %ebp
  803066:	89 e5                	mov    %esp,%ebp
  803068:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80306b:	8b 55 08             	mov    0x8(%ebp),%edx
  80306e:	89 d0                	mov    %edx,%eax
  803070:	c1 e0 02             	shl    $0x2,%eax
  803073:	01 d0                	add    %edx,%eax
  803075:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80307c:	01 d0                	add    %edx,%eax
  80307e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803085:	01 d0                	add    %edx,%eax
  803087:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80308e:	01 d0                	add    %edx,%eax
  803090:	c1 e0 04             	shl    $0x4,%eax
  803093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80309d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030a0:	83 ec 0c             	sub    $0xc,%esp
  8030a3:	50                   	push   %eax
  8030a4:	e8 7b eb ff ff       	call   801c24 <sys_get_virtual_time>
  8030a9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030ac:	eb 41                	jmp    8030ef <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030b1:	83 ec 0c             	sub    $0xc,%esp
  8030b4:	50                   	push   %eax
  8030b5:	e8 6a eb ff ff       	call   801c24 <sys_get_virtual_time>
  8030ba:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c3:	29 c2                	sub    %eax,%edx
  8030c5:	89 d0                	mov    %edx,%eax
  8030c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d0:	89 d1                	mov    %edx,%ecx
  8030d2:	29 c1                	sub    %eax,%ecx
  8030d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030da:	39 c2                	cmp    %eax,%edx
  8030dc:	0f 97 c0             	seta   %al
  8030df:	0f b6 c0             	movzbl %al,%eax
  8030e2:	29 c1                	sub    %eax,%ecx
  8030e4:	89 c8                	mov    %ecx,%eax
  8030e6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030f5:	72 b7                	jb     8030ae <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030f7:	90                   	nop
  8030f8:	c9                   	leave  
  8030f9:	c3                   	ret    

008030fa <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030fa:	55                   	push   %ebp
  8030fb:	89 e5                	mov    %esp,%ebp
  8030fd:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803107:	eb 03                	jmp    80310c <busy_wait+0x12>
  803109:	ff 45 fc             	incl   -0x4(%ebp)
  80310c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80310f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803112:	72 f5                	jb     803109 <busy_wait+0xf>
	return i;
  803114:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803117:	c9                   	leave  
  803118:	c3                   	ret    
  803119:	66 90                	xchg   %ax,%ax
  80311b:	90                   	nop

0080311c <__udivdi3>:
  80311c:	55                   	push   %ebp
  80311d:	57                   	push   %edi
  80311e:	56                   	push   %esi
  80311f:	53                   	push   %ebx
  803120:	83 ec 1c             	sub    $0x1c,%esp
  803123:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803127:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80312b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80312f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803133:	89 ca                	mov    %ecx,%edx
  803135:	89 f8                	mov    %edi,%eax
  803137:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80313b:	85 f6                	test   %esi,%esi
  80313d:	75 2d                	jne    80316c <__udivdi3+0x50>
  80313f:	39 cf                	cmp    %ecx,%edi
  803141:	77 65                	ja     8031a8 <__udivdi3+0x8c>
  803143:	89 fd                	mov    %edi,%ebp
  803145:	85 ff                	test   %edi,%edi
  803147:	75 0b                	jne    803154 <__udivdi3+0x38>
  803149:	b8 01 00 00 00       	mov    $0x1,%eax
  80314e:	31 d2                	xor    %edx,%edx
  803150:	f7 f7                	div    %edi
  803152:	89 c5                	mov    %eax,%ebp
  803154:	31 d2                	xor    %edx,%edx
  803156:	89 c8                	mov    %ecx,%eax
  803158:	f7 f5                	div    %ebp
  80315a:	89 c1                	mov    %eax,%ecx
  80315c:	89 d8                	mov    %ebx,%eax
  80315e:	f7 f5                	div    %ebp
  803160:	89 cf                	mov    %ecx,%edi
  803162:	89 fa                	mov    %edi,%edx
  803164:	83 c4 1c             	add    $0x1c,%esp
  803167:	5b                   	pop    %ebx
  803168:	5e                   	pop    %esi
  803169:	5f                   	pop    %edi
  80316a:	5d                   	pop    %ebp
  80316b:	c3                   	ret    
  80316c:	39 ce                	cmp    %ecx,%esi
  80316e:	77 28                	ja     803198 <__udivdi3+0x7c>
  803170:	0f bd fe             	bsr    %esi,%edi
  803173:	83 f7 1f             	xor    $0x1f,%edi
  803176:	75 40                	jne    8031b8 <__udivdi3+0x9c>
  803178:	39 ce                	cmp    %ecx,%esi
  80317a:	72 0a                	jb     803186 <__udivdi3+0x6a>
  80317c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803180:	0f 87 9e 00 00 00    	ja     803224 <__udivdi3+0x108>
  803186:	b8 01 00 00 00       	mov    $0x1,%eax
  80318b:	89 fa                	mov    %edi,%edx
  80318d:	83 c4 1c             	add    $0x1c,%esp
  803190:	5b                   	pop    %ebx
  803191:	5e                   	pop    %esi
  803192:	5f                   	pop    %edi
  803193:	5d                   	pop    %ebp
  803194:	c3                   	ret    
  803195:	8d 76 00             	lea    0x0(%esi),%esi
  803198:	31 ff                	xor    %edi,%edi
  80319a:	31 c0                	xor    %eax,%eax
  80319c:	89 fa                	mov    %edi,%edx
  80319e:	83 c4 1c             	add    $0x1c,%esp
  8031a1:	5b                   	pop    %ebx
  8031a2:	5e                   	pop    %esi
  8031a3:	5f                   	pop    %edi
  8031a4:	5d                   	pop    %ebp
  8031a5:	c3                   	ret    
  8031a6:	66 90                	xchg   %ax,%ax
  8031a8:	89 d8                	mov    %ebx,%eax
  8031aa:	f7 f7                	div    %edi
  8031ac:	31 ff                	xor    %edi,%edi
  8031ae:	89 fa                	mov    %edi,%edx
  8031b0:	83 c4 1c             	add    $0x1c,%esp
  8031b3:	5b                   	pop    %ebx
  8031b4:	5e                   	pop    %esi
  8031b5:	5f                   	pop    %edi
  8031b6:	5d                   	pop    %ebp
  8031b7:	c3                   	ret    
  8031b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031bd:	89 eb                	mov    %ebp,%ebx
  8031bf:	29 fb                	sub    %edi,%ebx
  8031c1:	89 f9                	mov    %edi,%ecx
  8031c3:	d3 e6                	shl    %cl,%esi
  8031c5:	89 c5                	mov    %eax,%ebp
  8031c7:	88 d9                	mov    %bl,%cl
  8031c9:	d3 ed                	shr    %cl,%ebp
  8031cb:	89 e9                	mov    %ebp,%ecx
  8031cd:	09 f1                	or     %esi,%ecx
  8031cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031d3:	89 f9                	mov    %edi,%ecx
  8031d5:	d3 e0                	shl    %cl,%eax
  8031d7:	89 c5                	mov    %eax,%ebp
  8031d9:	89 d6                	mov    %edx,%esi
  8031db:	88 d9                	mov    %bl,%cl
  8031dd:	d3 ee                	shr    %cl,%esi
  8031df:	89 f9                	mov    %edi,%ecx
  8031e1:	d3 e2                	shl    %cl,%edx
  8031e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e7:	88 d9                	mov    %bl,%cl
  8031e9:	d3 e8                	shr    %cl,%eax
  8031eb:	09 c2                	or     %eax,%edx
  8031ed:	89 d0                	mov    %edx,%eax
  8031ef:	89 f2                	mov    %esi,%edx
  8031f1:	f7 74 24 0c          	divl   0xc(%esp)
  8031f5:	89 d6                	mov    %edx,%esi
  8031f7:	89 c3                	mov    %eax,%ebx
  8031f9:	f7 e5                	mul    %ebp
  8031fb:	39 d6                	cmp    %edx,%esi
  8031fd:	72 19                	jb     803218 <__udivdi3+0xfc>
  8031ff:	74 0b                	je     80320c <__udivdi3+0xf0>
  803201:	89 d8                	mov    %ebx,%eax
  803203:	31 ff                	xor    %edi,%edi
  803205:	e9 58 ff ff ff       	jmp    803162 <__udivdi3+0x46>
  80320a:	66 90                	xchg   %ax,%ax
  80320c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803210:	89 f9                	mov    %edi,%ecx
  803212:	d3 e2                	shl    %cl,%edx
  803214:	39 c2                	cmp    %eax,%edx
  803216:	73 e9                	jae    803201 <__udivdi3+0xe5>
  803218:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80321b:	31 ff                	xor    %edi,%edi
  80321d:	e9 40 ff ff ff       	jmp    803162 <__udivdi3+0x46>
  803222:	66 90                	xchg   %ax,%ax
  803224:	31 c0                	xor    %eax,%eax
  803226:	e9 37 ff ff ff       	jmp    803162 <__udivdi3+0x46>
  80322b:	90                   	nop

0080322c <__umoddi3>:
  80322c:	55                   	push   %ebp
  80322d:	57                   	push   %edi
  80322e:	56                   	push   %esi
  80322f:	53                   	push   %ebx
  803230:	83 ec 1c             	sub    $0x1c,%esp
  803233:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803237:	8b 74 24 34          	mov    0x34(%esp),%esi
  80323b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80323f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803243:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803247:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80324b:	89 f3                	mov    %esi,%ebx
  80324d:	89 fa                	mov    %edi,%edx
  80324f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803253:	89 34 24             	mov    %esi,(%esp)
  803256:	85 c0                	test   %eax,%eax
  803258:	75 1a                	jne    803274 <__umoddi3+0x48>
  80325a:	39 f7                	cmp    %esi,%edi
  80325c:	0f 86 a2 00 00 00    	jbe    803304 <__umoddi3+0xd8>
  803262:	89 c8                	mov    %ecx,%eax
  803264:	89 f2                	mov    %esi,%edx
  803266:	f7 f7                	div    %edi
  803268:	89 d0                	mov    %edx,%eax
  80326a:	31 d2                	xor    %edx,%edx
  80326c:	83 c4 1c             	add    $0x1c,%esp
  80326f:	5b                   	pop    %ebx
  803270:	5e                   	pop    %esi
  803271:	5f                   	pop    %edi
  803272:	5d                   	pop    %ebp
  803273:	c3                   	ret    
  803274:	39 f0                	cmp    %esi,%eax
  803276:	0f 87 ac 00 00 00    	ja     803328 <__umoddi3+0xfc>
  80327c:	0f bd e8             	bsr    %eax,%ebp
  80327f:	83 f5 1f             	xor    $0x1f,%ebp
  803282:	0f 84 ac 00 00 00    	je     803334 <__umoddi3+0x108>
  803288:	bf 20 00 00 00       	mov    $0x20,%edi
  80328d:	29 ef                	sub    %ebp,%edi
  80328f:	89 fe                	mov    %edi,%esi
  803291:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803295:	89 e9                	mov    %ebp,%ecx
  803297:	d3 e0                	shl    %cl,%eax
  803299:	89 d7                	mov    %edx,%edi
  80329b:	89 f1                	mov    %esi,%ecx
  80329d:	d3 ef                	shr    %cl,%edi
  80329f:	09 c7                	or     %eax,%edi
  8032a1:	89 e9                	mov    %ebp,%ecx
  8032a3:	d3 e2                	shl    %cl,%edx
  8032a5:	89 14 24             	mov    %edx,(%esp)
  8032a8:	89 d8                	mov    %ebx,%eax
  8032aa:	d3 e0                	shl    %cl,%eax
  8032ac:	89 c2                	mov    %eax,%edx
  8032ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032b2:	d3 e0                	shl    %cl,%eax
  8032b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032bc:	89 f1                	mov    %esi,%ecx
  8032be:	d3 e8                	shr    %cl,%eax
  8032c0:	09 d0                	or     %edx,%eax
  8032c2:	d3 eb                	shr    %cl,%ebx
  8032c4:	89 da                	mov    %ebx,%edx
  8032c6:	f7 f7                	div    %edi
  8032c8:	89 d3                	mov    %edx,%ebx
  8032ca:	f7 24 24             	mull   (%esp)
  8032cd:	89 c6                	mov    %eax,%esi
  8032cf:	89 d1                	mov    %edx,%ecx
  8032d1:	39 d3                	cmp    %edx,%ebx
  8032d3:	0f 82 87 00 00 00    	jb     803360 <__umoddi3+0x134>
  8032d9:	0f 84 91 00 00 00    	je     803370 <__umoddi3+0x144>
  8032df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032e3:	29 f2                	sub    %esi,%edx
  8032e5:	19 cb                	sbb    %ecx,%ebx
  8032e7:	89 d8                	mov    %ebx,%eax
  8032e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032ed:	d3 e0                	shl    %cl,%eax
  8032ef:	89 e9                	mov    %ebp,%ecx
  8032f1:	d3 ea                	shr    %cl,%edx
  8032f3:	09 d0                	or     %edx,%eax
  8032f5:	89 e9                	mov    %ebp,%ecx
  8032f7:	d3 eb                	shr    %cl,%ebx
  8032f9:	89 da                	mov    %ebx,%edx
  8032fb:	83 c4 1c             	add    $0x1c,%esp
  8032fe:	5b                   	pop    %ebx
  8032ff:	5e                   	pop    %esi
  803300:	5f                   	pop    %edi
  803301:	5d                   	pop    %ebp
  803302:	c3                   	ret    
  803303:	90                   	nop
  803304:	89 fd                	mov    %edi,%ebp
  803306:	85 ff                	test   %edi,%edi
  803308:	75 0b                	jne    803315 <__umoddi3+0xe9>
  80330a:	b8 01 00 00 00       	mov    $0x1,%eax
  80330f:	31 d2                	xor    %edx,%edx
  803311:	f7 f7                	div    %edi
  803313:	89 c5                	mov    %eax,%ebp
  803315:	89 f0                	mov    %esi,%eax
  803317:	31 d2                	xor    %edx,%edx
  803319:	f7 f5                	div    %ebp
  80331b:	89 c8                	mov    %ecx,%eax
  80331d:	f7 f5                	div    %ebp
  80331f:	89 d0                	mov    %edx,%eax
  803321:	e9 44 ff ff ff       	jmp    80326a <__umoddi3+0x3e>
  803326:	66 90                	xchg   %ax,%ax
  803328:	89 c8                	mov    %ecx,%eax
  80332a:	89 f2                	mov    %esi,%edx
  80332c:	83 c4 1c             	add    $0x1c,%esp
  80332f:	5b                   	pop    %ebx
  803330:	5e                   	pop    %esi
  803331:	5f                   	pop    %edi
  803332:	5d                   	pop    %ebp
  803333:	c3                   	ret    
  803334:	3b 04 24             	cmp    (%esp),%eax
  803337:	72 06                	jb     80333f <__umoddi3+0x113>
  803339:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80333d:	77 0f                	ja     80334e <__umoddi3+0x122>
  80333f:	89 f2                	mov    %esi,%edx
  803341:	29 f9                	sub    %edi,%ecx
  803343:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803347:	89 14 24             	mov    %edx,(%esp)
  80334a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80334e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803352:	8b 14 24             	mov    (%esp),%edx
  803355:	83 c4 1c             	add    $0x1c,%esp
  803358:	5b                   	pop    %ebx
  803359:	5e                   	pop    %esi
  80335a:	5f                   	pop    %edi
  80335b:	5d                   	pop    %ebp
  80335c:	c3                   	ret    
  80335d:	8d 76 00             	lea    0x0(%esi),%esi
  803360:	2b 04 24             	sub    (%esp),%eax
  803363:	19 fa                	sbb    %edi,%edx
  803365:	89 d1                	mov    %edx,%ecx
  803367:	89 c6                	mov    %eax,%esi
  803369:	e9 71 ff ff ff       	jmp    8032df <__umoddi3+0xb3>
  80336e:	66 90                	xchg   %ax,%ax
  803370:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803374:	72 ea                	jb     803360 <__umoddi3+0x134>
  803376:	89 d9                	mov    %ebx,%ecx
  803378:	e9 62 ff ff ff       	jmp    8032df <__umoddi3+0xb3>
