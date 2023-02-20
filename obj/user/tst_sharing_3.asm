
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 8a 02 00 00       	call   8002c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800074:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80008c:	68 40 34 80 00       	push   $0x803440
  800091:	6a 12                	push   $0x12
  800093:	68 5c 34 80 00       	push   $0x80345c
  800098:	e8 5f 03 00 00       	call   8003fc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 59 15 00 00       	call   801600 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 74 34 80 00       	push   $0x803474
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 a8 34 80 00       	push   $0x8034a8
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 04 35 80 00       	push   $0x803504
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 38 35 80 00       	push   $0x803538
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 80 35 80 00       	push   $0x803580
  8000f9:	e8 63 16 00 00       	call   801761 <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 5b 19 00 00       	call   801a64 <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 80 35 80 00       	push   $0x803580
  80011b:	e8 41 16 00 00       	call   801761 <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 84 35 80 00       	push   $0x803584
  800134:	6a 24                	push   $0x24
  800136:	68 5c 34 80 00       	push   $0x80345c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 1f 19 00 00       	call   801a64 <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 d8 35 80 00       	push   $0x8035d8
  800156:	6a 25                	push   $0x25
  800158:	68 5c 34 80 00       	push   $0x80345c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 34 36 80 00       	push   $0x803634
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 ed 18 00 00       	call   801a64 <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 8c 36 80 00       	push   $0x80368c
  80018e:	e8 ce 15 00 00       	call   801761 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 90 36 80 00       	push   $0x803690
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 5c 34 80 00       	push   $0x80345c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 ac 18 00 00       	call   801a64 <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 04 37 80 00       	push   $0x803704
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 5c 34 80 00       	push   $0x80345c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 78 37 80 00       	push   $0x803778
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 d3 1a 00 00       	call   801cbd <sys_getMaxShares>
  8001ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f4:	eb 45                	jmp    80023b <_main+0x203>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 ec             	pushl  -0x14(%ebp)
  800200:	e8 d3 0f 00 00       	call   8011d8 <ltostr>
  800205:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	6a 01                	push   $0x1
  80020d:	6a 01                	push   $0x1
  80020f:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  800212:	50                   	push   %eax
  800213:	e8 49 15 00 00       	call   801761 <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 ec 37 80 00       	push   $0x8037ec
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 5c 34 80 00       	push   $0x80345c
  800233:	e8 c4 01 00 00       	call   8003fc <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  800238:	ff 45 ec             	incl   -0x14(%ebp)
  80023b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800244:	39 c2                	cmp    %eax,%edx
  800246:	77 ae                	ja     8001f6 <_main+0x1be>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	6a 01                	push   $0x1
  80024d:	6a 01                	push   $0x1
  80024f:	68 1c 38 80 00       	push   $0x80381c
  800254:	e8 08 15 00 00       	call   801761 <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 59 1a 00 00       	call   801cbd <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 28 38 80 00       	push   $0x803828
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 5c 34 80 00       	push   $0x80345c
  800284:	e8 73 01 00 00       	call   8003fc <_panic>
		//else
		if ((maxShares_after == 2*maxShares) && (z == NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS, krealloc should be invoked to double the size of shares array!!");
  800289:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800291:	75 1a                	jne    8002ad <_main+0x275>
  800293:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800297:	75 14                	jne    8002ad <_main+0x275>
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 a4 38 80 00       	push   $0x8038a4
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 5c 34 80 00       	push   $0x80345c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 30 39 80 00       	push   $0x803930
  8002b5:	e8 f6 03 00 00       	call   8006b0 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp

	return;
  8002bd:	90                   	nop
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002c6:	e8 79 1a 00 00       	call   801d44 <sys_getenvindex>
  8002cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002d1:	89 d0                	mov    %edx,%eax
  8002d3:	c1 e0 03             	shl    $0x3,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	c1 e0 04             	shl    $0x4,%eax
  8002e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ed:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002fd:	84 c0                	test   %al,%al
  8002ff:	74 0f                	je     800310 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800301:	a1 20 50 80 00       	mov    0x805020,%eax
  800306:	05 5c 05 00 00       	add    $0x55c,%eax
  80030b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x60>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800331:	e8 1b 18 00 00       	call   801b51 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 a8 39 80 00       	push   $0x8039a8
  80033e:	e8 6d 03 00 00       	call   8006b0 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800346:	a1 20 50 80 00       	mov    0x805020,%eax
  80034b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800351:	a1 20 50 80 00       	mov    0x805020,%eax
  800356:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 d0 39 80 00       	push   $0x8039d0
  800366:	e8 45 03 00 00       	call   8006b0 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036e:	a1 20 50 80 00       	mov    0x805020,%eax
  800373:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800379:	a1 20 50 80 00       	mov    0x805020,%eax
  80037e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800384:	a1 20 50 80 00       	mov    0x805020,%eax
  800389:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80038f:	51                   	push   %ecx
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	68 f8 39 80 00       	push   $0x8039f8
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 50 3a 80 00       	push   $0x803a50
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 a8 39 80 00       	push   $0x8039a8
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 9b 17 00 00       	call   801b6b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003d0:	e8 19 00 00 00       	call   8003ee <exit>
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	6a 00                	push   $0x0
  8003e3:	e8 28 19 00 00       	call   801d10 <sys_destroy_env>
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <exit>:

void
exit(void)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f4:	e8 7d 19 00 00       	call   801d76 <sys_exit_env>
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800402:	8d 45 10             	lea    0x10(%ebp),%eax
  800405:	83 c0 04             	add    $0x4,%eax
  800408:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80040b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800410:	85 c0                	test   %eax,%eax
  800412:	74 16                	je     80042a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800414:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 64 3a 80 00       	push   $0x803a64
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 69 3a 80 00       	push   $0x803a69
  80043b:	e8 70 02 00 00       	call   8006b0 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 f4             	pushl  -0xc(%ebp)
  80044c:	50                   	push   %eax
  80044d:	e8 f3 01 00 00       	call   800645 <vcprintf>
  800452:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	6a 00                	push   $0x0
  80045a:	68 85 3a 80 00       	push   $0x803a85
  80045f:	e8 e1 01 00 00       	call   800645 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800467:	e8 82 ff ff ff       	call   8003ee <exit>

	// should not return here
	while (1) ;
  80046c:	eb fe                	jmp    80046c <_panic+0x70>

0080046e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800474:	a1 20 50 80 00       	mov    0x805020,%eax
  800479:	8b 50 74             	mov    0x74(%eax),%edx
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	39 c2                	cmp    %eax,%edx
  800481:	74 14                	je     800497 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	68 88 3a 80 00       	push   $0x803a88
  80048b:	6a 26                	push   $0x26
  80048d:	68 d4 3a 80 00       	push   $0x803ad4
  800492:	e8 65 ff ff ff       	call   8003fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a5:	e9 c2 00 00 00       	jmp    80056c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	75 08                	jne    8004c7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c2:	e9 a2 00 00 00       	jmp    800569 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d5:	eb 69                	jmp    800540 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004dc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	c1 e0 03             	shl    $0x3,%eax
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	8a 40 04             	mov    0x4(%eax),%al
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 46                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800502:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800505:	89 d0                	mov    %edx,%eax
  800507:	01 c0                	add    %eax,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	c1 e0 03             	shl    $0x3,%eax
  80050e:	01 c8                	add    %ecx,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800518:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800530:	39 c2                	cmp    %eax,%edx
  800532:	75 09                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800534:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053b:	eb 12                	jmp    80054f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053d:	ff 45 e8             	incl   -0x18(%ebp)
  800540:	a1 20 50 80 00       	mov    0x805020,%eax
  800545:	8b 50 74             	mov    0x74(%eax),%edx
  800548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	77 88                	ja     8004d7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800553:	75 14                	jne    800569 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 e0 3a 80 00       	push   $0x803ae0
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 d4 3a 80 00       	push   $0x803ad4
  800564:	e8 93 fe ff ff       	call   8003fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800569:	ff 45 f0             	incl   -0x10(%ebp)
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800572:	0f 8c 32 ff ff ff    	jl     8004aa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800578:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800586:	eb 26                	jmp    8005ae <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800588:	a1 20 50 80 00       	mov    0x805020,%eax
  80058d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 c8                	add    %ecx,%eax
  8005a1:	8a 40 04             	mov    0x4(%eax),%al
  8005a4:	3c 01                	cmp    $0x1,%al
  8005a6:	75 03                	jne    8005ab <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e0             	incl   -0x20(%ebp)
  8005ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b3:	8b 50 74             	mov    0x74(%eax),%edx
  8005b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	77 cb                	ja     800588 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c3:	74 14                	je     8005d9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 34 3b 80 00       	push   $0x803b34
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 d4 3a 80 00       	push   $0x803ad4
  8005d4:	e8 23 fe ff ff       	call   8003fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d9:	90                   	nop
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 0a                	mov    %ecx,(%edx)
  8005ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f2:	88 d1                	mov    %dl,%cl
  8005f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	3d ff 00 00 00       	cmp    $0xff,%eax
  800605:	75 2c                	jne    800633 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800607:	a0 24 50 80 00       	mov    0x805024,%al
  80060c:	0f b6 c0             	movzbl %al,%eax
  80060f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800612:	8b 12                	mov    (%edx),%edx
  800614:	89 d1                	mov    %edx,%ecx
  800616:	8b 55 0c             	mov    0xc(%ebp),%edx
  800619:	83 c2 08             	add    $0x8,%edx
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	e8 7c 13 00 00       	call   8019a3 <sys_cputs>
  800627:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 40 04             	mov    0x4(%eax),%eax
  800639:	8d 50 01             	lea    0x1(%eax),%edx
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800655:	00 00 00 
	b.cnt = 0;
  800658:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	68 dc 05 80 00       	push   $0x8005dc
  800674:	e8 11 02 00 00       	call   80088a <vprintfmt>
  800679:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067c:	a0 24 50 80 00       	mov    0x805024,%al
  800681:	0f b6 c0             	movzbl %al,%eax
  800684:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	50                   	push   %eax
  80068e:	52                   	push   %edx
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	83 c0 08             	add    $0x8,%eax
  800698:	50                   	push   %eax
  800699:	e8 05 13 00 00       	call   8019a3 <sys_cputs>
  80069e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a1:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8006a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b6:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8006bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	e8 73 ff ff ff       	call   800645 <vcprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e3:	e8 69 14 00 00       	call   801b51 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	e8 48 ff ff ff       	call   800645 <vcprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800703:	e8 63 14 00 00       	call   801b6b <sys_enable_interrupt>
	return cnt;
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	53                   	push   %ebx
  800711:	83 ec 14             	sub    $0x14,%esp
  800714:	8b 45 10             	mov    0x10(%ebp),%eax
  800717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800720:	8b 45 18             	mov    0x18(%ebp),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072b:	77 55                	ja     800782 <printnum+0x75>
  80072d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800730:	72 05                	jb     800737 <printnum+0x2a>
  800732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800735:	77 4b                	ja     800782 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800737:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073d:	8b 45 18             	mov    0x18(%ebp),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	ff 75 f4             	pushl  -0xc(%ebp)
  80074a:	ff 75 f0             	pushl  -0x10(%ebp)
  80074d:	e8 82 2a 00 00       	call   8031d4 <__udivdi3>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	ff 75 20             	pushl  0x20(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	ff 75 18             	pushl  0x18(%ebp)
  80075f:	52                   	push   %edx
  800760:	50                   	push   %eax
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 a1 ff ff ff       	call   80070d <printnum>
  80076c:	83 c4 20             	add    $0x20,%esp
  80076f:	eb 1a                	jmp    80078b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	ff 75 20             	pushl  0x20(%ebp)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800782:	ff 4d 1c             	decl   0x1c(%ebp)
  800785:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800789:	7f e6                	jg     800771 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	53                   	push   %ebx
  80079a:	51                   	push   %ecx
  80079b:	52                   	push   %edx
  80079c:	50                   	push   %eax
  80079d:	e8 42 2b 00 00       	call   8032e4 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 94 3d 80 00       	add    $0x803d94,%eax
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f be c0             	movsbl %al,%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	90                   	nop
  8007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cb:	7e 1c                	jle    8007e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 50 08             	lea    0x8(%eax),%edx
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 10                	mov    %edx,(%eax)
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	83 e8 08             	sub    $0x8,%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	eb 40                	jmp    800829 <getuint+0x65>
	else if (lflag)
  8007e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ed:	74 1e                	je     80080d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	89 10                	mov    %edx,(%eax)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	eb 1c                	jmp    800829 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 10                	mov    %edx,(%eax)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800832:	7e 1c                	jle    800850 <getint+0x25>
		return va_arg(*ap, long long);
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8d 50 08             	lea    0x8(%eax),%edx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 10                	mov    %edx,(%eax)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	83 e8 08             	sub    $0x8,%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	eb 38                	jmp    800888 <getint+0x5d>
	else if (lflag)
  800850:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800854:	74 1a                	je     800870 <getint+0x45>
		return va_arg(*ap, long);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	99                   	cltd   
  80086e:	eb 18                	jmp    800888 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 10                	mov    %edx,(%eax)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	99                   	cltd   
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
  80088f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800892:	eb 17                	jmp    8008ab <vprintfmt+0x21>
			if (ch == '\0')
  800894:	85 db                	test   %ebx,%ebx
  800896:	0f 84 af 03 00 00    	je     800c4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	83 fb 25             	cmp    $0x25,%ebx
  8008bc:	75 d6                	jne    800894 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	8d 50 01             	lea    0x1(%eax),%edx
  8008e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e7:	8a 00                	mov    (%eax),%al
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ef:	83 f8 55             	cmp    $0x55,%eax
  8008f2:	0f 87 2b 03 00 00    	ja     800c23 <vprintfmt+0x399>
  8008f8:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
  8008ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800901:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800905:	eb d7                	jmp    8008de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800907:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090b:	eb d1                	jmp    8008de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800917:	89 d0                	mov    %edx,%eax
  800919:	c1 e0 02             	shl    $0x2,%eax
  80091c:	01 d0                	add    %edx,%eax
  80091e:	01 c0                	add    %eax,%eax
  800920:	01 d8                	add    %ebx,%eax
  800922:	83 e8 30             	sub    $0x30,%eax
  800925:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800928:	8b 45 10             	mov    0x10(%ebp),%eax
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800930:	83 fb 2f             	cmp    $0x2f,%ebx
  800933:	7e 3e                	jle    800973 <vprintfmt+0xe9>
  800935:	83 fb 39             	cmp    $0x39,%ebx
  800938:	7f 39                	jg     800973 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093d:	eb d5                	jmp    800914 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800953:	eb 1f                	jmp    800974 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	79 83                	jns    8008de <vprintfmt+0x54>
				width = 0;
  80095b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800967:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096e:	e9 6b ff ff ff       	jmp    8008de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800973:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	0f 89 60 ff ff ff    	jns    8008de <vprintfmt+0x54>
				width = precision, precision = -1;
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800984:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098b:	e9 4e ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800990:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800993:	e9 46 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
			break;
  8009b8:	e9 89 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 c0 04             	add    $0x4,%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 e8 04             	sub    $0x4,%eax
  8009cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	79 02                	jns    8009d4 <vprintfmt+0x14a>
				err = -err;
  8009d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d4:	83 fb 64             	cmp    $0x64,%ebx
  8009d7:	7f 0b                	jg     8009e4 <vprintfmt+0x15a>
  8009d9:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 a5 3d 80 00       	push   $0x803da5
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 5e 02 00 00       	call   800c53 <printfmt>
  8009f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f8:	e9 49 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fd:	56                   	push   %esi
  8009fe:	68 ae 3d 80 00       	push   $0x803dae
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	ff 75 08             	pushl  0x8(%ebp)
  800a09:	e8 45 02 00 00       	call   800c53 <printfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
			break;
  800a11:	e9 30 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 30                	mov    (%eax),%esi
  800a27:	85 f6                	test   %esi,%esi
  800a29:	75 05                	jne    800a30 <vprintfmt+0x1a6>
				p = "(null)";
  800a2b:	be b1 3d 80 00       	mov    $0x803db1,%esi
			if (width > 0 && padc != '-')
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7e 6d                	jle    800aa3 <vprintfmt+0x219>
  800a36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3a:	74 67                	je     800aa3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	50                   	push   %eax
  800a43:	56                   	push   %esi
  800a44:	e8 0c 03 00 00       	call   800d55 <strnlen>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4f:	eb 16                	jmp    800a67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a64:	ff 4d e4             	decl   -0x1c(%ebp)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	7f e4                	jg     800a51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	eb 34                	jmp    800aa3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a73:	74 1c                	je     800a91 <vprintfmt+0x207>
  800a75:	83 fb 1f             	cmp    $0x1f,%ebx
  800a78:	7e 05                	jle    800a7f <vprintfmt+0x1f5>
  800a7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7d:	7e 12                	jle    800a91 <vprintfmt+0x207>
					putch('?', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 3f                	push   $0x3f
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	eb 0f                	jmp    800aa0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	8d 70 01             	lea    0x1(%eax),%esi
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	0f be d8             	movsbl %al,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	74 24                	je     800ad5 <vprintfmt+0x24b>
  800ab1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab5:	78 b8                	js     800a6f <vprintfmt+0x1e5>
  800ab7:	ff 4d e0             	decl   -0x20(%ebp)
  800aba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abe:	79 af                	jns    800a6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	eb 13                	jmp    800ad5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	6a 20                	push   $0x20
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad9:	7f e7                	jg     800ac2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adb:	e9 66 01 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 3c fd ff ff       	call   80082b <getint>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afe:	85 d2                	test   %edx,%edx
  800b00:	79 23                	jns    800b25 <vprintfmt+0x29b>
				putch('-', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 2d                	push   $0x2d
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	f7 d8                	neg    %eax
  800b1a:	83 d2 00             	adc    $0x0,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2c:	e9 bc 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 e8             	pushl  -0x18(%ebp)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 84 fc ff ff       	call   8007c4 <getuint>
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b50:	e9 98 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 58                	push   $0x58
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 58                	push   $0x58
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 58                	push   $0x58
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			break;
  800b85:	e9 bc 00 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 30                	push   $0x30
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 78                	push   $0x78
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	83 c0 04             	add    $0x4,%eax
  800bb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bcc:	eb 1f                	jmp    800bed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 e7 fb ff ff       	call   8007c4 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf4:	83 ec 04             	sub    $0x4,%esp
  800bf7:	52                   	push   %edx
  800bf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	ff 75 f0             	pushl  -0x10(%ebp)
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 00 fb ff ff       	call   80070d <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
			break;
  800c10:	eb 34                	jmp    800c46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			break;
  800c21:	eb 23                	jmp    800c46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 25                	push   $0x25
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c33:	ff 4d 10             	decl   0x10(%ebp)
  800c36:	eb 03                	jmp    800c3b <vprintfmt+0x3b1>
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	48                   	dec    %eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	3c 25                	cmp    $0x25,%al
  800c43:	75 f3                	jne    800c38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c45:	90                   	nop
		}
	}
  800c46:	e9 47 fc ff ff       	jmp    800892 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c59:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5c:	83 c0 04             	add    $0x4,%eax
  800c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 16 fc ff ff       	call   80088a <vprintfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c77:	90                   	nop
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 40 08             	mov    0x8(%eax),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8b 10                	mov    (%eax),%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 40 04             	mov    0x4(%eax),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	73 12                	jae    800cad <sprintputch+0x33>
		*b->buf++ = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 10                	mov    %dl,(%eax)
}
  800cad:	90                   	nop
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	01 d0                	add    %edx,%eax
  800cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd5:	74 06                	je     800cdd <vsnprintf+0x2d>
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	7f 07                	jg     800ce4 <vsnprintf+0x34>
		return -E_INVAL;
  800cdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce2:	eb 20                	jmp    800d04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	68 7a 0c 80 00       	push   $0x800c7a
  800cf3:	e8 92 fb ff ff       	call   80088a <vprintfmt>
  800cf8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 89 ff ff ff       	call   800cb0 <vsnprintf>
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 06                	jmp    800d47 <strlen+0x15>
		n++;
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	84 c0                	test   %al,%al
  800d4e:	75 f1                	jne    800d41 <strlen+0xf>
		n++;
	return n;
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d62:	eb 09                	jmp    800d6d <strnlen+0x18>
		n++;
  800d64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	ff 4d 0c             	decl   0xc(%ebp)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 09                	je     800d7c <strnlen+0x27>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e8                	jne    800d64 <strnlen+0xf>
		n++;
	return n;
  800d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8d:	90                   	nop
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 08             	mov    %edx,0x8(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	75 e4                	jne    800d8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc2:	eb 1f                	jmp    800de3 <strncpy+0x34>
		*dst++ = *src;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	74 03                	je     800de0 <strncpy+0x31>
			src++;
  800ddd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de9:	72 d9                	jb     800dc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 30                	je     800e32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e02:	eb 16                	jmp    800e1a <strlcpy+0x2a>
			*dst++ = *src++;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1a:	ff 4d 10             	decl   0x10(%ebp)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 09                	je     800e2c <strlcpy+0x3c>
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 d8                	jne    800e04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 d0                	mov    %edx,%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e41:	eb 06                	jmp    800e49 <strcmp+0xb>
		p++, q++;
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0e                	je     800e60 <strcmp+0x22>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 10                	mov    (%eax),%dl
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	38 c2                	cmp    %al,%dl
  800e5e:	74 e3                	je     800e43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 d0             	movzbl %al,%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 d0                	mov    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e79:	eb 09                	jmp    800e84 <strncmp+0xe>
		n--, p++, q++;
  800e7b:	ff 4d 10             	decl   0x10(%ebp)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 17                	je     800ea1 <strncmp+0x2b>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 0e                	je     800ea1 <strncmp+0x2b>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 da                	je     800e7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	75 07                	jne    800eae <strncmp+0x38>
		return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb 14                	jmp    800ec2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 c0             	movzbl %al,%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed0:	eb 12                	jmp    800ee4 <strchr+0x20>
		if (*s == c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eda:	75 05                	jne    800ee1 <strchr+0x1d>
			return (char *) s;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	eb 11                	jmp    800ef2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e5                	jne    800ed2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 04             	sub    $0x4,%esp
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f00:	eb 0d                	jmp    800f0f <strfind+0x1b>
		if (*s == c)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0a:	74 0e                	je     800f1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0c:	ff 45 08             	incl   0x8(%ebp)
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	75 ea                	jne    800f02 <strfind+0xe>
  800f18:	eb 01                	jmp    800f1b <strfind+0x27>
		if (*s == c)
			break;
  800f1a:	90                   	nop
	return (char *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f32:	eb 0e                	jmp    800f42 <memset+0x22>
		*p++ = c;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	8d 50 01             	lea    0x1(%eax),%edx
  800f3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f42:	ff 4d f8             	decl   -0x8(%ebp)
  800f45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f49:	79 e9                	jns    800f34 <memset+0x14>
		*p++ = c;

	return v;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f62:	eb 16                	jmp    800f7a <memcpy+0x2a>
		*d++ = *s++;
  800f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f76:	8a 12                	mov    (%edx),%dl
  800f78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 dd                	jne    800f64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa4:	73 50                	jae    800ff6 <memmove+0x6a>
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	76 43                	jbe    800ff6 <memmove+0x6a>
		s += n;
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 10                	jmp    800fd1 <memmove+0x45>
			*--d = *--s;
  800fc1:	ff 4d f8             	decl   -0x8(%ebp)
  800fc4:	ff 4d fc             	decl   -0x4(%ebp)
  800fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fca:	8a 10                	mov    (%eax),%dl
  800fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 e3                	jne    800fc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fde:	eb 23                	jmp    801003 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff2:	8a 12                	mov    (%edx),%dl
  800ff4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 dd                	jne    800fe0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101a:	eb 2a                	jmp    801046 <memcmp+0x3e>
		if (*s1 != *s2)
  80101c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101f:	8a 10                	mov    (%eax),%dl
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	38 c2                	cmp    %al,%dl
  801028:	74 16                	je     801040 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	eb 18                	jmp    801058 <memcmp+0x50>
		s1++, s2++;
  801040:	ff 45 fc             	incl   -0x4(%ebp)
  801043:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 c9                	jne    80101c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106b:	eb 15                	jmp    801082 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	39 c2                	cmp    %eax,%edx
  80107d:	74 0d                	je     80108c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801088:	72 e3                	jb     80106d <memfind+0x13>
  80108a:	eb 01                	jmp    80108d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108c:	90                   	nop
	return (void *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a6:	eb 03                	jmp    8010ab <strtol+0x19>
		s++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 20                	cmp    $0x20,%al
  8010b2:	74 f4                	je     8010a8 <strtol+0x16>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 09                	cmp    $0x9,%al
  8010bb:	74 eb                	je     8010a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 2b                	cmp    $0x2b,%al
  8010c4:	75 05                	jne    8010cb <strtol+0x39>
		s++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	eb 13                	jmp    8010de <strtol+0x4c>
	else if (*s == '-')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2d                	cmp    $0x2d,%al
  8010d2:	75 0a                	jne    8010de <strtol+0x4c>
		s++, neg = 1;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	74 06                	je     8010ea <strtol+0x58>
  8010e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e8:	75 20                	jne    80110a <strtol+0x78>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 30                	cmp    $0x30,%al
  8010f1:	75 17                	jne    80110a <strtol+0x78>
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	40                   	inc    %eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	3c 78                	cmp    $0x78,%al
  8010fb:	75 0d                	jne    80110a <strtol+0x78>
		s += 2, base = 16;
  8010fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801101:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801108:	eb 28                	jmp    801132 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	75 15                	jne    801125 <strtol+0x93>
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 30                	cmp    $0x30,%al
  801117:	75 0c                	jne    801125 <strtol+0x93>
		s++, base = 8;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801123:	eb 0d                	jmp    801132 <strtol+0xa0>
	else if (base == 0)
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	75 07                	jne    801132 <strtol+0xa0>
		base = 10;
  80112b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 2f                	cmp    $0x2f,%al
  801139:	7e 19                	jle    801154 <strtol+0xc2>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 39                	cmp    $0x39,%al
  801142:	7f 10                	jg     801154 <strtol+0xc2>
			dig = *s - '0';
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	83 e8 30             	sub    $0x30,%eax
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801152:	eb 42                	jmp    801196 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 60                	cmp    $0x60,%al
  80115b:	7e 19                	jle    801176 <strtol+0xe4>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 7a                	cmp    $0x7a,%al
  801164:	7f 10                	jg     801176 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	83 e8 57             	sub    $0x57,%eax
  801171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801174:	eb 20                	jmp    801196 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 40                	cmp    $0x40,%al
  80117d:	7e 39                	jle    8011b8 <strtol+0x126>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 5a                	cmp    $0x5a,%al
  801186:	7f 30                	jg     8011b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f be c0             	movsbl %al,%eax
  801190:	83 e8 37             	sub    $0x37,%eax
  801193:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801199:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119c:	7d 19                	jge    8011b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b2:	e9 7b ff ff ff       	jmp    801132 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bc:	74 08                	je     8011c6 <strtol+0x134>
		*endptr = (char *) s;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ca:	74 07                	je     8011d3 <strtol+0x141>
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	f7 d8                	neg    %eax
  8011d1:	eb 03                	jmp    8011d6 <strtol+0x144>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f0:	79 13                	jns    801205 <ltostr+0x2d>
	{
		neg = 1;
  8011f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801202:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120d:	99                   	cltd   
  80120e:	f7 f9                	idiv   %ecx
  801210:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801226:	83 c2 30             	add    $0x30,%edx
  801229:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801233:	f7 e9                	imul   %ecx
  801235:	c1 fa 02             	sar    $0x2,%edx
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	c1 f8 1f             	sar    $0x1f,%eax
  80123d:	29 c2                	sub    %eax,%edx
  80123f:	89 d0                	mov    %edx,%eax
  801241:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124c:	f7 e9                	imul   %ecx
  80124e:	c1 fa 02             	sar    $0x2,%edx
  801251:	89 c8                	mov    %ecx,%eax
  801253:	c1 f8 1f             	sar    $0x1f,%eax
  801256:	29 c2                	sub    %eax,%edx
  801258:	89 d0                	mov    %edx,%eax
  80125a:	c1 e0 02             	shl    $0x2,%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	01 c0                	add    %eax,%eax
  801261:	29 c1                	sub    %eax,%ecx
  801263:	89 ca                	mov    %ecx,%edx
  801265:	85 d2                	test   %edx,%edx
  801267:	75 9c                	jne    801205 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801273:	48                   	dec    %eax
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127b:	74 3d                	je     8012ba <ltostr+0xe2>
		start = 1 ;
  80127d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801284:	eb 34                	jmp    8012ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c0:	7c c4                	jl     801286 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 54 fa ff ff       	call   800d32 <strlen>
  8012de:	83 c4 04             	add    $0x4,%esp
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	e8 46 fa ff ff       	call   800d32 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801300:	eb 17                	jmp    801319 <strcconcat+0x49>
		final[s] = str1[s] ;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 c8                	add    %ecx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801316:	ff 45 fc             	incl   -0x4(%ebp)
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131f:	7c e1                	jl     801302 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132f:	eb 1f                	jmp    801350 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	01 c2                	add    %eax,%edx
  801341:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c8                	add    %ecx,%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134d:	ff 45 f8             	incl   -0x8(%ebp)
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c d9                	jl     801331 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801358:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135b:	8b 45 10             	mov    0x10(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801372:	8b 45 14             	mov    0x14(%ebp),%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801389:	eb 0c                	jmp    801397 <strsplit+0x31>
			*string++ = 0;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8d 50 01             	lea    0x1(%eax),%edx
  801391:	89 55 08             	mov    %edx,0x8(%ebp)
  801394:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	74 18                	je     8013b8 <strsplit+0x52>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	0f be c0             	movsbl %al,%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 13 fb ff ff       	call   800ec4 <strchr>
  8013b1:	83 c4 08             	add    $0x8,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 d3                	jne    80138b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 5a                	je     80141b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	83 f8 0f             	cmp    $0xf,%eax
  8013c9:	75 07                	jne    8013d2 <strsplit+0x6c>
		{
			return 0;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	eb 66                	jmp    801438 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013da:	8b 55 14             	mov    0x14(%ebp),%edx
  8013dd:	89 0a                	mov    %ecx,(%edx)
  8013df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	01 c2                	add    %eax,%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f0:	eb 03                	jmp    8013f5 <strsplit+0x8f>
			string++;
  8013f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 8b                	je     801389 <strsplit+0x23>
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	0f be c0             	movsbl %al,%eax
  801406:	50                   	push   %eax
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	e8 b5 fa ff ff       	call   800ec4 <strchr>
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	74 dc                	je     8013f2 <strsplit+0x8c>
			string++;
	}
  801416:	e9 6e ff ff ff       	jmp    801389 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801440:	a1 04 50 80 00       	mov    0x805004,%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 1f                	je     801468 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801449:	e8 1d 00 00 00       	call   80146b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	68 10 3f 80 00       	push   $0x803f10
  801456:	e8 55 f2 ff ff       	call   8006b0 <cprintf>
  80145b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80145e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801465:	00 00 00 
	}
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801471:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801478:	00 00 00 
  80147b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801482:	00 00 00 
  801485:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80148c:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80148f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801496:	00 00 00 
  801499:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8014a0:	00 00 00 
  8014a3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8014aa:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8014ad:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8014b4:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8014b7:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8014be:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8014c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014cd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014d2:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  8014d7:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  8014de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	6a 06                	push   $0x6
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	e8 ee 05 00 00       	call   801ae7 <sys_allocate_chunk>
  8014f9:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	50                   	push   %eax
  801505:	e8 63 0c 00 00       	call   80216d <initialize_MemBlocksList>
  80150a:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80150d:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801512:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801515:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801518:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80151f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801522:	8b 40 0c             	mov    0xc(%eax),%eax
  801525:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80152b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801530:	89 c2                	mov    %eax,%edx
  801532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801535:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80153b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801542:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80154c:	8b 50 08             	mov    0x8(%eax),%edx
  80154f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801552:	01 d0                	add    %edx,%eax
  801554:	48                   	dec    %eax
  801555:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801558:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80155b:	ba 00 00 00 00       	mov    $0x0,%edx
  801560:	f7 75 e0             	divl   -0x20(%ebp)
  801563:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801566:	29 d0                	sub    %edx,%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156d:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801570:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801574:	75 14                	jne    80158a <initialize_dyn_block_system+0x11f>
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 35 3f 80 00       	push   $0x803f35
  80157e:	6a 34                	push   $0x34
  801580:	68 53 3f 80 00       	push   $0x803f53
  801585:	e8 72 ee ff ff       	call   8003fc <_panic>
  80158a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158d:	8b 00                	mov    (%eax),%eax
  80158f:	85 c0                	test   %eax,%eax
  801591:	74 10                	je     8015a3 <initialize_dyn_block_system+0x138>
  801593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80159b:	8b 52 04             	mov    0x4(%edx),%edx
  80159e:	89 50 04             	mov    %edx,0x4(%eax)
  8015a1:	eb 0b                	jmp    8015ae <initialize_dyn_block_system+0x143>
  8015a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a6:	8b 40 04             	mov    0x4(%eax),%eax
  8015a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8015ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b1:	8b 40 04             	mov    0x4(%eax),%eax
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	74 0f                	je     8015c7 <initialize_dyn_block_system+0x15c>
  8015b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015bb:	8b 40 04             	mov    0x4(%eax),%eax
  8015be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015c1:	8b 12                	mov    (%edx),%edx
  8015c3:	89 10                	mov    %edx,(%eax)
  8015c5:	eb 0a                	jmp    8015d1 <initialize_dyn_block_system+0x166>
  8015c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	a3 48 51 80 00       	mov    %eax,0x805148
  8015d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e4:	a1 54 51 80 00       	mov    0x805154,%eax
  8015e9:	48                   	dec    %eax
  8015ea:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8015ef:	83 ec 0c             	sub    $0xc,%esp
  8015f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f5:	e8 c4 13 00 00       	call   8029be <insert_sorted_with_merge_freeList>
  8015fa:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015fd:	90                   	nop
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801606:	e8 2f fe ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  80160b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80160f:	75 07                	jne    801618 <malloc+0x18>
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
  801616:	eb 71                	jmp    801689 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801618:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80161f:	76 07                	jbe    801628 <malloc+0x28>
	return NULL;
  801621:	b8 00 00 00 00       	mov    $0x0,%eax
  801626:	eb 61                	jmp    801689 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801628:	e8 88 08 00 00       	call   801eb5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162d:	85 c0                	test   %eax,%eax
  80162f:	74 53                	je     801684 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801631:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801638:	8b 55 08             	mov    0x8(%ebp),%edx
  80163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163e:	01 d0                	add    %edx,%eax
  801640:	48                   	dec    %eax
  801641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	ba 00 00 00 00       	mov    $0x0,%edx
  80164c:	f7 75 f4             	divl   -0xc(%ebp)
  80164f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801652:	29 d0                	sub    %edx,%eax
  801654:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801657:	83 ec 0c             	sub    $0xc,%esp
  80165a:	ff 75 ec             	pushl  -0x14(%ebp)
  80165d:	e8 d2 0d 00 00       	call   802434 <alloc_block_FF>
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801668:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80166c:	74 16                	je     801684 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  80166e:	83 ec 0c             	sub    $0xc,%esp
  801671:	ff 75 e8             	pushl  -0x18(%ebp)
  801674:	e8 0c 0c 00 00       	call   802285 <insert_sorted_allocList>
  801679:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80167c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80167f:	8b 40 08             	mov    0x8(%eax),%eax
  801682:	eb 05                	jmp    801689 <malloc+0x89>
    }

			}


	return NULL;
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80169f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a8:	68 40 50 80 00       	push   $0x805040
  8016ad:	e8 a0 0b 00 00       	call   802252 <find_block>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8016b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	e8 e4 03 00 00       	call   801aaf <sys_free_user_mem>
  8016cb:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8016ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016d2:	75 17                	jne    8016eb <free+0x60>
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	68 35 3f 80 00       	push   $0x803f35
  8016dc:	68 84 00 00 00       	push   $0x84
  8016e1:	68 53 3f 80 00       	push   $0x803f53
  8016e6:	e8 11 ed ff ff       	call   8003fc <_panic>
  8016eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ee:	8b 00                	mov    (%eax),%eax
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	74 10                	je     801704 <free+0x79>
  8016f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016fc:	8b 52 04             	mov    0x4(%edx),%edx
  8016ff:	89 50 04             	mov    %edx,0x4(%eax)
  801702:	eb 0b                	jmp    80170f <free+0x84>
  801704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801707:	8b 40 04             	mov    0x4(%eax),%eax
  80170a:	a3 44 50 80 00       	mov    %eax,0x805044
  80170f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801712:	8b 40 04             	mov    0x4(%eax),%eax
  801715:	85 c0                	test   %eax,%eax
  801717:	74 0f                	je     801728 <free+0x9d>
  801719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171c:	8b 40 04             	mov    0x4(%eax),%eax
  80171f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801722:	8b 12                	mov    (%edx),%edx
  801724:	89 10                	mov    %edx,(%eax)
  801726:	eb 0a                	jmp    801732 <free+0xa7>
  801728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172b:	8b 00                	mov    (%eax),%eax
  80172d:	a3 40 50 80 00       	mov    %eax,0x805040
  801732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80173b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801745:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80174a:	48                   	dec    %eax
  80174b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801750:	83 ec 0c             	sub    $0xc,%esp
  801753:	ff 75 ec             	pushl  -0x14(%ebp)
  801756:	e8 63 12 00 00       	call   8029be <insert_sorted_with_merge_freeList>
  80175b:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80175e:	90                   	nop
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 38             	sub    $0x38,%esp
  801767:	8b 45 10             	mov    0x10(%ebp),%eax
  80176a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176d:	e8 c8 fc ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  801772:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801776:	75 0a                	jne    801782 <smalloc+0x21>
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
  80177d:	e9 a0 00 00 00       	jmp    801822 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801782:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801789:	76 0a                	jbe    801795 <smalloc+0x34>
		return NULL;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	e9 8d 00 00 00       	jmp    801822 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801795:	e8 1b 07 00 00       	call   801eb5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80179a:	85 c0                	test   %eax,%eax
  80179c:	74 7f                	je     80181d <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80179e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	48                   	dec    %eax
  8017ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b9:	f7 75 f4             	divl   -0xc(%ebp)
  8017bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bf:	29 d0                	sub    %edx,%eax
  8017c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	ff 75 ec             	pushl  -0x14(%ebp)
  8017ca:	e8 65 0c 00 00       	call   802434 <alloc_block_FF>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8017d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017d9:	74 42                	je     80181d <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8017db:	83 ec 0c             	sub    $0xc,%esp
  8017de:	ff 75 e8             	pushl  -0x18(%ebp)
  8017e1:	e8 9f 0a 00 00       	call   802285 <insert_sorted_allocList>
  8017e6:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8017e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	89 c2                	mov    %eax,%edx
  8017f1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017f5:	52                   	push   %edx
  8017f6:	50                   	push   %eax
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	ff 75 08             	pushl  0x8(%ebp)
  8017fd:	e8 38 04 00 00       	call   801c3a <sys_createSharedObject>
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80180c:	79 07                	jns    801815 <smalloc+0xb4>
	    		  return NULL;
  80180e:	b8 00 00 00 00       	mov    $0x0,%eax
  801813:	eb 0d                	jmp    801822 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801818:	8b 40 08             	mov    0x8(%eax),%eax
  80181b:	eb 05                	jmp    801822 <smalloc+0xc1>


				}


		return NULL;
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182a:	e8 0b fc ff ff       	call   80143a <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80182f:	e8 81 06 00 00       	call   801eb5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801834:	85 c0                	test   %eax,%eax
  801836:	0f 84 9f 00 00 00    	je     8018db <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80183c:	83 ec 08             	sub    $0x8,%esp
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	ff 75 08             	pushl  0x8(%ebp)
  801845:	e8 1a 04 00 00       	call   801c64 <sys_getSizeOfSharedObject>
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801854:	79 0a                	jns    801860 <sget+0x3c>
		return NULL;
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
  80185b:	e9 80 00 00 00       	jmp    8018e0 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801860:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186d:	01 d0                	add    %edx,%eax
  80186f:	48                   	dec    %eax
  801870:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801876:	ba 00 00 00 00       	mov    $0x0,%edx
  80187b:	f7 75 f0             	divl   -0x10(%ebp)
  80187e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801881:	29 d0                	sub    %edx,%eax
  801883:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	ff 75 e8             	pushl  -0x18(%ebp)
  80188c:	e8 a3 0b 00 00       	call   802434 <alloc_block_FF>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801897:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80189b:	74 3e                	je     8018db <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80189d:	83 ec 0c             	sub    $0xc,%esp
  8018a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018a3:	e8 dd 09 00 00       	call   802285 <insert_sorted_allocList>
  8018a8:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8018ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ae:	8b 40 08             	mov    0x8(%eax),%eax
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	50                   	push   %eax
  8018b5:	ff 75 0c             	pushl  0xc(%ebp)
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	e8 c1 03 00 00       	call   801c81 <sys_getSharedObject>
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8018c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018ca:	79 07                	jns    8018d3 <sget+0xaf>
	    		  return NULL;
  8018cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d1:	eb 0d                	jmp    8018e0 <sget+0xbc>
	  	return(void*) returned_block->sva;
  8018d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d6:	8b 40 08             	mov    0x8(%eax),%eax
  8018d9:	eb 05                	jmp    8018e0 <sget+0xbc>
	      }
	}
	   return NULL;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e8:	e8 4d fb ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018ed:	83 ec 04             	sub    $0x4,%esp
  8018f0:	68 60 3f 80 00       	push   $0x803f60
  8018f5:	68 12 01 00 00       	push   $0x112
  8018fa:	68 53 3f 80 00       	push   $0x803f53
  8018ff:	e8 f8 ea ff ff       	call   8003fc <_panic>

00801904 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	68 88 3f 80 00       	push   $0x803f88
  801912:	68 26 01 00 00       	push   $0x126
  801917:	68 53 3f 80 00       	push   $0x803f53
  80191c:	e8 db ea ff ff       	call   8003fc <_panic>

00801921 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	68 ac 3f 80 00       	push   $0x803fac
  80192f:	68 31 01 00 00       	push   $0x131
  801934:	68 53 3f 80 00       	push   $0x803f53
  801939:	e8 be ea ff ff       	call   8003fc <_panic>

0080193e <shrink>:

}
void shrink(uint32 newSize)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	68 ac 3f 80 00       	push   $0x803fac
  80194c:	68 36 01 00 00       	push   $0x136
  801951:	68 53 3f 80 00       	push   $0x803f53
  801956:	e8 a1 ea ff ff       	call   8003fc <_panic>

0080195b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	68 ac 3f 80 00       	push   $0x803fac
  801969:	68 3b 01 00 00       	push   $0x13b
  80196e:	68 53 3f 80 00       	push   $0x803f53
  801973:	e8 84 ea ff ff       	call   8003fc <_panic>

00801978 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	57                   	push   %edi
  80197c:	56                   	push   %esi
  80197d:	53                   	push   %ebx
  80197e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	8b 55 0c             	mov    0xc(%ebp),%edx
  801987:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801990:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801993:	cd 30                	int    $0x30
  801995:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801998:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5f                   	pop    %edi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019af:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	52                   	push   %edx
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	50                   	push   %eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	e8 b2 ff ff ff       	call   801978 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 01                	push   $0x1
  8019db:	e8 98 ff ff ff       	call   801978 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 05                	push   $0x5
  8019f8:	e8 7b ff ff ff       	call   801978 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	56                   	push   %esi
  801a06:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a07:	8b 75 18             	mov    0x18(%ebp),%esi
  801a0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	51                   	push   %ecx
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 06                	push   $0x6
  801a1d:	e8 56 ff ff ff       	call   801978 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	52                   	push   %edx
  801a3c:	50                   	push   %eax
  801a3d:	6a 07                	push   $0x7
  801a3f:	e8 34 ff ff ff       	call   801978 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	ff 75 08             	pushl  0x8(%ebp)
  801a58:	6a 08                	push   $0x8
  801a5a:	e8 19 ff ff ff       	call   801978 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 09                	push   $0x9
  801a73:	e8 00 ff ff ff       	call   801978 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 0a                	push   $0xa
  801a8c:	e8 e7 fe ff ff       	call   801978 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 0b                	push   $0xb
  801aa5:	e8 ce fe ff ff       	call   801978 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 0f                	push   $0xf
  801ac0:	e8 b3 fe ff ff       	call   801978 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	6a 10                	push   $0x10
  801adc:	e8 97 fe ff ff       	call   801978 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae4:	90                   	nop
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 10             	pushl  0x10(%ebp)
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	ff 75 08             	pushl  0x8(%ebp)
  801af7:	6a 11                	push   $0x11
  801af9:	e8 7a fe ff ff       	call   801978 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 0c                	push   $0xc
  801b13:	e8 60 fe ff ff       	call   801978 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	6a 0d                	push   $0xd
  801b2d:	e8 46 fe ff ff       	call   801978 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 0e                	push   $0xe
  801b46:	e8 2d fe ff ff       	call   801978 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	90                   	nop
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 13                	push   $0x13
  801b60:	e8 13 fe ff ff       	call   801978 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	90                   	nop
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 14                	push   $0x14
  801b7a:	e8 f9 fd ff ff       	call   801978 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b91:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	50                   	push   %eax
  801b9e:	6a 15                	push   $0x15
  801ba0:	e8 d3 fd ff ff       	call   801978 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	90                   	nop
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 16                	push   $0x16
  801bba:	e8 b9 fd ff ff       	call   801978 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	90                   	nop
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	ff 75 0c             	pushl  0xc(%ebp)
  801bd4:	50                   	push   %eax
  801bd5:	6a 17                	push   $0x17
  801bd7:	e8 9c fd ff ff       	call   801978 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	52                   	push   %edx
  801bf1:	50                   	push   %eax
  801bf2:	6a 1a                	push   $0x1a
  801bf4:	e8 7f fd ff ff       	call   801978 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	52                   	push   %edx
  801c0e:	50                   	push   %eax
  801c0f:	6a 18                	push   $0x18
  801c11:	e8 62 fd ff ff       	call   801978 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	90                   	nop
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	52                   	push   %edx
  801c2c:	50                   	push   %eax
  801c2d:	6a 19                	push   $0x19
  801c2f:	e8 44 fd ff ff       	call   801978 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	90                   	nop
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 04             	sub    $0x4,%esp
  801c40:	8b 45 10             	mov    0x10(%ebp),%eax
  801c43:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c46:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c49:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	51                   	push   %ecx
  801c53:	52                   	push   %edx
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	50                   	push   %eax
  801c58:	6a 1b                	push   $0x1b
  801c5a:	e8 19 fd ff ff       	call   801978 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	6a 1c                	push   $0x1c
  801c77:	e8 fc fc ff ff       	call   801978 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	51                   	push   %ecx
  801c92:	52                   	push   %edx
  801c93:	50                   	push   %eax
  801c94:	6a 1d                	push   $0x1d
  801c96:	e8 dd fc ff ff       	call   801978 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	6a 1e                	push   $0x1e
  801cb3:	e8 c0 fc ff ff       	call   801978 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 1f                	push   $0x1f
  801ccc:	e8 a7 fc ff ff       	call   801978 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	6a 00                	push   $0x0
  801cde:	ff 75 14             	pushl  0x14(%ebp)
  801ce1:	ff 75 10             	pushl  0x10(%ebp)
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	50                   	push   %eax
  801ce8:	6a 20                	push   $0x20
  801cea:	e8 89 fc ff ff       	call   801978 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	50                   	push   %eax
  801d03:	6a 21                	push   $0x21
  801d05:	e8 6e fc ff ff       	call   801978 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	50                   	push   %eax
  801d1f:	6a 22                	push   $0x22
  801d21:	e8 52 fc ff ff       	call   801978 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 02                	push   $0x2
  801d3a:	e8 39 fc ff ff       	call   801978 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 03                	push   $0x3
  801d53:	e8 20 fc ff ff       	call   801978 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 04                	push   $0x4
  801d6c:	e8 07 fc ff ff       	call   801978 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_exit_env>:


void sys_exit_env(void)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 23                	push   $0x23
  801d85:	e8 ee fb ff ff       	call   801978 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	90                   	nop
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d96:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d99:	8d 50 04             	lea    0x4(%eax),%edx
  801d9c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	52                   	push   %edx
  801da6:	50                   	push   %eax
  801da7:	6a 24                	push   $0x24
  801da9:	e8 ca fb ff ff       	call   801978 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return result;
  801db1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dba:	89 01                	mov    %eax,(%ecx)
  801dbc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	c9                   	leave  
  801dc3:	c2 04 00             	ret    $0x4

00801dc6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	ff 75 10             	pushl  0x10(%ebp)
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	6a 12                	push   $0x12
  801dd8:	e8 9b fb ff ff       	call   801978 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  801de0:	90                   	nop
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 25                	push   $0x25
  801df2:	e8 81 fb ff ff       	call   801978 <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 04             	sub    $0x4,%esp
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e08:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	50                   	push   %eax
  801e15:	6a 26                	push   $0x26
  801e17:	e8 5c fb ff ff       	call   801978 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1f:	90                   	nop
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <rsttst>:
void rsttst()
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 28                	push   $0x28
  801e31:	e8 42 fb ff ff       	call   801978 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
	return ;
  801e39:	90                   	nop
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	8b 45 14             	mov    0x14(%ebp),%eax
  801e45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e48:	8b 55 18             	mov    0x18(%ebp),%edx
  801e4b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	ff 75 10             	pushl  0x10(%ebp)
  801e54:	ff 75 0c             	pushl  0xc(%ebp)
  801e57:	ff 75 08             	pushl  0x8(%ebp)
  801e5a:	6a 27                	push   $0x27
  801e5c:	e8 17 fb ff ff       	call   801978 <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
	return ;
  801e64:	90                   	nop
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <chktst>:
void chktst(uint32 n)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	ff 75 08             	pushl  0x8(%ebp)
  801e75:	6a 29                	push   $0x29
  801e77:	e8 fc fa ff ff       	call   801978 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7f:	90                   	nop
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <inctst>:

void inctst()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 2a                	push   $0x2a
  801e91:	e8 e2 fa ff ff       	call   801978 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
	return ;
  801e99:	90                   	nop
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <gettst>:
uint32 gettst()
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 2b                	push   $0x2b
  801eab:	e8 c8 fa ff ff       	call   801978 <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 2c                	push   $0x2c
  801ec7:	e8 ac fa ff ff       	call   801978 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
  801ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ed2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ed6:	75 07                	jne    801edf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ed8:	b8 01 00 00 00       	mov    $0x1,%eax
  801edd:	eb 05                	jmp    801ee4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 2c                	push   $0x2c
  801ef8:	e8 7b fa ff ff       	call   801978 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
  801f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f03:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f07:	75 07                	jne    801f10 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f09:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0e:	eb 05                	jmp    801f15 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 2c                	push   $0x2c
  801f29:	e8 4a fa ff ff       	call   801978 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
  801f31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f34:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f38:	75 07                	jne    801f41 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3f:	eb 05                	jmp    801f46 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 2c                	push   $0x2c
  801f5a:	e8 19 fa ff ff       	call   801978 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
  801f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f65:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f69:	75 07                	jne    801f72 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f70:	eb 05                	jmp    801f77 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	ff 75 08             	pushl  0x8(%ebp)
  801f87:	6a 2d                	push   $0x2d
  801f89:	e8 ea f9 ff ff       	call   801978 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f91:	90                   	nop
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	6a 00                	push   $0x0
  801fa6:	53                   	push   %ebx
  801fa7:	51                   	push   %ecx
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	6a 2e                	push   $0x2e
  801fac:	e8 c7 f9 ff ff       	call   801978 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	52                   	push   %edx
  801fc9:	50                   	push   %eax
  801fca:	6a 2f                	push   $0x2f
  801fcc:	e8 a7 f9 ff ff       	call   801978 <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fdc:	83 ec 0c             	sub    $0xc,%esp
  801fdf:	68 bc 3f 80 00       	push   $0x803fbc
  801fe4:	e8 c7 e6 ff ff       	call   8006b0 <cprintf>
  801fe9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	68 e8 3f 80 00       	push   $0x803fe8
  801ffb:	e8 b0 e6 ff ff       	call   8006b0 <cprintf>
  802000:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802003:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802007:	a1 38 51 80 00       	mov    0x805138,%eax
  80200c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200f:	eb 56                	jmp    802067 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802011:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802015:	74 1c                	je     802033 <print_mem_block_lists+0x5d>
  802017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201a:	8b 50 08             	mov    0x8(%eax),%edx
  80201d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802020:	8b 48 08             	mov    0x8(%eax),%ecx
  802023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802026:	8b 40 0c             	mov    0xc(%eax),%eax
  802029:	01 c8                	add    %ecx,%eax
  80202b:	39 c2                	cmp    %eax,%edx
  80202d:	73 04                	jae    802033 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80202f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	8b 50 08             	mov    0x8(%eax),%edx
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	8b 40 0c             	mov    0xc(%eax),%eax
  80203f:	01 c2                	add    %eax,%edx
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	8b 40 08             	mov    0x8(%eax),%eax
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	52                   	push   %edx
  80204b:	50                   	push   %eax
  80204c:	68 fd 3f 80 00       	push   $0x803ffd
  802051:	e8 5a e6 ff ff       	call   8006b0 <cprintf>
  802056:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80205f:	a1 40 51 80 00       	mov    0x805140,%eax
  802064:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206b:	74 07                	je     802074 <print_mem_block_lists+0x9e>
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	8b 00                	mov    (%eax),%eax
  802072:	eb 05                	jmp    802079 <print_mem_block_lists+0xa3>
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
  802079:	a3 40 51 80 00       	mov    %eax,0x805140
  80207e:	a1 40 51 80 00       	mov    0x805140,%eax
  802083:	85 c0                	test   %eax,%eax
  802085:	75 8a                	jne    802011 <print_mem_block_lists+0x3b>
  802087:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208b:	75 84                	jne    802011 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80208d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802091:	75 10                	jne    8020a3 <print_mem_block_lists+0xcd>
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	68 0c 40 80 00       	push   $0x80400c
  80209b:	e8 10 e6 ff ff       	call   8006b0 <cprintf>
  8020a0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	68 30 40 80 00       	push   $0x804030
  8020b2:	e8 f9 e5 ff ff       	call   8006b0 <cprintf>
  8020b7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020ba:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020be:	a1 40 50 80 00       	mov    0x805040,%eax
  8020c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c6:	eb 56                	jmp    80211e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020cc:	74 1c                	je     8020ea <print_mem_block_lists+0x114>
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	8b 50 08             	mov    0x8(%eax),%edx
  8020d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d7:	8b 48 08             	mov    0x8(%eax),%ecx
  8020da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e0:	01 c8                	add    %ecx,%eax
  8020e2:	39 c2                	cmp    %eax,%edx
  8020e4:	73 04                	jae    8020ea <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020e6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	8b 50 08             	mov    0x8(%eax),%edx
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f6:	01 c2                	add    %eax,%edx
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 40 08             	mov    0x8(%eax),%eax
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	52                   	push   %edx
  802102:	50                   	push   %eax
  802103:	68 fd 3f 80 00       	push   $0x803ffd
  802108:	e8 a3 e5 ff ff       	call   8006b0 <cprintf>
  80210d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802116:	a1 48 50 80 00       	mov    0x805048,%eax
  80211b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802122:	74 07                	je     80212b <print_mem_block_lists+0x155>
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 00                	mov    (%eax),%eax
  802129:	eb 05                	jmp    802130 <print_mem_block_lists+0x15a>
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
  802130:	a3 48 50 80 00       	mov    %eax,0x805048
  802135:	a1 48 50 80 00       	mov    0x805048,%eax
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 8a                	jne    8020c8 <print_mem_block_lists+0xf2>
  80213e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802142:	75 84                	jne    8020c8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802144:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802148:	75 10                	jne    80215a <print_mem_block_lists+0x184>
  80214a:	83 ec 0c             	sub    $0xc,%esp
  80214d:	68 48 40 80 00       	push   $0x804048
  802152:	e8 59 e5 ff ff       	call   8006b0 <cprintf>
  802157:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	68 bc 3f 80 00       	push   $0x803fbc
  802162:	e8 49 e5 ff ff       	call   8006b0 <cprintf>
  802167:	83 c4 10             	add    $0x10,%esp

}
  80216a:	90                   	nop
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802173:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80217a:	00 00 00 
  80217d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802184:	00 00 00 
  802187:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80218e:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802191:	a1 50 50 80 00       	mov    0x805050,%eax
  802196:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802199:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021a0:	e9 9e 00 00 00       	jmp    802243 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8021a5:	a1 50 50 80 00       	mov    0x805050,%eax
  8021aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ad:	c1 e2 04             	shl    $0x4,%edx
  8021b0:	01 d0                	add    %edx,%eax
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	75 14                	jne    8021ca <initialize_MemBlocksList+0x5d>
  8021b6:	83 ec 04             	sub    $0x4,%esp
  8021b9:	68 70 40 80 00       	push   $0x804070
  8021be:	6a 48                	push   $0x48
  8021c0:	68 93 40 80 00       	push   $0x804093
  8021c5:	e8 32 e2 ff ff       	call   8003fc <_panic>
  8021ca:	a1 50 50 80 00       	mov    0x805050,%eax
  8021cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d2:	c1 e2 04             	shl    $0x4,%edx
  8021d5:	01 d0                	add    %edx,%eax
  8021d7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021dd:	89 10                	mov    %edx,(%eax)
  8021df:	8b 00                	mov    (%eax),%eax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	74 18                	je     8021fd <initialize_MemBlocksList+0x90>
  8021e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8021ea:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021f0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021f3:	c1 e1 04             	shl    $0x4,%ecx
  8021f6:	01 ca                	add    %ecx,%edx
  8021f8:	89 50 04             	mov    %edx,0x4(%eax)
  8021fb:	eb 12                	jmp    80220f <initialize_MemBlocksList+0xa2>
  8021fd:	a1 50 50 80 00       	mov    0x805050,%eax
  802202:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802205:	c1 e2 04             	shl    $0x4,%edx
  802208:	01 d0                	add    %edx,%eax
  80220a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80220f:	a1 50 50 80 00       	mov    0x805050,%eax
  802214:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802217:	c1 e2 04             	shl    $0x4,%edx
  80221a:	01 d0                	add    %edx,%eax
  80221c:	a3 48 51 80 00       	mov    %eax,0x805148
  802221:	a1 50 50 80 00       	mov    0x805050,%eax
  802226:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802229:	c1 e2 04             	shl    $0x4,%edx
  80222c:	01 d0                	add    %edx,%eax
  80222e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802235:	a1 54 51 80 00       	mov    0x805154,%eax
  80223a:	40                   	inc    %eax
  80223b:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802240:	ff 45 f4             	incl   -0xc(%ebp)
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	3b 45 08             	cmp    0x8(%ebp),%eax
  802249:	0f 82 56 ff ff ff    	jb     8021a5 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80224f:	90                   	nop
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	8b 00                	mov    (%eax),%eax
  80225d:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802260:	eb 18                	jmp    80227a <find_block+0x28>
		{
			if(tmp->sva==va)
  802262:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802265:	8b 40 08             	mov    0x8(%eax),%eax
  802268:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80226b:	75 05                	jne    802272 <find_block+0x20>
			{
				return tmp;
  80226d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802270:	eb 11                	jmp    802283 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802272:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80227a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80227e:	75 e2                	jne    802262 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802280:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80228b:	a1 40 50 80 00       	mov    0x805040,%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	0f 85 83 00 00 00    	jne    80231b <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802298:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80229f:	00 00 00 
  8022a2:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8022a9:	00 00 00 
  8022ac:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8022b3:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8022b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ba:	75 14                	jne    8022d0 <insert_sorted_allocList+0x4b>
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 70 40 80 00       	push   $0x804070
  8022c4:	6a 7f                	push   $0x7f
  8022c6:	68 93 40 80 00       	push   $0x804093
  8022cb:	e8 2c e1 ff ff       	call   8003fc <_panic>
  8022d0:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	89 10                	mov    %edx,(%eax)
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 0d                	je     8022f1 <insert_sorted_allocList+0x6c>
  8022e4:	a1 40 50 80 00       	mov    0x805040,%eax
  8022e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ec:	89 50 04             	mov    %edx,0x4(%eax)
  8022ef:	eb 08                	jmp    8022f9 <insert_sorted_allocList+0x74>
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	a3 44 50 80 00       	mov    %eax,0x805044
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	a3 40 50 80 00       	mov    %eax,0x805040
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802310:	40                   	inc    %eax
  802311:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802316:	e9 16 01 00 00       	jmp    802431 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8b 50 08             	mov    0x8(%eax),%edx
  802321:	a1 44 50 80 00       	mov    0x805044,%eax
  802326:	8b 40 08             	mov    0x8(%eax),%eax
  802329:	39 c2                	cmp    %eax,%edx
  80232b:	76 68                	jbe    802395 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80232d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802331:	75 17                	jne    80234a <insert_sorted_allocList+0xc5>
  802333:	83 ec 04             	sub    $0x4,%esp
  802336:	68 ac 40 80 00       	push   $0x8040ac
  80233b:	68 85 00 00 00       	push   $0x85
  802340:	68 93 40 80 00       	push   $0x804093
  802345:	e8 b2 e0 ff ff       	call   8003fc <_panic>
  80234a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	89 50 04             	mov    %edx,0x4(%eax)
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	8b 40 04             	mov    0x4(%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 0c                	je     80236c <insert_sorted_allocList+0xe7>
  802360:	a1 44 50 80 00       	mov    0x805044,%eax
  802365:	8b 55 08             	mov    0x8(%ebp),%edx
  802368:	89 10                	mov    %edx,(%eax)
  80236a:	eb 08                	jmp    802374 <insert_sorted_allocList+0xef>
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	a3 40 50 80 00       	mov    %eax,0x805040
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 44 50 80 00       	mov    %eax,0x805044
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802385:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80238a:	40                   	inc    %eax
  80238b:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802390:	e9 9c 00 00 00       	jmp    802431 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802395:	a1 40 50 80 00       	mov    0x805040,%eax
  80239a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80239d:	e9 85 00 00 00       	jmp    802427 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	8b 50 08             	mov    0x8(%eax),%edx
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 40 08             	mov    0x8(%eax),%eax
  8023ae:	39 c2                	cmp    %eax,%edx
  8023b0:	73 6d                	jae    80241f <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8023b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b6:	74 06                	je     8023be <insert_sorted_allocList+0x139>
  8023b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023bc:	75 17                	jne    8023d5 <insert_sorted_allocList+0x150>
  8023be:	83 ec 04             	sub    $0x4,%esp
  8023c1:	68 d0 40 80 00       	push   $0x8040d0
  8023c6:	68 90 00 00 00       	push   $0x90
  8023cb:	68 93 40 80 00       	push   $0x804093
  8023d0:	e8 27 e0 ff ff       	call   8003fc <_panic>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 50 04             	mov    0x4(%eax),%edx
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	89 50 04             	mov    %edx,0x4(%eax)
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e7:	89 10                	mov    %edx,(%eax)
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 40 04             	mov    0x4(%eax),%eax
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	74 0d                	je     802400 <insert_sorted_allocList+0x17b>
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 40 04             	mov    0x4(%eax),%eax
  8023f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fc:	89 10                	mov    %edx,(%eax)
  8023fe:	eb 08                	jmp    802408 <insert_sorted_allocList+0x183>
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	a3 40 50 80 00       	mov    %eax,0x805040
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 55 08             	mov    0x8(%ebp),%edx
  80240e:	89 50 04             	mov    %edx,0x4(%eax)
  802411:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802416:	40                   	inc    %eax
  802417:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80241c:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80241d:	eb 12                	jmp    802431 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242b:	0f 85 71 ff ff ff    	jne    8023a2 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802431:	90                   	nop
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80243a:	a1 38 51 80 00       	mov    0x805138,%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802442:	e9 76 01 00 00       	jmp    8025bd <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 40 0c             	mov    0xc(%eax),%eax
  80244d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802450:	0f 85 8a 00 00 00    	jne    8024e0 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245a:	75 17                	jne    802473 <alloc_block_FF+0x3f>
  80245c:	83 ec 04             	sub    $0x4,%esp
  80245f:	68 05 41 80 00       	push   $0x804105
  802464:	68 a8 00 00 00       	push   $0xa8
  802469:	68 93 40 80 00       	push   $0x804093
  80246e:	e8 89 df ff ff       	call   8003fc <_panic>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	85 c0                	test   %eax,%eax
  80247a:	74 10                	je     80248c <alloc_block_FF+0x58>
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802484:	8b 52 04             	mov    0x4(%edx),%edx
  802487:	89 50 04             	mov    %edx,0x4(%eax)
  80248a:	eb 0b                	jmp    802497 <alloc_block_FF+0x63>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 40 04             	mov    0x4(%eax),%eax
  802492:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 40 04             	mov    0x4(%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 0f                	je     8024b0 <alloc_block_FF+0x7c>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024aa:	8b 12                	mov    (%edx),%edx
  8024ac:	89 10                	mov    %edx,(%eax)
  8024ae:	eb 0a                	jmp    8024ba <alloc_block_FF+0x86>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8024d2:	48                   	dec    %eax
  8024d3:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	e9 ea 00 00 00       	jmp    8025ca <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e9:	0f 86 c6 00 00 00    	jbe    8025b5 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8024ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8024f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fd:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 50 08             	mov    0x8(%eax),%edx
  802506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802509:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 40 0c             	mov    0xc(%eax),%eax
  802512:	2b 45 08             	sub    0x8(%ebp),%eax
  802515:	89 c2                	mov    %eax,%edx
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 50 08             	mov    0x8(%eax),%edx
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	01 c2                	add    %eax,%edx
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80252e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802532:	75 17                	jne    80254b <alloc_block_FF+0x117>
  802534:	83 ec 04             	sub    $0x4,%esp
  802537:	68 05 41 80 00       	push   $0x804105
  80253c:	68 b6 00 00 00       	push   $0xb6
  802541:	68 93 40 80 00       	push   $0x804093
  802546:	e8 b1 de ff ff       	call   8003fc <_panic>
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	85 c0                	test   %eax,%eax
  802552:	74 10                	je     802564 <alloc_block_FF+0x130>
  802554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255c:	8b 52 04             	mov    0x4(%edx),%edx
  80255f:	89 50 04             	mov    %edx,0x4(%eax)
  802562:	eb 0b                	jmp    80256f <alloc_block_FF+0x13b>
  802564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802567:	8b 40 04             	mov    0x4(%eax),%eax
  80256a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80256f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	74 0f                	je     802588 <alloc_block_FF+0x154>
  802579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257c:	8b 40 04             	mov    0x4(%eax),%eax
  80257f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802582:	8b 12                	mov    (%edx),%edx
  802584:	89 10                	mov    %edx,(%eax)
  802586:	eb 0a                	jmp    802592 <alloc_block_FF+0x15e>
  802588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258b:	8b 00                	mov    (%eax),%eax
  80258d:	a3 48 51 80 00       	mov    %eax,0x805148
  802592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802595:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8025aa:	48                   	dec    %eax
  8025ab:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	eb 15                	jmp    8025ca <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 00                	mov    (%eax),%eax
  8025ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8025bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c1:	0f 85 80 fe ff ff    	jne    802447 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8025d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8025d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  8025da:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8025e1:	e9 c0 00 00 00       	jmp    8026a6 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ef:	0f 85 8a 00 00 00    	jne    80267f <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8025f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f9:	75 17                	jne    802612 <alloc_block_BF+0x46>
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	68 05 41 80 00       	push   $0x804105
  802603:	68 cf 00 00 00       	push   $0xcf
  802608:	68 93 40 80 00       	push   $0x804093
  80260d:	e8 ea dd ff ff       	call   8003fc <_panic>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	74 10                	je     80262b <alloc_block_BF+0x5f>
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802623:	8b 52 04             	mov    0x4(%edx),%edx
  802626:	89 50 04             	mov    %edx,0x4(%eax)
  802629:	eb 0b                	jmp    802636 <alloc_block_BF+0x6a>
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 40 04             	mov    0x4(%eax),%eax
  802631:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 40 04             	mov    0x4(%eax),%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	74 0f                	je     80264f <alloc_block_BF+0x83>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802649:	8b 12                	mov    (%edx),%edx
  80264b:	89 10                	mov    %edx,(%eax)
  80264d:	eb 0a                	jmp    802659 <alloc_block_BF+0x8d>
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	a3 38 51 80 00       	mov    %eax,0x805138
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266c:	a1 44 51 80 00       	mov    0x805144,%eax
  802671:	48                   	dec    %eax
  802672:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	e9 2a 01 00 00       	jmp    8027a9 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 40 0c             	mov    0xc(%eax),%eax
  802685:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802688:	73 14                	jae    80269e <alloc_block_BF+0xd2>
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 40 0c             	mov    0xc(%eax),%eax
  802690:	3b 45 08             	cmp    0x8(%ebp),%eax
  802693:	76 09                	jbe    80269e <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 40 0c             	mov    0xc(%eax),%eax
  80269b:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  8026a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026aa:	0f 85 36 ff ff ff    	jne    8025e6 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8026b0:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8026b8:	e9 dd 00 00 00       	jmp    80279a <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026c6:	0f 85 c6 00 00 00    	jne    802792 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8026cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8026d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 50 08             	mov    0x8(%eax),%edx
  8026da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026dd:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8026e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e6:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 50 08             	mov    0x8(%eax),%edx
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	01 c2                	add    %eax,%edx
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802700:	2b 45 08             	sub    0x8(%ebp),%eax
  802703:	89 c2                	mov    %eax,%edx
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80270b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80270f:	75 17                	jne    802728 <alloc_block_BF+0x15c>
  802711:	83 ec 04             	sub    $0x4,%esp
  802714:	68 05 41 80 00       	push   $0x804105
  802719:	68 eb 00 00 00       	push   $0xeb
  80271e:	68 93 40 80 00       	push   $0x804093
  802723:	e8 d4 dc ff ff       	call   8003fc <_panic>
  802728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272b:	8b 00                	mov    (%eax),%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	74 10                	je     802741 <alloc_block_BF+0x175>
  802731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802739:	8b 52 04             	mov    0x4(%edx),%edx
  80273c:	89 50 04             	mov    %edx,0x4(%eax)
  80273f:	eb 0b                	jmp    80274c <alloc_block_BF+0x180>
  802741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802744:	8b 40 04             	mov    0x4(%eax),%eax
  802747:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80274c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274f:	8b 40 04             	mov    0x4(%eax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	74 0f                	je     802765 <alloc_block_BF+0x199>
  802756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802759:	8b 40 04             	mov    0x4(%eax),%eax
  80275c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80275f:	8b 12                	mov    (%edx),%edx
  802761:	89 10                	mov    %edx,(%eax)
  802763:	eb 0a                	jmp    80276f <alloc_block_BF+0x1a3>
  802765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	a3 48 51 80 00       	mov    %eax,0x805148
  80276f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802782:	a1 54 51 80 00       	mov    0x805154,%eax
  802787:	48                   	dec    %eax
  802788:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  80278d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802790:	eb 17                	jmp    8027a9 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 00                	mov    (%eax),%eax
  802797:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  80279a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279e:	0f 85 19 ff ff ff    	jne    8026bd <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
  8027ae:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8027b1:	a1 40 50 80 00       	mov    0x805040,%eax
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	75 19                	jne    8027d3 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	ff 75 08             	pushl  0x8(%ebp)
  8027c0:	e8 6f fc ff ff       	call   802434 <alloc_block_FF>
  8027c5:	83 c4 10             	add    $0x10,%esp
  8027c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	e9 e9 01 00 00       	jmp    8029bc <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8027d3:	a1 44 50 80 00       	mov    0x805044,%eax
  8027d8:	8b 40 08             	mov    0x8(%eax),%eax
  8027db:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8027de:	a1 44 50 80 00       	mov    0x805044,%eax
  8027e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8027e6:	a1 44 50 80 00       	mov    0x805044,%eax
  8027eb:	8b 40 08             	mov    0x8(%eax),%eax
  8027ee:	01 d0                	add    %edx,%eax
  8027f0:	83 ec 08             	sub    $0x8,%esp
  8027f3:	50                   	push   %eax
  8027f4:	68 38 51 80 00       	push   $0x805138
  8027f9:	e8 54 fa ff ff       	call   802252 <find_block>
  8027fe:	83 c4 10             	add    $0x10,%esp
  802801:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 40 0c             	mov    0xc(%eax),%eax
  80280a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280d:	0f 85 9b 00 00 00    	jne    8028ae <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 50 0c             	mov    0xc(%eax),%edx
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 40 08             	mov    0x8(%eax),%eax
  80281f:	01 d0                	add    %edx,%eax
  802821:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802828:	75 17                	jne    802841 <alloc_block_NF+0x96>
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 05 41 80 00       	push   $0x804105
  802832:	68 1a 01 00 00       	push   $0x11a
  802837:	68 93 40 80 00       	push   $0x804093
  80283c:	e8 bb db ff ff       	call   8003fc <_panic>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 10                	je     80285a <alloc_block_NF+0xaf>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802852:	8b 52 04             	mov    0x4(%edx),%edx
  802855:	89 50 04             	mov    %edx,0x4(%eax)
  802858:	eb 0b                	jmp    802865 <alloc_block_NF+0xba>
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 04             	mov    0x4(%eax),%eax
  802860:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 40 04             	mov    0x4(%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 0f                	je     80287e <alloc_block_NF+0xd3>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 40 04             	mov    0x4(%eax),%eax
  802875:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802878:	8b 12                	mov    (%edx),%edx
  80287a:	89 10                	mov    %edx,(%eax)
  80287c:	eb 0a                	jmp    802888 <alloc_block_NF+0xdd>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	a3 38 51 80 00       	mov    %eax,0x805138
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289b:	a1 44 51 80 00       	mov    0x805144,%eax
  8028a0:	48                   	dec    %eax
  8028a1:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	e9 0e 01 00 00       	jmp    8029bc <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b7:	0f 86 cf 00 00 00    	jbe    80298c <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8028bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8028c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cb:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 50 08             	mov    0x8(%eax),%edx
  8028d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d7:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 50 08             	mov    0x8(%eax),%edx
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	01 c2                	add    %eax,%edx
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8028f4:	89 c2                	mov    %eax,%edx
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 40 08             	mov    0x8(%eax),%eax
  802902:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802905:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802909:	75 17                	jne    802922 <alloc_block_NF+0x177>
  80290b:	83 ec 04             	sub    $0x4,%esp
  80290e:	68 05 41 80 00       	push   $0x804105
  802913:	68 28 01 00 00       	push   $0x128
  802918:	68 93 40 80 00       	push   $0x804093
  80291d:	e8 da da ff ff       	call   8003fc <_panic>
  802922:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	74 10                	je     80293b <alloc_block_NF+0x190>
  80292b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802933:	8b 52 04             	mov    0x4(%edx),%edx
  802936:	89 50 04             	mov    %edx,0x4(%eax)
  802939:	eb 0b                	jmp    802946 <alloc_block_NF+0x19b>
  80293b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	74 0f                	je     80295f <alloc_block_NF+0x1b4>
  802950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802959:	8b 12                	mov    (%edx),%edx
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	eb 0a                	jmp    802969 <alloc_block_NF+0x1be>
  80295f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	a3 48 51 80 00       	mov    %eax,0x805148
  802969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802975:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297c:	a1 54 51 80 00       	mov    0x805154,%eax
  802981:	48                   	dec    %eax
  802982:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298a:	eb 30                	jmp    8029bc <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80298c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802991:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802994:	75 0a                	jne    8029a0 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802996:	a1 38 51 80 00       	mov    0x805138,%eax
  80299b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299e:	eb 08                	jmp    8029a8 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 08             	mov    0x8(%eax),%eax
  8029ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029b1:	0f 85 4d fe ff ff    	jne    802804 <alloc_block_NF+0x59>

			return NULL;
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    

008029be <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
  8029c1:	53                   	push   %ebx
  8029c2:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8029c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	0f 85 86 00 00 00    	jne    802a58 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8029d2:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8029d9:	00 00 00 
  8029dc:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8029e3:	00 00 00 
  8029e6:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8029ed:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f4:	75 17                	jne    802a0d <insert_sorted_with_merge_freeList+0x4f>
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 70 40 80 00       	push   $0x804070
  8029fe:	68 48 01 00 00       	push   $0x148
  802a03:	68 93 40 80 00       	push   $0x804093
  802a08:	e8 ef d9 ff ff       	call   8003fc <_panic>
  802a0d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	89 10                	mov    %edx,(%eax)
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	74 0d                	je     802a2e <insert_sorted_with_merge_freeList+0x70>
  802a21:	a1 38 51 80 00       	mov    0x805138,%eax
  802a26:	8b 55 08             	mov    0x8(%ebp),%edx
  802a29:	89 50 04             	mov    %edx,0x4(%eax)
  802a2c:	eb 08                	jmp    802a36 <insert_sorted_with_merge_freeList+0x78>
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	a3 38 51 80 00       	mov    %eax,0x805138
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a48:	a1 44 51 80 00       	mov    0x805144,%eax
  802a4d:	40                   	inc    %eax
  802a4e:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802a53:	e9 73 07 00 00       	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	8b 50 08             	mov    0x8(%eax),%edx
  802a5e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802a63:	8b 40 08             	mov    0x8(%eax),%eax
  802a66:	39 c2                	cmp    %eax,%edx
  802a68:	0f 86 84 00 00 00    	jbe    802af2 <insert_sorted_with_merge_freeList+0x134>
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	8b 50 08             	mov    0x8(%eax),%edx
  802a74:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802a79:	8b 48 0c             	mov    0xc(%eax),%ecx
  802a7c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802a81:	8b 40 08             	mov    0x8(%eax),%eax
  802a84:	01 c8                	add    %ecx,%eax
  802a86:	39 c2                	cmp    %eax,%edx
  802a88:	74 68                	je     802af2 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802a8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8e:	75 17                	jne    802aa7 <insert_sorted_with_merge_freeList+0xe9>
  802a90:	83 ec 04             	sub    $0x4,%esp
  802a93:	68 ac 40 80 00       	push   $0x8040ac
  802a98:	68 4c 01 00 00       	push   $0x14c
  802a9d:	68 93 40 80 00       	push   $0x804093
  802aa2:	e8 55 d9 ff ff       	call   8003fc <_panic>
  802aa7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	89 50 04             	mov    %edx,0x4(%eax)
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0c                	je     802ac9 <insert_sorted_with_merge_freeList+0x10b>
  802abd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac5:	89 10                	mov    %edx,(%eax)
  802ac7:	eb 08                	jmp    802ad1 <insert_sorted_with_merge_freeList+0x113>
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	a3 38 51 80 00       	mov    %eax,0x805138
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ae7:	40                   	inc    %eax
  802ae8:	a3 44 51 80 00       	mov    %eax,0x805144
  802aed:	e9 d9 06 00 00       	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	8b 50 08             	mov    0x8(%eax),%edx
  802af8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802afd:	8b 40 08             	mov    0x8(%eax),%eax
  802b00:	39 c2                	cmp    %eax,%edx
  802b02:	0f 86 b5 00 00 00    	jbe    802bbd <insert_sorted_with_merge_freeList+0x1ff>
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	8b 50 08             	mov    0x8(%eax),%edx
  802b0e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b13:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b16:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b1b:	8b 40 08             	mov    0x8(%eax),%eax
  802b1e:	01 c8                	add    %ecx,%eax
  802b20:	39 c2                	cmp    %eax,%edx
  802b22:	0f 85 95 00 00 00    	jne    802bbd <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802b28:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b2d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802b33:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b36:	8b 55 08             	mov    0x8(%ebp),%edx
  802b39:	8b 52 0c             	mov    0xc(%edx),%edx
  802b3c:	01 ca                	add    %ecx,%edx
  802b3e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b59:	75 17                	jne    802b72 <insert_sorted_with_merge_freeList+0x1b4>
  802b5b:	83 ec 04             	sub    $0x4,%esp
  802b5e:	68 70 40 80 00       	push   $0x804070
  802b63:	68 54 01 00 00       	push   $0x154
  802b68:	68 93 40 80 00       	push   $0x804093
  802b6d:	e8 8a d8 ff ff       	call   8003fc <_panic>
  802b72:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	89 10                	mov    %edx,(%eax)
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 00                	mov    (%eax),%eax
  802b82:	85 c0                	test   %eax,%eax
  802b84:	74 0d                	je     802b93 <insert_sorted_with_merge_freeList+0x1d5>
  802b86:	a1 48 51 80 00       	mov    0x805148,%eax
  802b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8e:	89 50 04             	mov    %edx,0x4(%eax)
  802b91:	eb 08                	jmp    802b9b <insert_sorted_with_merge_freeList+0x1dd>
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bad:	a1 54 51 80 00       	mov    0x805154,%eax
  802bb2:	40                   	inc    %eax
  802bb3:	a3 54 51 80 00       	mov    %eax,0x805154
  802bb8:	e9 0e 06 00 00       	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	8b 50 08             	mov    0x8(%eax),%edx
  802bc3:	a1 38 51 80 00       	mov    0x805138,%eax
  802bc8:	8b 40 08             	mov    0x8(%eax),%eax
  802bcb:	39 c2                	cmp    %eax,%edx
  802bcd:	0f 83 c1 00 00 00    	jae    802c94 <insert_sorted_with_merge_freeList+0x2d6>
  802bd3:	a1 38 51 80 00       	mov    0x805138,%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	8b 48 08             	mov    0x8(%eax),%ecx
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 40 0c             	mov    0xc(%eax),%eax
  802be7:	01 c8                	add    %ecx,%eax
  802be9:	39 c2                	cmp    %eax,%edx
  802beb:	0f 85 a3 00 00 00    	jne    802c94 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802bf1:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf9:	8b 52 08             	mov    0x8(%edx),%edx
  802bfc:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802bff:	a1 38 51 80 00       	mov    0x805138,%eax
  802c04:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c0a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c10:	8b 52 0c             	mov    0xc(%edx),%edx
  802c13:	01 ca                	add    %ecx,%edx
  802c15:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c30:	75 17                	jne    802c49 <insert_sorted_with_merge_freeList+0x28b>
  802c32:	83 ec 04             	sub    $0x4,%esp
  802c35:	68 70 40 80 00       	push   $0x804070
  802c3a:	68 5d 01 00 00       	push   $0x15d
  802c3f:	68 93 40 80 00       	push   $0x804093
  802c44:	e8 b3 d7 ff ff       	call   8003fc <_panic>
  802c49:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	89 10                	mov    %edx,(%eax)
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	74 0d                	je     802c6a <insert_sorted_with_merge_freeList+0x2ac>
  802c5d:	a1 48 51 80 00       	mov    0x805148,%eax
  802c62:	8b 55 08             	mov    0x8(%ebp),%edx
  802c65:	89 50 04             	mov    %edx,0x4(%eax)
  802c68:	eb 08                	jmp    802c72 <insert_sorted_with_merge_freeList+0x2b4>
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	a3 48 51 80 00       	mov    %eax,0x805148
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c84:	a1 54 51 80 00       	mov    0x805154,%eax
  802c89:	40                   	inc    %eax
  802c8a:	a3 54 51 80 00       	mov    %eax,0x805154
  802c8f:	e9 37 05 00 00       	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	8b 50 08             	mov    0x8(%eax),%edx
  802c9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ca2:	39 c2                	cmp    %eax,%edx
  802ca4:	0f 83 82 00 00 00    	jae    802d2c <insert_sorted_with_merge_freeList+0x36e>
  802caa:	a1 38 51 80 00       	mov    0x805138,%eax
  802caf:	8b 50 08             	mov    0x8(%eax),%edx
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	8b 48 08             	mov    0x8(%eax),%ecx
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	01 c8                	add    %ecx,%eax
  802cc0:	39 c2                	cmp    %eax,%edx
  802cc2:	74 68                	je     802d2c <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802cc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc8:	75 17                	jne    802ce1 <insert_sorted_with_merge_freeList+0x323>
  802cca:	83 ec 04             	sub    $0x4,%esp
  802ccd:	68 70 40 80 00       	push   $0x804070
  802cd2:	68 62 01 00 00       	push   $0x162
  802cd7:	68 93 40 80 00       	push   $0x804093
  802cdc:	e8 1b d7 ff ff       	call   8003fc <_panic>
  802ce1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	89 10                	mov    %edx,(%eax)
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 0d                	je     802d02 <insert_sorted_with_merge_freeList+0x344>
  802cf5:	a1 38 51 80 00       	mov    0x805138,%eax
  802cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfd:	89 50 04             	mov    %edx,0x4(%eax)
  802d00:	eb 08                	jmp    802d0a <insert_sorted_with_merge_freeList+0x34c>
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d21:	40                   	inc    %eax
  802d22:	a3 44 51 80 00       	mov    %eax,0x805144
  802d27:	e9 9f 04 00 00       	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  802d2c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802d36:	e9 84 04 00 00       	jmp    8031bf <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 50 08             	mov    0x8(%eax),%edx
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 40 08             	mov    0x8(%eax),%eax
  802d47:	39 c2                	cmp    %eax,%edx
  802d49:	0f 86 a9 00 00 00    	jbe    802df8 <insert_sorted_with_merge_freeList+0x43a>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 50 08             	mov    0x8(%eax),%edx
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 48 08             	mov    0x8(%eax),%ecx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d61:	01 c8                	add    %ecx,%eax
  802d63:	39 c2                	cmp    %eax,%edx
  802d65:	0f 84 8d 00 00 00    	je     802df8 <insert_sorted_with_merge_freeList+0x43a>
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	8b 50 08             	mov    0x8(%eax),%edx
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 40 04             	mov    0x4(%eax),%eax
  802d77:	8b 48 08             	mov    0x8(%eax),%ecx
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	8b 40 0c             	mov    0xc(%eax),%eax
  802d83:	01 c8                	add    %ecx,%eax
  802d85:	39 c2                	cmp    %eax,%edx
  802d87:	74 6f                	je     802df8 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  802d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8d:	74 06                	je     802d95 <insert_sorted_with_merge_freeList+0x3d7>
  802d8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d93:	75 17                	jne    802dac <insert_sorted_with_merge_freeList+0x3ee>
  802d95:	83 ec 04             	sub    $0x4,%esp
  802d98:	68 d0 40 80 00       	push   $0x8040d0
  802d9d:	68 6b 01 00 00       	push   $0x16b
  802da2:	68 93 40 80 00       	push   $0x804093
  802da7:	e8 50 d6 ff ff       	call   8003fc <_panic>
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 50 04             	mov    0x4(%eax),%edx
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbe:	89 10                	mov    %edx,(%eax)
  802dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc3:	8b 40 04             	mov    0x4(%eax),%eax
  802dc6:	85 c0                	test   %eax,%eax
  802dc8:	74 0d                	je     802dd7 <insert_sorted_with_merge_freeList+0x419>
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 40 04             	mov    0x4(%eax),%eax
  802dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd3:	89 10                	mov    %edx,(%eax)
  802dd5:	eb 08                	jmp    802ddf <insert_sorted_with_merge_freeList+0x421>
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	a3 38 51 80 00       	mov    %eax,0x805138
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 55 08             	mov    0x8(%ebp),%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ded:	40                   	inc    %eax
  802dee:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  802df3:	e9 d3 03 00 00       	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 50 08             	mov    0x8(%eax),%edx
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 40 08             	mov    0x8(%eax),%eax
  802e04:	39 c2                	cmp    %eax,%edx
  802e06:	0f 86 da 00 00 00    	jbe    802ee6 <insert_sorted_with_merge_freeList+0x528>
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 50 08             	mov    0x8(%eax),%edx
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	8b 48 08             	mov    0x8(%eax),%ecx
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1e:	01 c8                	add    %ecx,%eax
  802e20:	39 c2                	cmp    %eax,%edx
  802e22:	0f 85 be 00 00 00    	jne    802ee6 <insert_sorted_with_merge_freeList+0x528>
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 50 08             	mov    0x8(%eax),%edx
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 04             	mov    0x4(%eax),%eax
  802e34:	8b 48 08             	mov    0x8(%eax),%ecx
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	8b 40 04             	mov    0x4(%eax),%eax
  802e3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e40:	01 c8                	add    %ecx,%eax
  802e42:	39 c2                	cmp    %eax,%edx
  802e44:	0f 84 9c 00 00 00    	je     802ee6 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	8b 50 08             	mov    0x8(%eax),%edx
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e82:	75 17                	jne    802e9b <insert_sorted_with_merge_freeList+0x4dd>
  802e84:	83 ec 04             	sub    $0x4,%esp
  802e87:	68 70 40 80 00       	push   $0x804070
  802e8c:	68 74 01 00 00       	push   $0x174
  802e91:	68 93 40 80 00       	push   $0x804093
  802e96:	e8 61 d5 ff ff       	call   8003fc <_panic>
  802e9b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	89 10                	mov    %edx,(%eax)
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	74 0d                	je     802ebc <insert_sorted_with_merge_freeList+0x4fe>
  802eaf:	a1 48 51 80 00       	mov    0x805148,%eax
  802eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb7:	89 50 04             	mov    %edx,0x4(%eax)
  802eba:	eb 08                	jmp    802ec4 <insert_sorted_with_merge_freeList+0x506>
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	a3 48 51 80 00       	mov    %eax,0x805148
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed6:	a1 54 51 80 00       	mov    0x805154,%eax
  802edb:	40                   	inc    %eax
  802edc:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  802ee1:	e9 e5 02 00 00       	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 50 08             	mov    0x8(%eax),%edx
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 40 08             	mov    0x8(%eax),%eax
  802ef2:	39 c2                	cmp    %eax,%edx
  802ef4:	0f 86 d7 00 00 00    	jbe    802fd1 <insert_sorted_with_merge_freeList+0x613>
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 50 08             	mov    0x8(%eax),%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 48 08             	mov    0x8(%eax),%ecx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	01 c8                	add    %ecx,%eax
  802f0e:	39 c2                	cmp    %eax,%edx
  802f10:	0f 84 bb 00 00 00    	je     802fd1 <insert_sorted_with_merge_freeList+0x613>
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 50 08             	mov    0x8(%eax),%edx
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 40 04             	mov    0x4(%eax),%eax
  802f22:	8b 48 08             	mov    0x8(%eax),%ecx
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 40 04             	mov    0x4(%eax),%eax
  802f2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2e:	01 c8                	add    %ecx,%eax
  802f30:	39 c2                	cmp    %eax,%edx
  802f32:	0f 85 99 00 00 00    	jne    802fd1 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  802f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f44:	8b 50 0c             	mov    0xc(%eax),%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4d:	01 c2                	add    %eax,%edx
  802f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f52:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6d:	75 17                	jne    802f86 <insert_sorted_with_merge_freeList+0x5c8>
  802f6f:	83 ec 04             	sub    $0x4,%esp
  802f72:	68 70 40 80 00       	push   $0x804070
  802f77:	68 7d 01 00 00       	push   $0x17d
  802f7c:	68 93 40 80 00       	push   $0x804093
  802f81:	e8 76 d4 ff ff       	call   8003fc <_panic>
  802f86:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	89 10                	mov    %edx,(%eax)
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	85 c0                	test   %eax,%eax
  802f98:	74 0d                	je     802fa7 <insert_sorted_with_merge_freeList+0x5e9>
  802f9a:	a1 48 51 80 00       	mov    0x805148,%eax
  802f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa2:	89 50 04             	mov    %edx,0x4(%eax)
  802fa5:	eb 08                	jmp    802faf <insert_sorted_with_merge_freeList+0x5f1>
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc1:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc6:	40                   	inc    %eax
  802fc7:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  802fcc:	e9 fa 01 00 00       	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 50 08             	mov    0x8(%eax),%edx
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	8b 40 08             	mov    0x8(%eax),%eax
  802fdd:	39 c2                	cmp    %eax,%edx
  802fdf:	0f 86 d2 01 00 00    	jbe    8031b7 <insert_sorted_with_merge_freeList+0x7f9>
  802fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe8:	8b 50 08             	mov    0x8(%eax),%edx
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	8b 48 08             	mov    0x8(%eax),%ecx
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff7:	01 c8                	add    %ecx,%eax
  802ff9:	39 c2                	cmp    %eax,%edx
  802ffb:	0f 85 b6 01 00 00    	jne    8031b7 <insert_sorted_with_merge_freeList+0x7f9>
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	8b 50 08             	mov    0x8(%eax),%edx
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 40 04             	mov    0x4(%eax),%eax
  80300d:	8b 48 08             	mov    0x8(%eax),%ecx
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 40 04             	mov    0x4(%eax),%eax
  803016:	8b 40 0c             	mov    0xc(%eax),%eax
  803019:	01 c8                	add    %ecx,%eax
  80301b:	39 c2                	cmp    %eax,%edx
  80301d:	0f 85 94 01 00 00    	jne    8031b7 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 40 04             	mov    0x4(%eax),%eax
  803029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302c:	8b 52 04             	mov    0x4(%edx),%edx
  80302f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803032:	8b 55 08             	mov    0x8(%ebp),%edx
  803035:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303b:	8b 52 0c             	mov    0xc(%edx),%edx
  80303e:	01 da                	add    %ebx,%edx
  803040:	01 ca                	add    %ecx,%edx
  803042:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803059:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305d:	75 17                	jne    803076 <insert_sorted_with_merge_freeList+0x6b8>
  80305f:	83 ec 04             	sub    $0x4,%esp
  803062:	68 05 41 80 00       	push   $0x804105
  803067:	68 86 01 00 00       	push   $0x186
  80306c:	68 93 40 80 00       	push   $0x804093
  803071:	e8 86 d3 ff ff       	call   8003fc <_panic>
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 10                	je     80308f <insert_sorted_with_merge_freeList+0x6d1>
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803087:	8b 52 04             	mov    0x4(%edx),%edx
  80308a:	89 50 04             	mov    %edx,0x4(%eax)
  80308d:	eb 0b                	jmp    80309a <insert_sorted_with_merge_freeList+0x6dc>
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 04             	mov    0x4(%eax),%eax
  803095:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 0f                	je     8030b3 <insert_sorted_with_merge_freeList+0x6f5>
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 40 04             	mov    0x4(%eax),%eax
  8030aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ad:	8b 12                	mov    (%edx),%edx
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	eb 0a                	jmp    8030bd <insert_sorted_with_merge_freeList+0x6ff>
  8030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d0:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d5:	48                   	dec    %eax
  8030d6:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  8030db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030df:	75 17                	jne    8030f8 <insert_sorted_with_merge_freeList+0x73a>
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 70 40 80 00       	push   $0x804070
  8030e9:	68 87 01 00 00       	push   $0x187
  8030ee:	68 93 40 80 00       	push   $0x804093
  8030f3:	e8 04 d3 ff ff       	call   8003fc <_panic>
  8030f8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	89 10                	mov    %edx,(%eax)
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	85 c0                	test   %eax,%eax
  80310a:	74 0d                	je     803119 <insert_sorted_with_merge_freeList+0x75b>
  80310c:	a1 48 51 80 00       	mov    0x805148,%eax
  803111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803114:	89 50 04             	mov    %edx,0x4(%eax)
  803117:	eb 08                	jmp    803121 <insert_sorted_with_merge_freeList+0x763>
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	a3 48 51 80 00       	mov    %eax,0x805148
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803133:	a1 54 51 80 00       	mov    0x805154,%eax
  803138:	40                   	inc    %eax
  803139:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803152:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803156:	75 17                	jne    80316f <insert_sorted_with_merge_freeList+0x7b1>
  803158:	83 ec 04             	sub    $0x4,%esp
  80315b:	68 70 40 80 00       	push   $0x804070
  803160:	68 8a 01 00 00       	push   $0x18a
  803165:	68 93 40 80 00       	push   $0x804093
  80316a:	e8 8d d2 ff ff       	call   8003fc <_panic>
  80316f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	89 10                	mov    %edx,(%eax)
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 00                	mov    (%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 0d                	je     803190 <insert_sorted_with_merge_freeList+0x7d2>
  803183:	a1 48 51 80 00       	mov    0x805148,%eax
  803188:	8b 55 08             	mov    0x8(%ebp),%edx
  80318b:	89 50 04             	mov    %edx,0x4(%eax)
  80318e:	eb 08                	jmp    803198 <insert_sorted_with_merge_freeList+0x7da>
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8031af:	40                   	inc    %eax
  8031b0:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  8031b5:	eb 14                	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8031bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c3:	0f 85 72 fb ff ff    	jne    802d3b <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8031c9:	eb 00                	jmp    8031cb <insert_sorted_with_merge_freeList+0x80d>
  8031cb:	90                   	nop
  8031cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031cf:	c9                   	leave  
  8031d0:	c3                   	ret    
  8031d1:	66 90                	xchg   %ax,%ax
  8031d3:	90                   	nop

008031d4 <__udivdi3>:
  8031d4:	55                   	push   %ebp
  8031d5:	57                   	push   %edi
  8031d6:	56                   	push   %esi
  8031d7:	53                   	push   %ebx
  8031d8:	83 ec 1c             	sub    $0x1c,%esp
  8031db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031eb:	89 ca                	mov    %ecx,%edx
  8031ed:	89 f8                	mov    %edi,%eax
  8031ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031f3:	85 f6                	test   %esi,%esi
  8031f5:	75 2d                	jne    803224 <__udivdi3+0x50>
  8031f7:	39 cf                	cmp    %ecx,%edi
  8031f9:	77 65                	ja     803260 <__udivdi3+0x8c>
  8031fb:	89 fd                	mov    %edi,%ebp
  8031fd:	85 ff                	test   %edi,%edi
  8031ff:	75 0b                	jne    80320c <__udivdi3+0x38>
  803201:	b8 01 00 00 00       	mov    $0x1,%eax
  803206:	31 d2                	xor    %edx,%edx
  803208:	f7 f7                	div    %edi
  80320a:	89 c5                	mov    %eax,%ebp
  80320c:	31 d2                	xor    %edx,%edx
  80320e:	89 c8                	mov    %ecx,%eax
  803210:	f7 f5                	div    %ebp
  803212:	89 c1                	mov    %eax,%ecx
  803214:	89 d8                	mov    %ebx,%eax
  803216:	f7 f5                	div    %ebp
  803218:	89 cf                	mov    %ecx,%edi
  80321a:	89 fa                	mov    %edi,%edx
  80321c:	83 c4 1c             	add    $0x1c,%esp
  80321f:	5b                   	pop    %ebx
  803220:	5e                   	pop    %esi
  803221:	5f                   	pop    %edi
  803222:	5d                   	pop    %ebp
  803223:	c3                   	ret    
  803224:	39 ce                	cmp    %ecx,%esi
  803226:	77 28                	ja     803250 <__udivdi3+0x7c>
  803228:	0f bd fe             	bsr    %esi,%edi
  80322b:	83 f7 1f             	xor    $0x1f,%edi
  80322e:	75 40                	jne    803270 <__udivdi3+0x9c>
  803230:	39 ce                	cmp    %ecx,%esi
  803232:	72 0a                	jb     80323e <__udivdi3+0x6a>
  803234:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803238:	0f 87 9e 00 00 00    	ja     8032dc <__udivdi3+0x108>
  80323e:	b8 01 00 00 00       	mov    $0x1,%eax
  803243:	89 fa                	mov    %edi,%edx
  803245:	83 c4 1c             	add    $0x1c,%esp
  803248:	5b                   	pop    %ebx
  803249:	5e                   	pop    %esi
  80324a:	5f                   	pop    %edi
  80324b:	5d                   	pop    %ebp
  80324c:	c3                   	ret    
  80324d:	8d 76 00             	lea    0x0(%esi),%esi
  803250:	31 ff                	xor    %edi,%edi
  803252:	31 c0                	xor    %eax,%eax
  803254:	89 fa                	mov    %edi,%edx
  803256:	83 c4 1c             	add    $0x1c,%esp
  803259:	5b                   	pop    %ebx
  80325a:	5e                   	pop    %esi
  80325b:	5f                   	pop    %edi
  80325c:	5d                   	pop    %ebp
  80325d:	c3                   	ret    
  80325e:	66 90                	xchg   %ax,%ax
  803260:	89 d8                	mov    %ebx,%eax
  803262:	f7 f7                	div    %edi
  803264:	31 ff                	xor    %edi,%edi
  803266:	89 fa                	mov    %edi,%edx
  803268:	83 c4 1c             	add    $0x1c,%esp
  80326b:	5b                   	pop    %ebx
  80326c:	5e                   	pop    %esi
  80326d:	5f                   	pop    %edi
  80326e:	5d                   	pop    %ebp
  80326f:	c3                   	ret    
  803270:	bd 20 00 00 00       	mov    $0x20,%ebp
  803275:	89 eb                	mov    %ebp,%ebx
  803277:	29 fb                	sub    %edi,%ebx
  803279:	89 f9                	mov    %edi,%ecx
  80327b:	d3 e6                	shl    %cl,%esi
  80327d:	89 c5                	mov    %eax,%ebp
  80327f:	88 d9                	mov    %bl,%cl
  803281:	d3 ed                	shr    %cl,%ebp
  803283:	89 e9                	mov    %ebp,%ecx
  803285:	09 f1                	or     %esi,%ecx
  803287:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80328b:	89 f9                	mov    %edi,%ecx
  80328d:	d3 e0                	shl    %cl,%eax
  80328f:	89 c5                	mov    %eax,%ebp
  803291:	89 d6                	mov    %edx,%esi
  803293:	88 d9                	mov    %bl,%cl
  803295:	d3 ee                	shr    %cl,%esi
  803297:	89 f9                	mov    %edi,%ecx
  803299:	d3 e2                	shl    %cl,%edx
  80329b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80329f:	88 d9                	mov    %bl,%cl
  8032a1:	d3 e8                	shr    %cl,%eax
  8032a3:	09 c2                	or     %eax,%edx
  8032a5:	89 d0                	mov    %edx,%eax
  8032a7:	89 f2                	mov    %esi,%edx
  8032a9:	f7 74 24 0c          	divl   0xc(%esp)
  8032ad:	89 d6                	mov    %edx,%esi
  8032af:	89 c3                	mov    %eax,%ebx
  8032b1:	f7 e5                	mul    %ebp
  8032b3:	39 d6                	cmp    %edx,%esi
  8032b5:	72 19                	jb     8032d0 <__udivdi3+0xfc>
  8032b7:	74 0b                	je     8032c4 <__udivdi3+0xf0>
  8032b9:	89 d8                	mov    %ebx,%eax
  8032bb:	31 ff                	xor    %edi,%edi
  8032bd:	e9 58 ff ff ff       	jmp    80321a <__udivdi3+0x46>
  8032c2:	66 90                	xchg   %ax,%ax
  8032c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032c8:	89 f9                	mov    %edi,%ecx
  8032ca:	d3 e2                	shl    %cl,%edx
  8032cc:	39 c2                	cmp    %eax,%edx
  8032ce:	73 e9                	jae    8032b9 <__udivdi3+0xe5>
  8032d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032d3:	31 ff                	xor    %edi,%edi
  8032d5:	e9 40 ff ff ff       	jmp    80321a <__udivdi3+0x46>
  8032da:	66 90                	xchg   %ax,%ax
  8032dc:	31 c0                	xor    %eax,%eax
  8032de:	e9 37 ff ff ff       	jmp    80321a <__udivdi3+0x46>
  8032e3:	90                   	nop

008032e4 <__umoddi3>:
  8032e4:	55                   	push   %ebp
  8032e5:	57                   	push   %edi
  8032e6:	56                   	push   %esi
  8032e7:	53                   	push   %ebx
  8032e8:	83 ec 1c             	sub    $0x1c,%esp
  8032eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803303:	89 f3                	mov    %esi,%ebx
  803305:	89 fa                	mov    %edi,%edx
  803307:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80330b:	89 34 24             	mov    %esi,(%esp)
  80330e:	85 c0                	test   %eax,%eax
  803310:	75 1a                	jne    80332c <__umoddi3+0x48>
  803312:	39 f7                	cmp    %esi,%edi
  803314:	0f 86 a2 00 00 00    	jbe    8033bc <__umoddi3+0xd8>
  80331a:	89 c8                	mov    %ecx,%eax
  80331c:	89 f2                	mov    %esi,%edx
  80331e:	f7 f7                	div    %edi
  803320:	89 d0                	mov    %edx,%eax
  803322:	31 d2                	xor    %edx,%edx
  803324:	83 c4 1c             	add    $0x1c,%esp
  803327:	5b                   	pop    %ebx
  803328:	5e                   	pop    %esi
  803329:	5f                   	pop    %edi
  80332a:	5d                   	pop    %ebp
  80332b:	c3                   	ret    
  80332c:	39 f0                	cmp    %esi,%eax
  80332e:	0f 87 ac 00 00 00    	ja     8033e0 <__umoddi3+0xfc>
  803334:	0f bd e8             	bsr    %eax,%ebp
  803337:	83 f5 1f             	xor    $0x1f,%ebp
  80333a:	0f 84 ac 00 00 00    	je     8033ec <__umoddi3+0x108>
  803340:	bf 20 00 00 00       	mov    $0x20,%edi
  803345:	29 ef                	sub    %ebp,%edi
  803347:	89 fe                	mov    %edi,%esi
  803349:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80334d:	89 e9                	mov    %ebp,%ecx
  80334f:	d3 e0                	shl    %cl,%eax
  803351:	89 d7                	mov    %edx,%edi
  803353:	89 f1                	mov    %esi,%ecx
  803355:	d3 ef                	shr    %cl,%edi
  803357:	09 c7                	or     %eax,%edi
  803359:	89 e9                	mov    %ebp,%ecx
  80335b:	d3 e2                	shl    %cl,%edx
  80335d:	89 14 24             	mov    %edx,(%esp)
  803360:	89 d8                	mov    %ebx,%eax
  803362:	d3 e0                	shl    %cl,%eax
  803364:	89 c2                	mov    %eax,%edx
  803366:	8b 44 24 08          	mov    0x8(%esp),%eax
  80336a:	d3 e0                	shl    %cl,%eax
  80336c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803370:	8b 44 24 08          	mov    0x8(%esp),%eax
  803374:	89 f1                	mov    %esi,%ecx
  803376:	d3 e8                	shr    %cl,%eax
  803378:	09 d0                	or     %edx,%eax
  80337a:	d3 eb                	shr    %cl,%ebx
  80337c:	89 da                	mov    %ebx,%edx
  80337e:	f7 f7                	div    %edi
  803380:	89 d3                	mov    %edx,%ebx
  803382:	f7 24 24             	mull   (%esp)
  803385:	89 c6                	mov    %eax,%esi
  803387:	89 d1                	mov    %edx,%ecx
  803389:	39 d3                	cmp    %edx,%ebx
  80338b:	0f 82 87 00 00 00    	jb     803418 <__umoddi3+0x134>
  803391:	0f 84 91 00 00 00    	je     803428 <__umoddi3+0x144>
  803397:	8b 54 24 04          	mov    0x4(%esp),%edx
  80339b:	29 f2                	sub    %esi,%edx
  80339d:	19 cb                	sbb    %ecx,%ebx
  80339f:	89 d8                	mov    %ebx,%eax
  8033a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8033a5:	d3 e0                	shl    %cl,%eax
  8033a7:	89 e9                	mov    %ebp,%ecx
  8033a9:	d3 ea                	shr    %cl,%edx
  8033ab:	09 d0                	or     %edx,%eax
  8033ad:	89 e9                	mov    %ebp,%ecx
  8033af:	d3 eb                	shr    %cl,%ebx
  8033b1:	89 da                	mov    %ebx,%edx
  8033b3:	83 c4 1c             	add    $0x1c,%esp
  8033b6:	5b                   	pop    %ebx
  8033b7:	5e                   	pop    %esi
  8033b8:	5f                   	pop    %edi
  8033b9:	5d                   	pop    %ebp
  8033ba:	c3                   	ret    
  8033bb:	90                   	nop
  8033bc:	89 fd                	mov    %edi,%ebp
  8033be:	85 ff                	test   %edi,%edi
  8033c0:	75 0b                	jne    8033cd <__umoddi3+0xe9>
  8033c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033c7:	31 d2                	xor    %edx,%edx
  8033c9:	f7 f7                	div    %edi
  8033cb:	89 c5                	mov    %eax,%ebp
  8033cd:	89 f0                	mov    %esi,%eax
  8033cf:	31 d2                	xor    %edx,%edx
  8033d1:	f7 f5                	div    %ebp
  8033d3:	89 c8                	mov    %ecx,%eax
  8033d5:	f7 f5                	div    %ebp
  8033d7:	89 d0                	mov    %edx,%eax
  8033d9:	e9 44 ff ff ff       	jmp    803322 <__umoddi3+0x3e>
  8033de:	66 90                	xchg   %ax,%ax
  8033e0:	89 c8                	mov    %ecx,%eax
  8033e2:	89 f2                	mov    %esi,%edx
  8033e4:	83 c4 1c             	add    $0x1c,%esp
  8033e7:	5b                   	pop    %ebx
  8033e8:	5e                   	pop    %esi
  8033e9:	5f                   	pop    %edi
  8033ea:	5d                   	pop    %ebp
  8033eb:	c3                   	ret    
  8033ec:	3b 04 24             	cmp    (%esp),%eax
  8033ef:	72 06                	jb     8033f7 <__umoddi3+0x113>
  8033f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033f5:	77 0f                	ja     803406 <__umoddi3+0x122>
  8033f7:	89 f2                	mov    %esi,%edx
  8033f9:	29 f9                	sub    %edi,%ecx
  8033fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033ff:	89 14 24             	mov    %edx,(%esp)
  803402:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803406:	8b 44 24 04          	mov    0x4(%esp),%eax
  80340a:	8b 14 24             	mov    (%esp),%edx
  80340d:	83 c4 1c             	add    $0x1c,%esp
  803410:	5b                   	pop    %ebx
  803411:	5e                   	pop    %esi
  803412:	5f                   	pop    %edi
  803413:	5d                   	pop    %ebp
  803414:	c3                   	ret    
  803415:	8d 76 00             	lea    0x0(%esi),%esi
  803418:	2b 04 24             	sub    (%esp),%eax
  80341b:	19 fa                	sbb    %edi,%edx
  80341d:	89 d1                	mov    %edx,%ecx
  80341f:	89 c6                	mov    %eax,%esi
  803421:	e9 71 ff ff ff       	jmp    803397 <__umoddi3+0xb3>
  803426:	66 90                	xchg   %ax,%ax
  803428:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80342c:	72 ea                	jb     803418 <__umoddi3+0x134>
  80342e:	89 d9                	mov    %ebx,%ecx
  803430:	e9 62 ff ff ff       	jmp    803397 <__umoddi3+0xb3>
