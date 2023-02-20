
obj/user/tst_malloc_0:     file format elf32-i386


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
  800031:	e8 a3 01 00 00       	call   8001d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
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
void _main(void)
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
  80008c:	68 60 33 80 00       	push   $0x803360
  800091:	6a 14                	push   $0x14
  800093:	68 7c 33 80 00       	push   $0x80337c
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 db 18 00 00       	call   80197d <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 73 19 00 00       	call   801a1d <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 62 14 00 00       	call   801519 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 be 18 00 00       	call   80197d <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 56 19 00 00       	call   801a1d <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 90 33 80 00       	push   $0x803390
  8000de:	6a 23                	push   $0x23
  8000e0:	68 7c 33 80 00       	push   $0x80337c
  8000e5:	e8 2b 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AvailableMemBlocksList
	if (LIST_SIZE(&(AvailableMemBlocksList)) != MAX_MEM_BLOCK_CNT-1)
  8000ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8000ef:	8b 15 20 41 80 00    	mov    0x804120,%edx
  8000f5:	4a                   	dec    %edx
  8000f6:	39 d0                	cmp    %edx,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
	{
		panic("Wrong initialize: Wrong size for the AvailableMemBlocksList");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 e4 33 80 00       	push   $0x8033e4
  800102:	6a 29                	push   $0x29
  800104:	68 7c 33 80 00       	push   $0x80337c
  800109:	e8 07 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AllocMemBlocksList
	if (LIST_SIZE(&(AllocMemBlocksList)) != 0)
  80010e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  800113:	85 c0                	test   %eax,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
	{
		panic("Wrong initialize: Wrong size for the AllocMemBlocksList");
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 20 34 80 00       	push   $0x803420
  80011f:	6a 2f                	push   $0x2f
  800121:	68 7c 33 80 00       	push   $0x80337c
  800126:	e8 ea 01 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in FreeMemBlocksList
	if (LIST_SIZE(&(FreeMemBlocksList)) != 1)
  80012b:	a1 44 41 80 00       	mov    0x804144,%eax
  800130:	83 f8 01             	cmp    $0x1,%eax
  800133:	74 14                	je     800149 <_main+0x111>
	{
		panic("Wrong initialize: Wrong size for the FreeMemBlocksList");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 58 34 80 00       	push   $0x803458
  80013d:	6a 35                	push   $0x35
  80013f:	68 7c 33 80 00       	push   $0x80337c
  800144:	e8 cc 01 00 00       	call   800315 <_panic>
	}

	//Check content of FreeMemBlocksList
	struct MemBlock* block = LIST_FIRST(&FreeMemBlocksList);
  800149:	a1 38 41 80 00       	mov    0x804138,%eax
  80014e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(block == NULL || block->size != (0xA0000000-0x80000000) || block->sva != 0x80000000)
  800151:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800155:	74 1a                	je     800171 <_main+0x139>
  800157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015a:	8b 40 0c             	mov    0xc(%eax),%eax
  80015d:	3d 00 00 00 20       	cmp    $0x20000000,%eax
  800162:	75 0d                	jne    800171 <_main+0x139>
  800164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800167:	8b 40 08             	mov    0x8(%eax),%eax
  80016a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
	{
		panic("Wrong initialize: Wrong content for the FreeMemBlocksList.");
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 90 34 80 00       	push   $0x803490
  800179:	6a 3c                	push   $0x3c
  80017b:	68 7c 33 80 00       	push   $0x80337c
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 cc 34 80 00       	push   $0x8034cc
  800195:	6a 40                	push   $0x40
  800197:	68 7c 33 80 00       	push   $0x80337c
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 34 35 80 00       	push   $0x803534
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 7c 33 80 00       	push   $0x80337c
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 78 35 80 00       	push   $0x803578
  8001ce:	e8 f6 03 00 00       	call   8005c9 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp

	return;
  8001d6:	90                   	nop
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001df:	e8 79 1a 00 00       	call   801c5d <sys_getenvindex>
  8001e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ea:	89 d0                	mov    %edx,%eax
  8001ec:	c1 e0 03             	shl    $0x3,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	01 c0                	add    %eax,%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	c1 e0 04             	shl    $0x4,%eax
  800201:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800206:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800216:	84 c0                	test   %al,%al
  800218:	74 0f                	je     800229 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	05 5c 05 00 00       	add    $0x55c,%eax
  800224:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022d:	7e 0a                	jle    800239 <libmain+0x60>
		binaryname = argv[0];
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 f1 fd ff ff       	call   800038 <_main>
  800247:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80024a:	e8 1b 18 00 00       	call   801a6a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 e8 35 80 00       	push   $0x8035e8
  800257:	e8 6d 03 00 00       	call   8005c9 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025f:	a1 20 40 80 00       	mov    0x804020,%eax
  800264:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80026a:	a1 20 40 80 00       	mov    0x804020,%eax
  80026f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 10 36 80 00       	push   $0x803610
  80027f:	e8 45 03 00 00       	call   8005c9 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800287:	a1 20 40 80 00       	mov    0x804020,%eax
  80028c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800292:	a1 20 40 80 00       	mov    0x804020,%eax
  800297:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80029d:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002a8:	51                   	push   %ecx
  8002a9:	52                   	push   %edx
  8002aa:	50                   	push   %eax
  8002ab:	68 38 36 80 00       	push   $0x803638
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 90 36 80 00       	push   $0x803690
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 e8 35 80 00       	push   $0x8035e8
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 9b 17 00 00       	call   801a84 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002e9:	e8 19 00 00 00       	call   800307 <exit>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 28 19 00 00       	call   801c29 <sys_destroy_env>
  800301:	83 c4 10             	add    $0x10,%esp
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <exit>:

void
exit(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030d:	e8 7d 19 00 00       	call   801c8f <sys_exit_env>
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031b:	8d 45 10             	lea    0x10(%ebp),%eax
  80031e:	83 c0 04             	add    $0x4,%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800324:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 16                	je     800343 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 a4 36 80 00       	push   $0x8036a4
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 40 80 00       	mov    0x804000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 a9 36 80 00       	push   $0x8036a9
  800354:	e8 70 02 00 00       	call   8005c9 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	50                   	push   %eax
  800366:	e8 f3 01 00 00       	call   80055e <vcprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	6a 00                	push   $0x0
  800373:	68 c5 36 80 00       	push   $0x8036c5
  800378:	e8 e1 01 00 00       	call   80055e <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800380:	e8 82 ff ff ff       	call   800307 <exit>

	// should not return here
	while (1) ;
  800385:	eb fe                	jmp    800385 <_panic+0x70>

00800387 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038d:	a1 20 40 80 00       	mov    0x804020,%eax
  800392:	8b 50 74             	mov    0x74(%eax),%edx
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	39 c2                	cmp    %eax,%edx
  80039a:	74 14                	je     8003b0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 c8 36 80 00       	push   $0x8036c8
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 14 37 80 00       	push   $0x803714
  8003ab:	e8 65 ff ff ff       	call   800315 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003be:	e9 c2 00 00 00       	jmp    800485 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	75 08                	jne    8003e0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003d8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003db:	e9 a2 00 00 00       	jmp    800482 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ee:	eb 69                	jmp    800459 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	c1 e0 03             	shl    $0x3,%eax
  800407:	01 c8                	add    %ecx,%eax
  800409:	8a 40 04             	mov    0x4(%eax),%al
  80040c:	84 c0                	test   %al,%al
  80040e:	75 46                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800436:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	01 c8                	add    %ecx,%eax
  800447:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	39 c2                	cmp    %eax,%edx
  80044b:	75 09                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80044d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800454:	eb 12                	jmp    800468 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	ff 45 e8             	incl   -0x18(%ebp)
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 50 74             	mov    0x74(%eax),%edx
  800461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	77 88                	ja     8003f0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046c:	75 14                	jne    800482 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	68 20 37 80 00       	push   $0x803720
  800476:	6a 3a                	push   $0x3a
  800478:	68 14 37 80 00       	push   $0x803714
  80047d:	e8 93 fe ff ff       	call   800315 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800482:	ff 45 f0             	incl   -0x10(%ebp)
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800488:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048b:	0f 8c 32 ff ff ff    	jl     8003c3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049f:	eb 26                	jmp    8004c7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004af:	89 d0                	mov    %edx,%eax
  8004b1:	01 c0                	add    %eax,%eax
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	c1 e0 03             	shl    $0x3,%eax
  8004b8:	01 c8                	add    %ecx,%eax
  8004ba:	8a 40 04             	mov    0x4(%eax),%al
  8004bd:	3c 01                	cmp    $0x1,%al
  8004bf:	75 03                	jne    8004c4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c4:	ff 45 e0             	incl   -0x20(%ebp)
  8004c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004cc:	8b 50 74             	mov    0x74(%eax),%edx
  8004cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	77 cb                	ja     8004a1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 74 37 80 00       	push   $0x803774
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 14 37 80 00       	push   $0x803714
  8004ed:	e8 23 fe ff ff       	call   800315 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f2:	90                   	nop
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 01             	lea    0x1(%eax),%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 55 08             	mov    0x8(%ebp),%edx
  80050b:	88 d1                	mov    %dl,%cl
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051e:	75 2c                	jne    80054c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800520:	a0 24 40 80 00       	mov    0x804024,%al
  800525:	0f b6 c0             	movzbl %al,%eax
  800528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052b:	8b 12                	mov    (%edx),%edx
  80052d:	89 d1                	mov    %edx,%ecx
  80052f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800532:	83 c2 08             	add    $0x8,%edx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	50                   	push   %eax
  800539:	51                   	push   %ecx
  80053a:	52                   	push   %edx
  80053b:	e8 7c 13 00 00       	call   8018bc <sys_cputs>
  800540:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800543:	8b 45 0c             	mov    0xc(%ebp),%eax
  800546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	8b 40 04             	mov    0x4(%eax),%eax
  800552:	8d 50 01             	lea    0x1(%eax),%edx
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800567:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056e:	00 00 00 
	b.cnt = 0;
  800571:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800578:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	68 f5 04 80 00       	push   $0x8004f5
  80058d:	e8 11 02 00 00       	call   8007a3 <vprintfmt>
  800592:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800595:	a0 24 40 80 00       	mov    0x804024,%al
  80059a:	0f b6 c0             	movzbl %al,%eax
  80059d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	50                   	push   %eax
  8005a7:	52                   	push   %edx
  8005a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ae:	83 c0 08             	add    $0x8,%eax
  8005b1:	50                   	push   %eax
  8005b2:	e8 05 13 00 00       	call   8018bc <sys_cputs>
  8005b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ba:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005cf:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	e8 73 ff ff ff       	call   80055e <vcprintf>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005fc:	e8 69 14 00 00       	call   801a6a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800601:	8d 45 0c             	lea    0xc(%ebp),%eax
  800604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 48 ff ff ff       	call   80055e <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80061c:	e8 63 14 00 00       	call   801a84 <sys_enable_interrupt>
	return cnt;
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	53                   	push   %ebx
  80062a:	83 ec 14             	sub    $0x14,%esp
  80062d:	8b 45 10             	mov    0x10(%ebp),%eax
  800630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 18             	mov    0x18(%ebp),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800644:	77 55                	ja     80069b <printnum+0x75>
  800646:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800649:	72 05                	jb     800650 <printnum+0x2a>
  80064b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80064e:	77 4b                	ja     80069b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800653:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800656:	8b 45 18             	mov    0x18(%ebp),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	ff 75 f4             	pushl  -0xc(%ebp)
  800663:	ff 75 f0             	pushl  -0x10(%ebp)
  800666:	e8 81 2a 00 00       	call   8030ec <__udivdi3>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	ff 75 20             	pushl  0x20(%ebp)
  800674:	53                   	push   %ebx
  800675:	ff 75 18             	pushl  0x18(%ebp)
  800678:	52                   	push   %edx
  800679:	50                   	push   %eax
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	ff 75 08             	pushl  0x8(%ebp)
  800680:	e8 a1 ff ff ff       	call   800626 <printnum>
  800685:	83 c4 20             	add    $0x20,%esp
  800688:	eb 1a                	jmp    8006a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 20             	pushl  0x20(%ebp)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069b:	ff 4d 1c             	decl   0x1c(%ebp)
  80069e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a2:	7f e6                	jg     80068a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	53                   	push   %ebx
  8006b3:	51                   	push   %ecx
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	e8 41 2b 00 00       	call   8031fc <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 d4 39 80 00       	add    $0x8039d4,%eax
  8006c3:	8a 00                	mov    (%eax),%al
  8006c5:	0f be c0             	movsbl %al,%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
}
  8006d7:	90                   	nop
  8006d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e4:	7e 1c                	jle    800702 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	8d 50 08             	lea    0x8(%eax),%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 10                	mov    %edx,(%eax)
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	83 e8 08             	sub    $0x8,%eax
  8006fb:	8b 50 04             	mov    0x4(%eax),%edx
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	eb 40                	jmp    800742 <getuint+0x65>
	else if (lflag)
  800702:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800706:	74 1e                	je     800726 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 10                	mov    %edx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	83 e8 04             	sub    $0x4,%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	eb 1c                	jmp    800742 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800747:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074b:	7e 1c                	jle    800769 <getint+0x25>
		return va_arg(*ap, long long);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 08             	lea    0x8(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 08             	sub    $0x8,%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	eb 38                	jmp    8007a1 <getint+0x5d>
	else if (lflag)
  800769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076d:	74 1a                	je     800789 <getint+0x45>
		return va_arg(*ap, long);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	99                   	cltd   
  800787:	eb 18                	jmp    8007a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	99                   	cltd   
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	56                   	push   %esi
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	eb 17                	jmp    8007c4 <vprintfmt+0x21>
			if (ch == '\0')
  8007ad:	85 db                	test   %ebx,%ebx
  8007af:	0f 84 af 03 00 00    	je     800b64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8007cd:	8a 00                	mov    (%eax),%al
  8007cf:	0f b6 d8             	movzbl %al,%ebx
  8007d2:	83 fb 25             	cmp    $0x25,%ebx
  8007d5:	75 d6                	jne    8007ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800808:	83 f8 55             	cmp    $0x55,%eax
  80080b:	0f 87 2b 03 00 00    	ja     800b3c <vprintfmt+0x399>
  800811:	8b 04 85 f8 39 80 00 	mov    0x8039f8(,%eax,4),%eax
  800818:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80081e:	eb d7                	jmp    8007f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800820:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800824:	eb d1                	jmp    8007f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80082d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800830:	89 d0                	mov    %edx,%eax
  800832:	c1 e0 02             	shl    $0x2,%eax
  800835:	01 d0                	add    %edx,%eax
  800837:	01 c0                	add    %eax,%eax
  800839:	01 d8                	add    %ebx,%eax
  80083b:	83 e8 30             	sub    $0x30,%eax
  80083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800849:	83 fb 2f             	cmp    $0x2f,%ebx
  80084c:	7e 3e                	jle    80088c <vprintfmt+0xe9>
  80084e:	83 fb 39             	cmp    $0x39,%ebx
  800851:	7f 39                	jg     80088c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800856:	eb d5                	jmp    80082d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80086c:	eb 1f                	jmp    80088d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800872:	79 83                	jns    8007f7 <vprintfmt+0x54>
				width = 0;
  800874:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087b:	e9 77 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800880:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800887:	e9 6b ff ff ff       	jmp    8007f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80088c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	0f 89 60 ff ff ff    	jns    8007f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a4:	e9 4e ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ac:	e9 46 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			break;
  8008d1:	e9 89 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 c0 04             	add    $0x4,%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	83 e8 04             	sub    $0x4,%eax
  8008e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	79 02                	jns    8008ed <vprintfmt+0x14a>
				err = -err;
  8008eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ed:	83 fb 64             	cmp    $0x64,%ebx
  8008f0:	7f 0b                	jg     8008fd <vprintfmt+0x15a>
  8008f2:	8b 34 9d 40 38 80 00 	mov    0x803840(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 e5 39 80 00       	push   $0x8039e5
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 5e 02 00 00       	call   800b6c <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 49 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	56                   	push   %esi
  800917:	68 ee 39 80 00       	push   $0x8039ee
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 45 02 00 00       	call   800b6c <printfmt>
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 30 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 30                	mov    (%eax),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 05                	jne    800949 <vprintfmt+0x1a6>
				p = "(null)";
  800944:	be f1 39 80 00       	mov    $0x8039f1,%esi
			if (width > 0 && padc != '-')
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7e 6d                	jle    8009bc <vprintfmt+0x219>
  80094f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800953:	74 67                	je     8009bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	50                   	push   %eax
  80095c:	56                   	push   %esi
  80095d:	e8 0c 03 00 00       	call   800c6e <strnlen>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800968:	eb 16                	jmp    800980 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	ff 4d e4             	decl   -0x1c(%ebp)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	7f e4                	jg     80096a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	eb 34                	jmp    8009bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098c:	74 1c                	je     8009aa <vprintfmt+0x207>
  80098e:	83 fb 1f             	cmp    $0x1f,%ebx
  800991:	7e 05                	jle    800998 <vprintfmt+0x1f5>
  800993:	83 fb 7e             	cmp    $0x7e,%ebx
  800996:	7e 12                	jle    8009aa <vprintfmt+0x207>
					putch('?', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	6a 3f                	push   $0x3f
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	89 f0                	mov    %esi,%eax
  8009be:	8d 70 01             	lea    0x1(%eax),%esi
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	74 24                	je     8009ee <vprintfmt+0x24b>
  8009ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ce:	78 b8                	js     800988 <vprintfmt+0x1e5>
  8009d0:	ff 4d e0             	decl   -0x20(%ebp)
  8009d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d7:	79 af                	jns    800988 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d9:	eb 13                	jmp    8009ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 20                	push   $0x20
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f2:	7f e7                	jg     8009db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f4:	e9 66 01 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	50                   	push   %eax
  800a03:	e8 3c fd ff ff       	call   800744 <getint>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a17:	85 d2                	test   %edx,%edx
  800a19:	79 23                	jns    800a3e <vprintfmt+0x29b>
				putch('-', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 2d                	push   $0x2d
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a31:	f7 d8                	neg    %eax
  800a33:	83 d2 00             	adc    $0x0,%edx
  800a36:	f7 da                	neg    %edx
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a45:	e9 bc 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	e8 84 fc ff ff       	call   8006dd <getuint>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a69:	e9 98 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 30                	push   $0x30
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 78                	push   $0x78
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 14             	mov    %eax,0x14(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 e8 04             	sub    $0x4,%eax
  800ad2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ade:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae5:	eb 1f                	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 e8             	pushl  -0x18(%ebp)
  800aed:	8d 45 14             	lea    0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 e7 fb ff ff       	call   8006dd <getuint>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	52                   	push   %edx
  800b11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	ff 75 08             	pushl  0x8(%ebp)
  800b21:	e8 00 fb ff ff       	call   800626 <printnum>
  800b26:	83 c4 20             	add    $0x20,%esp
			break;
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
			break;
  800b3a:	eb 23                	jmp    800b5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 25                	push   $0x25
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4c:	ff 4d 10             	decl   0x10(%ebp)
  800b4f:	eb 03                	jmp    800b54 <vprintfmt+0x3b1>
  800b51:	ff 4d 10             	decl   0x10(%ebp)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	48                   	dec    %eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	3c 25                	cmp    $0x25,%al
  800b5c:	75 f3                	jne    800b51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b5e:	90                   	nop
		}
	}
  800b5f:	e9 47 fc ff ff       	jmp    8007ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b72:	8d 45 10             	lea    0x10(%ebp),%eax
  800b75:	83 c0 04             	add    $0x4,%eax
  800b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	50                   	push   %eax
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 16 fc ff ff       	call   8007a3 <vprintfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b90:	90                   	nop
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8b 40 08             	mov    0x8(%eax),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8b 10                	mov    (%eax),%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 40 04             	mov    0x4(%eax),%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	73 12                	jae    800bc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	89 0a                	mov    %ecx,(%edx)
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	88 10                	mov    %dl,(%eax)
}
  800bc6:	90                   	nop
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 06                	je     800bf6 <vsnprintf+0x2d>
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	7f 07                	jg     800bfd <vsnprintf+0x34>
		return -E_INVAL;
  800bf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfb:	eb 20                	jmp    800c1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfd:	ff 75 14             	pushl  0x14(%ebp)
  800c00:	ff 75 10             	pushl  0x10(%ebp)
  800c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 93 0b 80 00       	push   $0x800b93
  800c0c:	e8 92 fb ff ff       	call   8007a3 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c25:	8d 45 10             	lea    0x10(%ebp),%eax
  800c28:	83 c0 04             	add    $0x4,%eax
  800c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	50                   	push   %eax
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	ff 75 08             	pushl  0x8(%ebp)
  800c3b:	e8 89 ff ff ff       	call   800bc9 <vsnprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 06                	jmp    800c60 <strlen+0x15>
		n++;
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 f1                	jne    800c5a <strlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 09                	jmp    800c86 <strnlen+0x18>
		n++;
  800c7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	ff 4d 0c             	decl   0xc(%ebp)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 09                	je     800c95 <strnlen+0x27>
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e8                	jne    800c7d <strnlen+0xf>
		n++;
	return n;
  800c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca6:	90                   	nop
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb9:	8a 12                	mov    (%edx),%dl
  800cbb:	88 10                	mov    %dl,(%eax)
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 e4                	jne    800ca7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdb:	eb 1f                	jmp    800cfc <strncpy+0x34>
		*dst++ = *src;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8d 50 01             	lea    0x1(%eax),%edx
  800ce3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 03                	je     800cf9 <strncpy+0x31>
			src++;
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf9:	ff 45 fc             	incl   -0x4(%ebp)
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d02:	72 d9                	jb     800cdd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 30                	je     800d4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1b:	eb 16                	jmp    800d33 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 08             	mov    %edx,0x8(%ebp)
  800d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2f:	8a 12                	mov    (%edx),%dl
  800d31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3a:	74 09                	je     800d45 <strlcpy+0x3c>
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 d8                	jne    800d1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5a:	eb 06                	jmp    800d62 <strcmp+0xb>
		p++, q++;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	74 0e                	je     800d79 <strcmp+0x22>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	38 c2                	cmp    %al,%dl
  800d77:	74 e3                	je     800d5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d92:	eb 09                	jmp    800d9d <strncmp+0xe>
		n--, p++, q++;
  800d94:	ff 4d 10             	decl   0x10(%ebp)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 17                	je     800dba <strncmp+0x2b>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	74 0e                	je     800dba <strncmp+0x2b>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 da                	je     800d94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbe:	75 07                	jne    800dc7 <strncmp+0x38>
		return 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc5:	eb 14                	jmp    800ddb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de9:	eb 12                	jmp    800dfd <strchr+0x20>
		if (*s == c)
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df3:	75 05                	jne    800dfa <strchr+0x1d>
			return (char *) s;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	eb 11                	jmp    800e0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	75 e5                	jne    800deb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 0d                	jmp    800e28 <strfind+0x1b>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	74 0e                	je     800e33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 ea                	jne    800e1b <strfind+0xe>
  800e31:	eb 01                	jmp    800e34 <strfind+0x27>
		if (*s == c)
			break;
  800e33:	90                   	nop
	return (char *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4b:	eb 0e                	jmp    800e5b <memset+0x22>
		*p++ = c;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5b:	ff 4d f8             	decl   -0x8(%ebp)
  800e5e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e62:	79 e9                	jns    800e4d <memset+0x14>
		*p++ = c;

	return v;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7b:	eb 16                	jmp    800e93 <memcpy+0x2a>
		*d++ = *s++;
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 dd                	jne    800e7d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebd:	73 50                	jae    800f0f <memmove+0x6a>
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	76 43                	jbe    800f0f <memmove+0x6a>
		s += n;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 10                	jmp    800eea <memmove+0x45>
			*--d = *--s;
  800eda:	ff 4d f8             	decl   -0x8(%ebp)
  800edd:	ff 4d fc             	decl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 e3                	jne    800eda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef7:	eb 23                	jmp    800f1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 dd                	jne    800ef9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f33:	eb 2a                	jmp    800f5f <memcmp+0x3e>
		if (*s1 != *s2)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 16                	je     800f59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	eb 18                	jmp    800f71 <memcmp+0x50>
		s1++, s2++;
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 c9                	jne    800f35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f84:	eb 15                	jmp    800f9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	39 c2                	cmp    %eax,%edx
  800f96:	74 0d                	je     800fa5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa1:	72 e3                	jb     800f86 <memfind+0x13>
  800fa3:	eb 01                	jmp    800fa6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa5:	90                   	nop
	return (void *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbf:	eb 03                	jmp    800fc4 <strtol+0x19>
		s++;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 20                	cmp    $0x20,%al
  800fcb:	74 f4                	je     800fc1 <strtol+0x16>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 09                	cmp    $0x9,%al
  800fd4:	74 eb                	je     800fc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	75 05                	jne    800fe4 <strtol+0x39>
		s++;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	eb 13                	jmp    800ff7 <strtol+0x4c>
	else if (*s == '-')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 2d                	cmp    $0x2d,%al
  800feb:	75 0a                	jne    800ff7 <strtol+0x4c>
		s++, neg = 1;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	74 06                	je     801003 <strtol+0x58>
  800ffd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801001:	75 20                	jne    801023 <strtol+0x78>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 30                	cmp    $0x30,%al
  80100a:	75 17                	jne    801023 <strtol+0x78>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	40                   	inc    %eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 78                	cmp    $0x78,%al
  801014:	75 0d                	jne    801023 <strtol+0x78>
		s += 2, base = 16;
  801016:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801021:	eb 28                	jmp    80104b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 15                	jne    80103e <strtol+0x93>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 0c                	jne    80103e <strtol+0x93>
		s++, base = 8;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80103c:	eb 0d                	jmp    80104b <strtol+0xa0>
	else if (base == 0)
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 07                	jne    80104b <strtol+0xa0>
		base = 10;
  801044:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2f                	cmp    $0x2f,%al
  801052:	7e 19                	jle    80106d <strtol+0xc2>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	7f 10                	jg     80106d <strtol+0xc2>
			dig = *s - '0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 30             	sub    $0x30,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106b:	eb 42                	jmp    8010af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 60                	cmp    $0x60,%al
  801074:	7e 19                	jle    80108f <strtol+0xe4>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 7a                	cmp    $0x7a,%al
  80107d:	7f 10                	jg     80108f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 57             	sub    $0x57,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 20                	jmp    8010af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 40                	cmp    $0x40,%al
  801096:	7e 39                	jle    8010d1 <strtol+0x126>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 5a                	cmp    $0x5a,%al
  80109f:	7f 30                	jg     8010d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 37             	sub    $0x37,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b5:	7d 19                	jge    8010d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cb:	e9 7b ff ff ff       	jmp    80104b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d5:	74 08                	je     8010df <strtol+0x134>
		*endptr = (char *) s;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e3:	74 07                	je     8010ec <strtol+0x141>
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	f7 d8                	neg    %eax
  8010ea:	eb 03                	jmp    8010ef <strtol+0x144>
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	79 13                	jns    80111e <ltostr+0x2d>
	{
		neg = 1;
  80110b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801118:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801126:	99                   	cltd   
  801127:	f7 f9                	idiv   %ecx
  801129:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113f:	83 c2 30             	add    $0x30,%edx
  801142:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80115d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801160:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801165:	f7 e9                	imul   %ecx
  801167:	c1 fa 02             	sar    $0x2,%edx
  80116a:	89 c8                	mov    %ecx,%eax
  80116c:	c1 f8 1f             	sar    $0x1f,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	c1 e0 02             	shl    $0x2,%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	01 c0                	add    %eax,%eax
  80117a:	29 c1                	sub    %eax,%ecx
  80117c:	89 ca                	mov    %ecx,%edx
  80117e:	85 d2                	test   %edx,%edx
  801180:	75 9c                	jne    80111e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 3d                	je     8011d3 <ltostr+0xe2>
		start = 1 ;
  801196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80119d:	eb 34                	jmp    8011d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c c4                	jl     80119f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 54 fa ff ff       	call   800c4b <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 46 fa ff ff       	call   800c4b <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 17                	jmp    801232 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 c2                	add    %eax,%edx
  801223:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	01 c8                	add    %ecx,%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122f:	ff 45 fc             	incl   -0x4(%ebp)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801238:	7c e1                	jl     80121b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801241:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801248:	eb 1f                	jmp    801269 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801266:	ff 45 f8             	incl   -0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c d9                	jl     80124a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	eb 0c                	jmp    8012b0 <strsplit+0x31>
			*string++ = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	84 c0                	test   %al,%al
  8012b7:	74 18                	je     8012d1 <strsplit+0x52>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 13 fb ff ff       	call   800ddd <strchr>
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 d3                	jne    8012a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	74 5a                	je     801334 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012da:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 f8 0f             	cmp    $0xf,%eax
  8012e2:	75 07                	jne    8012eb <strsplit+0x6c>
		{
			return 0;
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	eb 66                	jmp    801351 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801309:	eb 03                	jmp    80130e <strsplit+0x8f>
			string++;
  80130b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	74 8b                	je     8012a2 <strsplit+0x23>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	e8 b5 fa ff ff       	call   800ddd <strchr>
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 dc                	je     80130b <strsplit+0x8c>
			string++;
	}
  80132f:	e9 6e ff ff ff       	jmp    8012a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801334:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801359:	a1 04 40 80 00       	mov    0x804004,%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 1f                	je     801381 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801362:	e8 1d 00 00 00       	call   801384 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	68 50 3b 80 00       	push   $0x803b50
  80136f:	e8 55 f2 ff ff       	call   8005c9 <cprintf>
  801374:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801377:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80137e:	00 00 00 
	}
}
  801381:	90                   	nop
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80138a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801391:	00 00 00 
  801394:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80139b:	00 00 00 
  80139e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013a5:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8013a8:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013af:	00 00 00 
  8013b2:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013b9:	00 00 00 
  8013bc:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013c3:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8013c6:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013cd:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8013d0:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8013d7:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013eb:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8013f0:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8013f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ff:	2d 00 10 00 00       	sub    $0x1000,%eax
  801404:	83 ec 04             	sub    $0x4,%esp
  801407:	6a 06                	push   $0x6
  801409:	ff 75 f4             	pushl  -0xc(%ebp)
  80140c:	50                   	push   %eax
  80140d:	e8 ee 05 00 00       	call   801a00 <sys_allocate_chunk>
  801412:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801415:	a1 20 41 80 00       	mov    0x804120,%eax
  80141a:	83 ec 0c             	sub    $0xc,%esp
  80141d:	50                   	push   %eax
  80141e:	e8 63 0c 00 00       	call   802086 <initialize_MemBlocksList>
  801423:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801426:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80142b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  80142e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801431:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801438:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143b:	8b 40 0c             	mov    0xc(%eax),%eax
  80143e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801449:	89 c2                	mov    %eax,%edx
  80144b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144e:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801454:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80145b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801462:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801465:	8b 50 08             	mov    0x8(%eax),%edx
  801468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146b:	01 d0                	add    %edx,%eax
  80146d:	48                   	dec    %eax
  80146e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801471:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801474:	ba 00 00 00 00       	mov    $0x0,%edx
  801479:	f7 75 e0             	divl   -0x20(%ebp)
  80147c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80147f:	29 d0                	sub    %edx,%eax
  801481:	89 c2                	mov    %eax,%edx
  801483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801486:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801489:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80148d:	75 14                	jne    8014a3 <initialize_dyn_block_system+0x11f>
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	68 75 3b 80 00       	push   $0x803b75
  801497:	6a 34                	push   $0x34
  801499:	68 93 3b 80 00       	push   $0x803b93
  80149e:	e8 72 ee ff ff       	call   800315 <_panic>
  8014a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a6:	8b 00                	mov    (%eax),%eax
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	74 10                	je     8014bc <initialize_dyn_block_system+0x138>
  8014ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014b4:	8b 52 04             	mov    0x4(%edx),%edx
  8014b7:	89 50 04             	mov    %edx,0x4(%eax)
  8014ba:	eb 0b                	jmp    8014c7 <initialize_dyn_block_system+0x143>
  8014bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014bf:	8b 40 04             	mov    0x4(%eax),%eax
  8014c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ca:	8b 40 04             	mov    0x4(%eax),%eax
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	74 0f                	je     8014e0 <initialize_dyn_block_system+0x15c>
  8014d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014d4:	8b 40 04             	mov    0x4(%eax),%eax
  8014d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014da:	8b 12                	mov    (%edx),%edx
  8014dc:	89 10                	mov    %edx,(%eax)
  8014de:	eb 0a                	jmp    8014ea <initialize_dyn_block_system+0x166>
  8014e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014e3:	8b 00                	mov    (%eax),%eax
  8014e5:	a3 48 41 80 00       	mov    %eax,0x804148
  8014ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014fd:	a1 54 41 80 00       	mov    0x804154,%eax
  801502:	48                   	dec    %eax
  801503:	a3 54 41 80 00       	mov    %eax,0x804154
			insert_sorted_with_merge_freeList(freeSva);
  801508:	83 ec 0c             	sub    $0xc,%esp
  80150b:	ff 75 e8             	pushl  -0x18(%ebp)
  80150e:	e8 c4 13 00 00       	call   8028d7 <insert_sorted_with_merge_freeList>
  801513:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80151f:	e8 2f fe ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  801524:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801528:	75 07                	jne    801531 <malloc+0x18>
  80152a:	b8 00 00 00 00       	mov    $0x0,%eax
  80152f:	eb 71                	jmp    8015a2 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801531:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801538:	76 07                	jbe    801541 <malloc+0x28>
	return NULL;
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
  80153f:	eb 61                	jmp    8015a2 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801541:	e8 88 08 00 00       	call   801dce <sys_isUHeapPlacementStrategyFIRSTFIT>
  801546:	85 c0                	test   %eax,%eax
  801548:	74 53                	je     80159d <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80154a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801551:	8b 55 08             	mov    0x8(%ebp),%edx
  801554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801557:	01 d0                	add    %edx,%eax
  801559:	48                   	dec    %eax
  80155a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80155d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801560:	ba 00 00 00 00       	mov    $0x0,%edx
  801565:	f7 75 f4             	divl   -0xc(%ebp)
  801568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156b:	29 d0                	sub    %edx,%eax
  80156d:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801570:	83 ec 0c             	sub    $0xc,%esp
  801573:	ff 75 ec             	pushl  -0x14(%ebp)
  801576:	e8 d2 0d 00 00       	call   80234d <alloc_block_FF>
  80157b:	83 c4 10             	add    $0x10,%esp
  80157e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801581:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801585:	74 16                	je     80159d <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801587:	83 ec 0c             	sub    $0xc,%esp
  80158a:	ff 75 e8             	pushl  -0x18(%ebp)
  80158d:	e8 0c 0c 00 00       	call   80219e <insert_sorted_allocList>
  801592:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801598:	8b 40 08             	mov    0x8(%eax),%eax
  80159b:	eb 05                	jmp    8015a2 <malloc+0x89>
    }

			}


	return NULL;
  80159d:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	ff 75 f0             	pushl  -0x10(%ebp)
  8015c1:	68 40 40 80 00       	push   $0x804040
  8015c6:	e8 a0 0b 00 00       	call   80216b <find_block>
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8015d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	52                   	push   %edx
  8015de:	50                   	push   %eax
  8015df:	e8 e4 03 00 00       	call   8019c8 <sys_free_user_mem>
  8015e4:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8015e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015eb:	75 17                	jne    801604 <free+0x60>
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	68 75 3b 80 00       	push   $0x803b75
  8015f5:	68 84 00 00 00       	push   $0x84
  8015fa:	68 93 3b 80 00       	push   $0x803b93
  8015ff:	e8 11 ed ff ff       	call   800315 <_panic>
  801604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801607:	8b 00                	mov    (%eax),%eax
  801609:	85 c0                	test   %eax,%eax
  80160b:	74 10                	je     80161d <free+0x79>
  80160d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801610:	8b 00                	mov    (%eax),%eax
  801612:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801615:	8b 52 04             	mov    0x4(%edx),%edx
  801618:	89 50 04             	mov    %edx,0x4(%eax)
  80161b:	eb 0b                	jmp    801628 <free+0x84>
  80161d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801620:	8b 40 04             	mov    0x4(%eax),%eax
  801623:	a3 44 40 80 00       	mov    %eax,0x804044
  801628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162b:	8b 40 04             	mov    0x4(%eax),%eax
  80162e:	85 c0                	test   %eax,%eax
  801630:	74 0f                	je     801641 <free+0x9d>
  801632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801635:	8b 40 04             	mov    0x4(%eax),%eax
  801638:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80163b:	8b 12                	mov    (%edx),%edx
  80163d:	89 10                	mov    %edx,(%eax)
  80163f:	eb 0a                	jmp    80164b <free+0xa7>
  801641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801644:	8b 00                	mov    (%eax),%eax
  801646:	a3 40 40 80 00       	mov    %eax,0x804040
  80164b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801654:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801657:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80165e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801663:	48                   	dec    %eax
  801664:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(returned_block);
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	ff 75 ec             	pushl  -0x14(%ebp)
  80166f:	e8 63 12 00 00       	call   8028d7 <insert_sorted_with_merge_freeList>
  801674:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801677:	90                   	nop
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 38             	sub    $0x38,%esp
  801680:	8b 45 10             	mov    0x10(%ebp),%eax
  801683:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801686:	e8 c8 fc ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  80168b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168f:	75 0a                	jne    80169b <smalloc+0x21>
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
  801696:	e9 a0 00 00 00       	jmp    80173b <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80169b:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016a2:	76 0a                	jbe    8016ae <smalloc+0x34>
		return NULL;
  8016a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a9:	e9 8d 00 00 00       	jmp    80173b <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ae:	e8 1b 07 00 00       	call   801dce <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	74 7f                	je     801736 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8016b7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	48                   	dec    %eax
  8016c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d2:	f7 75 f4             	divl   -0xc(%ebp)
  8016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d8:	29 d0                	sub    %edx,%eax
  8016da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8016dd:	83 ec 0c             	sub    $0xc,%esp
  8016e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8016e3:	e8 65 0c 00 00       	call   80234d <alloc_block_FF>
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8016ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016f2:	74 42                	je     801736 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8016f4:	83 ec 0c             	sub    $0xc,%esp
  8016f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8016fa:	e8 9f 0a 00 00       	call   80219e <insert_sorted_allocList>
  8016ff:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801705:	8b 40 08             	mov    0x8(%eax),%eax
  801708:	89 c2                	mov    %eax,%edx
  80170a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80170e:	52                   	push   %edx
  80170f:	50                   	push   %eax
  801710:	ff 75 0c             	pushl  0xc(%ebp)
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	e8 38 04 00 00       	call   801b53 <sys_createSharedObject>
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801721:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801725:	79 07                	jns    80172e <smalloc+0xb4>
	    		  return NULL;
  801727:	b8 00 00 00 00       	mov    $0x0,%eax
  80172c:	eb 0d                	jmp    80173b <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80172e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801731:	8b 40 08             	mov    0x8(%eax),%eax
  801734:	eb 05                	jmp    80173b <smalloc+0xc1>


				}


		return NULL;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801743:	e8 0b fc ff ff       	call   801353 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801748:	e8 81 06 00 00       	call   801dce <sys_isUHeapPlacementStrategyFIRSTFIT>
  80174d:	85 c0                	test   %eax,%eax
  80174f:	0f 84 9f 00 00 00    	je     8017f4 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	ff 75 0c             	pushl  0xc(%ebp)
  80175b:	ff 75 08             	pushl  0x8(%ebp)
  80175e:	e8 1a 04 00 00       	call   801b7d <sys_getSizeOfSharedObject>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80176d:	79 0a                	jns    801779 <sget+0x3c>
		return NULL;
  80176f:	b8 00 00 00 00       	mov    $0x0,%eax
  801774:	e9 80 00 00 00       	jmp    8017f9 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801779:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801786:	01 d0                	add    %edx,%eax
  801788:	48                   	dec    %eax
  801789:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80178c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178f:	ba 00 00 00 00       	mov    $0x0,%edx
  801794:	f7 75 f0             	divl   -0x10(%ebp)
  801797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179a:	29 d0                	sub    %edx,%eax
  80179c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80179f:	83 ec 0c             	sub    $0xc,%esp
  8017a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8017a5:	e8 a3 0b 00 00       	call   80234d <alloc_block_FF>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  8017b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017b4:	74 3e                	je     8017f4 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  8017b6:	83 ec 0c             	sub    $0xc,%esp
  8017b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017bc:	e8 dd 09 00 00       	call   80219e <insert_sorted_allocList>
  8017c1:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8017c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c7:	8b 40 08             	mov    0x8(%eax),%eax
  8017ca:	83 ec 04             	sub    $0x4,%esp
  8017cd:	50                   	push   %eax
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	ff 75 08             	pushl  0x8(%ebp)
  8017d4:	e8 c1 03 00 00       	call   801b9a <sys_getSharedObject>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8017df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017e3:	79 07                	jns    8017ec <sget+0xaf>
	    		  return NULL;
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ea:	eb 0d                	jmp    8017f9 <sget+0xbc>
	  	return(void*) returned_block->sva;
  8017ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ef:	8b 40 08             	mov    0x8(%eax),%eax
  8017f2:	eb 05                	jmp    8017f9 <sget+0xbc>
	      }
	}
	   return NULL;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801801:	e8 4d fb ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	68 a0 3b 80 00       	push   $0x803ba0
  80180e:	68 12 01 00 00       	push   $0x112
  801813:	68 93 3b 80 00       	push   $0x803b93
  801818:	e8 f8 ea ff ff       	call   800315 <_panic>

0080181d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	68 c8 3b 80 00       	push   $0x803bc8
  80182b:	68 26 01 00 00       	push   $0x126
  801830:	68 93 3b 80 00       	push   $0x803b93
  801835:	e8 db ea ff ff       	call   800315 <_panic>

0080183a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	68 ec 3b 80 00       	push   $0x803bec
  801848:	68 31 01 00 00       	push   $0x131
  80184d:	68 93 3b 80 00       	push   $0x803b93
  801852:	e8 be ea ff ff       	call   800315 <_panic>

00801857 <shrink>:

}
void shrink(uint32 newSize)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	68 ec 3b 80 00       	push   $0x803bec
  801865:	68 36 01 00 00       	push   $0x136
  80186a:	68 93 3b 80 00       	push   $0x803b93
  80186f:	e8 a1 ea ff ff       	call   800315 <_panic>

00801874 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 ec 3b 80 00       	push   $0x803bec
  801882:	68 3b 01 00 00       	push   $0x13b
  801887:	68 93 3b 80 00       	push   $0x803b93
  80188c:	e8 84 ea ff ff       	call   800315 <_panic>

00801891 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	57                   	push   %edi
  801895:	56                   	push   %esi
  801896:	53                   	push   %ebx
  801897:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018a9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ac:	cd 30                	int    $0x30
  8018ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5e                   	pop    %esi
  8018b9:	5f                   	pop    %edi
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018c8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	52                   	push   %edx
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	50                   	push   %eax
  8018d8:	6a 00                	push   $0x0
  8018da:	e8 b2 ff ff ff       	call   801891 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	90                   	nop
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 01                	push   $0x1
  8018f4:	e8 98 ff ff ff       	call   801891 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	52                   	push   %edx
  80190e:	50                   	push   %eax
  80190f:	6a 05                	push   $0x5
  801911:	e8 7b ff ff ff       	call   801891 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	56                   	push   %esi
  80191f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801920:	8b 75 18             	mov    0x18(%ebp),%esi
  801923:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801926:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
  801931:	51                   	push   %ecx
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 06                	push   $0x6
  801936:	e8 56 ff ff ff       	call   801891 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801941:	5b                   	pop    %ebx
  801942:	5e                   	pop    %esi
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    

00801945 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	52                   	push   %edx
  801955:	50                   	push   %eax
  801956:	6a 07                	push   $0x7
  801958:	e8 34 ff ff ff       	call   801891 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	6a 08                	push   $0x8
  801973:	e8 19 ff ff ff       	call   801891 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 09                	push   $0x9
  80198c:	e8 00 ff ff ff       	call   801891 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 0a                	push   $0xa
  8019a5:	e8 e7 fe ff ff       	call   801891 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 0b                	push   $0xb
  8019be:	e8 ce fe ff ff       	call   801891 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	ff 75 08             	pushl  0x8(%ebp)
  8019d7:	6a 0f                	push   $0xf
  8019d9:	e8 b3 fe ff ff       	call   801891 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
	return;
  8019e1:	90                   	nop
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	ff 75 08             	pushl  0x8(%ebp)
  8019f3:	6a 10                	push   $0x10
  8019f5:	e8 97 fe ff ff       	call   801891 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fd:	90                   	nop
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	ff 75 10             	pushl  0x10(%ebp)
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	ff 75 08             	pushl  0x8(%ebp)
  801a10:	6a 11                	push   $0x11
  801a12:	e8 7a fe ff ff       	call   801891 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1a:	90                   	nop
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 0c                	push   $0xc
  801a2c:	e8 60 fe ff ff       	call   801891 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	ff 75 08             	pushl  0x8(%ebp)
  801a44:	6a 0d                	push   $0xd
  801a46:	e8 46 fe ff ff       	call   801891 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 0e                	push   $0xe
  801a5f:	e8 2d fe ff ff       	call   801891 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	90                   	nop
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 13                	push   $0x13
  801a79:	e8 13 fe ff ff       	call   801891 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 14                	push   $0x14
  801a93:	e8 f9 fd ff ff       	call   801891 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	90                   	nop
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aaa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	50                   	push   %eax
  801ab7:	6a 15                	push   $0x15
  801ab9:	e8 d3 fd ff ff       	call   801891 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	90                   	nop
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 16                	push   $0x16
  801ad3:	e8 b9 fd ff ff       	call   801891 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	90                   	nop
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	50                   	push   %eax
  801aee:	6a 17                	push   $0x17
  801af0:	e8 9c fd ff ff       	call   801891 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	6a 1a                	push   $0x1a
  801b0d:	e8 7f fd ff ff       	call   801891 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	6a 18                	push   $0x18
  801b2a:	e8 62 fd ff ff       	call   801891 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	90                   	nop
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	52                   	push   %edx
  801b45:	50                   	push   %eax
  801b46:	6a 19                	push   $0x19
  801b48:	e8 44 fd ff ff       	call   801891 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	90                   	nop
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b62:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	51                   	push   %ecx
  801b6c:	52                   	push   %edx
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	50                   	push   %eax
  801b71:	6a 1b                	push   $0x1b
  801b73:	e8 19 fd ff ff       	call   801891 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	52                   	push   %edx
  801b8d:	50                   	push   %eax
  801b8e:	6a 1c                	push   $0x1c
  801b90:	e8 fc fc ff ff       	call   801891 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	51                   	push   %ecx
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 1d                	push   $0x1d
  801baf:	e8 dd fc ff ff       	call   801891 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 1e                	push   $0x1e
  801bcc:	e8 c0 fc ff ff       	call   801891 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 1f                	push   $0x1f
  801be5:	e8 a7 fc ff ff       	call   801891 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	ff 75 14             	pushl  0x14(%ebp)
  801bfa:	ff 75 10             	pushl  0x10(%ebp)
  801bfd:	ff 75 0c             	pushl  0xc(%ebp)
  801c00:	50                   	push   %eax
  801c01:	6a 20                	push   $0x20
  801c03:	e8 89 fc ff ff       	call   801891 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	50                   	push   %eax
  801c1c:	6a 21                	push   $0x21
  801c1e:	e8 6e fc ff ff       	call   801891 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	90                   	nop
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	50                   	push   %eax
  801c38:	6a 22                	push   $0x22
  801c3a:	e8 52 fc ff ff       	call   801891 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 02                	push   $0x2
  801c53:	e8 39 fc ff ff       	call   801891 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 03                	push   $0x3
  801c6c:	e8 20 fc ff ff       	call   801891 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 04                	push   $0x4
  801c85:	e8 07 fc ff ff       	call   801891 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_exit_env>:


void sys_exit_env(void)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 23                	push   $0x23
  801c9e:	e8 ee fb ff ff       	call   801891 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	90                   	nop
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801caf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb2:	8d 50 04             	lea    0x4(%eax),%edx
  801cb5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 24                	push   $0x24
  801cc2:	e8 ca fb ff ff       	call   801891 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
	return result;
  801cca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ccd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd3:	89 01                	mov    %eax,(%ecx)
  801cd5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	c9                   	leave  
  801cdc:	c2 04 00             	ret    $0x4

00801cdf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	ff 75 10             	pushl  0x10(%ebp)
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	ff 75 08             	pushl  0x8(%ebp)
  801cef:	6a 12                	push   $0x12
  801cf1:	e8 9b fb ff ff       	call   801891 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf9:	90                   	nop
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_rcr2>:
uint32 sys_rcr2()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 25                	push   $0x25
  801d0b:	e8 81 fb ff ff       	call   801891 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 04             	sub    $0x4,%esp
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d21:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	50                   	push   %eax
  801d2e:	6a 26                	push   $0x26
  801d30:	e8 5c fb ff ff       	call   801891 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
	return ;
  801d38:	90                   	nop
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <rsttst>:
void rsttst()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 28                	push   $0x28
  801d4a:	e8 42 fb ff ff       	call   801891 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 04             	sub    $0x4,%esp
  801d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d61:	8b 55 18             	mov    0x18(%ebp),%edx
  801d64:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	ff 75 10             	pushl  0x10(%ebp)
  801d6d:	ff 75 0c             	pushl  0xc(%ebp)
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	6a 27                	push   $0x27
  801d75:	e8 17 fb ff ff       	call   801891 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7d:	90                   	nop
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <chktst>:
void chktst(uint32 n)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	ff 75 08             	pushl  0x8(%ebp)
  801d8e:	6a 29                	push   $0x29
  801d90:	e8 fc fa ff ff       	call   801891 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
	return ;
  801d98:	90                   	nop
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <inctst>:

void inctst()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 2a                	push   $0x2a
  801daa:	e8 e2 fa ff ff       	call   801891 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
	return ;
  801db2:	90                   	nop
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <gettst>:
uint32 gettst()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 2b                	push   $0x2b
  801dc4:	e8 c8 fa ff ff       	call   801891 <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801de0:	e8 ac fa ff ff       	call   801891 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
  801de8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801deb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801def:	75 07                	jne    801df8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df1:	b8 01 00 00 00       	mov    $0x1,%eax
  801df6:	eb 05                	jmp    801dfd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 2c                	push   $0x2c
  801e11:	e8 7b fa ff ff       	call   801891 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
  801e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e1c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e20:	75 07                	jne    801e29 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e22:	b8 01 00 00 00       	mov    $0x1,%eax
  801e27:	eb 05                	jmp    801e2e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 2c                	push   $0x2c
  801e42:	e8 4a fa ff ff       	call   801891 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
  801e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e4d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e51:	75 07                	jne    801e5a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e53:	b8 01 00 00 00       	mov    $0x1,%eax
  801e58:	eb 05                	jmp    801e5f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 2c                	push   $0x2c
  801e73:	e8 19 fa ff ff       	call   801891 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
  801e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e7e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e82:	75 07                	jne    801e8b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e84:	b8 01 00 00 00       	mov    $0x1,%eax
  801e89:	eb 05                	jmp    801e90 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	ff 75 08             	pushl  0x8(%ebp)
  801ea0:	6a 2d                	push   $0x2d
  801ea2:	e8 ea f9 ff ff       	call   801891 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eaa:	90                   	nop
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	6a 00                	push   $0x0
  801ebf:	53                   	push   %ebx
  801ec0:	51                   	push   %ecx
  801ec1:	52                   	push   %edx
  801ec2:	50                   	push   %eax
  801ec3:	6a 2e                	push   $0x2e
  801ec5:	e8 c7 f9 ff ff       	call   801891 <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
}
  801ecd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	52                   	push   %edx
  801ee2:	50                   	push   %eax
  801ee3:	6a 2f                	push   $0x2f
  801ee5:	e8 a7 f9 ff ff       	call   801891 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	68 fc 3b 80 00       	push   $0x803bfc
  801efd:	e8 c7 e6 ff ff       	call   8005c9 <cprintf>
  801f02:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	68 28 3c 80 00       	push   $0x803c28
  801f14:	e8 b0 e6 ff ff       	call   8005c9 <cprintf>
  801f19:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f1c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f20:	a1 38 41 80 00       	mov    0x804138,%eax
  801f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f28:	eb 56                	jmp    801f80 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2e:	74 1c                	je     801f4c <print_mem_block_lists+0x5d>
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	8b 50 08             	mov    0x8(%eax),%edx
  801f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f39:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f42:	01 c8                	add    %ecx,%eax
  801f44:	39 c2                	cmp    %eax,%edx
  801f46:	73 04                	jae    801f4c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f48:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	8b 50 08             	mov    0x8(%eax),%edx
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 40 0c             	mov    0xc(%eax),%eax
  801f58:	01 c2                	add    %eax,%edx
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	8b 40 08             	mov    0x8(%eax),%eax
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	52                   	push   %edx
  801f64:	50                   	push   %eax
  801f65:	68 3d 3c 80 00       	push   $0x803c3d
  801f6a:	e8 5a e6 ff ff       	call   8005c9 <cprintf>
  801f6f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f78:	a1 40 41 80 00       	mov    0x804140,%eax
  801f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f84:	74 07                	je     801f8d <print_mem_block_lists+0x9e>
  801f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f89:	8b 00                	mov    (%eax),%eax
  801f8b:	eb 05                	jmp    801f92 <print_mem_block_lists+0xa3>
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	a3 40 41 80 00       	mov    %eax,0x804140
  801f97:	a1 40 41 80 00       	mov    0x804140,%eax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	75 8a                	jne    801f2a <print_mem_block_lists+0x3b>
  801fa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa4:	75 84                	jne    801f2a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fa6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801faa:	75 10                	jne    801fbc <print_mem_block_lists+0xcd>
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	68 4c 3c 80 00       	push   $0x803c4c
  801fb4:	e8 10 e6 ff ff       	call   8005c9 <cprintf>
  801fb9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fbc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	68 70 3c 80 00       	push   $0x803c70
  801fcb:	e8 f9 e5 ff ff       	call   8005c9 <cprintf>
  801fd0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fd3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd7:	a1 40 40 80 00       	mov    0x804040,%eax
  801fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdf:	eb 56                	jmp    802037 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe5:	74 1c                	je     802003 <print_mem_block_lists+0x114>
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fea:	8b 50 08             	mov    0x8(%eax),%edx
  801fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff0:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff9:	01 c8                	add    %ecx,%eax
  801ffb:	39 c2                	cmp    %eax,%edx
  801ffd:	73 04                	jae    802003 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fff:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	8b 50 08             	mov    0x8(%eax),%edx
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 40 0c             	mov    0xc(%eax),%eax
  80200f:	01 c2                	add    %eax,%edx
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 40 08             	mov    0x8(%eax),%eax
  802017:	83 ec 04             	sub    $0x4,%esp
  80201a:	52                   	push   %edx
  80201b:	50                   	push   %eax
  80201c:	68 3d 3c 80 00       	push   $0x803c3d
  802021:	e8 a3 e5 ff ff       	call   8005c9 <cprintf>
  802026:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80202f:	a1 48 40 80 00       	mov    0x804048,%eax
  802034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802037:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203b:	74 07                	je     802044 <print_mem_block_lists+0x155>
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	8b 00                	mov    (%eax),%eax
  802042:	eb 05                	jmp    802049 <print_mem_block_lists+0x15a>
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	a3 48 40 80 00       	mov    %eax,0x804048
  80204e:	a1 48 40 80 00       	mov    0x804048,%eax
  802053:	85 c0                	test   %eax,%eax
  802055:	75 8a                	jne    801fe1 <print_mem_block_lists+0xf2>
  802057:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205b:	75 84                	jne    801fe1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80205d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802061:	75 10                	jne    802073 <print_mem_block_lists+0x184>
  802063:	83 ec 0c             	sub    $0xc,%esp
  802066:	68 88 3c 80 00       	push   $0x803c88
  80206b:	e8 59 e5 ff ff       	call   8005c9 <cprintf>
  802070:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	68 fc 3b 80 00       	push   $0x803bfc
  80207b:	e8 49 e5 ff ff       	call   8005c9 <cprintf>
  802080:	83 c4 10             	add    $0x10,%esp

}
  802083:	90                   	nop
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80208c:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802093:	00 00 00 
  802096:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80209d:	00 00 00 
  8020a0:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020a7:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8020aa:	a1 50 40 80 00       	mov    0x804050,%eax
  8020af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8020b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020b9:	e9 9e 00 00 00       	jmp    80215c <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8020be:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c6:	c1 e2 04             	shl    $0x4,%edx
  8020c9:	01 d0                	add    %edx,%eax
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	75 14                	jne    8020e3 <initialize_MemBlocksList+0x5d>
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	68 b0 3c 80 00       	push   $0x803cb0
  8020d7:	6a 48                	push   $0x48
  8020d9:	68 d3 3c 80 00       	push   $0x803cd3
  8020de:	e8 32 e2 ff ff       	call   800315 <_panic>
  8020e3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020eb:	c1 e2 04             	shl    $0x4,%edx
  8020ee:	01 d0                	add    %edx,%eax
  8020f0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020f6:	89 10                	mov    %edx,(%eax)
  8020f8:	8b 00                	mov    (%eax),%eax
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	74 18                	je     802116 <initialize_MemBlocksList+0x90>
  8020fe:	a1 48 41 80 00       	mov    0x804148,%eax
  802103:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802109:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80210c:	c1 e1 04             	shl    $0x4,%ecx
  80210f:	01 ca                	add    %ecx,%edx
  802111:	89 50 04             	mov    %edx,0x4(%eax)
  802114:	eb 12                	jmp    802128 <initialize_MemBlocksList+0xa2>
  802116:	a1 50 40 80 00       	mov    0x804050,%eax
  80211b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211e:	c1 e2 04             	shl    $0x4,%edx
  802121:	01 d0                	add    %edx,%eax
  802123:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802128:	a1 50 40 80 00       	mov    0x804050,%eax
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	c1 e2 04             	shl    $0x4,%edx
  802133:	01 d0                	add    %edx,%eax
  802135:	a3 48 41 80 00       	mov    %eax,0x804148
  80213a:	a1 50 40 80 00       	mov    0x804050,%eax
  80213f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802142:	c1 e2 04             	shl    $0x4,%edx
  802145:	01 d0                	add    %edx,%eax
  802147:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214e:	a1 54 41 80 00       	mov    0x804154,%eax
  802153:	40                   	inc    %eax
  802154:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802159:	ff 45 f4             	incl   -0xc(%ebp)
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802162:	0f 82 56 ff ff ff    	jb     8020be <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802168:	90                   	nop
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8b 00                	mov    (%eax),%eax
  802176:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802179:	eb 18                	jmp    802193 <find_block+0x28>
		{
			if(tmp->sva==va)
  80217b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217e:	8b 40 08             	mov    0x8(%eax),%eax
  802181:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802184:	75 05                	jne    80218b <find_block+0x20>
			{
				return tmp;
  802186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802189:	eb 11                	jmp    80219c <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80218b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218e:	8b 00                	mov    (%eax),%eax
  802190:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802193:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802197:	75 e2                	jne    80217b <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802199:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8021a4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	0f 85 83 00 00 00    	jne    802234 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8021b1:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8021b8:	00 00 00 
  8021bb:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8021c2:	00 00 00 
  8021c5:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8021cc:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d3:	75 14                	jne    8021e9 <insert_sorted_allocList+0x4b>
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	68 b0 3c 80 00       	push   $0x803cb0
  8021dd:	6a 7f                	push   $0x7f
  8021df:	68 d3 3c 80 00       	push   $0x803cd3
  8021e4:	e8 2c e1 ff ff       	call   800315 <_panic>
  8021e9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	89 10                	mov    %edx,(%eax)
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	74 0d                	je     80220a <insert_sorted_allocList+0x6c>
  8021fd:	a1 40 40 80 00       	mov    0x804040,%eax
  802202:	8b 55 08             	mov    0x8(%ebp),%edx
  802205:	89 50 04             	mov    %edx,0x4(%eax)
  802208:	eb 08                	jmp    802212 <insert_sorted_allocList+0x74>
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	a3 44 40 80 00       	mov    %eax,0x804044
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	a3 40 40 80 00       	mov    %eax,0x804040
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802224:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802229:	40                   	inc    %eax
  80222a:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80222f:	e9 16 01 00 00       	jmp    80234a <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 50 08             	mov    0x8(%eax),%edx
  80223a:	a1 44 40 80 00       	mov    0x804044,%eax
  80223f:	8b 40 08             	mov    0x8(%eax),%eax
  802242:	39 c2                	cmp    %eax,%edx
  802244:	76 68                	jbe    8022ae <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802246:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224a:	75 17                	jne    802263 <insert_sorted_allocList+0xc5>
  80224c:	83 ec 04             	sub    $0x4,%esp
  80224f:	68 ec 3c 80 00       	push   $0x803cec
  802254:	68 85 00 00 00       	push   $0x85
  802259:	68 d3 3c 80 00       	push   $0x803cd3
  80225e:	e8 b2 e0 ff ff       	call   800315 <_panic>
  802263:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	89 50 04             	mov    %edx,0x4(%eax)
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8b 40 04             	mov    0x4(%eax),%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	74 0c                	je     802285 <insert_sorted_allocList+0xe7>
  802279:	a1 44 40 80 00       	mov    0x804044,%eax
  80227e:	8b 55 08             	mov    0x8(%ebp),%edx
  802281:	89 10                	mov    %edx,(%eax)
  802283:	eb 08                	jmp    80228d <insert_sorted_allocList+0xef>
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 40 40 80 00       	mov    %eax,0x804040
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	a3 44 40 80 00       	mov    %eax,0x804044
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80229e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a3:	40                   	inc    %eax
  8022a4:	a3 4c 40 80 00       	mov    %eax,0x80404c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8022a9:	e9 9c 00 00 00       	jmp    80234a <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8022ae:	a1 40 40 80 00       	mov    0x804040,%eax
  8022b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8022b6:	e9 85 00 00 00       	jmp    802340 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	8b 50 08             	mov    0x8(%eax),%edx
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 40 08             	mov    0x8(%eax),%eax
  8022c7:	39 c2                	cmp    %eax,%edx
  8022c9:	73 6d                	jae    802338 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8022cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cf:	74 06                	je     8022d7 <insert_sorted_allocList+0x139>
  8022d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d5:	75 17                	jne    8022ee <insert_sorted_allocList+0x150>
  8022d7:	83 ec 04             	sub    $0x4,%esp
  8022da:	68 10 3d 80 00       	push   $0x803d10
  8022df:	68 90 00 00 00       	push   $0x90
  8022e4:	68 d3 3c 80 00       	push   $0x803cd3
  8022e9:	e8 27 e0 ff ff       	call   800315 <_panic>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 50 04             	mov    0x4(%eax),%edx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	89 50 04             	mov    %edx,0x4(%eax)
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802300:	89 10                	mov    %edx,(%eax)
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 40 04             	mov    0x4(%eax),%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	74 0d                	je     802319 <insert_sorted_allocList+0x17b>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	8b 55 08             	mov    0x8(%ebp),%edx
  802315:	89 10                	mov    %edx,(%eax)
  802317:	eb 08                	jmp    802321 <insert_sorted_allocList+0x183>
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	a3 40 40 80 00       	mov    %eax,0x804040
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 55 08             	mov    0x8(%ebp),%edx
  802327:	89 50 04             	mov    %edx,0x4(%eax)
  80232a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232f:	40                   	inc    %eax
  802330:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802335:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802336:	eb 12                	jmp    80234a <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	8b 00                	mov    (%eax),%eax
  80233d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802344:	0f 85 71 ff ff ff    	jne    8022bb <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80234a:	90                   	nop
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802353:	a1 38 41 80 00       	mov    0x804138,%eax
  802358:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80235b:	e9 76 01 00 00       	jmp    8024d6 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 40 0c             	mov    0xc(%eax),%eax
  802366:	3b 45 08             	cmp    0x8(%ebp),%eax
  802369:	0f 85 8a 00 00 00    	jne    8023f9 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  80236f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802373:	75 17                	jne    80238c <alloc_block_FF+0x3f>
  802375:	83 ec 04             	sub    $0x4,%esp
  802378:	68 45 3d 80 00       	push   $0x803d45
  80237d:	68 a8 00 00 00       	push   $0xa8
  802382:	68 d3 3c 80 00       	push   $0x803cd3
  802387:	e8 89 df ff ff       	call   800315 <_panic>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	85 c0                	test   %eax,%eax
  802393:	74 10                	je     8023a5 <alloc_block_FF+0x58>
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239d:	8b 52 04             	mov    0x4(%edx),%edx
  8023a0:	89 50 04             	mov    %edx,0x4(%eax)
  8023a3:	eb 0b                	jmp    8023b0 <alloc_block_FF+0x63>
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 40 04             	mov    0x4(%eax),%eax
  8023ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 40 04             	mov    0x4(%eax),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	74 0f                	je     8023c9 <alloc_block_FF+0x7c>
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 40 04             	mov    0x4(%eax),%eax
  8023c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c3:	8b 12                	mov    (%edx),%edx
  8023c5:	89 10                	mov    %edx,(%eax)
  8023c7:	eb 0a                	jmp    8023d3 <alloc_block_FF+0x86>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	a3 38 41 80 00       	mov    %eax,0x804138
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8023eb:	48                   	dec    %eax
  8023ec:	a3 44 41 80 00       	mov    %eax,0x804144

			return tmp;
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	e9 ea 00 00 00       	jmp    8024e3 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802402:	0f 86 c6 00 00 00    	jbe    8024ce <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802408:	a1 48 41 80 00       	mov    0x804148,%eax
  80240d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802413:	8b 55 08             	mov    0x8(%ebp),%edx
  802416:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 50 08             	mov    0x8(%eax),%edx
  80241f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802422:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802428:	8b 40 0c             	mov    0xc(%eax),%eax
  80242b:	2b 45 08             	sub    0x8(%ebp),%eax
  80242e:	89 c2                	mov    %eax,%edx
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 50 08             	mov    0x8(%eax),%edx
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	01 c2                	add    %eax,%edx
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802447:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80244b:	75 17                	jne    802464 <alloc_block_FF+0x117>
  80244d:	83 ec 04             	sub    $0x4,%esp
  802450:	68 45 3d 80 00       	push   $0x803d45
  802455:	68 b6 00 00 00       	push   $0xb6
  80245a:	68 d3 3c 80 00       	push   $0x803cd3
  80245f:	e8 b1 de ff ff       	call   800315 <_panic>
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	74 10                	je     80247d <alloc_block_FF+0x130>
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802475:	8b 52 04             	mov    0x4(%edx),%edx
  802478:	89 50 04             	mov    %edx,0x4(%eax)
  80247b:	eb 0b                	jmp    802488 <alloc_block_FF+0x13b>
  80247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802480:	8b 40 04             	mov    0x4(%eax),%eax
  802483:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248b:	8b 40 04             	mov    0x4(%eax),%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	74 0f                	je     8024a1 <alloc_block_FF+0x154>
  802492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802495:	8b 40 04             	mov    0x4(%eax),%eax
  802498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80249b:	8b 12                	mov    (%edx),%edx
  80249d:	89 10                	mov    %edx,(%eax)
  80249f:	eb 0a                	jmp    8024ab <alloc_block_FF+0x15e>
  8024a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	a3 48 41 80 00       	mov    %eax,0x804148
  8024ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024be:	a1 54 41 80 00       	mov    0x804154,%eax
  8024c3:	48                   	dec    %eax
  8024c4:	a3 54 41 80 00       	mov    %eax,0x804154
			 return newBlock;
  8024c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cc:	eb 15                	jmp    8024e3 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8024d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024da:	0f 85 80 fe ff ff    	jne    802360 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8024eb:	a1 38 41 80 00       	mov    0x804138,%eax
  8024f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8024f3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8024fa:	e9 c0 00 00 00       	jmp    8025bf <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 40 0c             	mov    0xc(%eax),%eax
  802505:	3b 45 08             	cmp    0x8(%ebp),%eax
  802508:	0f 85 8a 00 00 00    	jne    802598 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  80250e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802512:	75 17                	jne    80252b <alloc_block_BF+0x46>
  802514:	83 ec 04             	sub    $0x4,%esp
  802517:	68 45 3d 80 00       	push   $0x803d45
  80251c:	68 cf 00 00 00       	push   $0xcf
  802521:	68 d3 3c 80 00       	push   $0x803cd3
  802526:	e8 ea dd ff ff       	call   800315 <_panic>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 00                	mov    (%eax),%eax
  802530:	85 c0                	test   %eax,%eax
  802532:	74 10                	je     802544 <alloc_block_BF+0x5f>
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 00                	mov    (%eax),%eax
  802539:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253c:	8b 52 04             	mov    0x4(%edx),%edx
  80253f:	89 50 04             	mov    %edx,0x4(%eax)
  802542:	eb 0b                	jmp    80254f <alloc_block_BF+0x6a>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 04             	mov    0x4(%eax),%eax
  80254a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 40 04             	mov    0x4(%eax),%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	74 0f                	je     802568 <alloc_block_BF+0x83>
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 04             	mov    0x4(%eax),%eax
  80255f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802562:	8b 12                	mov    (%edx),%edx
  802564:	89 10                	mov    %edx,(%eax)
  802566:	eb 0a                	jmp    802572 <alloc_block_BF+0x8d>
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	a3 38 41 80 00       	mov    %eax,0x804138
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802585:	a1 44 41 80 00       	mov    0x804144,%eax
  80258a:	48                   	dec    %eax
  80258b:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp;
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	e9 2a 01 00 00       	jmp    8026c2 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 40 0c             	mov    0xc(%eax),%eax
  80259e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025a1:	73 14                	jae    8025b7 <alloc_block_BF+0xd2>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ac:	76 09                	jbe    8025b7 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  8025bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c3:	0f 85 36 ff ff ff    	jne    8024ff <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8025c9:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8025d1:	e9 dd 00 00 00       	jmp    8026b3 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025df:	0f 85 c6 00 00 00    	jne    8026ab <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8025e5:	a1 48 41 80 00       	mov    0x804148,%eax
  8025ea:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 50 08             	mov    0x8(%eax),%edx
  8025f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f6:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8025f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ff:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 50 08             	mov    0x8(%eax),%edx
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	01 c2                	add    %eax,%edx
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 0c             	mov    0xc(%eax),%eax
  802619:	2b 45 08             	sub    0x8(%ebp),%eax
  80261c:	89 c2                	mov    %eax,%edx
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802624:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802628:	75 17                	jne    802641 <alloc_block_BF+0x15c>
  80262a:	83 ec 04             	sub    $0x4,%esp
  80262d:	68 45 3d 80 00       	push   $0x803d45
  802632:	68 eb 00 00 00       	push   $0xeb
  802637:	68 d3 3c 80 00       	push   $0x803cd3
  80263c:	e8 d4 dc ff ff       	call   800315 <_panic>
  802641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	74 10                	je     80265a <alloc_block_BF+0x175>
  80264a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802652:	8b 52 04             	mov    0x4(%edx),%edx
  802655:	89 50 04             	mov    %edx,0x4(%eax)
  802658:	eb 0b                	jmp    802665 <alloc_block_BF+0x180>
  80265a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265d:	8b 40 04             	mov    0x4(%eax),%eax
  802660:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802668:	8b 40 04             	mov    0x4(%eax),%eax
  80266b:	85 c0                	test   %eax,%eax
  80266d:	74 0f                	je     80267e <alloc_block_BF+0x199>
  80266f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802672:	8b 40 04             	mov    0x4(%eax),%eax
  802675:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802678:	8b 12                	mov    (%edx),%edx
  80267a:	89 10                	mov    %edx,(%eax)
  80267c:	eb 0a                	jmp    802688 <alloc_block_BF+0x1a3>
  80267e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	a3 48 41 80 00       	mov    %eax,0x804148
  802688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802694:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269b:	a1 54 41 80 00       	mov    0x804154,%eax
  8026a0:	48                   	dec    %eax
  8026a1:	a3 54 41 80 00       	mov    %eax,0x804154
											 return newBlock;
  8026a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a9:	eb 17                	jmp    8026c2 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  8026b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b7:	0f 85 19 ff ff ff    	jne    8025d6 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8026ca:	a1 40 40 80 00       	mov    0x804040,%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	75 19                	jne    8026ec <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8026d3:	83 ec 0c             	sub    $0xc,%esp
  8026d6:	ff 75 08             	pushl  0x8(%ebp)
  8026d9:	e8 6f fc ff ff       	call   80234d <alloc_block_FF>
  8026de:	83 c4 10             	add    $0x10,%esp
  8026e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	e9 e9 01 00 00       	jmp    8028d5 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8026ec:	a1 44 40 80 00       	mov    0x804044,%eax
  8026f1:	8b 40 08             	mov    0x8(%eax),%eax
  8026f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8026f7:	a1 44 40 80 00       	mov    0x804044,%eax
  8026fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8026ff:	a1 44 40 80 00       	mov    0x804044,%eax
  802704:	8b 40 08             	mov    0x8(%eax),%eax
  802707:	01 d0                	add    %edx,%eax
  802709:	83 ec 08             	sub    $0x8,%esp
  80270c:	50                   	push   %eax
  80270d:	68 38 41 80 00       	push   $0x804138
  802712:	e8 54 fa ff ff       	call   80216b <find_block>
  802717:	83 c4 10             	add    $0x10,%esp
  80271a:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 40 0c             	mov    0xc(%eax),%eax
  802723:	3b 45 08             	cmp    0x8(%ebp),%eax
  802726:	0f 85 9b 00 00 00    	jne    8027c7 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 50 0c             	mov    0xc(%eax),%edx
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 08             	mov    0x8(%eax),%eax
  802738:	01 d0                	add    %edx,%eax
  80273a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  80273d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802741:	75 17                	jne    80275a <alloc_block_NF+0x96>
  802743:	83 ec 04             	sub    $0x4,%esp
  802746:	68 45 3d 80 00       	push   $0x803d45
  80274b:	68 1a 01 00 00       	push   $0x11a
  802750:	68 d3 3c 80 00       	push   $0x803cd3
  802755:	e8 bb db ff ff       	call   800315 <_panic>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	85 c0                	test   %eax,%eax
  802761:	74 10                	je     802773 <alloc_block_NF+0xaf>
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 00                	mov    (%eax),%eax
  802768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276b:	8b 52 04             	mov    0x4(%edx),%edx
  80276e:	89 50 04             	mov    %edx,0x4(%eax)
  802771:	eb 0b                	jmp    80277e <alloc_block_NF+0xba>
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 04             	mov    0x4(%eax),%eax
  802779:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 40 04             	mov    0x4(%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 0f                	je     802797 <alloc_block_NF+0xd3>
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802791:	8b 12                	mov    (%edx),%edx
  802793:	89 10                	mov    %edx,(%eax)
  802795:	eb 0a                	jmp    8027a1 <alloc_block_NF+0xdd>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b4:	a1 44 41 80 00       	mov    0x804144,%eax
  8027b9:	48                   	dec    %eax
  8027ba:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp1;
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	e9 0e 01 00 00       	jmp    8028d5 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d0:	0f 86 cf 00 00 00    	jbe    8028a5 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8027d6:	a1 48 41 80 00       	mov    0x804148,%eax
  8027db:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8027de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e4:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 50 08             	mov    0x8(%eax),%edx
  8027ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f0:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 50 08             	mov    0x8(%eax),%edx
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	01 c2                	add    %eax,%edx
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 40 0c             	mov    0xc(%eax),%eax
  80280a:	2b 45 08             	sub    0x8(%ebp),%eax
  80280d:	89 c2                	mov    %eax,%edx
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 40 08             	mov    0x8(%eax),%eax
  80281b:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80281e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802822:	75 17                	jne    80283b <alloc_block_NF+0x177>
  802824:	83 ec 04             	sub    $0x4,%esp
  802827:	68 45 3d 80 00       	push   $0x803d45
  80282c:	68 28 01 00 00       	push   $0x128
  802831:	68 d3 3c 80 00       	push   $0x803cd3
  802836:	e8 da da ff ff       	call   800315 <_panic>
  80283b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283e:	8b 00                	mov    (%eax),%eax
  802840:	85 c0                	test   %eax,%eax
  802842:	74 10                	je     802854 <alloc_block_NF+0x190>
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80284c:	8b 52 04             	mov    0x4(%edx),%edx
  80284f:	89 50 04             	mov    %edx,0x4(%eax)
  802852:	eb 0b                	jmp    80285f <alloc_block_NF+0x19b>
  802854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802857:	8b 40 04             	mov    0x4(%eax),%eax
  80285a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80285f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802862:	8b 40 04             	mov    0x4(%eax),%eax
  802865:	85 c0                	test   %eax,%eax
  802867:	74 0f                	je     802878 <alloc_block_NF+0x1b4>
  802869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286c:	8b 40 04             	mov    0x4(%eax),%eax
  80286f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802872:	8b 12                	mov    (%edx),%edx
  802874:	89 10                	mov    %edx,(%eax)
  802876:	eb 0a                	jmp    802882 <alloc_block_NF+0x1be>
  802878:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	a3 48 41 80 00       	mov    %eax,0x804148
  802882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802885:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802895:	a1 54 41 80 00       	mov    0x804154,%eax
  80289a:	48                   	dec    %eax
  80289b:	a3 54 41 80 00       	mov    %eax,0x804154
					 return newBlock;
  8028a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a3:	eb 30                	jmp    8028d5 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8028a5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8028ad:	75 0a                	jne    8028b9 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  8028af:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b7:	eb 08                	jmp    8028c1 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 40 08             	mov    0x8(%eax),%eax
  8028c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028ca:	0f 85 4d fe ff ff    	jne    80271d <alloc_block_NF+0x59>

			return NULL;
  8028d0:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8028d5:	c9                   	leave  
  8028d6:	c3                   	ret    

008028d7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	53                   	push   %ebx
  8028db:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8028de:	a1 38 41 80 00       	mov    0x804138,%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	0f 85 86 00 00 00    	jne    802971 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8028eb:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8028f2:	00 00 00 
  8028f5:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8028fc:	00 00 00 
  8028ff:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  802906:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802909:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80290d:	75 17                	jne    802926 <insert_sorted_with_merge_freeList+0x4f>
  80290f:	83 ec 04             	sub    $0x4,%esp
  802912:	68 b0 3c 80 00       	push   $0x803cb0
  802917:	68 48 01 00 00       	push   $0x148
  80291c:	68 d3 3c 80 00       	push   $0x803cd3
  802921:	e8 ef d9 ff ff       	call   800315 <_panic>
  802926:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	89 10                	mov    %edx,(%eax)
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	85 c0                	test   %eax,%eax
  802938:	74 0d                	je     802947 <insert_sorted_with_merge_freeList+0x70>
  80293a:	a1 38 41 80 00       	mov    0x804138,%eax
  80293f:	8b 55 08             	mov    0x8(%ebp),%edx
  802942:	89 50 04             	mov    %edx,0x4(%eax)
  802945:	eb 08                	jmp    80294f <insert_sorted_with_merge_freeList+0x78>
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	a3 38 41 80 00       	mov    %eax,0x804138
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802961:	a1 44 41 80 00       	mov    0x804144,%eax
  802966:	40                   	inc    %eax
  802967:	a3 44 41 80 00       	mov    %eax,0x804144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80296c:	e9 73 07 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	8b 50 08             	mov    0x8(%eax),%edx
  802977:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80297c:	8b 40 08             	mov    0x8(%eax),%eax
  80297f:	39 c2                	cmp    %eax,%edx
  802981:	0f 86 84 00 00 00    	jbe    802a0b <insert_sorted_with_merge_freeList+0x134>
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	8b 50 08             	mov    0x8(%eax),%edx
  80298d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802992:	8b 48 0c             	mov    0xc(%eax),%ecx
  802995:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80299a:	8b 40 08             	mov    0x8(%eax),%eax
  80299d:	01 c8                	add    %ecx,%eax
  80299f:	39 c2                	cmp    %eax,%edx
  8029a1:	74 68                	je     802a0b <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8029a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a7:	75 17                	jne    8029c0 <insert_sorted_with_merge_freeList+0xe9>
  8029a9:	83 ec 04             	sub    $0x4,%esp
  8029ac:	68 ec 3c 80 00       	push   $0x803cec
  8029b1:	68 4c 01 00 00       	push   $0x14c
  8029b6:	68 d3 3c 80 00       	push   $0x803cd3
  8029bb:	e8 55 d9 ff ff       	call   800315 <_panic>
  8029c0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	89 50 04             	mov    %edx,0x4(%eax)
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	8b 40 04             	mov    0x4(%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 0c                	je     8029e2 <insert_sorted_with_merge_freeList+0x10b>
  8029d6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029db:	8b 55 08             	mov    0x8(%ebp),%edx
  8029de:	89 10                	mov    %edx,(%eax)
  8029e0:	eb 08                	jmp    8029ea <insert_sorted_with_merge_freeList+0x113>
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fb:	a1 44 41 80 00       	mov    0x804144,%eax
  802a00:	40                   	inc    %eax
  802a01:	a3 44 41 80 00       	mov    %eax,0x804144
  802a06:	e9 d9 06 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	8b 50 08             	mov    0x8(%eax),%edx
  802a11:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a16:	8b 40 08             	mov    0x8(%eax),%eax
  802a19:	39 c2                	cmp    %eax,%edx
  802a1b:	0f 86 b5 00 00 00    	jbe    802ad6 <insert_sorted_with_merge_freeList+0x1ff>
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 50 08             	mov    0x8(%eax),%edx
  802a27:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a2c:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a2f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a34:	8b 40 08             	mov    0x8(%eax),%eax
  802a37:	01 c8                	add    %ecx,%eax
  802a39:	39 c2                	cmp    %eax,%edx
  802a3b:	0f 85 95 00 00 00    	jne    802ad6 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802a41:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a46:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a4c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a52:	8b 52 0c             	mov    0xc(%edx),%edx
  802a55:	01 ca                	add    %ecx,%edx
  802a57:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a72:	75 17                	jne    802a8b <insert_sorted_with_merge_freeList+0x1b4>
  802a74:	83 ec 04             	sub    $0x4,%esp
  802a77:	68 b0 3c 80 00       	push   $0x803cb0
  802a7c:	68 54 01 00 00       	push   $0x154
  802a81:	68 d3 3c 80 00       	push   $0x803cd3
  802a86:	e8 8a d8 ff ff       	call   800315 <_panic>
  802a8b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	89 10                	mov    %edx,(%eax)
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	74 0d                	je     802aac <insert_sorted_with_merge_freeList+0x1d5>
  802a9f:	a1 48 41 80 00       	mov    0x804148,%eax
  802aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa7:	89 50 04             	mov    %edx,0x4(%eax)
  802aaa:	eb 08                	jmp    802ab4 <insert_sorted_with_merge_freeList+0x1dd>
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	a3 48 41 80 00       	mov    %eax,0x804148
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac6:	a1 54 41 80 00       	mov    0x804154,%eax
  802acb:	40                   	inc    %eax
  802acc:	a3 54 41 80 00       	mov    %eax,0x804154
  802ad1:	e9 0e 06 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	8b 50 08             	mov    0x8(%eax),%edx
  802adc:	a1 38 41 80 00       	mov    0x804138,%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	39 c2                	cmp    %eax,%edx
  802ae6:	0f 83 c1 00 00 00    	jae    802bad <insert_sorted_with_merge_freeList+0x2d6>
  802aec:	a1 38 41 80 00       	mov    0x804138,%eax
  802af1:	8b 50 08             	mov    0x8(%eax),%edx
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 48 08             	mov    0x8(%eax),%ecx
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	8b 40 0c             	mov    0xc(%eax),%eax
  802b00:	01 c8                	add    %ecx,%eax
  802b02:	39 c2                	cmp    %eax,%edx
  802b04:	0f 85 a3 00 00 00    	jne    802bad <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802b0a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b12:	8b 52 08             	mov    0x8(%edx),%edx
  802b15:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802b18:	a1 38 41 80 00       	mov    0x804138,%eax
  802b1d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b23:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b26:	8b 55 08             	mov    0x8(%ebp),%edx
  802b29:	8b 52 0c             	mov    0xc(%edx),%edx
  802b2c:	01 ca                	add    %ecx,%edx
  802b2e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b49:	75 17                	jne    802b62 <insert_sorted_with_merge_freeList+0x28b>
  802b4b:	83 ec 04             	sub    $0x4,%esp
  802b4e:	68 b0 3c 80 00       	push   $0x803cb0
  802b53:	68 5d 01 00 00       	push   $0x15d
  802b58:	68 d3 3c 80 00       	push   $0x803cd3
  802b5d:	e8 b3 d7 ff ff       	call   800315 <_panic>
  802b62:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	89 10                	mov    %edx,(%eax)
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0d                	je     802b83 <insert_sorted_with_merge_freeList+0x2ac>
  802b76:	a1 48 41 80 00       	mov    0x804148,%eax
  802b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	eb 08                	jmp    802b8b <insert_sorted_with_merge_freeList+0x2b4>
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	a3 48 41 80 00       	mov    %eax,0x804148
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9d:	a1 54 41 80 00       	mov    0x804154,%eax
  802ba2:	40                   	inc    %eax
  802ba3:	a3 54 41 80 00       	mov    %eax,0x804154
  802ba8:	e9 37 05 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	39 c2                	cmp    %eax,%edx
  802bbd:	0f 83 82 00 00 00    	jae    802c45 <insert_sorted_with_merge_freeList+0x36e>
  802bc3:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc8:	8b 50 08             	mov    0x8(%eax),%edx
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	8b 48 08             	mov    0x8(%eax),%ecx
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd7:	01 c8                	add    %ecx,%eax
  802bd9:	39 c2                	cmp    %eax,%edx
  802bdb:	74 68                	je     802c45 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be1:	75 17                	jne    802bfa <insert_sorted_with_merge_freeList+0x323>
  802be3:	83 ec 04             	sub    $0x4,%esp
  802be6:	68 b0 3c 80 00       	push   $0x803cb0
  802beb:	68 62 01 00 00       	push   $0x162
  802bf0:	68 d3 3c 80 00       	push   $0x803cd3
  802bf5:	e8 1b d7 ff ff       	call   800315 <_panic>
  802bfa:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	89 10                	mov    %edx,(%eax)
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	74 0d                	je     802c1b <insert_sorted_with_merge_freeList+0x344>
  802c0e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c13:	8b 55 08             	mov    0x8(%ebp),%edx
  802c16:	89 50 04             	mov    %edx,0x4(%eax)
  802c19:	eb 08                	jmp    802c23 <insert_sorted_with_merge_freeList+0x34c>
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	a3 38 41 80 00       	mov    %eax,0x804138
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c35:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3a:	40                   	inc    %eax
  802c3b:	a3 44 41 80 00       	mov    %eax,0x804144
  802c40:	e9 9f 04 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802c45:	a1 38 41 80 00       	mov    0x804138,%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802c4f:	e9 84 04 00 00       	jmp    8030d8 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 50 08             	mov    0x8(%eax),%edx
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	39 c2                	cmp    %eax,%edx
  802c62:	0f 86 a9 00 00 00    	jbe    802d11 <insert_sorted_with_merge_freeList+0x43a>
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 50 08             	mov    0x8(%eax),%edx
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 48 08             	mov    0x8(%eax),%ecx
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7a:	01 c8                	add    %ecx,%eax
  802c7c:	39 c2                	cmp    %eax,%edx
  802c7e:	0f 84 8d 00 00 00    	je     802d11 <insert_sorted_with_merge_freeList+0x43a>
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	8b 50 08             	mov    0x8(%eax),%edx
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 04             	mov    0x4(%eax),%eax
  802c90:	8b 48 08             	mov    0x8(%eax),%ecx
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9c:	01 c8                	add    %ecx,%eax
  802c9e:	39 c2                	cmp    %eax,%edx
  802ca0:	74 6f                	je     802d11 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca6:	74 06                	je     802cae <insert_sorted_with_merge_freeList+0x3d7>
  802ca8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cac:	75 17                	jne    802cc5 <insert_sorted_with_merge_freeList+0x3ee>
  802cae:	83 ec 04             	sub    $0x4,%esp
  802cb1:	68 10 3d 80 00       	push   $0x803d10
  802cb6:	68 6b 01 00 00       	push   $0x16b
  802cbb:	68 d3 3c 80 00       	push   $0x803cd3
  802cc0:	e8 50 d6 ff ff       	call   800315 <_panic>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 50 04             	mov    0x4(%eax),%edx
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	89 50 04             	mov    %edx,0x4(%eax)
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 04             	mov    0x4(%eax),%eax
  802cdf:	85 c0                	test   %eax,%eax
  802ce1:	74 0d                	je     802cf0 <insert_sorted_with_merge_freeList+0x419>
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	eb 08                	jmp    802cf8 <insert_sorted_with_merge_freeList+0x421>
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	a3 38 41 80 00       	mov    %eax,0x804138
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfe:	89 50 04             	mov    %edx,0x4(%eax)
  802d01:	a1 44 41 80 00       	mov    0x804144,%eax
  802d06:	40                   	inc    %eax
  802d07:	a3 44 41 80 00       	mov    %eax,0x804144
				break;
  802d0c:	e9 d3 03 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 50 08             	mov    0x8(%eax),%edx
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	8b 40 08             	mov    0x8(%eax),%eax
  802d1d:	39 c2                	cmp    %eax,%edx
  802d1f:	0f 86 da 00 00 00    	jbe    802dff <insert_sorted_with_merge_freeList+0x528>
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 50 08             	mov    0x8(%eax),%edx
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 48 08             	mov    0x8(%eax),%ecx
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c8                	add    %ecx,%eax
  802d39:	39 c2                	cmp    %eax,%edx
  802d3b:	0f 85 be 00 00 00    	jne    802dff <insert_sorted_with_merge_freeList+0x528>
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 50 08             	mov    0x8(%eax),%edx
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	8b 48 08             	mov    0x8(%eax),%ecx
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 40 04             	mov    0x4(%eax),%eax
  802d56:	8b 40 0c             	mov    0xc(%eax),%eax
  802d59:	01 c8                	add    %ecx,%eax
  802d5b:	39 c2                	cmp    %eax,%edx
  802d5d:	0f 84 9c 00 00 00    	je     802dff <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	8b 50 08             	mov    0x8(%eax),%edx
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 50 0c             	mov    0xc(%eax),%edx
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7b:	01 c2                	add    %eax,%edx
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d9b:	75 17                	jne    802db4 <insert_sorted_with_merge_freeList+0x4dd>
  802d9d:	83 ec 04             	sub    $0x4,%esp
  802da0:	68 b0 3c 80 00       	push   $0x803cb0
  802da5:	68 74 01 00 00       	push   $0x174
  802daa:	68 d3 3c 80 00       	push   $0x803cd3
  802daf:	e8 61 d5 ff ff       	call   800315 <_panic>
  802db4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	89 10                	mov    %edx,(%eax)
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	74 0d                	je     802dd5 <insert_sorted_with_merge_freeList+0x4fe>
  802dc8:	a1 48 41 80 00       	mov    0x804148,%eax
  802dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd0:	89 50 04             	mov    %edx,0x4(%eax)
  802dd3:	eb 08                	jmp    802ddd <insert_sorted_with_merge_freeList+0x506>
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	a3 48 41 80 00       	mov    %eax,0x804148
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802def:	a1 54 41 80 00       	mov    0x804154,%eax
  802df4:	40                   	inc    %eax
  802df5:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802dfa:	e9 e5 02 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 50 08             	mov    0x8(%eax),%edx
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	8b 40 08             	mov    0x8(%eax),%eax
  802e0b:	39 c2                	cmp    %eax,%edx
  802e0d:	0f 86 d7 00 00 00    	jbe    802eea <insert_sorted_with_merge_freeList+0x613>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 50 08             	mov    0x8(%eax),%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	8b 48 08             	mov    0x8(%eax),%ecx
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 40 0c             	mov    0xc(%eax),%eax
  802e25:	01 c8                	add    %ecx,%eax
  802e27:	39 c2                	cmp    %eax,%edx
  802e29:	0f 84 bb 00 00 00    	je     802eea <insert_sorted_with_merge_freeList+0x613>
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	8b 48 08             	mov    0x8(%eax),%ecx
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 04             	mov    0x4(%eax),%eax
  802e44:	8b 40 0c             	mov    0xc(%eax),%eax
  802e47:	01 c8                	add    %ecx,%eax
  802e49:	39 c2                	cmp    %eax,%edx
  802e4b:	0f 85 99 00 00 00    	jne    802eea <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	8b 40 0c             	mov    0xc(%eax),%eax
  802e66:	01 c2                	add    %eax,%edx
  802e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6b:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e86:	75 17                	jne    802e9f <insert_sorted_with_merge_freeList+0x5c8>
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	68 b0 3c 80 00       	push   $0x803cb0
  802e90:	68 7d 01 00 00       	push   $0x17d
  802e95:	68 d3 3c 80 00       	push   $0x803cd3
  802e9a:	e8 76 d4 ff ff       	call   800315 <_panic>
  802e9f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	89 10                	mov    %edx,(%eax)
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	85 c0                	test   %eax,%eax
  802eb1:	74 0d                	je     802ec0 <insert_sorted_with_merge_freeList+0x5e9>
  802eb3:	a1 48 41 80 00       	mov    0x804148,%eax
  802eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebb:	89 50 04             	mov    %edx,0x4(%eax)
  802ebe:	eb 08                	jmp    802ec8 <insert_sorted_with_merge_freeList+0x5f1>
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eda:	a1 54 41 80 00       	mov    0x804154,%eax
  802edf:	40                   	inc    %eax
  802ee0:	a3 54 41 80 00       	mov    %eax,0x804154
break;
  802ee5:	e9 fa 01 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 50 08             	mov    0x8(%eax),%edx
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	8b 40 08             	mov    0x8(%eax),%eax
  802ef6:	39 c2                	cmp    %eax,%edx
  802ef8:	0f 86 d2 01 00 00    	jbe    8030d0 <insert_sorted_with_merge_freeList+0x7f9>
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 50 08             	mov    0x8(%eax),%edx
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	8b 48 08             	mov    0x8(%eax),%ecx
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f10:	01 c8                	add    %ecx,%eax
  802f12:	39 c2                	cmp    %eax,%edx
  802f14:	0f 85 b6 01 00 00    	jne    8030d0 <insert_sorted_with_merge_freeList+0x7f9>
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	8b 50 08             	mov    0x8(%eax),%edx
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 40 04             	mov    0x4(%eax),%eax
  802f26:	8b 48 08             	mov    0x8(%eax),%ecx
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 40 04             	mov    0x4(%eax),%eax
  802f2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f32:	01 c8                	add    %ecx,%eax
  802f34:	39 c2                	cmp    %eax,%edx
  802f36:	0f 85 94 01 00 00    	jne    8030d0 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f45:	8b 52 04             	mov    0x4(%edx),%edx
  802f48:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4e:	8b 5a 0c             	mov    0xc(%edx),%ebx
  802f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f54:	8b 52 0c             	mov    0xc(%edx),%edx
  802f57:	01 da                	add    %ebx,%edx
  802f59:	01 ca                	add    %ecx,%edx
  802f5b:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f76:	75 17                	jne    802f8f <insert_sorted_with_merge_freeList+0x6b8>
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	68 45 3d 80 00       	push   $0x803d45
  802f80:	68 86 01 00 00       	push   $0x186
  802f85:	68 d3 3c 80 00       	push   $0x803cd3
  802f8a:	e8 86 d3 ff ff       	call   800315 <_panic>
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 10                	je     802fa8 <insert_sorted_with_merge_freeList+0x6d1>
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa0:	8b 52 04             	mov    0x4(%edx),%edx
  802fa3:	89 50 04             	mov    %edx,0x4(%eax)
  802fa6:	eb 0b                	jmp    802fb3 <insert_sorted_with_merge_freeList+0x6dc>
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0f                	je     802fcc <insert_sorted_with_merge_freeList+0x6f5>
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc6:	8b 12                	mov    (%edx),%edx
  802fc8:	89 10                	mov    %edx,(%eax)
  802fca:	eb 0a                	jmp    802fd6 <insert_sorted_with_merge_freeList+0x6ff>
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	a3 38 41 80 00       	mov    %eax,0x804138
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe9:	a1 44 41 80 00       	mov    0x804144,%eax
  802fee:	48                   	dec    %eax
  802fef:	a3 44 41 80 00       	mov    %eax,0x804144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  802ff4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff8:	75 17                	jne    803011 <insert_sorted_with_merge_freeList+0x73a>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 b0 3c 80 00       	push   $0x803cb0
  803002:	68 87 01 00 00       	push   $0x187
  803007:	68 d3 3c 80 00       	push   $0x803cd3
  80300c:	e8 04 d3 ff ff       	call   800315 <_panic>
  803011:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 0d                	je     803032 <insert_sorted_with_merge_freeList+0x75b>
  803025:	a1 48 41 80 00       	mov    0x804148,%eax
  80302a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	eb 08                	jmp    80303a <insert_sorted_with_merge_freeList+0x763>
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	a3 48 41 80 00       	mov    %eax,0x804148
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304c:	a1 54 41 80 00       	mov    0x804154,%eax
  803051:	40                   	inc    %eax
  803052:	a3 54 41 80 00       	mov    %eax,0x804154
				blockToInsert->sva=0;
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80306b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80306f:	75 17                	jne    803088 <insert_sorted_with_merge_freeList+0x7b1>
  803071:	83 ec 04             	sub    $0x4,%esp
  803074:	68 b0 3c 80 00       	push   $0x803cb0
  803079:	68 8a 01 00 00       	push   $0x18a
  80307e:	68 d3 3c 80 00       	push   $0x803cd3
  803083:	e8 8d d2 ff ff       	call   800315 <_panic>
  803088:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	89 10                	mov    %edx,(%eax)
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 0d                	je     8030a9 <insert_sorted_with_merge_freeList+0x7d2>
  80309c:	a1 48 41 80 00       	mov    0x804148,%eax
  8030a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
  8030a7:	eb 08                	jmp    8030b1 <insert_sorted_with_merge_freeList+0x7da>
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	a3 48 41 80 00       	mov    %eax,0x804148
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c3:	a1 54 41 80 00       	mov    0x804154,%eax
  8030c8:	40                   	inc    %eax
  8030c9:	a3 54 41 80 00       	mov    %eax,0x804154
				break;
  8030ce:	eb 14                	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8030d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030dc:	0f 85 72 fb ff ff    	jne    802c54 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8030e2:	eb 00                	jmp    8030e4 <insert_sorted_with_merge_freeList+0x80d>
  8030e4:	90                   	nop
  8030e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030e8:	c9                   	leave  
  8030e9:	c3                   	ret    
  8030ea:	66 90                	xchg   %ax,%ax

008030ec <__udivdi3>:
  8030ec:	55                   	push   %ebp
  8030ed:	57                   	push   %edi
  8030ee:	56                   	push   %esi
  8030ef:	53                   	push   %ebx
  8030f0:	83 ec 1c             	sub    $0x1c,%esp
  8030f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803103:	89 ca                	mov    %ecx,%edx
  803105:	89 f8                	mov    %edi,%eax
  803107:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80310b:	85 f6                	test   %esi,%esi
  80310d:	75 2d                	jne    80313c <__udivdi3+0x50>
  80310f:	39 cf                	cmp    %ecx,%edi
  803111:	77 65                	ja     803178 <__udivdi3+0x8c>
  803113:	89 fd                	mov    %edi,%ebp
  803115:	85 ff                	test   %edi,%edi
  803117:	75 0b                	jne    803124 <__udivdi3+0x38>
  803119:	b8 01 00 00 00       	mov    $0x1,%eax
  80311e:	31 d2                	xor    %edx,%edx
  803120:	f7 f7                	div    %edi
  803122:	89 c5                	mov    %eax,%ebp
  803124:	31 d2                	xor    %edx,%edx
  803126:	89 c8                	mov    %ecx,%eax
  803128:	f7 f5                	div    %ebp
  80312a:	89 c1                	mov    %eax,%ecx
  80312c:	89 d8                	mov    %ebx,%eax
  80312e:	f7 f5                	div    %ebp
  803130:	89 cf                	mov    %ecx,%edi
  803132:	89 fa                	mov    %edi,%edx
  803134:	83 c4 1c             	add    $0x1c,%esp
  803137:	5b                   	pop    %ebx
  803138:	5e                   	pop    %esi
  803139:	5f                   	pop    %edi
  80313a:	5d                   	pop    %ebp
  80313b:	c3                   	ret    
  80313c:	39 ce                	cmp    %ecx,%esi
  80313e:	77 28                	ja     803168 <__udivdi3+0x7c>
  803140:	0f bd fe             	bsr    %esi,%edi
  803143:	83 f7 1f             	xor    $0x1f,%edi
  803146:	75 40                	jne    803188 <__udivdi3+0x9c>
  803148:	39 ce                	cmp    %ecx,%esi
  80314a:	72 0a                	jb     803156 <__udivdi3+0x6a>
  80314c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803150:	0f 87 9e 00 00 00    	ja     8031f4 <__udivdi3+0x108>
  803156:	b8 01 00 00 00       	mov    $0x1,%eax
  80315b:	89 fa                	mov    %edi,%edx
  80315d:	83 c4 1c             	add    $0x1c,%esp
  803160:	5b                   	pop    %ebx
  803161:	5e                   	pop    %esi
  803162:	5f                   	pop    %edi
  803163:	5d                   	pop    %ebp
  803164:	c3                   	ret    
  803165:	8d 76 00             	lea    0x0(%esi),%esi
  803168:	31 ff                	xor    %edi,%edi
  80316a:	31 c0                	xor    %eax,%eax
  80316c:	89 fa                	mov    %edi,%edx
  80316e:	83 c4 1c             	add    $0x1c,%esp
  803171:	5b                   	pop    %ebx
  803172:	5e                   	pop    %esi
  803173:	5f                   	pop    %edi
  803174:	5d                   	pop    %ebp
  803175:	c3                   	ret    
  803176:	66 90                	xchg   %ax,%ax
  803178:	89 d8                	mov    %ebx,%eax
  80317a:	f7 f7                	div    %edi
  80317c:	31 ff                	xor    %edi,%edi
  80317e:	89 fa                	mov    %edi,%edx
  803180:	83 c4 1c             	add    $0x1c,%esp
  803183:	5b                   	pop    %ebx
  803184:	5e                   	pop    %esi
  803185:	5f                   	pop    %edi
  803186:	5d                   	pop    %ebp
  803187:	c3                   	ret    
  803188:	bd 20 00 00 00       	mov    $0x20,%ebp
  80318d:	89 eb                	mov    %ebp,%ebx
  80318f:	29 fb                	sub    %edi,%ebx
  803191:	89 f9                	mov    %edi,%ecx
  803193:	d3 e6                	shl    %cl,%esi
  803195:	89 c5                	mov    %eax,%ebp
  803197:	88 d9                	mov    %bl,%cl
  803199:	d3 ed                	shr    %cl,%ebp
  80319b:	89 e9                	mov    %ebp,%ecx
  80319d:	09 f1                	or     %esi,%ecx
  80319f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031a3:	89 f9                	mov    %edi,%ecx
  8031a5:	d3 e0                	shl    %cl,%eax
  8031a7:	89 c5                	mov    %eax,%ebp
  8031a9:	89 d6                	mov    %edx,%esi
  8031ab:	88 d9                	mov    %bl,%cl
  8031ad:	d3 ee                	shr    %cl,%esi
  8031af:	89 f9                	mov    %edi,%ecx
  8031b1:	d3 e2                	shl    %cl,%edx
  8031b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031b7:	88 d9                	mov    %bl,%cl
  8031b9:	d3 e8                	shr    %cl,%eax
  8031bb:	09 c2                	or     %eax,%edx
  8031bd:	89 d0                	mov    %edx,%eax
  8031bf:	89 f2                	mov    %esi,%edx
  8031c1:	f7 74 24 0c          	divl   0xc(%esp)
  8031c5:	89 d6                	mov    %edx,%esi
  8031c7:	89 c3                	mov    %eax,%ebx
  8031c9:	f7 e5                	mul    %ebp
  8031cb:	39 d6                	cmp    %edx,%esi
  8031cd:	72 19                	jb     8031e8 <__udivdi3+0xfc>
  8031cf:	74 0b                	je     8031dc <__udivdi3+0xf0>
  8031d1:	89 d8                	mov    %ebx,%eax
  8031d3:	31 ff                	xor    %edi,%edi
  8031d5:	e9 58 ff ff ff       	jmp    803132 <__udivdi3+0x46>
  8031da:	66 90                	xchg   %ax,%ax
  8031dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031e0:	89 f9                	mov    %edi,%ecx
  8031e2:	d3 e2                	shl    %cl,%edx
  8031e4:	39 c2                	cmp    %eax,%edx
  8031e6:	73 e9                	jae    8031d1 <__udivdi3+0xe5>
  8031e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031eb:	31 ff                	xor    %edi,%edi
  8031ed:	e9 40 ff ff ff       	jmp    803132 <__udivdi3+0x46>
  8031f2:	66 90                	xchg   %ax,%ax
  8031f4:	31 c0                	xor    %eax,%eax
  8031f6:	e9 37 ff ff ff       	jmp    803132 <__udivdi3+0x46>
  8031fb:	90                   	nop

008031fc <__umoddi3>:
  8031fc:	55                   	push   %ebp
  8031fd:	57                   	push   %edi
  8031fe:	56                   	push   %esi
  8031ff:	53                   	push   %ebx
  803200:	83 ec 1c             	sub    $0x1c,%esp
  803203:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803207:	8b 74 24 34          	mov    0x34(%esp),%esi
  80320b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80320f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803213:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803217:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80321b:	89 f3                	mov    %esi,%ebx
  80321d:	89 fa                	mov    %edi,%edx
  80321f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803223:	89 34 24             	mov    %esi,(%esp)
  803226:	85 c0                	test   %eax,%eax
  803228:	75 1a                	jne    803244 <__umoddi3+0x48>
  80322a:	39 f7                	cmp    %esi,%edi
  80322c:	0f 86 a2 00 00 00    	jbe    8032d4 <__umoddi3+0xd8>
  803232:	89 c8                	mov    %ecx,%eax
  803234:	89 f2                	mov    %esi,%edx
  803236:	f7 f7                	div    %edi
  803238:	89 d0                	mov    %edx,%eax
  80323a:	31 d2                	xor    %edx,%edx
  80323c:	83 c4 1c             	add    $0x1c,%esp
  80323f:	5b                   	pop    %ebx
  803240:	5e                   	pop    %esi
  803241:	5f                   	pop    %edi
  803242:	5d                   	pop    %ebp
  803243:	c3                   	ret    
  803244:	39 f0                	cmp    %esi,%eax
  803246:	0f 87 ac 00 00 00    	ja     8032f8 <__umoddi3+0xfc>
  80324c:	0f bd e8             	bsr    %eax,%ebp
  80324f:	83 f5 1f             	xor    $0x1f,%ebp
  803252:	0f 84 ac 00 00 00    	je     803304 <__umoddi3+0x108>
  803258:	bf 20 00 00 00       	mov    $0x20,%edi
  80325d:	29 ef                	sub    %ebp,%edi
  80325f:	89 fe                	mov    %edi,%esi
  803261:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803265:	89 e9                	mov    %ebp,%ecx
  803267:	d3 e0                	shl    %cl,%eax
  803269:	89 d7                	mov    %edx,%edi
  80326b:	89 f1                	mov    %esi,%ecx
  80326d:	d3 ef                	shr    %cl,%edi
  80326f:	09 c7                	or     %eax,%edi
  803271:	89 e9                	mov    %ebp,%ecx
  803273:	d3 e2                	shl    %cl,%edx
  803275:	89 14 24             	mov    %edx,(%esp)
  803278:	89 d8                	mov    %ebx,%eax
  80327a:	d3 e0                	shl    %cl,%eax
  80327c:	89 c2                	mov    %eax,%edx
  80327e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803282:	d3 e0                	shl    %cl,%eax
  803284:	89 44 24 04          	mov    %eax,0x4(%esp)
  803288:	8b 44 24 08          	mov    0x8(%esp),%eax
  80328c:	89 f1                	mov    %esi,%ecx
  80328e:	d3 e8                	shr    %cl,%eax
  803290:	09 d0                	or     %edx,%eax
  803292:	d3 eb                	shr    %cl,%ebx
  803294:	89 da                	mov    %ebx,%edx
  803296:	f7 f7                	div    %edi
  803298:	89 d3                	mov    %edx,%ebx
  80329a:	f7 24 24             	mull   (%esp)
  80329d:	89 c6                	mov    %eax,%esi
  80329f:	89 d1                	mov    %edx,%ecx
  8032a1:	39 d3                	cmp    %edx,%ebx
  8032a3:	0f 82 87 00 00 00    	jb     803330 <__umoddi3+0x134>
  8032a9:	0f 84 91 00 00 00    	je     803340 <__umoddi3+0x144>
  8032af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032b3:	29 f2                	sub    %esi,%edx
  8032b5:	19 cb                	sbb    %ecx,%ebx
  8032b7:	89 d8                	mov    %ebx,%eax
  8032b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032bd:	d3 e0                	shl    %cl,%eax
  8032bf:	89 e9                	mov    %ebp,%ecx
  8032c1:	d3 ea                	shr    %cl,%edx
  8032c3:	09 d0                	or     %edx,%eax
  8032c5:	89 e9                	mov    %ebp,%ecx
  8032c7:	d3 eb                	shr    %cl,%ebx
  8032c9:	89 da                	mov    %ebx,%edx
  8032cb:	83 c4 1c             	add    $0x1c,%esp
  8032ce:	5b                   	pop    %ebx
  8032cf:	5e                   	pop    %esi
  8032d0:	5f                   	pop    %edi
  8032d1:	5d                   	pop    %ebp
  8032d2:	c3                   	ret    
  8032d3:	90                   	nop
  8032d4:	89 fd                	mov    %edi,%ebp
  8032d6:	85 ff                	test   %edi,%edi
  8032d8:	75 0b                	jne    8032e5 <__umoddi3+0xe9>
  8032da:	b8 01 00 00 00       	mov    $0x1,%eax
  8032df:	31 d2                	xor    %edx,%edx
  8032e1:	f7 f7                	div    %edi
  8032e3:	89 c5                	mov    %eax,%ebp
  8032e5:	89 f0                	mov    %esi,%eax
  8032e7:	31 d2                	xor    %edx,%edx
  8032e9:	f7 f5                	div    %ebp
  8032eb:	89 c8                	mov    %ecx,%eax
  8032ed:	f7 f5                	div    %ebp
  8032ef:	89 d0                	mov    %edx,%eax
  8032f1:	e9 44 ff ff ff       	jmp    80323a <__umoddi3+0x3e>
  8032f6:	66 90                	xchg   %ax,%ax
  8032f8:	89 c8                	mov    %ecx,%eax
  8032fa:	89 f2                	mov    %esi,%edx
  8032fc:	83 c4 1c             	add    $0x1c,%esp
  8032ff:	5b                   	pop    %ebx
  803300:	5e                   	pop    %esi
  803301:	5f                   	pop    %edi
  803302:	5d                   	pop    %ebp
  803303:	c3                   	ret    
  803304:	3b 04 24             	cmp    (%esp),%eax
  803307:	72 06                	jb     80330f <__umoddi3+0x113>
  803309:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80330d:	77 0f                	ja     80331e <__umoddi3+0x122>
  80330f:	89 f2                	mov    %esi,%edx
  803311:	29 f9                	sub    %edi,%ecx
  803313:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803317:	89 14 24             	mov    %edx,(%esp)
  80331a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80331e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803322:	8b 14 24             	mov    (%esp),%edx
  803325:	83 c4 1c             	add    $0x1c,%esp
  803328:	5b                   	pop    %ebx
  803329:	5e                   	pop    %esi
  80332a:	5f                   	pop    %edi
  80332b:	5d                   	pop    %ebp
  80332c:	c3                   	ret    
  80332d:	8d 76 00             	lea    0x0(%esi),%esi
  803330:	2b 04 24             	sub    (%esp),%eax
  803333:	19 fa                	sbb    %edi,%edx
  803335:	89 d1                	mov    %edx,%ecx
  803337:	89 c6                	mov    %eax,%esi
  803339:	e9 71 ff ff ff       	jmp    8032af <__umoddi3+0xb3>
  80333e:	66 90                	xchg   %ax,%ax
  803340:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803344:	72 ea                	jb     803330 <__umoddi3+0x134>
  803346:	89 d9                	mov    %ebx,%ecx
  803348:	e9 62 ff ff ff       	jmp    8032af <__umoddi3+0xb3>
