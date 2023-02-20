
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 b6 0b 00 00       	call   800bec <libmain>
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
	int Mega = 1024*1024;
  800043:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80004a:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 03                	push   $0x3
  800056:	e8 4a 28 00 00       	call   8028a5 <sys_set_uheap_strategy>
  80005b:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80005e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800069:	eb 29                	jmp    800094 <_main+0x5c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80006b:	a1 20 50 80 00       	mov    0x805020,%eax
  800070:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800079:	89 d0                	mov    %edx,%eax
  80007b:	01 c0                	add    %eax,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 c8                	add    %ecx,%eax
  800084:	8a 40 04             	mov    0x4(%eax),%al
  800087:	84 c0                	test   %al,%al
  800089:	74 06                	je     800091 <_main+0x59>
			{
				fullWS = 0;
  80008b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80008f:	eb 12                	jmp    8000a3 <_main+0x6b>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800091:	ff 45 f0             	incl   -0x10(%ebp)
  800094:	a1 20 50 80 00       	mov    0x805020,%eax
  800099:	8b 50 74             	mov    0x74(%eax),%edx
  80009c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 c8                	ja     80006b <_main+0x33>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000a3:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000a7:	74 14                	je     8000bd <_main+0x85>
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	68 80 3d 80 00       	push   $0x803d80
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 9c 3d 80 00       	push   $0x803d9c
  8000b8:	e8 6b 0c 00 00       	call   800d28 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 65 1e 00 00       	call   801f2c <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	f7 f7                	div    %edi
  8000dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000e0:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  8000e7:	74 16                	je     8000ff <_main+0xc7>
  8000e9:	68 af 3d 80 00       	push   $0x803daf
  8000ee:	68 c6 3d 80 00       	push   $0x803dc6
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 9c 3d 80 00       	push   $0x803d9c
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 9c 27 00 00       	call   8028a5 <sys_set_uheap_strategy>
  800109:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80010c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800117:	eb 29                	jmp    800142 <_main+0x10a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800119:	a1 20 50 80 00       	mov    0x805020,%eax
  80011e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	01 c0                	add    %eax,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 c8                	add    %ecx,%eax
  800132:	8a 40 04             	mov    0x4(%eax),%al
  800135:	84 c0                	test   %al,%al
  800137:	74 06                	je     80013f <_main+0x107>
			{
				fullWS = 0;
  800139:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80013d:	eb 12                	jmp    800151 <_main+0x119>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80013f:	ff 45 e8             	incl   -0x18(%ebp)
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 50 74             	mov    0x74(%eax),%edx
  80014a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	77 c8                	ja     800119 <_main+0xe1>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 80 3d 80 00       	push   $0x803d80
  80015f:	6a 32                	push   $0x32
  800161:	68 9c 3d 80 00       	push   $0x803d9c
  800166:	e8 bd 0b 00 00       	call   800d28 <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80016b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800172:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800187:	eb 26                	jmp    8001af <_main+0x177>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  800189:	a1 20 50 80 00       	mov    0x805020,%eax
  80018e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800197:	89 d0                	mov    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	8a 40 04             	mov    0x4(%eax),%al
  8001a5:	3c 01                	cmp    $0x1,%al
  8001a7:	75 03                	jne    8001ac <_main+0x174>
			numOfEmptyWSLocs++;
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8001ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8001af:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b4:	8b 50 74             	mov    0x74(%eax),%edx
  8001b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ba:	39 c2                	cmp    %eax,%edx
  8001bc:	77 cb                	ja     800189 <_main+0x151>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c4:	7d 14                	jge    8001da <_main+0x1a2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 dc 3d 80 00       	push   $0x803ddc
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 9c 3d 80 00       	push   $0x803d9c
  8001d5:	e8 4e 0b 00 00       	call   800d28 <_panic>


	void* ptr_allocations[512] = {0};
  8001da:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  8001e0:	b9 00 02 00 00       	mov    $0x200,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 2c 3e 80 00       	push   $0x803e2c
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 8d 21 00 00       	call   802390 <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 25 22 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	eb 20                	jmp    800237 <_main+0x1ff>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	e8 07 1d 00 00       	call   801f2c <malloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022d:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800234:	ff 45 dc             	incl   -0x24(%ebp)
  800237:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80023e:	7e d7                	jle    800217 <_main+0x1df>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800240:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800246:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80024b:	75 5b                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80024d:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800253:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800258:	75 4e                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80025a:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800260:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800265:	75 41                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800267:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026d:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800272:	75 34                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800274:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  80027a:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80027f:	75 27                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800281:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800287:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80028c:	75 1a                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80028e:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800294:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800299:	75 0d                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029b:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8002a1:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002a6:	74 14                	je     8002bc <_main+0x284>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	68 7c 3e 80 00       	push   $0x803e7c
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 9c 3d 80 00       	push   $0x803d9c
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 6f 21 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8002c1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002c4:	89 c2                	mov    %eax,%edx
  8002c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c9:	c1 e0 09             	shl    $0x9,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	79 05                	jns    8002d5 <_main+0x29d>
  8002d0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d5:	c1 f8 0c             	sar    $0xc,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 ba 3e 80 00       	push   $0x803eba
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 9c 3d 80 00       	push   $0x803d9c
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 98 20 00 00       	call   802390 <sys_calculate_free_frames>
  8002f8:	29 c3                	sub    %eax,%ebx
  8002fa:	89 da                	mov    %ebx,%edx
  8002fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ff:	c1 e0 09             	shl    $0x9,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	79 05                	jns    80030b <_main+0x2d3>
  800306:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030b:	c1 f8 16             	sar    $0x16,%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 d7 3e 80 00       	push   $0x803ed7
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 9c 3d 80 00       	push   $0x803d9c
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 65 20 00 00       	call   802390 <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 fd 20 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 72 1c 00 00       	call   801fb7 <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 60 1c 00 00       	call   801fb7 <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 4e 1c 00 00       	call   801fb7 <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 3c 1c 00 00       	call   801fb7 <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 2a 1c 00 00       	call   801fb7 <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 18 1c 00 00       	call   801fb7 <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 06 1c 00 00       	call   801fb7 <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 f4 1b 00 00       	call   801fb7 <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 e2 1b 00 00       	call   801fb7 <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 d0 1b 00 00       	call   801fb7 <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 41 20 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8003ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	29 c1                	sub    %eax,%ecx
  8003f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	c1 e0 02             	shl    $0x2,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 02             	shl    $0x2,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	79 05                	jns    80040c <_main+0x3d4>
  800407:	05 ff 0f 00 00       	add    $0xfff,%eax
  80040c:	c1 f8 0c             	sar    $0xc,%eax
  80040f:	39 c1                	cmp    %eax,%ecx
  800411:	74 14                	je     800427 <_main+0x3ef>
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 e8 3e 80 00       	push   $0x803ee8
  80041b:	6a 70                	push   $0x70
  80041d:	68 9c 3d 80 00       	push   $0x803d9c
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 64 1f 00 00       	call   802390 <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 24 3f 80 00       	push   $0x803f24
  80043d:	6a 71                	push   $0x71
  80043f:	68 9c 3d 80 00       	push   $0x803d9c
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 42 1f 00 00       	call   802390 <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 da 1f 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 c4 1a 00 00       	call   801f2c <malloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  80046e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800471:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
		panic("Next Fit not working correctly");
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 64 3f 80 00       	push   $0x803f64
  800480:	6a 79                	push   $0x79
  800482:	68 9c 3d 80 00       	push   $0x803d9c
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 9f 1f 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800491:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800494:	89 c2                	mov    %eax,%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	79 05                	jns    8004a2 <_main+0x46a>
  80049d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004a2:	c1 f8 0c             	sar    $0xc,%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 ba 3e 80 00       	push   $0x803eba
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 9c 3d 80 00       	push   $0x803d9c
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 ce 1e 00 00       	call   802390 <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 d7 3e 80 00       	push   $0x803ed7
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 9c 3d 80 00       	push   $0x803d9c
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 ac 1e 00 00       	call   802390 <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 44 1f 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  8004ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	50                   	push   %eax
  8004f6:	e8 31 1a 00 00       	call   801f2c <malloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80100000)
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800509:	74 17                	je     800522 <_main+0x4ea>
		panic("Next Fit not working correctly");
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 64 3f 80 00       	push   $0x803f64
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 9c 3d 80 00       	push   $0x803d9c
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 09 1f 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800527:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	79 05                	jns    80053b <_main+0x503>
  800536:	05 ff 0f 00 00       	add    $0xfff,%eax
  80053b:	c1 f8 0c             	sar    $0xc,%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 17                	je     800559 <_main+0x521>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 ba 3e 80 00       	push   $0x803eba
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 9c 3d 80 00       	push   $0x803d9c
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 32 1e 00 00       	call   802390 <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 d7 3e 80 00       	push   $0x803ed7
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 9c 3d 80 00       	push   $0x803d9c
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 0d 1e 00 00       	call   802390 <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 a5 1e 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  80058b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80058e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	c1 e0 02             	shl    $0x2,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	e8 8b 19 00 00       	call   801f2c <malloc>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8005a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005aa:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8005af:	74 17                	je     8005c8 <_main+0x590>
		panic("Next Fit not working correctly");
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 64 3f 80 00       	push   $0x803f64
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 9c 3d 80 00       	push   $0x803d9c
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 63 1e 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8005cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d0:	89 c1                	mov    %eax,%ecx
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e0 02             	shl    $0x2,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	79 05                	jns    8005e5 <_main+0x5ad>
  8005e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e5:	c1 f8 0c             	sar    $0xc,%eax
  8005e8:	39 c1                	cmp    %eax,%ecx
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 ba 3e 80 00       	push   $0x803eba
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 9c 3d 80 00       	push   $0x803d9c
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 88 1d 00 00       	call   802390 <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 d7 3e 80 00       	push   $0x803ed7
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 9c 3d 80 00       	push   $0x803d9c
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 63 1d 00 00       	call   802390 <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 fb 1d 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800635:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 e8 18 00 00       	call   801f2c <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81900000)
  80064a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80064d:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800652:	74 17                	je     80066b <_main+0x633>
		panic("Next Fit not working correctly");
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 64 3f 80 00       	push   $0x803f64
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 9c 3d 80 00       	push   $0x803d9c
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 c0 1d 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800670:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800678:	85 c0                	test   %eax,%eax
  80067a:	79 05                	jns    800681 <_main+0x649>
  80067c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800681:	c1 f8 0c             	sar    $0xc,%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 ba 3e 80 00       	push   $0x803eba
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 9c 3d 80 00       	push   $0x803d9c
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 ec 1c 00 00       	call   802390 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 d7 3e 80 00       	push   $0x803ed7
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 9c 3d 80 00       	push   $0x803d9c
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 c7 1c 00 00       	call   802390 <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 5f 1d 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 d4 18 00 00       	call   801fb7 <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 45 1d 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	01 c0                	add    %eax,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	79 05                	jns    8006fe <_main+0x6c6>
  8006f9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006fe:	c1 f8 0c             	sar    $0xc,%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	74 17                	je     80071c <_main+0x6e4>
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 e8 3e 80 00       	push   $0x803ee8
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 9c 3d 80 00       	push   $0x803d9c
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 6f 1c 00 00       	call   802390 <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 24 3f 80 00       	push   $0x803f24
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 9c 3d 80 00       	push   $0x803d9c
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 4a 1c 00 00       	call   802390 <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 e2 1c 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  80074e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  800751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 cf 17 00 00       	call   801f2c <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80076b:	74 17                	je     800784 <_main+0x74c>
		panic("Next Fit not working correctly");
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	68 64 3f 80 00       	push   $0x803f64
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 9c 3d 80 00       	push   $0x803d9c
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 a7 1c 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800791:	c1 e0 02             	shl    $0x2,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	79 05                	jns    80079d <_main+0x765>
  800798:	05 ff 0f 00 00       	add    $0xfff,%eax
  80079d:	c1 f8 0c             	sar    $0xc,%eax
  8007a0:	39 c2                	cmp    %eax,%edx
  8007a2:	74 17                	je     8007bb <_main+0x783>
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	68 ba 3e 80 00       	push   $0x803eba
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 9c 3d 80 00       	push   $0x803d9c
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 d0 1b 00 00       	call   802390 <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 d7 3e 80 00       	push   $0x803ed7
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 9c 3d 80 00       	push   $0x803d9c
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 ab 1b 00 00       	call   802390 <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 43 1c 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8007ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f3:	c1 e0 03             	shl    $0x3,%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	c1 e2 07             	shl    $0x7,%edx
  8007fb:	29 c2                	sub    %eax,%edx
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	01 d0                	add    %edx,%eax
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	50                   	push   %eax
  800806:	e8 21 17 00 00       	call   801f2c <malloc>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800814:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800819:	74 17                	je     800832 <_main+0x7fa>
		panic("Next Fit not working correctly");
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	68 64 3f 80 00       	push   $0x803f64
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 9c 3d 80 00       	push   $0x803d9c
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 f9 1b 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800837:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	89 c1                	mov    %eax,%ecx
  800844:	c1 e1 07             	shl    $0x7,%ecx
  800847:	29 c1                	sub    %eax,%ecx
  800849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084c:	01 c8                	add    %ecx,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	79 05                	jns    800857 <_main+0x81f>
  800852:	05 ff 0f 00 00       	add    $0xfff,%eax
  800857:	c1 f8 0c             	sar    $0xc,%eax
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 17                	je     800875 <_main+0x83d>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 ba 3e 80 00       	push   $0x803eba
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 9c 3d 80 00       	push   $0x803d9c
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 16 1b 00 00       	call   802390 <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 d7 3e 80 00       	push   $0x803ed7
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 9c 3d 80 00       	push   $0x803d9c
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 f1 1a 00 00       	call   802390 <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 89 1b 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8008a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ad:	c1 e0 09             	shl    $0x9,%eax
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	50                   	push   %eax
  8008b4:	e8 73 16 00 00       	call   801f2c <malloc>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8008bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008c2:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8008c7:	74 17                	je     8008e0 <_main+0x8a8>
		panic("Next Fit not working correctly");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 64 3f 80 00       	push   $0x803f64
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 9c 3d 80 00       	push   $0x803d9c
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 4b 1b 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8008e5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008e8:	89 c2                	mov    %eax,%edx
  8008ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ed:	c1 e0 09             	shl    $0x9,%eax
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	79 05                	jns    8008f9 <_main+0x8c1>
  8008f4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008f9:	c1 f8 0c             	sar    $0xc,%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 17                	je     800917 <_main+0x8df>
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 ba 3e 80 00       	push   $0x803eba
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 9c 3d 80 00       	push   $0x803d9c
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 74 1a 00 00       	call   802390 <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 d7 3e 80 00       	push   $0x803ed7
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 9c 3d 80 00       	push   $0x803d9c
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 84 3f 80 00       	push   $0x803f84
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 3f 1a 00 00       	call   802390 <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 d7 1a 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800959:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 c2                	mov    %eax,%edx
  800961:	01 d2                	add    %edx,%edx
  800963:	01 c2                	add    %eax,%edx
  800965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800968:	c1 e0 09             	shl    $0x9,%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	50                   	push   %eax
  800971:	e8 b6 15 00 00       	call   801f2c <malloc>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80097c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80097f:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800984:	74 17                	je     80099d <_main+0x965>
		panic("Next Fit not working correctly");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 64 3f 80 00       	push   $0x803f64
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 9c 3d 80 00       	push   $0x803d9c
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 8e 1a 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  8009a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 c1                	mov    %eax,%ecx
  8009ac:	01 c9                	add    %ecx,%ecx
  8009ae:	01 c1                	add    %eax,%ecx
  8009b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009b3:	c1 e0 09             	shl    $0x9,%eax
  8009b6:	01 c8                	add    %ecx,%eax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	79 05                	jns    8009c1 <_main+0x989>
  8009bc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009c1:	c1 f8 0c             	sar    $0xc,%eax
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 17                	je     8009df <_main+0x9a7>
  8009c8:	83 ec 04             	sub    $0x4,%esp
  8009cb:	68 ba 3e 80 00       	push   $0x803eba
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 9c 3d 80 00       	push   $0x803d9c
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 ac 19 00 00       	call   802390 <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 d7 3e 80 00       	push   $0x803ed7
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 9c 3d 80 00       	push   $0x803d9c
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 87 19 00 00       	call   802390 <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 1f 1a 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 94 15 00 00       	call   801fb7 <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 05 1a 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800a2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	85 c0                	test   %eax,%eax
  800a37:	79 05                	jns    800a3e <_main+0xa06>
  800a39:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a3e:	c1 f8 0c             	sar    $0xc,%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 17                	je     800a5c <_main+0xa24>
  800a45:	83 ec 04             	sub    $0x4,%esp
  800a48:	68 e8 3e 80 00       	push   $0x803ee8
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 9c 3d 80 00       	push   $0x803d9c
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 2f 19 00 00       	call   802390 <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 24 3f 80 00       	push   $0x803f24
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 9c 3d 80 00       	push   $0x803d9c
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 0a 19 00 00       	call   802390 <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 a2 19 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  800a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a94:	c1 e0 02             	shl    $0x2,%eax
  800a97:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800a9a:	83 ec 0c             	sub    $0xc,%esp
  800a9d:	50                   	push   %eax
  800a9e:	e8 89 14 00 00       	call   801f2c <malloc>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aac:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800ab1:	74 17                	je     800aca <_main+0xa92>
		panic("Next Fit not working correctly");
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 64 3f 80 00       	push   $0x803f64
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 9c 3d 80 00       	push   $0x803d9c
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 61 19 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800acf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	79 05                	jns    800ae3 <_main+0xaab>
  800ade:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ae3:	c1 f8 0c             	sar    $0xc,%eax
  800ae6:	39 c2                	cmp    %eax,%edx
  800ae8:	74 17                	je     800b01 <_main+0xac9>
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	68 ba 3e 80 00       	push   $0x803eba
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 9c 3d 80 00       	push   $0x803d9c
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 8a 18 00 00       	call   802390 <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 d7 3e 80 00       	push   $0x803ed7
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 9c 3d 80 00       	push   $0x803d9c
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 c0 3f 80 00       	push   $0x803fc0
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 55 18 00 00       	call   802390 <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 ed 18 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 d2 13 00 00       	call   801f2c <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 17                	je     800b7e <_main+0xb46>
		panic("Next Fit not working correctly");
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 64 3f 80 00       	push   $0x803f64
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 9c 3d 80 00       	push   $0x803d9c
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 ad 18 00 00       	call   802430 <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 ba 3e 80 00       	push   $0x803eba
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 9c 3d 80 00       	push   $0x803d9c
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 ec 17 00 00       	call   802390 <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 d7 3e 80 00       	push   $0x803ed7
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 9c 3d 80 00       	push   $0x803d9c
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 f8 3f 80 00       	push   $0x803ff8
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 34 40 80 00       	push   $0x804034
  800bdc:	e8 fb 03 00 00       	call   800fdc <cprintf>
  800be1:	83 c4 10             	add    $0x10,%esp

	return;
  800be4:	90                   	nop
}
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bf2:	e8 79 1a 00 00       	call   802670 <sys_getenvindex>
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 03             	shl    $0x3,%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	01 c0                	add    %eax,%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	c1 e0 04             	shl    $0x4,%eax
  800c14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c19:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c1e:	a1 20 50 80 00       	mov    0x805020,%eax
  800c23:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 0f                	je     800c3c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c32:	05 5c 05 00 00       	add    $0x55c,%eax
  800c37:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c40:	7e 0a                	jle    800c4c <libmain+0x60>
		binaryname = argv[0];
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 de f3 ff ff       	call   800038 <_main>
  800c5a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c5d:	e8 1b 18 00 00       	call   80247d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 88 40 80 00       	push   $0x804088
  800c6a:	e8 6d 03 00 00       	call   800fdc <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c72:	a1 20 50 80 00       	mov    0x805020,%eax
  800c77:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800c7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c82:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	52                   	push   %edx
  800c8c:	50                   	push   %eax
  800c8d:	68 b0 40 80 00       	push   $0x8040b0
  800c92:	e8 45 03 00 00       	call   800fdc <cprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c9f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ca5:	a1 20 50 80 00       	mov    0x805020,%eax
  800caa:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800cb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800cb5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800cbb:	51                   	push   %ecx
  800cbc:	52                   	push   %edx
  800cbd:	50                   	push   %eax
  800cbe:	68 d8 40 80 00       	push   $0x8040d8
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 30 41 80 00       	push   $0x804130
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 88 40 80 00       	push   $0x804088
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 9b 17 00 00       	call   802497 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800cfc:	e8 19 00 00 00       	call   800d1a <exit>
}
  800d01:	90                   	nop
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	6a 00                	push   $0x0
  800d0f:	e8 28 19 00 00       	call   80263c <sys_destroy_env>
  800d14:	83 c4 10             	add    $0x10,%esp
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <exit>:

void
exit(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d20:	e8 7d 19 00 00       	call   8026a2 <sys_exit_env>
}
  800d25:	90                   	nop
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d31:	83 c0 04             	add    $0x4,%eax
  800d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d37:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	74 16                	je     800d56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d40:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	68 44 41 80 00       	push   $0x804144
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 49 41 80 00       	push   $0x804149
  800d67:	e8 70 02 00 00       	call   800fdc <cprintf>
  800d6c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	50                   	push   %eax
  800d79:	e8 f3 01 00 00       	call   800f71 <vcprintf>
  800d7e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	6a 00                	push   $0x0
  800d86:	68 65 41 80 00       	push   $0x804165
  800d8b:	e8 e1 01 00 00       	call   800f71 <vcprintf>
  800d90:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d93:	e8 82 ff ff ff       	call   800d1a <exit>

	// should not return here
	while (1) ;
  800d98:	eb fe                	jmp    800d98 <_panic+0x70>

00800d9a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da0:	a1 20 50 80 00       	mov    0x805020,%eax
  800da5:	8b 50 74             	mov    0x74(%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	39 c2                	cmp    %eax,%edx
  800dad:	74 14                	je     800dc3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	68 68 41 80 00       	push   $0x804168
  800db7:	6a 26                	push   $0x26
  800db9:	68 b4 41 80 00       	push   $0x8041b4
  800dbe:	e8 65 ff ff ff       	call   800d28 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd1:	e9 c2 00 00 00       	jmp    800e98 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 08                	jne    800df3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800deb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800dee:	e9 a2 00 00 00       	jmp    800e95 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800df3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e01:	eb 69                	jmp    800e6c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e03:	a1 20 50 80 00       	mov    0x805020,%eax
  800e08:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	01 c0                	add    %eax,%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	c1 e0 03             	shl    $0x3,%eax
  800e1a:	01 c8                	add    %ecx,%eax
  800e1c:	8a 40 04             	mov    0x4(%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 46                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e23:	a1 20 50 80 00       	mov    0x805020,%eax
  800e28:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e49:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	01 c8                	add    %ecx,%eax
  800e5a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e5c:	39 c2                	cmp    %eax,%edx
  800e5e:	75 09                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e60:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e67:	eb 12                	jmp    800e7b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e69:	ff 45 e8             	incl   -0x18(%ebp)
  800e6c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e71:	8b 50 74             	mov    0x74(%eax),%edx
  800e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e77:	39 c2                	cmp    %eax,%edx
  800e79:	77 88                	ja     800e03 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7f:	75 14                	jne    800e95 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	68 c0 41 80 00       	push   $0x8041c0
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 b4 41 80 00       	push   $0x8041b4
  800e90:	e8 93 fe ff ff       	call   800d28 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e95:	ff 45 f0             	incl   -0x10(%ebp)
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e9e:	0f 8c 32 ff ff ff    	jl     800dd6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800eb2:	eb 26                	jmp    800eda <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800eb4:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	c1 e0 03             	shl    $0x3,%eax
  800ecb:	01 c8                	add    %ecx,%eax
  800ecd:	8a 40 04             	mov    0x4(%eax),%al
  800ed0:	3c 01                	cmp    $0x1,%al
  800ed2:	75 03                	jne    800ed7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ed4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed7:	ff 45 e0             	incl   -0x20(%ebp)
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 50 74             	mov    0x74(%eax),%edx
  800ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	77 cb                	ja     800eb4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800eef:	74 14                	je     800f05 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	68 14 42 80 00       	push   $0x804214
  800ef9:	6a 44                	push   $0x44
  800efb:	68 b4 41 80 00       	push   $0x8041b4
  800f00:	e8 23 fe ff ff       	call   800d28 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	8d 48 01             	lea    0x1(%eax),%ecx
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	89 0a                	mov    %ecx,(%edx)
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	88 d1                	mov    %dl,%cl
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f31:	75 2c                	jne    800f5f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f33:	a0 24 50 80 00       	mov    0x805024,%al
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8b 12                	mov    (%edx),%edx
  800f40:	89 d1                	mov    %edx,%ecx
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	83 c2 08             	add    $0x8,%edx
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	50                   	push   %eax
  800f4c:	51                   	push   %ecx
  800f4d:	52                   	push   %edx
  800f4e:	e8 7c 13 00 00       	call   8022cf <sys_cputs>
  800f53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 40 04             	mov    0x4(%eax),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f7a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f81:	00 00 00 
	b.cnt = 0;
  800f84:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f8b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	68 08 0f 80 00       	push   $0x800f08
  800fa0:	e8 11 02 00 00       	call   8011b6 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fa8:	a0 24 50 80 00       	mov    0x805024,%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	50                   	push   %eax
  800fba:	52                   	push   %edx
  800fbb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fc1:	83 c0 08             	add    $0x8,%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 05 13 00 00       	call   8022cf <sys_cputs>
  800fca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fcd:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800fd4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <cprintf>:

int cprintf(const char *fmt, ...) {
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fe2:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800fe9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	83 ec 08             	sub    $0x8,%esp
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	50                   	push   %eax
  800ff9:	e8 73 ff ff ff       	call   800f71 <vcprintf>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80100f:	e8 69 14 00 00       	call   80247d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801014:	8d 45 0c             	lea    0xc(%ebp),%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 f4             	pushl  -0xc(%ebp)
  801023:	50                   	push   %eax
  801024:	e8 48 ff ff ff       	call   800f71 <vcprintf>
  801029:	83 c4 10             	add    $0x10,%esp
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80102f:	e8 63 14 00 00       	call   802497 <sys_enable_interrupt>
	return cnt;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 14             	sub    $0x14,%esp
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80104c:	8b 45 18             	mov    0x18(%ebp),%eax
  80104f:	ba 00 00 00 00       	mov    $0x0,%edx
  801054:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801057:	77 55                	ja     8010ae <printnum+0x75>
  801059:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105c:	72 05                	jb     801063 <printnum+0x2a>
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	77 4b                	ja     8010ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801063:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801066:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801069:	8b 45 18             	mov    0x18(%ebp),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
  801071:	52                   	push   %edx
  801072:	50                   	push   %eax
  801073:	ff 75 f4             	pushl  -0xc(%ebp)
  801076:	ff 75 f0             	pushl  -0x10(%ebp)
  801079:	e8 82 2a 00 00       	call   803b00 <__udivdi3>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	ff 75 20             	pushl  0x20(%ebp)
  801087:	53                   	push   %ebx
  801088:	ff 75 18             	pushl  0x18(%ebp)
  80108b:	52                   	push   %edx
  80108c:	50                   	push   %eax
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	ff 75 08             	pushl  0x8(%ebp)
  801093:	e8 a1 ff ff ff       	call   801039 <printnum>
  801098:	83 c4 20             	add    $0x20,%esp
  80109b:	eb 1a                	jmp    8010b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 20             	pushl  0x20(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8010b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010b5:	7f e6                	jg     80109d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	53                   	push   %ebx
  8010c6:	51                   	push   %ecx
  8010c7:	52                   	push   %edx
  8010c8:	50                   	push   %eax
  8010c9:	e8 42 2b 00 00       	call   803c10 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 74 44 80 00       	add    $0x804474,%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
}
  8010ea:	90                   	nop
  8010eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010f7:	7e 1c                	jle    801115 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 50 08             	lea    0x8(%eax),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 10                	mov    %edx,(%eax)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	83 e8 08             	sub    $0x8,%eax
  80110e:	8b 50 04             	mov    0x4(%eax),%edx
  801111:	8b 00                	mov    (%eax),%eax
  801113:	eb 40                	jmp    801155 <getuint+0x65>
	else if (lflag)
  801115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801119:	74 1e                	je     801139 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	8d 50 04             	lea    0x4(%eax),%edx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 10                	mov    %edx,(%eax)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	83 e8 04             	sub    $0x4,%eax
  801130:	8b 00                	mov    (%eax),%eax
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	eb 1c                	jmp    801155 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8b 00                	mov    (%eax),%eax
  80113e:	8d 50 04             	lea    0x4(%eax),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 10                	mov    %edx,(%eax)
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	83 e8 04             	sub    $0x4,%eax
  80114e:	8b 00                	mov    (%eax),%eax
  801150:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80115a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80115e:	7e 1c                	jle    80117c <getint+0x25>
		return va_arg(*ap, long long);
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	8d 50 08             	lea    0x8(%eax),%edx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 10                	mov    %edx,(%eax)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 e8 08             	sub    $0x8,%eax
  801175:	8b 50 04             	mov    0x4(%eax),%edx
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	eb 38                	jmp    8011b4 <getint+0x5d>
	else if (lflag)
  80117c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801180:	74 1a                	je     80119c <getint+0x45>
		return va_arg(*ap, long);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8b 00                	mov    (%eax),%eax
  801187:	8d 50 04             	lea    0x4(%eax),%edx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 10                	mov    %edx,(%eax)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	83 e8 04             	sub    $0x4,%eax
  801197:	8b 00                	mov    (%eax),%eax
  801199:	99                   	cltd   
  80119a:	eb 18                	jmp    8011b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8b 00                	mov    (%eax),%eax
  8011a1:	8d 50 04             	lea    0x4(%eax),%edx
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 10                	mov    %edx,(%eax)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	83 e8 04             	sub    $0x4,%eax
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	99                   	cltd   
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011be:	eb 17                	jmp    8011d7 <vprintfmt+0x21>
			if (ch == '\0')
  8011c0:	85 db                	test   %ebx,%ebx
  8011c2:	0f 84 af 03 00 00    	je     801577 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	8d 50 01             	lea    0x1(%eax),%edx
  8011dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d8             	movzbl %al,%ebx
  8011e5:	83 fb 25             	cmp    $0x25,%ebx
  8011e8:	75 d6                	jne    8011c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 10             	mov    %edx,0x10(%ebp)
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f b6 d8             	movzbl %al,%ebx
  801218:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80121b:	83 f8 55             	cmp    $0x55,%eax
  80121e:	0f 87 2b 03 00 00    	ja     80154f <vprintfmt+0x399>
  801224:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
  80122b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80122d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801231:	eb d7                	jmp    80120a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801233:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801237:	eb d1                	jmp    80120a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801243:	89 d0                	mov    %edx,%eax
  801245:	c1 e0 02             	shl    $0x2,%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	01 c0                	add    %eax,%eax
  80124c:	01 d8                	add    %ebx,%eax
  80124e:	83 e8 30             	sub    $0x30,%eax
  801251:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80125c:	83 fb 2f             	cmp    $0x2f,%ebx
  80125f:	7e 3e                	jle    80129f <vprintfmt+0xe9>
  801261:	83 fb 39             	cmp    $0x39,%ebx
  801264:	7f 39                	jg     80129f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801266:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801269:	eb d5                	jmp    801240 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80127f:	eb 1f                	jmp    8012a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801285:	79 83                	jns    80120a <vprintfmt+0x54>
				width = 0;
  801287:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80128e:	e9 77 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801293:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80129a:	e9 6b ff ff ff       	jmp    80120a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80129f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a4:	0f 89 60 ff ff ff    	jns    80120a <vprintfmt+0x54>
				width = precision, precision = -1;
  8012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012b7:	e9 4e ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012bf:	e9 46 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 00                	mov    (%eax),%eax
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	50                   	push   %eax
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	ff d0                	call   *%eax
  8012e1:	83 c4 10             	add    $0x10,%esp
			break;
  8012e4:	e9 89 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	83 c0 04             	add    $0x4,%eax
  8012ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	83 e8 04             	sub    $0x4,%eax
  8012f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012fa:	85 db                	test   %ebx,%ebx
  8012fc:	79 02                	jns    801300 <vprintfmt+0x14a>
				err = -err;
  8012fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801300:	83 fb 64             	cmp    $0x64,%ebx
  801303:	7f 0b                	jg     801310 <vprintfmt+0x15a>
  801305:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 85 44 80 00       	push   $0x804485
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	ff 75 08             	pushl  0x8(%ebp)
  80131c:	e8 5e 02 00 00       	call   80157f <printfmt>
  801321:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801324:	e9 49 02 00 00       	jmp    801572 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801329:	56                   	push   %esi
  80132a:	68 8e 44 80 00       	push   $0x80448e
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 45 02 00 00       	call   80157f <printfmt>
  80133a:	83 c4 10             	add    $0x10,%esp
			break;
  80133d:	e9 30 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	83 c0 04             	add    $0x4,%eax
  801348:	89 45 14             	mov    %eax,0x14(%ebp)
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	83 e8 04             	sub    $0x4,%eax
  801351:	8b 30                	mov    (%eax),%esi
  801353:	85 f6                	test   %esi,%esi
  801355:	75 05                	jne    80135c <vprintfmt+0x1a6>
				p = "(null)";
  801357:	be 91 44 80 00       	mov    $0x804491,%esi
			if (width > 0 && padc != '-')
  80135c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801360:	7e 6d                	jle    8013cf <vprintfmt+0x219>
  801362:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801366:	74 67                	je     8013cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	50                   	push   %eax
  80136f:	56                   	push   %esi
  801370:	e8 0c 03 00 00       	call   801681 <strnlen>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80137b:	eb 16                	jmp    801393 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80137d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	ff d0                	call   *%eax
  80138d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	ff 4d e4             	decl   -0x1c(%ebp)
  801393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801397:	7f e4                	jg     80137d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801399:	eb 34                	jmp    8013cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80139b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80139f:	74 1c                	je     8013bd <vprintfmt+0x207>
  8013a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a4:	7e 05                	jle    8013ab <vprintfmt+0x1f5>
  8013a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8013a9:	7e 12                	jle    8013bd <vprintfmt+0x207>
					putch('?', putdat);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	6a 3f                	push   $0x3f
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb 0f                	jmp    8013cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	53                   	push   %ebx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	ff d0                	call   *%eax
  8013c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	8d 70 01             	lea    0x1(%eax),%esi
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be d8             	movsbl %al,%ebx
  8013d9:	85 db                	test   %ebx,%ebx
  8013db:	74 24                	je     801401 <vprintfmt+0x24b>
  8013dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e1:	78 b8                	js     80139b <vprintfmt+0x1e5>
  8013e3:	ff 4d e0             	decl   -0x20(%ebp)
  8013e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ea:	79 af                	jns    80139b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ec:	eb 13                	jmp    801401 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	6a 20                	push   $0x20
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	ff d0                	call   *%eax
  8013fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fe:	ff 4d e4             	decl   -0x1c(%ebp)
  801401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801405:	7f e7                	jg     8013ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801407:	e9 66 01 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 e8             	pushl  -0x18(%ebp)
  801412:	8d 45 14             	lea    0x14(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	e8 3c fd ff ff       	call   801157 <getint>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	85 d2                	test   %edx,%edx
  80142c:	79 23                	jns    801451 <vprintfmt+0x29b>
				putch('-', putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	6a 2d                	push   $0x2d
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801444:	f7 d8                	neg    %eax
  801446:	83 d2 00             	adc    $0x0,%edx
  801449:	f7 da                	neg    %edx
  80144b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80144e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801451:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801458:	e9 bc 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 e8             	pushl  -0x18(%ebp)
  801463:	8d 45 14             	lea    0x14(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	e8 84 fc ff ff       	call   8010f0 <getuint>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801472:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801475:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80147c:	e9 98 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	6a 58                	push   $0x58
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	ff d0                	call   *%eax
  80148e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	6a 58                	push   $0x58
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	ff d0                	call   *%eax
  80149e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	6a 58                	push   $0x58
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	ff d0                	call   *%eax
  8014ae:	83 c4 10             	add    $0x10,%esp
			break;
  8014b1:	e9 bc 00 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	6a 30                	push   $0x30
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	ff d0                	call   *%eax
  8014c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	6a 78                	push   $0x78
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	ff d0                	call   *%eax
  8014d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	83 c0 04             	add    $0x4,%eax
  8014dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	83 e8 04             	sub    $0x4,%eax
  8014e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014f8:	eb 1f                	jmp    801519 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	8d 45 14             	lea    0x14(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	e8 e7 fb ff ff       	call   8010f0 <getuint>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801512:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801519:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	52                   	push   %edx
  801524:	ff 75 e4             	pushl  -0x1c(%ebp)
  801527:	50                   	push   %eax
  801528:	ff 75 f4             	pushl  -0xc(%ebp)
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	ff 75 08             	pushl  0x8(%ebp)
  801534:	e8 00 fb ff ff       	call   801039 <printnum>
  801539:	83 c4 20             	add    $0x20,%esp
			break;
  80153c:	eb 34                	jmp    801572 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	53                   	push   %ebx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	ff d0                	call   *%eax
  80154a:	83 c4 10             	add    $0x10,%esp
			break;
  80154d:	eb 23                	jmp    801572 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	6a 25                	push   $0x25
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80155f:	ff 4d 10             	decl   0x10(%ebp)
  801562:	eb 03                	jmp    801567 <vprintfmt+0x3b1>
  801564:	ff 4d 10             	decl   0x10(%ebp)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	48                   	dec    %eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 25                	cmp    $0x25,%al
  80156f:	75 f3                	jne    801564 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801571:	90                   	nop
		}
	}
  801572:	e9 47 fc ff ff       	jmp    8011be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801577:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801585:	8d 45 10             	lea    0x10(%ebp),%eax
  801588:	83 c0 04             	add    $0x4,%eax
  80158b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	ff 75 f4             	pushl  -0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 16 fc ff ff       	call   8011b6 <vprintfmt>
  8015a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	8b 40 08             	mov    0x8(%eax),%eax
  8015af:	8d 50 01             	lea    0x1(%eax),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8b 10                	mov    (%eax),%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	39 c2                	cmp    %eax,%edx
  8015c5:	73 12                	jae    8015d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	89 0a                	mov    %ecx,(%edx)
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	88 10                	mov    %dl,(%eax)
}
  8015d9:	90                   	nop
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801601:	74 06                	je     801609 <vsnprintf+0x2d>
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	7f 07                	jg     801610 <vsnprintf+0x34>
		return -E_INVAL;
  801609:	b8 03 00 00 00       	mov    $0x3,%eax
  80160e:	eb 20                	jmp    801630 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801610:	ff 75 14             	pushl  0x14(%ebp)
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	68 a6 15 80 00       	push   $0x8015a6
  80161f:	e8 92 fb ff ff       	call   8011b6 <vprintfmt>
  801624:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801638:	8d 45 10             	lea    0x10(%ebp),%eax
  80163b:	83 c0 04             	add    $0x4,%eax
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	e8 89 ff ff ff       	call   8015dc <vsnprintf>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166b:	eb 06                	jmp    801673 <strlen+0x15>
		n++;
  80166d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 f1                	jne    80166d <strlen+0xf>
		n++;
	return n;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168e:	eb 09                	jmp    801699 <strnlen+0x18>
		n++;
  801690:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801693:	ff 45 08             	incl   0x8(%ebp)
  801696:	ff 4d 0c             	decl   0xc(%ebp)
  801699:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169d:	74 09                	je     8016a8 <strnlen+0x27>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	75 e8                	jne    801690 <strnlen+0xf>
		n++;
	return n;
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016b9:	90                   	nop
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	84 c0                	test   %al,%al
  8016d4:	75 e4                	jne    8016ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ee:	eb 1f                	jmp    80170f <strncpy+0x34>
		*dst++ = *src;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8d 50 01             	lea    0x1(%eax),%edx
  8016f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8a 12                	mov    (%edx),%dl
  8016fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	84 c0                	test   %al,%al
  801707:	74 03                	je     80170c <strncpy+0x31>
			src++;
  801709:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170c:	ff 45 fc             	incl   -0x4(%ebp)
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	3b 45 10             	cmp    0x10(%ebp),%eax
  801715:	72 d9                	jb     8016f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172c:	74 30                	je     80175e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80172e:	eb 16                	jmp    801746 <strlcpy+0x2a>
			*dst++ = *src++;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8d 50 01             	lea    0x1(%eax),%edx
  801736:	89 55 08             	mov    %edx,0x8(%ebp)
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801742:	8a 12                	mov    (%edx),%dl
  801744:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801746:	ff 4d 10             	decl   0x10(%ebp)
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	74 09                	je     801758 <strlcpy+0x3c>
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	84 c0                	test   %al,%al
  801756:	75 d8                	jne    801730 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	29 c2                	sub    %eax,%edx
  801766:	89 d0                	mov    %edx,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80176d:	eb 06                	jmp    801775 <strcmp+0xb>
		p++, q++;
  80176f:	ff 45 08             	incl   0x8(%ebp)
  801772:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	84 c0                	test   %al,%al
  80177c:	74 0e                	je     80178c <strcmp+0x22>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 10                	mov    (%eax),%dl
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	38 c2                	cmp    %al,%dl
  80178a:	74 e3                	je     80176f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	0f b6 d0             	movzbl %al,%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f b6 c0             	movzbl %al,%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a5:	eb 09                	jmp    8017b0 <strncmp+0xe>
		n--, p++, q++;
  8017a7:	ff 4d 10             	decl   0x10(%ebp)
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b4:	74 17                	je     8017cd <strncmp+0x2b>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 0e                	je     8017cd <strncmp+0x2b>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 10                	mov    (%eax),%dl
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	38 c2                	cmp    %al,%dl
  8017cb:	74 da                	je     8017a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	75 07                	jne    8017da <strncmp+0x38>
		return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	eb 14                	jmp    8017ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f b6 d0             	movzbl %al,%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 c0             	movzbl %al,%eax
  8017ea:	29 c2                	sub    %eax,%edx
  8017ec:	89 d0                	mov    %edx,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017fc:	eb 12                	jmp    801810 <strchr+0x20>
		if (*s == c)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801806:	75 05                	jne    80180d <strchr+0x1d>
			return (char *) s;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	eb 11                	jmp    80181e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	84 c0                	test   %al,%al
  801817:	75 e5                	jne    8017fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182c:	eb 0d                	jmp    80183b <strfind+0x1b>
		if (*s == c)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801836:	74 0e                	je     801846 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801838:	ff 45 08             	incl   0x8(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	84 c0                	test   %al,%al
  801842:	75 ea                	jne    80182e <strfind+0xe>
  801844:	eb 01                	jmp    801847 <strfind+0x27>
		if (*s == c)
			break;
  801846:	90                   	nop
	return (char *) s;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80185e:	eb 0e                	jmp    80186e <memset+0x22>
		*p++ = c;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8d 50 01             	lea    0x1(%eax),%edx
  801866:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80186e:	ff 4d f8             	decl   -0x8(%ebp)
  801871:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801875:	79 e9                	jns    801860 <memset+0x14>
		*p++ = c;

	return v;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80188e:	eb 16                	jmp    8018a6 <memcpy+0x2a>
		*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018d0:	73 50                	jae    801922 <memmove+0x6a>
  8018d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	01 d0                	add    %edx,%eax
  8018da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018dd:	76 43                	jbe    801922 <memmove+0x6a>
		s += n;
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018eb:	eb 10                	jmp    8018fd <memmove+0x45>
			*--d = *--s;
  8018ed:	ff 4d f8             	decl   -0x8(%ebp)
  8018f0:	ff 4d fc             	decl   -0x4(%ebp)
  8018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f6:	8a 10                	mov    (%eax),%dl
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	8d 50 ff             	lea    -0x1(%eax),%edx
  801903:	89 55 10             	mov    %edx,0x10(%ebp)
  801906:	85 c0                	test   %eax,%eax
  801908:	75 e3                	jne    8018ed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80190a:	eb 23                	jmp    80192f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80190c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190f:	8d 50 01             	lea    0x1(%eax),%edx
  801912:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801918:	8d 4a 01             	lea    0x1(%edx),%ecx
  80191b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80191e:	8a 12                	mov    (%edx),%dl
  801920:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	8d 50 ff             	lea    -0x1(%eax),%edx
  801928:	89 55 10             	mov    %edx,0x10(%ebp)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 dd                	jne    80190c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801946:	eb 2a                	jmp    801972 <memcmp+0x3e>
		if (*s1 != *s2)
  801948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194b:	8a 10                	mov    (%eax),%dl
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	38 c2                	cmp    %al,%dl
  801954:	74 16                	je     80196c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	0f b6 d0             	movzbl %al,%edx
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	0f b6 c0             	movzbl %al,%eax
  801966:	29 c2                	sub    %eax,%edx
  801968:	89 d0                	mov    %edx,%eax
  80196a:	eb 18                	jmp    801984 <memcmp+0x50>
		s1++, s2++;
  80196c:	ff 45 fc             	incl   -0x4(%ebp)
  80196f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	8d 50 ff             	lea    -0x1(%eax),%edx
  801978:	89 55 10             	mov    %edx,0x10(%ebp)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	75 c9                	jne    801948 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80198c:	8b 55 08             	mov    0x8(%ebp),%edx
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801997:	eb 15                	jmp    8019ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f b6 d0             	movzbl %al,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	0f b6 c0             	movzbl %al,%eax
  8019a7:	39 c2                	cmp    %eax,%edx
  8019a9:	74 0d                	je     8019b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019ab:	ff 45 08             	incl   0x8(%ebp)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019b4:	72 e3                	jb     801999 <memfind+0x13>
  8019b6:	eb 01                	jmp    8019b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019b8:	90                   	nop
	return (void *) s;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d2:	eb 03                	jmp    8019d7 <strtol+0x19>
		s++;
  8019d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	3c 20                	cmp    $0x20,%al
  8019de:	74 f4                	je     8019d4 <strtol+0x16>
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 09                	cmp    $0x9,%al
  8019e7:	74 eb                	je     8019d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 2b                	cmp    $0x2b,%al
  8019f0:	75 05                	jne    8019f7 <strtol+0x39>
		s++;
  8019f2:	ff 45 08             	incl   0x8(%ebp)
  8019f5:	eb 13                	jmp    801a0a <strtol+0x4c>
	else if (*s == '-')
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	3c 2d                	cmp    $0x2d,%al
  8019fe:	75 0a                	jne    801a0a <strtol+0x4c>
		s++, neg = 1;
  801a00:	ff 45 08             	incl   0x8(%ebp)
  801a03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0e:	74 06                	je     801a16 <strtol+0x58>
  801a10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a14:	75 20                	jne    801a36 <strtol+0x78>
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	3c 30                	cmp    $0x30,%al
  801a1d:	75 17                	jne    801a36 <strtol+0x78>
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	40                   	inc    %eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	3c 78                	cmp    $0x78,%al
  801a27:	75 0d                	jne    801a36 <strtol+0x78>
		s += 2, base = 16;
  801a29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a34:	eb 28                	jmp    801a5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3a:	75 15                	jne    801a51 <strtol+0x93>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	3c 30                	cmp    $0x30,%al
  801a43:	75 0c                	jne    801a51 <strtol+0x93>
		s++, base = 8;
  801a45:	ff 45 08             	incl   0x8(%ebp)
  801a48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a4f:	eb 0d                	jmp    801a5e <strtol+0xa0>
	else if (base == 0)
  801a51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a55:	75 07                	jne    801a5e <strtol+0xa0>
		base = 10;
  801a57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	3c 2f                	cmp    $0x2f,%al
  801a65:	7e 19                	jle    801a80 <strtol+0xc2>
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	3c 39                	cmp    $0x39,%al
  801a6e:	7f 10                	jg     801a80 <strtol+0xc2>
			dig = *s - '0';
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	83 e8 30             	sub    $0x30,%eax
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7e:	eb 42                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	3c 60                	cmp    $0x60,%al
  801a87:	7e 19                	jle    801aa2 <strtol+0xe4>
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	3c 7a                	cmp    $0x7a,%al
  801a90:	7f 10                	jg     801aa2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	0f be c0             	movsbl %al,%eax
  801a9a:	83 e8 57             	sub    $0x57,%eax
  801a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa0:	eb 20                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 40                	cmp    $0x40,%al
  801aa9:	7e 39                	jle    801ae4 <strtol+0x126>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 5a                	cmp    $0x5a,%al
  801ab2:	7f 30                	jg     801ae4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	0f be c0             	movsbl %al,%eax
  801abc:	83 e8 37             	sub    $0x37,%eax
  801abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ac8:	7d 19                	jge    801ae3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aca:	ff 45 08             	incl   0x8(%ebp)
  801acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad0:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ade:	e9 7b ff ff ff       	jmp    801a5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ae3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ae4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae8:	74 08                	je     801af2 <strtol+0x134>
		*endptr = (char *) s;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	8b 55 08             	mov    0x8(%ebp),%edx
  801af0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af6:	74 07                	je     801aff <strtol+0x141>
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	f7 d8                	neg    %eax
  801afd:	eb 03                	jmp    801b02 <strtol+0x144>
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <ltostr>:

void
ltostr(long value, char *str)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1c:	79 13                	jns    801b31 <ltostr+0x2d>
	{
		neg = 1;
  801b1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b2b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b2e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b39:	99                   	cltd   
  801b3a:	f7 f9                	idiv   %ecx
  801b3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b42:	8d 50 01             	lea    0x1(%eax),%edx
  801b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4d:	01 d0                	add    %edx,%eax
  801b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b52:	83 c2 30             	add    $0x30,%edx
  801b55:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b5f:	f7 e9                	imul   %ecx
  801b61:	c1 fa 02             	sar    $0x2,%edx
  801b64:	89 c8                	mov    %ecx,%eax
  801b66:	c1 f8 1f             	sar    $0x1f,%eax
  801b69:	29 c2                	sub    %eax,%edx
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b78:	f7 e9                	imul   %ecx
  801b7a:	c1 fa 02             	sar    $0x2,%edx
  801b7d:	89 c8                	mov    %ecx,%eax
  801b7f:	c1 f8 1f             	sar    $0x1f,%eax
  801b82:	29 c2                	sub    %eax,%edx
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	c1 e0 02             	shl    $0x2,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	29 c1                	sub    %eax,%ecx
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	85 d2                	test   %edx,%edx
  801b93:	75 9c                	jne    801b31 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ba7:	74 3d                	je     801be6 <ltostr+0xe2>
		start = 1 ;
  801ba9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bb0:	eb 34                	jmp    801be6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8a 00                	mov    (%eax),%al
  801bbc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	01 c2                	add    %eax,%edx
  801bc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	01 c8                	add    %ecx,%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	01 c2                	add    %eax,%edx
  801bdb:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bde:	88 02                	mov    %al,(%edx)
		start++ ;
  801be0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801be3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bec:	7c c4                	jl     801bb2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 54 fa ff ff       	call   80165e <strlen>
  801c0a:	83 c4 04             	add    $0x4,%esp
  801c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 46 fa ff ff       	call   80165e <strlen>
  801c18:	83 c4 04             	add    $0x4,%esp
  801c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2c:	eb 17                	jmp    801c45 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	01 c2                	add    %eax,%edx
  801c36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	8a 00                	mov    (%eax),%al
  801c40:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c42:	ff 45 fc             	incl   -0x4(%ebp)
  801c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c4b:	7c e1                	jl     801c2e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c5b:	eb 1f                	jmp    801c7c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c60:	8d 50 01             	lea    0x1(%eax),%edx
  801c63:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	01 c8                	add    %ecx,%eax
  801c75:	8a 00                	mov    (%eax),%al
  801c77:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c79:	ff 45 f8             	incl   -0x8(%ebp)
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c82:	7c d9                	jl     801c5d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c95:	8b 45 14             	mov    0x14(%ebp),%eax
  801c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb5:	eb 0c                	jmp    801cc3 <strsplit+0x31>
			*string++ = 0;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8d 50 01             	lea    0x1(%eax),%edx
  801cbd:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8a 00                	mov    (%eax),%al
  801cc8:	84 c0                	test   %al,%al
  801cca:	74 18                	je     801ce4 <strsplit+0x52>
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8a 00                	mov    (%eax),%al
  801cd1:	0f be c0             	movsbl %al,%eax
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	e8 13 fb ff ff       	call   8017f0 <strchr>
  801cdd:	83 c4 08             	add    $0x8,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	75 d3                	jne    801cb7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	74 5a                	je     801d47 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	83 f8 0f             	cmp    $0xf,%eax
  801cf5:	75 07                	jne    801cfe <strsplit+0x6c>
		{
			return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 66                	jmp    801d64 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	8d 48 01             	lea    0x1(%eax),%ecx
  801d06:	8b 55 14             	mov    0x14(%ebp),%edx
  801d09:	89 0a                	mov    %ecx,(%edx)
  801d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	01 c2                	add    %eax,%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d1c:	eb 03                	jmp    801d21 <strsplit+0x8f>
			string++;
  801d1e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	84 c0                	test   %al,%al
  801d28:	74 8b                	je     801cb5 <strsplit+0x23>
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	0f be c0             	movsbl %al,%eax
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 b5 fa ff ff       	call   8017f0 <strchr>
  801d3b:	83 c4 08             	add    $0x8,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 dc                	je     801d1e <strsplit+0x8c>
			string++;
	}
  801d42:	e9 6e ff ff ff       	jmp    801cb5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d47:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801d6c:	a1 04 50 80 00       	mov    0x805004,%eax
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 1f                	je     801d94 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801d75:	e8 1d 00 00 00       	call   801d97 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 f0 45 80 00       	push   $0x8045f0
  801d82:	e8 55 f2 ff ff       	call   800fdc <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d8a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d91:	00 00 00 
	}
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801d9d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801da4:	00 00 00 
  801da7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801dae:	00 00 00 
  801db1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801db8:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801dbb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801dc2:	00 00 00 
  801dc5:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801dcc:	00 00 00 
  801dcf:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801dd6:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801dd9:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801de0:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801de3:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801dea:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801df9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dfe:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801e03:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e12:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	6a 06                	push   $0x6
  801e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1f:	50                   	push   %eax
  801e20:	e8 ee 05 00 00       	call   802413 <sys_allocate_chunk>
  801e25:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e28:	a1 20 51 80 00       	mov    0x805120,%eax
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	50                   	push   %eax
  801e31:	e8 63 0c 00 00       	call   802a99 <initialize_MemBlocksList>
  801e36:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801e39:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801e3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801e41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e44:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801e4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e5c:	89 c2                	mov    %eax,%edx
  801e5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e61:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e67:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801e6e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801e75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e78:	8b 50 08             	mov    0x8(%eax),%edx
  801e7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e7e:	01 d0                	add    %edx,%eax
  801e80:	48                   	dec    %eax
  801e81:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e87:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8c:	f7 75 e0             	divl   -0x20(%ebp)
  801e8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e92:	29 d0                	sub    %edx,%eax
  801e94:	89 c2                	mov    %eax,%edx
  801e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e99:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801e9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ea0:	75 14                	jne    801eb6 <initialize_dyn_block_system+0x11f>
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	68 15 46 80 00       	push   $0x804615
  801eaa:	6a 34                	push   $0x34
  801eac:	68 33 46 80 00       	push   $0x804633
  801eb1:	e8 72 ee ff ff       	call   800d28 <_panic>
  801eb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eb9:	8b 00                	mov    (%eax),%eax
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	74 10                	je     801ecf <initialize_dyn_block_system+0x138>
  801ebf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ec2:	8b 00                	mov    (%eax),%eax
  801ec4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ec7:	8b 52 04             	mov    0x4(%edx),%edx
  801eca:	89 50 04             	mov    %edx,0x4(%eax)
  801ecd:	eb 0b                	jmp    801eda <initialize_dyn_block_system+0x143>
  801ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ed2:	8b 40 04             	mov    0x4(%eax),%eax
  801ed5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801eda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801edd:	8b 40 04             	mov    0x4(%eax),%eax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	74 0f                	je     801ef3 <initialize_dyn_block_system+0x15c>
  801ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ee7:	8b 40 04             	mov    0x4(%eax),%eax
  801eea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eed:	8b 12                	mov    (%edx),%edx
  801eef:	89 10                	mov    %edx,(%eax)
  801ef1:	eb 0a                	jmp    801efd <initialize_dyn_block_system+0x166>
  801ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef6:	8b 00                	mov    (%eax),%eax
  801ef8:	a3 48 51 80 00       	mov    %eax,0x805148
  801efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f10:	a1 54 51 80 00       	mov    0x805154,%eax
  801f15:	48                   	dec    %eax
  801f16:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	ff 75 e8             	pushl  -0x18(%ebp)
  801f21:	e8 c4 13 00 00       	call   8032ea <insert_sorted_with_merge_freeList>
  801f26:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801f29:	90                   	nop
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <malloc>:
//=================================



void* malloc(uint32 size)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f32:	e8 2f fe ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f3b:	75 07                	jne    801f44 <malloc+0x18>
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	eb 71                	jmp    801fb5 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801f44:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801f4b:	76 07                	jbe    801f54 <malloc+0x28>
	return NULL;
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f52:	eb 61                	jmp    801fb5 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f54:	e8 88 08 00 00       	call   8027e1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	74 53                	je     801fb0 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801f5d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f64:	8b 55 08             	mov    0x8(%ebp),%edx
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	01 d0                	add    %edx,%eax
  801f6c:	48                   	dec    %eax
  801f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f73:	ba 00 00 00 00       	mov    $0x0,%edx
  801f78:	f7 75 f4             	divl   -0xc(%ebp)
  801f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7e:	29 d0                	sub    %edx,%eax
  801f80:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801f83:	83 ec 0c             	sub    $0xc,%esp
  801f86:	ff 75 ec             	pushl  -0x14(%ebp)
  801f89:	e8 d2 0d 00 00       	call   802d60 <alloc_block_FF>
  801f8e:	83 c4 10             	add    $0x10,%esp
  801f91:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801f94:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f98:	74 16                	je     801fb0 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	ff 75 e8             	pushl  -0x18(%ebp)
  801fa0:	e8 0c 0c 00 00       	call   802bb1 <insert_sorted_allocList>
  801fa5:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801fa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fab:	8b 40 08             	mov    0x8(%eax),%eax
  801fae:	eb 05                	jmp    801fb5 <malloc+0x89>
    }

			}


	return NULL;
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801fce:	83 ec 08             	sub    $0x8,%esp
  801fd1:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd4:	68 40 50 80 00       	push   $0x805040
  801fd9:	e8 a0 0b 00 00       	call   802b7e <find_block>
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe7:	8b 50 0c             	mov    0xc(%eax),%edx
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	83 ec 08             	sub    $0x8,%esp
  801ff0:	52                   	push   %edx
  801ff1:	50                   	push   %eax
  801ff2:	e8 e4 03 00 00       	call   8023db <sys_free_user_mem>
  801ff7:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801ffa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ffe:	75 17                	jne    802017 <free+0x60>
  802000:	83 ec 04             	sub    $0x4,%esp
  802003:	68 15 46 80 00       	push   $0x804615
  802008:	68 84 00 00 00       	push   $0x84
  80200d:	68 33 46 80 00       	push   $0x804633
  802012:	e8 11 ed ff ff       	call   800d28 <_panic>
  802017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201a:	8b 00                	mov    (%eax),%eax
  80201c:	85 c0                	test   %eax,%eax
  80201e:	74 10                	je     802030 <free+0x79>
  802020:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802023:	8b 00                	mov    (%eax),%eax
  802025:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802028:	8b 52 04             	mov    0x4(%edx),%edx
  80202b:	89 50 04             	mov    %edx,0x4(%eax)
  80202e:	eb 0b                	jmp    80203b <free+0x84>
  802030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802033:	8b 40 04             	mov    0x4(%eax),%eax
  802036:	a3 44 50 80 00       	mov    %eax,0x805044
  80203b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203e:	8b 40 04             	mov    0x4(%eax),%eax
  802041:	85 c0                	test   %eax,%eax
  802043:	74 0f                	je     802054 <free+0x9d>
  802045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802048:	8b 40 04             	mov    0x4(%eax),%eax
  80204b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80204e:	8b 12                	mov    (%edx),%edx
  802050:	89 10                	mov    %edx,(%eax)
  802052:	eb 0a                	jmp    80205e <free+0xa7>
  802054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802057:	8b 00                	mov    (%eax),%eax
  802059:	a3 40 50 80 00       	mov    %eax,0x805040
  80205e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802061:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802071:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802076:	48                   	dec    %eax
  802077:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  80207c:	83 ec 0c             	sub    $0xc,%esp
  80207f:	ff 75 ec             	pushl  -0x14(%ebp)
  802082:	e8 63 12 00 00       	call   8032ea <insert_sorted_with_merge_freeList>
  802087:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80208a:	90                   	nop
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 38             	sub    $0x38,%esp
  802093:	8b 45 10             	mov    0x10(%ebp),%eax
  802096:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802099:	e8 c8 fc ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  80209e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020a2:	75 0a                	jne    8020ae <smalloc+0x21>
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	e9 a0 00 00 00       	jmp    80214e <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8020ae:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8020b5:	76 0a                	jbe    8020c1 <smalloc+0x34>
		return NULL;
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	e9 8d 00 00 00       	jmp    80214e <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020c1:	e8 1b 07 00 00       	call   8027e1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	74 7f                	je     802149 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8020ca:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8020d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	01 d0                	add    %edx,%eax
  8020d9:	48                   	dec    %eax
  8020da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e5:	f7 75 f4             	divl   -0xc(%ebp)
  8020e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020eb:	29 d0                	sub    %edx,%eax
  8020ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8020f0:	83 ec 0c             	sub    $0xc,%esp
  8020f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8020f6:	e8 65 0c 00 00       	call   802d60 <alloc_block_FF>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  802101:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802105:	74 42                	je     802149 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  802107:	83 ec 0c             	sub    $0xc,%esp
  80210a:	ff 75 e8             	pushl  -0x18(%ebp)
  80210d:	e8 9f 0a 00 00       	call   802bb1 <insert_sorted_allocList>
  802112:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  802115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802118:	8b 40 08             	mov    0x8(%eax),%eax
  80211b:	89 c2                	mov    %eax,%edx
  80211d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802121:	52                   	push   %edx
  802122:	50                   	push   %eax
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	ff 75 08             	pushl  0x8(%ebp)
  802129:	e8 38 04 00 00       	call   802566 <sys_createSharedObject>
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  802134:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802138:	79 07                	jns    802141 <smalloc+0xb4>
	    		  return NULL;
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	eb 0d                	jmp    80214e <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  802141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802144:	8b 40 08             	mov    0x8(%eax),%eax
  802147:	eb 05                	jmp    80214e <smalloc+0xc1>


				}


		return NULL;
  802149:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802156:	e8 0b fc ff ff       	call   801d66 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80215b:	e8 81 06 00 00       	call   8027e1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802160:	85 c0                	test   %eax,%eax
  802162:	0f 84 9f 00 00 00    	je     802207 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802168:	83 ec 08             	sub    $0x8,%esp
  80216b:	ff 75 0c             	pushl  0xc(%ebp)
  80216e:	ff 75 08             	pushl  0x8(%ebp)
  802171:	e8 1a 04 00 00       	call   802590 <sys_getSizeOfSharedObject>
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80217c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802180:	79 0a                	jns    80218c <sget+0x3c>
		return NULL;
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
  802187:	e9 80 00 00 00       	jmp    80220c <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80218c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802199:	01 d0                	add    %edx,%eax
  80219b:	48                   	dec    %eax
  80219c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80219f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a7:	f7 75 f0             	divl   -0x10(%ebp)
  8021aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ad:	29 d0                	sub    %edx,%eax
  8021af:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8021b2:	83 ec 0c             	sub    $0xc,%esp
  8021b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8021b8:	e8 a3 0b 00 00       	call   802d60 <alloc_block_FF>
  8021bd:	83 c4 10             	add    $0x10,%esp
  8021c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  8021c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021c7:	74 3e                	je     802207 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021cf:	e8 dd 09 00 00       	call   802bb1 <insert_sorted_allocList>
  8021d4:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8021d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021da:	8b 40 08             	mov    0x8(%eax),%eax
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	50                   	push   %eax
  8021e1:	ff 75 0c             	pushl  0xc(%ebp)
  8021e4:	ff 75 08             	pushl  0x8(%ebp)
  8021e7:	e8 c1 03 00 00       	call   8025ad <sys_getSharedObject>
  8021ec:	83 c4 10             	add    $0x10,%esp
  8021ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8021f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021f6:	79 07                	jns    8021ff <sget+0xaf>
	    		  return NULL;
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fd:	eb 0d                	jmp    80220c <sget+0xbc>
	  	return(void*) returned_block->sva;
  8021ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802202:	8b 40 08             	mov    0x8(%eax),%eax
  802205:	eb 05                	jmp    80220c <sget+0xbc>
	      }
	}
	   return NULL;
  802207:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802214:	e8 4d fb ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802219:	83 ec 04             	sub    $0x4,%esp
  80221c:	68 40 46 80 00       	push   $0x804640
  802221:	68 12 01 00 00       	push   $0x112
  802226:	68 33 46 80 00       	push   $0x804633
  80222b:	e8 f8 ea ff ff       	call   800d28 <_panic>

00802230 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	68 68 46 80 00       	push   $0x804668
  80223e:	68 26 01 00 00       	push   $0x126
  802243:	68 33 46 80 00       	push   $0x804633
  802248:	e8 db ea ff ff       	call   800d28 <_panic>

0080224d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	68 8c 46 80 00       	push   $0x80468c
  80225b:	68 31 01 00 00       	push   $0x131
  802260:	68 33 46 80 00       	push   $0x804633
  802265:	e8 be ea ff ff       	call   800d28 <_panic>

0080226a <shrink>:

}
void shrink(uint32 newSize)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	68 8c 46 80 00       	push   $0x80468c
  802278:	68 36 01 00 00       	push   $0x136
  80227d:	68 33 46 80 00       	push   $0x804633
  802282:	e8 a1 ea ff ff       	call   800d28 <_panic>

00802287 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80228d:	83 ec 04             	sub    $0x4,%esp
  802290:	68 8c 46 80 00       	push   $0x80468c
  802295:	68 3b 01 00 00       	push   $0x13b
  80229a:	68 33 46 80 00       	push   $0x804633
  80229f:	e8 84 ea ff ff       	call   800d28 <_panic>

008022a4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	57                   	push   %edi
  8022a8:	56                   	push   %esi
  8022a9:	53                   	push   %ebx
  8022aa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022b9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022bc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022bf:	cd 30                	int    $0x30
  8022c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022c7:	83 c4 10             	add    $0x10,%esp
  8022ca:	5b                   	pop    %ebx
  8022cb:	5e                   	pop    %esi
  8022cc:	5f                   	pop    %edi
  8022cd:	5d                   	pop    %ebp
  8022ce:	c3                   	ret    

008022cf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 04             	sub    $0x4,%esp
  8022d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	52                   	push   %edx
  8022e7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ea:	50                   	push   %eax
  8022eb:	6a 00                	push   $0x0
  8022ed:	e8 b2 ff ff ff       	call   8022a4 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
}
  8022f5:	90                   	nop
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 01                	push   $0x1
  802307:	e8 98 ff ff ff       	call   8022a4 <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802314:	8b 55 0c             	mov    0xc(%ebp),%edx
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	52                   	push   %edx
  802321:	50                   	push   %eax
  802322:	6a 05                	push   $0x5
  802324:	e8 7b ff ff ff       	call   8022a4 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	56                   	push   %esi
  802332:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802333:	8b 75 18             	mov    0x18(%ebp),%esi
  802336:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802339:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	51                   	push   %ecx
  802345:	52                   	push   %edx
  802346:	50                   	push   %eax
  802347:	6a 06                	push   $0x6
  802349:	e8 56 ff ff ff       	call   8022a4 <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
}
  802351:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802354:	5b                   	pop    %ebx
  802355:	5e                   	pop    %esi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    

00802358 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80235b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	52                   	push   %edx
  802368:	50                   	push   %eax
  802369:	6a 07                	push   $0x7
  80236b:	e8 34 ff ff ff       	call   8022a4 <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	ff 75 0c             	pushl  0xc(%ebp)
  802381:	ff 75 08             	pushl  0x8(%ebp)
  802384:	6a 08                	push   $0x8
  802386:	e8 19 ff ff ff       	call   8022a4 <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 09                	push   $0x9
  80239f:	e8 00 ff ff ff       	call   8022a4 <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 0a                	push   $0xa
  8023b8:	e8 e7 fe ff ff       	call   8022a4 <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 0b                	push   $0xb
  8023d1:	e8 ce fe ff ff       	call   8022a4 <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	ff 75 0c             	pushl  0xc(%ebp)
  8023e7:	ff 75 08             	pushl  0x8(%ebp)
  8023ea:	6a 0f                	push   $0xf
  8023ec:	e8 b3 fe ff ff       	call   8022a4 <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
	return;
  8023f4:	90                   	nop
}
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	ff 75 0c             	pushl  0xc(%ebp)
  802403:	ff 75 08             	pushl  0x8(%ebp)
  802406:	6a 10                	push   $0x10
  802408:	e8 97 fe ff ff       	call   8022a4 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
	return ;
  802410:	90                   	nop
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	ff 75 10             	pushl  0x10(%ebp)
  80241d:	ff 75 0c             	pushl  0xc(%ebp)
  802420:	ff 75 08             	pushl  0x8(%ebp)
  802423:	6a 11                	push   $0x11
  802425:	e8 7a fe ff ff       	call   8022a4 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
	return ;
  80242d:	90                   	nop
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 0c                	push   $0xc
  80243f:	e8 60 fe ff ff       	call   8022a4 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	ff 75 08             	pushl  0x8(%ebp)
  802457:	6a 0d                	push   $0xd
  802459:	e8 46 fe ff ff       	call   8022a4 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
}
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 0e                	push   $0xe
  802472:	e8 2d fe ff ff       	call   8022a4 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	90                   	nop
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 13                	push   $0x13
  80248c:	e8 13 fe ff ff       	call   8022a4 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	90                   	nop
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 14                	push   $0x14
  8024a6:	e8 f9 fd ff ff       	call   8022a4 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	90                   	nop
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 04             	sub    $0x4,%esp
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	50                   	push   %eax
  8024ca:	6a 15                	push   $0x15
  8024cc:	e8 d3 fd ff ff       	call   8022a4 <syscall>
  8024d1:	83 c4 18             	add    $0x18,%esp
}
  8024d4:	90                   	nop
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 16                	push   $0x16
  8024e6:	e8 b9 fd ff ff       	call   8022a4 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
}
  8024ee:	90                   	nop
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	ff 75 0c             	pushl  0xc(%ebp)
  802500:	50                   	push   %eax
  802501:	6a 17                	push   $0x17
  802503:	e8 9c fd ff ff       	call   8022a4 <syscall>
  802508:	83 c4 18             	add    $0x18,%esp
}
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802510:	8b 55 0c             	mov    0xc(%ebp),%edx
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	52                   	push   %edx
  80251d:	50                   	push   %eax
  80251e:	6a 1a                	push   $0x1a
  802520:	e8 7f fd ff ff       	call   8022a4 <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80252d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	52                   	push   %edx
  80253a:	50                   	push   %eax
  80253b:	6a 18                	push   $0x18
  80253d:	e8 62 fd ff ff       	call   8022a4 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
}
  802545:	90                   	nop
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80254b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	52                   	push   %edx
  802558:	50                   	push   %eax
  802559:	6a 19                	push   $0x19
  80255b:	e8 44 fd ff ff       	call   8022a4 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	90                   	nop
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	83 ec 04             	sub    $0x4,%esp
  80256c:	8b 45 10             	mov    0x10(%ebp),%eax
  80256f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802572:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802575:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	6a 00                	push   $0x0
  80257e:	51                   	push   %ecx
  80257f:	52                   	push   %edx
  802580:	ff 75 0c             	pushl  0xc(%ebp)
  802583:	50                   	push   %eax
  802584:	6a 1b                	push   $0x1b
  802586:	e8 19 fd ff ff       	call   8022a4 <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802593:	8b 55 0c             	mov    0xc(%ebp),%edx
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	52                   	push   %edx
  8025a0:	50                   	push   %eax
  8025a1:	6a 1c                	push   $0x1c
  8025a3:	e8 fc fc ff ff       	call   8022a4 <syscall>
  8025a8:	83 c4 18             	add    $0x18,%esp
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8025b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	51                   	push   %ecx
  8025be:	52                   	push   %edx
  8025bf:	50                   	push   %eax
  8025c0:	6a 1d                	push   $0x1d
  8025c2:	e8 dd fc ff ff       	call   8022a4 <syscall>
  8025c7:	83 c4 18             	add    $0x18,%esp
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	52                   	push   %edx
  8025dc:	50                   	push   %eax
  8025dd:	6a 1e                	push   $0x1e
  8025df:	e8 c0 fc ff ff       	call   8022a4 <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 1f                	push   $0x1f
  8025f8:	e8 a7 fc ff ff       	call   8022a4 <syscall>
  8025fd:	83 c4 18             	add    $0x18,%esp
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802605:	8b 45 08             	mov    0x8(%ebp),%eax
  802608:	6a 00                	push   $0x0
  80260a:	ff 75 14             	pushl  0x14(%ebp)
  80260d:	ff 75 10             	pushl  0x10(%ebp)
  802610:	ff 75 0c             	pushl  0xc(%ebp)
  802613:	50                   	push   %eax
  802614:	6a 20                	push   $0x20
  802616:	e8 89 fc ff ff       	call   8022a4 <syscall>
  80261b:	83 c4 18             	add    $0x18,%esp
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	50                   	push   %eax
  80262f:	6a 21                	push   $0x21
  802631:	e8 6e fc ff ff       	call   8022a4 <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	90                   	nop
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	50                   	push   %eax
  80264b:	6a 22                	push   $0x22
  80264d:	e8 52 fc ff ff       	call   8022a4 <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 02                	push   $0x2
  802666:	e8 39 fc ff ff       	call   8022a4 <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 03                	push   $0x3
  80267f:	e8 20 fc ff ff       	call   8022a4 <syscall>
  802684:	83 c4 18             	add    $0x18,%esp
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 04                	push   $0x4
  802698:	e8 07 fc ff ff       	call   8022a4 <syscall>
  80269d:	83 c4 18             	add    $0x18,%esp
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <sys_exit_env>:


void sys_exit_env(void)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 23                	push   $0x23
  8026b1:	e8 ee fb ff ff       	call   8022a4 <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
}
  8026b9:	90                   	nop
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
  8026bf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026c2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026c5:	8d 50 04             	lea    0x4(%eax),%edx
  8026c8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	52                   	push   %edx
  8026d2:	50                   	push   %eax
  8026d3:	6a 24                	push   $0x24
  8026d5:	e8 ca fb ff ff       	call   8022a4 <syscall>
  8026da:	83 c4 18             	add    $0x18,%esp
	return result;
  8026dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026e6:	89 01                	mov    %eax,(%ecx)
  8026e8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	c9                   	leave  
  8026ef:	c2 04 00             	ret    $0x4

008026f2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	ff 75 10             	pushl  0x10(%ebp)
  8026fc:	ff 75 0c             	pushl  0xc(%ebp)
  8026ff:	ff 75 08             	pushl  0x8(%ebp)
  802702:	6a 12                	push   $0x12
  802704:	e8 9b fb ff ff       	call   8022a4 <syscall>
  802709:	83 c4 18             	add    $0x18,%esp
	return ;
  80270c:	90                   	nop
}
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <sys_rcr2>:
uint32 sys_rcr2()
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 25                	push   $0x25
  80271e:	e8 81 fb ff ff       	call   8022a4 <syscall>
  802723:	83 c4 18             	add    $0x18,%esp
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	8b 45 08             	mov    0x8(%ebp),%eax
  802731:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802734:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	50                   	push   %eax
  802741:	6a 26                	push   $0x26
  802743:	e8 5c fb ff ff       	call   8022a4 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
	return ;
  80274b:	90                   	nop
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <rsttst>:
void rsttst()
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 28                	push   $0x28
  80275d:	e8 42 fb ff ff       	call   8022a4 <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
	return ;
  802765:	90                   	nop
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	8b 45 14             	mov    0x14(%ebp),%eax
  802771:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802774:	8b 55 18             	mov    0x18(%ebp),%edx
  802777:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80277b:	52                   	push   %edx
  80277c:	50                   	push   %eax
  80277d:	ff 75 10             	pushl  0x10(%ebp)
  802780:	ff 75 0c             	pushl  0xc(%ebp)
  802783:	ff 75 08             	pushl  0x8(%ebp)
  802786:	6a 27                	push   $0x27
  802788:	e8 17 fb ff ff       	call   8022a4 <syscall>
  80278d:	83 c4 18             	add    $0x18,%esp
	return ;
  802790:	90                   	nop
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <chktst>:
void chktst(uint32 n)
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	ff 75 08             	pushl  0x8(%ebp)
  8027a1:	6a 29                	push   $0x29
  8027a3:	e8 fc fa ff ff       	call   8022a4 <syscall>
  8027a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ab:	90                   	nop
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <inctst>:

void inctst()
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 2a                	push   $0x2a
  8027bd:	e8 e2 fa ff ff       	call   8022a4 <syscall>
  8027c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c5:	90                   	nop
}
  8027c6:	c9                   	leave  
  8027c7:	c3                   	ret    

008027c8 <gettst>:
uint32 gettst()
{
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 2b                	push   $0x2b
  8027d7:	e8 c8 fa ff ff       	call   8022a4 <syscall>
  8027dc:	83 c4 18             	add    $0x18,%esp
}
  8027df:	c9                   	leave  
  8027e0:	c3                   	ret    

008027e1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 2c                	push   $0x2c
  8027f3:	e8 ac fa ff ff       	call   8022a4 <syscall>
  8027f8:	83 c4 18             	add    $0x18,%esp
  8027fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027fe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802802:	75 07                	jne    80280b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802804:	b8 01 00 00 00       	mov    $0x1,%eax
  802809:	eb 05                	jmp    802810 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80280b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802810:	c9                   	leave  
  802811:	c3                   	ret    

00802812 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802812:	55                   	push   %ebp
  802813:	89 e5                	mov    %esp,%ebp
  802815:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 2c                	push   $0x2c
  802824:	e8 7b fa ff ff       	call   8022a4 <syscall>
  802829:	83 c4 18             	add    $0x18,%esp
  80282c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80282f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802833:	75 07                	jne    80283c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802835:	b8 01 00 00 00       	mov    $0x1,%eax
  80283a:	eb 05                	jmp    802841 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80283c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 2c                	push   $0x2c
  802855:	e8 4a fa ff ff       	call   8022a4 <syscall>
  80285a:	83 c4 18             	add    $0x18,%esp
  80285d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802860:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802864:	75 07                	jne    80286d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802866:	b8 01 00 00 00       	mov    $0x1,%eax
  80286b:	eb 05                	jmp    802872 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80287a:	6a 00                	push   $0x0
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 2c                	push   $0x2c
  802886:	e8 19 fa ff ff       	call   8022a4 <syscall>
  80288b:	83 c4 18             	add    $0x18,%esp
  80288e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802891:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802895:	75 07                	jne    80289e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802897:	b8 01 00 00 00       	mov    $0x1,%eax
  80289c:	eb 05                	jmp    8028a3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80289e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	ff 75 08             	pushl  0x8(%ebp)
  8028b3:	6a 2d                	push   $0x2d
  8028b5:	e8 ea f9 ff ff       	call   8022a4 <syscall>
  8028ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8028bd:	90                   	nop
}
  8028be:	c9                   	leave  
  8028bf:	c3                   	ret    

008028c0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
  8028c3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	6a 00                	push   $0x0
  8028d2:	53                   	push   %ebx
  8028d3:	51                   	push   %ecx
  8028d4:	52                   	push   %edx
  8028d5:	50                   	push   %eax
  8028d6:	6a 2e                	push   $0x2e
  8028d8:	e8 c7 f9 ff ff       	call   8022a4 <syscall>
  8028dd:	83 c4 18             	add    $0x18,%esp
}
  8028e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	6a 00                	push   $0x0
  8028f4:	52                   	push   %edx
  8028f5:	50                   	push   %eax
  8028f6:	6a 2f                	push   $0x2f
  8028f8:	e8 a7 f9 ff ff       	call   8022a4 <syscall>
  8028fd:	83 c4 18             	add    $0x18,%esp
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802908:	83 ec 0c             	sub    $0xc,%esp
  80290b:	68 9c 46 80 00       	push   $0x80469c
  802910:	e8 c7 e6 ff ff       	call   800fdc <cprintf>
  802915:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802918:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80291f:	83 ec 0c             	sub    $0xc,%esp
  802922:	68 c8 46 80 00       	push   $0x8046c8
  802927:	e8 b0 e6 ff ff       	call   800fdc <cprintf>
  80292c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80292f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802933:	a1 38 51 80 00       	mov    0x805138,%eax
  802938:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293b:	eb 56                	jmp    802993 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80293d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802941:	74 1c                	je     80295f <print_mem_block_lists+0x5d>
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 50 08             	mov    0x8(%eax),%edx
  802949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294c:	8b 48 08             	mov    0x8(%eax),%ecx
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 40 0c             	mov    0xc(%eax),%eax
  802955:	01 c8                	add    %ecx,%eax
  802957:	39 c2                	cmp    %eax,%edx
  802959:	73 04                	jae    80295f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80295b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 50 08             	mov    0x8(%eax),%edx
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 0c             	mov    0xc(%eax),%eax
  80296b:	01 c2                	add    %eax,%edx
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 08             	mov    0x8(%eax),%eax
  802973:	83 ec 04             	sub    $0x4,%esp
  802976:	52                   	push   %edx
  802977:	50                   	push   %eax
  802978:	68 dd 46 80 00       	push   $0x8046dd
  80297d:	e8 5a e6 ff ff       	call   800fdc <cprintf>
  802982:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80298b:	a1 40 51 80 00       	mov    0x805140,%eax
  802990:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802997:	74 07                	je     8029a0 <print_mem_block_lists+0x9e>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	eb 05                	jmp    8029a5 <print_mem_block_lists+0xa3>
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a5:	a3 40 51 80 00       	mov    %eax,0x805140
  8029aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	75 8a                	jne    80293d <print_mem_block_lists+0x3b>
  8029b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b7:	75 84                	jne    80293d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029b9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029bd:	75 10                	jne    8029cf <print_mem_block_lists+0xcd>
  8029bf:	83 ec 0c             	sub    $0xc,%esp
  8029c2:	68 ec 46 80 00       	push   $0x8046ec
  8029c7:	e8 10 e6 ff ff       	call   800fdc <cprintf>
  8029cc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029d6:	83 ec 0c             	sub    $0xc,%esp
  8029d9:	68 10 47 80 00       	push   $0x804710
  8029de:	e8 f9 e5 ff ff       	call   800fdc <cprintf>
  8029e3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8029e6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029ea:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f2:	eb 56                	jmp    802a4a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f8:	74 1c                	je     802a16 <print_mem_block_lists+0x114>
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 50 08             	mov    0x8(%eax),%edx
  802a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a03:	8b 48 08             	mov    0x8(%eax),%ecx
  802a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a09:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0c:	01 c8                	add    %ecx,%eax
  802a0e:	39 c2                	cmp    %eax,%edx
  802a10:	73 04                	jae    802a16 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802a12:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 50 08             	mov    0x8(%eax),%edx
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a22:	01 c2                	add    %eax,%edx
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 08             	mov    0x8(%eax),%eax
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	52                   	push   %edx
  802a2e:	50                   	push   %eax
  802a2f:	68 dd 46 80 00       	push   $0x8046dd
  802a34:	e8 a3 e5 ff ff       	call   800fdc <cprintf>
  802a39:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a42:	a1 48 50 80 00       	mov    0x805048,%eax
  802a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4e:	74 07                	je     802a57 <print_mem_block_lists+0x155>
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 00                	mov    (%eax),%eax
  802a55:	eb 05                	jmp    802a5c <print_mem_block_lists+0x15a>
  802a57:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5c:	a3 48 50 80 00       	mov    %eax,0x805048
  802a61:	a1 48 50 80 00       	mov    0x805048,%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	75 8a                	jne    8029f4 <print_mem_block_lists+0xf2>
  802a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6e:	75 84                	jne    8029f4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a70:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a74:	75 10                	jne    802a86 <print_mem_block_lists+0x184>
  802a76:	83 ec 0c             	sub    $0xc,%esp
  802a79:	68 28 47 80 00       	push   $0x804728
  802a7e:	e8 59 e5 ff ff       	call   800fdc <cprintf>
  802a83:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a86:	83 ec 0c             	sub    $0xc,%esp
  802a89:	68 9c 46 80 00       	push   $0x80469c
  802a8e:	e8 49 e5 ff ff       	call   800fdc <cprintf>
  802a93:	83 c4 10             	add    $0x10,%esp

}
  802a96:	90                   	nop
  802a97:	c9                   	leave  
  802a98:	c3                   	ret    

00802a99 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a99:	55                   	push   %ebp
  802a9a:	89 e5                	mov    %esp,%ebp
  802a9c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802a9f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802aa6:	00 00 00 
  802aa9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802ab0:	00 00 00 
  802ab3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802aba:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802abd:	a1 50 50 80 00       	mov    0x805050,%eax
  802ac2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802acc:	e9 9e 00 00 00       	jmp    802b6f <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802ad1:	a1 50 50 80 00       	mov    0x805050,%eax
  802ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad9:	c1 e2 04             	shl    $0x4,%edx
  802adc:	01 d0                	add    %edx,%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	75 14                	jne    802af6 <initialize_MemBlocksList+0x5d>
  802ae2:	83 ec 04             	sub    $0x4,%esp
  802ae5:	68 50 47 80 00       	push   $0x804750
  802aea:	6a 48                	push   $0x48
  802aec:	68 73 47 80 00       	push   $0x804773
  802af1:	e8 32 e2 ff ff       	call   800d28 <_panic>
  802af6:	a1 50 50 80 00       	mov    0x805050,%eax
  802afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afe:	c1 e2 04             	shl    $0x4,%edx
  802b01:	01 d0                	add    %edx,%eax
  802b03:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b09:	89 10                	mov    %edx,(%eax)
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 18                	je     802b29 <initialize_MemBlocksList+0x90>
  802b11:	a1 48 51 80 00       	mov    0x805148,%eax
  802b16:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b1c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b1f:	c1 e1 04             	shl    $0x4,%ecx
  802b22:	01 ca                	add    %ecx,%edx
  802b24:	89 50 04             	mov    %edx,0x4(%eax)
  802b27:	eb 12                	jmp    802b3b <initialize_MemBlocksList+0xa2>
  802b29:	a1 50 50 80 00       	mov    0x805050,%eax
  802b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b31:	c1 e2 04             	shl    $0x4,%edx
  802b34:	01 d0                	add    %edx,%eax
  802b36:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b3b:	a1 50 50 80 00       	mov    0x805050,%eax
  802b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b43:	c1 e2 04             	shl    $0x4,%edx
  802b46:	01 d0                	add    %edx,%eax
  802b48:	a3 48 51 80 00       	mov    %eax,0x805148
  802b4d:	a1 50 50 80 00       	mov    0x805050,%eax
  802b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b55:	c1 e2 04             	shl    $0x4,%edx
  802b58:	01 d0                	add    %edx,%eax
  802b5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b61:	a1 54 51 80 00       	mov    0x805154,%eax
  802b66:	40                   	inc    %eax
  802b67:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802b6c:	ff 45 f4             	incl   -0xc(%ebp)
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b75:	0f 82 56 ff ff ff    	jb     802ad1 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802b7b:	90                   	nop
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    

00802b7e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b7e:	55                   	push   %ebp
  802b7f:	89 e5                	mov    %esp,%ebp
  802b81:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	8b 00                	mov    (%eax),%eax
  802b89:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802b8c:	eb 18                	jmp    802ba6 <find_block+0x28>
		{
			if(tmp->sva==va)
  802b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b91:	8b 40 08             	mov    0x8(%eax),%eax
  802b94:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b97:	75 05                	jne    802b9e <find_block+0x20>
			{
				return tmp;
  802b99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b9c:	eb 11                	jmp    802baf <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802b9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802ba6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802baa:	75 e2                	jne    802b8e <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802baf:	c9                   	leave  
  802bb0:	c3                   	ret    

00802bb1 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
  802bb4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802bb7:	a1 40 50 80 00       	mov    0x805040,%eax
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	0f 85 83 00 00 00    	jne    802c47 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802bc4:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802bcb:	00 00 00 
  802bce:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802bd5:	00 00 00 
  802bd8:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802bdf:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802be2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be6:	75 14                	jne    802bfc <insert_sorted_allocList+0x4b>
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	68 50 47 80 00       	push   $0x804750
  802bf0:	6a 7f                	push   $0x7f
  802bf2:	68 73 47 80 00       	push   $0x804773
  802bf7:	e8 2c e1 ff ff       	call   800d28 <_panic>
  802bfc:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0d                	je     802c1d <insert_sorted_allocList+0x6c>
  802c10:	a1 40 50 80 00       	mov    0x805040,%eax
  802c15:	8b 55 08             	mov    0x8(%ebp),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	eb 08                	jmp    802c25 <insert_sorted_allocList+0x74>
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	a3 44 50 80 00       	mov    %eax,0x805044
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	a3 40 50 80 00       	mov    %eax,0x805040
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c37:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c3c:	40                   	inc    %eax
  802c3d:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802c42:	e9 16 01 00 00       	jmp    802d5d <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	8b 50 08             	mov    0x8(%eax),%edx
  802c4d:	a1 44 50 80 00       	mov    0x805044,%eax
  802c52:	8b 40 08             	mov    0x8(%eax),%eax
  802c55:	39 c2                	cmp    %eax,%edx
  802c57:	76 68                	jbe    802cc1 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802c59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5d:	75 17                	jne    802c76 <insert_sorted_allocList+0xc5>
  802c5f:	83 ec 04             	sub    $0x4,%esp
  802c62:	68 8c 47 80 00       	push   $0x80478c
  802c67:	68 85 00 00 00       	push   $0x85
  802c6c:	68 73 47 80 00       	push   $0x804773
  802c71:	e8 b2 e0 ff ff       	call   800d28 <_panic>
  802c76:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 40 04             	mov    0x4(%eax),%eax
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	74 0c                	je     802c98 <insert_sorted_allocList+0xe7>
  802c8c:	a1 44 50 80 00       	mov    0x805044,%eax
  802c91:	8b 55 08             	mov    0x8(%ebp),%edx
  802c94:	89 10                	mov    %edx,(%eax)
  802c96:	eb 08                	jmp    802ca0 <insert_sorted_allocList+0xef>
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	a3 40 50 80 00       	mov    %eax,0x805040
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	a3 44 50 80 00       	mov    %eax,0x805044
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cb6:	40                   	inc    %eax
  802cb7:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802cbc:	e9 9c 00 00 00       	jmp    802d5d <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802cc1:	a1 40 50 80 00       	mov    0x805040,%eax
  802cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802cc9:	e9 85 00 00 00       	jmp    802d53 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	8b 50 08             	mov    0x8(%eax),%edx
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 40 08             	mov    0x8(%eax),%eax
  802cda:	39 c2                	cmp    %eax,%edx
  802cdc:	73 6d                	jae    802d4b <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce2:	74 06                	je     802cea <insert_sorted_allocList+0x139>
  802ce4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce8:	75 17                	jne    802d01 <insert_sorted_allocList+0x150>
  802cea:	83 ec 04             	sub    $0x4,%esp
  802ced:	68 b0 47 80 00       	push   $0x8047b0
  802cf2:	68 90 00 00 00       	push   $0x90
  802cf7:	68 73 47 80 00       	push   $0x804773
  802cfc:	e8 27 e0 ff ff       	call   800d28 <_panic>
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 50 04             	mov    0x4(%eax),%edx
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	89 50 04             	mov    %edx,0x4(%eax)
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d13:	89 10                	mov    %edx,(%eax)
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 40 04             	mov    0x4(%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	74 0d                	je     802d2c <insert_sorted_allocList+0x17b>
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 40 04             	mov    0x4(%eax),%eax
  802d25:	8b 55 08             	mov    0x8(%ebp),%edx
  802d28:	89 10                	mov    %edx,(%eax)
  802d2a:	eb 08                	jmp    802d34 <insert_sorted_allocList+0x183>
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	a3 40 50 80 00       	mov    %eax,0x805040
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3a:	89 50 04             	mov    %edx,0x4(%eax)
  802d3d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d42:	40                   	inc    %eax
  802d43:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d48:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802d49:	eb 12                	jmp    802d5d <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802d53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d57:	0f 85 71 ff ff ff    	jne    802cce <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802d5d:	90                   	nop
  802d5e:	c9                   	leave  
  802d5f:	c3                   	ret    

00802d60 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802d60:	55                   	push   %ebp
  802d61:	89 e5                	mov    %esp,%ebp
  802d63:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802d66:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802d6e:	e9 76 01 00 00       	jmp    802ee9 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 40 0c             	mov    0xc(%eax),%eax
  802d79:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7c:	0f 85 8a 00 00 00    	jne    802e0c <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802d82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d86:	75 17                	jne    802d9f <alloc_block_FF+0x3f>
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	68 e5 47 80 00       	push   $0x8047e5
  802d90:	68 a8 00 00 00       	push   $0xa8
  802d95:	68 73 47 80 00       	push   $0x804773
  802d9a:	e8 89 df ff ff       	call   800d28 <_panic>
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 10                	je     802db8 <alloc_block_FF+0x58>
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db0:	8b 52 04             	mov    0x4(%edx),%edx
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	eb 0b                	jmp    802dc3 <alloc_block_FF+0x63>
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 40 04             	mov    0x4(%eax),%eax
  802dbe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 40 04             	mov    0x4(%eax),%eax
  802dc9:	85 c0                	test   %eax,%eax
  802dcb:	74 0f                	je     802ddc <alloc_block_FF+0x7c>
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd6:	8b 12                	mov    (%edx),%edx
  802dd8:	89 10                	mov    %edx,(%eax)
  802dda:	eb 0a                	jmp    802de6 <alloc_block_FF+0x86>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	a3 38 51 80 00       	mov    %eax,0x805138
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df9:	a1 44 51 80 00       	mov    0x805144,%eax
  802dfe:	48                   	dec    %eax
  802dff:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	e9 ea 00 00 00       	jmp    802ef6 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e15:	0f 86 c6 00 00 00    	jbe    802ee1 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802e1b:	a1 48 51 80 00       	mov    0x805148,%eax
  802e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e26:	8b 55 08             	mov    0x8(%ebp),%edx
  802e29:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 50 08             	mov    0x8(%eax),%edx
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802e41:	89 c2                	mov    %eax,%edx
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 50 08             	mov    0x8(%eax),%edx
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	01 c2                	add    %eax,%edx
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802e5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5e:	75 17                	jne    802e77 <alloc_block_FF+0x117>
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 e5 47 80 00       	push   $0x8047e5
  802e68:	68 b6 00 00 00       	push   $0xb6
  802e6d:	68 73 47 80 00       	push   $0x804773
  802e72:	e8 b1 de ff ff       	call   800d28 <_panic>
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 10                	je     802e90 <alloc_block_FF+0x130>
  802e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e88:	8b 52 04             	mov    0x4(%edx),%edx
  802e8b:	89 50 04             	mov    %edx,0x4(%eax)
  802e8e:	eb 0b                	jmp    802e9b <alloc_block_FF+0x13b>
  802e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	74 0f                	je     802eb4 <alloc_block_FF+0x154>
  802ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea8:	8b 40 04             	mov    0x4(%eax),%eax
  802eab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eae:	8b 12                	mov    (%edx),%edx
  802eb0:	89 10                	mov    %edx,(%eax)
  802eb2:	eb 0a                	jmp    802ebe <alloc_block_FF+0x15e>
  802eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb7:	8b 00                	mov    (%eax),%eax
  802eb9:	a3 48 51 80 00       	mov    %eax,0x805148
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ed6:	48                   	dec    %eax
  802ed7:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	eb 15                	jmp    802ef6 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802ee9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eed:	0f 85 80 fe ff ff    	jne    802d73 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ef6:	c9                   	leave  
  802ef7:	c3                   	ret    

00802ef8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ef8:	55                   	push   %ebp
  802ef9:	89 e5                	mov    %esp,%ebp
  802efb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802efe:	a1 38 51 80 00       	mov    0x805138,%eax
  802f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802f06:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802f0d:	e9 c0 00 00 00       	jmp    802fd2 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 0c             	mov    0xc(%eax),%eax
  802f18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1b:	0f 85 8a 00 00 00    	jne    802fab <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f25:	75 17                	jne    802f3e <alloc_block_BF+0x46>
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	68 e5 47 80 00       	push   $0x8047e5
  802f2f:	68 cf 00 00 00       	push   $0xcf
  802f34:	68 73 47 80 00       	push   $0x804773
  802f39:	e8 ea dd ff ff       	call   800d28 <_panic>
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 10                	je     802f57 <alloc_block_BF+0x5f>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4f:	8b 52 04             	mov    0x4(%edx),%edx
  802f52:	89 50 04             	mov    %edx,0x4(%eax)
  802f55:	eb 0b                	jmp    802f62 <alloc_block_BF+0x6a>
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	8b 40 04             	mov    0x4(%eax),%eax
  802f5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	8b 40 04             	mov    0x4(%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	74 0f                	je     802f7b <alloc_block_BF+0x83>
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 40 04             	mov    0x4(%eax),%eax
  802f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f75:	8b 12                	mov    (%edx),%edx
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	eb 0a                	jmp    802f85 <alloc_block_BF+0x8d>
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	a3 38 51 80 00       	mov    %eax,0x805138
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f98:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9d:	48                   	dec    %eax
  802f9e:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	e9 2a 01 00 00       	jmp    8030d5 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802fb4:	73 14                	jae    802fca <alloc_block_BF+0xd2>
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fbf:	76 09                	jbe    802fca <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802fd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd6:	0f 85 36 ff ff ff    	jne    802f12 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802fdc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802fe4:	e9 dd 00 00 00       	jmp    8030c6 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 40 0c             	mov    0xc(%eax),%eax
  802fef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ff2:	0f 85 c6 00 00 00    	jne    8030be <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802ff8:	a1 48 51 80 00       	mov    0x805148,%eax
  802ffd:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 50 08             	mov    0x8(%eax),%edx
  803006:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803009:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80300c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300f:	8b 55 08             	mov    0x8(%ebp),%edx
  803012:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 50 08             	mov    0x8(%eax),%edx
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	01 c2                	add    %eax,%edx
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	8b 40 0c             	mov    0xc(%eax),%eax
  80302c:	2b 45 08             	sub    0x8(%ebp),%eax
  80302f:	89 c2                	mov    %eax,%edx
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803037:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80303b:	75 17                	jne    803054 <alloc_block_BF+0x15c>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 e5 47 80 00       	push   $0x8047e5
  803045:	68 eb 00 00 00       	push   $0xeb
  80304a:	68 73 47 80 00       	push   $0x804773
  80304f:	e8 d4 dc ff ff       	call   800d28 <_panic>
  803054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	74 10                	je     80306d <alloc_block_BF+0x175>
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803065:	8b 52 04             	mov    0x4(%edx),%edx
  803068:	89 50 04             	mov    %edx,0x4(%eax)
  80306b:	eb 0b                	jmp    803078 <alloc_block_BF+0x180>
  80306d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803070:	8b 40 04             	mov    0x4(%eax),%eax
  803073:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307b:	8b 40 04             	mov    0x4(%eax),%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	74 0f                	je     803091 <alloc_block_BF+0x199>
  803082:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803085:	8b 40 04             	mov    0x4(%eax),%eax
  803088:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80308b:	8b 12                	mov    (%edx),%edx
  80308d:	89 10                	mov    %edx,(%eax)
  80308f:	eb 0a                	jmp    80309b <alloc_block_BF+0x1a3>
  803091:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803094:	8b 00                	mov    (%eax),%eax
  803096:	a3 48 51 80 00       	mov    %eax,0x805148
  80309b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b3:	48                   	dec    %eax
  8030b4:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  8030b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bc:	eb 17                	jmp    8030d5 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  8030c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ca:	0f 85 19 ff ff ff    	jne    802fe9 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  8030d0:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8030d5:	c9                   	leave  
  8030d6:	c3                   	ret    

008030d7 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8030d7:	55                   	push   %ebp
  8030d8:	89 e5                	mov    %esp,%ebp
  8030da:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8030dd:	a1 40 50 80 00       	mov    0x805040,%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	75 19                	jne    8030ff <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8030e6:	83 ec 0c             	sub    $0xc,%esp
  8030e9:	ff 75 08             	pushl  0x8(%ebp)
  8030ec:	e8 6f fc ff ff       	call   802d60 <alloc_block_FF>
  8030f1:	83 c4 10             	add    $0x10,%esp
  8030f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	e9 e9 01 00 00       	jmp    8032e8 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  8030ff:	a1 44 50 80 00       	mov    0x805044,%eax
  803104:	8b 40 08             	mov    0x8(%eax),%eax
  803107:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80310a:	a1 44 50 80 00       	mov    0x805044,%eax
  80310f:	8b 50 0c             	mov    0xc(%eax),%edx
  803112:	a1 44 50 80 00       	mov    0x805044,%eax
  803117:	8b 40 08             	mov    0x8(%eax),%eax
  80311a:	01 d0                	add    %edx,%eax
  80311c:	83 ec 08             	sub    $0x8,%esp
  80311f:	50                   	push   %eax
  803120:	68 38 51 80 00       	push   $0x805138
  803125:	e8 54 fa ff ff       	call   802b7e <find_block>
  80312a:	83 c4 10             	add    $0x10,%esp
  80312d:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 40 0c             	mov    0xc(%eax),%eax
  803136:	3b 45 08             	cmp    0x8(%ebp),%eax
  803139:	0f 85 9b 00 00 00    	jne    8031da <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803142:	8b 50 0c             	mov    0xc(%eax),%edx
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 40 08             	mov    0x8(%eax),%eax
  80314b:	01 d0                	add    %edx,%eax
  80314d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  803150:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803154:	75 17                	jne    80316d <alloc_block_NF+0x96>
  803156:	83 ec 04             	sub    $0x4,%esp
  803159:	68 e5 47 80 00       	push   $0x8047e5
  80315e:	68 1a 01 00 00       	push   $0x11a
  803163:	68 73 47 80 00       	push   $0x804773
  803168:	e8 bb db ff ff       	call   800d28 <_panic>
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	8b 00                	mov    (%eax),%eax
  803172:	85 c0                	test   %eax,%eax
  803174:	74 10                	je     803186 <alloc_block_NF+0xaf>
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317e:	8b 52 04             	mov    0x4(%edx),%edx
  803181:	89 50 04             	mov    %edx,0x4(%eax)
  803184:	eb 0b                	jmp    803191 <alloc_block_NF+0xba>
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	8b 40 04             	mov    0x4(%eax),%eax
  80318c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 40 04             	mov    0x4(%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 0f                	je     8031aa <alloc_block_NF+0xd3>
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 40 04             	mov    0x4(%eax),%eax
  8031a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a4:	8b 12                	mov    (%edx),%edx
  8031a6:	89 10                	mov    %edx,(%eax)
  8031a8:	eb 0a                	jmp    8031b4 <alloc_block_NF+0xdd>
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8031cc:	48                   	dec    %eax
  8031cd:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	e9 0e 01 00 00       	jmp    8032e8 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e3:	0f 86 cf 00 00 00    	jbe    8032b8 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8031e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8031f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f7:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 50 08             	mov    0x8(%eax),%edx
  803200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803203:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 50 08             	mov    0x8(%eax),%edx
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	01 c2                	add    %eax,%edx
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	8b 40 0c             	mov    0xc(%eax),%eax
  80321d:	2b 45 08             	sub    0x8(%ebp),%eax
  803220:	89 c2                	mov    %eax,%edx
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 40 08             	mov    0x8(%eax),%eax
  80322e:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803231:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803235:	75 17                	jne    80324e <alloc_block_NF+0x177>
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	68 e5 47 80 00       	push   $0x8047e5
  80323f:	68 28 01 00 00       	push   $0x128
  803244:	68 73 47 80 00       	push   $0x804773
  803249:	e8 da da ff ff       	call   800d28 <_panic>
  80324e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	85 c0                	test   %eax,%eax
  803255:	74 10                	je     803267 <alloc_block_NF+0x190>
  803257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80325f:	8b 52 04             	mov    0x4(%edx),%edx
  803262:	89 50 04             	mov    %edx,0x4(%eax)
  803265:	eb 0b                	jmp    803272 <alloc_block_NF+0x19b>
  803267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326a:	8b 40 04             	mov    0x4(%eax),%eax
  80326d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	74 0f                	je     80328b <alloc_block_NF+0x1b4>
  80327c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803285:	8b 12                	mov    (%edx),%edx
  803287:	89 10                	mov    %edx,(%eax)
  803289:	eb 0a                	jmp    803295 <alloc_block_NF+0x1be>
  80328b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	a3 48 51 80 00       	mov    %eax,0x805148
  803295:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ad:	48                   	dec    %eax
  8032ae:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  8032b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b6:	eb 30                	jmp    8032e8 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8032b8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032c0:	75 0a                	jne    8032cc <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  8032c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8032c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ca:	eb 08                	jmp    8032d4 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8032cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cf:	8b 00                	mov    (%eax),%eax
  8032d1:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	8b 40 08             	mov    0x8(%eax),%eax
  8032da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032dd:	0f 85 4d fe ff ff    	jne    803130 <alloc_block_NF+0x59>

			return NULL;
  8032e3:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8032e8:	c9                   	leave  
  8032e9:	c3                   	ret    

008032ea <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8032ea:	55                   	push   %ebp
  8032eb:	89 e5                	mov    %esp,%ebp
  8032ed:	53                   	push   %ebx
  8032ee:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8032f1:	a1 38 51 80 00       	mov    0x805138,%eax
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	0f 85 86 00 00 00    	jne    803384 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8032fe:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803305:	00 00 00 
  803308:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80330f:	00 00 00 
  803312:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  803319:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80331c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803320:	75 17                	jne    803339 <insert_sorted_with_merge_freeList+0x4f>
  803322:	83 ec 04             	sub    $0x4,%esp
  803325:	68 50 47 80 00       	push   $0x804750
  80332a:	68 48 01 00 00       	push   $0x148
  80332f:	68 73 47 80 00       	push   $0x804773
  803334:	e8 ef d9 ff ff       	call   800d28 <_panic>
  803339:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	89 10                	mov    %edx,(%eax)
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 0d                	je     80335a <insert_sorted_with_merge_freeList+0x70>
  80334d:	a1 38 51 80 00       	mov    0x805138,%eax
  803352:	8b 55 08             	mov    0x8(%ebp),%edx
  803355:	89 50 04             	mov    %edx,0x4(%eax)
  803358:	eb 08                	jmp    803362 <insert_sorted_with_merge_freeList+0x78>
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	a3 38 51 80 00       	mov    %eax,0x805138
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803374:	a1 44 51 80 00       	mov    0x805144,%eax
  803379:	40                   	inc    %eax
  80337a:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80337f:	e9 73 07 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	8b 50 08             	mov    0x8(%eax),%edx
  80338a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80338f:	8b 40 08             	mov    0x8(%eax),%eax
  803392:	39 c2                	cmp    %eax,%edx
  803394:	0f 86 84 00 00 00    	jbe    80341e <insert_sorted_with_merge_freeList+0x134>
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	8b 50 08             	mov    0x8(%eax),%edx
  8033a0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033a5:	8b 48 0c             	mov    0xc(%eax),%ecx
  8033a8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033ad:	8b 40 08             	mov    0x8(%eax),%eax
  8033b0:	01 c8                	add    %ecx,%eax
  8033b2:	39 c2                	cmp    %eax,%edx
  8033b4:	74 68                	je     80341e <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8033b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ba:	75 17                	jne    8033d3 <insert_sorted_with_merge_freeList+0xe9>
  8033bc:	83 ec 04             	sub    $0x4,%esp
  8033bf:	68 8c 47 80 00       	push   $0x80478c
  8033c4:	68 4c 01 00 00       	push   $0x14c
  8033c9:	68 73 47 80 00       	push   $0x804773
  8033ce:	e8 55 d9 ff ff       	call   800d28 <_panic>
  8033d3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	89 50 04             	mov    %edx,0x4(%eax)
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	8b 40 04             	mov    0x4(%eax),%eax
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	74 0c                	je     8033f5 <insert_sorted_with_merge_freeList+0x10b>
  8033e9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f1:	89 10                	mov    %edx,(%eax)
  8033f3:	eb 08                	jmp    8033fd <insert_sorted_with_merge_freeList+0x113>
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340e:	a1 44 51 80 00       	mov    0x805144,%eax
  803413:	40                   	inc    %eax
  803414:	a3 44 51 80 00       	mov    %eax,0x805144
  803419:	e9 d9 06 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	8b 50 08             	mov    0x8(%eax),%edx
  803424:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803429:	8b 40 08             	mov    0x8(%eax),%eax
  80342c:	39 c2                	cmp    %eax,%edx
  80342e:	0f 86 b5 00 00 00    	jbe    8034e9 <insert_sorted_with_merge_freeList+0x1ff>
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	8b 50 08             	mov    0x8(%eax),%edx
  80343a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80343f:	8b 48 0c             	mov    0xc(%eax),%ecx
  803442:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803447:	8b 40 08             	mov    0x8(%eax),%eax
  80344a:	01 c8                	add    %ecx,%eax
  80344c:	39 c2                	cmp    %eax,%edx
  80344e:	0f 85 95 00 00 00    	jne    8034e9 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803454:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803459:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80345f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803462:	8b 55 08             	mov    0x8(%ebp),%edx
  803465:	8b 52 0c             	mov    0xc(%edx),%edx
  803468:	01 ca                	add    %ecx,%edx
  80346a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803481:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803485:	75 17                	jne    80349e <insert_sorted_with_merge_freeList+0x1b4>
  803487:	83 ec 04             	sub    $0x4,%esp
  80348a:	68 50 47 80 00       	push   $0x804750
  80348f:	68 54 01 00 00       	push   $0x154
  803494:	68 73 47 80 00       	push   $0x804773
  803499:	e8 8a d8 ff ff       	call   800d28 <_panic>
  80349e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	89 10                	mov    %edx,(%eax)
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	8b 00                	mov    (%eax),%eax
  8034ae:	85 c0                	test   %eax,%eax
  8034b0:	74 0d                	je     8034bf <insert_sorted_with_merge_freeList+0x1d5>
  8034b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ba:	89 50 04             	mov    %edx,0x4(%eax)
  8034bd:	eb 08                	jmp    8034c7 <insert_sorted_with_merge_freeList+0x1dd>
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034de:	40                   	inc    %eax
  8034df:	a3 54 51 80 00       	mov    %eax,0x805154
  8034e4:	e9 0e 06 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	8b 50 08             	mov    0x8(%eax),%edx
  8034ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8034f4:	8b 40 08             	mov    0x8(%eax),%eax
  8034f7:	39 c2                	cmp    %eax,%edx
  8034f9:	0f 83 c1 00 00 00    	jae    8035c0 <insert_sorted_with_merge_freeList+0x2d6>
  8034ff:	a1 38 51 80 00       	mov    0x805138,%eax
  803504:	8b 50 08             	mov    0x8(%eax),%edx
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	8b 48 08             	mov    0x8(%eax),%ecx
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	8b 40 0c             	mov    0xc(%eax),%eax
  803513:	01 c8                	add    %ecx,%eax
  803515:	39 c2                	cmp    %eax,%edx
  803517:	0f 85 a3 00 00 00    	jne    8035c0 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80351d:	a1 38 51 80 00       	mov    0x805138,%eax
  803522:	8b 55 08             	mov    0x8(%ebp),%edx
  803525:	8b 52 08             	mov    0x8(%edx),%edx
  803528:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80352b:	a1 38 51 80 00       	mov    0x805138,%eax
  803530:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803536:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803539:	8b 55 08             	mov    0x8(%ebp),%edx
  80353c:	8b 52 0c             	mov    0xc(%edx),%edx
  80353f:	01 ca                	add    %ecx,%edx
  803541:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803558:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80355c:	75 17                	jne    803575 <insert_sorted_with_merge_freeList+0x28b>
  80355e:	83 ec 04             	sub    $0x4,%esp
  803561:	68 50 47 80 00       	push   $0x804750
  803566:	68 5d 01 00 00       	push   $0x15d
  80356b:	68 73 47 80 00       	push   $0x804773
  803570:	e8 b3 d7 ff ff       	call   800d28 <_panic>
  803575:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80357b:	8b 45 08             	mov    0x8(%ebp),%eax
  80357e:	89 10                	mov    %edx,(%eax)
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	85 c0                	test   %eax,%eax
  803587:	74 0d                	je     803596 <insert_sorted_with_merge_freeList+0x2ac>
  803589:	a1 48 51 80 00       	mov    0x805148,%eax
  80358e:	8b 55 08             	mov    0x8(%ebp),%edx
  803591:	89 50 04             	mov    %edx,0x4(%eax)
  803594:	eb 08                	jmp    80359e <insert_sorted_with_merge_freeList+0x2b4>
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8035a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8035b5:	40                   	inc    %eax
  8035b6:	a3 54 51 80 00       	mov    %eax,0x805154
  8035bb:	e9 37 05 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	8b 50 08             	mov    0x8(%eax),%edx
  8035c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8035cb:	8b 40 08             	mov    0x8(%eax),%eax
  8035ce:	39 c2                	cmp    %eax,%edx
  8035d0:	0f 83 82 00 00 00    	jae    803658 <insert_sorted_with_merge_freeList+0x36e>
  8035d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8035db:	8b 50 08             	mov    0x8(%eax),%edx
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	8b 48 08             	mov    0x8(%eax),%ecx
  8035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ea:	01 c8                	add    %ecx,%eax
  8035ec:	39 c2                	cmp    %eax,%edx
  8035ee:	74 68                	je     803658 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8035f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f4:	75 17                	jne    80360d <insert_sorted_with_merge_freeList+0x323>
  8035f6:	83 ec 04             	sub    $0x4,%esp
  8035f9:	68 50 47 80 00       	push   $0x804750
  8035fe:	68 62 01 00 00       	push   $0x162
  803603:	68 73 47 80 00       	push   $0x804773
  803608:	e8 1b d7 ff ff       	call   800d28 <_panic>
  80360d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	89 10                	mov    %edx,(%eax)
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	8b 00                	mov    (%eax),%eax
  80361d:	85 c0                	test   %eax,%eax
  80361f:	74 0d                	je     80362e <insert_sorted_with_merge_freeList+0x344>
  803621:	a1 38 51 80 00       	mov    0x805138,%eax
  803626:	8b 55 08             	mov    0x8(%ebp),%edx
  803629:	89 50 04             	mov    %edx,0x4(%eax)
  80362c:	eb 08                	jmp    803636 <insert_sorted_with_merge_freeList+0x34c>
  80362e:	8b 45 08             	mov    0x8(%ebp),%eax
  803631:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	a3 38 51 80 00       	mov    %eax,0x805138
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803648:	a1 44 51 80 00       	mov    0x805144,%eax
  80364d:	40                   	inc    %eax
  80364e:	a3 44 51 80 00       	mov    %eax,0x805144
  803653:	e9 9f 04 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803658:	a1 38 51 80 00       	mov    0x805138,%eax
  80365d:	8b 00                	mov    (%eax),%eax
  80365f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803662:	e9 84 04 00 00       	jmp    803aeb <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366a:	8b 50 08             	mov    0x8(%eax),%edx
  80366d:	8b 45 08             	mov    0x8(%ebp),%eax
  803670:	8b 40 08             	mov    0x8(%eax),%eax
  803673:	39 c2                	cmp    %eax,%edx
  803675:	0f 86 a9 00 00 00    	jbe    803724 <insert_sorted_with_merge_freeList+0x43a>
  80367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367e:	8b 50 08             	mov    0x8(%eax),%edx
  803681:	8b 45 08             	mov    0x8(%ebp),%eax
  803684:	8b 48 08             	mov    0x8(%eax),%ecx
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	8b 40 0c             	mov    0xc(%eax),%eax
  80368d:	01 c8                	add    %ecx,%eax
  80368f:	39 c2                	cmp    %eax,%edx
  803691:	0f 84 8d 00 00 00    	je     803724 <insert_sorted_with_merge_freeList+0x43a>
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	8b 50 08             	mov    0x8(%eax),%edx
  80369d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a0:	8b 40 04             	mov    0x4(%eax),%eax
  8036a3:	8b 48 08             	mov    0x8(%eax),%ecx
  8036a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a9:	8b 40 04             	mov    0x4(%eax),%eax
  8036ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8036af:	01 c8                	add    %ecx,%eax
  8036b1:	39 c2                	cmp    %eax,%edx
  8036b3:	74 6f                	je     803724 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  8036b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b9:	74 06                	je     8036c1 <insert_sorted_with_merge_freeList+0x3d7>
  8036bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036bf:	75 17                	jne    8036d8 <insert_sorted_with_merge_freeList+0x3ee>
  8036c1:	83 ec 04             	sub    $0x4,%esp
  8036c4:	68 b0 47 80 00       	push   $0x8047b0
  8036c9:	68 6b 01 00 00       	push   $0x16b
  8036ce:	68 73 47 80 00       	push   $0x804773
  8036d3:	e8 50 d6 ff ff       	call   800d28 <_panic>
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	8b 50 04             	mov    0x4(%eax),%edx
  8036de:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e1:	89 50 04             	mov    %edx,0x4(%eax)
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ea:	89 10                	mov    %edx,(%eax)
  8036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ef:	8b 40 04             	mov    0x4(%eax),%eax
  8036f2:	85 c0                	test   %eax,%eax
  8036f4:	74 0d                	je     803703 <insert_sorted_with_merge_freeList+0x419>
  8036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f9:	8b 40 04             	mov    0x4(%eax),%eax
  8036fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ff:	89 10                	mov    %edx,(%eax)
  803701:	eb 08                	jmp    80370b <insert_sorted_with_merge_freeList+0x421>
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	a3 38 51 80 00       	mov    %eax,0x805138
  80370b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370e:	8b 55 08             	mov    0x8(%ebp),%edx
  803711:	89 50 04             	mov    %edx,0x4(%eax)
  803714:	a1 44 51 80 00       	mov    0x805144,%eax
  803719:	40                   	inc    %eax
  80371a:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80371f:	e9 d3 03 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	8b 50 08             	mov    0x8(%eax),%edx
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	8b 40 08             	mov    0x8(%eax),%eax
  803730:	39 c2                	cmp    %eax,%edx
  803732:	0f 86 da 00 00 00    	jbe    803812 <insert_sorted_with_merge_freeList+0x528>
  803738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373b:	8b 50 08             	mov    0x8(%eax),%edx
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	8b 48 08             	mov    0x8(%eax),%ecx
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	8b 40 0c             	mov    0xc(%eax),%eax
  80374a:	01 c8                	add    %ecx,%eax
  80374c:	39 c2                	cmp    %eax,%edx
  80374e:	0f 85 be 00 00 00    	jne    803812 <insert_sorted_with_merge_freeList+0x528>
  803754:	8b 45 08             	mov    0x8(%ebp),%eax
  803757:	8b 50 08             	mov    0x8(%eax),%edx
  80375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375d:	8b 40 04             	mov    0x4(%eax),%eax
  803760:	8b 48 08             	mov    0x8(%eax),%ecx
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	8b 40 04             	mov    0x4(%eax),%eax
  803769:	8b 40 0c             	mov    0xc(%eax),%eax
  80376c:	01 c8                	add    %ecx,%eax
  80376e:	39 c2                	cmp    %eax,%edx
  803770:	0f 84 9c 00 00 00    	je     803812 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	8b 50 08             	mov    0x8(%eax),%edx
  80377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377f:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803785:	8b 50 0c             	mov    0xc(%eax),%edx
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
  80378b:	8b 40 0c             	mov    0xc(%eax),%eax
  80378e:	01 c2                	add    %eax,%edx
  803790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803793:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  8037a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8037aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ae:	75 17                	jne    8037c7 <insert_sorted_with_merge_freeList+0x4dd>
  8037b0:	83 ec 04             	sub    $0x4,%esp
  8037b3:	68 50 47 80 00       	push   $0x804750
  8037b8:	68 74 01 00 00       	push   $0x174
  8037bd:	68 73 47 80 00       	push   $0x804773
  8037c2:	e8 61 d5 ff ff       	call   800d28 <_panic>
  8037c7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d0:	89 10                	mov    %edx,(%eax)
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	74 0d                	je     8037e8 <insert_sorted_with_merge_freeList+0x4fe>
  8037db:	a1 48 51 80 00       	mov    0x805148,%eax
  8037e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e3:	89 50 04             	mov    %edx,0x4(%eax)
  8037e6:	eb 08                	jmp    8037f0 <insert_sorted_with_merge_freeList+0x506>
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803802:	a1 54 51 80 00       	mov    0x805154,%eax
  803807:	40                   	inc    %eax
  803808:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80380d:	e9 e5 02 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803815:	8b 50 08             	mov    0x8(%eax),%edx
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	8b 40 08             	mov    0x8(%eax),%eax
  80381e:	39 c2                	cmp    %eax,%edx
  803820:	0f 86 d7 00 00 00    	jbe    8038fd <insert_sorted_with_merge_freeList+0x613>
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	8b 50 08             	mov    0x8(%eax),%edx
  80382c:	8b 45 08             	mov    0x8(%ebp),%eax
  80382f:	8b 48 08             	mov    0x8(%eax),%ecx
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	8b 40 0c             	mov    0xc(%eax),%eax
  803838:	01 c8                	add    %ecx,%eax
  80383a:	39 c2                	cmp    %eax,%edx
  80383c:	0f 84 bb 00 00 00    	je     8038fd <insert_sorted_with_merge_freeList+0x613>
  803842:	8b 45 08             	mov    0x8(%ebp),%eax
  803845:	8b 50 08             	mov    0x8(%eax),%edx
  803848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384b:	8b 40 04             	mov    0x4(%eax),%eax
  80384e:	8b 48 08             	mov    0x8(%eax),%ecx
  803851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803854:	8b 40 04             	mov    0x4(%eax),%eax
  803857:	8b 40 0c             	mov    0xc(%eax),%eax
  80385a:	01 c8                	add    %ecx,%eax
  80385c:	39 c2                	cmp    %eax,%edx
  80385e:	0f 85 99 00 00 00    	jne    8038fd <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803867:	8b 40 04             	mov    0x4(%eax),%eax
  80386a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  80386d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803870:	8b 50 0c             	mov    0xc(%eax),%edx
  803873:	8b 45 08             	mov    0x8(%ebp),%eax
  803876:	8b 40 0c             	mov    0xc(%eax),%eax
  803879:	01 c2                	add    %eax,%edx
  80387b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80387e:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803881:	8b 45 08             	mov    0x8(%ebp),%eax
  803884:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80388b:	8b 45 08             	mov    0x8(%ebp),%eax
  80388e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803895:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803899:	75 17                	jne    8038b2 <insert_sorted_with_merge_freeList+0x5c8>
  80389b:	83 ec 04             	sub    $0x4,%esp
  80389e:	68 50 47 80 00       	push   $0x804750
  8038a3:	68 7d 01 00 00       	push   $0x17d
  8038a8:	68 73 47 80 00       	push   $0x804773
  8038ad:	e8 76 d4 ff ff       	call   800d28 <_panic>
  8038b2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bb:	89 10                	mov    %edx,(%eax)
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	8b 00                	mov    (%eax),%eax
  8038c2:	85 c0                	test   %eax,%eax
  8038c4:	74 0d                	je     8038d3 <insert_sorted_with_merge_freeList+0x5e9>
  8038c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8038cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ce:	89 50 04             	mov    %edx,0x4(%eax)
  8038d1:	eb 08                	jmp    8038db <insert_sorted_with_merge_freeList+0x5f1>
  8038d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038db:	8b 45 08             	mov    0x8(%ebp),%eax
  8038de:	a3 48 51 80 00       	mov    %eax,0x805148
  8038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8038f2:	40                   	inc    %eax
  8038f3:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8038f8:	e9 fa 01 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	8b 50 08             	mov    0x8(%eax),%edx
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	8b 40 08             	mov    0x8(%eax),%eax
  803909:	39 c2                	cmp    %eax,%edx
  80390b:	0f 86 d2 01 00 00    	jbe    803ae3 <insert_sorted_with_merge_freeList+0x7f9>
  803911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803914:	8b 50 08             	mov    0x8(%eax),%edx
  803917:	8b 45 08             	mov    0x8(%ebp),%eax
  80391a:	8b 48 08             	mov    0x8(%eax),%ecx
  80391d:	8b 45 08             	mov    0x8(%ebp),%eax
  803920:	8b 40 0c             	mov    0xc(%eax),%eax
  803923:	01 c8                	add    %ecx,%eax
  803925:	39 c2                	cmp    %eax,%edx
  803927:	0f 85 b6 01 00 00    	jne    803ae3 <insert_sorted_with_merge_freeList+0x7f9>
  80392d:	8b 45 08             	mov    0x8(%ebp),%eax
  803930:	8b 50 08             	mov    0x8(%eax),%edx
  803933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803936:	8b 40 04             	mov    0x4(%eax),%eax
  803939:	8b 48 08             	mov    0x8(%eax),%ecx
  80393c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393f:	8b 40 04             	mov    0x4(%eax),%eax
  803942:	8b 40 0c             	mov    0xc(%eax),%eax
  803945:	01 c8                	add    %ecx,%eax
  803947:	39 c2                	cmp    %eax,%edx
  803949:	0f 85 94 01 00 00    	jne    803ae3 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  80394f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803952:	8b 40 04             	mov    0x4(%eax),%eax
  803955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803958:	8b 52 04             	mov    0x4(%edx),%edx
  80395b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80395e:	8b 55 08             	mov    0x8(%ebp),%edx
  803961:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803967:	8b 52 0c             	mov    0xc(%edx),%edx
  80396a:	01 da                	add    %ebx,%edx
  80396c:	01 ca                	add    %ecx,%edx
  80396e:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803974:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80397b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803989:	75 17                	jne    8039a2 <insert_sorted_with_merge_freeList+0x6b8>
  80398b:	83 ec 04             	sub    $0x4,%esp
  80398e:	68 e5 47 80 00       	push   $0x8047e5
  803993:	68 86 01 00 00       	push   $0x186
  803998:	68 73 47 80 00       	push   $0x804773
  80399d:	e8 86 d3 ff ff       	call   800d28 <_panic>
  8039a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a5:	8b 00                	mov    (%eax),%eax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	74 10                	je     8039bb <insert_sorted_with_merge_freeList+0x6d1>
  8039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ae:	8b 00                	mov    (%eax),%eax
  8039b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039b3:	8b 52 04             	mov    0x4(%edx),%edx
  8039b6:	89 50 04             	mov    %edx,0x4(%eax)
  8039b9:	eb 0b                	jmp    8039c6 <insert_sorted_with_merge_freeList+0x6dc>
  8039bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039be:	8b 40 04             	mov    0x4(%eax),%eax
  8039c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c9:	8b 40 04             	mov    0x4(%eax),%eax
  8039cc:	85 c0                	test   %eax,%eax
  8039ce:	74 0f                	je     8039df <insert_sorted_with_merge_freeList+0x6f5>
  8039d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d3:	8b 40 04             	mov    0x4(%eax),%eax
  8039d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039d9:	8b 12                	mov    (%edx),%edx
  8039db:	89 10                	mov    %edx,(%eax)
  8039dd:	eb 0a                	jmp    8039e9 <insert_sorted_with_merge_freeList+0x6ff>
  8039df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e2:	8b 00                	mov    (%eax),%eax
  8039e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8039e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803a01:	48                   	dec    %eax
  803a02:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a0b:	75 17                	jne    803a24 <insert_sorted_with_merge_freeList+0x73a>
  803a0d:	83 ec 04             	sub    $0x4,%esp
  803a10:	68 50 47 80 00       	push   $0x804750
  803a15:	68 87 01 00 00       	push   $0x187
  803a1a:	68 73 47 80 00       	push   $0x804773
  803a1f:	e8 04 d3 ff ff       	call   800d28 <_panic>
  803a24:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2d:	89 10                	mov    %edx,(%eax)
  803a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a32:	8b 00                	mov    (%eax),%eax
  803a34:	85 c0                	test   %eax,%eax
  803a36:	74 0d                	je     803a45 <insert_sorted_with_merge_freeList+0x75b>
  803a38:	a1 48 51 80 00       	mov    0x805148,%eax
  803a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a40:	89 50 04             	mov    %edx,0x4(%eax)
  803a43:	eb 08                	jmp    803a4d <insert_sorted_with_merge_freeList+0x763>
  803a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a48:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a50:	a3 48 51 80 00       	mov    %eax,0x805148
  803a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5f:	a1 54 51 80 00       	mov    0x805154,%eax
  803a64:	40                   	inc    %eax
  803a65:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803a74:	8b 45 08             	mov    0x8(%ebp),%eax
  803a77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803a7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a82:	75 17                	jne    803a9b <insert_sorted_with_merge_freeList+0x7b1>
  803a84:	83 ec 04             	sub    $0x4,%esp
  803a87:	68 50 47 80 00       	push   $0x804750
  803a8c:	68 8a 01 00 00       	push   $0x18a
  803a91:	68 73 47 80 00       	push   $0x804773
  803a96:	e8 8d d2 ff ff       	call   800d28 <_panic>
  803a9b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa4:	89 10                	mov    %edx,(%eax)
  803aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa9:	8b 00                	mov    (%eax),%eax
  803aab:	85 c0                	test   %eax,%eax
  803aad:	74 0d                	je     803abc <insert_sorted_with_merge_freeList+0x7d2>
  803aaf:	a1 48 51 80 00       	mov    0x805148,%eax
  803ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab7:	89 50 04             	mov    %edx,0x4(%eax)
  803aba:	eb 08                	jmp    803ac4 <insert_sorted_with_merge_freeList+0x7da>
  803abc:	8b 45 08             	mov    0x8(%ebp),%eax
  803abf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac7:	a3 48 51 80 00       	mov    %eax,0x805148
  803acc:	8b 45 08             	mov    0x8(%ebp),%eax
  803acf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad6:	a1 54 51 80 00       	mov    0x805154,%eax
  803adb:	40                   	inc    %eax
  803adc:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803ae1:	eb 14                	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae6:	8b 00                	mov    (%eax),%eax
  803ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aef:	0f 85 72 fb ff ff    	jne    803667 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803af5:	eb 00                	jmp    803af7 <insert_sorted_with_merge_freeList+0x80d>
  803af7:	90                   	nop
  803af8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803afb:	c9                   	leave  
  803afc:	c3                   	ret    
  803afd:	66 90                	xchg   %ax,%ax
  803aff:	90                   	nop

00803b00 <__udivdi3>:
  803b00:	55                   	push   %ebp
  803b01:	57                   	push   %edi
  803b02:	56                   	push   %esi
  803b03:	53                   	push   %ebx
  803b04:	83 ec 1c             	sub    $0x1c,%esp
  803b07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b17:	89 ca                	mov    %ecx,%edx
  803b19:	89 f8                	mov    %edi,%eax
  803b1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b1f:	85 f6                	test   %esi,%esi
  803b21:	75 2d                	jne    803b50 <__udivdi3+0x50>
  803b23:	39 cf                	cmp    %ecx,%edi
  803b25:	77 65                	ja     803b8c <__udivdi3+0x8c>
  803b27:	89 fd                	mov    %edi,%ebp
  803b29:	85 ff                	test   %edi,%edi
  803b2b:	75 0b                	jne    803b38 <__udivdi3+0x38>
  803b2d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b32:	31 d2                	xor    %edx,%edx
  803b34:	f7 f7                	div    %edi
  803b36:	89 c5                	mov    %eax,%ebp
  803b38:	31 d2                	xor    %edx,%edx
  803b3a:	89 c8                	mov    %ecx,%eax
  803b3c:	f7 f5                	div    %ebp
  803b3e:	89 c1                	mov    %eax,%ecx
  803b40:	89 d8                	mov    %ebx,%eax
  803b42:	f7 f5                	div    %ebp
  803b44:	89 cf                	mov    %ecx,%edi
  803b46:	89 fa                	mov    %edi,%edx
  803b48:	83 c4 1c             	add    $0x1c,%esp
  803b4b:	5b                   	pop    %ebx
  803b4c:	5e                   	pop    %esi
  803b4d:	5f                   	pop    %edi
  803b4e:	5d                   	pop    %ebp
  803b4f:	c3                   	ret    
  803b50:	39 ce                	cmp    %ecx,%esi
  803b52:	77 28                	ja     803b7c <__udivdi3+0x7c>
  803b54:	0f bd fe             	bsr    %esi,%edi
  803b57:	83 f7 1f             	xor    $0x1f,%edi
  803b5a:	75 40                	jne    803b9c <__udivdi3+0x9c>
  803b5c:	39 ce                	cmp    %ecx,%esi
  803b5e:	72 0a                	jb     803b6a <__udivdi3+0x6a>
  803b60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b64:	0f 87 9e 00 00 00    	ja     803c08 <__udivdi3+0x108>
  803b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6f:	89 fa                	mov    %edi,%edx
  803b71:	83 c4 1c             	add    $0x1c,%esp
  803b74:	5b                   	pop    %ebx
  803b75:	5e                   	pop    %esi
  803b76:	5f                   	pop    %edi
  803b77:	5d                   	pop    %ebp
  803b78:	c3                   	ret    
  803b79:	8d 76 00             	lea    0x0(%esi),%esi
  803b7c:	31 ff                	xor    %edi,%edi
  803b7e:	31 c0                	xor    %eax,%eax
  803b80:	89 fa                	mov    %edi,%edx
  803b82:	83 c4 1c             	add    $0x1c,%esp
  803b85:	5b                   	pop    %ebx
  803b86:	5e                   	pop    %esi
  803b87:	5f                   	pop    %edi
  803b88:	5d                   	pop    %ebp
  803b89:	c3                   	ret    
  803b8a:	66 90                	xchg   %ax,%ax
  803b8c:	89 d8                	mov    %ebx,%eax
  803b8e:	f7 f7                	div    %edi
  803b90:	31 ff                	xor    %edi,%edi
  803b92:	89 fa                	mov    %edi,%edx
  803b94:	83 c4 1c             	add    $0x1c,%esp
  803b97:	5b                   	pop    %ebx
  803b98:	5e                   	pop    %esi
  803b99:	5f                   	pop    %edi
  803b9a:	5d                   	pop    %ebp
  803b9b:	c3                   	ret    
  803b9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ba1:	89 eb                	mov    %ebp,%ebx
  803ba3:	29 fb                	sub    %edi,%ebx
  803ba5:	89 f9                	mov    %edi,%ecx
  803ba7:	d3 e6                	shl    %cl,%esi
  803ba9:	89 c5                	mov    %eax,%ebp
  803bab:	88 d9                	mov    %bl,%cl
  803bad:	d3 ed                	shr    %cl,%ebp
  803baf:	89 e9                	mov    %ebp,%ecx
  803bb1:	09 f1                	or     %esi,%ecx
  803bb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bb7:	89 f9                	mov    %edi,%ecx
  803bb9:	d3 e0                	shl    %cl,%eax
  803bbb:	89 c5                	mov    %eax,%ebp
  803bbd:	89 d6                	mov    %edx,%esi
  803bbf:	88 d9                	mov    %bl,%cl
  803bc1:	d3 ee                	shr    %cl,%esi
  803bc3:	89 f9                	mov    %edi,%ecx
  803bc5:	d3 e2                	shl    %cl,%edx
  803bc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bcb:	88 d9                	mov    %bl,%cl
  803bcd:	d3 e8                	shr    %cl,%eax
  803bcf:	09 c2                	or     %eax,%edx
  803bd1:	89 d0                	mov    %edx,%eax
  803bd3:	89 f2                	mov    %esi,%edx
  803bd5:	f7 74 24 0c          	divl   0xc(%esp)
  803bd9:	89 d6                	mov    %edx,%esi
  803bdb:	89 c3                	mov    %eax,%ebx
  803bdd:	f7 e5                	mul    %ebp
  803bdf:	39 d6                	cmp    %edx,%esi
  803be1:	72 19                	jb     803bfc <__udivdi3+0xfc>
  803be3:	74 0b                	je     803bf0 <__udivdi3+0xf0>
  803be5:	89 d8                	mov    %ebx,%eax
  803be7:	31 ff                	xor    %edi,%edi
  803be9:	e9 58 ff ff ff       	jmp    803b46 <__udivdi3+0x46>
  803bee:	66 90                	xchg   %ax,%ax
  803bf0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bf4:	89 f9                	mov    %edi,%ecx
  803bf6:	d3 e2                	shl    %cl,%edx
  803bf8:	39 c2                	cmp    %eax,%edx
  803bfa:	73 e9                	jae    803be5 <__udivdi3+0xe5>
  803bfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bff:	31 ff                	xor    %edi,%edi
  803c01:	e9 40 ff ff ff       	jmp    803b46 <__udivdi3+0x46>
  803c06:	66 90                	xchg   %ax,%ax
  803c08:	31 c0                	xor    %eax,%eax
  803c0a:	e9 37 ff ff ff       	jmp    803b46 <__udivdi3+0x46>
  803c0f:	90                   	nop

00803c10 <__umoddi3>:
  803c10:	55                   	push   %ebp
  803c11:	57                   	push   %edi
  803c12:	56                   	push   %esi
  803c13:	53                   	push   %ebx
  803c14:	83 ec 1c             	sub    $0x1c,%esp
  803c17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c2f:	89 f3                	mov    %esi,%ebx
  803c31:	89 fa                	mov    %edi,%edx
  803c33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c37:	89 34 24             	mov    %esi,(%esp)
  803c3a:	85 c0                	test   %eax,%eax
  803c3c:	75 1a                	jne    803c58 <__umoddi3+0x48>
  803c3e:	39 f7                	cmp    %esi,%edi
  803c40:	0f 86 a2 00 00 00    	jbe    803ce8 <__umoddi3+0xd8>
  803c46:	89 c8                	mov    %ecx,%eax
  803c48:	89 f2                	mov    %esi,%edx
  803c4a:	f7 f7                	div    %edi
  803c4c:	89 d0                	mov    %edx,%eax
  803c4e:	31 d2                	xor    %edx,%edx
  803c50:	83 c4 1c             	add    $0x1c,%esp
  803c53:	5b                   	pop    %ebx
  803c54:	5e                   	pop    %esi
  803c55:	5f                   	pop    %edi
  803c56:	5d                   	pop    %ebp
  803c57:	c3                   	ret    
  803c58:	39 f0                	cmp    %esi,%eax
  803c5a:	0f 87 ac 00 00 00    	ja     803d0c <__umoddi3+0xfc>
  803c60:	0f bd e8             	bsr    %eax,%ebp
  803c63:	83 f5 1f             	xor    $0x1f,%ebp
  803c66:	0f 84 ac 00 00 00    	je     803d18 <__umoddi3+0x108>
  803c6c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c71:	29 ef                	sub    %ebp,%edi
  803c73:	89 fe                	mov    %edi,%esi
  803c75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c79:	89 e9                	mov    %ebp,%ecx
  803c7b:	d3 e0                	shl    %cl,%eax
  803c7d:	89 d7                	mov    %edx,%edi
  803c7f:	89 f1                	mov    %esi,%ecx
  803c81:	d3 ef                	shr    %cl,%edi
  803c83:	09 c7                	or     %eax,%edi
  803c85:	89 e9                	mov    %ebp,%ecx
  803c87:	d3 e2                	shl    %cl,%edx
  803c89:	89 14 24             	mov    %edx,(%esp)
  803c8c:	89 d8                	mov    %ebx,%eax
  803c8e:	d3 e0                	shl    %cl,%eax
  803c90:	89 c2                	mov    %eax,%edx
  803c92:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c96:	d3 e0                	shl    %cl,%eax
  803c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ca0:	89 f1                	mov    %esi,%ecx
  803ca2:	d3 e8                	shr    %cl,%eax
  803ca4:	09 d0                	or     %edx,%eax
  803ca6:	d3 eb                	shr    %cl,%ebx
  803ca8:	89 da                	mov    %ebx,%edx
  803caa:	f7 f7                	div    %edi
  803cac:	89 d3                	mov    %edx,%ebx
  803cae:	f7 24 24             	mull   (%esp)
  803cb1:	89 c6                	mov    %eax,%esi
  803cb3:	89 d1                	mov    %edx,%ecx
  803cb5:	39 d3                	cmp    %edx,%ebx
  803cb7:	0f 82 87 00 00 00    	jb     803d44 <__umoddi3+0x134>
  803cbd:	0f 84 91 00 00 00    	je     803d54 <__umoddi3+0x144>
  803cc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cc7:	29 f2                	sub    %esi,%edx
  803cc9:	19 cb                	sbb    %ecx,%ebx
  803ccb:	89 d8                	mov    %ebx,%eax
  803ccd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cd1:	d3 e0                	shl    %cl,%eax
  803cd3:	89 e9                	mov    %ebp,%ecx
  803cd5:	d3 ea                	shr    %cl,%edx
  803cd7:	09 d0                	or     %edx,%eax
  803cd9:	89 e9                	mov    %ebp,%ecx
  803cdb:	d3 eb                	shr    %cl,%ebx
  803cdd:	89 da                	mov    %ebx,%edx
  803cdf:	83 c4 1c             	add    $0x1c,%esp
  803ce2:	5b                   	pop    %ebx
  803ce3:	5e                   	pop    %esi
  803ce4:	5f                   	pop    %edi
  803ce5:	5d                   	pop    %ebp
  803ce6:	c3                   	ret    
  803ce7:	90                   	nop
  803ce8:	89 fd                	mov    %edi,%ebp
  803cea:	85 ff                	test   %edi,%edi
  803cec:	75 0b                	jne    803cf9 <__umoddi3+0xe9>
  803cee:	b8 01 00 00 00       	mov    $0x1,%eax
  803cf3:	31 d2                	xor    %edx,%edx
  803cf5:	f7 f7                	div    %edi
  803cf7:	89 c5                	mov    %eax,%ebp
  803cf9:	89 f0                	mov    %esi,%eax
  803cfb:	31 d2                	xor    %edx,%edx
  803cfd:	f7 f5                	div    %ebp
  803cff:	89 c8                	mov    %ecx,%eax
  803d01:	f7 f5                	div    %ebp
  803d03:	89 d0                	mov    %edx,%eax
  803d05:	e9 44 ff ff ff       	jmp    803c4e <__umoddi3+0x3e>
  803d0a:	66 90                	xchg   %ax,%ax
  803d0c:	89 c8                	mov    %ecx,%eax
  803d0e:	89 f2                	mov    %esi,%edx
  803d10:	83 c4 1c             	add    $0x1c,%esp
  803d13:	5b                   	pop    %ebx
  803d14:	5e                   	pop    %esi
  803d15:	5f                   	pop    %edi
  803d16:	5d                   	pop    %ebp
  803d17:	c3                   	ret    
  803d18:	3b 04 24             	cmp    (%esp),%eax
  803d1b:	72 06                	jb     803d23 <__umoddi3+0x113>
  803d1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d21:	77 0f                	ja     803d32 <__umoddi3+0x122>
  803d23:	89 f2                	mov    %esi,%edx
  803d25:	29 f9                	sub    %edi,%ecx
  803d27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d2b:	89 14 24             	mov    %edx,(%esp)
  803d2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d32:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d36:	8b 14 24             	mov    (%esp),%edx
  803d39:	83 c4 1c             	add    $0x1c,%esp
  803d3c:	5b                   	pop    %ebx
  803d3d:	5e                   	pop    %esi
  803d3e:	5f                   	pop    %edi
  803d3f:	5d                   	pop    %ebp
  803d40:	c3                   	ret    
  803d41:	8d 76 00             	lea    0x0(%esi),%esi
  803d44:	2b 04 24             	sub    (%esp),%eax
  803d47:	19 fa                	sbb    %edi,%edx
  803d49:	89 d1                	mov    %edx,%ecx
  803d4b:	89 c6                	mov    %eax,%esi
  803d4d:	e9 71 ff ff ff       	jmp    803cc3 <__umoddi3+0xb3>
  803d52:	66 90                	xchg   %ax,%ax
  803d54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d58:	72 ea                	jb     803d44 <__umoddi3+0x134>
  803d5a:	89 d9                	mov    %ebx,%ecx
  803d5c:	e9 62 ff ff ff       	jmp    803cc3 <__umoddi3+0xb3>
