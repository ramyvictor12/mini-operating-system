
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
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
  80008d:	68 e0 33 80 00       	push   $0x8033e0
  800092:	6a 13                	push   $0x13
  800094:	68 fc 33 80 00       	push   $0x8033fc
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 4e 1c 00 00       	call   801cf1 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 3a 1a 00 00       	call   801ae5 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 48 19 00 00       	call   8019f8 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 1a 34 80 00       	push   $0x80341a
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 f5 16 00 00       	call   8017b8 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 1c 34 80 00       	push   $0x80341c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 fc 33 80 00       	push   $0x8033fc
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 0a 19 00 00       	call   8019f8 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 7c 34 80 00       	push   $0x80347c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 fc 33 80 00       	push   $0x8033fc
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 ef 19 00 00       	call   801aff <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 d0 19 00 00       	call   801ae5 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 de 18 00 00       	call   8019f8 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 0d 35 80 00       	push   $0x80350d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 8b 16 00 00       	call   8017b8 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 1c 34 80 00       	push   $0x80341c
  800144:	6a 23                	push   $0x23
  800146:	68 fc 33 80 00       	push   $0x8033fc
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 a3 18 00 00       	call   8019f8 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 7c 34 80 00       	push   $0x80347c
  800166:	6a 24                	push   $0x24
  800168:	68 fc 33 80 00       	push   $0x8033fc
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 88 19 00 00       	call   801aff <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 10 35 80 00       	push   $0x803510
  800189:	6a 27                	push   $0x27
  80018b:	68 fc 33 80 00       	push   $0x8033fc
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 4b 19 00 00       	call   801ae5 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 59 18 00 00       	call   8019f8 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 47 35 80 00       	push   $0x803547
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 06 16 00 00       	call   8017b8 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 1c 34 80 00       	push   $0x80341c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 fc 33 80 00       	push   $0x8033fc
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 1e 18 00 00       	call   8019f8 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 7c 34 80 00       	push   $0x80347c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 fc 33 80 00       	push   $0x8033fc
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 03 19 00 00       	call   801aff <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 10 35 80 00       	push   $0x803510
  80020e:	6a 30                	push   $0x30
  800210:	68 fc 33 80 00       	push   $0x8033fc
  800215:	e8 76 01 00 00       	call   800390 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 10 35 80 00       	push   $0x803510
  80023d:	6a 33                	push   $0x33
  80023f:	68 fc 33 80 00       	push   $0x8033fc
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 c8 1b 00 00       	call   801e16 <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 79 1a 00 00       	call   801cd8 <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	c1 e0 03             	shl    $0x3,%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	01 c0                	add    %eax,%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 04             	shl    $0x4,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 40 80 00       	mov    0x804020,%eax
  80028b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	74 0f                	je     8002a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800295:	a1 20 40 80 00       	mov    0x804020,%eax
  80029a:	05 5c 05 00 00       	add    $0x55c,%eax
  80029f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x60>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c5:	e8 1b 18 00 00       	call   801ae5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 64 35 80 00       	push   $0x803564
  8002d2:	e8 6d 03 00 00       	call   800644 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 20 40 80 00       	mov    0x804020,%eax
  8002df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 8c 35 80 00       	push   $0x80358c
  8002fa:	e8 45 03 00 00       	call   800644 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 20 40 80 00       	mov    0x804020,%eax
  800307:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800318:	a1 20 40 80 00       	mov    0x804020,%eax
  80031d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 b4 35 80 00       	push   $0x8035b4
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 40 80 00       	mov    0x804020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 0c 36 80 00       	push   $0x80360c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 64 35 80 00       	push   $0x803564
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 9b 17 00 00       	call   801aff <sys_enable_interrupt>

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 28 19 00 00       	call   801ca4 <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 7d 19 00 00       	call   801d0a <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 20 36 80 00       	push   $0x803620
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 25 36 80 00       	push   $0x803625
  8003cf:	e8 70 02 00 00       	call   800644 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 f3 01 00 00       	call   8005d9 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 41 36 80 00       	push   $0x803641
  8003f3:	e8 e1 01 00 00       	call   8005d9 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 20 40 80 00       	mov    0x804020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 44 36 80 00       	push   $0x803644
  80041f:	6a 26                	push   $0x26
  800421:	68 90 36 80 00       	push   $0x803690
  800426:	e8 65 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c2 00 00 00       	jmp    800500 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a2 00 00 00       	jmp    8004fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 40 80 00       	mov    0x804020,%eax
  800470:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 40 80 00       	mov    0x804020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 12                	jmp    8004e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d9:	8b 50 74             	mov    0x74(%eax),%edx
  8004dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004df:	39 c2                	cmp    %eax,%edx
  8004e1:	77 88                	ja     80046b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e7:	75 14                	jne    8004fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 9c 36 80 00       	push   $0x80369c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 90 36 80 00       	push   $0x803690
  8004f8:	e8 93 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fd:	ff 45 f0             	incl   -0x10(%ebp)
  800500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800506:	0f 8c 32 ff ff ff    	jl     80043e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800513:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051a:	eb 26                	jmp    800542 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	01 c0                	add    %eax,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 c8                	add    %ecx,%eax
  800535:	8a 40 04             	mov    0x4(%eax),%al
  800538:	3c 01                	cmp    $0x1,%al
  80053a:	75 03                	jne    80053f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80053c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053f:	ff 45 e0             	incl   -0x20(%ebp)
  800542:	a1 20 40 80 00       	mov    0x804020,%eax
  800547:	8b 50 74             	mov    0x74(%eax),%edx
  80054a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	77 cb                	ja     80051c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800557:	74 14                	je     80056d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	68 f0 36 80 00       	push   $0x8036f0
  800561:	6a 44                	push   $0x44
  800563:	68 90 36 80 00       	push   $0x803690
  800568:	e8 23 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	8d 48 01             	lea    0x1(%eax),%ecx
  80057e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800581:	89 0a                	mov    %ecx,(%edx)
  800583:	8b 55 08             	mov    0x8(%ebp),%edx
  800586:	88 d1                	mov    %dl,%cl
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	3d ff 00 00 00       	cmp    $0xff,%eax
  800599:	75 2c                	jne    8005c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80059b:	a0 24 40 80 00       	mov    0x804024,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a6:	8b 12                	mov    (%edx),%edx
  8005a8:	89 d1                	mov    %edx,%ecx
  8005aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ad:	83 c2 08             	add    $0x8,%edx
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	52                   	push   %edx
  8005b6:	e8 7c 13 00 00       	call   801937 <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	8b 40 04             	mov    0x4(%eax),%eax
  8005cd:	8d 50 01             	lea    0x1(%eax),%edx
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e9:	00 00 00 
	b.cnt = 0;
  8005ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	68 70 05 80 00       	push   $0x800570
  800608:	e8 11 02 00 00       	call   80081e <vprintfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800610:	a0 24 40 80 00       	mov    0x804024,%al
  800615:	0f b6 c0             	movzbl %al,%eax
  800618:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	50                   	push   %eax
  800622:	52                   	push   %edx
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	83 c0 08             	add    $0x8,%eax
  80062c:	50                   	push   %eax
  80062d:	e8 05 13 00 00       	call   801937 <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800635:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <cprintf>:

int cprintf(const char *fmt, ...) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80064a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 73 ff ff ff       	call   8005d9 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800677:	e8 69 14 00 00       	call   801ae5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 48 ff ff ff       	call   8005d9 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800697:	e8 63 14 00 00       	call   801aff <sys_enable_interrupt>
	return cnt;
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 14             	sub    $0x14,%esp
  8006a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	77 55                	ja     800716 <printnum+0x75>
  8006c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c4:	72 05                	jb     8006cb <printnum+0x2a>
  8006c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c9:	77 4b                	ja     800716 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e1:	e8 82 2a 00 00       	call   803168 <__udivdi3>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 18             	pushl  0x18(%ebp)
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 a1 ff ff ff       	call   8006a1 <printnum>
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	eb 1a                	jmp    80071f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 20             	pushl  0x20(%ebp)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	ff 4d 1c             	decl   0x1c(%ebp)
  800719:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071d:	7f e6                	jg     800705 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800722:	bb 00 00 00 00       	mov    $0x0,%ebx
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	53                   	push   %ebx
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	e8 42 2b 00 00       	call   803278 <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 54 39 80 00       	add    $0x803954,%eax
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
}
  800752:	90                   	nop
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075f:	7e 1c                	jle    80077d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 08             	lea    0x8(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 08             	sub    $0x8,%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	eb 40                	jmp    8007bd <getuint+0x65>
	else if (lflag)
  80077d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800781:	74 1e                	je     8007a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	eb 1c                	jmp    8007bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c6:	7e 1c                	jle    8007e4 <getint+0x25>
		return va_arg(*ap, long long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 08             	lea    0x8(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 08             	sub    $0x8,%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	eb 38                	jmp    80081c <getint+0x5d>
	else if (lflag)
  8007e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e8:	74 1a                	je     800804 <getint+0x45>
		return va_arg(*ap, long);
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	8d 50 04             	lea    0x4(%eax),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	89 10                	mov    %edx,(%eax)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	eb 18                	jmp    80081c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	8d 50 04             	lea    0x4(%eax),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	89 10                	mov    %edx,(%eax)
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	99                   	cltd   
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	eb 17                	jmp    80083f <vprintfmt+0x21>
			if (ch == '\0')
  800828:	85 db                	test   %ebx,%ebx
  80082a:	0f 84 af 03 00 00    	je     800bdf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	8d 50 01             	lea    0x1(%eax),%edx
  800845:	89 55 10             	mov    %edx,0x10(%ebp)
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f b6 d8             	movzbl %al,%ebx
  80084d:	83 fb 25             	cmp    $0x25,%ebx
  800850:	75 d6                	jne    800828 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800852:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800856:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80086b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800883:	83 f8 55             	cmp    $0x55,%eax
  800886:	0f 87 2b 03 00 00    	ja     800bb7 <vprintfmt+0x399>
  80088c:	8b 04 85 78 39 80 00 	mov    0x803978(,%eax,4),%eax
  800893:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800895:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800899:	eb d7                	jmp    800872 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d1                	jmp    800872 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	c1 e0 02             	shl    $0x2,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	83 e8 30             	sub    $0x30,%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c7:	7e 3e                	jle    800907 <vprintfmt+0xe9>
  8008c9:	83 fb 39             	cmp    $0x39,%ebx
  8008cc:	7f 39                	jg     800907 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d1:	eb d5                	jmp    8008a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e7:	eb 1f                	jmp    800908 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	79 83                	jns    800872 <vprintfmt+0x54>
				width = 0;
  8008ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f6:	e9 77 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800902:	e9 6b ff ff ff       	jmp    800872 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800907:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 60 ff ff ff    	jns    800872 <vprintfmt+0x54>
				width = precision, precision = -1;
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091f:	e9 4e ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800924:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800927:	e9 46 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			break;
  80094c:	e9 89 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800962:	85 db                	test   %ebx,%ebx
  800964:	79 02                	jns    800968 <vprintfmt+0x14a>
				err = -err;
  800966:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800968:	83 fb 64             	cmp    $0x64,%ebx
  80096b:	7f 0b                	jg     800978 <vprintfmt+0x15a>
  80096d:	8b 34 9d c0 37 80 00 	mov    0x8037c0(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 65 39 80 00       	push   $0x803965
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 5e 02 00 00       	call   800be7 <printfmt>
  800989:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 49 02 00 00       	jmp    800bda <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	56                   	push   %esi
  800992:	68 6e 39 80 00       	push   $0x80396e
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 45 02 00 00       	call   800be7 <printfmt>
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 30 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 30                	mov    (%eax),%esi
  8009bb:	85 f6                	test   %esi,%esi
  8009bd:	75 05                	jne    8009c4 <vprintfmt+0x1a6>
				p = "(null)";
  8009bf:	be 71 39 80 00       	mov    $0x803971,%esi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c8:	7e 6d                	jle    800a37 <vprintfmt+0x219>
  8009ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ce:	74 67                	je     800a37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	50                   	push   %eax
  8009d7:	56                   	push   %esi
  8009d8:	e8 0c 03 00 00       	call   800ce9 <strnlen>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e3:	eb 16                	jmp    8009fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ff:	7f e4                	jg     8009e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a01:	eb 34                	jmp    800a37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a07:	74 1c                	je     800a25 <vprintfmt+0x207>
  800a09:	83 fb 1f             	cmp    $0x1f,%ebx
  800a0c:	7e 05                	jle    800a13 <vprintfmt+0x1f5>
  800a0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a11:	7e 12                	jle    800a25 <vprintfmt+0x207>
					putch('?', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 3f                	push   $0x3f
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	eb 0f                	jmp    800a34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	89 f0                	mov    %esi,%eax
  800a39:	8d 70 01             	lea    0x1(%eax),%esi
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	74 24                	je     800a69 <vprintfmt+0x24b>
  800a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a49:	78 b8                	js     800a03 <vprintfmt+0x1e5>
  800a4b:	ff 4d e0             	decl   -0x20(%ebp)
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	79 af                	jns    800a03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	eb 13                	jmp    800a69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 20                	push   $0x20
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	ff 4d e4             	decl   -0x1c(%ebp)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7f e7                	jg     800a56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6f:	e9 66 01 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 3c fd ff ff       	call   8007bf <getint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	85 d2                	test   %edx,%edx
  800a94:	79 23                	jns    800ab9 <vprintfmt+0x29b>
				putch('-', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	f7 d8                	neg    %eax
  800aae:	83 d2 00             	adc    $0x0,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac0:	e9 bc 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 e8             	pushl  -0x18(%ebp)
  800acb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	e8 84 fc ff ff       	call   800758 <getuint>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800add:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae4:	e9 98 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 58                	push   $0x58
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	6a 58                	push   $0x58
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			break;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 30                	push   $0x30
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 78                	push   $0x78
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 e8 04             	sub    $0x4,%eax
  800b4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b60:	eb 1f                	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 e7 fb ff ff       	call   800758 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	ff 75 f0             	pushl  -0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 00 fb ff ff       	call   8006a1 <printnum>
  800ba1:	83 c4 20             	add    $0x20,%esp
			break;
  800ba4:	eb 34                	jmp    800bda <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	eb 23                	jmp    800bda <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 25                	push   $0x25
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	eb 03                	jmp    800bcf <vprintfmt+0x3b1>
  800bcc:	ff 4d 10             	decl   0x10(%ebp)
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	48                   	dec    %eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	3c 25                	cmp    $0x25,%al
  800bd7:	75 f3                	jne    800bcc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd9:	90                   	nop
		}
	}
  800bda:	e9 47 fc ff ff       	jmp    800826 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bed:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf0:	83 c0 04             	add    $0x4,%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 16 fc ff ff       	call   80081e <vprintfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0b:	90                   	nop
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 40 08             	mov    0x8(%eax),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8b 40 04             	mov    0x4(%eax),%eax
  800c2b:	39 c2                	cmp    %eax,%edx
  800c2d:	73 12                	jae    800c41 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 48 01             	lea    0x1(%eax),%ecx
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 0a                	mov    %ecx,(%edx)
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	88 10                	mov    %dl,(%eax)
}
  800c41:	90                   	nop
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c69:	74 06                	je     800c71 <vsnprintf+0x2d>
  800c6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6f:	7f 07                	jg     800c78 <vsnprintf+0x34>
		return -E_INVAL;
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	eb 20                	jmp    800c98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	68 0e 0c 80 00       	push   $0x800c0e
  800c87:	e8 92 fb ff ff       	call   80081e <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 89 ff ff ff       	call   800c44 <vsnprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd3:	eb 06                	jmp    800cdb <strlen+0x15>
		n++;
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 f1                	jne    800cd5 <strlen+0xf>
		n++;
	return n;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 09                	jmp    800d01 <strnlen+0x18>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 4d 0c             	decl   0xc(%ebp)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 09                	je     800d10 <strnlen+0x27>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e8                	jne    800cf8 <strnlen+0xf>
		n++;
	return n;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d21:	90                   	nop
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 e4                	jne    800d22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 1f                	jmp    800d77 <strncpy+0x34>
		*dst++ = *src;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8a 12                	mov    (%edx),%dl
  800d66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 03                	je     800d74 <strncpy+0x31>
			src++;
  800d71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7d:	72 d9                	jb     800d58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d94:	74 30                	je     800dc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d96:	eb 16                	jmp    800dae <strlcpy+0x2a>
			*dst++ = *src++;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db5:	74 09                	je     800dc0 <strlcpy+0x3c>
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 d8                	jne    800d98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0xb>
		p++, q++;
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 0e                	je     800df4 <strcmp+0x22>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 e3                	je     800dd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0d:	eb 09                	jmp    800e18 <strncmp+0xe>
		n--, p++, q++;
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 17                	je     800e35 <strncmp+0x2b>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	74 0e                	je     800e35 <strncmp+0x2b>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 10                	mov    (%eax),%dl
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	38 c2                	cmp    %al,%dl
  800e33:	74 da                	je     800e0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	75 07                	jne    800e42 <strncmp+0x38>
		return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	eb 14                	jmp    800e56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	0f b6 c0             	movzbl %al,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e64:	eb 12                	jmp    800e78 <strchr+0x20>
		if (*s == c)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6e:	75 05                	jne    800e75 <strchr+0x1d>
			return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	eb 11                	jmp    800e86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e5                	jne    800e66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e94:	eb 0d                	jmp    800ea3 <strfind+0x1b>
		if (*s == c)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9e:	74 0e                	je     800eae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 ea                	jne    800e96 <strfind+0xe>
  800eac:	eb 01                	jmp    800eaf <strfind+0x27>
		if (*s == c)
			break;
  800eae:	90                   	nop
	return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x22>
		*p++ = c;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed6:	ff 4d f8             	decl   -0x8(%ebp)
  800ed9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800edd:	79 e9                	jns    800ec8 <memset+0x14>
		*p++ = c;

	return v;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef6:	eb 16                	jmp    800f0e <memcpy+0x2a>
		*d++ = *s++;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 dd                	jne    800ef8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f38:	73 50                	jae    800f8a <memmove+0x6a>
  800f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	76 43                	jbe    800f8a <memmove+0x6a>
		s += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f53:	eb 10                	jmp    800f65 <memmove+0x45>
			*--d = *--s;
  800f55:	ff 4d f8             	decl   -0x8(%ebp)
  800f58:	ff 4d fc             	decl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 e3                	jne    800f55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	eb 23                	jmp    800f97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fae:	eb 2a                	jmp    800fda <memcmp+0x3e>
		if (*s1 != *s2)
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 16                	je     800fd4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	eb 18                	jmp    800fec <memcmp+0x50>
		s1++, s2++;
  800fd4:	ff 45 fc             	incl   -0x4(%ebp)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	75 c9                	jne    800fb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fff:	eb 15                	jmp    801016 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	74 0d                	je     801020 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80101c:	72 e3                	jb     801001 <memfind+0x13>
  80101e:	eb 01                	jmp    801021 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801020:	90                   	nop
	return (void *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	eb 03                	jmp    80103f <strtol+0x19>
		s++;
  80103c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f4                	je     80103c <strtol+0x16>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 09                	cmp    $0x9,%al
  80104f:	74 eb                	je     80103c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2b                	cmp    $0x2b,%al
  801058:	75 05                	jne    80105f <strtol+0x39>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	eb 13                	jmp    801072 <strtol+0x4c>
	else if (*s == '-')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 2d                	cmp    $0x2d,%al
  801066:	75 0a                	jne    801072 <strtol+0x4c>
		s++, neg = 1;
  801068:	ff 45 08             	incl   0x8(%ebp)
  80106b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 06                	je     80107e <strtol+0x58>
  801078:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80107c:	75 20                	jne    80109e <strtol+0x78>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 17                	jne    80109e <strtol+0x78>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	40                   	inc    %eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 78                	cmp    $0x78,%al
  80108f:	75 0d                	jne    80109e <strtol+0x78>
		s += 2, base = 16;
  801091:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801095:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80109c:	eb 28                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 15                	jne    8010b9 <strtol+0x93>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 0c                	jne    8010b9 <strtol+0x93>
		s++, base = 8;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b7:	eb 0d                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0)
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 07                	jne    8010c6 <strtol+0xa0>
		base = 10;
  8010bf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 2f                	cmp    $0x2f,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xc2>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 39                	cmp    $0x39,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xc2>
			dig = *s - '0';
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 30             	sub    $0x30,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 42                	jmp    80112a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 60                	cmp    $0x60,%al
  8010ef:	7e 19                	jle    80110a <strtol+0xe4>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 7a                	cmp    $0x7a,%al
  8010f8:	7f 10                	jg     80110a <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 57             	sub    $0x57,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801108:	eb 20                	jmp    80112a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 40                	cmp    $0x40,%al
  801111:	7e 39                	jle    80114c <strtol+0x126>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 5a                	cmp    $0x5a,%al
  80111a:	7f 30                	jg     80114c <strtol+0x126>
			dig = *s - 'A' + 10;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	83 e8 37             	sub    $0x37,%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801130:	7d 19                	jge    80114b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	0f af 45 10          	imul   0x10(%ebp),%eax
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801146:	e9 7b ff ff ff       	jmp    8010c6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80114b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 08                	je     80115a <strtol+0x134>
		*endptr = (char *) s;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 07                	je     801167 <strtol+0x141>
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	f7 d8                	neg    %eax
  801165:	eb 03                	jmp    80116a <strtol+0x144>
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <ltostr>:

void
ltostr(long value, char *str)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	79 13                	jns    801199 <ltostr+0x2d>
	{
		neg = 1;
  801186:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801193:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801196:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a1:	99                   	cltd   
  8011a2:	f7 f9                	idiv   %ecx
  8011a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8d 50 01             	lea    0x1(%eax),%edx
  8011ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	83 c2 30             	add    $0x30,%edx
  8011bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c7:	f7 e9                	imul   %ecx
  8011c9:	c1 fa 02             	sar    $0x2,%edx
  8011cc:	89 c8                	mov    %ecx,%eax
  8011ce:	c1 f8 1f             	sar    $0x1f,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e0:	f7 e9                	imul   %ecx
  8011e2:	c1 fa 02             	sar    $0x2,%edx
  8011e5:	89 c8                	mov    %ecx,%eax
  8011e7:	c1 f8 1f             	sar    $0x1f,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	29 c1                	sub    %eax,%ecx
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	75 9c                	jne    801199 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	48                   	dec    %eax
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120f:	74 3d                	je     80124e <ltostr+0xe2>
		start = 1 ;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801218:	eb 34                	jmp    80124e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8a 45 eb             	mov    -0x15(%ebp),%al
  801246:	88 02                	mov    %al,(%edx)
		start++ ;
  801248:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801254:	7c c4                	jl     80121a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801256:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 54 fa ff ff       	call   800cc6 <strlen>
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 46 fa ff ff       	call   800cc6 <strlen>
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801294:	eb 17                	jmp    8012ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 c2                	add    %eax,%edx
  80129e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b3:	7c e1                	jl     801296 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c3:	eb 1f                	jmp    8012e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	7c d9                	jl     8012c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801306:	8b 45 14             	mov    0x14(%ebp),%eax
  801309:	8b 00                	mov    (%eax),%eax
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131d:	eb 0c                	jmp    80132b <strsplit+0x31>
			*string++ = 0;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 08             	mov    %edx,0x8(%ebp)
  801328:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	74 18                	je     80134c <strsplit+0x52>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	e8 13 fb ff ff       	call   800e58 <strchr>
  801345:	83 c4 08             	add    $0x8,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 d3                	jne    80131f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 5a                	je     8013af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	83 f8 0f             	cmp    $0xf,%eax
  80135d:	75 07                	jne    801366 <strsplit+0x6c>
		{
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	eb 66                	jmp    8013cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	8d 48 01             	lea    0x1(%eax),%ecx
  80136e:	8b 55 14             	mov    0x14(%ebp),%edx
  801371:	89 0a                	mov    %ecx,(%edx)
  801373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 c2                	add    %eax,%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	eb 03                	jmp    801389 <strsplit+0x8f>
			string++;
  801386:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 8b                	je     80131d <strsplit+0x23>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f be c0             	movsbl %al,%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 b5 fa ff ff       	call   800e58 <strchr>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 dc                	je     801386 <strsplit+0x8c>
			string++;
	}
  8013aa:	e9 6e ff ff ff       	jmp    80131d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 1f                	je     8013fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013dd:	e8 1d 00 00 00       	call   8013ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	68 d0 3a 80 00       	push   $0x803ad0
  8013ea:	e8 55 f2 ff ff       	call   800644 <cprintf>
  8013ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013f9:	00 00 00 
	}
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801405:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80140c:	00 00 00 
  80140f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801416:	00 00 00 
  801419:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801420:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801423:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80142a:	00 00 00 
  80142d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801434:	00 00 00 
  801437:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80143e:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801441:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801448:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  80144b:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801452:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801461:	2d 00 10 00 00       	sub    $0x1000,%eax
  801466:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  80146b:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801475:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	6a 06                	push   $0x6
  801484:	ff 75 f4             	pushl  -0xc(%ebp)
  801487:	50                   	push   %eax
  801488:	e8 ee 05 00 00       	call   801a7b <sys_allocate_chunk>
  80148d:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801490:	a1 20 41 80 00       	mov    0x804120,%eax
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	50                   	push   %eax
  801499:	e8 63 0c 00 00       	call   802101 <initialize_MemBlocksList>
  80149e:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8014a1:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8014a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ac:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8014b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8014b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c4:	89 c2                	mov    %eax,%edx
  8014c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014c9:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8014cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014cf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8014d6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014e0:	8b 50 08             	mov    0x8(%eax),%edx
  8014e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e6:	01 d0                	add    %edx,%eax
  8014e8:	48                   	dec    %eax
  8014e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f4:	f7 75 e0             	divl   -0x20(%ebp)
  8014f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014fa:	29 d0                	sub    %edx,%eax
  8014fc:	89 c2                	mov    %eax,%edx
  8014fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801501:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801504:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801508:	75 14                	jne    80151e <initialize_dyn_block_system+0x11f>
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	68 f5 3a 80 00       	push   $0x803af5
  801512:	6a 34                	push   $0x34
  801514:	68 13 3b 80 00       	push   $0x803b13
  801519:	e8 72 ee ff ff       	call   800390 <_panic>
  80151e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801521:	8b 00                	mov    (%eax),%eax
  801523:	85 c0                	test   %eax,%eax
  801525:	74 10                	je     801537 <initialize_dyn_block_system+0x138>
  801527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80152a:	8b 00                	mov    (%eax),%eax
  80152c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80152f:	8b 52 04             	mov    0x4(%edx),%edx
  801532:	89 50 04             	mov    %edx,0x4(%eax)
  801535:	eb 0b                	jmp    801542 <initialize_dyn_block_system+0x143>
  801537:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80153a:	8b 40 04             	mov    0x4(%eax),%eax
  80153d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801545:	8b 40 04             	mov    0x4(%eax),%eax
  801548:	85 c0                	test   %eax,%eax
  80154a:	74 0f                	je     80155b <initialize_dyn_block_system+0x15c>
  80154c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80154f:	8b 40 04             	mov    0x4(%eax),%eax
  801552:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801555:	8b 12                	mov    (%edx),%edx
  801557:	89 10                	mov    %edx,(%eax)
  801559:	eb 0a                	jmp    801565 <initialize_dyn_block_system+0x166>
  80155b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80155e:	8b 00                	mov    (%eax),%eax
  801560:	a3 48 41 80 00       	mov    %eax,0x804148
  801565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80156e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801571:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801578:	a1 54 41 80 00       	mov    0x804154,%eax
  80157d:	48                   	dec    %eax
  80157e:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	ff 75 e8             	pushl  -0x18(%ebp)
  801589:	e8 c4 13 00 00       	call   802952 <insert_sorted_with_merge_freeList>
  80158e:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801591:	90                   	nop
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159a:	e8 2f fe ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80159f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015a3:	75 07                	jne    8015ac <malloc+0x18>
  8015a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015aa:	eb 71                	jmp    80161d <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8015ac:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015b3:	76 07                	jbe    8015bc <malloc+0x28>
	return NULL;
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ba:	eb 61                	jmp    80161d <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015bc:	e8 88 08 00 00       	call   801e49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	74 53                	je     801618 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8015c5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d2:	01 d0                	add    %edx,%eax
  8015d4:	48                   	dec    %eax
  8015d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e0:	f7 75 f4             	divl   -0xc(%ebp)
  8015e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e6:	29 d0                	sub    %edx,%eax
  8015e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8015eb:	83 ec 0c             	sub    $0xc,%esp
  8015ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8015f1:	e8 d2 0d 00 00       	call   8023c8 <alloc_block_FF>
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8015fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801600:	74 16                	je     801618 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801602:	83 ec 0c             	sub    $0xc,%esp
  801605:	ff 75 e8             	pushl  -0x18(%ebp)
  801608:	e8 0c 0c 00 00       	call   802219 <insert_sorted_allocList>
  80160d:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801613:	8b 40 08             	mov    0x8(%eax),%eax
  801616:	eb 05                	jmp    80161d <malloc+0x89>
    }

			}


	return NULL;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80162b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801633:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	ff 75 f0             	pushl  -0x10(%ebp)
  80163c:	68 40 40 80 00       	push   $0x804040
  801641:	e8 a0 0b 00 00       	call   8021e6 <find_block>
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  80164c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164f:	8b 50 0c             	mov    0xc(%eax),%edx
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	52                   	push   %edx
  801659:	50                   	push   %eax
  80165a:	e8 e4 03 00 00       	call   801a43 <sys_free_user_mem>
  80165f:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801662:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801666:	75 17                	jne    80167f <free+0x60>
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	68 f5 3a 80 00       	push   $0x803af5
  801670:	68 84 00 00 00       	push   $0x84
  801675:	68 13 3b 80 00       	push   $0x803b13
  80167a:	e8 11 ed ff ff       	call   800390 <_panic>
  80167f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	85 c0                	test   %eax,%eax
  801686:	74 10                	je     801698 <free+0x79>
  801688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801690:	8b 52 04             	mov    0x4(%edx),%edx
  801693:	89 50 04             	mov    %edx,0x4(%eax)
  801696:	eb 0b                	jmp    8016a3 <free+0x84>
  801698:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169b:	8b 40 04             	mov    0x4(%eax),%eax
  80169e:	a3 44 40 80 00       	mov    %eax,0x804044
  8016a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a6:	8b 40 04             	mov    0x4(%eax),%eax
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	74 0f                	je     8016bc <free+0x9d>
  8016ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b0:	8b 40 04             	mov    0x4(%eax),%eax
  8016b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016b6:	8b 12                	mov    (%edx),%edx
  8016b8:	89 10                	mov    %edx,(%eax)
  8016ba:	eb 0a                	jmp    8016c6 <free+0xa7>
  8016bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bf:	8b 00                	mov    (%eax),%eax
  8016c1:	a3 40 40 80 00       	mov    %eax,0x804040
  8016c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016d9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016de:	48                   	dec    %eax
  8016df:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8016e4:	83 ec 0c             	sub    $0xc,%esp
  8016e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8016ea:	e8 63 12 00 00       	call   802952 <insert_sorted_with_merge_freeList>
  8016ef:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8016f2:	90                   	nop
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 38             	sub    $0x38,%esp
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801701:	e8 c8 fc ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  801706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80170a:	75 0a                	jne    801716 <smalloc+0x21>
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
  801711:	e9 a0 00 00 00       	jmp    8017b6 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801716:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80171d:	76 0a                	jbe    801729 <smalloc+0x34>
		return NULL;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
  801724:	e9 8d 00 00 00       	jmp    8017b6 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801729:	e8 1b 07 00 00       	call   801e49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80172e:	85 c0                	test   %eax,%eax
  801730:	74 7f                	je     8017b1 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801732:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173f:	01 d0                	add    %edx,%eax
  801741:	48                   	dec    %eax
  801742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801748:	ba 00 00 00 00       	mov    $0x0,%edx
  80174d:	f7 75 f4             	divl   -0xc(%ebp)
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	29 d0                	sub    %edx,%eax
  801755:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	ff 75 ec             	pushl  -0x14(%ebp)
  80175e:	e8 65 0c 00 00       	call   8023c8 <alloc_block_FF>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801769:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80176d:	74 42                	je     8017b1 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	ff 75 e8             	pushl  -0x18(%ebp)
  801775:	e8 9f 0a 00 00       	call   802219 <insert_sorted_allocList>
  80177a:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80177d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801780:	8b 40 08             	mov    0x8(%eax),%eax
  801783:	89 c2                	mov    %eax,%edx
  801785:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801789:	52                   	push   %edx
  80178a:	50                   	push   %eax
  80178b:	ff 75 0c             	pushl  0xc(%ebp)
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	e8 38 04 00 00       	call   801bce <sys_createSharedObject>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  80179c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017a0:	79 07                	jns    8017a9 <smalloc+0xb4>
	    		  return NULL;
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a7:	eb 0d                	jmp    8017b6 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8017a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ac:	8b 40 08             	mov    0x8(%eax),%eax
  8017af:	eb 05                	jmp    8017b6 <smalloc+0xc1>


				}


		return NULL;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017be:	e8 0b fc ff ff       	call   8013ce <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017c3:	e8 81 06 00 00       	call   801e49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	0f 84 9f 00 00 00    	je     80186f <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 1a 04 00 00       	call   801bf8 <sys_getSizeOfSharedObject>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8017e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e8:	79 0a                	jns    8017f4 <sget+0x3c>
		return NULL;
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ef:	e9 80 00 00 00       	jmp    801874 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8017f4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801801:	01 d0                	add    %edx,%eax
  801803:	48                   	dec    %eax
  801804:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180a:	ba 00 00 00 00       	mov    $0x0,%edx
  80180f:	f7 75 f0             	divl   -0x10(%ebp)
  801812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801815:	29 d0                	sub    %edx,%eax
  801817:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	ff 75 e8             	pushl  -0x18(%ebp)
  801820:	e8 a3 0b 00 00       	call   8023c8 <alloc_block_FF>
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80182b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80182f:	74 3e                	je     80186f <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801831:	83 ec 0c             	sub    $0xc,%esp
  801834:	ff 75 e4             	pushl  -0x1c(%ebp)
  801837:	e8 dd 09 00 00       	call   802219 <insert_sorted_allocList>
  80183c:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80183f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801842:	8b 40 08             	mov    0x8(%eax),%eax
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	50                   	push   %eax
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	ff 75 08             	pushl  0x8(%ebp)
  80184f:	e8 c1 03 00 00       	call   801c15 <sys_getSharedObject>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  80185a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80185e:	79 07                	jns    801867 <sget+0xaf>
	    		  return NULL;
  801860:	b8 00 00 00 00       	mov    $0x0,%eax
  801865:	eb 0d                	jmp    801874 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80186a:	8b 40 08             	mov    0x8(%eax),%eax
  80186d:	eb 05                	jmp    801874 <sget+0xbc>
	      }
	}
	   return NULL;
  80186f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80187c:	e8 4d fb ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	68 20 3b 80 00       	push   $0x803b20
  801889:	68 12 01 00 00       	push   $0x112
  80188e:	68 13 3b 80 00       	push   $0x803b13
  801893:	e8 f8 ea ff ff       	call   800390 <_panic>

00801898 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	68 48 3b 80 00       	push   $0x803b48
  8018a6:	68 26 01 00 00       	push   $0x126
  8018ab:	68 13 3b 80 00       	push   $0x803b13
  8018b0:	e8 db ea ff ff       	call   800390 <_panic>

008018b5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bb:	83 ec 04             	sub    $0x4,%esp
  8018be:	68 6c 3b 80 00       	push   $0x803b6c
  8018c3:	68 31 01 00 00       	push   $0x131
  8018c8:	68 13 3b 80 00       	push   $0x803b13
  8018cd:	e8 be ea ff ff       	call   800390 <_panic>

008018d2 <shrink>:

}
void shrink(uint32 newSize)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	68 6c 3b 80 00       	push   $0x803b6c
  8018e0:	68 36 01 00 00       	push   $0x136
  8018e5:	68 13 3b 80 00       	push   $0x803b13
  8018ea:	e8 a1 ea ff ff       	call   800390 <_panic>

008018ef <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f5:	83 ec 04             	sub    $0x4,%esp
  8018f8:	68 6c 3b 80 00       	push   $0x803b6c
  8018fd:	68 3b 01 00 00       	push   $0x13b
  801902:	68 13 3b 80 00       	push   $0x803b13
  801907:	e8 84 ea ff ff       	call   800390 <_panic>

0080190c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	57                   	push   %edi
  801910:	56                   	push   %esi
  801911:	53                   	push   %ebx
  801912:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801921:	8b 7d 18             	mov    0x18(%ebp),%edi
  801924:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801927:	cd 30                	int    $0x30
  801929:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5f                   	pop    %edi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	8b 45 10             	mov    0x10(%ebp),%eax
  801940:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801943:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	52                   	push   %edx
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	50                   	push   %eax
  801953:	6a 00                	push   $0x0
  801955:	e8 b2 ff ff ff       	call   80190c <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_cgetc>:

int
sys_cgetc(void)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 01                	push   $0x1
  80196f:	e8 98 ff ff ff       	call   80190c <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80197c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	52                   	push   %edx
  801989:	50                   	push   %eax
  80198a:	6a 05                	push   $0x5
  80198c:	e8 7b ff ff ff       	call   80190c <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80199b:	8b 75 18             	mov    0x18(%ebp),%esi
  80199e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	56                   	push   %esi
  8019ab:	53                   	push   %ebx
  8019ac:	51                   	push   %ecx
  8019ad:	52                   	push   %edx
  8019ae:	50                   	push   %eax
  8019af:	6a 06                	push   $0x6
  8019b1:	e8 56 ff ff ff       	call   80190c <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bc:	5b                   	pop    %ebx
  8019bd:	5e                   	pop    %esi
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    

008019c0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	52                   	push   %edx
  8019d0:	50                   	push   %eax
  8019d1:	6a 07                	push   $0x7
  8019d3:	e8 34 ff ff ff       	call   80190c <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	6a 08                	push   $0x8
  8019ee:	e8 19 ff ff ff       	call   80190c <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 09                	push   $0x9
  801a07:	e8 00 ff ff ff       	call   80190c <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 0a                	push   $0xa
  801a20:	e8 e7 fe ff ff       	call   80190c <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 0b                	push   $0xb
  801a39:	e8 ce fe ff ff       	call   80190c <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	ff 75 08             	pushl  0x8(%ebp)
  801a52:	6a 0f                	push   $0xf
  801a54:	e8 b3 fe ff ff       	call   80190c <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
	return;
  801a5c:	90                   	nop
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	6a 10                	push   $0x10
  801a70:	e8 97 fe ff ff       	call   80190c <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
	return ;
  801a78:	90                   	nop
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	ff 75 10             	pushl  0x10(%ebp)
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	6a 11                	push   $0x11
  801a8d:	e8 7a fe ff ff       	call   80190c <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
	return ;
  801a95:	90                   	nop
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 0c                	push   $0xc
  801aa7:	e8 60 fe ff ff       	call   80190c <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	ff 75 08             	pushl  0x8(%ebp)
  801abf:	6a 0d                	push   $0xd
  801ac1:	e8 46 fe ff ff       	call   80190c <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 0e                	push   $0xe
  801ada:	e8 2d fe ff ff       	call   80190c <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	90                   	nop
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 13                	push   $0x13
  801af4:	e8 13 fe ff ff       	call   80190c <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	90                   	nop
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 14                	push   $0x14
  801b0e:	e8 f9 fd ff ff       	call   80190c <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	90                   	nop
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 04             	sub    $0x4,%esp
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b25:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	50                   	push   %eax
  801b32:	6a 15                	push   $0x15
  801b34:	e8 d3 fd ff ff       	call   80190c <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	90                   	nop
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 16                	push   $0x16
  801b4e:	e8 b9 fd ff ff       	call   80190c <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	90                   	nop
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	50                   	push   %eax
  801b69:	6a 17                	push   $0x17
  801b6b:	e8 9c fd ff ff       	call   80190c <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	52                   	push   %edx
  801b85:	50                   	push   %eax
  801b86:	6a 1a                	push   $0x1a
  801b88:	e8 7f fd ff ff       	call   80190c <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 18                	push   $0x18
  801ba5:	e8 62 fd ff ff       	call   80190c <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	90                   	nop
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	6a 19                	push   $0x19
  801bc3:	e8 44 fd ff ff       	call   80190c <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	90                   	nop
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bda:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bdd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	51                   	push   %ecx
  801be7:	52                   	push   %edx
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	50                   	push   %eax
  801bec:	6a 1b                	push   $0x1b
  801bee:	e8 19 fd ff ff       	call   80190c <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	52                   	push   %edx
  801c08:	50                   	push   %eax
  801c09:	6a 1c                	push   $0x1c
  801c0b:	e8 fc fc ff ff       	call   80190c <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	51                   	push   %ecx
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	6a 1d                	push   $0x1d
  801c2a:	e8 dd fc ff ff       	call   80190c <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	52                   	push   %edx
  801c44:	50                   	push   %eax
  801c45:	6a 1e                	push   $0x1e
  801c47:	e8 c0 fc ff ff       	call   80190c <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 1f                	push   $0x1f
  801c60:	e8 a7 fc ff ff       	call   80190c <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	ff 75 14             	pushl  0x14(%ebp)
  801c75:	ff 75 10             	pushl  0x10(%ebp)
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	50                   	push   %eax
  801c7c:	6a 20                	push   $0x20
  801c7e:	e8 89 fc ff ff       	call   80190c <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	50                   	push   %eax
  801c97:	6a 21                	push   $0x21
  801c99:	e8 6e fc ff ff       	call   80190c <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	90                   	nop
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	50                   	push   %eax
  801cb3:	6a 22                	push   $0x22
  801cb5:	e8 52 fc ff ff       	call   80190c <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 02                	push   $0x2
  801cce:	e8 39 fc ff ff       	call   80190c <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 03                	push   $0x3
  801ce7:	e8 20 fc ff ff       	call   80190c <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 04                	push   $0x4
  801d00:	e8 07 fc ff ff       	call   80190c <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_exit_env>:


void sys_exit_env(void)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 23                	push   $0x23
  801d19:	e8 ee fb ff ff       	call   80190c <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	90                   	nop
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d2d:	8d 50 04             	lea    0x4(%eax),%edx
  801d30:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	52                   	push   %edx
  801d3a:	50                   	push   %eax
  801d3b:	6a 24                	push   $0x24
  801d3d:	e8 ca fb ff ff       	call   80190c <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
	return result;
  801d45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d4e:	89 01                	mov    %eax,(%ecx)
  801d50:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	c9                   	leave  
  801d57:	c2 04 00             	ret    $0x4

00801d5a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	ff 75 10             	pushl  0x10(%ebp)
  801d64:	ff 75 0c             	pushl  0xc(%ebp)
  801d67:	ff 75 08             	pushl  0x8(%ebp)
  801d6a:	6a 12                	push   $0x12
  801d6c:	e8 9b fb ff ff       	call   80190c <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
	return ;
  801d74:	90                   	nop
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 25                	push   $0x25
  801d86:	e8 81 fb ff ff       	call   80190c <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 04             	sub    $0x4,%esp
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d9c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	50                   	push   %eax
  801da9:	6a 26                	push   $0x26
  801dab:	e8 5c fb ff ff       	call   80190c <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
	return ;
  801db3:	90                   	nop
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <rsttst>:
void rsttst()
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 28                	push   $0x28
  801dc5:	e8 42 fb ff ff       	call   80190c <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcd:	90                   	nop
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 04             	sub    $0x4,%esp
  801dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ddc:	8b 55 18             	mov    0x18(%ebp),%edx
  801ddf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	ff 75 10             	pushl  0x10(%ebp)
  801de8:	ff 75 0c             	pushl  0xc(%ebp)
  801deb:	ff 75 08             	pushl  0x8(%ebp)
  801dee:	6a 27                	push   $0x27
  801df0:	e8 17 fb ff ff       	call   80190c <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
	return ;
  801df8:	90                   	nop
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <chktst>:
void chktst(uint32 n)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	6a 29                	push   $0x29
  801e0b:	e8 fc fa ff ff       	call   80190c <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
	return ;
  801e13:	90                   	nop
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <inctst>:

void inctst()
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 2a                	push   $0x2a
  801e25:	e8 e2 fa ff ff       	call   80190c <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2d:	90                   	nop
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <gettst>:
uint32 gettst()
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 2b                	push   $0x2b
  801e3f:	e8 c8 fa ff ff       	call   80190c <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 2c                	push   $0x2c
  801e5b:	e8 ac fa ff ff       	call   80190c <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
  801e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e66:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e6a:	75 07                	jne    801e73 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e71:	eb 05                	jmp    801e78 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 2c                	push   $0x2c
  801e8c:	e8 7b fa ff ff       	call   80190c <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
  801e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e97:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e9b:	75 07                	jne    801ea4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea2:	eb 05                	jmp    801ea9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 2c                	push   $0x2c
  801ebd:	e8 4a fa ff ff       	call   80190c <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
  801ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ec8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ecc:	75 07                	jne    801ed5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ece:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed3:	eb 05                	jmp    801eda <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 2c                	push   $0x2c
  801eee:	e8 19 fa ff ff       	call   80190c <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
  801ef6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ef9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801efd:	75 07                	jne    801f06 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eff:	b8 01 00 00 00       	mov    $0x1,%eax
  801f04:	eb 05                	jmp    801f0b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	ff 75 08             	pushl  0x8(%ebp)
  801f1b:	6a 2d                	push   $0x2d
  801f1d:	e8 ea f9 ff ff       	call   80190c <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
	return ;
  801f25:	90                   	nop
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	6a 00                	push   $0x0
  801f3a:	53                   	push   %ebx
  801f3b:	51                   	push   %ecx
  801f3c:	52                   	push   %edx
  801f3d:	50                   	push   %eax
  801f3e:	6a 2e                	push   $0x2e
  801f40:	e8 c7 f9 ff ff       	call   80190c <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	52                   	push   %edx
  801f5d:	50                   	push   %eax
  801f5e:	6a 2f                	push   $0x2f
  801f60:	e8 a7 f9 ff ff       	call   80190c <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	68 7c 3b 80 00       	push   $0x803b7c
  801f78:	e8 c7 e6 ff ff       	call   800644 <cprintf>
  801f7d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	68 a8 3b 80 00       	push   $0x803ba8
  801f8f:	e8 b0 e6 ff ff       	call   800644 <cprintf>
  801f94:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f97:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f9b:	a1 38 41 80 00       	mov    0x804138,%eax
  801fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa3:	eb 56                	jmp    801ffb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fa5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa9:	74 1c                	je     801fc7 <print_mem_block_lists+0x5d>
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 50 08             	mov    0x8(%eax),%edx
  801fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb4:	8b 48 08             	mov    0x8(%eax),%ecx
  801fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fba:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbd:	01 c8                	add    %ecx,%eax
  801fbf:	39 c2                	cmp    %eax,%edx
  801fc1:	73 04                	jae    801fc7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fc3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 50 08             	mov    0x8(%eax),%edx
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd3:	01 c2                	add    %eax,%edx
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	8b 40 08             	mov    0x8(%eax),%eax
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	52                   	push   %edx
  801fdf:	50                   	push   %eax
  801fe0:	68 bd 3b 80 00       	push   $0x803bbd
  801fe5:	e8 5a e6 ff ff       	call   800644 <cprintf>
  801fea:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ff3:	a1 40 41 80 00       	mov    0x804140,%eax
  801ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fff:	74 07                	je     802008 <print_mem_block_lists+0x9e>
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	8b 00                	mov    (%eax),%eax
  802006:	eb 05                	jmp    80200d <print_mem_block_lists+0xa3>
  802008:	b8 00 00 00 00       	mov    $0x0,%eax
  80200d:	a3 40 41 80 00       	mov    %eax,0x804140
  802012:	a1 40 41 80 00       	mov    0x804140,%eax
  802017:	85 c0                	test   %eax,%eax
  802019:	75 8a                	jne    801fa5 <print_mem_block_lists+0x3b>
  80201b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201f:	75 84                	jne    801fa5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802021:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802025:	75 10                	jne    802037 <print_mem_block_lists+0xcd>
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	68 cc 3b 80 00       	push   $0x803bcc
  80202f:	e8 10 e6 ff ff       	call   800644 <cprintf>
  802034:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802037:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	68 f0 3b 80 00       	push   $0x803bf0
  802046:	e8 f9 e5 ff ff       	call   800644 <cprintf>
  80204b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80204e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802052:	a1 40 40 80 00       	mov    0x804040,%eax
  802057:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205a:	eb 56                	jmp    8020b2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80205c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802060:	74 1c                	je     80207e <print_mem_block_lists+0x114>
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	8b 50 08             	mov    0x8(%eax),%edx
  802068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206b:	8b 48 08             	mov    0x8(%eax),%ecx
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	8b 40 0c             	mov    0xc(%eax),%eax
  802074:	01 c8                	add    %ecx,%eax
  802076:	39 c2                	cmp    %eax,%edx
  802078:	73 04                	jae    80207e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80207a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	8b 50 08             	mov    0x8(%eax),%edx
  802084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802087:	8b 40 0c             	mov    0xc(%eax),%eax
  80208a:	01 c2                	add    %eax,%edx
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	8b 40 08             	mov    0x8(%eax),%eax
  802092:	83 ec 04             	sub    $0x4,%esp
  802095:	52                   	push   %edx
  802096:	50                   	push   %eax
  802097:	68 bd 3b 80 00       	push   $0x803bbd
  80209c:	e8 a3 e5 ff ff       	call   800644 <cprintf>
  8020a1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020aa:	a1 48 40 80 00       	mov    0x804048,%eax
  8020af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b6:	74 07                	je     8020bf <print_mem_block_lists+0x155>
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	8b 00                	mov    (%eax),%eax
  8020bd:	eb 05                	jmp    8020c4 <print_mem_block_lists+0x15a>
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	a3 48 40 80 00       	mov    %eax,0x804048
  8020c9:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	75 8a                	jne    80205c <print_mem_block_lists+0xf2>
  8020d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d6:	75 84                	jne    80205c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020d8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020dc:	75 10                	jne    8020ee <print_mem_block_lists+0x184>
  8020de:	83 ec 0c             	sub    $0xc,%esp
  8020e1:	68 08 3c 80 00       	push   $0x803c08
  8020e6:	e8 59 e5 ff ff       	call   800644 <cprintf>
  8020eb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	68 7c 3b 80 00       	push   $0x803b7c
  8020f6:	e8 49 e5 ff ff       	call   800644 <cprintf>
  8020fb:	83 c4 10             	add    $0x10,%esp

}
  8020fe:	90                   	nop
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802107:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80210e:	00 00 00 
  802111:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802118:	00 00 00 
  80211b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802122:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802125:	a1 50 40 80 00       	mov    0x804050,%eax
  80212a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80212d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802134:	e9 9e 00 00 00       	jmp    8021d7 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802139:	a1 50 40 80 00       	mov    0x804050,%eax
  80213e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802141:	c1 e2 04             	shl    $0x4,%edx
  802144:	01 d0                	add    %edx,%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	75 14                	jne    80215e <initialize_MemBlocksList+0x5d>
  80214a:	83 ec 04             	sub    $0x4,%esp
  80214d:	68 30 3c 80 00       	push   $0x803c30
  802152:	6a 48                	push   $0x48
  802154:	68 53 3c 80 00       	push   $0x803c53
  802159:	e8 32 e2 ff ff       	call   800390 <_panic>
  80215e:	a1 50 40 80 00       	mov    0x804050,%eax
  802163:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802166:	c1 e2 04             	shl    $0x4,%edx
  802169:	01 d0                	add    %edx,%eax
  80216b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802171:	89 10                	mov    %edx,(%eax)
  802173:	8b 00                	mov    (%eax),%eax
  802175:	85 c0                	test   %eax,%eax
  802177:	74 18                	je     802191 <initialize_MemBlocksList+0x90>
  802179:	a1 48 41 80 00       	mov    0x804148,%eax
  80217e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802184:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802187:	c1 e1 04             	shl    $0x4,%ecx
  80218a:	01 ca                	add    %ecx,%edx
  80218c:	89 50 04             	mov    %edx,0x4(%eax)
  80218f:	eb 12                	jmp    8021a3 <initialize_MemBlocksList+0xa2>
  802191:	a1 50 40 80 00       	mov    0x804050,%eax
  802196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802199:	c1 e2 04             	shl    $0x4,%edx
  80219c:	01 d0                	add    %edx,%eax
  80219e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021a3:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ab:	c1 e2 04             	shl    $0x4,%edx
  8021ae:	01 d0                	add    %edx,%eax
  8021b0:	a3 48 41 80 00       	mov    %eax,0x804148
  8021b5:	a1 50 40 80 00       	mov    0x804050,%eax
  8021ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bd:	c1 e2 04             	shl    $0x4,%edx
  8021c0:	01 d0                	add    %edx,%eax
  8021c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c9:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ce:	40                   	inc    %eax
  8021cf:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8021d4:	ff 45 f4             	incl   -0xc(%ebp)
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021dd:	0f 82 56 ff ff ff    	jb     802139 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8021e3:	90                   	nop
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8021f4:	eb 18                	jmp    80220e <find_block+0x28>
		{
			if(tmp->sva==va)
  8021f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f9:	8b 40 08             	mov    0x8(%eax),%eax
  8021fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021ff:	75 05                	jne    802206 <find_block+0x20>
			{
				return tmp;
  802201:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802204:	eb 11                	jmp    802217 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80220e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802212:	75 e2                	jne    8021f6 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802214:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80221f:	a1 40 40 80 00       	mov    0x804040,%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	0f 85 83 00 00 00    	jne    8022af <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  80222c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802233:	00 00 00 
  802236:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80223d:	00 00 00 
  802240:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802247:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80224a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224e:	75 14                	jne    802264 <insert_sorted_allocList+0x4b>
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	68 30 3c 80 00       	push   $0x803c30
  802258:	6a 7f                	push   $0x7f
  80225a:	68 53 3c 80 00       	push   $0x803c53
  80225f:	e8 2c e1 ff ff       	call   800390 <_panic>
  802264:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	89 10                	mov    %edx,(%eax)
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	85 c0                	test   %eax,%eax
  802276:	74 0d                	je     802285 <insert_sorted_allocList+0x6c>
  802278:	a1 40 40 80 00       	mov    0x804040,%eax
  80227d:	8b 55 08             	mov    0x8(%ebp),%edx
  802280:	89 50 04             	mov    %edx,0x4(%eax)
  802283:	eb 08                	jmp    80228d <insert_sorted_allocList+0x74>
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 44 40 80 00       	mov    %eax,0x804044
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	a3 40 40 80 00       	mov    %eax,0x804040
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a4:	40                   	inc    %eax
  8022a5:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022aa:	e9 16 01 00 00       	jmp    8023c5 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	8b 50 08             	mov    0x8(%eax),%edx
  8022b5:	a1 44 40 80 00       	mov    0x804044,%eax
  8022ba:	8b 40 08             	mov    0x8(%eax),%eax
  8022bd:	39 c2                	cmp    %eax,%edx
  8022bf:	76 68                	jbe    802329 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8022c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c5:	75 17                	jne    8022de <insert_sorted_allocList+0xc5>
  8022c7:	83 ec 04             	sub    $0x4,%esp
  8022ca:	68 6c 3c 80 00       	push   $0x803c6c
  8022cf:	68 85 00 00 00       	push   $0x85
  8022d4:	68 53 3c 80 00       	push   $0x803c53
  8022d9:	e8 b2 e0 ff ff       	call   800390 <_panic>
  8022de:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	8b 40 04             	mov    0x4(%eax),%eax
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	74 0c                	je     802300 <insert_sorted_allocList+0xe7>
  8022f4:	a1 44 40 80 00       	mov    0x804044,%eax
  8022f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fc:	89 10                	mov    %edx,(%eax)
  8022fe:	eb 08                	jmp    802308 <insert_sorted_allocList+0xef>
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	a3 40 40 80 00       	mov    %eax,0x804040
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	a3 44 40 80 00       	mov    %eax,0x804044
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802319:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231e:	40                   	inc    %eax
  80231f:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802324:	e9 9c 00 00 00       	jmp    8023c5 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802329:	a1 40 40 80 00       	mov    0x804040,%eax
  80232e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802331:	e9 85 00 00 00       	jmp    8023bb <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	8b 50 08             	mov    0x8(%eax),%edx
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 40 08             	mov    0x8(%eax),%eax
  802342:	39 c2                	cmp    %eax,%edx
  802344:	73 6d                	jae    8023b3 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802346:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234a:	74 06                	je     802352 <insert_sorted_allocList+0x139>
  80234c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802350:	75 17                	jne    802369 <insert_sorted_allocList+0x150>
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	68 90 3c 80 00       	push   $0x803c90
  80235a:	68 90 00 00 00       	push   $0x90
  80235f:	68 53 3c 80 00       	push   $0x803c53
  802364:	e8 27 e0 ff ff       	call   800390 <_panic>
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 50 04             	mov    0x4(%eax),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	89 50 04             	mov    %edx,0x4(%eax)
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	89 10                	mov    %edx,(%eax)
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 40 04             	mov    0x4(%eax),%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	74 0d                	je     802394 <insert_sorted_allocList+0x17b>
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 04             	mov    0x4(%eax),%eax
  80238d:	8b 55 08             	mov    0x8(%ebp),%edx
  802390:	89 10                	mov    %edx,(%eax)
  802392:	eb 08                	jmp    80239c <insert_sorted_allocList+0x183>
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	a3 40 40 80 00       	mov    %eax,0x804040
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a2:	89 50 04             	mov    %edx,0x4(%eax)
  8023a5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023aa:	40                   	inc    %eax
  8023ab:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023b0:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023b1:	eb 12                	jmp    8023c5 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	8b 00                	mov    (%eax),%eax
  8023b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8023bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bf:	0f 85 71 ff ff ff    	jne    802336 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023c5:	90                   	nop
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8023ce:	a1 38 41 80 00       	mov    0x804138,%eax
  8023d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8023d6:	e9 76 01 00 00       	jmp    802551 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e4:	0f 85 8a 00 00 00    	jne    802474 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8023ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ee:	75 17                	jne    802407 <alloc_block_FF+0x3f>
  8023f0:	83 ec 04             	sub    $0x4,%esp
  8023f3:	68 c5 3c 80 00       	push   $0x803cc5
  8023f8:	68 a8 00 00 00       	push   $0xa8
  8023fd:	68 53 3c 80 00       	push   $0x803c53
  802402:	e8 89 df ff ff       	call   800390 <_panic>
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 10                	je     802420 <alloc_block_FF+0x58>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802418:	8b 52 04             	mov    0x4(%edx),%edx
  80241b:	89 50 04             	mov    %edx,0x4(%eax)
  80241e:	eb 0b                	jmp    80242b <alloc_block_FF+0x63>
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 40 04             	mov    0x4(%eax),%eax
  802426:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 40 04             	mov    0x4(%eax),%eax
  802431:	85 c0                	test   %eax,%eax
  802433:	74 0f                	je     802444 <alloc_block_FF+0x7c>
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 40 04             	mov    0x4(%eax),%eax
  80243b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243e:	8b 12                	mov    (%edx),%edx
  802440:	89 10                	mov    %edx,(%eax)
  802442:	eb 0a                	jmp    80244e <alloc_block_FF+0x86>
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	a3 38 41 80 00       	mov    %eax,0x804138
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802461:	a1 44 41 80 00       	mov    0x804144,%eax
  802466:	48                   	dec    %eax
  802467:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	e9 ea 00 00 00       	jmp    80255e <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 40 0c             	mov    0xc(%eax),%eax
  80247a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80247d:	0f 86 c6 00 00 00    	jbe    802549 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802483:	a1 48 41 80 00       	mov    0x804148,%eax
  802488:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  80248b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248e:	8b 55 08             	mov    0x8(%ebp),%edx
  802491:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 50 08             	mov    0x8(%eax),%edx
  80249a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249d:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a9:	89 c2                	mov    %eax,%edx
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 50 08             	mov    0x8(%eax),%edx
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	01 c2                	add    %eax,%edx
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8024c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c6:	75 17                	jne    8024df <alloc_block_FF+0x117>
  8024c8:	83 ec 04             	sub    $0x4,%esp
  8024cb:	68 c5 3c 80 00       	push   $0x803cc5
  8024d0:	68 b6 00 00 00       	push   $0xb6
  8024d5:	68 53 3c 80 00       	push   $0x803c53
  8024da:	e8 b1 de ff ff       	call   800390 <_panic>
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	74 10                	je     8024f8 <alloc_block_FF+0x130>
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	8b 00                	mov    (%eax),%eax
  8024ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f0:	8b 52 04             	mov    0x4(%edx),%edx
  8024f3:	89 50 04             	mov    %edx,0x4(%eax)
  8024f6:	eb 0b                	jmp    802503 <alloc_block_FF+0x13b>
  8024f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802506:	8b 40 04             	mov    0x4(%eax),%eax
  802509:	85 c0                	test   %eax,%eax
  80250b:	74 0f                	je     80251c <alloc_block_FF+0x154>
  80250d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802510:	8b 40 04             	mov    0x4(%eax),%eax
  802513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802516:	8b 12                	mov    (%edx),%edx
  802518:	89 10                	mov    %edx,(%eax)
  80251a:	eb 0a                	jmp    802526 <alloc_block_FF+0x15e>
  80251c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251f:	8b 00                	mov    (%eax),%eax
  802521:	a3 48 41 80 00       	mov    %eax,0x804148
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802532:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802539:	a1 54 41 80 00       	mov    0x804154,%eax
  80253e:	48                   	dec    %eax
  80253f:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802547:	eb 15                	jmp    80255e <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	0f 85 80 fe ff ff    	jne    8023db <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802566:	a1 38 41 80 00       	mov    0x804138,%eax
  80256b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80256e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802575:	e9 c0 00 00 00       	jmp    80263a <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 0c             	mov    0xc(%eax),%eax
  802580:	3b 45 08             	cmp    0x8(%ebp),%eax
  802583:	0f 85 8a 00 00 00    	jne    802613 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258d:	75 17                	jne    8025a6 <alloc_block_BF+0x46>
  80258f:	83 ec 04             	sub    $0x4,%esp
  802592:	68 c5 3c 80 00       	push   $0x803cc5
  802597:	68 cf 00 00 00       	push   $0xcf
  80259c:	68 53 3c 80 00       	push   $0x803c53
  8025a1:	e8 ea dd ff ff       	call   800390 <_panic>
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	74 10                	je     8025bf <alloc_block_BF+0x5f>
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b7:	8b 52 04             	mov    0x4(%edx),%edx
  8025ba:	89 50 04             	mov    %edx,0x4(%eax)
  8025bd:	eb 0b                	jmp    8025ca <alloc_block_BF+0x6a>
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 40 04             	mov    0x4(%eax),%eax
  8025c5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 40 04             	mov    0x4(%eax),%eax
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	74 0f                	je     8025e3 <alloc_block_BF+0x83>
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 40 04             	mov    0x4(%eax),%eax
  8025da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025dd:	8b 12                	mov    (%edx),%edx
  8025df:	89 10                	mov    %edx,(%eax)
  8025e1:	eb 0a                	jmp    8025ed <alloc_block_BF+0x8d>
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	a3 38 41 80 00       	mov    %eax,0x804138
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802600:	a1 44 41 80 00       	mov    0x804144,%eax
  802605:	48                   	dec    %eax
  802606:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	e9 2a 01 00 00       	jmp    80273d <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 0c             	mov    0xc(%eax),%eax
  802619:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80261c:	73 14                	jae    802632 <alloc_block_BF+0xd2>
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 0c             	mov    0xc(%eax),%eax
  802624:	3b 45 08             	cmp    0x8(%ebp),%eax
  802627:	76 09                	jbe    802632 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 40 0c             	mov    0xc(%eax),%eax
  80262f:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80263a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263e:	0f 85 36 ff ff ff    	jne    80257a <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802644:	a1 38 41 80 00       	mov    0x804138,%eax
  802649:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  80264c:	e9 dd 00 00 00       	jmp    80272e <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80265a:	0f 85 c6 00 00 00    	jne    802726 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802660:	a1 48 41 80 00       	mov    0x804148,%eax
  802665:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 50 08             	mov    0x8(%eax),%edx
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802677:	8b 55 08             	mov    0x8(%ebp),%edx
  80267a:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 50 08             	mov    0x8(%eax),%edx
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	01 c2                	add    %eax,%edx
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 0c             	mov    0xc(%eax),%eax
  802694:	2b 45 08             	sub    0x8(%ebp),%eax
  802697:	89 c2                	mov    %eax,%edx
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80269f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a3:	75 17                	jne    8026bc <alloc_block_BF+0x15c>
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 c5 3c 80 00       	push   $0x803cc5
  8026ad:	68 eb 00 00 00       	push   $0xeb
  8026b2:	68 53 3c 80 00       	push   $0x803c53
  8026b7:	e8 d4 dc ff ff       	call   800390 <_panic>
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 10                	je     8026d5 <alloc_block_BF+0x175>
  8026c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026cd:	8b 52 04             	mov    0x4(%edx),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	eb 0b                	jmp    8026e0 <alloc_block_BF+0x180>
  8026d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 0f                	je     8026f9 <alloc_block_BF+0x199>
  8026ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f3:	8b 12                	mov    (%edx),%edx
  8026f5:	89 10                	mov    %edx,(%eax)
  8026f7:	eb 0a                	jmp    802703 <alloc_block_BF+0x1a3>
  8026f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	a3 48 41 80 00       	mov    %eax,0x804148
  802703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802716:	a1 54 41 80 00       	mov    0x804154,%eax
  80271b:	48                   	dec    %eax
  80271c:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  802721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802724:	eb 17                	jmp    80273d <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80272e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802732:	0f 85 19 ff ff ff    	jne    802651 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802738:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
  802742:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802745:	a1 40 40 80 00       	mov    0x804040,%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	75 19                	jne    802767 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80274e:	83 ec 0c             	sub    $0xc,%esp
  802751:	ff 75 08             	pushl  0x8(%ebp)
  802754:	e8 6f fc ff ff       	call   8023c8 <alloc_block_FF>
  802759:	83 c4 10             	add    $0x10,%esp
  80275c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	e9 e9 01 00 00       	jmp    802950 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802767:	a1 44 40 80 00       	mov    0x804044,%eax
  80276c:	8b 40 08             	mov    0x8(%eax),%eax
  80276f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802772:	a1 44 40 80 00       	mov    0x804044,%eax
  802777:	8b 50 0c             	mov    0xc(%eax),%edx
  80277a:	a1 44 40 80 00       	mov    0x804044,%eax
  80277f:	8b 40 08             	mov    0x8(%eax),%eax
  802782:	01 d0                	add    %edx,%eax
  802784:	83 ec 08             	sub    $0x8,%esp
  802787:	50                   	push   %eax
  802788:	68 38 41 80 00       	push   $0x804138
  80278d:	e8 54 fa ff ff       	call   8021e6 <find_block>
  802792:	83 c4 10             	add    $0x10,%esp
  802795:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 0c             	mov    0xc(%eax),%eax
  80279e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a1:	0f 85 9b 00 00 00    	jne    802842 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 40 08             	mov    0x8(%eax),%eax
  8027b3:	01 d0                	add    %edx,%eax
  8027b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8027b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bc:	75 17                	jne    8027d5 <alloc_block_NF+0x96>
  8027be:	83 ec 04             	sub    $0x4,%esp
  8027c1:	68 c5 3c 80 00       	push   $0x803cc5
  8027c6:	68 1a 01 00 00       	push   $0x11a
  8027cb:	68 53 3c 80 00       	push   $0x803c53
  8027d0:	e8 bb db ff ff       	call   800390 <_panic>
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	74 10                	je     8027ee <alloc_block_NF+0xaf>
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 00                	mov    (%eax),%eax
  8027e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e6:	8b 52 04             	mov    0x4(%edx),%edx
  8027e9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ec:	eb 0b                	jmp    8027f9 <alloc_block_NF+0xba>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 40 04             	mov    0x4(%eax),%eax
  8027f4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 40 04             	mov    0x4(%eax),%eax
  8027ff:	85 c0                	test   %eax,%eax
  802801:	74 0f                	je     802812 <alloc_block_NF+0xd3>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280c:	8b 12                	mov    (%edx),%edx
  80280e:	89 10                	mov    %edx,(%eax)
  802810:	eb 0a                	jmp    80281c <alloc_block_NF+0xdd>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	a3 38 41 80 00       	mov    %eax,0x804138
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282f:	a1 44 41 80 00       	mov    0x804144,%eax
  802834:	48                   	dec    %eax
  802835:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	e9 0e 01 00 00       	jmp    802950 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 40 0c             	mov    0xc(%eax),%eax
  802848:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284b:	0f 86 cf 00 00 00    	jbe    802920 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802851:	a1 48 41 80 00       	mov    0x804148,%eax
  802856:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285c:	8b 55 08             	mov    0x8(%ebp),%edx
  80285f:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 50 08             	mov    0x8(%eax),%edx
  802868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286b:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 50 08             	mov    0x8(%eax),%edx
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	01 c2                	add    %eax,%edx
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 0c             	mov    0xc(%eax),%eax
  802885:	2b 45 08             	sub    0x8(%ebp),%eax
  802888:	89 c2                	mov    %eax,%edx
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 08             	mov    0x8(%eax),%eax
  802896:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802899:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80289d:	75 17                	jne    8028b6 <alloc_block_NF+0x177>
  80289f:	83 ec 04             	sub    $0x4,%esp
  8028a2:	68 c5 3c 80 00       	push   $0x803cc5
  8028a7:	68 28 01 00 00       	push   $0x128
  8028ac:	68 53 3c 80 00       	push   $0x803c53
  8028b1:	e8 da da ff ff       	call   800390 <_panic>
  8028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	74 10                	je     8028cf <alloc_block_NF+0x190>
  8028bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c2:	8b 00                	mov    (%eax),%eax
  8028c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c7:	8b 52 04             	mov    0x4(%edx),%edx
  8028ca:	89 50 04             	mov    %edx,0x4(%eax)
  8028cd:	eb 0b                	jmp    8028da <alloc_block_NF+0x19b>
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	8b 40 04             	mov    0x4(%eax),%eax
  8028d5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 0f                	je     8028f3 <alloc_block_NF+0x1b4>
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ed:	8b 12                	mov    (%edx),%edx
  8028ef:	89 10                	mov    %edx,(%eax)
  8028f1:	eb 0a                	jmp    8028fd <alloc_block_NF+0x1be>
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	a3 48 41 80 00       	mov    %eax,0x804148
  8028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802909:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802910:	a1 54 41 80 00       	mov    0x804154,%eax
  802915:	48                   	dec    %eax
  802916:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  80291b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291e:	eb 30                	jmp    802950 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802920:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802925:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802928:	75 0a                	jne    802934 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80292a:	a1 38 41 80 00       	mov    0x804138,%eax
  80292f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802932:	eb 08                	jmp    80293c <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 08             	mov    0x8(%eax),%eax
  802942:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802945:	0f 85 4d fe ff ff    	jne    802798 <alloc_block_NF+0x59>

			return NULL;
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
  802955:	53                   	push   %ebx
  802956:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802959:	a1 38 41 80 00       	mov    0x804138,%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	0f 85 86 00 00 00    	jne    8029ec <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802966:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80296d:	00 00 00 
  802970:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802977:	00 00 00 
  80297a:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802981:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802984:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802988:	75 17                	jne    8029a1 <insert_sorted_with_merge_freeList+0x4f>
  80298a:	83 ec 04             	sub    $0x4,%esp
  80298d:	68 30 3c 80 00       	push   $0x803c30
  802992:	68 48 01 00 00       	push   $0x148
  802997:	68 53 3c 80 00       	push   $0x803c53
  80299c:	e8 ef d9 ff ff       	call   800390 <_panic>
  8029a1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	89 10                	mov    %edx,(%eax)
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	74 0d                	je     8029c2 <insert_sorted_with_merge_freeList+0x70>
  8029b5:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bd:	89 50 04             	mov    %edx,0x4(%eax)
  8029c0:	eb 08                	jmp    8029ca <insert_sorted_with_merge_freeList+0x78>
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	a3 38 41 80 00       	mov    %eax,0x804138
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029dc:	a1 44 41 80 00       	mov    0x804144,%eax
  8029e1:	40                   	inc    %eax
  8029e2:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8029e7:	e9 73 07 00 00       	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	8b 50 08             	mov    0x8(%eax),%edx
  8029f2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029f7:	8b 40 08             	mov    0x8(%eax),%eax
  8029fa:	39 c2                	cmp    %eax,%edx
  8029fc:	0f 86 84 00 00 00    	jbe    802a86 <insert_sorted_with_merge_freeList+0x134>
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	8b 50 08             	mov    0x8(%eax),%edx
  802a08:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a0d:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a10:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a15:	8b 40 08             	mov    0x8(%eax),%eax
  802a18:	01 c8                	add    %ecx,%eax
  802a1a:	39 c2                	cmp    %eax,%edx
  802a1c:	74 68                	je     802a86 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802a1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a22:	75 17                	jne    802a3b <insert_sorted_with_merge_freeList+0xe9>
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	68 6c 3c 80 00       	push   $0x803c6c
  802a2c:	68 4c 01 00 00       	push   $0x14c
  802a31:	68 53 3c 80 00       	push   $0x803c53
  802a36:	e8 55 d9 ff ff       	call   800390 <_panic>
  802a3b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	89 50 04             	mov    %edx,0x4(%eax)
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	8b 40 04             	mov    0x4(%eax),%eax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	74 0c                	je     802a5d <insert_sorted_with_merge_freeList+0x10b>
  802a51:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a56:	8b 55 08             	mov    0x8(%ebp),%edx
  802a59:	89 10                	mov    %edx,(%eax)
  802a5b:	eb 08                	jmp    802a65 <insert_sorted_with_merge_freeList+0x113>
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	a3 38 41 80 00       	mov    %eax,0x804138
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a76:	a1 44 41 80 00       	mov    0x804144,%eax
  802a7b:	40                   	inc    %eax
  802a7c:	a3 44 41 80 00       	mov    %eax,0x804144
  802a81:	e9 d9 06 00 00       	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	8b 50 08             	mov    0x8(%eax),%edx
  802a8c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a91:	8b 40 08             	mov    0x8(%eax),%eax
  802a94:	39 c2                	cmp    %eax,%edx
  802a96:	0f 86 b5 00 00 00    	jbe    802b51 <insert_sorted_with_merge_freeList+0x1ff>
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	8b 50 08             	mov    0x8(%eax),%edx
  802aa2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aa7:	8b 48 0c             	mov    0xc(%eax),%ecx
  802aaa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aaf:	8b 40 08             	mov    0x8(%eax),%eax
  802ab2:	01 c8                	add    %ecx,%eax
  802ab4:	39 c2                	cmp    %eax,%edx
  802ab6:	0f 85 95 00 00 00    	jne    802b51 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802abc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ac1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ac7:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802aca:	8b 55 08             	mov    0x8(%ebp),%edx
  802acd:	8b 52 0c             	mov    0xc(%edx),%edx
  802ad0:	01 ca                	add    %ecx,%edx
  802ad2:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ae9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aed:	75 17                	jne    802b06 <insert_sorted_with_merge_freeList+0x1b4>
  802aef:	83 ec 04             	sub    $0x4,%esp
  802af2:	68 30 3c 80 00       	push   $0x803c30
  802af7:	68 54 01 00 00       	push   $0x154
  802afc:	68 53 3c 80 00       	push   $0x803c53
  802b01:	e8 8a d8 ff ff       	call   800390 <_panic>
  802b06:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	89 10                	mov    %edx,(%eax)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0d                	je     802b27 <insert_sorted_with_merge_freeList+0x1d5>
  802b1a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	eb 08                	jmp    802b2f <insert_sorted_with_merge_freeList+0x1dd>
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	a3 48 41 80 00       	mov    %eax,0x804148
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b41:	a1 54 41 80 00       	mov    0x804154,%eax
  802b46:	40                   	inc    %eax
  802b47:	a3 54 41 80 00       	mov    %eax,0x804154
  802b4c:	e9 0e 06 00 00       	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	8b 50 08             	mov    0x8(%eax),%edx
  802b57:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5c:	8b 40 08             	mov    0x8(%eax),%eax
  802b5f:	39 c2                	cmp    %eax,%edx
  802b61:	0f 83 c1 00 00 00    	jae    802c28 <insert_sorted_with_merge_freeList+0x2d6>
  802b67:	a1 38 41 80 00       	mov    0x804138,%eax
  802b6c:	8b 50 08             	mov    0x8(%eax),%edx
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	8b 48 08             	mov    0x8(%eax),%ecx
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	01 c8                	add    %ecx,%eax
  802b7d:	39 c2                	cmp    %eax,%edx
  802b7f:	0f 85 a3 00 00 00    	jne    802c28 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802b85:	a1 38 41 80 00       	mov    0x804138,%eax
  802b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8d:	8b 52 08             	mov    0x8(%edx),%edx
  802b90:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802b93:	a1 38 41 80 00       	mov    0x804138,%eax
  802b98:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b9e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba4:	8b 52 0c             	mov    0xc(%edx),%edx
  802ba7:	01 ca                	add    %ecx,%edx
  802ba9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc4:	75 17                	jne    802bdd <insert_sorted_with_merge_freeList+0x28b>
  802bc6:	83 ec 04             	sub    $0x4,%esp
  802bc9:	68 30 3c 80 00       	push   $0x803c30
  802bce:	68 5d 01 00 00       	push   $0x15d
  802bd3:	68 53 3c 80 00       	push   $0x803c53
  802bd8:	e8 b3 d7 ff ff       	call   800390 <_panic>
  802bdd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	89 10                	mov    %edx,(%eax)
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	85 c0                	test   %eax,%eax
  802bef:	74 0d                	je     802bfe <insert_sorted_with_merge_freeList+0x2ac>
  802bf1:	a1 48 41 80 00       	mov    0x804148,%eax
  802bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf9:	89 50 04             	mov    %edx,0x4(%eax)
  802bfc:	eb 08                	jmp    802c06 <insert_sorted_with_merge_freeList+0x2b4>
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	a3 48 41 80 00       	mov    %eax,0x804148
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c18:	a1 54 41 80 00       	mov    0x804154,%eax
  802c1d:	40                   	inc    %eax
  802c1e:	a3 54 41 80 00       	mov    %eax,0x804154
  802c23:	e9 37 05 00 00       	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 50 08             	mov    0x8(%eax),%edx
  802c2e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c33:	8b 40 08             	mov    0x8(%eax),%eax
  802c36:	39 c2                	cmp    %eax,%edx
  802c38:	0f 83 82 00 00 00    	jae    802cc0 <insert_sorted_with_merge_freeList+0x36e>
  802c3e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c43:	8b 50 08             	mov    0x8(%eax),%edx
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	8b 48 08             	mov    0x8(%eax),%ecx
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c52:	01 c8                	add    %ecx,%eax
  802c54:	39 c2                	cmp    %eax,%edx
  802c56:	74 68                	je     802cc0 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5c:	75 17                	jne    802c75 <insert_sorted_with_merge_freeList+0x323>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 30 3c 80 00       	push   $0x803c30
  802c66:	68 62 01 00 00       	push   $0x162
  802c6b:	68 53 3c 80 00       	push   $0x803c53
  802c70:	e8 1b d7 ff ff       	call   800390 <_panic>
  802c75:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	89 10                	mov    %edx,(%eax)
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 0d                	je     802c96 <insert_sorted_with_merge_freeList+0x344>
  802c89:	a1 38 41 80 00       	mov    0x804138,%eax
  802c8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c91:	89 50 04             	mov    %edx,0x4(%eax)
  802c94:	eb 08                	jmp    802c9e <insert_sorted_with_merge_freeList+0x34c>
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	a3 38 41 80 00       	mov    %eax,0x804138
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb0:	a1 44 41 80 00       	mov    0x804144,%eax
  802cb5:	40                   	inc    %eax
  802cb6:	a3 44 41 80 00       	mov    %eax,0x804144
  802cbb:	e9 9f 04 00 00       	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802cc0:	a1 38 41 80 00       	mov    0x804138,%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802cca:	e9 84 04 00 00       	jmp    803153 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 50 08             	mov    0x8(%eax),%edx
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	8b 40 08             	mov    0x8(%eax),%eax
  802cdb:	39 c2                	cmp    %eax,%edx
  802cdd:	0f 86 a9 00 00 00    	jbe    802d8c <insert_sorted_with_merge_freeList+0x43a>
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 50 08             	mov    0x8(%eax),%edx
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 48 08             	mov    0x8(%eax),%ecx
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf5:	01 c8                	add    %ecx,%eax
  802cf7:	39 c2                	cmp    %eax,%edx
  802cf9:	0f 84 8d 00 00 00    	je     802d8c <insert_sorted_with_merge_freeList+0x43a>
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	8b 50 08             	mov    0x8(%eax),%edx
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	8b 48 08             	mov    0x8(%eax),%ecx
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 04             	mov    0x4(%eax),%eax
  802d14:	8b 40 0c             	mov    0xc(%eax),%eax
  802d17:	01 c8                	add    %ecx,%eax
  802d19:	39 c2                	cmp    %eax,%edx
  802d1b:	74 6f                	je     802d8c <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d21:	74 06                	je     802d29 <insert_sorted_with_merge_freeList+0x3d7>
  802d23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d27:	75 17                	jne    802d40 <insert_sorted_with_merge_freeList+0x3ee>
  802d29:	83 ec 04             	sub    $0x4,%esp
  802d2c:	68 90 3c 80 00       	push   $0x803c90
  802d31:	68 6b 01 00 00       	push   $0x16b
  802d36:	68 53 3c 80 00       	push   $0x803c53
  802d3b:	e8 50 d6 ff ff       	call   800390 <_panic>
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	8b 50 04             	mov    0x4(%eax),%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	89 50 04             	mov    %edx,0x4(%eax)
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d52:	89 10                	mov    %edx,(%eax)
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 0d                	je     802d6b <insert_sorted_with_merge_freeList+0x419>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	8b 55 08             	mov    0x8(%ebp),%edx
  802d67:	89 10                	mov    %edx,(%eax)
  802d69:	eb 08                	jmp    802d73 <insert_sorted_with_merge_freeList+0x421>
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	a3 38 41 80 00       	mov    %eax,0x804138
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 55 08             	mov    0x8(%ebp),%edx
  802d79:	89 50 04             	mov    %edx,0x4(%eax)
  802d7c:	a1 44 41 80 00       	mov    0x804144,%eax
  802d81:	40                   	inc    %eax
  802d82:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802d87:	e9 d3 03 00 00       	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 50 08             	mov    0x8(%eax),%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 40 08             	mov    0x8(%eax),%eax
  802d98:	39 c2                	cmp    %eax,%edx
  802d9a:	0f 86 da 00 00 00    	jbe    802e7a <insert_sorted_with_merge_freeList+0x528>
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 50 08             	mov    0x8(%eax),%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 48 08             	mov    0x8(%eax),%ecx
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	8b 40 0c             	mov    0xc(%eax),%eax
  802db2:	01 c8                	add    %ecx,%eax
  802db4:	39 c2                	cmp    %eax,%edx
  802db6:	0f 85 be 00 00 00    	jne    802e7a <insert_sorted_with_merge_freeList+0x528>
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 50 08             	mov    0x8(%eax),%edx
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 40 04             	mov    0x4(%eax),%eax
  802dc8:	8b 48 08             	mov    0x8(%eax),%ecx
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 40 04             	mov    0x4(%eax),%eax
  802dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd4:	01 c8                	add    %ecx,%eax
  802dd6:	39 c2                	cmp    %eax,%edx
  802dd8:	0f 84 9c 00 00 00    	je     802e7a <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	8b 50 08             	mov    0x8(%eax),%edx
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 50 0c             	mov    0xc(%eax),%edx
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	8b 40 0c             	mov    0xc(%eax),%eax
  802df6:	01 c2                	add    %eax,%edx
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e16:	75 17                	jne    802e2f <insert_sorted_with_merge_freeList+0x4dd>
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 30 3c 80 00       	push   $0x803c30
  802e20:	68 74 01 00 00       	push   $0x174
  802e25:	68 53 3c 80 00       	push   $0x803c53
  802e2a:	e8 61 d5 ff ff       	call   800390 <_panic>
  802e2f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	89 10                	mov    %edx,(%eax)
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 0d                	je     802e50 <insert_sorted_with_merge_freeList+0x4fe>
  802e43:	a1 48 41 80 00       	mov    0x804148,%eax
  802e48:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4b:	89 50 04             	mov    %edx,0x4(%eax)
  802e4e:	eb 08                	jmp    802e58 <insert_sorted_with_merge_freeList+0x506>
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	a3 48 41 80 00       	mov    %eax,0x804148
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6a:	a1 54 41 80 00       	mov    0x804154,%eax
  802e6f:	40                   	inc    %eax
  802e70:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e75:	e9 e5 02 00 00       	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 50 08             	mov    0x8(%eax),%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 40 08             	mov    0x8(%eax),%eax
  802e86:	39 c2                	cmp    %eax,%edx
  802e88:	0f 86 d7 00 00 00    	jbe    802f65 <insert_sorted_with_merge_freeList+0x613>
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 50 08             	mov    0x8(%eax),%edx
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 48 08             	mov    0x8(%eax),%ecx
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea0:	01 c8                	add    %ecx,%eax
  802ea2:	39 c2                	cmp    %eax,%edx
  802ea4:	0f 84 bb 00 00 00    	je     802f65 <insert_sorted_with_merge_freeList+0x613>
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 50 08             	mov    0x8(%eax),%edx
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 40 04             	mov    0x4(%eax),%eax
  802eb6:	8b 48 08             	mov    0x8(%eax),%ecx
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 40 04             	mov    0x4(%eax),%eax
  802ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec2:	01 c8                	add    %ecx,%eax
  802ec4:	39 c2                	cmp    %eax,%edx
  802ec6:	0f 85 99 00 00 00    	jne    802f65 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 04             	mov    0x4(%eax),%eax
  802ed2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	8b 50 0c             	mov    0xc(%eax),%edx
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee1:	01 c2                	add    %eax,%edx
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802efd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f01:	75 17                	jne    802f1a <insert_sorted_with_merge_freeList+0x5c8>
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	68 30 3c 80 00       	push   $0x803c30
  802f0b:	68 7d 01 00 00       	push   $0x17d
  802f10:	68 53 3c 80 00       	push   $0x803c53
  802f15:	e8 76 d4 ff ff       	call   800390 <_panic>
  802f1a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	89 10                	mov    %edx,(%eax)
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	74 0d                	je     802f3b <insert_sorted_with_merge_freeList+0x5e9>
  802f2e:	a1 48 41 80 00       	mov    0x804148,%eax
  802f33:	8b 55 08             	mov    0x8(%ebp),%edx
  802f36:	89 50 04             	mov    %edx,0x4(%eax)
  802f39:	eb 08                	jmp    802f43 <insert_sorted_with_merge_freeList+0x5f1>
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	a3 48 41 80 00       	mov    %eax,0x804148
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f55:	a1 54 41 80 00       	mov    0x804154,%eax
  802f5a:	40                   	inc    %eax
  802f5b:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f60:	e9 fa 01 00 00       	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 50 08             	mov    0x8(%eax),%edx
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 40 08             	mov    0x8(%eax),%eax
  802f71:	39 c2                	cmp    %eax,%edx
  802f73:	0f 86 d2 01 00 00    	jbe    80314b <insert_sorted_with_merge_freeList+0x7f9>
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 50 08             	mov    0x8(%eax),%edx
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 48 08             	mov    0x8(%eax),%ecx
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c8                	add    %ecx,%eax
  802f8d:	39 c2                	cmp    %eax,%edx
  802f8f:	0f 85 b6 01 00 00    	jne    80314b <insert_sorted_with_merge_freeList+0x7f9>
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 50 08             	mov    0x8(%eax),%edx
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	8b 40 04             	mov    0x4(%eax),%eax
  802fa1:	8b 48 08             	mov    0x8(%eax),%ecx
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	8b 40 0c             	mov    0xc(%eax),%eax
  802fad:	01 c8                	add    %ecx,%eax
  802faf:	39 c2                	cmp    %eax,%edx
  802fb1:	0f 85 94 01 00 00    	jne    80314b <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 40 04             	mov    0x4(%eax),%eax
  802fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc0:	8b 52 04             	mov    0x4(%edx),%edx
  802fc3:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc9:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fcf:	8b 52 0c             	mov    0xc(%edx),%edx
  802fd2:	01 da                	add    %ebx,%edx
  802fd4:	01 ca                	add    %ecx,%edx
  802fd6:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff1:	75 17                	jne    80300a <insert_sorted_with_merge_freeList+0x6b8>
  802ff3:	83 ec 04             	sub    $0x4,%esp
  802ff6:	68 c5 3c 80 00       	push   $0x803cc5
  802ffb:	68 86 01 00 00       	push   $0x186
  803000:	68 53 3c 80 00       	push   $0x803c53
  803005:	e8 86 d3 ff ff       	call   800390 <_panic>
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	74 10                	je     803023 <insert_sorted_with_merge_freeList+0x6d1>
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301b:	8b 52 04             	mov    0x4(%edx),%edx
  80301e:	89 50 04             	mov    %edx,0x4(%eax)
  803021:	eb 0b                	jmp    80302e <insert_sorted_with_merge_freeList+0x6dc>
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 40 04             	mov    0x4(%eax),%eax
  803029:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 40 04             	mov    0x4(%eax),%eax
  803034:	85 c0                	test   %eax,%eax
  803036:	74 0f                	je     803047 <insert_sorted_with_merge_freeList+0x6f5>
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 40 04             	mov    0x4(%eax),%eax
  80303e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803041:	8b 12                	mov    (%edx),%edx
  803043:	89 10                	mov    %edx,(%eax)
  803045:	eb 0a                	jmp    803051 <insert_sorted_with_merge_freeList+0x6ff>
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	a3 38 41 80 00       	mov    %eax,0x804138
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803064:	a1 44 41 80 00       	mov    0x804144,%eax
  803069:	48                   	dec    %eax
  80306a:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80306f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803073:	75 17                	jne    80308c <insert_sorted_with_merge_freeList+0x73a>
  803075:	83 ec 04             	sub    $0x4,%esp
  803078:	68 30 3c 80 00       	push   $0x803c30
  80307d:	68 87 01 00 00       	push   $0x187
  803082:	68 53 3c 80 00       	push   $0x803c53
  803087:	e8 04 d3 ff ff       	call   800390 <_panic>
  80308c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	89 10                	mov    %edx,(%eax)
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 0d                	je     8030ad <insert_sorted_with_merge_freeList+0x75b>
  8030a0:	a1 48 41 80 00       	mov    0x804148,%eax
  8030a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a8:	89 50 04             	mov    %edx,0x4(%eax)
  8030ab:	eb 08                	jmp    8030b5 <insert_sorted_with_merge_freeList+0x763>
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	a3 48 41 80 00       	mov    %eax,0x804148
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c7:	a1 54 41 80 00       	mov    0x804154,%eax
  8030cc:	40                   	inc    %eax
  8030cd:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ea:	75 17                	jne    803103 <insert_sorted_with_merge_freeList+0x7b1>
  8030ec:	83 ec 04             	sub    $0x4,%esp
  8030ef:	68 30 3c 80 00       	push   $0x803c30
  8030f4:	68 8a 01 00 00       	push   $0x18a
  8030f9:	68 53 3c 80 00       	push   $0x803c53
  8030fe:	e8 8d d2 ff ff       	call   800390 <_panic>
  803103:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	89 10                	mov    %edx,(%eax)
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	85 c0                	test   %eax,%eax
  803115:	74 0d                	je     803124 <insert_sorted_with_merge_freeList+0x7d2>
  803117:	a1 48 41 80 00       	mov    0x804148,%eax
  80311c:	8b 55 08             	mov    0x8(%ebp),%edx
  80311f:	89 50 04             	mov    %edx,0x4(%eax)
  803122:	eb 08                	jmp    80312c <insert_sorted_with_merge_freeList+0x7da>
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	a3 48 41 80 00       	mov    %eax,0x804148
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313e:	a1 54 41 80 00       	mov    0x804154,%eax
  803143:	40                   	inc    %eax
  803144:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803149:	eb 14                	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803153:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803157:	0f 85 72 fb ff ff    	jne    802ccf <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80315d:	eb 00                	jmp    80315f <insert_sorted_with_merge_freeList+0x80d>
  80315f:	90                   	nop
  803160:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803163:	c9                   	leave  
  803164:	c3                   	ret    
  803165:	66 90                	xchg   %ax,%ax
  803167:	90                   	nop

00803168 <__udivdi3>:
  803168:	55                   	push   %ebp
  803169:	57                   	push   %edi
  80316a:	56                   	push   %esi
  80316b:	53                   	push   %ebx
  80316c:	83 ec 1c             	sub    $0x1c,%esp
  80316f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803173:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803177:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80317b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80317f:	89 ca                	mov    %ecx,%edx
  803181:	89 f8                	mov    %edi,%eax
  803183:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803187:	85 f6                	test   %esi,%esi
  803189:	75 2d                	jne    8031b8 <__udivdi3+0x50>
  80318b:	39 cf                	cmp    %ecx,%edi
  80318d:	77 65                	ja     8031f4 <__udivdi3+0x8c>
  80318f:	89 fd                	mov    %edi,%ebp
  803191:	85 ff                	test   %edi,%edi
  803193:	75 0b                	jne    8031a0 <__udivdi3+0x38>
  803195:	b8 01 00 00 00       	mov    $0x1,%eax
  80319a:	31 d2                	xor    %edx,%edx
  80319c:	f7 f7                	div    %edi
  80319e:	89 c5                	mov    %eax,%ebp
  8031a0:	31 d2                	xor    %edx,%edx
  8031a2:	89 c8                	mov    %ecx,%eax
  8031a4:	f7 f5                	div    %ebp
  8031a6:	89 c1                	mov    %eax,%ecx
  8031a8:	89 d8                	mov    %ebx,%eax
  8031aa:	f7 f5                	div    %ebp
  8031ac:	89 cf                	mov    %ecx,%edi
  8031ae:	89 fa                	mov    %edi,%edx
  8031b0:	83 c4 1c             	add    $0x1c,%esp
  8031b3:	5b                   	pop    %ebx
  8031b4:	5e                   	pop    %esi
  8031b5:	5f                   	pop    %edi
  8031b6:	5d                   	pop    %ebp
  8031b7:	c3                   	ret    
  8031b8:	39 ce                	cmp    %ecx,%esi
  8031ba:	77 28                	ja     8031e4 <__udivdi3+0x7c>
  8031bc:	0f bd fe             	bsr    %esi,%edi
  8031bf:	83 f7 1f             	xor    $0x1f,%edi
  8031c2:	75 40                	jne    803204 <__udivdi3+0x9c>
  8031c4:	39 ce                	cmp    %ecx,%esi
  8031c6:	72 0a                	jb     8031d2 <__udivdi3+0x6a>
  8031c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031cc:	0f 87 9e 00 00 00    	ja     803270 <__udivdi3+0x108>
  8031d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031d7:	89 fa                	mov    %edi,%edx
  8031d9:	83 c4 1c             	add    $0x1c,%esp
  8031dc:	5b                   	pop    %ebx
  8031dd:	5e                   	pop    %esi
  8031de:	5f                   	pop    %edi
  8031df:	5d                   	pop    %ebp
  8031e0:	c3                   	ret    
  8031e1:	8d 76 00             	lea    0x0(%esi),%esi
  8031e4:	31 ff                	xor    %edi,%edi
  8031e6:	31 c0                	xor    %eax,%eax
  8031e8:	89 fa                	mov    %edi,%edx
  8031ea:	83 c4 1c             	add    $0x1c,%esp
  8031ed:	5b                   	pop    %ebx
  8031ee:	5e                   	pop    %esi
  8031ef:	5f                   	pop    %edi
  8031f0:	5d                   	pop    %ebp
  8031f1:	c3                   	ret    
  8031f2:	66 90                	xchg   %ax,%ax
  8031f4:	89 d8                	mov    %ebx,%eax
  8031f6:	f7 f7                	div    %edi
  8031f8:	31 ff                	xor    %edi,%edi
  8031fa:	89 fa                	mov    %edi,%edx
  8031fc:	83 c4 1c             	add    $0x1c,%esp
  8031ff:	5b                   	pop    %ebx
  803200:	5e                   	pop    %esi
  803201:	5f                   	pop    %edi
  803202:	5d                   	pop    %ebp
  803203:	c3                   	ret    
  803204:	bd 20 00 00 00       	mov    $0x20,%ebp
  803209:	89 eb                	mov    %ebp,%ebx
  80320b:	29 fb                	sub    %edi,%ebx
  80320d:	89 f9                	mov    %edi,%ecx
  80320f:	d3 e6                	shl    %cl,%esi
  803211:	89 c5                	mov    %eax,%ebp
  803213:	88 d9                	mov    %bl,%cl
  803215:	d3 ed                	shr    %cl,%ebp
  803217:	89 e9                	mov    %ebp,%ecx
  803219:	09 f1                	or     %esi,%ecx
  80321b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80321f:	89 f9                	mov    %edi,%ecx
  803221:	d3 e0                	shl    %cl,%eax
  803223:	89 c5                	mov    %eax,%ebp
  803225:	89 d6                	mov    %edx,%esi
  803227:	88 d9                	mov    %bl,%cl
  803229:	d3 ee                	shr    %cl,%esi
  80322b:	89 f9                	mov    %edi,%ecx
  80322d:	d3 e2                	shl    %cl,%edx
  80322f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803233:	88 d9                	mov    %bl,%cl
  803235:	d3 e8                	shr    %cl,%eax
  803237:	09 c2                	or     %eax,%edx
  803239:	89 d0                	mov    %edx,%eax
  80323b:	89 f2                	mov    %esi,%edx
  80323d:	f7 74 24 0c          	divl   0xc(%esp)
  803241:	89 d6                	mov    %edx,%esi
  803243:	89 c3                	mov    %eax,%ebx
  803245:	f7 e5                	mul    %ebp
  803247:	39 d6                	cmp    %edx,%esi
  803249:	72 19                	jb     803264 <__udivdi3+0xfc>
  80324b:	74 0b                	je     803258 <__udivdi3+0xf0>
  80324d:	89 d8                	mov    %ebx,%eax
  80324f:	31 ff                	xor    %edi,%edi
  803251:	e9 58 ff ff ff       	jmp    8031ae <__udivdi3+0x46>
  803256:	66 90                	xchg   %ax,%ax
  803258:	8b 54 24 08          	mov    0x8(%esp),%edx
  80325c:	89 f9                	mov    %edi,%ecx
  80325e:	d3 e2                	shl    %cl,%edx
  803260:	39 c2                	cmp    %eax,%edx
  803262:	73 e9                	jae    80324d <__udivdi3+0xe5>
  803264:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803267:	31 ff                	xor    %edi,%edi
  803269:	e9 40 ff ff ff       	jmp    8031ae <__udivdi3+0x46>
  80326e:	66 90                	xchg   %ax,%ax
  803270:	31 c0                	xor    %eax,%eax
  803272:	e9 37 ff ff ff       	jmp    8031ae <__udivdi3+0x46>
  803277:	90                   	nop

00803278 <__umoddi3>:
  803278:	55                   	push   %ebp
  803279:	57                   	push   %edi
  80327a:	56                   	push   %esi
  80327b:	53                   	push   %ebx
  80327c:	83 ec 1c             	sub    $0x1c,%esp
  80327f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803283:	8b 74 24 34          	mov    0x34(%esp),%esi
  803287:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80328b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80328f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803293:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803297:	89 f3                	mov    %esi,%ebx
  803299:	89 fa                	mov    %edi,%edx
  80329b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80329f:	89 34 24             	mov    %esi,(%esp)
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	75 1a                	jne    8032c0 <__umoddi3+0x48>
  8032a6:	39 f7                	cmp    %esi,%edi
  8032a8:	0f 86 a2 00 00 00    	jbe    803350 <__umoddi3+0xd8>
  8032ae:	89 c8                	mov    %ecx,%eax
  8032b0:	89 f2                	mov    %esi,%edx
  8032b2:	f7 f7                	div    %edi
  8032b4:	89 d0                	mov    %edx,%eax
  8032b6:	31 d2                	xor    %edx,%edx
  8032b8:	83 c4 1c             	add    $0x1c,%esp
  8032bb:	5b                   	pop    %ebx
  8032bc:	5e                   	pop    %esi
  8032bd:	5f                   	pop    %edi
  8032be:	5d                   	pop    %ebp
  8032bf:	c3                   	ret    
  8032c0:	39 f0                	cmp    %esi,%eax
  8032c2:	0f 87 ac 00 00 00    	ja     803374 <__umoddi3+0xfc>
  8032c8:	0f bd e8             	bsr    %eax,%ebp
  8032cb:	83 f5 1f             	xor    $0x1f,%ebp
  8032ce:	0f 84 ac 00 00 00    	je     803380 <__umoddi3+0x108>
  8032d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8032d9:	29 ef                	sub    %ebp,%edi
  8032db:	89 fe                	mov    %edi,%esi
  8032dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032e1:	89 e9                	mov    %ebp,%ecx
  8032e3:	d3 e0                	shl    %cl,%eax
  8032e5:	89 d7                	mov    %edx,%edi
  8032e7:	89 f1                	mov    %esi,%ecx
  8032e9:	d3 ef                	shr    %cl,%edi
  8032eb:	09 c7                	or     %eax,%edi
  8032ed:	89 e9                	mov    %ebp,%ecx
  8032ef:	d3 e2                	shl    %cl,%edx
  8032f1:	89 14 24             	mov    %edx,(%esp)
  8032f4:	89 d8                	mov    %ebx,%eax
  8032f6:	d3 e0                	shl    %cl,%eax
  8032f8:	89 c2                	mov    %eax,%edx
  8032fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032fe:	d3 e0                	shl    %cl,%eax
  803300:	89 44 24 04          	mov    %eax,0x4(%esp)
  803304:	8b 44 24 08          	mov    0x8(%esp),%eax
  803308:	89 f1                	mov    %esi,%ecx
  80330a:	d3 e8                	shr    %cl,%eax
  80330c:	09 d0                	or     %edx,%eax
  80330e:	d3 eb                	shr    %cl,%ebx
  803310:	89 da                	mov    %ebx,%edx
  803312:	f7 f7                	div    %edi
  803314:	89 d3                	mov    %edx,%ebx
  803316:	f7 24 24             	mull   (%esp)
  803319:	89 c6                	mov    %eax,%esi
  80331b:	89 d1                	mov    %edx,%ecx
  80331d:	39 d3                	cmp    %edx,%ebx
  80331f:	0f 82 87 00 00 00    	jb     8033ac <__umoddi3+0x134>
  803325:	0f 84 91 00 00 00    	je     8033bc <__umoddi3+0x144>
  80332b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80332f:	29 f2                	sub    %esi,%edx
  803331:	19 cb                	sbb    %ecx,%ebx
  803333:	89 d8                	mov    %ebx,%eax
  803335:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803339:	d3 e0                	shl    %cl,%eax
  80333b:	89 e9                	mov    %ebp,%ecx
  80333d:	d3 ea                	shr    %cl,%edx
  80333f:	09 d0                	or     %edx,%eax
  803341:	89 e9                	mov    %ebp,%ecx
  803343:	d3 eb                	shr    %cl,%ebx
  803345:	89 da                	mov    %ebx,%edx
  803347:	83 c4 1c             	add    $0x1c,%esp
  80334a:	5b                   	pop    %ebx
  80334b:	5e                   	pop    %esi
  80334c:	5f                   	pop    %edi
  80334d:	5d                   	pop    %ebp
  80334e:	c3                   	ret    
  80334f:	90                   	nop
  803350:	89 fd                	mov    %edi,%ebp
  803352:	85 ff                	test   %edi,%edi
  803354:	75 0b                	jne    803361 <__umoddi3+0xe9>
  803356:	b8 01 00 00 00       	mov    $0x1,%eax
  80335b:	31 d2                	xor    %edx,%edx
  80335d:	f7 f7                	div    %edi
  80335f:	89 c5                	mov    %eax,%ebp
  803361:	89 f0                	mov    %esi,%eax
  803363:	31 d2                	xor    %edx,%edx
  803365:	f7 f5                	div    %ebp
  803367:	89 c8                	mov    %ecx,%eax
  803369:	f7 f5                	div    %ebp
  80336b:	89 d0                	mov    %edx,%eax
  80336d:	e9 44 ff ff ff       	jmp    8032b6 <__umoddi3+0x3e>
  803372:	66 90                	xchg   %ax,%ax
  803374:	89 c8                	mov    %ecx,%eax
  803376:	89 f2                	mov    %esi,%edx
  803378:	83 c4 1c             	add    $0x1c,%esp
  80337b:	5b                   	pop    %ebx
  80337c:	5e                   	pop    %esi
  80337d:	5f                   	pop    %edi
  80337e:	5d                   	pop    %ebp
  80337f:	c3                   	ret    
  803380:	3b 04 24             	cmp    (%esp),%eax
  803383:	72 06                	jb     80338b <__umoddi3+0x113>
  803385:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803389:	77 0f                	ja     80339a <__umoddi3+0x122>
  80338b:	89 f2                	mov    %esi,%edx
  80338d:	29 f9                	sub    %edi,%ecx
  80338f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803393:	89 14 24             	mov    %edx,(%esp)
  803396:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80339a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80339e:	8b 14 24             	mov    (%esp),%edx
  8033a1:	83 c4 1c             	add    $0x1c,%esp
  8033a4:	5b                   	pop    %ebx
  8033a5:	5e                   	pop    %esi
  8033a6:	5f                   	pop    %edi
  8033a7:	5d                   	pop    %ebp
  8033a8:	c3                   	ret    
  8033a9:	8d 76 00             	lea    0x0(%esi),%esi
  8033ac:	2b 04 24             	sub    (%esp),%eax
  8033af:	19 fa                	sbb    %edi,%edx
  8033b1:	89 d1                	mov    %edx,%ecx
  8033b3:	89 c6                	mov    %eax,%esi
  8033b5:	e9 71 ff ff ff       	jmp    80332b <__umoddi3+0xb3>
  8033ba:	66 90                	xchg   %ax,%ax
  8033bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033c0:	72 ea                	jb     8033ac <__umoddi3+0x134>
  8033c2:	89 d9                	mov    %ebx,%ecx
  8033c4:	e9 62 ff ff ff       	jmp    80332b <__umoddi3+0xb3>
