
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b5 08 00 00       	call   8008eb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 5a 25 00 00       	call   8025a4 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 60 3a 80 00       	push   $0x803a60
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 7c 3a 80 00       	push   $0x803a7c
  8000a7:	e8 7b 09 00 00       	call   800a27 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 75 1b 00 00       	call   801c2b <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 46 1b 00 00       	call   801c2b <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 94 3a 80 00       	push   $0x803a94
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 7c 3a 80 00       	push   $0x803a7c
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 84 1f 00 00       	call   80208f <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 1c 20 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 04 1b 00 00       	call   801c2b <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 d8 3a 80 00       	push   $0x803ad8
  80013f:	6a 31                	push   $0x31
  800141:	68 7c 3a 80 00       	push   $0x803a7c
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 df 1f 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 08 3b 80 00       	push   $0x803b08
  800162:	6a 33                	push   $0x33
  800164:	68 7c 3a 80 00       	push   $0x803a7c
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 1c 1f 00 00       	call   80208f <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 b4 1f 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 9c 1a 00 00       	call   801c2b <malloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800195:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800198:	89 c2                	mov    %eax,%edx
  80019a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019d:	01 c0                	add    %eax,%eax
  80019f:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 d8 3a 80 00       	push   $0x803ad8
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 7c 3a 80 00       	push   $0x803a7c
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 6e 1f 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 08 3b 80 00       	push   $0x803b08
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 7c 3a 80 00       	push   $0x803a7c
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 ab 1e 00 00       	call   80208f <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 43 1f 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	e8 2e 1a 00 00       	call   801c2b <malloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800203:	8b 45 98             	mov    -0x68(%ebp),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020b:	c1 e0 02             	shl    $0x2,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 d8 3a 80 00       	push   $0x803ad8
  80021f:	6a 41                	push   $0x41
  800221:	68 7c 3a 80 00       	push   $0x803a7c
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 ff 1e 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 08 3b 80 00       	push   $0x803b08
  800240:	6a 43                	push   $0x43
  800242:	68 7c 3a 80 00       	push   $0x803a7c
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 3e 1e 00 00       	call   80208f <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 d6 1e 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80025c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025f:	01 c0                	add    %eax,%eax
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	e8 c1 19 00 00       	call   801c2b <malloc>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800270:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	c1 e0 02             	shl    $0x2,%eax
  80027b:	89 c1                	mov    %eax,%ecx
  80027d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	01 c8                	add    %ecx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 d8 3a 80 00       	push   $0x803ad8
  800296:	6a 49                	push   $0x49
  800298:	68 7c 3a 80 00       	push   $0x803a7c
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 88 1e 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 08 3b 80 00       	push   $0x803b08
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 7c 3a 80 00       	push   $0x803a7c
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 c7 1d 00 00       	call   80208f <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 5f 1e 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 d7 19 00 00       	call   801cb6 <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 48 1e 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 25 3b 80 00       	push   $0x803b25
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 7c 3a 80 00       	push   $0x803a7c
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 83 1d 00 00       	call   80208f <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 1b 1e 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800314:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031a:	89 d0                	mov    %edx,%eax
  80031c:	01 c0                	add    %eax,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 fe 18 00 00       	call   801c2b <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800333:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 00 00 00 80       	add    $0x80000000,%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 d8 3a 80 00       	push   $0x803ad8
  800359:	6a 58                	push   $0x58
  80035b:	68 7c 3a 80 00       	push   $0x803a7c
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 c5 1d 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 08 3b 80 00       	push   $0x803b08
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 7c 3a 80 00       	push   $0x803a7c
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 04 1d 00 00       	call   80208f <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 9c 1d 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 14 19 00 00       	call   801cb6 <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 85 1d 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 25 3b 80 00       	push   $0x803b25
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 7c 3a 80 00       	push   $0x803a7c
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 be 1c 00 00       	call   80208f <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 56 1d 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	01 d2                	add    %edx,%edx
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	50                   	push   %eax
  8003ec:	e8 3a 18 00 00       	call   801c2b <malloc>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ff:	c1 e0 02             	shl    $0x2,%eax
  800402:	89 c1                	mov    %eax,%ecx
  800404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	05 00 00 00 80       	add    $0x80000000,%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 d8 3a 80 00       	push   $0x803ad8
  80041d:	6a 67                	push   $0x67
  80041f:	68 7c 3a 80 00       	push   $0x803a7c
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 01 1d 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80042e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	01 c9                	add    %ecx,%ecx
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	79 05                	jns    800445 <_main+0x40d>
  800440:	05 ff 0f 00 00       	add    $0xfff,%eax
  800445:	c1 f8 0c             	sar    $0xc,%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 08 3b 80 00       	push   $0x803b08
  800454:	6a 69                	push   $0x69
  800456:	68 7c 3a 80 00       	push   $0x803a7c
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 2a 1c 00 00       	call   80208f <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 c2 1c 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	01 d2                	add    %edx,%edx
  800477:	01 c2                	add    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	50                   	push   %eax
  800484:	e8 a2 17 00 00       	call   801c2b <malloc>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80048f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800492:	89 c1                	mov    %eax,%ecx
  800494:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	01 c0                	add    %eax,%eax
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a6:	c1 e0 04             	shl    $0x4,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b0:	39 c1                	cmp    %eax,%ecx
  8004b2:	74 14                	je     8004c8 <_main+0x490>
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	68 d8 3a 80 00       	push   $0x803ad8
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 7c 3a 80 00       	push   $0x803a7c
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 62 1c 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 08 3b 80 00       	push   $0x803b08
  8004df:	6a 71                	push   $0x71
  8004e1:	68 7c 3a 80 00       	push   $0x803a7c
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 9f 1b 00 00       	call   80208f <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 37 1c 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	c1 e0 02             	shl    $0x2,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	50                   	push   %eax
  80050c:	e8 1a 17 00 00       	call   801c2b <malloc>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800517:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051f:	89 d0                	mov    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	89 c3                	mov    %eax,%ebx
  800528:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	c1 e0 03             	shl    $0x3,%eax
  800534:	01 d8                	add    %ebx,%eax
  800536:	05 00 00 00 80       	add    $0x80000000,%eax
  80053b:	39 c1                	cmp    %eax,%ecx
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 d8 3a 80 00       	push   $0x803ad8
  800547:	6a 77                	push   $0x77
  800549:	68 7c 3a 80 00       	push   $0x803a7c
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 d7 1b 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800558:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	79 05                	jns    800570 <_main+0x538>
  80056b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800570:	c1 f8 0c             	sar    $0xc,%eax
  800573:	39 c1                	cmp    %eax,%ecx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 08 3b 80 00       	push   $0x803b08
  80057f:	6a 79                	push   $0x79
  800581:	68 7c 3a 80 00       	push   $0x803a7c
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 ff 1a 00 00       	call   80208f <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 97 1b 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 0f 17 00 00       	call   801cb6 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 80 1b 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 25 3b 80 00       	push   $0x803b25
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 7c 3a 80 00       	push   $0x803a7c
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 b6 1a 00 00       	call   80208f <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 4e 1b 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 c6 16 00 00       	call   801cb6 <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 37 1b 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 25 3b 80 00       	push   $0x803b25
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 7c 3a 80 00       	push   $0x803a7c
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 6d 1a 00 00       	call   80208f <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 05 1b 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  80062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 ed 15 00 00       	call   801c2b <malloc>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800647:	89 c1                	mov    %eax,%ecx
  800649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	89 c2                	mov    %eax,%edx
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	c1 e0 04             	shl    $0x4,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	05 00 00 00 80       	add    $0x80000000,%eax
  800665:	39 c1                	cmp    %eax,%ecx
  800667:	74 17                	je     800680 <_main+0x648>
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 d8 3a 80 00       	push   $0x803ad8
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 7c 3a 80 00       	push   $0x803a7c
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 aa 1a 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 08 3b 80 00       	push   $0x803b08
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 7c 3a 80 00       	push   $0x803a7c
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 e4 19 00 00       	call   80208f <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 7c 1a 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 61 15 00 00       	call   801c2b <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	89 c1                	mov    %eax,%ecx
  8006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 03             	shl    $0x3,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e4:	c1 e0 04             	shl    $0x4,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ee:	39 c1                	cmp    %eax,%ecx
  8006f0:	74 17                	je     800709 <_main+0x6d1>
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 d8 3a 80 00       	push   $0x803ad8
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 7c 3a 80 00       	push   $0x803a7c
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 21 1a 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 08 3b 80 00       	push   $0x803b08
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 7c 3a 80 00       	push   $0x803a7c
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 5d 19 00 00       	call   80208f <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 f5 19 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 6d 15 00 00       	call   801cb6 <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 de 19 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 25 3b 80 00       	push   $0x803b25
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 7c 3a 80 00       	push   $0x803a7c
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 14 19 00 00       	call   80208f <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 ac 19 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	01 d2                	add    %edx,%edx
  80078d:	01 d0                	add    %edx,%eax
  80078f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	50                   	push   %eax
  800796:	e8 90 14 00 00       	call   801c2b <malloc>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8007a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	89 c1                	mov    %eax,%ecx
  8007ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b1:	c1 e0 04             	shl    $0x4,%eax
  8007b4:	01 c8                	add    %ecx,%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 d8 3a 80 00       	push   $0x803ad8
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 7c 3a 80 00       	push   $0x803a7c
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 54 19 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  8007db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	01 c9                	add    %ecx,%ecx
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	79 05                	jns    8007f2 <_main+0x7ba>
  8007ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f2:	c1 f8 0c             	sar    $0xc,%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 08 3b 80 00       	push   $0x803b08
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 7c 3a 80 00       	push   $0x803a7c
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 7a 18 00 00       	call   80208f <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 12 19 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800829:	83 ec 0c             	sub    $0xc,%esp
  80082c:	50                   	push   %eax
  80082d:	e8 f9 13 00 00       	call   801c2b <malloc>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800838:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80083b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 d8 3a 80 00       	push   $0x803ad8
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 7c 3a 80 00       	push   $0x803a7c
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 d1 18 00 00       	call   80212f <sys_pf_calculate_allocated_pages>
  80085e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800861:	89 c2                	mov    %eax,%edx
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c1 e0 02             	shl    $0x2,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	79 05                	jns    800872 <_main+0x83a>
  80086d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800872:	c1 f8 0c             	sar    $0xc,%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	74 17                	je     800890 <_main+0x858>
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	68 08 3b 80 00       	push   $0x803b08
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 7c 3a 80 00       	push   $0x803a7c
  80088b:	e8 97 01 00 00       	call   800a27 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	f7 d8                	neg    %eax
  8008a1:	05 00 00 00 20       	add    $0x20000000,%eax
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	50                   	push   %eax
  8008aa:	e8 7c 13 00 00       	call   801c2b <malloc>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8008b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 17                	je     8008d3 <_main+0x89b>
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 3c 3b 80 00       	push   $0x803b3c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 7c 3a 80 00       	push   $0x803a7c
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 a0 3b 80 00       	push   $0x803ba0
  8008db:	e8 fb 03 00 00       	call   800cdb <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp

		return;
  8008e3:	90                   	nop
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008f1:	e8 79 1a 00 00       	call   80236f <sys_getenvindex>
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	c1 e0 03             	shl    $0x3,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090e:	01 d0                	add    %edx,%eax
  800910:	c1 e0 04             	shl    $0x4,%eax
  800913:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800918:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800928:	84 c0                	test   %al,%al
  80092a:	74 0f                	je     80093b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80092c:	a1 20 50 80 00       	mov    0x805020,%eax
  800931:	05 5c 05 00 00       	add    $0x55c,%eax
  800936:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093f:	7e 0a                	jle    80094b <libmain+0x60>
		binaryname = argv[0];
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 df f6 ff ff       	call   800038 <_main>
  800959:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80095c:	e8 1b 18 00 00       	call   80217c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 00 3c 80 00       	push   $0x803c00
  800969:	e8 6d 03 00 00       	call   800cdb <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800971:	a1 20 50 80 00       	mov    0x805020,%eax
  800976:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80097c:	a1 20 50 80 00       	mov    0x805020,%eax
  800981:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800987:	83 ec 04             	sub    $0x4,%esp
  80098a:	52                   	push   %edx
  80098b:	50                   	push   %eax
  80098c:	68 28 3c 80 00       	push   $0x803c28
  800991:	e8 45 03 00 00       	call   800cdb <cprintf>
  800996:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800999:	a1 20 50 80 00       	mov    0x805020,%eax
  80099e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8009a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009a9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8009af:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b4:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	68 50 3c 80 00       	push   $0x803c50
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 a8 3c 80 00       	push   $0x803ca8
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 00 3c 80 00       	push   $0x803c00
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 9b 17 00 00       	call   802196 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009fb:	e8 19 00 00 00       	call   800a19 <exit>
}
  800a00:	90                   	nop
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 28 19 00 00       	call   80233b <sys_destroy_env>
  800a13:	83 c4 10             	add    $0x10,%esp
}
  800a16:	90                   	nop
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <exit>:

void
exit(void)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a1f:	e8 7d 19 00 00       	call   8023a1 <sys_exit_env>
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a36:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a3b:	85 c0                	test   %eax,%eax
  800a3d:	74 16                	je     800a55 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a3f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	50                   	push   %eax
  800a48:	68 bc 3c 80 00       	push   $0x803cbc
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 c1 3c 80 00       	push   $0x803cc1
  800a66:	e8 70 02 00 00       	call   800cdb <cprintf>
  800a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 f4             	pushl  -0xc(%ebp)
  800a77:	50                   	push   %eax
  800a78:	e8 f3 01 00 00       	call   800c70 <vcprintf>
  800a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	6a 00                	push   $0x0
  800a85:	68 dd 3c 80 00       	push   $0x803cdd
  800a8a:	e8 e1 01 00 00       	call   800c70 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a92:	e8 82 ff ff ff       	call   800a19 <exit>

	// should not return here
	while (1) ;
  800a97:	eb fe                	jmp    800a97 <_panic+0x70>

00800a99 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa4:	8b 50 74             	mov    0x74(%eax),%edx
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	39 c2                	cmp    %eax,%edx
  800aac:	74 14                	je     800ac2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	68 e0 3c 80 00       	push   $0x803ce0
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 2c 3d 80 00       	push   $0x803d2c
  800abd:	e8 65 ff ff ff       	call   800a27 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ac9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ad0:	e9 c2 00 00 00       	jmp    800b97 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	75 08                	jne    800af2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800aea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800aed:	e9 a2 00 00 00       	jmp    800b94 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800af2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b00:	eb 69                	jmp    800b6b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b02:	a1 20 50 80 00       	mov    0x805020,%eax
  800b07:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b10:	89 d0                	mov    %edx,%eax
  800b12:	01 c0                	add    %eax,%eax
  800b14:	01 d0                	add    %edx,%eax
  800b16:	c1 e0 03             	shl    $0x3,%eax
  800b19:	01 c8                	add    %ecx,%eax
  800b1b:	8a 40 04             	mov    0x4(%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 46                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b22:	a1 20 50 80 00       	mov    0x805020,%eax
  800b27:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	01 c0                	add    %eax,%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	c1 e0 03             	shl    $0x3,%eax
  800b39:	01 c8                	add    %ecx,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b48:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	01 c8                	add    %ecx,%eax
  800b59:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b5b:	39 c2                	cmp    %eax,%edx
  800b5d:	75 09                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800b5f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b66:	eb 12                	jmp    800b7a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b68:	ff 45 e8             	incl   -0x18(%ebp)
  800b6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800b70:	8b 50 74             	mov    0x74(%eax),%edx
  800b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	77 88                	ja     800b02 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b7e:	75 14                	jne    800b94 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 38 3d 80 00       	push   $0x803d38
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 2c 3d 80 00       	push   $0x803d2c
  800b8f:	e8 93 fe ff ff       	call   800a27 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b94:	ff 45 f0             	incl   -0x10(%ebp)
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b9d:	0f 8c 32 ff ff ff    	jl     800ad5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ba3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800baa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bb1:	eb 26                	jmp    800bd9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bb3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	01 c0                	add    %eax,%eax
  800bc5:	01 d0                	add    %edx,%eax
  800bc7:	c1 e0 03             	shl    $0x3,%eax
  800bca:	01 c8                	add    %ecx,%eax
  800bcc:	8a 40 04             	mov    0x4(%eax),%al
  800bcf:	3c 01                	cmp    $0x1,%al
  800bd1:	75 03                	jne    800bd6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800bd3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bd6:	ff 45 e0             	incl   -0x20(%ebp)
  800bd9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bde:	8b 50 74             	mov    0x74(%eax),%edx
  800be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be4:	39 c2                	cmp    %eax,%edx
  800be6:	77 cb                	ja     800bb3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800beb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bee:	74 14                	je     800c04 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	68 8c 3d 80 00       	push   $0x803d8c
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 2c 3d 80 00       	push   $0x803d2c
  800bff:	e8 23 fe ff ff       	call   800a27 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c04:	90                   	nop
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 d1                	mov    %dl,%cl
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c32:	a0 24 50 80 00       	mov    0x805024,%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3d:	8b 12                	mov    (%edx),%edx
  800c3f:	89 d1                	mov    %edx,%ecx
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	83 c2 08             	add    $0x8,%edx
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	50                   	push   %eax
  800c4b:	51                   	push   %ecx
  800c4c:	52                   	push   %edx
  800c4d:	e8 7c 13 00 00       	call   801fce <sys_cputs>
  800c52:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 40 04             	mov    0x4(%eax),%eax
  800c64:	8d 50 01             	lea    0x1(%eax),%edx
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c80:	00 00 00 
	b.cnt = 0;
  800c83:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c8a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	ff 75 08             	pushl  0x8(%ebp)
  800c93:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	68 07 0c 80 00       	push   $0x800c07
  800c9f:	e8 11 02 00 00       	call   800eb5 <vprintfmt>
  800ca4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ca7:	a0 24 50 80 00       	mov    0x805024,%al
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	50                   	push   %eax
  800cb9:	52                   	push   %edx
  800cba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cc0:	83 c0 08             	add    $0x8,%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 05 13 00 00       	call   801fce <sys_cputs>
  800cc9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ccc:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800cd3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <cprintf>:

int cprintf(const char *fmt, ...) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ce1:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800ce8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	e8 73 ff ff ff       	call   800c70 <vcprintf>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d0e:	e8 69 14 00 00       	call   80217c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d13:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	50                   	push   %eax
  800d23:	e8 48 ff ff ff       	call   800c70 <vcprintf>
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d2e:	e8 63 14 00 00       	call   802196 <sys_enable_interrupt>
	return cnt;
  800d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 14             	sub    $0x14,%esp
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d4b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d56:	77 55                	ja     800dad <printnum+0x75>
  800d58:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d5b:	72 05                	jb     800d62 <printnum+0x2a>
  800d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d60:	77 4b                	ja     800dad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d62:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d65:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d68:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	52                   	push   %edx
  800d71:	50                   	push   %eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	ff 75 f0             	pushl  -0x10(%ebp)
  800d78:	e8 7f 2a 00 00       	call   8037fc <__udivdi3>
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	53                   	push   %ebx
  800d87:	ff 75 18             	pushl  0x18(%ebp)
  800d8a:	52                   	push   %edx
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 a1 ff ff ff       	call   800d38 <printnum>
  800d97:	83 c4 20             	add    $0x20,%esp
  800d9a:	eb 1a                	jmp    800db6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 20             	pushl  0x20(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dad:	ff 4d 1c             	decl   0x1c(%ebp)
  800db0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800db4:	7f e6                	jg     800d9c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc4:	53                   	push   %ebx
  800dc5:	51                   	push   %ecx
  800dc6:	52                   	push   %edx
  800dc7:	50                   	push   %eax
  800dc8:	e8 3f 2b 00 00       	call   80390c <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 f4 3f 80 00       	add    $0x803ff4,%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f be c0             	movsbl %al,%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
}
  800de9:	90                   	nop
  800dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df6:	7e 1c                	jle    800e14 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 00                	mov    (%eax),%eax
  800dfd:	8d 50 08             	lea    0x8(%eax),%edx
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 10                	mov    %edx,(%eax)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8b 00                	mov    (%eax),%eax
  800e0a:	83 e8 08             	sub    $0x8,%eax
  800e0d:	8b 50 04             	mov    0x4(%eax),%edx
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	eb 40                	jmp    800e54 <getuint+0x65>
	else if (lflag)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 1e                	je     800e38 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	8d 50 04             	lea    0x4(%eax),%edx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 10                	mov    %edx,(%eax)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 e8 04             	sub    $0x4,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	eb 1c                	jmp    800e54 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8b 00                	mov    (%eax),%eax
  800e3d:	8d 50 04             	lea    0x4(%eax),%edx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 10                	mov    %edx,(%eax)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 e8 04             	sub    $0x4,%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e59:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e5d:	7e 1c                	jle    800e7b <getint+0x25>
		return va_arg(*ap, long long);
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	8d 50 08             	lea    0x8(%eax),%edx
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 10                	mov    %edx,(%eax)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 00                	mov    (%eax),%eax
  800e71:	83 e8 08             	sub    $0x8,%eax
  800e74:	8b 50 04             	mov    0x4(%eax),%edx
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	eb 38                	jmp    800eb3 <getint+0x5d>
	else if (lflag)
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	74 1a                	je     800e9b <getint+0x45>
		return va_arg(*ap, long);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	8d 50 04             	lea    0x4(%eax),%edx
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 10                	mov    %edx,(%eax)
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	83 e8 04             	sub    $0x4,%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	99                   	cltd   
  800e99:	eb 18                	jmp    800eb3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	8d 50 04             	lea    0x4(%eax),%edx
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 10                	mov    %edx,(%eax)
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	99                   	cltd   
}
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x21>
			if (ch == '\0')
  800ebf:	85 db                	test   %ebx,%ebx
  800ec1:	0f 84 af 03 00 00    	je     801276 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	53                   	push   %ebx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 10             	mov    %edx,0x10(%ebp)
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d8             	movzbl %al,%ebx
  800ee4:	83 fb 25             	cmp    $0x25,%ebx
  800ee7:	75 d6                	jne    800ebf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ee9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ef4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800efb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	0f b6 d8             	movzbl %al,%ebx
  800f17:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f1a:	83 f8 55             	cmp    $0x55,%eax
  800f1d:	0f 87 2b 03 00 00    	ja     80124e <vprintfmt+0x399>
  800f23:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
  800f2a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f2c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f30:	eb d7                	jmp    800f09 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f32:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f36:	eb d1                	jmp    800f09 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f42:	89 d0                	mov    %edx,%eax
  800f44:	c1 e0 02             	shl    $0x2,%eax
  800f47:	01 d0                	add    %edx,%eax
  800f49:	01 c0                	add    %eax,%eax
  800f4b:	01 d8                	add    %ebx,%eax
  800f4d:	83 e8 30             	sub    $0x30,%eax
  800f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f5b:	83 fb 2f             	cmp    $0x2f,%ebx
  800f5e:	7e 3e                	jle    800f9e <vprintfmt+0xe9>
  800f60:	83 fb 39             	cmp    $0x39,%ebx
  800f63:	7f 39                	jg     800f9e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f65:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f68:	eb d5                	jmp    800f3f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f7e:	eb 1f                	jmp    800f9f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	79 83                	jns    800f09 <vprintfmt+0x54>
				width = 0;
  800f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f8d:	e9 77 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f92:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f99:	e9 6b ff ff ff       	jmp    800f09 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f9e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa3:	0f 89 60 ff ff ff    	jns    800f09 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800faf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fb6:	e9 4e ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fbb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fbe:	e9 46 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 e8 04             	sub    $0x4,%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
			break;
  800fe3:	e9 89 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	83 c0 04             	add    $0x4,%eax
  800fee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	83 e8 04             	sub    $0x4,%eax
  800ff7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ff9:	85 db                	test   %ebx,%ebx
  800ffb:	79 02                	jns    800fff <vprintfmt+0x14a>
				err = -err;
  800ffd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fff:	83 fb 64             	cmp    $0x64,%ebx
  801002:	7f 0b                	jg     80100f <vprintfmt+0x15a>
  801004:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 05 40 80 00       	push   $0x804005
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 5e 02 00 00       	call   80127e <printfmt>
  801020:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801023:	e9 49 02 00 00       	jmp    801271 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801028:	56                   	push   %esi
  801029:	68 0e 40 80 00       	push   $0x80400e
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 45 02 00 00       	call   80127e <printfmt>
  801039:	83 c4 10             	add    $0x10,%esp
			break;
  80103c:	e9 30 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	83 e8 04             	sub    $0x4,%eax
  801050:	8b 30                	mov    (%eax),%esi
  801052:	85 f6                	test   %esi,%esi
  801054:	75 05                	jne    80105b <vprintfmt+0x1a6>
				p = "(null)";
  801056:	be 11 40 80 00       	mov    $0x804011,%esi
			if (width > 0 && padc != '-')
  80105b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105f:	7e 6d                	jle    8010ce <vprintfmt+0x219>
  801061:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801065:	74 67                	je     8010ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	e8 0c 03 00 00       	call   801380 <strnlen>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80107a:	eb 16                	jmp    801092 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80107c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801080:	83 ec 08             	sub    $0x8,%esp
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	50                   	push   %eax
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80108f:	ff 4d e4             	decl   -0x1c(%ebp)
  801092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801096:	7f e4                	jg     80107c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801098:	eb 34                	jmp    8010ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80109a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80109e:	74 1c                	je     8010bc <vprintfmt+0x207>
  8010a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010a3:	7e 05                	jle    8010aa <vprintfmt+0x1f5>
  8010a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8010a8:	7e 12                	jle    8010bc <vprintfmt+0x207>
					putch('?', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 3f                	push   $0x3f
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	eb 0f                	jmp    8010cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 0c             	pushl  0xc(%ebp)
  8010c2:	53                   	push   %ebx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	8d 70 01             	lea    0x1(%eax),%esi
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f be d8             	movsbl %al,%ebx
  8010d8:	85 db                	test   %ebx,%ebx
  8010da:	74 24                	je     801100 <vprintfmt+0x24b>
  8010dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e0:	78 b8                	js     80109a <vprintfmt+0x1e5>
  8010e2:	ff 4d e0             	decl   -0x20(%ebp)
  8010e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e9:	79 af                	jns    80109a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010eb:	eb 13                	jmp    801100 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 20                	push   $0x20
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fd:	ff 4d e4             	decl   -0x1c(%ebp)
  801100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801104:	7f e7                	jg     8010ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801106:	e9 66 01 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 e8             	pushl  -0x18(%ebp)
  801111:	8d 45 14             	lea    0x14(%ebp),%eax
  801114:	50                   	push   %eax
  801115:	e8 3c fd ff ff       	call   800e56 <getint>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801120:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	85 d2                	test   %edx,%edx
  80112b:	79 23                	jns    801150 <vprintfmt+0x29b>
				putch('-', putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	6a 2d                	push   $0x2d
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	f7 d8                	neg    %eax
  801145:	83 d2 00             	adc    $0x0,%edx
  801148:	f7 da                	neg    %edx
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801150:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801157:	e9 bc 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 e8             	pushl  -0x18(%ebp)
  801162:	8d 45 14             	lea    0x14(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	e8 84 fc ff ff       	call   800def <getuint>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801174:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117b:	e9 98 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	6a 58                	push   $0x58
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	ff d0                	call   *%eax
  80118d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	6a 58                	push   $0x58
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	6a 58                	push   $0x58
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	ff d0                	call   *%eax
  8011ad:	83 c4 10             	add    $0x10,%esp
			break;
  8011b0:	e9 bc 00 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	6a 30                	push   $0x30
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	6a 78                	push   $0x78
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	ff d0                	call   *%eax
  8011d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 14             	mov    %eax,0x14(%ebp)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	83 e8 04             	sub    $0x4,%eax
  8011e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011f7:	eb 1f                	jmp    801218 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ff:	8d 45 14             	lea    0x14(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	e8 e7 fb ff ff       	call   800def <getuint>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801211:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801218:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80121c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	52                   	push   %edx
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	50                   	push   %eax
  801227:	ff 75 f4             	pushl  -0xc(%ebp)
  80122a:	ff 75 f0             	pushl  -0x10(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 00 fb ff ff       	call   800d38 <printnum>
  801238:	83 c4 20             	add    $0x20,%esp
			break;
  80123b:	eb 34                	jmp    801271 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80123d:	83 ec 08             	sub    $0x8,%esp
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	53                   	push   %ebx
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	ff d0                	call   *%eax
  801249:	83 c4 10             	add    $0x10,%esp
			break;
  80124c:	eb 23                	jmp    801271 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	6a 25                	push   $0x25
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	ff d0                	call   *%eax
  80125b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125e:	ff 4d 10             	decl   0x10(%ebp)
  801261:	eb 03                	jmp    801266 <vprintfmt+0x3b1>
  801263:	ff 4d 10             	decl   0x10(%ebp)
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 25                	cmp    $0x25,%al
  80126e:	75 f3                	jne    801263 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801270:	90                   	nop
		}
	}
  801271:	e9 47 fc ff ff       	jmp    800ebd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801276:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801284:	8d 45 10             	lea    0x10(%ebp),%eax
  801287:	83 c0 04             	add    $0x4,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	ff 75 f4             	pushl  -0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	ff 75 08             	pushl  0x8(%ebp)
  80129a:	e8 16 fc ff ff       	call   800eb5 <vprintfmt>
  80129f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	8b 40 08             	mov    0x8(%eax),%eax
  8012ae:	8d 50 01             	lea    0x1(%eax),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8b 10                	mov    (%eax),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 40 04             	mov    0x4(%eax),%eax
  8012c2:	39 c2                	cmp    %eax,%edx
  8012c4:	73 12                	jae    8012d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	89 0a                	mov    %ecx,(%edx)
  8012d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d6:	88 10                	mov    %dl,(%eax)
}
  8012d8:	90                   	nop
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801300:	74 06                	je     801308 <vsnprintf+0x2d>
  801302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801306:	7f 07                	jg     80130f <vsnprintf+0x34>
		return -E_INVAL;
  801308:	b8 03 00 00 00       	mov    $0x3,%eax
  80130d:	eb 20                	jmp    80132f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130f:	ff 75 14             	pushl  0x14(%ebp)
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	68 a5 12 80 00       	push   $0x8012a5
  80131e:	e8 92 fb ff ff       	call   800eb5 <vprintfmt>
  801323:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801329:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801337:	8d 45 10             	lea    0x10(%ebp),%eax
  80133a:	83 c0 04             	add    $0x4,%eax
  80133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 89 ff ff ff       	call   8012db <vsnprintf>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80155d:	eb 0e                	jmp    80156d <memset+0x22>
		*p++ = c;
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8d 50 01             	lea    0x1(%eax),%edx
  801565:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80156d:	ff 4d f8             	decl   -0x8(%ebp)
  801570:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801574:	79 e9                	jns    80155f <memset+0x14>
		*p++ = c;

	return v;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80158d:	eb 16                	jmp    8015a5 <memcpy+0x2a>
		*d++ = *s++;
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801598:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	75 dd                	jne    80158f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015cf:	73 50                	jae    801621 <memmove+0x6a>
  8015d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dc:	76 43                	jbe    801621 <memmove+0x6a>
		s += n;
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ea:	eb 10                	jmp    8015fc <memmove+0x45>
			*--d = *--s;
  8015ec:	ff 4d f8             	decl   -0x8(%ebp)
  8015ef:	ff 4d fc             	decl   -0x4(%ebp)
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f5:	8a 10                	mov    (%eax),%dl
  8015f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 e3                	jne    8015ec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801609:	eb 23                	jmp    80162e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801645:	eb 2a                	jmp    801671 <memcmp+0x3e>
		if (*s1 != *s2)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	8a 10                	mov    (%eax),%dl
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	38 c2                	cmp    %al,%dl
  801653:	74 16                	je     80166b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f b6 d0             	movzbl %al,%edx
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f b6 c0             	movzbl %al,%eax
  801665:	29 c2                	sub    %eax,%edx
  801667:	89 d0                	mov    %edx,%eax
  801669:	eb 18                	jmp    801683 <memcmp+0x50>
		s1++, s2++;
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	8d 50 ff             	lea    -0x1(%eax),%edx
  801677:	89 55 10             	mov    %edx,0x10(%ebp)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	75 c9                	jne    801647 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801696:	eb 15                	jmp    8016ad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f b6 d0             	movzbl %al,%edx
  8016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	39 c2                	cmp    %eax,%edx
  8016a8:	74 0d                	je     8016b7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016aa:	ff 45 08             	incl   0x8(%ebp)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016b3:	72 e3                	jb     801698 <memfind+0x13>
  8016b5:	eb 01                	jmp    8016b8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016b7:	90                   	nop
	return (void *) s;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d1:	eb 03                	jmp    8016d6 <strtol+0x19>
		s++;
  8016d3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 20                	cmp    $0x20,%al
  8016dd:	74 f4                	je     8016d3 <strtol+0x16>
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	3c 09                	cmp    $0x9,%al
  8016e6:	74 eb                	je     8016d3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 2b                	cmp    $0x2b,%al
  8016ef:	75 05                	jne    8016f6 <strtol+0x39>
		s++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	eb 13                	jmp    801709 <strtol+0x4c>
	else if (*s == '-')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2d                	cmp    $0x2d,%al
  8016fd:	75 0a                	jne    801709 <strtol+0x4c>
		s++, neg = 1;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	74 06                	je     801715 <strtol+0x58>
  80170f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801713:	75 20                	jne    801735 <strtol+0x78>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	3c 30                	cmp    $0x30,%al
  80171c:	75 17                	jne    801735 <strtol+0x78>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	40                   	inc    %eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	3c 78                	cmp    $0x78,%al
  801726:	75 0d                	jne    801735 <strtol+0x78>
		s += 2, base = 16;
  801728:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80172c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801733:	eb 28                	jmp    80175d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801739:	75 15                	jne    801750 <strtol+0x93>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3c 30                	cmp    $0x30,%al
  801742:	75 0c                	jne    801750 <strtol+0x93>
		s++, base = 8;
  801744:	ff 45 08             	incl   0x8(%ebp)
  801747:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80174e:	eb 0d                	jmp    80175d <strtol+0xa0>
	else if (base == 0)
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	75 07                	jne    80175d <strtol+0xa0>
		base = 10;
  801756:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3c 2f                	cmp    $0x2f,%al
  801764:	7e 19                	jle    80177f <strtol+0xc2>
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	3c 39                	cmp    $0x39,%al
  80176d:	7f 10                	jg     80177f <strtol+0xc2>
			dig = *s - '0';
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f be c0             	movsbl %al,%eax
  801777:	83 e8 30             	sub    $0x30,%eax
  80177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80177d:	eb 42                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 60                	cmp    $0x60,%al
  801786:	7e 19                	jle    8017a1 <strtol+0xe4>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 7a                	cmp    $0x7a,%al
  80178f:	7f 10                	jg     8017a1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 57             	sub    $0x57,%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179f:	eb 20                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 40                	cmp    $0x40,%al
  8017a8:	7e 39                	jle    8017e3 <strtol+0x126>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 5a                	cmp    $0x5a,%al
  8017b1:	7f 30                	jg     8017e3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 37             	sub    $0x37,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017c7:	7d 19                	jge    8017e2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017c9:	ff 45 08             	incl   0x8(%ebp)
  8017cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017dd:	e9 7b ff ff ff       	jmp    80175d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e7:	74 08                	je     8017f1 <strtol+0x134>
		*endptr = (char *) s;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ef:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017f5:	74 07                	je     8017fe <strtol+0x141>
  8017f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fa:	f7 d8                	neg    %eax
  8017fc:	eb 03                	jmp    801801 <strtol+0x144>
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <ltostr>:

void
ltostr(long value, char *str)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801810:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181b:	79 13                	jns    801830 <ltostr+0x2d>
	{
		neg = 1;
  80181d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80182a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80182d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801838:	99                   	cltd   
  801839:	f7 f9                	idiv   %ecx
  80183b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	8d 50 01             	lea    0x1(%eax),%edx
  801844:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801847:	89 c2                	mov    %eax,%edx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801851:	83 c2 30             	add    $0x30,%edx
  801854:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801859:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80185e:	f7 e9                	imul   %ecx
  801860:	c1 fa 02             	sar    $0x2,%edx
  801863:	89 c8                	mov    %ecx,%eax
  801865:	c1 f8 1f             	sar    $0x1f,%eax
  801868:	29 c2                	sub    %eax,%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80186f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801872:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801877:	f7 e9                	imul   %ecx
  801879:	c1 fa 02             	sar    $0x2,%edx
  80187c:	89 c8                	mov    %ecx,%eax
  80187e:	c1 f8 1f             	sar    $0x1f,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	01 c0                	add    %eax,%eax
  80188c:	29 c1                	sub    %eax,%ecx
  80188e:	89 ca                	mov    %ecx,%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	75 9c                	jne    801830 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	48                   	dec    %eax
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a6:	74 3d                	je     8018e5 <ltostr+0xe2>
		start = 1 ;
  8018a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018af:	eb 34                	jmp    8018e5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 c2                	add    %eax,%edx
  8018c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	01 c2                	add    %eax,%edx
  8018da:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018dd:	88 02                	mov    %al,(%edx)
		start++ ;
  8018df:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018e2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	7c c4                	jl     8018b1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 54 fa ff ff       	call   80135d <strlen>
  801909:	83 c4 04             	add    $0x4,%esp
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	e8 46 fa ff ff       	call   80135d <strlen>
  801917:	83 c4 04             	add    $0x4,%esp
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80191d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192b:	eb 17                	jmp    801944 <strcconcat+0x49>
		final[s] = str1[s] ;
  80192d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	01 c2                	add    %eax,%edx
  801935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	01 c8                	add    %ecx,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801941:	ff 45 fc             	incl   -0x4(%ebp)
  801944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801947:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80194a:	7c e1                	jl     80192d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80194c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801953:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80195a:	eb 1f                	jmp    80197b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195f:	8d 50 01             	lea    0x1(%eax),%edx
  801962:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801965:	89 c2                	mov    %eax,%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801978:	ff 45 f8             	incl   -0x8(%ebp)
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801981:	7c d9                	jl     80195c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c6 00 00             	movb   $0x0,(%eax)
}
  80198e:	90                   	nop
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801994:	8b 45 14             	mov    0x14(%ebp),%eax
  801997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80199d:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b4:	eb 0c                	jmp    8019c2 <strsplit+0x31>
			*string++ = 0;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8d 50 01             	lea    0x1(%eax),%edx
  8019bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8019bf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	84 c0                	test   %al,%al
  8019c9:	74 18                	je     8019e3 <strsplit+0x52>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	e8 13 fb ff ff       	call   8014ef <strchr>
  8019dc:	83 c4 08             	add    $0x8,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 d3                	jne    8019b6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	84 c0                	test   %al,%al
  8019ea:	74 5a                	je     801a46 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 f8 0f             	cmp    $0xf,%eax
  8019f4:	75 07                	jne    8019fd <strsplit+0x6c>
		{
			return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	eb 66                	jmp    801a63 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 48 01             	lea    0x1(%eax),%ecx
  801a05:	8b 55 14             	mov    0x14(%ebp),%edx
  801a08:	89 0a                	mov    %ecx,(%edx)
  801a0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a11:	8b 45 10             	mov    0x10(%ebp),%eax
  801a14:	01 c2                	add    %eax,%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a1b:	eb 03                	jmp    801a20 <strsplit+0x8f>
			string++;
  801a1d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	84 c0                	test   %al,%al
  801a27:	74 8b                	je     8019b4 <strsplit+0x23>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f be c0             	movsbl %al,%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 b5 fa ff ff       	call   8014ef <strchr>
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	74 dc                	je     801a1d <strsplit+0x8c>
			string++;
	}
  801a41:	e9 6e ff ff ff       	jmp    8019b4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a46:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	01 d0                	add    %edx,%eax
  801a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801a6b:	a1 04 50 80 00       	mov    0x805004,%eax
  801a70:	85 c0                	test   %eax,%eax
  801a72:	74 1f                	je     801a93 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801a74:	e8 1d 00 00 00       	call   801a96 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	68 70 41 80 00       	push   $0x804170
  801a81:	e8 55 f2 ff ff       	call   800cdb <cprintf>
  801a86:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a89:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a90:	00 00 00 
	}
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801a9c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801aa3:	00 00 00 
  801aa6:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801aad:	00 00 00 
  801ab0:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ab7:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801aba:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801ac1:	00 00 00 
  801ac4:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801acb:	00 00 00 
  801ace:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ad5:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801ad8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801adf:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801ae2:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801ae9:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801af8:	2d 00 10 00 00       	sub    $0x1000,%eax
  801afd:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801b02:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  801b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b11:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	6a 06                	push   $0x6
  801b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1e:	50                   	push   %eax
  801b1f:	e8 ee 05 00 00       	call   802112 <sys_allocate_chunk>
  801b24:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b27:	a1 20 51 80 00       	mov    0x805120,%eax
  801b2c:	83 ec 0c             	sub    $0xc,%esp
  801b2f:	50                   	push   %eax
  801b30:	e8 63 0c 00 00       	call   802798 <initialize_MemBlocksList>
  801b35:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  801b38:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801b3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  801b40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b43:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  801b4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b4d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b5b:	89 c2                	mov    %eax,%edx
  801b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b60:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  801b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b66:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801b6d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b77:	8b 50 08             	mov    0x8(%eax),%edx
  801b7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b7d:	01 d0                	add    %edx,%eax
  801b7f:	48                   	dec    %eax
  801b80:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b86:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8b:	f7 75 e0             	divl   -0x20(%ebp)
  801b8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b91:	29 d0                	sub    %edx,%eax
  801b93:	89 c2                	mov    %eax,%edx
  801b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b98:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801b9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b9f:	75 14                	jne    801bb5 <initialize_dyn_block_system+0x11f>
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	68 95 41 80 00       	push   $0x804195
  801ba9:	6a 34                	push   $0x34
  801bab:	68 b3 41 80 00       	push   $0x8041b3
  801bb0:	e8 72 ee ff ff       	call   800a27 <_panic>
  801bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bb8:	8b 00                	mov    (%eax),%eax
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	74 10                	je     801bce <initialize_dyn_block_system+0x138>
  801bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bc1:	8b 00                	mov    (%eax),%eax
  801bc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bc6:	8b 52 04             	mov    0x4(%edx),%edx
  801bc9:	89 50 04             	mov    %edx,0x4(%eax)
  801bcc:	eb 0b                	jmp    801bd9 <initialize_dyn_block_system+0x143>
  801bce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd1:	8b 40 04             	mov    0x4(%eax),%eax
  801bd4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801bd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bdc:	8b 40 04             	mov    0x4(%eax),%eax
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	74 0f                	je     801bf2 <initialize_dyn_block_system+0x15c>
  801be3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801be6:	8b 40 04             	mov    0x4(%eax),%eax
  801be9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bec:	8b 12                	mov    (%edx),%edx
  801bee:	89 10                	mov    %edx,(%eax)
  801bf0:	eb 0a                	jmp    801bfc <initialize_dyn_block_system+0x166>
  801bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bf5:	8b 00                	mov    (%eax),%eax
  801bf7:	a3 48 51 80 00       	mov    %eax,0x805148
  801bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c0f:	a1 54 51 80 00       	mov    0x805154,%eax
  801c14:	48                   	dec    %eax
  801c15:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	ff 75 e8             	pushl  -0x18(%ebp)
  801c20:	e8 c4 13 00 00       	call   802fe9 <insert_sorted_with_merge_freeList>
  801c25:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801c28:	90                   	nop
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <malloc>:
//=================================



void* malloc(uint32 size)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c31:	e8 2f fe ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c3a:	75 07                	jne    801c43 <malloc+0x18>
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c41:	eb 71                	jmp    801cb4 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801c43:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801c4a:	76 07                	jbe    801c53 <malloc+0x28>
	return NULL;
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c51:	eb 61                	jmp    801cb4 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c53:	e8 88 08 00 00       	call   8024e0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	74 53                	je     801caf <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801c5c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c63:	8b 55 08             	mov    0x8(%ebp),%edx
  801c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c69:	01 d0                	add    %edx,%eax
  801c6b:	48                   	dec    %eax
  801c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c72:	ba 00 00 00 00       	mov    $0x0,%edx
  801c77:	f7 75 f4             	divl   -0xc(%ebp)
  801c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7d:	29 d0                	sub    %edx,%eax
  801c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801c82:	83 ec 0c             	sub    $0xc,%esp
  801c85:	ff 75 ec             	pushl  -0x14(%ebp)
  801c88:	e8 d2 0d 00 00       	call   802a5f <alloc_block_FF>
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801c93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c97:	74 16                	je     801caf <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801c99:	83 ec 0c             	sub    $0xc,%esp
  801c9c:	ff 75 e8             	pushl  -0x18(%ebp)
  801c9f:	e8 0c 0c 00 00       	call   8028b0 <insert_sorted_allocList>
  801ca4:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801caa:	8b 40 08             	mov    0x8(%eax),%eax
  801cad:	eb 05                	jmp    801cb4 <malloc+0x89>
    }

			}


	return NULL;
  801caf:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801ccd:	83 ec 08             	sub    $0x8,%esp
  801cd0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd3:	68 40 50 80 00       	push   $0x805040
  801cd8:	e8 a0 0b 00 00       	call   80287d <find_block>
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce6:	8b 50 0c             	mov    0xc(%eax),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	e8 e4 03 00 00       	call   8020da <sys_free_user_mem>
  801cf6:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801cf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cfd:	75 17                	jne    801d16 <free+0x60>
  801cff:	83 ec 04             	sub    $0x4,%esp
  801d02:	68 95 41 80 00       	push   $0x804195
  801d07:	68 84 00 00 00       	push   $0x84
  801d0c:	68 b3 41 80 00       	push   $0x8041b3
  801d11:	e8 11 ed ff ff       	call   800a27 <_panic>
  801d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d19:	8b 00                	mov    (%eax),%eax
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	74 10                	je     801d2f <free+0x79>
  801d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d22:	8b 00                	mov    (%eax),%eax
  801d24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d27:	8b 52 04             	mov    0x4(%edx),%edx
  801d2a:	89 50 04             	mov    %edx,0x4(%eax)
  801d2d:	eb 0b                	jmp    801d3a <free+0x84>
  801d2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d32:	8b 40 04             	mov    0x4(%eax),%eax
  801d35:	a3 44 50 80 00       	mov    %eax,0x805044
  801d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3d:	8b 40 04             	mov    0x4(%eax),%eax
  801d40:	85 c0                	test   %eax,%eax
  801d42:	74 0f                	je     801d53 <free+0x9d>
  801d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d47:	8b 40 04             	mov    0x4(%eax),%eax
  801d4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d4d:	8b 12                	mov    (%edx),%edx
  801d4f:	89 10                	mov    %edx,(%eax)
  801d51:	eb 0a                	jmp    801d5d <free+0xa7>
  801d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d56:	8b 00                	mov    (%eax),%eax
  801d58:	a3 40 50 80 00       	mov    %eax,0x805040
  801d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d70:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d75:	48                   	dec    %eax
  801d76:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	ff 75 ec             	pushl  -0x14(%ebp)
  801d81:	e8 63 12 00 00       	call   802fe9 <insert_sorted_with_merge_freeList>
  801d86:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801d89:	90                   	nop
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 38             	sub    $0x38,%esp
  801d92:	8b 45 10             	mov    0x10(%ebp),%eax
  801d95:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d98:	e8 c8 fc ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801da1:	75 0a                	jne    801dad <smalloc+0x21>
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	e9 a0 00 00 00       	jmp    801e4d <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801dad:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801db4:	76 0a                	jbe    801dc0 <smalloc+0x34>
		return NULL;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbb:	e9 8d 00 00 00       	jmp    801e4d <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801dc0:	e8 1b 07 00 00       	call   8024e0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	74 7f                	je     801e48 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801dc9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	01 d0                	add    %edx,%eax
  801dd8:	48                   	dec    %eax
  801dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  801de4:	f7 75 f4             	divl   -0xc(%ebp)
  801de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dea:	29 d0                	sub    %edx,%eax
  801dec:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801def:	83 ec 0c             	sub    $0xc,%esp
  801df2:	ff 75 ec             	pushl  -0x14(%ebp)
  801df5:	e8 65 0c 00 00       	call   802a5f <alloc_block_FF>
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801e00:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e04:	74 42                	je     801e48 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801e06:	83 ec 0c             	sub    $0xc,%esp
  801e09:	ff 75 e8             	pushl  -0x18(%ebp)
  801e0c:	e8 9f 0a 00 00       	call   8028b0 <insert_sorted_allocList>
  801e11:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801e14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e17:	8b 40 08             	mov    0x8(%eax),%eax
  801e1a:	89 c2                	mov    %eax,%edx
  801e1c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e20:	52                   	push   %edx
  801e21:	50                   	push   %eax
  801e22:	ff 75 0c             	pushl  0xc(%ebp)
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	e8 38 04 00 00       	call   802265 <sys_createSharedObject>
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801e33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e37:	79 07                	jns    801e40 <smalloc+0xb4>
	    		  return NULL;
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	eb 0d                	jmp    801e4d <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e43:	8b 40 08             	mov    0x8(%eax),%eax
  801e46:	eb 05                	jmp    801e4d <smalloc+0xc1>


				}


		return NULL;
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e55:	e8 0b fc ff ff       	call   801a65 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801e5a:	e8 81 06 00 00       	call   8024e0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	0f 84 9f 00 00 00    	je     801f06 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e67:	83 ec 08             	sub    $0x8,%esp
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	e8 1a 04 00 00       	call   80228f <sys_getSizeOfSharedObject>
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801e7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7f:	79 0a                	jns    801e8b <sget+0x3c>
		return NULL;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	e9 80 00 00 00       	jmp    801f0b <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801e8b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e98:	01 d0                	add    %edx,%eax
  801e9a:	48                   	dec    %eax
  801e9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea6:	f7 75 f0             	divl   -0x10(%ebp)
  801ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eac:	29 d0                	sub    %edx,%eax
  801eae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801eb1:	83 ec 0c             	sub    $0xc,%esp
  801eb4:	ff 75 e8             	pushl  -0x18(%ebp)
  801eb7:	e8 a3 0b 00 00       	call   802a5f <alloc_block_FF>
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801ec2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ec6:	74 3e                	je     801f06 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ece:	e8 dd 09 00 00       	call   8028b0 <insert_sorted_allocList>
  801ed3:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed9:	8b 40 08             	mov    0x8(%eax),%eax
  801edc:	83 ec 04             	sub    $0x4,%esp
  801edf:	50                   	push   %eax
  801ee0:	ff 75 0c             	pushl  0xc(%ebp)
  801ee3:	ff 75 08             	pushl  0x8(%ebp)
  801ee6:	e8 c1 03 00 00       	call   8022ac <sys_getSharedObject>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801ef1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ef5:	79 07                	jns    801efe <sget+0xaf>
	    		  return NULL;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	eb 0d                	jmp    801f0b <sget+0xbc>
	  	return(void*) returned_block->sva;
  801efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f01:	8b 40 08             	mov    0x8(%eax),%eax
  801f04:	eb 05                	jmp    801f0b <sget+0xbc>
	      }
	}
	   return NULL;
  801f06:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f13:	e8 4d fb ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	68 c0 41 80 00       	push   $0x8041c0
  801f20:	68 12 01 00 00       	push   $0x112
  801f25:	68 b3 41 80 00       	push   $0x8041b3
  801f2a:	e8 f8 ea ff ff       	call   800a27 <_panic>

00801f2f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f35:	83 ec 04             	sub    $0x4,%esp
  801f38:	68 e8 41 80 00       	push   $0x8041e8
  801f3d:	68 26 01 00 00       	push   $0x126
  801f42:	68 b3 41 80 00       	push   $0x8041b3
  801f47:	e8 db ea ff ff       	call   800a27 <_panic>

00801f4c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f52:	83 ec 04             	sub    $0x4,%esp
  801f55:	68 0c 42 80 00       	push   $0x80420c
  801f5a:	68 31 01 00 00       	push   $0x131
  801f5f:	68 b3 41 80 00       	push   $0x8041b3
  801f64:	e8 be ea ff ff       	call   800a27 <_panic>

00801f69 <shrink>:

}
void shrink(uint32 newSize)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f6f:	83 ec 04             	sub    $0x4,%esp
  801f72:	68 0c 42 80 00       	push   $0x80420c
  801f77:	68 36 01 00 00       	push   $0x136
  801f7c:	68 b3 41 80 00       	push   $0x8041b3
  801f81:	e8 a1 ea ff ff       	call   800a27 <_panic>

00801f86 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f8c:	83 ec 04             	sub    $0x4,%esp
  801f8f:	68 0c 42 80 00       	push   $0x80420c
  801f94:	68 3b 01 00 00       	push   $0x13b
  801f99:	68 b3 41 80 00       	push   $0x8041b3
  801f9e:	e8 84 ea ff ff       	call   800a27 <_panic>

00801fa3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	57                   	push   %edi
  801fa7:	56                   	push   %esi
  801fa8:	53                   	push   %ebx
  801fa9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fb5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb8:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fbb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fbe:	cd 30                	int    $0x30
  801fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	5b                   	pop    %ebx
  801fca:	5e                   	pop    %esi
  801fcb:	5f                   	pop    %edi
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    

00801fce <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fda:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	52                   	push   %edx
  801fe6:	ff 75 0c             	pushl  0xc(%ebp)
  801fe9:	50                   	push   %eax
  801fea:	6a 00                	push   $0x0
  801fec:	e8 b2 ff ff ff       	call   801fa3 <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	90                   	nop
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 01                	push   $0x1
  802006:	e8 98 ff ff ff       	call   801fa3 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802013:	8b 55 0c             	mov    0xc(%ebp),%edx
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	52                   	push   %edx
  802020:	50                   	push   %eax
  802021:	6a 05                	push   $0x5
  802023:	e8 7b ff ff ff       	call   801fa3 <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	56                   	push   %esi
  802031:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802032:	8b 75 18             	mov    0x18(%ebp),%esi
  802035:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802038:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	56                   	push   %esi
  802042:	53                   	push   %ebx
  802043:	51                   	push   %ecx
  802044:	52                   	push   %edx
  802045:	50                   	push   %eax
  802046:	6a 06                	push   $0x6
  802048:	e8 56 ff ff ff       	call   801fa3 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802053:	5b                   	pop    %ebx
  802054:	5e                   	pop    %esi
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    

00802057 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80205a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	52                   	push   %edx
  802067:	50                   	push   %eax
  802068:	6a 07                	push   $0x7
  80206a:	e8 34 ff ff ff       	call   801fa3 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	ff 75 08             	pushl  0x8(%ebp)
  802083:	6a 08                	push   $0x8
  802085:	e8 19 ff ff ff       	call   801fa3 <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 09                	push   $0x9
  80209e:	e8 00 ff ff ff       	call   801fa3 <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 0a                	push   $0xa
  8020b7:	e8 e7 fe ff ff       	call   801fa3 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 0b                	push   $0xb
  8020d0:	e8 ce fe ff ff       	call   801fa3 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	ff 75 0c             	pushl  0xc(%ebp)
  8020e6:	ff 75 08             	pushl  0x8(%ebp)
  8020e9:	6a 0f                	push   $0xf
  8020eb:	e8 b3 fe ff ff       	call   801fa3 <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
	return;
  8020f3:	90                   	nop
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	ff 75 0c             	pushl  0xc(%ebp)
  802102:	ff 75 08             	pushl  0x8(%ebp)
  802105:	6a 10                	push   $0x10
  802107:	e8 97 fe ff ff       	call   801fa3 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
	return ;
  80210f:	90                   	nop
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	ff 75 10             	pushl  0x10(%ebp)
  80211c:	ff 75 0c             	pushl  0xc(%ebp)
  80211f:	ff 75 08             	pushl  0x8(%ebp)
  802122:	6a 11                	push   $0x11
  802124:	e8 7a fe ff ff       	call   801fa3 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
	return ;
  80212c:	90                   	nop
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 0c                	push   $0xc
  80213e:	e8 60 fe ff ff       	call   801fa3 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	ff 75 08             	pushl  0x8(%ebp)
  802156:	6a 0d                	push   $0xd
  802158:	e8 46 fe ff ff       	call   801fa3 <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 0e                	push   $0xe
  802171:	e8 2d fe ff ff       	call   801fa3 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	90                   	nop
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 13                	push   $0x13
  80218b:	e8 13 fe ff ff       	call   801fa3 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	90                   	nop
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 14                	push   $0x14
  8021a5:	e8 f9 fd ff ff       	call   801fa3 <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
}
  8021ad:	90                   	nop
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 04             	sub    $0x4,%esp
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	50                   	push   %eax
  8021c9:	6a 15                	push   $0x15
  8021cb:	e8 d3 fd ff ff       	call   801fa3 <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
}
  8021d3:	90                   	nop
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 16                	push   $0x16
  8021e5:	e8 b9 fd ff ff       	call   801fa3 <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
}
  8021ed:	90                   	nop
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	ff 75 0c             	pushl  0xc(%ebp)
  8021ff:	50                   	push   %eax
  802200:	6a 17                	push   $0x17
  802202:	e8 9c fd ff ff       	call   801fa3 <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80220f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	52                   	push   %edx
  80221c:	50                   	push   %eax
  80221d:	6a 1a                	push   $0x1a
  80221f:	e8 7f fd ff ff       	call   801fa3 <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80222c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	52                   	push   %edx
  802239:	50                   	push   %eax
  80223a:	6a 18                	push   $0x18
  80223c:	e8 62 fd ff ff       	call   801fa3 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
}
  802244:	90                   	nop
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80224a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	52                   	push   %edx
  802257:	50                   	push   %eax
  802258:	6a 19                	push   $0x19
  80225a:	e8 44 fd ff ff       	call   801fa3 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	90                   	nop
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 04             	sub    $0x4,%esp
  80226b:	8b 45 10             	mov    0x10(%ebp),%eax
  80226e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802271:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802274:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	6a 00                	push   $0x0
  80227d:	51                   	push   %ecx
  80227e:	52                   	push   %edx
  80227f:	ff 75 0c             	pushl  0xc(%ebp)
  802282:	50                   	push   %eax
  802283:	6a 1b                	push   $0x1b
  802285:	e8 19 fd ff ff       	call   801fa3 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802292:	8b 55 0c             	mov    0xc(%ebp),%edx
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	52                   	push   %edx
  80229f:	50                   	push   %eax
  8022a0:	6a 1c                	push   $0x1c
  8022a2:	e8 fc fc ff ff       	call   801fa3 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	51                   	push   %ecx
  8022bd:	52                   	push   %edx
  8022be:	50                   	push   %eax
  8022bf:	6a 1d                	push   $0x1d
  8022c1:	e8 dd fc ff ff       	call   801fa3 <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	52                   	push   %edx
  8022db:	50                   	push   %eax
  8022dc:	6a 1e                	push   $0x1e
  8022de:	e8 c0 fc ff ff       	call   801fa3 <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 1f                	push   $0x1f
  8022f7:	e8 a7 fc ff ff       	call   801fa3 <syscall>
  8022fc:	83 c4 18             	add    $0x18,%esp
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	ff 75 14             	pushl  0x14(%ebp)
  80230c:	ff 75 10             	pushl  0x10(%ebp)
  80230f:	ff 75 0c             	pushl  0xc(%ebp)
  802312:	50                   	push   %eax
  802313:	6a 20                	push   $0x20
  802315:	e8 89 fc ff ff       	call   801fa3 <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	50                   	push   %eax
  80232e:	6a 21                	push   $0x21
  802330:	e8 6e fc ff ff       	call   801fa3 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	90                   	nop
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	50                   	push   %eax
  80234a:	6a 22                	push   $0x22
  80234c:	e8 52 fc ff ff       	call   801fa3 <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 02                	push   $0x2
  802365:	e8 39 fc ff ff       	call   801fa3 <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 03                	push   $0x3
  80237e:	e8 20 fc ff ff       	call   801fa3 <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 04                	push   $0x4
  802397:	e8 07 fc ff ff       	call   801fa3 <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <sys_exit_env>:


void sys_exit_env(void)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 23                	push   $0x23
  8023b0:	e8 ee fb ff ff       	call   801fa3 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
}
  8023b8:	90                   	nop
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023c1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023c4:	8d 50 04             	lea    0x4(%eax),%edx
  8023c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	52                   	push   %edx
  8023d1:	50                   	push   %eax
  8023d2:	6a 24                	push   $0x24
  8023d4:	e8 ca fb ff ff       	call   801fa3 <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
	return result;
  8023dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023e5:	89 01                	mov    %eax,(%ecx)
  8023e7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	c9                   	leave  
  8023ee:	c2 04 00             	ret    $0x4

008023f1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	ff 75 10             	pushl  0x10(%ebp)
  8023fb:	ff 75 0c             	pushl  0xc(%ebp)
  8023fe:	ff 75 08             	pushl  0x8(%ebp)
  802401:	6a 12                	push   $0x12
  802403:	e8 9b fb ff ff       	call   801fa3 <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
	return ;
  80240b:	90                   	nop
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <sys_rcr2>:
uint32 sys_rcr2()
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 25                	push   $0x25
  80241d:	e8 81 fb ff ff       	call   801fa3 <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 04             	sub    $0x4,%esp
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802433:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	50                   	push   %eax
  802440:	6a 26                	push   $0x26
  802442:	e8 5c fb ff ff       	call   801fa3 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
	return ;
  80244a:	90                   	nop
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <rsttst>:
void rsttst()
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 28                	push   $0x28
  80245c:	e8 42 fb ff ff       	call   801fa3 <syscall>
  802461:	83 c4 18             	add    $0x18,%esp
	return ;
  802464:	90                   	nop
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 04             	sub    $0x4,%esp
  80246d:	8b 45 14             	mov    0x14(%ebp),%eax
  802470:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802473:	8b 55 18             	mov    0x18(%ebp),%edx
  802476:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80247a:	52                   	push   %edx
  80247b:	50                   	push   %eax
  80247c:	ff 75 10             	pushl  0x10(%ebp)
  80247f:	ff 75 0c             	pushl  0xc(%ebp)
  802482:	ff 75 08             	pushl  0x8(%ebp)
  802485:	6a 27                	push   $0x27
  802487:	e8 17 fb ff ff       	call   801fa3 <syscall>
  80248c:	83 c4 18             	add    $0x18,%esp
	return ;
  80248f:	90                   	nop
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <chktst>:
void chktst(uint32 n)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	ff 75 08             	pushl  0x8(%ebp)
  8024a0:	6a 29                	push   $0x29
  8024a2:	e8 fc fa ff ff       	call   801fa3 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024aa:	90                   	nop
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <inctst>:

void inctst()
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 2a                	push   $0x2a
  8024bc:	e8 e2 fa ff ff       	call   801fa3 <syscall>
  8024c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c4:	90                   	nop
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <gettst>:
uint32 gettst()
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 2b                	push   $0x2b
  8024d6:	e8 c8 fa ff ff       	call   801fa3 <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 2c                	push   $0x2c
  8024f2:	e8 ac fa ff ff       	call   801fa3 <syscall>
  8024f7:	83 c4 18             	add    $0x18,%esp
  8024fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024fd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802501:	75 07                	jne    80250a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802503:	b8 01 00 00 00       	mov    $0x1,%eax
  802508:	eb 05                	jmp    80250f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
  802514:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 2c                	push   $0x2c
  802523:	e8 7b fa ff ff       	call   801fa3 <syscall>
  802528:	83 c4 18             	add    $0x18,%esp
  80252b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80252e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802532:	75 07                	jne    80253b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802534:	b8 01 00 00 00       	mov    $0x1,%eax
  802539:	eb 05                	jmp    802540 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 2c                	push   $0x2c
  802554:	e8 4a fa ff ff       	call   801fa3 <syscall>
  802559:	83 c4 18             	add    $0x18,%esp
  80255c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80255f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802563:	75 07                	jne    80256c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802565:	b8 01 00 00 00       	mov    $0x1,%eax
  80256a:	eb 05                	jmp    802571 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 2c                	push   $0x2c
  802585:	e8 19 fa ff ff       	call   801fa3 <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
  80258d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802590:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802594:	75 07                	jne    80259d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802596:	b8 01 00 00 00       	mov    $0x1,%eax
  80259b:	eb 05                	jmp    8025a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a2:	c9                   	leave  
  8025a3:	c3                   	ret    

008025a4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	ff 75 08             	pushl  0x8(%ebp)
  8025b2:	6a 2d                	push   $0x2d
  8025b4:	e8 ea f9 ff ff       	call   801fa3 <syscall>
  8025b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025bc:	90                   	nop
}
  8025bd:	c9                   	leave  
  8025be:	c3                   	ret    

008025bf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	6a 00                	push   $0x0
  8025d1:	53                   	push   %ebx
  8025d2:	51                   	push   %ecx
  8025d3:	52                   	push   %edx
  8025d4:	50                   	push   %eax
  8025d5:	6a 2e                	push   $0x2e
  8025d7:	e8 c7 f9 ff ff       	call   801fa3 <syscall>
  8025dc:	83 c4 18             	add    $0x18,%esp
}
  8025df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	52                   	push   %edx
  8025f4:	50                   	push   %eax
  8025f5:	6a 2f                	push   $0x2f
  8025f7:	e8 a7 f9 ff ff       	call   801fa3 <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
  802604:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	68 1c 42 80 00       	push   $0x80421c
  80260f:	e8 c7 e6 ff ff       	call   800cdb <cprintf>
  802614:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802617:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	68 48 42 80 00       	push   $0x804248
  802626:	e8 b0 e6 ff ff       	call   800cdb <cprintf>
  80262b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80262e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802632:	a1 38 51 80 00       	mov    0x805138,%eax
  802637:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263a:	eb 56                	jmp    802692 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80263c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802640:	74 1c                	je     80265e <print_mem_block_lists+0x5d>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 50 08             	mov    0x8(%eax),%edx
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	8b 48 08             	mov    0x8(%eax),%ecx
  80264e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802651:	8b 40 0c             	mov    0xc(%eax),%eax
  802654:	01 c8                	add    %ecx,%eax
  802656:	39 c2                	cmp    %eax,%edx
  802658:	73 04                	jae    80265e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80265a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 50 08             	mov    0x8(%eax),%edx
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	01 c2                	add    %eax,%edx
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 08             	mov    0x8(%eax),%eax
  802672:	83 ec 04             	sub    $0x4,%esp
  802675:	52                   	push   %edx
  802676:	50                   	push   %eax
  802677:	68 5d 42 80 00       	push   $0x80425d
  80267c:	e8 5a e6 ff ff       	call   800cdb <cprintf>
  802681:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80268a:	a1 40 51 80 00       	mov    0x805140,%eax
  80268f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802696:	74 07                	je     80269f <print_mem_block_lists+0x9e>
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	eb 05                	jmp    8026a4 <print_mem_block_lists+0xa3>
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	a3 40 51 80 00       	mov    %eax,0x805140
  8026a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	75 8a                	jne    80263c <print_mem_block_lists+0x3b>
  8026b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b6:	75 84                	jne    80263c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026b8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026bc:	75 10                	jne    8026ce <print_mem_block_lists+0xcd>
  8026be:	83 ec 0c             	sub    $0xc,%esp
  8026c1:	68 6c 42 80 00       	push   $0x80426c
  8026c6:	e8 10 e6 ff ff       	call   800cdb <cprintf>
  8026cb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026d5:	83 ec 0c             	sub    $0xc,%esp
  8026d8:	68 90 42 80 00       	push   $0x804290
  8026dd:	e8 f9 e5 ff ff       	call   800cdb <cprintf>
  8026e2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026e5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026e9:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f1:	eb 56                	jmp    802749 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f7:	74 1c                	je     802715 <print_mem_block_lists+0x114>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 50 08             	mov    0x8(%eax),%edx
  8026ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802702:	8b 48 08             	mov    0x8(%eax),%ecx
  802705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802708:	8b 40 0c             	mov    0xc(%eax),%eax
  80270b:	01 c8                	add    %ecx,%eax
  80270d:	39 c2                	cmp    %eax,%edx
  80270f:	73 04                	jae    802715 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802711:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 50 08             	mov    0x8(%eax),%edx
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 0c             	mov    0xc(%eax),%eax
  802721:	01 c2                	add    %eax,%edx
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 40 08             	mov    0x8(%eax),%eax
  802729:	83 ec 04             	sub    $0x4,%esp
  80272c:	52                   	push   %edx
  80272d:	50                   	push   %eax
  80272e:	68 5d 42 80 00       	push   $0x80425d
  802733:	e8 a3 e5 ff ff       	call   800cdb <cprintf>
  802738:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802741:	a1 48 50 80 00       	mov    0x805048,%eax
  802746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274d:	74 07                	je     802756 <print_mem_block_lists+0x155>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	eb 05                	jmp    80275b <print_mem_block_lists+0x15a>
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
  80275b:	a3 48 50 80 00       	mov    %eax,0x805048
  802760:	a1 48 50 80 00       	mov    0x805048,%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	75 8a                	jne    8026f3 <print_mem_block_lists+0xf2>
  802769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276d:	75 84                	jne    8026f3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80276f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802773:	75 10                	jne    802785 <print_mem_block_lists+0x184>
  802775:	83 ec 0c             	sub    $0xc,%esp
  802778:	68 a8 42 80 00       	push   $0x8042a8
  80277d:	e8 59 e5 ff ff       	call   800cdb <cprintf>
  802782:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802785:	83 ec 0c             	sub    $0xc,%esp
  802788:	68 1c 42 80 00       	push   $0x80421c
  80278d:	e8 49 e5 ff ff       	call   800cdb <cprintf>
  802792:	83 c4 10             	add    $0x10,%esp

}
  802795:	90                   	nop
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  80279e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8027a5:	00 00 00 
  8027a8:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8027af:	00 00 00 
  8027b2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027b9:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8027bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8027c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8027c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027cb:	e9 9e 00 00 00       	jmp    80286e <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8027d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8027d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d8:	c1 e2 04             	shl    $0x4,%edx
  8027db:	01 d0                	add    %edx,%eax
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	75 14                	jne    8027f5 <initialize_MemBlocksList+0x5d>
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 d0 42 80 00       	push   $0x8042d0
  8027e9:	6a 48                	push   $0x48
  8027eb:	68 f3 42 80 00       	push   $0x8042f3
  8027f0:	e8 32 e2 ff ff       	call   800a27 <_panic>
  8027f5:	a1 50 50 80 00       	mov    0x805050,%eax
  8027fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fd:	c1 e2 04             	shl    $0x4,%edx
  802800:	01 d0                	add    %edx,%eax
  802802:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802808:	89 10                	mov    %edx,(%eax)
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 18                	je     802828 <initialize_MemBlocksList+0x90>
  802810:	a1 48 51 80 00       	mov    0x805148,%eax
  802815:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80281b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80281e:	c1 e1 04             	shl    $0x4,%ecx
  802821:	01 ca                	add    %ecx,%edx
  802823:	89 50 04             	mov    %edx,0x4(%eax)
  802826:	eb 12                	jmp    80283a <initialize_MemBlocksList+0xa2>
  802828:	a1 50 50 80 00       	mov    0x805050,%eax
  80282d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802830:	c1 e2 04             	shl    $0x4,%edx
  802833:	01 d0                	add    %edx,%eax
  802835:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80283a:	a1 50 50 80 00       	mov    0x805050,%eax
  80283f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802842:	c1 e2 04             	shl    $0x4,%edx
  802845:	01 d0                	add    %edx,%eax
  802847:	a3 48 51 80 00       	mov    %eax,0x805148
  80284c:	a1 50 50 80 00       	mov    0x805050,%eax
  802851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802854:	c1 e2 04             	shl    $0x4,%edx
  802857:	01 d0                	add    %edx,%eax
  802859:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802860:	a1 54 51 80 00       	mov    0x805154,%eax
  802865:	40                   	inc    %eax
  802866:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80286b:	ff 45 f4             	incl   -0xc(%ebp)
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	3b 45 08             	cmp    0x8(%ebp),%eax
  802874:	0f 82 56 ff ff ff    	jb     8027d0 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80287a:	90                   	nop
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
  802880:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80288b:	eb 18                	jmp    8028a5 <find_block+0x28>
		{
			if(tmp->sva==va)
  80288d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802890:	8b 40 08             	mov    0x8(%eax),%eax
  802893:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802896:	75 05                	jne    80289d <find_block+0x20>
			{
				return tmp;
  802898:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80289b:	eb 11                	jmp    8028ae <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80289d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8028a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028a9:	75 e2                	jne    80288d <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8028ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8028b6:	a1 40 50 80 00       	mov    0x805040,%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	0f 85 83 00 00 00    	jne    802946 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8028c3:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8028ca:	00 00 00 
  8028cd:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8028d4:	00 00 00 
  8028d7:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8028de:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8028e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e5:	75 14                	jne    8028fb <insert_sorted_allocList+0x4b>
  8028e7:	83 ec 04             	sub    $0x4,%esp
  8028ea:	68 d0 42 80 00       	push   $0x8042d0
  8028ef:	6a 7f                	push   $0x7f
  8028f1:	68 f3 42 80 00       	push   $0x8042f3
  8028f6:	e8 2c e1 ff ff       	call   800a27 <_panic>
  8028fb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	89 10                	mov    %edx,(%eax)
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	74 0d                	je     80291c <insert_sorted_allocList+0x6c>
  80290f:	a1 40 50 80 00       	mov    0x805040,%eax
  802914:	8b 55 08             	mov    0x8(%ebp),%edx
  802917:	89 50 04             	mov    %edx,0x4(%eax)
  80291a:	eb 08                	jmp    802924 <insert_sorted_allocList+0x74>
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	a3 44 50 80 00       	mov    %eax,0x805044
  802924:	8b 45 08             	mov    0x8(%ebp),%eax
  802927:	a3 40 50 80 00       	mov    %eax,0x805040
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802936:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80293b:	40                   	inc    %eax
  80293c:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802941:	e9 16 01 00 00       	jmp    802a5c <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	8b 50 08             	mov    0x8(%eax),%edx
  80294c:	a1 44 50 80 00       	mov    0x805044,%eax
  802951:	8b 40 08             	mov    0x8(%eax),%eax
  802954:	39 c2                	cmp    %eax,%edx
  802956:	76 68                	jbe    8029c0 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802958:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295c:	75 17                	jne    802975 <insert_sorted_allocList+0xc5>
  80295e:	83 ec 04             	sub    $0x4,%esp
  802961:	68 0c 43 80 00       	push   $0x80430c
  802966:	68 85 00 00 00       	push   $0x85
  80296b:	68 f3 42 80 00       	push   $0x8042f3
  802970:	e8 b2 e0 ff ff       	call   800a27 <_panic>
  802975:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	89 50 04             	mov    %edx,0x4(%eax)
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	8b 40 04             	mov    0x4(%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	74 0c                	je     802997 <insert_sorted_allocList+0xe7>
  80298b:	a1 44 50 80 00       	mov    0x805044,%eax
  802990:	8b 55 08             	mov    0x8(%ebp),%edx
  802993:	89 10                	mov    %edx,(%eax)
  802995:	eb 08                	jmp    80299f <insert_sorted_allocList+0xef>
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	a3 40 50 80 00       	mov    %eax,0x805040
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	a3 44 50 80 00       	mov    %eax,0x805044
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b5:	40                   	inc    %eax
  8029b6:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8029bb:	e9 9c 00 00 00       	jmp    802a5c <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8029c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8029c8:	e9 85 00 00 00       	jmp    802a52 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 50 08             	mov    0x8(%eax),%edx
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 40 08             	mov    0x8(%eax),%eax
  8029d9:	39 c2                	cmp    %eax,%edx
  8029db:	73 6d                	jae    802a4a <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8029dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e1:	74 06                	je     8029e9 <insert_sorted_allocList+0x139>
  8029e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e7:	75 17                	jne    802a00 <insert_sorted_allocList+0x150>
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	68 30 43 80 00       	push   $0x804330
  8029f1:	68 90 00 00 00       	push   $0x90
  8029f6:	68 f3 42 80 00       	push   $0x8042f3
  8029fb:	e8 27 e0 ff ff       	call   800a27 <_panic>
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 50 04             	mov    0x4(%eax),%edx
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	89 50 04             	mov    %edx,0x4(%eax)
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a12:	89 10                	mov    %edx,(%eax)
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 40 04             	mov    0x4(%eax),%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	74 0d                	je     802a2b <insert_sorted_allocList+0x17b>
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 40 04             	mov    0x4(%eax),%eax
  802a24:	8b 55 08             	mov    0x8(%ebp),%edx
  802a27:	89 10                	mov    %edx,(%eax)
  802a29:	eb 08                	jmp    802a33 <insert_sorted_allocList+0x183>
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	a3 40 50 80 00       	mov    %eax,0x805040
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 55 08             	mov    0x8(%ebp),%edx
  802a39:	89 50 04             	mov    %edx,0x4(%eax)
  802a3c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a41:	40                   	inc    %eax
  802a42:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a47:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802a48:	eb 12                	jmp    802a5c <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a56:	0f 85 71 ff ff ff    	jne    8029cd <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802a5c:	90                   	nop
  802a5d:	c9                   	leave  
  802a5e:	c3                   	ret    

00802a5f <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802a5f:	55                   	push   %ebp
  802a60:	89 e5                	mov    %esp,%ebp
  802a62:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802a65:	a1 38 51 80 00       	mov    0x805138,%eax
  802a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802a6d:	e9 76 01 00 00       	jmp    802be8 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 40 0c             	mov    0xc(%eax),%eax
  802a78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7b:	0f 85 8a 00 00 00    	jne    802b0b <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a85:	75 17                	jne    802a9e <alloc_block_FF+0x3f>
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 65 43 80 00       	push   $0x804365
  802a8f:	68 a8 00 00 00       	push   $0xa8
  802a94:	68 f3 42 80 00       	push   $0x8042f3
  802a99:	e8 89 df ff ff       	call   800a27 <_panic>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 10                	je     802ab7 <alloc_block_FF+0x58>
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaf:	8b 52 04             	mov    0x4(%edx),%edx
  802ab2:	89 50 04             	mov    %edx,0x4(%eax)
  802ab5:	eb 0b                	jmp    802ac2 <alloc_block_FF+0x63>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 40 04             	mov    0x4(%eax),%eax
  802abd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0f                	je     802adb <alloc_block_FF+0x7c>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad5:	8b 12                	mov    (%edx),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	eb 0a                	jmp    802ae5 <alloc_block_FF+0x86>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	a3 38 51 80 00       	mov    %eax,0x805138
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af8:	a1 44 51 80 00       	mov    0x805144,%eax
  802afd:	48                   	dec    %eax
  802afe:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	e9 ea 00 00 00       	jmp    802bf5 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b14:	0f 86 c6 00 00 00    	jbe    802be0 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802b1a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 55 08             	mov    0x8(%ebp),%edx
  802b28:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 50 08             	mov    0x8(%eax),%edx
  802b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b34:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b40:	89 c2                	mov    %eax,%edx
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 50 08             	mov    0x8(%eax),%edx
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	01 c2                	add    %eax,%edx
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b5d:	75 17                	jne    802b76 <alloc_block_FF+0x117>
  802b5f:	83 ec 04             	sub    $0x4,%esp
  802b62:	68 65 43 80 00       	push   $0x804365
  802b67:	68 b6 00 00 00       	push   $0xb6
  802b6c:	68 f3 42 80 00       	push   $0x8042f3
  802b71:	e8 b1 de ff ff       	call   800a27 <_panic>
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	74 10                	je     802b8f <alloc_block_FF+0x130>
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b87:	8b 52 04             	mov    0x4(%edx),%edx
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	eb 0b                	jmp    802b9a <alloc_block_FF+0x13b>
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 0f                	je     802bb3 <alloc_block_FF+0x154>
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	8b 40 04             	mov    0x4(%eax),%eax
  802baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bad:	8b 12                	mov    (%edx),%edx
  802baf:	89 10                	mov    %edx,(%eax)
  802bb1:	eb 0a                	jmp    802bbd <alloc_block_FF+0x15e>
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	a3 48 51 80 00       	mov    %eax,0x805148
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd0:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd5:	48                   	dec    %eax
  802bd6:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	eb 15                	jmp    802bf5 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  802be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bec:	0f 85 80 fe ff ff    	jne    802a72 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802bf5:	c9                   	leave  
  802bf6:	c3                   	ret    

00802bf7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
  802bfa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802bfd:	a1 38 51 80 00       	mov    0x805138,%eax
  802c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  802c05:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  802c0c:	e9 c0 00 00 00       	jmp    802cd1 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1a:	0f 85 8a 00 00 00    	jne    802caa <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  802c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c24:	75 17                	jne    802c3d <alloc_block_BF+0x46>
  802c26:	83 ec 04             	sub    $0x4,%esp
  802c29:	68 65 43 80 00       	push   $0x804365
  802c2e:	68 cf 00 00 00       	push   $0xcf
  802c33:	68 f3 42 80 00       	push   $0x8042f3
  802c38:	e8 ea dd ff ff       	call   800a27 <_panic>
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	74 10                	je     802c56 <alloc_block_BF+0x5f>
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4e:	8b 52 04             	mov    0x4(%edx),%edx
  802c51:	89 50 04             	mov    %edx,0x4(%eax)
  802c54:	eb 0b                	jmp    802c61 <alloc_block_BF+0x6a>
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 40 04             	mov    0x4(%eax),%eax
  802c5c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 40 04             	mov    0x4(%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 0f                	je     802c7a <alloc_block_BF+0x83>
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c74:	8b 12                	mov    (%edx),%edx
  802c76:	89 10                	mov    %edx,(%eax)
  802c78:	eb 0a                	jmp    802c84 <alloc_block_BF+0x8d>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	a3 38 51 80 00       	mov    %eax,0x805138
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c97:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9c:	48                   	dec    %eax
  802c9d:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	e9 2a 01 00 00       	jmp    802dd4 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cb3:	73 14                	jae    802cc9 <alloc_block_BF+0xd2>
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cbe:	76 09                	jbe    802cc9 <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd5:	0f 85 36 ff ff ff    	jne    802c11 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802cdb:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802ce3:	e9 dd 00 00 00       	jmp    802dc5 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cf1:	0f 85 c6 00 00 00    	jne    802dbd <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802cf7:	a1 48 51 80 00       	mov    0x805148,%eax
  802cfc:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 50 08             	mov    0x8(%eax),%edx
  802d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d08:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d11:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	8b 50 08             	mov    0x8(%eax),%edx
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	01 c2                	add    %eax,%edx
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	2b 45 08             	sub    0x8(%ebp),%eax
  802d2e:	89 c2                	mov    %eax,%edx
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802d36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d3a:	75 17                	jne    802d53 <alloc_block_BF+0x15c>
  802d3c:	83 ec 04             	sub    $0x4,%esp
  802d3f:	68 65 43 80 00       	push   $0x804365
  802d44:	68 eb 00 00 00       	push   $0xeb
  802d49:	68 f3 42 80 00       	push   $0x8042f3
  802d4e:	e8 d4 dc ff ff       	call   800a27 <_panic>
  802d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 10                	je     802d6c <alloc_block_BF+0x175>
  802d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d64:	8b 52 04             	mov    0x4(%edx),%edx
  802d67:	89 50 04             	mov    %edx,0x4(%eax)
  802d6a:	eb 0b                	jmp    802d77 <alloc_block_BF+0x180>
  802d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6f:	8b 40 04             	mov    0x4(%eax),%eax
  802d72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	8b 40 04             	mov    0x4(%eax),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	74 0f                	je     802d90 <alloc_block_BF+0x199>
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d8a:	8b 12                	mov    (%edx),%edx
  802d8c:	89 10                	mov    %edx,(%eax)
  802d8e:	eb 0a                	jmp    802d9a <alloc_block_BF+0x1a3>
  802d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	a3 48 51 80 00       	mov    %eax,0x805148
  802d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dad:	a1 54 51 80 00       	mov    0x805154,%eax
  802db2:	48                   	dec    %eax
  802db3:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbb:	eb 17                	jmp    802dd4 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc9:	0f 85 19 ff ff ff    	jne    802ce8 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802dcf:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802dd4:	c9                   	leave  
  802dd5:	c3                   	ret    

00802dd6 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802dd6:	55                   	push   %ebp
  802dd7:	89 e5                	mov    %esp,%ebp
  802dd9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802ddc:	a1 40 50 80 00       	mov    0x805040,%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	75 19                	jne    802dfe <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802de5:	83 ec 0c             	sub    $0xc,%esp
  802de8:	ff 75 08             	pushl  0x8(%ebp)
  802deb:	e8 6f fc ff ff       	call   802a5f <alloc_block_FF>
  802df0:	83 c4 10             	add    $0x10,%esp
  802df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	e9 e9 01 00 00       	jmp    802fe7 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802dfe:	a1 44 50 80 00       	mov    0x805044,%eax
  802e03:	8b 40 08             	mov    0x8(%eax),%eax
  802e06:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802e09:	a1 44 50 80 00       	mov    0x805044,%eax
  802e0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e11:	a1 44 50 80 00       	mov    0x805044,%eax
  802e16:	8b 40 08             	mov    0x8(%eax),%eax
  802e19:	01 d0                	add    %edx,%eax
  802e1b:	83 ec 08             	sub    $0x8,%esp
  802e1e:	50                   	push   %eax
  802e1f:	68 38 51 80 00       	push   $0x805138
  802e24:	e8 54 fa ff ff       	call   80287d <find_block>
  802e29:	83 c4 10             	add    $0x10,%esp
  802e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e38:	0f 85 9b 00 00 00    	jne    802ed9 <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 50 0c             	mov    0xc(%eax),%edx
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 40 08             	mov    0x8(%eax),%eax
  802e4a:	01 d0                	add    %edx,%eax
  802e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	75 17                	jne    802e6c <alloc_block_NF+0x96>
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 65 43 80 00       	push   $0x804365
  802e5d:	68 1a 01 00 00       	push   $0x11a
  802e62:	68 f3 42 80 00       	push   $0x8042f3
  802e67:	e8 bb db ff ff       	call   800a27 <_panic>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	85 c0                	test   %eax,%eax
  802e73:	74 10                	je     802e85 <alloc_block_NF+0xaf>
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7d:	8b 52 04             	mov    0x4(%edx),%edx
  802e80:	89 50 04             	mov    %edx,0x4(%eax)
  802e83:	eb 0b                	jmp    802e90 <alloc_block_NF+0xba>
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 40 04             	mov    0x4(%eax),%eax
  802e8b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	85 c0                	test   %eax,%eax
  802e98:	74 0f                	je     802ea9 <alloc_block_NF+0xd3>
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea3:	8b 12                	mov    (%edx),%edx
  802ea5:	89 10                	mov    %edx,(%eax)
  802ea7:	eb 0a                	jmp    802eb3 <alloc_block_NF+0xdd>
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec6:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecb:	48                   	dec    %eax
  802ecc:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	e9 0e 01 00 00       	jmp    802fe7 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 0c             	mov    0xc(%eax),%eax
  802edf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee2:	0f 86 cf 00 00 00    	jbe    802fb7 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802ee8:	a1 48 51 80 00       	mov    0x805148,%eax
  802eed:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef6:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 50 08             	mov    0x8(%eax),%edx
  802eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f02:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 50 08             	mov    0x8(%eax),%edx
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	01 c2                	add    %eax,%edx
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1c:	2b 45 08             	sub    0x8(%ebp),%eax
  802f1f:	89 c2                	mov    %eax,%edx
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 40 08             	mov    0x8(%eax),%eax
  802f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802f30:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f34:	75 17                	jne    802f4d <alloc_block_NF+0x177>
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	68 65 43 80 00       	push   $0x804365
  802f3e:	68 28 01 00 00       	push   $0x128
  802f43:	68 f3 42 80 00       	push   $0x8042f3
  802f48:	e8 da da ff ff       	call   800a27 <_panic>
  802f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 10                	je     802f66 <alloc_block_NF+0x190>
  802f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f5e:	8b 52 04             	mov    0x4(%edx),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 0b                	jmp    802f71 <alloc_block_NF+0x19b>
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0f                	je     802f8a <alloc_block_NF+0x1b4>
  802f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f84:	8b 12                	mov    (%edx),%edx
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	eb 0a                	jmp    802f94 <alloc_block_NF+0x1be>
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa7:	a1 54 51 80 00       	mov    0x805154,%eax
  802fac:	48                   	dec    %eax
  802fad:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb5:	eb 30                	jmp    802fe7 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802fb7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802fbf:	75 0a                	jne    802fcb <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802fc1:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc9:	eb 08                	jmp    802fd3 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	8b 40 08             	mov    0x8(%eax),%eax
  802fd9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802fdc:	0f 85 4d fe ff ff    	jne    802e2f <alloc_block_NF+0x59>

			return NULL;
  802fe2:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802fe7:	c9                   	leave  
  802fe8:	c3                   	ret    

00802fe9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fe9:	55                   	push   %ebp
  802fea:	89 e5                	mov    %esp,%ebp
  802fec:	53                   	push   %ebx
  802fed:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802ff0:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	0f 85 86 00 00 00    	jne    803083 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802ffd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803004:	00 00 00 
  803007:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80300e:	00 00 00 
  803011:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  803018:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80301b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301f:	75 17                	jne    803038 <insert_sorted_with_merge_freeList+0x4f>
  803021:	83 ec 04             	sub    $0x4,%esp
  803024:	68 d0 42 80 00       	push   $0x8042d0
  803029:	68 48 01 00 00       	push   $0x148
  80302e:	68 f3 42 80 00       	push   $0x8042f3
  803033:	e8 ef d9 ff ff       	call   800a27 <_panic>
  803038:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	89 10                	mov    %edx,(%eax)
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0d                	je     803059 <insert_sorted_with_merge_freeList+0x70>
  80304c:	a1 38 51 80 00       	mov    0x805138,%eax
  803051:	8b 55 08             	mov    0x8(%ebp),%edx
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	eb 08                	jmp    803061 <insert_sorted_with_merge_freeList+0x78>
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	a3 38 51 80 00       	mov    %eax,0x805138
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803073:	a1 44 51 80 00       	mov    0x805144,%eax
  803078:	40                   	inc    %eax
  803079:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  80307e:	e9 73 07 00 00       	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	8b 50 08             	mov    0x8(%eax),%edx
  803089:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80308e:	8b 40 08             	mov    0x8(%eax),%eax
  803091:	39 c2                	cmp    %eax,%edx
  803093:	0f 86 84 00 00 00    	jbe    80311d <insert_sorted_with_merge_freeList+0x134>
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	8b 50 08             	mov    0x8(%eax),%edx
  80309f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030a4:	8b 48 0c             	mov    0xc(%eax),%ecx
  8030a7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030ac:	8b 40 08             	mov    0x8(%eax),%eax
  8030af:	01 c8                	add    %ecx,%eax
  8030b1:	39 c2                	cmp    %eax,%edx
  8030b3:	74 68                	je     80311d <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8030b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b9:	75 17                	jne    8030d2 <insert_sorted_with_merge_freeList+0xe9>
  8030bb:	83 ec 04             	sub    $0x4,%esp
  8030be:	68 0c 43 80 00       	push   $0x80430c
  8030c3:	68 4c 01 00 00       	push   $0x14c
  8030c8:	68 f3 42 80 00       	push   $0x8042f3
  8030cd:	e8 55 d9 ff ff       	call   800a27 <_panic>
  8030d2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	89 50 04             	mov    %edx,0x4(%eax)
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 40 04             	mov    0x4(%eax),%eax
  8030e4:	85 c0                	test   %eax,%eax
  8030e6:	74 0c                	je     8030f4 <insert_sorted_with_merge_freeList+0x10b>
  8030e8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f0:	89 10                	mov    %edx,(%eax)
  8030f2:	eb 08                	jmp    8030fc <insert_sorted_with_merge_freeList+0x113>
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310d:	a1 44 51 80 00       	mov    0x805144,%eax
  803112:	40                   	inc    %eax
  803113:	a3 44 51 80 00       	mov    %eax,0x805144
  803118:	e9 d9 06 00 00       	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 50 08             	mov    0x8(%eax),%edx
  803123:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803128:	8b 40 08             	mov    0x8(%eax),%eax
  80312b:	39 c2                	cmp    %eax,%edx
  80312d:	0f 86 b5 00 00 00    	jbe    8031e8 <insert_sorted_with_merge_freeList+0x1ff>
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	8b 50 08             	mov    0x8(%eax),%edx
  803139:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80313e:	8b 48 0c             	mov    0xc(%eax),%ecx
  803141:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803146:	8b 40 08             	mov    0x8(%eax),%eax
  803149:	01 c8                	add    %ecx,%eax
  80314b:	39 c2                	cmp    %eax,%edx
  80314d:	0f 85 95 00 00 00    	jne    8031e8 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803153:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803158:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80315e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803161:	8b 55 08             	mov    0x8(%ebp),%edx
  803164:	8b 52 0c             	mov    0xc(%edx),%edx
  803167:	01 ca                	add    %ecx,%edx
  803169:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803184:	75 17                	jne    80319d <insert_sorted_with_merge_freeList+0x1b4>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 d0 42 80 00       	push   $0x8042d0
  80318e:	68 54 01 00 00       	push   $0x154
  803193:	68 f3 42 80 00       	push   $0x8042f3
  803198:	e8 8a d8 ff ff       	call   800a27 <_panic>
  80319d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	89 10                	mov    %edx,(%eax)
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	74 0d                	je     8031be <insert_sorted_with_merge_freeList+0x1d5>
  8031b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	eb 08                	jmp    8031c6 <insert_sorted_with_merge_freeList+0x1dd>
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031dd:	40                   	inc    %eax
  8031de:	a3 54 51 80 00       	mov    %eax,0x805154
  8031e3:	e9 0e 06 00 00       	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f3:	8b 40 08             	mov    0x8(%eax),%eax
  8031f6:	39 c2                	cmp    %eax,%edx
  8031f8:	0f 83 c1 00 00 00    	jae    8032bf <insert_sorted_with_merge_freeList+0x2d6>
  8031fe:	a1 38 51 80 00       	mov    0x805138,%eax
  803203:	8b 50 08             	mov    0x8(%eax),%edx
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	8b 48 08             	mov    0x8(%eax),%ecx
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	8b 40 0c             	mov    0xc(%eax),%eax
  803212:	01 c8                	add    %ecx,%eax
  803214:	39 c2                	cmp    %eax,%edx
  803216:	0f 85 a3 00 00 00    	jne    8032bf <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80321c:	a1 38 51 80 00       	mov    0x805138,%eax
  803221:	8b 55 08             	mov    0x8(%ebp),%edx
  803224:	8b 52 08             	mov    0x8(%edx),%edx
  803227:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80322a:	a1 38 51 80 00       	mov    0x805138,%eax
  80322f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803235:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803238:	8b 55 08             	mov    0x8(%ebp),%edx
  80323b:	8b 52 0c             	mov    0xc(%edx),%edx
  80323e:	01 ca                	add    %ecx,%edx
  803240:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803257:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325b:	75 17                	jne    803274 <insert_sorted_with_merge_freeList+0x28b>
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	68 d0 42 80 00       	push   $0x8042d0
  803265:	68 5d 01 00 00       	push   $0x15d
  80326a:	68 f3 42 80 00       	push   $0x8042f3
  80326f:	e8 b3 d7 ff ff       	call   800a27 <_panic>
  803274:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 00                	mov    (%eax),%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 0d                	je     803295 <insert_sorted_with_merge_freeList+0x2ac>
  803288:	a1 48 51 80 00       	mov    0x805148,%eax
  80328d:	8b 55 08             	mov    0x8(%ebp),%edx
  803290:	89 50 04             	mov    %edx,0x4(%eax)
  803293:	eb 08                	jmp    80329d <insert_sorted_with_merge_freeList+0x2b4>
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032af:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b4:	40                   	inc    %eax
  8032b5:	a3 54 51 80 00       	mov    %eax,0x805154
  8032ba:	e9 37 05 00 00       	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	8b 50 08             	mov    0x8(%eax),%edx
  8032c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ca:	8b 40 08             	mov    0x8(%eax),%eax
  8032cd:	39 c2                	cmp    %eax,%edx
  8032cf:	0f 83 82 00 00 00    	jae    803357 <insert_sorted_with_merge_freeList+0x36e>
  8032d5:	a1 38 51 80 00       	mov    0x805138,%eax
  8032da:	8b 50 08             	mov    0x8(%eax),%edx
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	8b 48 08             	mov    0x8(%eax),%ecx
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e9:	01 c8                	add    %ecx,%eax
  8032eb:	39 c2                	cmp    %eax,%edx
  8032ed:	74 68                	je     803357 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8032ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f3:	75 17                	jne    80330c <insert_sorted_with_merge_freeList+0x323>
  8032f5:	83 ec 04             	sub    $0x4,%esp
  8032f8:	68 d0 42 80 00       	push   $0x8042d0
  8032fd:	68 62 01 00 00       	push   $0x162
  803302:	68 f3 42 80 00       	push   $0x8042f3
  803307:	e8 1b d7 ff ff       	call   800a27 <_panic>
  80330c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	89 10                	mov    %edx,(%eax)
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	85 c0                	test   %eax,%eax
  80331e:	74 0d                	je     80332d <insert_sorted_with_merge_freeList+0x344>
  803320:	a1 38 51 80 00       	mov    0x805138,%eax
  803325:	8b 55 08             	mov    0x8(%ebp),%edx
  803328:	89 50 04             	mov    %edx,0x4(%eax)
  80332b:	eb 08                	jmp    803335 <insert_sorted_with_merge_freeList+0x34c>
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	a3 38 51 80 00       	mov    %eax,0x805138
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803347:	a1 44 51 80 00       	mov    0x805144,%eax
  80334c:	40                   	inc    %eax
  80334d:	a3 44 51 80 00       	mov    %eax,0x805144
  803352:	e9 9f 04 00 00       	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803357:	a1 38 51 80 00       	mov    0x805138,%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803361:	e9 84 04 00 00       	jmp    8037ea <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	8b 50 08             	mov    0x8(%eax),%edx
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	8b 40 08             	mov    0x8(%eax),%eax
  803372:	39 c2                	cmp    %eax,%edx
  803374:	0f 86 a9 00 00 00    	jbe    803423 <insert_sorted_with_merge_freeList+0x43a>
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	8b 50 08             	mov    0x8(%eax),%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	8b 48 08             	mov    0x8(%eax),%ecx
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	8b 40 0c             	mov    0xc(%eax),%eax
  80338c:	01 c8                	add    %ecx,%eax
  80338e:	39 c2                	cmp    %eax,%edx
  803390:	0f 84 8d 00 00 00    	je     803423 <insert_sorted_with_merge_freeList+0x43a>
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	8b 50 08             	mov    0x8(%eax),%edx
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	8b 40 04             	mov    0x4(%eax),%eax
  8033a2:	8b 48 08             	mov    0x8(%eax),%ecx
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 40 04             	mov    0x4(%eax),%eax
  8033ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ae:	01 c8                	add    %ecx,%eax
  8033b0:	39 c2                	cmp    %eax,%edx
  8033b2:	74 6f                	je     803423 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  8033b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b8:	74 06                	je     8033c0 <insert_sorted_with_merge_freeList+0x3d7>
  8033ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033be:	75 17                	jne    8033d7 <insert_sorted_with_merge_freeList+0x3ee>
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	68 30 43 80 00       	push   $0x804330
  8033c8:	68 6b 01 00 00       	push   $0x16b
  8033cd:	68 f3 42 80 00       	push   $0x8042f3
  8033d2:	e8 50 d6 ff ff       	call   800a27 <_panic>
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 50 04             	mov    0x4(%eax),%edx
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	89 50 04             	mov    %edx,0x4(%eax)
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e9:	89 10                	mov    %edx,(%eax)
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	8b 40 04             	mov    0x4(%eax),%eax
  8033f1:	85 c0                	test   %eax,%eax
  8033f3:	74 0d                	je     803402 <insert_sorted_with_merge_freeList+0x419>
  8033f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f8:	8b 40 04             	mov    0x4(%eax),%eax
  8033fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fe:	89 10                	mov    %edx,(%eax)
  803400:	eb 08                	jmp    80340a <insert_sorted_with_merge_freeList+0x421>
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	a3 38 51 80 00       	mov    %eax,0x805138
  80340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340d:	8b 55 08             	mov    0x8(%ebp),%edx
  803410:	89 50 04             	mov    %edx,0x4(%eax)
  803413:	a1 44 51 80 00       	mov    0x805144,%eax
  803418:	40                   	inc    %eax
  803419:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80341e:	e9 d3 03 00 00       	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8b 50 08             	mov    0x8(%eax),%edx
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 40 08             	mov    0x8(%eax),%eax
  80342f:	39 c2                	cmp    %eax,%edx
  803431:	0f 86 da 00 00 00    	jbe    803511 <insert_sorted_with_merge_freeList+0x528>
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 50 08             	mov    0x8(%eax),%edx
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	8b 48 08             	mov    0x8(%eax),%ecx
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	8b 40 0c             	mov    0xc(%eax),%eax
  803449:	01 c8                	add    %ecx,%eax
  80344b:	39 c2                	cmp    %eax,%edx
  80344d:	0f 85 be 00 00 00    	jne    803511 <insert_sorted_with_merge_freeList+0x528>
  803453:	8b 45 08             	mov    0x8(%ebp),%eax
  803456:	8b 50 08             	mov    0x8(%eax),%edx
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	8b 40 04             	mov    0x4(%eax),%eax
  80345f:	8b 48 08             	mov    0x8(%eax),%ecx
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 40 04             	mov    0x4(%eax),%eax
  803468:	8b 40 0c             	mov    0xc(%eax),%eax
  80346b:	01 c8                	add    %ecx,%eax
  80346d:	39 c2                	cmp    %eax,%edx
  80346f:	0f 84 9c 00 00 00    	je     803511 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	8b 50 08             	mov    0x8(%eax),%edx
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	8b 50 0c             	mov    0xc(%eax),%edx
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	8b 40 0c             	mov    0xc(%eax),%eax
  80348d:	01 c2                	add    %eax,%edx
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ad:	75 17                	jne    8034c6 <insert_sorted_with_merge_freeList+0x4dd>
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	68 d0 42 80 00       	push   $0x8042d0
  8034b7:	68 74 01 00 00       	push   $0x174
  8034bc:	68 f3 42 80 00       	push   $0x8042f3
  8034c1:	e8 61 d5 ff ff       	call   800a27 <_panic>
  8034c6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	74 0d                	je     8034e7 <insert_sorted_with_merge_freeList+0x4fe>
  8034da:	a1 48 51 80 00       	mov    0x805148,%eax
  8034df:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%eax)
  8034e5:	eb 08                	jmp    8034ef <insert_sorted_with_merge_freeList+0x506>
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803501:	a1 54 51 80 00       	mov    0x805154,%eax
  803506:	40                   	inc    %eax
  803507:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80350c:	e9 e5 02 00 00       	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	8b 50 08             	mov    0x8(%eax),%edx
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	8b 40 08             	mov    0x8(%eax),%eax
  80351d:	39 c2                	cmp    %eax,%edx
  80351f:	0f 86 d7 00 00 00    	jbe    8035fc <insert_sorted_with_merge_freeList+0x613>
  803525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803528:	8b 50 08             	mov    0x8(%eax),%edx
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	8b 48 08             	mov    0x8(%eax),%ecx
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	8b 40 0c             	mov    0xc(%eax),%eax
  803537:	01 c8                	add    %ecx,%eax
  803539:	39 c2                	cmp    %eax,%edx
  80353b:	0f 84 bb 00 00 00    	je     8035fc <insert_sorted_with_merge_freeList+0x613>
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	8b 50 08             	mov    0x8(%eax),%edx
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	8b 40 04             	mov    0x4(%eax),%eax
  80354d:	8b 48 08             	mov    0x8(%eax),%ecx
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	8b 40 04             	mov    0x4(%eax),%eax
  803556:	8b 40 0c             	mov    0xc(%eax),%eax
  803559:	01 c8                	add    %ecx,%eax
  80355b:	39 c2                	cmp    %eax,%edx
  80355d:	0f 85 99 00 00 00    	jne    8035fc <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	8b 40 04             	mov    0x4(%eax),%eax
  803569:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  80356c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356f:	8b 50 0c             	mov    0xc(%eax),%edx
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	8b 40 0c             	mov    0xc(%eax),%eax
  803578:	01 c2                	add    %eax,%edx
  80357a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357d:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803594:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803598:	75 17                	jne    8035b1 <insert_sorted_with_merge_freeList+0x5c8>
  80359a:	83 ec 04             	sub    $0x4,%esp
  80359d:	68 d0 42 80 00       	push   $0x8042d0
  8035a2:	68 7d 01 00 00       	push   $0x17d
  8035a7:	68 f3 42 80 00       	push   $0x8042f3
  8035ac:	e8 76 d4 ff ff       	call   800a27 <_panic>
  8035b1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ba:	89 10                	mov    %edx,(%eax)
  8035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	85 c0                	test   %eax,%eax
  8035c3:	74 0d                	je     8035d2 <insert_sorted_with_merge_freeList+0x5e9>
  8035c5:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8035cd:	89 50 04             	mov    %edx,0x4(%eax)
  8035d0:	eb 08                	jmp    8035da <insert_sorted_with_merge_freeList+0x5f1>
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8035f1:	40                   	inc    %eax
  8035f2:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8035f7:	e9 fa 01 00 00       	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8035fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ff:	8b 50 08             	mov    0x8(%eax),%edx
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	8b 40 08             	mov    0x8(%eax),%eax
  803608:	39 c2                	cmp    %eax,%edx
  80360a:	0f 86 d2 01 00 00    	jbe    8037e2 <insert_sorted_with_merge_freeList+0x7f9>
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 50 08             	mov    0x8(%eax),%edx
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	8b 48 08             	mov    0x8(%eax),%ecx
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	8b 40 0c             	mov    0xc(%eax),%eax
  803622:	01 c8                	add    %ecx,%eax
  803624:	39 c2                	cmp    %eax,%edx
  803626:	0f 85 b6 01 00 00    	jne    8037e2 <insert_sorted_with_merge_freeList+0x7f9>
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	8b 50 08             	mov    0x8(%eax),%edx
  803632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803635:	8b 40 04             	mov    0x4(%eax),%eax
  803638:	8b 48 08             	mov    0x8(%eax),%ecx
  80363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363e:	8b 40 04             	mov    0x4(%eax),%eax
  803641:	8b 40 0c             	mov    0xc(%eax),%eax
  803644:	01 c8                	add    %ecx,%eax
  803646:	39 c2                	cmp    %eax,%edx
  803648:	0f 85 94 01 00 00    	jne    8037e2 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  80364e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803651:	8b 40 04             	mov    0x4(%eax),%eax
  803654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803657:	8b 52 04             	mov    0x4(%edx),%edx
  80365a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80365d:	8b 55 08             	mov    0x8(%ebp),%edx
  803660:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803666:	8b 52 0c             	mov    0xc(%edx),%edx
  803669:	01 da                	add    %ebx,%edx
  80366b:	01 ca                	add    %ecx,%edx
  80366d:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803673:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803688:	75 17                	jne    8036a1 <insert_sorted_with_merge_freeList+0x6b8>
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	68 65 43 80 00       	push   $0x804365
  803692:	68 86 01 00 00       	push   $0x186
  803697:	68 f3 42 80 00       	push   $0x8042f3
  80369c:	e8 86 d3 ff ff       	call   800a27 <_panic>
  8036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	85 c0                	test   %eax,%eax
  8036a8:	74 10                	je     8036ba <insert_sorted_with_merge_freeList+0x6d1>
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b2:	8b 52 04             	mov    0x4(%edx),%edx
  8036b5:	89 50 04             	mov    %edx,0x4(%eax)
  8036b8:	eb 0b                	jmp    8036c5 <insert_sorted_with_merge_freeList+0x6dc>
  8036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bd:	8b 40 04             	mov    0x4(%eax),%eax
  8036c0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c8:	8b 40 04             	mov    0x4(%eax),%eax
  8036cb:	85 c0                	test   %eax,%eax
  8036cd:	74 0f                	je     8036de <insert_sorted_with_merge_freeList+0x6f5>
  8036cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d2:	8b 40 04             	mov    0x4(%eax),%eax
  8036d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036d8:	8b 12                	mov    (%edx),%edx
  8036da:	89 10                	mov    %edx,(%eax)
  8036dc:	eb 0a                	jmp    8036e8 <insert_sorted_with_merge_freeList+0x6ff>
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	a3 38 51 80 00       	mov    %eax,0x805138
  8036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036fb:	a1 44 51 80 00       	mov    0x805144,%eax
  803700:	48                   	dec    %eax
  803701:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370a:	75 17                	jne    803723 <insert_sorted_with_merge_freeList+0x73a>
  80370c:	83 ec 04             	sub    $0x4,%esp
  80370f:	68 d0 42 80 00       	push   $0x8042d0
  803714:	68 87 01 00 00       	push   $0x187
  803719:	68 f3 42 80 00       	push   $0x8042f3
  80371e:	e8 04 d3 ff ff       	call   800a27 <_panic>
  803723:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372c:	89 10                	mov    %edx,(%eax)
  80372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803731:	8b 00                	mov    (%eax),%eax
  803733:	85 c0                	test   %eax,%eax
  803735:	74 0d                	je     803744 <insert_sorted_with_merge_freeList+0x75b>
  803737:	a1 48 51 80 00       	mov    0x805148,%eax
  80373c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80373f:	89 50 04             	mov    %edx,0x4(%eax)
  803742:	eb 08                	jmp    80374c <insert_sorted_with_merge_freeList+0x763>
  803744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803747:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80374c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374f:	a3 48 51 80 00       	mov    %eax,0x805148
  803754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803757:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375e:	a1 54 51 80 00       	mov    0x805154,%eax
  803763:	40                   	inc    %eax
  803764:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80377d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803781:	75 17                	jne    80379a <insert_sorted_with_merge_freeList+0x7b1>
  803783:	83 ec 04             	sub    $0x4,%esp
  803786:	68 d0 42 80 00       	push   $0x8042d0
  80378b:	68 8a 01 00 00       	push   $0x18a
  803790:	68 f3 42 80 00       	push   $0x8042f3
  803795:	e8 8d d2 ff ff       	call   800a27 <_panic>
  80379a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a3:	89 10                	mov    %edx,(%eax)
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	85 c0                	test   %eax,%eax
  8037ac:	74 0d                	je     8037bb <insert_sorted_with_merge_freeList+0x7d2>
  8037ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8037b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037b6:	89 50 04             	mov    %edx,0x4(%eax)
  8037b9:	eb 08                	jmp    8037c3 <insert_sorted_with_merge_freeList+0x7da>
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8037da:	40                   	inc    %eax
  8037db:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  8037e0:	eb 14                	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8037e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8037ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ee:	0f 85 72 fb ff ff    	jne    803366 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8037f4:	eb 00                	jmp    8037f6 <insert_sorted_with_merge_freeList+0x80d>
  8037f6:	90                   	nop
  8037f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037fa:	c9                   	leave  
  8037fb:	c3                   	ret    

008037fc <__udivdi3>:
  8037fc:	55                   	push   %ebp
  8037fd:	57                   	push   %edi
  8037fe:	56                   	push   %esi
  8037ff:	53                   	push   %ebx
  803800:	83 ec 1c             	sub    $0x1c,%esp
  803803:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803807:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80380b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80380f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803813:	89 ca                	mov    %ecx,%edx
  803815:	89 f8                	mov    %edi,%eax
  803817:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80381b:	85 f6                	test   %esi,%esi
  80381d:	75 2d                	jne    80384c <__udivdi3+0x50>
  80381f:	39 cf                	cmp    %ecx,%edi
  803821:	77 65                	ja     803888 <__udivdi3+0x8c>
  803823:	89 fd                	mov    %edi,%ebp
  803825:	85 ff                	test   %edi,%edi
  803827:	75 0b                	jne    803834 <__udivdi3+0x38>
  803829:	b8 01 00 00 00       	mov    $0x1,%eax
  80382e:	31 d2                	xor    %edx,%edx
  803830:	f7 f7                	div    %edi
  803832:	89 c5                	mov    %eax,%ebp
  803834:	31 d2                	xor    %edx,%edx
  803836:	89 c8                	mov    %ecx,%eax
  803838:	f7 f5                	div    %ebp
  80383a:	89 c1                	mov    %eax,%ecx
  80383c:	89 d8                	mov    %ebx,%eax
  80383e:	f7 f5                	div    %ebp
  803840:	89 cf                	mov    %ecx,%edi
  803842:	89 fa                	mov    %edi,%edx
  803844:	83 c4 1c             	add    $0x1c,%esp
  803847:	5b                   	pop    %ebx
  803848:	5e                   	pop    %esi
  803849:	5f                   	pop    %edi
  80384a:	5d                   	pop    %ebp
  80384b:	c3                   	ret    
  80384c:	39 ce                	cmp    %ecx,%esi
  80384e:	77 28                	ja     803878 <__udivdi3+0x7c>
  803850:	0f bd fe             	bsr    %esi,%edi
  803853:	83 f7 1f             	xor    $0x1f,%edi
  803856:	75 40                	jne    803898 <__udivdi3+0x9c>
  803858:	39 ce                	cmp    %ecx,%esi
  80385a:	72 0a                	jb     803866 <__udivdi3+0x6a>
  80385c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803860:	0f 87 9e 00 00 00    	ja     803904 <__udivdi3+0x108>
  803866:	b8 01 00 00 00       	mov    $0x1,%eax
  80386b:	89 fa                	mov    %edi,%edx
  80386d:	83 c4 1c             	add    $0x1c,%esp
  803870:	5b                   	pop    %ebx
  803871:	5e                   	pop    %esi
  803872:	5f                   	pop    %edi
  803873:	5d                   	pop    %ebp
  803874:	c3                   	ret    
  803875:	8d 76 00             	lea    0x0(%esi),%esi
  803878:	31 ff                	xor    %edi,%edi
  80387a:	31 c0                	xor    %eax,%eax
  80387c:	89 fa                	mov    %edi,%edx
  80387e:	83 c4 1c             	add    $0x1c,%esp
  803881:	5b                   	pop    %ebx
  803882:	5e                   	pop    %esi
  803883:	5f                   	pop    %edi
  803884:	5d                   	pop    %ebp
  803885:	c3                   	ret    
  803886:	66 90                	xchg   %ax,%ax
  803888:	89 d8                	mov    %ebx,%eax
  80388a:	f7 f7                	div    %edi
  80388c:	31 ff                	xor    %edi,%edi
  80388e:	89 fa                	mov    %edi,%edx
  803890:	83 c4 1c             	add    $0x1c,%esp
  803893:	5b                   	pop    %ebx
  803894:	5e                   	pop    %esi
  803895:	5f                   	pop    %edi
  803896:	5d                   	pop    %ebp
  803897:	c3                   	ret    
  803898:	bd 20 00 00 00       	mov    $0x20,%ebp
  80389d:	89 eb                	mov    %ebp,%ebx
  80389f:	29 fb                	sub    %edi,%ebx
  8038a1:	89 f9                	mov    %edi,%ecx
  8038a3:	d3 e6                	shl    %cl,%esi
  8038a5:	89 c5                	mov    %eax,%ebp
  8038a7:	88 d9                	mov    %bl,%cl
  8038a9:	d3 ed                	shr    %cl,%ebp
  8038ab:	89 e9                	mov    %ebp,%ecx
  8038ad:	09 f1                	or     %esi,%ecx
  8038af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038b3:	89 f9                	mov    %edi,%ecx
  8038b5:	d3 e0                	shl    %cl,%eax
  8038b7:	89 c5                	mov    %eax,%ebp
  8038b9:	89 d6                	mov    %edx,%esi
  8038bb:	88 d9                	mov    %bl,%cl
  8038bd:	d3 ee                	shr    %cl,%esi
  8038bf:	89 f9                	mov    %edi,%ecx
  8038c1:	d3 e2                	shl    %cl,%edx
  8038c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038c7:	88 d9                	mov    %bl,%cl
  8038c9:	d3 e8                	shr    %cl,%eax
  8038cb:	09 c2                	or     %eax,%edx
  8038cd:	89 d0                	mov    %edx,%eax
  8038cf:	89 f2                	mov    %esi,%edx
  8038d1:	f7 74 24 0c          	divl   0xc(%esp)
  8038d5:	89 d6                	mov    %edx,%esi
  8038d7:	89 c3                	mov    %eax,%ebx
  8038d9:	f7 e5                	mul    %ebp
  8038db:	39 d6                	cmp    %edx,%esi
  8038dd:	72 19                	jb     8038f8 <__udivdi3+0xfc>
  8038df:	74 0b                	je     8038ec <__udivdi3+0xf0>
  8038e1:	89 d8                	mov    %ebx,%eax
  8038e3:	31 ff                	xor    %edi,%edi
  8038e5:	e9 58 ff ff ff       	jmp    803842 <__udivdi3+0x46>
  8038ea:	66 90                	xchg   %ax,%ax
  8038ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038f0:	89 f9                	mov    %edi,%ecx
  8038f2:	d3 e2                	shl    %cl,%edx
  8038f4:	39 c2                	cmp    %eax,%edx
  8038f6:	73 e9                	jae    8038e1 <__udivdi3+0xe5>
  8038f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038fb:	31 ff                	xor    %edi,%edi
  8038fd:	e9 40 ff ff ff       	jmp    803842 <__udivdi3+0x46>
  803902:	66 90                	xchg   %ax,%ax
  803904:	31 c0                	xor    %eax,%eax
  803906:	e9 37 ff ff ff       	jmp    803842 <__udivdi3+0x46>
  80390b:	90                   	nop

0080390c <__umoddi3>:
  80390c:	55                   	push   %ebp
  80390d:	57                   	push   %edi
  80390e:	56                   	push   %esi
  80390f:	53                   	push   %ebx
  803910:	83 ec 1c             	sub    $0x1c,%esp
  803913:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803917:	8b 74 24 34          	mov    0x34(%esp),%esi
  80391b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80391f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803923:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803927:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80392b:	89 f3                	mov    %esi,%ebx
  80392d:	89 fa                	mov    %edi,%edx
  80392f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803933:	89 34 24             	mov    %esi,(%esp)
  803936:	85 c0                	test   %eax,%eax
  803938:	75 1a                	jne    803954 <__umoddi3+0x48>
  80393a:	39 f7                	cmp    %esi,%edi
  80393c:	0f 86 a2 00 00 00    	jbe    8039e4 <__umoddi3+0xd8>
  803942:	89 c8                	mov    %ecx,%eax
  803944:	89 f2                	mov    %esi,%edx
  803946:	f7 f7                	div    %edi
  803948:	89 d0                	mov    %edx,%eax
  80394a:	31 d2                	xor    %edx,%edx
  80394c:	83 c4 1c             	add    $0x1c,%esp
  80394f:	5b                   	pop    %ebx
  803950:	5e                   	pop    %esi
  803951:	5f                   	pop    %edi
  803952:	5d                   	pop    %ebp
  803953:	c3                   	ret    
  803954:	39 f0                	cmp    %esi,%eax
  803956:	0f 87 ac 00 00 00    	ja     803a08 <__umoddi3+0xfc>
  80395c:	0f bd e8             	bsr    %eax,%ebp
  80395f:	83 f5 1f             	xor    $0x1f,%ebp
  803962:	0f 84 ac 00 00 00    	je     803a14 <__umoddi3+0x108>
  803968:	bf 20 00 00 00       	mov    $0x20,%edi
  80396d:	29 ef                	sub    %ebp,%edi
  80396f:	89 fe                	mov    %edi,%esi
  803971:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803975:	89 e9                	mov    %ebp,%ecx
  803977:	d3 e0                	shl    %cl,%eax
  803979:	89 d7                	mov    %edx,%edi
  80397b:	89 f1                	mov    %esi,%ecx
  80397d:	d3 ef                	shr    %cl,%edi
  80397f:	09 c7                	or     %eax,%edi
  803981:	89 e9                	mov    %ebp,%ecx
  803983:	d3 e2                	shl    %cl,%edx
  803985:	89 14 24             	mov    %edx,(%esp)
  803988:	89 d8                	mov    %ebx,%eax
  80398a:	d3 e0                	shl    %cl,%eax
  80398c:	89 c2                	mov    %eax,%edx
  80398e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803992:	d3 e0                	shl    %cl,%eax
  803994:	89 44 24 04          	mov    %eax,0x4(%esp)
  803998:	8b 44 24 08          	mov    0x8(%esp),%eax
  80399c:	89 f1                	mov    %esi,%ecx
  80399e:	d3 e8                	shr    %cl,%eax
  8039a0:	09 d0                	or     %edx,%eax
  8039a2:	d3 eb                	shr    %cl,%ebx
  8039a4:	89 da                	mov    %ebx,%edx
  8039a6:	f7 f7                	div    %edi
  8039a8:	89 d3                	mov    %edx,%ebx
  8039aa:	f7 24 24             	mull   (%esp)
  8039ad:	89 c6                	mov    %eax,%esi
  8039af:	89 d1                	mov    %edx,%ecx
  8039b1:	39 d3                	cmp    %edx,%ebx
  8039b3:	0f 82 87 00 00 00    	jb     803a40 <__umoddi3+0x134>
  8039b9:	0f 84 91 00 00 00    	je     803a50 <__umoddi3+0x144>
  8039bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039c3:	29 f2                	sub    %esi,%edx
  8039c5:	19 cb                	sbb    %ecx,%ebx
  8039c7:	89 d8                	mov    %ebx,%eax
  8039c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039cd:	d3 e0                	shl    %cl,%eax
  8039cf:	89 e9                	mov    %ebp,%ecx
  8039d1:	d3 ea                	shr    %cl,%edx
  8039d3:	09 d0                	or     %edx,%eax
  8039d5:	89 e9                	mov    %ebp,%ecx
  8039d7:	d3 eb                	shr    %cl,%ebx
  8039d9:	89 da                	mov    %ebx,%edx
  8039db:	83 c4 1c             	add    $0x1c,%esp
  8039de:	5b                   	pop    %ebx
  8039df:	5e                   	pop    %esi
  8039e0:	5f                   	pop    %edi
  8039e1:	5d                   	pop    %ebp
  8039e2:	c3                   	ret    
  8039e3:	90                   	nop
  8039e4:	89 fd                	mov    %edi,%ebp
  8039e6:	85 ff                	test   %edi,%edi
  8039e8:	75 0b                	jne    8039f5 <__umoddi3+0xe9>
  8039ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ef:	31 d2                	xor    %edx,%edx
  8039f1:	f7 f7                	div    %edi
  8039f3:	89 c5                	mov    %eax,%ebp
  8039f5:	89 f0                	mov    %esi,%eax
  8039f7:	31 d2                	xor    %edx,%edx
  8039f9:	f7 f5                	div    %ebp
  8039fb:	89 c8                	mov    %ecx,%eax
  8039fd:	f7 f5                	div    %ebp
  8039ff:	89 d0                	mov    %edx,%eax
  803a01:	e9 44 ff ff ff       	jmp    80394a <__umoddi3+0x3e>
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	89 c8                	mov    %ecx,%eax
  803a0a:	89 f2                	mov    %esi,%edx
  803a0c:	83 c4 1c             	add    $0x1c,%esp
  803a0f:	5b                   	pop    %ebx
  803a10:	5e                   	pop    %esi
  803a11:	5f                   	pop    %edi
  803a12:	5d                   	pop    %ebp
  803a13:	c3                   	ret    
  803a14:	3b 04 24             	cmp    (%esp),%eax
  803a17:	72 06                	jb     803a1f <__umoddi3+0x113>
  803a19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a1d:	77 0f                	ja     803a2e <__umoddi3+0x122>
  803a1f:	89 f2                	mov    %esi,%edx
  803a21:	29 f9                	sub    %edi,%ecx
  803a23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a27:	89 14 24             	mov    %edx,(%esp)
  803a2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a32:	8b 14 24             	mov    (%esp),%edx
  803a35:	83 c4 1c             	add    $0x1c,%esp
  803a38:	5b                   	pop    %ebx
  803a39:	5e                   	pop    %esi
  803a3a:	5f                   	pop    %edi
  803a3b:	5d                   	pop    %ebp
  803a3c:	c3                   	ret    
  803a3d:	8d 76 00             	lea    0x0(%esi),%esi
  803a40:	2b 04 24             	sub    (%esp),%eax
  803a43:	19 fa                	sbb    %edi,%edx
  803a45:	89 d1                	mov    %edx,%ecx
  803a47:	89 c6                	mov    %eax,%esi
  803a49:	e9 71 ff ff ff       	jmp    8039bf <__umoddi3+0xb3>
  803a4e:	66 90                	xchg   %ax,%ax
  803a50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a54:	72 ea                	jb     803a40 <__umoddi3+0x134>
  803a56:	89 d9                	mov    %ebx,%ecx
  803a58:	e9 62 ff ff ff       	jmp    8039bf <__umoddi3+0xb3>
