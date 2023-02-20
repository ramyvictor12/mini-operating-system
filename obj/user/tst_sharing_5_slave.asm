
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 ff 00 00 00       	call   800135 <libmain>
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
  80008c:	68 c0 32 80 00       	push   $0x8032c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 32 80 00       	push   $0x8032dc
  800098:	e8 d4 01 00 00       	call   800271 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 ce 13 00 00       	call   801475 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int expected;
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 23 1b 00 00       	call   801bd2 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 f7 32 80 00       	push   $0x8032f7
  8000b7:	50                   	push   %eax
  8000b8:	e8 dc 15 00 00       	call   801699 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 11 18 00 00       	call   8018d9 <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 fc 32 80 00       	push   $0x8032fc
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 93 16 00 00       	call   801779 <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 20 33 80 00       	push   $0x803320
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 db 17 00 00       	call   8018d9 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	expected = 1;
  80010a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 38 33 80 00       	push   $0x803338
  800121:	6a 24                	push   $0x24
  800123:	68 dc 32 80 00       	push   $0x8032dc
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 c5 1b 00 00       	call   801cf7 <inctst>

	return;
  800132:	90                   	nop
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013b:	e8 79 1a 00 00       	call   801bb9 <sys_getenvindex>
  800140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800146:	89 d0                	mov    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	01 c0                	add    %eax,%eax
  80014f:	01 d0                	add    %edx,%eax
  800151:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800158:	01 d0                	add    %edx,%eax
  80015a:	c1 e0 04             	shl    $0x4,%eax
  80015d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800162:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800167:	a1 20 40 80 00       	mov    0x804020,%eax
  80016c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0f                	je     800185 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	05 5c 05 00 00       	add    $0x55c,%eax
  800180:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800189:	7e 0a                	jle    800195 <libmain+0x60>
		binaryname = argv[0];
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 fe ff ff       	call   800038 <_main>
  8001a3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a6:	e8 1b 18 00 00       	call   8019c6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 dc 33 80 00       	push   $0x8033dc
  8001b3:	e8 6d 03 00 00       	call   800525 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	52                   	push   %edx
  8001d5:	50                   	push   %eax
  8001d6:	68 04 34 80 00       	push   $0x803404
  8001db:	e8 45 03 00 00       	call   800525 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fe:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800204:	51                   	push   %ecx
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	68 2c 34 80 00       	push   $0x80342c
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 84 34 80 00       	push   $0x803484
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 dc 33 80 00       	push   $0x8033dc
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 9b 17 00 00       	call   8019e0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800245:	e8 19 00 00 00       	call   800263 <exit>
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 00                	push   $0x0
  800258:	e8 28 19 00 00       	call   801b85 <sys_destroy_env>
  80025d:	83 c4 10             	add    $0x10,%esp
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <exit>:

void
exit(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800269:	e8 7d 19 00 00       	call   801beb <sys_exit_env>
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800277:	8d 45 10             	lea    0x10(%ebp),%eax
  80027a:	83 c0 04             	add    $0x4,%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800280:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800285:	85 c0                	test   %eax,%eax
  800287:	74 16                	je     80029f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800289:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	50                   	push   %eax
  800292:	68 98 34 80 00       	push   $0x803498
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 9d 34 80 00       	push   $0x80349d
  8002b0:	e8 70 02 00 00       	call   800525 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	e8 f3 01 00 00       	call   8004ba <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	68 b9 34 80 00       	push   $0x8034b9
  8002d4:	e8 e1 01 00 00       	call   8004ba <vcprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002dc:	e8 82 ff ff ff       	call   800263 <exit>

	// should not return here
	while (1) ;
  8002e1:	eb fe                	jmp    8002e1 <_panic+0x70>

008002e3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ee:	8b 50 74             	mov    0x74(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 bc 34 80 00       	push   $0x8034bc
  800300:	6a 26                	push   $0x26
  800302:	68 08 35 80 00       	push   $0x803508
  800307:	e8 65 ff ff ff       	call   800271 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031a:	e9 c2 00 00 00       	jmp    8003e1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	85 c0                	test   %eax,%eax
  800332:	75 08                	jne    80033c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800334:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800337:	e9 a2 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80033c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034a:	eb 69                	jmp    8003b5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034c:	a1 20 40 80 00       	mov    0x804020,%eax
  800351:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035a:	89 d0                	mov    %edx,%eax
  80035c:	01 c0                	add    %eax,%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	c1 e0 03             	shl    $0x3,%eax
  800363:	01 c8                	add    %ecx,%eax
  800365:	8a 40 04             	mov    0x4(%eax),%al
  800368:	84 c0                	test   %al,%al
  80036a:	75 46                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	a1 20 40 80 00       	mov    0x804020,%eax
  800371:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037a:	89 d0                	mov    %edx,%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 03             	shl    $0x3,%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 c8                	add    %ecx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	75 09                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b0:	eb 12                	jmp    8003c4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 50 74             	mov    0x74(%eax),%edx
  8003bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c0:	39 c2                	cmp    %eax,%edx
  8003c2:	77 88                	ja     80034c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c8:	75 14                	jne    8003de <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 14 35 80 00       	push   $0x803514
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 08 35 80 00       	push   $0x803508
  8003d9:	e8 93 fe ff ff       	call   800271 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003de:	ff 45 f0             	incl   -0x10(%ebp)
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e7:	0f 8c 32 ff ff ff    	jl     80031f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fb:	eb 26                	jmp    800423 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800402:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800408:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040b:	89 d0                	mov    %edx,%eax
  80040d:	01 c0                	add    %eax,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	c1 e0 03             	shl    $0x3,%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8a 40 04             	mov    0x4(%eax),%al
  800419:	3c 01                	cmp    $0x1,%al
  80041b:	75 03                	jne    800420 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80041d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	ff 45 e0             	incl   -0x20(%ebp)
  800423:	a1 20 40 80 00       	mov    0x804020,%eax
  800428:	8b 50 74             	mov    0x74(%eax),%edx
  80042b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	77 cb                	ja     8003fd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800435:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800438:	74 14                	je     80044e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	68 68 35 80 00       	push   $0x803568
  800442:	6a 44                	push   $0x44
  800444:	68 08 35 80 00       	push   $0x803508
  800449:	e8 23 fe ff ff       	call   800271 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044e:	90                   	nop
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 48 01             	lea    0x1(%eax),%ecx
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	89 0a                	mov    %ecx,(%edx)
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	88 d1                	mov    %dl,%cl
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047a:	75 2c                	jne    8004a8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047c:	a0 24 40 80 00       	mov    0x804024,%al
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	8b 55 0c             	mov    0xc(%ebp),%edx
  800487:	8b 12                	mov    (%edx),%edx
  800489:	89 d1                	mov    %edx,%ecx
  80048b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048e:	83 c2 08             	add    $0x8,%edx
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	50                   	push   %eax
  800495:	51                   	push   %ecx
  800496:	52                   	push   %edx
  800497:	e8 7c 13 00 00       	call   801818 <sys_cputs>
  80049c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 40 04             	mov    0x4(%eax),%eax
  8004ae:	8d 50 01             	lea    0x1(%eax),%edx
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ca:	00 00 00 
	b.cnt = 0;
  8004cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	ff 75 08             	pushl  0x8(%ebp)
  8004dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	68 51 04 80 00       	push   $0x800451
  8004e9:	e8 11 02 00 00       	call   8006ff <vprintfmt>
  8004ee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f1:	a0 24 40 80 00       	mov    0x804024,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	50                   	push   %eax
  800503:	52                   	push   %edx
  800504:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050a:	83 c0 08             	add    $0x8,%eax
  80050d:	50                   	push   %eax
  80050e:	e8 05 13 00 00       	call   801818 <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800516:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80051d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <cprintf>:

int cprintf(const char *fmt, ...) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 73 ff ff ff       	call   8004ba <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800558:	e8 69 14 00 00       	call   8019c6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800560:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 f4             	pushl  -0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	e8 48 ff ff ff       	call   8004ba <vcprintf>
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800578:	e8 63 14 00 00       	call   8019e0 <sys_enable_interrupt>
	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	53                   	push   %ebx
  800586:	83 ec 14             	sub    $0x14,%esp
  800589:	8b 45 10             	mov    0x10(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800595:	8b 45 18             	mov    0x18(%ebp),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a0:	77 55                	ja     8005f7 <printnum+0x75>
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	72 05                	jb     8005ac <printnum+0x2a>
  8005a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005aa:	77 4b                	ja     8005f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	52                   	push   %edx
  8005bb:	50                   	push   %eax
  8005bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c2:	e8 81 2a 00 00       	call   803048 <__udivdi3>
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	ff 75 20             	pushl  0x20(%ebp)
  8005d0:	53                   	push   %ebx
  8005d1:	ff 75 18             	pushl  0x18(%ebp)
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	e8 a1 ff ff ff       	call   800582 <printnum>
  8005e1:	83 c4 20             	add    $0x20,%esp
  8005e4:	eb 1a                	jmp    800600 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	ff d0                	call   *%eax
  8005f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8005fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fe:	7f e6                	jg     8005e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800600:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800603:	bb 00 00 00 00       	mov    $0x0,%ebx
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060e:	53                   	push   %ebx
  80060f:	51                   	push   %ecx
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	e8 41 2b 00 00       	call   803158 <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 d4 37 80 00       	add    $0x8037d4,%eax
  80061f:	8a 00                	mov    (%eax),%al
  800621:	0f be c0             	movsbl %al,%eax
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	50                   	push   %eax
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	ff d0                	call   *%eax
  800630:	83 c4 10             	add    $0x10,%esp
}
  800633:	90                   	nop
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800640:	7e 1c                	jle    80065e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	8d 50 08             	lea    0x8(%eax),%edx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 10                	mov    %edx,(%eax)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 e8 08             	sub    $0x8,%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	eb 40                	jmp    80069e <getuint+0x65>
	else if (lflag)
  80065e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800662:	74 1e                	je     800682 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	8d 50 04             	lea    0x4(%eax),%edx
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	89 10                	mov    %edx,(%eax)
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	eb 1c                	jmp    80069e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a7:	7e 1c                	jle    8006c5 <getint+0x25>
		return va_arg(*ap, long long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 08             	lea    0x8(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 08             	sub    $0x8,%eax
  8006be:	8b 50 04             	mov    0x4(%eax),%edx
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	eb 38                	jmp    8006fd <getint+0x5d>
	else if (lflag)
  8006c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c9:	74 1a                	je     8006e5 <getint+0x45>
		return va_arg(*ap, long);
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	89 10                	mov    %edx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	83 e8 04             	sub    $0x4,%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	99                   	cltd   
  8006e3:	eb 18                	jmp    8006fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	56                   	push   %esi
  800703:	53                   	push   %ebx
  800704:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x21>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 af 03 00 00    	je     800ac0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	53                   	push   %ebx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	8d 50 01             	lea    0x1(%eax),%edx
  800726:	89 55 10             	mov    %edx,0x10(%ebp)
  800729:	8a 00                	mov    (%eax),%al
  80072b:	0f b6 d8             	movzbl %al,%ebx
  80072e:	83 fb 25             	cmp    $0x25,%ebx
  800731:	75 d6                	jne    800709 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800733:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800737:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800745:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800753:	8b 45 10             	mov    0x10(%ebp),%eax
  800756:	8d 50 01             	lea    0x1(%eax),%edx
  800759:	89 55 10             	mov    %edx,0x10(%ebp)
  80075c:	8a 00                	mov    (%eax),%al
  80075e:	0f b6 d8             	movzbl %al,%ebx
  800761:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800764:	83 f8 55             	cmp    $0x55,%eax
  800767:	0f 87 2b 03 00 00    	ja     800a98 <vprintfmt+0x399>
  80076d:	8b 04 85 f8 37 80 00 	mov    0x8037f8(,%eax,4),%eax
  800774:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800776:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077a:	eb d7                	jmp    800753 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800780:	eb d1                	jmp    800753 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800782:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078c:	89 d0                	mov    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	01 d0                	add    %edx,%eax
  800793:	01 c0                	add    %eax,%eax
  800795:	01 d8                	add    %ebx,%eax
  800797:	83 e8 30             	sub    $0x30,%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079d:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 3e                	jle    8007e8 <vprintfmt+0xe9>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 39                	jg     8007e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b2:	eb d5                	jmp    800789 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c8:	eb 1f                	jmp    8007e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ce:	79 83                	jns    800753 <vprintfmt+0x54>
				width = 0;
  8007d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d7:	e9 77 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e3:	e9 6b ff ff ff       	jmp    800753 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	0f 89 60 ff ff ff    	jns    800753 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800800:	e9 4e ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800805:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800808:	e9 46 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	50                   	push   %eax
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	e9 89 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800843:	85 db                	test   %ebx,%ebx
  800845:	79 02                	jns    800849 <vprintfmt+0x14a>
				err = -err;
  800847:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800849:	83 fb 64             	cmp    $0x64,%ebx
  80084c:	7f 0b                	jg     800859 <vprintfmt+0x15a>
  80084e:	8b 34 9d 40 36 80 00 	mov    0x803640(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 e5 37 80 00       	push   $0x8037e5
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 5e 02 00 00       	call   800ac8 <printfmt>
  80086a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086d:	e9 49 02 00 00       	jmp    800abb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800872:	56                   	push   %esi
  800873:	68 ee 37 80 00       	push   $0x8037ee
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 45 02 00 00       	call   800ac8 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	e9 30 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 30                	mov    (%eax),%esi
  80089c:	85 f6                	test   %esi,%esi
  80089e:	75 05                	jne    8008a5 <vprintfmt+0x1a6>
				p = "(null)";
  8008a0:	be f1 37 80 00       	mov    $0x8037f1,%esi
			if (width > 0 && padc != '-')
  8008a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a9:	7e 6d                	jle    800918 <vprintfmt+0x219>
  8008ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008af:	74 67                	je     800918 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	50                   	push   %eax
  8008b8:	56                   	push   %esi
  8008b9:	e8 0c 03 00 00       	call   800bca <strnlen>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c4:	eb 16                	jmp    8008dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e0:	7f e4                	jg     8008c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	eb 34                	jmp    800918 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e8:	74 1c                	je     800906 <vprintfmt+0x207>
  8008ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ed:	7e 05                	jle    8008f4 <vprintfmt+0x1f5>
  8008ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f2:	7e 12                	jle    800906 <vprintfmt+0x207>
					putch('?', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	6a 3f                	push   $0x3f
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	ff 4d e4             	decl   -0x1c(%ebp)
  800918:	89 f0                	mov    %esi,%eax
  80091a:	8d 70 01             	lea    0x1(%eax),%esi
  80091d:	8a 00                	mov    (%eax),%al
  80091f:	0f be d8             	movsbl %al,%ebx
  800922:	85 db                	test   %ebx,%ebx
  800924:	74 24                	je     80094a <vprintfmt+0x24b>
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	78 b8                	js     8008e4 <vprintfmt+0x1e5>
  80092c:	ff 4d e0             	decl   -0x20(%ebp)
  80092f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800933:	79 af                	jns    8008e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800935:	eb 13                	jmp    80094a <vprintfmt+0x24b>
				putch(' ', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 20                	push   $0x20
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	ff 4d e4             	decl   -0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e7                	jg     800937 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800950:	e9 66 01 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 e8             	pushl  -0x18(%ebp)
  80095b:	8d 45 14             	lea    0x14(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	e8 3c fd ff ff       	call   8006a0 <getint>
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800973:	85 d2                	test   %edx,%edx
  800975:	79 23                	jns    80099a <vprintfmt+0x29b>
				putch('-', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 2d                	push   $0x2d
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	f7 d8                	neg    %eax
  80098f:	83 d2 00             	adc    $0x0,%edx
  800992:	f7 da                	neg    %edx
  800994:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800997:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a1:	e9 bc 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	e8 84 fc ff ff       	call   800639 <getuint>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c5:	e9 98 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 58                	push   $0x58
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			break;
  8009fa:	e9 bc 00 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 30                	push   $0x30
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 78                	push   $0x78
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 c0 04             	add    $0x4,%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 e8 04             	sub    $0x4,%eax
  800a2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a41:	eb 1f                	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 e7 fb ff ff       	call   800639 <getuint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	83 ec 04             	sub    $0x4,%esp
  800a6c:	52                   	push   %edx
  800a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 00 fb ff ff       	call   800582 <printnum>
  800a82:	83 c4 20             	add    $0x20,%esp
			break;
  800a85:	eb 34                	jmp    800abb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			break;
  800a96:	eb 23                	jmp    800abb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 25                	push   $0x25
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	eb 03                	jmp    800ab0 <vprintfmt+0x3b1>
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	48                   	dec    %eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	3c 25                	cmp    $0x25,%al
  800ab8:	75 f3                	jne    800aad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aba:	90                   	nop
		}
	}
  800abb:	e9 47 fc ff ff       	jmp    800707 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ace:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 16 fc ff ff       	call   8006ff <vprintfmt>
  800ae9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aec:	90                   	nop
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 40 08             	mov    0x8(%eax),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	8b 10                	mov    (%eax),%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 40 04             	mov    0x4(%eax),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	73 12                	jae    800b22 <sprintputch+0x33>
		*b->buf++ = ch;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	8d 48 01             	lea    0x1(%eax),%ecx
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 0a                	mov    %ecx,(%edx)
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	88 10                	mov    %dl,(%eax)
}
  800b22:	90                   	nop
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4a:	74 06                	je     800b52 <vsnprintf+0x2d>
  800b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b50:	7f 07                	jg     800b59 <vsnprintf+0x34>
		return -E_INVAL;
  800b52:	b8 03 00 00 00       	mov    $0x3,%eax
  800b57:	eb 20                	jmp    800b79 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b59:	ff 75 14             	pushl  0x14(%ebp)
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	68 ef 0a 80 00       	push   $0x800aef
  800b68:	e8 92 fb ff ff       	call   8006ff <vprintfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b81:	8d 45 10             	lea    0x10(%ebp),%eax
  800b84:	83 c0 04             	add    $0x4,%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 89 ff ff ff       	call   800b25 <vsnprintf>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb4:	eb 06                	jmp    800bbc <strlen+0x15>
		n++;
  800bb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	ff 45 08             	incl   0x8(%ebp)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	75 f1                	jne    800bb6 <strlen+0xf>
		n++;
	return n;
  800bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd7:	eb 09                	jmp    800be2 <strnlen+0x18>
		n++;
  800bd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdc:	ff 45 08             	incl   0x8(%ebp)
  800bdf:	ff 4d 0c             	decl   0xc(%ebp)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 09                	je     800bf1 <strnlen+0x27>
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e8                	jne    800bd9 <strnlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c02:	90                   	nop
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	75 e4                	jne    800c03 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 1f                	jmp    800c58 <strncpy+0x34>
		*dst++ = *src;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 03                	je     800c55 <strncpy+0x31>
			src++;
  800c52:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5e:	72 d9                	jb     800c39 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 30                	je     800ca7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c77:	eb 16                	jmp    800c8f <strlcpy+0x2a>
			*dst++ = *src++;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8b:	8a 12                	mov    (%edx),%dl
  800c8d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8f:	ff 4d 10             	decl   0x10(%ebp)
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 09                	je     800ca1 <strlcpy+0x3c>
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	84 c0                	test   %al,%al
  800c9f:	75 d8                	jne    800c79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	29 c2                	sub    %eax,%edx
  800caf:	89 d0                	mov    %edx,%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb6:	eb 06                	jmp    800cbe <strcmp+0xb>
		p++, q++;
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 0e                	je     800cd5 <strcmp+0x22>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	38 c2                	cmp    %al,%dl
  800cd3:	74 e3                	je     800cb8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	0f b6 d0             	movzbl %al,%edx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cee:	eb 09                	jmp    800cf9 <strncmp+0xe>
		n--, p++, q++;
  800cf0:	ff 4d 10             	decl   0x10(%ebp)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	74 17                	je     800d16 <strncmp+0x2b>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strncmp+0x2b>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 da                	je     800cf0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	75 07                	jne    800d23 <strncmp+0x38>
		return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	eb 14                	jmp    800d37 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 04             	sub    $0x4,%esp
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d45:	eb 12                	jmp    800d59 <strchr+0x20>
		if (*s == c)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4f:	75 05                	jne    800d56 <strchr+0x1d>
			return (char *) s;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	eb 11                	jmp    800d67 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 e5                	jne    800d47 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 0d                	jmp    800d84 <strfind+0x1b>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	74 0e                	je     800d8f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	75 ea                	jne    800d77 <strfind+0xe>
  800d8d:	eb 01                	jmp    800d90 <strfind+0x27>
		if (*s == c)
			break;
  800d8f:	90                   	nop
	return (char *) s;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da7:	eb 0e                	jmp    800db7 <memset+0x22>
		*p++ = c;
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db7:	ff 4d f8             	decl   -0x8(%ebp)
  800dba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbe:	79 e9                	jns    800da9 <memset+0x14>
		*p++ = c;

	return v;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd7:	eb 16                	jmp    800def <memcpy+0x2a>
		*d++ = *s++;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800deb:	8a 12                	mov    (%edx),%dl
  800ded:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 dd                	jne    800dd9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e19:	73 50                	jae    800e6b <memmove+0x6a>
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e26:	76 43                	jbe    800e6b <memmove+0x6a>
		s += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e34:	eb 10                	jmp    800e46 <memmove+0x45>
			*--d = *--s;
  800e36:	ff 4d f8             	decl   -0x8(%ebp)
  800e39:	ff 4d fc             	decl   -0x4(%ebp)
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	8a 10                	mov    (%eax),%dl
  800e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e44:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e3                	jne    800e36 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e53:	eb 23                	jmp    800e78 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e67:	8a 12                	mov    (%edx),%dl
  800e69:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 dd                	jne    800e55 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8f:	eb 2a                	jmp    800ebb <memcmp+0x3e>
		if (*s1 != *s2)
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	8a 10                	mov    (%eax),%dl
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	38 c2                	cmp    %al,%dl
  800e9d:	74 16                	je     800eb5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f b6 d0             	movzbl %al,%edx
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 c0             	movzbl %al,%eax
  800eaf:	29 c2                	sub    %eax,%edx
  800eb1:	89 d0                	mov    %edx,%eax
  800eb3:	eb 18                	jmp    800ecd <memcmp+0x50>
		s1++, s2++;
  800eb5:	ff 45 fc             	incl   -0x4(%ebp)
  800eb8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 c9                	jne    800e91 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee0:	eb 15                	jmp    800ef7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	39 c2                	cmp    %eax,%edx
  800ef2:	74 0d                	je     800f01 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efd:	72 e3                	jb     800ee2 <memfind+0x13>
  800eff:	eb 01                	jmp    800f02 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f01:	90                   	nop
	return (void *) s;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	eb 03                	jmp    800f20 <strtol+0x19>
		s++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 20                	cmp    $0x20,%al
  800f27:	74 f4                	je     800f1d <strtol+0x16>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 09                	cmp    $0x9,%al
  800f30:	74 eb                	je     800f1d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 2b                	cmp    $0x2b,%al
  800f39:	75 05                	jne    800f40 <strtol+0x39>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	eb 13                	jmp    800f53 <strtol+0x4c>
	else if (*s == '-')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2d                	cmp    $0x2d,%al
  800f47:	75 0a                	jne    800f53 <strtol+0x4c>
		s++, neg = 1;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 06                	je     800f5f <strtol+0x58>
  800f59:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5d:	75 20                	jne    800f7f <strtol+0x78>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 30                	cmp    $0x30,%al
  800f66:	75 17                	jne    800f7f <strtol+0x78>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	40                   	inc    %eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	3c 78                	cmp    $0x78,%al
  800f70:	75 0d                	jne    800f7f <strtol+0x78>
		s += 2, base = 16;
  800f72:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f76:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7d:	eb 28                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 15                	jne    800f9a <strtol+0x93>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 30                	cmp    $0x30,%al
  800f8c:	75 0c                	jne    800f9a <strtol+0x93>
		s++, base = 8;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f98:	eb 0d                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0)
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	75 07                	jne    800fa7 <strtol+0xa0>
		base = 10;
  800fa0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 2f                	cmp    $0x2f,%al
  800fae:	7e 19                	jle    800fc9 <strtol+0xc2>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 39                	cmp    $0x39,%al
  800fb7:	7f 10                	jg     800fc9 <strtol+0xc2>
			dig = *s - '0';
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 30             	sub    $0x30,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc7:	eb 42                	jmp    80100b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 60                	cmp    $0x60,%al
  800fd0:	7e 19                	jle    800feb <strtol+0xe4>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 7a                	cmp    $0x7a,%al
  800fd9:	7f 10                	jg     800feb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	83 e8 57             	sub    $0x57,%eax
  800fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe9:	eb 20                	jmp    80100b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 40                	cmp    $0x40,%al
  800ff2:	7e 39                	jle    80102d <strtol+0x126>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 5a                	cmp    $0x5a,%al
  800ffb:	7f 30                	jg     80102d <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 37             	sub    $0x37,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801011:	7d 19                	jge    80102c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801027:	e9 7b ff ff ff       	jmp    800fa7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801031:	74 08                	je     80103b <strtol+0x134>
		*endptr = (char *) s;
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103f:	74 07                	je     801048 <strtol+0x141>
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	f7 d8                	neg    %eax
  801046:	eb 03                	jmp    80104b <strtol+0x144>
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <ltostr>:

void
ltostr(long value, char *str)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801065:	79 13                	jns    80107a <ltostr+0x2d>
	{
		neg = 1;
  801067:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801074:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801077:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801082:	99                   	cltd   
  801083:	f7 f9                	idiv   %ecx
  801085:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801091:	89 c2                	mov    %eax,%edx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109b:	83 c2 30             	add    $0x30,%edx
  80109e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a8:	f7 e9                	imul   %ecx
  8010aa:	c1 fa 02             	sar    $0x2,%edx
  8010ad:	89 c8                	mov    %ecx,%eax
  8010af:	c1 f8 1f             	sar    $0x1f,%eax
  8010b2:	29 c2                	sub    %eax,%edx
  8010b4:	89 d0                	mov    %edx,%eax
  8010b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	c1 e0 02             	shl    $0x2,%eax
  8010d2:	01 d0                	add    %edx,%eax
  8010d4:	01 c0                	add    %eax,%eax
  8010d6:	29 c1                	sub    %eax,%ecx
  8010d8:	89 ca                	mov    %ecx,%edx
  8010da:	85 d2                	test   %edx,%edx
  8010dc:	75 9c                	jne    80107a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	48                   	dec    %eax
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 3d                	je     80112f <ltostr+0xe2>
		start = 1 ;
  8010f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f9:	eb 34                	jmp    80112f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 c2                	add    %eax,%edx
  801124:	8a 45 eb             	mov    -0x15(%ebp),%al
  801127:	88 02                	mov    %al,(%edx)
		start++ ;
  801129:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c c4                	jl     8010fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801137:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 54 fa ff ff       	call   800ba7 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 46 fa ff ff       	call   800ba7 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801175:	eb 17                	jmp    80118e <strcconcat+0x49>
		final[s] = str1[s] ;
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c8                	add    %ecx,%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801191:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801194:	7c e1                	jl     801177 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a4:	eb 1f                	jmp    8011c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c2:	ff 45 f8             	incl   -0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c d9                	jl     8011a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	eb 0c                	jmp    80120c <strsplit+0x31>
			*string++ = 0;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 08             	mov    %edx,0x8(%ebp)
  801209:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 18                	je     80122d <strsplit+0x52>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 13 fb ff ff       	call   800d39 <strchr>
  801226:	83 c4 08             	add    $0x8,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 d3                	jne    801200 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 5a                	je     801290 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	83 f8 0f             	cmp    $0xf,%eax
  80123e:	75 07                	jne    801247 <strsplit+0x6c>
		{
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 66                	jmp    8012ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 14             	mov    0x14(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	eb 03                	jmp    80126a <strsplit+0x8f>
			string++;
  801267:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	74 8b                	je     8011fe <strsplit+0x23>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 b5 fa ff ff       	call   800d39 <strchr>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	74 dc                	je     801267 <strsplit+0x8c>
			string++;
	}
  80128b:	e9 6e ff ff ff       	jmp    8011fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801290:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 1f                	je     8012dd <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012be:	e8 1d 00 00 00       	call   8012e0 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	68 50 39 80 00       	push   $0x803950
  8012cb:	e8 55 f2 ff ff       	call   800525 <cprintf>
  8012d0:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d3:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012da:	00 00 00 
	}
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8012e6:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012ed:	00 00 00 
  8012f0:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012f7:	00 00 00 
  8012fa:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801301:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801304:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80130b:	00 00 00 
  80130e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801315:	00 00 00 
  801318:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80131f:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801322:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801329:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80132c:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801333:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80133a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801342:	2d 00 10 00 00       	sub    $0x1000,%eax
  801347:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80134c:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801353:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801356:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801360:	83 ec 04             	sub    $0x4,%esp
  801363:	6a 06                	push   $0x6
  801365:	ff 75 f4             	pushl  -0xc(%ebp)
  801368:	50                   	push   %eax
  801369:	e8 ee 05 00 00       	call   80195c <sys_allocate_chunk>
  80136e:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801371:	a1 20 41 80 00       	mov    0x804120,%eax
  801376:	83 ec 0c             	sub    $0xc,%esp
  801379:	50                   	push   %eax
  80137a:	e8 63 0c 00 00       	call   801fe2 <initialize_MemBlocksList>
  80137f:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801382:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801387:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  80138a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80138d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801397:	8b 40 0c             	mov    0xc(%eax),%eax
  80139a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80139d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a5:	89 c2                	mov    %eax,%edx
  8013a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013aa:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8013ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8013b7:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c1:	8b 50 08             	mov    0x8(%eax),%edx
  8013c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	48                   	dec    %eax
  8013ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d5:	f7 75 e0             	divl   -0x20(%ebp)
  8013d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013db:	29 d0                	sub    %edx,%eax
  8013dd:	89 c2                	mov    %eax,%edx
  8013df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e2:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8013e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8013e9:	75 14                	jne    8013ff <initialize_dyn_block_system+0x11f>
  8013eb:	83 ec 04             	sub    $0x4,%esp
  8013ee:	68 75 39 80 00       	push   $0x803975
  8013f3:	6a 34                	push   $0x34
  8013f5:	68 93 39 80 00       	push   $0x803993
  8013fa:	e8 72 ee ff ff       	call   800271 <_panic>
  8013ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	85 c0                	test   %eax,%eax
  801406:	74 10                	je     801418 <initialize_dyn_block_system+0x138>
  801408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140b:	8b 00                	mov    (%eax),%eax
  80140d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801410:	8b 52 04             	mov    0x4(%edx),%edx
  801413:	89 50 04             	mov    %edx,0x4(%eax)
  801416:	eb 0b                	jmp    801423 <initialize_dyn_block_system+0x143>
  801418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80141b:	8b 40 04             	mov    0x4(%eax),%eax
  80141e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801426:	8b 40 04             	mov    0x4(%eax),%eax
  801429:	85 c0                	test   %eax,%eax
  80142b:	74 0f                	je     80143c <initialize_dyn_block_system+0x15c>
  80142d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801430:	8b 40 04             	mov    0x4(%eax),%eax
  801433:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801436:	8b 12                	mov    (%edx),%edx
  801438:	89 10                	mov    %edx,(%eax)
  80143a:	eb 0a                	jmp    801446 <initialize_dyn_block_system+0x166>
  80143c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143f:	8b 00                	mov    (%eax),%eax
  801441:	a3 48 41 80 00       	mov    %eax,0x804148
  801446:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801449:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80144f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801452:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801459:	a1 54 41 80 00       	mov    0x804154,%eax
  80145e:	48                   	dec    %eax
  80145f:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801464:	83 ec 0c             	sub    $0xc,%esp
  801467:	ff 75 e8             	pushl  -0x18(%ebp)
  80146a:	e8 c4 13 00 00       	call   802833 <insert_sorted_with_merge_freeList>
  80146f:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801472:	90                   	nop
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80147b:	e8 2f fe ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  801480:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801484:	75 07                	jne    80148d <malloc+0x18>
  801486:	b8 00 00 00 00       	mov    $0x0,%eax
  80148b:	eb 71                	jmp    8014fe <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80148d:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801494:	76 07                	jbe    80149d <malloc+0x28>
	return NULL;
  801496:	b8 00 00 00 00       	mov    $0x0,%eax
  80149b:	eb 61                	jmp    8014fe <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80149d:	e8 88 08 00 00       	call   801d2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	74 53                	je     8014f9 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8014a6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b3:	01 d0                	add    %edx,%eax
  8014b5:	48                   	dec    %eax
  8014b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c1:	f7 75 f4             	divl   -0xc(%ebp)
  8014c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c7:	29 d0                	sub    %edx,%eax
  8014c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8014d2:	e8 d2 0d 00 00       	call   8022a9 <alloc_block_FF>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8014dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014e1:	74 16                	je     8014f9 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8014e3:	83 ec 0c             	sub    $0xc,%esp
  8014e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8014e9:	e8 0c 0c 00 00       	call   8020fa <insert_sorted_allocList>
  8014ee:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8014f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f4:	8b 40 08             	mov    0x8(%eax),%eax
  8014f7:	eb 05                	jmp    8014fe <malloc+0x89>
    }

			}


	return NULL;
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801514:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801517:	83 ec 08             	sub    $0x8,%esp
  80151a:	ff 75 f0             	pushl  -0x10(%ebp)
  80151d:	68 40 40 80 00       	push   $0x804040
  801522:	e8 a0 0b 00 00       	call   8020c7 <find_block>
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80152d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801530:	8b 50 0c             	mov    0xc(%eax),%edx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	e8 e4 03 00 00       	call   801924 <sys_free_user_mem>
  801540:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801543:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801547:	75 17                	jne    801560 <free+0x60>
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 75 39 80 00       	push   $0x803975
  801551:	68 84 00 00 00       	push   $0x84
  801556:	68 93 39 80 00       	push   $0x803993
  80155b:	e8 11 ed ff ff       	call   800271 <_panic>
  801560:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	85 c0                	test   %eax,%eax
  801567:	74 10                	je     801579 <free+0x79>
  801569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156c:	8b 00                	mov    (%eax),%eax
  80156e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801571:	8b 52 04             	mov    0x4(%edx),%edx
  801574:	89 50 04             	mov    %edx,0x4(%eax)
  801577:	eb 0b                	jmp    801584 <free+0x84>
  801579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157c:	8b 40 04             	mov    0x4(%eax),%eax
  80157f:	a3 44 40 80 00       	mov    %eax,0x804044
  801584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801587:	8b 40 04             	mov    0x4(%eax),%eax
  80158a:	85 c0                	test   %eax,%eax
  80158c:	74 0f                	je     80159d <free+0x9d>
  80158e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801591:	8b 40 04             	mov    0x4(%eax),%eax
  801594:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801597:	8b 12                	mov    (%edx),%edx
  801599:	89 10                	mov    %edx,(%eax)
  80159b:	eb 0a                	jmp    8015a7 <free+0xa7>
  80159d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a0:	8b 00                	mov    (%eax),%eax
  8015a2:	a3 40 40 80 00       	mov    %eax,0x804040
  8015a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015bf:	48                   	dec    %eax
  8015c0:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8015cb:	e8 63 12 00 00       	call   802833 <insert_sorted_with_merge_freeList>
  8015d0:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 38             	sub    $0x38,%esp
  8015dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015df:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e2:	e8 c8 fc ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  8015e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015eb:	75 0a                	jne    8015f7 <smalloc+0x21>
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	e9 a0 00 00 00       	jmp    801697 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8015f7:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8015fe:	76 0a                	jbe    80160a <smalloc+0x34>
		return NULL;
  801600:	b8 00 00 00 00       	mov    $0x0,%eax
  801605:	e9 8d 00 00 00       	jmp    801697 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80160a:	e8 1b 07 00 00       	call   801d2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160f:	85 c0                	test   %eax,%eax
  801611:	74 7f                	je     801692 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801613:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80161a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801620:	01 d0                	add    %edx,%eax
  801622:	48                   	dec    %eax
  801623:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801629:	ba 00 00 00 00       	mov    $0x0,%edx
  80162e:	f7 75 f4             	divl   -0xc(%ebp)
  801631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801634:	29 d0                	sub    %edx,%eax
  801636:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801639:	83 ec 0c             	sub    $0xc,%esp
  80163c:	ff 75 ec             	pushl  -0x14(%ebp)
  80163f:	e8 65 0c 00 00       	call   8022a9 <alloc_block_FF>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80164a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80164e:	74 42                	je     801692 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	ff 75 e8             	pushl  -0x18(%ebp)
  801656:	e8 9f 0a 00 00       	call   8020fa <insert_sorted_allocList>
  80165b:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80165e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801661:	8b 40 08             	mov    0x8(%eax),%eax
  801664:	89 c2                	mov    %eax,%edx
  801666:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80166a:	52                   	push   %edx
  80166b:	50                   	push   %eax
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	e8 38 04 00 00       	call   801aaf <sys_createSharedObject>
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  80167d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801681:	79 07                	jns    80168a <smalloc+0xb4>
	    		  return NULL;
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	eb 0d                	jmp    801697 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80168a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80168d:	8b 40 08             	mov    0x8(%eax),%eax
  801690:	eb 05                	jmp    801697 <smalloc+0xc1>


				}


		return NULL;
  801692:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80169f:	e8 0b fc ff ff       	call   8012af <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016a4:	e8 81 06 00 00       	call   801d2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	0f 84 9f 00 00 00    	je     801750 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016b1:	83 ec 08             	sub    $0x8,%esp
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	ff 75 08             	pushl  0x8(%ebp)
  8016ba:	e8 1a 04 00 00       	call   801ad9 <sys_getSizeOfSharedObject>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8016c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c9:	79 0a                	jns    8016d5 <sget+0x3c>
		return NULL;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d0:	e9 80 00 00 00       	jmp    801755 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016d5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	48                   	dec    %eax
  8016e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f0:	f7 75 f0             	divl   -0x10(%ebp)
  8016f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f6:	29 d0                	sub    %edx,%eax
  8016f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8016fb:	83 ec 0c             	sub    $0xc,%esp
  8016fe:	ff 75 e8             	pushl  -0x18(%ebp)
  801701:	e8 a3 0b 00 00       	call   8022a9 <alloc_block_FF>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80170c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801710:	74 3e                	je     801750 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	ff 75 e4             	pushl  -0x1c(%ebp)
  801718:	e8 dd 09 00 00       	call   8020fa <insert_sorted_allocList>
  80171d:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801723:	8b 40 08             	mov    0x8(%eax),%eax
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	50                   	push   %eax
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	e8 c1 03 00 00       	call   801af6 <sys_getSharedObject>
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80173b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80173f:	79 07                	jns    801748 <sget+0xaf>
	    		  return NULL;
  801741:	b8 00 00 00 00       	mov    $0x0,%eax
  801746:	eb 0d                	jmp    801755 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80174b:	8b 40 08             	mov    0x8(%eax),%eax
  80174e:	eb 05                	jmp    801755 <sget+0xbc>
	      }
	}
	   return NULL;
  801750:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80175d:	e8 4d fb ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 a0 39 80 00       	push   $0x8039a0
  80176a:	68 12 01 00 00       	push   $0x112
  80176f:	68 93 39 80 00       	push   $0x803993
  801774:	e8 f8 ea ff ff       	call   800271 <_panic>

00801779 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	68 c8 39 80 00       	push   $0x8039c8
  801787:	68 26 01 00 00       	push   $0x126
  80178c:	68 93 39 80 00       	push   $0x803993
  801791:	e8 db ea ff ff       	call   800271 <_panic>

00801796 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179c:	83 ec 04             	sub    $0x4,%esp
  80179f:	68 ec 39 80 00       	push   $0x8039ec
  8017a4:	68 31 01 00 00       	push   $0x131
  8017a9:	68 93 39 80 00       	push   $0x803993
  8017ae:	e8 be ea ff ff       	call   800271 <_panic>

008017b3 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	68 ec 39 80 00       	push   $0x8039ec
  8017c1:	68 36 01 00 00       	push   $0x136
  8017c6:	68 93 39 80 00       	push   $0x803993
  8017cb:	e8 a1 ea ff ff       	call   800271 <_panic>

008017d0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	68 ec 39 80 00       	push   $0x8039ec
  8017de:	68 3b 01 00 00       	push   $0x13b
  8017e3:	68 93 39 80 00       	push   $0x803993
  8017e8:	e8 84 ea ff ff       	call   800271 <_panic>

008017ed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	57                   	push   %edi
  8017f1:	56                   	push   %esi
  8017f2:	53                   	push   %ebx
  8017f3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801802:	8b 7d 18             	mov    0x18(%ebp),%edi
  801805:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801808:	cd 30                	int    $0x30
  80180a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	8b 45 10             	mov    0x10(%ebp),%eax
  801821:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801824:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	52                   	push   %edx
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	50                   	push   %eax
  801834:	6a 00                	push   $0x0
  801836:	e8 b2 ff ff ff       	call   8017ed <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	90                   	nop
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_cgetc>:

int
sys_cgetc(void)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 01                	push   $0x1
  801850:	e8 98 ff ff ff       	call   8017ed <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	52                   	push   %edx
  80186a:	50                   	push   %eax
  80186b:	6a 05                	push   $0x5
  80186d:	e8 7b ff ff ff       	call   8017ed <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80187c:	8b 75 18             	mov    0x18(%ebp),%esi
  80187f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801882:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801885:	8b 55 0c             	mov    0xc(%ebp),%edx
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	56                   	push   %esi
  80188c:	53                   	push   %ebx
  80188d:	51                   	push   %ecx
  80188e:	52                   	push   %edx
  80188f:	50                   	push   %eax
  801890:	6a 06                	push   $0x6
  801892:	e8 56 ff ff ff       	call   8017ed <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    

008018a1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	52                   	push   %edx
  8018b1:	50                   	push   %eax
  8018b2:	6a 07                	push   $0x7
  8018b4:	e8 34 ff ff ff       	call   8017ed <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	ff 75 08             	pushl  0x8(%ebp)
  8018cd:	6a 08                	push   $0x8
  8018cf:	e8 19 ff ff ff       	call   8017ed <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 09                	push   $0x9
  8018e8:	e8 00 ff ff ff       	call   8017ed <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 0a                	push   $0xa
  801901:	e8 e7 fe ff ff       	call   8017ed <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 0b                	push   $0xb
  80191a:	e8 ce fe ff ff       	call   8017ed <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	ff 75 08             	pushl  0x8(%ebp)
  801933:	6a 0f                	push   $0xf
  801935:	e8 b3 fe ff ff       	call   8017ed <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
	return;
  80193d:	90                   	nop
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	6a 10                	push   $0x10
  801951:	e8 97 fe ff ff       	call   8017ed <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return ;
  801959:	90                   	nop
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	ff 75 10             	pushl  0x10(%ebp)
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	ff 75 08             	pushl  0x8(%ebp)
  80196c:	6a 11                	push   $0x11
  80196e:	e8 7a fe ff ff       	call   8017ed <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
	return ;
  801976:	90                   	nop
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 0c                	push   $0xc
  801988:	e8 60 fe ff ff       	call   8017ed <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 0d                	push   $0xd
  8019a2:	e8 46 fe ff ff       	call   8017ed <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 0e                	push   $0xe
  8019bb:	e8 2d fe ff ff       	call   8017ed <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	90                   	nop
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 13                	push   $0x13
  8019d5:	e8 13 fe ff ff       	call   8017ed <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	90                   	nop
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 14                	push   $0x14
  8019ef:	e8 f9 fd ff ff       	call   8017ed <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_cputc>:


void
sys_cputc(const char c)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a06:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	50                   	push   %eax
  801a13:	6a 15                	push   $0x15
  801a15:	e8 d3 fd ff ff       	call   8017ed <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	90                   	nop
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 16                	push   $0x16
  801a2f:	e8 b9 fd ff ff       	call   8017ed <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	50                   	push   %eax
  801a4a:	6a 17                	push   $0x17
  801a4c:	e8 9c fd ff ff       	call   8017ed <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 1a                	push   $0x1a
  801a69:	e8 7f fd ff ff       	call   8017ed <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	52                   	push   %edx
  801a83:	50                   	push   %eax
  801a84:	6a 18                	push   $0x18
  801a86:	e8 62 fd ff ff       	call   8017ed <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	90                   	nop
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 19                	push   $0x19
  801aa4:	e8 44 fd ff ff       	call   8017ed <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801abb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	51                   	push   %ecx
  801ac8:	52                   	push   %edx
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	50                   	push   %eax
  801acd:	6a 1b                	push   $0x1b
  801acf:	e8 19 fd ff ff       	call   8017ed <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 1c                	push   $0x1c
  801aec:	e8 fc fc ff ff       	call   8017ed <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	51                   	push   %ecx
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 1d                	push   $0x1d
  801b0b:	e8 dd fc ff ff       	call   8017ed <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 1e                	push   $0x1e
  801b28:	e8 c0 fc ff ff       	call   8017ed <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 1f                	push   $0x1f
  801b41:	e8 a7 fc ff ff       	call   8017ed <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	ff 75 14             	pushl  0x14(%ebp)
  801b56:	ff 75 10             	pushl  0x10(%ebp)
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	50                   	push   %eax
  801b5d:	6a 20                	push   $0x20
  801b5f:	e8 89 fc ff ff       	call   8017ed <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	50                   	push   %eax
  801b78:	6a 21                	push   $0x21
  801b7a:	e8 6e fc ff ff       	call   8017ed <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	50                   	push   %eax
  801b94:	6a 22                	push   $0x22
  801b96:	e8 52 fc ff ff       	call   8017ed <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 02                	push   $0x2
  801baf:	e8 39 fc ff ff       	call   8017ed <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 03                	push   $0x3
  801bc8:	e8 20 fc ff ff       	call   8017ed <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 04                	push   $0x4
  801be1:	e8 07 fc ff ff       	call   8017ed <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_exit_env>:


void sys_exit_env(void)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 23                	push   $0x23
  801bfa:	e8 ee fb ff ff       	call   8017ed <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	90                   	nop
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0e:	8d 50 04             	lea    0x4(%eax),%edx
  801c11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	52                   	push   %edx
  801c1b:	50                   	push   %eax
  801c1c:	6a 24                	push   $0x24
  801c1e:	e8 ca fb ff ff       	call   8017ed <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return result;
  801c26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c2f:	89 01                	mov    %eax,(%ecx)
  801c31:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	c9                   	leave  
  801c38:	c2 04 00             	ret    $0x4

00801c3b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	ff 75 10             	pushl  0x10(%ebp)
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	6a 12                	push   $0x12
  801c4d:	e8 9b fb ff ff       	call   8017ed <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return ;
  801c55:	90                   	nop
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 25                	push   $0x25
  801c67:	e8 81 fb ff ff       	call   8017ed <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c7d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	50                   	push   %eax
  801c8a:	6a 26                	push   $0x26
  801c8c:	e8 5c fb ff ff       	call   8017ed <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
	return ;
  801c94:	90                   	nop
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <rsttst>:
void rsttst()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 28                	push   $0x28
  801ca6:	e8 42 fb ff ff       	call   8017ed <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
	return ;
  801cae:	90                   	nop
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cbd:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc4:	52                   	push   %edx
  801cc5:	50                   	push   %eax
  801cc6:	ff 75 10             	pushl  0x10(%ebp)
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	ff 75 08             	pushl  0x8(%ebp)
  801ccf:	6a 27                	push   $0x27
  801cd1:	e8 17 fb ff ff       	call   8017ed <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd9:	90                   	nop
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <chktst>:
void chktst(uint32 n)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	ff 75 08             	pushl  0x8(%ebp)
  801cea:	6a 29                	push   $0x29
  801cec:	e8 fc fa ff ff       	call   8017ed <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <inctst>:

void inctst()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 2a                	push   $0x2a
  801d06:	e8 e2 fa ff ff       	call   8017ed <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0e:	90                   	nop
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <gettst>:
uint32 gettst()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 2b                	push   $0x2b
  801d20:	e8 c8 fa ff ff       	call   8017ed <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 2c                	push   $0x2c
  801d3c:	e8 ac fa ff ff       	call   8017ed <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
  801d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d47:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d4b:	75 07                	jne    801d54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d52:	eb 05                	jmp    801d59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 2c                	push   $0x2c
  801d6d:	e8 7b fa ff ff       	call   8017ed <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
  801d75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d78:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d7c:	75 07                	jne    801d85 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d83:	eb 05                	jmp    801d8a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 2c                	push   $0x2c
  801d9e:	e8 4a fa ff ff       	call   8017ed <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
  801da6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dad:	75 07                	jne    801db6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801daf:	b8 01 00 00 00       	mov    $0x1,%eax
  801db4:	eb 05                	jmp    801dbb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 2c                	push   $0x2c
  801dcf:	e8 19 fa ff ff       	call   8017ed <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dda:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dde:	75 07                	jne    801de7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de0:	b8 01 00 00 00       	mov    $0x1,%eax
  801de5:	eb 05                	jmp    801dec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	6a 2d                	push   $0x2d
  801dfe:	e8 ea f9 ff ff       	call   8017ed <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
	return ;
  801e06:	90                   	nop
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	6a 00                	push   $0x0
  801e1b:	53                   	push   %ebx
  801e1c:	51                   	push   %ecx
  801e1d:	52                   	push   %edx
  801e1e:	50                   	push   %eax
  801e1f:	6a 2e                	push   $0x2e
  801e21:	e8 c7 f9 ff ff       	call   8017ed <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	52                   	push   %edx
  801e3e:	50                   	push   %eax
  801e3f:	6a 2f                	push   $0x2f
  801e41:	e8 a7 f9 ff ff       	call   8017ed <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	68 fc 39 80 00       	push   $0x8039fc
  801e59:	e8 c7 e6 ff ff       	call   800525 <cprintf>
  801e5e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	68 28 3a 80 00       	push   $0x803a28
  801e70:	e8 b0 e6 ff ff       	call   800525 <cprintf>
  801e75:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e78:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e7c:	a1 38 41 80 00       	mov    0x804138,%eax
  801e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e84:	eb 56                	jmp    801edc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8a:	74 1c                	je     801ea8 <print_mem_block_lists+0x5d>
  801e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8f:	8b 50 08             	mov    0x8(%eax),%edx
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e95:	8b 48 08             	mov    0x8(%eax),%ecx
  801e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9e:	01 c8                	add    %ecx,%eax
  801ea0:	39 c2                	cmp    %eax,%edx
  801ea2:	73 04                	jae    801ea8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ea4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	8b 50 08             	mov    0x8(%eax),%edx
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb4:	01 c2                	add    %eax,%edx
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	8b 40 08             	mov    0x8(%eax),%eax
  801ebc:	83 ec 04             	sub    $0x4,%esp
  801ebf:	52                   	push   %edx
  801ec0:	50                   	push   %eax
  801ec1:	68 3d 3a 80 00       	push   $0x803a3d
  801ec6:	e8 5a e6 ff ff       	call   800525 <cprintf>
  801ecb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed4:	a1 40 41 80 00       	mov    0x804140,%eax
  801ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee0:	74 07                	je     801ee9 <print_mem_block_lists+0x9e>
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	eb 05                	jmp    801eee <print_mem_block_lists+0xa3>
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eee:	a3 40 41 80 00       	mov    %eax,0x804140
  801ef3:	a1 40 41 80 00       	mov    0x804140,%eax
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	75 8a                	jne    801e86 <print_mem_block_lists+0x3b>
  801efc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f00:	75 84                	jne    801e86 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f02:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f06:	75 10                	jne    801f18 <print_mem_block_lists+0xcd>
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	68 4c 3a 80 00       	push   $0x803a4c
  801f10:	e8 10 e6 ff ff       	call   800525 <cprintf>
  801f15:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f1f:	83 ec 0c             	sub    $0xc,%esp
  801f22:	68 70 3a 80 00       	push   $0x803a70
  801f27:	e8 f9 e5 ff ff       	call   800525 <cprintf>
  801f2c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f2f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f33:	a1 40 40 80 00       	mov    0x804040,%eax
  801f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3b:	eb 56                	jmp    801f93 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f41:	74 1c                	je     801f5f <print_mem_block_lists+0x114>
  801f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f46:	8b 50 08             	mov    0x8(%eax),%edx
  801f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f52:	8b 40 0c             	mov    0xc(%eax),%eax
  801f55:	01 c8                	add    %ecx,%eax
  801f57:	39 c2                	cmp    %eax,%edx
  801f59:	73 04                	jae    801f5f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f5b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	8b 50 08             	mov    0x8(%eax),%edx
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6b:	01 c2                	add    %eax,%edx
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	8b 40 08             	mov    0x8(%eax),%eax
  801f73:	83 ec 04             	sub    $0x4,%esp
  801f76:	52                   	push   %edx
  801f77:	50                   	push   %eax
  801f78:	68 3d 3a 80 00       	push   $0x803a3d
  801f7d:	e8 a3 e5 ff ff       	call   800525 <cprintf>
  801f82:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8b:	a1 48 40 80 00       	mov    0x804048,%eax
  801f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f97:	74 07                	je     801fa0 <print_mem_block_lists+0x155>
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 00                	mov    (%eax),%eax
  801f9e:	eb 05                	jmp    801fa5 <print_mem_block_lists+0x15a>
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	a3 48 40 80 00       	mov    %eax,0x804048
  801faa:	a1 48 40 80 00       	mov    0x804048,%eax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	75 8a                	jne    801f3d <print_mem_block_lists+0xf2>
  801fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb7:	75 84                	jne    801f3d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fb9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fbd:	75 10                	jne    801fcf <print_mem_block_lists+0x184>
  801fbf:	83 ec 0c             	sub    $0xc,%esp
  801fc2:	68 88 3a 80 00       	push   $0x803a88
  801fc7:	e8 59 e5 ff ff       	call   800525 <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	68 fc 39 80 00       	push   $0x8039fc
  801fd7:	e8 49 e5 ff ff       	call   800525 <cprintf>
  801fdc:	83 c4 10             	add    $0x10,%esp

}
  801fdf:	90                   	nop
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  801fe8:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fef:	00 00 00 
  801ff2:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ff9:	00 00 00 
  801ffc:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802003:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802006:	a1 50 40 80 00       	mov    0x804050,%eax
  80200b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80200e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802015:	e9 9e 00 00 00       	jmp    8020b8 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80201a:	a1 50 40 80 00       	mov    0x804050,%eax
  80201f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802022:	c1 e2 04             	shl    $0x4,%edx
  802025:	01 d0                	add    %edx,%eax
  802027:	85 c0                	test   %eax,%eax
  802029:	75 14                	jne    80203f <initialize_MemBlocksList+0x5d>
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	68 b0 3a 80 00       	push   $0x803ab0
  802033:	6a 48                	push   $0x48
  802035:	68 d3 3a 80 00       	push   $0x803ad3
  80203a:	e8 32 e2 ff ff       	call   800271 <_panic>
  80203f:	a1 50 40 80 00       	mov    0x804050,%eax
  802044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802047:	c1 e2 04             	shl    $0x4,%edx
  80204a:	01 d0                	add    %edx,%eax
  80204c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802052:	89 10                	mov    %edx,(%eax)
  802054:	8b 00                	mov    (%eax),%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	74 18                	je     802072 <initialize_MemBlocksList+0x90>
  80205a:	a1 48 41 80 00       	mov    0x804148,%eax
  80205f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802065:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802068:	c1 e1 04             	shl    $0x4,%ecx
  80206b:	01 ca                	add    %ecx,%edx
  80206d:	89 50 04             	mov    %edx,0x4(%eax)
  802070:	eb 12                	jmp    802084 <initialize_MemBlocksList+0xa2>
  802072:	a1 50 40 80 00       	mov    0x804050,%eax
  802077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207a:	c1 e2 04             	shl    $0x4,%edx
  80207d:	01 d0                	add    %edx,%eax
  80207f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802084:	a1 50 40 80 00       	mov    0x804050,%eax
  802089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208c:	c1 e2 04             	shl    $0x4,%edx
  80208f:	01 d0                	add    %edx,%eax
  802091:	a3 48 41 80 00       	mov    %eax,0x804148
  802096:	a1 50 40 80 00       	mov    0x804050,%eax
  80209b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209e:	c1 e2 04             	shl    $0x4,%edx
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020aa:	a1 54 41 80 00       	mov    0x804154,%eax
  8020af:	40                   	inc    %eax
  8020b0:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8020b5:	ff 45 f4             	incl   -0xc(%ebp)
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020be:	0f 82 56 ff ff ff    	jb     80201a <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8020c4:	90                   	nop
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 00                	mov    (%eax),%eax
  8020d2:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8020d5:	eb 18                	jmp    8020ef <find_block+0x28>
		{
			if(tmp->sva==va)
  8020d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020da:	8b 40 08             	mov    0x8(%eax),%eax
  8020dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020e0:	75 05                	jne    8020e7 <find_block+0x20>
			{
				return tmp;
  8020e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e5:	eb 11                	jmp    8020f8 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8020e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ea:	8b 00                	mov    (%eax),%eax
  8020ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8020ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f3:	75 e2                	jne    8020d7 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8020f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802100:	a1 40 40 80 00       	mov    0x804040,%eax
  802105:	85 c0                	test   %eax,%eax
  802107:	0f 85 83 00 00 00    	jne    802190 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80210d:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802114:	00 00 00 
  802117:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80211e:	00 00 00 
  802121:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802128:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80212b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212f:	75 14                	jne    802145 <insert_sorted_allocList+0x4b>
  802131:	83 ec 04             	sub    $0x4,%esp
  802134:	68 b0 3a 80 00       	push   $0x803ab0
  802139:	6a 7f                	push   $0x7f
  80213b:	68 d3 3a 80 00       	push   $0x803ad3
  802140:	e8 2c e1 ff ff       	call   800271 <_panic>
  802145:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	89 10                	mov    %edx,(%eax)
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	8b 00                	mov    (%eax),%eax
  802155:	85 c0                	test   %eax,%eax
  802157:	74 0d                	je     802166 <insert_sorted_allocList+0x6c>
  802159:	a1 40 40 80 00       	mov    0x804040,%eax
  80215e:	8b 55 08             	mov    0x8(%ebp),%edx
  802161:	89 50 04             	mov    %edx,0x4(%eax)
  802164:	eb 08                	jmp    80216e <insert_sorted_allocList+0x74>
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 44 40 80 00       	mov    %eax,0x804044
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	a3 40 40 80 00       	mov    %eax,0x804040
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802180:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802185:	40                   	inc    %eax
  802186:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80218b:	e9 16 01 00 00       	jmp    8022a6 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	8b 50 08             	mov    0x8(%eax),%edx
  802196:	a1 44 40 80 00       	mov    0x804044,%eax
  80219b:	8b 40 08             	mov    0x8(%eax),%eax
  80219e:	39 c2                	cmp    %eax,%edx
  8021a0:	76 68                	jbe    80220a <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8021a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a6:	75 17                	jne    8021bf <insert_sorted_allocList+0xc5>
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	68 ec 3a 80 00       	push   $0x803aec
  8021b0:	68 85 00 00 00       	push   $0x85
  8021b5:	68 d3 3a 80 00       	push   $0x803ad3
  8021ba:	e8 b2 e0 ff ff       	call   800271 <_panic>
  8021bf:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	89 50 04             	mov    %edx,0x4(%eax)
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	8b 40 04             	mov    0x4(%eax),%eax
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	74 0c                	je     8021e1 <insert_sorted_allocList+0xe7>
  8021d5:	a1 44 40 80 00       	mov    0x804044,%eax
  8021da:	8b 55 08             	mov    0x8(%ebp),%edx
  8021dd:	89 10                	mov    %edx,(%eax)
  8021df:	eb 08                	jmp    8021e9 <insert_sorted_allocList+0xef>
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	a3 44 40 80 00       	mov    %eax,0x804044
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021fa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ff:	40                   	inc    %eax
  802200:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802205:	e9 9c 00 00 00       	jmp    8022a6 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  80220a:	a1 40 40 80 00       	mov    0x804040,%eax
  80220f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802212:	e9 85 00 00 00       	jmp    80229c <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8b 50 08             	mov    0x8(%eax),%edx
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 40 08             	mov    0x8(%eax),%eax
  802223:	39 c2                	cmp    %eax,%edx
  802225:	73 6d                	jae    802294 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222b:	74 06                	je     802233 <insert_sorted_allocList+0x139>
  80222d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802231:	75 17                	jne    80224a <insert_sorted_allocList+0x150>
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	68 10 3b 80 00       	push   $0x803b10
  80223b:	68 90 00 00 00       	push   $0x90
  802240:	68 d3 3a 80 00       	push   $0x803ad3
  802245:	e8 27 e0 ff ff       	call   800271 <_panic>
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 50 04             	mov    0x4(%eax),%edx
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	89 50 04             	mov    %edx,0x4(%eax)
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225c:	89 10                	mov    %edx,(%eax)
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 40 04             	mov    0x4(%eax),%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	74 0d                	je     802275 <insert_sorted_allocList+0x17b>
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 40 04             	mov    0x4(%eax),%eax
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
  802271:	89 10                	mov    %edx,(%eax)
  802273:	eb 08                	jmp    80227d <insert_sorted_allocList+0x183>
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	a3 40 40 80 00       	mov    %eax,0x804040
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 55 08             	mov    0x8(%ebp),%edx
  802283:	89 50 04             	mov    %edx,0x4(%eax)
  802286:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80228b:	40                   	inc    %eax
  80228c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802291:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802292:	eb 12                	jmp    8022a6 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 00                	mov    (%eax),%eax
  802299:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  80229c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a0:	0f 85 71 ff ff ff    	jne    802217 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022a6:	90                   	nop
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8022af:	a1 38 41 80 00       	mov    0x804138,%eax
  8022b4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8022b7:	e9 76 01 00 00       	jmp    802432 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c5:	0f 85 8a 00 00 00    	jne    802355 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8022cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cf:	75 17                	jne    8022e8 <alloc_block_FF+0x3f>
  8022d1:	83 ec 04             	sub    $0x4,%esp
  8022d4:	68 45 3b 80 00       	push   $0x803b45
  8022d9:	68 a8 00 00 00       	push   $0xa8
  8022de:	68 d3 3a 80 00       	push   $0x803ad3
  8022e3:	e8 89 df ff ff       	call   800271 <_panic>
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	74 10                	je     802301 <alloc_block_FF+0x58>
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f9:	8b 52 04             	mov    0x4(%edx),%edx
  8022fc:	89 50 04             	mov    %edx,0x4(%eax)
  8022ff:	eb 0b                	jmp    80230c <alloc_block_FF+0x63>
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	85 c0                	test   %eax,%eax
  802314:	74 0f                	je     802325 <alloc_block_FF+0x7c>
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 40 04             	mov    0x4(%eax),%eax
  80231c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231f:	8b 12                	mov    (%edx),%edx
  802321:	89 10                	mov    %edx,(%eax)
  802323:	eb 0a                	jmp    80232f <alloc_block_FF+0x86>
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	a3 38 41 80 00       	mov    %eax,0x804138
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802342:	a1 44 41 80 00       	mov    0x804144,%eax
  802347:	48                   	dec    %eax
  802348:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	e9 ea 00 00 00       	jmp    80243f <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 40 0c             	mov    0xc(%eax),%eax
  80235b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80235e:	0f 86 c6 00 00 00    	jbe    80242a <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802364:	a1 48 41 80 00       	mov    0x804148,%eax
  802369:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  80236c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236f:	8b 55 08             	mov    0x8(%ebp),%edx
  802372:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 50 08             	mov    0x8(%eax),%edx
  80237b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237e:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 40 0c             	mov    0xc(%eax),%eax
  802387:	2b 45 08             	sub    0x8(%ebp),%eax
  80238a:	89 c2                	mov    %eax,%edx
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	01 c2                	add    %eax,%edx
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8023a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a7:	75 17                	jne    8023c0 <alloc_block_FF+0x117>
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 45 3b 80 00       	push   $0x803b45
  8023b1:	68 b6 00 00 00       	push   $0xb6
  8023b6:	68 d3 3a 80 00       	push   $0x803ad3
  8023bb:	e8 b1 de ff ff       	call   800271 <_panic>
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	74 10                	je     8023d9 <alloc_block_FF+0x130>
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d1:	8b 52 04             	mov    0x4(%edx),%edx
  8023d4:	89 50 04             	mov    %edx,0x4(%eax)
  8023d7:	eb 0b                	jmp    8023e4 <alloc_block_FF+0x13b>
  8023d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dc:	8b 40 04             	mov    0x4(%eax),%eax
  8023df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 0f                	je     8023fd <alloc_block_FF+0x154>
  8023ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f1:	8b 40 04             	mov    0x4(%eax),%eax
  8023f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f7:	8b 12                	mov    (%edx),%edx
  8023f9:	89 10                	mov    %edx,(%eax)
  8023fb:	eb 0a                	jmp    802407 <alloc_block_FF+0x15e>
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	a3 48 41 80 00       	mov    %eax,0x804148
  802407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802413:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241a:	a1 54 41 80 00       	mov    0x804154,%eax
  80241f:	48                   	dec    %eax
  802420:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802428:	eb 15                	jmp    80243f <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802436:	0f 85 80 fe ff ff    	jne    8022bc <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802447:	a1 38 41 80 00       	mov    0x804138,%eax
  80244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80244f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802456:	e9 c0 00 00 00       	jmp    80251b <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 40 0c             	mov    0xc(%eax),%eax
  802461:	3b 45 08             	cmp    0x8(%ebp),%eax
  802464:	0f 85 8a 00 00 00    	jne    8024f4 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80246a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246e:	75 17                	jne    802487 <alloc_block_BF+0x46>
  802470:	83 ec 04             	sub    $0x4,%esp
  802473:	68 45 3b 80 00       	push   $0x803b45
  802478:	68 cf 00 00 00       	push   $0xcf
  80247d:	68 d3 3a 80 00       	push   $0x803ad3
  802482:	e8 ea dd ff ff       	call   800271 <_panic>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	74 10                	je     8024a0 <alloc_block_BF+0x5f>
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802498:	8b 52 04             	mov    0x4(%edx),%edx
  80249b:	89 50 04             	mov    %edx,0x4(%eax)
  80249e:	eb 0b                	jmp    8024ab <alloc_block_BF+0x6a>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 04             	mov    0x4(%eax),%eax
  8024a6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 04             	mov    0x4(%eax),%eax
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	74 0f                	je     8024c4 <alloc_block_BF+0x83>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024be:	8b 12                	mov    (%edx),%edx
  8024c0:	89 10                	mov    %edx,(%eax)
  8024c2:	eb 0a                	jmp    8024ce <alloc_block_BF+0x8d>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	a3 38 41 80 00       	mov    %eax,0x804138
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e1:	a1 44 41 80 00       	mov    0x804144,%eax
  8024e6:	48                   	dec    %eax
  8024e7:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	e9 2a 01 00 00       	jmp    80261e <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024fd:	73 14                	jae    802513 <alloc_block_BF+0xd2>
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 40 0c             	mov    0xc(%eax),%eax
  802505:	3b 45 08             	cmp    0x8(%ebp),%eax
  802508:	76 09                	jbe    802513 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 0c             	mov    0xc(%eax),%eax
  802510:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 00                	mov    (%eax),%eax
  802518:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80251b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251f:	0f 85 36 ff ff ff    	jne    80245b <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802525:	a1 38 41 80 00       	mov    0x804138,%eax
  80252a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80252d:	e9 dd 00 00 00       	jmp    80260f <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 40 0c             	mov    0xc(%eax),%eax
  802538:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80253b:	0f 85 c6 00 00 00    	jne    802607 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802541:	a1 48 41 80 00       	mov    0x804148,%eax
  802546:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 50 08             	mov    0x8(%eax),%edx
  80254f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802552:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802558:	8b 55 08             	mov    0x8(%ebp),%edx
  80255b:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 50 08             	mov    0x8(%eax),%edx
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	01 c2                	add    %eax,%edx
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 0c             	mov    0xc(%eax),%eax
  802575:	2b 45 08             	sub    0x8(%ebp),%eax
  802578:	89 c2                	mov    %eax,%edx
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802580:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802584:	75 17                	jne    80259d <alloc_block_BF+0x15c>
  802586:	83 ec 04             	sub    $0x4,%esp
  802589:	68 45 3b 80 00       	push   $0x803b45
  80258e:	68 eb 00 00 00       	push   $0xeb
  802593:	68 d3 3a 80 00       	push   $0x803ad3
  802598:	e8 d4 dc ff ff       	call   800271 <_panic>
  80259d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 10                	je     8025b6 <alloc_block_BF+0x175>
  8025a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ae:	8b 52 04             	mov    0x4(%edx),%edx
  8025b1:	89 50 04             	mov    %edx,0x4(%eax)
  8025b4:	eb 0b                	jmp    8025c1 <alloc_block_BF+0x180>
  8025b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c4:	8b 40 04             	mov    0x4(%eax),%eax
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	74 0f                	je     8025da <alloc_block_BF+0x199>
  8025cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ce:	8b 40 04             	mov    0x4(%eax),%eax
  8025d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d4:	8b 12                	mov    (%edx),%edx
  8025d6:	89 10                	mov    %edx,(%eax)
  8025d8:	eb 0a                	jmp    8025e4 <alloc_block_BF+0x1a3>
  8025da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	a3 48 41 80 00       	mov    %eax,0x804148
  8025e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8025fc:	48                   	dec    %eax
  8025fd:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802605:	eb 17                	jmp    80261e <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80260f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802613:	0f 85 19 ff ff ff    	jne    802532 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802626:	a1 40 40 80 00       	mov    0x804040,%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	75 19                	jne    802648 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	ff 75 08             	pushl  0x8(%ebp)
  802635:	e8 6f fc ff ff       	call   8022a9 <alloc_block_FF>
  80263a:	83 c4 10             	add    $0x10,%esp
  80263d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	e9 e9 01 00 00       	jmp    802831 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802648:	a1 44 40 80 00       	mov    0x804044,%eax
  80264d:	8b 40 08             	mov    0x8(%eax),%eax
  802650:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802653:	a1 44 40 80 00       	mov    0x804044,%eax
  802658:	8b 50 0c             	mov    0xc(%eax),%edx
  80265b:	a1 44 40 80 00       	mov    0x804044,%eax
  802660:	8b 40 08             	mov    0x8(%eax),%eax
  802663:	01 d0                	add    %edx,%eax
  802665:	83 ec 08             	sub    $0x8,%esp
  802668:	50                   	push   %eax
  802669:	68 38 41 80 00       	push   $0x804138
  80266e:	e8 54 fa ff ff       	call   8020c7 <find_block>
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 40 0c             	mov    0xc(%eax),%eax
  80267f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802682:	0f 85 9b 00 00 00    	jne    802723 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 50 0c             	mov    0xc(%eax),%edx
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 08             	mov    0x8(%eax),%eax
  802694:	01 d0                	add    %edx,%eax
  802696:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802699:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269d:	75 17                	jne    8026b6 <alloc_block_NF+0x96>
  80269f:	83 ec 04             	sub    $0x4,%esp
  8026a2:	68 45 3b 80 00       	push   $0x803b45
  8026a7:	68 1a 01 00 00       	push   $0x11a
  8026ac:	68 d3 3a 80 00       	push   $0x803ad3
  8026b1:	e8 bb db ff ff       	call   800271 <_panic>
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 10                	je     8026cf <alloc_block_NF+0xaf>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c7:	8b 52 04             	mov    0x4(%edx),%edx
  8026ca:	89 50 04             	mov    %edx,0x4(%eax)
  8026cd:	eb 0b                	jmp    8026da <alloc_block_NF+0xba>
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	8b 40 04             	mov    0x4(%eax),%eax
  8026d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 04             	mov    0x4(%eax),%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	74 0f                	je     8026f3 <alloc_block_NF+0xd3>
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ed:	8b 12                	mov    (%edx),%edx
  8026ef:	89 10                	mov    %edx,(%eax)
  8026f1:	eb 0a                	jmp    8026fd <alloc_block_NF+0xdd>
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	a3 38 41 80 00       	mov    %eax,0x804138
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802710:	a1 44 41 80 00       	mov    0x804144,%eax
  802715:	48                   	dec    %eax
  802716:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	e9 0e 01 00 00       	jmp    802831 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 40 0c             	mov    0xc(%eax),%eax
  802729:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272c:	0f 86 cf 00 00 00    	jbe    802801 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802732:	a1 48 41 80 00       	mov    0x804148,%eax
  802737:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  80273a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273d:	8b 55 08             	mov    0x8(%ebp),%edx
  802740:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 50 08             	mov    0x8(%eax),%edx
  802749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274c:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 50 08             	mov    0x8(%eax),%edx
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	01 c2                	add    %eax,%edx
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 40 0c             	mov    0xc(%eax),%eax
  802766:	2b 45 08             	sub    0x8(%ebp),%eax
  802769:	89 c2                	mov    %eax,%edx
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 08             	mov    0x8(%eax),%eax
  802777:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80277a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80277e:	75 17                	jne    802797 <alloc_block_NF+0x177>
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	68 45 3b 80 00       	push   $0x803b45
  802788:	68 28 01 00 00       	push   $0x128
  80278d:	68 d3 3a 80 00       	push   $0x803ad3
  802792:	e8 da da ff ff       	call   800271 <_panic>
  802797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 10                	je     8027b0 <alloc_block_NF+0x190>
  8027a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a8:	8b 52 04             	mov    0x4(%edx),%edx
  8027ab:	89 50 04             	mov    %edx,0x4(%eax)
  8027ae:	eb 0b                	jmp    8027bb <alloc_block_NF+0x19b>
  8027b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027be:	8b 40 04             	mov    0x4(%eax),%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	74 0f                	je     8027d4 <alloc_block_NF+0x1b4>
  8027c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ce:	8b 12                	mov    (%edx),%edx
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	eb 0a                	jmp    8027de <alloc_block_NF+0x1be>
  8027d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	a3 48 41 80 00       	mov    %eax,0x804148
  8027de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f1:	a1 54 41 80 00       	mov    0x804154,%eax
  8027f6:	48                   	dec    %eax
  8027f7:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	eb 30                	jmp    802831 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802801:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802806:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802809:	75 0a                	jne    802815 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80280b:	a1 38 41 80 00       	mov    0x804138,%eax
  802810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802813:	eb 08                	jmp    80281d <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 08             	mov    0x8(%eax),%eax
  802823:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802826:	0f 85 4d fe ff ff    	jne    802679 <alloc_block_NF+0x59>

			return NULL;
  80282c:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
  802836:	53                   	push   %ebx
  802837:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  80283a:	a1 38 41 80 00       	mov    0x804138,%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	0f 85 86 00 00 00    	jne    8028cd <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802847:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80284e:	00 00 00 
  802851:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802858:	00 00 00 
  80285b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802862:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802865:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802869:	75 17                	jne    802882 <insert_sorted_with_merge_freeList+0x4f>
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	68 b0 3a 80 00       	push   $0x803ab0
  802873:	68 48 01 00 00       	push   $0x148
  802878:	68 d3 3a 80 00       	push   $0x803ad3
  80287d:	e8 ef d9 ff ff       	call   800271 <_panic>
  802882:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	89 10                	mov    %edx,(%eax)
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	8b 00                	mov    (%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 0d                	je     8028a3 <insert_sorted_with_merge_freeList+0x70>
  802896:	a1 38 41 80 00       	mov    0x804138,%eax
  80289b:	8b 55 08             	mov    0x8(%ebp),%edx
  80289e:	89 50 04             	mov    %edx,0x4(%eax)
  8028a1:	eb 08                	jmp    8028ab <insert_sorted_with_merge_freeList+0x78>
  8028a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	a3 38 41 80 00       	mov    %eax,0x804138
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bd:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c2:	40                   	inc    %eax
  8028c3:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8028c8:	e9 73 07 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	8b 50 08             	mov    0x8(%eax),%edx
  8028d3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028d8:	8b 40 08             	mov    0x8(%eax),%eax
  8028db:	39 c2                	cmp    %eax,%edx
  8028dd:	0f 86 84 00 00 00    	jbe    802967 <insert_sorted_with_merge_freeList+0x134>
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	8b 50 08             	mov    0x8(%eax),%edx
  8028e9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028ee:	8b 48 0c             	mov    0xc(%eax),%ecx
  8028f1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028f6:	8b 40 08             	mov    0x8(%eax),%eax
  8028f9:	01 c8                	add    %ecx,%eax
  8028fb:	39 c2                	cmp    %eax,%edx
  8028fd:	74 68                	je     802967 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8028ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802903:	75 17                	jne    80291c <insert_sorted_with_merge_freeList+0xe9>
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	68 ec 3a 80 00       	push   $0x803aec
  80290d:	68 4c 01 00 00       	push   $0x14c
  802912:	68 d3 3a 80 00       	push   $0x803ad3
  802917:	e8 55 d9 ff ff       	call   800271 <_panic>
  80291c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	89 50 04             	mov    %edx,0x4(%eax)
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	85 c0                	test   %eax,%eax
  802930:	74 0c                	je     80293e <insert_sorted_with_merge_freeList+0x10b>
  802932:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802937:	8b 55 08             	mov    0x8(%ebp),%edx
  80293a:	89 10                	mov    %edx,(%eax)
  80293c:	eb 08                	jmp    802946 <insert_sorted_with_merge_freeList+0x113>
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	a3 38 41 80 00       	mov    %eax,0x804138
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802957:	a1 44 41 80 00       	mov    0x804144,%eax
  80295c:	40                   	inc    %eax
  80295d:	a3 44 41 80 00       	mov    %eax,0x804144
  802962:	e9 d9 06 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8b 50 08             	mov    0x8(%eax),%edx
  80296d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802972:	8b 40 08             	mov    0x8(%eax),%eax
  802975:	39 c2                	cmp    %eax,%edx
  802977:	0f 86 b5 00 00 00    	jbe    802a32 <insert_sorted_with_merge_freeList+0x1ff>
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	8b 50 08             	mov    0x8(%eax),%edx
  802983:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802988:	8b 48 0c             	mov    0xc(%eax),%ecx
  80298b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802990:	8b 40 08             	mov    0x8(%eax),%eax
  802993:	01 c8                	add    %ecx,%eax
  802995:	39 c2                	cmp    %eax,%edx
  802997:	0f 85 95 00 00 00    	jne    802a32 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  80299d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029a2:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029a8:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8029ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ae:	8b 52 0c             	mov    0xc(%edx),%edx
  8029b1:	01 ca                	add    %ecx,%edx
  8029b3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ce:	75 17                	jne    8029e7 <insert_sorted_with_merge_freeList+0x1b4>
  8029d0:	83 ec 04             	sub    $0x4,%esp
  8029d3:	68 b0 3a 80 00       	push   $0x803ab0
  8029d8:	68 54 01 00 00       	push   $0x154
  8029dd:	68 d3 3a 80 00       	push   $0x803ad3
  8029e2:	e8 8a d8 ff ff       	call   800271 <_panic>
  8029e7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	89 10                	mov    %edx,(%eax)
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	74 0d                	je     802a08 <insert_sorted_with_merge_freeList+0x1d5>
  8029fb:	a1 48 41 80 00       	mov    0x804148,%eax
  802a00:	8b 55 08             	mov    0x8(%ebp),%edx
  802a03:	89 50 04             	mov    %edx,0x4(%eax)
  802a06:	eb 08                	jmp    802a10 <insert_sorted_with_merge_freeList+0x1dd>
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	a3 48 41 80 00       	mov    %eax,0x804148
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a22:	a1 54 41 80 00       	mov    0x804154,%eax
  802a27:	40                   	inc    %eax
  802a28:	a3 54 41 80 00       	mov    %eax,0x804154
  802a2d:	e9 0e 06 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	8b 50 08             	mov    0x8(%eax),%edx
  802a38:	a1 38 41 80 00       	mov    0x804138,%eax
  802a3d:	8b 40 08             	mov    0x8(%eax),%eax
  802a40:	39 c2                	cmp    %eax,%edx
  802a42:	0f 83 c1 00 00 00    	jae    802b09 <insert_sorted_with_merge_freeList+0x2d6>
  802a48:	a1 38 41 80 00       	mov    0x804138,%eax
  802a4d:	8b 50 08             	mov    0x8(%eax),%edx
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	8b 48 08             	mov    0x8(%eax),%ecx
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5c:	01 c8                	add    %ecx,%eax
  802a5e:	39 c2                	cmp    %eax,%edx
  802a60:	0f 85 a3 00 00 00    	jne    802b09 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802a66:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6e:	8b 52 08             	mov    0x8(%edx),%edx
  802a71:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802a74:	a1 38 41 80 00       	mov    0x804138,%eax
  802a79:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a7f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a82:	8b 55 08             	mov    0x8(%ebp),%edx
  802a85:	8b 52 0c             	mov    0xc(%edx),%edx
  802a88:	01 ca                	add    %ecx,%edx
  802a8a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa5:	75 17                	jne    802abe <insert_sorted_with_merge_freeList+0x28b>
  802aa7:	83 ec 04             	sub    $0x4,%esp
  802aaa:	68 b0 3a 80 00       	push   $0x803ab0
  802aaf:	68 5d 01 00 00       	push   $0x15d
  802ab4:	68 d3 3a 80 00       	push   $0x803ad3
  802ab9:	e8 b3 d7 ff ff       	call   800271 <_panic>
  802abe:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 0d                	je     802adf <insert_sorted_with_merge_freeList+0x2ac>
  802ad2:	a1 48 41 80 00       	mov    0x804148,%eax
  802ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ada:	89 50 04             	mov    %edx,0x4(%eax)
  802add:	eb 08                	jmp    802ae7 <insert_sorted_with_merge_freeList+0x2b4>
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	a3 48 41 80 00       	mov    %eax,0x804148
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af9:	a1 54 41 80 00       	mov    0x804154,%eax
  802afe:	40                   	inc    %eax
  802aff:	a3 54 41 80 00       	mov    %eax,0x804154
  802b04:	e9 37 05 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 50 08             	mov    0x8(%eax),%edx
  802b0f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b14:	8b 40 08             	mov    0x8(%eax),%eax
  802b17:	39 c2                	cmp    %eax,%edx
  802b19:	0f 83 82 00 00 00    	jae    802ba1 <insert_sorted_with_merge_freeList+0x36e>
  802b1f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b24:	8b 50 08             	mov    0x8(%eax),%edx
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8b 48 08             	mov    0x8(%eax),%ecx
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 40 0c             	mov    0xc(%eax),%eax
  802b33:	01 c8                	add    %ecx,%eax
  802b35:	39 c2                	cmp    %eax,%edx
  802b37:	74 68                	je     802ba1 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3d:	75 17                	jne    802b56 <insert_sorted_with_merge_freeList+0x323>
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 b0 3a 80 00       	push   $0x803ab0
  802b47:	68 62 01 00 00       	push   $0x162
  802b4c:	68 d3 3a 80 00       	push   $0x803ad3
  802b51:	e8 1b d7 ff ff       	call   800271 <_panic>
  802b56:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	89 10                	mov    %edx,(%eax)
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0d                	je     802b77 <insert_sorted_with_merge_freeList+0x344>
  802b6a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b72:	89 50 04             	mov    %edx,0x4(%eax)
  802b75:	eb 08                	jmp    802b7f <insert_sorted_with_merge_freeList+0x34c>
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	a3 38 41 80 00       	mov    %eax,0x804138
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b91:	a1 44 41 80 00       	mov    0x804144,%eax
  802b96:	40                   	inc    %eax
  802b97:	a3 44 41 80 00       	mov    %eax,0x804144
  802b9c:	e9 9f 04 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802ba1:	a1 38 41 80 00       	mov    0x804138,%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802bab:	e9 84 04 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 50 08             	mov    0x8(%eax),%edx
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	8b 40 08             	mov    0x8(%eax),%eax
  802bbc:	39 c2                	cmp    %eax,%edx
  802bbe:	0f 86 a9 00 00 00    	jbe    802c6d <insert_sorted_with_merge_freeList+0x43a>
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 50 08             	mov    0x8(%eax),%edx
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	8b 48 08             	mov    0x8(%eax),%ecx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd6:	01 c8                	add    %ecx,%eax
  802bd8:	39 c2                	cmp    %eax,%edx
  802bda:	0f 84 8d 00 00 00    	je     802c6d <insert_sorted_with_merge_freeList+0x43a>
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	8b 50 08             	mov    0x8(%eax),%edx
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	8b 48 08             	mov    0x8(%eax),%ecx
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 04             	mov    0x4(%eax),%eax
  802bf5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf8:	01 c8                	add    %ecx,%eax
  802bfa:	39 c2                	cmp    %eax,%edx
  802bfc:	74 6f                	je     802c6d <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802bfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c02:	74 06                	je     802c0a <insert_sorted_with_merge_freeList+0x3d7>
  802c04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c08:	75 17                	jne    802c21 <insert_sorted_with_merge_freeList+0x3ee>
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	68 10 3b 80 00       	push   $0x803b10
  802c12:	68 6b 01 00 00       	push   $0x16b
  802c17:	68 d3 3a 80 00       	push   $0x803ad3
  802c1c:	e8 50 d6 ff ff       	call   800271 <_panic>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 50 04             	mov    0x4(%eax),%edx
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	89 50 04             	mov    %edx,0x4(%eax)
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c33:	89 10                	mov    %edx,(%eax)
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 40 04             	mov    0x4(%eax),%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	74 0d                	je     802c4c <insert_sorted_with_merge_freeList+0x419>
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 40 04             	mov    0x4(%eax),%eax
  802c45:	8b 55 08             	mov    0x8(%ebp),%edx
  802c48:	89 10                	mov    %edx,(%eax)
  802c4a:	eb 08                	jmp    802c54 <insert_sorted_with_merge_freeList+0x421>
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	a3 38 41 80 00       	mov    %eax,0x804138
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5a:	89 50 04             	mov    %edx,0x4(%eax)
  802c5d:	a1 44 41 80 00       	mov    0x804144,%eax
  802c62:	40                   	inc    %eax
  802c63:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802c68:	e9 d3 03 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 50 08             	mov    0x8(%eax),%edx
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 40 08             	mov    0x8(%eax),%eax
  802c79:	39 c2                	cmp    %eax,%edx
  802c7b:	0f 86 da 00 00 00    	jbe    802d5b <insert_sorted_with_merge_freeList+0x528>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 50 08             	mov    0x8(%eax),%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 48 08             	mov    0x8(%eax),%ecx
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 40 0c             	mov    0xc(%eax),%eax
  802c93:	01 c8                	add    %ecx,%eax
  802c95:	39 c2                	cmp    %eax,%edx
  802c97:	0f 85 be 00 00 00    	jne    802d5b <insert_sorted_with_merge_freeList+0x528>
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8b 50 08             	mov    0x8(%eax),%edx
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	8b 48 08             	mov    0x8(%eax),%ecx
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 04             	mov    0x4(%eax),%eax
  802cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb5:	01 c8                	add    %ecx,%eax
  802cb7:	39 c2                	cmp    %eax,%edx
  802cb9:	0f 84 9c 00 00 00    	je     802d5b <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	8b 50 08             	mov    0x8(%eax),%edx
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd7:	01 c2                	add    %eax,%edx
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802cf3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf7:	75 17                	jne    802d10 <insert_sorted_with_merge_freeList+0x4dd>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 b0 3a 80 00       	push   $0x803ab0
  802d01:	68 74 01 00 00       	push   $0x174
  802d06:	68 d3 3a 80 00       	push   $0x803ad3
  802d0b:	e8 61 d5 ff ff       	call   800271 <_panic>
  802d10:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	89 10                	mov    %edx,(%eax)
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	8b 00                	mov    (%eax),%eax
  802d20:	85 c0                	test   %eax,%eax
  802d22:	74 0d                	je     802d31 <insert_sorted_with_merge_freeList+0x4fe>
  802d24:	a1 48 41 80 00       	mov    0x804148,%eax
  802d29:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2c:	89 50 04             	mov    %edx,0x4(%eax)
  802d2f:	eb 08                	jmp    802d39 <insert_sorted_with_merge_freeList+0x506>
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4b:	a1 54 41 80 00       	mov    0x804154,%eax
  802d50:	40                   	inc    %eax
  802d51:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802d56:	e9 e5 02 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 50 08             	mov    0x8(%eax),%edx
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	8b 40 08             	mov    0x8(%eax),%eax
  802d67:	39 c2                	cmp    %eax,%edx
  802d69:	0f 86 d7 00 00 00    	jbe    802e46 <insert_sorted_with_merge_freeList+0x613>
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 50 08             	mov    0x8(%eax),%edx
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 48 08             	mov    0x8(%eax),%ecx
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d81:	01 c8                	add    %ecx,%eax
  802d83:	39 c2                	cmp    %eax,%edx
  802d85:	0f 84 bb 00 00 00    	je     802e46 <insert_sorted_with_merge_freeList+0x613>
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	8b 50 08             	mov    0x8(%eax),%edx
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 04             	mov    0x4(%eax),%eax
  802d97:	8b 48 08             	mov    0x8(%eax),%ecx
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	8b 40 0c             	mov    0xc(%eax),%eax
  802da3:	01 c8                	add    %ecx,%eax
  802da5:	39 c2                	cmp    %eax,%edx
  802da7:	0f 85 99 00 00 00    	jne    802e46 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 40 04             	mov    0x4(%eax),%eax
  802db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	01 c2                	add    %eax,%edx
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de2:	75 17                	jne    802dfb <insert_sorted_with_merge_freeList+0x5c8>
  802de4:	83 ec 04             	sub    $0x4,%esp
  802de7:	68 b0 3a 80 00       	push   $0x803ab0
  802dec:	68 7d 01 00 00       	push   $0x17d
  802df1:	68 d3 3a 80 00       	push   $0x803ad3
  802df6:	e8 76 d4 ff ff       	call   800271 <_panic>
  802dfb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	89 10                	mov    %edx,(%eax)
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 00                	mov    (%eax),%eax
  802e0b:	85 c0                	test   %eax,%eax
  802e0d:	74 0d                	je     802e1c <insert_sorted_with_merge_freeList+0x5e9>
  802e0f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e14:	8b 55 08             	mov    0x8(%ebp),%edx
  802e17:	89 50 04             	mov    %edx,0x4(%eax)
  802e1a:	eb 08                	jmp    802e24 <insert_sorted_with_merge_freeList+0x5f1>
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	a3 48 41 80 00       	mov    %eax,0x804148
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e36:	a1 54 41 80 00       	mov    0x804154,%eax
  802e3b:	40                   	inc    %eax
  802e3c:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e41:	e9 fa 01 00 00       	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 50 08             	mov    0x8(%eax),%edx
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	8b 40 08             	mov    0x8(%eax),%eax
  802e52:	39 c2                	cmp    %eax,%edx
  802e54:	0f 86 d2 01 00 00    	jbe    80302c <insert_sorted_with_merge_freeList+0x7f9>
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 50 08             	mov    0x8(%eax),%edx
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	8b 48 08             	mov    0x8(%eax),%ecx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6c:	01 c8                	add    %ecx,%eax
  802e6e:	39 c2                	cmp    %eax,%edx
  802e70:	0f 85 b6 01 00 00    	jne    80302c <insert_sorted_with_merge_freeList+0x7f9>
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 50 08             	mov    0x8(%eax),%edx
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	8b 48 08             	mov    0x8(%eax),%ecx
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 40 04             	mov    0x4(%eax),%eax
  802e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8e:	01 c8                	add    %ecx,%eax
  802e90:	39 c2                	cmp    %eax,%edx
  802e92:	0f 85 94 01 00 00    	jne    80302c <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea1:	8b 52 04             	mov    0x4(%edx),%edx
  802ea4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  802eaa:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb0:	8b 52 0c             	mov    0xc(%edx),%edx
  802eb3:	01 da                	add    %ebx,%edx
  802eb5:	01 ca                	add    %ecx,%edx
  802eb7:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed2:	75 17                	jne    802eeb <insert_sorted_with_merge_freeList+0x6b8>
  802ed4:	83 ec 04             	sub    $0x4,%esp
  802ed7:	68 45 3b 80 00       	push   $0x803b45
  802edc:	68 86 01 00 00       	push   $0x186
  802ee1:	68 d3 3a 80 00       	push   $0x803ad3
  802ee6:	e8 86 d3 ff ff       	call   800271 <_panic>
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 10                	je     802f04 <insert_sorted_with_merge_freeList+0x6d1>
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efc:	8b 52 04             	mov    0x4(%edx),%edx
  802eff:	89 50 04             	mov    %edx,0x4(%eax)
  802f02:	eb 0b                	jmp    802f0f <insert_sorted_with_merge_freeList+0x6dc>
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 40 04             	mov    0x4(%eax),%eax
  802f0a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 40 04             	mov    0x4(%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	74 0f                	je     802f28 <insert_sorted_with_merge_freeList+0x6f5>
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 40 04             	mov    0x4(%eax),%eax
  802f1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f22:	8b 12                	mov    (%edx),%edx
  802f24:	89 10                	mov    %edx,(%eax)
  802f26:	eb 0a                	jmp    802f32 <insert_sorted_with_merge_freeList+0x6ff>
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 00                	mov    (%eax),%eax
  802f2d:	a3 38 41 80 00       	mov    %eax,0x804138
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f45:	a1 44 41 80 00       	mov    0x804144,%eax
  802f4a:	48                   	dec    %eax
  802f4b:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802f50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f54:	75 17                	jne    802f6d <insert_sorted_with_merge_freeList+0x73a>
  802f56:	83 ec 04             	sub    $0x4,%esp
  802f59:	68 b0 3a 80 00       	push   $0x803ab0
  802f5e:	68 87 01 00 00       	push   $0x187
  802f63:	68 d3 3a 80 00       	push   $0x803ad3
  802f68:	e8 04 d3 ff ff       	call   800271 <_panic>
  802f6d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	89 10                	mov    %edx,(%eax)
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	74 0d                	je     802f8e <insert_sorted_with_merge_freeList+0x75b>
  802f81:	a1 48 41 80 00       	mov    0x804148,%eax
  802f86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f89:	89 50 04             	mov    %edx,0x4(%eax)
  802f8c:	eb 08                	jmp    802f96 <insert_sorted_with_merge_freeList+0x763>
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	a3 48 41 80 00       	mov    %eax,0x804148
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa8:	a1 54 41 80 00       	mov    0x804154,%eax
  802fad:	40                   	inc    %eax
  802fae:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fcb:	75 17                	jne    802fe4 <insert_sorted_with_merge_freeList+0x7b1>
  802fcd:	83 ec 04             	sub    $0x4,%esp
  802fd0:	68 b0 3a 80 00       	push   $0x803ab0
  802fd5:	68 8a 01 00 00       	push   $0x18a
  802fda:	68 d3 3a 80 00       	push   $0x803ad3
  802fdf:	e8 8d d2 ff ff       	call   800271 <_panic>
  802fe4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	89 10                	mov    %edx,(%eax)
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	74 0d                	je     803005 <insert_sorted_with_merge_freeList+0x7d2>
  802ff8:	a1 48 41 80 00       	mov    0x804148,%eax
  802ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  803000:	89 50 04             	mov    %edx,0x4(%eax)
  803003:	eb 08                	jmp    80300d <insert_sorted_with_merge_freeList+0x7da>
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	a3 48 41 80 00       	mov    %eax,0x804148
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301f:	a1 54 41 80 00       	mov    0x804154,%eax
  803024:	40                   	inc    %eax
  803025:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  80302a:	eb 14                	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803034:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803038:	0f 85 72 fb ff ff    	jne    802bb0 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80303e:	eb 00                	jmp    803040 <insert_sorted_with_merge_freeList+0x80d>
  803040:	90                   	nop
  803041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803044:	c9                   	leave  
  803045:	c3                   	ret    
  803046:	66 90                	xchg   %ax,%ax

00803048 <__udivdi3>:
  803048:	55                   	push   %ebp
  803049:	57                   	push   %edi
  80304a:	56                   	push   %esi
  80304b:	53                   	push   %ebx
  80304c:	83 ec 1c             	sub    $0x1c,%esp
  80304f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803053:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803057:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80305b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80305f:	89 ca                	mov    %ecx,%edx
  803061:	89 f8                	mov    %edi,%eax
  803063:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803067:	85 f6                	test   %esi,%esi
  803069:	75 2d                	jne    803098 <__udivdi3+0x50>
  80306b:	39 cf                	cmp    %ecx,%edi
  80306d:	77 65                	ja     8030d4 <__udivdi3+0x8c>
  80306f:	89 fd                	mov    %edi,%ebp
  803071:	85 ff                	test   %edi,%edi
  803073:	75 0b                	jne    803080 <__udivdi3+0x38>
  803075:	b8 01 00 00 00       	mov    $0x1,%eax
  80307a:	31 d2                	xor    %edx,%edx
  80307c:	f7 f7                	div    %edi
  80307e:	89 c5                	mov    %eax,%ebp
  803080:	31 d2                	xor    %edx,%edx
  803082:	89 c8                	mov    %ecx,%eax
  803084:	f7 f5                	div    %ebp
  803086:	89 c1                	mov    %eax,%ecx
  803088:	89 d8                	mov    %ebx,%eax
  80308a:	f7 f5                	div    %ebp
  80308c:	89 cf                	mov    %ecx,%edi
  80308e:	89 fa                	mov    %edi,%edx
  803090:	83 c4 1c             	add    $0x1c,%esp
  803093:	5b                   	pop    %ebx
  803094:	5e                   	pop    %esi
  803095:	5f                   	pop    %edi
  803096:	5d                   	pop    %ebp
  803097:	c3                   	ret    
  803098:	39 ce                	cmp    %ecx,%esi
  80309a:	77 28                	ja     8030c4 <__udivdi3+0x7c>
  80309c:	0f bd fe             	bsr    %esi,%edi
  80309f:	83 f7 1f             	xor    $0x1f,%edi
  8030a2:	75 40                	jne    8030e4 <__udivdi3+0x9c>
  8030a4:	39 ce                	cmp    %ecx,%esi
  8030a6:	72 0a                	jb     8030b2 <__udivdi3+0x6a>
  8030a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030ac:	0f 87 9e 00 00 00    	ja     803150 <__udivdi3+0x108>
  8030b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030b7:	89 fa                	mov    %edi,%edx
  8030b9:	83 c4 1c             	add    $0x1c,%esp
  8030bc:	5b                   	pop    %ebx
  8030bd:	5e                   	pop    %esi
  8030be:	5f                   	pop    %edi
  8030bf:	5d                   	pop    %ebp
  8030c0:	c3                   	ret    
  8030c1:	8d 76 00             	lea    0x0(%esi),%esi
  8030c4:	31 ff                	xor    %edi,%edi
  8030c6:	31 c0                	xor    %eax,%eax
  8030c8:	89 fa                	mov    %edi,%edx
  8030ca:	83 c4 1c             	add    $0x1c,%esp
  8030cd:	5b                   	pop    %ebx
  8030ce:	5e                   	pop    %esi
  8030cf:	5f                   	pop    %edi
  8030d0:	5d                   	pop    %ebp
  8030d1:	c3                   	ret    
  8030d2:	66 90                	xchg   %ax,%ax
  8030d4:	89 d8                	mov    %ebx,%eax
  8030d6:	f7 f7                	div    %edi
  8030d8:	31 ff                	xor    %edi,%edi
  8030da:	89 fa                	mov    %edi,%edx
  8030dc:	83 c4 1c             	add    $0x1c,%esp
  8030df:	5b                   	pop    %ebx
  8030e0:	5e                   	pop    %esi
  8030e1:	5f                   	pop    %edi
  8030e2:	5d                   	pop    %ebp
  8030e3:	c3                   	ret    
  8030e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030e9:	89 eb                	mov    %ebp,%ebx
  8030eb:	29 fb                	sub    %edi,%ebx
  8030ed:	89 f9                	mov    %edi,%ecx
  8030ef:	d3 e6                	shl    %cl,%esi
  8030f1:	89 c5                	mov    %eax,%ebp
  8030f3:	88 d9                	mov    %bl,%cl
  8030f5:	d3 ed                	shr    %cl,%ebp
  8030f7:	89 e9                	mov    %ebp,%ecx
  8030f9:	09 f1                	or     %esi,%ecx
  8030fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030ff:	89 f9                	mov    %edi,%ecx
  803101:	d3 e0                	shl    %cl,%eax
  803103:	89 c5                	mov    %eax,%ebp
  803105:	89 d6                	mov    %edx,%esi
  803107:	88 d9                	mov    %bl,%cl
  803109:	d3 ee                	shr    %cl,%esi
  80310b:	89 f9                	mov    %edi,%ecx
  80310d:	d3 e2                	shl    %cl,%edx
  80310f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803113:	88 d9                	mov    %bl,%cl
  803115:	d3 e8                	shr    %cl,%eax
  803117:	09 c2                	or     %eax,%edx
  803119:	89 d0                	mov    %edx,%eax
  80311b:	89 f2                	mov    %esi,%edx
  80311d:	f7 74 24 0c          	divl   0xc(%esp)
  803121:	89 d6                	mov    %edx,%esi
  803123:	89 c3                	mov    %eax,%ebx
  803125:	f7 e5                	mul    %ebp
  803127:	39 d6                	cmp    %edx,%esi
  803129:	72 19                	jb     803144 <__udivdi3+0xfc>
  80312b:	74 0b                	je     803138 <__udivdi3+0xf0>
  80312d:	89 d8                	mov    %ebx,%eax
  80312f:	31 ff                	xor    %edi,%edi
  803131:	e9 58 ff ff ff       	jmp    80308e <__udivdi3+0x46>
  803136:	66 90                	xchg   %ax,%ax
  803138:	8b 54 24 08          	mov    0x8(%esp),%edx
  80313c:	89 f9                	mov    %edi,%ecx
  80313e:	d3 e2                	shl    %cl,%edx
  803140:	39 c2                	cmp    %eax,%edx
  803142:	73 e9                	jae    80312d <__udivdi3+0xe5>
  803144:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803147:	31 ff                	xor    %edi,%edi
  803149:	e9 40 ff ff ff       	jmp    80308e <__udivdi3+0x46>
  80314e:	66 90                	xchg   %ax,%ax
  803150:	31 c0                	xor    %eax,%eax
  803152:	e9 37 ff ff ff       	jmp    80308e <__udivdi3+0x46>
  803157:	90                   	nop

00803158 <__umoddi3>:
  803158:	55                   	push   %ebp
  803159:	57                   	push   %edi
  80315a:	56                   	push   %esi
  80315b:	53                   	push   %ebx
  80315c:	83 ec 1c             	sub    $0x1c,%esp
  80315f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803163:	8b 74 24 34          	mov    0x34(%esp),%esi
  803167:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80316b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80316f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803173:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803177:	89 f3                	mov    %esi,%ebx
  803179:	89 fa                	mov    %edi,%edx
  80317b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80317f:	89 34 24             	mov    %esi,(%esp)
  803182:	85 c0                	test   %eax,%eax
  803184:	75 1a                	jne    8031a0 <__umoddi3+0x48>
  803186:	39 f7                	cmp    %esi,%edi
  803188:	0f 86 a2 00 00 00    	jbe    803230 <__umoddi3+0xd8>
  80318e:	89 c8                	mov    %ecx,%eax
  803190:	89 f2                	mov    %esi,%edx
  803192:	f7 f7                	div    %edi
  803194:	89 d0                	mov    %edx,%eax
  803196:	31 d2                	xor    %edx,%edx
  803198:	83 c4 1c             	add    $0x1c,%esp
  80319b:	5b                   	pop    %ebx
  80319c:	5e                   	pop    %esi
  80319d:	5f                   	pop    %edi
  80319e:	5d                   	pop    %ebp
  80319f:	c3                   	ret    
  8031a0:	39 f0                	cmp    %esi,%eax
  8031a2:	0f 87 ac 00 00 00    	ja     803254 <__umoddi3+0xfc>
  8031a8:	0f bd e8             	bsr    %eax,%ebp
  8031ab:	83 f5 1f             	xor    $0x1f,%ebp
  8031ae:	0f 84 ac 00 00 00    	je     803260 <__umoddi3+0x108>
  8031b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8031b9:	29 ef                	sub    %ebp,%edi
  8031bb:	89 fe                	mov    %edi,%esi
  8031bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031c1:	89 e9                	mov    %ebp,%ecx
  8031c3:	d3 e0                	shl    %cl,%eax
  8031c5:	89 d7                	mov    %edx,%edi
  8031c7:	89 f1                	mov    %esi,%ecx
  8031c9:	d3 ef                	shr    %cl,%edi
  8031cb:	09 c7                	or     %eax,%edi
  8031cd:	89 e9                	mov    %ebp,%ecx
  8031cf:	d3 e2                	shl    %cl,%edx
  8031d1:	89 14 24             	mov    %edx,(%esp)
  8031d4:	89 d8                	mov    %ebx,%eax
  8031d6:	d3 e0                	shl    %cl,%eax
  8031d8:	89 c2                	mov    %eax,%edx
  8031da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031de:	d3 e0                	shl    %cl,%eax
  8031e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e8:	89 f1                	mov    %esi,%ecx
  8031ea:	d3 e8                	shr    %cl,%eax
  8031ec:	09 d0                	or     %edx,%eax
  8031ee:	d3 eb                	shr    %cl,%ebx
  8031f0:	89 da                	mov    %ebx,%edx
  8031f2:	f7 f7                	div    %edi
  8031f4:	89 d3                	mov    %edx,%ebx
  8031f6:	f7 24 24             	mull   (%esp)
  8031f9:	89 c6                	mov    %eax,%esi
  8031fb:	89 d1                	mov    %edx,%ecx
  8031fd:	39 d3                	cmp    %edx,%ebx
  8031ff:	0f 82 87 00 00 00    	jb     80328c <__umoddi3+0x134>
  803205:	0f 84 91 00 00 00    	je     80329c <__umoddi3+0x144>
  80320b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80320f:	29 f2                	sub    %esi,%edx
  803211:	19 cb                	sbb    %ecx,%ebx
  803213:	89 d8                	mov    %ebx,%eax
  803215:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803219:	d3 e0                	shl    %cl,%eax
  80321b:	89 e9                	mov    %ebp,%ecx
  80321d:	d3 ea                	shr    %cl,%edx
  80321f:	09 d0                	or     %edx,%eax
  803221:	89 e9                	mov    %ebp,%ecx
  803223:	d3 eb                	shr    %cl,%ebx
  803225:	89 da                	mov    %ebx,%edx
  803227:	83 c4 1c             	add    $0x1c,%esp
  80322a:	5b                   	pop    %ebx
  80322b:	5e                   	pop    %esi
  80322c:	5f                   	pop    %edi
  80322d:	5d                   	pop    %ebp
  80322e:	c3                   	ret    
  80322f:	90                   	nop
  803230:	89 fd                	mov    %edi,%ebp
  803232:	85 ff                	test   %edi,%edi
  803234:	75 0b                	jne    803241 <__umoddi3+0xe9>
  803236:	b8 01 00 00 00       	mov    $0x1,%eax
  80323b:	31 d2                	xor    %edx,%edx
  80323d:	f7 f7                	div    %edi
  80323f:	89 c5                	mov    %eax,%ebp
  803241:	89 f0                	mov    %esi,%eax
  803243:	31 d2                	xor    %edx,%edx
  803245:	f7 f5                	div    %ebp
  803247:	89 c8                	mov    %ecx,%eax
  803249:	f7 f5                	div    %ebp
  80324b:	89 d0                	mov    %edx,%eax
  80324d:	e9 44 ff ff ff       	jmp    803196 <__umoddi3+0x3e>
  803252:	66 90                	xchg   %ax,%ax
  803254:	89 c8                	mov    %ecx,%eax
  803256:	89 f2                	mov    %esi,%edx
  803258:	83 c4 1c             	add    $0x1c,%esp
  80325b:	5b                   	pop    %ebx
  80325c:	5e                   	pop    %esi
  80325d:	5f                   	pop    %edi
  80325e:	5d                   	pop    %ebp
  80325f:	c3                   	ret    
  803260:	3b 04 24             	cmp    (%esp),%eax
  803263:	72 06                	jb     80326b <__umoddi3+0x113>
  803265:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803269:	77 0f                	ja     80327a <__umoddi3+0x122>
  80326b:	89 f2                	mov    %esi,%edx
  80326d:	29 f9                	sub    %edi,%ecx
  80326f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803273:	89 14 24             	mov    %edx,(%esp)
  803276:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80327a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80327e:	8b 14 24             	mov    (%esp),%edx
  803281:	83 c4 1c             	add    $0x1c,%esp
  803284:	5b                   	pop    %ebx
  803285:	5e                   	pop    %esi
  803286:	5f                   	pop    %edi
  803287:	5d                   	pop    %ebp
  803288:	c3                   	ret    
  803289:	8d 76 00             	lea    0x0(%esi),%esi
  80328c:	2b 04 24             	sub    (%esp),%eax
  80328f:	19 fa                	sbb    %edi,%edx
  803291:	89 d1                	mov    %edx,%ecx
  803293:	89 c6                	mov    %eax,%esi
  803295:	e9 71 ff ff ff       	jmp    80320b <__umoddi3+0xb3>
  80329a:	66 90                	xchg   %ax,%ax
  80329c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032a0:	72 ea                	jb     80328c <__umoddi3+0x134>
  8032a2:	89 d9                	mov    %ebx,%ecx
  8032a4:	e9 62 ff ff ff       	jmp    80320b <__umoddi3+0xb3>
