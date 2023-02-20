
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 81 0c 00 00       	call   800cb7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 04                	push   $0x4
  800048:	e8 23 29 00 00       	call   802970 <sys_set_uheap_strategy>
  80004d:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800050:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80005b:	eb 29                	jmp    800086 <_main+0x4e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005d:	a1 20 50 80 00       	mov    0x805020,%eax
  800062:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80006b:	89 d0                	mov    %edx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	01 c8                	add    %ecx,%eax
  800076:	8a 40 04             	mov    0x4(%eax),%al
  800079:	84 c0                	test   %al,%al
  80007b:	74 06                	je     800083 <_main+0x4b>
			{
				fullWS = 0;
  80007d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800081:	eb 12                	jmp    800095 <_main+0x5d>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800083:	ff 45 f0             	incl   -0x10(%ebp)
  800086:	a1 20 50 80 00       	mov    0x805020,%eax
  80008b:	8b 50 74             	mov    0x74(%eax),%edx
  80008e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800091:	39 c2                	cmp    %eax,%edx
  800093:	77 c8                	ja     80005d <_main+0x25>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800095:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 40 3e 80 00       	push   $0x803e40
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 5c 3e 80 00       	push   $0x803e5c
  8000aa:	e8 44 0d 00 00       	call   800df3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 3e 1f 00 00       	call   801ff7 <malloc>
  8000b9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000bc:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  8000c3:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)

	int count = 0;
  8000ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int totalNumberOfTests = 11;
  8000d1:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	f7 f7                	div    %edi
  8000eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000ee:	81 7d c8 00 01 00 00 	cmpl   $0x100,-0x38(%ebp)
  8000f5:	74 16                	je     80010d <_main+0xd5>
  8000f7:	68 70 3e 80 00       	push   $0x803e70
  8000fc:	68 87 3e 80 00       	push   $0x803e87
  800101:	6a 24                	push   $0x24
  800103:	68 5c 3e 80 00       	push   $0x803e5c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 59 28 00 00       	call   802970 <sys_set_uheap_strategy>
  800117:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80011a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80011e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800125:	eb 29                	jmp    800150 <_main+0x118>
		{
			if (myEnv->__uptr_pws[i].empty)
  800127:	a1 20 50 80 00       	mov    0x805020,%eax
  80012c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800135:	89 d0                	mov    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 c8                	add    %ecx,%eax
  800140:	8a 40 04             	mov    0x4(%eax),%al
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <_main+0x115>
			{
				fullWS = 0;
  800147:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80014b:	eb 12                	jmp    80015f <_main+0x127>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80014d:	ff 45 e8             	incl   -0x18(%ebp)
  800150:	a1 20 50 80 00       	mov    0x805020,%eax
  800155:	8b 50 74             	mov    0x74(%eax),%edx
  800158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015b:	39 c2                	cmp    %eax,%edx
  80015d:	77 c8                	ja     800127 <_main+0xef>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80015f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800163:	74 14                	je     800179 <_main+0x141>
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	68 40 3e 80 00       	push   $0x803e40
  80016d:	6a 36                	push   $0x36
  80016f:	68 5c 3e 80 00       	push   $0x803e5c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 9c 3e 80 00       	push   $0x803e9c
  800184:	e8 1e 0f 00 00       	call   8010a7 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80018c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800193:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
	int numOfEmptyWSLocs = 0;
  80019a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a8:	eb 26                	jmp    8001d0 <_main+0x198>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8001aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e0 03             	shl    $0x3,%eax
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	8a 40 04             	mov    0x4(%eax),%al
  8001c6:	3c 01                	cmp    $0x1,%al
  8001c8:	75 03                	jne    8001cd <_main+0x195>
			numOfEmptyWSLocs++;
  8001ca:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001cd:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 50 74             	mov    0x74(%eax),%edx
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 cb                	ja     8001aa <_main+0x172>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001e5:	7d 14                	jge    8001fb <_main+0x1c3>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 e8 3e 80 00       	push   $0x803ee8
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 5c 3e 80 00       	push   $0x803e5c
  8001f6:	e8 f8 0b 00 00       	call   800df3 <_panic>

	void* ptr_allocations[512] = {0};
  8001fb:	8d 95 b8 f7 ff ff    	lea    -0x848(%ebp),%edx
  800201:	b9 00 02 00 00       	mov    $0x200,%ecx
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 47 22 00 00       	call   80245b <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 df 22 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	for(i = 0; i< 256;i++)
  80021f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800226:	eb 20                	jmp    800248 <_main+0x210>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	e8 c1 1d 00 00       	call   801ff7 <malloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 c2                	mov    %eax,%edx
  80023b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023e:	89 94 85 b8 f7 ff ff 	mov    %edx,-0x848(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800245:	ff 45 dc             	incl   -0x24(%ebp)
  800248:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80024f:	7e d7                	jle    800228 <_main+0x1f0>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800251:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800257:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80025c:	75 4e                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80025e:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800264:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800269:	75 41                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026b:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800271:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800276:	75 34                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800278:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80027e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800283:	75 27                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800285:	8b 85 10 fa ff ff    	mov    -0x5f0(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  80028b:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  800290:	75 1a                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800292:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800298:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  80029d:	75 0d                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029f:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  8002a5:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 38 3f 80 00       	push   $0x803f38
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 5c 3e 80 00       	push   $0x803e5c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 36 22 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	c1 e0 09             	shl    $0x9,%eax
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	79 05                	jns    8002d9 <_main+0x2a1>
  8002d4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d9:	c1 f8 0c             	sar    $0xc,%eax
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 76 3f 80 00       	push   $0x803f76
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 5c 3e 80 00       	push   $0x803e5c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 5f 21 00 00       	call   80245b <sys_calculate_free_frames>
  8002fc:	29 c3                	sub    %eax,%ebx
  8002fe:	89 da                	mov    %ebx,%edx
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	c1 e0 09             	shl    $0x9,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	79 05                	jns    80030f <_main+0x2d7>
  80030a:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030f:	c1 f8 16             	sar    $0x16,%eax
  800312:	39 c2                	cmp    %eax,%edx
  800314:	74 14                	je     80032a <_main+0x2f2>
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	68 93 3f 80 00       	push   $0x803f93
  80031e:	6a 60                	push   $0x60
  800320:	68 5c 3e 80 00       	push   $0x803e5c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 2c 21 00 00       	call   80245b <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 c4 21 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 39 1d 00 00       	call   802082 <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 27 1d 00 00       	call   802082 <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 15 1d 00 00       	call   802082 <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 03 1d 00 00       	call   802082 <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 f1 1c 00 00       	call   802082 <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 df 1c 00 00       	call   802082 <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 cd 1c 00 00       	call   802082 <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 bb 1c 00 00       	call   802082 <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 a9 1c 00 00       	call   802082 <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 97 1c 00 00       	call   802082 <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 85 1c 00 00       	call   802082 <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 73 1c 00 00       	call   802082 <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 61 1c 00 00       	call   802082 <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 4f 1c 00 00       	call   802082 <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 3d 1c 00 00       	call   802082 <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 ae 20 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  80044d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 05                	jns    800471 <_main+0x439>
  80046c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800471:	c1 f8 0c             	sar    $0xc,%eax
  800474:	39 c1                	cmp    %eax,%ecx
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 a4 3f 80 00       	push   $0x803fa4
  800480:	6a 76                	push   $0x76
  800482:	68 5c 3e 80 00       	push   $0x803e5c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 ca 1f 00 00       	call   80245b <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 e0 3f 80 00       	push   $0x803fe0
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 5c 3e 80 00       	push   $0x803e5c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 a8 1f 00 00       	call   80245b <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 40 20 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  8004bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  8004be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	50                   	push   %eax
  8004c5:	e8 2d 1b 00 00       	call   801ff7 <malloc>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  8004d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004d3:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8004d8:	74 14                	je     8004ee <_main+0x4b6>
		panic("Worst Fit not working correctly");
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	68 20 40 80 00       	push   $0x804020
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 5c 3e 80 00       	push   $0x803e5c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 08 20 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  8004f3:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	79 05                	jns    800504 <_main+0x4cc>
  8004ff:	05 ff 0f 00 00       	add    $0xfff,%eax
  800504:	c1 f8 0c             	sar    $0xc,%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	74 17                	je     800522 <_main+0x4ea>
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 76 3f 80 00       	push   $0x803f76
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 5c 3e 80 00       	push   $0x803e5c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 34 1f 00 00       	call   80245b <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 93 3f 80 00       	push   $0x803f93
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 5c 3e 80 00       	push   $0x803e5c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 40 40 80 00       	push   $0x804040
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 f9 1e 00 00       	call   80245b <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 91 1f 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  80056a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 7b 1a 00 00       	call   801ff7 <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800582:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800585:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80058a:	74 17                	je     8005a3 <_main+0x56b>
		panic("Worst Fit not working correctly");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 20 40 80 00       	push   $0x804020
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 5c 3e 80 00       	push   $0x803e5c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 53 1f 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  8005a8:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b0:	c1 e0 02             	shl    $0x2,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	79 05                	jns    8005bc <_main+0x584>
  8005b7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005bc:	c1 f8 0c             	sar    $0xc,%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 17                	je     8005da <_main+0x5a2>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 76 3f 80 00       	push   $0x803f76
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 5c 3e 80 00       	push   $0x803e5c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 7c 1e 00 00       	call   80245b <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 93 3f 80 00       	push   $0x803f93
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 5c 3e 80 00       	push   $0x803e5c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 40 40 80 00       	push   $0x804040
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 41 1e 00 00       	call   80245b <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 d9 1e 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800622:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	50                   	push   %eax
  800634:	e8 be 19 00 00       	call   801ff7 <malloc>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99000000)
  80063f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800642:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800647:	74 17                	je     800660 <_main+0x628>
		panic("Worst Fit not working correctly");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 20 40 80 00       	push   $0x804020
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 5c 3e 80 00       	push   $0x803e5c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 96 1e 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800665:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	85 c0                	test   %eax,%eax
  800677:	79 05                	jns    80067e <_main+0x646>
  800679:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067e:	c1 f8 0c             	sar    $0xc,%eax
  800681:	39 c1                	cmp    %eax,%ecx
  800683:	74 17                	je     80069c <_main+0x664>
  800685:	83 ec 04             	sub    $0x4,%esp
  800688:	68 76 3f 80 00       	push   $0x803f76
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 5c 3e 80 00       	push   $0x803e5c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 ba 1d 00 00       	call   80245b <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 93 3f 80 00       	push   $0x803f93
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 5c 3e 80 00       	push   $0x803e5c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 40 40 80 00       	push   $0x804040
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 7f 1d 00 00       	call   80245b <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 17 1e 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  8006e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	50                   	push   %eax
  8006f5:	e8 fd 18 00 00       	call   801ff7 <malloc>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800703:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
		panic("Worst Fit not working correctly");
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 20 40 80 00       	push   $0x804020
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 5c 3e 80 00       	push   $0x803e5c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 d5 1d 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800726:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800729:	89 c1                	mov    %eax,%ecx
  80072b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	c1 e0 02             	shl    $0x2,%eax
  800733:	01 d0                	add    %edx,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 76 3f 80 00       	push   $0x803f76
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 5c 3e 80 00       	push   $0x803e5c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 fa 1c 00 00       	call   80245b <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 93 3f 80 00       	push   $0x803f93
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 5c 3e 80 00       	push   $0x803e5c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 40 40 80 00       	push   $0x804040
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 bf 1c 00 00       	call   80245b <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 57 1d 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  8007a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  8007a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007aa:	c1 e0 02             	shl    $0x2,%eax
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	50                   	push   %eax
  8007b1:	e8 41 18 00 00       	call   801ff7 <malloc>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8007bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007bf:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8007c4:	74 17                	je     8007dd <_main+0x7a5>
		panic("Worst Fit not working correctly");
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 20 40 80 00       	push   $0x804020
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 5c 3e 80 00       	push   $0x803e5c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 19 1d 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	79 05                	jns    8007f6 <_main+0x7be>
  8007f1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f6:	c1 f8 0c             	sar    $0xc,%eax
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	74 17                	je     800814 <_main+0x7dc>
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	68 76 3f 80 00       	push   $0x803f76
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 5c 3e 80 00       	push   $0x803e5c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 42 1c 00 00       	call   80245b <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 93 3f 80 00       	push   $0x803f93
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 5c 3e 80 00       	push   $0x803e5c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 40 40 80 00       	push   $0x804040
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 07 1c 00 00       	call   80245b <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 9f 1c 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  80085c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  80085f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	50                   	push   %eax
  800868:	e8 8a 17 00 00       	call   801ff7 <malloc>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80400000)
  800873:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800876:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
		panic("Worst Fit not working correctly");
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 20 40 80 00       	push   $0x804020
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 5c 3e 80 00       	push   $0x803e5c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 62 1c 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800899:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	79 05                	jns    8008ac <_main+0x874>
  8008a7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008ac:	c1 f8 0c             	sar    $0xc,%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	74 17                	je     8008ca <_main+0x892>
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 76 3f 80 00       	push   $0x803f76
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 5c 3e 80 00       	push   $0x803e5c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 8c 1b 00 00       	call   80245b <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 93 3f 80 00       	push   $0x803f93
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 5c 3e 80 00       	push   $0x803e5c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 40 40 80 00       	push   $0x804040
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 51 1b 00 00       	call   80245b <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 e9 1b 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800912:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  800915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800918:	c1 e0 09             	shl    $0x9,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 cc 16 00 00       	call   801ff7 <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800931:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800934:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800939:	74 17                	je     800952 <_main+0x91a>
		panic("Worst Fit not working correctly");
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 20 40 80 00       	push   $0x804020
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 5c 3e 80 00       	push   $0x803e5c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 a4 1b 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800957:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80095f:	c1 e0 09             	shl    $0x9,%eax
  800962:	89 c1                	mov    %eax,%ecx
  800964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	85 c0                	test   %eax,%eax
  80096b:	79 05                	jns    800972 <_main+0x93a>
  80096d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800972:	c1 f8 0c             	sar    $0xc,%eax
  800975:	39 c2                	cmp    %eax,%edx
  800977:	74 17                	je     800990 <_main+0x958>
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	68 76 3f 80 00       	push   $0x803f76
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 5c 3e 80 00       	push   $0x803e5c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 c6 1a 00 00       	call   80245b <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 93 3f 80 00       	push   $0x803f93
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 5c 3e 80 00       	push   $0x803e5c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 40 40 80 00       	push   $0x804040
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 8b 1a 00 00       	call   80245b <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 23 1b 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8009db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009de:	c1 e0 09             	shl    $0x9,%eax
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	50                   	push   %eax
  8009e5:	e8 0d 16 00 00       	call   801ff7 <malloc>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8009f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009f3:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8009f8:	74 17                	je     800a11 <_main+0x9d9>
		panic("Worst Fit not working correctly");
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 20 40 80 00       	push   $0x804020
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 5c 3e 80 00       	push   $0x803e5c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 e5 1a 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800a16:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1e:	c1 e0 09             	shl    $0x9,%eax
  800a21:	85 c0                	test   %eax,%eax
  800a23:	79 05                	jns    800a2a <_main+0x9f2>
  800a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a2a:	c1 f8 0c             	sar    $0xc,%eax
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 17                	je     800a48 <_main+0xa10>
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 76 3f 80 00       	push   $0x803f76
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 5c 3e 80 00       	push   $0x803e5c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 0e 1a 00 00       	call   80245b <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 93 3f 80 00       	push   $0x803f93
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 5c 3e 80 00       	push   $0x803e5c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 40 40 80 00       	push   $0x804040
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 d3 19 00 00       	call   80245b <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 6b 1a 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800a90:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  800a93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 58 15 00 00       	call   801ff7 <malloc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800aa8:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800aad:	74 17                	je     800ac6 <_main+0xa8e>
		panic("Worst Fit not working correctly");
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 20 40 80 00       	push   $0x804020
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 5c 3e 80 00       	push   $0x803e5c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 30 1a 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800acb:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	79 05                	jns    800adf <_main+0xaa7>
  800ada:	05 ff 0f 00 00       	add    $0xfff,%eax
  800adf:	c1 f8 0c             	sar    $0xc,%eax
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 17                	je     800afd <_main+0xac5>
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	68 76 3f 80 00       	push   $0x803f76
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 5c 3e 80 00       	push   $0x803e5c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 59 19 00 00       	call   80245b <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 93 3f 80 00       	push   $0x803f93
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 5c 3e 80 00       	push   $0x803e5c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 40 40 80 00       	push   $0x804040
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 1e 19 00 00       	call   80245b <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 b6 19 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b52:	29 d0                	sub    %edx,%eax
  800b54:	01 c0                	add    %eax,%eax
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	e8 98 14 00 00       	call   801ff7 <malloc>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b68:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800b6d:	74 17                	je     800b86 <_main+0xb4e>
		panic("Worst Fit not working correctly");
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	68 20 40 80 00       	push   $0x804020
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 5c 3e 80 00       	push   $0x803e5c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 70 19 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800b8b:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	29 c8                	sub    %ecx,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	79 05                	jns    800ba7 <_main+0xb6f>
  800ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ba7:	c1 f8 0c             	sar    $0xc,%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 76 3f 80 00       	push   $0x803f76
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 5c 3e 80 00       	push   $0x803e5c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 91 18 00 00       	call   80245b <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 93 3f 80 00       	push   $0x803f93
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 5c 3e 80 00       	push   $0x803e5c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 40 40 80 00       	push   $0x804040
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 56 18 00 00       	call   80245b <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 ee 18 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	e8 d8 13 00 00       	call   801ff7 <malloc>
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x0)
  800c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
		panic("Worst Fit not working correctly");
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 20 40 80 00       	push   $0x804020
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 5c 3e 80 00       	push   $0x803e5c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 b3 18 00 00       	call   8024fb <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 76 3f 80 00       	push   $0x803f76
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 5c 3e 80 00       	push   $0x803e5c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 f2 17 00 00       	call   80245b <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 93 3f 80 00       	push   $0x803f93
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 5c 3e 80 00       	push   $0x803e5c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 40 40 80 00       	push   $0x804040
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 54 40 80 00       	push   $0x804054
  800ca7:	e8 fb 03 00 00       	call   8010a7 <cprintf>
  800cac:	83 c4 10             	add    $0x10,%esp

	return;
  800caf:	90                   	nop
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800cbd:	e8 79 1a 00 00       	call   80273b <sys_getenvindex>
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	c1 e0 03             	shl    $0x3,%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	c1 e0 04             	shl    $0x4,%eax
  800cdf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ce4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ce9:	a1 20 50 80 00       	mov    0x805020,%eax
  800cee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 0f                	je     800d07 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800cf8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cfd:	05 5c 05 00 00       	add    $0x55c,%eax
  800d02:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0b:	7e 0a                	jle    800d17 <libmain+0x60>
		binaryname = argv[0];
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 13 f3 ff ff       	call   800038 <_main>
  800d25:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800d28:	e8 1b 18 00 00       	call   802548 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 a8 40 80 00       	push   $0x8040a8
  800d35:	e8 6d 03 00 00       	call   8010a7 <cprintf>
  800d3a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800d48:	a1 20 50 80 00       	mov    0x805020,%eax
  800d4d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	52                   	push   %edx
  800d57:	50                   	push   %eax
  800d58:	68 d0 40 80 00       	push   $0x8040d0
  800d5d:	e8 45 03 00 00       	call   8010a7 <cprintf>
  800d62:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800d65:	a1 20 50 80 00       	mov    0x805020,%eax
  800d6a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800d70:	a1 20 50 80 00       	mov    0x805020,%eax
  800d75:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800d7b:	a1 20 50 80 00       	mov    0x805020,%eax
  800d80:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800d86:	51                   	push   %ecx
  800d87:	52                   	push   %edx
  800d88:	50                   	push   %eax
  800d89:	68 f8 40 80 00       	push   $0x8040f8
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 50 41 80 00       	push   $0x804150
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 a8 40 80 00       	push   $0x8040a8
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 9b 17 00 00       	call   802562 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800dc7:	e8 19 00 00 00       	call   800de5 <exit>
}
  800dcc:	90                   	nop
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	6a 00                	push   $0x0
  800dda:	e8 28 19 00 00       	call   802707 <sys_destroy_env>
  800ddf:	83 c4 10             	add    $0x10,%esp
}
  800de2:	90                   	nop
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <exit>:

void
exit(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800deb:	e8 7d 19 00 00       	call   80276d <sys_exit_env>
}
  800df0:	90                   	nop
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e02:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e07:	85 c0                	test   %eax,%eax
  800e09:	74 16                	je     800e21 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800e0b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	50                   	push   %eax
  800e14:	68 64 41 80 00       	push   $0x804164
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 69 41 80 00       	push   $0x804169
  800e32:	e8 70 02 00 00       	call   8010a7 <cprintf>
  800e37:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 f4             	pushl  -0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	e8 f3 01 00 00       	call   80103c <vcprintf>
  800e49:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	6a 00                	push   $0x0
  800e51:	68 85 41 80 00       	push   $0x804185
  800e56:	e8 e1 01 00 00       	call   80103c <vcprintf>
  800e5b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800e5e:	e8 82 ff ff ff       	call   800de5 <exit>

	// should not return here
	while (1) ;
  800e63:	eb fe                	jmp    800e63 <_panic+0x70>

00800e65 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800e6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800e70:	8b 50 74             	mov    0x74(%eax),%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	39 c2                	cmp    %eax,%edx
  800e78:	74 14                	je     800e8e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 88 41 80 00       	push   $0x804188
  800e82:	6a 26                	push   $0x26
  800e84:	68 d4 41 80 00       	push   $0x8041d4
  800e89:	e8 65 ff ff ff       	call   800df3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9c:	e9 c2 00 00 00       	jmp    800f63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 08                	jne    800ebe <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800eb6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800eb9:	e9 a2 00 00 00       	jmp    800f60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ebe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ecc:	eb 69                	jmp    800f37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ece:	a1 20 50 80 00       	mov    0x805020,%eax
  800ed3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ed9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800edc:	89 d0                	mov    %edx,%eax
  800ede:	01 c0                	add    %eax,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	c1 e0 03             	shl    $0x3,%eax
  800ee5:	01 c8                	add    %ecx,%eax
  800ee7:	8a 40 04             	mov    0x4(%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 46                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800eee:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ef9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	01 c0                	add    %eax,%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	c1 e0 03             	shl    $0x3,%eax
  800f05:	01 c8                	add    %ecx,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f27:	39 c2                	cmp    %eax,%edx
  800f29:	75 09                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800f2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800f32:	eb 12                	jmp    800f46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
  800f37:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3c:	8b 50 74             	mov    0x74(%eax),%edx
  800f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f42:	39 c2                	cmp    %eax,%edx
  800f44:	77 88                	ja     800ece <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4a:	75 14                	jne    800f60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 e0 41 80 00       	push   $0x8041e0
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 d4 41 80 00       	push   $0x8041d4
  800f5b:	e8 93 fe ff ff       	call   800df3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800f60:	ff 45 f0             	incl   -0x10(%ebp)
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f69:	0f 8c 32 ff ff ff    	jl     800ea1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800f6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800f7d:	eb 26                	jmp    800fa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800f7f:	a1 20 50 80 00       	mov    0x805020,%eax
  800f84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f8d:	89 d0                	mov    %edx,%eax
  800f8f:	01 c0                	add    %eax,%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	c1 e0 03             	shl    $0x3,%eax
  800f96:	01 c8                	add    %ecx,%eax
  800f98:	8a 40 04             	mov    0x4(%eax),%al
  800f9b:	3c 01                	cmp    $0x1,%al
  800f9d:	75 03                	jne    800fa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800f9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fa2:	ff 45 e0             	incl   -0x20(%ebp)
  800fa5:	a1 20 50 80 00       	mov    0x805020,%eax
  800faa:	8b 50 74             	mov    0x74(%eax),%edx
  800fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb0:	39 c2                	cmp    %eax,%edx
  800fb2:	77 cb                	ja     800f7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800fba:	74 14                	je     800fd0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	68 34 42 80 00       	push   $0x804234
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 d4 41 80 00       	push   $0x8041d4
  800fcb:	e8 23 fe ff ff       	call   800df3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800fd0:	90                   	nop
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	89 0a                	mov    %ecx,(%edx)
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	88 d1                	mov    %dl,%cl
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ffc:	75 2c                	jne    80102a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ffe:	a0 24 50 80 00       	mov    0x805024,%al
  801003:	0f b6 c0             	movzbl %al,%eax
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	8b 12                	mov    (%edx),%edx
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	50                   	push   %eax
  801017:	51                   	push   %ecx
  801018:	52                   	push   %edx
  801019:	e8 7c 13 00 00       	call   80239a <sys_cputs>
  80101e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	8b 40 04             	mov    0x4(%eax),%eax
  801030:	8d 50 01             	lea    0x1(%eax),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 50 04             	mov    %edx,0x4(%eax)
}
  801039:	90                   	nop
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801045:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80104c:	00 00 00 
	b.cnt = 0;
  80104f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801056:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	68 d3 0f 80 00       	push   $0x800fd3
  80106b:	e8 11 02 00 00       	call   801281 <vprintfmt>
  801070:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801073:	a0 24 50 80 00       	mov    0x805024,%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	50                   	push   %eax
  801085:	52                   	push   %edx
  801086:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108c:	83 c0 08             	add    $0x8,%eax
  80108f:	50                   	push   %eax
  801090:	e8 05 13 00 00       	call   80239a <sys_cputs>
  801095:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801098:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80109f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8010ad:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8010b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	e8 73 ff ff ff       	call   80103c <vcprintf>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010da:	e8 69 14 00 00       	call   802548 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 48 ff ff ff       	call   80103c <vcprintf>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8010fa:	e8 63 14 00 00       	call   802562 <sys_enable_interrupt>
	return cnt;
  8010ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 14             	sub    $0x14,%esp
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801117:	8b 45 18             	mov    0x18(%ebp),%eax
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801122:	77 55                	ja     801179 <printnum+0x75>
  801124:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801127:	72 05                	jb     80112e <printnum+0x2a>
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	77 4b                	ja     801179 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80112e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801131:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801134:	8b 45 18             	mov    0x18(%ebp),%eax
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	52                   	push   %edx
  80113d:	50                   	push   %eax
  80113e:	ff 75 f4             	pushl  -0xc(%ebp)
  801141:	ff 75 f0             	pushl  -0x10(%ebp)
  801144:	e8 7f 2a 00 00       	call   803bc8 <__udivdi3>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	ff 75 20             	pushl  0x20(%ebp)
  801152:	53                   	push   %ebx
  801153:	ff 75 18             	pushl  0x18(%ebp)
  801156:	52                   	push   %edx
  801157:	50                   	push   %eax
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	ff 75 08             	pushl  0x8(%ebp)
  80115e:	e8 a1 ff ff ff       	call   801104 <printnum>
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	eb 1a                	jmp    801182 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 20             	pushl  0x20(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	ff d0                	call   *%eax
  801176:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801179:	ff 4d 1c             	decl   0x1c(%ebp)
  80117c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801180:	7f e6                	jg     801168 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801182:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	53                   	push   %ebx
  801191:	51                   	push   %ecx
  801192:	52                   	push   %edx
  801193:	50                   	push   %eax
  801194:	e8 3f 2b 00 00       	call   803cd8 <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 94 44 80 00       	add    $0x804494,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	50                   	push   %eax
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
}
  8011b5:	90                   	nop
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011c2:	7e 1c                	jle    8011e0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 50 08             	lea    0x8(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 10                	mov    %edx,(%eax)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 e8 08             	sub    $0x8,%eax
  8011d9:	8b 50 04             	mov    0x4(%eax),%edx
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	eb 40                	jmp    801220 <getuint+0x65>
	else if (lflag)
  8011e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e4:	74 1e                	je     801204 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 50 04             	lea    0x4(%eax),%edx
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 10                	mov    %edx,(%eax)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	83 e8 04             	sub    $0x4,%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801202:	eb 1c                	jmp    801220 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8b 00                	mov    (%eax),%eax
  801209:	8d 50 04             	lea    0x4(%eax),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 10                	mov    %edx,(%eax)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 e8 04             	sub    $0x4,%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801225:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801229:	7e 1c                	jle    801247 <getint+0x25>
		return va_arg(*ap, long long);
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 50 08             	lea    0x8(%eax),%edx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	89 10                	mov    %edx,(%eax)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	83 e8 08             	sub    $0x8,%eax
  801240:	8b 50 04             	mov    0x4(%eax),%edx
  801243:	8b 00                	mov    (%eax),%eax
  801245:	eb 38                	jmp    80127f <getint+0x5d>
	else if (lflag)
  801247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124b:	74 1a                	je     801267 <getint+0x45>
		return va_arg(*ap, long);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 50 04             	lea    0x4(%eax),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 10                	mov    %edx,(%eax)
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	83 e8 04             	sub    $0x4,%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	99                   	cltd   
  801265:	eb 18                	jmp    80127f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8b 00                	mov    (%eax),%eax
  80126c:	8d 50 04             	lea    0x4(%eax),%edx
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	89 10                	mov    %edx,(%eax)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 00                	mov    (%eax),%eax
  801279:	83 e8 04             	sub    $0x4,%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	99                   	cltd   
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801289:	eb 17                	jmp    8012a2 <vprintfmt+0x21>
			if (ch == '\0')
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	0f 84 af 03 00 00    	je     801642 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	53                   	push   %ebx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	ff d0                	call   *%eax
  80129f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	8d 50 01             	lea    0x1(%eax),%edx
  8012a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d8             	movzbl %al,%ebx
  8012b0:	83 fb 25             	cmp    $0x25,%ebx
  8012b3:	75 d6                	jne    80128b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8012b5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8012b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8012c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8012ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f b6 d8             	movzbl %al,%ebx
  8012e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8012e6:	83 f8 55             	cmp    $0x55,%eax
  8012e9:	0f 87 2b 03 00 00    	ja     80161a <vprintfmt+0x399>
  8012ef:	8b 04 85 b8 44 80 00 	mov    0x8044b8(,%eax,4),%eax
  8012f6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8012f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8012fc:	eb d7                	jmp    8012d5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801302:	eb d1                	jmp    8012d5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801304:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80130b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80130e:	89 d0                	mov    %edx,%eax
  801310:	c1 e0 02             	shl    $0x2,%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	01 c0                	add    %eax,%eax
  801317:	01 d8                	add    %ebx,%eax
  801319:	83 e8 30             	sub    $0x30,%eax
  80131c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801327:	83 fb 2f             	cmp    $0x2f,%ebx
  80132a:	7e 3e                	jle    80136a <vprintfmt+0xe9>
  80132c:	83 fb 39             	cmp    $0x39,%ebx
  80132f:	7f 39                	jg     80136a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801331:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801334:	eb d5                	jmp    80130b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801336:	8b 45 14             	mov    0x14(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 14             	mov    %eax,0x14(%ebp)
  80133f:	8b 45 14             	mov    0x14(%ebp),%eax
  801342:	83 e8 04             	sub    $0x4,%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80134a:	eb 1f                	jmp    80136b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80134c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801350:	79 83                	jns    8012d5 <vprintfmt+0x54>
				width = 0;
  801352:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801359:	e9 77 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80135e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801365:	e9 6b ff ff ff       	jmp    8012d5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80136a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80136b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136f:	0f 89 60 ff ff ff    	jns    8012d5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801382:	e9 4e ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801387:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80138a:	e9 46 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80138f:	8b 45 14             	mov    0x14(%ebp),%eax
  801392:	83 c0 04             	add    $0x4,%eax
  801395:	89 45 14             	mov    %eax,0x14(%ebp)
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	83 e8 04             	sub    $0x4,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	ff d0                	call   *%eax
  8013ac:	83 c4 10             	add    $0x10,%esp
			break;
  8013af:	e9 89 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	83 c0 04             	add    $0x4,%eax
  8013ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	83 e8 04             	sub    $0x4,%eax
  8013c3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8013c5:	85 db                	test   %ebx,%ebx
  8013c7:	79 02                	jns    8013cb <vprintfmt+0x14a>
				err = -err;
  8013c9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8013cb:	83 fb 64             	cmp    $0x64,%ebx
  8013ce:	7f 0b                	jg     8013db <vprintfmt+0x15a>
  8013d0:	8b 34 9d 00 43 80 00 	mov    0x804300(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 a5 44 80 00       	push   $0x8044a5
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 5e 02 00 00       	call   80164a <printfmt>
  8013ec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8013ef:	e9 49 02 00 00       	jmp    80163d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8013f4:	56                   	push   %esi
  8013f5:	68 ae 44 80 00       	push   $0x8044ae
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 45 02 00 00       	call   80164a <printfmt>
  801405:	83 c4 10             	add    $0x10,%esp
			break;
  801408:	e9 30 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	83 c0 04             	add    $0x4,%eax
  801413:	89 45 14             	mov    %eax,0x14(%ebp)
  801416:	8b 45 14             	mov    0x14(%ebp),%eax
  801419:	83 e8 04             	sub    $0x4,%eax
  80141c:	8b 30                	mov    (%eax),%esi
  80141e:	85 f6                	test   %esi,%esi
  801420:	75 05                	jne    801427 <vprintfmt+0x1a6>
				p = "(null)";
  801422:	be b1 44 80 00       	mov    $0x8044b1,%esi
			if (width > 0 && padc != '-')
  801427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80142b:	7e 6d                	jle    80149a <vprintfmt+0x219>
  80142d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801431:	74 67                	je     80149a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	50                   	push   %eax
  80143a:	56                   	push   %esi
  80143b:	e8 0c 03 00 00       	call   80174c <strnlen>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801446:	eb 16                	jmp    80145e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801448:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80145b:	ff 4d e4             	decl   -0x1c(%ebp)
  80145e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801462:	7f e4                	jg     801448 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801464:	eb 34                	jmp    80149a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801466:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80146a:	74 1c                	je     801488 <vprintfmt+0x207>
  80146c:	83 fb 1f             	cmp    $0x1f,%ebx
  80146f:	7e 05                	jle    801476 <vprintfmt+0x1f5>
  801471:	83 fb 7e             	cmp    $0x7e,%ebx
  801474:	7e 12                	jle    801488 <vprintfmt+0x207>
					putch('?', putdat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	6a 3f                	push   $0x3f
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	ff d0                	call   *%eax
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb 0f                	jmp    801497 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	53                   	push   %ebx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	ff d0                	call   *%eax
  801494:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801497:	ff 4d e4             	decl   -0x1c(%ebp)
  80149a:	89 f0                	mov    %esi,%eax
  80149c:	8d 70 01             	lea    0x1(%eax),%esi
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be d8             	movsbl %al,%ebx
  8014a4:	85 db                	test   %ebx,%ebx
  8014a6:	74 24                	je     8014cc <vprintfmt+0x24b>
  8014a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ac:	78 b8                	js     801466 <vprintfmt+0x1e5>
  8014ae:	ff 4d e0             	decl   -0x20(%ebp)
  8014b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b5:	79 af                	jns    801466 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014b7:	eb 13                	jmp    8014cc <vprintfmt+0x24b>
				putch(' ', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 20                	push   $0x20
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8014cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d0:	7f e7                	jg     8014b9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8014d2:	e9 66 01 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 e8             	pushl  -0x18(%ebp)
  8014dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	e8 3c fd ff ff       	call   801222 <getint>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	79 23                	jns    80151c <vprintfmt+0x29b>
				putch('-', putdat);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	6a 2d                	push   $0x2d
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	ff d0                	call   *%eax
  801506:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150f:	f7 d8                	neg    %eax
  801511:	83 d2 00             	adc    $0x0,%edx
  801514:	f7 da                	neg    %edx
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80151c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801523:	e9 bc 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	8d 45 14             	lea    0x14(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	e8 84 fc ff ff       	call   8011bb <getuint>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801540:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801547:	e9 98 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	6a 58                	push   $0x58
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	6a 58                	push   $0x58
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	ff d0                	call   *%eax
  801569:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	6a 58                	push   $0x58
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	ff d0                	call   *%eax
  801579:	83 c4 10             	add    $0x10,%esp
			break;
  80157c:	e9 bc 00 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	6a 30                	push   $0x30
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	ff d0                	call   *%eax
  80158e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	6a 78                	push   $0x78
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	ff d0                	call   *%eax
  80159e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8015a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a4:	83 c0 04             	add    $0x4,%eax
  8015a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	83 e8 04             	sub    $0x4,%eax
  8015b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8015bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8015c3:	eb 1f                	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	e8 e7 fb ff ff       	call   8011bb <getuint>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8015dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	52                   	push   %edx
  8015ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	e8 00 fb ff ff       	call   801104 <printnum>
  801604:	83 c4 20             	add    $0x20,%esp
			break;
  801607:	eb 34                	jmp    80163d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	53                   	push   %ebx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
			break;
  801618:	eb 23                	jmp    80163d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 25                	push   $0x25
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162a:	ff 4d 10             	decl   0x10(%ebp)
  80162d:	eb 03                	jmp    801632 <vprintfmt+0x3b1>
  80162f:	ff 4d 10             	decl   0x10(%ebp)
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	48                   	dec    %eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 25                	cmp    $0x25,%al
  80163a:	75 f3                	jne    80162f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80163c:	90                   	nop
		}
	}
  80163d:	e9 47 fc ff ff       	jmp    801289 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801642:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801643:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801650:	8d 45 10             	lea    0x10(%ebp),%eax
  801653:	83 c0 04             	add    $0x4,%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	ff 75 f4             	pushl  -0xc(%ebp)
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	e8 16 fc ff ff       	call   801281 <vprintfmt>
  80166b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	8d 50 01             	lea    0x1(%eax),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	8b 10                	mov    (%eax),%edx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	8b 40 04             	mov    0x4(%eax),%eax
  80168e:	39 c2                	cmp    %eax,%edx
  801690:	73 12                	jae    8016a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a2:	88 10                	mov    %dl,(%eax)
}
  8016a4:	90                   	nop
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8016c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cc:	74 06                	je     8016d4 <vsnprintf+0x2d>
  8016ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d2:	7f 07                	jg     8016db <vsnprintf+0x34>
		return -E_INVAL;
  8016d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d9:	eb 20                	jmp    8016fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8016db:	ff 75 14             	pushl  0x14(%ebp)
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	68 71 16 80 00       	push   $0x801671
  8016ea:	e8 92 fb ff ff       	call   801281 <vprintfmt>
  8016ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8016f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801703:	8d 45 10             	lea    0x10(%ebp),%eax
  801706:	83 c0 04             	add    $0x4,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 89 ff ff ff       	call   8016a7 <vsnprintf>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80172f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801736:	eb 06                	jmp    80173e <strlen+0x15>
		n++;
  801738:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	75 f1                	jne    801738 <strlen+0xf>
		n++;
	return n;
  801747:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801759:	eb 09                	jmp    801764 <strnlen+0x18>
		n++;
  80175b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80175e:	ff 45 08             	incl   0x8(%ebp)
  801761:	ff 4d 0c             	decl   0xc(%ebp)
  801764:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801768:	74 09                	je     801773 <strnlen+0x27>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	75 e8                	jne    80175b <strnlen+0xf>
		n++;
	return n;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801784:	90                   	nop
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8d 50 01             	lea    0x1(%eax),%edx
  80178b:	89 55 08             	mov    %edx,0x8(%ebp)
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8d 4a 01             	lea    0x1(%edx),%ecx
  801794:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801797:	8a 12                	mov    (%edx),%dl
  801799:	88 10                	mov    %dl,(%eax)
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	84 c0                	test   %al,%al
  80179f:	75 e4                	jne    801785 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8017a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b9:	eb 1f                	jmp    8017da <strncpy+0x34>
		*dst++ = *src;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8d 50 01             	lea    0x1(%eax),%edx
  8017c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8a 12                	mov    (%edx),%dl
  8017c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	84 c0                	test   %al,%al
  8017d2:	74 03                	je     8017d7 <strncpy+0x31>
			src++;
  8017d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017d7:	ff 45 fc             	incl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017e0:	72 d9                	jb     8017bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8017f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f7:	74 30                	je     801829 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8017f9:	eb 16                	jmp    801811 <strlcpy+0x2a>
			*dst++ = *src++;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8d 50 01             	lea    0x1(%eax),%edx
  801801:	89 55 08             	mov    %edx,0x8(%ebp)
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80180d:	8a 12                	mov    (%edx),%dl
  80180f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801811:	ff 4d 10             	decl   0x10(%ebp)
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	74 09                	je     801823 <strlcpy+0x3c>
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	84 c0                	test   %al,%al
  801821:	75 d8                	jne    8017fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182f:	29 c2                	sub    %eax,%edx
  801831:	89 d0                	mov    %edx,%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801838:	eb 06                	jmp    801840 <strcmp+0xb>
		p++, q++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
  80183d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	84 c0                	test   %al,%al
  801847:	74 0e                	je     801857 <strcmp+0x22>
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	38 c2                	cmp    %al,%dl
  801855:	74 e3                	je     80183a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	0f b6 d0             	movzbl %al,%edx
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	0f b6 c0             	movzbl %al,%eax
  801867:	29 c2                	sub    %eax,%edx
  801869:	89 d0                	mov    %edx,%eax
}
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801870:	eb 09                	jmp    80187b <strncmp+0xe>
		n--, p++, q++;
  801872:	ff 4d 10             	decl   0x10(%ebp)
  801875:	ff 45 08             	incl   0x8(%ebp)
  801878:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80187b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187f:	74 17                	je     801898 <strncmp+0x2b>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	74 0e                	je     801898 <strncmp+0x2b>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 10                	mov    (%eax),%dl
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	8a 00                	mov    (%eax),%al
  801894:	38 c2                	cmp    %al,%dl
  801896:	74 da                	je     801872 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189c:	75 07                	jne    8018a5 <strncmp+0x38>
		return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	eb 14                	jmp    8018b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	0f b6 d0             	movzbl %al,%edx
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	0f b6 c0             	movzbl %al,%eax
  8018b5:	29 c2                	sub    %eax,%edx
  8018b7:	89 d0                	mov    %edx,%eax
}
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018c7:	eb 12                	jmp    8018db <strchr+0x20>
		if (*s == c)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8018d1:	75 05                	jne    8018d8 <strchr+0x1d>
			return (char *) s;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	eb 11                	jmp    8018e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018d8:	ff 45 08             	incl   0x8(%ebp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	84 c0                	test   %al,%al
  8018e2:	75 e5                	jne    8018c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018f7:	eb 0d                	jmp    801906 <strfind+0x1b>
		if (*s == c)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801901:	74 0e                	je     801911 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801903:	ff 45 08             	incl   0x8(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	84 c0                	test   %al,%al
  80190d:	75 ea                	jne    8018f9 <strfind+0xe>
  80190f:	eb 01                	jmp    801912 <strfind+0x27>
		if (*s == c)
			break;
  801911:	90                   	nop
	return (char *) s;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801929:	eb 0e                	jmp    801939 <memset+0x22>
		*p++ = c;
  80192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192e:	8d 50 01             	lea    0x1(%eax),%edx
  801931:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801939:	ff 4d f8             	decl   -0x8(%ebp)
  80193c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801940:	79 e9                	jns    80192b <memset+0x14>
		*p++ = c;

	return v;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801959:	eb 16                	jmp    801971 <memcpy+0x2a>
		*d++ = *s++;
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8d 50 01             	lea    0x1(%eax),%edx
  801961:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8d 4a 01             	lea    0x1(%edx),%ecx
  80196a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80196d:	8a 12                	mov    (%edx),%dl
  80196f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	8d 50 ff             	lea    -0x1(%eax),%edx
  801977:	89 55 10             	mov    %edx,0x10(%ebp)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 dd                	jne    80195b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80199b:	73 50                	jae    8019ed <memmove+0x6a>
  80199d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019a8:	76 43                	jbe    8019ed <memmove+0x6a>
		s += n;
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8019b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8019b6:	eb 10                	jmp    8019c8 <memmove+0x45>
			*--d = *--s;
  8019b8:	ff 4d f8             	decl   -0x8(%ebp)
  8019bb:	ff 4d fc             	decl   -0x4(%ebp)
  8019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	75 e3                	jne    8019b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019d5:	eb 23                	jmp    8019fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019da:	8d 50 01             	lea    0x1(%eax),%edx
  8019dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019e9:	8a 12                	mov    (%edx),%dl
  8019eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	75 dd                	jne    8019d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801a11:	eb 2a                	jmp    801a3d <memcmp+0x3e>
		if (*s1 != *s2)
  801a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a16:	8a 10                	mov    (%eax),%dl
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	38 c2                	cmp    %al,%dl
  801a1f:	74 16                	je     801a37 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	0f b6 d0             	movzbl %al,%edx
  801a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f b6 c0             	movzbl %al,%eax
  801a31:	29 c2                	sub    %eax,%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	eb 18                	jmp    801a4f <memcmp+0x50>
		s1++, s2++;
  801a37:	ff 45 fc             	incl   -0x4(%ebp)
  801a3a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a43:	89 55 10             	mov    %edx,0x10(%ebp)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	75 c9                	jne    801a13 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a62:	eb 15                	jmp    801a79 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f b6 d0             	movzbl %al,%edx
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	0f b6 c0             	movzbl %al,%eax
  801a72:	39 c2                	cmp    %eax,%edx
  801a74:	74 0d                	je     801a83 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a76:	ff 45 08             	incl   0x8(%ebp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a7f:	72 e3                	jb     801a64 <memfind+0x13>
  801a81:	eb 01                	jmp    801a84 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a83:	90                   	nop
	return (void *) s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9d:	eb 03                	jmp    801aa2 <strtol+0x19>
		s++;
  801a9f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 20                	cmp    $0x20,%al
  801aa9:	74 f4                	je     801a9f <strtol+0x16>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 eb                	je     801a9f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	3c 2b                	cmp    $0x2b,%al
  801abb:	75 05                	jne    801ac2 <strtol+0x39>
		s++;
  801abd:	ff 45 08             	incl   0x8(%ebp)
  801ac0:	eb 13                	jmp    801ad5 <strtol+0x4c>
	else if (*s == '-')
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	3c 2d                	cmp    $0x2d,%al
  801ac9:	75 0a                	jne    801ad5 <strtol+0x4c>
		s++, neg = 1;
  801acb:	ff 45 08             	incl   0x8(%ebp)
  801ace:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad9:	74 06                	je     801ae1 <strtol+0x58>
  801adb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801adf:	75 20                	jne    801b01 <strtol+0x78>
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8a 00                	mov    (%eax),%al
  801ae6:	3c 30                	cmp    $0x30,%al
  801ae8:	75 17                	jne    801b01 <strtol+0x78>
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	40                   	inc    %eax
  801aee:	8a 00                	mov    (%eax),%al
  801af0:	3c 78                	cmp    $0x78,%al
  801af2:	75 0d                	jne    801b01 <strtol+0x78>
		s += 2, base = 16;
  801af4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801af8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801aff:	eb 28                	jmp    801b29 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b05:	75 15                	jne    801b1c <strtol+0x93>
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8a 00                	mov    (%eax),%al
  801b0c:	3c 30                	cmp    $0x30,%al
  801b0e:	75 0c                	jne    801b1c <strtol+0x93>
		s++, base = 8;
  801b10:	ff 45 08             	incl   0x8(%ebp)
  801b13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b1a:	eb 0d                	jmp    801b29 <strtol+0xa0>
	else if (base == 0)
  801b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b20:	75 07                	jne    801b29 <strtol+0xa0>
		base = 10;
  801b22:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	3c 2f                	cmp    $0x2f,%al
  801b30:	7e 19                	jle    801b4b <strtol+0xc2>
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	3c 39                	cmp    $0x39,%al
  801b39:	7f 10                	jg     801b4b <strtol+0xc2>
			dig = *s - '0';
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	0f be c0             	movsbl %al,%eax
  801b43:	83 e8 30             	sub    $0x30,%eax
  801b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b49:	eb 42                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8a 00                	mov    (%eax),%al
  801b50:	3c 60                	cmp    $0x60,%al
  801b52:	7e 19                	jle    801b6d <strtol+0xe4>
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 7a                	cmp    $0x7a,%al
  801b5b:	7f 10                	jg     801b6d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	0f be c0             	movsbl %al,%eax
  801b65:	83 e8 57             	sub    $0x57,%eax
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6b:	eb 20                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	3c 40                	cmp    $0x40,%al
  801b74:	7e 39                	jle    801baf <strtol+0x126>
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8a 00                	mov    (%eax),%al
  801b7b:	3c 5a                	cmp    $0x5a,%al
  801b7d:	7f 30                	jg     801baf <strtol+0x126>
			dig = *s - 'A' + 10;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	0f be c0             	movsbl %al,%eax
  801b87:	83 e8 37             	sub    $0x37,%eax
  801b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b93:	7d 19                	jge    801bae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b95:	ff 45 08             	incl   0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ba9:	e9 7b ff ff ff       	jmp    801b29 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb3:	74 08                	je     801bbd <strtol+0x134>
		*endptr = (char *) s;
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bc1:	74 07                	je     801bca <strtol+0x141>
  801bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc6:	f7 d8                	neg    %eax
  801bc8:	eb 03                	jmp    801bcd <strtol+0x144>
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <ltostr>:

void
ltostr(long value, char *str)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bdc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be7:	79 13                	jns    801bfc <ltostr+0x2d>
	{
		neg = 1;
  801be9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bf6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bf9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c04:	99                   	cltd   
  801c05:	f7 f9                	idiv   %ecx
  801c07:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0d:	8d 50 01             	lea    0x1(%eax),%edx
  801c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c13:	89 c2                	mov    %eax,%edx
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c1d:	83 c2 30             	add    $0x30,%edx
  801c20:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c25:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c2a:	f7 e9                	imul   %ecx
  801c2c:	c1 fa 02             	sar    $0x2,%edx
  801c2f:	89 c8                	mov    %ecx,%eax
  801c31:	c1 f8 1f             	sar    $0x1f,%eax
  801c34:	29 c2                	sub    %eax,%edx
  801c36:	89 d0                	mov    %edx,%eax
  801c38:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c43:	f7 e9                	imul   %ecx
  801c45:	c1 fa 02             	sar    $0x2,%edx
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	c1 f8 1f             	sar    $0x1f,%eax
  801c4d:	29 c2                	sub    %eax,%edx
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	01 c0                	add    %eax,%eax
  801c58:	29 c1                	sub    %eax,%ecx
  801c5a:	89 ca                	mov    %ecx,%edx
  801c5c:	85 d2                	test   %edx,%edx
  801c5e:	75 9c                	jne    801bfc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	48                   	dec    %eax
  801c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c72:	74 3d                	je     801cb1 <ltostr+0xe2>
		start = 1 ;
  801c74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c7b:	eb 34                	jmp    801cb1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	01 d0                	add    %edx,%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	01 c2                	add    %eax,%edx
  801c92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	8a 00                	mov    (%eax),%al
  801c9c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	01 c2                	add    %eax,%edx
  801ca6:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ca9:	88 02                	mov    %al,(%edx)
		start++ ;
  801cab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801cae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cb7:	7c c4                	jl     801c7d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801cb9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 54 fa ff ff       	call   801729 <strlen>
  801cd5:	83 c4 04             	add    $0x4,%esp
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	e8 46 fa ff ff       	call   801729 <strlen>
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cf7:	eb 17                	jmp    801d10 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	01 c2                	add    %eax,%edx
  801d01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	01 c8                	add    %ecx,%eax
  801d09:	8a 00                	mov    (%eax),%al
  801d0b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801d0d:	ff 45 fc             	incl   -0x4(%ebp)
  801d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d16:	7c e1                	jl     801cf9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801d18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801d1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801d26:	eb 1f                	jmp    801d47 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d2b:	8d 50 01             	lea    0x1(%eax),%edx
  801d2e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	01 c2                	add    %eax,%edx
  801d38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d44:	ff 45 f8             	incl   -0x8(%ebp)
  801d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d4d:	7c d9                	jl     801d28 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	c6 00 00             	movb   $0x0,(%eax)
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d75:	8b 45 10             	mov    0x10(%ebp),%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d80:	eb 0c                	jmp    801d8e <strsplit+0x31>
			*string++ = 0;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8a 00                	mov    (%eax),%al
  801d93:	84 c0                	test   %al,%al
  801d95:	74 18                	je     801daf <strsplit+0x52>
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8a 00                	mov    (%eax),%al
  801d9c:	0f be c0             	movsbl %al,%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 13 fb ff ff       	call   8018bb <strchr>
  801da8:	83 c4 08             	add    $0x8,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 d3                	jne    801d82 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8a 00                	mov    (%eax),%al
  801db4:	84 c0                	test   %al,%al
  801db6:	74 5a                	je     801e12 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	83 f8 0f             	cmp    $0xf,%eax
  801dc0:	75 07                	jne    801dc9 <strsplit+0x6c>
		{
			return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	eb 66                	jmp    801e2f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	8d 48 01             	lea    0x1(%eax),%ecx
  801dd1:	8b 55 14             	mov    0x14(%ebp),%edx
  801dd4:	89 0a                	mov    %ecx,(%edx)
  801dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	01 c2                	add    %eax,%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801de7:	eb 03                	jmp    801dec <strsplit+0x8f>
			string++;
  801de9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	8a 00                	mov    (%eax),%al
  801df1:	84 c0                	test   %al,%al
  801df3:	74 8b                	je     801d80 <strsplit+0x23>
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8a 00                	mov    (%eax),%al
  801dfa:	0f be c0             	movsbl %al,%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	e8 b5 fa ff ff       	call   8018bb <strchr>
  801e06:	83 c4 08             	add    $0x8,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 dc                	je     801de9 <strsplit+0x8c>
			string++;
	}
  801e0d:	e9 6e ff ff ff       	jmp    801d80 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801e12:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801e37:	a1 04 50 80 00       	mov    0x805004,%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 1f                	je     801e5f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801e40:	e8 1d 00 00 00       	call   801e62 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 10 46 80 00       	push   $0x804610
  801e4d:	e8 55 f2 ff ff       	call   8010a7 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801e55:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801e5c:	00 00 00 
	}
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801e68:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801e6f:	00 00 00 
  801e72:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801e79:	00 00 00 
  801e7c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801e83:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801e86:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801e8d:	00 00 00 
  801e90:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801e97:	00 00 00 
  801e9a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ea1:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801ea4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801eab:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801eae:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801eb5:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ec4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ec9:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801ece:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801edd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ee2:	83 ec 04             	sub    $0x4,%esp
  801ee5:	6a 06                	push   $0x6
  801ee7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eea:	50                   	push   %eax
  801eeb:	e8 ee 05 00 00       	call   8024de <sys_allocate_chunk>
  801ef0:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ef3:	a1 20 51 80 00       	mov    0x805120,%eax
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	50                   	push   %eax
  801efc:	e8 63 0c 00 00       	call   802b64 <initialize_MemBlocksList>
  801f01:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801f04:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801f09:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f0f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f19:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f27:	89 c2                	mov    %eax,%edx
  801f29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f2c:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f32:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801f39:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f43:	8b 50 08             	mov    0x8(%eax),%edx
  801f46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f49:	01 d0                	add    %edx,%eax
  801f4b:	48                   	dec    %eax
  801f4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f52:	ba 00 00 00 00       	mov    $0x0,%edx
  801f57:	f7 75 e0             	divl   -0x20(%ebp)
  801f5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f5d:	29 d0                	sub    %edx,%eax
  801f5f:	89 c2                	mov    %eax,%edx
  801f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f64:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801f67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f6b:	75 14                	jne    801f81 <initialize_dyn_block_system+0x11f>
  801f6d:	83 ec 04             	sub    $0x4,%esp
  801f70:	68 35 46 80 00       	push   $0x804635
  801f75:	6a 34                	push   $0x34
  801f77:	68 53 46 80 00       	push   $0x804653
  801f7c:	e8 72 ee ff ff       	call   800df3 <_panic>
  801f81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	74 10                	je     801f9a <initialize_dyn_block_system+0x138>
  801f8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f8d:	8b 00                	mov    (%eax),%eax
  801f8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f92:	8b 52 04             	mov    0x4(%edx),%edx
  801f95:	89 50 04             	mov    %edx,0x4(%eax)
  801f98:	eb 0b                	jmp    801fa5 <initialize_dyn_block_system+0x143>
  801f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9d:	8b 40 04             	mov    0x4(%eax),%eax
  801fa0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa8:	8b 40 04             	mov    0x4(%eax),%eax
  801fab:	85 c0                	test   %eax,%eax
  801fad:	74 0f                	je     801fbe <initialize_dyn_block_system+0x15c>
  801faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb2:	8b 40 04             	mov    0x4(%eax),%eax
  801fb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fb8:	8b 12                	mov    (%edx),%edx
  801fba:	89 10                	mov    %edx,(%eax)
  801fbc:	eb 0a                	jmp    801fc8 <initialize_dyn_block_system+0x166>
  801fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fc1:	8b 00                	mov    (%eax),%eax
  801fc3:	a3 48 51 80 00       	mov    %eax,0x805148
  801fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fdb:	a1 54 51 80 00       	mov    0x805154,%eax
  801fe0:	48                   	dec    %eax
  801fe1:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	ff 75 e8             	pushl  -0x18(%ebp)
  801fec:	e8 c4 13 00 00       	call   8033b5 <insert_sorted_with_merge_freeList>
  801ff1:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801ff4:	90                   	nop
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <malloc>:
//=================================



void* malloc(uint32 size)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ffd:	e8 2f fe ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  802002:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802006:	75 07                	jne    80200f <malloc+0x18>
  802008:	b8 00 00 00 00       	mov    $0x0,%eax
  80200d:	eb 71                	jmp    802080 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  80200f:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802016:	76 07                	jbe    80201f <malloc+0x28>
	return NULL;
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
  80201d:	eb 61                	jmp    802080 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80201f:	e8 88 08 00 00       	call   8028ac <sys_isUHeapPlacementStrategyFIRSTFIT>
  802024:	85 c0                	test   %eax,%eax
  802026:	74 53                	je     80207b <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802028:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80202f:	8b 55 08             	mov    0x8(%ebp),%edx
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	01 d0                	add    %edx,%eax
  802037:	48                   	dec    %eax
  802038:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203e:	ba 00 00 00 00       	mov    $0x0,%edx
  802043:	f7 75 f4             	divl   -0xc(%ebp)
  802046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802049:	29 d0                	sub    %edx,%eax
  80204b:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	ff 75 ec             	pushl  -0x14(%ebp)
  802054:	e8 d2 0d 00 00       	call   802e2b <alloc_block_FF>
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  80205f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802063:	74 16                	je     80207b <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	ff 75 e8             	pushl  -0x18(%ebp)
  80206b:	e8 0c 0c 00 00       	call   802c7c <insert_sorted_allocList>
  802070:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  802073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802076:	8b 40 08             	mov    0x8(%eax),%eax
  802079:	eb 05                	jmp    802080 <malloc+0x89>
    }

			}


	return NULL;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  802099:	83 ec 08             	sub    $0x8,%esp
  80209c:	ff 75 f0             	pushl  -0x10(%ebp)
  80209f:	68 40 50 80 00       	push   $0x805040
  8020a4:	e8 a0 0b 00 00       	call   802c49 <find_block>
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8020af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	52                   	push   %edx
  8020bc:	50                   	push   %eax
  8020bd:	e8 e4 03 00 00       	call   8024a6 <sys_free_user_mem>
  8020c2:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8020c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020c9:	75 17                	jne    8020e2 <free+0x60>
  8020cb:	83 ec 04             	sub    $0x4,%esp
  8020ce:	68 35 46 80 00       	push   $0x804635
  8020d3:	68 84 00 00 00       	push   $0x84
  8020d8:	68 53 46 80 00       	push   $0x804653
  8020dd:	e8 11 ed ff ff       	call   800df3 <_panic>
  8020e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e5:	8b 00                	mov    (%eax),%eax
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	74 10                	je     8020fb <free+0x79>
  8020eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ee:	8b 00                	mov    (%eax),%eax
  8020f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020f3:	8b 52 04             	mov    0x4(%edx),%edx
  8020f6:	89 50 04             	mov    %edx,0x4(%eax)
  8020f9:	eb 0b                	jmp    802106 <free+0x84>
  8020fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fe:	8b 40 04             	mov    0x4(%eax),%eax
  802101:	a3 44 50 80 00       	mov    %eax,0x805044
  802106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802109:	8b 40 04             	mov    0x4(%eax),%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	74 0f                	je     80211f <free+0x9d>
  802110:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802113:	8b 40 04             	mov    0x4(%eax),%eax
  802116:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802119:	8b 12                	mov    (%edx),%edx
  80211b:	89 10                	mov    %edx,(%eax)
  80211d:	eb 0a                	jmp    802129 <free+0xa7>
  80211f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802122:	8b 00                	mov    (%eax),%eax
  802124:	a3 40 50 80 00       	mov    %eax,0x805040
  802129:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802132:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802141:	48                   	dec    %eax
  802142:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  802147:	83 ec 0c             	sub    $0xc,%esp
  80214a:	ff 75 ec             	pushl  -0x14(%ebp)
  80214d:	e8 63 12 00 00       	call   8033b5 <insert_sorted_with_merge_freeList>
  802152:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  802155:	90                   	nop
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 38             	sub    $0x38,%esp
  80215e:	8b 45 10             	mov    0x10(%ebp),%eax
  802161:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802164:	e8 c8 fc ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  802169:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80216d:	75 0a                	jne    802179 <smalloc+0x21>
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	e9 a0 00 00 00       	jmp    802219 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  802179:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  802180:	76 0a                	jbe    80218c <smalloc+0x34>
		return NULL;
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
  802187:	e9 8d 00 00 00       	jmp    802219 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80218c:	e8 1b 07 00 00       	call   8028ac <sys_isUHeapPlacementStrategyFIRSTFIT>
  802191:	85 c0                	test   %eax,%eax
  802193:	74 7f                	je     802214 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802195:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80219c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	01 d0                	add    %edx,%eax
  8021a4:	48                   	dec    %eax
  8021a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b0:	f7 75 f4             	divl   -0xc(%ebp)
  8021b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b6:	29 d0                	sub    %edx,%eax
  8021b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8021bb:	83 ec 0c             	sub    $0xc,%esp
  8021be:	ff 75 ec             	pushl  -0x14(%ebp)
  8021c1:	e8 65 0c 00 00       	call   802e2b <alloc_block_FF>
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  8021cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021d0:	74 42                	je     802214 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  8021d2:	83 ec 0c             	sub    $0xc,%esp
  8021d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8021d8:	e8 9f 0a 00 00       	call   802c7c <insert_sorted_allocList>
  8021dd:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  8021e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021e3:	8b 40 08             	mov    0x8(%eax),%eax
  8021e6:	89 c2                	mov    %eax,%edx
  8021e8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8021ec:	52                   	push   %edx
  8021ed:	50                   	push   %eax
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	ff 75 08             	pushl  0x8(%ebp)
  8021f4:	e8 38 04 00 00       	call   802631 <sys_createSharedObject>
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8021ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802203:	79 07                	jns    80220c <smalloc+0xb4>
	    		  return NULL;
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
  80220a:	eb 0d                	jmp    802219 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  80220c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	eb 05                	jmp    802219 <smalloc+0xc1>


				}


		return NULL;
  802214:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802221:	e8 0b fc ff ff       	call   801e31 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802226:	e8 81 06 00 00       	call   8028ac <sys_isUHeapPlacementStrategyFIRSTFIT>
  80222b:	85 c0                	test   %eax,%eax
  80222d:	0f 84 9f 00 00 00    	je     8022d2 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802233:	83 ec 08             	sub    $0x8,%esp
  802236:	ff 75 0c             	pushl  0xc(%ebp)
  802239:	ff 75 08             	pushl  0x8(%ebp)
  80223c:	e8 1a 04 00 00       	call   80265b <sys_getSizeOfSharedObject>
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  802247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224b:	79 0a                	jns    802257 <sget+0x3c>
		return NULL;
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
  802252:	e9 80 00 00 00       	jmp    8022d7 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802257:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80225e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802264:	01 d0                	add    %edx,%eax
  802266:	48                   	dec    %eax
  802267:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80226a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226d:	ba 00 00 00 00       	mov    $0x0,%edx
  802272:	f7 75 f0             	divl   -0x10(%ebp)
  802275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802278:	29 d0                	sub    %edx,%eax
  80227a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  80227d:	83 ec 0c             	sub    $0xc,%esp
  802280:	ff 75 e8             	pushl  -0x18(%ebp)
  802283:	e8 a3 0b 00 00       	call   802e2b <alloc_block_FF>
  802288:	83 c4 10             	add    $0x10,%esp
  80228b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  80228e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802292:	74 3e                	je     8022d2 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  802294:	83 ec 0c             	sub    $0xc,%esp
  802297:	ff 75 e4             	pushl  -0x1c(%ebp)
  80229a:	e8 dd 09 00 00       	call   802c7c <insert_sorted_allocList>
  80229f:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8022a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a5:	8b 40 08             	mov    0x8(%eax),%eax
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	50                   	push   %eax
  8022ac:	ff 75 0c             	pushl  0xc(%ebp)
  8022af:	ff 75 08             	pushl  0x8(%ebp)
  8022b2:	e8 c1 03 00 00       	call   802678 <sys_getSharedObject>
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8022bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022c1:	79 07                	jns    8022ca <sget+0xaf>
	    		  return NULL;
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	eb 0d                	jmp    8022d7 <sget+0xbc>
	  	return(void*) returned_block->sva;
  8022ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022cd:	8b 40 08             	mov    0x8(%eax),%eax
  8022d0:	eb 05                	jmp    8022d7 <sget+0xbc>
	      }
	}
	   return NULL;
  8022d2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022df:	e8 4d fb ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	68 60 46 80 00       	push   $0x804660
  8022ec:	68 12 01 00 00       	push   $0x112
  8022f1:	68 53 46 80 00       	push   $0x804653
  8022f6:	e8 f8 ea ff ff       	call   800df3 <_panic>

008022fb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	68 88 46 80 00       	push   $0x804688
  802309:	68 26 01 00 00       	push   $0x126
  80230e:	68 53 46 80 00       	push   $0x804653
  802313:	e8 db ea ff ff       	call   800df3 <_panic>

00802318 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	68 ac 46 80 00       	push   $0x8046ac
  802326:	68 31 01 00 00       	push   $0x131
  80232b:	68 53 46 80 00       	push   $0x804653
  802330:	e8 be ea ff ff       	call   800df3 <_panic>

00802335 <shrink>:

}
void shrink(uint32 newSize)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80233b:	83 ec 04             	sub    $0x4,%esp
  80233e:	68 ac 46 80 00       	push   $0x8046ac
  802343:	68 36 01 00 00       	push   $0x136
  802348:	68 53 46 80 00       	push   $0x804653
  80234d:	e8 a1 ea ff ff       	call   800df3 <_panic>

00802352 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802358:	83 ec 04             	sub    $0x4,%esp
  80235b:	68 ac 46 80 00       	push   $0x8046ac
  802360:	68 3b 01 00 00       	push   $0x13b
  802365:	68 53 46 80 00       	push   $0x804653
  80236a:	e8 84 ea ff ff       	call   800df3 <_panic>

0080236f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	57                   	push   %edi
  802373:	56                   	push   %esi
  802374:	53                   	push   %ebx
  802375:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802381:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802384:	8b 7d 18             	mov    0x18(%ebp),%edi
  802387:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80238a:	cd 30                	int    $0x30
  80238c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802392:	83 c4 10             	add    $0x10,%esp
  802395:	5b                   	pop    %ebx
  802396:	5e                   	pop    %esi
  802397:	5f                   	pop    %edi
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    

0080239a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8023a6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	52                   	push   %edx
  8023b2:	ff 75 0c             	pushl  0xc(%ebp)
  8023b5:	50                   	push   %eax
  8023b6:	6a 00                	push   $0x0
  8023b8:	e8 b2 ff ff ff       	call   80236f <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
}
  8023c0:	90                   	nop
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 01                	push   $0x1
  8023d2:	e8 98 ff ff ff       	call   80236f <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	52                   	push   %edx
  8023ec:	50                   	push   %eax
  8023ed:	6a 05                	push   $0x5
  8023ef:	e8 7b ff ff ff       	call   80236f <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	56                   	push   %esi
  8023fd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023fe:	8b 75 18             	mov    0x18(%ebp),%esi
  802401:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802404:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	56                   	push   %esi
  80240e:	53                   	push   %ebx
  80240f:	51                   	push   %ecx
  802410:	52                   	push   %edx
  802411:	50                   	push   %eax
  802412:	6a 06                	push   $0x6
  802414:	e8 56 ff ff ff       	call   80236f <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
}
  80241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    

00802423 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802426:	8b 55 0c             	mov    0xc(%ebp),%edx
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	52                   	push   %edx
  802433:	50                   	push   %eax
  802434:	6a 07                	push   $0x7
  802436:	e8 34 ff ff ff       	call   80236f <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	ff 75 0c             	pushl  0xc(%ebp)
  80244c:	ff 75 08             	pushl  0x8(%ebp)
  80244f:	6a 08                	push   $0x8
  802451:	e8 19 ff ff ff       	call   80236f <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 09                	push   $0x9
  80246a:	e8 00 ff ff ff       	call   80236f <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 0a                	push   $0xa
  802483:	e8 e7 fe ff ff       	call   80236f <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 0b                	push   $0xb
  80249c:	e8 ce fe ff ff       	call   80236f <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	ff 75 0c             	pushl  0xc(%ebp)
  8024b2:	ff 75 08             	pushl  0x8(%ebp)
  8024b5:	6a 0f                	push   $0xf
  8024b7:	e8 b3 fe ff ff       	call   80236f <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
	return;
  8024bf:	90                   	nop
}
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    

008024c2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	ff 75 0c             	pushl  0xc(%ebp)
  8024ce:	ff 75 08             	pushl  0x8(%ebp)
  8024d1:	6a 10                	push   $0x10
  8024d3:	e8 97 fe ff ff       	call   80236f <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024db:	90                   	nop
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	ff 75 10             	pushl  0x10(%ebp)
  8024e8:	ff 75 0c             	pushl  0xc(%ebp)
  8024eb:	ff 75 08             	pushl  0x8(%ebp)
  8024ee:	6a 11                	push   $0x11
  8024f0:	e8 7a fe ff ff       	call   80236f <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f8:	90                   	nop
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 0c                	push   $0xc
  80250a:	e8 60 fe ff ff       	call   80236f <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	ff 75 08             	pushl  0x8(%ebp)
  802522:	6a 0d                	push   $0xd
  802524:	e8 46 fe ff ff       	call   80236f <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 0e                	push   $0xe
  80253d:	e8 2d fe ff ff       	call   80236f <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
}
  802545:	90                   	nop
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 13                	push   $0x13
  802557:	e8 13 fe ff ff       	call   80236f <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
}
  80255f:	90                   	nop
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 14                	push   $0x14
  802571:	e8 f9 fd ff ff       	call   80236f <syscall>
  802576:	83 c4 18             	add    $0x18,%esp
}
  802579:	90                   	nop
  80257a:	c9                   	leave  
  80257b:	c3                   	ret    

0080257c <sys_cputc>:


void
sys_cputc(const char c)
{
  80257c:	55                   	push   %ebp
  80257d:	89 e5                	mov    %esp,%ebp
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802588:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	50                   	push   %eax
  802595:	6a 15                	push   $0x15
  802597:	e8 d3 fd ff ff       	call   80236f <syscall>
  80259c:	83 c4 18             	add    $0x18,%esp
}
  80259f:	90                   	nop
  8025a0:	c9                   	leave  
  8025a1:	c3                   	ret    

008025a2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 16                	push   $0x16
  8025b1:	e8 b9 fd ff ff       	call   80236f <syscall>
  8025b6:	83 c4 18             	add    $0x18,%esp
}
  8025b9:	90                   	nop
  8025ba:	c9                   	leave  
  8025bb:	c3                   	ret    

008025bc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	ff 75 0c             	pushl  0xc(%ebp)
  8025cb:	50                   	push   %eax
  8025cc:	6a 17                	push   $0x17
  8025ce:	e8 9c fd ff ff       	call   80236f <syscall>
  8025d3:	83 c4 18             	add    $0x18,%esp
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	52                   	push   %edx
  8025e8:	50                   	push   %eax
  8025e9:	6a 1a                	push   $0x1a
  8025eb:	e8 7f fd ff ff       	call   80236f <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	52                   	push   %edx
  802605:	50                   	push   %eax
  802606:	6a 18                	push   $0x18
  802608:	e8 62 fd ff ff       	call   80236f <syscall>
  80260d:	83 c4 18             	add    $0x18,%esp
}
  802610:	90                   	nop
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802616:	8b 55 0c             	mov    0xc(%ebp),%edx
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	52                   	push   %edx
  802623:	50                   	push   %eax
  802624:	6a 19                	push   $0x19
  802626:	e8 44 fd ff ff       	call   80236f <syscall>
  80262b:	83 c4 18             	add    $0x18,%esp
}
  80262e:	90                   	nop
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 04             	sub    $0x4,%esp
  802637:	8b 45 10             	mov    0x10(%ebp),%eax
  80263a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80263d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802640:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	6a 00                	push   $0x0
  802649:	51                   	push   %ecx
  80264a:	52                   	push   %edx
  80264b:	ff 75 0c             	pushl  0xc(%ebp)
  80264e:	50                   	push   %eax
  80264f:	6a 1b                	push   $0x1b
  802651:	e8 19 fd ff ff       	call   80236f <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80265e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	52                   	push   %edx
  80266b:	50                   	push   %eax
  80266c:	6a 1c                	push   $0x1c
  80266e:	e8 fc fc ff ff       	call   80236f <syscall>
  802673:	83 c4 18             	add    $0x18,%esp
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80267b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80267e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	51                   	push   %ecx
  802689:	52                   	push   %edx
  80268a:	50                   	push   %eax
  80268b:	6a 1d                	push   $0x1d
  80268d:	e8 dd fc ff ff       	call   80236f <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80269a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	52                   	push   %edx
  8026a7:	50                   	push   %eax
  8026a8:	6a 1e                	push   $0x1e
  8026aa:	e8 c0 fc ff ff       	call   80236f <syscall>
  8026af:	83 c4 18             	add    $0x18,%esp
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 1f                	push   $0x1f
  8026c3:	e8 a7 fc ff ff       	call   80236f <syscall>
  8026c8:	83 c4 18             	add    $0x18,%esp
}
  8026cb:	c9                   	leave  
  8026cc:	c3                   	ret    

008026cd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	6a 00                	push   $0x0
  8026d5:	ff 75 14             	pushl  0x14(%ebp)
  8026d8:	ff 75 10             	pushl  0x10(%ebp)
  8026db:	ff 75 0c             	pushl  0xc(%ebp)
  8026de:	50                   	push   %eax
  8026df:	6a 20                	push   $0x20
  8026e1:	e8 89 fc ff ff       	call   80236f <syscall>
  8026e6:	83 c4 18             	add    $0x18,%esp
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	50                   	push   %eax
  8026fa:	6a 21                	push   $0x21
  8026fc:	e8 6e fc ff ff       	call   80236f <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	90                   	nop
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	50                   	push   %eax
  802716:	6a 22                	push   $0x22
  802718:	e8 52 fc ff ff       	call   80236f <syscall>
  80271d:	83 c4 18             	add    $0x18,%esp
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 02                	push   $0x2
  802731:	e8 39 fc ff ff       	call   80236f <syscall>
  802736:	83 c4 18             	add    $0x18,%esp
}
  802739:	c9                   	leave  
  80273a:	c3                   	ret    

0080273b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 03                	push   $0x3
  80274a:	e8 20 fc ff ff       	call   80236f <syscall>
  80274f:	83 c4 18             	add    $0x18,%esp
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 04                	push   $0x4
  802763:	e8 07 fc ff ff       	call   80236f <syscall>
  802768:	83 c4 18             	add    $0x18,%esp
}
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <sys_exit_env>:


void sys_exit_env(void)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 23                	push   $0x23
  80277c:	e8 ee fb ff ff       	call   80236f <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
}
  802784:	90                   	nop
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80278d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802790:	8d 50 04             	lea    0x4(%eax),%edx
  802793:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	52                   	push   %edx
  80279d:	50                   	push   %eax
  80279e:	6a 24                	push   $0x24
  8027a0:	e8 ca fb ff ff       	call   80236f <syscall>
  8027a5:	83 c4 18             	add    $0x18,%esp
	return result;
  8027a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027b1:	89 01                	mov    %eax,(%ecx)
  8027b3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	c9                   	leave  
  8027ba:	c2 04 00             	ret    $0x4

008027bd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	ff 75 10             	pushl  0x10(%ebp)
  8027c7:	ff 75 0c             	pushl  0xc(%ebp)
  8027ca:	ff 75 08             	pushl  0x8(%ebp)
  8027cd:	6a 12                	push   $0x12
  8027cf:	e8 9b fb ff ff       	call   80236f <syscall>
  8027d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d7:	90                   	nop
}
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <sys_rcr2>:
uint32 sys_rcr2()
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 25                	push   $0x25
  8027e9:	e8 81 fb ff ff       	call   80236f <syscall>
  8027ee:	83 c4 18             	add    $0x18,%esp
}
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	83 ec 04             	sub    $0x4,%esp
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027ff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	50                   	push   %eax
  80280c:	6a 26                	push   $0x26
  80280e:	e8 5c fb ff ff       	call   80236f <syscall>
  802813:	83 c4 18             	add    $0x18,%esp
	return ;
  802816:	90                   	nop
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <rsttst>:
void rsttst()
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 28                	push   $0x28
  802828:	e8 42 fb ff ff       	call   80236f <syscall>
  80282d:	83 c4 18             	add    $0x18,%esp
	return ;
  802830:	90                   	nop
}
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
  802836:	83 ec 04             	sub    $0x4,%esp
  802839:	8b 45 14             	mov    0x14(%ebp),%eax
  80283c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80283f:	8b 55 18             	mov    0x18(%ebp),%edx
  802842:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802846:	52                   	push   %edx
  802847:	50                   	push   %eax
  802848:	ff 75 10             	pushl  0x10(%ebp)
  80284b:	ff 75 0c             	pushl  0xc(%ebp)
  80284e:	ff 75 08             	pushl  0x8(%ebp)
  802851:	6a 27                	push   $0x27
  802853:	e8 17 fb ff ff       	call   80236f <syscall>
  802858:	83 c4 18             	add    $0x18,%esp
	return ;
  80285b:	90                   	nop
}
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <chktst>:
void chktst(uint32 n)
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	ff 75 08             	pushl  0x8(%ebp)
  80286c:	6a 29                	push   $0x29
  80286e:	e8 fc fa ff ff       	call   80236f <syscall>
  802873:	83 c4 18             	add    $0x18,%esp
	return ;
  802876:	90                   	nop
}
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <inctst>:

void inctst()
{
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 2a                	push   $0x2a
  802888:	e8 e2 fa ff ff       	call   80236f <syscall>
  80288d:	83 c4 18             	add    $0x18,%esp
	return ;
  802890:	90                   	nop
}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <gettst>:
uint32 gettst()
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 2b                	push   $0x2b
  8028a2:	e8 c8 fa ff ff       	call   80236f <syscall>
  8028a7:	83 c4 18             	add    $0x18,%esp
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 2c                	push   $0x2c
  8028be:	e8 ac fa ff ff       	call   80236f <syscall>
  8028c3:	83 c4 18             	add    $0x18,%esp
  8028c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028c9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028cd:	75 07                	jne    8028d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d4:	eb 05                	jmp    8028db <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 2c                	push   $0x2c
  8028ef:	e8 7b fa ff ff       	call   80236f <syscall>
  8028f4:	83 c4 18             	add    $0x18,%esp
  8028f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028fa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028fe:	75 07                	jne    802907 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802900:	b8 01 00 00 00       	mov    $0x1,%eax
  802905:	eb 05                	jmp    80290c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802907:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802914:	6a 00                	push   $0x0
  802916:	6a 00                	push   $0x0
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 2c                	push   $0x2c
  802920:	e8 4a fa ff ff       	call   80236f <syscall>
  802925:	83 c4 18             	add    $0x18,%esp
  802928:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80292b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80292f:	75 07                	jne    802938 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802931:	b8 01 00 00 00       	mov    $0x1,%eax
  802936:	eb 05                	jmp    80293d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802938:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    

0080293f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802945:	6a 00                	push   $0x0
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 2c                	push   $0x2c
  802951:	e8 19 fa ff ff       	call   80236f <syscall>
  802956:	83 c4 18             	add    $0x18,%esp
  802959:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80295c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802960:	75 07                	jne    802969 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802962:	b8 01 00 00 00       	mov    $0x1,%eax
  802967:	eb 05                	jmp    80296e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802969:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802973:	6a 00                	push   $0x0
  802975:	6a 00                	push   $0x0
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	ff 75 08             	pushl  0x8(%ebp)
  80297e:	6a 2d                	push   $0x2d
  802980:	e8 ea f9 ff ff       	call   80236f <syscall>
  802985:	83 c4 18             	add    $0x18,%esp
	return ;
  802988:	90                   	nop
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
  80298e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80298f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802992:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802995:	8b 55 0c             	mov    0xc(%ebp),%edx
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	6a 00                	push   $0x0
  80299d:	53                   	push   %ebx
  80299e:	51                   	push   %ecx
  80299f:	52                   	push   %edx
  8029a0:	50                   	push   %eax
  8029a1:	6a 2e                	push   $0x2e
  8029a3:	e8 c7 f9 ff ff       	call   80236f <syscall>
  8029a8:	83 c4 18             	add    $0x18,%esp
}
  8029ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029ae:	c9                   	leave  
  8029af:	c3                   	ret    

008029b0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8029b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	52                   	push   %edx
  8029c0:	50                   	push   %eax
  8029c1:	6a 2f                	push   $0x2f
  8029c3:	e8 a7 f9 ff ff       	call   80236f <syscall>
  8029c8:	83 c4 18             	add    $0x18,%esp
}
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
  8029d0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8029d3:	83 ec 0c             	sub    $0xc,%esp
  8029d6:	68 bc 46 80 00       	push   $0x8046bc
  8029db:	e8 c7 e6 ff ff       	call   8010a7 <cprintf>
  8029e0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029ea:	83 ec 0c             	sub    $0xc,%esp
  8029ed:	68 e8 46 80 00       	push   $0x8046e8
  8029f2:	e8 b0 e6 ff ff       	call   8010a7 <cprintf>
  8029f7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029fa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029fe:	a1 38 51 80 00       	mov    0x805138,%eax
  802a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a06:	eb 56                	jmp    802a5e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0c:	74 1c                	je     802a2a <print_mem_block_lists+0x5d>
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 50 08             	mov    0x8(%eax),%edx
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	8b 48 08             	mov    0x8(%eax),%ecx
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a20:	01 c8                	add    %ecx,%eax
  802a22:	39 c2                	cmp    %eax,%edx
  802a24:	73 04                	jae    802a2a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802a26:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 50 08             	mov    0x8(%eax),%edx
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 40 0c             	mov    0xc(%eax),%eax
  802a36:	01 c2                	add    %eax,%edx
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 08             	mov    0x8(%eax),%eax
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	52                   	push   %edx
  802a42:	50                   	push   %eax
  802a43:	68 fd 46 80 00       	push   $0x8046fd
  802a48:	e8 5a e6 ff ff       	call   8010a7 <cprintf>
  802a4d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a56:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a62:	74 07                	je     802a6b <print_mem_block_lists+0x9e>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	eb 05                	jmp    802a70 <print_mem_block_lists+0xa3>
  802a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a70:	a3 40 51 80 00       	mov    %eax,0x805140
  802a75:	a1 40 51 80 00       	mov    0x805140,%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	75 8a                	jne    802a08 <print_mem_block_lists+0x3b>
  802a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a82:	75 84                	jne    802a08 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a84:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a88:	75 10                	jne    802a9a <print_mem_block_lists+0xcd>
  802a8a:	83 ec 0c             	sub    $0xc,%esp
  802a8d:	68 0c 47 80 00       	push   $0x80470c
  802a92:	e8 10 e6 ff ff       	call   8010a7 <cprintf>
  802a97:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802aa1:	83 ec 0c             	sub    $0xc,%esp
  802aa4:	68 30 47 80 00       	push   $0x804730
  802aa9:	e8 f9 e5 ff ff       	call   8010a7 <cprintf>
  802aae:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802ab1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802ab5:	a1 40 50 80 00       	mov    0x805040,%eax
  802aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abd:	eb 56                	jmp    802b15 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802abf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac3:	74 1c                	je     802ae1 <print_mem_block_lists+0x114>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 50 08             	mov    0x8(%eax),%edx
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 48 08             	mov    0x8(%eax),%ecx
  802ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad7:	01 c8                	add    %ecx,%eax
  802ad9:	39 c2                	cmp    %eax,%edx
  802adb:	73 04                	jae    802ae1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802add:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 50 08             	mov    0x8(%eax),%edx
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 40 0c             	mov    0xc(%eax),%eax
  802aed:	01 c2                	add    %eax,%edx
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 08             	mov    0x8(%eax),%eax
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	52                   	push   %edx
  802af9:	50                   	push   %eax
  802afa:	68 fd 46 80 00       	push   $0x8046fd
  802aff:	e8 a3 e5 ff ff       	call   8010a7 <cprintf>
  802b04:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b0d:	a1 48 50 80 00       	mov    0x805048,%eax
  802b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b19:	74 07                	je     802b22 <print_mem_block_lists+0x155>
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	eb 05                	jmp    802b27 <print_mem_block_lists+0x15a>
  802b22:	b8 00 00 00 00       	mov    $0x0,%eax
  802b27:	a3 48 50 80 00       	mov    %eax,0x805048
  802b2c:	a1 48 50 80 00       	mov    0x805048,%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	75 8a                	jne    802abf <print_mem_block_lists+0xf2>
  802b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b39:	75 84                	jne    802abf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802b3b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b3f:	75 10                	jne    802b51 <print_mem_block_lists+0x184>
  802b41:	83 ec 0c             	sub    $0xc,%esp
  802b44:	68 48 47 80 00       	push   $0x804748
  802b49:	e8 59 e5 ff ff       	call   8010a7 <cprintf>
  802b4e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b51:	83 ec 0c             	sub    $0xc,%esp
  802b54:	68 bc 46 80 00       	push   $0x8046bc
  802b59:	e8 49 e5 ff ff       	call   8010a7 <cprintf>
  802b5e:	83 c4 10             	add    $0x10,%esp

}
  802b61:	90                   	nop
  802b62:	c9                   	leave  
  802b63:	c3                   	ret    

00802b64 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
  802b67:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802b6a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b71:	00 00 00 
  802b74:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b7b:	00 00 00 
  802b7e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b85:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802b88:	a1 50 50 80 00       	mov    0x805050,%eax
  802b8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802b90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b97:	e9 9e 00 00 00       	jmp    802c3a <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802b9c:	a1 50 50 80 00       	mov    0x805050,%eax
  802ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba4:	c1 e2 04             	shl    $0x4,%edx
  802ba7:	01 d0                	add    %edx,%eax
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	75 14                	jne    802bc1 <initialize_MemBlocksList+0x5d>
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	68 70 47 80 00       	push   $0x804770
  802bb5:	6a 48                	push   $0x48
  802bb7:	68 93 47 80 00       	push   $0x804793
  802bbc:	e8 32 e2 ff ff       	call   800df3 <_panic>
  802bc1:	a1 50 50 80 00       	mov    0x805050,%eax
  802bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc9:	c1 e2 04             	shl    $0x4,%edx
  802bcc:	01 d0                	add    %edx,%eax
  802bce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	85 c0                	test   %eax,%eax
  802bda:	74 18                	je     802bf4 <initialize_MemBlocksList+0x90>
  802bdc:	a1 48 51 80 00       	mov    0x805148,%eax
  802be1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802be7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802bea:	c1 e1 04             	shl    $0x4,%ecx
  802bed:	01 ca                	add    %ecx,%edx
  802bef:	89 50 04             	mov    %edx,0x4(%eax)
  802bf2:	eb 12                	jmp    802c06 <initialize_MemBlocksList+0xa2>
  802bf4:	a1 50 50 80 00       	mov    0x805050,%eax
  802bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfc:	c1 e2 04             	shl    $0x4,%edx
  802bff:	01 d0                	add    %edx,%eax
  802c01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c06:	a1 50 50 80 00       	mov    0x805050,%eax
  802c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0e:	c1 e2 04             	shl    $0x4,%edx
  802c11:	01 d0                	add    %edx,%eax
  802c13:	a3 48 51 80 00       	mov    %eax,0x805148
  802c18:	a1 50 50 80 00       	mov    0x805050,%eax
  802c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c20:	c1 e2 04             	shl    $0x4,%edx
  802c23:	01 d0                	add    %edx,%eax
  802c25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c31:	40                   	inc    %eax
  802c32:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802c37:	ff 45 f4             	incl   -0xc(%ebp)
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c40:	0f 82 56 ff ff ff    	jb     802b9c <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802c46:	90                   	nop
  802c47:	c9                   	leave  
  802c48:	c3                   	ret    

00802c49 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802c49:	55                   	push   %ebp
  802c4a:	89 e5                	mov    %esp,%ebp
  802c4c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802c57:	eb 18                	jmp    802c71 <find_block+0x28>
		{
			if(tmp->sva==va)
  802c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c5c:	8b 40 08             	mov    0x8(%eax),%eax
  802c5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c62:	75 05                	jne    802c69 <find_block+0x20>
			{
				return tmp;
  802c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c67:	eb 11                	jmp    802c7a <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c75:	75 e2                	jne    802c59 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802c7a:	c9                   	leave  
  802c7b:	c3                   	ret    

00802c7c <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802c7c:	55                   	push   %ebp
  802c7d:	89 e5                	mov    %esp,%ebp
  802c7f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802c82:	a1 40 50 80 00       	mov    0x805040,%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	0f 85 83 00 00 00    	jne    802d12 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802c8f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802c96:	00 00 00 
  802c99:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802ca0:	00 00 00 
  802ca3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802caa:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb1:	75 14                	jne    802cc7 <insert_sorted_allocList+0x4b>
  802cb3:	83 ec 04             	sub    $0x4,%esp
  802cb6:	68 70 47 80 00       	push   $0x804770
  802cbb:	6a 7f                	push   $0x7f
  802cbd:	68 93 47 80 00       	push   $0x804793
  802cc2:	e8 2c e1 ff ff       	call   800df3 <_panic>
  802cc7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	89 10                	mov    %edx,(%eax)
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 0d                	je     802ce8 <insert_sorted_allocList+0x6c>
  802cdb:	a1 40 50 80 00       	mov    0x805040,%eax
  802ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce3:	89 50 04             	mov    %edx,0x4(%eax)
  802ce6:	eb 08                	jmp    802cf0 <insert_sorted_allocList+0x74>
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	a3 44 50 80 00       	mov    %eax,0x805044
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	a3 40 50 80 00       	mov    %eax,0x805040
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d02:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d07:	40                   	inc    %eax
  802d08:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802d0d:	e9 16 01 00 00       	jmp    802e28 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	8b 50 08             	mov    0x8(%eax),%edx
  802d18:	a1 44 50 80 00       	mov    0x805044,%eax
  802d1d:	8b 40 08             	mov    0x8(%eax),%eax
  802d20:	39 c2                	cmp    %eax,%edx
  802d22:	76 68                	jbe    802d8c <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802d24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d28:	75 17                	jne    802d41 <insert_sorted_allocList+0xc5>
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	68 ac 47 80 00       	push   $0x8047ac
  802d32:	68 85 00 00 00       	push   $0x85
  802d37:	68 93 47 80 00       	push   $0x804793
  802d3c:	e8 b2 e0 ff ff       	call   800df3 <_panic>
  802d41:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	8b 40 04             	mov    0x4(%eax),%eax
  802d53:	85 c0                	test   %eax,%eax
  802d55:	74 0c                	je     802d63 <insert_sorted_allocList+0xe7>
  802d57:	a1 44 50 80 00       	mov    0x805044,%eax
  802d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5f:	89 10                	mov    %edx,(%eax)
  802d61:	eb 08                	jmp    802d6b <insert_sorted_allocList+0xef>
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	a3 40 50 80 00       	mov    %eax,0x805040
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	a3 44 50 80 00       	mov    %eax,0x805044
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d81:	40                   	inc    %eax
  802d82:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802d87:	e9 9c 00 00 00       	jmp    802e28 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802d8c:	a1 40 50 80 00       	mov    0x805040,%eax
  802d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802d94:	e9 85 00 00 00       	jmp    802e1e <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	8b 50 08             	mov    0x8(%eax),%edx
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 40 08             	mov    0x8(%eax),%eax
  802da5:	39 c2                	cmp    %eax,%edx
  802da7:	73 6d                	jae    802e16 <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802da9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dad:	74 06                	je     802db5 <insert_sorted_allocList+0x139>
  802daf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db3:	75 17                	jne    802dcc <insert_sorted_allocList+0x150>
  802db5:	83 ec 04             	sub    $0x4,%esp
  802db8:	68 d0 47 80 00       	push   $0x8047d0
  802dbd:	68 90 00 00 00       	push   $0x90
  802dc2:	68 93 47 80 00       	push   $0x804793
  802dc7:	e8 27 e0 ff ff       	call   800df3 <_panic>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 50 04             	mov    0x4(%eax),%edx
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	89 50 04             	mov    %edx,0x4(%eax)
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dde:	89 10                	mov    %edx,(%eax)
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 40 04             	mov    0x4(%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 0d                	je     802df7 <insert_sorted_allocList+0x17b>
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 40 04             	mov    0x4(%eax),%eax
  802df0:	8b 55 08             	mov    0x8(%ebp),%edx
  802df3:	89 10                	mov    %edx,(%eax)
  802df5:	eb 08                	jmp    802dff <insert_sorted_allocList+0x183>
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	a3 40 50 80 00       	mov    %eax,0x805040
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 55 08             	mov    0x8(%ebp),%edx
  802e05:	89 50 04             	mov    %edx,0x4(%eax)
  802e08:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e0d:	40                   	inc    %eax
  802e0e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802e13:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802e14:	eb 12                	jmp    802e28 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 00                	mov    (%eax),%eax
  802e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e22:	0f 85 71 ff ff ff    	jne    802d99 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802e28:	90                   	nop
  802e29:	c9                   	leave  
  802e2a:	c3                   	ret    

00802e2b <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802e2b:	55                   	push   %ebp
  802e2c:	89 e5                	mov    %esp,%ebp
  802e2e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802e31:	a1 38 51 80 00       	mov    0x805138,%eax
  802e36:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802e39:	e9 76 01 00 00       	jmp    802fb4 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 0c             	mov    0xc(%eax),%eax
  802e44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e47:	0f 85 8a 00 00 00    	jne    802ed7 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802e4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e51:	75 17                	jne    802e6a <alloc_block_FF+0x3f>
  802e53:	83 ec 04             	sub    $0x4,%esp
  802e56:	68 05 48 80 00       	push   $0x804805
  802e5b:	68 a8 00 00 00       	push   $0xa8
  802e60:	68 93 47 80 00       	push   $0x804793
  802e65:	e8 89 df ff ff       	call   800df3 <_panic>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	74 10                	je     802e83 <alloc_block_FF+0x58>
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 00                	mov    (%eax),%eax
  802e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7b:	8b 52 04             	mov    0x4(%edx),%edx
  802e7e:	89 50 04             	mov    %edx,0x4(%eax)
  802e81:	eb 0b                	jmp    802e8e <alloc_block_FF+0x63>
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 04             	mov    0x4(%eax),%eax
  802e89:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 40 04             	mov    0x4(%eax),%eax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	74 0f                	je     802ea7 <alloc_block_FF+0x7c>
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea1:	8b 12                	mov    (%edx),%edx
  802ea3:	89 10                	mov    %edx,(%eax)
  802ea5:	eb 0a                	jmp    802eb1 <alloc_block_FF+0x86>
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec9:	48                   	dec    %eax
  802eca:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	e9 ea 00 00 00       	jmp    802fc1 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee0:	0f 86 c6 00 00 00    	jbe    802fac <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802ee6:	a1 48 51 80 00       	mov    0x805148,%eax
  802eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef4:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 50 08             	mov    0x8(%eax),%edx
  802efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f00:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 40 0c             	mov    0xc(%eax),%eax
  802f09:	2b 45 08             	sub    0x8(%ebp),%eax
  802f0c:	89 c2                	mov    %eax,%edx
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 50 08             	mov    0x8(%eax),%edx
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	01 c2                	add    %eax,%edx
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802f25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f29:	75 17                	jne    802f42 <alloc_block_FF+0x117>
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	68 05 48 80 00       	push   $0x804805
  802f33:	68 b6 00 00 00       	push   $0xb6
  802f38:	68 93 47 80 00       	push   $0x804793
  802f3d:	e8 b1 de ff ff       	call   800df3 <_panic>
  802f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 10                	je     802f5b <alloc_block_FF+0x130>
  802f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f53:	8b 52 04             	mov    0x4(%edx),%edx
  802f56:	89 50 04             	mov    %edx,0x4(%eax)
  802f59:	eb 0b                	jmp    802f66 <alloc_block_FF+0x13b>
  802f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0f                	je     802f7f <alloc_block_FF+0x154>
  802f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f79:	8b 12                	mov    (%edx),%edx
  802f7b:	89 10                	mov    %edx,(%eax)
  802f7d:	eb 0a                	jmp    802f89 <alloc_block_FF+0x15e>
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	a3 48 51 80 00       	mov    %eax,0x805148
  802f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9c:	a1 54 51 80 00       	mov    0x805154,%eax
  802fa1:	48                   	dec    %eax
  802fa2:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802faa:	eb 15                	jmp    802fc1 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802fb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb8:	0f 85 80 fe ff ff    	jne    802e3e <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802fc1:	c9                   	leave  
  802fc2:	c3                   	ret    

00802fc3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802fc3:	55                   	push   %ebp
  802fc4:	89 e5                	mov    %esp,%ebp
  802fc6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802fc9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802fd1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802fd8:	e9 c0 00 00 00       	jmp    80309d <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe6:	0f 85 8a 00 00 00    	jne    803076 <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff0:	75 17                	jne    803009 <alloc_block_BF+0x46>
  802ff2:	83 ec 04             	sub    $0x4,%esp
  802ff5:	68 05 48 80 00       	push   $0x804805
  802ffa:	68 cf 00 00 00       	push   $0xcf
  802fff:	68 93 47 80 00       	push   $0x804793
  803004:	e8 ea dd ff ff       	call   800df3 <_panic>
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	74 10                	je     803022 <alloc_block_BF+0x5f>
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301a:	8b 52 04             	mov    0x4(%edx),%edx
  80301d:	89 50 04             	mov    %edx,0x4(%eax)
  803020:	eb 0b                	jmp    80302d <alloc_block_BF+0x6a>
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	8b 40 04             	mov    0x4(%eax),%eax
  803028:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 40 04             	mov    0x4(%eax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	74 0f                	je     803046 <alloc_block_BF+0x83>
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 40 04             	mov    0x4(%eax),%eax
  80303d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803040:	8b 12                	mov    (%edx),%edx
  803042:	89 10                	mov    %edx,(%eax)
  803044:	eb 0a                	jmp    803050 <alloc_block_BF+0x8d>
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	a3 38 51 80 00       	mov    %eax,0x805138
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803063:	a1 44 51 80 00       	mov    0x805144,%eax
  803068:	48                   	dec    %eax
  803069:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	e9 2a 01 00 00       	jmp    8031a0 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80307f:	73 14                	jae    803095 <alloc_block_BF+0xd2>
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 40 0c             	mov    0xc(%eax),%eax
  803087:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308a:	76 09                	jbe    803095 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 40 0c             	mov    0xc(%eax),%eax
  803092:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  80309d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a1:	0f 85 36 ff ff ff    	jne    802fdd <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8030a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8030af:	e9 dd 00 00 00       	jmp    803191 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030bd:	0f 85 c6 00 00 00    	jne    803189 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8030c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8030c8:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 50 08             	mov    0x8(%eax),%edx
  8030d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d4:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  8030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030da:	8b 55 08             	mov    0x8(%ebp),%edx
  8030dd:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  8030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e3:	8b 50 08             	mov    0x8(%eax),%edx
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	01 c2                	add    %eax,%edx
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8030fa:	89 c2                	mov    %eax,%edx
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803102:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803106:	75 17                	jne    80311f <alloc_block_BF+0x15c>
  803108:	83 ec 04             	sub    $0x4,%esp
  80310b:	68 05 48 80 00       	push   $0x804805
  803110:	68 eb 00 00 00       	push   $0xeb
  803115:	68 93 47 80 00       	push   $0x804793
  80311a:	e8 d4 dc ff ff       	call   800df3 <_panic>
  80311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	74 10                	je     803138 <alloc_block_BF+0x175>
  803128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803130:	8b 52 04             	mov    0x4(%edx),%edx
  803133:	89 50 04             	mov    %edx,0x4(%eax)
  803136:	eb 0b                	jmp    803143 <alloc_block_BF+0x180>
  803138:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313b:	8b 40 04             	mov    0x4(%eax),%eax
  80313e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803146:	8b 40 04             	mov    0x4(%eax),%eax
  803149:	85 c0                	test   %eax,%eax
  80314b:	74 0f                	je     80315c <alloc_block_BF+0x199>
  80314d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803150:	8b 40 04             	mov    0x4(%eax),%eax
  803153:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803156:	8b 12                	mov    (%edx),%edx
  803158:	89 10                	mov    %edx,(%eax)
  80315a:	eb 0a                	jmp    803166 <alloc_block_BF+0x1a3>
  80315c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	a3 48 51 80 00       	mov    %eax,0x805148
  803166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803172:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803179:	a1 54 51 80 00       	mov    0x805154,%eax
  80317e:	48                   	dec    %eax
  80317f:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  803184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803187:	eb 17                	jmp    8031a0 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  803191:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803195:	0f 85 19 ff ff ff    	jne    8030b4 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  80319b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8031a0:	c9                   	leave  
  8031a1:	c3                   	ret    

008031a2 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8031a2:	55                   	push   %ebp
  8031a3:	89 e5                	mov    %esp,%ebp
  8031a5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8031a8:	a1 40 50 80 00       	mov    0x805040,%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	75 19                	jne    8031ca <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8031b1:	83 ec 0c             	sub    $0xc,%esp
  8031b4:	ff 75 08             	pushl  0x8(%ebp)
  8031b7:	e8 6f fc ff ff       	call   802e2b <alloc_block_FF>
  8031bc:	83 c4 10             	add    $0x10,%esp
  8031bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	e9 e9 01 00 00       	jmp    8033b3 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8031ca:	a1 44 50 80 00       	mov    0x805044,%eax
  8031cf:	8b 40 08             	mov    0x8(%eax),%eax
  8031d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  8031d5:	a1 44 50 80 00       	mov    0x805044,%eax
  8031da:	8b 50 0c             	mov    0xc(%eax),%edx
  8031dd:	a1 44 50 80 00       	mov    0x805044,%eax
  8031e2:	8b 40 08             	mov    0x8(%eax),%eax
  8031e5:	01 d0                	add    %edx,%eax
  8031e7:	83 ec 08             	sub    $0x8,%esp
  8031ea:	50                   	push   %eax
  8031eb:	68 38 51 80 00       	push   $0x805138
  8031f0:	e8 54 fa ff ff       	call   802c49 <find_block>
  8031f5:	83 c4 10             	add    $0x10,%esp
  8031f8:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803201:	3b 45 08             	cmp    0x8(%ebp),%eax
  803204:	0f 85 9b 00 00 00    	jne    8032a5 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 50 0c             	mov    0xc(%eax),%edx
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	8b 40 08             	mov    0x8(%eax),%eax
  803216:	01 d0                	add    %edx,%eax
  803218:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  80321b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321f:	75 17                	jne    803238 <alloc_block_NF+0x96>
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	68 05 48 80 00       	push   $0x804805
  803229:	68 1a 01 00 00       	push   $0x11a
  80322e:	68 93 47 80 00       	push   $0x804793
  803233:	e8 bb db ff ff       	call   800df3 <_panic>
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	85 c0                	test   %eax,%eax
  80323f:	74 10                	je     803251 <alloc_block_NF+0xaf>
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803249:	8b 52 04             	mov    0x4(%edx),%edx
  80324c:	89 50 04             	mov    %edx,0x4(%eax)
  80324f:	eb 0b                	jmp    80325c <alloc_block_NF+0xba>
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	8b 40 04             	mov    0x4(%eax),%eax
  803257:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 40 04             	mov    0x4(%eax),%eax
  803262:	85 c0                	test   %eax,%eax
  803264:	74 0f                	je     803275 <alloc_block_NF+0xd3>
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 40 04             	mov    0x4(%eax),%eax
  80326c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80326f:	8b 12                	mov    (%edx),%edx
  803271:	89 10                	mov    %edx,(%eax)
  803273:	eb 0a                	jmp    80327f <alloc_block_NF+0xdd>
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	a3 38 51 80 00       	mov    %eax,0x805138
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803292:	a1 44 51 80 00       	mov    0x805144,%eax
  803297:	48                   	dec    %eax
  803298:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  80329d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a0:	e9 0e 01 00 00       	jmp    8033b3 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ae:	0f 86 cf 00 00 00    	jbe    803383 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8032b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8032bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c2:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	8b 50 08             	mov    0x8(%eax),%edx
  8032cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ce:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	8b 50 08             	mov    0x8(%eax),%edx
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	01 c2                	add    %eax,%edx
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8032eb:	89 c2                	mov    %eax,%edx
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 40 08             	mov    0x8(%eax),%eax
  8032f9:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8032fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803300:	75 17                	jne    803319 <alloc_block_NF+0x177>
  803302:	83 ec 04             	sub    $0x4,%esp
  803305:	68 05 48 80 00       	push   $0x804805
  80330a:	68 28 01 00 00       	push   $0x128
  80330f:	68 93 47 80 00       	push   $0x804793
  803314:	e8 da da ff ff       	call   800df3 <_panic>
  803319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	85 c0                	test   %eax,%eax
  803320:	74 10                	je     803332 <alloc_block_NF+0x190>
  803322:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80332a:	8b 52 04             	mov    0x4(%edx),%edx
  80332d:	89 50 04             	mov    %edx,0x4(%eax)
  803330:	eb 0b                	jmp    80333d <alloc_block_NF+0x19b>
  803332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803335:	8b 40 04             	mov    0x4(%eax),%eax
  803338:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80333d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803340:	8b 40 04             	mov    0x4(%eax),%eax
  803343:	85 c0                	test   %eax,%eax
  803345:	74 0f                	je     803356 <alloc_block_NF+0x1b4>
  803347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334a:	8b 40 04             	mov    0x4(%eax),%eax
  80334d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803350:	8b 12                	mov    (%edx),%edx
  803352:	89 10                	mov    %edx,(%eax)
  803354:	eb 0a                	jmp    803360 <alloc_block_NF+0x1be>
  803356:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803359:	8b 00                	mov    (%eax),%eax
  80335b:	a3 48 51 80 00       	mov    %eax,0x805148
  803360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803373:	a1 54 51 80 00       	mov    0x805154,%eax
  803378:	48                   	dec    %eax
  803379:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  80337e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803381:	eb 30                	jmp    8033b3 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  803383:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803388:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80338b:	75 0a                	jne    803397 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  80338d:	a1 38 51 80 00       	mov    0x805138,%eax
  803392:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803395:	eb 08                	jmp    80339f <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	8b 00                	mov    (%eax),%eax
  80339c:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	8b 40 08             	mov    0x8(%eax),%eax
  8033a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033a8:	0f 85 4d fe ff ff    	jne    8031fb <alloc_block_NF+0x59>

			return NULL;
  8033ae:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8033b3:	c9                   	leave  
  8033b4:	c3                   	ret    

008033b5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033b5:	55                   	push   %ebp
  8033b6:	89 e5                	mov    %esp,%ebp
  8033b8:	53                   	push   %ebx
  8033b9:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8033bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8033c1:	85 c0                	test   %eax,%eax
  8033c3:	0f 85 86 00 00 00    	jne    80344f <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8033c9:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8033d0:	00 00 00 
  8033d3:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8033da:	00 00 00 
  8033dd:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8033e4:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033eb:	75 17                	jne    803404 <insert_sorted_with_merge_freeList+0x4f>
  8033ed:	83 ec 04             	sub    $0x4,%esp
  8033f0:	68 70 47 80 00       	push   $0x804770
  8033f5:	68 48 01 00 00       	push   $0x148
  8033fa:	68 93 47 80 00       	push   $0x804793
  8033ff:	e8 ef d9 ff ff       	call   800df3 <_panic>
  803404:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	89 10                	mov    %edx,(%eax)
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	8b 00                	mov    (%eax),%eax
  803414:	85 c0                	test   %eax,%eax
  803416:	74 0d                	je     803425 <insert_sorted_with_merge_freeList+0x70>
  803418:	a1 38 51 80 00       	mov    0x805138,%eax
  80341d:	8b 55 08             	mov    0x8(%ebp),%edx
  803420:	89 50 04             	mov    %edx,0x4(%eax)
  803423:	eb 08                	jmp    80342d <insert_sorted_with_merge_freeList+0x78>
  803425:	8b 45 08             	mov    0x8(%ebp),%eax
  803428:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	a3 38 51 80 00       	mov    %eax,0x805138
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343f:	a1 44 51 80 00       	mov    0x805144,%eax
  803444:	40                   	inc    %eax
  803445:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80344a:	e9 73 07 00 00       	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	8b 50 08             	mov    0x8(%eax),%edx
  803455:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80345a:	8b 40 08             	mov    0x8(%eax),%eax
  80345d:	39 c2                	cmp    %eax,%edx
  80345f:	0f 86 84 00 00 00    	jbe    8034e9 <insert_sorted_with_merge_freeList+0x134>
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	8b 50 08             	mov    0x8(%eax),%edx
  80346b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803470:	8b 48 0c             	mov    0xc(%eax),%ecx
  803473:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803478:	8b 40 08             	mov    0x8(%eax),%eax
  80347b:	01 c8                	add    %ecx,%eax
  80347d:	39 c2                	cmp    %eax,%edx
  80347f:	74 68                	je     8034e9 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803481:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803485:	75 17                	jne    80349e <insert_sorted_with_merge_freeList+0xe9>
  803487:	83 ec 04             	sub    $0x4,%esp
  80348a:	68 ac 47 80 00       	push   $0x8047ac
  80348f:	68 4c 01 00 00       	push   $0x14c
  803494:	68 93 47 80 00       	push   $0x804793
  803499:	e8 55 d9 ff ff       	call   800df3 <_panic>
  80349e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	89 50 04             	mov    %edx,0x4(%eax)
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	8b 40 04             	mov    0x4(%eax),%eax
  8034b0:	85 c0                	test   %eax,%eax
  8034b2:	74 0c                	je     8034c0 <insert_sorted_with_merge_freeList+0x10b>
  8034b4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034bc:	89 10                	mov    %edx,(%eax)
  8034be:	eb 08                	jmp    8034c8 <insert_sorted_with_merge_freeList+0x113>
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034de:	40                   	inc    %eax
  8034df:	a3 44 51 80 00       	mov    %eax,0x805144
  8034e4:	e9 d9 06 00 00       	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	8b 50 08             	mov    0x8(%eax),%edx
  8034ef:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034f4:	8b 40 08             	mov    0x8(%eax),%eax
  8034f7:	39 c2                	cmp    %eax,%edx
  8034f9:	0f 86 b5 00 00 00    	jbe    8035b4 <insert_sorted_with_merge_freeList+0x1ff>
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	8b 50 08             	mov    0x8(%eax),%edx
  803505:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80350a:	8b 48 0c             	mov    0xc(%eax),%ecx
  80350d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803512:	8b 40 08             	mov    0x8(%eax),%eax
  803515:	01 c8                	add    %ecx,%eax
  803517:	39 c2                	cmp    %eax,%edx
  803519:	0f 85 95 00 00 00    	jne    8035b4 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  80351f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803524:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80352a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80352d:	8b 55 08             	mov    0x8(%ebp),%edx
  803530:	8b 52 0c             	mov    0xc(%edx),%edx
  803533:	01 ca                	add    %ecx,%edx
  803535:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80354c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803550:	75 17                	jne    803569 <insert_sorted_with_merge_freeList+0x1b4>
  803552:	83 ec 04             	sub    $0x4,%esp
  803555:	68 70 47 80 00       	push   $0x804770
  80355a:	68 54 01 00 00       	push   $0x154
  80355f:	68 93 47 80 00       	push   $0x804793
  803564:	e8 8a d8 ff ff       	call   800df3 <_panic>
  803569:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	89 10                	mov    %edx,(%eax)
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	8b 00                	mov    (%eax),%eax
  803579:	85 c0                	test   %eax,%eax
  80357b:	74 0d                	je     80358a <insert_sorted_with_merge_freeList+0x1d5>
  80357d:	a1 48 51 80 00       	mov    0x805148,%eax
  803582:	8b 55 08             	mov    0x8(%ebp),%edx
  803585:	89 50 04             	mov    %edx,0x4(%eax)
  803588:	eb 08                	jmp    803592 <insert_sorted_with_merge_freeList+0x1dd>
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803592:	8b 45 08             	mov    0x8(%ebp),%eax
  803595:	a3 48 51 80 00       	mov    %eax,0x805148
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a9:	40                   	inc    %eax
  8035aa:	a3 54 51 80 00       	mov    %eax,0x805154
  8035af:	e9 0e 06 00 00       	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	8b 50 08             	mov    0x8(%eax),%edx
  8035ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8035bf:	8b 40 08             	mov    0x8(%eax),%eax
  8035c2:	39 c2                	cmp    %eax,%edx
  8035c4:	0f 83 c1 00 00 00    	jae    80368b <insert_sorted_with_merge_freeList+0x2d6>
  8035ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8035cf:	8b 50 08             	mov    0x8(%eax),%edx
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	8b 48 08             	mov    0x8(%eax),%ecx
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	8b 40 0c             	mov    0xc(%eax),%eax
  8035de:	01 c8                	add    %ecx,%eax
  8035e0:	39 c2                	cmp    %eax,%edx
  8035e2:	0f 85 a3 00 00 00    	jne    80368b <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8035e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8035ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f0:	8b 52 08             	mov    0x8(%edx),%edx
  8035f3:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8035f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8035fb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803601:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803604:	8b 55 08             	mov    0x8(%ebp),%edx
  803607:	8b 52 0c             	mov    0xc(%edx),%edx
  80360a:	01 ca                	add    %ecx,%edx
  80360c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803623:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803627:	75 17                	jne    803640 <insert_sorted_with_merge_freeList+0x28b>
  803629:	83 ec 04             	sub    $0x4,%esp
  80362c:	68 70 47 80 00       	push   $0x804770
  803631:	68 5d 01 00 00       	push   $0x15d
  803636:	68 93 47 80 00       	push   $0x804793
  80363b:	e8 b3 d7 ff ff       	call   800df3 <_panic>
  803640:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	89 10                	mov    %edx,(%eax)
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	8b 00                	mov    (%eax),%eax
  803650:	85 c0                	test   %eax,%eax
  803652:	74 0d                	je     803661 <insert_sorted_with_merge_freeList+0x2ac>
  803654:	a1 48 51 80 00       	mov    0x805148,%eax
  803659:	8b 55 08             	mov    0x8(%ebp),%edx
  80365c:	89 50 04             	mov    %edx,0x4(%eax)
  80365f:	eb 08                	jmp    803669 <insert_sorted_with_merge_freeList+0x2b4>
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	a3 48 51 80 00       	mov    %eax,0x805148
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367b:	a1 54 51 80 00       	mov    0x805154,%eax
  803680:	40                   	inc    %eax
  803681:	a3 54 51 80 00       	mov    %eax,0x805154
  803686:	e9 37 05 00 00       	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	8b 50 08             	mov    0x8(%eax),%edx
  803691:	a1 38 51 80 00       	mov    0x805138,%eax
  803696:	8b 40 08             	mov    0x8(%eax),%eax
  803699:	39 c2                	cmp    %eax,%edx
  80369b:	0f 83 82 00 00 00    	jae    803723 <insert_sorted_with_merge_freeList+0x36e>
  8036a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8036a6:	8b 50 08             	mov    0x8(%eax),%edx
  8036a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ac:	8b 48 08             	mov    0x8(%eax),%ecx
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b5:	01 c8                	add    %ecx,%eax
  8036b7:	39 c2                	cmp    %eax,%edx
  8036b9:	74 68                	je     803723 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8036bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036bf:	75 17                	jne    8036d8 <insert_sorted_with_merge_freeList+0x323>
  8036c1:	83 ec 04             	sub    $0x4,%esp
  8036c4:	68 70 47 80 00       	push   $0x804770
  8036c9:	68 62 01 00 00       	push   $0x162
  8036ce:	68 93 47 80 00       	push   $0x804793
  8036d3:	e8 1b d7 ff ff       	call   800df3 <_panic>
  8036d8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036de:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e1:	89 10                	mov    %edx,(%eax)
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	74 0d                	je     8036f9 <insert_sorted_with_merge_freeList+0x344>
  8036ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8036f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f4:	89 50 04             	mov    %edx,0x4(%eax)
  8036f7:	eb 08                	jmp    803701 <insert_sorted_with_merge_freeList+0x34c>
  8036f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803701:	8b 45 08             	mov    0x8(%ebp),%eax
  803704:	a3 38 51 80 00       	mov    %eax,0x805138
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803713:	a1 44 51 80 00       	mov    0x805144,%eax
  803718:	40                   	inc    %eax
  803719:	a3 44 51 80 00       	mov    %eax,0x805144
  80371e:	e9 9f 04 00 00       	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803723:	a1 38 51 80 00       	mov    0x805138,%eax
  803728:	8b 00                	mov    (%eax),%eax
  80372a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80372d:	e9 84 04 00 00       	jmp    803bb6 <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803735:	8b 50 08             	mov    0x8(%eax),%edx
  803738:	8b 45 08             	mov    0x8(%ebp),%eax
  80373b:	8b 40 08             	mov    0x8(%eax),%eax
  80373e:	39 c2                	cmp    %eax,%edx
  803740:	0f 86 a9 00 00 00    	jbe    8037ef <insert_sorted_with_merge_freeList+0x43a>
  803746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803749:	8b 50 08             	mov    0x8(%eax),%edx
  80374c:	8b 45 08             	mov    0x8(%ebp),%eax
  80374f:	8b 48 08             	mov    0x8(%eax),%ecx
  803752:	8b 45 08             	mov    0x8(%ebp),%eax
  803755:	8b 40 0c             	mov    0xc(%eax),%eax
  803758:	01 c8                	add    %ecx,%eax
  80375a:	39 c2                	cmp    %eax,%edx
  80375c:	0f 84 8d 00 00 00    	je     8037ef <insert_sorted_with_merge_freeList+0x43a>
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	8b 50 08             	mov    0x8(%eax),%edx
  803768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376b:	8b 40 04             	mov    0x4(%eax),%eax
  80376e:	8b 48 08             	mov    0x8(%eax),%ecx
  803771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803774:	8b 40 04             	mov    0x4(%eax),%eax
  803777:	8b 40 0c             	mov    0xc(%eax),%eax
  80377a:	01 c8                	add    %ecx,%eax
  80377c:	39 c2                	cmp    %eax,%edx
  80377e:	74 6f                	je     8037ef <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803784:	74 06                	je     80378c <insert_sorted_with_merge_freeList+0x3d7>
  803786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80378a:	75 17                	jne    8037a3 <insert_sorted_with_merge_freeList+0x3ee>
  80378c:	83 ec 04             	sub    $0x4,%esp
  80378f:	68 d0 47 80 00       	push   $0x8047d0
  803794:	68 6b 01 00 00       	push   $0x16b
  803799:	68 93 47 80 00       	push   $0x804793
  80379e:	e8 50 d6 ff ff       	call   800df3 <_panic>
  8037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a6:	8b 50 04             	mov    0x4(%eax),%edx
  8037a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ac:	89 50 04             	mov    %edx,0x4(%eax)
  8037af:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037b5:	89 10                	mov    %edx,(%eax)
  8037b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ba:	8b 40 04             	mov    0x4(%eax),%eax
  8037bd:	85 c0                	test   %eax,%eax
  8037bf:	74 0d                	je     8037ce <insert_sorted_with_merge_freeList+0x419>
  8037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c4:	8b 40 04             	mov    0x4(%eax),%eax
  8037c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ca:	89 10                	mov    %edx,(%eax)
  8037cc:	eb 08                	jmp    8037d6 <insert_sorted_with_merge_freeList+0x421>
  8037ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8037dc:	89 50 04             	mov    %edx,0x4(%eax)
  8037df:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e4:	40                   	inc    %eax
  8037e5:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8037ea:	e9 d3 03 00 00       	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8037ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f2:	8b 50 08             	mov    0x8(%eax),%edx
  8037f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f8:	8b 40 08             	mov    0x8(%eax),%eax
  8037fb:	39 c2                	cmp    %eax,%edx
  8037fd:	0f 86 da 00 00 00    	jbe    8038dd <insert_sorted_with_merge_freeList+0x528>
  803803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803806:	8b 50 08             	mov    0x8(%eax),%edx
  803809:	8b 45 08             	mov    0x8(%ebp),%eax
  80380c:	8b 48 08             	mov    0x8(%eax),%ecx
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	8b 40 0c             	mov    0xc(%eax),%eax
  803815:	01 c8                	add    %ecx,%eax
  803817:	39 c2                	cmp    %eax,%edx
  803819:	0f 85 be 00 00 00    	jne    8038dd <insert_sorted_with_merge_freeList+0x528>
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	8b 50 08             	mov    0x8(%eax),%edx
  803825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803828:	8b 40 04             	mov    0x4(%eax),%eax
  80382b:	8b 48 08             	mov    0x8(%eax),%ecx
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	8b 40 04             	mov    0x4(%eax),%eax
  803834:	8b 40 0c             	mov    0xc(%eax),%eax
  803837:	01 c8                	add    %ecx,%eax
  803839:	39 c2                	cmp    %eax,%edx
  80383b:	0f 84 9c 00 00 00    	je     8038dd <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803841:	8b 45 08             	mov    0x8(%ebp),%eax
  803844:	8b 50 08             	mov    0x8(%eax),%edx
  803847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384a:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 50 0c             	mov    0xc(%eax),%edx
  803853:	8b 45 08             	mov    0x8(%ebp),%eax
  803856:	8b 40 0c             	mov    0xc(%eax),%eax
  803859:	01 c2                	add    %eax,%edx
  80385b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385e:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803861:	8b 45 08             	mov    0x8(%ebp),%eax
  803864:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803875:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803879:	75 17                	jne    803892 <insert_sorted_with_merge_freeList+0x4dd>
  80387b:	83 ec 04             	sub    $0x4,%esp
  80387e:	68 70 47 80 00       	push   $0x804770
  803883:	68 74 01 00 00       	push   $0x174
  803888:	68 93 47 80 00       	push   $0x804793
  80388d:	e8 61 d5 ff ff       	call   800df3 <_panic>
  803892:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	89 10                	mov    %edx,(%eax)
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	8b 00                	mov    (%eax),%eax
  8038a2:	85 c0                	test   %eax,%eax
  8038a4:	74 0d                	je     8038b3 <insert_sorted_with_merge_freeList+0x4fe>
  8038a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8038ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ae:	89 50 04             	mov    %edx,0x4(%eax)
  8038b1:	eb 08                	jmp    8038bb <insert_sorted_with_merge_freeList+0x506>
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038be:	a3 48 51 80 00       	mov    %eax,0x805148
  8038c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8038d2:	40                   	inc    %eax
  8038d3:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8038d8:	e9 e5 02 00 00       	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8038dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e0:	8b 50 08             	mov    0x8(%eax),%edx
  8038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e6:	8b 40 08             	mov    0x8(%eax),%eax
  8038e9:	39 c2                	cmp    %eax,%edx
  8038eb:	0f 86 d7 00 00 00    	jbe    8039c8 <insert_sorted_with_merge_freeList+0x613>
  8038f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f4:	8b 50 08             	mov    0x8(%eax),%edx
  8038f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fa:	8b 48 08             	mov    0x8(%eax),%ecx
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	8b 40 0c             	mov    0xc(%eax),%eax
  803903:	01 c8                	add    %ecx,%eax
  803905:	39 c2                	cmp    %eax,%edx
  803907:	0f 84 bb 00 00 00    	je     8039c8 <insert_sorted_with_merge_freeList+0x613>
  80390d:	8b 45 08             	mov    0x8(%ebp),%eax
  803910:	8b 50 08             	mov    0x8(%eax),%edx
  803913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803916:	8b 40 04             	mov    0x4(%eax),%eax
  803919:	8b 48 08             	mov    0x8(%eax),%ecx
  80391c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391f:	8b 40 04             	mov    0x4(%eax),%eax
  803922:	8b 40 0c             	mov    0xc(%eax),%eax
  803925:	01 c8                	add    %ecx,%eax
  803927:	39 c2                	cmp    %eax,%edx
  803929:	0f 85 99 00 00 00    	jne    8039c8 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  80392f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803932:	8b 40 04             	mov    0x4(%eax),%eax
  803935:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393b:	8b 50 0c             	mov    0xc(%eax),%edx
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	8b 40 0c             	mov    0xc(%eax),%eax
  803944:	01 c2                	add    %eax,%edx
  803946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803949:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803956:	8b 45 08             	mov    0x8(%ebp),%eax
  803959:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803960:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803964:	75 17                	jne    80397d <insert_sorted_with_merge_freeList+0x5c8>
  803966:	83 ec 04             	sub    $0x4,%esp
  803969:	68 70 47 80 00       	push   $0x804770
  80396e:	68 7d 01 00 00       	push   $0x17d
  803973:	68 93 47 80 00       	push   $0x804793
  803978:	e8 76 d4 ff ff       	call   800df3 <_panic>
  80397d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803983:	8b 45 08             	mov    0x8(%ebp),%eax
  803986:	89 10                	mov    %edx,(%eax)
  803988:	8b 45 08             	mov    0x8(%ebp),%eax
  80398b:	8b 00                	mov    (%eax),%eax
  80398d:	85 c0                	test   %eax,%eax
  80398f:	74 0d                	je     80399e <insert_sorted_with_merge_freeList+0x5e9>
  803991:	a1 48 51 80 00       	mov    0x805148,%eax
  803996:	8b 55 08             	mov    0x8(%ebp),%edx
  803999:	89 50 04             	mov    %edx,0x4(%eax)
  80399c:	eb 08                	jmp    8039a6 <insert_sorted_with_merge_freeList+0x5f1>
  80399e:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8039ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8039bd:	40                   	inc    %eax
  8039be:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8039c3:	e9 fa 01 00 00       	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8039c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cb:	8b 50 08             	mov    0x8(%eax),%edx
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	8b 40 08             	mov    0x8(%eax),%eax
  8039d4:	39 c2                	cmp    %eax,%edx
  8039d6:	0f 86 d2 01 00 00    	jbe    803bae <insert_sorted_with_merge_freeList+0x7f9>
  8039dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039df:	8b 50 08             	mov    0x8(%eax),%edx
  8039e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e5:	8b 48 08             	mov    0x8(%eax),%ecx
  8039e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ee:	01 c8                	add    %ecx,%eax
  8039f0:	39 c2                	cmp    %eax,%edx
  8039f2:	0f 85 b6 01 00 00    	jne    803bae <insert_sorted_with_merge_freeList+0x7f9>
  8039f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fb:	8b 50 08             	mov    0x8(%eax),%edx
  8039fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a01:	8b 40 04             	mov    0x4(%eax),%eax
  803a04:	8b 48 08             	mov    0x8(%eax),%ecx
  803a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0a:	8b 40 04             	mov    0x4(%eax),%eax
  803a0d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a10:	01 c8                	add    %ecx,%eax
  803a12:	39 c2                	cmp    %eax,%edx
  803a14:	0f 85 94 01 00 00    	jne    803bae <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1d:	8b 40 04             	mov    0x4(%eax),%eax
  803a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a23:	8b 52 04             	mov    0x4(%edx),%edx
  803a26:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803a29:	8b 55 08             	mov    0x8(%ebp),%edx
  803a2c:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a32:	8b 52 0c             	mov    0xc(%edx),%edx
  803a35:	01 da                	add    %ebx,%edx
  803a37:	01 ca                	add    %ecx,%edx
  803a39:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a54:	75 17                	jne    803a6d <insert_sorted_with_merge_freeList+0x6b8>
  803a56:	83 ec 04             	sub    $0x4,%esp
  803a59:	68 05 48 80 00       	push   $0x804805
  803a5e:	68 86 01 00 00       	push   $0x186
  803a63:	68 93 47 80 00       	push   $0x804793
  803a68:	e8 86 d3 ff ff       	call   800df3 <_panic>
  803a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a70:	8b 00                	mov    (%eax),%eax
  803a72:	85 c0                	test   %eax,%eax
  803a74:	74 10                	je     803a86 <insert_sorted_with_merge_freeList+0x6d1>
  803a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a7e:	8b 52 04             	mov    0x4(%edx),%edx
  803a81:	89 50 04             	mov    %edx,0x4(%eax)
  803a84:	eb 0b                	jmp    803a91 <insert_sorted_with_merge_freeList+0x6dc>
  803a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a89:	8b 40 04             	mov    0x4(%eax),%eax
  803a8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a94:	8b 40 04             	mov    0x4(%eax),%eax
  803a97:	85 c0                	test   %eax,%eax
  803a99:	74 0f                	je     803aaa <insert_sorted_with_merge_freeList+0x6f5>
  803a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9e:	8b 40 04             	mov    0x4(%eax),%eax
  803aa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aa4:	8b 12                	mov    (%edx),%edx
  803aa6:	89 10                	mov    %edx,(%eax)
  803aa8:	eb 0a                	jmp    803ab4 <insert_sorted_with_merge_freeList+0x6ff>
  803aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aad:	8b 00                	mov    (%eax),%eax
  803aaf:	a3 38 51 80 00       	mov    %eax,0x805138
  803ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ac7:	a1 44 51 80 00       	mov    0x805144,%eax
  803acc:	48                   	dec    %eax
  803acd:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ad6:	75 17                	jne    803aef <insert_sorted_with_merge_freeList+0x73a>
  803ad8:	83 ec 04             	sub    $0x4,%esp
  803adb:	68 70 47 80 00       	push   $0x804770
  803ae0:	68 87 01 00 00       	push   $0x187
  803ae5:	68 93 47 80 00       	push   $0x804793
  803aea:	e8 04 d3 ff ff       	call   800df3 <_panic>
  803aef:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af8:	89 10                	mov    %edx,(%eax)
  803afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afd:	8b 00                	mov    (%eax),%eax
  803aff:	85 c0                	test   %eax,%eax
  803b01:	74 0d                	je     803b10 <insert_sorted_with_merge_freeList+0x75b>
  803b03:	a1 48 51 80 00       	mov    0x805148,%eax
  803b08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b0b:	89 50 04             	mov    %edx,0x4(%eax)
  803b0e:	eb 08                	jmp    803b18 <insert_sorted_with_merge_freeList+0x763>
  803b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b13:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1b:	a3 48 51 80 00       	mov    %eax,0x805148
  803b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2a:	a1 54 51 80 00       	mov    0x805154,%eax
  803b2f:	40                   	inc    %eax
  803b30:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803b35:	8b 45 08             	mov    0x8(%ebp),%eax
  803b38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b4d:	75 17                	jne    803b66 <insert_sorted_with_merge_freeList+0x7b1>
  803b4f:	83 ec 04             	sub    $0x4,%esp
  803b52:	68 70 47 80 00       	push   $0x804770
  803b57:	68 8a 01 00 00       	push   $0x18a
  803b5c:	68 93 47 80 00       	push   $0x804793
  803b61:	e8 8d d2 ff ff       	call   800df3 <_panic>
  803b66:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6f:	89 10                	mov    %edx,(%eax)
  803b71:	8b 45 08             	mov    0x8(%ebp),%eax
  803b74:	8b 00                	mov    (%eax),%eax
  803b76:	85 c0                	test   %eax,%eax
  803b78:	74 0d                	je     803b87 <insert_sorted_with_merge_freeList+0x7d2>
  803b7a:	a1 48 51 80 00       	mov    0x805148,%eax
  803b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  803b82:	89 50 04             	mov    %edx,0x4(%eax)
  803b85:	eb 08                	jmp    803b8f <insert_sorted_with_merge_freeList+0x7da>
  803b87:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b92:	a3 48 51 80 00       	mov    %eax,0x805148
  803b97:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ba1:	a1 54 51 80 00       	mov    0x805154,%eax
  803ba6:	40                   	inc    %eax
  803ba7:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803bac:	eb 14                	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb1:	8b 00                	mov    (%eax),%eax
  803bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bba:	0f 85 72 fb ff ff    	jne    803732 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803bc0:	eb 00                	jmp    803bc2 <insert_sorted_with_merge_freeList+0x80d>
  803bc2:	90                   	nop
  803bc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803bc6:	c9                   	leave  
  803bc7:	c3                   	ret    

00803bc8 <__udivdi3>:
  803bc8:	55                   	push   %ebp
  803bc9:	57                   	push   %edi
  803bca:	56                   	push   %esi
  803bcb:	53                   	push   %ebx
  803bcc:	83 ec 1c             	sub    $0x1c,%esp
  803bcf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bd3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bdb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bdf:	89 ca                	mov    %ecx,%edx
  803be1:	89 f8                	mov    %edi,%eax
  803be3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803be7:	85 f6                	test   %esi,%esi
  803be9:	75 2d                	jne    803c18 <__udivdi3+0x50>
  803beb:	39 cf                	cmp    %ecx,%edi
  803bed:	77 65                	ja     803c54 <__udivdi3+0x8c>
  803bef:	89 fd                	mov    %edi,%ebp
  803bf1:	85 ff                	test   %edi,%edi
  803bf3:	75 0b                	jne    803c00 <__udivdi3+0x38>
  803bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  803bfa:	31 d2                	xor    %edx,%edx
  803bfc:	f7 f7                	div    %edi
  803bfe:	89 c5                	mov    %eax,%ebp
  803c00:	31 d2                	xor    %edx,%edx
  803c02:	89 c8                	mov    %ecx,%eax
  803c04:	f7 f5                	div    %ebp
  803c06:	89 c1                	mov    %eax,%ecx
  803c08:	89 d8                	mov    %ebx,%eax
  803c0a:	f7 f5                	div    %ebp
  803c0c:	89 cf                	mov    %ecx,%edi
  803c0e:	89 fa                	mov    %edi,%edx
  803c10:	83 c4 1c             	add    $0x1c,%esp
  803c13:	5b                   	pop    %ebx
  803c14:	5e                   	pop    %esi
  803c15:	5f                   	pop    %edi
  803c16:	5d                   	pop    %ebp
  803c17:	c3                   	ret    
  803c18:	39 ce                	cmp    %ecx,%esi
  803c1a:	77 28                	ja     803c44 <__udivdi3+0x7c>
  803c1c:	0f bd fe             	bsr    %esi,%edi
  803c1f:	83 f7 1f             	xor    $0x1f,%edi
  803c22:	75 40                	jne    803c64 <__udivdi3+0x9c>
  803c24:	39 ce                	cmp    %ecx,%esi
  803c26:	72 0a                	jb     803c32 <__udivdi3+0x6a>
  803c28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c2c:	0f 87 9e 00 00 00    	ja     803cd0 <__udivdi3+0x108>
  803c32:	b8 01 00 00 00       	mov    $0x1,%eax
  803c37:	89 fa                	mov    %edi,%edx
  803c39:	83 c4 1c             	add    $0x1c,%esp
  803c3c:	5b                   	pop    %ebx
  803c3d:	5e                   	pop    %esi
  803c3e:	5f                   	pop    %edi
  803c3f:	5d                   	pop    %ebp
  803c40:	c3                   	ret    
  803c41:	8d 76 00             	lea    0x0(%esi),%esi
  803c44:	31 ff                	xor    %edi,%edi
  803c46:	31 c0                	xor    %eax,%eax
  803c48:	89 fa                	mov    %edi,%edx
  803c4a:	83 c4 1c             	add    $0x1c,%esp
  803c4d:	5b                   	pop    %ebx
  803c4e:	5e                   	pop    %esi
  803c4f:	5f                   	pop    %edi
  803c50:	5d                   	pop    %ebp
  803c51:	c3                   	ret    
  803c52:	66 90                	xchg   %ax,%ax
  803c54:	89 d8                	mov    %ebx,%eax
  803c56:	f7 f7                	div    %edi
  803c58:	31 ff                	xor    %edi,%edi
  803c5a:	89 fa                	mov    %edi,%edx
  803c5c:	83 c4 1c             	add    $0x1c,%esp
  803c5f:	5b                   	pop    %ebx
  803c60:	5e                   	pop    %esi
  803c61:	5f                   	pop    %edi
  803c62:	5d                   	pop    %ebp
  803c63:	c3                   	ret    
  803c64:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c69:	89 eb                	mov    %ebp,%ebx
  803c6b:	29 fb                	sub    %edi,%ebx
  803c6d:	89 f9                	mov    %edi,%ecx
  803c6f:	d3 e6                	shl    %cl,%esi
  803c71:	89 c5                	mov    %eax,%ebp
  803c73:	88 d9                	mov    %bl,%cl
  803c75:	d3 ed                	shr    %cl,%ebp
  803c77:	89 e9                	mov    %ebp,%ecx
  803c79:	09 f1                	or     %esi,%ecx
  803c7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c7f:	89 f9                	mov    %edi,%ecx
  803c81:	d3 e0                	shl    %cl,%eax
  803c83:	89 c5                	mov    %eax,%ebp
  803c85:	89 d6                	mov    %edx,%esi
  803c87:	88 d9                	mov    %bl,%cl
  803c89:	d3 ee                	shr    %cl,%esi
  803c8b:	89 f9                	mov    %edi,%ecx
  803c8d:	d3 e2                	shl    %cl,%edx
  803c8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c93:	88 d9                	mov    %bl,%cl
  803c95:	d3 e8                	shr    %cl,%eax
  803c97:	09 c2                	or     %eax,%edx
  803c99:	89 d0                	mov    %edx,%eax
  803c9b:	89 f2                	mov    %esi,%edx
  803c9d:	f7 74 24 0c          	divl   0xc(%esp)
  803ca1:	89 d6                	mov    %edx,%esi
  803ca3:	89 c3                	mov    %eax,%ebx
  803ca5:	f7 e5                	mul    %ebp
  803ca7:	39 d6                	cmp    %edx,%esi
  803ca9:	72 19                	jb     803cc4 <__udivdi3+0xfc>
  803cab:	74 0b                	je     803cb8 <__udivdi3+0xf0>
  803cad:	89 d8                	mov    %ebx,%eax
  803caf:	31 ff                	xor    %edi,%edi
  803cb1:	e9 58 ff ff ff       	jmp    803c0e <__udivdi3+0x46>
  803cb6:	66 90                	xchg   %ax,%ax
  803cb8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cbc:	89 f9                	mov    %edi,%ecx
  803cbe:	d3 e2                	shl    %cl,%edx
  803cc0:	39 c2                	cmp    %eax,%edx
  803cc2:	73 e9                	jae    803cad <__udivdi3+0xe5>
  803cc4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cc7:	31 ff                	xor    %edi,%edi
  803cc9:	e9 40 ff ff ff       	jmp    803c0e <__udivdi3+0x46>
  803cce:	66 90                	xchg   %ax,%ax
  803cd0:	31 c0                	xor    %eax,%eax
  803cd2:	e9 37 ff ff ff       	jmp    803c0e <__udivdi3+0x46>
  803cd7:	90                   	nop

00803cd8 <__umoddi3>:
  803cd8:	55                   	push   %ebp
  803cd9:	57                   	push   %edi
  803cda:	56                   	push   %esi
  803cdb:	53                   	push   %ebx
  803cdc:	83 ec 1c             	sub    $0x1c,%esp
  803cdf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ce3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ce7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ceb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cf3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cf7:	89 f3                	mov    %esi,%ebx
  803cf9:	89 fa                	mov    %edi,%edx
  803cfb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cff:	89 34 24             	mov    %esi,(%esp)
  803d02:	85 c0                	test   %eax,%eax
  803d04:	75 1a                	jne    803d20 <__umoddi3+0x48>
  803d06:	39 f7                	cmp    %esi,%edi
  803d08:	0f 86 a2 00 00 00    	jbe    803db0 <__umoddi3+0xd8>
  803d0e:	89 c8                	mov    %ecx,%eax
  803d10:	89 f2                	mov    %esi,%edx
  803d12:	f7 f7                	div    %edi
  803d14:	89 d0                	mov    %edx,%eax
  803d16:	31 d2                	xor    %edx,%edx
  803d18:	83 c4 1c             	add    $0x1c,%esp
  803d1b:	5b                   	pop    %ebx
  803d1c:	5e                   	pop    %esi
  803d1d:	5f                   	pop    %edi
  803d1e:	5d                   	pop    %ebp
  803d1f:	c3                   	ret    
  803d20:	39 f0                	cmp    %esi,%eax
  803d22:	0f 87 ac 00 00 00    	ja     803dd4 <__umoddi3+0xfc>
  803d28:	0f bd e8             	bsr    %eax,%ebp
  803d2b:	83 f5 1f             	xor    $0x1f,%ebp
  803d2e:	0f 84 ac 00 00 00    	je     803de0 <__umoddi3+0x108>
  803d34:	bf 20 00 00 00       	mov    $0x20,%edi
  803d39:	29 ef                	sub    %ebp,%edi
  803d3b:	89 fe                	mov    %edi,%esi
  803d3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d41:	89 e9                	mov    %ebp,%ecx
  803d43:	d3 e0                	shl    %cl,%eax
  803d45:	89 d7                	mov    %edx,%edi
  803d47:	89 f1                	mov    %esi,%ecx
  803d49:	d3 ef                	shr    %cl,%edi
  803d4b:	09 c7                	or     %eax,%edi
  803d4d:	89 e9                	mov    %ebp,%ecx
  803d4f:	d3 e2                	shl    %cl,%edx
  803d51:	89 14 24             	mov    %edx,(%esp)
  803d54:	89 d8                	mov    %ebx,%eax
  803d56:	d3 e0                	shl    %cl,%eax
  803d58:	89 c2                	mov    %eax,%edx
  803d5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d5e:	d3 e0                	shl    %cl,%eax
  803d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d64:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d68:	89 f1                	mov    %esi,%ecx
  803d6a:	d3 e8                	shr    %cl,%eax
  803d6c:	09 d0                	or     %edx,%eax
  803d6e:	d3 eb                	shr    %cl,%ebx
  803d70:	89 da                	mov    %ebx,%edx
  803d72:	f7 f7                	div    %edi
  803d74:	89 d3                	mov    %edx,%ebx
  803d76:	f7 24 24             	mull   (%esp)
  803d79:	89 c6                	mov    %eax,%esi
  803d7b:	89 d1                	mov    %edx,%ecx
  803d7d:	39 d3                	cmp    %edx,%ebx
  803d7f:	0f 82 87 00 00 00    	jb     803e0c <__umoddi3+0x134>
  803d85:	0f 84 91 00 00 00    	je     803e1c <__umoddi3+0x144>
  803d8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d8f:	29 f2                	sub    %esi,%edx
  803d91:	19 cb                	sbb    %ecx,%ebx
  803d93:	89 d8                	mov    %ebx,%eax
  803d95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d99:	d3 e0                	shl    %cl,%eax
  803d9b:	89 e9                	mov    %ebp,%ecx
  803d9d:	d3 ea                	shr    %cl,%edx
  803d9f:	09 d0                	or     %edx,%eax
  803da1:	89 e9                	mov    %ebp,%ecx
  803da3:	d3 eb                	shr    %cl,%ebx
  803da5:	89 da                	mov    %ebx,%edx
  803da7:	83 c4 1c             	add    $0x1c,%esp
  803daa:	5b                   	pop    %ebx
  803dab:	5e                   	pop    %esi
  803dac:	5f                   	pop    %edi
  803dad:	5d                   	pop    %ebp
  803dae:	c3                   	ret    
  803daf:	90                   	nop
  803db0:	89 fd                	mov    %edi,%ebp
  803db2:	85 ff                	test   %edi,%edi
  803db4:	75 0b                	jne    803dc1 <__umoddi3+0xe9>
  803db6:	b8 01 00 00 00       	mov    $0x1,%eax
  803dbb:	31 d2                	xor    %edx,%edx
  803dbd:	f7 f7                	div    %edi
  803dbf:	89 c5                	mov    %eax,%ebp
  803dc1:	89 f0                	mov    %esi,%eax
  803dc3:	31 d2                	xor    %edx,%edx
  803dc5:	f7 f5                	div    %ebp
  803dc7:	89 c8                	mov    %ecx,%eax
  803dc9:	f7 f5                	div    %ebp
  803dcb:	89 d0                	mov    %edx,%eax
  803dcd:	e9 44 ff ff ff       	jmp    803d16 <__umoddi3+0x3e>
  803dd2:	66 90                	xchg   %ax,%ax
  803dd4:	89 c8                	mov    %ecx,%eax
  803dd6:	89 f2                	mov    %esi,%edx
  803dd8:	83 c4 1c             	add    $0x1c,%esp
  803ddb:	5b                   	pop    %ebx
  803ddc:	5e                   	pop    %esi
  803ddd:	5f                   	pop    %edi
  803dde:	5d                   	pop    %ebp
  803ddf:	c3                   	ret    
  803de0:	3b 04 24             	cmp    (%esp),%eax
  803de3:	72 06                	jb     803deb <__umoddi3+0x113>
  803de5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803de9:	77 0f                	ja     803dfa <__umoddi3+0x122>
  803deb:	89 f2                	mov    %esi,%edx
  803ded:	29 f9                	sub    %edi,%ecx
  803def:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803df3:	89 14 24             	mov    %edx,(%esp)
  803df6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dfa:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dfe:	8b 14 24             	mov    (%esp),%edx
  803e01:	83 c4 1c             	add    $0x1c,%esp
  803e04:	5b                   	pop    %ebx
  803e05:	5e                   	pop    %esi
  803e06:	5f                   	pop    %edi
  803e07:	5d                   	pop    %ebp
  803e08:	c3                   	ret    
  803e09:	8d 76 00             	lea    0x0(%esi),%esi
  803e0c:	2b 04 24             	sub    (%esp),%eax
  803e0f:	19 fa                	sbb    %edi,%edx
  803e11:	89 d1                	mov    %edx,%ecx
  803e13:	89 c6                	mov    %eax,%esi
  803e15:	e9 71 ff ff ff       	jmp    803d8b <__umoddi3+0xb3>
  803e1a:	66 90                	xchg   %ax,%ax
  803e1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e20:	72 ea                	jb     803e0c <__umoddi3+0x134>
  803e22:	89 d9                	mov    %ebx,%ecx
  803e24:	e9 62 ff ff ff       	jmp    803d8b <__umoddi3+0xb3>
