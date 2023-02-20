
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 c3 01 00 00       	call   8001f9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 80 33 80 00       	push   $0x803380
  800092:	6a 13                	push   $0x13
  800094:	68 9c 33 80 00       	push   $0x80339c
  800099:	e8 97 02 00 00       	call   800335 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 91 14 00 00       	call   801539 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 e6 1b 00 00       	call   801c96 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 d2 19 00 00       	call   801a8a <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 e0 18 00 00       	call   80199d <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 b7 33 80 00       	push   $0x8033b7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 8d 16 00 00       	call   80175d <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 bc 33 80 00       	push   $0x8033bc
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 9c 33 80 00       	push   $0x80339c
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 a2 18 00 00       	call   80199d <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 1c 34 80 00       	push   $0x80341c
  80010c:	6a 22                	push   $0x22
  80010e:	68 9c 33 80 00       	push   $0x80339c
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 87 19 00 00       	call   801aa4 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 68 19 00 00       	call   801a8a <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 76 18 00 00       	call   80199d <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ad 34 80 00       	push   $0x8034ad
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 23 16 00 00       	call   80175d <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 bc 33 80 00       	push   $0x8033bc
  800151:	6a 28                	push   $0x28
  800153:	68 9c 33 80 00       	push   $0x80339c
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 3b 18 00 00       	call   80199d <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 1c 34 80 00       	push   $0x80341c
  800173:	6a 29                	push   $0x29
  800175:	68 9c 33 80 00       	push   $0x80339c
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 20 19 00 00       	call   801aa4 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 b0 34 80 00       	push   $0x8034b0
  800196:	6a 2c                	push   $0x2c
  800198:	68 9c 33 80 00       	push   $0x80339c
  80019d:	e8 93 01 00 00       	call   800335 <_panic>

	//Edit the writable object
	*z = 30;
  8001a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a5:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8001ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	83 f8 1e             	cmp    $0x1e,%eax
  8001b3:	74 14                	je     8001c9 <_main+0x191>
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 b0 34 80 00       	push   $0x8034b0
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 9c 33 80 00       	push   $0x80339c
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 e8 34 80 00       	push   $0x8034e8
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 18 35 80 00       	push   $0x803518
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 9c 33 80 00       	push   $0x80339c
  8001f4:	e8 3c 01 00 00       	call   800335 <_panic>

008001f9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ff:	e8 79 1a 00 00       	call   801c7d <sys_getenvindex>
  800204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	c1 e0 03             	shl    $0x3,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021c:	01 d0                	add    %edx,%eax
  80021e:	c1 e0 04             	shl    $0x4,%eax
  800221:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800226:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800236:	84 c0                	test   %al,%al
  800238:	74 0f                	je     800249 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	05 5c 05 00 00       	add    $0x55c,%eax
  800244:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024d:	7e 0a                	jle    800259 <libmain+0x60>
		binaryname = argv[0];
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 d1 fd ff ff       	call   800038 <_main>
  800267:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026a:	e8 1b 18 00 00       	call   801a8a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 74 35 80 00       	push   $0x803574
  800277:	e8 6d 03 00 00       	call   8005e9 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 40 80 00       	mov    0x804020,%eax
  800284:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80028a:	a1 20 40 80 00       	mov    0x804020,%eax
  80028f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 9c 35 80 00       	push   $0x80359c
  80029f:	e8 45 03 00 00       	call   8005e9 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ac:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	68 c4 35 80 00       	push   $0x8035c4
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 1c 36 80 00       	push   $0x80361c
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 74 35 80 00       	push   $0x803574
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 9b 17 00 00       	call   801aa4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800309:	e8 19 00 00 00       	call   800327 <exit>
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 28 19 00 00       	call   801c49 <sys_destroy_env>
  800321:	83 c4 10             	add    $0x10,%esp
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <exit>:

void
exit(void)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80032d:	e8 7d 19 00 00       	call   801caf <sys_exit_env>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80033b:	8d 45 10             	lea    0x10(%ebp),%eax
  80033e:	83 c0 04             	add    $0x4,%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800344:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	74 16                	je     800363 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80034d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	68 30 36 80 00       	push   $0x803630
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 40 80 00       	mov    0x804000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 35 36 80 00       	push   $0x803635
  800374:	e8 70 02 00 00       	call   8005e9 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 f3 01 00 00       	call   80057e <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	6a 00                	push   $0x0
  800393:	68 51 36 80 00       	push   $0x803651
  800398:	e8 e1 01 00 00       	call   80057e <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a0:	e8 82 ff ff ff       	call   800327 <exit>

	// should not return here
	while (1) ;
  8003a5:	eb fe                	jmp    8003a5 <_panic+0x70>

008003a7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b2:	8b 50 74             	mov    0x74(%eax),%edx
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b8:	39 c2                	cmp    %eax,%edx
  8003ba:	74 14                	je     8003d0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 54 36 80 00       	push   $0x803654
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 a0 36 80 00       	push   $0x8036a0
  8003cb:	e8 65 ff ff ff       	call   800335 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003de:	e9 c2 00 00 00       	jmp    8004a5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	75 08                	jne    800400 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003fb:	e9 a2 00 00 00       	jmp    8004a2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80040e:	eb 69                	jmp    800479 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8a 40 04             	mov    0x4(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	75 46                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	a1 20 40 80 00       	mov    0x804020,%eax
  800435:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80043b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	c1 e0 03             	shl    $0x3,%eax
  800447:	01 c8                	add    %ecx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800456:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c8                	add    %ecx,%eax
  800467:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	75 09                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80046d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800474:	eb 12                	jmp    800488 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	ff 45 e8             	incl   -0x18(%ebp)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 50 74             	mov    0x74(%eax),%edx
  800481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800484:	39 c2                	cmp    %eax,%edx
  800486:	77 88                	ja     800410 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80048c:	75 14                	jne    8004a2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	68 ac 36 80 00       	push   $0x8036ac
  800496:	6a 3a                	push   $0x3a
  800498:	68 a0 36 80 00       	push   $0x8036a0
  80049d:	e8 93 fe ff ff       	call   800335 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a2:	ff 45 f0             	incl   -0x10(%ebp)
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ab:	0f 8c 32 ff ff ff    	jl     8003e3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004bf:	eb 26                	jmp    8004e7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	89 d0                	mov    %edx,%eax
  8004d1:	01 c0                	add    %eax,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 03             	shl    $0x3,%eax
  8004d8:	01 c8                	add    %ecx,%eax
  8004da:	8a 40 04             	mov    0x4(%eax),%al
  8004dd:	3c 01                	cmp    $0x1,%al
  8004df:	75 03                	jne    8004e4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e4:	ff 45 e0             	incl   -0x20(%ebp)
  8004e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ec:	8b 50 74             	mov    0x74(%eax),%edx
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 cb                	ja     8004c1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fc:	74 14                	je     800512 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 00 37 80 00       	push   $0x803700
  800506:	6a 44                	push   $0x44
  800508:	68 a0 36 80 00       	push   $0x8036a0
  80050d:	e8 23 fe ff ff       	call   800335 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800512:	90                   	nop
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 48 01             	lea    0x1(%eax),%ecx
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	89 0a                	mov    %ecx,(%edx)
  800528:	8b 55 08             	mov    0x8(%ebp),%edx
  80052b:	88 d1                	mov    %dl,%cl
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053e:	75 2c                	jne    80056c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800540:	a0 24 40 80 00       	mov    0x804024,%al
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	8b 12                	mov    (%edx),%edx
  80054d:	89 d1                	mov    %edx,%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	83 c2 08             	add    $0x8,%edx
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	52                   	push   %edx
  80055b:	e8 7c 13 00 00       	call   8018dc <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	8b 40 04             	mov    0x4(%eax),%eax
  800572:	8d 50 01             	lea    0x1(%eax),%edx
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058e:	00 00 00 
	b.cnt = 0;
  800591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800598:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	50                   	push   %eax
  8005a8:	68 15 05 80 00       	push   $0x800515
  8005ad:	e8 11 02 00 00       	call   8007c3 <vprintfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005b5:	a0 24 40 80 00       	mov    0x804024,%al
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	52                   	push   %edx
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 05 13 00 00       	call   8018dc <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005da:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ef:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 73 ff ff ff       	call   80057e <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80061c:	e8 69 14 00 00       	call   801a8a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 48 ff ff ff       	call   80057e <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80063c:	e8 63 14 00 00       	call   801aa4 <sys_enable_interrupt>
	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	53                   	push   %ebx
  80064a:	83 ec 14             	sub    $0x14,%esp
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800659:	8b 45 18             	mov    0x18(%ebp),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800664:	77 55                	ja     8006bb <printnum+0x75>
  800666:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800669:	72 05                	jb     800670 <printnum+0x2a>
  80066b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066e:	77 4b                	ja     8006bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800670:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800673:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800676:	8b 45 18             	mov    0x18(%ebp),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	ff 75 f0             	pushl  -0x10(%ebp)
  800686:	e8 81 2a 00 00       	call   80310c <__udivdi3>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	53                   	push   %ebx
  800695:	ff 75 18             	pushl  0x18(%ebp)
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 a1 ff ff ff       	call   800646 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	eb 1a                	jmp    8006c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c2:	7f e6                	jg     8006aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	53                   	push   %ebx
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	e8 41 2b 00 00       	call   80321c <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 74 39 80 00       	add    $0x803974,%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  800720:	eb 40                	jmp    800762 <getuint+0x65>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1e                	je     800746 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 1c                	jmp    800762 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076b:	7e 1c                	jle    800789 <getint+0x25>
		return va_arg(*ap, long long);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 08             	lea    0x8(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 08             	sub    $0x8,%eax
  800782:	8b 50 04             	mov    0x4(%eax),%edx
  800785:	8b 00                	mov    (%eax),%eax
  800787:	eb 38                	jmp    8007c1 <getint+0x5d>
	else if (lflag)
  800789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078d:	74 1a                	je     8007a9 <getint+0x45>
		return va_arg(*ap, long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	99                   	cltd   
  8007a7:	eb 18                	jmp    8007c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 04             	lea    0x4(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	eb 17                	jmp    8007e4 <vprintfmt+0x21>
			if (ch == '\0')
  8007cd:	85 db                	test   %ebx,%ebx
  8007cf:	0f 84 af 03 00 00    	je     800b84 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f b6 d8             	movzbl %al,%ebx
  8007f2:	83 fb 25             	cmp    $0x25,%ebx
  8007f5:	75 d6                	jne    8007cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800802:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 2b 03 00 00    	ja     800b5c <vprintfmt+0x399>
  800831:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
  800838:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083e:	eb d7                	jmp    800817 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800844:	eb d1                	jmp    800817 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800869:	83 fb 2f             	cmp    $0x2f,%ebx
  80086c:	7e 3e                	jle    8008ac <vprintfmt+0xe9>
  80086e:	83 fb 39             	cmp    $0x39,%ebx
  800871:	7f 39                	jg     8008ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb d5                	jmp    80084d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	83 c0 04             	add    $0x4,%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088c:	eb 1f                	jmp    8008ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	79 83                	jns    800817 <vprintfmt+0x54>
				width = 0;
  800894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80089b:	e9 77 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a7:	e9 6b ff ff ff       	jmp    800817 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	0f 89 60 ff ff ff    	jns    800817 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c4:	e9 4e ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008cc:	e9 46 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	50                   	push   %eax
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			break;
  8008f1:	e9 89 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800907:	85 db                	test   %ebx,%ebx
  800909:	79 02                	jns    80090d <vprintfmt+0x14a>
				err = -err;
  80090b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090d:	83 fb 64             	cmp    $0x64,%ebx
  800910:	7f 0b                	jg     80091d <vprintfmt+0x15a>
  800912:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 85 39 80 00       	push   $0x803985
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 5e 02 00 00       	call   800b8c <printfmt>
  80092e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800931:	e9 49 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800936:	56                   	push   %esi
  800937:	68 8e 39 80 00       	push   $0x80398e
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 45 02 00 00       	call   800b8c <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			break;
  80094a:	e9 30 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 30                	mov    (%eax),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 05                	jne    800969 <vprintfmt+0x1a6>
				p = "(null)";
  800964:	be 91 39 80 00       	mov    $0x803991,%esi
			if (width > 0 && padc != '-')
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7e 6d                	jle    8009dc <vprintfmt+0x219>
  80096f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800973:	74 67                	je     8009dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	50                   	push   %eax
  80097c:	56                   	push   %esi
  80097d:	e8 0c 03 00 00       	call   800c8e <strnlen>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80098a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	50                   	push   %eax
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 34                	jmp    8009dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	74 1c                	je     8009ca <vprintfmt+0x207>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x1f5>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 12                	jle    8009ca <vprintfmt+0x207>
					putch('?', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 3f                	push   $0x3f
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	eb 0f                	jmp    8009d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	8d 70 01             	lea    0x1(%eax),%esi
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 24                	je     800a0e <vprintfmt+0x24b>
  8009ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ee:	78 b8                	js     8009a8 <vprintfmt+0x1e5>
  8009f0:	ff 4d e0             	decl   -0x20(%ebp)
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	79 af                	jns    8009a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 13                	jmp    800a0e <vprintfmt+0x24b>
				putch(' ', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 20                	push   $0x20
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e7                	jg     8009fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a14:	e9 66 01 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 3c fd ff ff       	call   800764 <getint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	85 d2                	test   %edx,%edx
  800a39:	79 23                	jns    800a5e <vprintfmt+0x29b>
				putch('-', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 2d                	push   $0x2d
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	f7 d8                	neg    %eax
  800a53:	83 d2 00             	adc    $0x0,%edx
  800a56:	f7 da                	neg    %edx
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a65:	e9 bc 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 84 fc ff ff       	call   8006fd <getuint>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a89:	e9 98 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 58                	push   $0x58
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 bc 00 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 30                	push   $0x30
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 78                	push   $0x78
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b05:	eb 1f                	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 e7 fb ff ff       	call   8006fd <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	52                   	push   %edx
  800b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 f4             	pushl  -0xc(%ebp)
  800b38:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 00 fb ff ff       	call   800646 <printnum>
  800b46:	83 c4 20             	add    $0x20,%esp
			break;
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			break;
  800b5a:	eb 23                	jmp    800b7f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 25                	push   $0x25
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6c:	ff 4d 10             	decl   0x10(%ebp)
  800b6f:	eb 03                	jmp    800b74 <vprintfmt+0x3b1>
  800b71:	ff 4d 10             	decl   0x10(%ebp)
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	48                   	dec    %eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	3c 25                	cmp    $0x25,%al
  800b7c:	75 f3                	jne    800b71 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b7e:	90                   	nop
		}
	}
  800b7f:	e9 47 fc ff ff       	jmp    8007cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 16 fc ff ff       	call   8007c3 <vprintfmt>
  800bad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb0:	90                   	nop
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 40 08             	mov    0x8(%eax),%eax
  800bbc:	8d 50 01             	lea    0x1(%eax),%edx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 10                	mov    (%eax),%edx
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8b 40 04             	mov    0x4(%eax),%eax
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	73 12                	jae    800be6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdf:	89 0a                	mov    %ecx,(%edx)
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	88 10                	mov    %dl,(%eax)
}
  800be6:	90                   	nop
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
  800c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0e:	74 06                	je     800c16 <vsnprintf+0x2d>
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	7f 07                	jg     800c1d <vsnprintf+0x34>
		return -E_INVAL;
  800c16:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1b:	eb 20                	jmp    800c3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1d:	ff 75 14             	pushl  0x14(%ebp)
  800c20:	ff 75 10             	pushl  0x10(%ebp)
  800c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	68 b3 0b 80 00       	push   $0x800bb3
  800c2c:	e8 92 fb ff ff       	call   8007c3 <vprintfmt>
  800c31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c45:	8d 45 10             	lea    0x10(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	50                   	push   %eax
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	ff 75 08             	pushl  0x8(%ebp)
  800c5b:	e8 89 ff ff ff       	call   800be9 <vsnprintf>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 06                	jmp    800c80 <strlen+0x15>
		n++;
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	75 f1                	jne    800c7a <strlen+0xf>
		n++;
	return n;
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9b:	eb 09                	jmp    800ca6 <strnlen+0x18>
		n++;
  800c9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	ff 4d 0c             	decl   0xc(%ebp)
  800ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caa:	74 09                	je     800cb5 <strnlen+0x27>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 e8                	jne    800c9d <strnlen+0xf>
		n++;
	return n;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc6:	90                   	nop
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd9:	8a 12                	mov    (%edx),%dl
  800cdb:	88 10                	mov    %dl,(%eax)
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e4                	jne    800cc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfb:	eb 1f                	jmp    800d1c <strncpy+0x34>
		*dst++ = *src;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 08             	mov    %edx,0x8(%ebp)
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 03                	je     800d19 <strncpy+0x31>
			src++;
  800d16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d19:	ff 45 fc             	incl   -0x4(%ebp)
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d22:	72 d9                	jb     800cfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	74 30                	je     800d6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3b:	eb 16                	jmp    800d53 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 08             	mov    %edx,0x8(%ebp)
  800d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 09                	je     800d65 <strlcpy+0x3c>
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 d8                	jne    800d3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	29 c2                	sub    %eax,%edx
  800d73:	89 d0                	mov    %edx,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7a:	eb 06                	jmp    800d82 <strcmp+0xb>
		p++, q++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	74 0e                	je     800d99 <strcmp+0x22>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 10                	mov    (%eax),%dl
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	38 c2                	cmp    %al,%dl
  800d97:	74 e3                	je     800d7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	0f b6 d0             	movzbl %al,%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	29 c2                	sub    %eax,%edx
  800dab:	89 d0                	mov    %edx,%eax
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db2:	eb 09                	jmp    800dbd <strncmp+0xe>
		n--, p++, q++;
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	74 17                	je     800dda <strncmp+0x2b>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	74 0e                	je     800dda <strncmp+0x2b>
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 10                	mov    (%eax),%dl
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	38 c2                	cmp    %al,%dl
  800dd8:	74 da                	je     800db4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dde:	75 07                	jne    800de7 <strncmp+0x38>
		return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	eb 14                	jmp    800dfb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 04             	sub    $0x4,%esp
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e09:	eb 12                	jmp    800e1d <strchr+0x20>
		if (*s == c)
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e13:	75 05                	jne    800e1a <strchr+0x1d>
			return (char *) s;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	eb 11                	jmp    800e2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 e5                	jne    800e0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 0d                	jmp    800e48 <strfind+0x1b>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	74 0e                	je     800e53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e45:	ff 45 08             	incl   0x8(%ebp)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	84 c0                	test   %al,%al
  800e4f:	75 ea                	jne    800e3b <strfind+0xe>
  800e51:	eb 01                	jmp    800e54 <strfind+0x27>
		if (*s == c)
			break;
  800e53:	90                   	nop
	return (char *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x22>
		*p++ = c;
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e82:	79 e9                	jns    800e6d <memset+0x14>
		*p++ = c;

	return v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e9b:	eb 16                	jmp    800eb3 <memcpy+0x2a>
		*d++ = *s++;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaf:	8a 12                	mov    (%edx),%dl
  800eb1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	75 dd                	jne    800e9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	73 50                	jae    800f2f <memmove+0x6a>
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	76 43                	jbe    800f2f <memmove+0x6a>
		s += n;
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef8:	eb 10                	jmp    800f0a <memmove+0x45>
			*--d = *--s;
  800efa:	ff 4d f8             	decl   -0x8(%ebp)
  800efd:	ff 4d fc             	decl   -0x4(%ebp)
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f10:	89 55 10             	mov    %edx,0x10(%ebp)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	75 e3                	jne    800efa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f17:	eb 23                	jmp    800f3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f35:	89 55 10             	mov    %edx,0x10(%ebp)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	75 dd                	jne    800f19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f53:	eb 2a                	jmp    800f7f <memcmp+0x3e>
		if (*s1 != *s2)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	38 c2                	cmp    %al,%dl
  800f61:	74 16                	je     800f79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 d0             	movzbl %al,%edx
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f b6 c0             	movzbl %al,%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
  800f77:	eb 18                	jmp    800f91 <memcmp+0x50>
		s1++, s2++;
  800f79:	ff 45 fc             	incl   -0x4(%ebp)
  800f7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f85:	89 55 10             	mov    %edx,0x10(%ebp)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	75 c9                	jne    800f55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa4:	eb 15                	jmp    800fbb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f b6 d0             	movzbl %al,%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	39 c2                	cmp    %eax,%edx
  800fb6:	74 0d                	je     800fc5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc1:	72 e3                	jb     800fa6 <memfind+0x13>
  800fc3:	eb 01                	jmp    800fc6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc5:	90                   	nop
	return (void *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	eb 03                	jmp    800fe4 <strtol+0x19>
		s++;
  800fe1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 20                	cmp    $0x20,%al
  800feb:	74 f4                	je     800fe1 <strtol+0x16>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 eb                	je     800fe1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 2b                	cmp    $0x2b,%al
  800ffd:	75 05                	jne    801004 <strtol+0x39>
		s++;
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	eb 13                	jmp    801017 <strtol+0x4c>
	else if (*s == '-')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2d                	cmp    $0x2d,%al
  80100b:	75 0a                	jne    801017 <strtol+0x4c>
		s++, neg = 1;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101b:	74 06                	je     801023 <strtol+0x58>
  80101d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801021:	75 20                	jne    801043 <strtol+0x78>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 30                	cmp    $0x30,%al
  80102a:	75 17                	jne    801043 <strtol+0x78>
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	40                   	inc    %eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 78                	cmp    $0x78,%al
  801034:	75 0d                	jne    801043 <strtol+0x78>
		s += 2, base = 16;
  801036:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801041:	eb 28                	jmp    80106b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	75 15                	jne    80105e <strtol+0x93>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 30                	cmp    $0x30,%al
  801050:	75 0c                	jne    80105e <strtol+0x93>
		s++, base = 8;
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105c:	eb 0d                	jmp    80106b <strtol+0xa0>
	else if (base == 0)
  80105e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801062:	75 07                	jne    80106b <strtol+0xa0>
		base = 10;
  801064:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 2f                	cmp    $0x2f,%al
  801072:	7e 19                	jle    80108d <strtol+0xc2>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 39                	cmp    $0x39,%al
  80107b:	7f 10                	jg     80108d <strtol+0xc2>
			dig = *s - '0';
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	83 e8 30             	sub    $0x30,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108b:	eb 42                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 60                	cmp    $0x60,%al
  801094:	7e 19                	jle    8010af <strtol+0xe4>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 7a                	cmp    $0x7a,%al
  80109d:	7f 10                	jg     8010af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 57             	sub    $0x57,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 20                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 40                	cmp    $0x40,%al
  8010b6:	7e 39                	jle    8010f1 <strtol+0x126>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 5a                	cmp    $0x5a,%al
  8010bf:	7f 30                	jg     8010f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	83 e8 37             	sub    $0x37,%eax
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d5:	7d 19                	jge    8010f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010eb:	e9 7b ff ff ff       	jmp    80106b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 08                	je     8010ff <strtol+0x134>
		*endptr = (char *) s;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 07                	je     80110c <strtol+0x141>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	f7 d8                	neg    %eax
  80110a:	eb 03                	jmp    80110f <strtol+0x144>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <ltostr>:

void
ltostr(long value, char *str)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80111e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801129:	79 13                	jns    80113e <ltostr+0x2d>
	{
		neg = 1;
  80112b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801138:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801146:	99                   	cltd   
  801147:	f7 f9                	idiv   %ecx
  801149:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114f:	8d 50 01             	lea    0x1(%eax),%edx
  801152:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801155:	89 c2                	mov    %eax,%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 d0                	add    %edx,%eax
  80115c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115f:	83 c2 30             	add    $0x30,%edx
  801162:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801167:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116c:	f7 e9                	imul   %ecx
  80116e:	c1 fa 02             	sar    $0x2,%edx
  801171:	89 c8                	mov    %ecx,%eax
  801173:	c1 f8 1f             	sar    $0x1f,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
  80117a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80117d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801180:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801185:	f7 e9                	imul   %ecx
  801187:	c1 fa 02             	sar    $0x2,%edx
  80118a:	89 c8                	mov    %ecx,%eax
  80118c:	c1 f8 1f             	sar    $0x1f,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
  801193:	c1 e0 02             	shl    $0x2,%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	01 c0                	add    %eax,%eax
  80119a:	29 c1                	sub    %eax,%ecx
  80119c:	89 ca                	mov    %ecx,%edx
  80119e:	85 d2                	test   %edx,%edx
  8011a0:	75 9c                	jne    80113e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	48                   	dec    %eax
  8011ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b4:	74 3d                	je     8011f3 <ltostr+0xe2>
		start = 1 ;
  8011b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011bd:	eb 34                	jmp    8011f3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 c8                	add    %ecx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f9:	7c c4                	jl     8011bf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 54 fa ff ff       	call   800c6b <strlen>
  801217:	83 c4 04             	add    $0x4,%esp
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 46 fa ff ff       	call   800c6b <strlen>
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80122b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801239:	eb 17                	jmp    801252 <strcconcat+0x49>
		final[s] = str1[s] ;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	01 c8                	add    %ecx,%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80124f:	ff 45 fc             	incl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801258:	7c e1                	jl     80123b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801261:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801268:	eb 1f                	jmp    801289 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c8                	add    %ecx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801286:	ff 45 f8             	incl   -0x8(%ebp)
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128f:	7c d9                	jl     80126a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	c6 00 00             	movb   $0x0,(%eax)
}
  80129c:	90                   	nop
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	8b 00                	mov    (%eax),%eax
  8012b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c2:	eb 0c                	jmp    8012d0 <strsplit+0x31>
			*string++ = 0;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8012cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 18                	je     8012f1 <strsplit+0x52>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 13 fb ff ff       	call   800dfd <strchr>
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	75 d3                	jne    8012c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 5a                	je     801354 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	83 f8 0f             	cmp    $0xf,%eax
  801302:	75 07                	jne    80130b <strsplit+0x6c>
		{
			return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	eb 66                	jmp    801371 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80130b:	8b 45 14             	mov    0x14(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	8d 48 01             	lea    0x1(%eax),%ecx
  801313:	8b 55 14             	mov    0x14(%ebp),%edx
  801316:	89 0a                	mov    %ecx,(%edx)
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801329:	eb 03                	jmp    80132e <strsplit+0x8f>
			string++;
  80132b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	84 c0                	test   %al,%al
  801335:	74 8b                	je     8012c2 <strsplit+0x23>
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	50                   	push   %eax
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	e8 b5 fa ff ff       	call   800dfd <strchr>
  801348:	83 c4 08             	add    $0x8,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	74 dc                	je     80132b <strsplit+0x8c>
			string++;
	}
  80134f:	e9 6e ff ff ff       	jmp    8012c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801354:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80136c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801379:	a1 04 40 80 00       	mov    0x804004,%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	74 1f                	je     8013a1 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801382:	e8 1d 00 00 00       	call   8013a4 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	68 f0 3a 80 00       	push   $0x803af0
  80138f:	e8 55 f2 ff ff       	call   8005e9 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801397:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80139e:	00 00 00 
	}
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8013aa:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013b1:	00 00 00 
  8013b4:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013bb:	00 00 00 
  8013be:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013c5:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8013c8:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013cf:	00 00 00 
  8013d2:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013d9:	00 00 00 
  8013dc:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013e3:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8013e6:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013ed:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8013f0:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8013f7:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801401:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801406:	2d 00 10 00 00       	sub    $0x1000,%eax
  80140b:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801410:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80141a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80141f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	6a 06                	push   $0x6
  801429:	ff 75 f4             	pushl  -0xc(%ebp)
  80142c:	50                   	push   %eax
  80142d:	e8 ee 05 00 00       	call   801a20 <sys_allocate_chunk>
  801432:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801435:	a1 20 41 80 00       	mov    0x804120,%eax
  80143a:	83 ec 0c             	sub    $0xc,%esp
  80143d:	50                   	push   %eax
  80143e:	e8 63 0c 00 00       	call   8020a6 <initialize_MemBlocksList>
  801443:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801446:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80144b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  80144e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801451:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145b:	8b 40 0c             	mov    0xc(%eax),%eax
  80145e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801464:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801469:	89 c2                	mov    %eax,%edx
  80146b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80146e:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801474:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80147b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801482:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801485:	8b 50 08             	mov    0x8(%eax),%edx
  801488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148b:	01 d0                	add    %edx,%eax
  80148d:	48                   	dec    %eax
  80148e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801491:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801494:	ba 00 00 00 00       	mov    $0x0,%edx
  801499:	f7 75 e0             	divl   -0x20(%ebp)
  80149c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80149f:	29 d0                	sub    %edx,%eax
  8014a1:	89 c2                	mov    %eax,%edx
  8014a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a6:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8014a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014ad:	75 14                	jne    8014c3 <initialize_dyn_block_system+0x11f>
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	68 15 3b 80 00       	push   $0x803b15
  8014b7:	6a 34                	push   $0x34
  8014b9:	68 33 3b 80 00       	push   $0x803b33
  8014be:	e8 72 ee ff ff       	call   800335 <_panic>
  8014c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014c6:	8b 00                	mov    (%eax),%eax
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	74 10                	je     8014dc <initialize_dyn_block_system+0x138>
  8014cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014cf:	8b 00                	mov    (%eax),%eax
  8014d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014d4:	8b 52 04             	mov    0x4(%edx),%edx
  8014d7:	89 50 04             	mov    %edx,0x4(%eax)
  8014da:	eb 0b                	jmp    8014e7 <initialize_dyn_block_system+0x143>
  8014dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014df:	8b 40 04             	mov    0x4(%eax),%eax
  8014e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ea:	8b 40 04             	mov    0x4(%eax),%eax
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	74 0f                	je     801500 <initialize_dyn_block_system+0x15c>
  8014f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f4:	8b 40 04             	mov    0x4(%eax),%eax
  8014f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014fa:	8b 12                	mov    (%edx),%edx
  8014fc:	89 10                	mov    %edx,(%eax)
  8014fe:	eb 0a                	jmp    80150a <initialize_dyn_block_system+0x166>
  801500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801503:	8b 00                	mov    (%eax),%eax
  801505:	a3 48 41 80 00       	mov    %eax,0x804148
  80150a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801516:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80151d:	a1 54 41 80 00       	mov    0x804154,%eax
  801522:	48                   	dec    %eax
  801523:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	e8 c4 13 00 00       	call   8028f7 <insert_sorted_with_merge_freeList>
  801533:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801536:	90                   	nop
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80153f:	e8 2f fe ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  801544:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801548:	75 07                	jne    801551 <malloc+0x18>
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	eb 71                	jmp    8015c2 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801551:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801558:	76 07                	jbe    801561 <malloc+0x28>
	return NULL;
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	eb 61                	jmp    8015c2 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801561:	e8 88 08 00 00       	call   801dee <sys_isUHeapPlacementStrategyFIRSTFIT>
  801566:	85 c0                	test   %eax,%eax
  801568:	74 53                	je     8015bd <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80156a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801571:	8b 55 08             	mov    0x8(%ebp),%edx
  801574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801577:	01 d0                	add    %edx,%eax
  801579:	48                   	dec    %eax
  80157a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801580:	ba 00 00 00 00       	mov    $0x0,%edx
  801585:	f7 75 f4             	divl   -0xc(%ebp)
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	29 d0                	sub    %edx,%eax
  80158d:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801590:	83 ec 0c             	sub    $0xc,%esp
  801593:	ff 75 ec             	pushl  -0x14(%ebp)
  801596:	e8 d2 0d 00 00       	call   80236d <alloc_block_FF>
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8015a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015a5:	74 16                	je     8015bd <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8015a7:	83 ec 0c             	sub    $0xc,%esp
  8015aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ad:	e8 0c 0c 00 00       	call   8021be <insert_sorted_allocList>
  8015b2:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8015b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b8:	8b 40 08             	mov    0x8(%eax),%eax
  8015bb:	eb 05                	jmp    8015c2 <malloc+0x89>
    }

			}


	return NULL;
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	ff 75 f0             	pushl  -0x10(%ebp)
  8015e1:	68 40 40 80 00       	push   $0x804040
  8015e6:	e8 a0 0b 00 00       	call   80218b <find_block>
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8015f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	83 ec 08             	sub    $0x8,%esp
  8015fd:	52                   	push   %edx
  8015fe:	50                   	push   %eax
  8015ff:	e8 e4 03 00 00       	call   8019e8 <sys_free_user_mem>
  801604:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801607:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160b:	75 17                	jne    801624 <free+0x60>
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	68 15 3b 80 00       	push   $0x803b15
  801615:	68 84 00 00 00       	push   $0x84
  80161a:	68 33 3b 80 00       	push   $0x803b33
  80161f:	e8 11 ed ff ff       	call   800335 <_panic>
  801624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801627:	8b 00                	mov    (%eax),%eax
  801629:	85 c0                	test   %eax,%eax
  80162b:	74 10                	je     80163d <free+0x79>
  80162d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801630:	8b 00                	mov    (%eax),%eax
  801632:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801635:	8b 52 04             	mov    0x4(%edx),%edx
  801638:	89 50 04             	mov    %edx,0x4(%eax)
  80163b:	eb 0b                	jmp    801648 <free+0x84>
  80163d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801640:	8b 40 04             	mov    0x4(%eax),%eax
  801643:	a3 44 40 80 00       	mov    %eax,0x804044
  801648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164b:	8b 40 04             	mov    0x4(%eax),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	74 0f                	je     801661 <free+0x9d>
  801652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801655:	8b 40 04             	mov    0x4(%eax),%eax
  801658:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80165b:	8b 12                	mov    (%edx),%edx
  80165d:	89 10                	mov    %edx,(%eax)
  80165f:	eb 0a                	jmp    80166b <free+0xa7>
  801661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801664:	8b 00                	mov    (%eax),%eax
  801666:	a3 40 40 80 00       	mov    %eax,0x804040
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801677:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80167e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801683:	48                   	dec    %eax
  801684:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801689:	83 ec 0c             	sub    $0xc,%esp
  80168c:	ff 75 ec             	pushl  -0x14(%ebp)
  80168f:	e8 63 12 00 00       	call   8028f7 <insert_sorted_with_merge_freeList>
  801694:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801697:	90                   	nop
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 38             	sub    $0x38,%esp
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a6:	e8 c8 fc ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016af:	75 0a                	jne    8016bb <smalloc+0x21>
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b6:	e9 a0 00 00 00       	jmp    80175b <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8016bb:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016c2:	76 0a                	jbe    8016ce <smalloc+0x34>
		return NULL;
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	e9 8d 00 00 00       	jmp    80175b <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ce:	e8 1b 07 00 00       	call   801dee <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 7f                	je     801756 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016d7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e4:	01 d0                	add    %edx,%eax
  8016e6:	48                   	dec    %eax
  8016e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f2:	f7 75 f4             	divl   -0xc(%ebp)
  8016f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f8:	29 d0                	sub    %edx,%eax
  8016fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8016fd:	83 ec 0c             	sub    $0xc,%esp
  801700:	ff 75 ec             	pushl  -0x14(%ebp)
  801703:	e8 65 0c 00 00       	call   80236d <alloc_block_FF>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  80170e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801712:	74 42                	je     801756 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801714:	83 ec 0c             	sub    $0xc,%esp
  801717:	ff 75 e8             	pushl  -0x18(%ebp)
  80171a:	e8 9f 0a 00 00       	call   8021be <insert_sorted_allocList>
  80171f:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801722:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801725:	8b 40 08             	mov    0x8(%eax),%eax
  801728:	89 c2                	mov    %eax,%edx
  80172a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80172e:	52                   	push   %edx
  80172f:	50                   	push   %eax
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	e8 38 04 00 00       	call   801b73 <sys_createSharedObject>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801741:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801745:	79 07                	jns    80174e <smalloc+0xb4>
	    		  return NULL;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	eb 0d                	jmp    80175b <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80174e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801751:	8b 40 08             	mov    0x8(%eax),%eax
  801754:	eb 05                	jmp    80175b <smalloc+0xc1>


				}


		return NULL;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801763:	e8 0b fc ff ff       	call   801373 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801768:	e8 81 06 00 00       	call   801dee <sys_isUHeapPlacementStrategyFIRSTFIT>
  80176d:	85 c0                	test   %eax,%eax
  80176f:	0f 84 9f 00 00 00    	je     801814 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	e8 1a 04 00 00       	call   801b9d <sys_getSizeOfSharedObject>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801789:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80178d:	79 0a                	jns    801799 <sget+0x3c>
		return NULL;
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	e9 80 00 00 00       	jmp    801819 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801799:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	48                   	dec    %eax
  8017a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017af:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b4:	f7 75 f0             	divl   -0x10(%ebp)
  8017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ba:	29 d0                	sub    %edx,%eax
  8017bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8017bf:	83 ec 0c             	sub    $0xc,%esp
  8017c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8017c5:	e8 a3 0b 00 00       	call   80236d <alloc_block_FF>
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  8017d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017d4:	74 3e                	je     801814 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017dc:	e8 dd 09 00 00       	call   8021be <insert_sorted_allocList>
  8017e1:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8017e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e7:	8b 40 08             	mov    0x8(%eax),%eax
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	50                   	push   %eax
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	ff 75 08             	pushl  0x8(%ebp)
  8017f4:	e8 c1 03 00 00       	call   801bba <sys_getSharedObject>
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8017ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801803:	79 07                	jns    80180c <sget+0xaf>
	    		  return NULL;
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
  80180a:	eb 0d                	jmp    801819 <sget+0xbc>
	  	return(void*) returned_block->sva;
  80180c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180f:	8b 40 08             	mov    0x8(%eax),%eax
  801812:	eb 05                	jmp    801819 <sget+0xbc>
	      }
	}
	   return NULL;
  801814:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801821:	e8 4d fb ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	68 40 3b 80 00       	push   $0x803b40
  80182e:	68 12 01 00 00       	push   $0x112
  801833:	68 33 3b 80 00       	push   $0x803b33
  801838:	e8 f8 ea ff ff       	call   800335 <_panic>

0080183d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	68 68 3b 80 00       	push   $0x803b68
  80184b:	68 26 01 00 00       	push   $0x126
  801850:	68 33 3b 80 00       	push   $0x803b33
  801855:	e8 db ea ff ff       	call   800335 <_panic>

0080185a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	68 8c 3b 80 00       	push   $0x803b8c
  801868:	68 31 01 00 00       	push   $0x131
  80186d:	68 33 3b 80 00       	push   $0x803b33
  801872:	e8 be ea ff ff       	call   800335 <_panic>

00801877 <shrink>:

}
void shrink(uint32 newSize)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	68 8c 3b 80 00       	push   $0x803b8c
  801885:	68 36 01 00 00       	push   $0x136
  80188a:	68 33 3b 80 00       	push   $0x803b33
  80188f:	e8 a1 ea ff ff       	call   800335 <_panic>

00801894 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	68 8c 3b 80 00       	push   $0x803b8c
  8018a2:	68 3b 01 00 00       	push   $0x13b
  8018a7:	68 33 3b 80 00       	push   $0x803b33
  8018ac:	e8 84 ea ff ff       	call   800335 <_panic>

008018b1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	57                   	push   %edi
  8018b5:	56                   	push   %esi
  8018b6:	53                   	push   %ebx
  8018b7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018c9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018cc:	cd 30                	int    $0x30
  8018ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5f                   	pop    %edi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 04             	sub    $0x4,%esp
  8018e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018e8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	52                   	push   %edx
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	50                   	push   %eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	e8 b2 ff ff ff       	call   8018b1 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_cgetc>:

int
sys_cgetc(void)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 01                	push   $0x1
  801914:	e8 98 ff ff ff       	call   8018b1 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801921:	8b 55 0c             	mov    0xc(%ebp),%edx
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	6a 05                	push   $0x5
  801931:	e8 7b ff ff ff       	call   8018b1 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801940:	8b 75 18             	mov    0x18(%ebp),%esi
  801943:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801946:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	51                   	push   %ecx
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	6a 06                	push   $0x6
  801956:	e8 56 ff ff ff       	call   8018b1 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801961:	5b                   	pop    %ebx
  801962:	5e                   	pop    %esi
  801963:	5d                   	pop    %ebp
  801964:	c3                   	ret    

00801965 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	52                   	push   %edx
  801975:	50                   	push   %eax
  801976:	6a 07                	push   $0x7
  801978:	e8 34 ff ff ff       	call   8018b1 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	ff 75 08             	pushl  0x8(%ebp)
  801991:	6a 08                	push   $0x8
  801993:	e8 19 ff ff ff       	call   8018b1 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 09                	push   $0x9
  8019ac:	e8 00 ff ff ff       	call   8018b1 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 0a                	push   $0xa
  8019c5:	e8 e7 fe ff ff       	call   8018b1 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 0b                	push   $0xb
  8019de:	e8 ce fe ff ff       	call   8018b1 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	ff 75 08             	pushl  0x8(%ebp)
  8019f7:	6a 0f                	push   $0xf
  8019f9:	e8 b3 fe ff ff       	call   8018b1 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
	return;
  801a01:	90                   	nop
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	6a 10                	push   $0x10
  801a15:	e8 97 fe ff ff       	call   8018b1 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1d:	90                   	nop
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	ff 75 10             	pushl  0x10(%ebp)
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	ff 75 08             	pushl  0x8(%ebp)
  801a30:	6a 11                	push   $0x11
  801a32:	e8 7a fe ff ff       	call   8018b1 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3a:	90                   	nop
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 0c                	push   $0xc
  801a4c:	e8 60 fe ff ff       	call   8018b1 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	ff 75 08             	pushl  0x8(%ebp)
  801a64:	6a 0d                	push   $0xd
  801a66:	e8 46 fe ff ff       	call   8018b1 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 0e                	push   $0xe
  801a7f:	e8 2d fe ff ff       	call   8018b1 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	90                   	nop
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 13                	push   $0x13
  801a99:	e8 13 fe ff ff       	call   8018b1 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	90                   	nop
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 14                	push   $0x14
  801ab3:	e8 f9 fd ff ff       	call   8018b1 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	90                   	nop
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_cputc>:


void
sys_cputc(const char c)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 04             	sub    $0x4,%esp
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	50                   	push   %eax
  801ad7:	6a 15                	push   $0x15
  801ad9:	e8 d3 fd ff ff       	call   8018b1 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 16                	push   $0x16
  801af3:	e8 b9 fd ff ff       	call   8018b1 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	90                   	nop
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	50                   	push   %eax
  801b0e:	6a 17                	push   $0x17
  801b10:	e8 9c fd ff ff       	call   8018b1 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	52                   	push   %edx
  801b2a:	50                   	push   %eax
  801b2b:	6a 1a                	push   $0x1a
  801b2d:	e8 7f fd ff ff       	call   8018b1 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 18                	push   $0x18
  801b4a:	e8 62 fd ff ff       	call   8018b1 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	90                   	nop
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	52                   	push   %edx
  801b65:	50                   	push   %eax
  801b66:	6a 19                	push   $0x19
  801b68:	e8 44 fd ff ff       	call   8018b1 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	90                   	nop
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b82:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	51                   	push   %ecx
  801b8c:	52                   	push   %edx
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	50                   	push   %eax
  801b91:	6a 1b                	push   $0x1b
  801b93:	e8 19 fd ff ff       	call   8018b1 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	52                   	push   %edx
  801bad:	50                   	push   %eax
  801bae:	6a 1c                	push   $0x1c
  801bb0:	e8 fc fc ff ff       	call   8018b1 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bbd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	51                   	push   %ecx
  801bcb:	52                   	push   %edx
  801bcc:	50                   	push   %eax
  801bcd:	6a 1d                	push   $0x1d
  801bcf:	e8 dd fc ff ff       	call   8018b1 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	52                   	push   %edx
  801be9:	50                   	push   %eax
  801bea:	6a 1e                	push   $0x1e
  801bec:	e8 c0 fc ff ff       	call   8018b1 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 1f                	push   $0x1f
  801c05:	e8 a7 fc ff ff       	call   8018b1 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	ff 75 14             	pushl  0x14(%ebp)
  801c1a:	ff 75 10             	pushl  0x10(%ebp)
  801c1d:	ff 75 0c             	pushl  0xc(%ebp)
  801c20:	50                   	push   %eax
  801c21:	6a 20                	push   $0x20
  801c23:	e8 89 fc ff ff       	call   8018b1 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	50                   	push   %eax
  801c3c:	6a 21                	push   $0x21
  801c3e:	e8 6e fc ff ff       	call   8018b1 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	50                   	push   %eax
  801c58:	6a 22                	push   $0x22
  801c5a:	e8 52 fc ff ff       	call   8018b1 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 02                	push   $0x2
  801c73:	e8 39 fc ff ff       	call   8018b1 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 03                	push   $0x3
  801c8c:	e8 20 fc ff ff       	call   8018b1 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 04                	push   $0x4
  801ca5:	e8 07 fc ff ff       	call   8018b1 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_exit_env>:


void sys_exit_env(void)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 23                	push   $0x23
  801cbe:	e8 ee fb ff ff       	call   8018b1 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	90                   	nop
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ccf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd2:	8d 50 04             	lea    0x4(%eax),%edx
  801cd5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	52                   	push   %edx
  801cdf:	50                   	push   %eax
  801ce0:	6a 24                	push   $0x24
  801ce2:	e8 ca fb ff ff       	call   8018b1 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
	return result;
  801cea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cf3:	89 01                	mov    %eax,(%ecx)
  801cf5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	c9                   	leave  
  801cfc:	c2 04 00             	ret    $0x4

00801cff <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	ff 75 10             	pushl  0x10(%ebp)
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	ff 75 08             	pushl  0x8(%ebp)
  801d0f:	6a 12                	push   $0x12
  801d11:	e8 9b fb ff ff       	call   8018b1 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
	return ;
  801d19:	90                   	nop
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_rcr2>:
uint32 sys_rcr2()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 25                	push   $0x25
  801d2b:	e8 81 fb ff ff       	call   8018b1 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 04             	sub    $0x4,%esp
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d41:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	50                   	push   %eax
  801d4e:	6a 26                	push   $0x26
  801d50:	e8 5c fb ff ff       	call   8018b1 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
	return ;
  801d58:	90                   	nop
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <rsttst>:
void rsttst()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 28                	push   $0x28
  801d6a:	e8 42 fb ff ff       	call   8018b1 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d72:	90                   	nop
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d81:	8b 55 18             	mov    0x18(%ebp),%edx
  801d84:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d88:	52                   	push   %edx
  801d89:	50                   	push   %eax
  801d8a:	ff 75 10             	pushl  0x10(%ebp)
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	ff 75 08             	pushl  0x8(%ebp)
  801d93:	6a 27                	push   $0x27
  801d95:	e8 17 fb ff ff       	call   8018b1 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9d:	90                   	nop
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <chktst>:
void chktst(uint32 n)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	6a 29                	push   $0x29
  801db0:	e8 fc fa ff ff       	call   8018b1 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
	return ;
  801db8:	90                   	nop
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <inctst>:

void inctst()
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 2a                	push   $0x2a
  801dca:	e8 e2 fa ff ff       	call   8018b1 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd2:	90                   	nop
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <gettst>:
uint32 gettst()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 2b                	push   $0x2b
  801de4:	e8 c8 fa ff ff       	call   8018b1 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 2c                	push   $0x2c
  801e00:	e8 ac fa ff ff       	call   8018b1 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
  801e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e0b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e0f:	75 07                	jne    801e18 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e11:	b8 01 00 00 00       	mov    $0x1,%eax
  801e16:	eb 05                	jmp    801e1d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 2c                	push   $0x2c
  801e31:	e8 7b fa ff ff       	call   8018b1 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
  801e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e3c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e40:	75 07                	jne    801e49 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e42:	b8 01 00 00 00       	mov    $0x1,%eax
  801e47:	eb 05                	jmp    801e4e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 2c                	push   $0x2c
  801e62:	e8 4a fa ff ff       	call   8018b1 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
  801e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e6d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e71:	75 07                	jne    801e7a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e73:	b8 01 00 00 00       	mov    $0x1,%eax
  801e78:	eb 05                	jmp    801e7f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 2c                	push   $0x2c
  801e93:	e8 19 fa ff ff       	call   8018b1 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
  801e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e9e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ea2:	75 07                	jne    801eab <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ea4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea9:	eb 05                	jmp    801eb0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	6a 2d                	push   $0x2d
  801ec2:	e8 ea f9 ff ff       	call   8018b1 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ed1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	6a 00                	push   $0x0
  801edf:	53                   	push   %ebx
  801ee0:	51                   	push   %ecx
  801ee1:	52                   	push   %edx
  801ee2:	50                   	push   %eax
  801ee3:	6a 2e                	push   $0x2e
  801ee5:	e8 c7 f9 ff ff       	call   8018b1 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	52                   	push   %edx
  801f02:	50                   	push   %eax
  801f03:	6a 2f                	push   $0x2f
  801f05:	e8 a7 f9 ff ff       	call   8018b1 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f15:	83 ec 0c             	sub    $0xc,%esp
  801f18:	68 9c 3b 80 00       	push   $0x803b9c
  801f1d:	e8 c7 e6 ff ff       	call   8005e9 <cprintf>
  801f22:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	68 c8 3b 80 00       	push   $0x803bc8
  801f34:	e8 b0 e6 ff ff       	call   8005e9 <cprintf>
  801f39:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f3c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f40:	a1 38 41 80 00       	mov    0x804138,%eax
  801f45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f48:	eb 56                	jmp    801fa0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4e:	74 1c                	je     801f6c <print_mem_block_lists+0x5d>
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 50 08             	mov    0x8(%eax),%edx
  801f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f59:	8b 48 08             	mov    0x8(%eax),%ecx
  801f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f62:	01 c8                	add    %ecx,%eax
  801f64:	39 c2                	cmp    %eax,%edx
  801f66:	73 04                	jae    801f6c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f68:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 50 08             	mov    0x8(%eax),%edx
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	8b 40 0c             	mov    0xc(%eax),%eax
  801f78:	01 c2                	add    %eax,%edx
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	8b 40 08             	mov    0x8(%eax),%eax
  801f80:	83 ec 04             	sub    $0x4,%esp
  801f83:	52                   	push   %edx
  801f84:	50                   	push   %eax
  801f85:	68 dd 3b 80 00       	push   $0x803bdd
  801f8a:	e8 5a e6 ff ff       	call   8005e9 <cprintf>
  801f8f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f98:	a1 40 41 80 00       	mov    0x804140,%eax
  801f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa4:	74 07                	je     801fad <print_mem_block_lists+0x9e>
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	8b 00                	mov    (%eax),%eax
  801fab:	eb 05                	jmp    801fb2 <print_mem_block_lists+0xa3>
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb2:	a3 40 41 80 00       	mov    %eax,0x804140
  801fb7:	a1 40 41 80 00       	mov    0x804140,%eax
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	75 8a                	jne    801f4a <print_mem_block_lists+0x3b>
  801fc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc4:	75 84                	jne    801f4a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fc6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fca:	75 10                	jne    801fdc <print_mem_block_lists+0xcd>
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	68 ec 3b 80 00       	push   $0x803bec
  801fd4:	e8 10 e6 ff ff       	call   8005e9 <cprintf>
  801fd9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fdc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	68 10 3c 80 00       	push   $0x803c10
  801feb:	e8 f9 e5 ff ff       	call   8005e9 <cprintf>
  801ff0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ff3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff7:	a1 40 40 80 00       	mov    0x804040,%eax
  801ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fff:	eb 56                	jmp    802057 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802001:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802005:	74 1c                	je     802023 <print_mem_block_lists+0x114>
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	8b 50 08             	mov    0x8(%eax),%edx
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802010:	8b 48 08             	mov    0x8(%eax),%ecx
  802013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802016:	8b 40 0c             	mov    0xc(%eax),%eax
  802019:	01 c8                	add    %ecx,%eax
  80201b:	39 c2                	cmp    %eax,%edx
  80201d:	73 04                	jae    802023 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80201f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802026:	8b 50 08             	mov    0x8(%eax),%edx
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	8b 40 0c             	mov    0xc(%eax),%eax
  80202f:	01 c2                	add    %eax,%edx
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	8b 40 08             	mov    0x8(%eax),%eax
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	52                   	push   %edx
  80203b:	50                   	push   %eax
  80203c:	68 dd 3b 80 00       	push   $0x803bdd
  802041:	e8 a3 e5 ff ff       	call   8005e9 <cprintf>
  802046:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80204f:	a1 48 40 80 00       	mov    0x804048,%eax
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802057:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205b:	74 07                	je     802064 <print_mem_block_lists+0x155>
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	8b 00                	mov    (%eax),%eax
  802062:	eb 05                	jmp    802069 <print_mem_block_lists+0x15a>
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	a3 48 40 80 00       	mov    %eax,0x804048
  80206e:	a1 48 40 80 00       	mov    0x804048,%eax
  802073:	85 c0                	test   %eax,%eax
  802075:	75 8a                	jne    802001 <print_mem_block_lists+0xf2>
  802077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207b:	75 84                	jne    802001 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80207d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802081:	75 10                	jne    802093 <print_mem_block_lists+0x184>
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	68 28 3c 80 00       	push   $0x803c28
  80208b:	e8 59 e5 ff ff       	call   8005e9 <cprintf>
  802090:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	68 9c 3b 80 00       	push   $0x803b9c
  80209b:	e8 49 e5 ff ff       	call   8005e9 <cprintf>
  8020a0:	83 c4 10             	add    $0x10,%esp

}
  8020a3:	90                   	nop
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8020ac:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020b3:	00 00 00 
  8020b6:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020bd:	00 00 00 
  8020c0:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020c7:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8020ca:	a1 50 40 80 00       	mov    0x804050,%eax
  8020cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8020d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020d9:	e9 9e 00 00 00       	jmp    80217c <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8020de:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e6:	c1 e2 04             	shl    $0x4,%edx
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	75 14                	jne    802103 <initialize_MemBlocksList+0x5d>
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	68 50 3c 80 00       	push   $0x803c50
  8020f7:	6a 48                	push   $0x48
  8020f9:	68 73 3c 80 00       	push   $0x803c73
  8020fe:	e8 32 e2 ff ff       	call   800335 <_panic>
  802103:	a1 50 40 80 00       	mov    0x804050,%eax
  802108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210b:	c1 e2 04             	shl    $0x4,%edx
  80210e:	01 d0                	add    %edx,%eax
  802110:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802116:	89 10                	mov    %edx,(%eax)
  802118:	8b 00                	mov    (%eax),%eax
  80211a:	85 c0                	test   %eax,%eax
  80211c:	74 18                	je     802136 <initialize_MemBlocksList+0x90>
  80211e:	a1 48 41 80 00       	mov    0x804148,%eax
  802123:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802129:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80212c:	c1 e1 04             	shl    $0x4,%ecx
  80212f:	01 ca                	add    %ecx,%edx
  802131:	89 50 04             	mov    %edx,0x4(%eax)
  802134:	eb 12                	jmp    802148 <initialize_MemBlocksList+0xa2>
  802136:	a1 50 40 80 00       	mov    0x804050,%eax
  80213b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213e:	c1 e2 04             	shl    $0x4,%edx
  802141:	01 d0                	add    %edx,%eax
  802143:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802148:	a1 50 40 80 00       	mov    0x804050,%eax
  80214d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802150:	c1 e2 04             	shl    $0x4,%edx
  802153:	01 d0                	add    %edx,%eax
  802155:	a3 48 41 80 00       	mov    %eax,0x804148
  80215a:	a1 50 40 80 00       	mov    0x804050,%eax
  80215f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802162:	c1 e2 04             	shl    $0x4,%edx
  802165:	01 d0                	add    %edx,%eax
  802167:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216e:	a1 54 41 80 00       	mov    0x804154,%eax
  802173:	40                   	inc    %eax
  802174:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802179:	ff 45 f4             	incl   -0xc(%ebp)
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802182:	0f 82 56 ff ff ff    	jb     8020de <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802188:	90                   	nop
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	8b 00                	mov    (%eax),%eax
  802196:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802199:	eb 18                	jmp    8021b3 <find_block+0x28>
		{
			if(tmp->sva==va)
  80219b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219e:	8b 40 08             	mov    0x8(%eax),%eax
  8021a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021a4:	75 05                	jne    8021ab <find_block+0x20>
			{
				return tmp;
  8021a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a9:	eb 11                	jmp    8021bc <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8021ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8021b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b7:	75 e2                	jne    80219b <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8021b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8021c4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	0f 85 83 00 00 00    	jne    802254 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8021d1:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8021d8:	00 00 00 
  8021db:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8021e2:	00 00 00 
  8021e5:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8021ec:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f3:	75 14                	jne    802209 <insert_sorted_allocList+0x4b>
  8021f5:	83 ec 04             	sub    $0x4,%esp
  8021f8:	68 50 3c 80 00       	push   $0x803c50
  8021fd:	6a 7f                	push   $0x7f
  8021ff:	68 73 3c 80 00       	push   $0x803c73
  802204:	e8 2c e1 ff ff       	call   800335 <_panic>
  802209:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	89 10                	mov    %edx,(%eax)
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	8b 00                	mov    (%eax),%eax
  802219:	85 c0                	test   %eax,%eax
  80221b:	74 0d                	je     80222a <insert_sorted_allocList+0x6c>
  80221d:	a1 40 40 80 00       	mov    0x804040,%eax
  802222:	8b 55 08             	mov    0x8(%ebp),%edx
  802225:	89 50 04             	mov    %edx,0x4(%eax)
  802228:	eb 08                	jmp    802232 <insert_sorted_allocList+0x74>
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	a3 44 40 80 00       	mov    %eax,0x804044
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 40 40 80 00       	mov    %eax,0x804040
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802244:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802249:	40                   	inc    %eax
  80224a:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80224f:	e9 16 01 00 00       	jmp    80236a <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	8b 50 08             	mov    0x8(%eax),%edx
  80225a:	a1 44 40 80 00       	mov    0x804044,%eax
  80225f:	8b 40 08             	mov    0x8(%eax),%eax
  802262:	39 c2                	cmp    %eax,%edx
  802264:	76 68                	jbe    8022ce <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802266:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226a:	75 17                	jne    802283 <insert_sorted_allocList+0xc5>
  80226c:	83 ec 04             	sub    $0x4,%esp
  80226f:	68 8c 3c 80 00       	push   $0x803c8c
  802274:	68 85 00 00 00       	push   $0x85
  802279:	68 73 3c 80 00       	push   $0x803c73
  80227e:	e8 b2 e0 ff ff       	call   800335 <_panic>
  802283:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	89 50 04             	mov    %edx,0x4(%eax)
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	8b 40 04             	mov    0x4(%eax),%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	74 0c                	je     8022a5 <insert_sorted_allocList+0xe7>
  802299:	a1 44 40 80 00       	mov    0x804044,%eax
  80229e:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a1:	89 10                	mov    %edx,(%eax)
  8022a3:	eb 08                	jmp    8022ad <insert_sorted_allocList+0xef>
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022be:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022c3:	40                   	inc    %eax
  8022c4:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022c9:	e9 9c 00 00 00       	jmp    80236a <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8022ce:	a1 40 40 80 00       	mov    0x804040,%eax
  8022d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8022d6:	e9 85 00 00 00       	jmp    802360 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	8b 50 08             	mov    0x8(%eax),%edx
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 40 08             	mov    0x8(%eax),%eax
  8022e7:	39 c2                	cmp    %eax,%edx
  8022e9:	73 6d                	jae    802358 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8022eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ef:	74 06                	je     8022f7 <insert_sorted_allocList+0x139>
  8022f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f5:	75 17                	jne    80230e <insert_sorted_allocList+0x150>
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 b0 3c 80 00       	push   $0x803cb0
  8022ff:	68 90 00 00 00       	push   $0x90
  802304:	68 73 3c 80 00       	push   $0x803c73
  802309:	e8 27 e0 ff ff       	call   800335 <_panic>
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 50 04             	mov    0x4(%eax),%edx
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	89 50 04             	mov    %edx,0x4(%eax)
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802320:	89 10                	mov    %edx,(%eax)
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 40 04             	mov    0x4(%eax),%eax
  802328:	85 c0                	test   %eax,%eax
  80232a:	74 0d                	je     802339 <insert_sorted_allocList+0x17b>
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 40 04             	mov    0x4(%eax),%eax
  802332:	8b 55 08             	mov    0x8(%ebp),%edx
  802335:	89 10                	mov    %edx,(%eax)
  802337:	eb 08                	jmp    802341 <insert_sorted_allocList+0x183>
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	a3 40 40 80 00       	mov    %eax,0x804040
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 55 08             	mov    0x8(%ebp),%edx
  802347:	89 50 04             	mov    %edx,0x4(%eax)
  80234a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80234f:	40                   	inc    %eax
  802350:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802355:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802356:	eb 12                	jmp    80236a <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802364:	0f 85 71 ff ff ff    	jne    8022db <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80236a:	90                   	nop
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802373:	a1 38 41 80 00       	mov    0x804138,%eax
  802378:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80237b:	e9 76 01 00 00       	jmp    8024f6 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 40 0c             	mov    0xc(%eax),%eax
  802386:	3b 45 08             	cmp    0x8(%ebp),%eax
  802389:	0f 85 8a 00 00 00    	jne    802419 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80238f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802393:	75 17                	jne    8023ac <alloc_block_FF+0x3f>
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 e5 3c 80 00       	push   $0x803ce5
  80239d:	68 a8 00 00 00       	push   $0xa8
  8023a2:	68 73 3c 80 00       	push   $0x803c73
  8023a7:	e8 89 df ff ff       	call   800335 <_panic>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 00                	mov    (%eax),%eax
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	74 10                	je     8023c5 <alloc_block_FF+0x58>
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 00                	mov    (%eax),%eax
  8023ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bd:	8b 52 04             	mov    0x4(%edx),%edx
  8023c0:	89 50 04             	mov    %edx,0x4(%eax)
  8023c3:	eb 0b                	jmp    8023d0 <alloc_block_FF+0x63>
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 40 04             	mov    0x4(%eax),%eax
  8023cb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 04             	mov    0x4(%eax),%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	74 0f                	je     8023e9 <alloc_block_FF+0x7c>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 04             	mov    0x4(%eax),%eax
  8023e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e3:	8b 12                	mov    (%edx),%edx
  8023e5:	89 10                	mov    %edx,(%eax)
  8023e7:	eb 0a                	jmp    8023f3 <alloc_block_FF+0x86>
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	a3 38 41 80 00       	mov    %eax,0x804138
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802406:	a1 44 41 80 00       	mov    0x804144,%eax
  80240b:	48                   	dec    %eax
  80240c:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	e9 ea 00 00 00       	jmp    802503 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 40 0c             	mov    0xc(%eax),%eax
  80241f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802422:	0f 86 c6 00 00 00    	jbe    8024ee <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802428:	a1 48 41 80 00       	mov    0x804148,%eax
  80242d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	8b 55 08             	mov    0x8(%ebp),%edx
  802436:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 50 08             	mov    0x8(%eax),%edx
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 0c             	mov    0xc(%eax),%eax
  80244b:	2b 45 08             	sub    0x8(%ebp),%eax
  80244e:	89 c2                	mov    %eax,%edx
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 50 08             	mov    0x8(%eax),%edx
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	01 c2                	add    %eax,%edx
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246b:	75 17                	jne    802484 <alloc_block_FF+0x117>
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	68 e5 3c 80 00       	push   $0x803ce5
  802475:	68 b6 00 00 00       	push   $0xb6
  80247a:	68 73 3c 80 00       	push   $0x803c73
  80247f:	e8 b1 de ff ff       	call   800335 <_panic>
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 10                	je     80249d <alloc_block_FF+0x130>
  80248d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802490:	8b 00                	mov    (%eax),%eax
  802492:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802495:	8b 52 04             	mov    0x4(%edx),%edx
  802498:	89 50 04             	mov    %edx,0x4(%eax)
  80249b:	eb 0b                	jmp    8024a8 <alloc_block_FF+0x13b>
  80249d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a0:	8b 40 04             	mov    0x4(%eax),%eax
  8024a3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ab:	8b 40 04             	mov    0x4(%eax),%eax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	74 0f                	je     8024c1 <alloc_block_FF+0x154>
  8024b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024bb:	8b 12                	mov    (%edx),%edx
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	eb 0a                	jmp    8024cb <alloc_block_FF+0x15e>
  8024c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	a3 48 41 80 00       	mov    %eax,0x804148
  8024cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024de:	a1 54 41 80 00       	mov    0x804154,%eax
  8024e3:	48                   	dec    %eax
  8024e4:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	eb 15                	jmp    802503 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 00                	mov    (%eax),%eax
  8024f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8024f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fa:	0f 85 80 fe ff ff    	jne    802380 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80250b:	a1 38 41 80 00       	mov    0x804138,%eax
  802510:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802513:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80251a:	e9 c0 00 00 00       	jmp    8025df <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 40 0c             	mov    0xc(%eax),%eax
  802525:	3b 45 08             	cmp    0x8(%ebp),%eax
  802528:	0f 85 8a 00 00 00    	jne    8025b8 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80252e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802532:	75 17                	jne    80254b <alloc_block_BF+0x46>
  802534:	83 ec 04             	sub    $0x4,%esp
  802537:	68 e5 3c 80 00       	push   $0x803ce5
  80253c:	68 cf 00 00 00       	push   $0xcf
  802541:	68 73 3c 80 00       	push   $0x803c73
  802546:	e8 ea dd ff ff       	call   800335 <_panic>
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	85 c0                	test   %eax,%eax
  802552:	74 10                	je     802564 <alloc_block_BF+0x5f>
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255c:	8b 52 04             	mov    0x4(%edx),%edx
  80255f:	89 50 04             	mov    %edx,0x4(%eax)
  802562:	eb 0b                	jmp    80256f <alloc_block_BF+0x6a>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 40 04             	mov    0x4(%eax),%eax
  80256a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	74 0f                	je     802588 <alloc_block_BF+0x83>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 04             	mov    0x4(%eax),%eax
  80257f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802582:	8b 12                	mov    (%edx),%edx
  802584:	89 10                	mov    %edx,(%eax)
  802586:	eb 0a                	jmp    802592 <alloc_block_BF+0x8d>
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 00                	mov    (%eax),%eax
  80258d:	a3 38 41 80 00       	mov    %eax,0x804138
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a5:	a1 44 41 80 00       	mov    0x804144,%eax
  8025aa:	48                   	dec    %eax
  8025ab:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	e9 2a 01 00 00       	jmp    8026e2 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c1:	73 14                	jae    8025d7 <alloc_block_BF+0xd2>
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cc:	76 09                	jbe    8025d7 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d4:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 00                	mov    (%eax),%eax
  8025dc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  8025df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e3:	0f 85 36 ff ff ff    	jne    80251f <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8025e9:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8025f1:	e9 dd 00 00 00       	jmp    8026d3 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025ff:	0f 85 c6 00 00 00    	jne    8026cb <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802605:	a1 48 41 80 00       	mov    0x804148,%eax
  80260a:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 50 08             	mov    0x8(%eax),%edx
  802613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802616:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261c:	8b 55 08             	mov    0x8(%ebp),%edx
  80261f:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 50 08             	mov    0x8(%eax),%edx
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	01 c2                	add    %eax,%edx
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 40 0c             	mov    0xc(%eax),%eax
  802639:	2b 45 08             	sub    0x8(%ebp),%eax
  80263c:	89 c2                	mov    %eax,%edx
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802644:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802648:	75 17                	jne    802661 <alloc_block_BF+0x15c>
  80264a:	83 ec 04             	sub    $0x4,%esp
  80264d:	68 e5 3c 80 00       	push   $0x803ce5
  802652:	68 eb 00 00 00       	push   $0xeb
  802657:	68 73 3c 80 00       	push   $0x803c73
  80265c:	e8 d4 dc ff ff       	call   800335 <_panic>
  802661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	85 c0                	test   %eax,%eax
  802668:	74 10                	je     80267a <alloc_block_BF+0x175>
  80266a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266d:	8b 00                	mov    (%eax),%eax
  80266f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802672:	8b 52 04             	mov    0x4(%edx),%edx
  802675:	89 50 04             	mov    %edx,0x4(%eax)
  802678:	eb 0b                	jmp    802685 <alloc_block_BF+0x180>
  80267a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267d:	8b 40 04             	mov    0x4(%eax),%eax
  802680:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 0f                	je     80269e <alloc_block_BF+0x199>
  80268f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802698:	8b 12                	mov    (%edx),%edx
  80269a:	89 10                	mov    %edx,(%eax)
  80269c:	eb 0a                	jmp    8026a8 <alloc_block_BF+0x1a3>
  80269e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	a3 48 41 80 00       	mov    %eax,0x804148
  8026a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026bb:	a1 54 41 80 00       	mov    0x804154,%eax
  8026c0:	48                   	dec    %eax
  8026c1:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  8026c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c9:	eb 17                	jmp    8026e2 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	0f 85 19 ff ff ff    	jne    8025f6 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8026ea:	a1 40 40 80 00       	mov    0x804040,%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	75 19                	jne    80270c <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8026f3:	83 ec 0c             	sub    $0xc,%esp
  8026f6:	ff 75 08             	pushl  0x8(%ebp)
  8026f9:	e8 6f fc ff ff       	call   80236d <alloc_block_FF>
  8026fe:	83 c4 10             	add    $0x10,%esp
  802701:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	e9 e9 01 00 00       	jmp    8028f5 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80270c:	a1 44 40 80 00       	mov    0x804044,%eax
  802711:	8b 40 08             	mov    0x8(%eax),%eax
  802714:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802717:	a1 44 40 80 00       	mov    0x804044,%eax
  80271c:	8b 50 0c             	mov    0xc(%eax),%edx
  80271f:	a1 44 40 80 00       	mov    0x804044,%eax
  802724:	8b 40 08             	mov    0x8(%eax),%eax
  802727:	01 d0                	add    %edx,%eax
  802729:	83 ec 08             	sub    $0x8,%esp
  80272c:	50                   	push   %eax
  80272d:	68 38 41 80 00       	push   $0x804138
  802732:	e8 54 fa ff ff       	call   80218b <find_block>
  802737:	83 c4 10             	add    $0x10,%esp
  80273a:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 40 0c             	mov    0xc(%eax),%eax
  802743:	3b 45 08             	cmp    0x8(%ebp),%eax
  802746:	0f 85 9b 00 00 00    	jne    8027e7 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 50 0c             	mov    0xc(%eax),%edx
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 40 08             	mov    0x8(%eax),%eax
  802758:	01 d0                	add    %edx,%eax
  80275a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  80275d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802761:	75 17                	jne    80277a <alloc_block_NF+0x96>
  802763:	83 ec 04             	sub    $0x4,%esp
  802766:	68 e5 3c 80 00       	push   $0x803ce5
  80276b:	68 1a 01 00 00       	push   $0x11a
  802770:	68 73 3c 80 00       	push   $0x803c73
  802775:	e8 bb db ff ff       	call   800335 <_panic>
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 00                	mov    (%eax),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	74 10                	je     802793 <alloc_block_NF+0xaf>
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278b:	8b 52 04             	mov    0x4(%edx),%edx
  80278e:	89 50 04             	mov    %edx,0x4(%eax)
  802791:	eb 0b                	jmp    80279e <alloc_block_NF+0xba>
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 40 04             	mov    0x4(%eax),%eax
  802799:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 40 04             	mov    0x4(%eax),%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 0f                	je     8027b7 <alloc_block_NF+0xd3>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 40 04             	mov    0x4(%eax),%eax
  8027ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b1:	8b 12                	mov    (%edx),%edx
  8027b3:	89 10                	mov    %edx,(%eax)
  8027b5:	eb 0a                	jmp    8027c1 <alloc_block_NF+0xdd>
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 00                	mov    (%eax),%eax
  8027bc:	a3 38 41 80 00       	mov    %eax,0x804138
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d4:	a1 44 41 80 00       	mov    0x804144,%eax
  8027d9:	48                   	dec    %eax
  8027da:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	e9 0e 01 00 00       	jmp    8028f5 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f0:	0f 86 cf 00 00 00    	jbe    8028c5 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027f6:	a1 48 41 80 00       	mov    0x804148,%eax
  8027fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8027fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802801:	8b 55 08             	mov    0x8(%ebp),%edx
  802804:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 50 08             	mov    0x8(%eax),%edx
  80280d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802810:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 50 08             	mov    0x8(%eax),%edx
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	01 c2                	add    %eax,%edx
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 40 0c             	mov    0xc(%eax),%eax
  80282a:	2b 45 08             	sub    0x8(%ebp),%eax
  80282d:	89 c2                	mov    %eax,%edx
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 08             	mov    0x8(%eax),%eax
  80283b:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80283e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802842:	75 17                	jne    80285b <alloc_block_NF+0x177>
  802844:	83 ec 04             	sub    $0x4,%esp
  802847:	68 e5 3c 80 00       	push   $0x803ce5
  80284c:	68 28 01 00 00       	push   $0x128
  802851:	68 73 3c 80 00       	push   $0x803c73
  802856:	e8 da da ff ff       	call   800335 <_panic>
  80285b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	74 10                	je     802874 <alloc_block_NF+0x190>
  802864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80286c:	8b 52 04             	mov    0x4(%edx),%edx
  80286f:	89 50 04             	mov    %edx,0x4(%eax)
  802872:	eb 0b                	jmp    80287f <alloc_block_NF+0x19b>
  802874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802877:	8b 40 04             	mov    0x4(%eax),%eax
  80287a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80287f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	85 c0                	test   %eax,%eax
  802887:	74 0f                	je     802898 <alloc_block_NF+0x1b4>
  802889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288c:	8b 40 04             	mov    0x4(%eax),%eax
  80288f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802892:	8b 12                	mov    (%edx),%edx
  802894:	89 10                	mov    %edx,(%eax)
  802896:	eb 0a                	jmp    8028a2 <alloc_block_NF+0x1be>
  802898:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	a3 48 41 80 00       	mov    %eax,0x804148
  8028a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b5:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ba:	48                   	dec    %eax
  8028bb:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  8028c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c3:	eb 30                	jmp    8028f5 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8028c5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8028cd:	75 0a                	jne    8028d9 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  8028cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d7:	eb 08                	jmp    8028e1 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 40 08             	mov    0x8(%eax),%eax
  8028e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028ea:	0f 85 4d fe ff ff    	jne    80273d <alloc_block_NF+0x59>

			return NULL;
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	53                   	push   %ebx
  8028fb:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8028fe:	a1 38 41 80 00       	mov    0x804138,%eax
  802903:	85 c0                	test   %eax,%eax
  802905:	0f 85 86 00 00 00    	jne    802991 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80290b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  802912:	00 00 00 
  802915:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80291c:	00 00 00 
  80291f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802926:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802929:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292d:	75 17                	jne    802946 <insert_sorted_with_merge_freeList+0x4f>
  80292f:	83 ec 04             	sub    $0x4,%esp
  802932:	68 50 3c 80 00       	push   $0x803c50
  802937:	68 48 01 00 00       	push   $0x148
  80293c:	68 73 3c 80 00       	push   $0x803c73
  802941:	e8 ef d9 ff ff       	call   800335 <_panic>
  802946:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	89 10                	mov    %edx,(%eax)
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 0d                	je     802967 <insert_sorted_with_merge_freeList+0x70>
  80295a:	a1 38 41 80 00       	mov    0x804138,%eax
  80295f:	8b 55 08             	mov    0x8(%ebp),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 08                	jmp    80296f <insert_sorted_with_merge_freeList+0x78>
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	a3 38 41 80 00       	mov    %eax,0x804138
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802981:	a1 44 41 80 00       	mov    0x804144,%eax
  802986:	40                   	inc    %eax
  802987:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80298c:	e9 73 07 00 00       	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	8b 50 08             	mov    0x8(%eax),%edx
  802997:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80299c:	8b 40 08             	mov    0x8(%eax),%eax
  80299f:	39 c2                	cmp    %eax,%edx
  8029a1:	0f 86 84 00 00 00    	jbe    802a2b <insert_sorted_with_merge_freeList+0x134>
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	8b 50 08             	mov    0x8(%eax),%edx
  8029ad:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029b2:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029b5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ba:	8b 40 08             	mov    0x8(%eax),%eax
  8029bd:	01 c8                	add    %ecx,%eax
  8029bf:	39 c2                	cmp    %eax,%edx
  8029c1:	74 68                	je     802a2b <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8029c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c7:	75 17                	jne    8029e0 <insert_sorted_with_merge_freeList+0xe9>
  8029c9:	83 ec 04             	sub    $0x4,%esp
  8029cc:	68 8c 3c 80 00       	push   $0x803c8c
  8029d1:	68 4c 01 00 00       	push   $0x14c
  8029d6:	68 73 3c 80 00       	push   $0x803c73
  8029db:	e8 55 d9 ff ff       	call   800335 <_panic>
  8029e0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	8b 40 04             	mov    0x4(%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	74 0c                	je     802a02 <insert_sorted_with_merge_freeList+0x10b>
  8029f6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	eb 08                	jmp    802a0a <insert_sorted_with_merge_freeList+0x113>
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	a3 38 41 80 00       	mov    %eax,0x804138
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a20:	40                   	inc    %eax
  802a21:	a3 44 41 80 00       	mov    %eax,0x804144
  802a26:	e9 d9 06 00 00       	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	8b 50 08             	mov    0x8(%eax),%edx
  802a31:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a36:	8b 40 08             	mov    0x8(%eax),%eax
  802a39:	39 c2                	cmp    %eax,%edx
  802a3b:	0f 86 b5 00 00 00    	jbe    802af6 <insert_sorted_with_merge_freeList+0x1ff>
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	8b 50 08             	mov    0x8(%eax),%edx
  802a47:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a4c:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a4f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a54:	8b 40 08             	mov    0x8(%eax),%eax
  802a57:	01 c8                	add    %ecx,%eax
  802a59:	39 c2                	cmp    %eax,%edx
  802a5b:	0f 85 95 00 00 00    	jne    802af6 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802a61:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a66:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a6c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a72:	8b 52 0c             	mov    0xc(%edx),%edx
  802a75:	01 ca                	add    %ecx,%edx
  802a77:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a92:	75 17                	jne    802aab <insert_sorted_with_merge_freeList+0x1b4>
  802a94:	83 ec 04             	sub    $0x4,%esp
  802a97:	68 50 3c 80 00       	push   $0x803c50
  802a9c:	68 54 01 00 00       	push   $0x154
  802aa1:	68 73 3c 80 00       	push   $0x803c73
  802aa6:	e8 8a d8 ff ff       	call   800335 <_panic>
  802aab:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	89 10                	mov    %edx,(%eax)
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	8b 00                	mov    (%eax),%eax
  802abb:	85 c0                	test   %eax,%eax
  802abd:	74 0d                	je     802acc <insert_sorted_with_merge_freeList+0x1d5>
  802abf:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac7:	89 50 04             	mov    %edx,0x4(%eax)
  802aca:	eb 08                	jmp    802ad4 <insert_sorted_with_merge_freeList+0x1dd>
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	a3 48 41 80 00       	mov    %eax,0x804148
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae6:	a1 54 41 80 00       	mov    0x804154,%eax
  802aeb:	40                   	inc    %eax
  802aec:	a3 54 41 80 00       	mov    %eax,0x804154
  802af1:	e9 0e 06 00 00       	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	8b 50 08             	mov    0x8(%eax),%edx
  802afc:	a1 38 41 80 00       	mov    0x804138,%eax
  802b01:	8b 40 08             	mov    0x8(%eax),%eax
  802b04:	39 c2                	cmp    %eax,%edx
  802b06:	0f 83 c1 00 00 00    	jae    802bcd <insert_sorted_with_merge_freeList+0x2d6>
  802b0c:	a1 38 41 80 00       	mov    0x804138,%eax
  802b11:	8b 50 08             	mov    0x8(%eax),%edx
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	8b 48 08             	mov    0x8(%eax),%ecx
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b20:	01 c8                	add    %ecx,%eax
  802b22:	39 c2                	cmp    %eax,%edx
  802b24:	0f 85 a3 00 00 00    	jne    802bcd <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802b2a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b32:	8b 52 08             	mov    0x8(%edx),%edx
  802b35:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802b38:	a1 38 41 80 00       	mov    0x804138,%eax
  802b3d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b43:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b46:	8b 55 08             	mov    0x8(%ebp),%edx
  802b49:	8b 52 0c             	mov    0xc(%edx),%edx
  802b4c:	01 ca                	add    %ecx,%edx
  802b4e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b69:	75 17                	jne    802b82 <insert_sorted_with_merge_freeList+0x28b>
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	68 50 3c 80 00       	push   $0x803c50
  802b73:	68 5d 01 00 00       	push   $0x15d
  802b78:	68 73 3c 80 00       	push   $0x803c73
  802b7d:	e8 b3 d7 ff ff       	call   800335 <_panic>
  802b82:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	89 10                	mov    %edx,(%eax)
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	74 0d                	je     802ba3 <insert_sorted_with_merge_freeList+0x2ac>
  802b96:	a1 48 41 80 00       	mov    0x804148,%eax
  802b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ba1:	eb 08                	jmp    802bab <insert_sorted_with_merge_freeList+0x2b4>
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	a3 48 41 80 00       	mov    %eax,0x804148
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbd:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc2:	40                   	inc    %eax
  802bc3:	a3 54 41 80 00       	mov    %eax,0x804154
  802bc8:	e9 37 05 00 00       	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	8b 50 08             	mov    0x8(%eax),%edx
  802bd3:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd8:	8b 40 08             	mov    0x8(%eax),%eax
  802bdb:	39 c2                	cmp    %eax,%edx
  802bdd:	0f 83 82 00 00 00    	jae    802c65 <insert_sorted_with_merge_freeList+0x36e>
  802be3:	a1 38 41 80 00       	mov    0x804138,%eax
  802be8:	8b 50 08             	mov    0x8(%eax),%edx
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	8b 48 08             	mov    0x8(%eax),%ecx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf7:	01 c8                	add    %ecx,%eax
  802bf9:	39 c2                	cmp    %eax,%edx
  802bfb:	74 68                	je     802c65 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c01:	75 17                	jne    802c1a <insert_sorted_with_merge_freeList+0x323>
  802c03:	83 ec 04             	sub    $0x4,%esp
  802c06:	68 50 3c 80 00       	push   $0x803c50
  802c0b:	68 62 01 00 00       	push   $0x162
  802c10:	68 73 3c 80 00       	push   $0x803c73
  802c15:	e8 1b d7 ff ff       	call   800335 <_panic>
  802c1a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	89 10                	mov    %edx,(%eax)
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 0d                	je     802c3b <insert_sorted_with_merge_freeList+0x344>
  802c2e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c33:	8b 55 08             	mov    0x8(%ebp),%edx
  802c36:	89 50 04             	mov    %edx,0x4(%eax)
  802c39:	eb 08                	jmp    802c43 <insert_sorted_with_merge_freeList+0x34c>
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	a3 38 41 80 00       	mov    %eax,0x804138
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c55:	a1 44 41 80 00       	mov    0x804144,%eax
  802c5a:	40                   	inc    %eax
  802c5b:	a3 44 41 80 00       	mov    %eax,0x804144
  802c60:	e9 9f 04 00 00       	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802c65:	a1 38 41 80 00       	mov    0x804138,%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802c6f:	e9 84 04 00 00       	jmp    8030f8 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 50 08             	mov    0x8(%eax),%edx
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	8b 40 08             	mov    0x8(%eax),%eax
  802c80:	39 c2                	cmp    %eax,%edx
  802c82:	0f 86 a9 00 00 00    	jbe    802d31 <insert_sorted_with_merge_freeList+0x43a>
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 50 08             	mov    0x8(%eax),%edx
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 48 08             	mov    0x8(%eax),%ecx
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9a:	01 c8                	add    %ecx,%eax
  802c9c:	39 c2                	cmp    %eax,%edx
  802c9e:	0f 84 8d 00 00 00    	je     802d31 <insert_sorted_with_merge_freeList+0x43a>
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 50 08             	mov    0x8(%eax),%edx
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	8b 48 08             	mov    0x8(%eax),%ecx
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 40 04             	mov    0x4(%eax),%eax
  802cb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbc:	01 c8                	add    %ecx,%eax
  802cbe:	39 c2                	cmp    %eax,%edx
  802cc0:	74 6f                	je     802d31 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802cc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc6:	74 06                	je     802cce <insert_sorted_with_merge_freeList+0x3d7>
  802cc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ccc:	75 17                	jne    802ce5 <insert_sorted_with_merge_freeList+0x3ee>
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	68 b0 3c 80 00       	push   $0x803cb0
  802cd6:	68 6b 01 00 00       	push   $0x16b
  802cdb:	68 73 3c 80 00       	push   $0x803c73
  802ce0:	e8 50 d6 ff ff       	call   800335 <_panic>
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 50 04             	mov    0x4(%eax),%edx
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	89 50 04             	mov    %edx,0x4(%eax)
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf7:	89 10                	mov    %edx,(%eax)
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0d                	je     802d10 <insert_sorted_with_merge_freeList+0x419>
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0c:	89 10                	mov    %edx,(%eax)
  802d0e:	eb 08                	jmp    802d18 <insert_sorted_with_merge_freeList+0x421>
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	a3 38 41 80 00       	mov    %eax,0x804138
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1e:	89 50 04             	mov    %edx,0x4(%eax)
  802d21:	a1 44 41 80 00       	mov    0x804144,%eax
  802d26:	40                   	inc    %eax
  802d27:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802d2c:	e9 d3 03 00 00       	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 50 08             	mov    0x8(%eax),%edx
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	8b 40 08             	mov    0x8(%eax),%eax
  802d3d:	39 c2                	cmp    %eax,%edx
  802d3f:	0f 86 da 00 00 00    	jbe    802e1f <insert_sorted_with_merge_freeList+0x528>
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 50 08             	mov    0x8(%eax),%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	8b 48 08             	mov    0x8(%eax),%ecx
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8b 40 0c             	mov    0xc(%eax),%eax
  802d57:	01 c8                	add    %ecx,%eax
  802d59:	39 c2                	cmp    %eax,%edx
  802d5b:	0f 85 be 00 00 00    	jne    802e1f <insert_sorted_with_merge_freeList+0x528>
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	8b 50 08             	mov    0x8(%eax),%edx
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	8b 48 08             	mov    0x8(%eax),%ecx
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 40 04             	mov    0x4(%eax),%eax
  802d76:	8b 40 0c             	mov    0xc(%eax),%eax
  802d79:	01 c8                	add    %ecx,%eax
  802d7b:	39 c2                	cmp    %eax,%edx
  802d7d:	0f 84 9c 00 00 00    	je     802e1f <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 50 08             	mov    0x8(%eax),%edx
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 50 0c             	mov    0xc(%eax),%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	01 c2                	add    %eax,%edx
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802db7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbb:	75 17                	jne    802dd4 <insert_sorted_with_merge_freeList+0x4dd>
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	68 50 3c 80 00       	push   $0x803c50
  802dc5:	68 74 01 00 00       	push   $0x174
  802dca:	68 73 3c 80 00       	push   $0x803c73
  802dcf:	e8 61 d5 ff ff       	call   800335 <_panic>
  802dd4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	89 10                	mov    %edx,(%eax)
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	85 c0                	test   %eax,%eax
  802de6:	74 0d                	je     802df5 <insert_sorted_with_merge_freeList+0x4fe>
  802de8:	a1 48 41 80 00       	mov    0x804148,%eax
  802ded:	8b 55 08             	mov    0x8(%ebp),%edx
  802df0:	89 50 04             	mov    %edx,0x4(%eax)
  802df3:	eb 08                	jmp    802dfd <insert_sorted_with_merge_freeList+0x506>
  802df5:	8b 45 08             	mov    0x8(%ebp),%eax
  802df8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	a3 48 41 80 00       	mov    %eax,0x804148
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802e14:	40                   	inc    %eax
  802e15:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e1a:	e9 e5 02 00 00       	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 50 08             	mov    0x8(%eax),%edx
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	8b 40 08             	mov    0x8(%eax),%eax
  802e2b:	39 c2                	cmp    %eax,%edx
  802e2d:	0f 86 d7 00 00 00    	jbe    802f0a <insert_sorted_with_merge_freeList+0x613>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 50 08             	mov    0x8(%eax),%edx
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	8b 48 08             	mov    0x8(%eax),%ecx
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	8b 40 0c             	mov    0xc(%eax),%eax
  802e45:	01 c8                	add    %ecx,%eax
  802e47:	39 c2                	cmp    %eax,%edx
  802e49:	0f 84 bb 00 00 00    	je     802f0a <insert_sorted_with_merge_freeList+0x613>
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	8b 50 08             	mov    0x8(%eax),%edx
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 40 04             	mov    0x4(%eax),%eax
  802e5b:	8b 48 08             	mov    0x8(%eax),%ecx
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	8b 40 04             	mov    0x4(%eax),%eax
  802e64:	8b 40 0c             	mov    0xc(%eax),%eax
  802e67:	01 c8                	add    %ecx,%eax
  802e69:	39 c2                	cmp    %eax,%edx
  802e6b:	0f 85 99 00 00 00    	jne    802f0a <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 40 0c             	mov    0xc(%eax),%eax
  802e86:	01 c2                	add    %eax,%edx
  802e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8b:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea6:	75 17                	jne    802ebf <insert_sorted_with_merge_freeList+0x5c8>
  802ea8:	83 ec 04             	sub    $0x4,%esp
  802eab:	68 50 3c 80 00       	push   $0x803c50
  802eb0:	68 7d 01 00 00       	push   $0x17d
  802eb5:	68 73 3c 80 00       	push   $0x803c73
  802eba:	e8 76 d4 ff ff       	call   800335 <_panic>
  802ebf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	89 10                	mov    %edx,(%eax)
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 0d                	je     802ee0 <insert_sorted_with_merge_freeList+0x5e9>
  802ed3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  802edb:	89 50 04             	mov    %edx,0x4(%eax)
  802ede:	eb 08                	jmp    802ee8 <insert_sorted_with_merge_freeList+0x5f1>
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efa:	a1 54 41 80 00       	mov    0x804154,%eax
  802eff:	40                   	inc    %eax
  802f00:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f05:	e9 fa 01 00 00       	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 50 08             	mov    0x8(%eax),%edx
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	8b 40 08             	mov    0x8(%eax),%eax
  802f16:	39 c2                	cmp    %eax,%edx
  802f18:	0f 86 d2 01 00 00    	jbe    8030f0 <insert_sorted_with_merge_freeList+0x7f9>
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 50 08             	mov    0x8(%eax),%edx
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 48 08             	mov    0x8(%eax),%ecx
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f30:	01 c8                	add    %ecx,%eax
  802f32:	39 c2                	cmp    %eax,%edx
  802f34:	0f 85 b6 01 00 00    	jne    8030f0 <insert_sorted_with_merge_freeList+0x7f9>
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	8b 50 08             	mov    0x8(%eax),%edx
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 40 04             	mov    0x4(%eax),%eax
  802f46:	8b 48 08             	mov    0x8(%eax),%ecx
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f52:	01 c8                	add    %ecx,%eax
  802f54:	39 c2                	cmp    %eax,%edx
  802f56:	0f 85 94 01 00 00    	jne    8030f0 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5f:	8b 40 04             	mov    0x4(%eax),%eax
  802f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f65:	8b 52 04             	mov    0x4(%edx),%edx
  802f68:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6e:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802f71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f74:	8b 52 0c             	mov    0xc(%edx),%edx
  802f77:	01 da                	add    %ebx,%edx
  802f79:	01 ca                	add    %ecx,%edx
  802f7b:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f96:	75 17                	jne    802faf <insert_sorted_with_merge_freeList+0x6b8>
  802f98:	83 ec 04             	sub    $0x4,%esp
  802f9b:	68 e5 3c 80 00       	push   $0x803ce5
  802fa0:	68 86 01 00 00       	push   $0x186
  802fa5:	68 73 3c 80 00       	push   $0x803c73
  802faa:	e8 86 d3 ff ff       	call   800335 <_panic>
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 00                	mov    (%eax),%eax
  802fb4:	85 c0                	test   %eax,%eax
  802fb6:	74 10                	je     802fc8 <insert_sorted_with_merge_freeList+0x6d1>
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc0:	8b 52 04             	mov    0x4(%edx),%edx
  802fc3:	89 50 04             	mov    %edx,0x4(%eax)
  802fc6:	eb 0b                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x6dc>
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	8b 40 04             	mov    0x4(%eax),%eax
  802fd9:	85 c0                	test   %eax,%eax
  802fdb:	74 0f                	je     802fec <insert_sorted_with_merge_freeList+0x6f5>
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 40 04             	mov    0x4(%eax),%eax
  802fe3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe6:	8b 12                	mov    (%edx),%edx
  802fe8:	89 10                	mov    %edx,(%eax)
  802fea:	eb 0a                	jmp    802ff6 <insert_sorted_with_merge_freeList+0x6ff>
  802fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	a3 38 41 80 00       	mov    %eax,0x804138
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803009:	a1 44 41 80 00       	mov    0x804144,%eax
  80300e:	48                   	dec    %eax
  80300f:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803018:	75 17                	jne    803031 <insert_sorted_with_merge_freeList+0x73a>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 50 3c 80 00       	push   $0x803c50
  803022:	68 87 01 00 00       	push   $0x187
  803027:	68 73 3c 80 00       	push   $0x803c73
  80302c:	e8 04 d3 ff ff       	call   800335 <_panic>
  803031:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	89 10                	mov    %edx,(%eax)
  80303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303f:	8b 00                	mov    (%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	74 0d                	je     803052 <insert_sorted_with_merge_freeList+0x75b>
  803045:	a1 48 41 80 00       	mov    0x804148,%eax
  80304a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80304d:	89 50 04             	mov    %edx,0x4(%eax)
  803050:	eb 08                	jmp    80305a <insert_sorted_with_merge_freeList+0x763>
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	a3 48 41 80 00       	mov    %eax,0x804148
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306c:	a1 54 41 80 00       	mov    0x804154,%eax
  803071:	40                   	inc    %eax
  803072:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80308b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308f:	75 17                	jne    8030a8 <insert_sorted_with_merge_freeList+0x7b1>
  803091:	83 ec 04             	sub    $0x4,%esp
  803094:	68 50 3c 80 00       	push   $0x803c50
  803099:	68 8a 01 00 00       	push   $0x18a
  80309e:	68 73 3c 80 00       	push   $0x803c73
  8030a3:	e8 8d d2 ff ff       	call   800335 <_panic>
  8030a8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	89 10                	mov    %edx,(%eax)
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 0d                	je     8030c9 <insert_sorted_with_merge_freeList+0x7d2>
  8030bc:	a1 48 41 80 00       	mov    0x804148,%eax
  8030c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c4:	89 50 04             	mov    %edx,0x4(%eax)
  8030c7:	eb 08                	jmp    8030d1 <insert_sorted_with_merge_freeList+0x7da>
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e3:	a1 54 41 80 00       	mov    0x804154,%eax
  8030e8:	40                   	inc    %eax
  8030e9:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  8030ee:	eb 14                	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 00                	mov    (%eax),%eax
  8030f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8030f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fc:	0f 85 72 fb ff ff    	jne    802c74 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803102:	eb 00                	jmp    803104 <insert_sorted_with_merge_freeList+0x80d>
  803104:	90                   	nop
  803105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803108:	c9                   	leave  
  803109:	c3                   	ret    
  80310a:	66 90                	xchg   %ax,%ax

0080310c <__udivdi3>:
  80310c:	55                   	push   %ebp
  80310d:	57                   	push   %edi
  80310e:	56                   	push   %esi
  80310f:	53                   	push   %ebx
  803110:	83 ec 1c             	sub    $0x1c,%esp
  803113:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803117:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80311b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80311f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803123:	89 ca                	mov    %ecx,%edx
  803125:	89 f8                	mov    %edi,%eax
  803127:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80312b:	85 f6                	test   %esi,%esi
  80312d:	75 2d                	jne    80315c <__udivdi3+0x50>
  80312f:	39 cf                	cmp    %ecx,%edi
  803131:	77 65                	ja     803198 <__udivdi3+0x8c>
  803133:	89 fd                	mov    %edi,%ebp
  803135:	85 ff                	test   %edi,%edi
  803137:	75 0b                	jne    803144 <__udivdi3+0x38>
  803139:	b8 01 00 00 00       	mov    $0x1,%eax
  80313e:	31 d2                	xor    %edx,%edx
  803140:	f7 f7                	div    %edi
  803142:	89 c5                	mov    %eax,%ebp
  803144:	31 d2                	xor    %edx,%edx
  803146:	89 c8                	mov    %ecx,%eax
  803148:	f7 f5                	div    %ebp
  80314a:	89 c1                	mov    %eax,%ecx
  80314c:	89 d8                	mov    %ebx,%eax
  80314e:	f7 f5                	div    %ebp
  803150:	89 cf                	mov    %ecx,%edi
  803152:	89 fa                	mov    %edi,%edx
  803154:	83 c4 1c             	add    $0x1c,%esp
  803157:	5b                   	pop    %ebx
  803158:	5e                   	pop    %esi
  803159:	5f                   	pop    %edi
  80315a:	5d                   	pop    %ebp
  80315b:	c3                   	ret    
  80315c:	39 ce                	cmp    %ecx,%esi
  80315e:	77 28                	ja     803188 <__udivdi3+0x7c>
  803160:	0f bd fe             	bsr    %esi,%edi
  803163:	83 f7 1f             	xor    $0x1f,%edi
  803166:	75 40                	jne    8031a8 <__udivdi3+0x9c>
  803168:	39 ce                	cmp    %ecx,%esi
  80316a:	72 0a                	jb     803176 <__udivdi3+0x6a>
  80316c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803170:	0f 87 9e 00 00 00    	ja     803214 <__udivdi3+0x108>
  803176:	b8 01 00 00 00       	mov    $0x1,%eax
  80317b:	89 fa                	mov    %edi,%edx
  80317d:	83 c4 1c             	add    $0x1c,%esp
  803180:	5b                   	pop    %ebx
  803181:	5e                   	pop    %esi
  803182:	5f                   	pop    %edi
  803183:	5d                   	pop    %ebp
  803184:	c3                   	ret    
  803185:	8d 76 00             	lea    0x0(%esi),%esi
  803188:	31 ff                	xor    %edi,%edi
  80318a:	31 c0                	xor    %eax,%eax
  80318c:	89 fa                	mov    %edi,%edx
  80318e:	83 c4 1c             	add    $0x1c,%esp
  803191:	5b                   	pop    %ebx
  803192:	5e                   	pop    %esi
  803193:	5f                   	pop    %edi
  803194:	5d                   	pop    %ebp
  803195:	c3                   	ret    
  803196:	66 90                	xchg   %ax,%ax
  803198:	89 d8                	mov    %ebx,%eax
  80319a:	f7 f7                	div    %edi
  80319c:	31 ff                	xor    %edi,%edi
  80319e:	89 fa                	mov    %edi,%edx
  8031a0:	83 c4 1c             	add    $0x1c,%esp
  8031a3:	5b                   	pop    %ebx
  8031a4:	5e                   	pop    %esi
  8031a5:	5f                   	pop    %edi
  8031a6:	5d                   	pop    %ebp
  8031a7:	c3                   	ret    
  8031a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031ad:	89 eb                	mov    %ebp,%ebx
  8031af:	29 fb                	sub    %edi,%ebx
  8031b1:	89 f9                	mov    %edi,%ecx
  8031b3:	d3 e6                	shl    %cl,%esi
  8031b5:	89 c5                	mov    %eax,%ebp
  8031b7:	88 d9                	mov    %bl,%cl
  8031b9:	d3 ed                	shr    %cl,%ebp
  8031bb:	89 e9                	mov    %ebp,%ecx
  8031bd:	09 f1                	or     %esi,%ecx
  8031bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031c3:	89 f9                	mov    %edi,%ecx
  8031c5:	d3 e0                	shl    %cl,%eax
  8031c7:	89 c5                	mov    %eax,%ebp
  8031c9:	89 d6                	mov    %edx,%esi
  8031cb:	88 d9                	mov    %bl,%cl
  8031cd:	d3 ee                	shr    %cl,%esi
  8031cf:	89 f9                	mov    %edi,%ecx
  8031d1:	d3 e2                	shl    %cl,%edx
  8031d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d7:	88 d9                	mov    %bl,%cl
  8031d9:	d3 e8                	shr    %cl,%eax
  8031db:	09 c2                	or     %eax,%edx
  8031dd:	89 d0                	mov    %edx,%eax
  8031df:	89 f2                	mov    %esi,%edx
  8031e1:	f7 74 24 0c          	divl   0xc(%esp)
  8031e5:	89 d6                	mov    %edx,%esi
  8031e7:	89 c3                	mov    %eax,%ebx
  8031e9:	f7 e5                	mul    %ebp
  8031eb:	39 d6                	cmp    %edx,%esi
  8031ed:	72 19                	jb     803208 <__udivdi3+0xfc>
  8031ef:	74 0b                	je     8031fc <__udivdi3+0xf0>
  8031f1:	89 d8                	mov    %ebx,%eax
  8031f3:	31 ff                	xor    %edi,%edi
  8031f5:	e9 58 ff ff ff       	jmp    803152 <__udivdi3+0x46>
  8031fa:	66 90                	xchg   %ax,%ax
  8031fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803200:	89 f9                	mov    %edi,%ecx
  803202:	d3 e2                	shl    %cl,%edx
  803204:	39 c2                	cmp    %eax,%edx
  803206:	73 e9                	jae    8031f1 <__udivdi3+0xe5>
  803208:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80320b:	31 ff                	xor    %edi,%edi
  80320d:	e9 40 ff ff ff       	jmp    803152 <__udivdi3+0x46>
  803212:	66 90                	xchg   %ax,%ax
  803214:	31 c0                	xor    %eax,%eax
  803216:	e9 37 ff ff ff       	jmp    803152 <__udivdi3+0x46>
  80321b:	90                   	nop

0080321c <__umoddi3>:
  80321c:	55                   	push   %ebp
  80321d:	57                   	push   %edi
  80321e:	56                   	push   %esi
  80321f:	53                   	push   %ebx
  803220:	83 ec 1c             	sub    $0x1c,%esp
  803223:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803227:	8b 74 24 34          	mov    0x34(%esp),%esi
  80322b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80322f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803233:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803237:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80323b:	89 f3                	mov    %esi,%ebx
  80323d:	89 fa                	mov    %edi,%edx
  80323f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803243:	89 34 24             	mov    %esi,(%esp)
  803246:	85 c0                	test   %eax,%eax
  803248:	75 1a                	jne    803264 <__umoddi3+0x48>
  80324a:	39 f7                	cmp    %esi,%edi
  80324c:	0f 86 a2 00 00 00    	jbe    8032f4 <__umoddi3+0xd8>
  803252:	89 c8                	mov    %ecx,%eax
  803254:	89 f2                	mov    %esi,%edx
  803256:	f7 f7                	div    %edi
  803258:	89 d0                	mov    %edx,%eax
  80325a:	31 d2                	xor    %edx,%edx
  80325c:	83 c4 1c             	add    $0x1c,%esp
  80325f:	5b                   	pop    %ebx
  803260:	5e                   	pop    %esi
  803261:	5f                   	pop    %edi
  803262:	5d                   	pop    %ebp
  803263:	c3                   	ret    
  803264:	39 f0                	cmp    %esi,%eax
  803266:	0f 87 ac 00 00 00    	ja     803318 <__umoddi3+0xfc>
  80326c:	0f bd e8             	bsr    %eax,%ebp
  80326f:	83 f5 1f             	xor    $0x1f,%ebp
  803272:	0f 84 ac 00 00 00    	je     803324 <__umoddi3+0x108>
  803278:	bf 20 00 00 00       	mov    $0x20,%edi
  80327d:	29 ef                	sub    %ebp,%edi
  80327f:	89 fe                	mov    %edi,%esi
  803281:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803285:	89 e9                	mov    %ebp,%ecx
  803287:	d3 e0                	shl    %cl,%eax
  803289:	89 d7                	mov    %edx,%edi
  80328b:	89 f1                	mov    %esi,%ecx
  80328d:	d3 ef                	shr    %cl,%edi
  80328f:	09 c7                	or     %eax,%edi
  803291:	89 e9                	mov    %ebp,%ecx
  803293:	d3 e2                	shl    %cl,%edx
  803295:	89 14 24             	mov    %edx,(%esp)
  803298:	89 d8                	mov    %ebx,%eax
  80329a:	d3 e0                	shl    %cl,%eax
  80329c:	89 c2                	mov    %eax,%edx
  80329e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032a2:	d3 e0                	shl    %cl,%eax
  8032a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ac:	89 f1                	mov    %esi,%ecx
  8032ae:	d3 e8                	shr    %cl,%eax
  8032b0:	09 d0                	or     %edx,%eax
  8032b2:	d3 eb                	shr    %cl,%ebx
  8032b4:	89 da                	mov    %ebx,%edx
  8032b6:	f7 f7                	div    %edi
  8032b8:	89 d3                	mov    %edx,%ebx
  8032ba:	f7 24 24             	mull   (%esp)
  8032bd:	89 c6                	mov    %eax,%esi
  8032bf:	89 d1                	mov    %edx,%ecx
  8032c1:	39 d3                	cmp    %edx,%ebx
  8032c3:	0f 82 87 00 00 00    	jb     803350 <__umoddi3+0x134>
  8032c9:	0f 84 91 00 00 00    	je     803360 <__umoddi3+0x144>
  8032cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032d3:	29 f2                	sub    %esi,%edx
  8032d5:	19 cb                	sbb    %ecx,%ebx
  8032d7:	89 d8                	mov    %ebx,%eax
  8032d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032dd:	d3 e0                	shl    %cl,%eax
  8032df:	89 e9                	mov    %ebp,%ecx
  8032e1:	d3 ea                	shr    %cl,%edx
  8032e3:	09 d0                	or     %edx,%eax
  8032e5:	89 e9                	mov    %ebp,%ecx
  8032e7:	d3 eb                	shr    %cl,%ebx
  8032e9:	89 da                	mov    %ebx,%edx
  8032eb:	83 c4 1c             	add    $0x1c,%esp
  8032ee:	5b                   	pop    %ebx
  8032ef:	5e                   	pop    %esi
  8032f0:	5f                   	pop    %edi
  8032f1:	5d                   	pop    %ebp
  8032f2:	c3                   	ret    
  8032f3:	90                   	nop
  8032f4:	89 fd                	mov    %edi,%ebp
  8032f6:	85 ff                	test   %edi,%edi
  8032f8:	75 0b                	jne    803305 <__umoddi3+0xe9>
  8032fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ff:	31 d2                	xor    %edx,%edx
  803301:	f7 f7                	div    %edi
  803303:	89 c5                	mov    %eax,%ebp
  803305:	89 f0                	mov    %esi,%eax
  803307:	31 d2                	xor    %edx,%edx
  803309:	f7 f5                	div    %ebp
  80330b:	89 c8                	mov    %ecx,%eax
  80330d:	f7 f5                	div    %ebp
  80330f:	89 d0                	mov    %edx,%eax
  803311:	e9 44 ff ff ff       	jmp    80325a <__umoddi3+0x3e>
  803316:	66 90                	xchg   %ax,%ax
  803318:	89 c8                	mov    %ecx,%eax
  80331a:	89 f2                	mov    %esi,%edx
  80331c:	83 c4 1c             	add    $0x1c,%esp
  80331f:	5b                   	pop    %ebx
  803320:	5e                   	pop    %esi
  803321:	5f                   	pop    %edi
  803322:	5d                   	pop    %ebp
  803323:	c3                   	ret    
  803324:	3b 04 24             	cmp    (%esp),%eax
  803327:	72 06                	jb     80332f <__umoddi3+0x113>
  803329:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80332d:	77 0f                	ja     80333e <__umoddi3+0x122>
  80332f:	89 f2                	mov    %esi,%edx
  803331:	29 f9                	sub    %edi,%ecx
  803333:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803337:	89 14 24             	mov    %edx,(%esp)
  80333a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80333e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803342:	8b 14 24             	mov    (%esp),%edx
  803345:	83 c4 1c             	add    $0x1c,%esp
  803348:	5b                   	pop    %ebx
  803349:	5e                   	pop    %esi
  80334a:	5f                   	pop    %edi
  80334b:	5d                   	pop    %ebp
  80334c:	c3                   	ret    
  80334d:	8d 76 00             	lea    0x0(%esi),%esi
  803350:	2b 04 24             	sub    (%esp),%eax
  803353:	19 fa                	sbb    %edi,%edx
  803355:	89 d1                	mov    %edx,%ecx
  803357:	89 c6                	mov    %eax,%esi
  803359:	e9 71 ff ff ff       	jmp    8032cf <__umoddi3+0xb3>
  80335e:	66 90                	xchg   %ax,%ax
  803360:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803364:	72 ea                	jb     803350 <__umoddi3+0x134>
  803366:	89 d9                	mov    %ebx,%ecx
  803368:	e9 62 ff ff ff       	jmp    8032cf <__umoddi3+0xb3>
