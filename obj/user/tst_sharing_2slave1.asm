
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 2b 02 00 00       	call   800261 <libmain>
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
  800099:	e8 ff 02 00 00       	call   80039d <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 f9 14 00 00       	call   8015a1 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 4e 1c 00 00       	call   801cfe <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 3a 1a 00 00       	call   801af2 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 48 19 00 00       	call   801a05 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 17 34 80 00       	push   $0x803417
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 f5 16 00 00       	call   8017c5 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 1c 34 80 00       	push   $0x80341c
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 fc 33 80 00       	push   $0x8033fc
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 0a 19 00 00       	call   801a05 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 7c 34 80 00       	push   $0x80347c
  80010c:	6a 21                	push   $0x21
  80010e:	68 fc 33 80 00       	push   $0x8033fc
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 ef 19 00 00       	call   801b0c <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 d0 19 00 00       	call   801af2 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 de 18 00 00       	call   801a05 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 0d 35 80 00       	push   $0x80350d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 8b 16 00 00       	call   8017c5 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 1c 34 80 00       	push   $0x80341c
  800151:	6a 27                	push   $0x27
  800153:	68 fc 33 80 00       	push   $0x8033fc
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 a3 18 00 00       	call   801a05 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 7c 34 80 00       	push   $0x80347c
  800173:	6a 28                	push   $0x28
  800175:	68 fc 33 80 00       	push   $0x8033fc
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 88 19 00 00       	call   801b0c <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 10 35 80 00       	push   $0x803510
  800196:	6a 2b                	push   $0x2b
  800198:	68 fc 33 80 00       	push   $0x8033fc
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 4b 19 00 00       	call   801af2 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 59 18 00 00       	call   801a05 <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 47 35 80 00       	push   $0x803547
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 06 16 00 00       	call   8017c5 <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 1c 34 80 00       	push   $0x80341c
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 fc 33 80 00       	push   $0x8033fc
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 1e 18 00 00       	call   801a05 <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 7c 34 80 00       	push   $0x80347c
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 fc 33 80 00       	push   $0x8033fc
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 03 19 00 00       	call   801b0c <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 10 35 80 00       	push   $0x803510
  80021b:	6a 34                	push   $0x34
  80021d:	68 fc 33 80 00       	push   $0x8033fc
  800222:	e8 76 01 00 00       	call   80039d <_panic>

	*z = *x + *y ;
  800227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022a:	8b 10                	mov    (%eax),%edx
  80022c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	01 c2                	add    %eax,%edx
  800233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800236:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	83 f8 1e             	cmp    $0x1e,%eax
  800240:	74 14                	je     800256 <_main+0x21e>
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 10 35 80 00       	push   $0x803510
  80024a:	6a 37                	push   $0x37
  80024c:	68 fc 33 80 00       	push   $0x8033fc
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 c8 1b 00 00       	call   801e23 <inctst>

	return;
  80025b:	90                   	nop
}
  80025c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800267:	e8 79 1a 00 00       	call   801ce5 <sys_getenvindex>
  80026c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80026f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800272:	89 d0                	mov    %edx,%eax
  800274:	c1 e0 03             	shl    $0x3,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	01 c0                	add    %eax,%eax
  80027b:	01 d0                	add    %edx,%eax
  80027d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800284:	01 d0                	add    %edx,%eax
  800286:	c1 e0 04             	shl    $0x4,%eax
  800289:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800293:	a1 20 40 80 00       	mov    0x804020,%eax
  800298:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80029e:	84 c0                	test   %al,%al
  8002a0:	74 0f                	je     8002b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8002ac:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b5:	7e 0a                	jle    8002c1 <libmain+0x60>
		binaryname = argv[0];
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 0c             	pushl  0xc(%ebp)
  8002c7:	ff 75 08             	pushl  0x8(%ebp)
  8002ca:	e8 69 fd ff ff       	call   800038 <_main>
  8002cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d2:	e8 1b 18 00 00       	call   801af2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 64 35 80 00       	push   $0x803564
  8002df:	e8 6d 03 00 00       	call   800651 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	68 8c 35 80 00       	push   $0x80358c
  800307:	e8 45 03 00 00       	call   800651 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80030f:	a1 20 40 80 00       	mov    0x804020,%eax
  800314:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80031a:	a1 20 40 80 00       	mov    0x804020,%eax
  80031f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800325:	a1 20 40 80 00       	mov    0x804020,%eax
  80032a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800330:	51                   	push   %ecx
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	68 b4 35 80 00       	push   $0x8035b4
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 40 80 00       	mov    0x804020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 0c 36 80 00       	push   $0x80360c
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 64 35 80 00       	push   $0x803564
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 9b 17 00 00       	call   801b0c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800371:	e8 19 00 00 00       	call   80038f <exit>
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	6a 00                	push   $0x0
  800384:	e8 28 19 00 00       	call   801cb1 <sys_destroy_env>
  800389:	83 c4 10             	add    $0x10,%esp
}
  80038c:	90                   	nop
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <exit>:

void
exit(void)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800395:	e8 7d 19 00 00       	call   801d17 <sys_exit_env>
}
  80039a:	90                   	nop
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003ac:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	74 16                	je     8003cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	50                   	push   %eax
  8003be:	68 20 36 80 00       	push   $0x803620
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 40 80 00       	mov    0x804000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 25 36 80 00       	push   $0x803625
  8003dc:	e8 70 02 00 00       	call   800651 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ed:	50                   	push   %eax
  8003ee:	e8 f3 01 00 00       	call   8005e6 <vcprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	6a 00                	push   $0x0
  8003fb:	68 41 36 80 00       	push   $0x803641
  800400:	e8 e1 01 00 00       	call   8005e6 <vcprintf>
  800405:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800408:	e8 82 ff ff ff       	call   80038f <exit>

	// should not return here
	while (1) ;
  80040d:	eb fe                	jmp    80040d <_panic+0x70>

0080040f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 44 36 80 00       	push   $0x803644
  80042c:	6a 26                	push   $0x26
  80042e:	68 90 36 80 00       	push   $0x803690
  800433:	e8 65 ff ff ff       	call   80039d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80043f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800446:	e9 c2 00 00 00       	jmp    80050d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80044b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	85 c0                	test   %eax,%eax
  80045e:	75 08                	jne    800468 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800460:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800463:	e9 a2 00 00 00       	jmp    80050a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800476:	eb 69                	jmp    8004e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800478:	a1 20 40 80 00       	mov    0x804020,%eax
  80047d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800483:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800486:	89 d0                	mov    %edx,%eax
  800488:	01 c0                	add    %eax,%eax
  80048a:	01 d0                	add    %edx,%eax
  80048c:	c1 e0 03             	shl    $0x3,%eax
  80048f:	01 c8                	add    %ecx,%eax
  800491:	8a 40 04             	mov    0x4(%eax),%al
  800494:	84 c0                	test   %al,%al
  800496:	75 46                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a6:	89 d0                	mov    %edx,%eax
  8004a8:	01 c0                	add    %eax,%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	c1 e0 03             	shl    $0x3,%eax
  8004af:	01 c8                	add    %ecx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	75 09                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004dc:	eb 12                	jmp    8004f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004de:	ff 45 e8             	incl   -0x18(%ebp)
  8004e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004e6:	8b 50 74             	mov    0x74(%eax),%edx
  8004e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	77 88                	ja     800478 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004f4:	75 14                	jne    80050a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 9c 36 80 00       	push   $0x80369c
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 90 36 80 00       	push   $0x803690
  800505:	e8 93 fe ff ff       	call   80039d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80050a:	ff 45 f0             	incl   -0x10(%ebp)
  80050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800510:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800513:	0f 8c 32 ff ff ff    	jl     80044b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800519:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800520:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800527:	eb 26                	jmp    80054f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800529:	a1 20 40 80 00       	mov    0x804020,%eax
  80052e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	01 c0                	add    %eax,%eax
  80053b:	01 d0                	add    %edx,%eax
  80053d:	c1 e0 03             	shl    $0x3,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	8a 40 04             	mov    0x4(%eax),%al
  800545:	3c 01                	cmp    $0x1,%al
  800547:	75 03                	jne    80054c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800549:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054c:	ff 45 e0             	incl   -0x20(%ebp)
  80054f:	a1 20 40 80 00       	mov    0x804020,%eax
  800554:	8b 50 74             	mov    0x74(%eax),%edx
  800557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055a:	39 c2                	cmp    %eax,%edx
  80055c:	77 cb                	ja     800529 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800561:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800564:	74 14                	je     80057a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800566:	83 ec 04             	sub    $0x4,%esp
  800569:	68 f0 36 80 00       	push   $0x8036f0
  80056e:	6a 44                	push   $0x44
  800570:	68 90 36 80 00       	push   $0x803690
  800575:	e8 23 fe ff ff       	call   80039d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80057a:	90                   	nop
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	8d 48 01             	lea    0x1(%eax),%ecx
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	89 0a                	mov    %ecx,(%edx)
  800590:	8b 55 08             	mov    0x8(%ebp),%edx
  800593:	88 d1                	mov    %dl,%cl
  800595:	8b 55 0c             	mov    0xc(%ebp),%edx
  800598:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a6:	75 2c                	jne    8005d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005a8:	a0 24 40 80 00       	mov    0x804024,%al
  8005ad:	0f b6 c0             	movzbl %al,%eax
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	8b 12                	mov    (%edx),%edx
  8005b5:	89 d1                	mov    %edx,%ecx
  8005b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ba:	83 c2 08             	add    $0x8,%edx
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	50                   	push   %eax
  8005c1:	51                   	push   %ecx
  8005c2:	52                   	push   %edx
  8005c3:	e8 7c 13 00 00       	call   801944 <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d7:	8b 40 04             	mov    0x4(%eax),%eax
  8005da:	8d 50 01             	lea    0x1(%eax),%edx
  8005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e3:	90                   	nop
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f6:	00 00 00 
	b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800600:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060f:	50                   	push   %eax
  800610:	68 7d 05 80 00       	push   $0x80057d
  800615:	e8 11 02 00 00       	call   80082b <vprintfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80061d:	a0 24 40 80 00       	mov    0x804024,%al
  800622:	0f b6 c0             	movzbl %al,%eax
  800625:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80062b:	83 ec 04             	sub    $0x4,%esp
  80062e:	50                   	push   %eax
  80062f:	52                   	push   %edx
  800630:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800636:	83 c0 08             	add    $0x8,%eax
  800639:	50                   	push   %eax
  80063a:	e8 05 13 00 00       	call   801944 <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800642:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800649:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <cprintf>:

int cprintf(const char *fmt, ...) {
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800657:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80065e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 f4             	pushl  -0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	e8 73 ff ff ff       	call   8005e6 <vcprintf>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800684:	e8 69 14 00 00       	call   801af2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800689:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 f4             	pushl  -0xc(%ebp)
  800698:	50                   	push   %eax
  800699:	e8 48 ff ff ff       	call   8005e6 <vcprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006a4:	e8 63 14 00 00       	call   801b0c <sys_enable_interrupt>
	return cnt;
  8006a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 14             	sub    $0x14,%esp
  8006b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006cc:	77 55                	ja     800723 <printnum+0x75>
  8006ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d1:	72 05                	jb     8006d8 <printnum+0x2a>
  8006d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006d6:	77 4b                	ja     800723 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006de:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ee:	e8 81 2a 00 00       	call   803174 <__udivdi3>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	53                   	push   %ebx
  8006fd:	ff 75 18             	pushl  0x18(%ebp)
  800700:	52                   	push   %edx
  800701:	50                   	push   %eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	e8 a1 ff ff ff       	call   8006ae <printnum>
  80070d:	83 c4 20             	add    $0x20,%esp
  800710:	eb 1a                	jmp    80072c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 20             	pushl  0x20(%ebp)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	ff d0                	call   *%eax
  800720:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800723:	ff 4d 1c             	decl   0x1c(%ebp)
  800726:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80072a:	7f e6                	jg     800712 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80072c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80072f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	53                   	push   %ebx
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	e8 41 2b 00 00       	call   803284 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 54 39 80 00       	add    $0x803954,%eax
  80074b:	8a 00                	mov    (%eax),%al
  80074d:	0f be c0             	movsbl %al,%eax
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	50                   	push   %eax
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
}
  80075f:	90                   	nop
  800760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800768:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076c:	7e 1c                	jle    80078a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	8d 50 08             	lea    0x8(%eax),%edx
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	89 10                	mov    %edx,(%eax)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	83 e8 08             	sub    $0x8,%eax
  800783:	8b 50 04             	mov    0x4(%eax),%edx
  800786:	8b 00                	mov    (%eax),%eax
  800788:	eb 40                	jmp    8007ca <getuint+0x65>
	else if (lflag)
  80078a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078e:	74 1e                	je     8007ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	8d 50 04             	lea    0x4(%eax),%edx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	89 10                	mov    %edx,(%eax)
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	83 e8 04             	sub    $0x4,%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	eb 1c                	jmp    8007ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d3:	7e 1c                	jle    8007f1 <getint+0x25>
		return va_arg(*ap, long long);
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	8d 50 08             	lea    0x8(%eax),%edx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	89 10                	mov    %edx,(%eax)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	83 e8 08             	sub    $0x8,%eax
  8007ea:	8b 50 04             	mov    0x4(%eax),%edx
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	eb 38                	jmp    800829 <getint+0x5d>
	else if (lflag)
  8007f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f5:	74 1a                	je     800811 <getint+0x45>
		return va_arg(*ap, long);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	8d 50 04             	lea    0x4(%eax),%edx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 10                	mov    %edx,(%eax)
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	83 e8 04             	sub    $0x4,%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	99                   	cltd   
  80080f:	eb 18                	jmp    800829 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	99                   	cltd   
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	56                   	push   %esi
  80082f:	53                   	push   %ebx
  800830:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800833:	eb 17                	jmp    80084c <vprintfmt+0x21>
			if (ch == '\0')
  800835:	85 db                	test   %ebx,%ebx
  800837:	0f 84 af 03 00 00    	je     800bec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	83 fb 25             	cmp    $0x25,%ebx
  80085d:	75 d6                	jne    800835 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800863:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80086a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800871:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800878:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	89 55 10             	mov    %edx,0x10(%ebp)
  800888:	8a 00                	mov    (%eax),%al
  80088a:	0f b6 d8             	movzbl %al,%ebx
  80088d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800890:	83 f8 55             	cmp    $0x55,%eax
  800893:	0f 87 2b 03 00 00    	ja     800bc4 <vprintfmt+0x399>
  800899:	8b 04 85 78 39 80 00 	mov    0x803978(,%eax,4),%eax
  8008a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008a6:	eb d7                	jmp    80087f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ac:	eb d1                	jmp    80087f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	c1 e0 02             	shl    $0x2,%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	01 c0                	add    %eax,%eax
  8008c1:	01 d8                	add    %ebx,%eax
  8008c3:	83 e8 30             	sub    $0x30,%eax
  8008c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	8a 00                	mov    (%eax),%al
  8008ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d4:	7e 3e                	jle    800914 <vprintfmt+0xe9>
  8008d6:	83 fb 39             	cmp    $0x39,%ebx
  8008d9:	7f 39                	jg     800914 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008de:	eb d5                	jmp    8008b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 c0 04             	add    $0x4,%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f4:	eb 1f                	jmp    800915 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	79 83                	jns    80087f <vprintfmt+0x54>
				width = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800903:	e9 77 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800908:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80090f:	e9 6b ff ff ff       	jmp    80087f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800914:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800919:	0f 89 60 ff ff ff    	jns    80087f <vprintfmt+0x54>
				width = precision, precision = -1;
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800925:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80092c:	e9 4e ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800931:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800934:	e9 46 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	50                   	push   %eax
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			break;
  800959:	e9 89 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 c0 04             	add    $0x4,%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	83 e8 04             	sub    $0x4,%eax
  80096d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80096f:	85 db                	test   %ebx,%ebx
  800971:	79 02                	jns    800975 <vprintfmt+0x14a>
				err = -err;
  800973:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800975:	83 fb 64             	cmp    $0x64,%ebx
  800978:	7f 0b                	jg     800985 <vprintfmt+0x15a>
  80097a:	8b 34 9d c0 37 80 00 	mov    0x8037c0(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 65 39 80 00       	push   $0x803965
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 5e 02 00 00       	call   800bf4 <printfmt>
  800996:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800999:	e9 49 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80099e:	56                   	push   %esi
  80099f:	68 6e 39 80 00       	push   $0x80396e
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 45 02 00 00       	call   800bf4 <printfmt>
  8009af:	83 c4 10             	add    $0x10,%esp
			break;
  8009b2:	e9 30 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	83 c0 04             	add    $0x4,%eax
  8009bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 30                	mov    (%eax),%esi
  8009c8:	85 f6                	test   %esi,%esi
  8009ca:	75 05                	jne    8009d1 <vprintfmt+0x1a6>
				p = "(null)";
  8009cc:	be 71 39 80 00       	mov    $0x803971,%esi
			if (width > 0 && padc != '-')
  8009d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d5:	7e 6d                	jle    800a44 <vprintfmt+0x219>
  8009d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009db:	74 67                	je     800a44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	50                   	push   %eax
  8009e4:	56                   	push   %esi
  8009e5:	e8 0c 03 00 00       	call   800cf6 <strnlen>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f0:	eb 16                	jmp    800a08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a05:	ff 4d e4             	decl   -0x1c(%ebp)
  800a08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0c:	7f e4                	jg     8009f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	eb 34                	jmp    800a44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a14:	74 1c                	je     800a32 <vprintfmt+0x207>
  800a16:	83 fb 1f             	cmp    $0x1f,%ebx
  800a19:	7e 05                	jle    800a20 <vprintfmt+0x1f5>
  800a1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a1e:	7e 12                	jle    800a32 <vprintfmt+0x207>
					putch('?', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 3f                	push   $0x3f
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	eb 0f                	jmp    800a41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	53                   	push   %ebx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a41:	ff 4d e4             	decl   -0x1c(%ebp)
  800a44:	89 f0                	mov    %esi,%eax
  800a46:	8d 70 01             	lea    0x1(%eax),%esi
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	0f be d8             	movsbl %al,%ebx
  800a4e:	85 db                	test   %ebx,%ebx
  800a50:	74 24                	je     800a76 <vprintfmt+0x24b>
  800a52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a56:	78 b8                	js     800a10 <vprintfmt+0x1e5>
  800a58:	ff 4d e0             	decl   -0x20(%ebp)
  800a5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5f:	79 af                	jns    800a10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	eb 13                	jmp    800a76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	6a 20                	push   $0x20
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7a:	7f e7                	jg     800a63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a7c:	e9 66 01 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 e8             	pushl  -0x18(%ebp)
  800a87:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8a:	50                   	push   %eax
  800a8b:	e8 3c fd ff ff       	call   8007cc <getint>
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9f:	85 d2                	test   %edx,%edx
  800aa1:	79 23                	jns    800ac6 <vprintfmt+0x29b>
				putch('-', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 2d                	push   $0x2d
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab9:	f7 d8                	neg    %eax
  800abb:	83 d2 00             	adc    $0x0,%edx
  800abe:	f7 da                	neg    %edx
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ac6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800acd:	e9 bc 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad8:	8d 45 14             	lea    0x14(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 84 fc ff ff       	call   800765 <getuint>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af1:	e9 98 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 58                	push   $0x58
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 58                	push   $0x58
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 58                	push   $0x58
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			break;
  800b26:	e9 bc 00 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 30                	push   $0x30
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 78                	push   $0x78
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b6d:	eb 1f                	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 e8             	pushl  -0x18(%ebp)
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	e8 e7 fb ff ff       	call   800765 <getuint>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	52                   	push   %edx
  800b99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b9c:	50                   	push   %eax
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 00 fb ff ff       	call   8006ae <printnum>
  800bae:	83 c4 20             	add    $0x20,%esp
			break;
  800bb1:	eb 34                	jmp    800be7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			break;
  800bc2:	eb 23                	jmp    800be7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 25                	push   $0x25
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd4:	ff 4d 10             	decl   0x10(%ebp)
  800bd7:	eb 03                	jmp    800bdc <vprintfmt+0x3b1>
  800bd9:	ff 4d 10             	decl   0x10(%ebp)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	48                   	dec    %eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	3c 25                	cmp    $0x25,%al
  800be4:	75 f3                	jne    800bd9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800be6:	90                   	nop
		}
	}
  800be7:	e9 47 fc ff ff       	jmp    800833 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	ff 75 f4             	pushl  -0xc(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 16 fc ff ff       	call   80082b <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c18:	90                   	nop
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 40 08             	mov    0x8(%eax),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 10                	mov    (%eax),%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8b 40 04             	mov    0x4(%eax),%eax
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	73 12                	jae    800c4e <sprintputch+0x33>
		*b->buf++ = ch;
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	8d 48 01             	lea    0x1(%eax),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 0a                	mov    %ecx,(%edx)
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	88 10                	mov    %dl,(%eax)
}
  800c4e:	90                   	nop
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	01 d0                	add    %edx,%eax
  800c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c76:	74 06                	je     800c7e <vsnprintf+0x2d>
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	7f 07                	jg     800c85 <vsnprintf+0x34>
		return -E_INVAL;
  800c7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c83:	eb 20                	jmp    800ca5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c85:	ff 75 14             	pushl  0x14(%ebp)
  800c88:	ff 75 10             	pushl  0x10(%ebp)
  800c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	68 1b 0c 80 00       	push   $0x800c1b
  800c94:	e8 92 fb ff ff       	call   80082b <vprintfmt>
  800c99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cad:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb0:	83 c0 04             	add    $0x4,%eax
  800cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 89 ff ff ff       	call   800c51 <vsnprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 06                	jmp    800ce8 <strlen+0x15>
		n++;
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 f1                	jne    800ce2 <strlen+0xf>
		n++;
	return n;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d03:	eb 09                	jmp    800d0e <strnlen+0x18>
		n++;
  800d05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d08:	ff 45 08             	incl   0x8(%ebp)
  800d0b:	ff 4d 0c             	decl   0xc(%ebp)
  800d0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d12:	74 09                	je     800d1d <strnlen+0x27>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	75 e8                	jne    800d05 <strnlen+0xf>
		n++;
	return n;
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d2e:	90                   	nop
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 08             	mov    %edx,0x8(%ebp)
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 e4                	jne    800d2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d63:	eb 1f                	jmp    800d84 <strncpy+0x34>
		*dst++ = *src;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 03                	je     800d81 <strncpy+0x31>
			src++;
  800d7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d81:	ff 45 fc             	incl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8a:	72 d9                	jb     800d65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 30                	je     800dd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da3:	eb 16                	jmp    800dbb <strlcpy+0x2a>
			*dst++ = *src++;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 08             	mov    %edx,0x8(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dbb:	ff 4d 10             	decl   0x10(%ebp)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	74 09                	je     800dcd <strlcpy+0x3c>
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 d8                	jne    800da5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de2:	eb 06                	jmp    800dea <strcmp+0xb>
		p++, q++;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 0e                	je     800e01 <strcmp+0x22>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 10                	mov    (%eax),%dl
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	38 c2                	cmp    %al,%dl
  800dff:	74 e3                	je     800de4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	0f b6 d0             	movzbl %al,%edx
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	0f b6 c0             	movzbl %al,%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e1a:	eb 09                	jmp    800e25 <strncmp+0xe>
		n--, p++, q++;
  800e1c:	ff 4d 10             	decl   0x10(%ebp)
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 17                	je     800e42 <strncmp+0x2b>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	74 0e                	je     800e42 <strncmp+0x2b>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 10                	mov    (%eax),%dl
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	38 c2                	cmp    %al,%dl
  800e40:	74 da                	je     800e1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strncmp+0x38>
		return 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	eb 14                	jmp    800e63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f b6 d0             	movzbl %al,%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 c0             	movzbl %al,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
}
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e71:	eb 12                	jmp    800e85 <strchr+0x20>
		if (*s == c)
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7b:	75 05                	jne    800e82 <strchr+0x1d>
			return (char *) s;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	eb 11                	jmp    800e93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e5                	jne    800e73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea1:	eb 0d                	jmp    800eb0 <strfind+0x1b>
		if (*s == c)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eab:	74 0e                	je     800ebb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ead:	ff 45 08             	incl   0x8(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 ea                	jne    800ea3 <strfind+0xe>
  800eb9:	eb 01                	jmp    800ebc <strfind+0x27>
		if (*s == c)
			break;
  800ebb:	90                   	nop
	return (char *) s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ed3:	eb 0e                	jmp    800ee3 <memset+0x22>
		*p++ = c;
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ee3:	ff 4d f8             	decl   -0x8(%ebp)
  800ee6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eea:	79 e9                	jns    800ed5 <memset+0x14>
		*p++ = c;

	return v;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f03:	eb 16                	jmp    800f1b <memcpy+0x2a>
		*d++ = *s++;
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f17:	8a 12                	mov    (%edx),%dl
  800f19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 dd                	jne    800f05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	73 50                	jae    800f97 <memmove+0x6a>
  800f47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f52:	76 43                	jbe    800f97 <memmove+0x6a>
		s += n;
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f60:	eb 10                	jmp    800f72 <memmove+0x45>
			*--d = *--s;
  800f62:	ff 4d f8             	decl   -0x8(%ebp)
  800f65:	ff 4d fc             	decl   -0x4(%ebp)
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6b:	8a 10                	mov    (%eax),%dl
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 e3                	jne    800f62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f7f:	eb 23                	jmp    800fa4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f84:	8d 50 01             	lea    0x1(%eax),%edx
  800f87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f93:	8a 12                	mov    (%edx),%dl
  800f95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 dd                	jne    800f81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fbb:	eb 2a                	jmp    800fe7 <memcmp+0x3e>
		if (*s1 != *s2)
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc0:	8a 10                	mov    (%eax),%dl
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	38 c2                	cmp    %al,%dl
  800fc9:	74 16                	je     800fe1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 d0             	movzbl %al,%edx
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	eb 18                	jmp    800ff9 <memcmp+0x50>
		s1++, s2++;
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 c9                	jne    800fbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80100c:	eb 15                	jmp    801023 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f b6 d0             	movzbl %al,%edx
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	0f b6 c0             	movzbl %al,%eax
  80101c:	39 c2                	cmp    %eax,%edx
  80101e:	74 0d                	je     80102d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801029:	72 e3                	jb     80100e <memfind+0x13>
  80102b:	eb 01                	jmp    80102e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80102d:	90                   	nop
	return (void *) s;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801040:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801047:	eb 03                	jmp    80104c <strtol+0x19>
		s++;
  801049:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	3c 20                	cmp    $0x20,%al
  801053:	74 f4                	je     801049 <strtol+0x16>
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	3c 09                	cmp    $0x9,%al
  80105c:	74 eb                	je     801049 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 2b                	cmp    $0x2b,%al
  801065:	75 05                	jne    80106c <strtol+0x39>
		s++;
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	eb 13                	jmp    80107f <strtol+0x4c>
	else if (*s == '-')
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 2d                	cmp    $0x2d,%al
  801073:	75 0a                	jne    80107f <strtol+0x4c>
		s++, neg = 1;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80107f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801083:	74 06                	je     80108b <strtol+0x58>
  801085:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801089:	75 20                	jne    8010ab <strtol+0x78>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 30                	cmp    $0x30,%al
  801092:	75 17                	jne    8010ab <strtol+0x78>
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	40                   	inc    %eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 78                	cmp    $0x78,%al
  80109c:	75 0d                	jne    8010ab <strtol+0x78>
		s += 2, base = 16;
  80109e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010a2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010a9:	eb 28                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010af:	75 15                	jne    8010c6 <strtol+0x93>
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 30                	cmp    $0x30,%al
  8010b8:	75 0c                	jne    8010c6 <strtol+0x93>
		s++, base = 8;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010c4:	eb 0d                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0)
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	75 07                	jne    8010d3 <strtol+0xa0>
		base = 10;
  8010cc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2f                	cmp    $0x2f,%al
  8010da:	7e 19                	jle    8010f5 <strtol+0xc2>
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 39                	cmp    $0x39,%al
  8010e3:	7f 10                	jg     8010f5 <strtol+0xc2>
			dig = *s - '0';
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	0f be c0             	movsbl %al,%eax
  8010ed:	83 e8 30             	sub    $0x30,%eax
  8010f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f3:	eb 42                	jmp    801137 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 60                	cmp    $0x60,%al
  8010fc:	7e 19                	jle    801117 <strtol+0xe4>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 7a                	cmp    $0x7a,%al
  801105:	7f 10                	jg     801117 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f be c0             	movsbl %al,%eax
  80110f:	83 e8 57             	sub    $0x57,%eax
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801115:	eb 20                	jmp    801137 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 40                	cmp    $0x40,%al
  80111e:	7e 39                	jle    801159 <strtol+0x126>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 5a                	cmp    $0x5a,%al
  801127:	7f 30                	jg     801159 <strtol+0x126>
			dig = *s - 'A' + 10;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f be c0             	movsbl %al,%eax
  801131:	83 e8 37             	sub    $0x37,%eax
  801134:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80113d:	7d 19                	jge    801158 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80113f:	ff 45 08             	incl   0x8(%ebp)
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	0f af 45 10          	imul   0x10(%ebp),%eax
  801149:	89 c2                	mov    %eax,%edx
  80114b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801153:	e9 7b ff ff ff       	jmp    8010d3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801158:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801159:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115d:	74 08                	je     801167 <strtol+0x134>
		*endptr = (char *) s;
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8b 55 08             	mov    0x8(%ebp),%edx
  801165:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801167:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80116b:	74 07                	je     801174 <strtol+0x141>
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	f7 d8                	neg    %eax
  801172:	eb 03                	jmp    801177 <strtol+0x144>
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <ltostr>:

void
ltostr(long value, char *str)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80118d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801191:	79 13                	jns    8011a6 <ltostr+0x2d>
	{
		neg = 1;
  801193:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ae:	99                   	cltd   
  8011af:	f7 f9                	idiv   %ecx
  8011b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011c7:	83 c2 30             	add    $0x30,%edx
  8011ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011d4:	f7 e9                	imul   %ecx
  8011d6:	c1 fa 02             	sar    $0x2,%edx
  8011d9:	89 c8                	mov    %ecx,%eax
  8011db:	c1 f8 1f             	sar    $0x1f,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ed:	f7 e9                	imul   %ecx
  8011ef:	c1 fa 02             	sar    $0x2,%edx
  8011f2:	89 c8                	mov    %ecx,%eax
  8011f4:	c1 f8 1f             	sar    $0x1f,%eax
  8011f7:	29 c2                	sub    %eax,%edx
  8011f9:	89 d0                	mov    %edx,%eax
  8011fb:	c1 e0 02             	shl    $0x2,%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	01 c0                	add    %eax,%eax
  801202:	29 c1                	sub    %eax,%ecx
  801204:	89 ca                	mov    %ecx,%edx
  801206:	85 d2                	test   %edx,%edx
  801208:	75 9c                	jne    8011a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80120a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	48                   	dec    %eax
  801215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121c:	74 3d                	je     80125b <ltostr+0xe2>
		start = 1 ;
  80121e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801225:	eb 34                	jmp    80125b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 c2                	add    %eax,%edx
  80123c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 c8                	add    %ecx,%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8a 45 eb             	mov    -0x15(%ebp),%al
  801253:	88 02                	mov    %al,(%edx)
		start++ ;
  801255:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801258:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801261:	7c c4                	jl     801227 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801263:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80126e:	90                   	nop
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801277:	ff 75 08             	pushl  0x8(%ebp)
  80127a:	e8 54 fa ff ff       	call   800cd3 <strlen>
  80127f:	83 c4 04             	add    $0x4,%esp
  801282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	e8 46 fa ff ff       	call   800cd3 <strlen>
  80128d:	83 c4 04             	add    $0x4,%esp
  801290:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80129a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a1:	eb 17                	jmp    8012ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	01 c2                	add    %eax,%edx
  8012ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	01 c8                	add    %ecx,%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b7:	ff 45 fc             	incl   -0x4(%ebp)
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c0:	7c e1                	jl     8012a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d0:	eb 1f                	jmp    8012f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 c2                	add    %eax,%edx
  8012e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e8:	01 c8                	add    %ecx,%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ee:	ff 45 f8             	incl   -0x8(%ebp)
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f7:	7c d9                	jl     8012d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 d0                	add    %edx,%eax
  801301:	c6 00 00             	movb   $0x0,(%eax)
}
  801304:	90                   	nop
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	8b 00                	mov    (%eax),%eax
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132a:	eb 0c                	jmp    801338 <strsplit+0x31>
			*string++ = 0;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8d 50 01             	lea    0x1(%eax),%edx
  801332:	89 55 08             	mov    %edx,0x8(%ebp)
  801335:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 18                	je     801359 <strsplit+0x52>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	0f be c0             	movsbl %al,%eax
  801349:	50                   	push   %eax
  80134a:	ff 75 0c             	pushl  0xc(%ebp)
  80134d:	e8 13 fb ff ff       	call   800e65 <strchr>
  801352:	83 c4 08             	add    $0x8,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	75 d3                	jne    80132c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 5a                	je     8013bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	83 f8 0f             	cmp    $0xf,%eax
  80136a:	75 07                	jne    801373 <strsplit+0x6c>
		{
			return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
  801371:	eb 66                	jmp    8013d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	8d 48 01             	lea    0x1(%eax),%ecx
  80137b:	8b 55 14             	mov    0x14(%ebp),%edx
  80137e:	89 0a                	mov    %ecx,(%edx)
  801380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 c2                	add    %eax,%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801391:	eb 03                	jmp    801396 <strsplit+0x8f>
			string++;
  801393:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	84 c0                	test   %al,%al
  80139d:	74 8b                	je     80132a <strsplit+0x23>
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	0f be c0             	movsbl %al,%eax
  8013a7:	50                   	push   %eax
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	e8 b5 fa ff ff       	call   800e65 <strchr>
  8013b0:	83 c4 08             	add    $0x8,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 dc                	je     801393 <strsplit+0x8c>
			string++;
	}
  8013b7:	e9 6e ff ff ff       	jmp    80132a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	74 1f                	je     801409 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013ea:	e8 1d 00 00 00       	call   80140c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	68 d0 3a 80 00       	push   $0x803ad0
  8013f7:	e8 55 f2 ff ff       	call   800651 <cprintf>
  8013fc:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013ff:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801406:	00 00 00 
	}
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801412:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801419:	00 00 00 
  80141c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801423:	00 00 00 
  801426:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80142d:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801430:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801437:	00 00 00 
  80143a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801441:	00 00 00 
  801444:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80144b:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80144e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801455:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801458:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80145f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801469:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80146e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801473:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801478:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80147f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801482:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801487:	2d 00 10 00 00       	sub    $0x1000,%eax
  80148c:	83 ec 04             	sub    $0x4,%esp
  80148f:	6a 06                	push   $0x6
  801491:	ff 75 f4             	pushl  -0xc(%ebp)
  801494:	50                   	push   %eax
  801495:	e8 ee 05 00 00       	call   801a88 <sys_allocate_chunk>
  80149a:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80149d:	a1 20 41 80 00       	mov    0x804120,%eax
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	50                   	push   %eax
  8014a6:	e8 63 0c 00 00       	call   80210e <initialize_MemBlocksList>
  8014ab:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8014ae:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8014b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8014c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8014c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014d1:	89 c2                	mov    %eax,%edx
  8014d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014d6:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8014d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014dc:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8014e3:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ed:	8b 50 08             	mov    0x8(%eax),%edx
  8014f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f3:	01 d0                	add    %edx,%eax
  8014f5:	48                   	dec    %eax
  8014f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801501:	f7 75 e0             	divl   -0x20(%ebp)
  801504:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801507:	29 d0                	sub    %edx,%eax
  801509:	89 c2                	mov    %eax,%edx
  80150b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150e:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801511:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801515:	75 14                	jne    80152b <initialize_dyn_block_system+0x11f>
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 f5 3a 80 00       	push   $0x803af5
  80151f:	6a 34                	push   $0x34
  801521:	68 13 3b 80 00       	push   $0x803b13
  801526:	e8 72 ee ff ff       	call   80039d <_panic>
  80152b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80152e:	8b 00                	mov    (%eax),%eax
  801530:	85 c0                	test   %eax,%eax
  801532:	74 10                	je     801544 <initialize_dyn_block_system+0x138>
  801534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801537:	8b 00                	mov    (%eax),%eax
  801539:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80153c:	8b 52 04             	mov    0x4(%edx),%edx
  80153f:	89 50 04             	mov    %edx,0x4(%eax)
  801542:	eb 0b                	jmp    80154f <initialize_dyn_block_system+0x143>
  801544:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801547:	8b 40 04             	mov    0x4(%eax),%eax
  80154a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80154f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801552:	8b 40 04             	mov    0x4(%eax),%eax
  801555:	85 c0                	test   %eax,%eax
  801557:	74 0f                	je     801568 <initialize_dyn_block_system+0x15c>
  801559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80155c:	8b 40 04             	mov    0x4(%eax),%eax
  80155f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801562:	8b 12                	mov    (%edx),%edx
  801564:	89 10                	mov    %edx,(%eax)
  801566:	eb 0a                	jmp    801572 <initialize_dyn_block_system+0x166>
  801568:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156b:	8b 00                	mov    (%eax),%eax
  80156d:	a3 48 41 80 00       	mov    %eax,0x804148
  801572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801575:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80157b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80157e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801585:	a1 54 41 80 00       	mov    0x804154,%eax
  80158a:	48                   	dec    %eax
  80158b:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801590:	83 ec 0c             	sub    $0xc,%esp
  801593:	ff 75 e8             	pushl  -0x18(%ebp)
  801596:	e8 c4 13 00 00       	call   80295f <insert_sorted_with_merge_freeList>
  80159b:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80159e:	90                   	nop
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a7:	e8 2f fe ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b0:	75 07                	jne    8015b9 <malloc+0x18>
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 71                	jmp    80162a <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8015b9:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015c0:	76 07                	jbe    8015c9 <malloc+0x28>
	return NULL;
  8015c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c7:	eb 61                	jmp    80162a <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015c9:	e8 88 08 00 00       	call   801e56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	74 53                	je     801625 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8015d2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	48                   	dec    %eax
  8015e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ed:	f7 75 f4             	divl   -0xc(%ebp)
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f3:	29 d0                	sub    %edx,%eax
  8015f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8015fe:	e8 d2 0d 00 00       	call   8023d5 <alloc_block_FF>
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801609:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80160d:	74 16                	je     801625 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	ff 75 e8             	pushl  -0x18(%ebp)
  801615:	e8 0c 0c 00 00       	call   802226 <insert_sorted_allocList>
  80161a:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80161d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801620:	8b 40 08             	mov    0x8(%eax),%eax
  801623:	eb 05                	jmp    80162a <malloc+0x89>
    }

			}


	return NULL;
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801640:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801643:	83 ec 08             	sub    $0x8,%esp
  801646:	ff 75 f0             	pushl  -0x10(%ebp)
  801649:	68 40 40 80 00       	push   $0x804040
  80164e:	e8 a0 0b 00 00       	call   8021f3 <find_block>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165c:	8b 50 0c             	mov    0xc(%eax),%edx
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	52                   	push   %edx
  801666:	50                   	push   %eax
  801667:	e8 e4 03 00 00       	call   801a50 <sys_free_user_mem>
  80166c:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80166f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801673:	75 17                	jne    80168c <free+0x60>
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	68 f5 3a 80 00       	push   $0x803af5
  80167d:	68 84 00 00 00       	push   $0x84
  801682:	68 13 3b 80 00       	push   $0x803b13
  801687:	e8 11 ed ff ff       	call   80039d <_panic>
  80168c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168f:	8b 00                	mov    (%eax),%eax
  801691:	85 c0                	test   %eax,%eax
  801693:	74 10                	je     8016a5 <free+0x79>
  801695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801698:	8b 00                	mov    (%eax),%eax
  80169a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80169d:	8b 52 04             	mov    0x4(%edx),%edx
  8016a0:	89 50 04             	mov    %edx,0x4(%eax)
  8016a3:	eb 0b                	jmp    8016b0 <free+0x84>
  8016a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a8:	8b 40 04             	mov    0x4(%eax),%eax
  8016ab:	a3 44 40 80 00       	mov    %eax,0x804044
  8016b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b3:	8b 40 04             	mov    0x4(%eax),%eax
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	74 0f                	je     8016c9 <free+0x9d>
  8016ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bd:	8b 40 04             	mov    0x4(%eax),%eax
  8016c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016c3:	8b 12                	mov    (%edx),%edx
  8016c5:	89 10                	mov    %edx,(%eax)
  8016c7:	eb 0a                	jmp    8016d3 <free+0xa7>
  8016c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cc:	8b 00                	mov    (%eax),%eax
  8016ce:	a3 40 40 80 00       	mov    %eax,0x804040
  8016d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016e6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016eb:	48                   	dec    %eax
  8016ec:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  8016f1:	83 ec 0c             	sub    $0xc,%esp
  8016f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f7:	e8 63 12 00 00       	call   80295f <insert_sorted_with_merge_freeList>
  8016fc:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8016ff:	90                   	nop
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 38             	sub    $0x38,%esp
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80170e:	e8 c8 fc ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  801713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801717:	75 0a                	jne    801723 <smalloc+0x21>
  801719:	b8 00 00 00 00       	mov    $0x0,%eax
  80171e:	e9 a0 00 00 00       	jmp    8017c3 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801723:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80172a:	76 0a                	jbe    801736 <smalloc+0x34>
		return NULL;
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
  801731:	e9 8d 00 00 00       	jmp    8017c3 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801736:	e8 1b 07 00 00       	call   801e56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80173b:	85 c0                	test   %eax,%eax
  80173d:	74 7f                	je     8017be <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80173f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801746:	8b 55 0c             	mov    0xc(%ebp),%edx
  801749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174c:	01 d0                	add    %edx,%eax
  80174e:	48                   	dec    %eax
  80174f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	ba 00 00 00 00       	mov    $0x0,%edx
  80175a:	f7 75 f4             	divl   -0xc(%ebp)
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	29 d0                	sub    %edx,%eax
  801762:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801765:	83 ec 0c             	sub    $0xc,%esp
  801768:	ff 75 ec             	pushl  -0x14(%ebp)
  80176b:	e8 65 0c 00 00       	call   8023d5 <alloc_block_FF>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801776:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80177a:	74 42                	je     8017be <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  80177c:	83 ec 0c             	sub    $0xc,%esp
  80177f:	ff 75 e8             	pushl  -0x18(%ebp)
  801782:	e8 9f 0a 00 00       	call   802226 <insert_sorted_allocList>
  801787:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  80178a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178d:	8b 40 08             	mov    0x8(%eax),%eax
  801790:	89 c2                	mov    %eax,%edx
  801792:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801796:	52                   	push   %edx
  801797:	50                   	push   %eax
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	ff 75 08             	pushl  0x8(%ebp)
  80179e:	e8 38 04 00 00       	call   801bdb <sys_createSharedObject>
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8017a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017ad:	79 07                	jns    8017b6 <smalloc+0xb4>
	    		  return NULL;
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b4:	eb 0d                	jmp    8017c3 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8017b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b9:	8b 40 08             	mov    0x8(%eax),%eax
  8017bc:	eb 05                	jmp    8017c3 <smalloc+0xc1>


				}


		return NULL;
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017cb:	e8 0b fc ff ff       	call   8013db <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017d0:	e8 81 06 00 00       	call   801e56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	0f 84 9f 00 00 00    	je     80187c <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 1a 04 00 00       	call   801c05 <sys_getSizeOfSharedObject>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8017f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017f5:	79 0a                	jns    801801 <sget+0x3c>
		return NULL;
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	e9 80 00 00 00       	jmp    801881 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801801:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801808:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180e:	01 d0                	add    %edx,%eax
  801810:	48                   	dec    %eax
  801811:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801814:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801817:	ba 00 00 00 00       	mov    $0x0,%edx
  80181c:	f7 75 f0             	divl   -0x10(%ebp)
  80181f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801822:	29 d0                	sub    %edx,%eax
  801824:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801827:	83 ec 0c             	sub    $0xc,%esp
  80182a:	ff 75 e8             	pushl  -0x18(%ebp)
  80182d:	e8 a3 0b 00 00       	call   8023d5 <alloc_block_FF>
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80183c:	74 3e                	je     80187c <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80183e:	83 ec 0c             	sub    $0xc,%esp
  801841:	ff 75 e4             	pushl  -0x1c(%ebp)
  801844:	e8 dd 09 00 00       	call   802226 <insert_sorted_allocList>
  801849:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  80184c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184f:	8b 40 08             	mov    0x8(%eax),%eax
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	50                   	push   %eax
  801856:	ff 75 0c             	pushl  0xc(%ebp)
  801859:	ff 75 08             	pushl  0x8(%ebp)
  80185c:	e8 c1 03 00 00       	call   801c22 <sys_getSharedObject>
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801867:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80186b:	79 07                	jns    801874 <sget+0xaf>
	    		  return NULL;
  80186d:	b8 00 00 00 00       	mov    $0x0,%eax
  801872:	eb 0d                	jmp    801881 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801877:	8b 40 08             	mov    0x8(%eax),%eax
  80187a:	eb 05                	jmp    801881 <sget+0xbc>
	      }
	}
	   return NULL;
  80187c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801889:	e8 4d fb ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80188e:	83 ec 04             	sub    $0x4,%esp
  801891:	68 20 3b 80 00       	push   $0x803b20
  801896:	68 12 01 00 00       	push   $0x112
  80189b:	68 13 3b 80 00       	push   $0x803b13
  8018a0:	e8 f8 ea ff ff       	call   80039d <_panic>

008018a5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	68 48 3b 80 00       	push   $0x803b48
  8018b3:	68 26 01 00 00       	push   $0x126
  8018b8:	68 13 3b 80 00       	push   $0x803b13
  8018bd:	e8 db ea ff ff       	call   80039d <_panic>

008018c2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c8:	83 ec 04             	sub    $0x4,%esp
  8018cb:	68 6c 3b 80 00       	push   $0x803b6c
  8018d0:	68 31 01 00 00       	push   $0x131
  8018d5:	68 13 3b 80 00       	push   $0x803b13
  8018da:	e8 be ea ff ff       	call   80039d <_panic>

008018df <shrink>:

}
void shrink(uint32 newSize)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	68 6c 3b 80 00       	push   $0x803b6c
  8018ed:	68 36 01 00 00       	push   $0x136
  8018f2:	68 13 3b 80 00       	push   $0x803b13
  8018f7:	e8 a1 ea ff ff       	call   80039d <_panic>

008018fc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	68 6c 3b 80 00       	push   $0x803b6c
  80190a:	68 3b 01 00 00       	push   $0x13b
  80190f:	68 13 3b 80 00       	push   $0x803b13
  801914:	e8 84 ea ff ff       	call   80039d <_panic>

00801919 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	57                   	push   %edi
  80191d:	56                   	push   %esi
  80191e:	53                   	push   %ebx
  80191f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801931:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801934:	cd 30                	int    $0x30
  801936:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5f                   	pop    %edi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	8b 45 10             	mov    0x10(%ebp),%eax
  80194d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801950:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	52                   	push   %edx
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	50                   	push   %eax
  801960:	6a 00                	push   $0x0
  801962:	e8 b2 ff ff ff       	call   801919 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	90                   	nop
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_cgetc>:

int
sys_cgetc(void)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 01                	push   $0x1
  80197c:	e8 98 ff ff ff       	call   801919 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	52                   	push   %edx
  801996:	50                   	push   %eax
  801997:	6a 05                	push   $0x5
  801999:	e8 7b ff ff ff       	call   801919 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019a8:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	56                   	push   %esi
  8019b8:	53                   	push   %ebx
  8019b9:	51                   	push   %ecx
  8019ba:	52                   	push   %edx
  8019bb:	50                   	push   %eax
  8019bc:	6a 06                	push   $0x6
  8019be:	e8 56 ff ff ff       	call   801919 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c9:	5b                   	pop    %ebx
  8019ca:	5e                   	pop    %esi
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    

008019cd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	52                   	push   %edx
  8019dd:	50                   	push   %eax
  8019de:	6a 07                	push   $0x7
  8019e0:	e8 34 ff ff ff       	call   801919 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	ff 75 08             	pushl  0x8(%ebp)
  8019f9:	6a 08                	push   $0x8
  8019fb:	e8 19 ff ff ff       	call   801919 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 09                	push   $0x9
  801a14:	e8 00 ff ff ff       	call   801919 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 0a                	push   $0xa
  801a2d:	e8 e7 fe ff ff       	call   801919 <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 0b                	push   $0xb
  801a46:	e8 ce fe ff ff       	call   801919 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	6a 0f                	push   $0xf
  801a61:	e8 b3 fe ff ff       	call   801919 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
	return;
  801a69:	90                   	nop
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	ff 75 0c             	pushl  0xc(%ebp)
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 10                	push   $0x10
  801a7d:	e8 97 fe ff ff       	call   801919 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
	return ;
  801a85:	90                   	nop
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	ff 75 10             	pushl  0x10(%ebp)
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	ff 75 08             	pushl  0x8(%ebp)
  801a98:	6a 11                	push   $0x11
  801a9a:	e8 7a fe ff ff       	call   801919 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa2:	90                   	nop
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 0c                	push   $0xc
  801ab4:	e8 60 fe ff ff       	call   801919 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	ff 75 08             	pushl  0x8(%ebp)
  801acc:	6a 0d                	push   $0xd
  801ace:	e8 46 fe ff ff       	call   801919 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 0e                	push   $0xe
  801ae7:	e8 2d fe ff ff       	call   801919 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	90                   	nop
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 13                	push   $0x13
  801b01:	e8 13 fe ff ff       	call   801919 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 14                	push   $0x14
  801b1b:	e8 f9 fd ff ff       	call   801919 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	90                   	nop
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	50                   	push   %eax
  801b3f:	6a 15                	push   $0x15
  801b41:	e8 d3 fd ff ff       	call   801919 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 16                	push   $0x16
  801b5b:	e8 b9 fd ff ff       	call   801919 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	50                   	push   %eax
  801b76:	6a 17                	push   $0x17
  801b78:	e8 9c fd ff ff       	call   801919 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	52                   	push   %edx
  801b92:	50                   	push   %eax
  801b93:	6a 1a                	push   $0x1a
  801b95:	e8 7f fd ff ff       	call   801919 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	52                   	push   %edx
  801baf:	50                   	push   %eax
  801bb0:	6a 18                	push   $0x18
  801bb2:	e8 62 fd ff ff       	call   801919 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	90                   	nop
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 19                	push   $0x19
  801bd0:	e8 44 fd ff ff       	call   801919 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	90                   	nop
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 04             	sub    $0x4,%esp
  801be1:	8b 45 10             	mov    0x10(%ebp),%eax
  801be4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801be7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	6a 00                	push   $0x0
  801bf3:	51                   	push   %ecx
  801bf4:	52                   	push   %edx
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	50                   	push   %eax
  801bf9:	6a 1b                	push   $0x1b
  801bfb:	e8 19 fd ff ff       	call   801919 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	6a 1c                	push   $0x1c
  801c18:	e8 fc fc ff ff       	call   801919 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	51                   	push   %ecx
  801c33:	52                   	push   %edx
  801c34:	50                   	push   %eax
  801c35:	6a 1d                	push   $0x1d
  801c37:	e8 dd fc ff ff       	call   801919 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	6a 1e                	push   $0x1e
  801c54:	e8 c0 fc ff ff       	call   801919 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 1f                	push   $0x1f
  801c6d:	e8 a7 fc ff ff       	call   801919 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	ff 75 14             	pushl  0x14(%ebp)
  801c82:	ff 75 10             	pushl  0x10(%ebp)
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	50                   	push   %eax
  801c89:	6a 20                	push   $0x20
  801c8b:	e8 89 fc ff ff       	call   801919 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	50                   	push   %eax
  801ca4:	6a 21                	push   $0x21
  801ca6:	e8 6e fc ff ff       	call   801919 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	90                   	nop
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	50                   	push   %eax
  801cc0:	6a 22                	push   $0x22
  801cc2:	e8 52 fc ff ff       	call   801919 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 02                	push   $0x2
  801cdb:	e8 39 fc ff ff       	call   801919 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 03                	push   $0x3
  801cf4:	e8 20 fc ff ff       	call   801919 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 04                	push   $0x4
  801d0d:	e8 07 fc ff ff       	call   801919 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_exit_env>:


void sys_exit_env(void)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 23                	push   $0x23
  801d26:	e8 ee fb ff ff       	call   801919 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	90                   	nop
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3a:	8d 50 04             	lea    0x4(%eax),%edx
  801d3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	52                   	push   %edx
  801d47:	50                   	push   %eax
  801d48:	6a 24                	push   $0x24
  801d4a:	e8 ca fb ff ff       	call   801919 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return result;
  801d52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d5b:	89 01                	mov    %eax,(%ecx)
  801d5d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	c9                   	leave  
  801d64:	c2 04 00             	ret    $0x4

00801d67 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	ff 75 10             	pushl  0x10(%ebp)
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	6a 12                	push   $0x12
  801d79:	e8 9b fb ff ff       	call   801919 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d81:	90                   	nop
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 25                	push   $0x25
  801d93:	e8 81 fb ff ff       	call   801919 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801da9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	50                   	push   %eax
  801db6:	6a 26                	push   $0x26
  801db8:	e8 5c fb ff ff       	call   801919 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <rsttst>:
void rsttst()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 28                	push   $0x28
  801dd2:	e8 42 fb ff ff       	call   801919 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 04             	sub    $0x4,%esp
  801de3:	8b 45 14             	mov    0x14(%ebp),%eax
  801de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801de9:	8b 55 18             	mov    0x18(%ebp),%edx
  801dec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df0:	52                   	push   %edx
  801df1:	50                   	push   %eax
  801df2:	ff 75 10             	pushl  0x10(%ebp)
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	6a 27                	push   $0x27
  801dfd:	e8 17 fb ff ff       	call   801919 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return ;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <chktst>:
void chktst(uint32 n)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	6a 29                	push   $0x29
  801e18:	e8 fc fa ff ff       	call   801919 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e20:	90                   	nop
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <inctst>:

void inctst()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 2a                	push   $0x2a
  801e32:	e8 e2 fa ff ff       	call   801919 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3a:	90                   	nop
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <gettst>:
uint32 gettst()
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 2b                	push   $0x2b
  801e4c:	e8 c8 fa ff ff       	call   801919 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 2c                	push   $0x2c
  801e68:	e8 ac fa ff ff       	call   801919 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
  801e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e73:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e77:	75 07                	jne    801e80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e79:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7e:	eb 05                	jmp    801e85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 2c                	push   $0x2c
  801e99:	e8 7b fa ff ff       	call   801919 <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
  801ea1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ea8:	75 07                	jne    801eb1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eaf:	eb 05                	jmp    801eb6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 2c                	push   $0x2c
  801eca:	e8 4a fa ff ff       	call   801919 <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
  801ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ed5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ed9:	75 07                	jne    801ee2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801edb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee0:	eb 05                	jmp    801ee7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 2c                	push   $0x2c
  801efb:	e8 19 fa ff ff       	call   801919 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
  801f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f06:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f0a:	75 07                	jne    801f13 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f11:	eb 05                	jmp    801f18 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	ff 75 08             	pushl  0x8(%ebp)
  801f28:	6a 2d                	push   $0x2d
  801f2a:	e8 ea f9 ff ff       	call   801919 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f32:	90                   	nop
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	6a 00                	push   $0x0
  801f47:	53                   	push   %ebx
  801f48:	51                   	push   %ecx
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	6a 2e                	push   $0x2e
  801f4d:	e8 c7 f9 ff ff       	call   801919 <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	52                   	push   %edx
  801f6a:	50                   	push   %eax
  801f6b:	6a 2f                	push   $0x2f
  801f6d:	e8 a7 f9 ff ff       	call   801919 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	68 7c 3b 80 00       	push   $0x803b7c
  801f85:	e8 c7 e6 ff ff       	call   800651 <cprintf>
  801f8a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	68 a8 3b 80 00       	push   $0x803ba8
  801f9c:	e8 b0 e6 ff ff       	call   800651 <cprintf>
  801fa1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fa4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa8:	a1 38 41 80 00       	mov    0x804138,%eax
  801fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb0:	eb 56                	jmp    802008 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb6:	74 1c                	je     801fd4 <print_mem_block_lists+0x5d>
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 50 08             	mov    0x8(%eax),%edx
  801fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc1:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  801fca:	01 c8                	add    %ecx,%eax
  801fcc:	39 c2                	cmp    %eax,%edx
  801fce:	73 04                	jae    801fd4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fd0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	8b 50 08             	mov    0x8(%eax),%edx
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe0:	01 c2                	add    %eax,%edx
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe5:	8b 40 08             	mov    0x8(%eax),%eax
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	68 bd 3b 80 00       	push   $0x803bbd
  801ff2:	e8 5a e6 ff ff       	call   800651 <cprintf>
  801ff7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802000:	a1 40 41 80 00       	mov    0x804140,%eax
  802005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200c:	74 07                	je     802015 <print_mem_block_lists+0x9e>
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 00                	mov    (%eax),%eax
  802013:	eb 05                	jmp    80201a <print_mem_block_lists+0xa3>
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
  80201a:	a3 40 41 80 00       	mov    %eax,0x804140
  80201f:	a1 40 41 80 00       	mov    0x804140,%eax
  802024:	85 c0                	test   %eax,%eax
  802026:	75 8a                	jne    801fb2 <print_mem_block_lists+0x3b>
  802028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202c:	75 84                	jne    801fb2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80202e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802032:	75 10                	jne    802044 <print_mem_block_lists+0xcd>
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	68 cc 3b 80 00       	push   $0x803bcc
  80203c:	e8 10 e6 ff ff       	call   800651 <cprintf>
  802041:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802044:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	68 f0 3b 80 00       	push   $0x803bf0
  802053:	e8 f9 e5 ff ff       	call   800651 <cprintf>
  802058:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80205b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80205f:	a1 40 40 80 00       	mov    0x804040,%eax
  802064:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802067:	eb 56                	jmp    8020bf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802069:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80206d:	74 1c                	je     80208b <print_mem_block_lists+0x114>
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	8b 50 08             	mov    0x8(%eax),%edx
  802075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802078:	8b 48 08             	mov    0x8(%eax),%ecx
  80207b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207e:	8b 40 0c             	mov    0xc(%eax),%eax
  802081:	01 c8                	add    %ecx,%eax
  802083:	39 c2                	cmp    %eax,%edx
  802085:	73 04                	jae    80208b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802087:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80208b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208e:	8b 50 08             	mov    0x8(%eax),%edx
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	8b 40 0c             	mov    0xc(%eax),%eax
  802097:	01 c2                	add    %eax,%edx
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	8b 40 08             	mov    0x8(%eax),%eax
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	52                   	push   %edx
  8020a3:	50                   	push   %eax
  8020a4:	68 bd 3b 80 00       	push   $0x803bbd
  8020a9:	e8 a3 e5 ff ff       	call   800651 <cprintf>
  8020ae:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b7:	a1 48 40 80 00       	mov    0x804048,%eax
  8020bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c3:	74 07                	je     8020cc <print_mem_block_lists+0x155>
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	8b 00                	mov    (%eax),%eax
  8020ca:	eb 05                	jmp    8020d1 <print_mem_block_lists+0x15a>
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d1:	a3 48 40 80 00       	mov    %eax,0x804048
  8020d6:	a1 48 40 80 00       	mov    0x804048,%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	75 8a                	jne    802069 <print_mem_block_lists+0xf2>
  8020df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e3:	75 84                	jne    802069 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020e5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020e9:	75 10                	jne    8020fb <print_mem_block_lists+0x184>
  8020eb:	83 ec 0c             	sub    $0xc,%esp
  8020ee:	68 08 3c 80 00       	push   $0x803c08
  8020f3:	e8 59 e5 ff ff       	call   800651 <cprintf>
  8020f8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020fb:	83 ec 0c             	sub    $0xc,%esp
  8020fe:	68 7c 3b 80 00       	push   $0x803b7c
  802103:	e8 49 e5 ff ff       	call   800651 <cprintf>
  802108:	83 c4 10             	add    $0x10,%esp

}
  80210b:	90                   	nop
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802114:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80211b:	00 00 00 
  80211e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802125:	00 00 00 
  802128:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80212f:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802132:	a1 50 40 80 00       	mov    0x804050,%eax
  802137:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  80213a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802141:	e9 9e 00 00 00       	jmp    8021e4 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802146:	a1 50 40 80 00       	mov    0x804050,%eax
  80214b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214e:	c1 e2 04             	shl    $0x4,%edx
  802151:	01 d0                	add    %edx,%eax
  802153:	85 c0                	test   %eax,%eax
  802155:	75 14                	jne    80216b <initialize_MemBlocksList+0x5d>
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	68 30 3c 80 00       	push   $0x803c30
  80215f:	6a 48                	push   $0x48
  802161:	68 53 3c 80 00       	push   $0x803c53
  802166:	e8 32 e2 ff ff       	call   80039d <_panic>
  80216b:	a1 50 40 80 00       	mov    0x804050,%eax
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	c1 e2 04             	shl    $0x4,%edx
  802176:	01 d0                	add    %edx,%eax
  802178:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80217e:	89 10                	mov    %edx,(%eax)
  802180:	8b 00                	mov    (%eax),%eax
  802182:	85 c0                	test   %eax,%eax
  802184:	74 18                	je     80219e <initialize_MemBlocksList+0x90>
  802186:	a1 48 41 80 00       	mov    0x804148,%eax
  80218b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802191:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802194:	c1 e1 04             	shl    $0x4,%ecx
  802197:	01 ca                	add    %ecx,%edx
  802199:	89 50 04             	mov    %edx,0x4(%eax)
  80219c:	eb 12                	jmp    8021b0 <initialize_MemBlocksList+0xa2>
  80219e:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a6:	c1 e2 04             	shl    $0x4,%edx
  8021a9:	01 d0                	add    %edx,%eax
  8021ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021b0:	a1 50 40 80 00       	mov    0x804050,%eax
  8021b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b8:	c1 e2 04             	shl    $0x4,%edx
  8021bb:	01 d0                	add    %edx,%eax
  8021bd:	a3 48 41 80 00       	mov    %eax,0x804148
  8021c2:	a1 50 40 80 00       	mov    0x804050,%eax
  8021c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ca:	c1 e2 04             	shl    $0x4,%edx
  8021cd:	01 d0                	add    %edx,%eax
  8021cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d6:	a1 54 41 80 00       	mov    0x804154,%eax
  8021db:	40                   	inc    %eax
  8021dc:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8021e1:	ff 45 f4             	incl   -0xc(%ebp)
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ea:	0f 82 56 ff ff ff    	jb     802146 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8021f0:	90                   	nop
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802201:	eb 18                	jmp    80221b <find_block+0x28>
		{
			if(tmp->sva==va)
  802203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802206:	8b 40 08             	mov    0x8(%eax),%eax
  802209:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80220c:	75 05                	jne    802213 <find_block+0x20>
			{
				return tmp;
  80220e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802211:	eb 11                	jmp    802224 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802213:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802216:	8b 00                	mov    (%eax),%eax
  802218:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80221b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80221f:	75 e2                	jne    802203 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802221:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80222c:	a1 40 40 80 00       	mov    0x804040,%eax
  802231:	85 c0                	test   %eax,%eax
  802233:	0f 85 83 00 00 00    	jne    8022bc <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802239:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  802240:	00 00 00 
  802243:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80224a:	00 00 00 
  80224d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  802254:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802257:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225b:	75 14                	jne    802271 <insert_sorted_allocList+0x4b>
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	68 30 3c 80 00       	push   $0x803c30
  802265:	6a 7f                	push   $0x7f
  802267:	68 53 3c 80 00       	push   $0x803c53
  80226c:	e8 2c e1 ff ff       	call   80039d <_panic>
  802271:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	89 10                	mov    %edx,(%eax)
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	8b 00                	mov    (%eax),%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	74 0d                	je     802292 <insert_sorted_allocList+0x6c>
  802285:	a1 40 40 80 00       	mov    0x804040,%eax
  80228a:	8b 55 08             	mov    0x8(%ebp),%edx
  80228d:	89 50 04             	mov    %edx,0x4(%eax)
  802290:	eb 08                	jmp    80229a <insert_sorted_allocList+0x74>
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	a3 44 40 80 00       	mov    %eax,0x804044
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	a3 40 40 80 00       	mov    %eax,0x804040
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ac:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b1:	40                   	inc    %eax
  8022b2:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022b7:	e9 16 01 00 00       	jmp    8023d2 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8b 50 08             	mov    0x8(%eax),%edx
  8022c2:	a1 44 40 80 00       	mov    0x804044,%eax
  8022c7:	8b 40 08             	mov    0x8(%eax),%eax
  8022ca:	39 c2                	cmp    %eax,%edx
  8022cc:	76 68                	jbe    802336 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8022ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d2:	75 17                	jne    8022eb <insert_sorted_allocList+0xc5>
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	68 6c 3c 80 00       	push   $0x803c6c
  8022dc:	68 85 00 00 00       	push   $0x85
  8022e1:	68 53 3c 80 00       	push   $0x803c53
  8022e6:	e8 b2 e0 ff ff       	call   80039d <_panic>
  8022eb:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	89 50 04             	mov    %edx,0x4(%eax)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 40 04             	mov    0x4(%eax),%eax
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	74 0c                	je     80230d <insert_sorted_allocList+0xe7>
  802301:	a1 44 40 80 00       	mov    0x804044,%eax
  802306:	8b 55 08             	mov    0x8(%ebp),%edx
  802309:	89 10                	mov    %edx,(%eax)
  80230b:	eb 08                	jmp    802315 <insert_sorted_allocList+0xef>
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	a3 40 40 80 00       	mov    %eax,0x804040
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	a3 44 40 80 00       	mov    %eax,0x804044
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802326:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232b:	40                   	inc    %eax
  80232c:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802331:	e9 9c 00 00 00       	jmp    8023d2 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802336:	a1 40 40 80 00       	mov    0x804040,%eax
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80233e:	e9 85 00 00 00       	jmp    8023c8 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	8b 50 08             	mov    0x8(%eax),%edx
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	8b 40 08             	mov    0x8(%eax),%eax
  80234f:	39 c2                	cmp    %eax,%edx
  802351:	73 6d                	jae    8023c0 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802357:	74 06                	je     80235f <insert_sorted_allocList+0x139>
  802359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235d:	75 17                	jne    802376 <insert_sorted_allocList+0x150>
  80235f:	83 ec 04             	sub    $0x4,%esp
  802362:	68 90 3c 80 00       	push   $0x803c90
  802367:	68 90 00 00 00       	push   $0x90
  80236c:	68 53 3c 80 00       	push   $0x803c53
  802371:	e8 27 e0 ff ff       	call   80039d <_panic>
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 50 04             	mov    0x4(%eax),%edx
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	89 50 04             	mov    %edx,0x4(%eax)
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802388:	89 10                	mov    %edx,(%eax)
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 40 04             	mov    0x4(%eax),%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	74 0d                	je     8023a1 <insert_sorted_allocList+0x17b>
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 40 04             	mov    0x4(%eax),%eax
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
  80239d:	89 10                	mov    %edx,(%eax)
  80239f:	eb 08                	jmp    8023a9 <insert_sorted_allocList+0x183>
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	a3 40 40 80 00       	mov    %eax,0x804040
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8023af:	89 50 04             	mov    %edx,0x4(%eax)
  8023b2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023b7:	40                   	inc    %eax
  8023b8:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023bd:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023be:	eb 12                	jmp    8023d2 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8023c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cc:	0f 85 71 ff ff ff    	jne    802343 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8023d2:	90                   	nop
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
  8023d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8023db:	a1 38 41 80 00       	mov    0x804138,%eax
  8023e0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8023e3:	e9 76 01 00 00       	jmp    80255e <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f1:	0f 85 8a 00 00 00    	jne    802481 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8023f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fb:	75 17                	jne    802414 <alloc_block_FF+0x3f>
  8023fd:	83 ec 04             	sub    $0x4,%esp
  802400:	68 c5 3c 80 00       	push   $0x803cc5
  802405:	68 a8 00 00 00       	push   $0xa8
  80240a:	68 53 3c 80 00       	push   $0x803c53
  80240f:	e8 89 df ff ff       	call   80039d <_panic>
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	74 10                	je     80242d <alloc_block_FF+0x58>
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802425:	8b 52 04             	mov    0x4(%edx),%edx
  802428:	89 50 04             	mov    %edx,0x4(%eax)
  80242b:	eb 0b                	jmp    802438 <alloc_block_FF+0x63>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 04             	mov    0x4(%eax),%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	74 0f                	je     802451 <alloc_block_FF+0x7c>
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 40 04             	mov    0x4(%eax),%eax
  802448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244b:	8b 12                	mov    (%edx),%edx
  80244d:	89 10                	mov    %edx,(%eax)
  80244f:	eb 0a                	jmp    80245b <alloc_block_FF+0x86>
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 00                	mov    (%eax),%eax
  802456:	a3 38 41 80 00       	mov    %eax,0x804138
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246e:	a1 44 41 80 00       	mov    0x804144,%eax
  802473:	48                   	dec    %eax
  802474:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	e9 ea 00 00 00       	jmp    80256b <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 40 0c             	mov    0xc(%eax),%eax
  802487:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248a:	0f 86 c6 00 00 00    	jbe    802556 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802490:	a1 48 41 80 00       	mov    0x804148,%eax
  802495:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	8b 55 08             	mov    0x8(%ebp),%edx
  80249e:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 50 08             	mov    0x8(%eax),%edx
  8024a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024aa:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8024b6:	89 c2                	mov    %eax,%edx
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 50 08             	mov    0x8(%eax),%edx
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	01 c2                	add    %eax,%edx
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8024cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024d3:	75 17                	jne    8024ec <alloc_block_FF+0x117>
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	68 c5 3c 80 00       	push   $0x803cc5
  8024dd:	68 b6 00 00 00       	push   $0xb6
  8024e2:	68 53 3c 80 00       	push   $0x803c53
  8024e7:	e8 b1 de ff ff       	call   80039d <_panic>
  8024ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 10                	je     802505 <alloc_block_FF+0x130>
  8024f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024fd:	8b 52 04             	mov    0x4(%edx),%edx
  802500:	89 50 04             	mov    %edx,0x4(%eax)
  802503:	eb 0b                	jmp    802510 <alloc_block_FF+0x13b>
  802505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802508:	8b 40 04             	mov    0x4(%eax),%eax
  80250b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802513:	8b 40 04             	mov    0x4(%eax),%eax
  802516:	85 c0                	test   %eax,%eax
  802518:	74 0f                	je     802529 <alloc_block_FF+0x154>
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802523:	8b 12                	mov    (%edx),%edx
  802525:	89 10                	mov    %edx,(%eax)
  802527:	eb 0a                	jmp    802533 <alloc_block_FF+0x15e>
  802529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	a3 48 41 80 00       	mov    %eax,0x804148
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802546:	a1 54 41 80 00       	mov    0x804154,%eax
  80254b:	48                   	dec    %eax
  80254c:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	eb 15                	jmp    80256b <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80255e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802562:	0f 85 80 fe ff ff    	jne    8023e8 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802573:	a1 38 41 80 00       	mov    0x804138,%eax
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80257b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802582:	e9 c0 00 00 00       	jmp    802647 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 0c             	mov    0xc(%eax),%eax
  80258d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802590:	0f 85 8a 00 00 00    	jne    802620 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259a:	75 17                	jne    8025b3 <alloc_block_BF+0x46>
  80259c:	83 ec 04             	sub    $0x4,%esp
  80259f:	68 c5 3c 80 00       	push   $0x803cc5
  8025a4:	68 cf 00 00 00       	push   $0xcf
  8025a9:	68 53 3c 80 00       	push   $0x803c53
  8025ae:	e8 ea dd ff ff       	call   80039d <_panic>
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 10                	je     8025cc <alloc_block_BF+0x5f>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c4:	8b 52 04             	mov    0x4(%edx),%edx
  8025c7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ca:	eb 0b                	jmp    8025d7 <alloc_block_BF+0x6a>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 04             	mov    0x4(%eax),%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 0f                	je     8025f0 <alloc_block_BF+0x83>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 04             	mov    0x4(%eax),%eax
  8025e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ea:	8b 12                	mov    (%edx),%edx
  8025ec:	89 10                	mov    %edx,(%eax)
  8025ee:	eb 0a                	jmp    8025fa <alloc_block_BF+0x8d>
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260d:	a1 44 41 80 00       	mov    0x804144,%eax
  802612:	48                   	dec    %eax
  802613:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	e9 2a 01 00 00       	jmp    80274a <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 0c             	mov    0xc(%eax),%eax
  802626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802629:	73 14                	jae    80263f <alloc_block_BF+0xd2>
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 40 0c             	mov    0xc(%eax),%eax
  802631:	3b 45 08             	cmp    0x8(%ebp),%eax
  802634:	76 09                	jbe    80263f <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 40 0c             	mov    0xc(%eax),%eax
  80263c:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 00                	mov    (%eax),%eax
  802644:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264b:	0f 85 36 ff ff ff    	jne    802587 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802651:	a1 38 41 80 00       	mov    0x804138,%eax
  802656:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802659:	e9 dd 00 00 00       	jmp    80273b <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 40 0c             	mov    0xc(%eax),%eax
  802664:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802667:	0f 85 c6 00 00 00    	jne    802733 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80266d:	a1 48 41 80 00       	mov    0x804148,%eax
  802672:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 50 08             	mov    0x8(%eax),%edx
  80267b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267e:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802684:	8b 55 08             	mov    0x8(%ebp),%edx
  802687:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 50 08             	mov    0x8(%eax),%edx
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	01 c2                	add    %eax,%edx
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a4:	89 c2                	mov    %eax,%edx
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8026ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026b0:	75 17                	jne    8026c9 <alloc_block_BF+0x15c>
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	68 c5 3c 80 00       	push   $0x803cc5
  8026ba:	68 eb 00 00 00       	push   $0xeb
  8026bf:	68 53 3c 80 00       	push   $0x803c53
  8026c4:	e8 d4 dc ff ff       	call   80039d <_panic>
  8026c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	74 10                	je     8026e2 <alloc_block_BF+0x175>
  8026d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d5:	8b 00                	mov    (%eax),%eax
  8026d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026da:	8b 52 04             	mov    0x4(%edx),%edx
  8026dd:	89 50 04             	mov    %edx,0x4(%eax)
  8026e0:	eb 0b                	jmp    8026ed <alloc_block_BF+0x180>
  8026e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e5:	8b 40 04             	mov    0x4(%eax),%eax
  8026e8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f0:	8b 40 04             	mov    0x4(%eax),%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	74 0f                	je     802706 <alloc_block_BF+0x199>
  8026f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fa:	8b 40 04             	mov    0x4(%eax),%eax
  8026fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802700:	8b 12                	mov    (%edx),%edx
  802702:	89 10                	mov    %edx,(%eax)
  802704:	eb 0a                	jmp    802710 <alloc_block_BF+0x1a3>
  802706:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	a3 48 41 80 00       	mov    %eax,0x804148
  802710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802713:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802723:	a1 54 41 80 00       	mov    0x804154,%eax
  802728:	48                   	dec    %eax
  802729:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  80272e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802731:	eb 17                	jmp    80274a <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80273b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273f:	0f 85 19 ff ff ff    	jne    80265e <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802745:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80274a:	c9                   	leave  
  80274b:	c3                   	ret    

0080274c <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
  80274f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802752:	a1 40 40 80 00       	mov    0x804040,%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	75 19                	jne    802774 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  80275b:	83 ec 0c             	sub    $0xc,%esp
  80275e:	ff 75 08             	pushl  0x8(%ebp)
  802761:	e8 6f fc ff ff       	call   8023d5 <alloc_block_FF>
  802766:	83 c4 10             	add    $0x10,%esp
  802769:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	e9 e9 01 00 00       	jmp    80295d <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802774:	a1 44 40 80 00       	mov    0x804044,%eax
  802779:	8b 40 08             	mov    0x8(%eax),%eax
  80277c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80277f:	a1 44 40 80 00       	mov    0x804044,%eax
  802784:	8b 50 0c             	mov    0xc(%eax),%edx
  802787:	a1 44 40 80 00       	mov    0x804044,%eax
  80278c:	8b 40 08             	mov    0x8(%eax),%eax
  80278f:	01 d0                	add    %edx,%eax
  802791:	83 ec 08             	sub    $0x8,%esp
  802794:	50                   	push   %eax
  802795:	68 38 41 80 00       	push   $0x804138
  80279a:	e8 54 fa ff ff       	call   8021f3 <find_block>
  80279f:	83 c4 10             	add    $0x10,%esp
  8027a2:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ae:	0f 85 9b 00 00 00    	jne    80284f <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 40 08             	mov    0x8(%eax),%eax
  8027c0:	01 d0                	add    %edx,%eax
  8027c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8027c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c9:	75 17                	jne    8027e2 <alloc_block_NF+0x96>
  8027cb:	83 ec 04             	sub    $0x4,%esp
  8027ce:	68 c5 3c 80 00       	push   $0x803cc5
  8027d3:	68 1a 01 00 00       	push   $0x11a
  8027d8:	68 53 3c 80 00       	push   $0x803c53
  8027dd:	e8 bb db ff ff       	call   80039d <_panic>
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	74 10                	je     8027fb <alloc_block_NF+0xaf>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f3:	8b 52 04             	mov    0x4(%edx),%edx
  8027f6:	89 50 04             	mov    %edx,0x4(%eax)
  8027f9:	eb 0b                	jmp    802806 <alloc_block_NF+0xba>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 04             	mov    0x4(%eax),%eax
  802801:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 0f                	je     80281f <alloc_block_NF+0xd3>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 40 04             	mov    0x4(%eax),%eax
  802816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802819:	8b 12                	mov    (%edx),%edx
  80281b:	89 10                	mov    %edx,(%eax)
  80281d:	eb 0a                	jmp    802829 <alloc_block_NF+0xdd>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	a3 38 41 80 00       	mov    %eax,0x804138
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283c:	a1 44 41 80 00       	mov    0x804144,%eax
  802841:	48                   	dec    %eax
  802842:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	e9 0e 01 00 00       	jmp    80295d <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 40 0c             	mov    0xc(%eax),%eax
  802855:	3b 45 08             	cmp    0x8(%ebp),%eax
  802858:	0f 86 cf 00 00 00    	jbe    80292d <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80285e:	a1 48 41 80 00       	mov    0x804148,%eax
  802863:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802869:	8b 55 08             	mov    0x8(%ebp),%edx
  80286c:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 50 08             	mov    0x8(%eax),%edx
  802875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802878:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 50 08             	mov    0x8(%eax),%edx
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	01 c2                	add    %eax,%edx
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	2b 45 08             	sub    0x8(%ebp),%eax
  802895:	89 c2                	mov    %eax,%edx
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 08             	mov    0x8(%eax),%eax
  8028a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8028a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028aa:	75 17                	jne    8028c3 <alloc_block_NF+0x177>
  8028ac:	83 ec 04             	sub    $0x4,%esp
  8028af:	68 c5 3c 80 00       	push   $0x803cc5
  8028b4:	68 28 01 00 00       	push   $0x128
  8028b9:	68 53 3c 80 00       	push   $0x803c53
  8028be:	e8 da da ff ff       	call   80039d <_panic>
  8028c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	74 10                	je     8028dc <alloc_block_NF+0x190>
  8028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d4:	8b 52 04             	mov    0x4(%edx),%edx
  8028d7:	89 50 04             	mov    %edx,0x4(%eax)
  8028da:	eb 0b                	jmp    8028e7 <alloc_block_NF+0x19b>
  8028dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ea:	8b 40 04             	mov    0x4(%eax),%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	74 0f                	je     802900 <alloc_block_NF+0x1b4>
  8028f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f4:	8b 40 04             	mov    0x4(%eax),%eax
  8028f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028fa:	8b 12                	mov    (%edx),%edx
  8028fc:	89 10                	mov    %edx,(%eax)
  8028fe:	eb 0a                	jmp    80290a <alloc_block_NF+0x1be>
  802900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	a3 48 41 80 00       	mov    %eax,0x804148
  80290a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291d:	a1 54 41 80 00       	mov    0x804154,%eax
  802922:	48                   	dec    %eax
  802923:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  802928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292b:	eb 30                	jmp    80295d <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80292d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802932:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802935:	75 0a                	jne    802941 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802937:	a1 38 41 80 00       	mov    0x804138,%eax
  80293c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293f:	eb 08                	jmp    802949 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 08             	mov    0x8(%eax),%eax
  80294f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802952:	0f 85 4d fe ff ff    	jne    8027a5 <alloc_block_NF+0x59>

			return NULL;
  802958:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	53                   	push   %ebx
  802963:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802966:	a1 38 41 80 00       	mov    0x804138,%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	0f 85 86 00 00 00    	jne    8029f9 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802973:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80297a:	00 00 00 
  80297d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  802984:	00 00 00 
  802987:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80298e:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802991:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802995:	75 17                	jne    8029ae <insert_sorted_with_merge_freeList+0x4f>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 30 3c 80 00       	push   $0x803c30
  80299f:	68 48 01 00 00       	push   $0x148
  8029a4:	68 53 3c 80 00       	push   $0x803c53
  8029a9:	e8 ef d9 ff ff       	call   80039d <_panic>
  8029ae:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	89 10                	mov    %edx,(%eax)
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	74 0d                	je     8029cf <insert_sorted_with_merge_freeList+0x70>
  8029c2:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ca:	89 50 04             	mov    %edx,0x4(%eax)
  8029cd:	eb 08                	jmp    8029d7 <insert_sorted_with_merge_freeList+0x78>
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	a3 38 41 80 00       	mov    %eax,0x804138
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e9:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ee:	40                   	inc    %eax
  8029ef:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8029f4:	e9 73 07 00 00       	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	8b 50 08             	mov    0x8(%eax),%edx
  8029ff:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a04:	8b 40 08             	mov    0x8(%eax),%eax
  802a07:	39 c2                	cmp    %eax,%edx
  802a09:	0f 86 84 00 00 00    	jbe    802a93 <insert_sorted_with_merge_freeList+0x134>
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	8b 50 08             	mov    0x8(%eax),%edx
  802a15:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a1a:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a1d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a22:	8b 40 08             	mov    0x8(%eax),%eax
  802a25:	01 c8                	add    %ecx,%eax
  802a27:	39 c2                	cmp    %eax,%edx
  802a29:	74 68                	je     802a93 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802a2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2f:	75 17                	jne    802a48 <insert_sorted_with_merge_freeList+0xe9>
  802a31:	83 ec 04             	sub    $0x4,%esp
  802a34:	68 6c 3c 80 00       	push   $0x803c6c
  802a39:	68 4c 01 00 00       	push   $0x14c
  802a3e:	68 53 3c 80 00       	push   $0x803c53
  802a43:	e8 55 d9 ff ff       	call   80039d <_panic>
  802a48:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	89 50 04             	mov    %edx,0x4(%eax)
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	8b 40 04             	mov    0x4(%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 0c                	je     802a6a <insert_sorted_with_merge_freeList+0x10b>
  802a5e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a63:	8b 55 08             	mov    0x8(%ebp),%edx
  802a66:	89 10                	mov    %edx,(%eax)
  802a68:	eb 08                	jmp    802a72 <insert_sorted_with_merge_freeList+0x113>
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	a3 38 41 80 00       	mov    %eax,0x804138
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a83:	a1 44 41 80 00       	mov    0x804144,%eax
  802a88:	40                   	inc    %eax
  802a89:	a3 44 41 80 00       	mov    %eax,0x804144
  802a8e:	e9 d9 06 00 00       	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	8b 50 08             	mov    0x8(%eax),%edx
  802a99:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a9e:	8b 40 08             	mov    0x8(%eax),%eax
  802aa1:	39 c2                	cmp    %eax,%edx
  802aa3:	0f 86 b5 00 00 00    	jbe    802b5e <insert_sorted_with_merge_freeList+0x1ff>
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	8b 50 08             	mov    0x8(%eax),%edx
  802aaf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ab4:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ab7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802abc:	8b 40 08             	mov    0x8(%eax),%eax
  802abf:	01 c8                	add    %ecx,%eax
  802ac1:	39 c2                	cmp    %eax,%edx
  802ac3:	0f 85 95 00 00 00    	jne    802b5e <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802ac9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ace:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ad4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ada:	8b 52 0c             	mov    0xc(%edx),%edx
  802add:	01 ca                	add    %ecx,%edx
  802adf:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802af6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802afa:	75 17                	jne    802b13 <insert_sorted_with_merge_freeList+0x1b4>
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	68 30 3c 80 00       	push   $0x803c30
  802b04:	68 54 01 00 00       	push   $0x154
  802b09:	68 53 3c 80 00       	push   $0x803c53
  802b0e:	e8 8a d8 ff ff       	call   80039d <_panic>
  802b13:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	85 c0                	test   %eax,%eax
  802b25:	74 0d                	je     802b34 <insert_sorted_with_merge_freeList+0x1d5>
  802b27:	a1 48 41 80 00       	mov    0x804148,%eax
  802b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2f:	89 50 04             	mov    %edx,0x4(%eax)
  802b32:	eb 08                	jmp    802b3c <insert_sorted_with_merge_freeList+0x1dd>
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	a3 48 41 80 00       	mov    %eax,0x804148
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4e:	a1 54 41 80 00       	mov    0x804154,%eax
  802b53:	40                   	inc    %eax
  802b54:	a3 54 41 80 00       	mov    %eax,0x804154
  802b59:	e9 0e 06 00 00       	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	8b 50 08             	mov    0x8(%eax),%edx
  802b64:	a1 38 41 80 00       	mov    0x804138,%eax
  802b69:	8b 40 08             	mov    0x8(%eax),%eax
  802b6c:	39 c2                	cmp    %eax,%edx
  802b6e:	0f 83 c1 00 00 00    	jae    802c35 <insert_sorted_with_merge_freeList+0x2d6>
  802b74:	a1 38 41 80 00       	mov    0x804138,%eax
  802b79:	8b 50 08             	mov    0x8(%eax),%edx
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 48 08             	mov    0x8(%eax),%ecx
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 40 0c             	mov    0xc(%eax),%eax
  802b88:	01 c8                	add    %ecx,%eax
  802b8a:	39 c2                	cmp    %eax,%edx
  802b8c:	0f 85 a3 00 00 00    	jne    802c35 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802b92:	a1 38 41 80 00       	mov    0x804138,%eax
  802b97:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9a:	8b 52 08             	mov    0x8(%edx),%edx
  802b9d:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802ba0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ba5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bab:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802bae:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb1:	8b 52 0c             	mov    0xc(%edx),%edx
  802bb4:	01 ca                	add    %ecx,%edx
  802bb6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd1:	75 17                	jne    802bea <insert_sorted_with_merge_freeList+0x28b>
  802bd3:	83 ec 04             	sub    $0x4,%esp
  802bd6:	68 30 3c 80 00       	push   $0x803c30
  802bdb:	68 5d 01 00 00       	push   $0x15d
  802be0:	68 53 3c 80 00       	push   $0x803c53
  802be5:	e8 b3 d7 ff ff       	call   80039d <_panic>
  802bea:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	89 10                	mov    %edx,(%eax)
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	74 0d                	je     802c0b <insert_sorted_with_merge_freeList+0x2ac>
  802bfe:	a1 48 41 80 00       	mov    0x804148,%eax
  802c03:	8b 55 08             	mov    0x8(%ebp),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	eb 08                	jmp    802c13 <insert_sorted_with_merge_freeList+0x2b4>
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	a3 48 41 80 00       	mov    %eax,0x804148
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c25:	a1 54 41 80 00       	mov    0x804154,%eax
  802c2a:	40                   	inc    %eax
  802c2b:	a3 54 41 80 00       	mov    %eax,0x804154
  802c30:	e9 37 05 00 00       	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	8b 50 08             	mov    0x8(%eax),%edx
  802c3b:	a1 38 41 80 00       	mov    0x804138,%eax
  802c40:	8b 40 08             	mov    0x8(%eax),%eax
  802c43:	39 c2                	cmp    %eax,%edx
  802c45:	0f 83 82 00 00 00    	jae    802ccd <insert_sorted_with_merge_freeList+0x36e>
  802c4b:	a1 38 41 80 00       	mov    0x804138,%eax
  802c50:	8b 50 08             	mov    0x8(%eax),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 48 08             	mov    0x8(%eax),%ecx
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5f:	01 c8                	add    %ecx,%eax
  802c61:	39 c2                	cmp    %eax,%edx
  802c63:	74 68                	je     802ccd <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c69:	75 17                	jne    802c82 <insert_sorted_with_merge_freeList+0x323>
  802c6b:	83 ec 04             	sub    $0x4,%esp
  802c6e:	68 30 3c 80 00       	push   $0x803c30
  802c73:	68 62 01 00 00       	push   $0x162
  802c78:	68 53 3c 80 00       	push   $0x803c53
  802c7d:	e8 1b d7 ff ff       	call   80039d <_panic>
  802c82:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 0d                	je     802ca3 <insert_sorted_with_merge_freeList+0x344>
  802c96:	a1 38 41 80 00       	mov    0x804138,%eax
  802c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ca1:	eb 08                	jmp    802cab <insert_sorted_with_merge_freeList+0x34c>
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	a3 38 41 80 00       	mov    %eax,0x804138
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbd:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc2:	40                   	inc    %eax
  802cc3:	a3 44 41 80 00       	mov    %eax,0x804144
  802cc8:	e9 9f 04 00 00       	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802ccd:	a1 38 41 80 00       	mov    0x804138,%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802cd7:	e9 84 04 00 00       	jmp    803160 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 50 08             	mov    0x8(%eax),%edx
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 40 08             	mov    0x8(%eax),%eax
  802ce8:	39 c2                	cmp    %eax,%edx
  802cea:	0f 86 a9 00 00 00    	jbe    802d99 <insert_sorted_with_merge_freeList+0x43a>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 50 08             	mov    0x8(%eax),%edx
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	8b 48 08             	mov    0x8(%eax),%ecx
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	8b 40 0c             	mov    0xc(%eax),%eax
  802d02:	01 c8                	add    %ecx,%eax
  802d04:	39 c2                	cmp    %eax,%edx
  802d06:	0f 84 8d 00 00 00    	je     802d99 <insert_sorted_with_merge_freeList+0x43a>
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	8b 50 08             	mov    0x8(%eax),%edx
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	8b 48 08             	mov    0x8(%eax),%ecx
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	8b 40 0c             	mov    0xc(%eax),%eax
  802d24:	01 c8                	add    %ecx,%eax
  802d26:	39 c2                	cmp    %eax,%edx
  802d28:	74 6f                	je     802d99 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802d2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2e:	74 06                	je     802d36 <insert_sorted_with_merge_freeList+0x3d7>
  802d30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d34:	75 17                	jne    802d4d <insert_sorted_with_merge_freeList+0x3ee>
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	68 90 3c 80 00       	push   $0x803c90
  802d3e:	68 6b 01 00 00       	push   $0x16b
  802d43:	68 53 3c 80 00       	push   $0x803c53
  802d48:	e8 50 d6 ff ff       	call   80039d <_panic>
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 50 04             	mov    0x4(%eax),%edx
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	89 50 04             	mov    %edx,0x4(%eax)
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5f:	89 10                	mov    %edx,(%eax)
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 04             	mov    0x4(%eax),%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	74 0d                	je     802d78 <insert_sorted_with_merge_freeList+0x419>
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	8b 40 04             	mov    0x4(%eax),%eax
  802d71:	8b 55 08             	mov    0x8(%ebp),%edx
  802d74:	89 10                	mov    %edx,(%eax)
  802d76:	eb 08                	jmp    802d80 <insert_sorted_with_merge_freeList+0x421>
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	a3 38 41 80 00       	mov    %eax,0x804138
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 55 08             	mov    0x8(%ebp),%edx
  802d86:	89 50 04             	mov    %edx,0x4(%eax)
  802d89:	a1 44 41 80 00       	mov    0x804144,%eax
  802d8e:	40                   	inc    %eax
  802d8f:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802d94:	e9 d3 03 00 00       	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	8b 50 08             	mov    0x8(%eax),%edx
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	8b 40 08             	mov    0x8(%eax),%eax
  802da5:	39 c2                	cmp    %eax,%edx
  802da7:	0f 86 da 00 00 00    	jbe    802e87 <insert_sorted_with_merge_freeList+0x528>
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 50 08             	mov    0x8(%eax),%edx
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	8b 48 08             	mov    0x8(%eax),%ecx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbf:	01 c8                	add    %ecx,%eax
  802dc1:	39 c2                	cmp    %eax,%edx
  802dc3:	0f 85 be 00 00 00    	jne    802e87 <insert_sorted_with_merge_freeList+0x528>
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	8b 50 08             	mov    0x8(%eax),%edx
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	8b 48 08             	mov    0x8(%eax),%ecx
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 40 04             	mov    0x4(%eax),%eax
  802dde:	8b 40 0c             	mov    0xc(%eax),%eax
  802de1:	01 c8                	add    %ecx,%eax
  802de3:	39 c2                	cmp    %eax,%edx
  802de5:	0f 84 9c 00 00 00    	je     802e87 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 50 08             	mov    0x8(%eax),%edx
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	8b 40 0c             	mov    0xc(%eax),%eax
  802e03:	01 c2                	add    %eax,%edx
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e23:	75 17                	jne    802e3c <insert_sorted_with_merge_freeList+0x4dd>
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	68 30 3c 80 00       	push   $0x803c30
  802e2d:	68 74 01 00 00       	push   $0x174
  802e32:	68 53 3c 80 00       	push   $0x803c53
  802e37:	e8 61 d5 ff ff       	call   80039d <_panic>
  802e3c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	89 10                	mov    %edx,(%eax)
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0d                	je     802e5d <insert_sorted_with_merge_freeList+0x4fe>
  802e50:	a1 48 41 80 00       	mov    0x804148,%eax
  802e55:	8b 55 08             	mov    0x8(%ebp),%edx
  802e58:	89 50 04             	mov    %edx,0x4(%eax)
  802e5b:	eb 08                	jmp    802e65 <insert_sorted_with_merge_freeList+0x506>
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e77:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7c:	40                   	inc    %eax
  802e7d:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802e82:	e9 e5 02 00 00       	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	8b 40 08             	mov    0x8(%eax),%eax
  802e93:	39 c2                	cmp    %eax,%edx
  802e95:	0f 86 d7 00 00 00    	jbe    802f72 <insert_sorted_with_merge_freeList+0x613>
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	8b 48 08             	mov    0x8(%eax),%ecx
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ead:	01 c8                	add    %ecx,%eax
  802eaf:	39 c2                	cmp    %eax,%edx
  802eb1:	0f 84 bb 00 00 00    	je     802f72 <insert_sorted_with_merge_freeList+0x613>
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 50 08             	mov    0x8(%eax),%edx
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 04             	mov    0x4(%eax),%eax
  802ec3:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecf:	01 c8                	add    %ecx,%eax
  802ed1:	39 c2                	cmp    %eax,%edx
  802ed3:	0f 85 99 00 00 00    	jne    802f72 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802eee:	01 c2                	add    %eax,%edx
  802ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef3:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0e:	75 17                	jne    802f27 <insert_sorted_with_merge_freeList+0x5c8>
  802f10:	83 ec 04             	sub    $0x4,%esp
  802f13:	68 30 3c 80 00       	push   $0x803c30
  802f18:	68 7d 01 00 00       	push   $0x17d
  802f1d:	68 53 3c 80 00       	push   $0x803c53
  802f22:	e8 76 d4 ff ff       	call   80039d <_panic>
  802f27:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	89 10                	mov    %edx,(%eax)
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 00                	mov    (%eax),%eax
  802f37:	85 c0                	test   %eax,%eax
  802f39:	74 0d                	je     802f48 <insert_sorted_with_merge_freeList+0x5e9>
  802f3b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f40:	8b 55 08             	mov    0x8(%ebp),%edx
  802f43:	89 50 04             	mov    %edx,0x4(%eax)
  802f46:	eb 08                	jmp    802f50 <insert_sorted_with_merge_freeList+0x5f1>
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	a3 48 41 80 00       	mov    %eax,0x804148
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f62:	a1 54 41 80 00       	mov    0x804154,%eax
  802f67:	40                   	inc    %eax
  802f68:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802f6d:	e9 fa 01 00 00       	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 50 08             	mov    0x8(%eax),%edx
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	8b 40 08             	mov    0x8(%eax),%eax
  802f7e:	39 c2                	cmp    %eax,%edx
  802f80:	0f 86 d2 01 00 00    	jbe    803158 <insert_sorted_with_merge_freeList+0x7f9>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 50 08             	mov    0x8(%eax),%edx
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	8b 48 08             	mov    0x8(%eax),%ecx
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	01 c8                	add    %ecx,%eax
  802f9a:	39 c2                	cmp    %eax,%edx
  802f9c:	0f 85 b6 01 00 00    	jne    803158 <insert_sorted_with_merge_freeList+0x7f9>
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	8b 50 08             	mov    0x8(%eax),%edx
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	8b 48 08             	mov    0x8(%eax),%ecx
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	8b 40 04             	mov    0x4(%eax),%eax
  802fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fba:	01 c8                	add    %ecx,%eax
  802fbc:	39 c2                	cmp    %eax,%edx
  802fbe:	0f 85 94 01 00 00    	jne    803158 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 40 04             	mov    0x4(%eax),%eax
  802fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fcd:	8b 52 04             	mov    0x4(%edx),%edx
  802fd0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd6:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802fd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdc:	8b 52 0c             	mov    0xc(%edx),%edx
  802fdf:	01 da                	add    %ebx,%edx
  802fe1:	01 ca                	add    %ecx,%edx
  802fe3:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802ffa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffe:	75 17                	jne    803017 <insert_sorted_with_merge_freeList+0x6b8>
  803000:	83 ec 04             	sub    $0x4,%esp
  803003:	68 c5 3c 80 00       	push   $0x803cc5
  803008:	68 86 01 00 00       	push   $0x186
  80300d:	68 53 3c 80 00       	push   $0x803c53
  803012:	e8 86 d3 ff ff       	call   80039d <_panic>
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	74 10                	je     803030 <insert_sorted_with_merge_freeList+0x6d1>
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 00                	mov    (%eax),%eax
  803025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803028:	8b 52 04             	mov    0x4(%edx),%edx
  80302b:	89 50 04             	mov    %edx,0x4(%eax)
  80302e:	eb 0b                	jmp    80303b <insert_sorted_with_merge_freeList+0x6dc>
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	8b 40 04             	mov    0x4(%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	74 0f                	je     803054 <insert_sorted_with_merge_freeList+0x6f5>
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80304e:	8b 12                	mov    (%edx),%edx
  803050:	89 10                	mov    %edx,(%eax)
  803052:	eb 0a                	jmp    80305e <insert_sorted_with_merge_freeList+0x6ff>
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	a3 38 41 80 00       	mov    %eax,0x804138
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803071:	a1 44 41 80 00       	mov    0x804144,%eax
  803076:	48                   	dec    %eax
  803077:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80307c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803080:	75 17                	jne    803099 <insert_sorted_with_merge_freeList+0x73a>
  803082:	83 ec 04             	sub    $0x4,%esp
  803085:	68 30 3c 80 00       	push   $0x803c30
  80308a:	68 87 01 00 00       	push   $0x187
  80308f:	68 53 3c 80 00       	push   $0x803c53
  803094:	e8 04 d3 ff ff       	call   80039d <_panic>
  803099:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	89 10                	mov    %edx,(%eax)
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	85 c0                	test   %eax,%eax
  8030ab:	74 0d                	je     8030ba <insert_sorted_with_merge_freeList+0x75b>
  8030ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8030b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b5:	89 50 04             	mov    %edx,0x4(%eax)
  8030b8:	eb 08                	jmp    8030c2 <insert_sorted_with_merge_freeList+0x763>
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d4:	a1 54 41 80 00       	mov    0x804154,%eax
  8030d9:	40                   	inc    %eax
  8030da:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f7:	75 17                	jne    803110 <insert_sorted_with_merge_freeList+0x7b1>
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	68 30 3c 80 00       	push   $0x803c30
  803101:	68 8a 01 00 00       	push   $0x18a
  803106:	68 53 3c 80 00       	push   $0x803c53
  80310b:	e8 8d d2 ff ff       	call   80039d <_panic>
  803110:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	89 10                	mov    %edx,(%eax)
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0d                	je     803131 <insert_sorted_with_merge_freeList+0x7d2>
  803124:	a1 48 41 80 00       	mov    0x804148,%eax
  803129:	8b 55 08             	mov    0x8(%ebp),%edx
  80312c:	89 50 04             	mov    %edx,0x4(%eax)
  80312f:	eb 08                	jmp    803139 <insert_sorted_with_merge_freeList+0x7da>
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	a3 48 41 80 00       	mov    %eax,0x804148
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314b:	a1 54 41 80 00       	mov    0x804154,%eax
  803150:	40                   	inc    %eax
  803151:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  803156:	eb 14                	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803164:	0f 85 72 fb ff ff    	jne    802cdc <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80316a:	eb 00                	jmp    80316c <insert_sorted_with_merge_freeList+0x80d>
  80316c:	90                   	nop
  80316d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
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
