
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 e0 37 80 00       	push   $0x8037e0
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 8f 1d 00 00       	call   801e03 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 27 1e 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 07 19 00 00       	call   80199f <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 04 38 80 00       	push   $0x803804
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 34 38 80 00       	push   $0x803834
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 3f 1d 00 00       	call   801e03 <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 4c 38 80 00       	push   $0x80384c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 34 38 80 00       	push   $0x803834
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 bd 1d 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 b8 38 80 00       	push   $0x8038b8
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 34 38 80 00       	push   $0x803834
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 fc 1c 00 00       	call   801e03 <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 94 1d 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 76 18 00 00       	call   80199f <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 04 38 80 00       	push   $0x803804
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 34 38 80 00       	push   $0x803834
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 97 1c 00 00       	call   801e03 <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 4c 38 80 00       	push   $0x80384c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 34 38 80 00       	push   $0x803834
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 15 1d 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 b8 38 80 00       	push   $0x8038b8
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 34 38 80 00       	push   $0x803834
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 54 1c 00 00       	call   801e03 <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 ec 1c 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 ca 17 00 00       	call   80199f <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 04 38 80 00       	push   $0x803804
  800206:	6a 23                	push   $0x23
  800208:	68 34 38 80 00       	push   $0x803834
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 ec 1b 00 00       	call   801e03 <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 4c 38 80 00       	push   $0x80384c
  800228:	6a 25                	push   $0x25
  80022a:	68 34 38 80 00       	push   $0x803834
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 6a 1c 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 b8 38 80 00       	push   $0x8038b8
  800249:	6a 26                	push   $0x26
  80024b:	68 34 38 80 00       	push   $0x803834
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 a9 1b 00 00       	call   801e03 <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 41 1c 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 1f 17 00 00       	call   80199f <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 04 38 80 00       	push   $0x803804
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 34 38 80 00       	push   $0x803834
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 45 1b 00 00       	call   801e03 <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 4c 38 80 00       	push   $0x80384c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 34 38 80 00       	push   $0x803834
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 c3 1b 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 b8 38 80 00       	push   $0x8038b8
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 34 38 80 00       	push   $0x803834
  8002f7:	e8 9f 04 00 00       	call   80079b <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 dc 19 00 00       	call   801e03 <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 74 1a 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 2c 18 00 00       	call   801c81 <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 e8 38 80 00       	push   $0x8038e8
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 34 38 80 00       	push   $0x803834
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 15 1a 00 00       	call   801ea3 <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 1c 39 80 00       	push   $0x80391c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 34 38 80 00       	push   $0x803834
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 4d 39 80 00       	push   $0x80394d
  8004b4:	e8 2b 05 00 00       	call   8009e4 <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 54 39 80 00       	push   $0x803954
  800506:	6a 7a                	push   $0x7a
  800508:	68 34 38 80 00       	push   $0x803834
  80050d:	e8 89 02 00 00       	call   80079b <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 54 39 80 00       	push   $0x803954
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 34 38 80 00       	push   $0x803834
  800568:	e8 2e 02 00 00       	call   80079b <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 54 39 80 00       	push   $0x803954
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 34 38 80 00       	push   $0x803834
  8005ca:	e8 cc 01 00 00       	call   80079b <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 54 39 80 00       	push   $0x803954
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 34 38 80 00       	push   $0x803834
  800625:	e8 71 01 00 00       	call   80079b <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 8c 39 80 00       	push   $0x80398c
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 98 39 80 00       	push   $0x803998
  80064f:	e8 fb 03 00 00       	call   800a4f <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 79 1a 00 00       	call   8020e3 <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 03             	shl    $0x3,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	01 c0                	add    %eax,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800682:	01 d0                	add    %edx,%eax
  800684:	c1 e0 04             	shl    $0x4,%eax
  800687:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80068c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800691:	a1 20 50 80 00       	mov    0x805020,%eax
  800696:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80069c:	84 c0                	test   %al,%al
  80069e:	74 0f                	je     8006af <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a5:	05 5c 05 00 00       	add    $0x55c,%eax
  8006aa:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006b3:	7e 0a                	jle    8006bf <libmain+0x60>
		binaryname = argv[0];
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 6b f9 ff ff       	call   800038 <_main>
  8006cd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d0:	e8 1b 18 00 00       	call   801ef0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 ec 39 80 00       	push   $0x8039ec
  8006dd:	e8 6d 03 00 00       	call   800a4f <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ea:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	52                   	push   %edx
  8006ff:	50                   	push   %eax
  800700:	68 14 3a 80 00       	push   $0x803a14
  800705:	e8 45 03 00 00       	call   800a4f <cprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80070d:	a1 20 50 80 00       	mov    0x805020,%eax
  800712:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800718:	a1 20 50 80 00       	mov    0x805020,%eax
  80071d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800723:	a1 20 50 80 00       	mov    0x805020,%eax
  800728:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	68 3c 3a 80 00       	push   $0x803a3c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 94 3a 80 00       	push   $0x803a94
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 ec 39 80 00       	push   $0x8039ec
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 9b 17 00 00       	call   801f0a <sys_enable_interrupt>

	// exit gracefully
	exit();
  80076f:	e8 19 00 00 00       	call   80078d <exit>
}
  800774:	90                   	nop
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	6a 00                	push   $0x0
  800782:	e8 28 19 00 00       	call   8020af <sys_destroy_env>
  800787:	83 c4 10             	add    $0x10,%esp
}
  80078a:	90                   	nop
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <exit>:

void
exit(void)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800793:	e8 7d 19 00 00       	call   802115 <sys_exit_env>
}
  800798:	90                   	nop
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007aa:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	74 16                	je     8007c9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007b3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	68 a8 3a 80 00       	push   $0x803aa8
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 ad 3a 80 00       	push   $0x803aad
  8007da:	e8 70 02 00 00       	call   800a4f <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	50                   	push   %eax
  8007ec:	e8 f3 01 00 00       	call   8009e4 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	6a 00                	push   $0x0
  8007f9:	68 c9 3a 80 00       	push   $0x803ac9
  8007fe:	e8 e1 01 00 00       	call   8009e4 <vcprintf>
  800803:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800806:	e8 82 ff ff ff       	call   80078d <exit>

	// should not return here
	while (1) ;
  80080b:	eb fe                	jmp    80080b <_panic+0x70>

0080080d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 14                	je     800836 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 cc 3a 80 00       	push   $0x803acc
  80082a:	6a 26                	push   $0x26
  80082c:	68 18 3b 80 00       	push   $0x803b18
  800831:	e8 65 ff ff ff       	call   80079b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800844:	e9 c2 00 00 00       	jmp    80090b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 d0                	add    %edx,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	85 c0                	test   %eax,%eax
  80085c:	75 08                	jne    800866 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80085e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800861:	e9 a2 00 00 00       	jmp    800908 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800874:	eb 69                	jmp    8008df <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800876:	a1 20 50 80 00       	mov    0x805020,%eax
  80087b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800884:	89 d0                	mov    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	c1 e0 03             	shl    $0x3,%eax
  80088d:	01 c8                	add    %ecx,%eax
  80088f:	8a 40 04             	mov    0x4(%eax),%al
  800892:	84 c0                	test   %al,%al
  800894:	75 46                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800896:	a1 20 50 80 00       	mov    0x805020,%eax
  80089b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a4:	89 d0                	mov    %edx,%eax
  8008a6:	01 c0                	add    %eax,%eax
  8008a8:	01 d0                	add    %edx,%eax
  8008aa:	c1 e0 03             	shl    $0x3,%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	75 09                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008da:	eb 12                	jmp    8008ee <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
  8008df:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e4:	8b 50 74             	mov    0x74(%eax),%edx
  8008e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	77 88                	ja     800876 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008f2:	75 14                	jne    800908 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 24 3b 80 00       	push   $0x803b24
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 18 3b 80 00       	push   $0x803b18
  800903:	e8 93 fe ff ff       	call   80079b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800908:	ff 45 f0             	incl   -0x10(%ebp)
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800911:	0f 8c 32 ff ff ff    	jl     800849 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800917:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800925:	eb 26                	jmp    80094d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800927:	a1 20 50 80 00       	mov    0x805020,%eax
  80092c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800932:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800935:	89 d0                	mov    %edx,%eax
  800937:	01 c0                	add    %eax,%eax
  800939:	01 d0                	add    %edx,%eax
  80093b:	c1 e0 03             	shl    $0x3,%eax
  80093e:	01 c8                	add    %ecx,%eax
  800940:	8a 40 04             	mov    0x4(%eax),%al
  800943:	3c 01                	cmp    $0x1,%al
  800945:	75 03                	jne    80094a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800947:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	ff 45 e0             	incl   -0x20(%ebp)
  80094d:	a1 20 50 80 00       	mov    0x805020,%eax
  800952:	8b 50 74             	mov    0x74(%eax),%edx
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	77 cb                	ja     800927 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800962:	74 14                	je     800978 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800964:	83 ec 04             	sub    $0x4,%esp
  800967:	68 78 3b 80 00       	push   $0x803b78
  80096c:	6a 44                	push   $0x44
  80096e:	68 18 3b 80 00       	push   $0x803b18
  800973:	e8 23 fe ff ff       	call   80079b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 48 01             	lea    0x1(%eax),%ecx
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 0a                	mov    %ecx,(%edx)
  80098e:	8b 55 08             	mov    0x8(%ebp),%edx
  800991:	88 d1                	mov    %dl,%cl
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a4:	75 2c                	jne    8009d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009a6:	a0 24 50 80 00       	mov    0x805024,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	8b 12                	mov    (%edx),%edx
  8009b3:	89 d1                	mov    %edx,%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	83 c2 08             	add    $0x8,%edx
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	50                   	push   %eax
  8009bf:	51                   	push   %ecx
  8009c0:	52                   	push   %edx
  8009c1:	e8 7c 13 00 00       	call   801d42 <sys_cputs>
  8009c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 40 04             	mov    0x4(%eax),%eax
  8009d8:	8d 50 01             	lea    0x1(%eax),%edx
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e1:	90                   	nop
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f4:	00 00 00 
	b.cnt = 0;
  8009f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a0d:	50                   	push   %eax
  800a0e:	68 7b 09 80 00       	push   $0x80097b
  800a13:	e8 11 02 00 00       	call   800c29 <vprintfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a1b:	a0 24 50 80 00       	mov    0x805024,%al
  800a20:	0f b6 c0             	movzbl %al,%eax
  800a23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	50                   	push   %eax
  800a2d:	52                   	push   %edx
  800a2e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	50                   	push   %eax
  800a38:	e8 05 13 00 00       	call   801d42 <sys_cputs>
  800a3d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a40:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <cprintf>:

int cprintf(const char *fmt, ...) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a55:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a5c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	e8 73 ff ff ff       	call   8009e4 <vcprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a82:	e8 69 14 00 00       	call   801ef0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a87:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 f4             	pushl  -0xc(%ebp)
  800a96:	50                   	push   %eax
  800a97:	e8 48 ff ff ff       	call   8009e4 <vcprintf>
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aa2:	e8 63 14 00 00       	call   801f0a <sys_enable_interrupt>
	return cnt;
  800aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	53                   	push   %ebx
  800ab0:	83 ec 14             	sub    $0x14,%esp
  800ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800abf:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aca:	77 55                	ja     800b21 <printnum+0x75>
  800acc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800acf:	72 05                	jb     800ad6 <printnum+0x2a>
  800ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ad4:	77 4b                	ja     800b21 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ad6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800adc:	8b 45 18             	mov    0x18(%ebp),%eax
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	52                   	push   %edx
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae9:	ff 75 f0             	pushl  -0x10(%ebp)
  800aec:	e8 7f 2a 00 00       	call   803570 <__udivdi3>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	ff 75 20             	pushl  0x20(%ebp)
  800afa:	53                   	push   %ebx
  800afb:	ff 75 18             	pushl  0x18(%ebp)
  800afe:	52                   	push   %edx
  800aff:	50                   	push   %eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 a1 ff ff ff       	call   800aac <printnum>
  800b0b:	83 c4 20             	add    $0x20,%esp
  800b0e:	eb 1a                	jmp    800b2a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 20             	pushl  0x20(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b21:	ff 4d 1c             	decl   0x1c(%ebp)
  800b24:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b28:	7f e6                	jg     800b10 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b2a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b38:	53                   	push   %ebx
  800b39:	51                   	push   %ecx
  800b3a:	52                   	push   %edx
  800b3b:	50                   	push   %eax
  800b3c:	e8 3f 2b 00 00       	call   803680 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 f4 3d 80 00       	add    $0x803df4,%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be c0             	movsbl %al,%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
}
  800b5d:	90                   	nop
  800b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b66:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b6a:	7e 1c                	jle    800b88 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	8d 50 08             	lea    0x8(%eax),%edx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 10                	mov    %edx,(%eax)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	83 e8 08             	sub    $0x8,%eax
  800b81:	8b 50 04             	mov    0x4(%eax),%edx
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	eb 40                	jmp    800bc8 <getuint+0x65>
	else if (lflag)
  800b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8c:	74 1e                	je     800bac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	8d 50 04             	lea    0x4(%eax),%edx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 10                	mov    %edx,(%eax)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	eb 1c                	jmp    800bc8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 10                	mov    %edx,(%eax)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	83 e8 04             	sub    $0x4,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bcd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd1:	7e 1c                	jle    800bef <getint+0x25>
		return va_arg(*ap, long long);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	8d 50 08             	lea    0x8(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 10                	mov    %edx,(%eax)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	83 e8 08             	sub    $0x8,%eax
  800be8:	8b 50 04             	mov    0x4(%eax),%edx
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	eb 38                	jmp    800c27 <getint+0x5d>
	else if (lflag)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 1a                	je     800c0f <getint+0x45>
		return va_arg(*ap, long);
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	8d 50 04             	lea    0x4(%eax),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 10                	mov    %edx,(%eax)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	83 e8 04             	sub    $0x4,%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	99                   	cltd   
  800c0d:	eb 18                	jmp    800c27 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 50 04             	lea    0x4(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	83 e8 04             	sub    $0x4,%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	99                   	cltd   
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c31:	eb 17                	jmp    800c4a <vprintfmt+0x21>
			if (ch == '\0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	0f 84 af 03 00 00    	je     800fea <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	53                   	push   %ebx
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d8             	movzbl %al,%ebx
  800c58:	83 fb 25             	cmp    $0x25,%ebx
  800c5b:	75 d6                	jne    800c33 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c5d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c61:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d8             	movzbl %al,%ebx
  800c8b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c8e:	83 f8 55             	cmp    $0x55,%eax
  800c91:	0f 87 2b 03 00 00    	ja     800fc2 <vprintfmt+0x399>
  800c97:	8b 04 85 18 3e 80 00 	mov    0x803e18(,%eax,4),%eax
  800c9e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ca4:	eb d7                	jmp    800c7d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800caa:	eb d1                	jmp    800c7d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	c1 e0 02             	shl    $0x2,%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	01 c0                	add    %eax,%eax
  800cbf:	01 d8                	add    %ebx,%eax
  800cc1:	83 e8 30             	sub    $0x30,%eax
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd2:	7e 3e                	jle    800d12 <vprintfmt+0xe9>
  800cd4:	83 fb 39             	cmp    $0x39,%ebx
  800cd7:	7f 39                	jg     800d12 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cdc:	eb d5                	jmp    800cb3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 e8 04             	sub    $0x4,%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf2:	eb 1f                	jmp    800d13 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	79 83                	jns    800c7d <vprintfmt+0x54>
				width = 0;
  800cfa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d01:	e9 77 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d06:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d0d:	e9 6b ff ff ff       	jmp    800c7d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d12:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	0f 89 60 ff ff ff    	jns    800c7d <vprintfmt+0x54>
				width = precision, precision = -1;
  800d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d2a:	e9 4e ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d2f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d32:	e9 46 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 c0 04             	add    $0x4,%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			break;
  800d57:	e9 89 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 c0 04             	add    $0x4,%eax
  800d62:	89 45 14             	mov    %eax,0x14(%ebp)
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 e8 04             	sub    $0x4,%eax
  800d6b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	79 02                	jns    800d73 <vprintfmt+0x14a>
				err = -err;
  800d71:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d73:	83 fb 64             	cmp    $0x64,%ebx
  800d76:	7f 0b                	jg     800d83 <vprintfmt+0x15a>
  800d78:	8b 34 9d 60 3c 80 00 	mov    0x803c60(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 05 3e 80 00       	push   $0x803e05
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 5e 02 00 00       	call   800ff2 <printfmt>
  800d94:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d97:	e9 49 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d9c:	56                   	push   %esi
  800d9d:	68 0e 3e 80 00       	push   $0x803e0e
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 45 02 00 00       	call   800ff2 <printfmt>
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	e9 30 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 c0 04             	add    $0x4,%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 e8 04             	sub    $0x4,%eax
  800dc4:	8b 30                	mov    (%eax),%esi
  800dc6:	85 f6                	test   %esi,%esi
  800dc8:	75 05                	jne    800dcf <vprintfmt+0x1a6>
				p = "(null)";
  800dca:	be 11 3e 80 00       	mov    $0x803e11,%esi
			if (width > 0 && padc != '-')
  800dcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd3:	7e 6d                	jle    800e42 <vprintfmt+0x219>
  800dd5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd9:	74 67                	je     800e42 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	50                   	push   %eax
  800de2:	56                   	push   %esi
  800de3:	e8 0c 03 00 00       	call   8010f4 <strnlen>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dee:	eb 16                	jmp    800e06 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	50                   	push   %eax
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	ff d0                	call   *%eax
  800e00:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e03:	ff 4d e4             	decl   -0x1c(%ebp)
  800e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0a:	7f e4                	jg     800df0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0c:	eb 34                	jmp    800e42 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e12:	74 1c                	je     800e30 <vprintfmt+0x207>
  800e14:	83 fb 1f             	cmp    $0x1f,%ebx
  800e17:	7e 05                	jle    800e1e <vprintfmt+0x1f5>
  800e19:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1c:	7e 12                	jle    800e30 <vprintfmt+0x207>
					putch('?', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	6a 3f                	push   $0x3f
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	ff d0                	call   *%eax
  800e2b:	83 c4 10             	add    $0x10,%esp
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e42:	89 f0                	mov    %esi,%eax
  800e44:	8d 70 01             	lea    0x1(%eax),%esi
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	74 24                	je     800e74 <vprintfmt+0x24b>
  800e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e54:	78 b8                	js     800e0e <vprintfmt+0x1e5>
  800e56:	ff 4d e0             	decl   -0x20(%ebp)
  800e59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5d:	79 af                	jns    800e0e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5f:	eb 13                	jmp    800e74 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	6a 20                	push   $0x20
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	ff d0                	call   *%eax
  800e6e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e71:	ff 4d e4             	decl   -0x1c(%ebp)
  800e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e78:	7f e7                	jg     800e61 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e7a:	e9 66 01 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 e8             	pushl  -0x18(%ebp)
  800e85:	8d 45 14             	lea    0x14(%ebp),%eax
  800e88:	50                   	push   %eax
  800e89:	e8 3c fd ff ff       	call   800bca <getint>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	85 d2                	test   %edx,%edx
  800e9f:	79 23                	jns    800ec4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 2d                	push   $0x2d
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb7:	f7 d8                	neg    %eax
  800eb9:	83 d2 00             	adc    $0x0,%edx
  800ebc:	f7 da                	neg    %edx
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ec4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecb:	e9 bc 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	e8 84 fc ff ff       	call   800b63 <getuint>
  800edf:	83 c4 10             	add    $0x10,%esp
  800ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eef:	e9 98 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	6a 58                	push   $0x58
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	6a 58                	push   $0x58
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	6a 58                	push   $0x58
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			break;
  800f24:	e9 bc 00 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 30                	push   $0x30
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	6a 78                	push   $0x78
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 e8             	pushl  -0x18(%ebp)
  800f73:	8d 45 14             	lea    0x14(%ebp),%eax
  800f76:	50                   	push   %eax
  800f77:	e8 e7 fb ff ff       	call   800b63 <getuint>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f8c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f93:	83 ec 04             	sub    $0x4,%esp
  800f96:	52                   	push   %edx
  800f97:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 08             	pushl  0x8(%ebp)
  800fa7:	e8 00 fb ff ff       	call   800aac <printnum>
  800fac:	83 c4 20             	add    $0x20,%esp
			break;
  800faf:	eb 34                	jmp    800fe5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			break;
  800fc0:	eb 23                	jmp    800fe5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 25                	push   $0x25
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd2:	ff 4d 10             	decl   0x10(%ebp)
  800fd5:	eb 03                	jmp    800fda <vprintfmt+0x3b1>
  800fd7:	ff 4d 10             	decl   0x10(%ebp)
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	48                   	dec    %eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 25                	cmp    $0x25,%al
  800fe2:	75 f3                	jne    800fd7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fe4:	90                   	nop
		}
	}
  800fe5:	e9 47 fc ff ff       	jmp    800c31 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800feb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	ff 75 f4             	pushl  -0xc(%ebp)
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 16 fc ff ff       	call   800c29 <vprintfmt>
  801013:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801016:	90                   	nop
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 40 08             	mov    0x8(%eax),%eax
  801022:	8d 50 01             	lea    0x1(%eax),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 40 04             	mov    0x4(%eax),%eax
  801036:	39 c2                	cmp    %eax,%edx
  801038:	73 12                	jae    80104c <sprintputch+0x33>
		*b->buf++ = ch;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8b 00                	mov    (%eax),%eax
  80103f:	8d 48 01             	lea    0x1(%eax),%ecx
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	89 0a                	mov    %ecx,(%edx)
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	88 10                	mov    %dl,(%eax)
}
  80104c:	90                   	nop
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801074:	74 06                	je     80107c <vsnprintf+0x2d>
  801076:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107a:	7f 07                	jg     801083 <vsnprintf+0x34>
		return -E_INVAL;
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	eb 20                	jmp    8010a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801083:	ff 75 14             	pushl  0x14(%ebp)
  801086:	ff 75 10             	pushl  0x10(%ebp)
  801089:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	68 19 10 80 00       	push   $0x801019
  801092:	e8 92 fb ff ff       	call   800c29 <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ae:	83 c0 04             	add    $0x4,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	ff 75 08             	pushl  0x8(%ebp)
  8010c1:	e8 89 ff ff ff       	call   80104f <vsnprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010de:	eb 06                	jmp    8010e6 <strlen+0x15>
		n++;
  8010e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 f1                	jne    8010e0 <strlen+0xf>
		n++;
	return n;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801101:	eb 09                	jmp    80110c <strnlen+0x18>
		n++;
  801103:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	ff 4d 0c             	decl   0xc(%ebp)
  80110c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801110:	74 09                	je     80111b <strnlen+0x27>
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	84 c0                	test   %al,%al
  801119:	75 e8                	jne    801103 <strnlen+0xf>
		n++;
	return n;
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80112c:	90                   	nop
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113f:	8a 12                	mov    (%edx),%dl
  801141:	88 10                	mov    %dl,(%eax)
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	75 e4                	jne    80112d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801161:	eb 1f                	jmp    801182 <strncpy+0x34>
		*dst++ = *src;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 08             	mov    %edx,0x8(%ebp)
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	8a 12                	mov    (%edx),%dl
  801171:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	84 c0                	test   %al,%al
  80117a:	74 03                	je     80117f <strncpy+0x31>
			src++;
  80117c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	ff 45 fc             	incl   -0x4(%ebp)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	3b 45 10             	cmp    0x10(%ebp),%eax
  801188:	72 d9                	jb     801163 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	74 30                	je     8011d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011a1:	eb 16                	jmp    8011b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b5:	8a 12                	mov    (%edx),%dl
  8011b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b9:	ff 4d 10             	decl   0x10(%ebp)
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 09                	je     8011cb <strlcpy+0x3c>
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	75 d8                	jne    8011a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011e0:	eb 06                	jmp    8011e8 <strcmp+0xb>
		p++, q++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 0e                	je     8011ff <strcmp+0x22>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 10                	mov    (%eax),%dl
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	38 c2                	cmp    %al,%dl
  8011fd:	74 e3                	je     8011e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 c0             	movzbl %al,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801218:	eb 09                	jmp    801223 <strncmp+0xe>
		n--, p++, q++;
  80121a:	ff 4d 10             	decl   0x10(%ebp)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 17                	je     801240 <strncmp+0x2b>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	74 0e                	je     801240 <strncmp+0x2b>
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 10                	mov    (%eax),%dl
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	38 c2                	cmp    %al,%dl
  80123e:	74 da                	je     80121a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 07                	jne    80124d <strncmp+0x38>
		return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 14                	jmp    801261 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 c0             	movzbl %al,%eax
  80125d:	29 c2                	sub    %eax,%edx
  80125f:	89 d0                	mov    %edx,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126f:	eb 12                	jmp    801283 <strchr+0x20>
		if (*s == c)
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801279:	75 05                	jne    801280 <strchr+0x1d>
			return (char *) s;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	eb 11                	jmp    801291 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e5                	jne    801271 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80129f:	eb 0d                	jmp    8012ae <strfind+0x1b>
		if (*s == c)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a9:	74 0e                	je     8012b9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 ea                	jne    8012a1 <strfind+0xe>
  8012b7:	eb 01                	jmp    8012ba <strfind+0x27>
		if (*s == c)
			break;
  8012b9:	90                   	nop
	return (char *) s;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012d1:	eb 0e                	jmp    8012e1 <memset+0x22>
		*p++ = c;
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012e1:	ff 4d f8             	decl   -0x8(%ebp)
  8012e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012e8:	79 e9                	jns    8012d3 <memset+0x14>
		*p++ = c;

	return v;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801301:	eb 16                	jmp    801319 <memcpy+0x2a>
		*d++ = *s++;
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	8d 50 01             	lea    0x1(%eax),%edx
  801309:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801312:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801315:	8a 12                	mov    (%edx),%dl
  801317:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 dd                	jne    801303 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801343:	73 50                	jae    801395 <memmove+0x6a>
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801350:	76 43                	jbe    801395 <memmove+0x6a>
		s += n;
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80135e:	eb 10                	jmp    801370 <memmove+0x45>
			*--d = *--s;
  801360:	ff 4d f8             	decl   -0x8(%ebp)
  801363:	ff 4d fc             	decl   -0x4(%ebp)
  801366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801369:	8a 10                	mov    (%eax),%dl
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	8d 50 ff             	lea    -0x1(%eax),%edx
  801376:	89 55 10             	mov    %edx,0x10(%ebp)
  801379:	85 c0                	test   %eax,%eax
  80137b:	75 e3                	jne    801360 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80137d:	eb 23                	jmp    8013a2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8d 50 01             	lea    0x1(%eax),%edx
  801385:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801391:	8a 12                	mov    (%edx),%dl
  801393:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139b:	89 55 10             	mov    %edx,0x10(%ebp)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	75 dd                	jne    80137f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b9:	eb 2a                	jmp    8013e5 <memcmp+0x3e>
		if (*s1 != *s2)
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	8a 10                	mov    (%eax),%dl
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 16                	je     8013df <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	0f b6 d0             	movzbl %al,%edx
  8013d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f b6 c0             	movzbl %al,%eax
  8013d9:	29 c2                	sub    %eax,%edx
  8013db:	89 d0                	mov    %edx,%eax
  8013dd:	eb 18                	jmp    8013f7 <memcmp+0x50>
		s1++, s2++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 c9                	jne    8013bb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80140a:	eb 15                	jmp    801421 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	39 c2                	cmp    %eax,%edx
  80141c:	74 0d                	je     80142b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141e:	ff 45 08             	incl   0x8(%ebp)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801427:	72 e3                	jb     80140c <memfind+0x13>
  801429:	eb 01                	jmp    80142c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80142b:	90                   	nop
	return (void *) s;
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80143e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801445:	eb 03                	jmp    80144a <strtol+0x19>
		s++;
  801447:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 20                	cmp    $0x20,%al
  801451:	74 f4                	je     801447 <strtol+0x16>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 09                	cmp    $0x9,%al
  80145a:	74 eb                	je     801447 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 2b                	cmp    $0x2b,%al
  801463:	75 05                	jne    80146a <strtol+0x39>
		s++;
  801465:	ff 45 08             	incl   0x8(%ebp)
  801468:	eb 13                	jmp    80147d <strtol+0x4c>
	else if (*s == '-')
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 2d                	cmp    $0x2d,%al
  801471:	75 0a                	jne    80147d <strtol+0x4c>
		s++, neg = 1;
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801481:	74 06                	je     801489 <strtol+0x58>
  801483:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801487:	75 20                	jne    8014a9 <strtol+0x78>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 30                	cmp    $0x30,%al
  801490:	75 17                	jne    8014a9 <strtol+0x78>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	40                   	inc    %eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	3c 78                	cmp    $0x78,%al
  80149a:	75 0d                	jne    8014a9 <strtol+0x78>
		s += 2, base = 16;
  80149c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014a0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a7:	eb 28                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ad:	75 15                	jne    8014c4 <strtol+0x93>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3c 30                	cmp    $0x30,%al
  8014b6:	75 0c                	jne    8014c4 <strtol+0x93>
		s++, base = 8;
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xa0>
		base = 10;
  8014ca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 2f                	cmp    $0x2f,%al
  8014d8:	7e 19                	jle    8014f3 <strtol+0xc2>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	3c 39                	cmp    $0x39,%al
  8014e1:	7f 10                	jg     8014f3 <strtol+0xc2>
			dig = *s - '0';
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	83 e8 30             	sub    $0x30,%eax
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f1:	eb 42                	jmp    801535 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 19                	jle    801515 <strtol+0xe4>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 7a                	cmp    $0x7a,%al
  801503:	7f 10                	jg     801515 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 57             	sub    $0x57,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801513:	eb 20                	jmp    801535 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 39                	jle    801557 <strtol+0x126>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 5a                	cmp    $0x5a,%al
  801525:	7f 30                	jg     801557 <strtol+0x126>
			dig = *s - 'A' + 10;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	83 e8 37             	sub    $0x37,%eax
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	3b 45 10             	cmp    0x10(%ebp),%eax
  80153b:	7d 19                	jge    801556 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80153d:	ff 45 08             	incl   0x8(%ebp)
  801540:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801543:	0f af 45 10          	imul   0x10(%ebp),%eax
  801547:	89 c2                	mov    %eax,%edx
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801551:	e9 7b ff ff ff       	jmp    8014d1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801556:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155b:	74 08                	je     801565 <strtol+0x134>
		*endptr = (char *) s;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801565:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801569:	74 07                	je     801572 <strtol+0x141>
  80156b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156e:	f7 d8                	neg    %eax
  801570:	eb 03                	jmp    801575 <strtol+0x144>
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <ltostr>:

void
ltostr(long value, char *str)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801584:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80158b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158f:	79 13                	jns    8015a4 <ltostr+0x2d>
	{
		neg = 1;
  801591:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80159e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015a1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ac:	99                   	cltd   
  8015ad:	f7 f9                	idiv   %ecx
  8015af:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b5:	8d 50 01             	lea    0x1(%eax),%edx
  8015b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c5:	83 c2 30             	add    $0x30,%edx
  8015c8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015d2:	f7 e9                	imul   %ecx
  8015d4:	c1 fa 02             	sar    $0x2,%edx
  8015d7:	89 c8                	mov    %ecx,%eax
  8015d9:	c1 f8 1f             	sar    $0x1f,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015eb:	f7 e9                	imul   %ecx
  8015ed:	c1 fa 02             	sar    $0x2,%edx
  8015f0:	89 c8                	mov    %ecx,%eax
  8015f2:	c1 f8 1f             	sar    $0x1f,%eax
  8015f5:	29 c2                	sub    %eax,%edx
  8015f7:	89 d0                	mov    %edx,%eax
  8015f9:	c1 e0 02             	shl    $0x2,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	01 c0                	add    %eax,%eax
  801600:	29 c1                	sub    %eax,%ecx
  801602:	89 ca                	mov    %ecx,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	75 9c                	jne    8015a4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	48                   	dec    %eax
  801613:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161a:	74 3d                	je     801659 <ltostr+0xe2>
		start = 1 ;
  80161c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801623:	eb 34                	jmp    801659 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 c8                	add    %ecx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801651:	88 02                	mov    %al,(%edx)
		start++ ;
  801653:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801656:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165f:	7c c4                	jl     801625 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801661:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 54 fa ff ff       	call   8010d1 <strlen>
  80167d:	83 c4 04             	add    $0x4,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 46 fa ff ff       	call   8010d1 <strlen>
  80168b:	83 c4 04             	add    $0x4,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169f:	eb 17                	jmp    8016b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	01 c2                	add    %eax,%edx
  8016a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	01 c8                	add    %ecx,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b5:	ff 45 fc             	incl   -0x4(%ebp)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016be:	7c e1                	jl     8016a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ce:	eb 1f                	jmp    8016ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ec:	ff 45 f8             	incl   -0x8(%ebp)
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f5:	7c d9                	jl     8016d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801728:	eb 0c                	jmp    801736 <strsplit+0x31>
			*string++ = 0;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8d 50 01             	lea    0x1(%eax),%edx
  801730:	89 55 08             	mov    %edx,0x8(%ebp)
  801733:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	84 c0                	test   %al,%al
  80173d:	74 18                	je     801757 <strsplit+0x52>
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f be c0             	movsbl %al,%eax
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	e8 13 fb ff ff       	call   801263 <strchr>
  801750:	83 c4 08             	add    $0x8,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	75 d3                	jne    80172a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 5a                	je     8017ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	83 f8 0f             	cmp    $0xf,%eax
  801768:	75 07                	jne    801771 <strsplit+0x6c>
		{
			return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 66                	jmp    8017d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8d 48 01             	lea    0x1(%eax),%ecx
  801779:	8b 55 14             	mov    0x14(%ebp),%edx
  80177c:	89 0a                	mov    %ecx,(%edx)
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 c2                	add    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178f:	eb 03                	jmp    801794 <strsplit+0x8f>
			string++;
  801791:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	74 8b                	je     801728 <strsplit+0x23>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	50                   	push   %eax
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 b5 fa ff ff       	call   801263 <strchr>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	74 dc                	je     801791 <strsplit+0x8c>
			string++;
	}
  8017b5:	e9 6e ff ff ff       	jmp    801728 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8017df:	a1 04 50 80 00       	mov    0x805004,%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	74 1f                	je     801807 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017e8:	e8 1d 00 00 00       	call   80180a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	68 70 3f 80 00       	push   $0x803f70
  8017f5:	e8 55 f2 ff ff       	call   800a4f <cprintf>
  8017fa:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017fd:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801810:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801817:	00 00 00 
  80181a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801821:	00 00 00 
  801824:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80182b:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80182e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801835:	00 00 00 
  801838:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80183f:	00 00 00 
  801842:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801849:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80184c:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801853:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801856:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80185d:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801867:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80186c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801871:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801876:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80187d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801880:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801885:	2d 00 10 00 00       	sub    $0x1000,%eax
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	6a 06                	push   $0x6
  80188f:	ff 75 f4             	pushl  -0xc(%ebp)
  801892:	50                   	push   %eax
  801893:	e8 ee 05 00 00       	call   801e86 <sys_allocate_chunk>
  801898:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80189b:	a1 20 51 80 00       	mov    0x805120,%eax
  8018a0:	83 ec 0c             	sub    $0xc,%esp
  8018a3:	50                   	push   %eax
  8018a4:	e8 63 0c 00 00       	call   80250c <initialize_MemBlocksList>
  8018a9:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8018ac:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8018b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8018b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b7:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8018be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018cf:	89 c2                	mov    %eax,%edx
  8018d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d4:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8018d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018da:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8018e1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8018e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018eb:	8b 50 08             	mov    0x8(%eax),%edx
  8018ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	48                   	dec    %eax
  8018f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ff:	f7 75 e0             	divl   -0x20(%ebp)
  801902:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801905:	29 d0                	sub    %edx,%eax
  801907:	89 c2                	mov    %eax,%edx
  801909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190c:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80190f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801913:	75 14                	jne    801929 <initialize_dyn_block_system+0x11f>
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	68 95 3f 80 00       	push   $0x803f95
  80191d:	6a 34                	push   $0x34
  80191f:	68 b3 3f 80 00       	push   $0x803fb3
  801924:	e8 72 ee ff ff       	call   80079b <_panic>
  801929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80192c:	8b 00                	mov    (%eax),%eax
  80192e:	85 c0                	test   %eax,%eax
  801930:	74 10                	je     801942 <initialize_dyn_block_system+0x138>
  801932:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801935:	8b 00                	mov    (%eax),%eax
  801937:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80193a:	8b 52 04             	mov    0x4(%edx),%edx
  80193d:	89 50 04             	mov    %edx,0x4(%eax)
  801940:	eb 0b                	jmp    80194d <initialize_dyn_block_system+0x143>
  801942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801945:	8b 40 04             	mov    0x4(%eax),%eax
  801948:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80194d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801950:	8b 40 04             	mov    0x4(%eax),%eax
  801953:	85 c0                	test   %eax,%eax
  801955:	74 0f                	je     801966 <initialize_dyn_block_system+0x15c>
  801957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195a:	8b 40 04             	mov    0x4(%eax),%eax
  80195d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801960:	8b 12                	mov    (%edx),%edx
  801962:	89 10                	mov    %edx,(%eax)
  801964:	eb 0a                	jmp    801970 <initialize_dyn_block_system+0x166>
  801966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801969:	8b 00                	mov    (%eax),%eax
  80196b:	a3 48 51 80 00       	mov    %eax,0x805148
  801970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801973:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80197c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801983:	a1 54 51 80 00       	mov    0x805154,%eax
  801988:	48                   	dec    %eax
  801989:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	e8 c4 13 00 00       	call   802d5d <insert_sorted_with_merge_freeList>
  801999:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <malloc>:
//=================================



void* malloc(uint32 size)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019a5:	e8 2f fe ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019ae:	75 07                	jne    8019b7 <malloc+0x18>
  8019b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b5:	eb 71                	jmp    801a28 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8019b7:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8019be:	76 07                	jbe    8019c7 <malloc+0x28>
	return NULL;
  8019c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c5:	eb 61                	jmp    801a28 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019c7:	e8 88 08 00 00       	call   802254 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	74 53                	je     801a23 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8019d0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8019d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019dd:	01 d0                	add    %edx,%eax
  8019df:	48                   	dec    %eax
  8019e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019eb:	f7 75 f4             	divl   -0xc(%ebp)
  8019ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f1:	29 d0                	sub    %edx,%eax
  8019f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	ff 75 ec             	pushl  -0x14(%ebp)
  8019fc:	e8 d2 0d 00 00       	call   8027d3 <alloc_block_FF>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801a07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a0b:	74 16                	je     801a23 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801a0d:	83 ec 0c             	sub    $0xc,%esp
  801a10:	ff 75 e8             	pushl  -0x18(%ebp)
  801a13:	e8 0c 0c 00 00       	call   802624 <insert_sorted_allocList>
  801a18:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1e:	8b 40 08             	mov    0x8(%eax),%eax
  801a21:	eb 05                	jmp    801a28 <malloc+0x89>
    }

			}


	return NULL;
  801a23:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801a41:	83 ec 08             	sub    $0x8,%esp
  801a44:	ff 75 f0             	pushl  -0x10(%ebp)
  801a47:	68 40 50 80 00       	push   $0x805040
  801a4c:	e8 a0 0b 00 00       	call   8025f1 <find_block>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a5a:	8b 50 0c             	mov    0xc(%eax),%edx
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	52                   	push   %edx
  801a64:	50                   	push   %eax
  801a65:	e8 e4 03 00 00       	call   801e4e <sys_free_user_mem>
  801a6a:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801a6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a71:	75 17                	jne    801a8a <free+0x60>
  801a73:	83 ec 04             	sub    $0x4,%esp
  801a76:	68 95 3f 80 00       	push   $0x803f95
  801a7b:	68 84 00 00 00       	push   $0x84
  801a80:	68 b3 3f 80 00       	push   $0x803fb3
  801a85:	e8 11 ed ff ff       	call   80079b <_panic>
  801a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8d:	8b 00                	mov    (%eax),%eax
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	74 10                	je     801aa3 <free+0x79>
  801a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a96:	8b 00                	mov    (%eax),%eax
  801a98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a9b:	8b 52 04             	mov    0x4(%edx),%edx
  801a9e:	89 50 04             	mov    %edx,0x4(%eax)
  801aa1:	eb 0b                	jmp    801aae <free+0x84>
  801aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa6:	8b 40 04             	mov    0x4(%eax),%eax
  801aa9:	a3 44 50 80 00       	mov    %eax,0x805044
  801aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab1:	8b 40 04             	mov    0x4(%eax),%eax
  801ab4:	85 c0                	test   %eax,%eax
  801ab6:	74 0f                	je     801ac7 <free+0x9d>
  801ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801abb:	8b 40 04             	mov    0x4(%eax),%eax
  801abe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ac1:	8b 12                	mov    (%edx),%edx
  801ac3:	89 10                	mov    %edx,(%eax)
  801ac5:	eb 0a                	jmp    801ad1 <free+0xa7>
  801ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aca:	8b 00                	mov    (%eax),%eax
  801acc:	a3 40 50 80 00       	mov    %eax,0x805040
  801ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801add:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ae4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ae9:	48                   	dec    %eax
  801aea:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801aef:	83 ec 0c             	sub    $0xc,%esp
  801af2:	ff 75 ec             	pushl  -0x14(%ebp)
  801af5:	e8 63 12 00 00       	call   802d5d <insert_sorted_with_merge_freeList>
  801afa:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 38             	sub    $0x38,%esp
  801b06:	8b 45 10             	mov    0x10(%ebp),%eax
  801b09:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b0c:	e8 c8 fc ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b15:	75 0a                	jne    801b21 <smalloc+0x21>
  801b17:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1c:	e9 a0 00 00 00       	jmp    801bc1 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801b21:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801b28:	76 0a                	jbe    801b34 <smalloc+0x34>
		return NULL;
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2f:	e9 8d 00 00 00       	jmp    801bc1 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b34:	e8 1b 07 00 00       	call   802254 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	74 7f                	je     801bbc <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b3d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4a:	01 d0                	add    %edx,%eax
  801b4c:	48                   	dec    %eax
  801b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b53:	ba 00 00 00 00       	mov    $0x0,%edx
  801b58:	f7 75 f4             	divl   -0xc(%ebp)
  801b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5e:	29 d0                	sub    %edx,%eax
  801b60:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801b63:	83 ec 0c             	sub    $0xc,%esp
  801b66:	ff 75 ec             	pushl  -0x14(%ebp)
  801b69:	e8 65 0c 00 00       	call   8027d3 <alloc_block_FF>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801b74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b78:	74 42                	je     801bbc <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	ff 75 e8             	pushl  -0x18(%ebp)
  801b80:	e8 9f 0a 00 00       	call   802624 <insert_sorted_allocList>
  801b85:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8b:	8b 40 08             	mov    0x8(%eax),%eax
  801b8e:	89 c2                	mov    %eax,%edx
  801b90:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	e8 38 04 00 00       	call   801fd9 <sys_createSharedObject>
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801ba7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bab:	79 07                	jns    801bb4 <smalloc+0xb4>
	    		  return NULL;
  801bad:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb2:	eb 0d                	jmp    801bc1 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801bb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bb7:	8b 40 08             	mov    0x8(%eax),%eax
  801bba:	eb 05                	jmp    801bc1 <smalloc+0xc1>


				}


		return NULL;
  801bbc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bc9:	e8 0b fc ff ff       	call   8017d9 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801bce:	e8 81 06 00 00       	call   802254 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	0f 84 9f 00 00 00    	je     801c7a <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801bdb:	83 ec 08             	sub    $0x8,%esp
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	ff 75 08             	pushl  0x8(%ebp)
  801be4:	e8 1a 04 00 00       	call   802003 <sys_getSizeOfSharedObject>
  801be9:	83 c4 10             	add    $0x10,%esp
  801bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bf3:	79 0a                	jns    801bff <sget+0x3c>
		return NULL;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfa:	e9 80 00 00 00       	jmp    801c7f <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801bff:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	48                   	dec    %eax
  801c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c15:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1a:	f7 75 f0             	divl   -0x10(%ebp)
  801c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c20:	29 d0                	sub    %edx,%eax
  801c22:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801c25:	83 ec 0c             	sub    $0xc,%esp
  801c28:	ff 75 e8             	pushl  -0x18(%ebp)
  801c2b:	e8 a3 0b 00 00       	call   8027d3 <alloc_block_FF>
  801c30:	83 c4 10             	add    $0x10,%esp
  801c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801c36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c3a:	74 3e                	je     801c7a <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801c3c:	83 ec 0c             	sub    $0xc,%esp
  801c3f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c42:	e8 dd 09 00 00       	call   802624 <insert_sorted_allocList>
  801c47:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c4d:	8b 40 08             	mov    0x8(%eax),%eax
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	50                   	push   %eax
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	e8 c1 03 00 00       	call   802020 <sys_getSharedObject>
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801c65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c69:	79 07                	jns    801c72 <sget+0xaf>
	    		  return NULL;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c70:	eb 0d                	jmp    801c7f <sget+0xbc>
	  	return(void*) returned_block->sva;
  801c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c75:	8b 40 08             	mov    0x8(%eax),%eax
  801c78:	eb 05                	jmp    801c7f <sget+0xbc>
	      }
	}
	   return NULL;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c87:	e8 4d fb ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	68 c0 3f 80 00       	push   $0x803fc0
  801c94:	68 12 01 00 00       	push   $0x112
  801c99:	68 b3 3f 80 00       	push   $0x803fb3
  801c9e:	e8 f8 ea ff ff       	call   80079b <_panic>

00801ca3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ca9:	83 ec 04             	sub    $0x4,%esp
  801cac:	68 e8 3f 80 00       	push   $0x803fe8
  801cb1:	68 26 01 00 00       	push   $0x126
  801cb6:	68 b3 3f 80 00       	push   $0x803fb3
  801cbb:	e8 db ea ff ff       	call   80079b <_panic>

00801cc0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	68 0c 40 80 00       	push   $0x80400c
  801cce:	68 31 01 00 00       	push   $0x131
  801cd3:	68 b3 3f 80 00       	push   $0x803fb3
  801cd8:	e8 be ea ff ff       	call   80079b <_panic>

00801cdd <shrink>:

}
void shrink(uint32 newSize)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	68 0c 40 80 00       	push   $0x80400c
  801ceb:	68 36 01 00 00       	push   $0x136
  801cf0:	68 b3 3f 80 00       	push   $0x803fb3
  801cf5:	e8 a1 ea ff ff       	call   80079b <_panic>

00801cfa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d00:	83 ec 04             	sub    $0x4,%esp
  801d03:	68 0c 40 80 00       	push   $0x80400c
  801d08:	68 3b 01 00 00       	push   $0x13b
  801d0d:	68 b3 3f 80 00       	push   $0x803fb3
  801d12:	e8 84 ea ff ff       	call   80079b <_panic>

00801d17 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	57                   	push   %edi
  801d1b:	56                   	push   %esi
  801d1c:	53                   	push   %ebx
  801d1d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d29:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d2c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d2f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d32:	cd 30                	int    $0x30
  801d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	5b                   	pop    %ebx
  801d3e:	5e                   	pop    %esi
  801d3f:	5f                   	pop    %edi
  801d40:	5d                   	pop    %ebp
  801d41:	c3                   	ret    

00801d42 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d4e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	52                   	push   %edx
  801d5a:	ff 75 0c             	pushl  0xc(%ebp)
  801d5d:	50                   	push   %eax
  801d5e:	6a 00                	push   $0x0
  801d60:	e8 b2 ff ff ff       	call   801d17 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	90                   	nop
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_cgetc>:

int
sys_cgetc(void)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 01                	push   $0x1
  801d7a:	e8 98 ff ff ff       	call   801d17 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	52                   	push   %edx
  801d94:	50                   	push   %eax
  801d95:	6a 05                	push   $0x5
  801d97:	e8 7b ff ff ff       	call   801d17 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	56                   	push   %esi
  801da5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801da6:	8b 75 18             	mov    0x18(%ebp),%esi
  801da9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	56                   	push   %esi
  801db6:	53                   	push   %ebx
  801db7:	51                   	push   %ecx
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	6a 06                	push   $0x6
  801dbc:	e8 56 ff ff ff       	call   801d17 <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	52                   	push   %edx
  801ddb:	50                   	push   %eax
  801ddc:	6a 07                	push   $0x7
  801dde:	e8 34 ff ff ff       	call   801d17 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	ff 75 0c             	pushl  0xc(%ebp)
  801df4:	ff 75 08             	pushl  0x8(%ebp)
  801df7:	6a 08                	push   $0x8
  801df9:	e8 19 ff ff ff       	call   801d17 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 09                	push   $0x9
  801e12:	e8 00 ff ff ff       	call   801d17 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 0a                	push   $0xa
  801e2b:	e8 e7 fe ff ff       	call   801d17 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 0b                	push   $0xb
  801e44:	e8 ce fe ff ff       	call   801d17 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	ff 75 0c             	pushl  0xc(%ebp)
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 0f                	push   $0xf
  801e5f:	e8 b3 fe ff ff       	call   801d17 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	ff 75 0c             	pushl  0xc(%ebp)
  801e76:	ff 75 08             	pushl  0x8(%ebp)
  801e79:	6a 10                	push   $0x10
  801e7b:	e8 97 fe ff ff       	call   801d17 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
	return ;
  801e83:	90                   	nop
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	ff 75 10             	pushl  0x10(%ebp)
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	6a 11                	push   $0x11
  801e98:	e8 7a fe ff ff       	call   801d17 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea0:	90                   	nop
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 0c                	push   $0xc
  801eb2:	e8 60 fe ff ff       	call   801d17 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	ff 75 08             	pushl  0x8(%ebp)
  801eca:	6a 0d                	push   $0xd
  801ecc:	e8 46 fe ff ff       	call   801d17 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 0e                	push   $0xe
  801ee5:	e8 2d fe ff ff       	call   801d17 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	90                   	nop
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 13                	push   $0x13
  801eff:	e8 13 fe ff ff       	call   801d17 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	90                   	nop
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 14                	push   $0x14
  801f19:	e8 f9 fd ff ff       	call   801d17 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	90                   	nop
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 04             	sub    $0x4,%esp
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	50                   	push   %eax
  801f3d:	6a 15                	push   $0x15
  801f3f:	e8 d3 fd ff ff       	call   801d17 <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
}
  801f47:	90                   	nop
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 16                	push   $0x16
  801f59:	e8 b9 fd ff ff       	call   801d17 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	90                   	nop
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	ff 75 0c             	pushl  0xc(%ebp)
  801f73:	50                   	push   %eax
  801f74:	6a 17                	push   $0x17
  801f76:	e8 9c fd ff ff       	call   801d17 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	52                   	push   %edx
  801f90:	50                   	push   %eax
  801f91:	6a 1a                	push   $0x1a
  801f93:	e8 7f fd ff ff       	call   801d17 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	52                   	push   %edx
  801fad:	50                   	push   %eax
  801fae:	6a 18                	push   $0x18
  801fb0:	e8 62 fd ff ff       	call   801d17 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	90                   	nop
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	52                   	push   %edx
  801fcb:	50                   	push   %eax
  801fcc:	6a 19                	push   $0x19
  801fce:	e8 44 fd ff ff       	call   801d17 <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
}
  801fd6:	90                   	nop
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fe5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fe8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	6a 00                	push   $0x0
  801ff1:	51                   	push   %ecx
  801ff2:	52                   	push   %edx
  801ff3:	ff 75 0c             	pushl  0xc(%ebp)
  801ff6:	50                   	push   %eax
  801ff7:	6a 1b                	push   $0x1b
  801ff9:	e8 19 fd ff ff       	call   801d17 <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802006:	8b 55 0c             	mov    0xc(%ebp),%edx
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	52                   	push   %edx
  802013:	50                   	push   %eax
  802014:	6a 1c                	push   $0x1c
  802016:	e8 fc fc ff ff       	call   801d17 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802023:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802026:	8b 55 0c             	mov    0xc(%ebp),%edx
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	51                   	push   %ecx
  802031:	52                   	push   %edx
  802032:	50                   	push   %eax
  802033:	6a 1d                	push   $0x1d
  802035:	e8 dd fc ff ff       	call   801d17 <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802042:	8b 55 0c             	mov    0xc(%ebp),%edx
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	52                   	push   %edx
  80204f:	50                   	push   %eax
  802050:	6a 1e                	push   $0x1e
  802052:	e8 c0 fc ff ff       	call   801d17 <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 1f                	push   $0x1f
  80206b:	e8 a7 fc ff ff       	call   801d17 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	6a 00                	push   $0x0
  80207d:	ff 75 14             	pushl  0x14(%ebp)
  802080:	ff 75 10             	pushl  0x10(%ebp)
  802083:	ff 75 0c             	pushl  0xc(%ebp)
  802086:	50                   	push   %eax
  802087:	6a 20                	push   $0x20
  802089:	e8 89 fc ff ff       	call   801d17 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	50                   	push   %eax
  8020a2:	6a 21                	push   $0x21
  8020a4:	e8 6e fc ff ff       	call   801d17 <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	90                   	nop
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	50                   	push   %eax
  8020be:	6a 22                	push   $0x22
  8020c0:	e8 52 fc ff ff       	call   801d17 <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 02                	push   $0x2
  8020d9:	e8 39 fc ff ff       	call   801d17 <syscall>
  8020de:	83 c4 18             	add    $0x18,%esp
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 03                	push   $0x3
  8020f2:	e8 20 fc ff ff       	call   801d17 <syscall>
  8020f7:	83 c4 18             	add    $0x18,%esp
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 04                	push   $0x4
  80210b:	e8 07 fc ff ff       	call   801d17 <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <sys_exit_env>:


void sys_exit_env(void)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 23                	push   $0x23
  802124:	e8 ee fb ff ff       	call   801d17 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	90                   	nop
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802135:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802138:	8d 50 04             	lea    0x4(%eax),%edx
  80213b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	52                   	push   %edx
  802145:	50                   	push   %eax
  802146:	6a 24                	push   $0x24
  802148:	e8 ca fb ff ff       	call   801d17 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
	return result;
  802150:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802153:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802156:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802159:	89 01                	mov    %eax,(%ecx)
  80215b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	c9                   	leave  
  802162:	c2 04 00             	ret    $0x4

00802165 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	ff 75 10             	pushl  0x10(%ebp)
  80216f:	ff 75 0c             	pushl  0xc(%ebp)
  802172:	ff 75 08             	pushl  0x8(%ebp)
  802175:	6a 12                	push   $0x12
  802177:	e8 9b fb ff ff       	call   801d17 <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
	return ;
  80217f:	90                   	nop
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_rcr2>:
uint32 sys_rcr2()
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 25                	push   $0x25
  802191:	e8 81 fb ff ff       	call   801d17 <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 04             	sub    $0x4,%esp
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021a7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	50                   	push   %eax
  8021b4:	6a 26                	push   $0x26
  8021b6:	e8 5c fb ff ff       	call   801d17 <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021be:	90                   	nop
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <rsttst>:
void rsttst()
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 28                	push   $0x28
  8021d0:	e8 42 fb ff ff       	call   801d17 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d8:	90                   	nop
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021e7:	8b 55 18             	mov    0x18(%ebp),%edx
  8021ea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021ee:	52                   	push   %edx
  8021ef:	50                   	push   %eax
  8021f0:	ff 75 10             	pushl  0x10(%ebp)
  8021f3:	ff 75 0c             	pushl  0xc(%ebp)
  8021f6:	ff 75 08             	pushl  0x8(%ebp)
  8021f9:	6a 27                	push   $0x27
  8021fb:	e8 17 fb ff ff       	call   801d17 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
	return ;
  802203:	90                   	nop
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <chktst>:
void chktst(uint32 n)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	ff 75 08             	pushl  0x8(%ebp)
  802214:	6a 29                	push   $0x29
  802216:	e8 fc fa ff ff       	call   801d17 <syscall>
  80221b:	83 c4 18             	add    $0x18,%esp
	return ;
  80221e:	90                   	nop
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <inctst>:

void inctst()
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 2a                	push   $0x2a
  802230:	e8 e2 fa ff ff       	call   801d17 <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
	return ;
  802238:	90                   	nop
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <gettst>:
uint32 gettst()
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 2b                	push   $0x2b
  80224a:	e8 c8 fa ff ff       	call   801d17 <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 2c                	push   $0x2c
  802266:	e8 ac fa ff ff       	call   801d17 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
  80226e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802271:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802275:	75 07                	jne    80227e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802277:	b8 01 00 00 00       	mov    $0x1,%eax
  80227c:	eb 05                	jmp    802283 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80227e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 2c                	push   $0x2c
  802297:	e8 7b fa ff ff       	call   801d17 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
  80229f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022a2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022a6:	75 07                	jne    8022af <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ad:	eb 05                	jmp    8022b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 2c                	push   $0x2c
  8022c8:	e8 4a fa ff ff       	call   801d17 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
  8022d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022d3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022d7:	75 07                	jne    8022e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022de:	eb 05                	jmp    8022e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
  8022ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 2c                	push   $0x2c
  8022f9:	e8 19 fa ff ff       	call   801d17 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
  802301:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802304:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802308:	75 07                	jne    802311 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80230a:	b8 01 00 00 00       	mov    $0x1,%eax
  80230f:	eb 05                	jmp    802316 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	ff 75 08             	pushl  0x8(%ebp)
  802326:	6a 2d                	push   $0x2d
  802328:	e8 ea f9 ff ff       	call   801d17 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
	return ;
  802330:	90                   	nop
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802337:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80233a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80233d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	6a 00                	push   $0x0
  802345:	53                   	push   %ebx
  802346:	51                   	push   %ecx
  802347:	52                   	push   %edx
  802348:	50                   	push   %eax
  802349:	6a 2e                	push   $0x2e
  80234b:	e8 c7 f9 ff ff       	call   801d17 <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
}
  802353:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80235b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	52                   	push   %edx
  802368:	50                   	push   %eax
  802369:	6a 2f                	push   $0x2f
  80236b:	e8 a7 f9 ff ff       	call   801d17 <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80237b:	83 ec 0c             	sub    $0xc,%esp
  80237e:	68 1c 40 80 00       	push   $0x80401c
  802383:	e8 c7 e6 ff ff       	call   800a4f <cprintf>
  802388:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80238b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802392:	83 ec 0c             	sub    $0xc,%esp
  802395:	68 48 40 80 00       	push   $0x804048
  80239a:	e8 b0 e6 ff ff       	call   800a4f <cprintf>
  80239f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023a2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8023ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ae:	eb 56                	jmp    802406 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b4:	74 1c                	je     8023d2 <print_mem_block_lists+0x5d>
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 50 08             	mov    0x8(%eax),%edx
  8023bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8023c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c8:	01 c8                	add    %ecx,%eax
  8023ca:	39 c2                	cmp    %eax,%edx
  8023cc:	73 04                	jae    8023d2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023ce:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 50 08             	mov    0x8(%eax),%edx
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 40 0c             	mov    0xc(%eax),%eax
  8023de:	01 c2                	add    %eax,%edx
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 40 08             	mov    0x8(%eax),%eax
  8023e6:	83 ec 04             	sub    $0x4,%esp
  8023e9:	52                   	push   %edx
  8023ea:	50                   	push   %eax
  8023eb:	68 5d 40 80 00       	push   $0x80405d
  8023f0:	e8 5a e6 ff ff       	call   800a4f <cprintf>
  8023f5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240a:	74 07                	je     802413 <print_mem_block_lists+0x9e>
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	eb 05                	jmp    802418 <print_mem_block_lists+0xa3>
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
  802418:	a3 40 51 80 00       	mov    %eax,0x805140
  80241d:	a1 40 51 80 00       	mov    0x805140,%eax
  802422:	85 c0                	test   %eax,%eax
  802424:	75 8a                	jne    8023b0 <print_mem_block_lists+0x3b>
  802426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242a:	75 84                	jne    8023b0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80242c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802430:	75 10                	jne    802442 <print_mem_block_lists+0xcd>
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	68 6c 40 80 00       	push   $0x80406c
  80243a:	e8 10 e6 ff ff       	call   800a4f <cprintf>
  80243f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802442:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	68 90 40 80 00       	push   $0x804090
  802451:	e8 f9 e5 ff ff       	call   800a4f <cprintf>
  802456:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802459:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80245d:	a1 40 50 80 00       	mov    0x805040,%eax
  802462:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802465:	eb 56                	jmp    8024bd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246b:	74 1c                	je     802489 <print_mem_block_lists+0x114>
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 50 08             	mov    0x8(%eax),%edx
  802473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802476:	8b 48 08             	mov    0x8(%eax),%ecx
  802479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247c:	8b 40 0c             	mov    0xc(%eax),%eax
  80247f:	01 c8                	add    %ecx,%eax
  802481:	39 c2                	cmp    %eax,%edx
  802483:	73 04                	jae    802489 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802485:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 50 08             	mov    0x8(%eax),%edx
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 0c             	mov    0xc(%eax),%eax
  802495:	01 c2                	add    %eax,%edx
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 40 08             	mov    0x8(%eax),%eax
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	52                   	push   %edx
  8024a1:	50                   	push   %eax
  8024a2:	68 5d 40 80 00       	push   $0x80405d
  8024a7:	e8 a3 e5 ff ff       	call   800a4f <cprintf>
  8024ac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8024ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c1:	74 07                	je     8024ca <print_mem_block_lists+0x155>
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	eb 05                	jmp    8024cf <print_mem_block_lists+0x15a>
  8024ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cf:	a3 48 50 80 00       	mov    %eax,0x805048
  8024d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 8a                	jne    802467 <print_mem_block_lists+0xf2>
  8024dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e1:	75 84                	jne    802467 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024e3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024e7:	75 10                	jne    8024f9 <print_mem_block_lists+0x184>
  8024e9:	83 ec 0c             	sub    $0xc,%esp
  8024ec:	68 a8 40 80 00       	push   $0x8040a8
  8024f1:	e8 59 e5 ff ff       	call   800a4f <cprintf>
  8024f6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024f9:	83 ec 0c             	sub    $0xc,%esp
  8024fc:	68 1c 40 80 00       	push   $0x80401c
  802501:	e8 49 e5 ff ff       	call   800a4f <cprintf>
  802506:	83 c4 10             	add    $0x10,%esp

}
  802509:	90                   	nop
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802512:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802519:	00 00 00 
  80251c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802523:	00 00 00 
  802526:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80252d:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802530:	a1 50 50 80 00       	mov    0x805050,%eax
  802535:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802538:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80253f:	e9 9e 00 00 00       	jmp    8025e2 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802544:	a1 50 50 80 00       	mov    0x805050,%eax
  802549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254c:	c1 e2 04             	shl    $0x4,%edx
  80254f:	01 d0                	add    %edx,%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	75 14                	jne    802569 <initialize_MemBlocksList+0x5d>
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	68 d0 40 80 00       	push   $0x8040d0
  80255d:	6a 48                	push   $0x48
  80255f:	68 f3 40 80 00       	push   $0x8040f3
  802564:	e8 32 e2 ff ff       	call   80079b <_panic>
  802569:	a1 50 50 80 00       	mov    0x805050,%eax
  80256e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802571:	c1 e2 04             	shl    $0x4,%edx
  802574:	01 d0                	add    %edx,%eax
  802576:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80257c:	89 10                	mov    %edx,(%eax)
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	74 18                	je     80259c <initialize_MemBlocksList+0x90>
  802584:	a1 48 51 80 00       	mov    0x805148,%eax
  802589:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80258f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802592:	c1 e1 04             	shl    $0x4,%ecx
  802595:	01 ca                	add    %ecx,%edx
  802597:	89 50 04             	mov    %edx,0x4(%eax)
  80259a:	eb 12                	jmp    8025ae <initialize_MemBlocksList+0xa2>
  80259c:	a1 50 50 80 00       	mov    0x805050,%eax
  8025a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a4:	c1 e2 04             	shl    $0x4,%edx
  8025a7:	01 d0                	add    %edx,%eax
  8025a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8025b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b6:	c1 e2 04             	shl    $0x4,%edx
  8025b9:	01 d0                	add    %edx,%eax
  8025bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8025c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8025c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c8:	c1 e2 04             	shl    $0x4,%edx
  8025cb:	01 d0                	add    %edx,%eax
  8025cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d9:	40                   	inc    %eax
  8025da:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8025df:	ff 45 f4             	incl   -0xc(%ebp)
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e8:	0f 82 56 ff ff ff    	jb     802544 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8025ee:	90                   	nop
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  8025ff:	eb 18                	jmp    802619 <find_block+0x28>
		{
			if(tmp->sva==va)
  802601:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802604:	8b 40 08             	mov    0x8(%eax),%eax
  802607:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80260a:	75 05                	jne    802611 <find_block+0x20>
			{
				return tmp;
  80260c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260f:	eb 11                	jmp    802622 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802611:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802619:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80261d:	75 e2                	jne    802601 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80261f:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80262a:	a1 40 50 80 00       	mov    0x805040,%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	0f 85 83 00 00 00    	jne    8026ba <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802637:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80263e:	00 00 00 
  802641:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802648:	00 00 00 
  80264b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802652:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802655:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802659:	75 14                	jne    80266f <insert_sorted_allocList+0x4b>
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 d0 40 80 00       	push   $0x8040d0
  802663:	6a 7f                	push   $0x7f
  802665:	68 f3 40 80 00       	push   $0x8040f3
  80266a:	e8 2c e1 ff ff       	call   80079b <_panic>
  80266f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802675:	8b 45 08             	mov    0x8(%ebp),%eax
  802678:	89 10                	mov    %edx,(%eax)
  80267a:	8b 45 08             	mov    0x8(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	85 c0                	test   %eax,%eax
  802681:	74 0d                	je     802690 <insert_sorted_allocList+0x6c>
  802683:	a1 40 50 80 00       	mov    0x805040,%eax
  802688:	8b 55 08             	mov    0x8(%ebp),%edx
  80268b:	89 50 04             	mov    %edx,0x4(%eax)
  80268e:	eb 08                	jmp    802698 <insert_sorted_allocList+0x74>
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	a3 44 50 80 00       	mov    %eax,0x805044
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	a3 40 50 80 00       	mov    %eax,0x805040
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026aa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026af:	40                   	inc    %eax
  8026b0:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8026b5:	e9 16 01 00 00       	jmp    8027d0 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	8b 50 08             	mov    0x8(%eax),%edx
  8026c0:	a1 44 50 80 00       	mov    0x805044,%eax
  8026c5:	8b 40 08             	mov    0x8(%eax),%eax
  8026c8:	39 c2                	cmp    %eax,%edx
  8026ca:	76 68                	jbe    802734 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8026cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d0:	75 17                	jne    8026e9 <insert_sorted_allocList+0xc5>
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	68 0c 41 80 00       	push   $0x80410c
  8026da:	68 85 00 00 00       	push   $0x85
  8026df:	68 f3 40 80 00       	push   $0x8040f3
  8026e4:	e8 b2 e0 ff ff       	call   80079b <_panic>
  8026e9:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	89 50 04             	mov    %edx,0x4(%eax)
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	8b 40 04             	mov    0x4(%eax),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 0c                	je     80270b <insert_sorted_allocList+0xe7>
  8026ff:	a1 44 50 80 00       	mov    0x805044,%eax
  802704:	8b 55 08             	mov    0x8(%ebp),%edx
  802707:	89 10                	mov    %edx,(%eax)
  802709:	eb 08                	jmp    802713 <insert_sorted_allocList+0xef>
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	a3 40 50 80 00       	mov    %eax,0x805040
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	a3 44 50 80 00       	mov    %eax,0x805044
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802724:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802729:	40                   	inc    %eax
  80272a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80272f:	e9 9c 00 00 00       	jmp    8027d0 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802734:	a1 40 50 80 00       	mov    0x805040,%eax
  802739:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80273c:	e9 85 00 00 00       	jmp    8027c6 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	8b 50 08             	mov    0x8(%eax),%edx
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 08             	mov    0x8(%eax),%eax
  80274d:	39 c2                	cmp    %eax,%edx
  80274f:	73 6d                	jae    8027be <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802755:	74 06                	je     80275d <insert_sorted_allocList+0x139>
  802757:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275b:	75 17                	jne    802774 <insert_sorted_allocList+0x150>
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	68 30 41 80 00       	push   $0x804130
  802765:	68 90 00 00 00       	push   $0x90
  80276a:	68 f3 40 80 00       	push   $0x8040f3
  80276f:	e8 27 e0 ff ff       	call   80079b <_panic>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 50 04             	mov    0x4(%eax),%edx
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	89 50 04             	mov    %edx,0x4(%eax)
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802786:	89 10                	mov    %edx,(%eax)
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 0d                	je     80279f <insert_sorted_allocList+0x17b>
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	8b 55 08             	mov    0x8(%ebp),%edx
  80279b:	89 10                	mov    %edx,(%eax)
  80279d:	eb 08                	jmp    8027a7 <insert_sorted_allocList+0x183>
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	a3 40 50 80 00       	mov    %eax,0x805040
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ad:	89 50 04             	mov    %edx,0x4(%eax)
  8027b0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027b5:	40                   	inc    %eax
  8027b6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027bb:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8027bc:	eb 12                	jmp    8027d0 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8027c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ca:	0f 85 71 ff ff ff    	jne    802741 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8027d0:	90                   	nop
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8027d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8027de:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8027e1:	e9 76 01 00 00       	jmp    80295c <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ef:	0f 85 8a 00 00 00    	jne    80287f <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  8027f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f9:	75 17                	jne    802812 <alloc_block_FF+0x3f>
  8027fb:	83 ec 04             	sub    $0x4,%esp
  8027fe:	68 65 41 80 00       	push   $0x804165
  802803:	68 a8 00 00 00       	push   $0xa8
  802808:	68 f3 40 80 00       	push   $0x8040f3
  80280d:	e8 89 df ff ff       	call   80079b <_panic>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 10                	je     80282b <alloc_block_FF+0x58>
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802823:	8b 52 04             	mov    0x4(%edx),%edx
  802826:	89 50 04             	mov    %edx,0x4(%eax)
  802829:	eb 0b                	jmp    802836 <alloc_block_FF+0x63>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 40 04             	mov    0x4(%eax),%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	74 0f                	je     80284f <alloc_block_FF+0x7c>
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 04             	mov    0x4(%eax),%eax
  802846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802849:	8b 12                	mov    (%edx),%edx
  80284b:	89 10                	mov    %edx,(%eax)
  80284d:	eb 0a                	jmp    802859 <alloc_block_FF+0x86>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	a3 38 51 80 00       	mov    %eax,0x805138
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286c:	a1 44 51 80 00       	mov    0x805144,%eax
  802871:	48                   	dec    %eax
  802872:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	e9 ea 00 00 00       	jmp    802969 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 0c             	mov    0xc(%eax),%eax
  802885:	3b 45 08             	cmp    0x8(%ebp),%eax
  802888:	0f 86 c6 00 00 00    	jbe    802954 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80288e:	a1 48 51 80 00       	mov    0x805148,%eax
  802893:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	8b 55 08             	mov    0x8(%ebp),%edx
  80289c:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 50 08             	mov    0x8(%eax),%edx
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b4:	89 c2                	mov    %eax,%edx
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 50 08             	mov    0x8(%eax),%edx
  8028c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c5:	01 c2                	add    %eax,%edx
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8028cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028d1:	75 17                	jne    8028ea <alloc_block_FF+0x117>
  8028d3:	83 ec 04             	sub    $0x4,%esp
  8028d6:	68 65 41 80 00       	push   $0x804165
  8028db:	68 b6 00 00 00       	push   $0xb6
  8028e0:	68 f3 40 80 00       	push   $0x8040f3
  8028e5:	e8 b1 de ff ff       	call   80079b <_panic>
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	74 10                	je     802903 <alloc_block_FF+0x130>
  8028f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028fb:	8b 52 04             	mov    0x4(%edx),%edx
  8028fe:	89 50 04             	mov    %edx,0x4(%eax)
  802901:	eb 0b                	jmp    80290e <alloc_block_FF+0x13b>
  802903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802906:	8b 40 04             	mov    0x4(%eax),%eax
  802909:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80290e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 0f                	je     802927 <alloc_block_FF+0x154>
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	8b 40 04             	mov    0x4(%eax),%eax
  80291e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802921:	8b 12                	mov    (%edx),%edx
  802923:	89 10                	mov    %edx,(%eax)
  802925:	eb 0a                	jmp    802931 <alloc_block_FF+0x15e>
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	a3 48 51 80 00       	mov    %eax,0x805148
  802931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802934:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802944:	a1 54 51 80 00       	mov    0x805154,%eax
  802949:	48                   	dec    %eax
  80294a:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	eb 15                	jmp    802969 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80295c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802960:	0f 85 80 fe ff ff    	jne    8027e6 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802971:	a1 38 51 80 00       	mov    0x805138,%eax
  802976:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802979:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802980:	e9 c0 00 00 00       	jmp    802a45 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 40 0c             	mov    0xc(%eax),%eax
  80298b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298e:	0f 85 8a 00 00 00    	jne    802a1e <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802994:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802998:	75 17                	jne    8029b1 <alloc_block_BF+0x46>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 65 41 80 00       	push   $0x804165
  8029a2:	68 cf 00 00 00       	push   $0xcf
  8029a7:	68 f3 40 80 00       	push   $0x8040f3
  8029ac:	e8 ea dd ff ff       	call   80079b <_panic>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 10                	je     8029ca <alloc_block_BF+0x5f>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c2:	8b 52 04             	mov    0x4(%edx),%edx
  8029c5:	89 50 04             	mov    %edx,0x4(%eax)
  8029c8:	eb 0b                	jmp    8029d5 <alloc_block_BF+0x6a>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 0f                	je     8029ee <alloc_block_BF+0x83>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e8:	8b 12                	mov    (%edx),%edx
  8029ea:	89 10                	mov    %edx,(%eax)
  8029ec:	eb 0a                	jmp    8029f8 <alloc_block_BF+0x8d>
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0b:	a1 44 51 80 00       	mov    0x805144,%eax
  802a10:	48                   	dec    %eax
  802a11:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	e9 2a 01 00 00       	jmp    802b48 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 40 0c             	mov    0xc(%eax),%eax
  802a24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a27:	73 14                	jae    802a3d <alloc_block_BF+0xd2>
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a32:	76 09                	jbe    802a3d <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a49:	0f 85 36 ff ff ff    	jne    802985 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802a4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802a57:	e9 dd 00 00 00       	jmp    802b39 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a65:	0f 85 c6 00 00 00    	jne    802b31 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802a6b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a70:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 50 08             	mov    0x8(%eax),%edx
  802a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7c:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a82:	8b 55 08             	mov    0x8(%ebp),%edx
  802a85:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 50 08             	mov    0x8(%eax),%edx
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	01 c2                	add    %eax,%edx
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9f:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa2:	89 c2                	mov    %eax,%edx
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802aaa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aae:	75 17                	jne    802ac7 <alloc_block_BF+0x15c>
  802ab0:	83 ec 04             	sub    $0x4,%esp
  802ab3:	68 65 41 80 00       	push   $0x804165
  802ab8:	68 eb 00 00 00       	push   $0xeb
  802abd:	68 f3 40 80 00       	push   $0x8040f3
  802ac2:	e8 d4 dc ff ff       	call   80079b <_panic>
  802ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aca:	8b 00                	mov    (%eax),%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	74 10                	je     802ae0 <alloc_block_BF+0x175>
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	8b 00                	mov    (%eax),%eax
  802ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad8:	8b 52 04             	mov    0x4(%edx),%edx
  802adb:	89 50 04             	mov    %edx,0x4(%eax)
  802ade:	eb 0b                	jmp    802aeb <alloc_block_BF+0x180>
  802ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae3:	8b 40 04             	mov    0x4(%eax),%eax
  802ae6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aee:	8b 40 04             	mov    0x4(%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 0f                	je     802b04 <alloc_block_BF+0x199>
  802af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802afe:	8b 12                	mov    (%edx),%edx
  802b00:	89 10                	mov    %edx,(%eax)
  802b02:	eb 0a                	jmp    802b0e <alloc_block_BF+0x1a3>
  802b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	a3 48 51 80 00       	mov    %eax,0x805148
  802b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b21:	a1 54 51 80 00       	mov    0x805154,%eax
  802b26:	48                   	dec    %eax
  802b27:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2f:	eb 17                	jmp    802b48 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3d:	0f 85 19 ff ff ff    	jne    802a5c <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802b43:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802b48:	c9                   	leave  
  802b49:	c3                   	ret    

00802b4a <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802b4a:	55                   	push   %ebp
  802b4b:	89 e5                	mov    %esp,%ebp
  802b4d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802b50:	a1 40 50 80 00       	mov    0x805040,%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	75 19                	jne    802b72 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802b59:	83 ec 0c             	sub    $0xc,%esp
  802b5c:	ff 75 08             	pushl  0x8(%ebp)
  802b5f:	e8 6f fc ff ff       	call   8027d3 <alloc_block_FF>
  802b64:	83 c4 10             	add    $0x10,%esp
  802b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	e9 e9 01 00 00       	jmp    802d5b <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802b72:	a1 44 50 80 00       	mov    0x805044,%eax
  802b77:	8b 40 08             	mov    0x8(%eax),%eax
  802b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802b7d:	a1 44 50 80 00       	mov    0x805044,%eax
  802b82:	8b 50 0c             	mov    0xc(%eax),%edx
  802b85:	a1 44 50 80 00       	mov    0x805044,%eax
  802b8a:	8b 40 08             	mov    0x8(%eax),%eax
  802b8d:	01 d0                	add    %edx,%eax
  802b8f:	83 ec 08             	sub    $0x8,%esp
  802b92:	50                   	push   %eax
  802b93:	68 38 51 80 00       	push   $0x805138
  802b98:	e8 54 fa ff ff       	call   8025f1 <find_block>
  802b9d:	83 c4 10             	add    $0x10,%esp
  802ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bac:	0f 85 9b 00 00 00    	jne    802c4d <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 08             	mov    0x8(%eax),%eax
  802bbe:	01 d0                	add    %edx,%eax
  802bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc7:	75 17                	jne    802be0 <alloc_block_NF+0x96>
  802bc9:	83 ec 04             	sub    $0x4,%esp
  802bcc:	68 65 41 80 00       	push   $0x804165
  802bd1:	68 1a 01 00 00       	push   $0x11a
  802bd6:	68 f3 40 80 00       	push   $0x8040f3
  802bdb:	e8 bb db ff ff       	call   80079b <_panic>
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	85 c0                	test   %eax,%eax
  802be7:	74 10                	je     802bf9 <alloc_block_NF+0xaf>
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf1:	8b 52 04             	mov    0x4(%edx),%edx
  802bf4:	89 50 04             	mov    %edx,0x4(%eax)
  802bf7:	eb 0b                	jmp    802c04 <alloc_block_NF+0xba>
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 40 04             	mov    0x4(%eax),%eax
  802bff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	74 0f                	je     802c1d <alloc_block_NF+0xd3>
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c17:	8b 12                	mov    (%edx),%edx
  802c19:	89 10                	mov    %edx,(%eax)
  802c1b:	eb 0a                	jmp    802c27 <alloc_block_NF+0xdd>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	a3 38 51 80 00       	mov    %eax,0x805138
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c3f:	48                   	dec    %eax
  802c40:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	e9 0e 01 00 00       	jmp    802d5b <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 0c             	mov    0xc(%eax),%eax
  802c53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c56:	0f 86 cf 00 00 00    	jbe    802d2b <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802c5c:	a1 48 51 80 00       	mov    0x805148,%eax
  802c61:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802c64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c67:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6a:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 50 08             	mov    0x8(%eax),%edx
  802c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c76:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 50 08             	mov    0x8(%eax),%edx
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	01 c2                	add    %eax,%edx
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	2b 45 08             	sub    0x8(%ebp),%eax
  802c93:	89 c2                	mov    %eax,%edx
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802ca4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ca8:	75 17                	jne    802cc1 <alloc_block_NF+0x177>
  802caa:	83 ec 04             	sub    $0x4,%esp
  802cad:	68 65 41 80 00       	push   $0x804165
  802cb2:	68 28 01 00 00       	push   $0x128
  802cb7:	68 f3 40 80 00       	push   $0x8040f3
  802cbc:	e8 da da ff ff       	call   80079b <_panic>
  802cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 10                	je     802cda <alloc_block_NF+0x190>
  802cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cd2:	8b 52 04             	mov    0x4(%edx),%edx
  802cd5:	89 50 04             	mov    %edx,0x4(%eax)
  802cd8:	eb 0b                	jmp    802ce5 <alloc_block_NF+0x19b>
  802cda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce8:	8b 40 04             	mov    0x4(%eax),%eax
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	74 0f                	je     802cfe <alloc_block_NF+0x1b4>
  802cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cf8:	8b 12                	mov    (%edx),%edx
  802cfa:	89 10                	mov    %edx,(%eax)
  802cfc:	eb 0a                	jmp    802d08 <alloc_block_NF+0x1be>
  802cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	a3 48 51 80 00       	mov    %eax,0x805148
  802d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d20:	48                   	dec    %eax
  802d21:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d29:	eb 30                	jmp    802d5b <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802d2b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d30:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d33:	75 0a                	jne    802d3f <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802d35:	a1 38 51 80 00       	mov    0x805138,%eax
  802d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d3d:	eb 08                	jmp    802d47 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 08             	mov    0x8(%eax),%eax
  802d4d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d50:	0f 85 4d fe ff ff    	jne    802ba3 <alloc_block_NF+0x59>

			return NULL;
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802d5b:	c9                   	leave  
  802d5c:	c3                   	ret    

00802d5d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d5d:	55                   	push   %ebp
  802d5e:	89 e5                	mov    %esp,%ebp
  802d60:	53                   	push   %ebx
  802d61:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802d64:	a1 38 51 80 00       	mov    0x805138,%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	0f 85 86 00 00 00    	jne    802df7 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802d71:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802d78:	00 00 00 
  802d7b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802d82:	00 00 00 
  802d85:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802d8c:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d93:	75 17                	jne    802dac <insert_sorted_with_merge_freeList+0x4f>
  802d95:	83 ec 04             	sub    $0x4,%esp
  802d98:	68 d0 40 80 00       	push   $0x8040d0
  802d9d:	68 48 01 00 00       	push   $0x148
  802da2:	68 f3 40 80 00       	push   $0x8040f3
  802da7:	e8 ef d9 ff ff       	call   80079b <_panic>
  802dac:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	89 10                	mov    %edx,(%eax)
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	74 0d                	je     802dcd <insert_sorted_with_merge_freeList+0x70>
  802dc0:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc8:	89 50 04             	mov    %edx,0x4(%eax)
  802dcb:	eb 08                	jmp    802dd5 <insert_sorted_with_merge_freeList+0x78>
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	a3 38 51 80 00       	mov    %eax,0x805138
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de7:	a1 44 51 80 00       	mov    0x805144,%eax
  802dec:	40                   	inc    %eax
  802ded:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802df2:	e9 73 07 00 00       	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	8b 50 08             	mov    0x8(%eax),%edx
  802dfd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e02:	8b 40 08             	mov    0x8(%eax),%eax
  802e05:	39 c2                	cmp    %eax,%edx
  802e07:	0f 86 84 00 00 00    	jbe    802e91 <insert_sorted_with_merge_freeList+0x134>
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	8b 50 08             	mov    0x8(%eax),%edx
  802e13:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e18:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e1b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e20:	8b 40 08             	mov    0x8(%eax),%eax
  802e23:	01 c8                	add    %ecx,%eax
  802e25:	39 c2                	cmp    %eax,%edx
  802e27:	74 68                	je     802e91 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802e29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2d:	75 17                	jne    802e46 <insert_sorted_with_merge_freeList+0xe9>
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 0c 41 80 00       	push   $0x80410c
  802e37:	68 4c 01 00 00       	push   $0x14c
  802e3c:	68 f3 40 80 00       	push   $0x8040f3
  802e41:	e8 55 d9 ff ff       	call   80079b <_panic>
  802e46:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	89 50 04             	mov    %edx,0x4(%eax)
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 40 04             	mov    0x4(%eax),%eax
  802e58:	85 c0                	test   %eax,%eax
  802e5a:	74 0c                	je     802e68 <insert_sorted_with_merge_freeList+0x10b>
  802e5c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e61:	8b 55 08             	mov    0x8(%ebp),%edx
  802e64:	89 10                	mov    %edx,(%eax)
  802e66:	eb 08                	jmp    802e70 <insert_sorted_with_merge_freeList+0x113>
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e81:	a1 44 51 80 00       	mov    0x805144,%eax
  802e86:	40                   	inc    %eax
  802e87:	a3 44 51 80 00       	mov    %eax,0x805144
  802e8c:	e9 d9 06 00 00       	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	8b 50 08             	mov    0x8(%eax),%edx
  802e97:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e9c:	8b 40 08             	mov    0x8(%eax),%eax
  802e9f:	39 c2                	cmp    %eax,%edx
  802ea1:	0f 86 b5 00 00 00    	jbe    802f5c <insert_sorted_with_merge_freeList+0x1ff>
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 50 08             	mov    0x8(%eax),%edx
  802ead:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eb2:	8b 48 0c             	mov    0xc(%eax),%ecx
  802eb5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eba:	8b 40 08             	mov    0x8(%eax),%eax
  802ebd:	01 c8                	add    %ecx,%eax
  802ebf:	39 c2                	cmp    %eax,%edx
  802ec1:	0f 85 95 00 00 00    	jne    802f5c <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802ec7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ecc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ed2:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed8:	8b 52 0c             	mov    0xc(%edx),%edx
  802edb:	01 ca                	add    %ecx,%edx
  802edd:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ef4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef8:	75 17                	jne    802f11 <insert_sorted_with_merge_freeList+0x1b4>
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	68 d0 40 80 00       	push   $0x8040d0
  802f02:	68 54 01 00 00       	push   $0x154
  802f07:	68 f3 40 80 00       	push   $0x8040f3
  802f0c:	e8 8a d8 ff ff       	call   80079b <_panic>
  802f11:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	74 0d                	je     802f32 <insert_sorted_with_merge_freeList+0x1d5>
  802f25:	a1 48 51 80 00       	mov    0x805148,%eax
  802f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	eb 08                	jmp    802f3a <insert_sorted_with_merge_freeList+0x1dd>
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	a3 48 51 80 00       	mov    %eax,0x805148
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4c:	a1 54 51 80 00       	mov    0x805154,%eax
  802f51:	40                   	inc    %eax
  802f52:	a3 54 51 80 00       	mov    %eax,0x805154
  802f57:	e9 0e 06 00 00       	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 50 08             	mov    0x8(%eax),%edx
  802f62:	a1 38 51 80 00       	mov    0x805138,%eax
  802f67:	8b 40 08             	mov    0x8(%eax),%eax
  802f6a:	39 c2                	cmp    %eax,%edx
  802f6c:	0f 83 c1 00 00 00    	jae    803033 <insert_sorted_with_merge_freeList+0x2d6>
  802f72:	a1 38 51 80 00       	mov    0x805138,%eax
  802f77:	8b 50 08             	mov    0x8(%eax),%edx
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	8b 48 08             	mov    0x8(%eax),%ecx
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 40 0c             	mov    0xc(%eax),%eax
  802f86:	01 c8                	add    %ecx,%eax
  802f88:	39 c2                	cmp    %eax,%edx
  802f8a:	0f 85 a3 00 00 00    	jne    803033 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802f90:	a1 38 51 80 00       	mov    0x805138,%eax
  802f95:	8b 55 08             	mov    0x8(%ebp),%edx
  802f98:	8b 52 08             	mov    0x8(%edx),%edx
  802f9b:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802f9e:	a1 38 51 80 00       	mov    0x805138,%eax
  802fa3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fa9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802fac:	8b 55 08             	mov    0x8(%ebp),%edx
  802faf:	8b 52 0c             	mov    0xc(%edx),%edx
  802fb2:	01 ca                	add    %ecx,%edx
  802fb4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fcb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fcf:	75 17                	jne    802fe8 <insert_sorted_with_merge_freeList+0x28b>
  802fd1:	83 ec 04             	sub    $0x4,%esp
  802fd4:	68 d0 40 80 00       	push   $0x8040d0
  802fd9:	68 5d 01 00 00       	push   $0x15d
  802fde:	68 f3 40 80 00       	push   $0x8040f3
  802fe3:	e8 b3 d7 ff ff       	call   80079b <_panic>
  802fe8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	89 10                	mov    %edx,(%eax)
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	8b 00                	mov    (%eax),%eax
  802ff8:	85 c0                	test   %eax,%eax
  802ffa:	74 0d                	je     803009 <insert_sorted_with_merge_freeList+0x2ac>
  802ffc:	a1 48 51 80 00       	mov    0x805148,%eax
  803001:	8b 55 08             	mov    0x8(%ebp),%edx
  803004:	89 50 04             	mov    %edx,0x4(%eax)
  803007:	eb 08                	jmp    803011 <insert_sorted_with_merge_freeList+0x2b4>
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	a3 48 51 80 00       	mov    %eax,0x805148
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803023:	a1 54 51 80 00       	mov    0x805154,%eax
  803028:	40                   	inc    %eax
  803029:	a3 54 51 80 00       	mov    %eax,0x805154
  80302e:	e9 37 05 00 00       	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	8b 50 08             	mov    0x8(%eax),%edx
  803039:	a1 38 51 80 00       	mov    0x805138,%eax
  80303e:	8b 40 08             	mov    0x8(%eax),%eax
  803041:	39 c2                	cmp    %eax,%edx
  803043:	0f 83 82 00 00 00    	jae    8030cb <insert_sorted_with_merge_freeList+0x36e>
  803049:	a1 38 51 80 00       	mov    0x805138,%eax
  80304e:	8b 50 08             	mov    0x8(%eax),%edx
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	8b 48 08             	mov    0x8(%eax),%ecx
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 40 0c             	mov    0xc(%eax),%eax
  80305d:	01 c8                	add    %ecx,%eax
  80305f:	39 c2                	cmp    %eax,%edx
  803061:	74 68                	je     8030cb <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803063:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803067:	75 17                	jne    803080 <insert_sorted_with_merge_freeList+0x323>
  803069:	83 ec 04             	sub    $0x4,%esp
  80306c:	68 d0 40 80 00       	push   $0x8040d0
  803071:	68 62 01 00 00       	push   $0x162
  803076:	68 f3 40 80 00       	push   $0x8040f3
  80307b:	e8 1b d7 ff ff       	call   80079b <_panic>
  803080:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	89 10                	mov    %edx,(%eax)
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 0d                	je     8030a1 <insert_sorted_with_merge_freeList+0x344>
  803094:	a1 38 51 80 00       	mov    0x805138,%eax
  803099:	8b 55 08             	mov    0x8(%ebp),%edx
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	eb 08                	jmp    8030a9 <insert_sorted_with_merge_freeList+0x34c>
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c0:	40                   	inc    %eax
  8030c1:	a3 44 51 80 00       	mov    %eax,0x805144
  8030c6:	e9 9f 04 00 00       	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8030cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8030d5:	e9 84 04 00 00       	jmp    80355e <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 50 08             	mov    0x8(%eax),%edx
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	8b 40 08             	mov    0x8(%eax),%eax
  8030e6:	39 c2                	cmp    %eax,%edx
  8030e8:	0f 86 a9 00 00 00    	jbe    803197 <insert_sorted_with_merge_freeList+0x43a>
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 50 08             	mov    0x8(%eax),%edx
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	8b 48 08             	mov    0x8(%eax),%ecx
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803100:	01 c8                	add    %ecx,%eax
  803102:	39 c2                	cmp    %eax,%edx
  803104:	0f 84 8d 00 00 00    	je     803197 <insert_sorted_with_merge_freeList+0x43a>
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	8b 50 08             	mov    0x8(%eax),%edx
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 40 04             	mov    0x4(%eax),%eax
  803116:	8b 48 08             	mov    0x8(%eax),%ecx
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	8b 40 04             	mov    0x4(%eax),%eax
  80311f:	8b 40 0c             	mov    0xc(%eax),%eax
  803122:	01 c8                	add    %ecx,%eax
  803124:	39 c2                	cmp    %eax,%edx
  803126:	74 6f                	je     803197 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312c:	74 06                	je     803134 <insert_sorted_with_merge_freeList+0x3d7>
  80312e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803132:	75 17                	jne    80314b <insert_sorted_with_merge_freeList+0x3ee>
  803134:	83 ec 04             	sub    $0x4,%esp
  803137:	68 30 41 80 00       	push   $0x804130
  80313c:	68 6b 01 00 00       	push   $0x16b
  803141:	68 f3 40 80 00       	push   $0x8040f3
  803146:	e8 50 d6 ff ff       	call   80079b <_panic>
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 50 04             	mov    0x4(%eax),%edx
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	89 50 04             	mov    %edx,0x4(%eax)
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80315d:	89 10                	mov    %edx,(%eax)
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0d                	je     803176 <insert_sorted_with_merge_freeList+0x419>
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	8b 55 08             	mov    0x8(%ebp),%edx
  803172:	89 10                	mov    %edx,(%eax)
  803174:	eb 08                	jmp    80317e <insert_sorted_with_merge_freeList+0x421>
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	a3 38 51 80 00       	mov    %eax,0x805138
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 55 08             	mov    0x8(%ebp),%edx
  803184:	89 50 04             	mov    %edx,0x4(%eax)
  803187:	a1 44 51 80 00       	mov    0x805144,%eax
  80318c:	40                   	inc    %eax
  80318d:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  803192:	e9 d3 03 00 00       	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	8b 50 08             	mov    0x8(%eax),%edx
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	8b 40 08             	mov    0x8(%eax),%eax
  8031a3:	39 c2                	cmp    %eax,%edx
  8031a5:	0f 86 da 00 00 00    	jbe    803285 <insert_sorted_with_merge_freeList+0x528>
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 50 08             	mov    0x8(%eax),%edx
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	8b 48 08             	mov    0x8(%eax),%ecx
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bd:	01 c8                	add    %ecx,%eax
  8031bf:	39 c2                	cmp    %eax,%edx
  8031c1:	0f 85 be 00 00 00    	jne    803285 <insert_sorted_with_merge_freeList+0x528>
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	8b 50 08             	mov    0x8(%eax),%edx
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 40 04             	mov    0x4(%eax),%eax
  8031d3:	8b 48 08             	mov    0x8(%eax),%ecx
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	8b 40 04             	mov    0x4(%eax),%eax
  8031dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031df:	01 c8                	add    %ecx,%eax
  8031e1:	39 c2                	cmp    %eax,%edx
  8031e3:	0f 84 9c 00 00 00    	je     803285 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	8b 50 08             	mov    0x8(%eax),%edx
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  8031f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f8:	8b 50 0c             	mov    0xc(%eax),%edx
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803201:	01 c2                	add    %eax,%edx
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80321d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803221:	75 17                	jne    80323a <insert_sorted_with_merge_freeList+0x4dd>
  803223:	83 ec 04             	sub    $0x4,%esp
  803226:	68 d0 40 80 00       	push   $0x8040d0
  80322b:	68 74 01 00 00       	push   $0x174
  803230:	68 f3 40 80 00       	push   $0x8040f3
  803235:	e8 61 d5 ff ff       	call   80079b <_panic>
  80323a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	89 10                	mov    %edx,(%eax)
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	8b 00                	mov    (%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 0d                	je     80325b <insert_sorted_with_merge_freeList+0x4fe>
  80324e:	a1 48 51 80 00       	mov    0x805148,%eax
  803253:	8b 55 08             	mov    0x8(%ebp),%edx
  803256:	89 50 04             	mov    %edx,0x4(%eax)
  803259:	eb 08                	jmp    803263 <insert_sorted_with_merge_freeList+0x506>
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	a3 48 51 80 00       	mov    %eax,0x805148
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803275:	a1 54 51 80 00       	mov    0x805154,%eax
  80327a:	40                   	inc    %eax
  80327b:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803280:	e9 e5 02 00 00       	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803288:	8b 50 08             	mov    0x8(%eax),%edx
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 40 08             	mov    0x8(%eax),%eax
  803291:	39 c2                	cmp    %eax,%edx
  803293:	0f 86 d7 00 00 00    	jbe    803370 <insert_sorted_with_merge_freeList+0x613>
  803299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329c:	8b 50 08             	mov    0x8(%eax),%edx
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	8b 48 08             	mov    0x8(%eax),%ecx
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ab:	01 c8                	add    %ecx,%eax
  8032ad:	39 c2                	cmp    %eax,%edx
  8032af:	0f 84 bb 00 00 00    	je     803370 <insert_sorted_with_merge_freeList+0x613>
  8032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b8:	8b 50 08             	mov    0x8(%eax),%edx
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 40 04             	mov    0x4(%eax),%eax
  8032c1:	8b 48 08             	mov    0x8(%eax),%ecx
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8032cd:	01 c8                	add    %ecx,%eax
  8032cf:	39 c2                	cmp    %eax,%edx
  8032d1:	0f 85 99 00 00 00    	jne    803370 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  8032e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ec:	01 c2                	add    %eax,%edx
  8032ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f1:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330c:	75 17                	jne    803325 <insert_sorted_with_merge_freeList+0x5c8>
  80330e:	83 ec 04             	sub    $0x4,%esp
  803311:	68 d0 40 80 00       	push   $0x8040d0
  803316:	68 7d 01 00 00       	push   $0x17d
  80331b:	68 f3 40 80 00       	push   $0x8040f3
  803320:	e8 76 d4 ff ff       	call   80079b <_panic>
  803325:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	89 10                	mov    %edx,(%eax)
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	8b 00                	mov    (%eax),%eax
  803335:	85 c0                	test   %eax,%eax
  803337:	74 0d                	je     803346 <insert_sorted_with_merge_freeList+0x5e9>
  803339:	a1 48 51 80 00       	mov    0x805148,%eax
  80333e:	8b 55 08             	mov    0x8(%ebp),%edx
  803341:	89 50 04             	mov    %edx,0x4(%eax)
  803344:	eb 08                	jmp    80334e <insert_sorted_with_merge_freeList+0x5f1>
  803346:	8b 45 08             	mov    0x8(%ebp),%eax
  803349:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334e:	8b 45 08             	mov    0x8(%ebp),%eax
  803351:	a3 48 51 80 00       	mov    %eax,0x805148
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803360:	a1 54 51 80 00       	mov    0x805154,%eax
  803365:	40                   	inc    %eax
  803366:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80336b:	e9 fa 01 00 00       	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 50 08             	mov    0x8(%eax),%edx
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 40 08             	mov    0x8(%eax),%eax
  80337c:	39 c2                	cmp    %eax,%edx
  80337e:	0f 86 d2 01 00 00    	jbe    803556 <insert_sorted_with_merge_freeList+0x7f9>
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	8b 50 08             	mov    0x8(%eax),%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	8b 48 08             	mov    0x8(%eax),%ecx
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	8b 40 0c             	mov    0xc(%eax),%eax
  803396:	01 c8                	add    %ecx,%eax
  803398:	39 c2                	cmp    %eax,%edx
  80339a:	0f 85 b6 01 00 00    	jne    803556 <insert_sorted_with_merge_freeList+0x7f9>
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	8b 50 08             	mov    0x8(%eax),%edx
  8033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a9:	8b 40 04             	mov    0x4(%eax),%eax
  8033ac:	8b 48 08             	mov    0x8(%eax),%ecx
  8033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b2:	8b 40 04             	mov    0x4(%eax),%eax
  8033b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b8:	01 c8                	add    %ecx,%eax
  8033ba:	39 c2                	cmp    %eax,%edx
  8033bc:	0f 85 94 01 00 00    	jne    803556 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033cb:	8b 52 04             	mov    0x4(%edx),%edx
  8033ce:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8033d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d4:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8033d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033da:	8b 52 0c             	mov    0xc(%edx),%edx
  8033dd:	01 da                	add    %ebx,%edx
  8033df:	01 ca                	add    %ecx,%edx
  8033e1:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  8033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8033f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fc:	75 17                	jne    803415 <insert_sorted_with_merge_freeList+0x6b8>
  8033fe:	83 ec 04             	sub    $0x4,%esp
  803401:	68 65 41 80 00       	push   $0x804165
  803406:	68 86 01 00 00       	push   $0x186
  80340b:	68 f3 40 80 00       	push   $0x8040f3
  803410:	e8 86 d3 ff ff       	call   80079b <_panic>
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	85 c0                	test   %eax,%eax
  80341c:	74 10                	je     80342e <insert_sorted_with_merge_freeList+0x6d1>
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	8b 00                	mov    (%eax),%eax
  803423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803426:	8b 52 04             	mov    0x4(%edx),%edx
  803429:	89 50 04             	mov    %edx,0x4(%eax)
  80342c:	eb 0b                	jmp    803439 <insert_sorted_with_merge_freeList+0x6dc>
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	8b 40 04             	mov    0x4(%eax),%eax
  803434:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 40 04             	mov    0x4(%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	74 0f                	je     803452 <insert_sorted_with_merge_freeList+0x6f5>
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80344c:	8b 12                	mov    (%edx),%edx
  80344e:	89 10                	mov    %edx,(%eax)
  803450:	eb 0a                	jmp    80345c <insert_sorted_with_merge_freeList+0x6ff>
  803452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803455:	8b 00                	mov    (%eax),%eax
  803457:	a3 38 51 80 00       	mov    %eax,0x805138
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346f:	a1 44 51 80 00       	mov    0x805144,%eax
  803474:	48                   	dec    %eax
  803475:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80347a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347e:	75 17                	jne    803497 <insert_sorted_with_merge_freeList+0x73a>
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	68 d0 40 80 00       	push   $0x8040d0
  803488:	68 87 01 00 00       	push   $0x187
  80348d:	68 f3 40 80 00       	push   $0x8040f3
  803492:	e8 04 d3 ff ff       	call   80079b <_panic>
  803497:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	89 10                	mov    %edx,(%eax)
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	8b 00                	mov    (%eax),%eax
  8034a7:	85 c0                	test   %eax,%eax
  8034a9:	74 0d                	je     8034b8 <insert_sorted_with_merge_freeList+0x75b>
  8034ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b3:	89 50 04             	mov    %edx,0x4(%eax)
  8034b6:	eb 08                	jmp    8034c0 <insert_sorted_with_merge_freeList+0x763>
  8034b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d2:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d7:	40                   	inc    %eax
  8034d8:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f5:	75 17                	jne    80350e <insert_sorted_with_merge_freeList+0x7b1>
  8034f7:	83 ec 04             	sub    $0x4,%esp
  8034fa:	68 d0 40 80 00       	push   $0x8040d0
  8034ff:	68 8a 01 00 00       	push   $0x18a
  803504:	68 f3 40 80 00       	push   $0x8040f3
  803509:	e8 8d d2 ff ff       	call   80079b <_panic>
  80350e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	89 10                	mov    %edx,(%eax)
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	85 c0                	test   %eax,%eax
  803520:	74 0d                	je     80352f <insert_sorted_with_merge_freeList+0x7d2>
  803522:	a1 48 51 80 00       	mov    0x805148,%eax
  803527:	8b 55 08             	mov    0x8(%ebp),%edx
  80352a:	89 50 04             	mov    %edx,0x4(%eax)
  80352d:	eb 08                	jmp    803537 <insert_sorted_with_merge_freeList+0x7da>
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803537:	8b 45 08             	mov    0x8(%ebp),%eax
  80353a:	a3 48 51 80 00       	mov    %eax,0x805148
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803549:	a1 54 51 80 00       	mov    0x805154,%eax
  80354e:	40                   	inc    %eax
  80354f:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803554:	eb 14                	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	8b 00                	mov    (%eax),%eax
  80355b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80355e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803562:	0f 85 72 fb ff ff    	jne    8030da <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803568:	eb 00                	jmp    80356a <insert_sorted_with_merge_freeList+0x80d>
  80356a:	90                   	nop
  80356b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80356e:	c9                   	leave  
  80356f:	c3                   	ret    

00803570 <__udivdi3>:
  803570:	55                   	push   %ebp
  803571:	57                   	push   %edi
  803572:	56                   	push   %esi
  803573:	53                   	push   %ebx
  803574:	83 ec 1c             	sub    $0x1c,%esp
  803577:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80357b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80357f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803583:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803587:	89 ca                	mov    %ecx,%edx
  803589:	89 f8                	mov    %edi,%eax
  80358b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80358f:	85 f6                	test   %esi,%esi
  803591:	75 2d                	jne    8035c0 <__udivdi3+0x50>
  803593:	39 cf                	cmp    %ecx,%edi
  803595:	77 65                	ja     8035fc <__udivdi3+0x8c>
  803597:	89 fd                	mov    %edi,%ebp
  803599:	85 ff                	test   %edi,%edi
  80359b:	75 0b                	jne    8035a8 <__udivdi3+0x38>
  80359d:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a2:	31 d2                	xor    %edx,%edx
  8035a4:	f7 f7                	div    %edi
  8035a6:	89 c5                	mov    %eax,%ebp
  8035a8:	31 d2                	xor    %edx,%edx
  8035aa:	89 c8                	mov    %ecx,%eax
  8035ac:	f7 f5                	div    %ebp
  8035ae:	89 c1                	mov    %eax,%ecx
  8035b0:	89 d8                	mov    %ebx,%eax
  8035b2:	f7 f5                	div    %ebp
  8035b4:	89 cf                	mov    %ecx,%edi
  8035b6:	89 fa                	mov    %edi,%edx
  8035b8:	83 c4 1c             	add    $0x1c,%esp
  8035bb:	5b                   	pop    %ebx
  8035bc:	5e                   	pop    %esi
  8035bd:	5f                   	pop    %edi
  8035be:	5d                   	pop    %ebp
  8035bf:	c3                   	ret    
  8035c0:	39 ce                	cmp    %ecx,%esi
  8035c2:	77 28                	ja     8035ec <__udivdi3+0x7c>
  8035c4:	0f bd fe             	bsr    %esi,%edi
  8035c7:	83 f7 1f             	xor    $0x1f,%edi
  8035ca:	75 40                	jne    80360c <__udivdi3+0x9c>
  8035cc:	39 ce                	cmp    %ecx,%esi
  8035ce:	72 0a                	jb     8035da <__udivdi3+0x6a>
  8035d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035d4:	0f 87 9e 00 00 00    	ja     803678 <__udivdi3+0x108>
  8035da:	b8 01 00 00 00       	mov    $0x1,%eax
  8035df:	89 fa                	mov    %edi,%edx
  8035e1:	83 c4 1c             	add    $0x1c,%esp
  8035e4:	5b                   	pop    %ebx
  8035e5:	5e                   	pop    %esi
  8035e6:	5f                   	pop    %edi
  8035e7:	5d                   	pop    %ebp
  8035e8:	c3                   	ret    
  8035e9:	8d 76 00             	lea    0x0(%esi),%esi
  8035ec:	31 ff                	xor    %edi,%edi
  8035ee:	31 c0                	xor    %eax,%eax
  8035f0:	89 fa                	mov    %edi,%edx
  8035f2:	83 c4 1c             	add    $0x1c,%esp
  8035f5:	5b                   	pop    %ebx
  8035f6:	5e                   	pop    %esi
  8035f7:	5f                   	pop    %edi
  8035f8:	5d                   	pop    %ebp
  8035f9:	c3                   	ret    
  8035fa:	66 90                	xchg   %ax,%ax
  8035fc:	89 d8                	mov    %ebx,%eax
  8035fe:	f7 f7                	div    %edi
  803600:	31 ff                	xor    %edi,%edi
  803602:	89 fa                	mov    %edi,%edx
  803604:	83 c4 1c             	add    $0x1c,%esp
  803607:	5b                   	pop    %ebx
  803608:	5e                   	pop    %esi
  803609:	5f                   	pop    %edi
  80360a:	5d                   	pop    %ebp
  80360b:	c3                   	ret    
  80360c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803611:	89 eb                	mov    %ebp,%ebx
  803613:	29 fb                	sub    %edi,%ebx
  803615:	89 f9                	mov    %edi,%ecx
  803617:	d3 e6                	shl    %cl,%esi
  803619:	89 c5                	mov    %eax,%ebp
  80361b:	88 d9                	mov    %bl,%cl
  80361d:	d3 ed                	shr    %cl,%ebp
  80361f:	89 e9                	mov    %ebp,%ecx
  803621:	09 f1                	or     %esi,%ecx
  803623:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803627:	89 f9                	mov    %edi,%ecx
  803629:	d3 e0                	shl    %cl,%eax
  80362b:	89 c5                	mov    %eax,%ebp
  80362d:	89 d6                	mov    %edx,%esi
  80362f:	88 d9                	mov    %bl,%cl
  803631:	d3 ee                	shr    %cl,%esi
  803633:	89 f9                	mov    %edi,%ecx
  803635:	d3 e2                	shl    %cl,%edx
  803637:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363b:	88 d9                	mov    %bl,%cl
  80363d:	d3 e8                	shr    %cl,%eax
  80363f:	09 c2                	or     %eax,%edx
  803641:	89 d0                	mov    %edx,%eax
  803643:	89 f2                	mov    %esi,%edx
  803645:	f7 74 24 0c          	divl   0xc(%esp)
  803649:	89 d6                	mov    %edx,%esi
  80364b:	89 c3                	mov    %eax,%ebx
  80364d:	f7 e5                	mul    %ebp
  80364f:	39 d6                	cmp    %edx,%esi
  803651:	72 19                	jb     80366c <__udivdi3+0xfc>
  803653:	74 0b                	je     803660 <__udivdi3+0xf0>
  803655:	89 d8                	mov    %ebx,%eax
  803657:	31 ff                	xor    %edi,%edi
  803659:	e9 58 ff ff ff       	jmp    8035b6 <__udivdi3+0x46>
  80365e:	66 90                	xchg   %ax,%ax
  803660:	8b 54 24 08          	mov    0x8(%esp),%edx
  803664:	89 f9                	mov    %edi,%ecx
  803666:	d3 e2                	shl    %cl,%edx
  803668:	39 c2                	cmp    %eax,%edx
  80366a:	73 e9                	jae    803655 <__udivdi3+0xe5>
  80366c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80366f:	31 ff                	xor    %edi,%edi
  803671:	e9 40 ff ff ff       	jmp    8035b6 <__udivdi3+0x46>
  803676:	66 90                	xchg   %ax,%ax
  803678:	31 c0                	xor    %eax,%eax
  80367a:	e9 37 ff ff ff       	jmp    8035b6 <__udivdi3+0x46>
  80367f:	90                   	nop

00803680 <__umoddi3>:
  803680:	55                   	push   %ebp
  803681:	57                   	push   %edi
  803682:	56                   	push   %esi
  803683:	53                   	push   %ebx
  803684:	83 ec 1c             	sub    $0x1c,%esp
  803687:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80368b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80368f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803693:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803697:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80369b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80369f:	89 f3                	mov    %esi,%ebx
  8036a1:	89 fa                	mov    %edi,%edx
  8036a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036a7:	89 34 24             	mov    %esi,(%esp)
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	75 1a                	jne    8036c8 <__umoddi3+0x48>
  8036ae:	39 f7                	cmp    %esi,%edi
  8036b0:	0f 86 a2 00 00 00    	jbe    803758 <__umoddi3+0xd8>
  8036b6:	89 c8                	mov    %ecx,%eax
  8036b8:	89 f2                	mov    %esi,%edx
  8036ba:	f7 f7                	div    %edi
  8036bc:	89 d0                	mov    %edx,%eax
  8036be:	31 d2                	xor    %edx,%edx
  8036c0:	83 c4 1c             	add    $0x1c,%esp
  8036c3:	5b                   	pop    %ebx
  8036c4:	5e                   	pop    %esi
  8036c5:	5f                   	pop    %edi
  8036c6:	5d                   	pop    %ebp
  8036c7:	c3                   	ret    
  8036c8:	39 f0                	cmp    %esi,%eax
  8036ca:	0f 87 ac 00 00 00    	ja     80377c <__umoddi3+0xfc>
  8036d0:	0f bd e8             	bsr    %eax,%ebp
  8036d3:	83 f5 1f             	xor    $0x1f,%ebp
  8036d6:	0f 84 ac 00 00 00    	je     803788 <__umoddi3+0x108>
  8036dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8036e1:	29 ef                	sub    %ebp,%edi
  8036e3:	89 fe                	mov    %edi,%esi
  8036e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036e9:	89 e9                	mov    %ebp,%ecx
  8036eb:	d3 e0                	shl    %cl,%eax
  8036ed:	89 d7                	mov    %edx,%edi
  8036ef:	89 f1                	mov    %esi,%ecx
  8036f1:	d3 ef                	shr    %cl,%edi
  8036f3:	09 c7                	or     %eax,%edi
  8036f5:	89 e9                	mov    %ebp,%ecx
  8036f7:	d3 e2                	shl    %cl,%edx
  8036f9:	89 14 24             	mov    %edx,(%esp)
  8036fc:	89 d8                	mov    %ebx,%eax
  8036fe:	d3 e0                	shl    %cl,%eax
  803700:	89 c2                	mov    %eax,%edx
  803702:	8b 44 24 08          	mov    0x8(%esp),%eax
  803706:	d3 e0                	shl    %cl,%eax
  803708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80370c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803710:	89 f1                	mov    %esi,%ecx
  803712:	d3 e8                	shr    %cl,%eax
  803714:	09 d0                	or     %edx,%eax
  803716:	d3 eb                	shr    %cl,%ebx
  803718:	89 da                	mov    %ebx,%edx
  80371a:	f7 f7                	div    %edi
  80371c:	89 d3                	mov    %edx,%ebx
  80371e:	f7 24 24             	mull   (%esp)
  803721:	89 c6                	mov    %eax,%esi
  803723:	89 d1                	mov    %edx,%ecx
  803725:	39 d3                	cmp    %edx,%ebx
  803727:	0f 82 87 00 00 00    	jb     8037b4 <__umoddi3+0x134>
  80372d:	0f 84 91 00 00 00    	je     8037c4 <__umoddi3+0x144>
  803733:	8b 54 24 04          	mov    0x4(%esp),%edx
  803737:	29 f2                	sub    %esi,%edx
  803739:	19 cb                	sbb    %ecx,%ebx
  80373b:	89 d8                	mov    %ebx,%eax
  80373d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803741:	d3 e0                	shl    %cl,%eax
  803743:	89 e9                	mov    %ebp,%ecx
  803745:	d3 ea                	shr    %cl,%edx
  803747:	09 d0                	or     %edx,%eax
  803749:	89 e9                	mov    %ebp,%ecx
  80374b:	d3 eb                	shr    %cl,%ebx
  80374d:	89 da                	mov    %ebx,%edx
  80374f:	83 c4 1c             	add    $0x1c,%esp
  803752:	5b                   	pop    %ebx
  803753:	5e                   	pop    %esi
  803754:	5f                   	pop    %edi
  803755:	5d                   	pop    %ebp
  803756:	c3                   	ret    
  803757:	90                   	nop
  803758:	89 fd                	mov    %edi,%ebp
  80375a:	85 ff                	test   %edi,%edi
  80375c:	75 0b                	jne    803769 <__umoddi3+0xe9>
  80375e:	b8 01 00 00 00       	mov    $0x1,%eax
  803763:	31 d2                	xor    %edx,%edx
  803765:	f7 f7                	div    %edi
  803767:	89 c5                	mov    %eax,%ebp
  803769:	89 f0                	mov    %esi,%eax
  80376b:	31 d2                	xor    %edx,%edx
  80376d:	f7 f5                	div    %ebp
  80376f:	89 c8                	mov    %ecx,%eax
  803771:	f7 f5                	div    %ebp
  803773:	89 d0                	mov    %edx,%eax
  803775:	e9 44 ff ff ff       	jmp    8036be <__umoddi3+0x3e>
  80377a:	66 90                	xchg   %ax,%ax
  80377c:	89 c8                	mov    %ecx,%eax
  80377e:	89 f2                	mov    %esi,%edx
  803780:	83 c4 1c             	add    $0x1c,%esp
  803783:	5b                   	pop    %ebx
  803784:	5e                   	pop    %esi
  803785:	5f                   	pop    %edi
  803786:	5d                   	pop    %ebp
  803787:	c3                   	ret    
  803788:	3b 04 24             	cmp    (%esp),%eax
  80378b:	72 06                	jb     803793 <__umoddi3+0x113>
  80378d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803791:	77 0f                	ja     8037a2 <__umoddi3+0x122>
  803793:	89 f2                	mov    %esi,%edx
  803795:	29 f9                	sub    %edi,%ecx
  803797:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80379b:	89 14 24             	mov    %edx,(%esp)
  80379e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037a6:	8b 14 24             	mov    (%esp),%edx
  8037a9:	83 c4 1c             	add    $0x1c,%esp
  8037ac:	5b                   	pop    %ebx
  8037ad:	5e                   	pop    %esi
  8037ae:	5f                   	pop    %edi
  8037af:	5d                   	pop    %ebp
  8037b0:	c3                   	ret    
  8037b1:	8d 76 00             	lea    0x0(%esi),%esi
  8037b4:	2b 04 24             	sub    (%esp),%eax
  8037b7:	19 fa                	sbb    %edi,%edx
  8037b9:	89 d1                	mov    %edx,%ecx
  8037bb:	89 c6                	mov    %eax,%esi
  8037bd:	e9 71 ff ff ff       	jmp    803733 <__umoddi3+0xb3>
  8037c2:	66 90                	xchg   %ax,%ax
  8037c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037c8:	72 ea                	jb     8037b4 <__umoddi3+0x134>
  8037ca:	89 d9                	mov    %ebx,%ecx
  8037cc:	e9 62 ff ff ff       	jmp    803733 <__umoddi3+0xb3>
