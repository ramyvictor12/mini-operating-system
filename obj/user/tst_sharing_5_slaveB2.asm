
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 44 01 00 00       	call   80017a <libmain>
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
  80008c:	68 c0 33 80 00       	push   $0x8033c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 33 80 00       	push   $0x8033dc
  800098:	e8 19 02 00 00       	call   8002b6 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 13 14 00 00       	call   8014ba <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  8000aa:	e8 68 1b 00 00       	call   801c17 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 f9 33 80 00       	push   $0x8033f9
  8000b7:	50                   	push   %eax
  8000b8:	e8 21 16 00 00       	call   8016de <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 fc 33 80 00       	push   $0x8033fc
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 64 1c 00 00       	call   801d3c <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 24 34 80 00       	push   $0x803424
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 96 2f 00 00       	call   80308b <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 58 1c 00 00       	call   801d56 <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 16 18 00 00       	call   80191e <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 a8 16 00 00       	call   8017be <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 44 34 80 00       	push   $0x803444
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 e9 17 00 00       	call   80191e <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 5c 34 80 00       	push   $0x80345c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 dc 33 80 00       	push   $0x8033dc
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 fc 34 80 00       	push   $0x8034fc
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 20 35 80 00       	push   $0x803520
  80016f:	e8 f6 03 00 00       	call   80056a <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	return;
  800177:	90                   	nop
}
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800180:	e8 79 1a 00 00       	call   801bfe <sys_getenvindex>
  800185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019d:	01 d0                	add    %edx,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0f                	je     8001ca <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	05 5c 05 00 00       	add    $0x55c,%eax
  8001c5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x60>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001eb:	e8 1b 18 00 00       	call   801a0b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 84 35 80 00       	push   $0x803584
  8001f8:	e8 6d 03 00 00       	call   80056a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800200:	a1 20 40 80 00       	mov    0x804020,%eax
  800205:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 ac 35 80 00       	push   $0x8035ac
  800220:	e8 45 03 00 00       	call   80056a <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800228:	a1 20 40 80 00       	mov    0x804020,%eax
  80022d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800249:	51                   	push   %ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	68 d4 35 80 00       	push   $0x8035d4
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 2c 36 80 00       	push   $0x80362c
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 84 35 80 00       	push   $0x803584
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 9b 17 00 00       	call   801a25 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80028a:	e8 19 00 00 00       	call   8002a8 <exit>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 00                	push   $0x0
  80029d:	e8 28 19 00 00       	call   801bca <sys_destroy_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <exit>:

void
exit(void)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ae:	e8 7d 19 00 00       	call   801c30 <sys_exit_env>
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bf:	83 c0 04             	add    $0x4,%eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	74 16                	je     8002e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ce:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	50                   	push   %eax
  8002d7:	68 40 36 80 00       	push   $0x803640
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 40 80 00       	mov    0x804000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 45 36 80 00       	push   $0x803645
  8002f5:	e8 70 02 00 00       	call   80056a <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 f3 01 00 00       	call   8004ff <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	6a 00                	push   $0x0
  800314:	68 61 36 80 00       	push   $0x803661
  800319:	e8 e1 01 00 00       	call   8004ff <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800321:	e8 82 ff ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  800326:	eb fe                	jmp    800326 <_panic+0x70>

00800328 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032e:	a1 20 40 80 00       	mov    0x804020,%eax
  800333:	8b 50 74             	mov    0x74(%eax),%edx
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 14                	je     800351 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 64 36 80 00       	push   $0x803664
  800345:	6a 26                	push   $0x26
  800347:	68 b0 36 80 00       	push   $0x8036b0
  80034c:	e8 65 ff ff ff       	call   8002b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035f:	e9 c2 00 00 00       	jmp    800426 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	01 d0                	add    %edx,%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	75 08                	jne    800381 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800379:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037c:	e9 a2 00 00 00       	jmp    800423 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800388:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038f:	eb 69                	jmp    8003fa <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800391:	a1 20 40 80 00       	mov    0x804020,%eax
  800396:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80039c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	01 c0                	add    %eax,%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	c1 e0 03             	shl    $0x3,%eax
  8003a8:	01 c8                	add    %ecx,%eax
  8003aa:	8a 40 04             	mov    0x4(%eax),%al
  8003ad:	84 c0                	test   %al,%al
  8003af:	75 46                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003bf:	89 d0                	mov    %edx,%eax
  8003c1:	01 c0                	add    %eax,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c1 e0 03             	shl    $0x3,%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	75 09                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f5:	eb 12                	jmp    800409 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f7:	ff 45 e8             	incl   -0x18(%ebp)
  8003fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ff:	8b 50 74             	mov    0x74(%eax),%edx
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	77 88                	ja     800391 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80040d:	75 14                	jne    800423 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 bc 36 80 00       	push   $0x8036bc
  800417:	6a 3a                	push   $0x3a
  800419:	68 b0 36 80 00       	push   $0x8036b0
  80041e:	e8 93 fe ff ff       	call   8002b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800423:	ff 45 f0             	incl   -0x10(%ebp)
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042c:	0f 8c 32 ff ff ff    	jl     800364 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800432:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800440:	eb 26                	jmp    800468 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800450:	89 d0                	mov    %edx,%eax
  800452:	01 c0                	add    %eax,%eax
  800454:	01 d0                	add    %edx,%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	01 c8                	add    %ecx,%eax
  80045b:	8a 40 04             	mov    0x4(%eax),%al
  80045e:	3c 01                	cmp    $0x1,%al
  800460:	75 03                	jne    800465 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800462:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	ff 45 e0             	incl   -0x20(%ebp)
  800468:	a1 20 40 80 00       	mov    0x804020,%eax
  80046d:	8b 50 74             	mov    0x74(%eax),%edx
  800470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 cb                	ja     800442 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047d:	74 14                	je     800493 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 10 37 80 00       	push   $0x803710
  800487:	6a 44                	push   $0x44
  800489:	68 b0 36 80 00       	push   $0x8036b0
  80048e:	e8 23 fe ff ff       	call   8002b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 0a                	mov    %ecx,(%edx)
  8004a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ac:	88 d1                	mov    %dl,%cl
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bf:	75 2c                	jne    8004ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c1:	a0 24 40 80 00       	mov    0x804024,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	8b 12                	mov    (%edx),%edx
  8004ce:	89 d1                	mov    %edx,%ecx
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	83 c2 08             	add    $0x8,%edx
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	50                   	push   %eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	e8 7c 13 00 00       	call   80185d <sys_cputs>
  8004e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 40 04             	mov    0x4(%eax),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	68 96 04 80 00       	push   $0x800496
  80052e:	e8 11 02 00 00       	call   800744 <vprintfmt>
  800533:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800536:	a0 24 40 80 00       	mov    0x804024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	50                   	push   %eax
  800548:	52                   	push   %edx
  800549:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054f:	83 c0 08             	add    $0x8,%eax
  800552:	50                   	push   %eax
  800553:	e8 05 13 00 00       	call   80185d <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int cprintf(const char *fmt, ...) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800570:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 73 ff ff ff       	call   8004ff <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059d:	e8 69 14 00 00       	call   801a0b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 48 ff ff ff       	call   8004ff <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bd:	e8 63 14 00 00       	call   801a25 <sys_enable_interrupt>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 34 2b 00 00       	call   803140 <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 f4 2b 00 00       	call   803250 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 74 39 80 00       	add    $0x803974,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 af 03 00 00    	je     800b05 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 55             	cmp    $0x55,%eax
  8007ac:	0f 87 2b 03 00 00    	ja     800add <vprintfmt+0x399>
  8007b2:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 89 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 85 39 80 00       	push   $0x803985
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 5e 02 00 00       	call   800b0d <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 49 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 8e 39 80 00       	push   $0x80398e
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 45 02 00 00       	call   800b0d <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 30 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be 91 39 80 00       	mov    $0x803991,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 0c 03 00 00       	call   800c0f <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 66 01 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 23                	jmp    800b00 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 25                	push   $0x25
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aed:	ff 4d 10             	decl   0x10(%ebp)
  800af0:	eb 03                	jmp    800af5 <vprintfmt+0x3b1>
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	48                   	dec    %eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 f3                	jne    800af2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	e9 47 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b05:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b13:	8d 45 10             	lea    0x10(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	50                   	push   %eax
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 16 fc ff ff       	call   800744 <vprintfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b31:	90                   	nop
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 08             	mov    0x8(%eax),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 10                	mov    (%eax),%edx
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	73 12                	jae    800b67 <sprintputch+0x33>
		*b->buf++ = ch;
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 0a                	mov    %ecx,(%edx)
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	88 10                	mov    %dl,(%eax)
}
  800b67:	90                   	nop
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8f:	74 06                	je     800b97 <vsnprintf+0x2d>
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	7f 07                	jg     800b9e <vsnprintf+0x34>
		return -E_INVAL;
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	eb 20                	jmp    800bbe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9e:	ff 75 14             	pushl  0x14(%ebp)
  800ba1:	ff 75 10             	pushl  0x10(%ebp)
  800ba4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	68 34 0b 80 00       	push   $0x800b34
  800bad:	e8 92 fb ff ff       	call   800744 <vprintfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 89 ff ff ff       	call   800b6a <vsnprintf>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 06                	jmp    800c01 <strlen+0x15>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 f1                	jne    800bfb <strlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 09                	jmp    800c27 <strnlen+0x18>
		n++;
  800c1e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	ff 4d 0c             	decl   0xc(%ebp)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 09                	je     800c36 <strnlen+0x27>
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e8                	jne    800c1e <strnlen+0xf>
		n++;
	return n;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c47:	90                   	nop
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e4                	jne    800c48 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 1f                	jmp    800c9d <strncpy+0x34>
		*dst++ = *src;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 03                	je     800c9a <strncpy+0x31>
			src++;
  800c97:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca3:	72 d9                	jb     800c7e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 30                	je     800cec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbc:	eb 16                	jmp    800cd4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	74 09                	je     800ce6 <strlcpy+0x3c>
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 d8                	jne    800cbe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfb:	eb 06                	jmp    800d03 <strcmp+0xb>
		p++, q++;
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0e                	je     800d1a <strcmp+0x22>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 10                	mov    (%eax),%dl
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	38 c2                	cmp    %al,%dl
  800d18:	74 e3                	je     800cfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 c0             	movzbl %al,%eax
  800d2a:	29 c2                	sub    %eax,%edx
  800d2c:	89 d0                	mov    %edx,%eax
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d33:	eb 09                	jmp    800d3e <strncmp+0xe>
		n--, p++, q++;
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 17                	je     800d5b <strncmp+0x2b>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0e                	je     800d5b <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 10                	mov    (%eax),%dl
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	38 c2                	cmp    %al,%dl
  800d59:	74 da                	je     800d35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	75 07                	jne    800d68 <strncmp+0x38>
		return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	eb 14                	jmp    800d7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 12                	jmp    800d9e <strchr+0x20>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	75 05                	jne    800d9b <strchr+0x1d>
			return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	eb 11                	jmp    800dac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 e5                	jne    800d8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dba:	eb 0d                	jmp    800dc9 <strfind+0x1b>
		if (*s == c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc4:	74 0e                	je     800dd4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 ea                	jne    800dbc <strfind+0xe>
  800dd2:	eb 01                	jmp    800dd5 <strfind+0x27>
		if (*s == c)
			break;
  800dd4:	90                   	nop
	return (char *) s;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dec:	eb 0e                	jmp    800dfc <memset+0x22>
		*p++ = c;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfc:	ff 4d f8             	decl   -0x8(%ebp)
  800dff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e03:	79 e9                	jns    800dee <memset+0x14>
		*p++ = c;

	return v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1c:	eb 16                	jmp    800e34 <memcpy+0x2a>
		*d++ = *s++;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e21:	8d 50 01             	lea    0x1(%eax),%edx
  800e24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e30:	8a 12                	mov    (%edx),%dl
  800e32:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	75 dd                	jne    800e1e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5e:	73 50                	jae    800eb0 <memmove+0x6a>
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	76 43                	jbe    800eb0 <memmove+0x6a>
		s += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e79:	eb 10                	jmp    800e8b <memmove+0x45>
			*--d = *--s;
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	ff 4d fc             	decl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 e3                	jne    800e7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e98:	eb 23                	jmp    800ebd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 dd                	jne    800e9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed4:	eb 2a                	jmp    800f00 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 16                	je     800efa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 c0             	movzbl %al,%eax
  800ef4:	29 c2                	sub    %eax,%edx
  800ef6:	89 d0                	mov    %edx,%eax
  800ef8:	eb 18                	jmp    800f12 <memcmp+0x50>
		s1++, s2++;
  800efa:	ff 45 fc             	incl   -0x4(%ebp)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 c9                	jne    800ed6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f25:	eb 15                	jmp    800f3c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 0d                	je     800f46 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f42:	72 e3                	jb     800f27 <memfind+0x13>
  800f44:	eb 01                	jmp    800f47 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f46:	90                   	nop
	return (void *) s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x19>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f4                	je     800f62 <strtol+0x16>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 eb                	je     800f62 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2b                	cmp    $0x2b,%al
  800f7e:	75 05                	jne    800f85 <strtol+0x39>
		s++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	eb 13                	jmp    800f98 <strtol+0x4c>
	else if (*s == '-')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 2d                	cmp    $0x2d,%al
  800f8c:	75 0a                	jne    800f98 <strtol+0x4c>
		s++, neg = 1;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 06                	je     800fa4 <strtol+0x58>
  800f9e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa2:	75 20                	jne    800fc4 <strtol+0x78>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 17                	jne    800fc4 <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	40                   	inc    %eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 78                	cmp    $0x78,%al
  800fb5:	75 0d                	jne    800fc4 <strtol+0x78>
		s += 2, base = 16;
  800fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc2:	eb 28                	jmp    800fec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 15                	jne    800fdf <strtol+0x93>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 30                	cmp    $0x30,%al
  800fd1:	75 0c                	jne    800fdf <strtol+0x93>
		s++, base = 8;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdd:	eb 0d                	jmp    800fec <strtol+0xa0>
	else if (base == 0)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 07                	jne    800fec <strtol+0xa0>
		base = 10;
  800fe5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2f                	cmp    $0x2f,%al
  800ff3:	7e 19                	jle    80100e <strtol+0xc2>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 39                	cmp    $0x39,%al
  800ffc:	7f 10                	jg     80100e <strtol+0xc2>
			dig = *s - '0';
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 42                	jmp    801050 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 60                	cmp    $0x60,%al
  801015:	7e 19                	jle    801030 <strtol+0xe4>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 7a                	cmp    $0x7a,%al
  80101e:	7f 10                	jg     801030 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	83 e8 57             	sub    $0x57,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102e:	eb 20                	jmp    801050 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 39                	jle    801072 <strtol+0x126>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 5a                	cmp    $0x5a,%al
  801040:	7f 30                	jg     801072 <strtol+0x126>
			dig = *s - 'A' + 10;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f be c0             	movsbl %al,%eax
  80104a:	83 e8 37             	sub    $0x37,%eax
  80104d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 10             	cmp    0x10(%ebp),%eax
  801056:	7d 19                	jge    801071 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801062:	89 c2                	mov    %eax,%edx
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106c:	e9 7b ff ff ff       	jmp    800fec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801071:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 08                	je     801080 <strtol+0x134>
		*endptr = (char *) s;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801084:	74 07                	je     80108d <strtol+0x141>
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	f7 d8                	neg    %eax
  80108b:	eb 03                	jmp    801090 <strtol+0x144>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <ltostr>:

void
ltostr(long value, char *str)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	79 13                	jns    8010bf <ltostr+0x2d>
	{
		neg = 1;
  8010ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c7:	99                   	cltd   
  8010c8:	f7 f9                	idiv   %ecx
  8010ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e0:	83 c2 30             	add    $0x30,%edx
  8010e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ed:	f7 e9                	imul   %ecx
  8010ef:	c1 fa 02             	sar    $0x2,%edx
  8010f2:	89 c8                	mov    %ecx,%eax
  8010f4:	c1 f8 1f             	sar    $0x1f,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801106:	f7 e9                	imul   %ecx
  801108:	c1 fa 02             	sar    $0x2,%edx
  80110b:	89 c8                	mov    %ecx,%eax
  80110d:	c1 f8 1f             	sar    $0x1f,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	c1 e0 02             	shl    $0x2,%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	01 c0                	add    %eax,%eax
  80111b:	29 c1                	sub    %eax,%ecx
  80111d:	89 ca                	mov    %ecx,%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	75 9c                	jne    8010bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xe2>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 54 fa ff ff       	call   800bec <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 46 fa ff ff       	call   800bec <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 13 fb ff ff       	call   800d7e <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 b5 fa ff ff       	call   800d7e <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 1f                	je     801322 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801303:	e8 1d 00 00 00       	call   801325 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	68 f0 3a 80 00       	push   $0x803af0
  801310:	e8 55 f2 ff ff       	call   80056a <cprintf>
  801315:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801318:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131f:	00 00 00 
	}
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80132b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801332:	00 00 00 
  801335:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80133c:	00 00 00 
  80133f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801346:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801349:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801350:	00 00 00 
  801353:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80135a:	00 00 00 
  80135d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801364:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801367:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80136e:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801371:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801378:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80137f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801387:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138c:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801391:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80139b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	6a 06                	push   $0x6
  8013aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ad:	50                   	push   %eax
  8013ae:	e8 ee 05 00 00       	call   8019a1 <sys_allocate_chunk>
  8013b3:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013b6:	a1 20 41 80 00       	mov    0x804120,%eax
  8013bb:	83 ec 0c             	sub    $0xc,%esp
  8013be:	50                   	push   %eax
  8013bf:	e8 63 0c 00 00       	call   802027 <initialize_MemBlocksList>
  8013c4:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8013c7:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8013cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013d2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8013d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8013df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ea:	89 c2                	mov    %eax,%edx
  8013ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ef:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8013f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8013fc:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801406:	8b 50 08             	mov    0x8(%eax),%edx
  801409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140c:	01 d0                	add    %edx,%eax
  80140e:	48                   	dec    %eax
  80140f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801412:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801415:	ba 00 00 00 00       	mov    $0x0,%edx
  80141a:	f7 75 e0             	divl   -0x20(%ebp)
  80141d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801420:	29 d0                	sub    %edx,%eax
  801422:	89 c2                	mov    %eax,%edx
  801424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801427:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80142a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80142e:	75 14                	jne    801444 <initialize_dyn_block_system+0x11f>
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	68 15 3b 80 00       	push   $0x803b15
  801438:	6a 34                	push   $0x34
  80143a:	68 33 3b 80 00       	push   $0x803b33
  80143f:	e8 72 ee ff ff       	call   8002b6 <_panic>
  801444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	85 c0                	test   %eax,%eax
  80144b:	74 10                	je     80145d <initialize_dyn_block_system+0x138>
  80144d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801455:	8b 52 04             	mov    0x4(%edx),%edx
  801458:	89 50 04             	mov    %edx,0x4(%eax)
  80145b:	eb 0b                	jmp    801468 <initialize_dyn_block_system+0x143>
  80145d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801460:	8b 40 04             	mov    0x4(%eax),%eax
  801463:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80146b:	8b 40 04             	mov    0x4(%eax),%eax
  80146e:	85 c0                	test   %eax,%eax
  801470:	74 0f                	je     801481 <initialize_dyn_block_system+0x15c>
  801472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801475:	8b 40 04             	mov    0x4(%eax),%eax
  801478:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80147b:	8b 12                	mov    (%edx),%edx
  80147d:	89 10                	mov    %edx,(%eax)
  80147f:	eb 0a                	jmp    80148b <initialize_dyn_block_system+0x166>
  801481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801484:	8b 00                	mov    (%eax),%eax
  801486:	a3 48 41 80 00       	mov    %eax,0x804148
  80148b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801497:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80149e:	a1 54 41 80 00       	mov    0x804154,%eax
  8014a3:	48                   	dec    %eax
  8014a4:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8014af:	e8 c4 13 00 00       	call   802878 <insert_sorted_with_merge_freeList>
  8014b4:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014b7:	90                   	nop
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <malloc>:
//=================================



void* malloc(uint32 size)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c0:	e8 2f fe ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c9:	75 07                	jne    8014d2 <malloc+0x18>
  8014cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d0:	eb 71                	jmp    801543 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8014d2:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8014d9:	76 07                	jbe    8014e2 <malloc+0x28>
	return NULL;
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e0:	eb 61                	jmp    801543 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014e2:	e8 88 08 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	74 53                	je     80153e <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014eb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f8:	01 d0                	add    %edx,%eax
  8014fa:	48                   	dec    %eax
  8014fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801501:	ba 00 00 00 00       	mov    $0x0,%edx
  801506:	f7 75 f4             	divl   -0xc(%ebp)
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	29 d0                	sub    %edx,%eax
  80150e:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	ff 75 ec             	pushl  -0x14(%ebp)
  801517:	e8 d2 0d 00 00       	call   8022ee <alloc_block_FF>
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801522:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801526:	74 16                	je     80153e <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	e8 0c 0c 00 00       	call   80213f <insert_sorted_allocList>
  801533:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801536:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801539:	8b 40 08             	mov    0x8(%eax),%eax
  80153c:	eb 05                	jmp    801543 <malloc+0x89>
    }

			}


	return NULL;
  80153e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801554:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 f0             	pushl  -0x10(%ebp)
  801562:	68 40 40 80 00       	push   $0x804040
  801567:	e8 a0 0b 00 00       	call   80210c <find_block>
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801575:	8b 50 0c             	mov    0xc(%eax),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	83 ec 08             	sub    $0x8,%esp
  80157e:	52                   	push   %edx
  80157f:	50                   	push   %eax
  801580:	e8 e4 03 00 00       	call   801969 <sys_free_user_mem>
  801585:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801588:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80158c:	75 17                	jne    8015a5 <free+0x60>
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	68 15 3b 80 00       	push   $0x803b15
  801596:	68 84 00 00 00       	push   $0x84
  80159b:	68 33 3b 80 00       	push   $0x803b33
  8015a0:	e8 11 ed ff ff       	call   8002b6 <_panic>
  8015a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a8:	8b 00                	mov    (%eax),%eax
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	74 10                	je     8015be <free+0x79>
  8015ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b1:	8b 00                	mov    (%eax),%eax
  8015b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015b6:	8b 52 04             	mov    0x4(%edx),%edx
  8015b9:	89 50 04             	mov    %edx,0x4(%eax)
  8015bc:	eb 0b                	jmp    8015c9 <free+0x84>
  8015be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c1:	8b 40 04             	mov    0x4(%eax),%eax
  8015c4:	a3 44 40 80 00       	mov    %eax,0x804044
  8015c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cc:	8b 40 04             	mov    0x4(%eax),%eax
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	74 0f                	je     8015e2 <free+0x9d>
  8015d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d6:	8b 40 04             	mov    0x4(%eax),%eax
  8015d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015dc:	8b 12                	mov    (%edx),%edx
  8015de:	89 10                	mov    %edx,(%eax)
  8015e0:	eb 0a                	jmp    8015ec <free+0xa7>
  8015e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	a3 40 40 80 00       	mov    %eax,0x804040
  8015ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ff:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801604:	48                   	dec    %eax
  801605:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	ff 75 ec             	pushl  -0x14(%ebp)
  801610:	e8 63 12 00 00       	call   802878 <insert_sorted_with_merge_freeList>
  801615:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801618:	90                   	nop
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 38             	sub    $0x38,%esp
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801627:	e8 c8 fc ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  80162c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801630:	75 0a                	jne    80163c <smalloc+0x21>
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
  801637:	e9 a0 00 00 00       	jmp    8016dc <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80163c:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801643:	76 0a                	jbe    80164f <smalloc+0x34>
		return NULL;
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	e9 8d 00 00 00       	jmp    8016dc <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80164f:	e8 1b 07 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801654:	85 c0                	test   %eax,%eax
  801656:	74 7f                	je     8016d7 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801658:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80165f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	48                   	dec    %eax
  801668:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80166b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166e:	ba 00 00 00 00       	mov    $0x0,%edx
  801673:	f7 75 f4             	divl   -0xc(%ebp)
  801676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801679:	29 d0                	sub    %edx,%eax
  80167b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80167e:	83 ec 0c             	sub    $0xc,%esp
  801681:	ff 75 ec             	pushl  -0x14(%ebp)
  801684:	e8 65 0c 00 00       	call   8022ee <alloc_block_FF>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80168f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801693:	74 42                	je     8016d7 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801695:	83 ec 0c             	sub    $0xc,%esp
  801698:	ff 75 e8             	pushl  -0x18(%ebp)
  80169b:	e8 9f 0a 00 00       	call   80213f <insert_sorted_allocList>
  8016a0:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8016a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a6:	8b 40 08             	mov    0x8(%eax),%eax
  8016a9:	89 c2                	mov    %eax,%edx
  8016ab:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	ff 75 08             	pushl  0x8(%ebp)
  8016b7:	e8 38 04 00 00       	call   801af4 <sys_createSharedObject>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8016c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016c6:	79 07                	jns    8016cf <smalloc+0xb4>
	    		  return NULL;
  8016c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cd:	eb 0d                	jmp    8016dc <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8016cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d2:	8b 40 08             	mov    0x8(%eax),%eax
  8016d5:	eb 05                	jmp    8016dc <smalloc+0xc1>


				}


		return NULL;
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e4:	e8 0b fc ff ff       	call   8012f4 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016e9:	e8 81 06 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	0f 84 9f 00 00 00    	je     801795 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	ff 75 08             	pushl  0x8(%ebp)
  8016ff:	e8 1a 04 00 00       	call   801b1e <sys_getSizeOfSharedObject>
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80170a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80170e:	79 0a                	jns    80171a <sget+0x3c>
		return NULL;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	e9 80 00 00 00       	jmp    80179a <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80171a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801727:	01 d0                	add    %edx,%eax
  801729:	48                   	dec    %eax
  80172a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80172d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801730:	ba 00 00 00 00       	mov    $0x0,%edx
  801735:	f7 75 f0             	divl   -0x10(%ebp)
  801738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173b:	29 d0                	sub    %edx,%eax
  80173d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801740:	83 ec 0c             	sub    $0xc,%esp
  801743:	ff 75 e8             	pushl  -0x18(%ebp)
  801746:	e8 a3 0b 00 00       	call   8022ee <alloc_block_FF>
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801751:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801755:	74 3e                	je     801795 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80175d:	e8 dd 09 00 00       	call   80213f <insert_sorted_allocList>
  801762:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801768:	8b 40 08             	mov    0x8(%eax),%eax
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	50                   	push   %eax
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	ff 75 08             	pushl  0x8(%ebp)
  801775:	e8 c1 03 00 00       	call   801b3b <sys_getSharedObject>
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801780:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801784:	79 07                	jns    80178d <sget+0xaf>
	    		  return NULL;
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	eb 0d                	jmp    80179a <sget+0xbc>
	  	return(void*) returned_block->sva;
  80178d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801790:	8b 40 08             	mov    0x8(%eax),%eax
  801793:	eb 05                	jmp    80179a <sget+0xbc>
	      }
	}
	   return NULL;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a2:	e8 4d fb ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 40 3b 80 00       	push   $0x803b40
  8017af:	68 12 01 00 00       	push   $0x112
  8017b4:	68 33 3b 80 00       	push   $0x803b33
  8017b9:	e8 f8 ea ff ff       	call   8002b6 <_panic>

008017be <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 68 3b 80 00       	push   $0x803b68
  8017cc:	68 26 01 00 00       	push   $0x126
  8017d1:	68 33 3b 80 00       	push   $0x803b33
  8017d6:	e8 db ea ff ff       	call   8002b6 <_panic>

008017db <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 8c 3b 80 00       	push   $0x803b8c
  8017e9:	68 31 01 00 00       	push   $0x131
  8017ee:	68 33 3b 80 00       	push   $0x803b33
  8017f3:	e8 be ea ff ff       	call   8002b6 <_panic>

008017f8 <shrink>:

}
void shrink(uint32 newSize)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fe:	83 ec 04             	sub    $0x4,%esp
  801801:	68 8c 3b 80 00       	push   $0x803b8c
  801806:	68 36 01 00 00       	push   $0x136
  80180b:	68 33 3b 80 00       	push   $0x803b33
  801810:	e8 a1 ea ff ff       	call   8002b6 <_panic>

00801815 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	68 8c 3b 80 00       	push   $0x803b8c
  801823:	68 3b 01 00 00       	push   $0x13b
  801828:	68 33 3b 80 00       	push   $0x803b33
  80182d:	e8 84 ea ff ff       	call   8002b6 <_panic>

00801832 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	57                   	push   %edi
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
  801838:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801841:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801844:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801847:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80184d:	cd 30                	int    $0x30
  80184f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	5b                   	pop    %ebx
  801859:	5e                   	pop    %esi
  80185a:	5f                   	pop    %edi
  80185b:	5d                   	pop    %ebp
  80185c:	c3                   	ret    

0080185d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801869:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	52                   	push   %edx
  801875:	ff 75 0c             	pushl  0xc(%ebp)
  801878:	50                   	push   %eax
  801879:	6a 00                	push   $0x0
  80187b:	e8 b2 ff ff ff       	call   801832 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	90                   	nop
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_cgetc>:

int
sys_cgetc(void)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 01                	push   $0x1
  801895:	e8 98 ff ff ff       	call   801832 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	52                   	push   %edx
  8018af:	50                   	push   %eax
  8018b0:	6a 05                	push   $0x5
  8018b2:	e8 7b ff ff ff       	call   801832 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c1:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	56                   	push   %esi
  8018d1:	53                   	push   %ebx
  8018d2:	51                   	push   %ecx
  8018d3:	52                   	push   %edx
  8018d4:	50                   	push   %eax
  8018d5:	6a 06                	push   $0x6
  8018d7:	e8 56 ff ff ff       	call   801832 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	52                   	push   %edx
  8018f6:	50                   	push   %eax
  8018f7:	6a 07                	push   $0x7
  8018f9:	e8 34 ff ff ff       	call   801832 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	ff 75 08             	pushl  0x8(%ebp)
  801912:	6a 08                	push   $0x8
  801914:	e8 19 ff ff ff       	call   801832 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 09                	push   $0x9
  80192d:	e8 00 ff ff ff       	call   801832 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 0a                	push   $0xa
  801946:	e8 e7 fe ff ff       	call   801832 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 0b                	push   $0xb
  80195f:	e8 ce fe ff ff       	call   801832 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 0f                	push   $0xf
  80197a:	e8 b3 fe ff ff       	call   801832 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	6a 10                	push   $0x10
  801996:	e8 97 fe ff ff       	call   801832 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
	return ;
  80199e:	90                   	nop
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	ff 75 10             	pushl  0x10(%ebp)
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	6a 11                	push   $0x11
  8019b3:	e8 7a fe ff ff       	call   801832 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bb:	90                   	nop
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 0c                	push   $0xc
  8019cd:	e8 60 fe ff ff       	call   801832 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 08             	pushl  0x8(%ebp)
  8019e5:	6a 0d                	push   $0xd
  8019e7:	e8 46 fe ff ff       	call   801832 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 0e                	push   $0xe
  801a00:	e8 2d fe ff ff       	call   801832 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 13                	push   $0x13
  801a1a:	e8 13 fe ff ff       	call   801832 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 14                	push   $0x14
  801a34:	e8 f9 fd ff ff       	call   801832 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	90                   	nop
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_cputc>:


void
sys_cputc(const char c)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a4b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	50                   	push   %eax
  801a58:	6a 15                	push   $0x15
  801a5a:	e8 d3 fd ff ff       	call   801832 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 16                	push   $0x16
  801a74:	e8 b9 fd ff ff       	call   801832 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	50                   	push   %eax
  801a8f:	6a 17                	push   $0x17
  801a91:	e8 9c fd ff ff       	call   801832 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	52                   	push   %edx
  801aab:	50                   	push   %eax
  801aac:	6a 1a                	push   $0x1a
  801aae:	e8 7f fd ff ff       	call   801832 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 18                	push   $0x18
  801acb:	e8 62 fd ff ff       	call   801832 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	52                   	push   %edx
  801ae6:	50                   	push   %eax
  801ae7:	6a 19                	push   $0x19
  801ae9:	e8 44 fd ff ff       	call   801832 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	90                   	nop
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	8b 45 10             	mov    0x10(%ebp),%eax
  801afd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	51                   	push   %ecx
  801b0d:	52                   	push   %edx
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	50                   	push   %eax
  801b12:	6a 1b                	push   $0x1b
  801b14:	e8 19 fd ff ff       	call   801832 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 1c                	push   $0x1c
  801b31:	e8 fc fc ff ff       	call   801832 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	51                   	push   %ecx
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 1d                	push   $0x1d
  801b50:	e8 dd fc ff ff       	call   801832 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 1e                	push   $0x1e
  801b6d:	e8 c0 fc ff ff       	call   801832 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 1f                	push   $0x1f
  801b86:	e8 a7 fc ff ff       	call   801832 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	ff 75 14             	pushl  0x14(%ebp)
  801b9b:	ff 75 10             	pushl  0x10(%ebp)
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	50                   	push   %eax
  801ba2:	6a 20                	push   $0x20
  801ba4:	e8 89 fc ff ff       	call   801832 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	50                   	push   %eax
  801bbd:	6a 21                	push   $0x21
  801bbf:	e8 6e fc ff ff       	call   801832 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	90                   	nop
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	50                   	push   %eax
  801bd9:	6a 22                	push   $0x22
  801bdb:	e8 52 fc ff ff       	call   801832 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 02                	push   $0x2
  801bf4:	e8 39 fc ff ff       	call   801832 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 03                	push   $0x3
  801c0d:	e8 20 fc ff ff       	call   801832 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 04                	push   $0x4
  801c26:	e8 07 fc ff ff       	call   801832 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_exit_env>:


void sys_exit_env(void)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 23                	push   $0x23
  801c3f:	e8 ee fb ff ff       	call   801832 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	90                   	nop
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c53:	8d 50 04             	lea    0x4(%eax),%edx
  801c56:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	6a 24                	push   $0x24
  801c63:	e8 ca fb ff ff       	call   801832 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c74:	89 01                	mov    %eax,(%ecx)
  801c76:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	c9                   	leave  
  801c7d:	c2 04 00             	ret    $0x4

00801c80 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	ff 75 10             	pushl  0x10(%ebp)
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	ff 75 08             	pushl  0x8(%ebp)
  801c90:	6a 12                	push   $0x12
  801c92:	e8 9b fb ff ff       	call   801832 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_rcr2>:
uint32 sys_rcr2()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 25                	push   $0x25
  801cac:	e8 81 fb ff ff       	call   801832 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 04             	sub    $0x4,%esp
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	50                   	push   %eax
  801ccf:	6a 26                	push   $0x26
  801cd1:	e8 5c fb ff ff       	call   801832 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd9:	90                   	nop
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <rsttst>:
void rsttst()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 28                	push   $0x28
  801ceb:	e8 42 fb ff ff       	call   801832 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  801cff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d02:	8b 55 18             	mov    0x18(%ebp),%edx
  801d05:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d09:	52                   	push   %edx
  801d0a:	50                   	push   %eax
  801d0b:	ff 75 10             	pushl  0x10(%ebp)
  801d0e:	ff 75 0c             	pushl  0xc(%ebp)
  801d11:	ff 75 08             	pushl  0x8(%ebp)
  801d14:	6a 27                	push   $0x27
  801d16:	e8 17 fb ff ff       	call   801832 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1e:	90                   	nop
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <chktst>:
void chktst(uint32 n)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	6a 29                	push   $0x29
  801d31:	e8 fc fa ff ff       	call   801832 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return ;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <inctst>:

void inctst()
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 2a                	push   $0x2a
  801d4b:	e8 e2 fa ff ff       	call   801832 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return ;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <gettst>:
uint32 gettst()
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 2b                	push   $0x2b
  801d65:	e8 c8 fa ff ff       	call   801832 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 2c                	push   $0x2c
  801d81:	e8 ac fa ff ff       	call   801832 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
  801d89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d8c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d90:	75 07                	jne    801d99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d92:	b8 01 00 00 00       	mov    $0x1,%eax
  801d97:	eb 05                	jmp    801d9e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 2c                	push   $0x2c
  801db2:	e8 7b fa ff ff       	call   801832 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
  801dba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dbd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc1:	75 07                	jne    801dca <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc8:	eb 05                	jmp    801dcf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 2c                	push   $0x2c
  801de3:	e8 4a fa ff ff       	call   801832 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
  801deb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dee:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df2:	75 07                	jne    801dfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df4:	b8 01 00 00 00       	mov    $0x1,%eax
  801df9:	eb 05                	jmp    801e00 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 2c                	push   $0x2c
  801e14:	e8 19 fa ff ff       	call   801832 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
  801e1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e1f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e23:	75 07                	jne    801e2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e25:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2a:	eb 05                	jmp    801e31 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	ff 75 08             	pushl  0x8(%ebp)
  801e41:	6a 2d                	push   $0x2d
  801e43:	e8 ea f9 ff ff       	call   801832 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4b:	90                   	nop
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	53                   	push   %ebx
  801e61:	51                   	push   %ecx
  801e62:	52                   	push   %edx
  801e63:	50                   	push   %eax
  801e64:	6a 2e                	push   $0x2e
  801e66:	e8 c7 f9 ff ff       	call   801832 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	52                   	push   %edx
  801e83:	50                   	push   %eax
  801e84:	6a 2f                	push   $0x2f
  801e86:	e8 a7 f9 ff ff       	call   801832 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	68 9c 3b 80 00       	push   $0x803b9c
  801e9e:	e8 c7 e6 ff ff       	call   80056a <cprintf>
  801ea3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ea6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	68 c8 3b 80 00       	push   $0x803bc8
  801eb5:	e8 b0 e6 ff ff       	call   80056a <cprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ebd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec1:	a1 38 41 80 00       	mov    0x804138,%eax
  801ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec9:	eb 56                	jmp    801f21 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ecf:	74 1c                	je     801eed <print_mem_block_lists+0x5d>
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	8b 50 08             	mov    0x8(%eax),%edx
  801ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eda:	8b 48 08             	mov    0x8(%eax),%ecx
  801edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee3:	01 c8                	add    %ecx,%eax
  801ee5:	39 c2                	cmp    %eax,%edx
  801ee7:	73 04                	jae    801eed <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ee9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef0:	8b 50 08             	mov    0x8(%eax),%edx
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef9:	01 c2                	add    %eax,%edx
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	8b 40 08             	mov    0x8(%eax),%eax
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	68 dd 3b 80 00       	push   $0x803bdd
  801f0b:	e8 5a e6 ff ff       	call   80056a <cprintf>
  801f10:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f19:	a1 40 41 80 00       	mov    0x804140,%eax
  801f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f25:	74 07                	je     801f2e <print_mem_block_lists+0x9e>
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	eb 05                	jmp    801f33 <print_mem_block_lists+0xa3>
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	a3 40 41 80 00       	mov    %eax,0x804140
  801f38:	a1 40 41 80 00       	mov    0x804140,%eax
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	75 8a                	jne    801ecb <print_mem_block_lists+0x3b>
  801f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f45:	75 84                	jne    801ecb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f47:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4b:	75 10                	jne    801f5d <print_mem_block_lists+0xcd>
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	68 ec 3b 80 00       	push   $0x803bec
  801f55:	e8 10 e6 ff ff       	call   80056a <cprintf>
  801f5a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f64:	83 ec 0c             	sub    $0xc,%esp
  801f67:	68 10 3c 80 00       	push   $0x803c10
  801f6c:	e8 f9 e5 ff ff       	call   80056a <cprintf>
  801f71:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f74:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f78:	a1 40 40 80 00       	mov    0x804040,%eax
  801f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f80:	eb 56                	jmp    801fd8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f86:	74 1c                	je     801fa4 <print_mem_block_lists+0x114>
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 50 08             	mov    0x8(%eax),%edx
  801f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f91:	8b 48 08             	mov    0x8(%eax),%ecx
  801f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f97:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9a:	01 c8                	add    %ecx,%eax
  801f9c:	39 c2                	cmp    %eax,%edx
  801f9e:	73 04                	jae    801fa4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	8b 50 08             	mov    0x8(%eax),%edx
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb0:	01 c2                	add    %eax,%edx
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	8b 40 08             	mov    0x8(%eax),%eax
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	68 dd 3b 80 00       	push   $0x803bdd
  801fc2:	e8 a3 e5 ff ff       	call   80056a <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd0:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdc:	74 07                	je     801fe5 <print_mem_block_lists+0x155>
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	8b 00                	mov    (%eax),%eax
  801fe3:	eb 05                	jmp    801fea <print_mem_block_lists+0x15a>
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fea:	a3 48 40 80 00       	mov    %eax,0x804048
  801fef:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	75 8a                	jne    801f82 <print_mem_block_lists+0xf2>
  801ff8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffc:	75 84                	jne    801f82 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ffe:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802002:	75 10                	jne    802014 <print_mem_block_lists+0x184>
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	68 28 3c 80 00       	push   $0x803c28
  80200c:	e8 59 e5 ff ff       	call   80056a <cprintf>
  802011:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	68 9c 3b 80 00       	push   $0x803b9c
  80201c:	e8 49 e5 ff ff       	call   80056a <cprintf>
  802021:	83 c4 10             	add    $0x10,%esp

}
  802024:	90                   	nop
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80202d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802034:	00 00 00 
  802037:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80203e:	00 00 00 
  802041:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802048:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80204b:	a1 50 40 80 00       	mov    0x804050,%eax
  802050:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802053:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80205a:	e9 9e 00 00 00       	jmp    8020fd <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80205f:	a1 50 40 80 00       	mov    0x804050,%eax
  802064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802067:	c1 e2 04             	shl    $0x4,%edx
  80206a:	01 d0                	add    %edx,%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	75 14                	jne    802084 <initialize_MemBlocksList+0x5d>
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	68 50 3c 80 00       	push   $0x803c50
  802078:	6a 48                	push   $0x48
  80207a:	68 73 3c 80 00       	push   $0x803c73
  80207f:	e8 32 e2 ff ff       	call   8002b6 <_panic>
  802084:	a1 50 40 80 00       	mov    0x804050,%eax
  802089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208c:	c1 e2 04             	shl    $0x4,%edx
  80208f:	01 d0                	add    %edx,%eax
  802091:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802097:	89 10                	mov    %edx,(%eax)
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	74 18                	je     8020b7 <initialize_MemBlocksList+0x90>
  80209f:	a1 48 41 80 00       	mov    0x804148,%eax
  8020a4:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020ad:	c1 e1 04             	shl    $0x4,%ecx
  8020b0:	01 ca                	add    %ecx,%edx
  8020b2:	89 50 04             	mov    %edx,0x4(%eax)
  8020b5:	eb 12                	jmp    8020c9 <initialize_MemBlocksList+0xa2>
  8020b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bf:	c1 e2 04             	shl    $0x4,%edx
  8020c2:	01 d0                	add    %edx,%eax
  8020c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020c9:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d1:	c1 e2 04             	shl    $0x4,%edx
  8020d4:	01 d0                	add    %edx,%eax
  8020d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8020db:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e3:	c1 e2 04             	shl    $0x4,%edx
  8020e6:	01 d0                	add    %edx,%eax
  8020e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ef:	a1 54 41 80 00       	mov    0x804154,%eax
  8020f4:	40                   	inc    %eax
  8020f5:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8020fa:	ff 45 f4             	incl   -0xc(%ebp)
  8020fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802100:	3b 45 08             	cmp    0x8(%ebp),%eax
  802103:	0f 82 56 ff ff ff    	jb     80205f <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802109:	90                   	nop
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	8b 00                	mov    (%eax),%eax
  802117:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80211a:	eb 18                	jmp    802134 <find_block+0x28>
		{
			if(tmp->sva==va)
  80211c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211f:	8b 40 08             	mov    0x8(%eax),%eax
  802122:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802125:	75 05                	jne    80212c <find_block+0x20>
			{
				return tmp;
  802127:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212a:	eb 11                	jmp    80213d <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80212c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212f:	8b 00                	mov    (%eax),%eax
  802131:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802138:	75 e2                	jne    80211c <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80213a:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802145:	a1 40 40 80 00       	mov    0x804040,%eax
  80214a:	85 c0                	test   %eax,%eax
  80214c:	0f 85 83 00 00 00    	jne    8021d5 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802152:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802159:	00 00 00 
  80215c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  802163:	00 00 00 
  802166:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80216d:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802170:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802174:	75 14                	jne    80218a <insert_sorted_allocList+0x4b>
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	68 50 3c 80 00       	push   $0x803c50
  80217e:	6a 7f                	push   $0x7f
  802180:	68 73 3c 80 00       	push   $0x803c73
  802185:	e8 2c e1 ff ff       	call   8002b6 <_panic>
  80218a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	89 10                	mov    %edx,(%eax)
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	8b 00                	mov    (%eax),%eax
  80219a:	85 c0                	test   %eax,%eax
  80219c:	74 0d                	je     8021ab <insert_sorted_allocList+0x6c>
  80219e:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a6:	89 50 04             	mov    %edx,0x4(%eax)
  8021a9:	eb 08                	jmp    8021b3 <insert_sorted_allocList+0x74>
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	a3 44 40 80 00       	mov    %eax,0x804044
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	a3 40 40 80 00       	mov    %eax,0x804040
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ca:	40                   	inc    %eax
  8021cb:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021d0:	e9 16 01 00 00       	jmp    8022eb <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8b 50 08             	mov    0x8(%eax),%edx
  8021db:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e0:	8b 40 08             	mov    0x8(%eax),%eax
  8021e3:	39 c2                	cmp    %eax,%edx
  8021e5:	76 68                	jbe    80224f <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021eb:	75 17                	jne    802204 <insert_sorted_allocList+0xc5>
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	68 8c 3c 80 00       	push   $0x803c8c
  8021f5:	68 85 00 00 00       	push   $0x85
  8021fa:	68 73 3c 80 00       	push   $0x803c73
  8021ff:	e8 b2 e0 ff ff       	call   8002b6 <_panic>
  802204:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	89 50 04             	mov    %edx,0x4(%eax)
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	8b 40 04             	mov    0x4(%eax),%eax
  802216:	85 c0                	test   %eax,%eax
  802218:	74 0c                	je     802226 <insert_sorted_allocList+0xe7>
  80221a:	a1 44 40 80 00       	mov    0x804044,%eax
  80221f:	8b 55 08             	mov    0x8(%ebp),%edx
  802222:	89 10                	mov    %edx,(%eax)
  802224:	eb 08                	jmp    80222e <insert_sorted_allocList+0xef>
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 40 40 80 00       	mov    %eax,0x804040
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	a3 44 40 80 00       	mov    %eax,0x804044
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80223f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802244:	40                   	inc    %eax
  802245:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80224a:	e9 9c 00 00 00       	jmp    8022eb <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80224f:	a1 40 40 80 00       	mov    0x804040,%eax
  802254:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802257:	e9 85 00 00 00       	jmp    8022e1 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	8b 50 08             	mov    0x8(%eax),%edx
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	8b 40 08             	mov    0x8(%eax),%eax
  802268:	39 c2                	cmp    %eax,%edx
  80226a:	73 6d                	jae    8022d9 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80226c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802270:	74 06                	je     802278 <insert_sorted_allocList+0x139>
  802272:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802276:	75 17                	jne    80228f <insert_sorted_allocList+0x150>
  802278:	83 ec 04             	sub    $0x4,%esp
  80227b:	68 b0 3c 80 00       	push   $0x803cb0
  802280:	68 90 00 00 00       	push   $0x90
  802285:	68 73 3c 80 00       	push   $0x803c73
  80228a:	e8 27 e0 ff ff       	call   8002b6 <_panic>
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 50 04             	mov    0x4(%eax),%edx
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	89 50 04             	mov    %edx,0x4(%eax)
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a1:	89 10                	mov    %edx,(%eax)
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 40 04             	mov    0x4(%eax),%eax
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	74 0d                	je     8022ba <insert_sorted_allocList+0x17b>
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 40 04             	mov    0x4(%eax),%eax
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b6:	89 10                	mov    %edx,(%eax)
  8022b8:	eb 08                	jmp    8022c2 <insert_sorted_allocList+0x183>
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	a3 40 40 80 00       	mov    %eax,0x804040
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c8:	89 50 04             	mov    %edx,0x4(%eax)
  8022cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d0:	40                   	inc    %eax
  8022d1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022d6:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022d7:	eb 12                	jmp    8022eb <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8022e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e5:	0f 85 71 ff ff ff    	jne    80225c <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022eb:	90                   	nop
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8022f4:	a1 38 41 80 00       	mov    0x804138,%eax
  8022f9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8022fc:	e9 76 01 00 00       	jmp    802477 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 40 0c             	mov    0xc(%eax),%eax
  802307:	3b 45 08             	cmp    0x8(%ebp),%eax
  80230a:	0f 85 8a 00 00 00    	jne    80239a <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802314:	75 17                	jne    80232d <alloc_block_FF+0x3f>
  802316:	83 ec 04             	sub    $0x4,%esp
  802319:	68 e5 3c 80 00       	push   $0x803ce5
  80231e:	68 a8 00 00 00       	push   $0xa8
  802323:	68 73 3c 80 00       	push   $0x803c73
  802328:	e8 89 df ff ff       	call   8002b6 <_panic>
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	74 10                	je     802346 <alloc_block_FF+0x58>
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233e:	8b 52 04             	mov    0x4(%edx),%edx
  802341:	89 50 04             	mov    %edx,0x4(%eax)
  802344:	eb 0b                	jmp    802351 <alloc_block_FF+0x63>
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 40 04             	mov    0x4(%eax),%eax
  80234c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 40 04             	mov    0x4(%eax),%eax
  802357:	85 c0                	test   %eax,%eax
  802359:	74 0f                	je     80236a <alloc_block_FF+0x7c>
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 40 04             	mov    0x4(%eax),%eax
  802361:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802364:	8b 12                	mov    (%edx),%edx
  802366:	89 10                	mov    %edx,(%eax)
  802368:	eb 0a                	jmp    802374 <alloc_block_FF+0x86>
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	a3 38 41 80 00       	mov    %eax,0x804138
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802387:	a1 44 41 80 00       	mov    0x804144,%eax
  80238c:	48                   	dec    %eax
  80238d:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	e9 ea 00 00 00       	jmp    802484 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a3:	0f 86 c6 00 00 00    	jbe    80246f <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8023a9:	a1 48 41 80 00       	mov    0x804148,%eax
  8023ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b7:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 50 08             	mov    0x8(%eax),%edx
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c3:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cc:	2b 45 08             	sub    0x8(%ebp),%eax
  8023cf:	89 c2                	mov    %eax,%edx
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 50 08             	mov    0x8(%eax),%edx
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	01 c2                	add    %eax,%edx
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ec:	75 17                	jne    802405 <alloc_block_FF+0x117>
  8023ee:	83 ec 04             	sub    $0x4,%esp
  8023f1:	68 e5 3c 80 00       	push   $0x803ce5
  8023f6:	68 b6 00 00 00       	push   $0xb6
  8023fb:	68 73 3c 80 00       	push   $0x803c73
  802400:	e8 b1 de ff ff       	call   8002b6 <_panic>
  802405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	74 10                	je     80241e <alloc_block_FF+0x130>
  80240e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802411:	8b 00                	mov    (%eax),%eax
  802413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802416:	8b 52 04             	mov    0x4(%edx),%edx
  802419:	89 50 04             	mov    %edx,0x4(%eax)
  80241c:	eb 0b                	jmp    802429 <alloc_block_FF+0x13b>
  80241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802421:	8b 40 04             	mov    0x4(%eax),%eax
  802424:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242c:	8b 40 04             	mov    0x4(%eax),%eax
  80242f:	85 c0                	test   %eax,%eax
  802431:	74 0f                	je     802442 <alloc_block_FF+0x154>
  802433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243c:	8b 12                	mov    (%edx),%edx
  80243e:	89 10                	mov    %edx,(%eax)
  802440:	eb 0a                	jmp    80244c <alloc_block_FF+0x15e>
  802442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802445:	8b 00                	mov    (%eax),%eax
  802447:	a3 48 41 80 00       	mov    %eax,0x804148
  80244c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802458:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245f:	a1 54 41 80 00       	mov    0x804154,%eax
  802464:	48                   	dec    %eax
  802465:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	eb 15                	jmp    802484 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247b:	0f 85 80 fe ff ff    	jne    802301 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80248c:	a1 38 41 80 00       	mov    0x804138,%eax
  802491:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802494:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80249b:	e9 c0 00 00 00       	jmp    802560 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a9:	0f 85 8a 00 00 00    	jne    802539 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8024af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b3:	75 17                	jne    8024cc <alloc_block_BF+0x46>
  8024b5:	83 ec 04             	sub    $0x4,%esp
  8024b8:	68 e5 3c 80 00       	push   $0x803ce5
  8024bd:	68 cf 00 00 00       	push   $0xcf
  8024c2:	68 73 3c 80 00       	push   $0x803c73
  8024c7:	e8 ea dd ff ff       	call   8002b6 <_panic>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 10                	je     8024e5 <alloc_block_BF+0x5f>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dd:	8b 52 04             	mov    0x4(%edx),%edx
  8024e0:	89 50 04             	mov    %edx,0x4(%eax)
  8024e3:	eb 0b                	jmp    8024f0 <alloc_block_BF+0x6a>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 04             	mov    0x4(%eax),%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 0f                	je     802509 <alloc_block_BF+0x83>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 04             	mov    0x4(%eax),%eax
  802500:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802503:	8b 12                	mov    (%edx),%edx
  802505:	89 10                	mov    %edx,(%eax)
  802507:	eb 0a                	jmp    802513 <alloc_block_BF+0x8d>
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	a3 38 41 80 00       	mov    %eax,0x804138
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802526:	a1 44 41 80 00       	mov    0x804144,%eax
  80252b:	48                   	dec    %eax
  80252c:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	e9 2a 01 00 00       	jmp    802663 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 0c             	mov    0xc(%eax),%eax
  80253f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802542:	73 14                	jae    802558 <alloc_block_BF+0xd2>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 0c             	mov    0xc(%eax),%eax
  80254a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254d:	76 09                	jbe    802558 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 40 0c             	mov    0xc(%eax),%eax
  802555:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802564:	0f 85 36 ff ff ff    	jne    8024a0 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80256a:	a1 38 41 80 00       	mov    0x804138,%eax
  80256f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802572:	e9 dd 00 00 00       	jmp    802654 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 0c             	mov    0xc(%eax),%eax
  80257d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802580:	0f 85 c6 00 00 00    	jne    80264c <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802586:	a1 48 41 80 00       	mov    0x804148,%eax
  80258b:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 50 08             	mov    0x8(%eax),%edx
  802594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802597:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80259a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259d:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a0:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 50 08             	mov    0x8(%eax),%edx
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	01 c2                	add    %eax,%edx
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8025bd:	89 c2                	mov    %eax,%edx
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025c9:	75 17                	jne    8025e2 <alloc_block_BF+0x15c>
  8025cb:	83 ec 04             	sub    $0x4,%esp
  8025ce:	68 e5 3c 80 00       	push   $0x803ce5
  8025d3:	68 eb 00 00 00       	push   $0xeb
  8025d8:	68 73 3c 80 00       	push   $0x803c73
  8025dd:	e8 d4 dc ff ff       	call   8002b6 <_panic>
  8025e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	74 10                	je     8025fb <alloc_block_BF+0x175>
  8025eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f3:	8b 52 04             	mov    0x4(%edx),%edx
  8025f6:	89 50 04             	mov    %edx,0x4(%eax)
  8025f9:	eb 0b                	jmp    802606 <alloc_block_BF+0x180>
  8025fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fe:	8b 40 04             	mov    0x4(%eax),%eax
  802601:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 0f                	je     80261f <alloc_block_BF+0x199>
  802610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802619:	8b 12                	mov    (%edx),%edx
  80261b:	89 10                	mov    %edx,(%eax)
  80261d:	eb 0a                	jmp    802629 <alloc_block_BF+0x1a3>
  80261f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	a3 48 41 80 00       	mov    %eax,0x804148
  802629:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263c:	a1 54 41 80 00       	mov    0x804154,%eax
  802641:	48                   	dec    %eax
  802642:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264a:	eb 17                	jmp    802663 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802658:	0f 85 19 ff ff ff    	jne    802577 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80266b:	a1 40 40 80 00       	mov    0x804040,%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	75 19                	jne    80268d <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802674:	83 ec 0c             	sub    $0xc,%esp
  802677:	ff 75 08             	pushl  0x8(%ebp)
  80267a:	e8 6f fc ff ff       	call   8022ee <alloc_block_FF>
  80267f:	83 c4 10             	add    $0x10,%esp
  802682:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	e9 e9 01 00 00       	jmp    802876 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80268d:	a1 44 40 80 00       	mov    0x804044,%eax
  802692:	8b 40 08             	mov    0x8(%eax),%eax
  802695:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802698:	a1 44 40 80 00       	mov    0x804044,%eax
  80269d:	8b 50 0c             	mov    0xc(%eax),%edx
  8026a0:	a1 44 40 80 00       	mov    0x804044,%eax
  8026a5:	8b 40 08             	mov    0x8(%eax),%eax
  8026a8:	01 d0                	add    %edx,%eax
  8026aa:	83 ec 08             	sub    $0x8,%esp
  8026ad:	50                   	push   %eax
  8026ae:	68 38 41 80 00       	push   $0x804138
  8026b3:	e8 54 fa ff ff       	call   80210c <find_block>
  8026b8:	83 c4 10             	add    $0x10,%esp
  8026bb:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c7:	0f 85 9b 00 00 00    	jne    802768 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 40 08             	mov    0x8(%eax),%eax
  8026d9:	01 d0                	add    %edx,%eax
  8026db:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8026de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e2:	75 17                	jne    8026fb <alloc_block_NF+0x96>
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 e5 3c 80 00       	push   $0x803ce5
  8026ec:	68 1a 01 00 00       	push   $0x11a
  8026f1:	68 73 3c 80 00       	push   $0x803c73
  8026f6:	e8 bb db ff ff       	call   8002b6 <_panic>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 10                	je     802714 <alloc_block_NF+0xaf>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	8b 52 04             	mov    0x4(%edx),%edx
  80270f:	89 50 04             	mov    %edx,0x4(%eax)
  802712:	eb 0b                	jmp    80271f <alloc_block_NF+0xba>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 0f                	je     802738 <alloc_block_NF+0xd3>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802732:	8b 12                	mov    (%edx),%edx
  802734:	89 10                	mov    %edx,(%eax)
  802736:	eb 0a                	jmp    802742 <alloc_block_NF+0xdd>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	a3 38 41 80 00       	mov    %eax,0x804138
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802755:	a1 44 41 80 00       	mov    0x804144,%eax
  80275a:	48                   	dec    %eax
  80275b:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	e9 0e 01 00 00       	jmp    802876 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	0f 86 cf 00 00 00    	jbe    802846 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802777:	a1 48 41 80 00       	mov    0x804148,%eax
  80277c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80277f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802782:	8b 55 08             	mov    0x8(%ebp),%edx
  802785:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 50 08             	mov    0x8(%eax),%edx
  80278e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802791:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 50 08             	mov    0x8(%eax),%edx
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	01 c2                	add    %eax,%edx
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ae:	89 c2                	mov    %eax,%edx
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 40 08             	mov    0x8(%eax),%eax
  8027bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027c3:	75 17                	jne    8027dc <alloc_block_NF+0x177>
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	68 e5 3c 80 00       	push   $0x803ce5
  8027cd:	68 28 01 00 00       	push   $0x128
  8027d2:	68 73 3c 80 00       	push   $0x803c73
  8027d7:	e8 da da ff ff       	call   8002b6 <_panic>
  8027dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	74 10                	je     8027f5 <alloc_block_NF+0x190>
  8027e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ed:	8b 52 04             	mov    0x4(%edx),%edx
  8027f0:	89 50 04             	mov    %edx,0x4(%eax)
  8027f3:	eb 0b                	jmp    802800 <alloc_block_NF+0x19b>
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 0f                	je     802819 <alloc_block_NF+0x1b4>
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802813:	8b 12                	mov    (%edx),%edx
  802815:	89 10                	mov    %edx,(%eax)
  802817:	eb 0a                	jmp    802823 <alloc_block_NF+0x1be>
  802819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	a3 48 41 80 00       	mov    %eax,0x804148
  802823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802836:	a1 54 41 80 00       	mov    0x804154,%eax
  80283b:	48                   	dec    %eax
  80283c:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802844:	eb 30                	jmp    802876 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802846:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80284b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80284e:	75 0a                	jne    80285a <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802850:	a1 38 41 80 00       	mov    0x804138,%eax
  802855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802858:	eb 08                	jmp    802862 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 00                	mov    (%eax),%eax
  80285f:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 08             	mov    0x8(%eax),%eax
  802868:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80286b:	0f 85 4d fe ff ff    	jne    8026be <alloc_block_NF+0x59>

			return NULL;
  802871:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	53                   	push   %ebx
  80287c:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80287f:	a1 38 41 80 00       	mov    0x804138,%eax
  802884:	85 c0                	test   %eax,%eax
  802886:	0f 85 86 00 00 00    	jne    802912 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80288c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802893:	00 00 00 
  802896:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80289d:	00 00 00 
  8028a0:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8028a7:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ae:	75 17                	jne    8028c7 <insert_sorted_with_merge_freeList+0x4f>
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 50 3c 80 00       	push   $0x803c50
  8028b8:	68 48 01 00 00       	push   $0x148
  8028bd:	68 73 3c 80 00       	push   $0x803c73
  8028c2:	e8 ef d9 ff ff       	call   8002b6 <_panic>
  8028c7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	89 10                	mov    %edx,(%eax)
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 0d                	je     8028e8 <insert_sorted_with_merge_freeList+0x70>
  8028db:	a1 38 41 80 00       	mov    0x804138,%eax
  8028e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	eb 08                	jmp    8028f0 <insert_sorted_with_merge_freeList+0x78>
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	a3 38 41 80 00       	mov    %eax,0x804138
  8028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802902:	a1 44 41 80 00       	mov    0x804144,%eax
  802907:	40                   	inc    %eax
  802908:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80290d:	e9 73 07 00 00       	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	8b 50 08             	mov    0x8(%eax),%edx
  802918:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80291d:	8b 40 08             	mov    0x8(%eax),%eax
  802920:	39 c2                	cmp    %eax,%edx
  802922:	0f 86 84 00 00 00    	jbe    8029ac <insert_sorted_with_merge_freeList+0x134>
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	8b 50 08             	mov    0x8(%eax),%edx
  80292e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802933:	8b 48 0c             	mov    0xc(%eax),%ecx
  802936:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80293b:	8b 40 08             	mov    0x8(%eax),%eax
  80293e:	01 c8                	add    %ecx,%eax
  802940:	39 c2                	cmp    %eax,%edx
  802942:	74 68                	je     8029ac <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802944:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802948:	75 17                	jne    802961 <insert_sorted_with_merge_freeList+0xe9>
  80294a:	83 ec 04             	sub    $0x4,%esp
  80294d:	68 8c 3c 80 00       	push   $0x803c8c
  802952:	68 4c 01 00 00       	push   $0x14c
  802957:	68 73 3c 80 00       	push   $0x803c73
  80295c:	e8 55 d9 ff ff       	call   8002b6 <_panic>
  802961:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	8b 40 04             	mov    0x4(%eax),%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 0c                	je     802983 <insert_sorted_with_merge_freeList+0x10b>
  802977:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80297c:	8b 55 08             	mov    0x8(%ebp),%edx
  80297f:	89 10                	mov    %edx,(%eax)
  802981:	eb 08                	jmp    80298b <insert_sorted_with_merge_freeList+0x113>
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	a3 38 41 80 00       	mov    %eax,0x804138
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299c:	a1 44 41 80 00       	mov    0x804144,%eax
  8029a1:	40                   	inc    %eax
  8029a2:	a3 44 41 80 00       	mov    %eax,0x804144
  8029a7:	e9 d9 06 00 00       	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	8b 50 08             	mov    0x8(%eax),%edx
  8029b2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029b7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ba:	39 c2                	cmp    %eax,%edx
  8029bc:	0f 86 b5 00 00 00    	jbe    802a77 <insert_sorted_with_merge_freeList+0x1ff>
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	8b 50 08             	mov    0x8(%eax),%edx
  8029c8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029cd:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029d0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029d5:	8b 40 08             	mov    0x8(%eax),%eax
  8029d8:	01 c8                	add    %ecx,%eax
  8029da:	39 c2                	cmp    %eax,%edx
  8029dc:	0f 85 95 00 00 00    	jne    802a77 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8029e2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e7:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029ed:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f3:	8b 52 0c             	mov    0xc(%edx),%edx
  8029f6:	01 ca                	add    %ecx,%edx
  8029f8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a13:	75 17                	jne    802a2c <insert_sorted_with_merge_freeList+0x1b4>
  802a15:	83 ec 04             	sub    $0x4,%esp
  802a18:	68 50 3c 80 00       	push   $0x803c50
  802a1d:	68 54 01 00 00       	push   $0x154
  802a22:	68 73 3c 80 00       	push   $0x803c73
  802a27:	e8 8a d8 ff ff       	call   8002b6 <_panic>
  802a2c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	89 10                	mov    %edx,(%eax)
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	74 0d                	je     802a4d <insert_sorted_with_merge_freeList+0x1d5>
  802a40:	a1 48 41 80 00       	mov    0x804148,%eax
  802a45:	8b 55 08             	mov    0x8(%ebp),%edx
  802a48:	89 50 04             	mov    %edx,0x4(%eax)
  802a4b:	eb 08                	jmp    802a55 <insert_sorted_with_merge_freeList+0x1dd>
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	a3 48 41 80 00       	mov    %eax,0x804148
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a67:	a1 54 41 80 00       	mov    0x804154,%eax
  802a6c:	40                   	inc    %eax
  802a6d:	a3 54 41 80 00       	mov    %eax,0x804154
  802a72:	e9 0e 06 00 00       	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	8b 50 08             	mov    0x8(%eax),%edx
  802a7d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a82:	8b 40 08             	mov    0x8(%eax),%eax
  802a85:	39 c2                	cmp    %eax,%edx
  802a87:	0f 83 c1 00 00 00    	jae    802b4e <insert_sorted_with_merge_freeList+0x2d6>
  802a8d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a92:	8b 50 08             	mov    0x8(%eax),%edx
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	8b 48 08             	mov    0x8(%eax),%ecx
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa1:	01 c8                	add    %ecx,%eax
  802aa3:	39 c2                	cmp    %eax,%edx
  802aa5:	0f 85 a3 00 00 00    	jne    802b4e <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802aab:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab3:	8b 52 08             	mov    0x8(%edx),%edx
  802ab6:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ab9:	a1 38 41 80 00       	mov    0x804138,%eax
  802abe:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ac4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aca:	8b 52 0c             	mov    0xc(%edx),%edx
  802acd:	01 ca                	add    %ecx,%edx
  802acf:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ae6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aea:	75 17                	jne    802b03 <insert_sorted_with_merge_freeList+0x28b>
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	68 50 3c 80 00       	push   $0x803c50
  802af4:	68 5d 01 00 00       	push   $0x15d
  802af9:	68 73 3c 80 00       	push   $0x803c73
  802afe:	e8 b3 d7 ff ff       	call   8002b6 <_panic>
  802b03:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	89 10                	mov    %edx,(%eax)
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	74 0d                	je     802b24 <insert_sorted_with_merge_freeList+0x2ac>
  802b17:	a1 48 41 80 00       	mov    0x804148,%eax
  802b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1f:	89 50 04             	mov    %edx,0x4(%eax)
  802b22:	eb 08                	jmp    802b2c <insert_sorted_with_merge_freeList+0x2b4>
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	a3 48 41 80 00       	mov    %eax,0x804148
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3e:	a1 54 41 80 00       	mov    0x804154,%eax
  802b43:	40                   	inc    %eax
  802b44:	a3 54 41 80 00       	mov    %eax,0x804154
  802b49:	e9 37 05 00 00       	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	8b 50 08             	mov    0x8(%eax),%edx
  802b54:	a1 38 41 80 00       	mov    0x804138,%eax
  802b59:	8b 40 08             	mov    0x8(%eax),%eax
  802b5c:	39 c2                	cmp    %eax,%edx
  802b5e:	0f 83 82 00 00 00    	jae    802be6 <insert_sorted_with_merge_freeList+0x36e>
  802b64:	a1 38 41 80 00       	mov    0x804138,%eax
  802b69:	8b 50 08             	mov    0x8(%eax),%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	8b 48 08             	mov    0x8(%eax),%ecx
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 40 0c             	mov    0xc(%eax),%eax
  802b78:	01 c8                	add    %ecx,%eax
  802b7a:	39 c2                	cmp    %eax,%edx
  802b7c:	74 68                	je     802be6 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b82:	75 17                	jne    802b9b <insert_sorted_with_merge_freeList+0x323>
  802b84:	83 ec 04             	sub    $0x4,%esp
  802b87:	68 50 3c 80 00       	push   $0x803c50
  802b8c:	68 62 01 00 00       	push   $0x162
  802b91:	68 73 3c 80 00       	push   $0x803c73
  802b96:	e8 1b d7 ff ff       	call   8002b6 <_panic>
  802b9b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	89 10                	mov    %edx,(%eax)
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 0d                	je     802bbc <insert_sorted_with_merge_freeList+0x344>
  802baf:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb7:	89 50 04             	mov    %edx,0x4(%eax)
  802bba:	eb 08                	jmp    802bc4 <insert_sorted_with_merge_freeList+0x34c>
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	a3 38 41 80 00       	mov    %eax,0x804138
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd6:	a1 44 41 80 00       	mov    0x804144,%eax
  802bdb:	40                   	inc    %eax
  802bdc:	a3 44 41 80 00       	mov    %eax,0x804144
  802be1:	e9 9f 04 00 00       	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802be6:	a1 38 41 80 00       	mov    0x804138,%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802bf0:	e9 84 04 00 00       	jmp    803079 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 50 08             	mov    0x8(%eax),%edx
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	39 c2                	cmp    %eax,%edx
  802c03:	0f 86 a9 00 00 00    	jbe    802cb2 <insert_sorted_with_merge_freeList+0x43a>
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 50 08             	mov    0x8(%eax),%edx
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	8b 48 08             	mov    0x8(%eax),%ecx
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1b:	01 c8                	add    %ecx,%eax
  802c1d:	39 c2                	cmp    %eax,%edx
  802c1f:	0f 84 8d 00 00 00    	je     802cb2 <insert_sorted_with_merge_freeList+0x43a>
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	8b 50 08             	mov    0x8(%eax),%edx
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 40 04             	mov    0x4(%eax),%eax
  802c31:	8b 48 08             	mov    0x8(%eax),%ecx
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 04             	mov    0x4(%eax),%eax
  802c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3d:	01 c8                	add    %ecx,%eax
  802c3f:	39 c2                	cmp    %eax,%edx
  802c41:	74 6f                	je     802cb2 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c47:	74 06                	je     802c4f <insert_sorted_with_merge_freeList+0x3d7>
  802c49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4d:	75 17                	jne    802c66 <insert_sorted_with_merge_freeList+0x3ee>
  802c4f:	83 ec 04             	sub    $0x4,%esp
  802c52:	68 b0 3c 80 00       	push   $0x803cb0
  802c57:	68 6b 01 00 00       	push   $0x16b
  802c5c:	68 73 3c 80 00       	push   $0x803c73
  802c61:	e8 50 d6 ff ff       	call   8002b6 <_panic>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 50 04             	mov    0x4(%eax),%edx
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c78:	89 10                	mov    %edx,(%eax)
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 0d                	je     802c91 <insert_sorted_with_merge_freeList+0x419>
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8d:	89 10                	mov    %edx,(%eax)
  802c8f:	eb 08                	jmp    802c99 <insert_sorted_with_merge_freeList+0x421>
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	a3 38 41 80 00       	mov    %eax,0x804138
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca7:	40                   	inc    %eax
  802ca8:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802cad:	e9 d3 03 00 00       	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 50 08             	mov    0x8(%eax),%edx
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8b 40 08             	mov    0x8(%eax),%eax
  802cbe:	39 c2                	cmp    %eax,%edx
  802cc0:	0f 86 da 00 00 00    	jbe    802da0 <insert_sorted_with_merge_freeList+0x528>
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 50 08             	mov    0x8(%eax),%edx
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	8b 48 08             	mov    0x8(%eax),%ecx
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd8:	01 c8                	add    %ecx,%eax
  802cda:	39 c2                	cmp    %eax,%edx
  802cdc:	0f 85 be 00 00 00    	jne    802da0 <insert_sorted_with_merge_freeList+0x528>
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 50 08             	mov    0x8(%eax),%edx
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 40 04             	mov    0x4(%eax),%eax
  802cee:	8b 48 08             	mov    0x8(%eax),%ecx
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfa:	01 c8                	add    %ecx,%eax
  802cfc:	39 c2                	cmp    %eax,%edx
  802cfe:	0f 84 9c 00 00 00    	je     802da0 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	8b 50 08             	mov    0x8(%eax),%edx
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 50 0c             	mov    0xc(%eax),%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1c:	01 c2                	add    %eax,%edx
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3c:	75 17                	jne    802d55 <insert_sorted_with_merge_freeList+0x4dd>
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 50 3c 80 00       	push   $0x803c50
  802d46:	68 74 01 00 00       	push   $0x174
  802d4b:	68 73 3c 80 00       	push   $0x803c73
  802d50:	e8 61 d5 ff ff       	call   8002b6 <_panic>
  802d55:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	89 10                	mov    %edx,(%eax)
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	8b 00                	mov    (%eax),%eax
  802d65:	85 c0                	test   %eax,%eax
  802d67:	74 0d                	je     802d76 <insert_sorted_with_merge_freeList+0x4fe>
  802d69:	a1 48 41 80 00       	mov    0x804148,%eax
  802d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	eb 08                	jmp    802d7e <insert_sorted_with_merge_freeList+0x506>
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	a3 48 41 80 00       	mov    %eax,0x804148
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d90:	a1 54 41 80 00       	mov    0x804154,%eax
  802d95:	40                   	inc    %eax
  802d96:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d9b:	e9 e5 02 00 00       	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 50 08             	mov    0x8(%eax),%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 40 08             	mov    0x8(%eax),%eax
  802dac:	39 c2                	cmp    %eax,%edx
  802dae:	0f 86 d7 00 00 00    	jbe    802e8b <insert_sorted_with_merge_freeList+0x613>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 50 08             	mov    0x8(%eax),%edx
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	8b 48 08             	mov    0x8(%eax),%ecx
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	01 c8                	add    %ecx,%eax
  802dc8:	39 c2                	cmp    %eax,%edx
  802dca:	0f 84 bb 00 00 00    	je     802e8b <insert_sorted_with_merge_freeList+0x613>
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 50 08             	mov    0x8(%eax),%edx
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	8b 40 04             	mov    0x4(%eax),%eax
  802ddc:	8b 48 08             	mov    0x8(%eax),%ecx
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 40 04             	mov    0x4(%eax),%eax
  802de5:	8b 40 0c             	mov    0xc(%eax),%eax
  802de8:	01 c8                	add    %ecx,%eax
  802dea:	39 c2                	cmp    %eax,%edx
  802dec:	0f 85 99 00 00 00    	jne    802e8b <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	8b 50 0c             	mov    0xc(%eax),%edx
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	01 c2                	add    %eax,%edx
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e27:	75 17                	jne    802e40 <insert_sorted_with_merge_freeList+0x5c8>
  802e29:	83 ec 04             	sub    $0x4,%esp
  802e2c:	68 50 3c 80 00       	push   $0x803c50
  802e31:	68 7d 01 00 00       	push   $0x17d
  802e36:	68 73 3c 80 00       	push   $0x803c73
  802e3b:	e8 76 d4 ff ff       	call   8002b6 <_panic>
  802e40:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	89 10                	mov    %edx,(%eax)
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	74 0d                	je     802e61 <insert_sorted_with_merge_freeList+0x5e9>
  802e54:	a1 48 41 80 00       	mov    0x804148,%eax
  802e59:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5c:	89 50 04             	mov    %edx,0x4(%eax)
  802e5f:	eb 08                	jmp    802e69 <insert_sorted_with_merge_freeList+0x5f1>
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	a3 48 41 80 00       	mov    %eax,0x804148
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7b:	a1 54 41 80 00       	mov    0x804154,%eax
  802e80:	40                   	inc    %eax
  802e81:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e86:	e9 fa 01 00 00       	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 50 08             	mov    0x8(%eax),%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	8b 40 08             	mov    0x8(%eax),%eax
  802e97:	39 c2                	cmp    %eax,%edx
  802e99:	0f 86 d2 01 00 00    	jbe    803071 <insert_sorted_with_merge_freeList+0x7f9>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 50 08             	mov    0x8(%eax),%edx
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	8b 48 08             	mov    0x8(%eax),%ecx
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	01 c8                	add    %ecx,%eax
  802eb3:	39 c2                	cmp    %eax,%edx
  802eb5:	0f 85 b6 01 00 00    	jne    803071 <insert_sorted_with_merge_freeList+0x7f9>
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 50 08             	mov    0x8(%eax),%edx
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 40 04             	mov    0x4(%eax),%eax
  802ec7:	8b 48 08             	mov    0x8(%eax),%ecx
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 40 04             	mov    0x4(%eax),%eax
  802ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed3:	01 c8                	add    %ecx,%eax
  802ed5:	39 c2                	cmp    %eax,%edx
  802ed7:	0f 85 94 01 00 00    	jne    803071 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 40 04             	mov    0x4(%eax),%eax
  802ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee6:	8b 52 04             	mov    0x4(%edx),%edx
  802ee9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802eec:	8b 55 08             	mov    0x8(%ebp),%edx
  802eef:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802ef2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef5:	8b 52 0c             	mov    0xc(%edx),%edx
  802ef8:	01 da                	add    %ebx,%edx
  802efa:	01 ca                	add    %ecx,%edx
  802efc:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f17:	75 17                	jne    802f30 <insert_sorted_with_merge_freeList+0x6b8>
  802f19:	83 ec 04             	sub    $0x4,%esp
  802f1c:	68 e5 3c 80 00       	push   $0x803ce5
  802f21:	68 86 01 00 00       	push   $0x186
  802f26:	68 73 3c 80 00       	push   $0x803c73
  802f2b:	e8 86 d3 ff ff       	call   8002b6 <_panic>
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 10                	je     802f49 <insert_sorted_with_merge_freeList+0x6d1>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f41:	8b 52 04             	mov    0x4(%edx),%edx
  802f44:	89 50 04             	mov    %edx,0x4(%eax)
  802f47:	eb 0b                	jmp    802f54 <insert_sorted_with_merge_freeList+0x6dc>
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 40 04             	mov    0x4(%eax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	74 0f                	je     802f6d <insert_sorted_with_merge_freeList+0x6f5>
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f67:	8b 12                	mov    (%edx),%edx
  802f69:	89 10                	mov    %edx,(%eax)
  802f6b:	eb 0a                	jmp    802f77 <insert_sorted_with_merge_freeList+0x6ff>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	a3 38 41 80 00       	mov    %eax,0x804138
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8a:	a1 44 41 80 00       	mov    0x804144,%eax
  802f8f:	48                   	dec    %eax
  802f90:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f99:	75 17                	jne    802fb2 <insert_sorted_with_merge_freeList+0x73a>
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	68 50 3c 80 00       	push   $0x803c50
  802fa3:	68 87 01 00 00       	push   $0x187
  802fa8:	68 73 3c 80 00       	push   $0x803c73
  802fad:	e8 04 d3 ff ff       	call   8002b6 <_panic>
  802fb2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	89 10                	mov    %edx,(%eax)
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 00                	mov    (%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 0d                	je     802fd3 <insert_sorted_with_merge_freeList+0x75b>
  802fc6:	a1 48 41 80 00       	mov    0x804148,%eax
  802fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fce:	89 50 04             	mov    %edx,0x4(%eax)
  802fd1:	eb 08                	jmp    802fdb <insert_sorted_with_merge_freeList+0x763>
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	a3 48 41 80 00       	mov    %eax,0x804148
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fed:	a1 54 41 80 00       	mov    0x804154,%eax
  802ff2:	40                   	inc    %eax
  802ff3:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80300c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803010:	75 17                	jne    803029 <insert_sorted_with_merge_freeList+0x7b1>
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	68 50 3c 80 00       	push   $0x803c50
  80301a:	68 8a 01 00 00       	push   $0x18a
  80301f:	68 73 3c 80 00       	push   $0x803c73
  803024:	e8 8d d2 ff ff       	call   8002b6 <_panic>
  803029:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	89 10                	mov    %edx,(%eax)
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	8b 00                	mov    (%eax),%eax
  803039:	85 c0                	test   %eax,%eax
  80303b:	74 0d                	je     80304a <insert_sorted_with_merge_freeList+0x7d2>
  80303d:	a1 48 41 80 00       	mov    0x804148,%eax
  803042:	8b 55 08             	mov    0x8(%ebp),%edx
  803045:	89 50 04             	mov    %edx,0x4(%eax)
  803048:	eb 08                	jmp    803052 <insert_sorted_with_merge_freeList+0x7da>
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	a3 48 41 80 00       	mov    %eax,0x804148
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803064:	a1 54 41 80 00       	mov    0x804154,%eax
  803069:	40                   	inc    %eax
  80306a:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  80306f:	eb 14                	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307d:	0f 85 72 fb ff ff    	jne    802bf5 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803083:	eb 00                	jmp    803085 <insert_sorted_with_merge_freeList+0x80d>
  803085:	90                   	nop
  803086:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803089:	c9                   	leave  
  80308a:	c3                   	ret    

0080308b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80308b:	55                   	push   %ebp
  80308c:	89 e5                	mov    %esp,%ebp
  80308e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803091:	8b 55 08             	mov    0x8(%ebp),%edx
  803094:	89 d0                	mov    %edx,%eax
  803096:	c1 e0 02             	shl    $0x2,%eax
  803099:	01 d0                	add    %edx,%eax
  80309b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030a2:	01 d0                	add    %edx,%eax
  8030a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030ab:	01 d0                	add    %edx,%eax
  8030ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030b4:	01 d0                	add    %edx,%eax
  8030b6:	c1 e0 04             	shl    $0x4,%eax
  8030b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030c3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030c6:	83 ec 0c             	sub    $0xc,%esp
  8030c9:	50                   	push   %eax
  8030ca:	e8 7b eb ff ff       	call   801c4a <sys_get_virtual_time>
  8030cf:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030d2:	eb 41                	jmp    803115 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030d7:	83 ec 0c             	sub    $0xc,%esp
  8030da:	50                   	push   %eax
  8030db:	e8 6a eb ff ff       	call   801c4a <sys_get_virtual_time>
  8030e0:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e9:	29 c2                	sub    %eax,%edx
  8030eb:	89 d0                	mov    %edx,%eax
  8030ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f6:	89 d1                	mov    %edx,%ecx
  8030f8:	29 c1                	sub    %eax,%ecx
  8030fa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803100:	39 c2                	cmp    %eax,%edx
  803102:	0f 97 c0             	seta   %al
  803105:	0f b6 c0             	movzbl %al,%eax
  803108:	29 c1                	sub    %eax,%ecx
  80310a:	89 c8                	mov    %ecx,%eax
  80310c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80310f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803112:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803118:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80311b:	72 b7                	jb     8030d4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80311d:	90                   	nop
  80311e:	c9                   	leave  
  80311f:	c3                   	ret    

00803120 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803120:	55                   	push   %ebp
  803121:	89 e5                	mov    %esp,%ebp
  803123:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803126:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80312d:	eb 03                	jmp    803132 <busy_wait+0x12>
  80312f:	ff 45 fc             	incl   -0x4(%ebp)
  803132:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803135:	3b 45 08             	cmp    0x8(%ebp),%eax
  803138:	72 f5                	jb     80312f <busy_wait+0xf>
	return i;
  80313a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    
  80313f:	90                   	nop

00803140 <__udivdi3>:
  803140:	55                   	push   %ebp
  803141:	57                   	push   %edi
  803142:	56                   	push   %esi
  803143:	53                   	push   %ebx
  803144:	83 ec 1c             	sub    $0x1c,%esp
  803147:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80314b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80314f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803153:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803157:	89 ca                	mov    %ecx,%edx
  803159:	89 f8                	mov    %edi,%eax
  80315b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80315f:	85 f6                	test   %esi,%esi
  803161:	75 2d                	jne    803190 <__udivdi3+0x50>
  803163:	39 cf                	cmp    %ecx,%edi
  803165:	77 65                	ja     8031cc <__udivdi3+0x8c>
  803167:	89 fd                	mov    %edi,%ebp
  803169:	85 ff                	test   %edi,%edi
  80316b:	75 0b                	jne    803178 <__udivdi3+0x38>
  80316d:	b8 01 00 00 00       	mov    $0x1,%eax
  803172:	31 d2                	xor    %edx,%edx
  803174:	f7 f7                	div    %edi
  803176:	89 c5                	mov    %eax,%ebp
  803178:	31 d2                	xor    %edx,%edx
  80317a:	89 c8                	mov    %ecx,%eax
  80317c:	f7 f5                	div    %ebp
  80317e:	89 c1                	mov    %eax,%ecx
  803180:	89 d8                	mov    %ebx,%eax
  803182:	f7 f5                	div    %ebp
  803184:	89 cf                	mov    %ecx,%edi
  803186:	89 fa                	mov    %edi,%edx
  803188:	83 c4 1c             	add    $0x1c,%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5f                   	pop    %edi
  80318e:	5d                   	pop    %ebp
  80318f:	c3                   	ret    
  803190:	39 ce                	cmp    %ecx,%esi
  803192:	77 28                	ja     8031bc <__udivdi3+0x7c>
  803194:	0f bd fe             	bsr    %esi,%edi
  803197:	83 f7 1f             	xor    $0x1f,%edi
  80319a:	75 40                	jne    8031dc <__udivdi3+0x9c>
  80319c:	39 ce                	cmp    %ecx,%esi
  80319e:	72 0a                	jb     8031aa <__udivdi3+0x6a>
  8031a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031a4:	0f 87 9e 00 00 00    	ja     803248 <__udivdi3+0x108>
  8031aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8031af:	89 fa                	mov    %edi,%edx
  8031b1:	83 c4 1c             	add    $0x1c,%esp
  8031b4:	5b                   	pop    %ebx
  8031b5:	5e                   	pop    %esi
  8031b6:	5f                   	pop    %edi
  8031b7:	5d                   	pop    %ebp
  8031b8:	c3                   	ret    
  8031b9:	8d 76 00             	lea    0x0(%esi),%esi
  8031bc:	31 ff                	xor    %edi,%edi
  8031be:	31 c0                	xor    %eax,%eax
  8031c0:	89 fa                	mov    %edi,%edx
  8031c2:	83 c4 1c             	add    $0x1c,%esp
  8031c5:	5b                   	pop    %ebx
  8031c6:	5e                   	pop    %esi
  8031c7:	5f                   	pop    %edi
  8031c8:	5d                   	pop    %ebp
  8031c9:	c3                   	ret    
  8031ca:	66 90                	xchg   %ax,%ax
  8031cc:	89 d8                	mov    %ebx,%eax
  8031ce:	f7 f7                	div    %edi
  8031d0:	31 ff                	xor    %edi,%edi
  8031d2:	89 fa                	mov    %edi,%edx
  8031d4:	83 c4 1c             	add    $0x1c,%esp
  8031d7:	5b                   	pop    %ebx
  8031d8:	5e                   	pop    %esi
  8031d9:	5f                   	pop    %edi
  8031da:	5d                   	pop    %ebp
  8031db:	c3                   	ret    
  8031dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031e1:	89 eb                	mov    %ebp,%ebx
  8031e3:	29 fb                	sub    %edi,%ebx
  8031e5:	89 f9                	mov    %edi,%ecx
  8031e7:	d3 e6                	shl    %cl,%esi
  8031e9:	89 c5                	mov    %eax,%ebp
  8031eb:	88 d9                	mov    %bl,%cl
  8031ed:	d3 ed                	shr    %cl,%ebp
  8031ef:	89 e9                	mov    %ebp,%ecx
  8031f1:	09 f1                	or     %esi,%ecx
  8031f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031f7:	89 f9                	mov    %edi,%ecx
  8031f9:	d3 e0                	shl    %cl,%eax
  8031fb:	89 c5                	mov    %eax,%ebp
  8031fd:	89 d6                	mov    %edx,%esi
  8031ff:	88 d9                	mov    %bl,%cl
  803201:	d3 ee                	shr    %cl,%esi
  803203:	89 f9                	mov    %edi,%ecx
  803205:	d3 e2                	shl    %cl,%edx
  803207:	8b 44 24 08          	mov    0x8(%esp),%eax
  80320b:	88 d9                	mov    %bl,%cl
  80320d:	d3 e8                	shr    %cl,%eax
  80320f:	09 c2                	or     %eax,%edx
  803211:	89 d0                	mov    %edx,%eax
  803213:	89 f2                	mov    %esi,%edx
  803215:	f7 74 24 0c          	divl   0xc(%esp)
  803219:	89 d6                	mov    %edx,%esi
  80321b:	89 c3                	mov    %eax,%ebx
  80321d:	f7 e5                	mul    %ebp
  80321f:	39 d6                	cmp    %edx,%esi
  803221:	72 19                	jb     80323c <__udivdi3+0xfc>
  803223:	74 0b                	je     803230 <__udivdi3+0xf0>
  803225:	89 d8                	mov    %ebx,%eax
  803227:	31 ff                	xor    %edi,%edi
  803229:	e9 58 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  80322e:	66 90                	xchg   %ax,%ax
  803230:	8b 54 24 08          	mov    0x8(%esp),%edx
  803234:	89 f9                	mov    %edi,%ecx
  803236:	d3 e2                	shl    %cl,%edx
  803238:	39 c2                	cmp    %eax,%edx
  80323a:	73 e9                	jae    803225 <__udivdi3+0xe5>
  80323c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80323f:	31 ff                	xor    %edi,%edi
  803241:	e9 40 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  803246:	66 90                	xchg   %ax,%ax
  803248:	31 c0                	xor    %eax,%eax
  80324a:	e9 37 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  80324f:	90                   	nop

00803250 <__umoddi3>:
  803250:	55                   	push   %ebp
  803251:	57                   	push   %edi
  803252:	56                   	push   %esi
  803253:	53                   	push   %ebx
  803254:	83 ec 1c             	sub    $0x1c,%esp
  803257:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80325b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80325f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803263:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803267:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80326b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80326f:	89 f3                	mov    %esi,%ebx
  803271:	89 fa                	mov    %edi,%edx
  803273:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803277:	89 34 24             	mov    %esi,(%esp)
  80327a:	85 c0                	test   %eax,%eax
  80327c:	75 1a                	jne    803298 <__umoddi3+0x48>
  80327e:	39 f7                	cmp    %esi,%edi
  803280:	0f 86 a2 00 00 00    	jbe    803328 <__umoddi3+0xd8>
  803286:	89 c8                	mov    %ecx,%eax
  803288:	89 f2                	mov    %esi,%edx
  80328a:	f7 f7                	div    %edi
  80328c:	89 d0                	mov    %edx,%eax
  80328e:	31 d2                	xor    %edx,%edx
  803290:	83 c4 1c             	add    $0x1c,%esp
  803293:	5b                   	pop    %ebx
  803294:	5e                   	pop    %esi
  803295:	5f                   	pop    %edi
  803296:	5d                   	pop    %ebp
  803297:	c3                   	ret    
  803298:	39 f0                	cmp    %esi,%eax
  80329a:	0f 87 ac 00 00 00    	ja     80334c <__umoddi3+0xfc>
  8032a0:	0f bd e8             	bsr    %eax,%ebp
  8032a3:	83 f5 1f             	xor    $0x1f,%ebp
  8032a6:	0f 84 ac 00 00 00    	je     803358 <__umoddi3+0x108>
  8032ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8032b1:	29 ef                	sub    %ebp,%edi
  8032b3:	89 fe                	mov    %edi,%esi
  8032b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032b9:	89 e9                	mov    %ebp,%ecx
  8032bb:	d3 e0                	shl    %cl,%eax
  8032bd:	89 d7                	mov    %edx,%edi
  8032bf:	89 f1                	mov    %esi,%ecx
  8032c1:	d3 ef                	shr    %cl,%edi
  8032c3:	09 c7                	or     %eax,%edi
  8032c5:	89 e9                	mov    %ebp,%ecx
  8032c7:	d3 e2                	shl    %cl,%edx
  8032c9:	89 14 24             	mov    %edx,(%esp)
  8032cc:	89 d8                	mov    %ebx,%eax
  8032ce:	d3 e0                	shl    %cl,%eax
  8032d0:	89 c2                	mov    %eax,%edx
  8032d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d6:	d3 e0                	shl    %cl,%eax
  8032d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032e0:	89 f1                	mov    %esi,%ecx
  8032e2:	d3 e8                	shr    %cl,%eax
  8032e4:	09 d0                	or     %edx,%eax
  8032e6:	d3 eb                	shr    %cl,%ebx
  8032e8:	89 da                	mov    %ebx,%edx
  8032ea:	f7 f7                	div    %edi
  8032ec:	89 d3                	mov    %edx,%ebx
  8032ee:	f7 24 24             	mull   (%esp)
  8032f1:	89 c6                	mov    %eax,%esi
  8032f3:	89 d1                	mov    %edx,%ecx
  8032f5:	39 d3                	cmp    %edx,%ebx
  8032f7:	0f 82 87 00 00 00    	jb     803384 <__umoddi3+0x134>
  8032fd:	0f 84 91 00 00 00    	je     803394 <__umoddi3+0x144>
  803303:	8b 54 24 04          	mov    0x4(%esp),%edx
  803307:	29 f2                	sub    %esi,%edx
  803309:	19 cb                	sbb    %ecx,%ebx
  80330b:	89 d8                	mov    %ebx,%eax
  80330d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803311:	d3 e0                	shl    %cl,%eax
  803313:	89 e9                	mov    %ebp,%ecx
  803315:	d3 ea                	shr    %cl,%edx
  803317:	09 d0                	or     %edx,%eax
  803319:	89 e9                	mov    %ebp,%ecx
  80331b:	d3 eb                	shr    %cl,%ebx
  80331d:	89 da                	mov    %ebx,%edx
  80331f:	83 c4 1c             	add    $0x1c,%esp
  803322:	5b                   	pop    %ebx
  803323:	5e                   	pop    %esi
  803324:	5f                   	pop    %edi
  803325:	5d                   	pop    %ebp
  803326:	c3                   	ret    
  803327:	90                   	nop
  803328:	89 fd                	mov    %edi,%ebp
  80332a:	85 ff                	test   %edi,%edi
  80332c:	75 0b                	jne    803339 <__umoddi3+0xe9>
  80332e:	b8 01 00 00 00       	mov    $0x1,%eax
  803333:	31 d2                	xor    %edx,%edx
  803335:	f7 f7                	div    %edi
  803337:	89 c5                	mov    %eax,%ebp
  803339:	89 f0                	mov    %esi,%eax
  80333b:	31 d2                	xor    %edx,%edx
  80333d:	f7 f5                	div    %ebp
  80333f:	89 c8                	mov    %ecx,%eax
  803341:	f7 f5                	div    %ebp
  803343:	89 d0                	mov    %edx,%eax
  803345:	e9 44 ff ff ff       	jmp    80328e <__umoddi3+0x3e>
  80334a:	66 90                	xchg   %ax,%ax
  80334c:	89 c8                	mov    %ecx,%eax
  80334e:	89 f2                	mov    %esi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	3b 04 24             	cmp    (%esp),%eax
  80335b:	72 06                	jb     803363 <__umoddi3+0x113>
  80335d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803361:	77 0f                	ja     803372 <__umoddi3+0x122>
  803363:	89 f2                	mov    %esi,%edx
  803365:	29 f9                	sub    %edi,%ecx
  803367:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80336b:	89 14 24             	mov    %edx,(%esp)
  80336e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803372:	8b 44 24 04          	mov    0x4(%esp),%eax
  803376:	8b 14 24             	mov    (%esp),%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	2b 04 24             	sub    (%esp),%eax
  803387:	19 fa                	sbb    %edi,%edx
  803389:	89 d1                	mov    %edx,%ecx
  80338b:	89 c6                	mov    %eax,%esi
  80338d:	e9 71 ff ff ff       	jmp    803303 <__umoddi3+0xb3>
  803392:	66 90                	xchg   %ax,%ax
  803394:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803398:	72 ea                	jb     803384 <__umoddi3+0x134>
  80339a:	89 d9                	mov    %ebx,%ecx
  80339c:	e9 62 ff ff ff       	jmp    803303 <__umoddi3+0xb3>
