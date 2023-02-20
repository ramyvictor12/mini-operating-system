
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
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
  80008c:	68 e0 33 80 00       	push   $0x8033e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 33 80 00       	push   $0x8033fc
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 a8 1b 00 00       	call   801c4a <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 1c 34 80 00       	push   $0x80341c
  8000aa:	50                   	push   %eax
  8000ab:	e8 61 16 00 00       	call   801711 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 20 34 80 00       	push   $0x803420
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 48 34 80 00       	push   $0x803448
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 db 2f 00 00       	call   8030be <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 66 18 00 00       	call   801951 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 f8 16 00 00       	call   8017f1 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 68 34 80 00       	push   $0x803468
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 40 18 00 00       	call   801951 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 80 34 80 00       	push   $0x803480
  800127:	6a 20                	push   $0x20
  800129:	68 fc 33 80 00       	push   $0x8033fc
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 51 1c 00 00       	call   801d89 <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 20 35 80 00       	push   $0x803520
  800145:	6a 23                	push   $0x23
  800147:	68 fc 33 80 00       	push   $0x8033fc
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 2c 35 80 00       	push   $0x80352c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 50 35 80 00       	push   $0x803550
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 d4 1a 00 00       	call   801c4a <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 9c 35 80 00       	push   $0x80359c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 7b 15 00 00       	call   801711 <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 79 1a 00 00       	call   801c31 <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	c1 e0 03             	shl    $0x3,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	c1 e0 04             	shl    $0x4,%eax
  8001d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001da:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001df:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001ea:	84 c0                	test   %al,%al
  8001ec:	74 0f                	je     8001fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x60>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 1d fe ff ff       	call   800038 <_main>
  80021b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021e:	e8 1b 18 00 00       	call   801a3e <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 c4 35 80 00       	push   $0x8035c4
  80022b:	e8 6d 03 00 00       	call   80059d <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	52                   	push   %edx
  80024d:	50                   	push   %eax
  80024e:	68 ec 35 80 00       	push   $0x8035ec
  800253:	e8 45 03 00 00       	call   80059d <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025b:	a1 20 40 80 00       	mov    0x804020,%eax
  800260:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800266:	a1 20 40 80 00       	mov    0x804020,%eax
  80026b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027c:	51                   	push   %ecx
  80027d:	52                   	push   %edx
  80027e:	50                   	push   %eax
  80027f:	68 14 36 80 00       	push   $0x803614
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 40 80 00       	mov    0x804020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 6c 36 80 00       	push   $0x80366c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 c4 35 80 00       	push   $0x8035c4
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 9b 17 00 00       	call   801a58 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bd:	e8 19 00 00 00       	call   8002db <exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 28 19 00 00       	call   801bfd <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 7d 19 00 00       	call   801c63 <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 80 36 80 00       	push   $0x803680
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 40 80 00       	mov    0x804000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 85 36 80 00       	push   $0x803685
  800328:	e8 70 02 00 00       	call   80059d <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800330:	8b 45 10             	mov    0x10(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 f3 01 00 00       	call   800532 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	6a 00                	push   $0x0
  800347:	68 a1 36 80 00       	push   $0x8036a1
  80034c:	e8 e1 01 00 00       	call   800532 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800354:	e8 82 ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  800359:	eb fe                	jmp    800359 <_panic+0x70>

0080035b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 40 80 00       	mov    0x804020,%eax
  800366:	8b 50 74             	mov    0x74(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 a4 36 80 00       	push   $0x8036a4
  800378:	6a 26                	push   $0x26
  80037a:	68 f0 36 80 00       	push   $0x8036f0
  80037f:	e8 65 ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 c2 00 00 00       	jmp    800459 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 a2 00 00 00       	jmp    800456 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 69                	jmp    80042d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	c1 e0 03             	shl    $0x3,%eax
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	8a 40 04             	mov    0x4(%eax),%al
  8003e0:	84 c0                	test   %al,%al
  8003e2:	75 46                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	01 c0                	add    %eax,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	75 09                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800428:	eb 12                	jmp    80043c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e8             	incl   -0x18(%ebp)
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 50 74             	mov    0x74(%eax),%edx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	77 88                	ja     8003c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800440:	75 14                	jne    800456 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 fc 36 80 00       	push   $0x8036fc
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 f0 36 80 00       	push   $0x8036f0
  800451:	e8 93 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800456:	ff 45 f0             	incl   -0x10(%ebp)
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	0f 8c 32 ff ff ff    	jl     800397 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800473:	eb 26                	jmp    80049b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800475:	a1 20 40 80 00       	mov    0x804020,%eax
  80047a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8a 40 04             	mov    0x4(%eax),%al
  800491:	3c 01                	cmp    $0x1,%al
  800493:	75 03                	jne    800498 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	ff 45 e0             	incl   -0x20(%ebp)
  80049b:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a0:	8b 50 74             	mov    0x74(%eax),%edx
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	77 cb                	ja     800475 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b0:	74 14                	je     8004c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 50 37 80 00       	push   $0x803750
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 f0 36 80 00       	push   $0x8036f0
  8004c1:	e8 23 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 0a                	mov    %ecx,(%edx)
  8004dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004df:	88 d1                	mov    %dl,%cl
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f4:	a0 24 40 80 00       	mov    0x804024,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	8b 12                	mov    (%edx),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	83 c2 08             	add    $0x8,%edx
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	50                   	push   %eax
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	e8 7c 13 00 00       	call   801890 <sys_cputs>
  800514:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 40 04             	mov    0x4(%eax),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052f:	90                   	nop
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800542:	00 00 00 
	b.cnt = 0;
  800545:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	68 c9 04 80 00       	push   $0x8004c9
  800561:	e8 11 02 00 00       	call   800777 <vprintfmt>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800569:	a0 24 40 80 00       	mov    0x804024,%al
  80056e:	0f b6 c0             	movzbl %al,%eax
  800571:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	50                   	push   %eax
  80057b:	52                   	push   %edx
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	83 c0 08             	add    $0x8,%eax
  800585:	50                   	push   %eax
  800586:	e8 05 13 00 00       	call   801890 <sys_cputs>
  80058b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800595:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf>:

int cprintf(const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 73 ff ff ff       	call   800532 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d0:	e8 69 14 00 00       	call   801a3e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 48 ff ff ff       	call   800532 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f0:	e8 63 14 00 00       	call   801a58 <sys_enable_interrupt>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 35 2b 00 00       	call   803174 <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 f5 2b 00 00       	call   803284 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 b4 39 80 00       	add    $0x8039b4,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 af 03 00 00    	je     800b38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 55             	cmp    $0x55,%eax
  8007df:	0f 87 2b 03 00 00    	ja     800b10 <vprintfmt+0x399>
  8007e5:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 89 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 c5 39 80 00       	push   $0x8039c5
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 5e 02 00 00       	call   800b40 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 49 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 ce 39 80 00       	push   $0x8039ce
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 45 02 00 00       	call   800b40 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 30 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 0c 03 00 00       	call   800c42 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 66 01 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 23                	jmp    800b33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 25                	push   $0x25
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	eb 03                	jmp    800b28 <vprintfmt+0x3b1>
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2b:	48                   	dec    %eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 f3                	jne    800b25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	e9 47 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b46:	8d 45 10             	lea    0x10(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 16 fc ff ff       	call   800777 <vprintfmt>
  800b61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b64:	90                   	nop
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 08             	mov    0x8(%eax),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8b 40 04             	mov    0x4(%eax),%eax
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	73 12                	jae    800b9a <sprintputch+0x33>
		*b->buf++ = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 10                	mov    %dl,(%eax)
}
  800b9a:	90                   	nop
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	74 06                	je     800bca <vsnprintf+0x2d>
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	7f 07                	jg     800bd1 <vsnprintf+0x34>
		return -E_INVAL;
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	eb 20                	jmp    800bf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd1:	ff 75 14             	pushl  0x14(%ebp)
  800bd4:	ff 75 10             	pushl  0x10(%ebp)
  800bd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	68 67 0b 80 00       	push   $0x800b67
  800be0:	e8 92 fb ff ff       	call   800777 <vprintfmt>
  800be5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfc:	83 c0 04             	add    $0x4,%eax
  800bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 89 ff ff ff       	call   800b9d <vsnprintf>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 06                	jmp    800c34 <strlen+0x15>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 f1                	jne    800c2e <strlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 09                	jmp    800c5a <strnlen+0x18>
		n++;
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 4d 0c             	decl   0xc(%ebp)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 09                	je     800c69 <strnlen+0x27>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e8                	jne    800c51 <strnlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c7a:	90                   	nop
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e4                	jne    800c7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caf:	eb 1f                	jmp    800cd0 <strncpy+0x34>
		*dst++ = *src;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 03                	je     800ccd <strncpy+0x31>
			src++;
  800cca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd6:	72 d9                	jb     800cb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 30                	je     800d1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cef:	eb 16                	jmp    800d07 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 09                	je     800d19 <strlcpy+0x3c>
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 d8                	jne    800cf1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2e:	eb 06                	jmp    800d36 <strcmp+0xb>
		p++, q++;
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strcmp+0x22>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 e3                	je     800d30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d66:	eb 09                	jmp    800d71 <strncmp+0xe>
		n--, p++, q++;
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 17                	je     800d8e <strncmp+0x2b>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 0e                	je     800d8e <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 10                	mov    (%eax),%dl
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	38 c2                	cmp    %al,%dl
  800d8c:	74 da                	je     800d68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	75 07                	jne    800d9b <strncmp+0x38>
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 14                	jmp    800daf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 12                	jmp    800dd1 <strchr+0x20>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc7:	75 05                	jne    800dce <strchr+0x1d>
			return (char *) s;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	eb 11                	jmp    800ddf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 e5                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 0d                	jmp    800dfc <strfind+0x1b>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	74 0e                	je     800e07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 ea                	jne    800def <strfind+0xe>
  800e05:	eb 01                	jmp    800e08 <strfind+0x27>
		if (*s == c)
			break;
  800e07:	90                   	nop
	return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1f:	eb 0e                	jmp    800e2f <memset+0x22>
		*p++ = c;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2f:	ff 4d f8             	decl   -0x8(%ebp)
  800e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e36:	79 e9                	jns    800e21 <memset+0x14>
		*p++ = c;

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4f:	eb 16                	jmp    800e67 <memcpy+0x2a>
		*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e91:	73 50                	jae    800ee3 <memmove+0x6a>
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	76 43                	jbe    800ee3 <memmove+0x6a>
		s += n;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 10                	jmp    800ebe <memmove+0x45>
			*--d = *--s;
  800eae:	ff 4d f8             	decl   -0x8(%ebp)
  800eb1:	ff 4d fc             	decl   -0x4(%ebp)
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 e3                	jne    800eae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ecb:	eb 23                	jmp    800ef0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f07:	eb 2a                	jmp    800f33 <memcmp+0x3e>
		if (*s1 != *s2)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 16                	je     800f2d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	eb 18                	jmp    800f45 <memcmp+0x50>
		s1++, s2++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
  800f30:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f39:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	75 c9                	jne    800f09 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f58:	eb 15                	jmp    800f6f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d0             	movzbl %al,%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	0f b6 c0             	movzbl %al,%eax
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 0d                	je     800f79 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f75:	72 e3                	jb     800f5a <memfind+0x13>
  800f77:	eb 01                	jmp    800f7a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f79:	90                   	nop
	return (void *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	eb 03                	jmp    800f98 <strtol+0x19>
		s++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 20                	cmp    $0x20,%al
  800f9f:	74 f4                	je     800f95 <strtol+0x16>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 09                	cmp    $0x9,%al
  800fa8:	74 eb                	je     800f95 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2b                	cmp    $0x2b,%al
  800fb1:	75 05                	jne    800fb8 <strtol+0x39>
		s++;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	eb 13                	jmp    800fcb <strtol+0x4c>
	else if (*s == '-')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	75 0a                	jne    800fcb <strtol+0x4c>
		s++, neg = 1;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x58>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 20                	jne    800ff7 <strtol+0x78>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 17                	jne    800ff7 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	40                   	inc    %eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 78                	cmp    $0x78,%al
  800fe8:	75 0d                	jne    800ff7 <strtol+0x78>
		s += 2, base = 16;
  800fea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff5:	eb 28                	jmp    80101f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 15                	jne    801012 <strtol+0x93>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 30                	cmp    $0x30,%al
  801004:	75 0c                	jne    801012 <strtol+0x93>
		s++, base = 8;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801010:	eb 0d                	jmp    80101f <strtol+0xa0>
	else if (base == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strtol+0xa0>
		base = 10;
  801018:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 2f                	cmp    $0x2f,%al
  801026:	7e 19                	jle    801041 <strtol+0xc2>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 39                	cmp    $0x39,%al
  80102f:	7f 10                	jg     801041 <strtol+0xc2>
			dig = *s - '0';
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 30             	sub    $0x30,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 42                	jmp    801083 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 60                	cmp    $0x60,%al
  801048:	7e 19                	jle    801063 <strtol+0xe4>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 7a                	cmp    $0x7a,%al
  801051:	7f 10                	jg     801063 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 57             	sub    $0x57,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801061:	eb 20                	jmp    801083 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 40                	cmp    $0x40,%al
  80106a:	7e 39                	jle    8010a5 <strtol+0x126>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 5a                	cmp    $0x5a,%al
  801073:	7f 30                	jg     8010a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	83 e8 37             	sub    $0x37,%eax
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 10             	cmp    0x10(%ebp),%eax
  801089:	7d 19                	jge    8010a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	0f af 45 10          	imul   0x10(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109f:	e9 7b ff ff ff       	jmp    80101f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a9:	74 08                	je     8010b3 <strtol+0x134>
		*endptr = (char *) s;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 07                	je     8010c0 <strtol+0x141>
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	f7 d8                	neg    %eax
  8010be:	eb 03                	jmp    8010c3 <strtol+0x144>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dd:	79 13                	jns    8010f2 <ltostr+0x2d>
	{
		neg = 1;
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010fa:	99                   	cltd   
  8010fb:	f7 f9                	idiv   %ecx
  8010fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	8d 50 01             	lea    0x1(%eax),%edx
  801106:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801109:	89 c2                	mov    %eax,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801113:	83 c2 30             	add    $0x30,%edx
  801116:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801139:	f7 e9                	imul   %ecx
  80113b:	c1 fa 02             	sar    $0x2,%edx
  80113e:	89 c8                	mov    %ecx,%eax
  801140:	c1 f8 1f             	sar    $0x1f,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	c1 e0 02             	shl    $0x2,%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	01 c0                	add    %eax,%eax
  80114e:	29 c1                	sub    %eax,%ecx
  801150:	89 ca                	mov    %ecx,%edx
  801152:	85 d2                	test   %edx,%edx
  801154:	75 9c                	jne    8010f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	48                   	dec    %eax
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801168:	74 3d                	je     8011a7 <ltostr+0xe2>
		start = 1 ;
  80116a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801171:	eb 34                	jmp    8011a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119f:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c c4                	jl     801173 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	e8 54 fa ff ff       	call   800c1f <strlen>
  8011cb:	83 c4 04             	add    $0x4,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 46 fa ff ff       	call   800c1f <strlen>
  8011d9:	83 c4 04             	add    $0x4,%esp
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 17                	jmp    801206 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120c:	7c e1                	jl     8011ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801215:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121c:	eb 1f                	jmp    80123d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c8                	add    %ecx,%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80123a:	ff 45 f8             	incl   -0x8(%ebp)
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801243:	7c d9                	jl     80121e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801245:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	c6 00 00             	movb   $0x0,(%eax)
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801276:	eb 0c                	jmp    801284 <strsplit+0x31>
			*string++ = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 08             	mov    %edx,0x8(%ebp)
  801281:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 18                	je     8012a5 <strsplit+0x52>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f be c0             	movsbl %al,%eax
  801295:	50                   	push   %eax
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 13 fb ff ff       	call   800db1 <strchr>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	75 d3                	jne    801278 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 5a                	je     801308 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	83 f8 0f             	cmp    $0xf,%eax
  8012b6:	75 07                	jne    8012bf <strsplit+0x6c>
		{
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 66                	jmp    801325 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ca:	89 0a                	mov    %ecx,(%edx)
  8012cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	01 c2                	add    %eax,%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	eb 03                	jmp    8012e2 <strsplit+0x8f>
			string++;
  8012df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 8b                	je     801276 <strsplit+0x23>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	e8 b5 fa ff ff       	call   800db1 <strchr>
  8012fc:	83 c4 08             	add    $0x8,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 dc                	je     8012df <strsplit+0x8c>
			string++;
	}
  801303:	e9 6e ff ff ff       	jmp    801276 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801308:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801309:	8b 45 14             	mov    0x14(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80132d:	a1 04 40 80 00       	mov    0x804004,%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	74 1f                	je     801355 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801336:	e8 1d 00 00 00       	call   801358 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	68 30 3b 80 00       	push   $0x803b30
  801343:	e8 55 f2 ff ff       	call   80059d <cprintf>
  801348:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80134b:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801352:	00 00 00 
	}
}
  801355:	90                   	nop
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80135e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801365:	00 00 00 
  801368:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80136f:	00 00 00 
  801372:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801379:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80137c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801383:	00 00 00 
  801386:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80138d:	00 00 00 
  801390:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801397:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80139a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013a1:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8013a4:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8013ab:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013bf:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8013c4:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8013cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	6a 06                	push   $0x6
  8013dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e0:	50                   	push   %eax
  8013e1:	e8 ee 05 00 00       	call   8019d4 <sys_allocate_chunk>
  8013e6:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e9:	a1 20 41 80 00       	mov    0x804120,%eax
  8013ee:	83 ec 0c             	sub    $0xc,%esp
  8013f1:	50                   	push   %eax
  8013f2:	e8 63 0c 00 00       	call   80205a <initialize_MemBlocksList>
  8013f7:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8013fa:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801405:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80140c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140f:	8b 40 0c             	mov    0xc(%eax),%eax
  801412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801418:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80141d:	89 c2                	mov    %eax,%edx
  80141f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801422:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801425:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801428:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80142f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801439:	8b 50 08             	mov    0x8(%eax),%edx
  80143c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	48                   	dec    %eax
  801442:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801445:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801448:	ba 00 00 00 00       	mov    $0x0,%edx
  80144d:	f7 75 e0             	divl   -0x20(%ebp)
  801450:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801453:	29 d0                	sub    %edx,%eax
  801455:	89 c2                	mov    %eax,%edx
  801457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145a:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80145d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801461:	75 14                	jne    801477 <initialize_dyn_block_system+0x11f>
  801463:	83 ec 04             	sub    $0x4,%esp
  801466:	68 55 3b 80 00       	push   $0x803b55
  80146b:	6a 34                	push   $0x34
  80146d:	68 73 3b 80 00       	push   $0x803b73
  801472:	e8 72 ee ff ff       	call   8002e9 <_panic>
  801477:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	85 c0                	test   %eax,%eax
  80147e:	74 10                	je     801490 <initialize_dyn_block_system+0x138>
  801480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801488:	8b 52 04             	mov    0x4(%edx),%edx
  80148b:	89 50 04             	mov    %edx,0x4(%eax)
  80148e:	eb 0b                	jmp    80149b <initialize_dyn_block_system+0x143>
  801490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801493:	8b 40 04             	mov    0x4(%eax),%eax
  801496:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80149b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80149e:	8b 40 04             	mov    0x4(%eax),%eax
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	74 0f                	je     8014b4 <initialize_dyn_block_system+0x15c>
  8014a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a8:	8b 40 04             	mov    0x4(%eax),%eax
  8014ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014ae:	8b 12                	mov    (%edx),%edx
  8014b0:	89 10                	mov    %edx,(%eax)
  8014b2:	eb 0a                	jmp    8014be <initialize_dyn_block_system+0x166>
  8014b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b7:	8b 00                	mov    (%eax),%eax
  8014b9:	a3 48 41 80 00       	mov    %eax,0x804148
  8014be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014d1:	a1 54 41 80 00       	mov    0x804154,%eax
  8014d6:	48                   	dec    %eax
  8014d7:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  8014dc:	83 ec 0c             	sub    $0xc,%esp
  8014df:	ff 75 e8             	pushl  -0x18(%ebp)
  8014e2:	e8 c4 13 00 00       	call   8028ab <insert_sorted_with_merge_freeList>
  8014e7:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014ea:	90                   	nop
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <malloc>:
//=================================



void* malloc(uint32 size)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f3:	e8 2f fe ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014fc:	75 07                	jne    801505 <malloc+0x18>
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801503:	eb 71                	jmp    801576 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801505:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80150c:	76 07                	jbe    801515 <malloc+0x28>
	return NULL;
  80150e:	b8 00 00 00 00       	mov    $0x0,%eax
  801513:	eb 61                	jmp    801576 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801515:	e8 88 08 00 00       	call   801da2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80151a:	85 c0                	test   %eax,%eax
  80151c:	74 53                	je     801571 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80151e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801525:	8b 55 08             	mov    0x8(%ebp),%edx
  801528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152b:	01 d0                	add    %edx,%eax
  80152d:	48                   	dec    %eax
  80152e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	ba 00 00 00 00       	mov    $0x0,%edx
  801539:	f7 75 f4             	divl   -0xc(%ebp)
  80153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153f:	29 d0                	sub    %edx,%eax
  801541:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	ff 75 ec             	pushl  -0x14(%ebp)
  80154a:	e8 d2 0d 00 00       	call   802321 <alloc_block_FF>
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801555:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801559:	74 16                	je     801571 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  80155b:	83 ec 0c             	sub    $0xc,%esp
  80155e:	ff 75 e8             	pushl  -0x18(%ebp)
  801561:	e8 0c 0c 00 00       	call   802172 <insert_sorted_allocList>
  801566:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801569:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156c:	8b 40 08             	mov    0x8(%eax),%eax
  80156f:	eb 05                	jmp    801576 <malloc+0x89>
    }

			}


	return NULL;
  801571:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801587:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	ff 75 f0             	pushl  -0x10(%ebp)
  801595:	68 40 40 80 00       	push   $0x804040
  80159a:	e8 a0 0b 00 00       	call   80213f <find_block>
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8015a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	52                   	push   %edx
  8015b2:	50                   	push   %eax
  8015b3:	e8 e4 03 00 00       	call   80199c <sys_free_user_mem>
  8015b8:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8015bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015bf:	75 17                	jne    8015d8 <free+0x60>
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 55 3b 80 00       	push   $0x803b55
  8015c9:	68 84 00 00 00       	push   $0x84
  8015ce:	68 73 3b 80 00       	push   $0x803b73
  8015d3:	e8 11 ed ff ff       	call   8002e9 <_panic>
  8015d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015db:	8b 00                	mov    (%eax),%eax
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	74 10                	je     8015f1 <free+0x79>
  8015e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e4:	8b 00                	mov    (%eax),%eax
  8015e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e9:	8b 52 04             	mov    0x4(%edx),%edx
  8015ec:	89 50 04             	mov    %edx,0x4(%eax)
  8015ef:	eb 0b                	jmp    8015fc <free+0x84>
  8015f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f4:	8b 40 04             	mov    0x4(%eax),%eax
  8015f7:	a3 44 40 80 00       	mov    %eax,0x804044
  8015fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ff:	8b 40 04             	mov    0x4(%eax),%eax
  801602:	85 c0                	test   %eax,%eax
  801604:	74 0f                	je     801615 <free+0x9d>
  801606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801609:	8b 40 04             	mov    0x4(%eax),%eax
  80160c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80160f:	8b 12                	mov    (%edx),%edx
  801611:	89 10                	mov    %edx,(%eax)
  801613:	eb 0a                	jmp    80161f <free+0xa7>
  801615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801618:	8b 00                	mov    (%eax),%eax
  80161a:	a3 40 40 80 00       	mov    %eax,0x804040
  80161f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801632:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801637:	48                   	dec    %eax
  801638:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff 75 ec             	pushl  -0x14(%ebp)
  801643:	e8 63 12 00 00       	call   8028ab <insert_sorted_with_merge_freeList>
  801648:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80164b:	90                   	nop
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 38             	sub    $0x38,%esp
  801654:	8b 45 10             	mov    0x10(%ebp),%eax
  801657:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165a:	e8 c8 fc ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  80165f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801663:	75 0a                	jne    80166f <smalloc+0x21>
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
  80166a:	e9 a0 00 00 00       	jmp    80170f <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80166f:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801676:	76 0a                	jbe    801682 <smalloc+0x34>
		return NULL;
  801678:	b8 00 00 00 00       	mov    $0x0,%eax
  80167d:	e9 8d 00 00 00       	jmp    80170f <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801682:	e8 1b 07 00 00       	call   801da2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801687:	85 c0                	test   %eax,%eax
  801689:	74 7f                	je     80170a <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80168b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801692:	8b 55 0c             	mov    0xc(%ebp),%edx
  801695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801698:	01 d0                	add    %edx,%eax
  80169a:	48                   	dec    %eax
  80169b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a6:	f7 75 f4             	divl   -0xc(%ebp)
  8016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ac:	29 d0                	sub    %edx,%eax
  8016ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8016b1:	83 ec 0c             	sub    $0xc,%esp
  8016b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b7:	e8 65 0c 00 00       	call   802321 <alloc_block_FF>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8016c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016c6:	74 42                	je     80170a <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8016c8:	83 ec 0c             	sub    $0xc,%esp
  8016cb:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ce:	e8 9f 0a 00 00       	call   802172 <insert_sorted_allocList>
  8016d3:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8016d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d9:	8b 40 08             	mov    0x8(%eax),%eax
  8016dc:	89 c2                	mov    %eax,%edx
  8016de:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016e2:	52                   	push   %edx
  8016e3:	50                   	push   %eax
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	ff 75 08             	pushl  0x8(%ebp)
  8016ea:	e8 38 04 00 00       	call   801b27 <sys_createSharedObject>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8016f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016f9:	79 07                	jns    801702 <smalloc+0xb4>
	    		  return NULL;
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801700:	eb 0d                	jmp    80170f <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801705:	8b 40 08             	mov    0x8(%eax),%eax
  801708:	eb 05                	jmp    80170f <smalloc+0xc1>


				}


		return NULL;
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801717:	e8 0b fc ff ff       	call   801327 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80171c:	e8 81 06 00 00       	call   801da2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801721:	85 c0                	test   %eax,%eax
  801723:	0f 84 9f 00 00 00    	je     8017c8 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 1a 04 00 00       	call   801b51 <sys_getSizeOfSharedObject>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80173d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801741:	79 0a                	jns    80174d <sget+0x3c>
		return NULL;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
  801748:	e9 80 00 00 00       	jmp    8017cd <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80174d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175a:	01 d0                	add    %edx,%eax
  80175c:	48                   	dec    %eax
  80175d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801763:	ba 00 00 00 00       	mov    $0x0,%edx
  801768:	f7 75 f0             	divl   -0x10(%ebp)
  80176b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176e:	29 d0                	sub    %edx,%eax
  801770:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801773:	83 ec 0c             	sub    $0xc,%esp
  801776:	ff 75 e8             	pushl  -0x18(%ebp)
  801779:	e8 a3 0b 00 00       	call   802321 <alloc_block_FF>
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801784:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801788:	74 3e                	je     8017c8 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80178a:	83 ec 0c             	sub    $0xc,%esp
  80178d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801790:	e8 dd 09 00 00       	call   802172 <insert_sorted_allocList>
  801795:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80179b:	8b 40 08             	mov    0x8(%eax),%eax
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	50                   	push   %eax
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	e8 c1 03 00 00       	call   801b6e <sys_getSharedObject>
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8017b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017b7:	79 07                	jns    8017c0 <sget+0xaf>
	    		  return NULL;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017be:	eb 0d                	jmp    8017cd <sget+0xbc>
	  	return(void*) returned_block->sva;
  8017c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c3:	8b 40 08             	mov    0x8(%eax),%eax
  8017c6:	eb 05                	jmp    8017cd <sget+0xbc>
	      }
	}
	   return NULL;
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d5:	e8 4d fb ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 80 3b 80 00       	push   $0x803b80
  8017e2:	68 12 01 00 00       	push   $0x112
  8017e7:	68 73 3b 80 00       	push   $0x803b73
  8017ec:	e8 f8 ea ff ff       	call   8002e9 <_panic>

008017f1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 a8 3b 80 00       	push   $0x803ba8
  8017ff:	68 26 01 00 00       	push   $0x126
  801804:	68 73 3b 80 00       	push   $0x803b73
  801809:	e8 db ea ff ff       	call   8002e9 <_panic>

0080180e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 cc 3b 80 00       	push   $0x803bcc
  80181c:	68 31 01 00 00       	push   $0x131
  801821:	68 73 3b 80 00       	push   $0x803b73
  801826:	e8 be ea ff ff       	call   8002e9 <_panic>

0080182b <shrink>:

}
void shrink(uint32 newSize)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	68 cc 3b 80 00       	push   $0x803bcc
  801839:	68 36 01 00 00       	push   $0x136
  80183e:	68 73 3b 80 00       	push   $0x803b73
  801843:	e8 a1 ea ff ff       	call   8002e9 <_panic>

00801848 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184e:	83 ec 04             	sub    $0x4,%esp
  801851:	68 cc 3b 80 00       	push   $0x803bcc
  801856:	68 3b 01 00 00       	push   $0x13b
  80185b:	68 73 3b 80 00       	push   $0x803b73
  801860:	e8 84 ea ff ff       	call   8002e9 <_panic>

00801865 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	57                   	push   %edi
  801869:	56                   	push   %esi
  80186a:	53                   	push   %ebx
  80186b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
  801874:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801877:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80187d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801880:	cd 30                	int    $0x30
  801882:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801885:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5f                   	pop    %edi
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    

00801890 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	8b 45 10             	mov    0x10(%ebp),%eax
  801899:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80189c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	52                   	push   %edx
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	50                   	push   %eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	e8 b2 ff ff ff       	call   801865 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	90                   	nop
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 01                	push   $0x1
  8018c8:	e8 98 ff ff ff       	call   801865 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	52                   	push   %edx
  8018e2:	50                   	push   %eax
  8018e3:	6a 05                	push   $0x5
  8018e5:	e8 7b ff ff ff       	call   801865 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018f4:	8b 75 18             	mov    0x18(%ebp),%esi
  8018f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	51                   	push   %ecx
  801906:	52                   	push   %edx
  801907:	50                   	push   %eax
  801908:	6a 06                	push   $0x6
  80190a:	e8 56 ff ff ff       	call   801865 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	6a 07                	push   $0x7
  80192c:	e8 34 ff ff ff       	call   801865 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	ff 75 08             	pushl  0x8(%ebp)
  801945:	6a 08                	push   $0x8
  801947:	e8 19 ff ff ff       	call   801865 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 09                	push   $0x9
  801960:	e8 00 ff ff ff       	call   801865 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 0a                	push   $0xa
  801979:	e8 e7 fe ff ff       	call   801865 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 0b                	push   $0xb
  801992:	e8 ce fe ff ff       	call   801865 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	ff 75 0c             	pushl  0xc(%ebp)
  8019a8:	ff 75 08             	pushl  0x8(%ebp)
  8019ab:	6a 0f                	push   $0xf
  8019ad:	e8 b3 fe ff ff       	call   801865 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
	return;
  8019b5:	90                   	nop
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	6a 10                	push   $0x10
  8019c9:	e8 97 fe ff ff       	call   801865 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 10             	pushl  0x10(%ebp)
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	6a 11                	push   $0x11
  8019e6:	e8 7a fe ff ff       	call   801865 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ee:	90                   	nop
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 0c                	push   $0xc
  801a00:	e8 60 fe ff ff       	call   801865 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	6a 0d                	push   $0xd
  801a1a:	e8 46 fe ff ff       	call   801865 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 0e                	push   $0xe
  801a33:	e8 2d fe ff ff       	call   801865 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 13                	push   $0x13
  801a4d:	e8 13 fe ff ff       	call   801865 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	90                   	nop
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 14                	push   $0x14
  801a67:	e8 f9 fd ff ff       	call   801865 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a7e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	50                   	push   %eax
  801a8b:	6a 15                	push   $0x15
  801a8d:	e8 d3 fd ff ff       	call   801865 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 16                	push   $0x16
  801aa7:	e8 b9 fd ff ff       	call   801865 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	90                   	nop
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	ff 75 0c             	pushl  0xc(%ebp)
  801ac1:	50                   	push   %eax
  801ac2:	6a 17                	push   $0x17
  801ac4:	e8 9c fd ff ff       	call   801865 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	52                   	push   %edx
  801ade:	50                   	push   %eax
  801adf:	6a 1a                	push   $0x1a
  801ae1:	e8 7f fd ff ff       	call   801865 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	52                   	push   %edx
  801afb:	50                   	push   %eax
  801afc:	6a 18                	push   $0x18
  801afe:	e8 62 fd ff ff       	call   801865 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	52                   	push   %edx
  801b19:	50                   	push   %eax
  801b1a:	6a 19                	push   $0x19
  801b1c:	e8 44 fd ff ff       	call   801865 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	90                   	nop
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b30:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b33:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b36:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	51                   	push   %ecx
  801b40:	52                   	push   %edx
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	50                   	push   %eax
  801b45:	6a 1b                	push   $0x1b
  801b47:	e8 19 fd ff ff       	call   801865 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	6a 1c                	push   $0x1c
  801b64:	e8 fc fc ff ff       	call   801865 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b71:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	51                   	push   %ecx
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 1d                	push   $0x1d
  801b83:	e8 dd fc ff ff       	call   801865 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	52                   	push   %edx
  801b9d:	50                   	push   %eax
  801b9e:	6a 1e                	push   $0x1e
  801ba0:	e8 c0 fc ff ff       	call   801865 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 1f                	push   $0x1f
  801bb9:	e8 a7 fc ff ff       	call   801865 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	ff 75 14             	pushl  0x14(%ebp)
  801bce:	ff 75 10             	pushl  0x10(%ebp)
  801bd1:	ff 75 0c             	pushl  0xc(%ebp)
  801bd4:	50                   	push   %eax
  801bd5:	6a 20                	push   $0x20
  801bd7:	e8 89 fc ff ff       	call   801865 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	50                   	push   %eax
  801bf0:	6a 21                	push   $0x21
  801bf2:	e8 6e fc ff ff       	call   801865 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	90                   	nop
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	50                   	push   %eax
  801c0c:	6a 22                	push   $0x22
  801c0e:	e8 52 fc ff ff       	call   801865 <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 02                	push   $0x2
  801c27:	e8 39 fc ff ff       	call   801865 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 03                	push   $0x3
  801c40:	e8 20 fc ff ff       	call   801865 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 04                	push   $0x4
  801c59:	e8 07 fc ff ff       	call   801865 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_exit_env>:


void sys_exit_env(void)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 23                	push   $0x23
  801c72:	e8 ee fb ff ff       	call   801865 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	90                   	nop
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c83:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c86:	8d 50 04             	lea    0x4(%eax),%edx
  801c89:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	52                   	push   %edx
  801c93:	50                   	push   %eax
  801c94:	6a 24                	push   $0x24
  801c96:	e8 ca fb ff ff       	call   801865 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca7:	89 01                	mov    %eax,(%ecx)
  801ca9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	c9                   	leave  
  801cb0:	c2 04 00             	ret    $0x4

00801cb3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	ff 75 10             	pushl  0x10(%ebp)
  801cbd:	ff 75 0c             	pushl  0xc(%ebp)
  801cc0:	ff 75 08             	pushl  0x8(%ebp)
  801cc3:	6a 12                	push   $0x12
  801cc5:	e8 9b fb ff ff       	call   801865 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccd:	90                   	nop
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 25                	push   $0x25
  801cdf:	e8 81 fb ff ff       	call   801865 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	50                   	push   %eax
  801d02:	6a 26                	push   $0x26
  801d04:	e8 5c fb ff ff       	call   801865 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0c:	90                   	nop
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <rsttst>:
void rsttst()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 28                	push   $0x28
  801d1e:	e8 42 fb ff ff       	call   801865 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
	return ;
  801d26:	90                   	nop
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d35:	8b 55 18             	mov    0x18(%ebp),%edx
  801d38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	ff 75 10             	pushl  0x10(%ebp)
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	ff 75 08             	pushl  0x8(%ebp)
  801d47:	6a 27                	push   $0x27
  801d49:	e8 17 fb ff ff       	call   801865 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d51:	90                   	nop
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <chktst>:
void chktst(uint32 n)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 08             	pushl  0x8(%ebp)
  801d62:	6a 29                	push   $0x29
  801d64:	e8 fc fa ff ff       	call   801865 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6c:	90                   	nop
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <inctst>:

void inctst()
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 2a                	push   $0x2a
  801d7e:	e8 e2 fa ff ff       	call   801865 <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
	return ;
  801d86:	90                   	nop
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <gettst>:
uint32 gettst()
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 2b                	push   $0x2b
  801d98:	e8 c8 fa ff ff       	call   801865 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 2c                	push   $0x2c
  801db4:	e8 ac fa ff ff       	call   801865 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
  801dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dbf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dc3:	75 07                	jne    801dcc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dca:	eb 05                	jmp    801dd1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 2c                	push   $0x2c
  801de5:	e8 7b fa ff ff       	call   801865 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
  801ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801df0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df4:	75 07                	jne    801dfd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfb:	eb 05                	jmp    801e02 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 2c                	push   $0x2c
  801e16:	e8 4a fa ff ff       	call   801865 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
  801e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e21:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e25:	75 07                	jne    801e2e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e27:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2c:	eb 05                	jmp    801e33 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 2c                	push   $0x2c
  801e47:	e8 19 fa ff ff       	call   801865 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
  801e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e52:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e56:	75 07                	jne    801e5f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e58:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5d:	eb 05                	jmp    801e64 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	ff 75 08             	pushl  0x8(%ebp)
  801e74:	6a 2d                	push   $0x2d
  801e76:	e8 ea f9 ff ff       	call   801865 <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7e:	90                   	nop
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e85:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	6a 00                	push   $0x0
  801e93:	53                   	push   %ebx
  801e94:	51                   	push   %ecx
  801e95:	52                   	push   %edx
  801e96:	50                   	push   %eax
  801e97:	6a 2e                	push   $0x2e
  801e99:	e8 c7 f9 ff ff       	call   801865 <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
}
  801ea1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	52                   	push   %edx
  801eb6:	50                   	push   %eax
  801eb7:	6a 2f                	push   $0x2f
  801eb9:	e8 a7 f9 ff ff       	call   801865 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ec9:	83 ec 0c             	sub    $0xc,%esp
  801ecc:	68 dc 3b 80 00       	push   $0x803bdc
  801ed1:	e8 c7 e6 ff ff       	call   80059d <cprintf>
  801ed6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ed9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	68 08 3c 80 00       	push   $0x803c08
  801ee8:	e8 b0 e6 ff ff       	call   80059d <cprintf>
  801eed:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ef0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ef4:	a1 38 41 80 00       	mov    0x804138,%eax
  801ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801efc:	eb 56                	jmp    801f54 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801efe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f02:	74 1c                	je     801f20 <print_mem_block_lists+0x5d>
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	8b 50 08             	mov    0x8(%eax),%edx
  801f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0d:	8b 48 08             	mov    0x8(%eax),%ecx
  801f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f13:	8b 40 0c             	mov    0xc(%eax),%eax
  801f16:	01 c8                	add    %ecx,%eax
  801f18:	39 c2                	cmp    %eax,%edx
  801f1a:	73 04                	jae    801f20 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f1c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 50 08             	mov    0x8(%eax),%edx
  801f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f29:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2c:	01 c2                	add    %eax,%edx
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	8b 40 08             	mov    0x8(%eax),%eax
  801f34:	83 ec 04             	sub    $0x4,%esp
  801f37:	52                   	push   %edx
  801f38:	50                   	push   %eax
  801f39:	68 1d 3c 80 00       	push   $0x803c1d
  801f3e:	e8 5a e6 ff ff       	call   80059d <cprintf>
  801f43:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f4c:	a1 40 41 80 00       	mov    0x804140,%eax
  801f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f58:	74 07                	je     801f61 <print_mem_block_lists+0x9e>
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	8b 00                	mov    (%eax),%eax
  801f5f:	eb 05                	jmp    801f66 <print_mem_block_lists+0xa3>
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	a3 40 41 80 00       	mov    %eax,0x804140
  801f6b:	a1 40 41 80 00       	mov    0x804140,%eax
  801f70:	85 c0                	test   %eax,%eax
  801f72:	75 8a                	jne    801efe <print_mem_block_lists+0x3b>
  801f74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f78:	75 84                	jne    801efe <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f7a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f7e:	75 10                	jne    801f90 <print_mem_block_lists+0xcd>
  801f80:	83 ec 0c             	sub    $0xc,%esp
  801f83:	68 2c 3c 80 00       	push   $0x803c2c
  801f88:	e8 10 e6 ff ff       	call   80059d <cprintf>
  801f8d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	68 50 3c 80 00       	push   $0x803c50
  801f9f:	e8 f9 e5 ff ff       	call   80059d <cprintf>
  801fa4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fa7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fab:	a1 40 40 80 00       	mov    0x804040,%eax
  801fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb3:	eb 56                	jmp    80200b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb9:	74 1c                	je     801fd7 <print_mem_block_lists+0x114>
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	8b 50 08             	mov    0x8(%eax),%edx
  801fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc4:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fca:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcd:	01 c8                	add    %ecx,%eax
  801fcf:	39 c2                	cmp    %eax,%edx
  801fd1:	73 04                	jae    801fd7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fd3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	8b 50 08             	mov    0x8(%eax),%edx
  801fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe3:	01 c2                	add    %eax,%edx
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	8b 40 08             	mov    0x8(%eax),%eax
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	52                   	push   %edx
  801fef:	50                   	push   %eax
  801ff0:	68 1d 3c 80 00       	push   $0x803c1d
  801ff5:	e8 a3 e5 ff ff       	call   80059d <cprintf>
  801ffa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802003:	a1 48 40 80 00       	mov    0x804048,%eax
  802008:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200f:	74 07                	je     802018 <print_mem_block_lists+0x155>
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 00                	mov    (%eax),%eax
  802016:	eb 05                	jmp    80201d <print_mem_block_lists+0x15a>
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
  80201d:	a3 48 40 80 00       	mov    %eax,0x804048
  802022:	a1 48 40 80 00       	mov    0x804048,%eax
  802027:	85 c0                	test   %eax,%eax
  802029:	75 8a                	jne    801fb5 <print_mem_block_lists+0xf2>
  80202b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202f:	75 84                	jne    801fb5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802031:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802035:	75 10                	jne    802047 <print_mem_block_lists+0x184>
  802037:	83 ec 0c             	sub    $0xc,%esp
  80203a:	68 68 3c 80 00       	push   $0x803c68
  80203f:	e8 59 e5 ff ff       	call   80059d <cprintf>
  802044:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802047:	83 ec 0c             	sub    $0xc,%esp
  80204a:	68 dc 3b 80 00       	push   $0x803bdc
  80204f:	e8 49 e5 ff ff       	call   80059d <cprintf>
  802054:	83 c4 10             	add    $0x10,%esp

}
  802057:	90                   	nop
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802060:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802067:	00 00 00 
  80206a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802071:	00 00 00 
  802074:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80207b:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80207e:	a1 50 40 80 00       	mov    0x804050,%eax
  802083:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80208d:	e9 9e 00 00 00       	jmp    802130 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802092:	a1 50 40 80 00       	mov    0x804050,%eax
  802097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209a:	c1 e2 04             	shl    $0x4,%edx
  80209d:	01 d0                	add    %edx,%eax
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	75 14                	jne    8020b7 <initialize_MemBlocksList+0x5d>
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	68 90 3c 80 00       	push   $0x803c90
  8020ab:	6a 48                	push   $0x48
  8020ad:	68 b3 3c 80 00       	push   $0x803cb3
  8020b2:	e8 32 e2 ff ff       	call   8002e9 <_panic>
  8020b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bf:	c1 e2 04             	shl    $0x4,%edx
  8020c2:	01 d0                	add    %edx,%eax
  8020c4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020ca:	89 10                	mov    %edx,(%eax)
  8020cc:	8b 00                	mov    (%eax),%eax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	74 18                	je     8020ea <initialize_MemBlocksList+0x90>
  8020d2:	a1 48 41 80 00       	mov    0x804148,%eax
  8020d7:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020dd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020e0:	c1 e1 04             	shl    $0x4,%ecx
  8020e3:	01 ca                	add    %ecx,%edx
  8020e5:	89 50 04             	mov    %edx,0x4(%eax)
  8020e8:	eb 12                	jmp    8020fc <initialize_MemBlocksList+0xa2>
  8020ea:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f2:	c1 e2 04             	shl    $0x4,%edx
  8020f5:	01 d0                	add    %edx,%eax
  8020f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020fc:	a1 50 40 80 00       	mov    0x804050,%eax
  802101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802104:	c1 e2 04             	shl    $0x4,%edx
  802107:	01 d0                	add    %edx,%eax
  802109:	a3 48 41 80 00       	mov    %eax,0x804148
  80210e:	a1 50 40 80 00       	mov    0x804050,%eax
  802113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802116:	c1 e2 04             	shl    $0x4,%edx
  802119:	01 d0                	add    %edx,%eax
  80211b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802122:	a1 54 41 80 00       	mov    0x804154,%eax
  802127:	40                   	inc    %eax
  802128:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80212d:	ff 45 f4             	incl   -0xc(%ebp)
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	3b 45 08             	cmp    0x8(%ebp),%eax
  802136:	0f 82 56 ff ff ff    	jb     802092 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80213c:	90                   	nop
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	8b 00                	mov    (%eax),%eax
  80214a:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80214d:	eb 18                	jmp    802167 <find_block+0x28>
		{
			if(tmp->sva==va)
  80214f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802152:	8b 40 08             	mov    0x8(%eax),%eax
  802155:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802158:	75 05                	jne    80215f <find_block+0x20>
			{
				return tmp;
  80215a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215d:	eb 11                	jmp    802170 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80215f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802162:	8b 00                	mov    (%eax),%eax
  802164:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802167:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80216b:	75 e2                	jne    80214f <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80216d:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802178:	a1 40 40 80 00       	mov    0x804040,%eax
  80217d:	85 c0                	test   %eax,%eax
  80217f:	0f 85 83 00 00 00    	jne    802208 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802185:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80218c:	00 00 00 
  80218f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  802196:	00 00 00 
  802199:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8021a0:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a7:	75 14                	jne    8021bd <insert_sorted_allocList+0x4b>
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	68 90 3c 80 00       	push   $0x803c90
  8021b1:	6a 7f                	push   $0x7f
  8021b3:	68 b3 3c 80 00       	push   $0x803cb3
  8021b8:	e8 2c e1 ff ff       	call   8002e9 <_panic>
  8021bd:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	89 10                	mov    %edx,(%eax)
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8b 00                	mov    (%eax),%eax
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	74 0d                	je     8021de <insert_sorted_allocList+0x6c>
  8021d1:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	89 50 04             	mov    %edx,0x4(%eax)
  8021dc:	eb 08                	jmp    8021e6 <insert_sorted_allocList+0x74>
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	a3 44 40 80 00       	mov    %eax,0x804044
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	a3 40 40 80 00       	mov    %eax,0x804040
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021fd:	40                   	inc    %eax
  8021fe:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802203:	e9 16 01 00 00       	jmp    80231e <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8b 50 08             	mov    0x8(%eax),%edx
  80220e:	a1 44 40 80 00       	mov    0x804044,%eax
  802213:	8b 40 08             	mov    0x8(%eax),%eax
  802216:	39 c2                	cmp    %eax,%edx
  802218:	76 68                	jbe    802282 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80221a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221e:	75 17                	jne    802237 <insert_sorted_allocList+0xc5>
  802220:	83 ec 04             	sub    $0x4,%esp
  802223:	68 cc 3c 80 00       	push   $0x803ccc
  802228:	68 85 00 00 00       	push   $0x85
  80222d:	68 b3 3c 80 00       	push   $0x803cb3
  802232:	e8 b2 e0 ff ff       	call   8002e9 <_panic>
  802237:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	89 50 04             	mov    %edx,0x4(%eax)
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	8b 40 04             	mov    0x4(%eax),%eax
  802249:	85 c0                	test   %eax,%eax
  80224b:	74 0c                	je     802259 <insert_sorted_allocList+0xe7>
  80224d:	a1 44 40 80 00       	mov    0x804044,%eax
  802252:	8b 55 08             	mov    0x8(%ebp),%edx
  802255:	89 10                	mov    %edx,(%eax)
  802257:	eb 08                	jmp    802261 <insert_sorted_allocList+0xef>
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	a3 40 40 80 00       	mov    %eax,0x804040
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	a3 44 40 80 00       	mov    %eax,0x804044
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802272:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802277:	40                   	inc    %eax
  802278:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80227d:	e9 9c 00 00 00       	jmp    80231e <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802282:	a1 40 40 80 00       	mov    0x804040,%eax
  802287:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80228a:	e9 85 00 00 00       	jmp    802314 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	8b 50 08             	mov    0x8(%eax),%edx
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 40 08             	mov    0x8(%eax),%eax
  80229b:	39 c2                	cmp    %eax,%edx
  80229d:	73 6d                	jae    80230c <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  80229f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a3:	74 06                	je     8022ab <insert_sorted_allocList+0x139>
  8022a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a9:	75 17                	jne    8022c2 <insert_sorted_allocList+0x150>
  8022ab:	83 ec 04             	sub    $0x4,%esp
  8022ae:	68 f0 3c 80 00       	push   $0x803cf0
  8022b3:	68 90 00 00 00       	push   $0x90
  8022b8:	68 b3 3c 80 00       	push   $0x803cb3
  8022bd:	e8 27 e0 ff ff       	call   8002e9 <_panic>
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 50 04             	mov    0x4(%eax),%edx
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	89 50 04             	mov    %edx,0x4(%eax)
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 40 04             	mov    0x4(%eax),%eax
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	74 0d                	je     8022ed <insert_sorted_allocList+0x17b>
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	8b 40 04             	mov    0x4(%eax),%eax
  8022e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e9:	89 10                	mov    %edx,(%eax)
  8022eb:	eb 08                	jmp    8022f5 <insert_sorted_allocList+0x183>
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fb:	89 50 04             	mov    %edx,0x4(%eax)
  8022fe:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802303:	40                   	inc    %eax
  802304:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802309:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80230a:	eb 12                	jmp    80231e <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 00                	mov    (%eax),%eax
  802311:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802318:	0f 85 71 ff ff ff    	jne    80228f <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80231e:	90                   	nop
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802327:	a1 38 41 80 00       	mov    0x804138,%eax
  80232c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80232f:	e9 76 01 00 00       	jmp    8024aa <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 40 0c             	mov    0xc(%eax),%eax
  80233a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233d:	0f 85 8a 00 00 00    	jne    8023cd <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802343:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802347:	75 17                	jne    802360 <alloc_block_FF+0x3f>
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	68 25 3d 80 00       	push   $0x803d25
  802351:	68 a8 00 00 00       	push   $0xa8
  802356:	68 b3 3c 80 00       	push   $0x803cb3
  80235b:	e8 89 df ff ff       	call   8002e9 <_panic>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	74 10                	je     802379 <alloc_block_FF+0x58>
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 00                	mov    (%eax),%eax
  80236e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802371:	8b 52 04             	mov    0x4(%edx),%edx
  802374:	89 50 04             	mov    %edx,0x4(%eax)
  802377:	eb 0b                	jmp    802384 <alloc_block_FF+0x63>
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 40 04             	mov    0x4(%eax),%eax
  80237f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 40 04             	mov    0x4(%eax),%eax
  80238a:	85 c0                	test   %eax,%eax
  80238c:	74 0f                	je     80239d <alloc_block_FF+0x7c>
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 40 04             	mov    0x4(%eax),%eax
  802394:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802397:	8b 12                	mov    (%edx),%edx
  802399:	89 10                	mov    %edx,(%eax)
  80239b:	eb 0a                	jmp    8023a7 <alloc_block_FF+0x86>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	a3 38 41 80 00       	mov    %eax,0x804138
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ba:	a1 44 41 80 00       	mov    0x804144,%eax
  8023bf:	48                   	dec    %eax
  8023c0:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	e9 ea 00 00 00       	jmp    8024b7 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d6:	0f 86 c6 00 00 00    	jbe    8024a2 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8023dc:	a1 48 41 80 00       	mov    0x804148,%eax
  8023e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8023e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ea:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 50 08             	mov    0x8(%eax),%edx
  8023f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f6:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ff:	2b 45 08             	sub    0x8(%ebp),%eax
  802402:	89 c2                	mov    %eax,%edx
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 50 08             	mov    0x8(%eax),%edx
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	01 c2                	add    %eax,%edx
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80241b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80241f:	75 17                	jne    802438 <alloc_block_FF+0x117>
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	68 25 3d 80 00       	push   $0x803d25
  802429:	68 b6 00 00 00       	push   $0xb6
  80242e:	68 b3 3c 80 00       	push   $0x803cb3
  802433:	e8 b1 de ff ff       	call   8002e9 <_panic>
  802438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	85 c0                	test   %eax,%eax
  80243f:	74 10                	je     802451 <alloc_block_FF+0x130>
  802441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802444:	8b 00                	mov    (%eax),%eax
  802446:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802449:	8b 52 04             	mov    0x4(%edx),%edx
  80244c:	89 50 04             	mov    %edx,0x4(%eax)
  80244f:	eb 0b                	jmp    80245c <alloc_block_FF+0x13b>
  802451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802454:	8b 40 04             	mov    0x4(%eax),%eax
  802457:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	85 c0                	test   %eax,%eax
  802464:	74 0f                	je     802475 <alloc_block_FF+0x154>
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802469:	8b 40 04             	mov    0x4(%eax),%eax
  80246c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80246f:	8b 12                	mov    (%edx),%edx
  802471:	89 10                	mov    %edx,(%eax)
  802473:	eb 0a                	jmp    80247f <alloc_block_FF+0x15e>
  802475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	a3 48 41 80 00       	mov    %eax,0x804148
  80247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802492:	a1 54 41 80 00       	mov    0x804154,%eax
  802497:	48                   	dec    %eax
  802498:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  80249d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a0:	eb 15                	jmp    8024b7 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8024aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ae:	0f 85 80 fe ff ff    	jne    802334 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024bf:	a1 38 41 80 00       	mov    0x804138,%eax
  8024c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8024c7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8024ce:	e9 c0 00 00 00       	jmp    802593 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dc:	0f 85 8a 00 00 00    	jne    80256c <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	75 17                	jne    8024ff <alloc_block_BF+0x46>
  8024e8:	83 ec 04             	sub    $0x4,%esp
  8024eb:	68 25 3d 80 00       	push   $0x803d25
  8024f0:	68 cf 00 00 00       	push   $0xcf
  8024f5:	68 b3 3c 80 00       	push   $0x803cb3
  8024fa:	e8 ea dd ff ff       	call   8002e9 <_panic>
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 00                	mov    (%eax),%eax
  802504:	85 c0                	test   %eax,%eax
  802506:	74 10                	je     802518 <alloc_block_BF+0x5f>
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 00                	mov    (%eax),%eax
  80250d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802510:	8b 52 04             	mov    0x4(%edx),%edx
  802513:	89 50 04             	mov    %edx,0x4(%eax)
  802516:	eb 0b                	jmp    802523 <alloc_block_BF+0x6a>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 04             	mov    0x4(%eax),%eax
  80251e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 40 04             	mov    0x4(%eax),%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	74 0f                	je     80253c <alloc_block_BF+0x83>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 04             	mov    0x4(%eax),%eax
  802533:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802536:	8b 12                	mov    (%edx),%edx
  802538:	89 10                	mov    %edx,(%eax)
  80253a:	eb 0a                	jmp    802546 <alloc_block_BF+0x8d>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	a3 38 41 80 00       	mov    %eax,0x804138
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802559:	a1 44 41 80 00       	mov    0x804144,%eax
  80255e:	48                   	dec    %eax
  80255f:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	e9 2a 01 00 00       	jmp    802696 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 40 0c             	mov    0xc(%eax),%eax
  802572:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802575:	73 14                	jae    80258b <alloc_block_BF+0xd2>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 0c             	mov    0xc(%eax),%eax
  80257d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802580:	76 09                	jbe    80258b <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 0c             	mov    0xc(%eax),%eax
  802588:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802593:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802597:	0f 85 36 ff ff ff    	jne    8024d3 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80259d:	a1 38 41 80 00       	mov    0x804138,%eax
  8025a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8025a5:	e9 dd 00 00 00       	jmp    802687 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025b3:	0f 85 c6 00 00 00    	jne    80267f <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8025b9:	a1 48 41 80 00       	mov    0x804148,%eax
  8025be:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 50 08             	mov    0x8(%eax),%edx
  8025c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ca:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8025cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d3:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 50 08             	mov    0x8(%eax),%edx
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	01 c2                	add    %eax,%edx
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ed:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f0:	89 c2                	mov    %eax,%edx
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8025f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025fc:	75 17                	jne    802615 <alloc_block_BF+0x15c>
  8025fe:	83 ec 04             	sub    $0x4,%esp
  802601:	68 25 3d 80 00       	push   $0x803d25
  802606:	68 eb 00 00 00       	push   $0xeb
  80260b:	68 b3 3c 80 00       	push   $0x803cb3
  802610:	e8 d4 dc ff ff       	call   8002e9 <_panic>
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	85 c0                	test   %eax,%eax
  80261c:	74 10                	je     80262e <alloc_block_BF+0x175>
  80261e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802626:	8b 52 04             	mov    0x4(%edx),%edx
  802629:	89 50 04             	mov    %edx,0x4(%eax)
  80262c:	eb 0b                	jmp    802639 <alloc_block_BF+0x180>
  80262e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802631:	8b 40 04             	mov    0x4(%eax),%eax
  802634:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 0f                	je     802652 <alloc_block_BF+0x199>
  802643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802646:	8b 40 04             	mov    0x4(%eax),%eax
  802649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264c:	8b 12                	mov    (%edx),%edx
  80264e:	89 10                	mov    %edx,(%eax)
  802650:	eb 0a                	jmp    80265c <alloc_block_BF+0x1a3>
  802652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	a3 48 41 80 00       	mov    %eax,0x804148
  80265c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802668:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266f:	a1 54 41 80 00       	mov    0x804154,%eax
  802674:	48                   	dec    %eax
  802675:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  80267a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267d:	eb 17                	jmp    802696 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268b:	0f 85 19 ff ff ff    	jne    8025aa <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802691:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
  80269b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80269e:	a1 40 40 80 00       	mov    0x804040,%eax
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	75 19                	jne    8026c0 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	ff 75 08             	pushl  0x8(%ebp)
  8026ad:	e8 6f fc ff ff       	call   802321 <alloc_block_FF>
  8026b2:	83 c4 10             	add    $0x10,%esp
  8026b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	e9 e9 01 00 00       	jmp    8028a9 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8026c0:	a1 44 40 80 00       	mov    0x804044,%eax
  8026c5:	8b 40 08             	mov    0x8(%eax),%eax
  8026c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8026cb:	a1 44 40 80 00       	mov    0x804044,%eax
  8026d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8026d3:	a1 44 40 80 00       	mov    0x804044,%eax
  8026d8:	8b 40 08             	mov    0x8(%eax),%eax
  8026db:	01 d0                	add    %edx,%eax
  8026dd:	83 ec 08             	sub    $0x8,%esp
  8026e0:	50                   	push   %eax
  8026e1:	68 38 41 80 00       	push   $0x804138
  8026e6:	e8 54 fa ff ff       	call   80213f <find_block>
  8026eb:	83 c4 10             	add    $0x10,%esp
  8026ee:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fa:	0f 85 9b 00 00 00    	jne    80279b <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 50 0c             	mov    0xc(%eax),%edx
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 40 08             	mov    0x8(%eax),%eax
  80270c:	01 d0                	add    %edx,%eax
  80270e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802715:	75 17                	jne    80272e <alloc_block_NF+0x96>
  802717:	83 ec 04             	sub    $0x4,%esp
  80271a:	68 25 3d 80 00       	push   $0x803d25
  80271f:	68 1a 01 00 00       	push   $0x11a
  802724:	68 b3 3c 80 00       	push   $0x803cb3
  802729:	e8 bb db ff ff       	call   8002e9 <_panic>
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	74 10                	je     802747 <alloc_block_NF+0xaf>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273f:	8b 52 04             	mov    0x4(%edx),%edx
  802742:	89 50 04             	mov    %edx,0x4(%eax)
  802745:	eb 0b                	jmp    802752 <alloc_block_NF+0xba>
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 04             	mov    0x4(%eax),%eax
  80274d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	74 0f                	je     80276b <alloc_block_NF+0xd3>
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 40 04             	mov    0x4(%eax),%eax
  802762:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802765:	8b 12                	mov    (%edx),%edx
  802767:	89 10                	mov    %edx,(%eax)
  802769:	eb 0a                	jmp    802775 <alloc_block_NF+0xdd>
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	a3 38 41 80 00       	mov    %eax,0x804138
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802788:	a1 44 41 80 00       	mov    0x804144,%eax
  80278d:	48                   	dec    %eax
  80278e:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	e9 0e 01 00 00       	jmp    8028a9 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a4:	0f 86 cf 00 00 00    	jbe    802879 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027aa:	a1 48 41 80 00       	mov    0x804148,%eax
  8027af:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8027b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b8:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 50 08             	mov    0x8(%eax),%edx
  8027c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c4:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 50 08             	mov    0x8(%eax),%edx
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	01 c2                	add    %eax,%edx
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e1:	89 c2                	mov    %eax,%edx
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 08             	mov    0x8(%eax),%eax
  8027ef:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8027f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027f6:	75 17                	jne    80280f <alloc_block_NF+0x177>
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	68 25 3d 80 00       	push   $0x803d25
  802800:	68 28 01 00 00       	push   $0x128
  802805:	68 b3 3c 80 00       	push   $0x803cb3
  80280a:	e8 da da ff ff       	call   8002e9 <_panic>
  80280f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 10                	je     802828 <alloc_block_NF+0x190>
  802818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802820:	8b 52 04             	mov    0x4(%edx),%edx
  802823:	89 50 04             	mov    %edx,0x4(%eax)
  802826:	eb 0b                	jmp    802833 <alloc_block_NF+0x19b>
  802828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282b:	8b 40 04             	mov    0x4(%eax),%eax
  80282e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	74 0f                	je     80284c <alloc_block_NF+0x1b4>
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	8b 40 04             	mov    0x4(%eax),%eax
  802843:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802846:	8b 12                	mov    (%edx),%edx
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	eb 0a                	jmp    802856 <alloc_block_NF+0x1be>
  80284c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	a3 48 41 80 00       	mov    %eax,0x804148
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802869:	a1 54 41 80 00       	mov    0x804154,%eax
  80286e:	48                   	dec    %eax
  80286f:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802877:	eb 30                	jmp    8028a9 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802879:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80287e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802881:	75 0a                	jne    80288d <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802883:	a1 38 41 80 00       	mov    0x804138,%eax
  802888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288b:	eb 08                	jmp    802895 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 00                	mov    (%eax),%eax
  802892:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 08             	mov    0x8(%eax),%eax
  80289b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80289e:	0f 85 4d fe ff ff    	jne    8026f1 <alloc_block_NF+0x59>

			return NULL;
  8028a4:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8028a9:	c9                   	leave  
  8028aa:	c3                   	ret    

008028ab <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	53                   	push   %ebx
  8028af:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8028b2:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	0f 85 86 00 00 00    	jne    802945 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8028bf:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8028c6:	00 00 00 
  8028c9:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8028d0:	00 00 00 
  8028d3:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8028da:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e1:	75 17                	jne    8028fa <insert_sorted_with_merge_freeList+0x4f>
  8028e3:	83 ec 04             	sub    $0x4,%esp
  8028e6:	68 90 3c 80 00       	push   $0x803c90
  8028eb:	68 48 01 00 00       	push   $0x148
  8028f0:	68 b3 3c 80 00       	push   $0x803cb3
  8028f5:	e8 ef d9 ff ff       	call   8002e9 <_panic>
  8028fa:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	89 10                	mov    %edx,(%eax)
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 0d                	je     80291b <insert_sorted_with_merge_freeList+0x70>
  80290e:	a1 38 41 80 00       	mov    0x804138,%eax
  802913:	8b 55 08             	mov    0x8(%ebp),%edx
  802916:	89 50 04             	mov    %edx,0x4(%eax)
  802919:	eb 08                	jmp    802923 <insert_sorted_with_merge_freeList+0x78>
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	a3 38 41 80 00       	mov    %eax,0x804138
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802935:	a1 44 41 80 00       	mov    0x804144,%eax
  80293a:	40                   	inc    %eax
  80293b:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802940:	e9 73 07 00 00       	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	8b 50 08             	mov    0x8(%eax),%edx
  80294b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802950:	8b 40 08             	mov    0x8(%eax),%eax
  802953:	39 c2                	cmp    %eax,%edx
  802955:	0f 86 84 00 00 00    	jbe    8029df <insert_sorted_with_merge_freeList+0x134>
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	8b 50 08             	mov    0x8(%eax),%edx
  802961:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802966:	8b 48 0c             	mov    0xc(%eax),%ecx
  802969:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80296e:	8b 40 08             	mov    0x8(%eax),%eax
  802971:	01 c8                	add    %ecx,%eax
  802973:	39 c2                	cmp    %eax,%edx
  802975:	74 68                	je     8029df <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802977:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80297b:	75 17                	jne    802994 <insert_sorted_with_merge_freeList+0xe9>
  80297d:	83 ec 04             	sub    $0x4,%esp
  802980:	68 cc 3c 80 00       	push   $0x803ccc
  802985:	68 4c 01 00 00       	push   $0x14c
  80298a:	68 b3 3c 80 00       	push   $0x803cb3
  80298f:	e8 55 d9 ff ff       	call   8002e9 <_panic>
  802994:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	89 50 04             	mov    %edx,0x4(%eax)
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	8b 40 04             	mov    0x4(%eax),%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	74 0c                	je     8029b6 <insert_sorted_with_merge_freeList+0x10b>
  8029aa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029af:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b2:	89 10                	mov    %edx,(%eax)
  8029b4:	eb 08                	jmp    8029be <insert_sorted_with_merge_freeList+0x113>
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	a3 38 41 80 00       	mov    %eax,0x804138
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cf:	a1 44 41 80 00       	mov    0x804144,%eax
  8029d4:	40                   	inc    %eax
  8029d5:	a3 44 41 80 00       	mov    %eax,0x804144
  8029da:	e9 d9 06 00 00       	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	8b 50 08             	mov    0x8(%eax),%edx
  8029e5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ea:	8b 40 08             	mov    0x8(%eax),%eax
  8029ed:	39 c2                	cmp    %eax,%edx
  8029ef:	0f 86 b5 00 00 00    	jbe    802aaa <insert_sorted_with_merge_freeList+0x1ff>
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	8b 50 08             	mov    0x8(%eax),%edx
  8029fb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a00:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a03:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a08:	8b 40 08             	mov    0x8(%eax),%eax
  802a0b:	01 c8                	add    %ecx,%eax
  802a0d:	39 c2                	cmp    %eax,%edx
  802a0f:	0f 85 95 00 00 00    	jne    802aaa <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802a15:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a1a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a20:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a23:	8b 55 08             	mov    0x8(%ebp),%edx
  802a26:	8b 52 0c             	mov    0xc(%edx),%edx
  802a29:	01 ca                	add    %ecx,%edx
  802a2b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a46:	75 17                	jne    802a5f <insert_sorted_with_merge_freeList+0x1b4>
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	68 90 3c 80 00       	push   $0x803c90
  802a50:	68 54 01 00 00       	push   $0x154
  802a55:	68 b3 3c 80 00       	push   $0x803cb3
  802a5a:	e8 8a d8 ff ff       	call   8002e9 <_panic>
  802a5f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 0d                	je     802a80 <insert_sorted_with_merge_freeList+0x1d5>
  802a73:	a1 48 41 80 00       	mov    0x804148,%eax
  802a78:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	eb 08                	jmp    802a88 <insert_sorted_with_merge_freeList+0x1dd>
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	a3 48 41 80 00       	mov    %eax,0x804148
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9a:	a1 54 41 80 00       	mov    0x804154,%eax
  802a9f:	40                   	inc    %eax
  802aa0:	a3 54 41 80 00       	mov    %eax,0x804154
  802aa5:	e9 0e 06 00 00       	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	8b 50 08             	mov    0x8(%eax),%edx
  802ab0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab5:	8b 40 08             	mov    0x8(%eax),%eax
  802ab8:	39 c2                	cmp    %eax,%edx
  802aba:	0f 83 c1 00 00 00    	jae    802b81 <insert_sorted_with_merge_freeList+0x2d6>
  802ac0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac5:	8b 50 08             	mov    0x8(%eax),%edx
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	8b 48 08             	mov    0x8(%eax),%ecx
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad4:	01 c8                	add    %ecx,%eax
  802ad6:	39 c2                	cmp    %eax,%edx
  802ad8:	0f 85 a3 00 00 00    	jne    802b81 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ade:	a1 38 41 80 00       	mov    0x804138,%eax
  802ae3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae6:	8b 52 08             	mov    0x8(%edx),%edx
  802ae9:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802aec:	a1 38 41 80 00       	mov    0x804138,%eax
  802af1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802af7:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802afa:	8b 55 08             	mov    0x8(%ebp),%edx
  802afd:	8b 52 0c             	mov    0xc(%edx),%edx
  802b00:	01 ca                	add    %ecx,%edx
  802b02:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1d:	75 17                	jne    802b36 <insert_sorted_with_merge_freeList+0x28b>
  802b1f:	83 ec 04             	sub    $0x4,%esp
  802b22:	68 90 3c 80 00       	push   $0x803c90
  802b27:	68 5d 01 00 00       	push   $0x15d
  802b2c:	68 b3 3c 80 00       	push   $0x803cb3
  802b31:	e8 b3 d7 ff ff       	call   8002e9 <_panic>
  802b36:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	89 10                	mov    %edx,(%eax)
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0d                	je     802b57 <insert_sorted_with_merge_freeList+0x2ac>
  802b4a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	eb 08                	jmp    802b5f <insert_sorted_with_merge_freeList+0x2b4>
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	a3 48 41 80 00       	mov    %eax,0x804148
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b71:	a1 54 41 80 00       	mov    0x804154,%eax
  802b76:	40                   	inc    %eax
  802b77:	a3 54 41 80 00       	mov    %eax,0x804154
  802b7c:	e9 37 05 00 00       	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	8b 50 08             	mov    0x8(%eax),%edx
  802b87:	a1 38 41 80 00       	mov    0x804138,%eax
  802b8c:	8b 40 08             	mov    0x8(%eax),%eax
  802b8f:	39 c2                	cmp    %eax,%edx
  802b91:	0f 83 82 00 00 00    	jae    802c19 <insert_sorted_with_merge_freeList+0x36e>
  802b97:	a1 38 41 80 00       	mov    0x804138,%eax
  802b9c:	8b 50 08             	mov    0x8(%eax),%edx
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 48 08             	mov    0x8(%eax),%ecx
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bab:	01 c8                	add    %ecx,%eax
  802bad:	39 c2                	cmp    %eax,%edx
  802baf:	74 68                	je     802c19 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb5:	75 17                	jne    802bce <insert_sorted_with_merge_freeList+0x323>
  802bb7:	83 ec 04             	sub    $0x4,%esp
  802bba:	68 90 3c 80 00       	push   $0x803c90
  802bbf:	68 62 01 00 00       	push   $0x162
  802bc4:	68 b3 3c 80 00       	push   $0x803cb3
  802bc9:	e8 1b d7 ff ff       	call   8002e9 <_panic>
  802bce:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	89 10                	mov    %edx,(%eax)
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	85 c0                	test   %eax,%eax
  802be0:	74 0d                	je     802bef <insert_sorted_with_merge_freeList+0x344>
  802be2:	a1 38 41 80 00       	mov    0x804138,%eax
  802be7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bea:	89 50 04             	mov    %edx,0x4(%eax)
  802bed:	eb 08                	jmp    802bf7 <insert_sorted_with_merge_freeList+0x34c>
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	a3 38 41 80 00       	mov    %eax,0x804138
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c09:	a1 44 41 80 00       	mov    0x804144,%eax
  802c0e:	40                   	inc    %eax
  802c0f:	a3 44 41 80 00       	mov    %eax,0x804144
  802c14:	e9 9f 04 00 00       	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802c19:	a1 38 41 80 00       	mov    0x804138,%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802c23:	e9 84 04 00 00       	jmp    8030ac <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 50 08             	mov    0x8(%eax),%edx
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	8b 40 08             	mov    0x8(%eax),%eax
  802c34:	39 c2                	cmp    %eax,%edx
  802c36:	0f 86 a9 00 00 00    	jbe    802ce5 <insert_sorted_with_merge_freeList+0x43a>
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 50 08             	mov    0x8(%eax),%edx
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	8b 48 08             	mov    0x8(%eax),%ecx
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4e:	01 c8                	add    %ecx,%eax
  802c50:	39 c2                	cmp    %eax,%edx
  802c52:	0f 84 8d 00 00 00    	je     802ce5 <insert_sorted_with_merge_freeList+0x43a>
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	8b 50 08             	mov    0x8(%eax),%edx
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 04             	mov    0x4(%eax),%eax
  802c64:	8b 48 08             	mov    0x8(%eax),%ecx
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 40 04             	mov    0x4(%eax),%eax
  802c6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c70:	01 c8                	add    %ecx,%eax
  802c72:	39 c2                	cmp    %eax,%edx
  802c74:	74 6f                	je     802ce5 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802c76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7a:	74 06                	je     802c82 <insert_sorted_with_merge_freeList+0x3d7>
  802c7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c80:	75 17                	jne    802c99 <insert_sorted_with_merge_freeList+0x3ee>
  802c82:	83 ec 04             	sub    $0x4,%esp
  802c85:	68 f0 3c 80 00       	push   $0x803cf0
  802c8a:	68 6b 01 00 00       	push   $0x16b
  802c8f:	68 b3 3c 80 00       	push   $0x803cb3
  802c94:	e8 50 d6 ff ff       	call   8002e9 <_panic>
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 50 04             	mov    0x4(%eax),%edx
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	89 50 04             	mov    %edx,0x4(%eax)
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cab:	89 10                	mov    %edx,(%eax)
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 0d                	je     802cc4 <insert_sorted_with_merge_freeList+0x419>
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 40 04             	mov    0x4(%eax),%eax
  802cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	eb 08                	jmp    802ccc <insert_sorted_with_merge_freeList+0x421>
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	a3 38 41 80 00       	mov    %eax,0x804138
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	a1 44 41 80 00       	mov    0x804144,%eax
  802cda:	40                   	inc    %eax
  802cdb:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802ce0:	e9 d3 03 00 00       	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 50 08             	mov    0x8(%eax),%edx
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	8b 40 08             	mov    0x8(%eax),%eax
  802cf1:	39 c2                	cmp    %eax,%edx
  802cf3:	0f 86 da 00 00 00    	jbe    802dd3 <insert_sorted_with_merge_freeList+0x528>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 50 08             	mov    0x8(%eax),%edx
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	8b 48 08             	mov    0x8(%eax),%ecx
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0b:	01 c8                	add    %ecx,%eax
  802d0d:	39 c2                	cmp    %eax,%edx
  802d0f:	0f 85 be 00 00 00    	jne    802dd3 <insert_sorted_with_merge_freeList+0x528>
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	8b 50 08             	mov    0x8(%eax),%edx
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	8b 48 08             	mov    0x8(%eax),%ecx
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2d:	01 c8                	add    %ecx,%eax
  802d2f:	39 c2                	cmp    %eax,%edx
  802d31:	0f 84 9c 00 00 00    	je     802dd3 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	8b 50 08             	mov    0x8(%eax),%edx
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 50 0c             	mov    0xc(%eax),%edx
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4f:	01 c2                	add    %eax,%edx
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6f:	75 17                	jne    802d88 <insert_sorted_with_merge_freeList+0x4dd>
  802d71:	83 ec 04             	sub    $0x4,%esp
  802d74:	68 90 3c 80 00       	push   $0x803c90
  802d79:	68 74 01 00 00       	push   $0x174
  802d7e:	68 b3 3c 80 00       	push   $0x803cb3
  802d83:	e8 61 d5 ff ff       	call   8002e9 <_panic>
  802d88:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	89 10                	mov    %edx,(%eax)
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	85 c0                	test   %eax,%eax
  802d9a:	74 0d                	je     802da9 <insert_sorted_with_merge_freeList+0x4fe>
  802d9c:	a1 48 41 80 00       	mov    0x804148,%eax
  802da1:	8b 55 08             	mov    0x8(%ebp),%edx
  802da4:	89 50 04             	mov    %edx,0x4(%eax)
  802da7:	eb 08                	jmp    802db1 <insert_sorted_with_merge_freeList+0x506>
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	a3 48 41 80 00       	mov    %eax,0x804148
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc3:	a1 54 41 80 00       	mov    0x804154,%eax
  802dc8:	40                   	inc    %eax
  802dc9:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802dce:	e9 e5 02 00 00       	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 50 08             	mov    0x8(%eax),%edx
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	8b 40 08             	mov    0x8(%eax),%eax
  802ddf:	39 c2                	cmp    %eax,%edx
  802de1:	0f 86 d7 00 00 00    	jbe    802ebe <insert_sorted_with_merge_freeList+0x613>
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	8b 50 08             	mov    0x8(%eax),%edx
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	8b 48 08             	mov    0x8(%eax),%ecx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	01 c8                	add    %ecx,%eax
  802dfb:	39 c2                	cmp    %eax,%edx
  802dfd:	0f 84 bb 00 00 00    	je     802ebe <insert_sorted_with_merge_freeList+0x613>
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	8b 50 08             	mov    0x8(%eax),%edx
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	8b 48 08             	mov    0x8(%eax),%ecx
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	01 c8                	add    %ecx,%eax
  802e1d:	39 c2                	cmp    %eax,%edx
  802e1f:	0f 85 99 00 00 00    	jne    802ebe <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	8b 50 0c             	mov    0xc(%eax),%edx
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3a:	01 c2                	add    %eax,%edx
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5a:	75 17                	jne    802e73 <insert_sorted_with_merge_freeList+0x5c8>
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	68 90 3c 80 00       	push   $0x803c90
  802e64:	68 7d 01 00 00       	push   $0x17d
  802e69:	68 b3 3c 80 00       	push   $0x803cb3
  802e6e:	e8 76 d4 ff ff       	call   8002e9 <_panic>
  802e73:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	89 10                	mov    %edx,(%eax)
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	74 0d                	je     802e94 <insert_sorted_with_merge_freeList+0x5e9>
  802e87:	a1 48 41 80 00       	mov    0x804148,%eax
  802e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8f:	89 50 04             	mov    %edx,0x4(%eax)
  802e92:	eb 08                	jmp    802e9c <insert_sorted_with_merge_freeList+0x5f1>
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	a3 48 41 80 00       	mov    %eax,0x804148
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eae:	a1 54 41 80 00       	mov    0x804154,%eax
  802eb3:	40                   	inc    %eax
  802eb4:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802eb9:	e9 fa 01 00 00       	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 50 08             	mov    0x8(%eax),%edx
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	8b 40 08             	mov    0x8(%eax),%eax
  802eca:	39 c2                	cmp    %eax,%edx
  802ecc:	0f 86 d2 01 00 00    	jbe    8030a4 <insert_sorted_with_merge_freeList+0x7f9>
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 50 08             	mov    0x8(%eax),%edx
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 48 08             	mov    0x8(%eax),%ecx
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee4:	01 c8                	add    %ecx,%eax
  802ee6:	39 c2                	cmp    %eax,%edx
  802ee8:	0f 85 b6 01 00 00    	jne    8030a4 <insert_sorted_with_merge_freeList+0x7f9>
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 50 08             	mov    0x8(%eax),%edx
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 40 04             	mov    0x4(%eax),%eax
  802efa:	8b 48 08             	mov    0x8(%eax),%ecx
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	8b 40 0c             	mov    0xc(%eax),%eax
  802f06:	01 c8                	add    %ecx,%eax
  802f08:	39 c2                	cmp    %eax,%edx
  802f0a:	0f 85 94 01 00 00    	jne    8030a4 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 40 04             	mov    0x4(%eax),%eax
  802f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f19:	8b 52 04             	mov    0x4(%edx),%edx
  802f1c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f22:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f28:	8b 52 0c             	mov    0xc(%edx),%edx
  802f2b:	01 da                	add    %ebx,%edx
  802f2d:	01 ca                	add    %ecx,%edx
  802f2f:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4a:	75 17                	jne    802f63 <insert_sorted_with_merge_freeList+0x6b8>
  802f4c:	83 ec 04             	sub    $0x4,%esp
  802f4f:	68 25 3d 80 00       	push   $0x803d25
  802f54:	68 86 01 00 00       	push   $0x186
  802f59:	68 b3 3c 80 00       	push   $0x803cb3
  802f5e:	e8 86 d3 ff ff       	call   8002e9 <_panic>
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 00                	mov    (%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	74 10                	je     802f7c <insert_sorted_with_merge_freeList+0x6d1>
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f74:	8b 52 04             	mov    0x4(%edx),%edx
  802f77:	89 50 04             	mov    %edx,0x4(%eax)
  802f7a:	eb 0b                	jmp    802f87 <insert_sorted_with_merge_freeList+0x6dc>
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 40 04             	mov    0x4(%eax),%eax
  802f82:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	74 0f                	je     802fa0 <insert_sorted_with_merge_freeList+0x6f5>
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9a:	8b 12                	mov    (%edx),%edx
  802f9c:	89 10                	mov    %edx,(%eax)
  802f9e:	eb 0a                	jmp    802faa <insert_sorted_with_merge_freeList+0x6ff>
  802fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa3:	8b 00                	mov    (%eax),%eax
  802fa5:	a3 38 41 80 00       	mov    %eax,0x804138
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbd:	a1 44 41 80 00       	mov    0x804144,%eax
  802fc2:	48                   	dec    %eax
  802fc3:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802fc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcc:	75 17                	jne    802fe5 <insert_sorted_with_merge_freeList+0x73a>
  802fce:	83 ec 04             	sub    $0x4,%esp
  802fd1:	68 90 3c 80 00       	push   $0x803c90
  802fd6:	68 87 01 00 00       	push   $0x187
  802fdb:	68 b3 3c 80 00       	push   $0x803cb3
  802fe0:	e8 04 d3 ff ff       	call   8002e9 <_panic>
  802fe5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	89 10                	mov    %edx,(%eax)
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 0d                	je     803006 <insert_sorted_with_merge_freeList+0x75b>
  802ff9:	a1 48 41 80 00       	mov    0x804148,%eax
  802ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803001:	89 50 04             	mov    %edx,0x4(%eax)
  803004:	eb 08                	jmp    80300e <insert_sorted_with_merge_freeList+0x763>
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	a3 48 41 80 00       	mov    %eax,0x804148
  803016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803019:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803020:	a1 54 41 80 00       	mov    0x804154,%eax
  803025:	40                   	inc    %eax
  803026:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80303f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803043:	75 17                	jne    80305c <insert_sorted_with_merge_freeList+0x7b1>
  803045:	83 ec 04             	sub    $0x4,%esp
  803048:	68 90 3c 80 00       	push   $0x803c90
  80304d:	68 8a 01 00 00       	push   $0x18a
  803052:	68 b3 3c 80 00       	push   $0x803cb3
  803057:	e8 8d d2 ff ff       	call   8002e9 <_panic>
  80305c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	89 10                	mov    %edx,(%eax)
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	85 c0                	test   %eax,%eax
  80306e:	74 0d                	je     80307d <insert_sorted_with_merge_freeList+0x7d2>
  803070:	a1 48 41 80 00       	mov    0x804148,%eax
  803075:	8b 55 08             	mov    0x8(%ebp),%edx
  803078:	89 50 04             	mov    %edx,0x4(%eax)
  80307b:	eb 08                	jmp    803085 <insert_sorted_with_merge_freeList+0x7da>
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	a3 48 41 80 00       	mov    %eax,0x804148
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803097:	a1 54 41 80 00       	mov    0x804154,%eax
  80309c:	40                   	inc    %eax
  80309d:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  8030a2:	eb 14                	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8030ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b0:	0f 85 72 fb ff ff    	jne    802c28 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8030b6:	eb 00                	jmp    8030b8 <insert_sorted_with_merge_freeList+0x80d>
  8030b8:	90                   	nop
  8030b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030bc:	c9                   	leave  
  8030bd:	c3                   	ret    

008030be <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030be:	55                   	push   %ebp
  8030bf:	89 e5                	mov    %esp,%ebp
  8030c1:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8030c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c7:	89 d0                	mov    %edx,%eax
  8030c9:	c1 e0 02             	shl    $0x2,%eax
  8030cc:	01 d0                	add    %edx,%eax
  8030ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030d5:	01 d0                	add    %edx,%eax
  8030d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030de:	01 d0                	add    %edx,%eax
  8030e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030e7:	01 d0                	add    %edx,%eax
  8030e9:	c1 e0 04             	shl    $0x4,%eax
  8030ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030f6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030f9:	83 ec 0c             	sub    $0xc,%esp
  8030fc:	50                   	push   %eax
  8030fd:	e8 7b eb ff ff       	call   801c7d <sys_get_virtual_time>
  803102:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803105:	eb 41                	jmp    803148 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803107:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80310a:	83 ec 0c             	sub    $0xc,%esp
  80310d:	50                   	push   %eax
  80310e:	e8 6a eb ff ff       	call   801c7d <sys_get_virtual_time>
  803113:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803116:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	29 c2                	sub    %eax,%edx
  80311e:	89 d0                	mov    %edx,%eax
  803120:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803123:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803126:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803129:	89 d1                	mov    %edx,%ecx
  80312b:	29 c1                	sub    %eax,%ecx
  80312d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803133:	39 c2                	cmp    %eax,%edx
  803135:	0f 97 c0             	seta   %al
  803138:	0f b6 c0             	movzbl %al,%eax
  80313b:	29 c1                	sub    %eax,%ecx
  80313d:	89 c8                	mov    %ecx,%eax
  80313f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803142:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803145:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80314e:	72 b7                	jb     803107 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803150:	90                   	nop
  803151:	c9                   	leave  
  803152:	c3                   	ret    

00803153 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803153:	55                   	push   %ebp
  803154:	89 e5                	mov    %esp,%ebp
  803156:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803160:	eb 03                	jmp    803165 <busy_wait+0x12>
  803162:	ff 45 fc             	incl   -0x4(%ebp)
  803165:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803168:	3b 45 08             	cmp    0x8(%ebp),%eax
  80316b:	72 f5                	jb     803162 <busy_wait+0xf>
	return i;
  80316d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803170:	c9                   	leave  
  803171:	c3                   	ret    
  803172:	66 90                	xchg   %ax,%ax

00803174 <__udivdi3>:
  803174:	55                   	push   %ebp
  803175:	57                   	push   %edi
  803176:	56                   	push   %esi
  803177:	53                   	push   %ebx
  803178:	83 ec 1c             	sub    $0x1c,%esp
  80317b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80317f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803187:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80318b:	89 ca                	mov    %ecx,%edx
  80318d:	89 f8                	mov    %edi,%eax
  80318f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803193:	85 f6                	test   %esi,%esi
  803195:	75 2d                	jne    8031c4 <__udivdi3+0x50>
  803197:	39 cf                	cmp    %ecx,%edi
  803199:	77 65                	ja     803200 <__udivdi3+0x8c>
  80319b:	89 fd                	mov    %edi,%ebp
  80319d:	85 ff                	test   %edi,%edi
  80319f:	75 0b                	jne    8031ac <__udivdi3+0x38>
  8031a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8031a6:	31 d2                	xor    %edx,%edx
  8031a8:	f7 f7                	div    %edi
  8031aa:	89 c5                	mov    %eax,%ebp
  8031ac:	31 d2                	xor    %edx,%edx
  8031ae:	89 c8                	mov    %ecx,%eax
  8031b0:	f7 f5                	div    %ebp
  8031b2:	89 c1                	mov    %eax,%ecx
  8031b4:	89 d8                	mov    %ebx,%eax
  8031b6:	f7 f5                	div    %ebp
  8031b8:	89 cf                	mov    %ecx,%edi
  8031ba:	89 fa                	mov    %edi,%edx
  8031bc:	83 c4 1c             	add    $0x1c,%esp
  8031bf:	5b                   	pop    %ebx
  8031c0:	5e                   	pop    %esi
  8031c1:	5f                   	pop    %edi
  8031c2:	5d                   	pop    %ebp
  8031c3:	c3                   	ret    
  8031c4:	39 ce                	cmp    %ecx,%esi
  8031c6:	77 28                	ja     8031f0 <__udivdi3+0x7c>
  8031c8:	0f bd fe             	bsr    %esi,%edi
  8031cb:	83 f7 1f             	xor    $0x1f,%edi
  8031ce:	75 40                	jne    803210 <__udivdi3+0x9c>
  8031d0:	39 ce                	cmp    %ecx,%esi
  8031d2:	72 0a                	jb     8031de <__udivdi3+0x6a>
  8031d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031d8:	0f 87 9e 00 00 00    	ja     80327c <__udivdi3+0x108>
  8031de:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e3:	89 fa                	mov    %edi,%edx
  8031e5:	83 c4 1c             	add    $0x1c,%esp
  8031e8:	5b                   	pop    %ebx
  8031e9:	5e                   	pop    %esi
  8031ea:	5f                   	pop    %edi
  8031eb:	5d                   	pop    %ebp
  8031ec:	c3                   	ret    
  8031ed:	8d 76 00             	lea    0x0(%esi),%esi
  8031f0:	31 ff                	xor    %edi,%edi
  8031f2:	31 c0                	xor    %eax,%eax
  8031f4:	89 fa                	mov    %edi,%edx
  8031f6:	83 c4 1c             	add    $0x1c,%esp
  8031f9:	5b                   	pop    %ebx
  8031fa:	5e                   	pop    %esi
  8031fb:	5f                   	pop    %edi
  8031fc:	5d                   	pop    %ebp
  8031fd:	c3                   	ret    
  8031fe:	66 90                	xchg   %ax,%ax
  803200:	89 d8                	mov    %ebx,%eax
  803202:	f7 f7                	div    %edi
  803204:	31 ff                	xor    %edi,%edi
  803206:	89 fa                	mov    %edi,%edx
  803208:	83 c4 1c             	add    $0x1c,%esp
  80320b:	5b                   	pop    %ebx
  80320c:	5e                   	pop    %esi
  80320d:	5f                   	pop    %edi
  80320e:	5d                   	pop    %ebp
  80320f:	c3                   	ret    
  803210:	bd 20 00 00 00       	mov    $0x20,%ebp
  803215:	89 eb                	mov    %ebp,%ebx
  803217:	29 fb                	sub    %edi,%ebx
  803219:	89 f9                	mov    %edi,%ecx
  80321b:	d3 e6                	shl    %cl,%esi
  80321d:	89 c5                	mov    %eax,%ebp
  80321f:	88 d9                	mov    %bl,%cl
  803221:	d3 ed                	shr    %cl,%ebp
  803223:	89 e9                	mov    %ebp,%ecx
  803225:	09 f1                	or     %esi,%ecx
  803227:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80322b:	89 f9                	mov    %edi,%ecx
  80322d:	d3 e0                	shl    %cl,%eax
  80322f:	89 c5                	mov    %eax,%ebp
  803231:	89 d6                	mov    %edx,%esi
  803233:	88 d9                	mov    %bl,%cl
  803235:	d3 ee                	shr    %cl,%esi
  803237:	89 f9                	mov    %edi,%ecx
  803239:	d3 e2                	shl    %cl,%edx
  80323b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80323f:	88 d9                	mov    %bl,%cl
  803241:	d3 e8                	shr    %cl,%eax
  803243:	09 c2                	or     %eax,%edx
  803245:	89 d0                	mov    %edx,%eax
  803247:	89 f2                	mov    %esi,%edx
  803249:	f7 74 24 0c          	divl   0xc(%esp)
  80324d:	89 d6                	mov    %edx,%esi
  80324f:	89 c3                	mov    %eax,%ebx
  803251:	f7 e5                	mul    %ebp
  803253:	39 d6                	cmp    %edx,%esi
  803255:	72 19                	jb     803270 <__udivdi3+0xfc>
  803257:	74 0b                	je     803264 <__udivdi3+0xf0>
  803259:	89 d8                	mov    %ebx,%eax
  80325b:	31 ff                	xor    %edi,%edi
  80325d:	e9 58 ff ff ff       	jmp    8031ba <__udivdi3+0x46>
  803262:	66 90                	xchg   %ax,%ax
  803264:	8b 54 24 08          	mov    0x8(%esp),%edx
  803268:	89 f9                	mov    %edi,%ecx
  80326a:	d3 e2                	shl    %cl,%edx
  80326c:	39 c2                	cmp    %eax,%edx
  80326e:	73 e9                	jae    803259 <__udivdi3+0xe5>
  803270:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803273:	31 ff                	xor    %edi,%edi
  803275:	e9 40 ff ff ff       	jmp    8031ba <__udivdi3+0x46>
  80327a:	66 90                	xchg   %ax,%ax
  80327c:	31 c0                	xor    %eax,%eax
  80327e:	e9 37 ff ff ff       	jmp    8031ba <__udivdi3+0x46>
  803283:	90                   	nop

00803284 <__umoddi3>:
  803284:	55                   	push   %ebp
  803285:	57                   	push   %edi
  803286:	56                   	push   %esi
  803287:	53                   	push   %ebx
  803288:	83 ec 1c             	sub    $0x1c,%esp
  80328b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80328f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803297:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80329b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80329f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032a3:	89 f3                	mov    %esi,%ebx
  8032a5:	89 fa                	mov    %edi,%edx
  8032a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032ab:	89 34 24             	mov    %esi,(%esp)
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	75 1a                	jne    8032cc <__umoddi3+0x48>
  8032b2:	39 f7                	cmp    %esi,%edi
  8032b4:	0f 86 a2 00 00 00    	jbe    80335c <__umoddi3+0xd8>
  8032ba:	89 c8                	mov    %ecx,%eax
  8032bc:	89 f2                	mov    %esi,%edx
  8032be:	f7 f7                	div    %edi
  8032c0:	89 d0                	mov    %edx,%eax
  8032c2:	31 d2                	xor    %edx,%edx
  8032c4:	83 c4 1c             	add    $0x1c,%esp
  8032c7:	5b                   	pop    %ebx
  8032c8:	5e                   	pop    %esi
  8032c9:	5f                   	pop    %edi
  8032ca:	5d                   	pop    %ebp
  8032cb:	c3                   	ret    
  8032cc:	39 f0                	cmp    %esi,%eax
  8032ce:	0f 87 ac 00 00 00    	ja     803380 <__umoddi3+0xfc>
  8032d4:	0f bd e8             	bsr    %eax,%ebp
  8032d7:	83 f5 1f             	xor    $0x1f,%ebp
  8032da:	0f 84 ac 00 00 00    	je     80338c <__umoddi3+0x108>
  8032e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8032e5:	29 ef                	sub    %ebp,%edi
  8032e7:	89 fe                	mov    %edi,%esi
  8032e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032ed:	89 e9                	mov    %ebp,%ecx
  8032ef:	d3 e0                	shl    %cl,%eax
  8032f1:	89 d7                	mov    %edx,%edi
  8032f3:	89 f1                	mov    %esi,%ecx
  8032f5:	d3 ef                	shr    %cl,%edi
  8032f7:	09 c7                	or     %eax,%edi
  8032f9:	89 e9                	mov    %ebp,%ecx
  8032fb:	d3 e2                	shl    %cl,%edx
  8032fd:	89 14 24             	mov    %edx,(%esp)
  803300:	89 d8                	mov    %ebx,%eax
  803302:	d3 e0                	shl    %cl,%eax
  803304:	89 c2                	mov    %eax,%edx
  803306:	8b 44 24 08          	mov    0x8(%esp),%eax
  80330a:	d3 e0                	shl    %cl,%eax
  80330c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803310:	8b 44 24 08          	mov    0x8(%esp),%eax
  803314:	89 f1                	mov    %esi,%ecx
  803316:	d3 e8                	shr    %cl,%eax
  803318:	09 d0                	or     %edx,%eax
  80331a:	d3 eb                	shr    %cl,%ebx
  80331c:	89 da                	mov    %ebx,%edx
  80331e:	f7 f7                	div    %edi
  803320:	89 d3                	mov    %edx,%ebx
  803322:	f7 24 24             	mull   (%esp)
  803325:	89 c6                	mov    %eax,%esi
  803327:	89 d1                	mov    %edx,%ecx
  803329:	39 d3                	cmp    %edx,%ebx
  80332b:	0f 82 87 00 00 00    	jb     8033b8 <__umoddi3+0x134>
  803331:	0f 84 91 00 00 00    	je     8033c8 <__umoddi3+0x144>
  803337:	8b 54 24 04          	mov    0x4(%esp),%edx
  80333b:	29 f2                	sub    %esi,%edx
  80333d:	19 cb                	sbb    %ecx,%ebx
  80333f:	89 d8                	mov    %ebx,%eax
  803341:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803345:	d3 e0                	shl    %cl,%eax
  803347:	89 e9                	mov    %ebp,%ecx
  803349:	d3 ea                	shr    %cl,%edx
  80334b:	09 d0                	or     %edx,%eax
  80334d:	89 e9                	mov    %ebp,%ecx
  80334f:	d3 eb                	shr    %cl,%ebx
  803351:	89 da                	mov    %ebx,%edx
  803353:	83 c4 1c             	add    $0x1c,%esp
  803356:	5b                   	pop    %ebx
  803357:	5e                   	pop    %esi
  803358:	5f                   	pop    %edi
  803359:	5d                   	pop    %ebp
  80335a:	c3                   	ret    
  80335b:	90                   	nop
  80335c:	89 fd                	mov    %edi,%ebp
  80335e:	85 ff                	test   %edi,%edi
  803360:	75 0b                	jne    80336d <__umoddi3+0xe9>
  803362:	b8 01 00 00 00       	mov    $0x1,%eax
  803367:	31 d2                	xor    %edx,%edx
  803369:	f7 f7                	div    %edi
  80336b:	89 c5                	mov    %eax,%ebp
  80336d:	89 f0                	mov    %esi,%eax
  80336f:	31 d2                	xor    %edx,%edx
  803371:	f7 f5                	div    %ebp
  803373:	89 c8                	mov    %ecx,%eax
  803375:	f7 f5                	div    %ebp
  803377:	89 d0                	mov    %edx,%eax
  803379:	e9 44 ff ff ff       	jmp    8032c2 <__umoddi3+0x3e>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	89 c8                	mov    %ecx,%eax
  803382:	89 f2                	mov    %esi,%edx
  803384:	83 c4 1c             	add    $0x1c,%esp
  803387:	5b                   	pop    %ebx
  803388:	5e                   	pop    %esi
  803389:	5f                   	pop    %edi
  80338a:	5d                   	pop    %ebp
  80338b:	c3                   	ret    
  80338c:	3b 04 24             	cmp    (%esp),%eax
  80338f:	72 06                	jb     803397 <__umoddi3+0x113>
  803391:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803395:	77 0f                	ja     8033a6 <__umoddi3+0x122>
  803397:	89 f2                	mov    %esi,%edx
  803399:	29 f9                	sub    %edi,%ecx
  80339b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80339f:	89 14 24             	mov    %edx,(%esp)
  8033a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033aa:	8b 14 24             	mov    (%esp),%edx
  8033ad:	83 c4 1c             	add    $0x1c,%esp
  8033b0:	5b                   	pop    %ebx
  8033b1:	5e                   	pop    %esi
  8033b2:	5f                   	pop    %edi
  8033b3:	5d                   	pop    %ebp
  8033b4:	c3                   	ret    
  8033b5:	8d 76 00             	lea    0x0(%esi),%esi
  8033b8:	2b 04 24             	sub    (%esp),%eax
  8033bb:	19 fa                	sbb    %edi,%edx
  8033bd:	89 d1                	mov    %edx,%ecx
  8033bf:	89 c6                	mov    %eax,%esi
  8033c1:	e9 71 ff ff ff       	jmp    803337 <__umoddi3+0xb3>
  8033c6:	66 90                	xchg   %ax,%ax
  8033c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033cc:	72 ea                	jb     8033b8 <__umoddi3+0x134>
  8033ce:	89 d9                	mov    %ebx,%ecx
  8033d0:	e9 62 ff ff ff       	jmp    803337 <__umoddi3+0xb3>
