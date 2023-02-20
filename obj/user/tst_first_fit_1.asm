
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 38 0b 00 00       	call   800b6e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	83 ec 74             	sub    $0x74,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80003f:	83 ec 0c             	sub    $0xc,%esp
  800042:	6a 01                	push   $0x1
  800044:	e8 de 27 00 00       	call   802827 <sys_set_uheap_strategy>
  800049:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800050:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800057:	eb 29                	jmp    800082 <_main+0x4a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800059:	a1 20 50 80 00       	mov    0x805020,%eax
  80005e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800067:	89 d0                	mov    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	01 c8                	add    %ecx,%eax
  800072:	8a 40 04             	mov    0x4(%eax),%al
  800075:	84 c0                	test   %al,%al
  800077:	74 06                	je     80007f <_main+0x47>
			{
				fullWS = 0;
  800079:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007d:	eb 12                	jmp    800091 <_main+0x59>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007f:	ff 45 f0             	incl   -0x10(%ebp)
  800082:	a1 20 50 80 00       	mov    0x805020,%eax
  800087:	8b 50 74             	mov    0x74(%eax),%edx
  80008a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008d:	39 c2                	cmp    %eax,%edx
  80008f:	77 c8                	ja     800059 <_main+0x21>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800091:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800095:	74 14                	je     8000ab <_main+0x73>
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 00 3d 80 00       	push   $0x803d00
  80009f:	6a 15                	push   $0x15
  8000a1:	68 1c 3d 80 00       	push   $0x803d1c
  8000a6:	e8 ff 0b 00 00       	call   800caa <_panic>
	}

	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 eb 1d 00 00       	call   801eae <malloc>
  8000c3:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c6:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000c9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 36 22 00 00       	call   802312 <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 ce 22 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8000e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	50                   	push   %eax
  8000f1:	e8 b8 1d 00 00       	call   801eae <malloc>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ff:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800104:	74 14                	je     80011a <_main+0xe2>
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 34 3d 80 00       	push   $0x803d34
  80010e:	6a 26                	push   $0x26
  800110:	68 1c 3d 80 00       	push   $0x803d1c
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 93 22 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 64 3d 80 00       	push   $0x803d64
  80012c:	6a 28                	push   $0x28
  80012e:	68 1c 3d 80 00       	push   $0x803d1c
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 d5 21 00 00       	call   802312 <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 81 3d 80 00       	push   $0x803d81
  80014e:	6a 29                	push   $0x29
  800150:	68 1c 3d 80 00       	push   $0x803d1c
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 b3 21 00 00       	call   802312 <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 4b 22 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80016a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	50                   	push   %eax
  800174:	e8 35 1d 00 00       	call   801eae <malloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80017f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800182:	89 c2                	mov    %eax,%edx
  800184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 14                	je     8001a4 <_main+0x16c>
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 34 3d 80 00       	push   $0x803d34
  800198:	6a 2f                	push   $0x2f
  80019a:	68 1c 3d 80 00       	push   $0x803d1c
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 09 22 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 64 3d 80 00       	push   $0x803d64
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 1c 3d 80 00       	push   $0x803d1c
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 4b 21 00 00       	call   802312 <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 81 3d 80 00       	push   $0x803d81
  8001d8:	6a 32                	push   $0x32
  8001da:	68 1c 3d 80 00       	push   $0x803d1c
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 29 21 00 00       	call   802312 <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 c1 21 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	e8 ab 1c 00 00       	call   801eae <malloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800209:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020c:	89 c2                	mov    %eax,%edx
  80020e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	05 00 00 00 80       	add    $0x80000000,%eax
  800218:	39 c2                	cmp    %eax,%edx
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 34 3d 80 00       	push   $0x803d34
  800224:	6a 38                	push   $0x38
  800226:	68 1c 3d 80 00       	push   $0x803d1c
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 7d 21 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 64 3d 80 00       	push   $0x803d64
  800242:	6a 3a                	push   $0x3a
  800244:	68 1c 3d 80 00       	push   $0x803d1c
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 bf 20 00 00       	call   802312 <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 81 3d 80 00       	push   $0x803d81
  800264:	6a 3b                	push   $0x3b
  800266:	68 1c 3d 80 00       	push   $0x803d1c
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 9d 20 00 00       	call   802312 <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 35 21 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800283:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 1f 1c 00 00       	call   801eae <malloc>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  800295:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	01 d2                	add    %edx,%edx
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a8:	39 c1                	cmp    %eax,%ecx
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 34 3d 80 00       	push   $0x803d34
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 1c 3d 80 00       	push   $0x803d1c
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 ed 20 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 64 3d 80 00       	push   $0x803d64
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 1c 3d 80 00       	push   $0x803d1c
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 2f 20 00 00       	call   802312 <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 81 3d 80 00       	push   $0x803d81
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 1c 3d 80 00       	push   $0x803d1c
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 0d 20 00 00       	call   802312 <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 a5 20 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80030d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	e8 8d 1b 00 00       	call   801eae <malloc>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	89 c2                	mov    %eax,%edx
  80032c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032f:	c1 e0 02             	shl    $0x2,%eax
  800332:	05 00 00 00 80       	add    $0x80000000,%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	74 14                	je     80034f <_main+0x317>
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 34 3d 80 00       	push   $0x803d34
  800343:	6a 4a                	push   $0x4a
  800345:	68 1c 3d 80 00       	push   $0x803d1c
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 5e 20 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 64 3d 80 00       	push   $0x803d64
  800361:	6a 4c                	push   $0x4c
  800363:	68 1c 3d 80 00       	push   $0x803d1c
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 a0 1f 00 00       	call   802312 <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 81 3d 80 00       	push   $0x803d81
  800383:	6a 4d                	push   $0x4d
  800385:	68 1c 3d 80 00       	push   $0x803d1c
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 7e 1f 00 00       	call   802312 <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 16 20 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80039f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	50                   	push   %eax
  8003ab:	e8 fe 1a 00 00       	call   801eae <malloc>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003b9:	89 c1                	mov    %eax,%ecx
  8003bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003cb:	39 c1                	cmp    %eax,%ecx
  8003cd:	74 14                	je     8003e3 <_main+0x3ab>
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 34 3d 80 00       	push   $0x803d34
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 1c 3d 80 00       	push   $0x803d1c
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 ca 1f 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 64 3d 80 00       	push   $0x803d64
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 1c 3d 80 00       	push   $0x803d1c
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 0c 1f 00 00       	call   802312 <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 81 3d 80 00       	push   $0x803d81
  800417:	6a 56                	push   $0x56
  800419:	68 1c 3d 80 00       	push   $0x803d1c
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 ea 1e 00 00       	call   802312 <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 82 1f 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c2                	mov    %eax,%edx
  800438:	01 d2                	add    %edx,%edx
  80043a:	01 d0                	add    %edx,%eax
  80043c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 66 1a 00 00       	call   801eae <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80044e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800451:	89 c2                	mov    %eax,%edx
  800453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	05 00 00 00 80       	add    $0x80000000,%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	74 14                	je     800476 <_main+0x43e>
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	68 34 3d 80 00       	push   $0x803d34
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 1c 3d 80 00       	push   $0x803d1c
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 37 1f 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 64 3d 80 00       	push   $0x803d64
  800488:	6a 5e                	push   $0x5e
  80048a:	68 1c 3d 80 00       	push   $0x803d1c
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 79 1e 00 00       	call   802312 <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 81 3d 80 00       	push   $0x803d81
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 1c 3d 80 00       	push   $0x803d1c
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 57 1e 00 00       	call   802312 <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 ef 1e 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	89 c2                	mov    %eax,%edx
  8004cb:	01 d2                	add    %edx,%edx
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	50                   	push   %eax
  8004d6:	e8 d3 19 00 00       	call   801eae <malloc>
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004e1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e4:	89 c1                	mov    %eax,%ecx
  8004e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	c1 e0 02             	shl    $0x2,%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	01 c0                	add    %eax,%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8004f9:	39 c1                	cmp    %eax,%ecx
  8004fb:	74 14                	je     800511 <_main+0x4d9>
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 34 3d 80 00       	push   $0x803d34
  800505:	6a 65                	push   $0x65
  800507:	68 1c 3d 80 00       	push   $0x803d1c
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 9c 1e 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 64 3d 80 00       	push   $0x803d64
  800523:	6a 67                	push   $0x67
  800525:	68 1c 3d 80 00       	push   $0x803d1c
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 de 1d 00 00       	call   802312 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 81 3d 80 00       	push   $0x803d81
  800545:	6a 68                	push   $0x68
  800547:	68 1c 3d 80 00       	push   $0x803d1c
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 bc 1d 00 00       	call   802312 <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 54 1e 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 cc 19 00 00       	call   801f39 <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 3d 1e 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 94 3d 80 00       	push   $0x803d94
  800582:	6a 72                	push   $0x72
  800584:	68 1c 3d 80 00       	push   $0x803d1c
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 7f 1d 00 00       	call   802312 <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 ab 3d 80 00       	push   $0x803dab
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 1c 3d 80 00       	push   $0x803d1c
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 5d 1d 00 00       	call   802312 <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 f5 1d 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 6d 19 00 00       	call   801f39 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 de 1d 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 94 3d 80 00       	push   $0x803d94
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 1c 3d 80 00       	push   $0x803d1c
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 20 1d 00 00       	call   802312 <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 ab 3d 80 00       	push   $0x803dab
  800603:	6a 7b                	push   $0x7b
  800605:	68 1c 3d 80 00       	push   $0x803d1c
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 fe 1c 00 00       	call   802312 <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 96 1d 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 0e 19 00 00       	call   801f39 <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 7f 1d 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 94 3d 80 00       	push   $0x803d94
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 1c 3d 80 00       	push   $0x803d1c
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 be 1c 00 00       	call   802312 <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 ab 3d 80 00       	push   $0x803dab
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 1c 3d 80 00       	push   $0x803d1c
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 99 1c 00 00       	call   802312 <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 31 1d 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800687:	89 d0                	mov    %edx,%eax
  800689:	c1 e0 09             	shl    $0x9,%eax
  80068c:	29 d0                	sub    %edx,%eax
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	50                   	push   %eax
  800692:	e8 17 18 00 00       	call   801eae <malloc>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80069d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 17                	je     8006c5 <_main+0x68d>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 34 3d 80 00       	push   $0x803d34
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 1c 3d 80 00       	push   $0x803d1c
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 e8 1c 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 64 3d 80 00       	push   $0x803d64
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 1c 3d 80 00       	push   $0x803d1c
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 27 1c 00 00       	call   802312 <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 81 3d 80 00       	push   $0x803d81
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 1c 3d 80 00       	push   $0x803d1c
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 02 1c 00 00       	call   802312 <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 9a 1c 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800718:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80071b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	50                   	push   %eax
  800725:	e8 84 17 00 00       	call   801eae <malloc>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800733:	89 c2                	mov    %eax,%edx
  800735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800738:	c1 e0 02             	shl    $0x2,%eax
  80073b:	05 00 00 00 80       	add    $0x80000000,%eax
  800740:	39 c2                	cmp    %eax,%edx
  800742:	74 17                	je     80075b <_main+0x723>
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	68 34 3d 80 00       	push   $0x803d34
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 1c 3d 80 00       	push   $0x803d1c
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 52 1c 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 64 3d 80 00       	push   $0x803d64
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 1c 3d 80 00       	push   $0x803d1c
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 91 1b 00 00       	call   802312 <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 81 3d 80 00       	push   $0x803d81
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 1c 3d 80 00       	push   $0x803d1c
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 6c 1b 00 00       	call   802312 <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 04 1c 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8007b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 08             	shl    $0x8,%eax
  8007b9:	29 d0                	sub    %edx,%eax
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	50                   	push   %eax
  8007bf:	e8 ea 16 00 00       	call   801eae <malloc>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007d2:	c1 e0 09             	shl    $0x9,%eax
  8007d5:	89 c1                	mov    %eax,%ecx
  8007d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007da:	01 c8                	add    %ecx,%eax
  8007dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8007e1:	39 c2                	cmp    %eax,%edx
  8007e3:	74 17                	je     8007fc <_main+0x7c4>
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	68 34 3d 80 00       	push   $0x803d34
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 1c 3d 80 00       	push   $0x803d1c
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 b1 1b 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 64 3d 80 00       	push   $0x803d64
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 1c 3d 80 00       	push   $0x803d1c
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 f0 1a 00 00       	call   802312 <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 81 3d 80 00       	push   $0x803d81
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 1c 3d 80 00       	push   $0x803d1c
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 cb 1a 00 00       	call   802312 <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 63 1b 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	83 ec 0c             	sub    $0xc,%esp
  80085a:	50                   	push   %eax
  80085b:	e8 4e 16 00 00       	call   801eae <malloc>
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800866:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086e:	c1 e0 03             	shl    $0x3,%eax
  800871:	05 00 00 00 80       	add    $0x80000000,%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 17                	je     800891 <_main+0x859>
  80087a:	83 ec 04             	sub    $0x4,%esp
  80087d:	68 34 3d 80 00       	push   $0x803d34
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 1c 3d 80 00       	push   $0x803d1c
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 1c 1b 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 64 3d 80 00       	push   $0x803d64
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 1c 3d 80 00       	push   $0x803d1c
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 5b 1a 00 00       	call   802312 <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 81 3d 80 00       	push   $0x803d81
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 1c 3d 80 00       	push   $0x803d1c
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 36 1a 00 00       	call   802312 <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 ce 1a 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c1 e0 02             	shl    $0x2,%eax
  8008ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008f0:	83 ec 0c             	sub    $0xc,%esp
  8008f3:	50                   	push   %eax
  8008f4:	e8 b5 15 00 00       	call   801eae <malloc>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  8008ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800902:	89 c1                	mov    %eax,%ecx
  800904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800907:	89 d0                	mov    %edx,%eax
  800909:	01 c0                	add    %eax,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	01 c0                	add    %eax,%eax
  800913:	05 00 00 00 80       	add    $0x80000000,%eax
  800918:	39 c1                	cmp    %eax,%ecx
  80091a:	74 17                	je     800933 <_main+0x8fb>
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	68 34 3d 80 00       	push   $0x803d34
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 1c 3d 80 00       	push   $0x803d1c
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 7a 1a 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 64 3d 80 00       	push   $0x803d64
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 1c 3d 80 00       	push   $0x803d1c
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 b9 19 00 00       	call   802312 <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 81 3d 80 00       	push   $0x803d81
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 1c 3d 80 00       	push   $0x803d1c
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 94 19 00 00       	call   802312 <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 2c 1a 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 a4 15 00 00       	call   801f39 <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 15 1a 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 94 3d 80 00       	push   $0x803d94
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 1c 3d 80 00       	push   $0x803d1c
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 54 19 00 00       	call   802312 <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 ab 3d 80 00       	push   $0x803dab
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 1c 3d 80 00       	push   $0x803d1c
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 2f 19 00 00       	call   802312 <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 c7 19 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 3f 15 00 00       	call   801f39 <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 b0 19 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 94 3d 80 00       	push   $0x803d94
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 1c 3d 80 00       	push   $0x803d1c
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 ef 18 00 00       	call   802312 <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 ab 3d 80 00       	push   $0x803dab
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 1c 3d 80 00       	push   $0x803d1c
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 ca 18 00 00       	call   802312 <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 62 19 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 da 14 00 00       	call   801f39 <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 4b 19 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 94 3d 80 00       	push   $0x803d94
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 1c 3d 80 00       	push   $0x803d1c
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 8a 18 00 00       	call   802312 <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 ab 3d 80 00       	push   $0x803dab
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 1c 3d 80 00       	push   $0x803d1c
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 65 18 00 00       	call   802312 <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 fd 18 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800abb:	c1 e0 06             	shl    $0x6,%eax
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	c1 e0 02             	shl    $0x2,%eax
  800ac8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800acb:	83 ec 0c             	sub    $0xc,%esp
  800ace:	50                   	push   %eax
  800acf:	e8 da 13 00 00       	call   801eae <malloc>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800ada:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800add:	89 c1                	mov    %eax,%ecx
  800adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d0                	add    %edx,%eax
  800ae8:	c1 e0 08             	shl    $0x8,%eax
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af0:	01 d0                	add    %edx,%eax
  800af2:	05 00 00 00 80       	add    $0x80000000,%eax
  800af7:	39 c1                	cmp    %eax,%ecx
  800af9:	74 17                	je     800b12 <_main+0xada>
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 34 3d 80 00       	push   $0x803d34
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 1c 3d 80 00       	push   $0x803d1c
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 9b 18 00 00       	call   8023b2 <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 64 3d 80 00       	push   $0x803d64
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 1c 3d 80 00       	push   $0x803d1c
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 da 17 00 00       	call   802312 <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 81 3d 80 00       	push   $0x803d81
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 1c 3d 80 00       	push   $0x803d1c
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 b8 3d 80 00       	push   $0x803db8
  800b60:	e8 f9 03 00 00       	call   800f5e <cprintf>
  800b65:	83 c4 10             	add    $0x10,%esp

	return;
  800b68:	90                   	nop
}
  800b69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b74:	e8 79 1a 00 00       	call   8025f2 <sys_getenvindex>
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7f:	89 d0                	mov    %edx,%eax
  800b81:	c1 e0 03             	shl    $0x3,%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	01 c0                	add    %eax,%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b91:	01 d0                	add    %edx,%eax
  800b93:	c1 e0 04             	shl    $0x4,%eax
  800b96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b9b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ba0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0f                	je     800bbe <libmain+0x50>
		binaryname = myEnv->prog_name;
  800baf:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb4:	05 5c 05 00 00       	add    $0x55c,%eax
  800bb9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	7e 0a                	jle    800bce <libmain+0x60>
		binaryname = argv[0];
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 5c f4 ff ff       	call   800038 <_main>
  800bdc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bdf:	e8 1b 18 00 00       	call   8023ff <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 1c 3e 80 00       	push   $0x803e1c
  800bec:	e8 6d 03 00 00       	call   800f5e <cprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bff:	a1 20 50 80 00       	mov    0x805020,%eax
  800c04:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	52                   	push   %edx
  800c0e:	50                   	push   %eax
  800c0f:	68 44 3e 80 00       	push   $0x803e44
  800c14:	e8 45 03 00 00       	call   800f5e <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c1c:	a1 20 50 80 00       	mov    0x805020,%eax
  800c21:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c27:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c32:	a1 20 50 80 00       	mov    0x805020,%eax
  800c37:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c3d:	51                   	push   %ecx
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	68 6c 3e 80 00       	push   $0x803e6c
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 c4 3e 80 00       	push   $0x803ec4
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 1c 3e 80 00       	push   $0x803e1c
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 9b 17 00 00       	call   802419 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c7e:	e8 19 00 00 00       	call   800c9c <exit>
}
  800c83:	90                   	nop
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	6a 00                	push   $0x0
  800c91:	e8 28 19 00 00       	call   8025be <sys_destroy_env>
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <exit>:

void
exit(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800ca2:	e8 7d 19 00 00       	call   802624 <sys_exit_env>
}
  800ca7:	90                   	nop
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800cb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800cb9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 16                	je     800cd8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cc2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	50                   	push   %eax
  800ccb:	68 d8 3e 80 00       	push   $0x803ed8
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 dd 3e 80 00       	push   $0x803edd
  800ce9:	e8 70 02 00 00       	call   800f5e <cprintf>
  800cee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	e8 f3 01 00 00       	call   800ef3 <vcprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	6a 00                	push   $0x0
  800d08:	68 f9 3e 80 00       	push   $0x803ef9
  800d0d:	e8 e1 01 00 00       	call   800ef3 <vcprintf>
  800d12:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d15:	e8 82 ff ff ff       	call   800c9c <exit>

	// should not return here
	while (1) ;
  800d1a:	eb fe                	jmp    800d1a <_panic+0x70>

00800d1c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d22:	a1 20 50 80 00       	mov    0x805020,%eax
  800d27:	8b 50 74             	mov    0x74(%eax),%edx
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	74 14                	je     800d45 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	68 fc 3e 80 00       	push   $0x803efc
  800d39:	6a 26                	push   $0x26
  800d3b:	68 48 3f 80 00       	push   $0x803f48
  800d40:	e8 65 ff ff ff       	call   800caa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d53:	e9 c2 00 00 00       	jmp    800e1a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	75 08                	jne    800d75 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d70:	e9 a2 00 00 00       	jmp    800e17 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d83:	eb 69                	jmp    800dee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d85:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8a 40 04             	mov    0x4(%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 46                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800da5:	a1 20 50 80 00       	mov    0x805020,%eax
  800daa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	01 c0                	add    %eax,%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	c1 e0 03             	shl    $0x3,%eax
  800dbc:	01 c8                	add    %ecx,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dde:	39 c2                	cmp    %eax,%edx
  800de0:	75 09                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800de2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800de9:	eb 12                	jmp    800dfd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800deb:	ff 45 e8             	incl   -0x18(%ebp)
  800dee:	a1 20 50 80 00       	mov    0x805020,%eax
  800df3:	8b 50 74             	mov    0x74(%eax),%edx
  800df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800df9:	39 c2                	cmp    %eax,%edx
  800dfb:	77 88                	ja     800d85 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e01:	75 14                	jne    800e17 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	68 54 3f 80 00       	push   $0x803f54
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 48 3f 80 00       	push   $0x803f48
  800e12:	e8 93 fe ff ff       	call   800caa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e17:	ff 45 f0             	incl   -0x10(%ebp)
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e20:	0f 8c 32 ff ff ff    	jl     800d58 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e34:	eb 26                	jmp    800e5c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e36:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	c1 e0 03             	shl    $0x3,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8a 40 04             	mov    0x4(%eax),%al
  800e52:	3c 01                	cmp    $0x1,%al
  800e54:	75 03                	jne    800e59 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e56:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e59:	ff 45 e0             	incl   -0x20(%ebp)
  800e5c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e61:	8b 50 74             	mov    0x74(%eax),%edx
  800e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e67:	39 c2                	cmp    %eax,%edx
  800e69:	77 cb                	ja     800e36 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e71:	74 14                	je     800e87 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	68 a8 3f 80 00       	push   $0x803fa8
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 48 3f 80 00       	push   $0x803f48
  800e82:	e8 23 fe ff ff       	call   800caa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e87:	90                   	nop
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	8d 48 01             	lea    0x1(%eax),%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 0a                	mov    %ecx,(%edx)
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	88 d1                	mov    %dl,%cl
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	3d ff 00 00 00       	cmp    $0xff,%eax
  800eb3:	75 2c                	jne    800ee1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eb5:	a0 24 50 80 00       	mov    0x805024,%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec0:	8b 12                	mov    (%edx),%edx
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	83 c2 08             	add    $0x8,%edx
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	50                   	push   %eax
  800ece:	51                   	push   %ecx
  800ecf:	52                   	push   %edx
  800ed0:	e8 7c 13 00 00       	call   802251 <sys_cputs>
  800ed5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 40 04             	mov    0x4(%eax),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ef0:	90                   	nop
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800efc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f03:	00 00 00 
	b.cnt = 0;
  800f06:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f0d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	68 8a 0e 80 00       	push   $0x800e8a
  800f22:	e8 11 02 00 00       	call   801138 <vprintfmt>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f2a:	a0 24 50 80 00       	mov    0x805024,%al
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	50                   	push   %eax
  800f3c:	52                   	push   %edx
  800f3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f43:	83 c0 08             	add    $0x8,%eax
  800f46:	50                   	push   %eax
  800f47:	e8 05 13 00 00       	call   802251 <sys_cputs>
  800f4c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f4f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f56:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <cprintf>:

int cprintf(const char *fmt, ...) {
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f64:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	e8 73 ff ff ff       	call   800ef3 <vcprintf>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f91:	e8 69 14 00 00       	call   8023ff <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	e8 48 ff ff ff       	call   800ef3 <vcprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800fb1:	e8 63 14 00 00       	call   802419 <sys_enable_interrupt>
	return cnt;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 14             	sub    $0x14,%esp
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fce:	8b 45 18             	mov    0x18(%ebp),%eax
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd9:	77 55                	ja     801030 <printnum+0x75>
  800fdb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fde:	72 05                	jb     800fe5 <printnum+0x2a>
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	77 4b                	ja     801030 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fe5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fe8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800feb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff3:	52                   	push   %edx
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffb:	e8 80 2a 00 00       	call   803a80 <__udivdi3>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	ff 75 20             	pushl  0x20(%ebp)
  801009:	53                   	push   %ebx
  80100a:	ff 75 18             	pushl  0x18(%ebp)
  80100d:	52                   	push   %edx
  80100e:	50                   	push   %eax
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 a1 ff ff ff       	call   800fbb <printnum>
  80101a:	83 c4 20             	add    $0x20,%esp
  80101d:	eb 1a                	jmp    801039 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 20             	pushl  0x20(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801030:	ff 4d 1c             	decl   0x1c(%ebp)
  801033:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801037:	7f e6                	jg     80101f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801039:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	53                   	push   %ebx
  801048:	51                   	push   %ecx
  801049:	52                   	push   %edx
  80104a:	50                   	push   %eax
  80104b:	e8 40 2b 00 00       	call   803b90 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 14 42 80 00       	add    $0x804214,%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f be c0             	movsbl %al,%eax
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	50                   	push   %eax
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
}
  80106c:	90                   	nop
  80106d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801075:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801079:	7e 1c                	jle    801097 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8b 00                	mov    (%eax),%eax
  801080:	8d 50 08             	lea    0x8(%eax),%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 10                	mov    %edx,(%eax)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	83 e8 08             	sub    $0x8,%eax
  801090:	8b 50 04             	mov    0x4(%eax),%edx
  801093:	8b 00                	mov    (%eax),%eax
  801095:	eb 40                	jmp    8010d7 <getuint+0x65>
	else if (lflag)
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	74 1e                	je     8010bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 04             	lea    0x4(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 04             	sub    $0x4,%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b9:	eb 1c                	jmp    8010d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 50 04             	lea    0x4(%eax),%edx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	89 10                	mov    %edx,(%eax)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	83 e8 04             	sub    $0x4,%eax
  8010d0:	8b 00                	mov    (%eax),%eax
  8010d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010e0:	7e 1c                	jle    8010fe <getint+0x25>
		return va_arg(*ap, long long);
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	8d 50 08             	lea    0x8(%eax),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 10                	mov    %edx,(%eax)
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	83 e8 08             	sub    $0x8,%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	eb 38                	jmp    801136 <getint+0x5d>
	else if (lflag)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 1a                	je     80111e <getint+0x45>
		return va_arg(*ap, long);
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	8d 50 04             	lea    0x4(%eax),%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 10                	mov    %edx,(%eax)
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	83 e8 04             	sub    $0x4,%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	99                   	cltd   
  80111c:	eb 18                	jmp    801136 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 50 04             	lea    0x4(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 10                	mov    %edx,(%eax)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 e8 04             	sub    $0x4,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	99                   	cltd   
}
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801140:	eb 17                	jmp    801159 <vprintfmt+0x21>
			if (ch == '\0')
  801142:	85 db                	test   %ebx,%ebx
  801144:	0f 84 af 03 00 00    	je     8014f9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d8             	movzbl %al,%ebx
  801167:	83 fb 25             	cmp    $0x25,%ebx
  80116a:	75 d6                	jne    801142 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801170:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801177:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80117e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 10             	mov    %edx,0x10(%ebp)
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f b6 d8             	movzbl %al,%ebx
  80119a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80119d:	83 f8 55             	cmp    $0x55,%eax
  8011a0:	0f 87 2b 03 00 00    	ja     8014d1 <vprintfmt+0x399>
  8011a6:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
  8011ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011b3:	eb d7                	jmp    80118c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011b9:	eb d1                	jmp    80118c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	c1 e0 02             	shl    $0x2,%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	01 c0                	add    %eax,%eax
  8011ce:	01 d8                	add    %ebx,%eax
  8011d0:	83 e8 30             	sub    $0x30,%eax
  8011d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011de:	83 fb 2f             	cmp    $0x2f,%ebx
  8011e1:	7e 3e                	jle    801221 <vprintfmt+0xe9>
  8011e3:	83 fb 39             	cmp    $0x39,%ebx
  8011e6:	7f 39                	jg     801221 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011eb:	eb d5                	jmp    8011c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	83 c0 04             	add    $0x4,%eax
  8011f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f9:	83 e8 04             	sub    $0x4,%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801201:	eb 1f                	jmp    801222 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801207:	79 83                	jns    80118c <vprintfmt+0x54>
				width = 0;
  801209:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801210:	e9 77 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801215:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80121c:	e9 6b ff ff ff       	jmp    80118c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801221:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801222:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801226:	0f 89 60 ff ff ff    	jns    80118c <vprintfmt+0x54>
				width = precision, precision = -1;
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801232:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801239:	e9 4e ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80123e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801241:	e9 46 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 00                	mov    (%eax),%eax
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	50                   	push   %eax
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	ff d0                	call   *%eax
  801263:	83 c4 10             	add    $0x10,%esp
			break;
  801266:	e9 89 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80127c:	85 db                	test   %ebx,%ebx
  80127e:	79 02                	jns    801282 <vprintfmt+0x14a>
				err = -err;
  801280:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801282:	83 fb 64             	cmp    $0x64,%ebx
  801285:	7f 0b                	jg     801292 <vprintfmt+0x15a>
  801287:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 25 42 80 00       	push   $0x804225
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 5e 02 00 00       	call   801501 <printfmt>
  8012a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012a6:	e9 49 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012ab:	56                   	push   %esi
  8012ac:	68 2e 42 80 00       	push   $0x80422e
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	ff 75 08             	pushl  0x8(%ebp)
  8012b7:	e8 45 02 00 00       	call   801501 <printfmt>
  8012bc:	83 c4 10             	add    $0x10,%esp
			break;
  8012bf:	e9 30 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 30                	mov    (%eax),%esi
  8012d5:	85 f6                	test   %esi,%esi
  8012d7:	75 05                	jne    8012de <vprintfmt+0x1a6>
				p = "(null)";
  8012d9:	be 31 42 80 00       	mov    $0x804231,%esi
			if (width > 0 && padc != '-')
  8012de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e2:	7e 6d                	jle    801351 <vprintfmt+0x219>
  8012e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012e8:	74 67                	je     801351 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	50                   	push   %eax
  8012f1:	56                   	push   %esi
  8012f2:	e8 0c 03 00 00       	call   801603 <strnlen>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012fd:	eb 16                	jmp    801315 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	50                   	push   %eax
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	ff d0                	call   *%eax
  80130f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801312:	ff 4d e4             	decl   -0x1c(%ebp)
  801315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801319:	7f e4                	jg     8012ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80131b:	eb 34                	jmp    801351 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80131d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801321:	74 1c                	je     80133f <vprintfmt+0x207>
  801323:	83 fb 1f             	cmp    $0x1f,%ebx
  801326:	7e 05                	jle    80132d <vprintfmt+0x1f5>
  801328:	83 fb 7e             	cmp    $0x7e,%ebx
  80132b:	7e 12                	jle    80133f <vprintfmt+0x207>
					putch('?', putdat);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 0c             	pushl  0xc(%ebp)
  801333:	6a 3f                	push   $0x3f
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	ff d0                	call   *%eax
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb 0f                	jmp    80134e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	53                   	push   %ebx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	ff d0                	call   *%eax
  80134b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80134e:	ff 4d e4             	decl   -0x1c(%ebp)
  801351:	89 f0                	mov    %esi,%eax
  801353:	8d 70 01             	lea    0x1(%eax),%esi
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be d8             	movsbl %al,%ebx
  80135b:	85 db                	test   %ebx,%ebx
  80135d:	74 24                	je     801383 <vprintfmt+0x24b>
  80135f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801363:	78 b8                	js     80131d <vprintfmt+0x1e5>
  801365:	ff 4d e0             	decl   -0x20(%ebp)
  801368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136c:	79 af                	jns    80131d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80136e:	eb 13                	jmp    801383 <vprintfmt+0x24b>
				putch(' ', putdat);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	6a 20                	push   $0x20
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	ff d0                	call   *%eax
  80137d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801380:	ff 4d e4             	decl   -0x1c(%ebp)
  801383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801387:	7f e7                	jg     801370 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801389:	e9 66 01 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	8d 45 14             	lea    0x14(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	e8 3c fd ff ff       	call   8010d9 <getint>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	79 23                	jns    8013d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 2d                	push   $0x2d
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	f7 d8                	neg    %eax
  8013c8:	83 d2 00             	adc    $0x0,%edx
  8013cb:	f7 da                	neg    %edx
  8013cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013da:	e9 bc 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	e8 84 fc ff ff       	call   801072 <getuint>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013fe:	e9 98 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	6a 58                	push   $0x58
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	ff d0                	call   *%eax
  801430:	83 c4 10             	add    $0x10,%esp
			break;
  801433:	e9 bc 00 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 30                	push   $0x30
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	6a 78                	push   $0x78
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	ff d0                	call   *%eax
  801455:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801458:	8b 45 14             	mov    0x14(%ebp),%eax
  80145b:	83 c0 04             	add    $0x4,%eax
  80145e:	89 45 14             	mov    %eax,0x14(%ebp)
  801461:	8b 45 14             	mov    0x14(%ebp),%eax
  801464:	83 e8 04             	sub    $0x4,%eax
  801467:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801473:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80147a:	eb 1f                	jmp    80149b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 e8             	pushl  -0x18(%ebp)
  801482:	8d 45 14             	lea    0x14(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	e8 e7 fb ff ff       	call   801072 <getuint>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801491:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801494:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80149b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 00 fb ff ff       	call   800fbb <printnum>
  8014bb:	83 c4 20             	add    $0x20,%esp
			break;
  8014be:	eb 34                	jmp    8014f4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	53                   	push   %ebx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	ff d0                	call   *%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
			break;
  8014cf:	eb 23                	jmp    8014f4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	6a 25                	push   $0x25
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	ff d0                	call   *%eax
  8014de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e1:	ff 4d 10             	decl   0x10(%ebp)
  8014e4:	eb 03                	jmp    8014e9 <vprintfmt+0x3b1>
  8014e6:	ff 4d 10             	decl   0x10(%ebp)
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	48                   	dec    %eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 25                	cmp    $0x25,%al
  8014f1:	75 f3                	jne    8014e6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014f3:	90                   	nop
		}
	}
  8014f4:	e9 47 fc ff ff       	jmp    801140 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801507:	8d 45 10             	lea    0x10(%ebp),%eax
  80150a:	83 c0 04             	add    $0x4,%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	ff 75 f4             	pushl  -0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 16 fc ff ff       	call   801138 <vprintfmt>
  801522:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801525:	90                   	nop
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 40 08             	mov    0x8(%eax),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	8b 10                	mov    (%eax),%edx
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8b 40 04             	mov    0x4(%eax),%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	73 12                	jae    80155b <sprintputch+0x33>
		*b->buf++ = ch;
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 48 01             	lea    0x1(%eax),%ecx
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	89 0a                	mov    %ecx,(%edx)
  801556:	8b 55 08             	mov    0x8(%ebp),%edx
  801559:	88 10                	mov    %dl,(%eax)
}
  80155b:	90                   	nop
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80157f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801583:	74 06                	je     80158b <vsnprintf+0x2d>
  801585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801589:	7f 07                	jg     801592 <vsnprintf+0x34>
		return -E_INVAL;
  80158b:	b8 03 00 00 00       	mov    $0x3,%eax
  801590:	eb 20                	jmp    8015b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801592:	ff 75 14             	pushl  0x14(%ebp)
  801595:	ff 75 10             	pushl  0x10(%ebp)
  801598:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	68 28 15 80 00       	push   $0x801528
  8015a1:	e8 92 fb ff ff       	call   801138 <vprintfmt>
  8015a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bd:	83 c0 04             	add    $0x4,%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 89 ff ff ff       	call   80155e <vsnprintf>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 06                	jmp    8015f5 <strlen+0x15>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 f1                	jne    8015ef <strlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801610:	eb 09                	jmp    80161b <strnlen+0x18>
		n++;
  801612:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801615:	ff 45 08             	incl   0x8(%ebp)
  801618:	ff 4d 0c             	decl   0xc(%ebp)
  80161b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161f:	74 09                	je     80162a <strnlen+0x27>
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	75 e8                	jne    801612 <strnlen+0xf>
		n++;
	return n;
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163b:	90                   	nop
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8d 50 01             	lea    0x1(%eax),%edx
  801642:	89 55 08             	mov    %edx,0x8(%ebp)
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80164e:	8a 12                	mov    (%edx),%dl
  801650:	88 10                	mov    %dl,(%eax)
  801652:	8a 00                	mov    (%eax),%al
  801654:	84 c0                	test   %al,%al
  801656:	75 e4                	jne    80163c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801658:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801670:	eb 1f                	jmp    801691 <strncpy+0x34>
		*dst++ = *src;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8d 50 01             	lea    0x1(%eax),%edx
  801678:	89 55 08             	mov    %edx,0x8(%ebp)
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801682:	8b 45 0c             	mov    0xc(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	84 c0                	test   %al,%al
  801689:	74 03                	je     80168e <strncpy+0x31>
			src++;
  80168b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	3b 45 10             	cmp    0x10(%ebp),%eax
  801697:	72 d9                	jb     801672 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ae:	74 30                	je     8016e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b0:	eb 16                	jmp    8016c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8d 50 01             	lea    0x1(%eax),%edx
  8016b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c4:	8a 12                	mov    (%edx),%dl
  8016c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c8:	ff 4d 10             	decl   0x10(%ebp)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 09                	je     8016da <strlcpy+0x3c>
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	75 d8                	jne    8016b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ef:	eb 06                	jmp    8016f7 <strcmp+0xb>
		p++, q++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	84 c0                	test   %al,%al
  8016fe:	74 0e                	je     80170e <strcmp+0x22>
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 10                	mov    (%eax),%dl
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	74 e3                	je     8016f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 d0                	mov    %edx,%eax
}
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801727:	eb 09                	jmp    801732 <strncmp+0xe>
		n--, p++, q++;
  801729:	ff 4d 10             	decl   0x10(%ebp)
  80172c:	ff 45 08             	incl   0x8(%ebp)
  80172f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801732:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801736:	74 17                	je     80174f <strncmp+0x2b>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 0e                	je     80174f <strncmp+0x2b>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 10                	mov    (%eax),%dl
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	38 c2                	cmp    %al,%dl
  80174d:	74 da                	je     801729 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80174f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801753:	75 07                	jne    80175c <strncmp+0x38>
		return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 14                	jmp    801770 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f b6 c0             	movzbl %al,%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
}
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80177e:	eb 12                	jmp    801792 <strchr+0x20>
		if (*s == c)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801788:	75 05                	jne    80178f <strchr+0x1d>
			return (char *) s;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	eb 11                	jmp    8017a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80178f:	ff 45 08             	incl   0x8(%ebp)
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	84 c0                	test   %al,%al
  801799:	75 e5                	jne    801780 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ae:	eb 0d                	jmp    8017bd <strfind+0x1b>
		if (*s == c)
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017b8:	74 0e                	je     8017c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	84 c0                	test   %al,%al
  8017c4:	75 ea                	jne    8017b0 <strfind+0xe>
  8017c6:	eb 01                	jmp    8017c9 <strfind+0x27>
		if (*s == c)
			break;
  8017c8:	90                   	nop
	return (char *) s;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e0:	eb 0e                	jmp    8017f0 <memset+0x22>
		*p++ = c;
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	8d 50 01             	lea    0x1(%eax),%edx
  8017e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f0:	ff 4d f8             	decl   -0x8(%ebp)
  8017f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f7:	79 e9                	jns    8017e2 <memset+0x14>
		*p++ = c;

	return v;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801810:	eb 16                	jmp    801828 <memcpy+0x2a>
		*d++ = *s++;
  801812:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801815:	8d 50 01             	lea    0x1(%eax),%edx
  801818:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801821:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801824:	8a 12                	mov    (%edx),%dl
  801826:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	89 55 10             	mov    %edx,0x10(%ebp)
  801831:	85 c0                	test   %eax,%eax
  801833:	75 dd                	jne    801812 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801852:	73 50                	jae    8018a4 <memmove+0x6a>
  801854:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185f:	76 43                	jbe    8018a4 <memmove+0x6a>
		s += n;
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
  801864:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186d:	eb 10                	jmp    80187f <memmove+0x45>
			*--d = *--s;
  80186f:	ff 4d f8             	decl   -0x8(%ebp)
  801872:	ff 4d fc             	decl   -0x4(%ebp)
  801875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801878:	8a 10                	mov    (%eax),%dl
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	8d 50 ff             	lea    -0x1(%eax),%edx
  801885:	89 55 10             	mov    %edx,0x10(%ebp)
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 e3                	jne    80186f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188c:	eb 23                	jmp    8018b1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	8d 50 01             	lea    0x1(%eax),%edx
  801894:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801897:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a0:	8a 12                	mov    (%edx),%dl
  8018a2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 dd                	jne    80188e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018c8:	eb 2a                	jmp    8018f4 <memcmp+0x3e>
		if (*s1 != *s2)
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	8a 10                	mov    (%eax),%dl
  8018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	38 c2                	cmp    %al,%dl
  8018d6:	74 16                	je     8018ee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f b6 c0             	movzbl %al,%eax
  8018e8:	29 c2                	sub    %eax,%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	eb 18                	jmp    801906 <memcmp+0x50>
		s1++, s2++;
  8018ee:	ff 45 fc             	incl   -0x4(%ebp)
  8018f1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	75 c9                	jne    8018ca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801919:	eb 15                	jmp    801930 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	0f b6 d0             	movzbl %al,%edx
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	0f b6 c0             	movzbl %al,%eax
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	74 0d                	je     80193a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192d:	ff 45 08             	incl   0x8(%ebp)
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801936:	72 e3                	jb     80191b <memfind+0x13>
  801938:	eb 01                	jmp    80193b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193a:	90                   	nop
	return (void *) s;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801946:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801954:	eb 03                	jmp    801959 <strtol+0x19>
		s++;
  801956:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	3c 20                	cmp    $0x20,%al
  801960:	74 f4                	je     801956 <strtol+0x16>
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	8a 00                	mov    (%eax),%al
  801967:	3c 09                	cmp    $0x9,%al
  801969:	74 eb                	je     801956 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3c 2b                	cmp    $0x2b,%al
  801972:	75 05                	jne    801979 <strtol+0x39>
		s++;
  801974:	ff 45 08             	incl   0x8(%ebp)
  801977:	eb 13                	jmp    80198c <strtol+0x4c>
	else if (*s == '-')
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 2d                	cmp    $0x2d,%al
  801980:	75 0a                	jne    80198c <strtol+0x4c>
		s++, neg = 1;
  801982:	ff 45 08             	incl   0x8(%ebp)
  801985:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	74 06                	je     801998 <strtol+0x58>
  801992:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801996:	75 20                	jne    8019b8 <strtol+0x78>
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3c 30                	cmp    $0x30,%al
  80199f:	75 17                	jne    8019b8 <strtol+0x78>
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	40                   	inc    %eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	3c 78                	cmp    $0x78,%al
  8019a9:	75 0d                	jne    8019b8 <strtol+0x78>
		s += 2, base = 16;
  8019ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b6:	eb 28                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bc:	75 15                	jne    8019d3 <strtol+0x93>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 30                	cmp    $0x30,%al
  8019c5:	75 0c                	jne    8019d3 <strtol+0x93>
		s++, base = 8;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
  8019ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d1:	eb 0d                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0)
  8019d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d7:	75 07                	jne    8019e0 <strtol+0xa0>
		base = 10;
  8019d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 2f                	cmp    $0x2f,%al
  8019e7:	7e 19                	jle    801a02 <strtol+0xc2>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 39                	cmp    $0x39,%al
  8019f0:	7f 10                	jg     801a02 <strtol+0xc2>
			dig = *s - '0';
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	0f be c0             	movsbl %al,%eax
  8019fa:	83 e8 30             	sub    $0x30,%eax
  8019fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a00:	eb 42                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3c 60                	cmp    $0x60,%al
  801a09:	7e 19                	jle    801a24 <strtol+0xe4>
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	3c 7a                	cmp    $0x7a,%al
  801a12:	7f 10                	jg     801a24 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	0f be c0             	movsbl %al,%eax
  801a1c:	83 e8 57             	sub    $0x57,%eax
  801a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a22:	eb 20                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	3c 40                	cmp    $0x40,%al
  801a2b:	7e 39                	jle    801a66 <strtol+0x126>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	3c 5a                	cmp    $0x5a,%al
  801a34:	7f 30                	jg     801a66 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f be c0             	movsbl %al,%eax
  801a3e:	83 e8 37             	sub    $0x37,%eax
  801a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4a:	7d 19                	jge    801a65 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4c:	ff 45 08             	incl   0x8(%ebp)
  801a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a52:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a60:	e9 7b ff ff ff       	jmp    8019e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a65:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6a:	74 08                	je     801a74 <strtol+0x134>
		*endptr = (char *) s;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a72:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a78:	74 07                	je     801a81 <strtol+0x141>
  801a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7d:	f7 d8                	neg    %eax
  801a7f:	eb 03                	jmp    801a84 <strtol+0x144>
  801a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <ltostr>:

void
ltostr(long value, char *str)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9e:	79 13                	jns    801ab3 <ltostr+0x2d>
	{
		neg = 1;
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abb:	99                   	cltd   
  801abc:	f7 f9                	idiv   %ecx
  801abe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac4:	8d 50 01             	lea    0x1(%eax),%edx
  801ac7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad4:	83 c2 30             	add    $0x30,%edx
  801ad7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae1:	f7 e9                	imul   %ecx
  801ae3:	c1 fa 02             	sar    $0x2,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	c1 f8 1f             	sar    $0x1f,%eax
  801aeb:	29 c2                	sub    %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801afa:	f7 e9                	imul   %ecx
  801afc:	c1 fa 02             	sar    $0x2,%edx
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	c1 f8 1f             	sar    $0x1f,%eax
  801b04:	29 c2                	sub    %eax,%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	c1 e0 02             	shl    $0x2,%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	29 c1                	sub    %eax,%ecx
  801b11:	89 ca                	mov    %ecx,%edx
  801b13:	85 d2                	test   %edx,%edx
  801b15:	75 9c                	jne    801ab3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b21:	48                   	dec    %eax
  801b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b29:	74 3d                	je     801b68 <ltostr+0xe2>
		start = 1 ;
  801b2b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b32:	eb 34                	jmp    801b68 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 c2                	add    %eax,%edx
  801b49:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	01 c8                	add    %ecx,%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b60:	88 02                	mov    %al,(%edx)
		start++ ;
  801b62:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b65:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6e:	7c c4                	jl     801b34 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b70:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 54 fa ff ff       	call   8015e0 <strlen>
  801b8c:	83 c4 04             	add    $0x4,%esp
  801b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	e8 46 fa ff ff       	call   8015e0 <strlen>
  801b9a:	83 c4 04             	add    $0x4,%esp
  801b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bae:	eb 17                	jmp    801bc7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb6:	01 c2                	add    %eax,%edx
  801bb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	01 c8                	add    %ecx,%eax
  801bc0:	8a 00                	mov    (%eax),%al
  801bc2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bcd:	7c e1                	jl     801bb0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bdd:	eb 1f                	jmp    801bfe <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be2:	8d 50 01             	lea    0x1(%eax),%edx
  801be5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	01 c2                	add    %eax,%edx
  801bef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	01 c8                	add    %ecx,%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bfb:	ff 45 f8             	incl   -0x8(%ebp)
  801bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c04:	7c d9                	jl     801bdf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c6 00 00             	movb   $0x0,(%eax)
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c37:	eb 0c                	jmp    801c45 <strsplit+0x31>
			*string++ = 0;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8d 50 01             	lea    0x1(%eax),%edx
  801c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c42:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	84 c0                	test   %al,%al
  801c4c:	74 18                	je     801c66 <strsplit+0x52>
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	e8 13 fb ff ff       	call   801772 <strchr>
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 d3                	jne    801c39 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	84 c0                	test   %al,%al
  801c6d:	74 5a                	je     801cc9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c72:	8b 00                	mov    (%eax),%eax
  801c74:	83 f8 0f             	cmp    $0xf,%eax
  801c77:	75 07                	jne    801c80 <strsplit+0x6c>
		{
			return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb 66                	jmp    801ce6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	8d 48 01             	lea    0x1(%eax),%ecx
  801c88:	8b 55 14             	mov    0x14(%ebp),%edx
  801c8b:	89 0a                	mov    %ecx,(%edx)
  801c8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	01 c2                	add    %eax,%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c9e:	eb 03                	jmp    801ca3 <strsplit+0x8f>
			string++;
  801ca0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8a 00                	mov    (%eax),%al
  801ca8:	84 c0                	test   %al,%al
  801caa:	74 8b                	je     801c37 <strsplit+0x23>
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	0f be c0             	movsbl %al,%eax
  801cb4:	50                   	push   %eax
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	e8 b5 fa ff ff       	call   801772 <strchr>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	74 dc                	je     801ca0 <strsplit+0x8c>
			string++;
	}
  801cc4:	e9 6e ff ff ff       	jmp    801c37 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cc9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ce1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801cee:	a1 04 50 80 00       	mov    0x805004,%eax
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	74 1f                	je     801d16 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cf7:	e8 1d 00 00 00       	call   801d19 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	68 90 43 80 00       	push   $0x804390
  801d04:	e8 55 f2 ff ff       	call   800f5e <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d0c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d13:	00 00 00 
	}
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801d1f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d26:	00 00 00 
  801d29:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d30:	00 00 00 
  801d33:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d3a:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801d3d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d44:	00 00 00 
  801d47:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d4e:	00 00 00 
  801d51:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d58:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801d5b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d62:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801d65:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801d6c:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d7b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d80:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801d85:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d94:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	6a 06                	push   $0x6
  801d9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801da1:	50                   	push   %eax
  801da2:	e8 ee 05 00 00       	call   802395 <sys_allocate_chunk>
  801da7:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801daa:	a1 20 51 80 00       	mov    0x805120,%eax
  801daf:	83 ec 0c             	sub    $0xc,%esp
  801db2:	50                   	push   %eax
  801db3:	e8 63 0c 00 00       	call   802a1b <initialize_MemBlocksList>
  801db8:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801dbb:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801dc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801dcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dde:	89 c2                	mov    %eax,%edx
  801de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de3:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801de6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de9:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801df0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801df7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dfa:	8b 50 08             	mov    0x8(%eax),%edx
  801dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e00:	01 d0                	add    %edx,%eax
  801e02:	48                   	dec    %eax
  801e03:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e09:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0e:	f7 75 e0             	divl   -0x20(%ebp)
  801e11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e14:	29 d0                	sub    %edx,%eax
  801e16:	89 c2                	mov    %eax,%edx
  801e18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e1b:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801e1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e22:	75 14                	jne    801e38 <initialize_dyn_block_system+0x11f>
  801e24:	83 ec 04             	sub    $0x4,%esp
  801e27:	68 b5 43 80 00       	push   $0x8043b5
  801e2c:	6a 34                	push   $0x34
  801e2e:	68 d3 43 80 00       	push   $0x8043d3
  801e33:	e8 72 ee ff ff       	call   800caa <_panic>
  801e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	74 10                	je     801e51 <initialize_dyn_block_system+0x138>
  801e41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e44:	8b 00                	mov    (%eax),%eax
  801e46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e49:	8b 52 04             	mov    0x4(%edx),%edx
  801e4c:	89 50 04             	mov    %edx,0x4(%eax)
  801e4f:	eb 0b                	jmp    801e5c <initialize_dyn_block_system+0x143>
  801e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e54:	8b 40 04             	mov    0x4(%eax),%eax
  801e57:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e5f:	8b 40 04             	mov    0x4(%eax),%eax
  801e62:	85 c0                	test   %eax,%eax
  801e64:	74 0f                	je     801e75 <initialize_dyn_block_system+0x15c>
  801e66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e69:	8b 40 04             	mov    0x4(%eax),%eax
  801e6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e6f:	8b 12                	mov    (%edx),%edx
  801e71:	89 10                	mov    %edx,(%eax)
  801e73:	eb 0a                	jmp    801e7f <initialize_dyn_block_system+0x166>
  801e75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e78:	8b 00                	mov    (%eax),%eax
  801e7a:	a3 48 51 80 00       	mov    %eax,0x805148
  801e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e92:	a1 54 51 80 00       	mov    0x805154,%eax
  801e97:	48                   	dec    %eax
  801e98:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	ff 75 e8             	pushl  -0x18(%ebp)
  801ea3:	e8 c4 13 00 00       	call   80326c <insert_sorted_with_merge_freeList>
  801ea8:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801eab:	90                   	nop
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <malloc>:
//=================================



void* malloc(uint32 size)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eb4:	e8 2f fe ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801eb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ebd:	75 07                	jne    801ec6 <malloc+0x18>
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec4:	eb 71                	jmp    801f37 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801ec6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801ecd:	76 07                	jbe    801ed6 <malloc+0x28>
	return NULL;
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	eb 61                	jmp    801f37 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ed6:	e8 88 08 00 00       	call   802763 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801edb:	85 c0                	test   %eax,%eax
  801edd:	74 53                	je     801f32 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801edf:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	48                   	dec    %eax
  801eef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  801efa:	f7 75 f4             	divl   -0xc(%ebp)
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f00:	29 d0                	sub    %edx,%eax
  801f02:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	ff 75 ec             	pushl  -0x14(%ebp)
  801f0b:	e8 d2 0d 00 00       	call   802ce2 <alloc_block_FF>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801f16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f1a:	74 16                	je     801f32 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	ff 75 e8             	pushl  -0x18(%ebp)
  801f22:	e8 0c 0c 00 00       	call   802b33 <insert_sorted_allocList>
  801f27:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f2d:	8b 40 08             	mov    0x8(%eax),%eax
  801f30:	eb 05                	jmp    801f37 <malloc+0x89>
    }

			}


	return NULL;
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801f50:	83 ec 08             	sub    $0x8,%esp
  801f53:	ff 75 f0             	pushl  -0x10(%ebp)
  801f56:	68 40 50 80 00       	push   $0x805040
  801f5b:	e8 a0 0b 00 00       	call   802b00 <find_block>
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f69:	8b 50 0c             	mov    0xc(%eax),%edx
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	83 ec 08             	sub    $0x8,%esp
  801f72:	52                   	push   %edx
  801f73:	50                   	push   %eax
  801f74:	e8 e4 03 00 00       	call   80235d <sys_free_user_mem>
  801f79:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801f7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f80:	75 17                	jne    801f99 <free+0x60>
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	68 b5 43 80 00       	push   $0x8043b5
  801f8a:	68 84 00 00 00       	push   $0x84
  801f8f:	68 d3 43 80 00       	push   $0x8043d3
  801f94:	e8 11 ed ff ff       	call   800caa <_panic>
  801f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9c:	8b 00                	mov    (%eax),%eax
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	74 10                	je     801fb2 <free+0x79>
  801fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa5:	8b 00                	mov    (%eax),%eax
  801fa7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801faa:	8b 52 04             	mov    0x4(%edx),%edx
  801fad:	89 50 04             	mov    %edx,0x4(%eax)
  801fb0:	eb 0b                	jmp    801fbd <free+0x84>
  801fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb5:	8b 40 04             	mov    0x4(%eax),%eax
  801fb8:	a3 44 50 80 00       	mov    %eax,0x805044
  801fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc0:	8b 40 04             	mov    0x4(%eax),%eax
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	74 0f                	je     801fd6 <free+0x9d>
  801fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fca:	8b 40 04             	mov    0x4(%eax),%eax
  801fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fd0:	8b 12                	mov    (%edx),%edx
  801fd2:	89 10                	mov    %edx,(%eax)
  801fd4:	eb 0a                	jmp    801fe0 <free+0xa7>
  801fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd9:	8b 00                	mov    (%eax),%eax
  801fdb:	a3 40 50 80 00       	mov    %eax,0x805040
  801fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ff3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ff8:	48                   	dec    %eax
  801ff9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	ff 75 ec             	pushl  -0x14(%ebp)
  802004:	e8 63 12 00 00       	call   80326c <insert_sorted_with_merge_freeList>
  802009:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80200c:	90                   	nop
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 38             	sub    $0x38,%esp
  802015:	8b 45 10             	mov    0x10(%ebp),%eax
  802018:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80201b:	e8 c8 fc ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802020:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802024:	75 0a                	jne    802030 <smalloc+0x21>
  802026:	b8 00 00 00 00       	mov    $0x0,%eax
  80202b:	e9 a0 00 00 00       	jmp    8020d0 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  802030:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  802037:	76 0a                	jbe    802043 <smalloc+0x34>
		return NULL;
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	e9 8d 00 00 00       	jmp    8020d0 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802043:	e8 1b 07 00 00       	call   802763 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802048:	85 c0                	test   %eax,%eax
  80204a:	74 7f                	je     8020cb <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80204c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802053:	8b 55 0c             	mov    0xc(%ebp),%edx
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	01 d0                	add    %edx,%eax
  80205b:	48                   	dec    %eax
  80205c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80205f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802062:	ba 00 00 00 00       	mov    $0x0,%edx
  802067:	f7 75 f4             	divl   -0xc(%ebp)
  80206a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206d:	29 d0                	sub    %edx,%eax
  80206f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	ff 75 ec             	pushl  -0x14(%ebp)
  802078:	e8 65 0c 00 00       	call   802ce2 <alloc_block_FF>
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  802083:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802087:	74 42                	je     8020cb <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  802089:	83 ec 0c             	sub    $0xc,%esp
  80208c:	ff 75 e8             	pushl  -0x18(%ebp)
  80208f:	e8 9f 0a 00 00       	call   802b33 <insert_sorted_allocList>
  802094:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  802097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80209a:	8b 40 08             	mov    0x8(%eax),%eax
  80209d:	89 c2                	mov    %eax,%edx
  80209f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8020a3:	52                   	push   %edx
  8020a4:	50                   	push   %eax
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	ff 75 08             	pushl  0x8(%ebp)
  8020ab:	e8 38 04 00 00       	call   8024e8 <sys_createSharedObject>
  8020b0:	83 c4 10             	add    $0x10,%esp
  8020b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8020b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020ba:	79 07                	jns    8020c3 <smalloc+0xb4>
	    		  return NULL;
  8020bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c1:	eb 0d                	jmp    8020d0 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8020c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020c6:	8b 40 08             	mov    0x8(%eax),%eax
  8020c9:	eb 05                	jmp    8020d0 <smalloc+0xc1>


				}


		return NULL;
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020d8:	e8 0b fc ff ff       	call   801ce8 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8020dd:	e8 81 06 00 00       	call   802763 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	0f 84 9f 00 00 00    	je     802189 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020ea:	83 ec 08             	sub    $0x8,%esp
  8020ed:	ff 75 0c             	pushl  0xc(%ebp)
  8020f0:	ff 75 08             	pushl  0x8(%ebp)
  8020f3:	e8 1a 04 00 00       	call   802512 <sys_getSizeOfSharedObject>
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8020fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802102:	79 0a                	jns    80210e <sget+0x3c>
		return NULL;
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	e9 80 00 00 00       	jmp    80218e <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80210e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211b:	01 d0                	add    %edx,%eax
  80211d:	48                   	dec    %eax
  80211e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802121:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802124:	ba 00 00 00 00       	mov    $0x0,%edx
  802129:	f7 75 f0             	divl   -0x10(%ebp)
  80212c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212f:	29 d0                	sub    %edx,%eax
  802131:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	ff 75 e8             	pushl  -0x18(%ebp)
  80213a:	e8 a3 0b 00 00       	call   802ce2 <alloc_block_FF>
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  802145:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802149:	74 3e                	je     802189 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802151:	e8 dd 09 00 00       	call   802b33 <insert_sorted_allocList>
  802156:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  802159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215c:	8b 40 08             	mov    0x8(%eax),%eax
  80215f:	83 ec 04             	sub    $0x4,%esp
  802162:	50                   	push   %eax
  802163:	ff 75 0c             	pushl  0xc(%ebp)
  802166:	ff 75 08             	pushl  0x8(%ebp)
  802169:	e8 c1 03 00 00       	call   80252f <sys_getSharedObject>
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  802174:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802178:	79 07                	jns    802181 <sget+0xaf>
	    		  return NULL;
  80217a:	b8 00 00 00 00       	mov    $0x0,%eax
  80217f:	eb 0d                	jmp    80218e <sget+0xbc>
	  	return(void*) returned_block->sva;
  802181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	eb 05                	jmp    80218e <sget+0xbc>
	      }
	}
	   return NULL;
  802189:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802196:	e8 4d fb ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	68 e0 43 80 00       	push   $0x8043e0
  8021a3:	68 12 01 00 00       	push   $0x112
  8021a8:	68 d3 43 80 00       	push   $0x8043d3
  8021ad:	e8 f8 ea ff ff       	call   800caa <_panic>

008021b2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	68 08 44 80 00       	push   $0x804408
  8021c0:	68 26 01 00 00       	push   $0x126
  8021c5:	68 d3 43 80 00       	push   $0x8043d3
  8021ca:	e8 db ea ff ff       	call   800caa <_panic>

008021cf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	68 2c 44 80 00       	push   $0x80442c
  8021dd:	68 31 01 00 00       	push   $0x131
  8021e2:	68 d3 43 80 00       	push   $0x8043d3
  8021e7:	e8 be ea ff ff       	call   800caa <_panic>

008021ec <shrink>:

}
void shrink(uint32 newSize)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	68 2c 44 80 00       	push   $0x80442c
  8021fa:	68 36 01 00 00       	push   $0x136
  8021ff:	68 d3 43 80 00       	push   $0x8043d3
  802204:	e8 a1 ea ff ff       	call   800caa <_panic>

00802209 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80220f:	83 ec 04             	sub    $0x4,%esp
  802212:	68 2c 44 80 00       	push   $0x80442c
  802217:	68 3b 01 00 00       	push   $0x13b
  80221c:	68 d3 43 80 00       	push   $0x8043d3
  802221:	e8 84 ea ff ff       	call   800caa <_panic>

00802226 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	57                   	push   %edi
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	8b 55 0c             	mov    0xc(%ebp),%edx
  802235:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802238:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80223e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802241:	cd 30                	int    $0x30
  802243:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802249:	83 c4 10             	add    $0x10,%esp
  80224c:	5b                   	pop    %ebx
  80224d:	5e                   	pop    %esi
  80224e:	5f                   	pop    %edi
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    

00802251 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	8b 45 10             	mov    0x10(%ebp),%eax
  80225a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80225d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	52                   	push   %edx
  802269:	ff 75 0c             	pushl  0xc(%ebp)
  80226c:	50                   	push   %eax
  80226d:	6a 00                	push   $0x0
  80226f:	e8 b2 ff ff ff       	call   802226 <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	90                   	nop
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_cgetc>:

int
sys_cgetc(void)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 01                	push   $0x1
  802289:	e8 98 ff ff ff       	call   802226 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802296:	8b 55 0c             	mov    0xc(%ebp),%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	52                   	push   %edx
  8022a3:	50                   	push   %eax
  8022a4:	6a 05                	push   $0x5
  8022a6:	e8 7b ff ff ff       	call   802226 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	56                   	push   %esi
  8022b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8022b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	56                   	push   %esi
  8022c5:	53                   	push   %ebx
  8022c6:	51                   	push   %ecx
  8022c7:	52                   	push   %edx
  8022c8:	50                   	push   %eax
  8022c9:	6a 06                	push   $0x6
  8022cb:	e8 56 ff ff ff       	call   802226 <syscall>
  8022d0:	83 c4 18             	add    $0x18,%esp
}
  8022d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d6:	5b                   	pop    %ebx
  8022d7:	5e                   	pop    %esi
  8022d8:	5d                   	pop    %ebp
  8022d9:	c3                   	ret    

008022da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	52                   	push   %edx
  8022ea:	50                   	push   %eax
  8022eb:	6a 07                	push   $0x7
  8022ed:	e8 34 ff ff ff       	call   802226 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	6a 08                	push   $0x8
  802308:	e8 19 ff ff ff       	call   802226 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 09                	push   $0x9
  802321:	e8 00 ff ff ff       	call   802226 <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 0a                	push   $0xa
  80233a:	e8 e7 fe ff ff       	call   802226 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 0b                	push   $0xb
  802353:	e8 ce fe ff ff       	call   802226 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	ff 75 0c             	pushl  0xc(%ebp)
  802369:	ff 75 08             	pushl  0x8(%ebp)
  80236c:	6a 0f                	push   $0xf
  80236e:	e8 b3 fe ff ff       	call   802226 <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
	return;
  802376:	90                   	nop
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	ff 75 0c             	pushl  0xc(%ebp)
  802385:	ff 75 08             	pushl  0x8(%ebp)
  802388:	6a 10                	push   $0x10
  80238a:	e8 97 fe ff ff       	call   802226 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
	return ;
  802392:	90                   	nop
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	ff 75 10             	pushl  0x10(%ebp)
  80239f:	ff 75 0c             	pushl  0xc(%ebp)
  8023a2:	ff 75 08             	pushl  0x8(%ebp)
  8023a5:	6a 11                	push   $0x11
  8023a7:	e8 7a fe ff ff       	call   802226 <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8023af:	90                   	nop
}
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 0c                	push   $0xc
  8023c1:	e8 60 fe ff ff       	call   802226 <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	ff 75 08             	pushl  0x8(%ebp)
  8023d9:	6a 0d                	push   $0xd
  8023db:	e8 46 fe ff ff       	call   802226 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 0e                	push   $0xe
  8023f4:	e8 2d fe ff ff       	call   802226 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	90                   	nop
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 13                	push   $0x13
  80240e:	e8 13 fe ff ff       	call   802226 <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
}
  802416:	90                   	nop
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 14                	push   $0x14
  802428:	e8 f9 fd ff ff       	call   802226 <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
}
  802430:	90                   	nop
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <sys_cputc>:


void
sys_cputc(const char c)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	83 ec 04             	sub    $0x4,%esp
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80243f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	50                   	push   %eax
  80244c:	6a 15                	push   $0x15
  80244e:	e8 d3 fd ff ff       	call   802226 <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
}
  802456:	90                   	nop
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 16                	push   $0x16
  802468:	e8 b9 fd ff ff       	call   802226 <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
}
  802470:	90                   	nop
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	ff 75 0c             	pushl  0xc(%ebp)
  802482:	50                   	push   %eax
  802483:	6a 17                	push   $0x17
  802485:	e8 9c fd ff ff       	call   802226 <syscall>
  80248a:	83 c4 18             	add    $0x18,%esp
}
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802492:	8b 55 0c             	mov    0xc(%ebp),%edx
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	52                   	push   %edx
  80249f:	50                   	push   %eax
  8024a0:	6a 1a                	push   $0x1a
  8024a2:	e8 7f fd ff ff       	call   802226 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	52                   	push   %edx
  8024bc:	50                   	push   %eax
  8024bd:	6a 18                	push   $0x18
  8024bf:	e8 62 fd ff ff       	call   802226 <syscall>
  8024c4:	83 c4 18             	add    $0x18,%esp
}
  8024c7:	90                   	nop
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	52                   	push   %edx
  8024da:	50                   	push   %eax
  8024db:	6a 19                	push   $0x19
  8024dd:	e8 44 fd ff ff       	call   802226 <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
}
  8024e5:	90                   	nop
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	6a 00                	push   $0x0
  802500:	51                   	push   %ecx
  802501:	52                   	push   %edx
  802502:	ff 75 0c             	pushl  0xc(%ebp)
  802505:	50                   	push   %eax
  802506:	6a 1b                	push   $0x1b
  802508:	e8 19 fd ff ff       	call   802226 <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802515:	8b 55 0c             	mov    0xc(%ebp),%edx
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	52                   	push   %edx
  802522:	50                   	push   %eax
  802523:	6a 1c                	push   $0x1c
  802525:	e8 fc fc ff ff       	call   802226 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802532:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802535:	8b 55 0c             	mov    0xc(%ebp),%edx
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	51                   	push   %ecx
  802540:	52                   	push   %edx
  802541:	50                   	push   %eax
  802542:	6a 1d                	push   $0x1d
  802544:	e8 dd fc ff ff       	call   802226 <syscall>
  802549:	83 c4 18             	add    $0x18,%esp
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802551:	8b 55 0c             	mov    0xc(%ebp),%edx
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	52                   	push   %edx
  80255e:	50                   	push   %eax
  80255f:	6a 1e                	push   $0x1e
  802561:	e8 c0 fc ff ff       	call   802226 <syscall>
  802566:	83 c4 18             	add    $0x18,%esp
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 1f                	push   $0x1f
  80257a:	e8 a7 fc ff ff       	call   802226 <syscall>
  80257f:	83 c4 18             	add    $0x18,%esp
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	6a 00                	push   $0x0
  80258c:	ff 75 14             	pushl  0x14(%ebp)
  80258f:	ff 75 10             	pushl  0x10(%ebp)
  802592:	ff 75 0c             	pushl  0xc(%ebp)
  802595:	50                   	push   %eax
  802596:	6a 20                	push   $0x20
  802598:	e8 89 fc ff ff       	call   802226 <syscall>
  80259d:	83 c4 18             	add    $0x18,%esp
}
  8025a0:	c9                   	leave  
  8025a1:	c3                   	ret    

008025a2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	50                   	push   %eax
  8025b1:	6a 21                	push   $0x21
  8025b3:	e8 6e fc ff ff       	call   802226 <syscall>
  8025b8:	83 c4 18             	add    $0x18,%esp
}
  8025bb:	90                   	nop
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    

008025be <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	50                   	push   %eax
  8025cd:	6a 22                	push   $0x22
  8025cf:	e8 52 fc ff ff       	call   802226 <syscall>
  8025d4:	83 c4 18             	add    $0x18,%esp
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 02                	push   $0x2
  8025e8:	e8 39 fc ff ff       	call   802226 <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 03                	push   $0x3
  802601:	e8 20 fc ff ff       	call   802226 <syscall>
  802606:	83 c4 18             	add    $0x18,%esp
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 04                	push   $0x4
  80261a:	e8 07 fc ff ff       	call   802226 <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <sys_exit_env>:


void sys_exit_env(void)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 23                	push   $0x23
  802633:	e8 ee fb ff ff       	call   802226 <syscall>
  802638:	83 c4 18             	add    $0x18,%esp
}
  80263b:	90                   	nop
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
  802641:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802644:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802647:	8d 50 04             	lea    0x4(%eax),%edx
  80264a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	52                   	push   %edx
  802654:	50                   	push   %eax
  802655:	6a 24                	push   $0x24
  802657:	e8 ca fb ff ff       	call   802226 <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
	return result;
  80265f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802662:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802665:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802668:	89 01                	mov    %eax,(%ecx)
  80266a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	c9                   	leave  
  802671:	c2 04 00             	ret    $0x4

00802674 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	ff 75 10             	pushl  0x10(%ebp)
  80267e:	ff 75 0c             	pushl  0xc(%ebp)
  802681:	ff 75 08             	pushl  0x8(%ebp)
  802684:	6a 12                	push   $0x12
  802686:	e8 9b fb ff ff       	call   802226 <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
	return ;
  80268e:	90                   	nop
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_rcr2>:
uint32 sys_rcr2()
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 25                	push   $0x25
  8026a0:	e8 81 fb ff ff       	call   802226 <syscall>
  8026a5:	83 c4 18             	add    $0x18,%esp
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	83 ec 04             	sub    $0x4,%esp
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	50                   	push   %eax
  8026c3:	6a 26                	push   $0x26
  8026c5:	e8 5c fb ff ff       	call   802226 <syscall>
  8026ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cd:	90                   	nop
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <rsttst>:
void rsttst()
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 28                	push   $0x28
  8026df:	e8 42 fb ff ff       	call   802226 <syscall>
  8026e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e7:	90                   	nop
}
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8026f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8026f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026fd:	52                   	push   %edx
  8026fe:	50                   	push   %eax
  8026ff:	ff 75 10             	pushl  0x10(%ebp)
  802702:	ff 75 0c             	pushl  0xc(%ebp)
  802705:	ff 75 08             	pushl  0x8(%ebp)
  802708:	6a 27                	push   $0x27
  80270a:	e8 17 fb ff ff       	call   802226 <syscall>
  80270f:	83 c4 18             	add    $0x18,%esp
	return ;
  802712:	90                   	nop
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <chktst>:
void chktst(uint32 n)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	ff 75 08             	pushl  0x8(%ebp)
  802723:	6a 29                	push   $0x29
  802725:	e8 fc fa ff ff       	call   802226 <syscall>
  80272a:	83 c4 18             	add    $0x18,%esp
	return ;
  80272d:	90                   	nop
}
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <inctst>:

void inctst()
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 2a                	push   $0x2a
  80273f:	e8 e2 fa ff ff       	call   802226 <syscall>
  802744:	83 c4 18             	add    $0x18,%esp
	return ;
  802747:	90                   	nop
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <gettst>:
uint32 gettst()
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 2b                	push   $0x2b
  802759:	e8 c8 fa ff ff       	call   802226 <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 2c                	push   $0x2c
  802775:	e8 ac fa ff ff       	call   802226 <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
  80277d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802780:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802784:	75 07                	jne    80278d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802786:	b8 01 00 00 00       	mov    $0x1,%eax
  80278b:	eb 05                	jmp    802792 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802792:	c9                   	leave  
  802793:	c3                   	ret    

00802794 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 2c                	push   $0x2c
  8027a6:	e8 7b fa ff ff       	call   802226 <syscall>
  8027ab:	83 c4 18             	add    $0x18,%esp
  8027ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027b1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027b5:	75 07                	jne    8027be <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027bc:	eb 05                	jmp    8027c3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 2c                	push   $0x2c
  8027d7:	e8 4a fa ff ff       	call   802226 <syscall>
  8027dc:	83 c4 18             	add    $0x18,%esp
  8027df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027e2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027e6:	75 07                	jne    8027ef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ed:	eb 05                	jmp    8027f4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 2c                	push   $0x2c
  802808:	e8 19 fa ff ff       	call   802226 <syscall>
  80280d:	83 c4 18             	add    $0x18,%esp
  802810:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802813:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802817:	75 07                	jne    802820 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802819:	b8 01 00 00 00       	mov    $0x1,%eax
  80281e:	eb 05                	jmp    802825 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802820:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802825:	c9                   	leave  
  802826:	c3                   	ret    

00802827 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	ff 75 08             	pushl  0x8(%ebp)
  802835:	6a 2d                	push   $0x2d
  802837:	e8 ea f9 ff ff       	call   802226 <syscall>
  80283c:	83 c4 18             	add    $0x18,%esp
	return ;
  80283f:	90                   	nop
}
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802846:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802849:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80284c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284f:	8b 45 08             	mov    0x8(%ebp),%eax
  802852:	6a 00                	push   $0x0
  802854:	53                   	push   %ebx
  802855:	51                   	push   %ecx
  802856:	52                   	push   %edx
  802857:	50                   	push   %eax
  802858:	6a 2e                	push   $0x2e
  80285a:	e8 c7 f9 ff ff       	call   802226 <syscall>
  80285f:	83 c4 18             	add    $0x18,%esp
}
  802862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802865:	c9                   	leave  
  802866:	c3                   	ret    

00802867 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80286a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	52                   	push   %edx
  802877:	50                   	push   %eax
  802878:	6a 2f                	push   $0x2f
  80287a:	e8 a7 f9 ff ff       	call   802226 <syscall>
  80287f:	83 c4 18             	add    $0x18,%esp
}
  802882:	c9                   	leave  
  802883:	c3                   	ret    

00802884 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
  802887:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80288a:	83 ec 0c             	sub    $0xc,%esp
  80288d:	68 3c 44 80 00       	push   $0x80443c
  802892:	e8 c7 e6 ff ff       	call   800f5e <cprintf>
  802897:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80289a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8028a1:	83 ec 0c             	sub    $0xc,%esp
  8028a4:	68 68 44 80 00       	push   $0x804468
  8028a9:	e8 b0 e6 ff ff       	call   800f5e <cprintf>
  8028ae:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8028b1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bd:	eb 56                	jmp    802915 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c3:	74 1c                	je     8028e1 <print_mem_block_lists+0x5d>
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 50 08             	mov    0x8(%eax),%edx
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	8b 48 08             	mov    0x8(%eax),%ecx
  8028d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d7:	01 c8                	add    %ecx,%eax
  8028d9:	39 c2                	cmp    %eax,%edx
  8028db:	73 04                	jae    8028e1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028dd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 50 08             	mov    0x8(%eax),%edx
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ed:	01 c2                	add    %eax,%edx
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 08             	mov    0x8(%eax),%eax
  8028f5:	83 ec 04             	sub    $0x4,%esp
  8028f8:	52                   	push   %edx
  8028f9:	50                   	push   %eax
  8028fa:	68 7d 44 80 00       	push   $0x80447d
  8028ff:	e8 5a e6 ff ff       	call   800f5e <cprintf>
  802904:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80290d:	a1 40 51 80 00       	mov    0x805140,%eax
  802912:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802919:	74 07                	je     802922 <print_mem_block_lists+0x9e>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	eb 05                	jmp    802927 <print_mem_block_lists+0xa3>
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
  802927:	a3 40 51 80 00       	mov    %eax,0x805140
  80292c:	a1 40 51 80 00       	mov    0x805140,%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	75 8a                	jne    8028bf <print_mem_block_lists+0x3b>
  802935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802939:	75 84                	jne    8028bf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80293b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80293f:	75 10                	jne    802951 <print_mem_block_lists+0xcd>
  802941:	83 ec 0c             	sub    $0xc,%esp
  802944:	68 8c 44 80 00       	push   $0x80448c
  802949:	e8 10 e6 ff ff       	call   800f5e <cprintf>
  80294e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802951:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802958:	83 ec 0c             	sub    $0xc,%esp
  80295b:	68 b0 44 80 00       	push   $0x8044b0
  802960:	e8 f9 e5 ff ff       	call   800f5e <cprintf>
  802965:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802968:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80296c:	a1 40 50 80 00       	mov    0x805040,%eax
  802971:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802974:	eb 56                	jmp    8029cc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802976:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80297a:	74 1c                	je     802998 <print_mem_block_lists+0x114>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 50 08             	mov    0x8(%eax),%edx
  802982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802985:	8b 48 08             	mov    0x8(%eax),%ecx
  802988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298b:	8b 40 0c             	mov    0xc(%eax),%eax
  80298e:	01 c8                	add    %ecx,%eax
  802990:	39 c2                	cmp    %eax,%edx
  802992:	73 04                	jae    802998 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802994:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 50 08             	mov    0x8(%eax),%edx
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a4:	01 c2                	add    %eax,%edx
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 40 08             	mov    0x8(%eax),%eax
  8029ac:	83 ec 04             	sub    $0x4,%esp
  8029af:	52                   	push   %edx
  8029b0:	50                   	push   %eax
  8029b1:	68 7d 44 80 00       	push   $0x80447d
  8029b6:	e8 a3 e5 ff ff       	call   800f5e <cprintf>
  8029bb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029c4:	a1 48 50 80 00       	mov    0x805048,%eax
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d0:	74 07                	je     8029d9 <print_mem_block_lists+0x155>
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	eb 05                	jmp    8029de <print_mem_block_lists+0x15a>
  8029d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029de:	a3 48 50 80 00       	mov    %eax,0x805048
  8029e3:	a1 48 50 80 00       	mov    0x805048,%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	75 8a                	jne    802976 <print_mem_block_lists+0xf2>
  8029ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f0:	75 84                	jne    802976 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029f2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029f6:	75 10                	jne    802a08 <print_mem_block_lists+0x184>
  8029f8:	83 ec 0c             	sub    $0xc,%esp
  8029fb:	68 c8 44 80 00       	push   $0x8044c8
  802a00:	e8 59 e5 ff ff       	call   800f5e <cprintf>
  802a05:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a08:	83 ec 0c             	sub    $0xc,%esp
  802a0b:	68 3c 44 80 00       	push   $0x80443c
  802a10:	e8 49 e5 ff ff       	call   800f5e <cprintf>
  802a15:	83 c4 10             	add    $0x10,%esp

}
  802a18:	90                   	nop
  802a19:	c9                   	leave  
  802a1a:	c3                   	ret    

00802a1b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
  802a1e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802a21:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a28:	00 00 00 
  802a2b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a32:	00 00 00 
  802a35:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a3c:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802a3f:	a1 50 50 80 00       	mov    0x805050,%eax
  802a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802a47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a4e:	e9 9e 00 00 00       	jmp    802af1 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802a53:	a1 50 50 80 00       	mov    0x805050,%eax
  802a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5b:	c1 e2 04             	shl    $0x4,%edx
  802a5e:	01 d0                	add    %edx,%eax
  802a60:	85 c0                	test   %eax,%eax
  802a62:	75 14                	jne    802a78 <initialize_MemBlocksList+0x5d>
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	68 f0 44 80 00       	push   $0x8044f0
  802a6c:	6a 48                	push   $0x48
  802a6e:	68 13 45 80 00       	push   $0x804513
  802a73:	e8 32 e2 ff ff       	call   800caa <_panic>
  802a78:	a1 50 50 80 00       	mov    0x805050,%eax
  802a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a80:	c1 e2 04             	shl    $0x4,%edx
  802a83:	01 d0                	add    %edx,%eax
  802a85:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	8b 00                	mov    (%eax),%eax
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	74 18                	je     802aab <initialize_MemBlocksList+0x90>
  802a93:	a1 48 51 80 00       	mov    0x805148,%eax
  802a98:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a9e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802aa1:	c1 e1 04             	shl    $0x4,%ecx
  802aa4:	01 ca                	add    %ecx,%edx
  802aa6:	89 50 04             	mov    %edx,0x4(%eax)
  802aa9:	eb 12                	jmp    802abd <initialize_MemBlocksList+0xa2>
  802aab:	a1 50 50 80 00       	mov    0x805050,%eax
  802ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab3:	c1 e2 04             	shl    $0x4,%edx
  802ab6:	01 d0                	add    %edx,%eax
  802ab8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802abd:	a1 50 50 80 00       	mov    0x805050,%eax
  802ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac5:	c1 e2 04             	shl    $0x4,%edx
  802ac8:	01 d0                	add    %edx,%eax
  802aca:	a3 48 51 80 00       	mov    %eax,0x805148
  802acf:	a1 50 50 80 00       	mov    0x805050,%eax
  802ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad7:	c1 e2 04             	shl    $0x4,%edx
  802ada:	01 d0                	add    %edx,%eax
  802adc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ae8:	40                   	inc    %eax
  802ae9:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802aee:	ff 45 f4             	incl   -0xc(%ebp)
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af7:	0f 82 56 ff ff ff    	jb     802a53 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802afd:	90                   	nop
  802afe:	c9                   	leave  
  802aff:	c3                   	ret    

00802b00 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b00:	55                   	push   %ebp
  802b01:	89 e5                	mov    %esp,%ebp
  802b03:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802b0e:	eb 18                	jmp    802b28 <find_block+0x28>
		{
			if(tmp->sva==va)
  802b10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b13:	8b 40 08             	mov    0x8(%eax),%eax
  802b16:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b19:	75 05                	jne    802b20 <find_block+0x20>
			{
				return tmp;
  802b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b1e:	eb 11                	jmp    802b31 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802b28:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b2c:	75 e2                	jne    802b10 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802b2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
  802b36:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802b39:	a1 40 50 80 00       	mov    0x805040,%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	0f 85 83 00 00 00    	jne    802bc9 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802b46:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802b4d:	00 00 00 
  802b50:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802b57:	00 00 00 
  802b5a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802b61:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b68:	75 14                	jne    802b7e <insert_sorted_allocList+0x4b>
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	68 f0 44 80 00       	push   $0x8044f0
  802b72:	6a 7f                	push   $0x7f
  802b74:	68 13 45 80 00       	push   $0x804513
  802b79:	e8 2c e1 ff ff       	call   800caa <_panic>
  802b7e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	89 10                	mov    %edx,(%eax)
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	74 0d                	je     802b9f <insert_sorted_allocList+0x6c>
  802b92:	a1 40 50 80 00       	mov    0x805040,%eax
  802b97:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9a:	89 50 04             	mov    %edx,0x4(%eax)
  802b9d:	eb 08                	jmp    802ba7 <insert_sorted_allocList+0x74>
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	a3 44 50 80 00       	mov    %eax,0x805044
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	a3 40 50 80 00       	mov    %eax,0x805040
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bbe:	40                   	inc    %eax
  802bbf:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802bc4:	e9 16 01 00 00       	jmp    802cdf <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	8b 50 08             	mov    0x8(%eax),%edx
  802bcf:	a1 44 50 80 00       	mov    0x805044,%eax
  802bd4:	8b 40 08             	mov    0x8(%eax),%eax
  802bd7:	39 c2                	cmp    %eax,%edx
  802bd9:	76 68                	jbe    802c43 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802bdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdf:	75 17                	jne    802bf8 <insert_sorted_allocList+0xc5>
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	68 2c 45 80 00       	push   $0x80452c
  802be9:	68 85 00 00 00       	push   $0x85
  802bee:	68 13 45 80 00       	push   $0x804513
  802bf3:	e8 b2 e0 ff ff       	call   800caa <_panic>
  802bf8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	89 50 04             	mov    %edx,0x4(%eax)
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	74 0c                	je     802c1a <insert_sorted_allocList+0xe7>
  802c0e:	a1 44 50 80 00       	mov    0x805044,%eax
  802c13:	8b 55 08             	mov    0x8(%ebp),%edx
  802c16:	89 10                	mov    %edx,(%eax)
  802c18:	eb 08                	jmp    802c22 <insert_sorted_allocList+0xef>
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	a3 40 50 80 00       	mov    %eax,0x805040
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	a3 44 50 80 00       	mov    %eax,0x805044
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c33:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c38:	40                   	inc    %eax
  802c39:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802c3e:	e9 9c 00 00 00       	jmp    802cdf <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802c43:	a1 40 50 80 00       	mov    0x805040,%eax
  802c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802c4b:	e9 85 00 00 00       	jmp    802cd5 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	8b 50 08             	mov    0x8(%eax),%edx
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 40 08             	mov    0x8(%eax),%eax
  802c5c:	39 c2                	cmp    %eax,%edx
  802c5e:	73 6d                	jae    802ccd <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802c60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c64:	74 06                	je     802c6c <insert_sorted_allocList+0x139>
  802c66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c6a:	75 17                	jne    802c83 <insert_sorted_allocList+0x150>
  802c6c:	83 ec 04             	sub    $0x4,%esp
  802c6f:	68 50 45 80 00       	push   $0x804550
  802c74:	68 90 00 00 00       	push   $0x90
  802c79:	68 13 45 80 00       	push   $0x804513
  802c7e:	e8 27 e0 ff ff       	call   800caa <_panic>
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 50 04             	mov    0x4(%eax),%edx
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	89 50 04             	mov    %edx,0x4(%eax)
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c95:	89 10                	mov    %edx,(%eax)
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 0d                	je     802cae <insert_sorted_allocList+0x17b>
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 04             	mov    0x4(%eax),%eax
  802ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  802caa:	89 10                	mov    %edx,(%eax)
  802cac:	eb 08                	jmp    802cb6 <insert_sorted_allocList+0x183>
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	a3 40 50 80 00       	mov    %eax,0x805040
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbc:	89 50 04             	mov    %edx,0x4(%eax)
  802cbf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cc4:	40                   	inc    %eax
  802cc5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802cca:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802ccb:	eb 12                	jmp    802cdf <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 00                	mov    (%eax),%eax
  802cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd9:	0f 85 71 ff ff ff    	jne    802c50 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802cdf:	90                   	nop
  802ce0:	c9                   	leave  
  802ce1:	c3                   	ret    

00802ce2 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802ce2:	55                   	push   %ebp
  802ce3:	89 e5                	mov    %esp,%ebp
  802ce5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802ce8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ced:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802cf0:	e9 76 01 00 00       	jmp    802e6b <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfe:	0f 85 8a 00 00 00    	jne    802d8e <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802d04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d08:	75 17                	jne    802d21 <alloc_block_FF+0x3f>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 85 45 80 00       	push   $0x804585
  802d12:	68 a8 00 00 00       	push   $0xa8
  802d17:	68 13 45 80 00       	push   $0x804513
  802d1c:	e8 89 df ff ff       	call   800caa <_panic>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 10                	je     802d3a <alloc_block_FF+0x58>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d32:	8b 52 04             	mov    0x4(%edx),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 0b                	jmp    802d45 <alloc_block_FF+0x63>
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 40 04             	mov    0x4(%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 0f                	je     802d5e <alloc_block_FF+0x7c>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d58:	8b 12                	mov    (%edx),%edx
  802d5a:	89 10                	mov    %edx,(%eax)
  802d5c:	eb 0a                	jmp    802d68 <alloc_block_FF+0x86>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	a3 38 51 80 00       	mov    %eax,0x805138
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d80:	48                   	dec    %eax
  802d81:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	e9 ea 00 00 00       	jmp    802e78 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 40 0c             	mov    0xc(%eax),%eax
  802d94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d97:	0f 86 c6 00 00 00    	jbe    802e63 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802d9d:	a1 48 51 80 00       	mov    0x805148,%eax
  802da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dab:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 50 08             	mov    0x8(%eax),%edx
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc0:	2b 45 08             	sub    0x8(%ebp),%eax
  802dc3:	89 c2                	mov    %eax,%edx
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 50 08             	mov    0x8(%eax),%edx
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	01 c2                	add    %eax,%edx
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802ddc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de0:	75 17                	jne    802df9 <alloc_block_FF+0x117>
  802de2:	83 ec 04             	sub    $0x4,%esp
  802de5:	68 85 45 80 00       	push   $0x804585
  802dea:	68 b6 00 00 00       	push   $0xb6
  802def:	68 13 45 80 00       	push   $0x804513
  802df4:	e8 b1 de ff ff       	call   800caa <_panic>
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 10                	je     802e12 <alloc_block_FF+0x130>
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0a:	8b 52 04             	mov    0x4(%edx),%edx
  802e0d:	89 50 04             	mov    %edx,0x4(%eax)
  802e10:	eb 0b                	jmp    802e1d <alloc_block_FF+0x13b>
  802e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0f                	je     802e36 <alloc_block_FF+0x154>
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e30:	8b 12                	mov    (%edx),%edx
  802e32:	89 10                	mov    %edx,(%eax)
  802e34:	eb 0a                	jmp    802e40 <alloc_block_FF+0x15e>
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e53:	a1 54 51 80 00       	mov    0x805154,%eax
  802e58:	48                   	dec    %eax
  802e59:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	eb 15                	jmp    802e78 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6f:	0f 85 80 fe ff ff    	jne    802cf5 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802e78:	c9                   	leave  
  802e79:	c3                   	ret    

00802e7a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
  802e7d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802e80:	a1 38 51 80 00       	mov    0x805138,%eax
  802e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802e88:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802e8f:	e9 c0 00 00 00       	jmp    802f54 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9d:	0f 85 8a 00 00 00    	jne    802f2d <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea7:	75 17                	jne    802ec0 <alloc_block_BF+0x46>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 85 45 80 00       	push   $0x804585
  802eb1:	68 cf 00 00 00       	push   $0xcf
  802eb6:	68 13 45 80 00       	push   $0x804513
  802ebb:	e8 ea dd ff ff       	call   800caa <_panic>
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	85 c0                	test   %eax,%eax
  802ec7:	74 10                	je     802ed9 <alloc_block_BF+0x5f>
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed1:	8b 52 04             	mov    0x4(%edx),%edx
  802ed4:	89 50 04             	mov    %edx,0x4(%eax)
  802ed7:	eb 0b                	jmp    802ee4 <alloc_block_BF+0x6a>
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	85 c0                	test   %eax,%eax
  802eec:	74 0f                	je     802efd <alloc_block_BF+0x83>
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef7:	8b 12                	mov    (%edx),%edx
  802ef9:	89 10                	mov    %edx,(%eax)
  802efb:	eb 0a                	jmp    802f07 <alloc_block_BF+0x8d>
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	a3 38 51 80 00       	mov    %eax,0x805138
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1f:	48                   	dec    %eax
  802f20:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	e9 2a 01 00 00       	jmp    803057 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 40 0c             	mov    0xc(%eax),%eax
  802f33:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f36:	73 14                	jae    802f4c <alloc_block_BF+0xd2>
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f41:	76 09                	jbe    802f4c <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 0c             	mov    0xc(%eax),%eax
  802f49:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802f54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f58:	0f 85 36 ff ff ff    	jne    802e94 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802f5e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802f66:	e9 dd 00 00 00       	jmp    803048 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f71:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f74:	0f 85 c6 00 00 00    	jne    803040 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802f7a:	a1 48 51 80 00       	mov    0x805148,%eax
  802f7f:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 50 08             	mov    0x8(%eax),%edx
  802f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8b:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f91:	8b 55 08             	mov    0x8(%ebp),%edx
  802f94:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 50 08             	mov    0x8(%eax),%edx
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	01 c2                	add    %eax,%edx
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 40 0c             	mov    0xc(%eax),%eax
  802fae:	2b 45 08             	sub    0x8(%ebp),%eax
  802fb1:	89 c2                	mov    %eax,%edx
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802fb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fbd:	75 17                	jne    802fd6 <alloc_block_BF+0x15c>
  802fbf:	83 ec 04             	sub    $0x4,%esp
  802fc2:	68 85 45 80 00       	push   $0x804585
  802fc7:	68 eb 00 00 00       	push   $0xeb
  802fcc:	68 13 45 80 00       	push   $0x804513
  802fd1:	e8 d4 dc ff ff       	call   800caa <_panic>
  802fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	74 10                	je     802fef <alloc_block_BF+0x175>
  802fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fe7:	8b 52 04             	mov    0x4(%edx),%edx
  802fea:	89 50 04             	mov    %edx,0x4(%eax)
  802fed:	eb 0b                	jmp    802ffa <alloc_block_BF+0x180>
  802fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	74 0f                	je     803013 <alloc_block_BF+0x199>
  803004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80300d:	8b 12                	mov    (%edx),%edx
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	eb 0a                	jmp    80301d <alloc_block_BF+0x1a3>
  803013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	a3 48 51 80 00       	mov    %eax,0x805148
  80301d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 54 51 80 00       	mov    0x805154,%eax
  803035:	48                   	dec    %eax
  803036:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  80303b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303e:	eb 17                	jmp    803057 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  803048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304c:	0f 85 19 ff ff ff    	jne    802f6b <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  803052:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803057:	c9                   	leave  
  803058:	c3                   	ret    

00803059 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  803059:	55                   	push   %ebp
  80305a:	89 e5                	mov    %esp,%ebp
  80305c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80305f:	a1 40 50 80 00       	mov    0x805040,%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	75 19                	jne    803081 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  803068:	83 ec 0c             	sub    $0xc,%esp
  80306b:	ff 75 08             	pushl  0x8(%ebp)
  80306e:	e8 6f fc ff ff       	call   802ce2 <alloc_block_FF>
  803073:	83 c4 10             	add    $0x10,%esp
  803076:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  803079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307c:	e9 e9 01 00 00       	jmp    80326a <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  803081:	a1 44 50 80 00       	mov    0x805044,%eax
  803086:	8b 40 08             	mov    0x8(%eax),%eax
  803089:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80308c:	a1 44 50 80 00       	mov    0x805044,%eax
  803091:	8b 50 0c             	mov    0xc(%eax),%edx
  803094:	a1 44 50 80 00       	mov    0x805044,%eax
  803099:	8b 40 08             	mov    0x8(%eax),%eax
  80309c:	01 d0                	add    %edx,%eax
  80309e:	83 ec 08             	sub    $0x8,%esp
  8030a1:	50                   	push   %eax
  8030a2:	68 38 51 80 00       	push   $0x805138
  8030a7:	e8 54 fa ff ff       	call   802b00 <find_block>
  8030ac:	83 c4 10             	add    $0x10,%esp
  8030af:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030bb:	0f 85 9b 00 00 00    	jne    80315c <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 40 08             	mov    0x8(%eax),%eax
  8030cd:	01 d0                	add    %edx,%eax
  8030cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8030d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d6:	75 17                	jne    8030ef <alloc_block_NF+0x96>
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	68 85 45 80 00       	push   $0x804585
  8030e0:	68 1a 01 00 00       	push   $0x11a
  8030e5:	68 13 45 80 00       	push   $0x804513
  8030ea:	e8 bb db ff ff       	call   800caa <_panic>
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	85 c0                	test   %eax,%eax
  8030f6:	74 10                	je     803108 <alloc_block_NF+0xaf>
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803100:	8b 52 04             	mov    0x4(%edx),%edx
  803103:	89 50 04             	mov    %edx,0x4(%eax)
  803106:	eb 0b                	jmp    803113 <alloc_block_NF+0xba>
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 40 04             	mov    0x4(%eax),%eax
  80310e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 0f                	je     80312c <alloc_block_NF+0xd3>
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 40 04             	mov    0x4(%eax),%eax
  803123:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803126:	8b 12                	mov    (%edx),%edx
  803128:	89 10                	mov    %edx,(%eax)
  80312a:	eb 0a                	jmp    803136 <alloc_block_NF+0xdd>
  80312c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	a3 38 51 80 00       	mov    %eax,0x805138
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803142:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803149:	a1 44 51 80 00       	mov    0x805144,%eax
  80314e:	48                   	dec    %eax
  80314f:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	e9 0e 01 00 00       	jmp    80326a <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	8b 40 0c             	mov    0xc(%eax),%eax
  803162:	3b 45 08             	cmp    0x8(%ebp),%eax
  803165:	0f 86 cf 00 00 00    	jbe    80323a <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80316b:	a1 48 51 80 00       	mov    0x805148,%eax
  803170:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  803173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803176:	8b 55 08             	mov    0x8(%ebp),%edx
  803179:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	8b 50 08             	mov    0x8(%eax),%edx
  803182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803185:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	8b 50 08             	mov    0x8(%eax),%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	01 c2                	add    %eax,%edx
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	8b 40 0c             	mov    0xc(%eax),%eax
  80319f:	2b 45 08             	sub    0x8(%ebp),%eax
  8031a2:	89 c2                	mov    %eax,%edx
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	8b 40 08             	mov    0x8(%eax),%eax
  8031b0:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8031b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031b7:	75 17                	jne    8031d0 <alloc_block_NF+0x177>
  8031b9:	83 ec 04             	sub    $0x4,%esp
  8031bc:	68 85 45 80 00       	push   $0x804585
  8031c1:	68 28 01 00 00       	push   $0x128
  8031c6:	68 13 45 80 00       	push   $0x804513
  8031cb:	e8 da da ff ff       	call   800caa <_panic>
  8031d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d3:	8b 00                	mov    (%eax),%eax
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	74 10                	je     8031e9 <alloc_block_NF+0x190>
  8031d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031dc:	8b 00                	mov    (%eax),%eax
  8031de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031e1:	8b 52 04             	mov    0x4(%edx),%edx
  8031e4:	89 50 04             	mov    %edx,0x4(%eax)
  8031e7:	eb 0b                	jmp    8031f4 <alloc_block_NF+0x19b>
  8031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ec:	8b 40 04             	mov    0x4(%eax),%eax
  8031ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f7:	8b 40 04             	mov    0x4(%eax),%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	74 0f                	je     80320d <alloc_block_NF+0x1b4>
  8031fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803201:	8b 40 04             	mov    0x4(%eax),%eax
  803204:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803207:	8b 12                	mov    (%edx),%edx
  803209:	89 10                	mov    %edx,(%eax)
  80320b:	eb 0a                	jmp    803217 <alloc_block_NF+0x1be>
  80320d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803210:	8b 00                	mov    (%eax),%eax
  803212:	a3 48 51 80 00       	mov    %eax,0x805148
  803217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803220:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803223:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322a:	a1 54 51 80 00       	mov    0x805154,%eax
  80322f:	48                   	dec    %eax
  803230:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  803235:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803238:	eb 30                	jmp    80326a <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80323a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80323f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803242:	75 0a                	jne    80324e <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  803244:	a1 38 51 80 00       	mov    0x805138,%eax
  803249:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80324c:	eb 08                	jmp    803256 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80324e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 40 08             	mov    0x8(%eax),%eax
  80325c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80325f:	0f 85 4d fe ff ff    	jne    8030b2 <alloc_block_NF+0x59>

			return NULL;
  803265:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80326a:	c9                   	leave  
  80326b:	c3                   	ret    

0080326c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
  80326f:	53                   	push   %ebx
  803270:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  803273:	a1 38 51 80 00       	mov    0x805138,%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	0f 85 86 00 00 00    	jne    803306 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  803280:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803287:	00 00 00 
  80328a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  803291:	00 00 00 
  803294:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80329b:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80329e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a2:	75 17                	jne    8032bb <insert_sorted_with_merge_freeList+0x4f>
  8032a4:	83 ec 04             	sub    $0x4,%esp
  8032a7:	68 f0 44 80 00       	push   $0x8044f0
  8032ac:	68 48 01 00 00       	push   $0x148
  8032b1:	68 13 45 80 00       	push   $0x804513
  8032b6:	e8 ef d9 ff ff       	call   800caa <_panic>
  8032bb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	89 10                	mov    %edx,(%eax)
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	8b 00                	mov    (%eax),%eax
  8032cb:	85 c0                	test   %eax,%eax
  8032cd:	74 0d                	je     8032dc <insert_sorted_with_merge_freeList+0x70>
  8032cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8032d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d7:	89 50 04             	mov    %edx,0x4(%eax)
  8032da:	eb 08                	jmp    8032e4 <insert_sorted_with_merge_freeList+0x78>
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032fb:	40                   	inc    %eax
  8032fc:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803301:	e9 73 07 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	8b 50 08             	mov    0x8(%eax),%edx
  80330c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803311:	8b 40 08             	mov    0x8(%eax),%eax
  803314:	39 c2                	cmp    %eax,%edx
  803316:	0f 86 84 00 00 00    	jbe    8033a0 <insert_sorted_with_merge_freeList+0x134>
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	8b 50 08             	mov    0x8(%eax),%edx
  803322:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803327:	8b 48 0c             	mov    0xc(%eax),%ecx
  80332a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80332f:	8b 40 08             	mov    0x8(%eax),%eax
  803332:	01 c8                	add    %ecx,%eax
  803334:	39 c2                	cmp    %eax,%edx
  803336:	74 68                	je     8033a0 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333c:	75 17                	jne    803355 <insert_sorted_with_merge_freeList+0xe9>
  80333e:	83 ec 04             	sub    $0x4,%esp
  803341:	68 2c 45 80 00       	push   $0x80452c
  803346:	68 4c 01 00 00       	push   $0x14c
  80334b:	68 13 45 80 00       	push   $0x804513
  803350:	e8 55 d9 ff ff       	call   800caa <_panic>
  803355:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	89 50 04             	mov    %edx,0x4(%eax)
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	8b 40 04             	mov    0x4(%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	74 0c                	je     803377 <insert_sorted_with_merge_freeList+0x10b>
  80336b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803370:	8b 55 08             	mov    0x8(%ebp),%edx
  803373:	89 10                	mov    %edx,(%eax)
  803375:	eb 08                	jmp    80337f <insert_sorted_with_merge_freeList+0x113>
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	a3 38 51 80 00       	mov    %eax,0x805138
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803390:	a1 44 51 80 00       	mov    0x805144,%eax
  803395:	40                   	inc    %eax
  803396:	a3 44 51 80 00       	mov    %eax,0x805144
  80339b:	e9 d9 06 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	8b 50 08             	mov    0x8(%eax),%edx
  8033a6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033ab:	8b 40 08             	mov    0x8(%eax),%eax
  8033ae:	39 c2                	cmp    %eax,%edx
  8033b0:	0f 86 b5 00 00 00    	jbe    80346b <insert_sorted_with_merge_freeList+0x1ff>
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	8b 50 08             	mov    0x8(%eax),%edx
  8033bc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033c1:	8b 48 0c             	mov    0xc(%eax),%ecx
  8033c4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033c9:	8b 40 08             	mov    0x8(%eax),%eax
  8033cc:	01 c8                	add    %ecx,%eax
  8033ce:	39 c2                	cmp    %eax,%edx
  8033d0:	0f 85 95 00 00 00    	jne    80346b <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8033d6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033db:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033e1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8033e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8033ea:	01 ca                	add    %ecx,%edx
  8033ec:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803407:	75 17                	jne    803420 <insert_sorted_with_merge_freeList+0x1b4>
  803409:	83 ec 04             	sub    $0x4,%esp
  80340c:	68 f0 44 80 00       	push   $0x8044f0
  803411:	68 54 01 00 00       	push   $0x154
  803416:	68 13 45 80 00       	push   $0x804513
  80341b:	e8 8a d8 ff ff       	call   800caa <_panic>
  803420:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	89 10                	mov    %edx,(%eax)
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	8b 00                	mov    (%eax),%eax
  803430:	85 c0                	test   %eax,%eax
  803432:	74 0d                	je     803441 <insert_sorted_with_merge_freeList+0x1d5>
  803434:	a1 48 51 80 00       	mov    0x805148,%eax
  803439:	8b 55 08             	mov    0x8(%ebp),%edx
  80343c:	89 50 04             	mov    %edx,0x4(%eax)
  80343f:	eb 08                	jmp    803449 <insert_sorted_with_merge_freeList+0x1dd>
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	a3 48 51 80 00       	mov    %eax,0x805148
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345b:	a1 54 51 80 00       	mov    0x805154,%eax
  803460:	40                   	inc    %eax
  803461:	a3 54 51 80 00       	mov    %eax,0x805154
  803466:	e9 0e 06 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	8b 50 08             	mov    0x8(%eax),%edx
  803471:	a1 38 51 80 00       	mov    0x805138,%eax
  803476:	8b 40 08             	mov    0x8(%eax),%eax
  803479:	39 c2                	cmp    %eax,%edx
  80347b:	0f 83 c1 00 00 00    	jae    803542 <insert_sorted_with_merge_freeList+0x2d6>
  803481:	a1 38 51 80 00       	mov    0x805138,%eax
  803486:	8b 50 08             	mov    0x8(%eax),%edx
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 48 08             	mov    0x8(%eax),%ecx
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	8b 40 0c             	mov    0xc(%eax),%eax
  803495:	01 c8                	add    %ecx,%eax
  803497:	39 c2                	cmp    %eax,%edx
  803499:	0f 85 a3 00 00 00    	jne    803542 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80349f:	a1 38 51 80 00       	mov    0x805138,%eax
  8034a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a7:	8b 52 08             	mov    0x8(%edx),%edx
  8034aa:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  8034ad:	a1 38 51 80 00       	mov    0x805138,%eax
  8034b2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034b8:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8034bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8034be:	8b 52 0c             	mov    0xc(%edx),%edx
  8034c1:	01 ca                	add    %ecx,%edx
  8034c3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034de:	75 17                	jne    8034f7 <insert_sorted_with_merge_freeList+0x28b>
  8034e0:	83 ec 04             	sub    $0x4,%esp
  8034e3:	68 f0 44 80 00       	push   $0x8044f0
  8034e8:	68 5d 01 00 00       	push   $0x15d
  8034ed:	68 13 45 80 00       	push   $0x804513
  8034f2:	e8 b3 d7 ff ff       	call   800caa <_panic>
  8034f7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	89 10                	mov    %edx,(%eax)
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 0d                	je     803518 <insert_sorted_with_merge_freeList+0x2ac>
  80350b:	a1 48 51 80 00       	mov    0x805148,%eax
  803510:	8b 55 08             	mov    0x8(%ebp),%edx
  803513:	89 50 04             	mov    %edx,0x4(%eax)
  803516:	eb 08                	jmp    803520 <insert_sorted_with_merge_freeList+0x2b4>
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	a3 48 51 80 00       	mov    %eax,0x805148
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803532:	a1 54 51 80 00       	mov    0x805154,%eax
  803537:	40                   	inc    %eax
  803538:	a3 54 51 80 00       	mov    %eax,0x805154
  80353d:	e9 37 05 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	8b 50 08             	mov    0x8(%eax),%edx
  803548:	a1 38 51 80 00       	mov    0x805138,%eax
  80354d:	8b 40 08             	mov    0x8(%eax),%eax
  803550:	39 c2                	cmp    %eax,%edx
  803552:	0f 83 82 00 00 00    	jae    8035da <insert_sorted_with_merge_freeList+0x36e>
  803558:	a1 38 51 80 00       	mov    0x805138,%eax
  80355d:	8b 50 08             	mov    0x8(%eax),%edx
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	8b 48 08             	mov    0x8(%eax),%ecx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	8b 40 0c             	mov    0xc(%eax),%eax
  80356c:	01 c8                	add    %ecx,%eax
  80356e:	39 c2                	cmp    %eax,%edx
  803570:	74 68                	je     8035da <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803572:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803576:	75 17                	jne    80358f <insert_sorted_with_merge_freeList+0x323>
  803578:	83 ec 04             	sub    $0x4,%esp
  80357b:	68 f0 44 80 00       	push   $0x8044f0
  803580:	68 62 01 00 00       	push   $0x162
  803585:	68 13 45 80 00       	push   $0x804513
  80358a:	e8 1b d7 ff ff       	call   800caa <_panic>
  80358f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	89 10                	mov    %edx,(%eax)
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	8b 00                	mov    (%eax),%eax
  80359f:	85 c0                	test   %eax,%eax
  8035a1:	74 0d                	je     8035b0 <insert_sorted_with_merge_freeList+0x344>
  8035a3:	a1 38 51 80 00       	mov    0x805138,%eax
  8035a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ab:	89 50 04             	mov    %edx,0x4(%eax)
  8035ae:	eb 08                	jmp    8035b8 <insert_sorted_with_merge_freeList+0x34c>
  8035b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8035cf:	40                   	inc    %eax
  8035d0:	a3 44 51 80 00       	mov    %eax,0x805144
  8035d5:	e9 9f 04 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8035da:	a1 38 51 80 00       	mov    0x805138,%eax
  8035df:	8b 00                	mov    (%eax),%eax
  8035e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8035e4:	e9 84 04 00 00       	jmp    803a6d <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	8b 50 08             	mov    0x8(%eax),%edx
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	8b 40 08             	mov    0x8(%eax),%eax
  8035f5:	39 c2                	cmp    %eax,%edx
  8035f7:	0f 86 a9 00 00 00    	jbe    8036a6 <insert_sorted_with_merge_freeList+0x43a>
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 50 08             	mov    0x8(%eax),%edx
  803603:	8b 45 08             	mov    0x8(%ebp),%eax
  803606:	8b 48 08             	mov    0x8(%eax),%ecx
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	8b 40 0c             	mov    0xc(%eax),%eax
  80360f:	01 c8                	add    %ecx,%eax
  803611:	39 c2                	cmp    %eax,%edx
  803613:	0f 84 8d 00 00 00    	je     8036a6 <insert_sorted_with_merge_freeList+0x43a>
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	8b 50 08             	mov    0x8(%eax),%edx
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	8b 40 04             	mov    0x4(%eax),%eax
  803625:	8b 48 08             	mov    0x8(%eax),%ecx
  803628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362b:	8b 40 04             	mov    0x4(%eax),%eax
  80362e:	8b 40 0c             	mov    0xc(%eax),%eax
  803631:	01 c8                	add    %ecx,%eax
  803633:	39 c2                	cmp    %eax,%edx
  803635:	74 6f                	je     8036a6 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80363b:	74 06                	je     803643 <insert_sorted_with_merge_freeList+0x3d7>
  80363d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803641:	75 17                	jne    80365a <insert_sorted_with_merge_freeList+0x3ee>
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 50 45 80 00       	push   $0x804550
  80364b:	68 6b 01 00 00       	push   $0x16b
  803650:	68 13 45 80 00       	push   $0x804513
  803655:	e8 50 d6 ff ff       	call   800caa <_panic>
  80365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365d:	8b 50 04             	mov    0x4(%eax),%edx
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	89 50 04             	mov    %edx,0x4(%eax)
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80366c:	89 10                	mov    %edx,(%eax)
  80366e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803671:	8b 40 04             	mov    0x4(%eax),%eax
  803674:	85 c0                	test   %eax,%eax
  803676:	74 0d                	je     803685 <insert_sorted_with_merge_freeList+0x419>
  803678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367b:	8b 40 04             	mov    0x4(%eax),%eax
  80367e:	8b 55 08             	mov    0x8(%ebp),%edx
  803681:	89 10                	mov    %edx,(%eax)
  803683:	eb 08                	jmp    80368d <insert_sorted_with_merge_freeList+0x421>
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	a3 38 51 80 00       	mov    %eax,0x805138
  80368d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803690:	8b 55 08             	mov    0x8(%ebp),%edx
  803693:	89 50 04             	mov    %edx,0x4(%eax)
  803696:	a1 44 51 80 00       	mov    0x805144,%eax
  80369b:	40                   	inc    %eax
  80369c:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8036a1:	e9 d3 03 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8036a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a9:	8b 50 08             	mov    0x8(%eax),%edx
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	8b 40 08             	mov    0x8(%eax),%eax
  8036b2:	39 c2                	cmp    %eax,%edx
  8036b4:	0f 86 da 00 00 00    	jbe    803794 <insert_sorted_with_merge_freeList+0x528>
  8036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bd:	8b 50 08             	mov    0x8(%eax),%edx
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	8b 48 08             	mov    0x8(%eax),%ecx
  8036c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036cc:	01 c8                	add    %ecx,%eax
  8036ce:	39 c2                	cmp    %eax,%edx
  8036d0:	0f 85 be 00 00 00    	jne    803794 <insert_sorted_with_merge_freeList+0x528>
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	8b 50 08             	mov    0x8(%eax),%edx
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	8b 48 08             	mov    0x8(%eax),%ecx
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	8b 40 04             	mov    0x4(%eax),%eax
  8036eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ee:	01 c8                	add    %ecx,%eax
  8036f0:	39 c2                	cmp    %eax,%edx
  8036f2:	0f 84 9c 00 00 00    	je     803794 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	8b 50 08             	mov    0x8(%eax),%edx
  8036fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803701:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803707:	8b 50 0c             	mov    0xc(%eax),%edx
  80370a:	8b 45 08             	mov    0x8(%ebp),%eax
  80370d:	8b 40 0c             	mov    0xc(%eax),%eax
  803710:	01 c2                	add    %eax,%edx
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803718:	8b 45 08             	mov    0x8(%ebp),%eax
  80371b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80372c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803730:	75 17                	jne    803749 <insert_sorted_with_merge_freeList+0x4dd>
  803732:	83 ec 04             	sub    $0x4,%esp
  803735:	68 f0 44 80 00       	push   $0x8044f0
  80373a:	68 74 01 00 00       	push   $0x174
  80373f:	68 13 45 80 00       	push   $0x804513
  803744:	e8 61 d5 ff ff       	call   800caa <_panic>
  803749:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	89 10                	mov    %edx,(%eax)
  803754:	8b 45 08             	mov    0x8(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	85 c0                	test   %eax,%eax
  80375b:	74 0d                	je     80376a <insert_sorted_with_merge_freeList+0x4fe>
  80375d:	a1 48 51 80 00       	mov    0x805148,%eax
  803762:	8b 55 08             	mov    0x8(%ebp),%edx
  803765:	89 50 04             	mov    %edx,0x4(%eax)
  803768:	eb 08                	jmp    803772 <insert_sorted_with_merge_freeList+0x506>
  80376a:	8b 45 08             	mov    0x8(%ebp),%eax
  80376d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	a3 48 51 80 00       	mov    %eax,0x805148
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803784:	a1 54 51 80 00       	mov    0x805154,%eax
  803789:	40                   	inc    %eax
  80378a:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80378f:	e9 e5 02 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803797:	8b 50 08             	mov    0x8(%eax),%edx
  80379a:	8b 45 08             	mov    0x8(%ebp),%eax
  80379d:	8b 40 08             	mov    0x8(%eax),%eax
  8037a0:	39 c2                	cmp    %eax,%edx
  8037a2:	0f 86 d7 00 00 00    	jbe    80387f <insert_sorted_with_merge_freeList+0x613>
  8037a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ab:	8b 50 08             	mov    0x8(%eax),%edx
  8037ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b1:	8b 48 08             	mov    0x8(%eax),%ecx
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ba:	01 c8                	add    %ecx,%eax
  8037bc:	39 c2                	cmp    %eax,%edx
  8037be:	0f 84 bb 00 00 00    	je     80387f <insert_sorted_with_merge_freeList+0x613>
  8037c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c7:	8b 50 08             	mov    0x8(%eax),%edx
  8037ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cd:	8b 40 04             	mov    0x4(%eax),%eax
  8037d0:	8b 48 08             	mov    0x8(%eax),%ecx
  8037d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d6:	8b 40 04             	mov    0x4(%eax),%eax
  8037d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8037dc:	01 c8                	add    %ecx,%eax
  8037de:	39 c2                	cmp    %eax,%edx
  8037e0:	0f 85 99 00 00 00    	jne    80387f <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8037ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f2:	8b 50 0c             	mov    0xc(%eax),%edx
  8037f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037fb:	01 c2                	add    %eax,%edx
  8037fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803800:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803803:	8b 45 08             	mov    0x8(%ebp),%eax
  803806:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80380d:	8b 45 08             	mov    0x8(%ebp),%eax
  803810:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80381b:	75 17                	jne    803834 <insert_sorted_with_merge_freeList+0x5c8>
  80381d:	83 ec 04             	sub    $0x4,%esp
  803820:	68 f0 44 80 00       	push   $0x8044f0
  803825:	68 7d 01 00 00       	push   $0x17d
  80382a:	68 13 45 80 00       	push   $0x804513
  80382f:	e8 76 d4 ff ff       	call   800caa <_panic>
  803834:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	89 10                	mov    %edx,(%eax)
  80383f:	8b 45 08             	mov    0x8(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	74 0d                	je     803855 <insert_sorted_with_merge_freeList+0x5e9>
  803848:	a1 48 51 80 00       	mov    0x805148,%eax
  80384d:	8b 55 08             	mov    0x8(%ebp),%edx
  803850:	89 50 04             	mov    %edx,0x4(%eax)
  803853:	eb 08                	jmp    80385d <insert_sorted_with_merge_freeList+0x5f1>
  803855:	8b 45 08             	mov    0x8(%ebp),%eax
  803858:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80385d:	8b 45 08             	mov    0x8(%ebp),%eax
  803860:	a3 48 51 80 00       	mov    %eax,0x805148
  803865:	8b 45 08             	mov    0x8(%ebp),%eax
  803868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80386f:	a1 54 51 80 00       	mov    0x805154,%eax
  803874:	40                   	inc    %eax
  803875:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80387a:	e9 fa 01 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80387f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803882:	8b 50 08             	mov    0x8(%eax),%edx
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	8b 40 08             	mov    0x8(%eax),%eax
  80388b:	39 c2                	cmp    %eax,%edx
  80388d:	0f 86 d2 01 00 00    	jbe    803a65 <insert_sorted_with_merge_freeList+0x7f9>
  803893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803896:	8b 50 08             	mov    0x8(%eax),%edx
  803899:	8b 45 08             	mov    0x8(%ebp),%eax
  80389c:	8b 48 08             	mov    0x8(%eax),%ecx
  80389f:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a5:	01 c8                	add    %ecx,%eax
  8038a7:	39 c2                	cmp    %eax,%edx
  8038a9:	0f 85 b6 01 00 00    	jne    803a65 <insert_sorted_with_merge_freeList+0x7f9>
  8038af:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b2:	8b 50 08             	mov    0x8(%eax),%edx
  8038b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b8:	8b 40 04             	mov    0x4(%eax),%eax
  8038bb:	8b 48 08             	mov    0x8(%eax),%ecx
  8038be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c1:	8b 40 04             	mov    0x4(%eax),%eax
  8038c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c7:	01 c8                	add    %ecx,%eax
  8038c9:	39 c2                	cmp    %eax,%edx
  8038cb:	0f 85 94 01 00 00    	jne    803a65 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8038d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d4:	8b 40 04             	mov    0x4(%eax),%eax
  8038d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038da:	8b 52 04             	mov    0x4(%edx),%edx
  8038dd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8038e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e3:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8038e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8038ec:	01 da                	add    %ebx,%edx
  8038ee:	01 ca                	add    %ecx,%edx
  8038f0:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8038f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80390b:	75 17                	jne    803924 <insert_sorted_with_merge_freeList+0x6b8>
  80390d:	83 ec 04             	sub    $0x4,%esp
  803910:	68 85 45 80 00       	push   $0x804585
  803915:	68 86 01 00 00       	push   $0x186
  80391a:	68 13 45 80 00       	push   $0x804513
  80391f:	e8 86 d3 ff ff       	call   800caa <_panic>
  803924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803927:	8b 00                	mov    (%eax),%eax
  803929:	85 c0                	test   %eax,%eax
  80392b:	74 10                	je     80393d <insert_sorted_with_merge_freeList+0x6d1>
  80392d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803930:	8b 00                	mov    (%eax),%eax
  803932:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803935:	8b 52 04             	mov    0x4(%edx),%edx
  803938:	89 50 04             	mov    %edx,0x4(%eax)
  80393b:	eb 0b                	jmp    803948 <insert_sorted_with_merge_freeList+0x6dc>
  80393d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803940:	8b 40 04             	mov    0x4(%eax),%eax
  803943:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394b:	8b 40 04             	mov    0x4(%eax),%eax
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 0f                	je     803961 <insert_sorted_with_merge_freeList+0x6f5>
  803952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803955:	8b 40 04             	mov    0x4(%eax),%eax
  803958:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80395b:	8b 12                	mov    (%edx),%edx
  80395d:	89 10                	mov    %edx,(%eax)
  80395f:	eb 0a                	jmp    80396b <insert_sorted_with_merge_freeList+0x6ff>
  803961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	a3 38 51 80 00       	mov    %eax,0x805138
  80396b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803977:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397e:	a1 44 51 80 00       	mov    0x805144,%eax
  803983:	48                   	dec    %eax
  803984:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80398d:	75 17                	jne    8039a6 <insert_sorted_with_merge_freeList+0x73a>
  80398f:	83 ec 04             	sub    $0x4,%esp
  803992:	68 f0 44 80 00       	push   $0x8044f0
  803997:	68 87 01 00 00       	push   $0x187
  80399c:	68 13 45 80 00       	push   $0x804513
  8039a1:	e8 04 d3 ff ff       	call   800caa <_panic>
  8039a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039af:	89 10                	mov    %edx,(%eax)
  8039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b4:	8b 00                	mov    (%eax),%eax
  8039b6:	85 c0                	test   %eax,%eax
  8039b8:	74 0d                	je     8039c7 <insert_sorted_with_merge_freeList+0x75b>
  8039ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8039bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039c2:	89 50 04             	mov    %edx,0x4(%eax)
  8039c5:	eb 08                	jmp    8039cf <insert_sorted_with_merge_freeList+0x763>
  8039c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8039d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8039e6:	40                   	inc    %eax
  8039e7:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8039ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8039f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803a00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a04:	75 17                	jne    803a1d <insert_sorted_with_merge_freeList+0x7b1>
  803a06:	83 ec 04             	sub    $0x4,%esp
  803a09:	68 f0 44 80 00       	push   $0x8044f0
  803a0e:	68 8a 01 00 00       	push   $0x18a
  803a13:	68 13 45 80 00       	push   $0x804513
  803a18:	e8 8d d2 ff ff       	call   800caa <_panic>
  803a1d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a23:	8b 45 08             	mov    0x8(%ebp),%eax
  803a26:	89 10                	mov    %edx,(%eax)
  803a28:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2b:	8b 00                	mov    (%eax),%eax
  803a2d:	85 c0                	test   %eax,%eax
  803a2f:	74 0d                	je     803a3e <insert_sorted_with_merge_freeList+0x7d2>
  803a31:	a1 48 51 80 00       	mov    0x805148,%eax
  803a36:	8b 55 08             	mov    0x8(%ebp),%edx
  803a39:	89 50 04             	mov    %edx,0x4(%eax)
  803a3c:	eb 08                	jmp    803a46 <insert_sorted_with_merge_freeList+0x7da>
  803a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a41:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a46:	8b 45 08             	mov    0x8(%ebp),%eax
  803a49:	a3 48 51 80 00       	mov    %eax,0x805148
  803a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a58:	a1 54 51 80 00       	mov    0x805154,%eax
  803a5d:	40                   	inc    %eax
  803a5e:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803a63:	eb 14                	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a68:	8b 00                	mov    (%eax),%eax
  803a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a71:	0f 85 72 fb ff ff    	jne    8035e9 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803a77:	eb 00                	jmp    803a79 <insert_sorted_with_merge_freeList+0x80d>
  803a79:	90                   	nop
  803a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a7d:	c9                   	leave  
  803a7e:	c3                   	ret    
  803a7f:	90                   	nop

00803a80 <__udivdi3>:
  803a80:	55                   	push   %ebp
  803a81:	57                   	push   %edi
  803a82:	56                   	push   %esi
  803a83:	53                   	push   %ebx
  803a84:	83 ec 1c             	sub    $0x1c,%esp
  803a87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a97:	89 ca                	mov    %ecx,%edx
  803a99:	89 f8                	mov    %edi,%eax
  803a9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a9f:	85 f6                	test   %esi,%esi
  803aa1:	75 2d                	jne    803ad0 <__udivdi3+0x50>
  803aa3:	39 cf                	cmp    %ecx,%edi
  803aa5:	77 65                	ja     803b0c <__udivdi3+0x8c>
  803aa7:	89 fd                	mov    %edi,%ebp
  803aa9:	85 ff                	test   %edi,%edi
  803aab:	75 0b                	jne    803ab8 <__udivdi3+0x38>
  803aad:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab2:	31 d2                	xor    %edx,%edx
  803ab4:	f7 f7                	div    %edi
  803ab6:	89 c5                	mov    %eax,%ebp
  803ab8:	31 d2                	xor    %edx,%edx
  803aba:	89 c8                	mov    %ecx,%eax
  803abc:	f7 f5                	div    %ebp
  803abe:	89 c1                	mov    %eax,%ecx
  803ac0:	89 d8                	mov    %ebx,%eax
  803ac2:	f7 f5                	div    %ebp
  803ac4:	89 cf                	mov    %ecx,%edi
  803ac6:	89 fa                	mov    %edi,%edx
  803ac8:	83 c4 1c             	add    $0x1c,%esp
  803acb:	5b                   	pop    %ebx
  803acc:	5e                   	pop    %esi
  803acd:	5f                   	pop    %edi
  803ace:	5d                   	pop    %ebp
  803acf:	c3                   	ret    
  803ad0:	39 ce                	cmp    %ecx,%esi
  803ad2:	77 28                	ja     803afc <__udivdi3+0x7c>
  803ad4:	0f bd fe             	bsr    %esi,%edi
  803ad7:	83 f7 1f             	xor    $0x1f,%edi
  803ada:	75 40                	jne    803b1c <__udivdi3+0x9c>
  803adc:	39 ce                	cmp    %ecx,%esi
  803ade:	72 0a                	jb     803aea <__udivdi3+0x6a>
  803ae0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ae4:	0f 87 9e 00 00 00    	ja     803b88 <__udivdi3+0x108>
  803aea:	b8 01 00 00 00       	mov    $0x1,%eax
  803aef:	89 fa                	mov    %edi,%edx
  803af1:	83 c4 1c             	add    $0x1c,%esp
  803af4:	5b                   	pop    %ebx
  803af5:	5e                   	pop    %esi
  803af6:	5f                   	pop    %edi
  803af7:	5d                   	pop    %ebp
  803af8:	c3                   	ret    
  803af9:	8d 76 00             	lea    0x0(%esi),%esi
  803afc:	31 ff                	xor    %edi,%edi
  803afe:	31 c0                	xor    %eax,%eax
  803b00:	89 fa                	mov    %edi,%edx
  803b02:	83 c4 1c             	add    $0x1c,%esp
  803b05:	5b                   	pop    %ebx
  803b06:	5e                   	pop    %esi
  803b07:	5f                   	pop    %edi
  803b08:	5d                   	pop    %ebp
  803b09:	c3                   	ret    
  803b0a:	66 90                	xchg   %ax,%ax
  803b0c:	89 d8                	mov    %ebx,%eax
  803b0e:	f7 f7                	div    %edi
  803b10:	31 ff                	xor    %edi,%edi
  803b12:	89 fa                	mov    %edi,%edx
  803b14:	83 c4 1c             	add    $0x1c,%esp
  803b17:	5b                   	pop    %ebx
  803b18:	5e                   	pop    %esi
  803b19:	5f                   	pop    %edi
  803b1a:	5d                   	pop    %ebp
  803b1b:	c3                   	ret    
  803b1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b21:	89 eb                	mov    %ebp,%ebx
  803b23:	29 fb                	sub    %edi,%ebx
  803b25:	89 f9                	mov    %edi,%ecx
  803b27:	d3 e6                	shl    %cl,%esi
  803b29:	89 c5                	mov    %eax,%ebp
  803b2b:	88 d9                	mov    %bl,%cl
  803b2d:	d3 ed                	shr    %cl,%ebp
  803b2f:	89 e9                	mov    %ebp,%ecx
  803b31:	09 f1                	or     %esi,%ecx
  803b33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b37:	89 f9                	mov    %edi,%ecx
  803b39:	d3 e0                	shl    %cl,%eax
  803b3b:	89 c5                	mov    %eax,%ebp
  803b3d:	89 d6                	mov    %edx,%esi
  803b3f:	88 d9                	mov    %bl,%cl
  803b41:	d3 ee                	shr    %cl,%esi
  803b43:	89 f9                	mov    %edi,%ecx
  803b45:	d3 e2                	shl    %cl,%edx
  803b47:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b4b:	88 d9                	mov    %bl,%cl
  803b4d:	d3 e8                	shr    %cl,%eax
  803b4f:	09 c2                	or     %eax,%edx
  803b51:	89 d0                	mov    %edx,%eax
  803b53:	89 f2                	mov    %esi,%edx
  803b55:	f7 74 24 0c          	divl   0xc(%esp)
  803b59:	89 d6                	mov    %edx,%esi
  803b5b:	89 c3                	mov    %eax,%ebx
  803b5d:	f7 e5                	mul    %ebp
  803b5f:	39 d6                	cmp    %edx,%esi
  803b61:	72 19                	jb     803b7c <__udivdi3+0xfc>
  803b63:	74 0b                	je     803b70 <__udivdi3+0xf0>
  803b65:	89 d8                	mov    %ebx,%eax
  803b67:	31 ff                	xor    %edi,%edi
  803b69:	e9 58 ff ff ff       	jmp    803ac6 <__udivdi3+0x46>
  803b6e:	66 90                	xchg   %ax,%ax
  803b70:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b74:	89 f9                	mov    %edi,%ecx
  803b76:	d3 e2                	shl    %cl,%edx
  803b78:	39 c2                	cmp    %eax,%edx
  803b7a:	73 e9                	jae    803b65 <__udivdi3+0xe5>
  803b7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b7f:	31 ff                	xor    %edi,%edi
  803b81:	e9 40 ff ff ff       	jmp    803ac6 <__udivdi3+0x46>
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	31 c0                	xor    %eax,%eax
  803b8a:	e9 37 ff ff ff       	jmp    803ac6 <__udivdi3+0x46>
  803b8f:	90                   	nop

00803b90 <__umoddi3>:
  803b90:	55                   	push   %ebp
  803b91:	57                   	push   %edi
  803b92:	56                   	push   %esi
  803b93:	53                   	push   %ebx
  803b94:	83 ec 1c             	sub    $0x1c,%esp
  803b97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ba3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ba7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803baf:	89 f3                	mov    %esi,%ebx
  803bb1:	89 fa                	mov    %edi,%edx
  803bb3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bb7:	89 34 24             	mov    %esi,(%esp)
  803bba:	85 c0                	test   %eax,%eax
  803bbc:	75 1a                	jne    803bd8 <__umoddi3+0x48>
  803bbe:	39 f7                	cmp    %esi,%edi
  803bc0:	0f 86 a2 00 00 00    	jbe    803c68 <__umoddi3+0xd8>
  803bc6:	89 c8                	mov    %ecx,%eax
  803bc8:	89 f2                	mov    %esi,%edx
  803bca:	f7 f7                	div    %edi
  803bcc:	89 d0                	mov    %edx,%eax
  803bce:	31 d2                	xor    %edx,%edx
  803bd0:	83 c4 1c             	add    $0x1c,%esp
  803bd3:	5b                   	pop    %ebx
  803bd4:	5e                   	pop    %esi
  803bd5:	5f                   	pop    %edi
  803bd6:	5d                   	pop    %ebp
  803bd7:	c3                   	ret    
  803bd8:	39 f0                	cmp    %esi,%eax
  803bda:	0f 87 ac 00 00 00    	ja     803c8c <__umoddi3+0xfc>
  803be0:	0f bd e8             	bsr    %eax,%ebp
  803be3:	83 f5 1f             	xor    $0x1f,%ebp
  803be6:	0f 84 ac 00 00 00    	je     803c98 <__umoddi3+0x108>
  803bec:	bf 20 00 00 00       	mov    $0x20,%edi
  803bf1:	29 ef                	sub    %ebp,%edi
  803bf3:	89 fe                	mov    %edi,%esi
  803bf5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bf9:	89 e9                	mov    %ebp,%ecx
  803bfb:	d3 e0                	shl    %cl,%eax
  803bfd:	89 d7                	mov    %edx,%edi
  803bff:	89 f1                	mov    %esi,%ecx
  803c01:	d3 ef                	shr    %cl,%edi
  803c03:	09 c7                	or     %eax,%edi
  803c05:	89 e9                	mov    %ebp,%ecx
  803c07:	d3 e2                	shl    %cl,%edx
  803c09:	89 14 24             	mov    %edx,(%esp)
  803c0c:	89 d8                	mov    %ebx,%eax
  803c0e:	d3 e0                	shl    %cl,%eax
  803c10:	89 c2                	mov    %eax,%edx
  803c12:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c16:	d3 e0                	shl    %cl,%eax
  803c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c20:	89 f1                	mov    %esi,%ecx
  803c22:	d3 e8                	shr    %cl,%eax
  803c24:	09 d0                	or     %edx,%eax
  803c26:	d3 eb                	shr    %cl,%ebx
  803c28:	89 da                	mov    %ebx,%edx
  803c2a:	f7 f7                	div    %edi
  803c2c:	89 d3                	mov    %edx,%ebx
  803c2e:	f7 24 24             	mull   (%esp)
  803c31:	89 c6                	mov    %eax,%esi
  803c33:	89 d1                	mov    %edx,%ecx
  803c35:	39 d3                	cmp    %edx,%ebx
  803c37:	0f 82 87 00 00 00    	jb     803cc4 <__umoddi3+0x134>
  803c3d:	0f 84 91 00 00 00    	je     803cd4 <__umoddi3+0x144>
  803c43:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c47:	29 f2                	sub    %esi,%edx
  803c49:	19 cb                	sbb    %ecx,%ebx
  803c4b:	89 d8                	mov    %ebx,%eax
  803c4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c51:	d3 e0                	shl    %cl,%eax
  803c53:	89 e9                	mov    %ebp,%ecx
  803c55:	d3 ea                	shr    %cl,%edx
  803c57:	09 d0                	or     %edx,%eax
  803c59:	89 e9                	mov    %ebp,%ecx
  803c5b:	d3 eb                	shr    %cl,%ebx
  803c5d:	89 da                	mov    %ebx,%edx
  803c5f:	83 c4 1c             	add    $0x1c,%esp
  803c62:	5b                   	pop    %ebx
  803c63:	5e                   	pop    %esi
  803c64:	5f                   	pop    %edi
  803c65:	5d                   	pop    %ebp
  803c66:	c3                   	ret    
  803c67:	90                   	nop
  803c68:	89 fd                	mov    %edi,%ebp
  803c6a:	85 ff                	test   %edi,%edi
  803c6c:	75 0b                	jne    803c79 <__umoddi3+0xe9>
  803c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c73:	31 d2                	xor    %edx,%edx
  803c75:	f7 f7                	div    %edi
  803c77:	89 c5                	mov    %eax,%ebp
  803c79:	89 f0                	mov    %esi,%eax
  803c7b:	31 d2                	xor    %edx,%edx
  803c7d:	f7 f5                	div    %ebp
  803c7f:	89 c8                	mov    %ecx,%eax
  803c81:	f7 f5                	div    %ebp
  803c83:	89 d0                	mov    %edx,%eax
  803c85:	e9 44 ff ff ff       	jmp    803bce <__umoddi3+0x3e>
  803c8a:	66 90                	xchg   %ax,%ax
  803c8c:	89 c8                	mov    %ecx,%eax
  803c8e:	89 f2                	mov    %esi,%edx
  803c90:	83 c4 1c             	add    $0x1c,%esp
  803c93:	5b                   	pop    %ebx
  803c94:	5e                   	pop    %esi
  803c95:	5f                   	pop    %edi
  803c96:	5d                   	pop    %ebp
  803c97:	c3                   	ret    
  803c98:	3b 04 24             	cmp    (%esp),%eax
  803c9b:	72 06                	jb     803ca3 <__umoddi3+0x113>
  803c9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ca1:	77 0f                	ja     803cb2 <__umoddi3+0x122>
  803ca3:	89 f2                	mov    %esi,%edx
  803ca5:	29 f9                	sub    %edi,%ecx
  803ca7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cab:	89 14 24             	mov    %edx,(%esp)
  803cae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cb2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cb6:	8b 14 24             	mov    (%esp),%edx
  803cb9:	83 c4 1c             	add    $0x1c,%esp
  803cbc:	5b                   	pop    %ebx
  803cbd:	5e                   	pop    %esi
  803cbe:	5f                   	pop    %edi
  803cbf:	5d                   	pop    %ebp
  803cc0:	c3                   	ret    
  803cc1:	8d 76 00             	lea    0x0(%esi),%esi
  803cc4:	2b 04 24             	sub    (%esp),%eax
  803cc7:	19 fa                	sbb    %edi,%edx
  803cc9:	89 d1                	mov    %edx,%ecx
  803ccb:	89 c6                	mov    %eax,%esi
  803ccd:	e9 71 ff ff ff       	jmp    803c43 <__umoddi3+0xb3>
  803cd2:	66 90                	xchg   %ax,%ax
  803cd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cd8:	72 ea                	jb     803cc4 <__umoddi3+0x134>
  803cda:	89 d9                	mov    %ebx,%ecx
  803cdc:	e9 62 ff ff ff       	jmp    803c43 <__umoddi3+0xb3>
