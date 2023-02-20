
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e9 00 00 00       	call   80011f <libmain>
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
  80008c:	68 a0 32 80 00       	push   $0x8032a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 32 80 00       	push   $0x8032bc
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 1a 1b 00 00       	call   801bbc <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 da 32 80 00       	push   $0x8032da
  8000aa:	50                   	push   %eax
  8000ab:	e8 d3 15 00 00       	call   801683 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 08 18 00 00       	call   8018c3 <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 dc 32 80 00       	push   $0x8032dc
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 8a 16 00 00       	call   801763 <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 00 33 80 00       	push   $0x803300
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 d2 17 00 00       	call   8018c3 <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 18 33 80 00       	push   $0x803318
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 bc 32 80 00       	push   $0x8032bc
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 c5 1b 00 00       	call   801ce1 <inctst>

	return;
  80011c:	90                   	nop
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800125:	e8 79 1a 00 00       	call   801ba3 <sys_getenvindex>
  80012a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	89 d0                	mov    %edx,%eax
  800132:	c1 e0 03             	shl    $0x3,%eax
  800135:	01 d0                	add    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800142:	01 d0                	add    %edx,%eax
  800144:	c1 e0 04             	shl    $0x4,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800151:	a1 20 40 80 00       	mov    0x804020,%eax
  800156:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80015c:	84 c0                	test   %al,%al
  80015e:	74 0f                	je     80016f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800160:	a1 20 40 80 00       	mov    0x804020,%eax
  800165:	05 5c 05 00 00       	add    $0x55c,%eax
  80016a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800173:	7e 0a                	jle    80017f <libmain+0x60>
		binaryname = argv[0];
  800175:	8b 45 0c             	mov    0xc(%ebp),%eax
  800178:	8b 00                	mov    (%eax),%eax
  80017a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	e8 ab fe ff ff       	call   800038 <_main>
  80018d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800190:	e8 1b 18 00 00       	call   8019b0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 bc 33 80 00       	push   $0x8033bc
  80019d:	e8 6d 03 00 00       	call   80050f <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001aa:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	68 e4 33 80 00       	push   $0x8033e4
  8001c5:	e8 45 03 00 00       	call   80050f <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dd:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001ee:	51                   	push   %ecx
  8001ef:	52                   	push   %edx
  8001f0:	50                   	push   %eax
  8001f1:	68 0c 34 80 00       	push   $0x80340c
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 64 34 80 00       	push   $0x803464
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 bc 33 80 00       	push   $0x8033bc
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 9b 17 00 00       	call   8019ca <sys_enable_interrupt>

	// exit gracefully
	exit();
  80022f:	e8 19 00 00 00       	call   80024d <exit>
}
  800234:	90                   	nop
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 00                	push   $0x0
  800242:	e8 28 19 00 00       	call   801b6f <sys_destroy_env>
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <exit>:

void
exit(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800253:	e8 7d 19 00 00       	call   801bd5 <sys_exit_env>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800261:	8d 45 10             	lea    0x10(%ebp),%eax
  800264:	83 c0 04             	add    $0x4,%eax
  800267:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80026f:	85 c0                	test   %eax,%eax
  800271:	74 16                	je     800289 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800273:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	50                   	push   %eax
  80027c:	68 78 34 80 00       	push   $0x803478
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 7d 34 80 00       	push   $0x80347d
  80029a:	e8 70 02 00 00       	call   80050f <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 f3 01 00 00       	call   8004a4 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	68 99 34 80 00       	push   $0x803499
  8002be:	e8 e1 01 00 00       	call   8004a4 <vcprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c6:	e8 82 ff ff ff       	call   80024d <exit>

	// should not return here
	while (1) ;
  8002cb:	eb fe                	jmp    8002cb <_panic+0x70>

008002cd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 50 74             	mov    0x74(%eax),%edx
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	74 14                	je     8002f6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 9c 34 80 00       	push   $0x80349c
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 e8 34 80 00       	push   $0x8034e8
  8002f1:	e8 65 ff ff ff       	call   80025b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800304:	e9 c2 00 00 00       	jmp    8003cb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	01 d0                	add    %edx,%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	85 c0                	test   %eax,%eax
  80031c:	75 08                	jne    800326 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80031e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800321:	e9 a2 00 00 00       	jmp    8003c8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800326:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800334:	eb 69                	jmp    80039f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800336:	a1 20 40 80 00       	mov    0x804020,%eax
  80033b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800341:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800344:	89 d0                	mov    %edx,%eax
  800346:	01 c0                	add    %eax,%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	c1 e0 03             	shl    $0x3,%eax
  80034d:	01 c8                	add    %ecx,%eax
  80034f:	8a 40 04             	mov    0x4(%eax),%al
  800352:	84 c0                	test   %al,%al
  800354:	75 46                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800356:	a1 20 40 80 00       	mov    0x804020,%eax
  80035b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800361:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	01 c0                	add    %eax,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	c1 e0 03             	shl    $0x3,%eax
  80036d:	01 c8                	add    %ecx,%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	75 09                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800393:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039a:	eb 12                	jmp    8003ae <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	ff 45 e8             	incl   -0x18(%ebp)
  80039f:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a4:	8b 50 74             	mov    0x74(%eax),%edx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	77 88                	ja     800336 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b2:	75 14                	jne    8003c8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	68 f4 34 80 00       	push   $0x8034f4
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 e8 34 80 00       	push   $0x8034e8
  8003c3:	e8 93 fe ff ff       	call   80025b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c8:	ff 45 f0             	incl   -0x10(%ebp)
  8003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d1:	0f 8c 32 ff ff ff    	jl     800309 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e5:	eb 26                	jmp    80040d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	01 c0                	add    %eax,%eax
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	c1 e0 03             	shl    $0x3,%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8a 40 04             	mov    0x4(%eax),%al
  800403:	3c 01                	cmp    $0x1,%al
  800405:	75 03                	jne    80040a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800407:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040a:	ff 45 e0             	incl   -0x20(%ebp)
  80040d:	a1 20 40 80 00       	mov    0x804020,%eax
  800412:	8b 50 74             	mov    0x74(%eax),%edx
  800415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	77 cb                	ja     8003e7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 48 35 80 00       	push   $0x803548
  80042c:	6a 44                	push   $0x44
  80042e:	68 e8 34 80 00       	push   $0x8034e8
  800433:	e8 23 fe ff ff       	call   80025b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800438:	90                   	nop
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 48 01             	lea    0x1(%eax),%ecx
  800449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044c:	89 0a                	mov    %ecx,(%edx)
  80044e:	8b 55 08             	mov    0x8(%ebp),%edx
  800451:	88 d1                	mov    %dl,%cl
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800464:	75 2c                	jne    800492 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800466:	a0 24 40 80 00       	mov    0x804024,%al
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	8b 12                	mov    (%edx),%edx
  800473:	89 d1                	mov    %edx,%ecx
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	83 c2 08             	add    $0x8,%edx
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	50                   	push   %eax
  80047f:	51                   	push   %ecx
  800480:	52                   	push   %edx
  800481:	e8 7c 13 00 00       	call   801802 <sys_cputs>
  800486:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
  800495:	8b 40 04             	mov    0x4(%eax),%eax
  800498:	8d 50 01             	lea    0x1(%eax),%edx
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a1:	90                   	nop
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b4:	00 00 00 
	b.cnt = 0;
  8004b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004be:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	68 3b 04 80 00       	push   $0x80043b
  8004d3:	e8 11 02 00 00       	call   8006e9 <vprintfmt>
  8004d8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004db:	a0 24 40 80 00       	mov    0x804024,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	50                   	push   %eax
  8004ed:	52                   	push   %edx
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	83 c0 08             	add    $0x8,%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 05 13 00 00       	call   801802 <sys_cputs>
  8004fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800500:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int cprintf(const char *fmt, ...) {
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800515:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80051c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 f4             	pushl  -0xc(%ebp)
  80052b:	50                   	push   %eax
  80052c:	e8 73 ff ff ff       	call   8004a4 <vcprintf>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800542:	e8 69 14 00 00       	call   8019b0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 48 ff ff ff       	call   8004a4 <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800562:	e8 63 14 00 00       	call   8019ca <sys_enable_interrupt>
	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	53                   	push   %ebx
  800570:	83 ec 14             	sub    $0x14,%esp
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 18             	mov    0x18(%ebp),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058a:	77 55                	ja     8005e1 <printnum+0x75>
  80058c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058f:	72 05                	jb     800596 <printnum+0x2a>
  800591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800594:	77 4b                	ja     8005e1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800596:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800599:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80059c:	8b 45 18             	mov    0x18(%ebp),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	52                   	push   %edx
  8005a5:	50                   	push   %eax
  8005a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ac:	e8 7f 2a 00 00       	call   803030 <__udivdi3>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	ff 75 20             	pushl  0x20(%ebp)
  8005ba:	53                   	push   %ebx
  8005bb:	ff 75 18             	pushl  0x18(%ebp)
  8005be:	52                   	push   %edx
  8005bf:	50                   	push   %eax
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 a1 ff ff ff       	call   80056c <printnum>
  8005cb:	83 c4 20             	add    $0x20,%esp
  8005ce:	eb 1a                	jmp    8005ea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 20             	pushl  0x20(%ebp)
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	ff d0                	call   *%eax
  8005de:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e1:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e8:	7f e6                	jg     8005d0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f8:	53                   	push   %ebx
  8005f9:	51                   	push   %ecx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 3f 2b 00 00       	call   803140 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 b4 37 80 00       	add    $0x8037b4,%eax
  800609:	8a 00                	mov    (%eax),%al
  80060b:	0f be c0             	movsbl %al,%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
}
  80061d:	90                   	nop
  80061e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800626:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062a:	7e 1c                	jle    800648 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 08             	lea    0x8(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 08             	sub    $0x8,%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	eb 40                	jmp    800688 <getuint+0x65>
	else if (lflag)
  800648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064c:	74 1e                	je     80066c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	eb 1c                	jmp    800688 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800691:	7e 1c                	jle    8006af <getint+0x25>
		return va_arg(*ap, long long);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 08             	sub    $0x8,%eax
  8006a8:	8b 50 04             	mov    0x4(%eax),%edx
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	eb 38                	jmp    8006e7 <getint+0x5d>
	else if (lflag)
  8006af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b3:	74 1a                	je     8006cf <getint+0x45>
		return va_arg(*ap, long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	eb 18                	jmp    8006e7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	eb 17                	jmp    80070a <vprintfmt+0x21>
			if (ch == '\0')
  8006f3:	85 db                	test   %ebx,%ebx
  8006f5:	0f 84 af 03 00 00    	je     800aaa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	53                   	push   %ebx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	8d 50 01             	lea    0x1(%eax),%edx
  800710:	89 55 10             	mov    %edx,0x10(%ebp)
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f b6 d8             	movzbl %al,%ebx
  800718:	83 fb 25             	cmp    $0x25,%ebx
  80071b:	75 d6                	jne    8006f3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800721:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800736:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 10             	mov    0x10(%ebp),%eax
  800740:	8d 50 01             	lea    0x1(%eax),%edx
  800743:	89 55 10             	mov    %edx,0x10(%ebp)
  800746:	8a 00                	mov    (%eax),%al
  800748:	0f b6 d8             	movzbl %al,%ebx
  80074b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80074e:	83 f8 55             	cmp    $0x55,%eax
  800751:	0f 87 2b 03 00 00    	ja     800a82 <vprintfmt+0x399>
  800757:	8b 04 85 d8 37 80 00 	mov    0x8037d8(,%eax,4),%eax
  80075e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800760:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800764:	eb d7                	jmp    80073d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800766:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80076a:	eb d1                	jmp    80073d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800773:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800776:	89 d0                	mov    %edx,%eax
  800778:	c1 e0 02             	shl    $0x2,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	01 c0                	add    %eax,%eax
  80077f:	01 d8                	add    %ebx,%eax
  800781:	83 e8 30             	sub    $0x30,%eax
  800784:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800787:	8b 45 10             	mov    0x10(%ebp),%eax
  80078a:	8a 00                	mov    (%eax),%al
  80078c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078f:	83 fb 2f             	cmp    $0x2f,%ebx
  800792:	7e 3e                	jle    8007d2 <vprintfmt+0xe9>
  800794:	83 fb 39             	cmp    $0x39,%ebx
  800797:	7f 39                	jg     8007d2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800799:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80079c:	eb d5                	jmp    800773 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	83 c0 04             	add    $0x4,%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b2:	eb 1f                	jmp    8007d3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b8:	79 83                	jns    80073d <vprintfmt+0x54>
				width = 0;
  8007ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c1:	e9 77 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007cd:	e9 6b ff ff ff       	jmp    80073d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d7:	0f 89 60 ff ff ff    	jns    80073d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ea:	e9 4e ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f2:	e9 46 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
			break;
  800817:	e9 89 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80082d:	85 db                	test   %ebx,%ebx
  80082f:	79 02                	jns    800833 <vprintfmt+0x14a>
				err = -err;
  800831:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800833:	83 fb 64             	cmp    $0x64,%ebx
  800836:	7f 0b                	jg     800843 <vprintfmt+0x15a>
  800838:	8b 34 9d 20 36 80 00 	mov    0x803620(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 c5 37 80 00       	push   $0x8037c5
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 5e 02 00 00       	call   800ab2 <printfmt>
  800854:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800857:	e9 49 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80085c:	56                   	push   %esi
  80085d:	68 ce 37 80 00       	push   $0x8037ce
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 45 02 00 00       	call   800ab2 <printfmt>
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 30 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 30                	mov    (%eax),%esi
  800886:	85 f6                	test   %esi,%esi
  800888:	75 05                	jne    80088f <vprintfmt+0x1a6>
				p = "(null)";
  80088a:	be d1 37 80 00       	mov    $0x8037d1,%esi
			if (width > 0 && padc != '-')
  80088f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800893:	7e 6d                	jle    800902 <vprintfmt+0x219>
  800895:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800899:	74 67                	je     800902 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	50                   	push   %eax
  8008a2:	56                   	push   %esi
  8008a3:	e8 0c 03 00 00       	call   800bb4 <strnlen>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ae:	eb 16                	jmp    8008c6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ca:	7f e4                	jg     8008b0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cc:	eb 34                	jmp    800902 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d2:	74 1c                	je     8008f0 <vprintfmt+0x207>
  8008d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d7:	7e 05                	jle    8008de <vprintfmt+0x1f5>
  8008d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008dc:	7e 12                	jle    8008f0 <vprintfmt+0x207>
					putch('?', putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	6a 3f                	push   $0x3f
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	eb 0f                	jmp    8008ff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	53                   	push   %ebx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 70 01             	lea    0x1(%eax),%esi
  800907:	8a 00                	mov    (%eax),%al
  800909:	0f be d8             	movsbl %al,%ebx
  80090c:	85 db                	test   %ebx,%ebx
  80090e:	74 24                	je     800934 <vprintfmt+0x24b>
  800910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800914:	78 b8                	js     8008ce <vprintfmt+0x1e5>
  800916:	ff 4d e0             	decl   -0x20(%ebp)
  800919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091d:	79 af                	jns    8008ce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091f:	eb 13                	jmp    800934 <vprintfmt+0x24b>
				putch(' ', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	6a 20                	push   $0x20
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	ff 4d e4             	decl   -0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e7                	jg     800921 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80093a:	e9 66 01 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 e8             	pushl  -0x18(%ebp)
  800945:	8d 45 14             	lea    0x14(%ebp),%eax
  800948:	50                   	push   %eax
  800949:	e8 3c fd ff ff       	call   80068a <getint>
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	79 23                	jns    800984 <vprintfmt+0x29b>
				putch('-', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	6a 2d                	push   $0x2d
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800977:	f7 d8                	neg    %eax
  800979:	83 d2 00             	adc    $0x0,%edx
  80097c:	f7 da                	neg    %edx
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800984:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098b:	e9 bc 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 e8             	pushl  -0x18(%ebp)
  800996:	8d 45 14             	lea    0x14(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	e8 84 fc ff ff       	call   800623 <getuint>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 98 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	6a 58                	push   $0x58
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 58                	push   $0x58
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 58                	push   $0x58
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 30                	push   $0x30
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 78                	push   $0x78
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 e8             	pushl  -0x18(%ebp)
  800a33:	8d 45 14             	lea    0x14(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	e8 e7 fb ff ff       	call   800623 <getuint>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	52                   	push   %edx
  800a57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 00 fb ff ff       	call   80056c <printnum>
  800a6c:	83 c4 20             	add    $0x20,%esp
			break;
  800a6f:	eb 34                	jmp    800aa5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
			break;
  800a80:	eb 23                	jmp    800aa5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 25                	push   $0x25
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a92:	ff 4d 10             	decl   0x10(%ebp)
  800a95:	eb 03                	jmp    800a9a <vprintfmt+0x3b1>
  800a97:	ff 4d 10             	decl   0x10(%ebp)
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	48                   	dec    %eax
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	3c 25                	cmp    $0x25,%al
  800aa2:	75 f3                	jne    800a97 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aa4:	90                   	nop
		}
	}
  800aa5:	e9 47 fc ff ff       	jmp    8006f1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aaa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab8:	8d 45 10             	lea    0x10(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 16 fc ff ff       	call   8006e9 <vprintfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad6:	90                   	nop
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 08             	mov    0x8(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 10                	mov    (%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8b 40 04             	mov    0x4(%eax),%eax
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	73 12                	jae    800b0c <sprintputch+0x33>
		*b->buf++ = ch;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	8d 48 01             	lea    0x1(%eax),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 0a                	mov    %ecx,(%edx)
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	88 10                	mov    %dl,(%eax)
}
  800b0c:	90                   	nop
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b34:	74 06                	je     800b3c <vsnprintf+0x2d>
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	7f 07                	jg     800b43 <vsnprintf+0x34>
		return -E_INVAL;
  800b3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b41:	eb 20                	jmp    800b63 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b43:	ff 75 14             	pushl  0x14(%ebp)
  800b46:	ff 75 10             	pushl  0x10(%ebp)
  800b49:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	68 d9 0a 80 00       	push   $0x800ad9
  800b52:	e8 92 fb ff ff       	call   8006e9 <vprintfmt>
  800b57:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b6e:	83 c0 04             	add    $0x4,%eax
  800b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 89 ff ff ff       	call   800b0f <vsnprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9e:	eb 06                	jmp    800ba6 <strlen+0x15>
		n++;
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 f1                	jne    800ba0 <strlen+0xf>
		n++;
	return n;
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc1:	eb 09                	jmp    800bcc <strnlen+0x18>
		n++;
  800bc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc6:	ff 45 08             	incl   0x8(%ebp)
  800bc9:	ff 4d 0c             	decl   0xc(%ebp)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 09                	je     800bdb <strnlen+0x27>
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	75 e8                	jne    800bc3 <strnlen+0xf>
		n++;
	return n;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bec:	90                   	nop
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bff:	8a 12                	mov    (%edx),%dl
  800c01:	88 10                	mov    %dl,(%eax)
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 e4                	jne    800bed <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c21:	eb 1f                	jmp    800c42 <strncpy+0x34>
		*dst++ = *src;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8a 12                	mov    (%edx),%dl
  800c31:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	74 03                	je     800c3f <strncpy+0x31>
			src++;
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3f:	ff 45 fc             	incl   -0x4(%ebp)
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c48:	72 d9                	jb     800c23 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5f:	74 30                	je     800c91 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c61:	eb 16                	jmp    800c79 <strlcpy+0x2a>
			*dst++ = *src++;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c80:	74 09                	je     800c8b <strlcpy+0x3c>
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 d8                	jne    800c63 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c97:	29 c2                	sub    %eax,%edx
  800c99:	89 d0                	mov    %edx,%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca0:	eb 06                	jmp    800ca8 <strcmp+0xb>
		p++, q++;
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	74 0e                	je     800cbf <strcmp+0x22>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 10                	mov    (%eax),%dl
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	38 c2                	cmp    %al,%dl
  800cbd:	74 e3                	je     800ca2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f b6 d0             	movzbl %al,%edx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	29 c2                	sub    %eax,%edx
  800cd1:	89 d0                	mov    %edx,%eax
}
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd8:	eb 09                	jmp    800ce3 <strncmp+0xe>
		n--, p++, q++;
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	74 17                	je     800d00 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 0e                	je     800d00 <strncmp+0x2b>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 10                	mov    (%eax),%dl
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	38 c2                	cmp    %al,%dl
  800cfe:	74 da                	je     800cda <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strncmp+0x38>
		return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 14                	jmp    800d21 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 d0             	movzbl %al,%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 c0             	movzbl %al,%eax
  800d1d:	29 c2                	sub    %eax,%edx
  800d1f:	89 d0                	mov    %edx,%eax
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2f:	eb 12                	jmp    800d43 <strchr+0x20>
		if (*s == c)
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d39:	75 05                	jne    800d40 <strchr+0x1d>
			return (char *) s;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	eb 11                	jmp    800d51 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	75 e5                	jne    800d31 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5f:	eb 0d                	jmp    800d6e <strfind+0x1b>
		if (*s == c)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d69:	74 0e                	je     800d79 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	75 ea                	jne    800d61 <strfind+0xe>
  800d77:	eb 01                	jmp    800d7a <strfind+0x27>
		if (*s == c)
			break;
  800d79:	90                   	nop
	return (char *) s;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d91:	eb 0e                	jmp    800da1 <memset+0x22>
		*p++ = c;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da1:	ff 4d f8             	decl   -0x8(%ebp)
  800da4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da8:	79 e9                	jns    800d93 <memset+0x14>
		*p++ = c;

	return v;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc1:	eb 16                	jmp    800dd9 <memcpy+0x2a>
		*d++ = *s++;
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 dd                	jne    800dc3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e03:	73 50                	jae    800e55 <memmove+0x6a>
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	76 43                	jbe    800e55 <memmove+0x6a>
		s += n;
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1e:	eb 10                	jmp    800e30 <memmove+0x45>
			*--d = *--s;
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	ff 4d fc             	decl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 e3                	jne    800e20 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3d:	eb 23                	jmp    800e62 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 dd                	jne    800e3f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e79:	eb 2a                	jmp    800ea5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 16                	je     800e9f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	eb 18                	jmp    800eb7 <memcmp+0x50>
		s1++, s2++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 c9                	jne    800e7b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eca:	eb 15                	jmp    800ee1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	39 c2                	cmp    %eax,%edx
  800edc:	74 0d                	je     800eeb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee7:	72 e3                	jb     800ecc <memfind+0x13>
  800ee9:	eb 01                	jmp    800eec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eeb:	90                   	nop
	return (void *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	eb 03                	jmp    800f0a <strtol+0x19>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 20                	cmp    $0x20,%al
  800f11:	74 f4                	je     800f07 <strtol+0x16>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 09                	cmp    $0x9,%al
  800f1a:	74 eb                	je     800f07 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 2b                	cmp    $0x2b,%al
  800f23:	75 05                	jne    800f2a <strtol+0x39>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	eb 13                	jmp    800f3d <strtol+0x4c>
	else if (*s == '-')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	75 0a                	jne    800f3d <strtol+0x4c>
		s++, neg = 1;
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	74 06                	je     800f49 <strtol+0x58>
  800f43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f47:	75 20                	jne    800f69 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 17                	jne    800f69 <strtol+0x78>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	40                   	inc    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 78                	cmp    $0x78,%al
  800f5a:	75 0d                	jne    800f69 <strtol+0x78>
		s += 2, base = 16;
  800f5c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f60:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f67:	eb 28                	jmp    800f91 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 15                	jne    800f84 <strtol+0x93>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 0c                	jne    800f84 <strtol+0x93>
		s++, base = 8;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f82:	eb 0d                	jmp    800f91 <strtol+0xa0>
	else if (base == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strtol+0xa0>
		base = 10;
  800f8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2f                	cmp    $0x2f,%al
  800f98:	7e 19                	jle    800fb3 <strtol+0xc2>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 39                	cmp    $0x39,%al
  800fa1:	7f 10                	jg     800fb3 <strtol+0xc2>
			dig = *s - '0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f be c0             	movsbl %al,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb1:	eb 42                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 60                	cmp    $0x60,%al
  800fba:	7e 19                	jle    800fd5 <strtol+0xe4>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 7a                	cmp    $0x7a,%al
  800fc3:	7f 10                	jg     800fd5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	83 e8 57             	sub    $0x57,%eax
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	eb 20                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 40                	cmp    $0x40,%al
  800fdc:	7e 39                	jle    801017 <strtol+0x126>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 5a                	cmp    $0x5a,%al
  800fe5:	7f 30                	jg     801017 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f be c0             	movsbl %al,%eax
  800fef:	83 e8 37             	sub    $0x37,%eax
  800ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffb:	7d 19                	jge    801016 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	89 c2                	mov    %eax,%edx
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801011:	e9 7b ff ff ff       	jmp    800f91 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801016:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 08                	je     801025 <strtol+0x134>
		*endptr = (char *) s;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 07                	je     801032 <strtol+0x141>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	f7 d8                	neg    %eax
  801030:	eb 03                	jmp    801035 <strtol+0x144>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <ltostr>:

void
ltostr(long value, char *str)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104f:	79 13                	jns    801064 <ltostr+0x2d>
	{
		neg = 1;
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801061:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106c:	99                   	cltd   
  80106d:	f7 f9                	idiv   %ecx
  80106f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8d 50 01             	lea    0x1(%eax),%edx
  801078:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801085:	83 c2 30             	add    $0x30,%edx
  801088:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801092:	f7 e9                	imul   %ecx
  801094:	c1 fa 02             	sar    $0x2,%edx
  801097:	89 c8                	mov    %ecx,%eax
  801099:	c1 f8 1f             	sar    $0x1f,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ab:	f7 e9                	imul   %ecx
  8010ad:	c1 fa 02             	sar    $0x2,%edx
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 f8 1f             	sar    $0x1f,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
  8010b9:	c1 e0 02             	shl    $0x2,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	01 c0                	add    %eax,%eax
  8010c0:	29 c1                	sub    %eax,%ecx
  8010c2:	89 ca                	mov    %ecx,%edx
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	75 9c                	jne    801064 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	48                   	dec    %eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010da:	74 3d                	je     801119 <ltostr+0xe2>
		start = 1 ;
  8010dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e3:	eb 34                	jmp    801119 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801111:	88 02                	mov    %al,(%edx)
		start++ ;
  801113:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801116:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c c4                	jl     8010e5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801121:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 54 fa ff ff       	call   800b91 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 46 fa ff ff       	call   800b91 <strlen>
  80114b:	83 c4 04             	add    $0x4,%esp
  80114e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 17                	jmp    801178 <strcconcat+0x49>
		final[s] = str1[s] ;
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c8                	add    %ecx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117e:	7c e1                	jl     801161 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118e:	eb 1f                	jmp    8011af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 c2                	add    %eax,%edx
  8011a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ac:	ff 45 f8             	incl   -0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b5:	7c d9                	jl     801190 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c2:	90                   	nop
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	eb 0c                	jmp    8011f6 <strsplit+0x31>
			*string++ = 0;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 18                	je     801217 <strsplit+0x52>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f be c0             	movsbl %al,%eax
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 13 fb ff ff       	call   800d23 <strchr>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 d3                	jne    8011ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	74 5a                	je     80127a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	83 f8 0f             	cmp    $0xf,%eax
  801228:	75 07                	jne    801231 <strsplit+0x6c>
		{
			return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	eb 66                	jmp    801297 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 14             	mov    0x14(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	eb 03                	jmp    801254 <strsplit+0x8f>
			string++;
  801251:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	74 8b                	je     8011e8 <strsplit+0x23>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	50                   	push   %eax
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 b5 fa ff ff       	call   800d23 <strchr>
  80126e:	83 c4 08             	add    $0x8,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	74 dc                	je     801251 <strsplit+0x8c>
			string++;
	}
  801275:	e9 6e ff ff ff       	jmp    8011e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80129f:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 1f                	je     8012c7 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012a8:	e8 1d 00 00 00       	call   8012ca <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	68 30 39 80 00       	push   $0x803930
  8012b5:	e8 55 f2 ff ff       	call   80050f <cprintf>
  8012ba:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012bd:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012c4:	00 00 00 
	}
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8012d0:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012d7:	00 00 00 
  8012da:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012e1:	00 00 00 
  8012e4:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8012eb:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8012ee:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012f5:	00 00 00 
  8012f8:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012ff:	00 00 00 
  801302:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801309:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80130c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801313:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801316:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80131d:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801327:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801331:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801336:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80133d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801340:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801345:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134a:	83 ec 04             	sub    $0x4,%esp
  80134d:	6a 06                	push   $0x6
  80134f:	ff 75 f4             	pushl  -0xc(%ebp)
  801352:	50                   	push   %eax
  801353:	e8 ee 05 00 00       	call   801946 <sys_allocate_chunk>
  801358:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80135b:	a1 20 41 80 00       	mov    0x804120,%eax
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	50                   	push   %eax
  801364:	e8 63 0c 00 00       	call   801fcc <initialize_MemBlocksList>
  801369:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80136c:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801371:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801374:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801377:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80137e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801381:	8b 40 0c             	mov    0xc(%eax),%eax
  801384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80138a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138f:	89 c2                	mov    %eax,%edx
  801391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801394:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8013a1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ab:	8b 50 08             	mov    0x8(%eax),%edx
  8013ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b1:	01 d0                	add    %edx,%eax
  8013b3:	48                   	dec    %eax
  8013b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bf:	f7 75 e0             	divl   -0x20(%ebp)
  8013c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c5:	29 d0                	sub    %edx,%eax
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013cc:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8013cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8013d3:	75 14                	jne    8013e9 <initialize_dyn_block_system+0x11f>
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	68 55 39 80 00       	push   $0x803955
  8013dd:	6a 34                	push   $0x34
  8013df:	68 73 39 80 00       	push   $0x803973
  8013e4:	e8 72 ee ff ff       	call   80025b <_panic>
  8013e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	74 10                	je     801402 <initialize_dyn_block_system+0x138>
  8013f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f5:	8b 00                	mov    (%eax),%eax
  8013f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013fa:	8b 52 04             	mov    0x4(%edx),%edx
  8013fd:	89 50 04             	mov    %edx,0x4(%eax)
  801400:	eb 0b                	jmp    80140d <initialize_dyn_block_system+0x143>
  801402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801405:	8b 40 04             	mov    0x4(%eax),%eax
  801408:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80140d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801410:	8b 40 04             	mov    0x4(%eax),%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	74 0f                	je     801426 <initialize_dyn_block_system+0x15c>
  801417:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80141a:	8b 40 04             	mov    0x4(%eax),%eax
  80141d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801420:	8b 12                	mov    (%edx),%edx
  801422:	89 10                	mov    %edx,(%eax)
  801424:	eb 0a                	jmp    801430 <initialize_dyn_block_system+0x166>
  801426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801429:	8b 00                	mov    (%eax),%eax
  80142b:	a3 48 41 80 00       	mov    %eax,0x804148
  801430:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801439:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801443:	a1 54 41 80 00       	mov    0x804154,%eax
  801448:	48                   	dec    %eax
  801449:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	ff 75 e8             	pushl  -0x18(%ebp)
  801454:	e8 c4 13 00 00       	call   80281d <insert_sorted_with_merge_freeList>
  801459:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80145c:	90                   	nop
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <malloc>:
//=================================



void* malloc(uint32 size)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801465:	e8 2f fe ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  80146a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146e:	75 07                	jne    801477 <malloc+0x18>
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	eb 71                	jmp    8014e8 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801477:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80147e:	76 07                	jbe    801487 <malloc+0x28>
	return NULL;
  801480:	b8 00 00 00 00       	mov    $0x0,%eax
  801485:	eb 61                	jmp    8014e8 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801487:	e8 88 08 00 00       	call   801d14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80148c:	85 c0                	test   %eax,%eax
  80148e:	74 53                	je     8014e3 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801490:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801497:	8b 55 08             	mov    0x8(%ebp),%edx
  80149a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149d:	01 d0                	add    %edx,%eax
  80149f:	48                   	dec    %eax
  8014a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ab:	f7 75 f4             	divl   -0xc(%ebp)
  8014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b1:	29 d0                	sub    %edx,%eax
  8014b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8014b6:	83 ec 0c             	sub    $0xc,%esp
  8014b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bc:	e8 d2 0d 00 00       	call   802293 <alloc_block_FF>
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8014c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014cb:	74 16                	je     8014e3 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8014cd:	83 ec 0c             	sub    $0xc,%esp
  8014d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8014d3:	e8 0c 0c 00 00       	call   8020e4 <insert_sorted_allocList>
  8014d8:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8014db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014de:	8b 40 08             	mov    0x8(%eax),%eax
  8014e1:	eb 05                	jmp    8014e8 <malloc+0x89>
    }

			}


	return NULL;
  8014e3:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801501:	83 ec 08             	sub    $0x8,%esp
  801504:	ff 75 f0             	pushl  -0x10(%ebp)
  801507:	68 40 40 80 00       	push   $0x804040
  80150c:	e8 a0 0b 00 00       	call   8020b1 <find_block>
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151a:	8b 50 0c             	mov    0xc(%eax),%edx
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	83 ec 08             	sub    $0x8,%esp
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	e8 e4 03 00 00       	call   80190e <sys_free_user_mem>
  80152a:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80152d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801531:	75 17                	jne    80154a <free+0x60>
  801533:	83 ec 04             	sub    $0x4,%esp
  801536:	68 55 39 80 00       	push   $0x803955
  80153b:	68 84 00 00 00       	push   $0x84
  801540:	68 73 39 80 00       	push   $0x803973
  801545:	e8 11 ed ff ff       	call   80025b <_panic>
  80154a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154d:	8b 00                	mov    (%eax),%eax
  80154f:	85 c0                	test   %eax,%eax
  801551:	74 10                	je     801563 <free+0x79>
  801553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801556:	8b 00                	mov    (%eax),%eax
  801558:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80155b:	8b 52 04             	mov    0x4(%edx),%edx
  80155e:	89 50 04             	mov    %edx,0x4(%eax)
  801561:	eb 0b                	jmp    80156e <free+0x84>
  801563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801566:	8b 40 04             	mov    0x4(%eax),%eax
  801569:	a3 44 40 80 00       	mov    %eax,0x804044
  80156e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801571:	8b 40 04             	mov    0x4(%eax),%eax
  801574:	85 c0                	test   %eax,%eax
  801576:	74 0f                	je     801587 <free+0x9d>
  801578:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157b:	8b 40 04             	mov    0x4(%eax),%eax
  80157e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801581:	8b 12                	mov    (%edx),%edx
  801583:	89 10                	mov    %edx,(%eax)
  801585:	eb 0a                	jmp    801591 <free+0xa7>
  801587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	a3 40 40 80 00       	mov    %eax,0x804040
  801591:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80159a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015a4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015a9:	48                   	dec    %eax
  8015aa:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8015b5:	e8 63 12 00 00       	call   80281d <insert_sorted_with_merge_freeList>
  8015ba:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8015bd:	90                   	nop
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 38             	sub    $0x38,%esp
  8015c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015cc:	e8 c8 fc ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d5:	75 0a                	jne    8015e1 <smalloc+0x21>
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dc:	e9 a0 00 00 00       	jmp    801681 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8015e1:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8015e8:	76 0a                	jbe    8015f4 <smalloc+0x34>
		return NULL;
  8015ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ef:	e9 8d 00 00 00       	jmp    801681 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f4:	e8 1b 07 00 00       	call   801d14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	74 7f                	je     80167c <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8015fd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801604:	8b 55 0c             	mov    0xc(%ebp),%edx
  801607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160a:	01 d0                	add    %edx,%eax
  80160c:	48                   	dec    %eax
  80160d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801613:	ba 00 00 00 00       	mov    $0x0,%edx
  801618:	f7 75 f4             	divl   -0xc(%ebp)
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	29 d0                	sub    %edx,%eax
  801620:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	ff 75 ec             	pushl  -0x14(%ebp)
  801629:	e8 65 0c 00 00       	call   802293 <alloc_block_FF>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801634:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801638:	74 42                	je     80167c <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	ff 75 e8             	pushl  -0x18(%ebp)
  801640:	e8 9f 0a 00 00       	call   8020e4 <insert_sorted_allocList>
  801645:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80164b:	8b 40 08             	mov    0x8(%eax),%eax
  80164e:	89 c2                	mov    %eax,%edx
  801650:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801654:	52                   	push   %edx
  801655:	50                   	push   %eax
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 38 04 00 00       	call   801a99 <sys_createSharedObject>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801667:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80166b:	79 07                	jns    801674 <smalloc+0xb4>
	    		  return NULL;
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
  801672:	eb 0d                	jmp    801681 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	eb 05                	jmp    801681 <smalloc+0xc1>


				}


		return NULL;
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801689:	e8 0b fc ff ff       	call   801299 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80168e:	e8 81 06 00 00       	call   801d14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801693:	85 c0                	test   %eax,%eax
  801695:	0f 84 9f 00 00 00    	je     80173a <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	ff 75 08             	pushl  0x8(%ebp)
  8016a4:	e8 1a 04 00 00       	call   801ac3 <sys_getSizeOfSharedObject>
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8016af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016b3:	79 0a                	jns    8016bf <sget+0x3c>
		return NULL;
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ba:	e9 80 00 00 00       	jmp    80173f <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016bf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cc:	01 d0                	add    %edx,%eax
  8016ce:	48                   	dec    %eax
  8016cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016da:	f7 75 f0             	divl   -0x10(%ebp)
  8016dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e0:	29 d0                	sub    %edx,%eax
  8016e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8016e5:	83 ec 0c             	sub    $0xc,%esp
  8016e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8016eb:	e8 a3 0b 00 00       	call   802293 <alloc_block_FF>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  8016f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016fa:	74 3e                	je     80173a <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  8016fc:	83 ec 0c             	sub    $0xc,%esp
  8016ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  801702:	e8 dd 09 00 00       	call   8020e4 <insert_sorted_allocList>
  801707:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80170a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170d:	8b 40 08             	mov    0x8(%eax),%eax
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	50                   	push   %eax
  801714:	ff 75 0c             	pushl  0xc(%ebp)
  801717:	ff 75 08             	pushl  0x8(%ebp)
  80171a:	e8 c1 03 00 00       	call   801ae0 <sys_getSharedObject>
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801725:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801729:	79 07                	jns    801732 <sget+0xaf>
	    		  return NULL;
  80172b:	b8 00 00 00 00       	mov    $0x0,%eax
  801730:	eb 0d                	jmp    80173f <sget+0xbc>
	  	return(void*) returned_block->sva;
  801732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801735:	8b 40 08             	mov    0x8(%eax),%eax
  801738:	eb 05                	jmp    80173f <sget+0xbc>
	      }
	}
	   return NULL;
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801747:	e8 4d fb ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80174c:	83 ec 04             	sub    $0x4,%esp
  80174f:	68 80 39 80 00       	push   $0x803980
  801754:	68 12 01 00 00       	push   $0x112
  801759:	68 73 39 80 00       	push   $0x803973
  80175e:	e8 f8 ea ff ff       	call   80025b <_panic>

00801763 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	68 a8 39 80 00       	push   $0x8039a8
  801771:	68 26 01 00 00       	push   $0x126
  801776:	68 73 39 80 00       	push   $0x803973
  80177b:	e8 db ea ff ff       	call   80025b <_panic>

00801780 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	68 cc 39 80 00       	push   $0x8039cc
  80178e:	68 31 01 00 00       	push   $0x131
  801793:	68 73 39 80 00       	push   $0x803973
  801798:	e8 be ea ff ff       	call   80025b <_panic>

0080179d <shrink>:

}
void shrink(uint32 newSize)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 cc 39 80 00       	push   $0x8039cc
  8017ab:	68 36 01 00 00       	push   $0x136
  8017b0:	68 73 39 80 00       	push   $0x803973
  8017b5:	e8 a1 ea ff ff       	call   80025b <_panic>

008017ba <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 cc 39 80 00       	push   $0x8039cc
  8017c8:	68 3b 01 00 00       	push   $0x13b
  8017cd:	68 73 39 80 00       	push   $0x803973
  8017d2:	e8 84 ea ff ff       	call   80025b <_panic>

008017d7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	57                   	push   %edi
  8017db:	56                   	push   %esi
  8017dc:	53                   	push   %ebx
  8017dd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ec:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ef:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f2:	cd 30                	int    $0x30
  8017f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5e                   	pop    %esi
  8017ff:	5f                   	pop    %edi
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    

00801802 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	8b 45 10             	mov    0x10(%ebp),%eax
  80180b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80180e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	52                   	push   %edx
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	50                   	push   %eax
  80181e:	6a 00                	push   $0x0
  801820:	e8 b2 ff ff ff       	call   8017d7 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_cgetc>:

int
sys_cgetc(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 01                	push   $0x1
  80183a:	e8 98 ff ff ff       	call   8017d7 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	6a 05                	push   $0x5
  801857:	e8 7b ff ff ff       	call   8017d7 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801866:	8b 75 18             	mov    0x18(%ebp),%esi
  801869:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	56                   	push   %esi
  801876:	53                   	push   %ebx
  801877:	51                   	push   %ecx
  801878:	52                   	push   %edx
  801879:	50                   	push   %eax
  80187a:	6a 06                	push   $0x6
  80187c:	e8 56 ff ff ff       	call   8017d7 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    

0080188b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 07                	push   $0x7
  80189e:	e8 34 ff ff ff       	call   8017d7 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	6a 08                	push   $0x8
  8018b9:	e8 19 ff ff ff       	call   8017d7 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 09                	push   $0x9
  8018d2:	e8 00 ff ff ff       	call   8017d7 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 0a                	push   $0xa
  8018eb:	e8 e7 fe ff ff       	call   8017d7 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 0b                	push   $0xb
  801904:	e8 ce fe ff ff       	call   8017d7 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	ff 75 08             	pushl  0x8(%ebp)
  80191d:	6a 0f                	push   $0xf
  80191f:	e8 b3 fe ff ff       	call   8017d7 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
	return;
  801927:	90                   	nop
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 10                	push   $0x10
  80193b:	e8 97 fe ff ff       	call   8017d7 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return ;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 10             	pushl  0x10(%ebp)
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 11                	push   $0x11
  801958:	e8 7a fe ff ff       	call   8017d7 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
	return ;
  801960:	90                   	nop
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 0c                	push   $0xc
  801972:	e8 60 fe ff ff       	call   8017d7 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	6a 0d                	push   $0xd
  80198c:	e8 46 fe ff ff       	call   8017d7 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 0e                	push   $0xe
  8019a5:	e8 2d fe ff ff       	call   8017d7 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 13                	push   $0x13
  8019bf:	e8 13 fe ff ff       	call   8017d7 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 14                	push   $0x14
  8019d9:	e8 f9 fd ff ff       	call   8017d7 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	50                   	push   %eax
  8019fd:	6a 15                	push   $0x15
  8019ff:	e8 d3 fd ff ff       	call   8017d7 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 16                	push   $0x16
  801a19:	e8 b9 fd ff ff       	call   8017d7 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	90                   	nop
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	50                   	push   %eax
  801a34:	6a 17                	push   $0x17
  801a36:	e8 9c fd ff ff       	call   8017d7 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	6a 1a                	push   $0x1a
  801a53:	e8 7f fd ff ff       	call   8017d7 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	52                   	push   %edx
  801a6d:	50                   	push   %eax
  801a6e:	6a 18                	push   $0x18
  801a70:	e8 62 fd ff ff       	call   8017d7 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	52                   	push   %edx
  801a8b:	50                   	push   %eax
  801a8c:	6a 19                	push   $0x19
  801a8e:	e8 44 fd ff ff       	call   8017d7 <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	90                   	nop
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	51                   	push   %ecx
  801ab2:	52                   	push   %edx
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	50                   	push   %eax
  801ab7:	6a 1b                	push   $0x1b
  801ab9:	e8 19 fd ff ff       	call   8017d7 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 1c                	push   $0x1c
  801ad6:	e8 fc fc ff ff       	call   8017d7 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	51                   	push   %ecx
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 1d                	push   $0x1d
  801af5:	e8 dd fc ff ff       	call   8017d7 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	6a 1e                	push   $0x1e
  801b12:	e8 c0 fc ff ff       	call   8017d7 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 1f                	push   $0x1f
  801b2b:	e8 a7 fc ff ff       	call   8017d7 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 14             	pushl  0x14(%ebp)
  801b40:	ff 75 10             	pushl  0x10(%ebp)
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	50                   	push   %eax
  801b47:	6a 20                	push   $0x20
  801b49:	e8 89 fc ff ff       	call   8017d7 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	50                   	push   %eax
  801b62:	6a 21                	push   $0x21
  801b64:	e8 6e fc ff ff       	call   8017d7 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	50                   	push   %eax
  801b7e:	6a 22                	push   $0x22
  801b80:	e8 52 fc ff ff       	call   8017d7 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 02                	push   $0x2
  801b99:	e8 39 fc ff ff       	call   8017d7 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 03                	push   $0x3
  801bb2:	e8 20 fc ff ff       	call   8017d7 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 04                	push   $0x4
  801bcb:	e8 07 fc ff ff       	call   8017d7 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 23                	push   $0x23
  801be4:	e8 ee fb ff ff       	call   8017d7 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	90                   	nop
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf8:	8d 50 04             	lea    0x4(%eax),%edx
  801bfb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	6a 24                	push   $0x24
  801c08:	e8 ca fb ff ff       	call   8017d7 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c19:	89 01                	mov    %eax,(%ecx)
  801c1b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	c9                   	leave  
  801c22:	c2 04 00             	ret    $0x4

00801c25 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	ff 75 10             	pushl  0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	6a 12                	push   $0x12
  801c37:	e8 9b fb ff ff       	call   8017d7 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3f:	90                   	nop
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 25                	push   $0x25
  801c51:	e8 81 fb ff ff       	call   8017d7 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c67:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	50                   	push   %eax
  801c74:	6a 26                	push   $0x26
  801c76:	e8 5c fb ff ff       	call   8017d7 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7e:	90                   	nop
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <rsttst>:
void rsttst()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 28                	push   $0x28
  801c90:	e8 42 fb ff ff       	call   8017d7 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
	return ;
  801c98:	90                   	nop
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca7:	8b 55 18             	mov    0x18(%ebp),%edx
  801caa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cae:	52                   	push   %edx
  801caf:	50                   	push   %eax
  801cb0:	ff 75 10             	pushl  0x10(%ebp)
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	ff 75 08             	pushl  0x8(%ebp)
  801cb9:	6a 27                	push   $0x27
  801cbb:	e8 17 fb ff ff       	call   8017d7 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc3:	90                   	nop
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <chktst>:
void chktst(uint32 n)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	6a 29                	push   $0x29
  801cd6:	e8 fc fa ff ff       	call   8017d7 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cde:	90                   	nop
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <inctst>:

void inctst()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 2a                	push   $0x2a
  801cf0:	e8 e2 fa ff ff       	call   8017d7 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <gettst>:
uint32 gettst()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 2b                	push   $0x2b
  801d0a:	e8 c8 fa ff ff       	call   8017d7 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 2c                	push   $0x2c
  801d26:	e8 ac fa ff ff       	call   8017d7 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
  801d2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d31:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d35:	75 07                	jne    801d3e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d37:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3c:	eb 05                	jmp    801d43 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 2c                	push   $0x2c
  801d57:	e8 7b fa ff ff       	call   8017d7 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
  801d5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d62:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d66:	75 07                	jne    801d6f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d68:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6d:	eb 05                	jmp    801d74 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801d88:	e8 4a fa ff ff       	call   8017d7 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
  801d90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d93:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d97:	75 07                	jne    801da0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d99:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9e:	eb 05                	jmp    801da5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801db9:	e8 19 fa ff ff       	call   8017d7 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
  801dc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc8:	75 07                	jne    801dd1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dca:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcf:	eb 05                	jmp    801dd6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	6a 2d                	push   $0x2d
  801de8:	e8 ea f9 ff ff       	call   8017d7 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
	return ;
  801df0:	90                   	nop
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	53                   	push   %ebx
  801e06:	51                   	push   %ecx
  801e07:	52                   	push   %edx
  801e08:	50                   	push   %eax
  801e09:	6a 2e                	push   $0x2e
  801e0b:	e8 c7 f9 ff ff       	call   8017d7 <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	52                   	push   %edx
  801e28:	50                   	push   %eax
  801e29:	6a 2f                	push   $0x2f
  801e2b:	e8 a7 f9 ff ff       	call   8017d7 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	68 dc 39 80 00       	push   $0x8039dc
  801e43:	e8 c7 e6 ff ff       	call   80050f <cprintf>
  801e48:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e52:	83 ec 0c             	sub    $0xc,%esp
  801e55:	68 08 3a 80 00       	push   $0x803a08
  801e5a:	e8 b0 e6 ff ff       	call   80050f <cprintf>
  801e5f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e62:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e66:	a1 38 41 80 00       	mov    0x804138,%eax
  801e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6e:	eb 56                	jmp    801ec6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e74:	74 1c                	je     801e92 <print_mem_block_lists+0x5d>
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	8b 50 08             	mov    0x8(%eax),%edx
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	8b 48 08             	mov    0x8(%eax),%ecx
  801e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e85:	8b 40 0c             	mov    0xc(%eax),%eax
  801e88:	01 c8                	add    %ecx,%eax
  801e8a:	39 c2                	cmp    %eax,%edx
  801e8c:	73 04                	jae    801e92 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e8e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 50 08             	mov    0x8(%eax),%edx
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9e:	01 c2                	add    %eax,%edx
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	8b 40 08             	mov    0x8(%eax),%eax
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	52                   	push   %edx
  801eaa:	50                   	push   %eax
  801eab:	68 1d 3a 80 00       	push   $0x803a1d
  801eb0:	e8 5a e6 ff ff       	call   80050f <cprintf>
  801eb5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ebe:	a1 40 41 80 00       	mov    0x804140,%eax
  801ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eca:	74 07                	je     801ed3 <print_mem_block_lists+0x9e>
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	8b 00                	mov    (%eax),%eax
  801ed1:	eb 05                	jmp    801ed8 <print_mem_block_lists+0xa3>
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	a3 40 41 80 00       	mov    %eax,0x804140
  801edd:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	75 8a                	jne    801e70 <print_mem_block_lists+0x3b>
  801ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eea:	75 84                	jne    801e70 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eec:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef0:	75 10                	jne    801f02 <print_mem_block_lists+0xcd>
  801ef2:	83 ec 0c             	sub    $0xc,%esp
  801ef5:	68 2c 3a 80 00       	push   $0x803a2c
  801efa:	e8 10 e6 ff ff       	call   80050f <cprintf>
  801eff:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	68 50 3a 80 00       	push   $0x803a50
  801f11:	e8 f9 e5 ff ff       	call   80050f <cprintf>
  801f16:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f19:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f1d:	a1 40 40 80 00       	mov    0x804040,%eax
  801f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f25:	eb 56                	jmp    801f7d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2b:	74 1c                	je     801f49 <print_mem_block_lists+0x114>
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	8b 50 08             	mov    0x8(%eax),%edx
  801f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f36:	8b 48 08             	mov    0x8(%eax),%ecx
  801f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3f:	01 c8                	add    %ecx,%eax
  801f41:	39 c2                	cmp    %eax,%edx
  801f43:	73 04                	jae    801f49 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f45:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4c:	8b 50 08             	mov    0x8(%eax),%edx
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 40 0c             	mov    0xc(%eax),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 40 08             	mov    0x8(%eax),%eax
  801f5d:	83 ec 04             	sub    $0x4,%esp
  801f60:	52                   	push   %edx
  801f61:	50                   	push   %eax
  801f62:	68 1d 3a 80 00       	push   $0x803a1d
  801f67:	e8 a3 e5 ff ff       	call   80050f <cprintf>
  801f6c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f75:	a1 48 40 80 00       	mov    0x804048,%eax
  801f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f81:	74 07                	je     801f8a <print_mem_block_lists+0x155>
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	8b 00                	mov    (%eax),%eax
  801f88:	eb 05                	jmp    801f8f <print_mem_block_lists+0x15a>
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8f:	a3 48 40 80 00       	mov    %eax,0x804048
  801f94:	a1 48 40 80 00       	mov    0x804048,%eax
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	75 8a                	jne    801f27 <print_mem_block_lists+0xf2>
  801f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa1:	75 84                	jne    801f27 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa7:	75 10                	jne    801fb9 <print_mem_block_lists+0x184>
  801fa9:	83 ec 0c             	sub    $0xc,%esp
  801fac:	68 68 3a 80 00       	push   $0x803a68
  801fb1:	e8 59 e5 ff ff       	call   80050f <cprintf>
  801fb6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	68 dc 39 80 00       	push   $0x8039dc
  801fc1:	e8 49 e5 ff ff       	call   80050f <cprintf>
  801fc6:	83 c4 10             	add    $0x10,%esp

}
  801fc9:	90                   	nop
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801fd2:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fd9:	00 00 00 
  801fdc:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fe3:	00 00 00 
  801fe6:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fed:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  801ff0:	a1 50 40 80 00       	mov    0x804050,%eax
  801ff5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  801ff8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fff:	e9 9e 00 00 00       	jmp    8020a2 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802004:	a1 50 40 80 00       	mov    0x804050,%eax
  802009:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200c:	c1 e2 04             	shl    $0x4,%edx
  80200f:	01 d0                	add    %edx,%eax
  802011:	85 c0                	test   %eax,%eax
  802013:	75 14                	jne    802029 <initialize_MemBlocksList+0x5d>
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	68 90 3a 80 00       	push   $0x803a90
  80201d:	6a 48                	push   $0x48
  80201f:	68 b3 3a 80 00       	push   $0x803ab3
  802024:	e8 32 e2 ff ff       	call   80025b <_panic>
  802029:	a1 50 40 80 00       	mov    0x804050,%eax
  80202e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802031:	c1 e2 04             	shl    $0x4,%edx
  802034:	01 d0                	add    %edx,%eax
  802036:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80203c:	89 10                	mov    %edx,(%eax)
  80203e:	8b 00                	mov    (%eax),%eax
  802040:	85 c0                	test   %eax,%eax
  802042:	74 18                	je     80205c <initialize_MemBlocksList+0x90>
  802044:	a1 48 41 80 00       	mov    0x804148,%eax
  802049:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80204f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802052:	c1 e1 04             	shl    $0x4,%ecx
  802055:	01 ca                	add    %ecx,%edx
  802057:	89 50 04             	mov    %edx,0x4(%eax)
  80205a:	eb 12                	jmp    80206e <initialize_MemBlocksList+0xa2>
  80205c:	a1 50 40 80 00       	mov    0x804050,%eax
  802061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802064:	c1 e2 04             	shl    $0x4,%edx
  802067:	01 d0                	add    %edx,%eax
  802069:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80206e:	a1 50 40 80 00       	mov    0x804050,%eax
  802073:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802076:	c1 e2 04             	shl    $0x4,%edx
  802079:	01 d0                	add    %edx,%eax
  80207b:	a3 48 41 80 00       	mov    %eax,0x804148
  802080:	a1 50 40 80 00       	mov    0x804050,%eax
  802085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802088:	c1 e2 04             	shl    $0x4,%edx
  80208b:	01 d0                	add    %edx,%eax
  80208d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802094:	a1 54 41 80 00       	mov    0x804154,%eax
  802099:	40                   	inc    %eax
  80209a:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80209f:	ff 45 f4             	incl   -0xc(%ebp)
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a8:	0f 82 56 ff ff ff    	jb     802004 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8020ae:	90                   	nop
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	8b 00                	mov    (%eax),%eax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8020bf:	eb 18                	jmp    8020d9 <find_block+0x28>
		{
			if(tmp->sva==va)
  8020c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c4:	8b 40 08             	mov    0x8(%eax),%eax
  8020c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020ca:	75 05                	jne    8020d1 <find_block+0x20>
			{
				return tmp;
  8020cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cf:	eb 11                	jmp    8020e2 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8020d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d4:	8b 00                	mov    (%eax),%eax
  8020d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8020d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020dd:	75 e2                	jne    8020c1 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8020df:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8020ea:	a1 40 40 80 00       	mov    0x804040,%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	0f 85 83 00 00 00    	jne    80217a <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8020f7:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8020fe:	00 00 00 
  802101:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  802108:	00 00 00 
  80210b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802112:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802119:	75 14                	jne    80212f <insert_sorted_allocList+0x4b>
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	68 90 3a 80 00       	push   $0x803a90
  802123:	6a 7f                	push   $0x7f
  802125:	68 b3 3a 80 00       	push   $0x803ab3
  80212a:	e8 2c e1 ff ff       	call   80025b <_panic>
  80212f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	89 10                	mov    %edx,(%eax)
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	85 c0                	test   %eax,%eax
  802141:	74 0d                	je     802150 <insert_sorted_allocList+0x6c>
  802143:	a1 40 40 80 00       	mov    0x804040,%eax
  802148:	8b 55 08             	mov    0x8(%ebp),%edx
  80214b:	89 50 04             	mov    %edx,0x4(%eax)
  80214e:	eb 08                	jmp    802158 <insert_sorted_allocList+0x74>
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	a3 44 40 80 00       	mov    %eax,0x804044
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	a3 40 40 80 00       	mov    %eax,0x804040
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80216f:	40                   	inc    %eax
  802170:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802175:	e9 16 01 00 00       	jmp    802290 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	8b 50 08             	mov    0x8(%eax),%edx
  802180:	a1 44 40 80 00       	mov    0x804044,%eax
  802185:	8b 40 08             	mov    0x8(%eax),%eax
  802188:	39 c2                	cmp    %eax,%edx
  80218a:	76 68                	jbe    8021f4 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80218c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802190:	75 17                	jne    8021a9 <insert_sorted_allocList+0xc5>
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	68 cc 3a 80 00       	push   $0x803acc
  80219a:	68 85 00 00 00       	push   $0x85
  80219f:	68 b3 3a 80 00       	push   $0x803ab3
  8021a4:	e8 b2 e0 ff ff       	call   80025b <_panic>
  8021a9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	89 50 04             	mov    %edx,0x4(%eax)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8b 40 04             	mov    0x4(%eax),%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	74 0c                	je     8021cb <insert_sorted_allocList+0xe7>
  8021bf:	a1 44 40 80 00       	mov    0x804044,%eax
  8021c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c7:	89 10                	mov    %edx,(%eax)
  8021c9:	eb 08                	jmp    8021d3 <insert_sorted_allocList+0xef>
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	a3 40 40 80 00       	mov    %eax,0x804040
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021e4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e9:	40                   	inc    %eax
  8021ea:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8021ef:	e9 9c 00 00 00       	jmp    802290 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8021f4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8021fc:	e9 85 00 00 00       	jmp    802286 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	8b 50 08             	mov    0x8(%eax),%edx
  802207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220a:	8b 40 08             	mov    0x8(%eax),%eax
  80220d:	39 c2                	cmp    %eax,%edx
  80220f:	73 6d                	jae    80227e <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802215:	74 06                	je     80221d <insert_sorted_allocList+0x139>
  802217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221b:	75 17                	jne    802234 <insert_sorted_allocList+0x150>
  80221d:	83 ec 04             	sub    $0x4,%esp
  802220:	68 f0 3a 80 00       	push   $0x803af0
  802225:	68 90 00 00 00       	push   $0x90
  80222a:	68 b3 3a 80 00       	push   $0x803ab3
  80222f:	e8 27 e0 ff ff       	call   80025b <_panic>
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 50 04             	mov    0x4(%eax),%edx
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	89 50 04             	mov    %edx,0x4(%eax)
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802246:	89 10                	mov    %edx,(%eax)
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	8b 40 04             	mov    0x4(%eax),%eax
  80224e:	85 c0                	test   %eax,%eax
  802250:	74 0d                	je     80225f <insert_sorted_allocList+0x17b>
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	8b 40 04             	mov    0x4(%eax),%eax
  802258:	8b 55 08             	mov    0x8(%ebp),%edx
  80225b:	89 10                	mov    %edx,(%eax)
  80225d:	eb 08                	jmp    802267 <insert_sorted_allocList+0x183>
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 40 40 80 00       	mov    %eax,0x804040
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 55 08             	mov    0x8(%ebp),%edx
  80226d:	89 50 04             	mov    %edx,0x4(%eax)
  802270:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802275:	40                   	inc    %eax
  802276:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80227b:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80227c:	eb 12                	jmp    802290 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 00                	mov    (%eax),%eax
  802283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802286:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228a:	0f 85 71 ff ff ff    	jne    802201 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802290:	90                   	nop
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802299:	a1 38 41 80 00       	mov    0x804138,%eax
  80229e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8022a1:	e9 76 01 00 00       	jmp    80241c <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022af:	0f 85 8a 00 00 00    	jne    80233f <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8022b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b9:	75 17                	jne    8022d2 <alloc_block_FF+0x3f>
  8022bb:	83 ec 04             	sub    $0x4,%esp
  8022be:	68 25 3b 80 00       	push   $0x803b25
  8022c3:	68 a8 00 00 00       	push   $0xa8
  8022c8:	68 b3 3a 80 00       	push   $0x803ab3
  8022cd:	e8 89 df ff ff       	call   80025b <_panic>
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	74 10                	je     8022eb <alloc_block_FF+0x58>
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e3:	8b 52 04             	mov    0x4(%edx),%edx
  8022e6:	89 50 04             	mov    %edx,0x4(%eax)
  8022e9:	eb 0b                	jmp    8022f6 <alloc_block_FF+0x63>
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 40 04             	mov    0x4(%eax),%eax
  8022f1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 40 04             	mov    0x4(%eax),%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	74 0f                	je     80230f <alloc_block_FF+0x7c>
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 40 04             	mov    0x4(%eax),%eax
  802306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802309:	8b 12                	mov    (%edx),%edx
  80230b:	89 10                	mov    %edx,(%eax)
  80230d:	eb 0a                	jmp    802319 <alloc_block_FF+0x86>
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 00                	mov    (%eax),%eax
  802314:	a3 38 41 80 00       	mov    %eax,0x804138
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232c:	a1 44 41 80 00       	mov    0x804144,%eax
  802331:	48                   	dec    %eax
  802332:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	e9 ea 00 00 00       	jmp    802429 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 40 0c             	mov    0xc(%eax),%eax
  802345:	3b 45 08             	cmp    0x8(%ebp),%eax
  802348:	0f 86 c6 00 00 00    	jbe    802414 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80234e:	a1 48 41 80 00       	mov    0x804148,%eax
  802353:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802359:	8b 55 08             	mov    0x8(%ebp),%edx
  80235c:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 50 08             	mov    0x8(%eax),%edx
  802365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802368:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 40 0c             	mov    0xc(%eax),%eax
  802371:	2b 45 08             	sub    0x8(%ebp),%eax
  802374:	89 c2                	mov    %eax,%edx
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 50 08             	mov    0x8(%eax),%edx
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	01 c2                	add    %eax,%edx
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80238d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802391:	75 17                	jne    8023aa <alloc_block_FF+0x117>
  802393:	83 ec 04             	sub    $0x4,%esp
  802396:	68 25 3b 80 00       	push   $0x803b25
  80239b:	68 b6 00 00 00       	push   $0xb6
  8023a0:	68 b3 3a 80 00       	push   $0x803ab3
  8023a5:	e8 b1 de ff ff       	call   80025b <_panic>
  8023aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ad:	8b 00                	mov    (%eax),%eax
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	74 10                	je     8023c3 <alloc_block_FF+0x130>
  8023b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b6:	8b 00                	mov    (%eax),%eax
  8023b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023bb:	8b 52 04             	mov    0x4(%edx),%edx
  8023be:	89 50 04             	mov    %edx,0x4(%eax)
  8023c1:	eb 0b                	jmp    8023ce <alloc_block_FF+0x13b>
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	8b 40 04             	mov    0x4(%eax),%eax
  8023c9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 40 04             	mov    0x4(%eax),%eax
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	74 0f                	je     8023e7 <alloc_block_FF+0x154>
  8023d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023db:	8b 40 04             	mov    0x4(%eax),%eax
  8023de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e1:	8b 12                	mov    (%edx),%edx
  8023e3:	89 10                	mov    %edx,(%eax)
  8023e5:	eb 0a                	jmp    8023f1 <alloc_block_FF+0x15e>
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	8b 00                	mov    (%eax),%eax
  8023ec:	a3 48 41 80 00       	mov    %eax,0x804148
  8023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802404:	a1 54 41 80 00       	mov    0x804154,%eax
  802409:	48                   	dec    %eax
  80240a:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80240f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802412:	eb 15                	jmp    802429 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80241c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802420:	0f 85 80 fe ff ff    	jne    8022a6 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802431:	a1 38 41 80 00       	mov    0x804138,%eax
  802436:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802439:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802440:	e9 c0 00 00 00       	jmp    802505 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 0c             	mov    0xc(%eax),%eax
  80244b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244e:	0f 85 8a 00 00 00    	jne    8024de <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802458:	75 17                	jne    802471 <alloc_block_BF+0x46>
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	68 25 3b 80 00       	push   $0x803b25
  802462:	68 cf 00 00 00       	push   $0xcf
  802467:	68 b3 3a 80 00       	push   $0x803ab3
  80246c:	e8 ea dd ff ff       	call   80025b <_panic>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 00                	mov    (%eax),%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 10                	je     80248a <alloc_block_BF+0x5f>
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 00                	mov    (%eax),%eax
  80247f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802482:	8b 52 04             	mov    0x4(%edx),%edx
  802485:	89 50 04             	mov    %edx,0x4(%eax)
  802488:	eb 0b                	jmp    802495 <alloc_block_BF+0x6a>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 40 04             	mov    0x4(%eax),%eax
  802490:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 04             	mov    0x4(%eax),%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	74 0f                	je     8024ae <alloc_block_BF+0x83>
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 40 04             	mov    0x4(%eax),%eax
  8024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a8:	8b 12                	mov    (%edx),%edx
  8024aa:	89 10                	mov    %edx,(%eax)
  8024ac:	eb 0a                	jmp    8024b8 <alloc_block_BF+0x8d>
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 00                	mov    (%eax),%eax
  8024b3:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cb:	a1 44 41 80 00       	mov    0x804144,%eax
  8024d0:	48                   	dec    %eax
  8024d1:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	e9 2a 01 00 00       	jmp    802608 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e7:	73 14                	jae    8024fd <alloc_block_BF+0xd2>
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f2:	76 09                	jbe    8024fd <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fa:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802509:	0f 85 36 ff ff ff    	jne    802445 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80250f:	a1 38 41 80 00       	mov    0x804138,%eax
  802514:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802517:	e9 dd 00 00 00       	jmp    8025f9 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 40 0c             	mov    0xc(%eax),%eax
  802522:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802525:	0f 85 c6 00 00 00    	jne    8025f1 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80252b:	a1 48 41 80 00       	mov    0x804148,%eax
  802530:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 50 08             	mov    0x8(%eax),%edx
  802539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253c:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80253f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802542:	8b 55 08             	mov    0x8(%ebp),%edx
  802545:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 50 08             	mov    0x8(%eax),%edx
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	01 c2                	add    %eax,%edx
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 0c             	mov    0xc(%eax),%eax
  80255f:	2b 45 08             	sub    0x8(%ebp),%eax
  802562:	89 c2                	mov    %eax,%edx
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80256a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80256e:	75 17                	jne    802587 <alloc_block_BF+0x15c>
  802570:	83 ec 04             	sub    $0x4,%esp
  802573:	68 25 3b 80 00       	push   $0x803b25
  802578:	68 eb 00 00 00       	push   $0xeb
  80257d:	68 b3 3a 80 00       	push   $0x803ab3
  802582:	e8 d4 dc ff ff       	call   80025b <_panic>
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	74 10                	je     8025a0 <alloc_block_BF+0x175>
  802590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802598:	8b 52 04             	mov    0x4(%edx),%edx
  80259b:	89 50 04             	mov    %edx,0x4(%eax)
  80259e:	eb 0b                	jmp    8025ab <alloc_block_BF+0x180>
  8025a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ae:	8b 40 04             	mov    0x4(%eax),%eax
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	74 0f                	je     8025c4 <alloc_block_BF+0x199>
  8025b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b8:	8b 40 04             	mov    0x4(%eax),%eax
  8025bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025be:	8b 12                	mov    (%edx),%edx
  8025c0:	89 10                	mov    %edx,(%eax)
  8025c2:	eb 0a                	jmp    8025ce <alloc_block_BF+0x1a3>
  8025c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	a3 48 41 80 00       	mov    %eax,0x804148
  8025ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e1:	a1 54 41 80 00       	mov    0x804154,%eax
  8025e6:	48                   	dec    %eax
  8025e7:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  8025ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ef:	eb 17                	jmp    802608 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  8025f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fd:	0f 85 19 ff ff ff    	jne    80251c <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802610:	a1 40 40 80 00       	mov    0x804040,%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	75 19                	jne    802632 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	ff 75 08             	pushl  0x8(%ebp)
  80261f:	e8 6f fc ff ff       	call   802293 <alloc_block_FF>
  802624:	83 c4 10             	add    $0x10,%esp
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	e9 e9 01 00 00       	jmp    80281b <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802632:	a1 44 40 80 00       	mov    0x804044,%eax
  802637:	8b 40 08             	mov    0x8(%eax),%eax
  80263a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80263d:	a1 44 40 80 00       	mov    0x804044,%eax
  802642:	8b 50 0c             	mov    0xc(%eax),%edx
  802645:	a1 44 40 80 00       	mov    0x804044,%eax
  80264a:	8b 40 08             	mov    0x8(%eax),%eax
  80264d:	01 d0                	add    %edx,%eax
  80264f:	83 ec 08             	sub    $0x8,%esp
  802652:	50                   	push   %eax
  802653:	68 38 41 80 00       	push   $0x804138
  802658:	e8 54 fa ff ff       	call   8020b1 <find_block>
  80265d:	83 c4 10             	add    $0x10,%esp
  802660:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 40 0c             	mov    0xc(%eax),%eax
  802669:	3b 45 08             	cmp    0x8(%ebp),%eax
  80266c:	0f 85 9b 00 00 00    	jne    80270d <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 50 0c             	mov    0xc(%eax),%edx
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 40 08             	mov    0x8(%eax),%eax
  80267e:	01 d0                	add    %edx,%eax
  802680:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802687:	75 17                	jne    8026a0 <alloc_block_NF+0x96>
  802689:	83 ec 04             	sub    $0x4,%esp
  80268c:	68 25 3b 80 00       	push   $0x803b25
  802691:	68 1a 01 00 00       	push   $0x11a
  802696:	68 b3 3a 80 00       	push   $0x803ab3
  80269b:	e8 bb db ff ff       	call   80025b <_panic>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 10                	je     8026b9 <alloc_block_NF+0xaf>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	8b 52 04             	mov    0x4(%edx),%edx
  8026b4:	89 50 04             	mov    %edx,0x4(%eax)
  8026b7:	eb 0b                	jmp    8026c4 <alloc_block_NF+0xba>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 0f                	je     8026dd <alloc_block_NF+0xd3>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d7:	8b 12                	mov    (%edx),%edx
  8026d9:	89 10                	mov    %edx,(%eax)
  8026db:	eb 0a                	jmp    8026e7 <alloc_block_NF+0xdd>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	a3 38 41 80 00       	mov    %eax,0x804138
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fa:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ff:	48                   	dec    %eax
  802700:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	e9 0e 01 00 00       	jmp    80281b <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 0c             	mov    0xc(%eax),%eax
  802713:	3b 45 08             	cmp    0x8(%ebp),%eax
  802716:	0f 86 cf 00 00 00    	jbe    8027eb <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80271c:	a1 48 41 80 00       	mov    0x804148,%eax
  802721:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802727:	8b 55 08             	mov    0x8(%ebp),%edx
  80272a:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 50 08             	mov    0x8(%eax),%edx
  802733:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802736:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 50 08             	mov    0x8(%eax),%edx
  80273f:	8b 45 08             	mov    0x8(%ebp),%eax
  802742:	01 c2                	add    %eax,%edx
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 40 0c             	mov    0xc(%eax),%eax
  802750:	2b 45 08             	sub    0x8(%ebp),%eax
  802753:	89 c2                	mov    %eax,%edx
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 08             	mov    0x8(%eax),%eax
  802761:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802764:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802768:	75 17                	jne    802781 <alloc_block_NF+0x177>
  80276a:	83 ec 04             	sub    $0x4,%esp
  80276d:	68 25 3b 80 00       	push   $0x803b25
  802772:	68 28 01 00 00       	push   $0x128
  802777:	68 b3 3a 80 00       	push   $0x803ab3
  80277c:	e8 da da ff ff       	call   80025b <_panic>
  802781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802784:	8b 00                	mov    (%eax),%eax
  802786:	85 c0                	test   %eax,%eax
  802788:	74 10                	je     80279a <alloc_block_NF+0x190>
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802792:	8b 52 04             	mov    0x4(%edx),%edx
  802795:	89 50 04             	mov    %edx,0x4(%eax)
  802798:	eb 0b                	jmp    8027a5 <alloc_block_NF+0x19b>
  80279a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279d:	8b 40 04             	mov    0x4(%eax),%eax
  8027a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a8:	8b 40 04             	mov    0x4(%eax),%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	74 0f                	je     8027be <alloc_block_NF+0x1b4>
  8027af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b2:	8b 40 04             	mov    0x4(%eax),%eax
  8027b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b8:	8b 12                	mov    (%edx),%edx
  8027ba:	89 10                	mov    %edx,(%eax)
  8027bc:	eb 0a                	jmp    8027c8 <alloc_block_NF+0x1be>
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	a3 48 41 80 00       	mov    %eax,0x804148
  8027c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027db:	a1 54 41 80 00       	mov    0x804154,%eax
  8027e0:	48                   	dec    %eax
  8027e1:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  8027e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e9:	eb 30                	jmp    80281b <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8027eb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027f3:	75 0a                	jne    8027ff <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  8027f5:	a1 38 41 80 00       	mov    0x804138,%eax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fd:	eb 08                	jmp    802807 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 00                	mov    (%eax),%eax
  802804:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 40 08             	mov    0x8(%eax),%eax
  80280d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802810:	0f 85 4d fe ff ff    	jne    802663 <alloc_block_NF+0x59>

			return NULL;
  802816:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	53                   	push   %ebx
  802821:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802824:	a1 38 41 80 00       	mov    0x804138,%eax
  802829:	85 c0                	test   %eax,%eax
  80282b:	0f 85 86 00 00 00    	jne    8028b7 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802831:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802838:	00 00 00 
  80283b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802842:	00 00 00 
  802845:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80284c:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80284f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802853:	75 17                	jne    80286c <insert_sorted_with_merge_freeList+0x4f>
  802855:	83 ec 04             	sub    $0x4,%esp
  802858:	68 90 3a 80 00       	push   $0x803a90
  80285d:	68 48 01 00 00       	push   $0x148
  802862:	68 b3 3a 80 00       	push   $0x803ab3
  802867:	e8 ef d9 ff ff       	call   80025b <_panic>
  80286c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	89 10                	mov    %edx,(%eax)
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	74 0d                	je     80288d <insert_sorted_with_merge_freeList+0x70>
  802880:	a1 38 41 80 00       	mov    0x804138,%eax
  802885:	8b 55 08             	mov    0x8(%ebp),%edx
  802888:	89 50 04             	mov    %edx,0x4(%eax)
  80288b:	eb 08                	jmp    802895 <insert_sorted_with_merge_freeList+0x78>
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	a3 38 41 80 00       	mov    %eax,0x804138
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a7:	a1 44 41 80 00       	mov    0x804144,%eax
  8028ac:	40                   	inc    %eax
  8028ad:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8028b2:	e9 73 07 00 00       	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	8b 50 08             	mov    0x8(%eax),%edx
  8028bd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028c2:	8b 40 08             	mov    0x8(%eax),%eax
  8028c5:	39 c2                	cmp    %eax,%edx
  8028c7:	0f 86 84 00 00 00    	jbe    802951 <insert_sorted_with_merge_freeList+0x134>
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	8b 50 08             	mov    0x8(%eax),%edx
  8028d3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028d8:	8b 48 0c             	mov    0xc(%eax),%ecx
  8028db:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028e0:	8b 40 08             	mov    0x8(%eax),%eax
  8028e3:	01 c8                	add    %ecx,%eax
  8028e5:	39 c2                	cmp    %eax,%edx
  8028e7:	74 68                	je     802951 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8028e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ed:	75 17                	jne    802906 <insert_sorted_with_merge_freeList+0xe9>
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	68 cc 3a 80 00       	push   $0x803acc
  8028f7:	68 4c 01 00 00       	push   $0x14c
  8028fc:	68 b3 3a 80 00       	push   $0x803ab3
  802901:	e8 55 d9 ff ff       	call   80025b <_panic>
  802906:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	89 50 04             	mov    %edx,0x4(%eax)
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	85 c0                	test   %eax,%eax
  80291a:	74 0c                	je     802928 <insert_sorted_with_merge_freeList+0x10b>
  80291c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802921:	8b 55 08             	mov    0x8(%ebp),%edx
  802924:	89 10                	mov    %edx,(%eax)
  802926:	eb 08                	jmp    802930 <insert_sorted_with_merge_freeList+0x113>
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	a3 38 41 80 00       	mov    %eax,0x804138
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802938:	8b 45 08             	mov    0x8(%ebp),%eax
  80293b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802941:	a1 44 41 80 00       	mov    0x804144,%eax
  802946:	40                   	inc    %eax
  802947:	a3 44 41 80 00       	mov    %eax,0x804144
  80294c:	e9 d9 06 00 00       	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	8b 50 08             	mov    0x8(%eax),%edx
  802957:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80295c:	8b 40 08             	mov    0x8(%eax),%eax
  80295f:	39 c2                	cmp    %eax,%edx
  802961:	0f 86 b5 00 00 00    	jbe    802a1c <insert_sorted_with_merge_freeList+0x1ff>
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8b 50 08             	mov    0x8(%eax),%edx
  80296d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802972:	8b 48 0c             	mov    0xc(%eax),%ecx
  802975:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80297a:	8b 40 08             	mov    0x8(%eax),%eax
  80297d:	01 c8                	add    %ecx,%eax
  80297f:	39 c2                	cmp    %eax,%edx
  802981:	0f 85 95 00 00 00    	jne    802a1c <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802987:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80298c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802992:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802995:	8b 55 08             	mov    0x8(%ebp),%edx
  802998:	8b 52 0c             	mov    0xc(%edx),%edx
  80299b:	01 ca                	add    %ecx,%edx
  80299d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b8:	75 17                	jne    8029d1 <insert_sorted_with_merge_freeList+0x1b4>
  8029ba:	83 ec 04             	sub    $0x4,%esp
  8029bd:	68 90 3a 80 00       	push   $0x803a90
  8029c2:	68 54 01 00 00       	push   $0x154
  8029c7:	68 b3 3a 80 00       	push   $0x803ab3
  8029cc:	e8 8a d8 ff ff       	call   80025b <_panic>
  8029d1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	89 10                	mov    %edx,(%eax)
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	8b 00                	mov    (%eax),%eax
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	74 0d                	je     8029f2 <insert_sorted_with_merge_freeList+0x1d5>
  8029e5:	a1 48 41 80 00       	mov    0x804148,%eax
  8029ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ed:	89 50 04             	mov    %edx,0x4(%eax)
  8029f0:	eb 08                	jmp    8029fa <insert_sorted_with_merge_freeList+0x1dd>
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	a3 48 41 80 00       	mov    %eax,0x804148
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0c:	a1 54 41 80 00       	mov    0x804154,%eax
  802a11:	40                   	inc    %eax
  802a12:	a3 54 41 80 00       	mov    %eax,0x804154
  802a17:	e9 0e 06 00 00       	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	8b 50 08             	mov    0x8(%eax),%edx
  802a22:	a1 38 41 80 00       	mov    0x804138,%eax
  802a27:	8b 40 08             	mov    0x8(%eax),%eax
  802a2a:	39 c2                	cmp    %eax,%edx
  802a2c:	0f 83 c1 00 00 00    	jae    802af3 <insert_sorted_with_merge_freeList+0x2d6>
  802a32:	a1 38 41 80 00       	mov    0x804138,%eax
  802a37:	8b 50 08             	mov    0x8(%eax),%edx
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8b 48 08             	mov    0x8(%eax),%ecx
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	8b 40 0c             	mov    0xc(%eax),%eax
  802a46:	01 c8                	add    %ecx,%eax
  802a48:	39 c2                	cmp    %eax,%edx
  802a4a:	0f 85 a3 00 00 00    	jne    802af3 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802a50:	a1 38 41 80 00       	mov    0x804138,%eax
  802a55:	8b 55 08             	mov    0x8(%ebp),%edx
  802a58:	8b 52 08             	mov    0x8(%edx),%edx
  802a5b:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802a5e:	a1 38 41 80 00       	mov    0x804138,%eax
  802a63:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a69:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6f:	8b 52 0c             	mov    0xc(%edx),%edx
  802a72:	01 ca                	add    %ecx,%edx
  802a74:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8f:	75 17                	jne    802aa8 <insert_sorted_with_merge_freeList+0x28b>
  802a91:	83 ec 04             	sub    $0x4,%esp
  802a94:	68 90 3a 80 00       	push   $0x803a90
  802a99:	68 5d 01 00 00       	push   $0x15d
  802a9e:	68 b3 3a 80 00       	push   $0x803ab3
  802aa3:	e8 b3 d7 ff ff       	call   80025b <_panic>
  802aa8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	89 10                	mov    %edx,(%eax)
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	74 0d                	je     802ac9 <insert_sorted_with_merge_freeList+0x2ac>
  802abc:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac4:	89 50 04             	mov    %edx,0x4(%eax)
  802ac7:	eb 08                	jmp    802ad1 <insert_sorted_with_merge_freeList+0x2b4>
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ae8:	40                   	inc    %eax
  802ae9:	a3 54 41 80 00       	mov    %eax,0x804154
  802aee:	e9 37 05 00 00       	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	8b 50 08             	mov    0x8(%eax),%edx
  802af9:	a1 38 41 80 00       	mov    0x804138,%eax
  802afe:	8b 40 08             	mov    0x8(%eax),%eax
  802b01:	39 c2                	cmp    %eax,%edx
  802b03:	0f 83 82 00 00 00    	jae    802b8b <insert_sorted_with_merge_freeList+0x36e>
  802b09:	a1 38 41 80 00       	mov    0x804138,%eax
  802b0e:	8b 50 08             	mov    0x8(%eax),%edx
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 48 08             	mov    0x8(%eax),%ecx
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1d:	01 c8                	add    %ecx,%eax
  802b1f:	39 c2                	cmp    %eax,%edx
  802b21:	74 68                	je     802b8b <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b27:	75 17                	jne    802b40 <insert_sorted_with_merge_freeList+0x323>
  802b29:	83 ec 04             	sub    $0x4,%esp
  802b2c:	68 90 3a 80 00       	push   $0x803a90
  802b31:	68 62 01 00 00       	push   $0x162
  802b36:	68 b3 3a 80 00       	push   $0x803ab3
  802b3b:	e8 1b d7 ff ff       	call   80025b <_panic>
  802b40:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	89 10                	mov    %edx,(%eax)
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	85 c0                	test   %eax,%eax
  802b52:	74 0d                	je     802b61 <insert_sorted_with_merge_freeList+0x344>
  802b54:	a1 38 41 80 00       	mov    0x804138,%eax
  802b59:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5c:	89 50 04             	mov    %edx,0x4(%eax)
  802b5f:	eb 08                	jmp    802b69 <insert_sorted_with_merge_freeList+0x34c>
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	a3 38 41 80 00       	mov    %eax,0x804138
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7b:	a1 44 41 80 00       	mov    0x804144,%eax
  802b80:	40                   	inc    %eax
  802b81:	a3 44 41 80 00       	mov    %eax,0x804144
  802b86:	e9 9f 04 00 00       	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802b8b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802b95:	e9 84 04 00 00       	jmp    80301e <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	8b 40 08             	mov    0x8(%eax),%eax
  802ba6:	39 c2                	cmp    %eax,%edx
  802ba8:	0f 86 a9 00 00 00    	jbe    802c57 <insert_sorted_with_merge_freeList+0x43a>
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 50 08             	mov    0x8(%eax),%edx
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	8b 48 08             	mov    0x8(%eax),%ecx
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc0:	01 c8                	add    %ecx,%eax
  802bc2:	39 c2                	cmp    %eax,%edx
  802bc4:	0f 84 8d 00 00 00    	je     802c57 <insert_sorted_with_merge_freeList+0x43a>
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	8b 50 08             	mov    0x8(%eax),%edx
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 04             	mov    0x4(%eax),%eax
  802bd6:	8b 48 08             	mov    0x8(%eax),%ecx
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 04             	mov    0x4(%eax),%eax
  802bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802be2:	01 c8                	add    %ecx,%eax
  802be4:	39 c2                	cmp    %eax,%edx
  802be6:	74 6f                	je     802c57 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bec:	74 06                	je     802bf4 <insert_sorted_with_merge_freeList+0x3d7>
  802bee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf2:	75 17                	jne    802c0b <insert_sorted_with_merge_freeList+0x3ee>
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	68 f0 3a 80 00       	push   $0x803af0
  802bfc:	68 6b 01 00 00       	push   $0x16b
  802c01:	68 b3 3a 80 00       	push   $0x803ab3
  802c06:	e8 50 d6 ff ff       	call   80025b <_panic>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 50 04             	mov    0x4(%eax),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	89 50 04             	mov    %edx,0x4(%eax)
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1d:	89 10                	mov    %edx,(%eax)
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 40 04             	mov    0x4(%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 0d                	je     802c36 <insert_sorted_with_merge_freeList+0x419>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 40 04             	mov    0x4(%eax),%eax
  802c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c32:	89 10                	mov    %edx,(%eax)
  802c34:	eb 08                	jmp    802c3e <insert_sorted_with_merge_freeList+0x421>
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 55 08             	mov    0x8(%ebp),%edx
  802c44:	89 50 04             	mov    %edx,0x4(%eax)
  802c47:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4c:	40                   	inc    %eax
  802c4d:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802c52:	e9 d3 03 00 00       	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 50 08             	mov    0x8(%eax),%edx
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	8b 40 08             	mov    0x8(%eax),%eax
  802c63:	39 c2                	cmp    %eax,%edx
  802c65:	0f 86 da 00 00 00    	jbe    802d45 <insert_sorted_with_merge_freeList+0x528>
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 50 08             	mov    0x8(%eax),%edx
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	8b 48 08             	mov    0x8(%eax),%ecx
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7d:	01 c8                	add    %ecx,%eax
  802c7f:	39 c2                	cmp    %eax,%edx
  802c81:	0f 85 be 00 00 00    	jne    802d45 <insert_sorted_with_merge_freeList+0x528>
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 50 08             	mov    0x8(%eax),%edx
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	8b 48 08             	mov    0x8(%eax),%ecx
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9f:	01 c8                	add    %ecx,%eax
  802ca1:	39 c2                	cmp    %eax,%edx
  802ca3:	0f 84 9c 00 00 00    	je     802d45 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	8b 50 08             	mov    0x8(%eax),%edx
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 50 0c             	mov    0xc(%eax),%edx
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc1:	01 c2                	add    %eax,%edx
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802cdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce1:	75 17                	jne    802cfa <insert_sorted_with_merge_freeList+0x4dd>
  802ce3:	83 ec 04             	sub    $0x4,%esp
  802ce6:	68 90 3a 80 00       	push   $0x803a90
  802ceb:	68 74 01 00 00       	push   $0x174
  802cf0:	68 b3 3a 80 00       	push   $0x803ab3
  802cf5:	e8 61 d5 ff ff       	call   80025b <_panic>
  802cfa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	89 10                	mov    %edx,(%eax)
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 0d                	je     802d1b <insert_sorted_with_merge_freeList+0x4fe>
  802d0e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d13:	8b 55 08             	mov    0x8(%ebp),%edx
  802d16:	89 50 04             	mov    %edx,0x4(%eax)
  802d19:	eb 08                	jmp    802d23 <insert_sorted_with_merge_freeList+0x506>
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	a3 48 41 80 00       	mov    %eax,0x804148
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d35:	a1 54 41 80 00       	mov    0x804154,%eax
  802d3a:	40                   	inc    %eax
  802d3b:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d40:	e9 e5 02 00 00       	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 50 08             	mov    0x8(%eax),%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	8b 40 08             	mov    0x8(%eax),%eax
  802d51:	39 c2                	cmp    %eax,%edx
  802d53:	0f 86 d7 00 00 00    	jbe    802e30 <insert_sorted_with_merge_freeList+0x613>
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 50 08             	mov    0x8(%eax),%edx
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	8b 48 08             	mov    0x8(%eax),%ecx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6b:	01 c8                	add    %ecx,%eax
  802d6d:	39 c2                	cmp    %eax,%edx
  802d6f:	0f 84 bb 00 00 00    	je     802e30 <insert_sorted_with_merge_freeList+0x613>
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 50 08             	mov    0x8(%eax),%edx
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 40 04             	mov    0x4(%eax),%eax
  802d81:	8b 48 08             	mov    0x8(%eax),%ecx
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 40 04             	mov    0x4(%eax),%eax
  802d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8d:	01 c8                	add    %ecx,%eax
  802d8f:	39 c2                	cmp    %eax,%edx
  802d91:	0f 85 99 00 00 00    	jne    802e30 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 40 04             	mov    0x4(%eax),%eax
  802d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	8b 50 0c             	mov    0xc(%eax),%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dac:	01 c2                	add    %eax,%edx
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcc:	75 17                	jne    802de5 <insert_sorted_with_merge_freeList+0x5c8>
  802dce:	83 ec 04             	sub    $0x4,%esp
  802dd1:	68 90 3a 80 00       	push   $0x803a90
  802dd6:	68 7d 01 00 00       	push   $0x17d
  802ddb:	68 b3 3a 80 00       	push   $0x803ab3
  802de0:	e8 76 d4 ff ff       	call   80025b <_panic>
  802de5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	89 10                	mov    %edx,(%eax)
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 0d                	je     802e06 <insert_sorted_with_merge_freeList+0x5e9>
  802df9:	a1 48 41 80 00       	mov    0x804148,%eax
  802dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  802e01:	89 50 04             	mov    %edx,0x4(%eax)
  802e04:	eb 08                	jmp    802e0e <insert_sorted_with_merge_freeList+0x5f1>
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	a3 48 41 80 00       	mov    %eax,0x804148
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e20:	a1 54 41 80 00       	mov    0x804154,%eax
  802e25:	40                   	inc    %eax
  802e26:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e2b:	e9 fa 01 00 00       	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 50 08             	mov    0x8(%eax),%edx
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	8b 40 08             	mov    0x8(%eax),%eax
  802e3c:	39 c2                	cmp    %eax,%edx
  802e3e:	0f 86 d2 01 00 00    	jbe    803016 <insert_sorted_with_merge_freeList+0x7f9>
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 50 08             	mov    0x8(%eax),%edx
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	8b 48 08             	mov    0x8(%eax),%ecx
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	8b 40 0c             	mov    0xc(%eax),%eax
  802e56:	01 c8                	add    %ecx,%eax
  802e58:	39 c2                	cmp    %eax,%edx
  802e5a:	0f 85 b6 01 00 00    	jne    803016 <insert_sorted_with_merge_freeList+0x7f9>
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	8b 50 08             	mov    0x8(%eax),%edx
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 04             	mov    0x4(%eax),%eax
  802e6c:	8b 48 08             	mov    0x8(%eax),%ecx
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	8b 40 0c             	mov    0xc(%eax),%eax
  802e78:	01 c8                	add    %ecx,%eax
  802e7a:	39 c2                	cmp    %eax,%edx
  802e7c:	0f 85 94 01 00 00    	jne    803016 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8b:	8b 52 04             	mov    0x4(%edx),%edx
  802e8e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e91:	8b 55 08             	mov    0x8(%ebp),%edx
  802e94:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9a:	8b 52 0c             	mov    0xc(%edx),%edx
  802e9d:	01 da                	add    %ebx,%edx
  802e9f:	01 ca                	add    %ecx,%edx
  802ea1:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802eb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebc:	75 17                	jne    802ed5 <insert_sorted_with_merge_freeList+0x6b8>
  802ebe:	83 ec 04             	sub    $0x4,%esp
  802ec1:	68 25 3b 80 00       	push   $0x803b25
  802ec6:	68 86 01 00 00       	push   $0x186
  802ecb:	68 b3 3a 80 00       	push   $0x803ab3
  802ed0:	e8 86 d3 ff ff       	call   80025b <_panic>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 10                	je     802eee <insert_sorted_with_merge_freeList+0x6d1>
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee6:	8b 52 04             	mov    0x4(%edx),%edx
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	eb 0b                	jmp    802ef9 <insert_sorted_with_merge_freeList+0x6dc>
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 40 04             	mov    0x4(%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 0f                	je     802f12 <insert_sorted_with_merge_freeList+0x6f5>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0c:	8b 12                	mov    (%edx),%edx
  802f0e:	89 10                	mov    %edx,(%eax)
  802f10:	eb 0a                	jmp    802f1c <insert_sorted_with_merge_freeList+0x6ff>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	a3 38 41 80 00       	mov    %eax,0x804138
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2f:	a1 44 41 80 00       	mov    0x804144,%eax
  802f34:	48                   	dec    %eax
  802f35:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3e:	75 17                	jne    802f57 <insert_sorted_with_merge_freeList+0x73a>
  802f40:	83 ec 04             	sub    $0x4,%esp
  802f43:	68 90 3a 80 00       	push   $0x803a90
  802f48:	68 87 01 00 00       	push   $0x187
  802f4d:	68 b3 3a 80 00       	push   $0x803ab3
  802f52:	e8 04 d3 ff ff       	call   80025b <_panic>
  802f57:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	89 10                	mov    %edx,(%eax)
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	85 c0                	test   %eax,%eax
  802f69:	74 0d                	je     802f78 <insert_sorted_with_merge_freeList+0x75b>
  802f6b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f73:	89 50 04             	mov    %edx,0x4(%eax)
  802f76:	eb 08                	jmp    802f80 <insert_sorted_with_merge_freeList+0x763>
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	a3 48 41 80 00       	mov    %eax,0x804148
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f92:	a1 54 41 80 00       	mov    0x804154,%eax
  802f97:	40                   	inc    %eax
  802f98:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb5:	75 17                	jne    802fce <insert_sorted_with_merge_freeList+0x7b1>
  802fb7:	83 ec 04             	sub    $0x4,%esp
  802fba:	68 90 3a 80 00       	push   $0x803a90
  802fbf:	68 8a 01 00 00       	push   $0x18a
  802fc4:	68 b3 3a 80 00       	push   $0x803ab3
  802fc9:	e8 8d d2 ff ff       	call   80025b <_panic>
  802fce:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	89 10                	mov    %edx,(%eax)
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	74 0d                	je     802fef <insert_sorted_with_merge_freeList+0x7d2>
  802fe2:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fea:	89 50 04             	mov    %edx,0x4(%eax)
  802fed:	eb 08                	jmp    802ff7 <insert_sorted_with_merge_freeList+0x7da>
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	a3 48 41 80 00       	mov    %eax,0x804148
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803009:	a1 54 41 80 00       	mov    0x804154,%eax
  80300e:	40                   	inc    %eax
  80300f:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803014:	eb 14                	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803019:	8b 00                	mov    (%eax),%eax
  80301b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80301e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803022:	0f 85 72 fb ff ff    	jne    802b9a <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803028:	eb 00                	jmp    80302a <insert_sorted_with_merge_freeList+0x80d>
  80302a:	90                   	nop
  80302b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80302e:	c9                   	leave  
  80302f:	c3                   	ret    

00803030 <__udivdi3>:
  803030:	55                   	push   %ebp
  803031:	57                   	push   %edi
  803032:	56                   	push   %esi
  803033:	53                   	push   %ebx
  803034:	83 ec 1c             	sub    $0x1c,%esp
  803037:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80303b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80303f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803043:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803047:	89 ca                	mov    %ecx,%edx
  803049:	89 f8                	mov    %edi,%eax
  80304b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80304f:	85 f6                	test   %esi,%esi
  803051:	75 2d                	jne    803080 <__udivdi3+0x50>
  803053:	39 cf                	cmp    %ecx,%edi
  803055:	77 65                	ja     8030bc <__udivdi3+0x8c>
  803057:	89 fd                	mov    %edi,%ebp
  803059:	85 ff                	test   %edi,%edi
  80305b:	75 0b                	jne    803068 <__udivdi3+0x38>
  80305d:	b8 01 00 00 00       	mov    $0x1,%eax
  803062:	31 d2                	xor    %edx,%edx
  803064:	f7 f7                	div    %edi
  803066:	89 c5                	mov    %eax,%ebp
  803068:	31 d2                	xor    %edx,%edx
  80306a:	89 c8                	mov    %ecx,%eax
  80306c:	f7 f5                	div    %ebp
  80306e:	89 c1                	mov    %eax,%ecx
  803070:	89 d8                	mov    %ebx,%eax
  803072:	f7 f5                	div    %ebp
  803074:	89 cf                	mov    %ecx,%edi
  803076:	89 fa                	mov    %edi,%edx
  803078:	83 c4 1c             	add    $0x1c,%esp
  80307b:	5b                   	pop    %ebx
  80307c:	5e                   	pop    %esi
  80307d:	5f                   	pop    %edi
  80307e:	5d                   	pop    %ebp
  80307f:	c3                   	ret    
  803080:	39 ce                	cmp    %ecx,%esi
  803082:	77 28                	ja     8030ac <__udivdi3+0x7c>
  803084:	0f bd fe             	bsr    %esi,%edi
  803087:	83 f7 1f             	xor    $0x1f,%edi
  80308a:	75 40                	jne    8030cc <__udivdi3+0x9c>
  80308c:	39 ce                	cmp    %ecx,%esi
  80308e:	72 0a                	jb     80309a <__udivdi3+0x6a>
  803090:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803094:	0f 87 9e 00 00 00    	ja     803138 <__udivdi3+0x108>
  80309a:	b8 01 00 00 00       	mov    $0x1,%eax
  80309f:	89 fa                	mov    %edi,%edx
  8030a1:	83 c4 1c             	add    $0x1c,%esp
  8030a4:	5b                   	pop    %ebx
  8030a5:	5e                   	pop    %esi
  8030a6:	5f                   	pop    %edi
  8030a7:	5d                   	pop    %ebp
  8030a8:	c3                   	ret    
  8030a9:	8d 76 00             	lea    0x0(%esi),%esi
  8030ac:	31 ff                	xor    %edi,%edi
  8030ae:	31 c0                	xor    %eax,%eax
  8030b0:	89 fa                	mov    %edi,%edx
  8030b2:	83 c4 1c             	add    $0x1c,%esp
  8030b5:	5b                   	pop    %ebx
  8030b6:	5e                   	pop    %esi
  8030b7:	5f                   	pop    %edi
  8030b8:	5d                   	pop    %ebp
  8030b9:	c3                   	ret    
  8030ba:	66 90                	xchg   %ax,%ax
  8030bc:	89 d8                	mov    %ebx,%eax
  8030be:	f7 f7                	div    %edi
  8030c0:	31 ff                	xor    %edi,%edi
  8030c2:	89 fa                	mov    %edi,%edx
  8030c4:	83 c4 1c             	add    $0x1c,%esp
  8030c7:	5b                   	pop    %ebx
  8030c8:	5e                   	pop    %esi
  8030c9:	5f                   	pop    %edi
  8030ca:	5d                   	pop    %ebp
  8030cb:	c3                   	ret    
  8030cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030d1:	89 eb                	mov    %ebp,%ebx
  8030d3:	29 fb                	sub    %edi,%ebx
  8030d5:	89 f9                	mov    %edi,%ecx
  8030d7:	d3 e6                	shl    %cl,%esi
  8030d9:	89 c5                	mov    %eax,%ebp
  8030db:	88 d9                	mov    %bl,%cl
  8030dd:	d3 ed                	shr    %cl,%ebp
  8030df:	89 e9                	mov    %ebp,%ecx
  8030e1:	09 f1                	or     %esi,%ecx
  8030e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030e7:	89 f9                	mov    %edi,%ecx
  8030e9:	d3 e0                	shl    %cl,%eax
  8030eb:	89 c5                	mov    %eax,%ebp
  8030ed:	89 d6                	mov    %edx,%esi
  8030ef:	88 d9                	mov    %bl,%cl
  8030f1:	d3 ee                	shr    %cl,%esi
  8030f3:	89 f9                	mov    %edi,%ecx
  8030f5:	d3 e2                	shl    %cl,%edx
  8030f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030fb:	88 d9                	mov    %bl,%cl
  8030fd:	d3 e8                	shr    %cl,%eax
  8030ff:	09 c2                	or     %eax,%edx
  803101:	89 d0                	mov    %edx,%eax
  803103:	89 f2                	mov    %esi,%edx
  803105:	f7 74 24 0c          	divl   0xc(%esp)
  803109:	89 d6                	mov    %edx,%esi
  80310b:	89 c3                	mov    %eax,%ebx
  80310d:	f7 e5                	mul    %ebp
  80310f:	39 d6                	cmp    %edx,%esi
  803111:	72 19                	jb     80312c <__udivdi3+0xfc>
  803113:	74 0b                	je     803120 <__udivdi3+0xf0>
  803115:	89 d8                	mov    %ebx,%eax
  803117:	31 ff                	xor    %edi,%edi
  803119:	e9 58 ff ff ff       	jmp    803076 <__udivdi3+0x46>
  80311e:	66 90                	xchg   %ax,%ax
  803120:	8b 54 24 08          	mov    0x8(%esp),%edx
  803124:	89 f9                	mov    %edi,%ecx
  803126:	d3 e2                	shl    %cl,%edx
  803128:	39 c2                	cmp    %eax,%edx
  80312a:	73 e9                	jae    803115 <__udivdi3+0xe5>
  80312c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80312f:	31 ff                	xor    %edi,%edi
  803131:	e9 40 ff ff ff       	jmp    803076 <__udivdi3+0x46>
  803136:	66 90                	xchg   %ax,%ax
  803138:	31 c0                	xor    %eax,%eax
  80313a:	e9 37 ff ff ff       	jmp    803076 <__udivdi3+0x46>
  80313f:	90                   	nop

00803140 <__umoddi3>:
  803140:	55                   	push   %ebp
  803141:	57                   	push   %edi
  803142:	56                   	push   %esi
  803143:	53                   	push   %ebx
  803144:	83 ec 1c             	sub    $0x1c,%esp
  803147:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80314b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80314f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803153:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803157:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80315b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80315f:	89 f3                	mov    %esi,%ebx
  803161:	89 fa                	mov    %edi,%edx
  803163:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803167:	89 34 24             	mov    %esi,(%esp)
  80316a:	85 c0                	test   %eax,%eax
  80316c:	75 1a                	jne    803188 <__umoddi3+0x48>
  80316e:	39 f7                	cmp    %esi,%edi
  803170:	0f 86 a2 00 00 00    	jbe    803218 <__umoddi3+0xd8>
  803176:	89 c8                	mov    %ecx,%eax
  803178:	89 f2                	mov    %esi,%edx
  80317a:	f7 f7                	div    %edi
  80317c:	89 d0                	mov    %edx,%eax
  80317e:	31 d2                	xor    %edx,%edx
  803180:	83 c4 1c             	add    $0x1c,%esp
  803183:	5b                   	pop    %ebx
  803184:	5e                   	pop    %esi
  803185:	5f                   	pop    %edi
  803186:	5d                   	pop    %ebp
  803187:	c3                   	ret    
  803188:	39 f0                	cmp    %esi,%eax
  80318a:	0f 87 ac 00 00 00    	ja     80323c <__umoddi3+0xfc>
  803190:	0f bd e8             	bsr    %eax,%ebp
  803193:	83 f5 1f             	xor    $0x1f,%ebp
  803196:	0f 84 ac 00 00 00    	je     803248 <__umoddi3+0x108>
  80319c:	bf 20 00 00 00       	mov    $0x20,%edi
  8031a1:	29 ef                	sub    %ebp,%edi
  8031a3:	89 fe                	mov    %edi,%esi
  8031a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031a9:	89 e9                	mov    %ebp,%ecx
  8031ab:	d3 e0                	shl    %cl,%eax
  8031ad:	89 d7                	mov    %edx,%edi
  8031af:	89 f1                	mov    %esi,%ecx
  8031b1:	d3 ef                	shr    %cl,%edi
  8031b3:	09 c7                	or     %eax,%edi
  8031b5:	89 e9                	mov    %ebp,%ecx
  8031b7:	d3 e2                	shl    %cl,%edx
  8031b9:	89 14 24             	mov    %edx,(%esp)
  8031bc:	89 d8                	mov    %ebx,%eax
  8031be:	d3 e0                	shl    %cl,%eax
  8031c0:	89 c2                	mov    %eax,%edx
  8031c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c6:	d3 e0                	shl    %cl,%eax
  8031c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d0:	89 f1                	mov    %esi,%ecx
  8031d2:	d3 e8                	shr    %cl,%eax
  8031d4:	09 d0                	or     %edx,%eax
  8031d6:	d3 eb                	shr    %cl,%ebx
  8031d8:	89 da                	mov    %ebx,%edx
  8031da:	f7 f7                	div    %edi
  8031dc:	89 d3                	mov    %edx,%ebx
  8031de:	f7 24 24             	mull   (%esp)
  8031e1:	89 c6                	mov    %eax,%esi
  8031e3:	89 d1                	mov    %edx,%ecx
  8031e5:	39 d3                	cmp    %edx,%ebx
  8031e7:	0f 82 87 00 00 00    	jb     803274 <__umoddi3+0x134>
  8031ed:	0f 84 91 00 00 00    	je     803284 <__umoddi3+0x144>
  8031f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031f7:	29 f2                	sub    %esi,%edx
  8031f9:	19 cb                	sbb    %ecx,%ebx
  8031fb:	89 d8                	mov    %ebx,%eax
  8031fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803201:	d3 e0                	shl    %cl,%eax
  803203:	89 e9                	mov    %ebp,%ecx
  803205:	d3 ea                	shr    %cl,%edx
  803207:	09 d0                	or     %edx,%eax
  803209:	89 e9                	mov    %ebp,%ecx
  80320b:	d3 eb                	shr    %cl,%ebx
  80320d:	89 da                	mov    %ebx,%edx
  80320f:	83 c4 1c             	add    $0x1c,%esp
  803212:	5b                   	pop    %ebx
  803213:	5e                   	pop    %esi
  803214:	5f                   	pop    %edi
  803215:	5d                   	pop    %ebp
  803216:	c3                   	ret    
  803217:	90                   	nop
  803218:	89 fd                	mov    %edi,%ebp
  80321a:	85 ff                	test   %edi,%edi
  80321c:	75 0b                	jne    803229 <__umoddi3+0xe9>
  80321e:	b8 01 00 00 00       	mov    $0x1,%eax
  803223:	31 d2                	xor    %edx,%edx
  803225:	f7 f7                	div    %edi
  803227:	89 c5                	mov    %eax,%ebp
  803229:	89 f0                	mov    %esi,%eax
  80322b:	31 d2                	xor    %edx,%edx
  80322d:	f7 f5                	div    %ebp
  80322f:	89 c8                	mov    %ecx,%eax
  803231:	f7 f5                	div    %ebp
  803233:	89 d0                	mov    %edx,%eax
  803235:	e9 44 ff ff ff       	jmp    80317e <__umoddi3+0x3e>
  80323a:	66 90                	xchg   %ax,%ax
  80323c:	89 c8                	mov    %ecx,%eax
  80323e:	89 f2                	mov    %esi,%edx
  803240:	83 c4 1c             	add    $0x1c,%esp
  803243:	5b                   	pop    %ebx
  803244:	5e                   	pop    %esi
  803245:	5f                   	pop    %edi
  803246:	5d                   	pop    %ebp
  803247:	c3                   	ret    
  803248:	3b 04 24             	cmp    (%esp),%eax
  80324b:	72 06                	jb     803253 <__umoddi3+0x113>
  80324d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803251:	77 0f                	ja     803262 <__umoddi3+0x122>
  803253:	89 f2                	mov    %esi,%edx
  803255:	29 f9                	sub    %edi,%ecx
  803257:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80325b:	89 14 24             	mov    %edx,(%esp)
  80325e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803262:	8b 44 24 04          	mov    0x4(%esp),%eax
  803266:	8b 14 24             	mov    (%esp),%edx
  803269:	83 c4 1c             	add    $0x1c,%esp
  80326c:	5b                   	pop    %ebx
  80326d:	5e                   	pop    %esi
  80326e:	5f                   	pop    %edi
  80326f:	5d                   	pop    %ebp
  803270:	c3                   	ret    
  803271:	8d 76 00             	lea    0x0(%esi),%esi
  803274:	2b 04 24             	sub    (%esp),%eax
  803277:	19 fa                	sbb    %edi,%edx
  803279:	89 d1                	mov    %edx,%ecx
  80327b:	89 c6                	mov    %eax,%esi
  80327d:	e9 71 ff ff ff       	jmp    8031f3 <__umoddi3+0xb3>
  803282:	66 90                	xchg   %ax,%ax
  803284:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803288:	72 ea                	jb     803274 <__umoddi3+0x134>
  80328a:	89 d9                	mov    %ebx,%ecx
  80328c:	e9 62 ff ff ff       	jmp    8031f3 <__umoddi3+0xb3>
