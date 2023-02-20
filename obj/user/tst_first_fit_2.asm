
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 4a 06 00 00       	call   800680 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 ef 22 00 00       	call   802339 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 00 38 80 00       	push   $0x803800
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 1c 38 80 00       	push   $0x80381c
  8000a7:	e8 10 07 00 00       	call   8007bc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 0a 19 00 00       	call   8019c0 <malloc>
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
  8000e0:	e8 db 18 00 00       	call   8019c0 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 34 38 80 00       	push   $0x803834
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 1c 38 80 00       	push   $0x80381c
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 19 1d 00 00       	call   801e24 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 b1 1d 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 99 18 00 00       	call   8019c0 <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 78 38 80 00       	push   $0x803878
  80013f:	6a 31                	push   $0x31
  800141:	68 1c 38 80 00       	push   $0x80381c
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 74 1d 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 a8 38 80 00       	push   $0x8038a8
  80015d:	6a 33                	push   $0x33
  80015f:	68 1c 38 80 00       	push   $0x80381c
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 b6 1c 00 00       	call   801e24 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 4e 1d 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	01 c0                	add    %eax,%eax
  80017e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	e8 36 18 00 00       	call   8019c0 <malloc>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	05 00 00 00 80       	add    $0x80000000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 78 38 80 00       	push   $0x803878
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 1c 38 80 00       	push   $0x80381c
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 08 1d 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 a8 38 80 00       	push   $0x8038a8
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 1c 38 80 00       	push   $0x80381c
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 4a 1c 00 00       	call   801e24 <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 e2 1c 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8001e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	01 d2                	add    %edx,%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 c9 17 00 00       	call   8019c0 <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001fd:	8b 45 98             	mov    -0x68(%ebp),%eax
  800200:	89 c2                	mov    %eax,%edx
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 00 80       	add    $0x80000000,%eax
  80020d:	39 c2                	cmp    %eax,%edx
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 78 38 80 00       	push   $0x803878
  800219:	6a 41                	push   $0x41
  80021b:	68 1c 38 80 00       	push   $0x80381c
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 9a 1c 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 a8 38 80 00       	push   $0x8038a8
  800237:	6a 43                	push   $0x43
  800239:	68 1c 38 80 00       	push   $0x80381c
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 dc 1b 00 00       	call   801e24 <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 74 1c 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800250:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 5b 17 00 00       	call   8019c0 <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	c1 e0 02             	shl    $0x2,%eax
  80027e:	01 c8                	add    %ecx,%eax
  800280:	05 00 00 00 80       	add    $0x80000000,%eax
  800285:	39 c2                	cmp    %eax,%edx
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 78 38 80 00       	push   $0x803878
  800291:	6a 49                	push   $0x49
  800293:	68 1c 38 80 00       	push   $0x80381c
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 22 1c 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 a8 38 80 00       	push   $0x8038a8
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 1c 38 80 00       	push   $0x80381c
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 64 1b 00 00       	call   801e24 <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 fc 1b 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 74 17 00 00       	call   801a4b <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 e5 1b 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 c5 38 80 00       	push   $0x8038c5
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 1c 38 80 00       	push   $0x80381c
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 27 1b 00 00       	call   801e24 <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 bf 1b 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800305:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	e8 a2 16 00 00       	call   8019c0 <malloc>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800324:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	c1 e0 02             	shl    $0x2,%eax
  80032f:	89 c1                	mov    %eax,%ecx
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	c1 e0 03             	shl    $0x3,%eax
  800337:	01 c8                	add    %ecx,%eax
  800339:	05 00 00 00 80       	add    $0x80000000,%eax
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	74 14                	je     800356 <_main+0x31e>
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	68 78 38 80 00       	push   $0x803878
  80034a:	6a 58                	push   $0x58
  80034c:	68 1c 38 80 00       	push   $0x80381c
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 69 1b 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 a8 38 80 00       	push   $0x8038a8
  800368:	6a 5a                	push   $0x5a
  80036a:	68 1c 38 80 00       	push   $0x80381c
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 ab 1a 00 00       	call   801e24 <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 43 1b 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 bb 16 00 00       	call   801a4b <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 2c 1b 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 c5 38 80 00       	push   $0x8038c5
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 1c 38 80 00       	push   $0x80381c
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 6e 1a 00 00       	call   801e24 <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 06 1b 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	01 d2                	add    %edx,%edx
  8003c8:	01 d0                	add    %edx,%eax
  8003ca:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	50                   	push   %eax
  8003d1:	e8 ea 15 00 00       	call   8019c0 <malloc>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	c1 e0 02             	shl    $0x2,%eax
  8003e7:	89 c1                	mov    %eax,%ecx
  8003e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ec:	c1 e0 04             	shl    $0x4,%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <_main+0x3d6>
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 78 38 80 00       	push   $0x803878
  800402:	6a 67                	push   $0x67
  800404:	68 1c 38 80 00       	push   $0x80381c
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 b1 1a 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 a8 38 80 00       	push   $0x8038a8
  800420:	6a 69                	push   $0x69
  800422:	68 1c 38 80 00       	push   $0x80381c
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 f3 19 00 00       	call   801e24 <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 8b 1a 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	89 c2                	mov    %eax,%edx
  800441:	01 d2                	add    %edx,%edx
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	01 c0                	add    %eax,%eax
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	50                   	push   %eax
  800450:	e8 6b 15 00 00       	call   8019c0 <malloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80045b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	c1 e0 04             	shl    $0x4,%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	05 00 00 00 80       	add    $0x80000000,%eax
  80047c:	39 c1                	cmp    %eax,%ecx
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 78 38 80 00       	push   $0x803878
  800488:	6a 6f                	push   $0x6f
  80048a:	68 1c 38 80 00       	push   $0x80381c
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 2b 1a 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 a8 38 80 00       	push   $0x8038a8
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 1c 38 80 00       	push   $0x80381c
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 6d 19 00 00       	call   801e24 <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 05 1a 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 7d 15 00 00       	call   801a4b <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 ee 19 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 c5 38 80 00       	push   $0x8038c5
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 1c 38 80 00       	push   $0x80381c
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 30 19 00 00       	call   801e24 <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 c8 19 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 40 15 00 00       	call   801a4b <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 b1 19 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 c5 38 80 00       	push   $0x8038c5
  800520:	6a 7f                	push   $0x7f
  800522:	68 1c 38 80 00       	push   $0x80381c
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 f3 18 00 00       	call   801e24 <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 8b 19 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800539:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80053c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	c1 e0 02             	shl    $0x2,%eax
  800544:	01 d0                	add    %edx,%eax
  800546:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	50                   	push   %eax
  80054d:	e8 6e 14 00 00       	call   8019c0 <malloc>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800558:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 03             	shl    $0x3,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	89 c3                	mov    %eax,%ebx
  800569:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056c:	89 d0                	mov    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	c1 e0 03             	shl    $0x3,%eax
  800575:	01 d8                	add    %ebx,%eax
  800577:	05 00 00 00 80       	add    $0x80000000,%eax
  80057c:	39 c1                	cmp    %eax,%ecx
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 78 38 80 00       	push   $0x803878
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 1c 38 80 00       	push   $0x80381c
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 28 19 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 a8 38 80 00       	push   $0x8038a8
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 1c 38 80 00       	push   $0x80381c
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 67 18 00 00       	call   801e24 <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 ff 18 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  8005c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cb:	89 c2                	mov    %eax,%edx
  8005cd:	01 d2                	add    %edx,%edx
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8005d4:	83 ec 0c             	sub    $0xc,%esp
  8005d7:	50                   	push   %eax
  8005d8:	e8 e3 13 00 00       	call   8019c0 <malloc>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8005e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005e6:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8005eb:	74 17                	je     800604 <_main+0x5cc>
  8005ed:	83 ec 04             	sub    $0x4,%esp
  8005f0:	68 78 38 80 00       	push   $0x803878
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 1c 38 80 00       	push   $0x80381c
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 bb 18 00 00       	call   801ec4 <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 a8 38 80 00       	push   $0x8038a8
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 1c 38 80 00       	push   $0x80381c
  800620:	e8 97 01 00 00       	call   8007bc <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800625:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	f7 d8                	neg    %eax
  800636:	05 00 00 00 20       	add    $0x20000000,%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 7c 13 00 00       	call   8019c0 <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80064a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	74 17                	je     800668 <_main+0x630>
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 dc 38 80 00       	push   $0x8038dc
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 1c 38 80 00       	push   $0x80381c
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 40 39 80 00       	push   $0x803940
  800670:	e8 fb 03 00 00       	call   800a70 <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp

		return;
  800678:	90                   	nop
	}
}
  800679:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5f                   	pop    %edi
  80067e:	5d                   	pop    %ebp
  80067f:	c3                   	ret    

00800680 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800686:	e8 79 1a 00 00       	call   802104 <sys_getenvindex>
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80068e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800691:	89 d0                	mov    %edx,%eax
  800693:	c1 e0 03             	shl    $0x3,%eax
  800696:	01 d0                	add    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	c1 e0 04             	shl    $0x4,%eax
  8006a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ad:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8006bd:	84 c0                	test   %al,%al
  8006bf:	74 0f                	je     8006d0 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	05 5c 05 00 00       	add    $0x55c,%eax
  8006cb:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d4:	7e 0a                	jle    8006e0 <libmain+0x60>
		binaryname = argv[0];
  8006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 4a f9 ff ff       	call   800038 <_main>
  8006ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006f1:	e8 1b 18 00 00       	call   801f11 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 a4 39 80 00       	push   $0x8039a4
  8006fe:	e8 6d 03 00 00       	call   800a70 <cprintf>
  800703:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800706:	a1 20 50 80 00       	mov    0x805020,%eax
  80070b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800711:	a1 20 50 80 00       	mov    0x805020,%eax
  800716:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	52                   	push   %edx
  800720:	50                   	push   %eax
  800721:	68 cc 39 80 00       	push   $0x8039cc
  800726:	e8 45 03 00 00       	call   800a70 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80072e:	a1 20 50 80 00       	mov    0x805020,%eax
  800733:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800739:	a1 20 50 80 00       	mov    0x805020,%eax
  80073e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800744:	a1 20 50 80 00       	mov    0x805020,%eax
  800749:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80074f:	51                   	push   %ecx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	68 f4 39 80 00       	push   $0x8039f4
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 4c 3a 80 00       	push   $0x803a4c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 a4 39 80 00       	push   $0x8039a4
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 9b 17 00 00       	call   801f2b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800790:	e8 19 00 00 00       	call   8007ae <exit>
}
  800795:	90                   	nop
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 28 19 00 00       	call   8020d0 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 7d 19 00 00       	call   802136 <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 60 3a 80 00       	push   $0x803a60
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 65 3a 80 00       	push   $0x803a65
  8007fb:	e8 70 02 00 00       	call   800a70 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 f3 01 00 00       	call   800a05 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	6a 00                	push   $0x0
  80081a:	68 81 3a 80 00       	push   $0x803a81
  80081f:	e8 e1 01 00 00       	call   800a05 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800827:	e8 82 ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  80082c:	eb fe                	jmp    80082c <_panic+0x70>

0080082e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 50 74             	mov    0x74(%eax),%edx
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083f:	39 c2                	cmp    %eax,%edx
  800841:	74 14                	je     800857 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 84 3a 80 00       	push   $0x803a84
  80084b:	6a 26                	push   $0x26
  80084d:	68 d0 3a 80 00       	push   $0x803ad0
  800852:	e8 65 ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80085e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800865:	e9 c2 00 00 00       	jmp    80092c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	85 c0                	test   %eax,%eax
  80087d:	75 08                	jne    800887 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80087f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800882:	e9 a2 00 00 00       	jmp    800929 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800887:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800895:	eb 69                	jmp    800900 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800897:	a1 20 50 80 00       	mov    0x805020,%eax
  80089c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a5:	89 d0                	mov    %edx,%eax
  8008a7:	01 c0                	add    %eax,%eax
  8008a9:	01 d0                	add    %edx,%eax
  8008ab:	c1 e0 03             	shl    $0x3,%eax
  8008ae:	01 c8                	add    %ecx,%eax
  8008b0:	8a 40 04             	mov    0x4(%eax),%al
  8008b3:	84 c0                	test   %al,%al
  8008b5:	75 46                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c5:	89 d0                	mov    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d0                	add    %edx,%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	01 c8                	add    %ecx,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	75 09                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008fb:	eb 12                	jmp    80090f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e8             	incl   -0x18(%ebp)
  800900:	a1 20 50 80 00       	mov    0x805020,%eax
  800905:	8b 50 74             	mov    0x74(%eax),%edx
  800908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090b:	39 c2                	cmp    %eax,%edx
  80090d:	77 88                	ja     800897 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800913:	75 14                	jne    800929 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 dc 3a 80 00       	push   $0x803adc
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 d0 3a 80 00       	push   $0x803ad0
  800924:	e8 93 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800929:	ff 45 f0             	incl   -0x10(%ebp)
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800932:	0f 8c 32 ff ff ff    	jl     80086a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800938:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800946:	eb 26                	jmp    80096e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800948:	a1 20 50 80 00       	mov    0x805020,%eax
  80094d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	01 c0                	add    %eax,%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	c1 e0 03             	shl    $0x3,%eax
  80095f:	01 c8                	add    %ecx,%eax
  800961:	8a 40 04             	mov    0x4(%eax),%al
  800964:	3c 01                	cmp    $0x1,%al
  800966:	75 03                	jne    80096b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800968:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	ff 45 e0             	incl   -0x20(%ebp)
  80096e:	a1 20 50 80 00       	mov    0x805020,%eax
  800973:	8b 50 74             	mov    0x74(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 cb                	ja     800948 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 30 3b 80 00       	push   $0x803b30
  80098d:	6a 44                	push   $0x44
  80098f:	68 d0 3a 80 00       	push   $0x803ad0
  800994:	e8 23 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	89 0a                	mov    %ecx,(%edx)
  8009af:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b2:	88 d1                	mov    %dl,%cl
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c5:	75 2c                	jne    8009f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009c7:	a0 24 50 80 00       	mov    0x805024,%al
  8009cc:	0f b6 c0             	movzbl %al,%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8b 12                	mov    (%edx),%edx
  8009d4:	89 d1                	mov    %edx,%ecx
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	83 c2 08             	add    $0x8,%edx
  8009dc:	83 ec 04             	sub    $0x4,%esp
  8009df:	50                   	push   %eax
  8009e0:	51                   	push   %ecx
  8009e1:	52                   	push   %edx
  8009e2:	e8 7c 13 00 00       	call   801d63 <sys_cputs>
  8009e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 40 04             	mov    0x4(%eax),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a02:	90                   	nop
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a15:	00 00 00 
	b.cnt = 0;
  800a18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2e:	50                   	push   %eax
  800a2f:	68 9c 09 80 00       	push   $0x80099c
  800a34:	e8 11 02 00 00       	call   800c4a <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a3c:	a0 24 50 80 00       	mov    0x805024,%al
  800a41:	0f b6 c0             	movzbl %al,%eax
  800a44:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a4a:	83 ec 04             	sub    $0x4,%esp
  800a4d:	50                   	push   %eax
  800a4e:	52                   	push   %edx
  800a4f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a55:	83 c0 08             	add    $0x8,%eax
  800a58:	50                   	push   %eax
  800a59:	e8 05 13 00 00       	call   801d63 <sys_cputs>
  800a5e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a61:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a68:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 73 ff ff ff       	call   800a05 <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800aa3:	e8 69 14 00 00       	call   801f11 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	50                   	push   %eax
  800ab8:	e8 48 ff ff ff       	call   800a05 <vcprintf>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ac3:	e8 63 14 00 00       	call   801f2b <sys_enable_interrupt>
	return cnt;
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 14             	sub    $0x14,%esp
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae0:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aeb:	77 55                	ja     800b42 <printnum+0x75>
  800aed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af0:	72 05                	jb     800af7 <printnum+0x2a>
  800af2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af5:	77 4b                	ja     800b42 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800afa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800afd:	8b 45 18             	mov    0x18(%ebp),%eax
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0d:	e8 82 2a 00 00       	call   803594 <__udivdi3>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	ff 75 20             	pushl  0x20(%ebp)
  800b1b:	53                   	push   %ebx
  800b1c:	ff 75 18             	pushl  0x18(%ebp)
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 a1 ff ff ff       	call   800acd <printnum>
  800b2c:	83 c4 20             	add    $0x20,%esp
  800b2f:	eb 1a                	jmp    800b4b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 20             	pushl  0x20(%ebp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b42:	ff 4d 1c             	decl   0x1c(%ebp)
  800b45:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b49:	7f e6                	jg     800b31 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b4b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	53                   	push   %ebx
  800b5a:	51                   	push   %ecx
  800b5b:	52                   	push   %edx
  800b5c:	50                   	push   %eax
  800b5d:	e8 42 2b 00 00       	call   8036a4 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 94 3d 80 00       	add    $0x803d94,%eax
  800b6a:	8a 00                	mov    (%eax),%al
  800b6c:	0f be c0             	movsbl %al,%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
}
  800b7e:	90                   	nop
  800b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b87:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8b:	7e 1c                	jle    800ba9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	8d 50 08             	lea    0x8(%eax),%edx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 10                	mov    %edx,(%eax)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	83 e8 08             	sub    $0x8,%eax
  800ba2:	8b 50 04             	mov    0x4(%eax),%edx
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	eb 40                	jmp    800be9 <getuint+0x65>
	else if (lflag)
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	74 1e                	je     800bcd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 04             	lea    0x4(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	eb 1c                	jmp    800be9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf2:	7e 1c                	jle    800c10 <getint+0x25>
		return va_arg(*ap, long long);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 08             	lea    0x8(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 08             	sub    $0x8,%eax
  800c09:	8b 50 04             	mov    0x4(%eax),%edx
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	eb 38                	jmp    800c48 <getint+0x5d>
	else if (lflag)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 1a                	je     800c30 <getint+0x45>
		return va_arg(*ap, long);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
  800c2e:	eb 18                	jmp    800c48 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	8d 50 04             	lea    0x4(%eax),%edx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 10                	mov    %edx,(%eax)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	99                   	cltd   
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c52:	eb 17                	jmp    800c6b <vprintfmt+0x21>
			if (ch == '\0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	0f 84 af 03 00 00    	je     80100b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6e:	8d 50 01             	lea    0x1(%eax),%edx
  800c71:	89 55 10             	mov    %edx,0x10(%ebp)
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	0f b6 d8             	movzbl %al,%ebx
  800c79:	83 fb 25             	cmp    $0x25,%ebx
  800c7c:	75 d6                	jne    800c54 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c7e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d8             	movzbl %al,%ebx
  800cac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800caf:	83 f8 55             	cmp    $0x55,%eax
  800cb2:	0f 87 2b 03 00 00    	ja     800fe3 <vprintfmt+0x399>
  800cb8:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
  800cbf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc5:	eb d7                	jmp    800c9e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ccb:	eb d1                	jmp    800c9e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd7:	89 d0                	mov    %edx,%eax
  800cd9:	c1 e0 02             	shl    $0x2,%eax
  800cdc:	01 d0                	add    %edx,%eax
  800cde:	01 c0                	add    %eax,%eax
  800ce0:	01 d8                	add    %ebx,%eax
  800ce2:	83 e8 30             	sub    $0x30,%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf3:	7e 3e                	jle    800d33 <vprintfmt+0xe9>
  800cf5:	83 fb 39             	cmp    $0x39,%ebx
  800cf8:	7f 39                	jg     800d33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfd:	eb d5                	jmp    800cd4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d13:	eb 1f                	jmp    800d34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	79 83                	jns    800c9e <vprintfmt+0x54>
				width = 0;
  800d1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d22:	e9 77 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d2e:	e9 6b ff ff ff       	jmp    800c9e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d38:	0f 89 60 ff ff ff    	jns    800c9e <vprintfmt+0x54>
				width = precision, precision = -1;
  800d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d4b:	e9 4e ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d53:	e9 46 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			break;
  800d78:	e9 89 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d8e:	85 db                	test   %ebx,%ebx
  800d90:	79 02                	jns    800d94 <vprintfmt+0x14a>
				err = -err;
  800d92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d94:	83 fb 64             	cmp    $0x64,%ebx
  800d97:	7f 0b                	jg     800da4 <vprintfmt+0x15a>
  800d99:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 a5 3d 80 00       	push   $0x803da5
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 5e 02 00 00       	call   801013 <printfmt>
  800db5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db8:	e9 49 02 00 00       	jmp    801006 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dbd:	56                   	push   %esi
  800dbe:	68 ae 3d 80 00       	push   $0x803dae
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 45 02 00 00       	call   801013 <printfmt>
  800dce:	83 c4 10             	add    $0x10,%esp
			break;
  800dd1:	e9 30 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 e8 04             	sub    $0x4,%eax
  800de5:	8b 30                	mov    (%eax),%esi
  800de7:	85 f6                	test   %esi,%esi
  800de9:	75 05                	jne    800df0 <vprintfmt+0x1a6>
				p = "(null)";
  800deb:	be b1 3d 80 00       	mov    $0x803db1,%esi
			if (width > 0 && padc != '-')
  800df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df4:	7e 6d                	jle    800e63 <vprintfmt+0x219>
  800df6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dfa:	74 67                	je     800e63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	50                   	push   %eax
  800e03:	56                   	push   %esi
  800e04:	e8 0c 03 00 00       	call   801115 <strnlen>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0f:	eb 16                	jmp    800e27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2b:	7f e4                	jg     800e11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	eb 34                	jmp    800e63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e33:	74 1c                	je     800e51 <vprintfmt+0x207>
  800e35:	83 fb 1f             	cmp    $0x1f,%ebx
  800e38:	7e 05                	jle    800e3f <vprintfmt+0x1f5>
  800e3a:	83 fb 7e             	cmp    $0x7e,%ebx
  800e3d:	7e 12                	jle    800e51 <vprintfmt+0x207>
					putch('?', putdat);
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	6a 3f                	push   $0x3f
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	53                   	push   %ebx
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	ff d0                	call   *%eax
  800e5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e60:	ff 4d e4             	decl   -0x1c(%ebp)
  800e63:	89 f0                	mov    %esi,%eax
  800e65:	8d 70 01             	lea    0x1(%eax),%esi
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f be d8             	movsbl %al,%ebx
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	74 24                	je     800e95 <vprintfmt+0x24b>
  800e71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e75:	78 b8                	js     800e2f <vprintfmt+0x1e5>
  800e77:	ff 4d e0             	decl   -0x20(%ebp)
  800e7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7e:	79 af                	jns    800e2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e80:	eb 13                	jmp    800e95 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	6a 20                	push   $0x20
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	ff d0                	call   *%eax
  800e8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e92:	ff 4d e4             	decl   -0x1c(%ebp)
  800e95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e99:	7f e7                	jg     800e82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e9b:	e9 66 01 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea9:	50                   	push   %eax
  800eaa:	e8 3c fd ff ff       	call   800beb <getint>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	79 23                	jns    800ee5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 2d                	push   $0x2d
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	f7 d8                	neg    %eax
  800eda:	83 d2 00             	adc    $0x0,%edx
  800edd:	f7 da                	neg    %edx
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eec:	e9 bc 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 84 fc ff ff       	call   800b84 <getuint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f10:	e9 98 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 58                	push   $0x58
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	6a 58                	push   $0x58
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 58                	push   $0x58
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			break;
  800f45:	e9 bc 00 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 30                	push   $0x30
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 78                	push   $0x78
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 e8             	pushl  -0x18(%ebp)
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	e8 e7 fb ff ff       	call   800b84 <getuint>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	52                   	push   %edx
  800fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	ff 75 08             	pushl  0x8(%ebp)
  800fc8:	e8 00 fb ff ff       	call   800acd <printnum>
  800fcd:	83 c4 20             	add    $0x20,%esp
			break;
  800fd0:	eb 34                	jmp    801006 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	53                   	push   %ebx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
			break;
  800fe1:	eb 23                	jmp    801006 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	6a 25                	push   $0x25
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff3:	ff 4d 10             	decl   0x10(%ebp)
  800ff6:	eb 03                	jmp    800ffb <vprintfmt+0x3b1>
  800ff8:	ff 4d 10             	decl   0x10(%ebp)
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	48                   	dec    %eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 25                	cmp    $0x25,%al
  801003:	75 f3                	jne    800ff8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801005:	90                   	nop
		}
	}
  801006:	e9 47 fc ff ff       	jmp    800c52 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80100b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801019:	8d 45 10             	lea    0x10(%ebp),%eax
  80101c:	83 c0 04             	add    $0x4,%eax
  80101f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	ff 75 f4             	pushl  -0xc(%ebp)
  801028:	50                   	push   %eax
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 16 fc ff ff       	call   800c4a <vprintfmt>
  801034:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 40 08             	mov    0x8(%eax),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 10                	mov    (%eax),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 40 04             	mov    0x4(%eax),%eax
  801057:	39 c2                	cmp    %eax,%edx
  801059:	73 12                	jae    80106d <sprintputch+0x33>
		*b->buf++ = ch;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8b 00                	mov    (%eax),%eax
  801060:	8d 48 01             	lea    0x1(%eax),%ecx
  801063:	8b 55 0c             	mov    0xc(%ebp),%edx
  801066:	89 0a                	mov    %ecx,(%edx)
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	88 10                	mov    %dl,(%eax)
}
  80106d:	90                   	nop
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	01 d0                	add    %edx,%eax
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	74 06                	je     80109d <vsnprintf+0x2d>
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	7f 07                	jg     8010a4 <vsnprintf+0x34>
		return -E_INVAL;
  80109d:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a2:	eb 20                	jmp    8010c4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a4:	ff 75 14             	pushl  0x14(%ebp)
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	68 3a 10 80 00       	push   $0x80103a
  8010b3:	e8 92 fb ff ff       	call   800c4a <vprintfmt>
  8010b8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8010cf:	83 c0 04             	add    $0x4,%eax
  8010d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010db:	50                   	push   %eax
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	ff 75 08             	pushl  0x8(%ebp)
  8010e2:	e8 89 ff ff ff       	call   801070 <vsnprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 06                	jmp    801107 <strlen+0x15>
		n++;
  801101:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	84 c0                	test   %al,%al
  80110e:	75 f1                	jne    801101 <strlen+0xf>
		n++;
	return n;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801122:	eb 09                	jmp    80112d <strnlen+0x18>
		n++;
  801124:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	ff 4d 0c             	decl   0xc(%ebp)
  80112d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801131:	74 09                	je     80113c <strnlen+0x27>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 e8                	jne    801124 <strnlen+0xf>
		n++;
	return n;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80114d:	90                   	nop
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 08             	mov    %edx,0x8(%ebp)
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801160:	8a 12                	mov    (%edx),%dl
  801162:	88 10                	mov    %dl,(%eax)
  801164:	8a 00                	mov    (%eax),%al
  801166:	84 c0                	test   %al,%al
  801168:	75 e4                	jne    80114e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 1f                	jmp    8011a3 <strncpy+0x34>
		*dst++ = *src;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 08             	mov    %edx,0x8(%ebp)
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801190:	8a 12                	mov    (%edx),%dl
  801192:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 03                	je     8011a0 <strncpy+0x31>
			src++;
  80119d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a0:	ff 45 fc             	incl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	72 d9                	jb     801184 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 30                	je     8011f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011c2:	eb 16                	jmp    8011da <strlcpy+0x2a>
			*dst++ = *src++;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d6:	8a 12                	mov    (%edx),%dl
  8011d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011da:	ff 4d 10             	decl   0x10(%ebp)
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	74 09                	je     8011ec <strlcpy+0x3c>
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	84 c0                	test   %al,%al
  8011ea:	75 d8                	jne    8011c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801201:	eb 06                	jmp    801209 <strcmp+0xb>
		p++, q++;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 0e                	je     801220 <strcmp+0x22>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 10                	mov    (%eax),%dl
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 e3                	je     801203 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f b6 c0             	movzbl %al,%eax
  801230:	29 c2                	sub    %eax,%edx
  801232:	89 d0                	mov    %edx,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801239:	eb 09                	jmp    801244 <strncmp+0xe>
		n--, p++, q++;
  80123b:	ff 4d 10             	decl   0x10(%ebp)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 17                	je     801261 <strncmp+0x2b>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 0e                	je     801261 <strncmp+0x2b>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 10                	mov    (%eax),%dl
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	38 c2                	cmp    %al,%dl
  80125f:	74 da                	je     80123b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801265:	75 07                	jne    80126e <strncmp+0x38>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 14                	jmp    801282 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	0f b6 d0             	movzbl %al,%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801290:	eb 12                	jmp    8012a4 <strchr+0x20>
		if (*s == c)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129a:	75 05                	jne    8012a1 <strchr+0x1d>
			return (char *) s;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	eb 11                	jmp    8012b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 e5                	jne    801292 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c0:	eb 0d                	jmp    8012cf <strfind+0x1b>
		if (*s == c)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ca:	74 0e                	je     8012da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 ea                	jne    8012c2 <strfind+0xe>
  8012d8:	eb 01                	jmp    8012db <strfind+0x27>
		if (*s == c)
			break;
  8012da:	90                   	nop
	return (char *) s;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012f2:	eb 0e                	jmp    801302 <memset+0x22>
		*p++ = c;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801302:	ff 4d f8             	decl   -0x8(%ebp)
  801305:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801309:	79 e9                	jns    8012f4 <memset+0x14>
		*p++ = c;

	return v;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801322:	eb 16                	jmp    80133a <memcpy+0x2a>
		*d++ = *s++;
  801324:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801327:	8d 50 01             	lea    0x1(%eax),%edx
  80132a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80132d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801330:	8d 4a 01             	lea    0x1(%edx),%ecx
  801333:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801336:	8a 12                	mov    (%edx),%dl
  801338:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 dd                	jne    801324 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801364:	73 50                	jae    8013b6 <memmove+0x6a>
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801371:	76 43                	jbe    8013b6 <memmove+0x6a>
		s += n;
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80137f:	eb 10                	jmp    801391 <memmove+0x45>
			*--d = *--s;
  801381:	ff 4d f8             	decl   -0x8(%ebp)
  801384:	ff 4d fc             	decl   -0x4(%ebp)
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 10                	mov    (%eax),%dl
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	8d 50 ff             	lea    -0x1(%eax),%edx
  801397:	89 55 10             	mov    %edx,0x10(%ebp)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	75 e3                	jne    801381 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139e:	eb 23                	jmp    8013c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b2:	8a 12                	mov    (%edx),%dl
  8013b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 dd                	jne    8013a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013da:	eb 2a                	jmp    801406 <memcmp+0x3e>
		if (*s1 != *s2)
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 16                	je     801400 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	eb 18                	jmp    801418 <memcmp+0x50>
		s1++, s2++;
  801400:	ff 45 fc             	incl   -0x4(%ebp)
  801403:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140c:	89 55 10             	mov    %edx,0x10(%ebp)
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 c9                	jne    8013dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801420:	8b 55 08             	mov    0x8(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80142b:	eb 15                	jmp    801442 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f b6 d0             	movzbl %al,%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	39 c2                	cmp    %eax,%edx
  80143d:	74 0d                	je     80144c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801448:	72 e3                	jb     80142d <memfind+0x13>
  80144a:	eb 01                	jmp    80144d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144c:	90                   	nop
	return (void *) s;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80145f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801466:	eb 03                	jmp    80146b <strtol+0x19>
		s++;
  801468:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 20                	cmp    $0x20,%al
  801472:	74 f4                	je     801468 <strtol+0x16>
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 09                	cmp    $0x9,%al
  80147b:	74 eb                	je     801468 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 2b                	cmp    $0x2b,%al
  801484:	75 05                	jne    80148b <strtol+0x39>
		s++;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	eb 13                	jmp    80149e <strtol+0x4c>
	else if (*s == '-')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 2d                	cmp    $0x2d,%al
  801492:	75 0a                	jne    80149e <strtol+0x4c>
		s++, neg = 1;
  801494:	ff 45 08             	incl   0x8(%ebp)
  801497:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a2:	74 06                	je     8014aa <strtol+0x58>
  8014a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a8:	75 20                	jne    8014ca <strtol+0x78>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 30                	cmp    $0x30,%al
  8014b1:	75 17                	jne    8014ca <strtol+0x78>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	40                   	inc    %eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 78                	cmp    $0x78,%al
  8014bb:	75 0d                	jne    8014ca <strtol+0x78>
		s += 2, base = 16;
  8014bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c8:	eb 28                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ce:	75 15                	jne    8014e5 <strtol+0x93>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	3c 30                	cmp    $0x30,%al
  8014d7:	75 0c                	jne    8014e5 <strtol+0x93>
		s++, base = 8;
  8014d9:	ff 45 08             	incl   0x8(%ebp)
  8014dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e3:	eb 0d                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0)
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	75 07                	jne    8014f2 <strtol+0xa0>
		base = 10;
  8014eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	3c 2f                	cmp    $0x2f,%al
  8014f9:	7e 19                	jle    801514 <strtol+0xc2>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 39                	cmp    $0x39,%al
  801502:	7f 10                	jg     801514 <strtol+0xc2>
			dig = *s - '0';
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 30             	sub    $0x30,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801512:	eb 42                	jmp    801556 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 60                	cmp    $0x60,%al
  80151b:	7e 19                	jle    801536 <strtol+0xe4>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3c 7a                	cmp    $0x7a,%al
  801524:	7f 10                	jg     801536 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	83 e8 57             	sub    $0x57,%eax
  801531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801534:	eb 20                	jmp    801556 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3c 40                	cmp    $0x40,%al
  80153d:	7e 39                	jle    801578 <strtol+0x126>
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 5a                	cmp    $0x5a,%al
  801546:	7f 30                	jg     801578 <strtol+0x126>
			dig = *s - 'A' + 10;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	0f be c0             	movsbl %al,%eax
  801550:	83 e8 37             	sub    $0x37,%eax
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155c:	7d 19                	jge    801577 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80155e:	ff 45 08             	incl   0x8(%ebp)
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	0f af 45 10          	imul   0x10(%ebp),%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801572:	e9 7b ff ff ff       	jmp    8014f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801577:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801578:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157c:	74 08                	je     801586 <strtol+0x134>
		*endptr = (char *) s;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158a:	74 07                	je     801593 <strtol+0x141>
  80158c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158f:	f7 d8                	neg    %eax
  801591:	eb 03                	jmp    801596 <strtol+0x144>
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <ltostr>:

void
ltostr(long value, char *str)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b0:	79 13                	jns    8015c5 <ltostr+0x2d>
	{
		neg = 1;
  8015b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cd:	99                   	cltd   
  8015ce:	f7 f9                	idiv   %ecx
  8015d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e6:	83 c2 30             	add    $0x30,%edx
  8015e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f3:	f7 e9                	imul   %ecx
  8015f5:	c1 fa 02             	sar    $0x2,%edx
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	c1 f8 1f             	sar    $0x1f,%eax
  8015fd:	29 c2                	sub    %eax,%edx
  8015ff:	89 d0                	mov    %edx,%eax
  801601:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801607:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80160c:	f7 e9                	imul   %ecx
  80160e:	c1 fa 02             	sar    $0x2,%edx
  801611:	89 c8                	mov    %ecx,%eax
  801613:	c1 f8 1f             	sar    $0x1f,%eax
  801616:	29 c2                	sub    %eax,%edx
  801618:	89 d0                	mov    %edx,%eax
  80161a:	c1 e0 02             	shl    $0x2,%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	01 c0                	add    %eax,%eax
  801621:	29 c1                	sub    %eax,%ecx
  801623:	89 ca                	mov    %ecx,%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	75 9c                	jne    8015c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	48                   	dec    %eax
  801634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163b:	74 3d                	je     80167a <ltostr+0xe2>
		start = 1 ;
  80163d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801644:	eb 34                	jmp    80167a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	01 c2                	add    %eax,%edx
  80165b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	01 c8                	add    %ecx,%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801667:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801672:	88 02                	mov    %al,(%edx)
		start++ ;
  801674:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801677:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801680:	7c c4                	jl     801646 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801682:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 54 fa ff ff       	call   8010f2 <strlen>
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	e8 46 fa ff ff       	call   8010f2 <strlen>
  8016ac:	83 c4 04             	add    $0x4,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c0:	eb 17                	jmp    8016d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	01 c8                	add    %ecx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d6:	ff 45 fc             	incl   -0x4(%ebp)
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016df:	7c e1                	jl     8016c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ef:	eb 1f                	jmp    801710 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f4:	8d 50 01             	lea    0x1(%eax),%edx
  8016f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	01 c2                	add    %eax,%edx
  801701:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	01 c8                	add    %ecx,%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170d:	ff 45 f8             	incl   -0x8(%ebp)
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801716:	7c d9                	jl     8016f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801718:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	c6 00 00             	movb   $0x0,(%eax)
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801729:	8b 45 14             	mov    0x14(%ebp),%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801732:	8b 45 14             	mov    0x14(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801749:	eb 0c                	jmp    801757 <strsplit+0x31>
			*string++ = 0;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8d 50 01             	lea    0x1(%eax),%edx
  801751:	89 55 08             	mov    %edx,0x8(%ebp)
  801754:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 18                	je     801778 <strsplit+0x52>
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	0f be c0             	movsbl %al,%eax
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	e8 13 fb ff ff       	call   801284 <strchr>
  801771:	83 c4 08             	add    $0x8,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	75 d3                	jne    80174b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 5a                	je     8017db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801781:	8b 45 14             	mov    0x14(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	83 f8 0f             	cmp    $0xf,%eax
  801789:	75 07                	jne    801792 <strsplit+0x6c>
		{
			return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 66                	jmp    8017f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	8d 48 01             	lea    0x1(%eax),%ecx
  80179a:	8b 55 14             	mov    0x14(%ebp),%edx
  80179d:	89 0a                	mov    %ecx,(%edx)
  80179f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b0:	eb 03                	jmp    8017b5 <strsplit+0x8f>
			string++;
  8017b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	84 c0                	test   %al,%al
  8017bc:	74 8b                	je     801749 <strsplit+0x23>
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 b5 fa ff ff       	call   801284 <strchr>
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 dc                	je     8017b2 <strsplit+0x8c>
			string++;
	}
  8017d6:	e9 6e ff ff ff       	jmp    801749 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801800:	a1 04 50 80 00       	mov    0x805004,%eax
  801805:	85 c0                	test   %eax,%eax
  801807:	74 1f                	je     801828 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801809:	e8 1d 00 00 00       	call   80182b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	68 10 3f 80 00       	push   $0x803f10
  801816:	e8 55 f2 ff ff       	call   800a70 <cprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80181e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801825:	00 00 00 
	}
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801831:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801838:	00 00 00 
  80183b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801842:	00 00 00 
  801845:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80184c:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80184f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801856:	00 00 00 
  801859:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801860:	00 00 00 
  801863:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80186a:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80186d:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801874:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  801877:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80187e:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80188d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801892:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  801897:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80189e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018a6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	6a 06                	push   $0x6
  8018b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b3:	50                   	push   %eax
  8018b4:	e8 ee 05 00 00       	call   801ea7 <sys_allocate_chunk>
  8018b9:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018bc:	a1 20 51 80 00       	mov    0x805120,%eax
  8018c1:	83 ec 0c             	sub    $0xc,%esp
  8018c4:	50                   	push   %eax
  8018c5:	e8 63 0c 00 00       	call   80252d <initialize_MemBlocksList>
  8018ca:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8018cd:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8018d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8018d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d8:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8018df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018f0:	89 c2                	mov    %eax,%edx
  8018f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f5:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8018f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018fb:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  801902:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190c:	8b 50 08             	mov    0x8(%eax),%edx
  80190f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801912:	01 d0                	add    %edx,%eax
  801914:	48                   	dec    %eax
  801915:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801918:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80191b:	ba 00 00 00 00       	mov    $0x0,%edx
  801920:	f7 75 e0             	divl   -0x20(%ebp)
  801923:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801926:	29 d0                	sub    %edx,%eax
  801928:	89 c2                	mov    %eax,%edx
  80192a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80192d:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  801930:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801934:	75 14                	jne    80194a <initialize_dyn_block_system+0x11f>
  801936:	83 ec 04             	sub    $0x4,%esp
  801939:	68 35 3f 80 00       	push   $0x803f35
  80193e:	6a 34                	push   $0x34
  801940:	68 53 3f 80 00       	push   $0x803f53
  801945:	e8 72 ee ff ff       	call   8007bc <_panic>
  80194a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80194d:	8b 00                	mov    (%eax),%eax
  80194f:	85 c0                	test   %eax,%eax
  801951:	74 10                	je     801963 <initialize_dyn_block_system+0x138>
  801953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801956:	8b 00                	mov    (%eax),%eax
  801958:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80195b:	8b 52 04             	mov    0x4(%edx),%edx
  80195e:	89 50 04             	mov    %edx,0x4(%eax)
  801961:	eb 0b                	jmp    80196e <initialize_dyn_block_system+0x143>
  801963:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801966:	8b 40 04             	mov    0x4(%eax),%eax
  801969:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80196e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801971:	8b 40 04             	mov    0x4(%eax),%eax
  801974:	85 c0                	test   %eax,%eax
  801976:	74 0f                	je     801987 <initialize_dyn_block_system+0x15c>
  801978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80197b:	8b 40 04             	mov    0x4(%eax),%eax
  80197e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801981:	8b 12                	mov    (%edx),%edx
  801983:	89 10                	mov    %edx,(%eax)
  801985:	eb 0a                	jmp    801991 <initialize_dyn_block_system+0x166>
  801987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80198a:	8b 00                	mov    (%eax),%eax
  80198c:	a3 48 51 80 00       	mov    %eax,0x805148
  801991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801994:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80199a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80199d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8019a9:	48                   	dec    %eax
  8019aa:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  8019af:	83 ec 0c             	sub    $0xc,%esp
  8019b2:	ff 75 e8             	pushl  -0x18(%ebp)
  8019b5:	e8 c4 13 00 00       	call   802d7e <insert_sorted_with_merge_freeList>
  8019ba:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8019bd:	90                   	nop
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <malloc>:
//=================================



void* malloc(uint32 size)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019c6:	e8 2f fe ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  8019cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019cf:	75 07                	jne    8019d8 <malloc+0x18>
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d6:	eb 71                	jmp    801a49 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8019d8:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8019df:	76 07                	jbe    8019e8 <malloc+0x28>
	return NULL;
  8019e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e6:	eb 61                	jmp    801a49 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019e8:	e8 88 08 00 00       	call   802275 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	74 53                	je     801a44 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8019f1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8019f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fe:	01 d0                	add    %edx,%eax
  801a00:	48                   	dec    %eax
  801a01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a07:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0c:	f7 75 f4             	divl   -0xc(%ebp)
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	29 d0                	sub    %edx,%eax
  801a14:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  801a17:	83 ec 0c             	sub    $0xc,%esp
  801a1a:	ff 75 ec             	pushl  -0x14(%ebp)
  801a1d:	e8 d2 0d 00 00       	call   8027f4 <alloc_block_FF>
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  801a28:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a2c:	74 16                	je     801a44 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  801a2e:	83 ec 0c             	sub    $0xc,%esp
  801a31:	ff 75 e8             	pushl  -0x18(%ebp)
  801a34:	e8 0c 0c 00 00       	call   802645 <insert_sorted_allocList>
  801a39:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  801a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a3f:	8b 40 08             	mov    0x8(%eax),%eax
  801a42:	eb 05                	jmp    801a49 <malloc+0x89>
    }

			}


	return NULL;
  801a44:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	ff 75 f0             	pushl  -0x10(%ebp)
  801a68:	68 40 50 80 00       	push   $0x805040
  801a6d:	e8 a0 0b 00 00       	call   802612 <find_block>
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  801a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7b:	8b 50 0c             	mov    0xc(%eax),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	52                   	push   %edx
  801a85:	50                   	push   %eax
  801a86:	e8 e4 03 00 00       	call   801e6f <sys_free_user_mem>
  801a8b:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  801a8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a92:	75 17                	jne    801aab <free+0x60>
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	68 35 3f 80 00       	push   $0x803f35
  801a9c:	68 84 00 00 00       	push   $0x84
  801aa1:	68 53 3f 80 00       	push   $0x803f53
  801aa6:	e8 11 ed ff ff       	call   8007bc <_panic>
  801aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aae:	8b 00                	mov    (%eax),%eax
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	74 10                	je     801ac4 <free+0x79>
  801ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab7:	8b 00                	mov    (%eax),%eax
  801ab9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801abc:	8b 52 04             	mov    0x4(%edx),%edx
  801abf:	89 50 04             	mov    %edx,0x4(%eax)
  801ac2:	eb 0b                	jmp    801acf <free+0x84>
  801ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac7:	8b 40 04             	mov    0x4(%eax),%eax
  801aca:	a3 44 50 80 00       	mov    %eax,0x805044
  801acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad2:	8b 40 04             	mov    0x4(%eax),%eax
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	74 0f                	je     801ae8 <free+0x9d>
  801ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801adc:	8b 40 04             	mov    0x4(%eax),%eax
  801adf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ae2:	8b 12                	mov    (%edx),%edx
  801ae4:	89 10                	mov    %edx,(%eax)
  801ae6:	eb 0a                	jmp    801af2 <free+0xa7>
  801ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aeb:	8b 00                	mov    (%eax),%eax
  801aed:	a3 40 50 80 00       	mov    %eax,0x805040
  801af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801afe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b05:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b0a:	48                   	dec    %eax
  801b0b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  801b10:	83 ec 0c             	sub    $0xc,%esp
  801b13:	ff 75 ec             	pushl  -0x14(%ebp)
  801b16:	e8 63 12 00 00       	call   802d7e <insert_sorted_with_merge_freeList>
  801b1b:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  801b1e:	90                   	nop
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 38             	sub    $0x38,%esp
  801b27:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b2d:	e8 c8 fc ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801b32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b36:	75 0a                	jne    801b42 <smalloc+0x21>
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3d:	e9 a0 00 00 00       	jmp    801be2 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  801b42:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801b49:	76 0a                	jbe    801b55 <smalloc+0x34>
		return NULL;
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b50:	e9 8d 00 00 00       	jmp    801be2 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b55:	e8 1b 07 00 00       	call   802275 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	74 7f                	je     801bdd <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801b5e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	01 d0                	add    %edx,%eax
  801b6d:	48                   	dec    %eax
  801b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b74:	ba 00 00 00 00       	mov    $0x0,%edx
  801b79:	f7 75 f4             	divl   -0xc(%ebp)
  801b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7f:	29 d0                	sub    %edx,%eax
  801b81:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	ff 75 ec             	pushl  -0x14(%ebp)
  801b8a:	e8 65 0c 00 00       	call   8027f4 <alloc_block_FF>
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  801b95:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b99:	74 42                	je     801bdd <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  801b9b:	83 ec 0c             	sub    $0xc,%esp
  801b9e:	ff 75 e8             	pushl  -0x18(%ebp)
  801ba1:	e8 9f 0a 00 00       	call   802645 <insert_sorted_allocList>
  801ba6:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  801ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bac:	8b 40 08             	mov    0x8(%eax),%eax
  801baf:	89 c2                	mov    %eax,%edx
  801bb1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801bb5:	52                   	push   %edx
  801bb6:	50                   	push   %eax
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	e8 38 04 00 00       	call   801ffa <sys_createSharedObject>
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  801bc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bcc:	79 07                	jns    801bd5 <smalloc+0xb4>
	    		  return NULL;
  801bce:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd3:	eb 0d                	jmp    801be2 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  801bd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd8:	8b 40 08             	mov    0x8(%eax),%eax
  801bdb:	eb 05                	jmp    801be2 <smalloc+0xc1>


				}


		return NULL;
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bea:	e8 0b fc ff ff       	call   8017fa <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801bef:	e8 81 06 00 00       	call   802275 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	0f 84 9f 00 00 00    	je     801c9b <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801bfc:	83 ec 08             	sub    $0x8,%esp
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 1a 04 00 00       	call   802024 <sys_getSizeOfSharedObject>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  801c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c14:	79 0a                	jns    801c20 <sget+0x3c>
		return NULL;
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1b:	e9 80 00 00 00       	jmp    801ca0 <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  801c20:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2d:	01 d0                	add    %edx,%eax
  801c2f:	48                   	dec    %eax
  801c30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c36:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3b:	f7 75 f0             	divl   -0x10(%ebp)
  801c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c41:	29 d0                	sub    %edx,%eax
  801c43:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  801c46:	83 ec 0c             	sub    $0xc,%esp
  801c49:	ff 75 e8             	pushl  -0x18(%ebp)
  801c4c:	e8 a3 0b 00 00       	call   8027f4 <alloc_block_FF>
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  801c57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c5b:	74 3e                	je     801c9b <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  801c5d:	83 ec 0c             	sub    $0xc,%esp
  801c60:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c63:	e8 dd 09 00 00       	call   802645 <insert_sorted_allocList>
  801c68:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  801c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c6e:	8b 40 08             	mov    0x8(%eax),%eax
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	50                   	push   %eax
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	ff 75 08             	pushl  0x8(%ebp)
  801c7b:	e8 c1 03 00 00       	call   802041 <sys_getSharedObject>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  801c86:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c8a:	79 07                	jns    801c93 <sget+0xaf>
	    		  return NULL;
  801c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c91:	eb 0d                	jmp    801ca0 <sget+0xbc>
	  	return(void*) returned_block->sva;
  801c93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c96:	8b 40 08             	mov    0x8(%eax),%eax
  801c99:	eb 05                	jmp    801ca0 <sget+0xbc>
	      }
	}
	   return NULL;
  801c9b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ca8:	e8 4d fb ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	68 60 3f 80 00       	push   $0x803f60
  801cb5:	68 12 01 00 00       	push   $0x112
  801cba:	68 53 3f 80 00       	push   $0x803f53
  801cbf:	e8 f8 ea ff ff       	call   8007bc <_panic>

00801cc4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	68 88 3f 80 00       	push   $0x803f88
  801cd2:	68 26 01 00 00       	push   $0x126
  801cd7:	68 53 3f 80 00       	push   $0x803f53
  801cdc:	e8 db ea ff ff       	call   8007bc <_panic>

00801ce1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ce7:	83 ec 04             	sub    $0x4,%esp
  801cea:	68 ac 3f 80 00       	push   $0x803fac
  801cef:	68 31 01 00 00       	push   $0x131
  801cf4:	68 53 3f 80 00       	push   $0x803f53
  801cf9:	e8 be ea ff ff       	call   8007bc <_panic>

00801cfe <shrink>:

}
void shrink(uint32 newSize)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d04:	83 ec 04             	sub    $0x4,%esp
  801d07:	68 ac 3f 80 00       	push   $0x803fac
  801d0c:	68 36 01 00 00       	push   $0x136
  801d11:	68 53 3f 80 00       	push   $0x803f53
  801d16:	e8 a1 ea ff ff       	call   8007bc <_panic>

00801d1b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d21:	83 ec 04             	sub    $0x4,%esp
  801d24:	68 ac 3f 80 00       	push   $0x803fac
  801d29:	68 3b 01 00 00       	push   $0x13b
  801d2e:	68 53 3f 80 00       	push   $0x803f53
  801d33:	e8 84 ea ff ff       	call   8007bc <_panic>

00801d38 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	57                   	push   %edi
  801d3c:	56                   	push   %esi
  801d3d:	53                   	push   %ebx
  801d3e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d4d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d50:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d53:	cd 30                	int    $0x30
  801d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5b:	83 c4 10             	add    $0x10,%esp
  801d5e:	5b                   	pop    %ebx
  801d5f:	5e                   	pop    %esi
  801d60:	5f                   	pop    %edi
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    

00801d63 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 04             	sub    $0x4,%esp
  801d69:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d6f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	52                   	push   %edx
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	50                   	push   %eax
  801d7f:	6a 00                	push   $0x0
  801d81:	e8 b2 ff ff ff       	call   801d38 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	90                   	nop
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_cgetc>:

int
sys_cgetc(void)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 01                	push   $0x1
  801d9b:	e8 98 ff ff ff       	call   801d38 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 05                	push   $0x5
  801db8:	e8 7b ff ff ff       	call   801d38 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	56                   	push   %esi
  801dc6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dc7:	8b 75 18             	mov    0x18(%ebp),%esi
  801dca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dcd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	51                   	push   %ecx
  801dd9:	52                   	push   %edx
  801dda:	50                   	push   %eax
  801ddb:	6a 06                	push   $0x6
  801ddd:	e8 56 ff ff ff       	call   801d38 <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de8:	5b                   	pop    %ebx
  801de9:	5e                   	pop    %esi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801def:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	52                   	push   %edx
  801dfc:	50                   	push   %eax
  801dfd:	6a 07                	push   $0x7
  801dff:	e8 34 ff ff ff       	call   801d38 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	ff 75 0c             	pushl  0xc(%ebp)
  801e15:	ff 75 08             	pushl  0x8(%ebp)
  801e18:	6a 08                	push   $0x8
  801e1a:	e8 19 ff ff ff       	call   801d38 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 09                	push   $0x9
  801e33:	e8 00 ff ff ff       	call   801d38 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 0a                	push   $0xa
  801e4c:	e8 e7 fe ff ff       	call   801d38 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 0b                	push   $0xb
  801e65:	e8 ce fe ff ff       	call   801d38 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	ff 75 0c             	pushl  0xc(%ebp)
  801e7b:	ff 75 08             	pushl  0x8(%ebp)
  801e7e:	6a 0f                	push   $0xf
  801e80:	e8 b3 fe ff ff       	call   801d38 <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
	return;
  801e88:	90                   	nop
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	ff 75 0c             	pushl  0xc(%ebp)
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	6a 10                	push   $0x10
  801e9c:	e8 97 fe ff ff       	call   801d38 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	ff 75 10             	pushl  0x10(%ebp)
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	ff 75 08             	pushl  0x8(%ebp)
  801eb7:	6a 11                	push   $0x11
  801eb9:	e8 7a fe ff ff       	call   801d38 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec1:	90                   	nop
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 0c                	push   $0xc
  801ed3:	e8 60 fe ff ff       	call   801d38 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	ff 75 08             	pushl  0x8(%ebp)
  801eeb:	6a 0d                	push   $0xd
  801eed:	e8 46 fe ff ff       	call   801d38 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 0e                	push   $0xe
  801f06:	e8 2d fe ff ff       	call   801d38 <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	90                   	nop
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 13                	push   $0x13
  801f20:	e8 13 fe ff ff       	call   801d38 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	90                   	nop
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 14                	push   $0x14
  801f3a:	e8 f9 fd ff ff       	call   801d38 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	90                   	nop
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f51:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	50                   	push   %eax
  801f5e:	6a 15                	push   $0x15
  801f60:	e8 d3 fd ff ff       	call   801d38 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	90                   	nop
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 16                	push   $0x16
  801f7a:	e8 b9 fd ff ff       	call   801d38 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	90                   	nop
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	ff 75 0c             	pushl  0xc(%ebp)
  801f94:	50                   	push   %eax
  801f95:	6a 17                	push   $0x17
  801f97:	e8 9c fd ff ff       	call   801d38 <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	52                   	push   %edx
  801fb1:	50                   	push   %eax
  801fb2:	6a 1a                	push   $0x1a
  801fb4:	e8 7f fd ff ff       	call   801d38 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	6a 18                	push   $0x18
  801fd1:	e8 62 fd ff ff       	call   801d38 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
}
  801fd9:	90                   	nop
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	6a 19                	push   $0x19
  801fef:	e8 44 fd ff ff       	call   801d38 <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
}
  801ff7:	90                   	nop
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	8b 45 10             	mov    0x10(%ebp),%eax
  802003:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802006:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802009:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	6a 00                	push   $0x0
  802012:	51                   	push   %ecx
  802013:	52                   	push   %edx
  802014:	ff 75 0c             	pushl  0xc(%ebp)
  802017:	50                   	push   %eax
  802018:	6a 1b                	push   $0x1b
  80201a:	e8 19 fd ff ff       	call   801d38 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	52                   	push   %edx
  802034:	50                   	push   %eax
  802035:	6a 1c                	push   $0x1c
  802037:	e8 fc fc ff ff       	call   801d38 <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802044:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	51                   	push   %ecx
  802052:	52                   	push   %edx
  802053:	50                   	push   %eax
  802054:	6a 1d                	push   $0x1d
  802056:	e8 dd fc ff ff       	call   801d38 <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802063:	8b 55 0c             	mov    0xc(%ebp),%edx
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	52                   	push   %edx
  802070:	50                   	push   %eax
  802071:	6a 1e                	push   $0x1e
  802073:	e8 c0 fc ff ff       	call   801d38 <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 1f                	push   $0x1f
  80208c:	e8 a7 fc ff ff       	call   801d38 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	6a 00                	push   $0x0
  80209e:	ff 75 14             	pushl  0x14(%ebp)
  8020a1:	ff 75 10             	pushl  0x10(%ebp)
  8020a4:	ff 75 0c             	pushl  0xc(%ebp)
  8020a7:	50                   	push   %eax
  8020a8:	6a 20                	push   $0x20
  8020aa:	e8 89 fc ff ff       	call   801d38 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	50                   	push   %eax
  8020c3:	6a 21                	push   $0x21
  8020c5:	e8 6e fc ff ff       	call   801d38 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	90                   	nop
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	50                   	push   %eax
  8020df:	6a 22                	push   $0x22
  8020e1:	e8 52 fc ff ff       	call   801d38 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 02                	push   $0x2
  8020fa:	e8 39 fc ff ff       	call   801d38 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 03                	push   $0x3
  802113:	e8 20 fc ff ff       	call   801d38 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 04                	push   $0x4
  80212c:	e8 07 fc ff ff       	call   801d38 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_exit_env>:


void sys_exit_env(void)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 23                	push   $0x23
  802145:	e8 ee fb ff ff       	call   801d38 <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	90                   	nop
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802156:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802159:	8d 50 04             	lea    0x4(%eax),%edx
  80215c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	52                   	push   %edx
  802166:	50                   	push   %eax
  802167:	6a 24                	push   $0x24
  802169:	e8 ca fb ff ff       	call   801d38 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
	return result;
  802171:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217a:	89 01                	mov    %eax,(%ecx)
  80217c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	c9                   	leave  
  802183:	c2 04 00             	ret    $0x4

00802186 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	ff 75 10             	pushl  0x10(%ebp)
  802190:	ff 75 0c             	pushl  0xc(%ebp)
  802193:	ff 75 08             	pushl  0x8(%ebp)
  802196:	6a 12                	push   $0x12
  802198:	e8 9b fb ff ff       	call   801d38 <syscall>
  80219d:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a0:	90                   	nop
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 25                	push   $0x25
  8021b2:	e8 81 fb ff ff       	call   801d38 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	50                   	push   %eax
  8021d5:	6a 26                	push   $0x26
  8021d7:	e8 5c fb ff ff       	call   801d38 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021df:	90                   	nop
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <rsttst>:
void rsttst()
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 28                	push   $0x28
  8021f1:	e8 42 fb ff ff       	call   801d38 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f9:	90                   	nop
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	8b 45 14             	mov    0x14(%ebp),%eax
  802205:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802208:	8b 55 18             	mov    0x18(%ebp),%edx
  80220b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80220f:	52                   	push   %edx
  802210:	50                   	push   %eax
  802211:	ff 75 10             	pushl  0x10(%ebp)
  802214:	ff 75 0c             	pushl  0xc(%ebp)
  802217:	ff 75 08             	pushl  0x8(%ebp)
  80221a:	6a 27                	push   $0x27
  80221c:	e8 17 fb ff ff       	call   801d38 <syscall>
  802221:	83 c4 18             	add    $0x18,%esp
	return ;
  802224:	90                   	nop
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <chktst>:
void chktst(uint32 n)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	ff 75 08             	pushl  0x8(%ebp)
  802235:	6a 29                	push   $0x29
  802237:	e8 fc fa ff ff       	call   801d38 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
	return ;
  80223f:	90                   	nop
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <inctst>:

void inctst()
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 2a                	push   $0x2a
  802251:	e8 e2 fa ff ff       	call   801d38 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
	return ;
  802259:	90                   	nop
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <gettst>:
uint32 gettst()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 2b                	push   $0x2b
  80226b:	e8 c8 fa ff ff       	call   801d38 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 2c                	push   $0x2c
  802287:	e8 ac fa ff ff       	call   801d38 <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
  80228f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802292:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802296:	75 07                	jne    80229f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802298:	b8 01 00 00 00       	mov    $0x1,%eax
  80229d:	eb 05                	jmp    8022a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 2c                	push   $0x2c
  8022b8:	e8 7b fa ff ff       	call   801d38 <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
  8022c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022c3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022c7:	75 07                	jne    8022d0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ce:	eb 05                	jmp    8022d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 2c                	push   $0x2c
  8022e9:	e8 4a fa ff ff       	call   801d38 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
  8022f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022f4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022f8:	75 07                	jne    802301 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ff:	eb 05                	jmp    802306 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 2c                	push   $0x2c
  80231a:	e8 19 fa ff ff       	call   801d38 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
  802322:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802325:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802329:	75 07                	jne    802332 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80232b:	b8 01 00 00 00       	mov    $0x1,%eax
  802330:	eb 05                	jmp    802337 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	ff 75 08             	pushl  0x8(%ebp)
  802347:	6a 2d                	push   $0x2d
  802349:	e8 ea f9 ff ff       	call   801d38 <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
	return ;
  802351:	90                   	nop
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802358:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80235b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80235e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	6a 00                	push   $0x0
  802366:	53                   	push   %ebx
  802367:	51                   	push   %ecx
  802368:	52                   	push   %edx
  802369:	50                   	push   %eax
  80236a:	6a 2e                	push   $0x2e
  80236c:	e8 c7 f9 ff ff       	call   801d38 <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
}
  802374:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80237c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	52                   	push   %edx
  802389:	50                   	push   %eax
  80238a:	6a 2f                	push   $0x2f
  80238c:	e8 a7 f9 ff ff       	call   801d38 <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80239c:	83 ec 0c             	sub    $0xc,%esp
  80239f:	68 bc 3f 80 00       	push   $0x803fbc
  8023a4:	e8 c7 e6 ff ff       	call   800a70 <cprintf>
  8023a9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8023ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	68 e8 3f 80 00       	push   $0x803fe8
  8023bb:	e8 b0 e6 ff ff       	call   800a70 <cprintf>
  8023c0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023c3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8023cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cf:	eb 56                	jmp    802427 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d5:	74 1c                	je     8023f3 <print_mem_block_lists+0x5d>
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 50 08             	mov    0x8(%eax),%edx
  8023dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e0:	8b 48 08             	mov    0x8(%eax),%ecx
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e9:	01 c8                	add    %ecx,%eax
  8023eb:	39 c2                	cmp    %eax,%edx
  8023ed:	73 04                	jae    8023f3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023ef:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 50 08             	mov    0x8(%eax),%edx
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ff:	01 c2                	add    %eax,%edx
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 40 08             	mov    0x8(%eax),%eax
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	52                   	push   %edx
  80240b:	50                   	push   %eax
  80240c:	68 fd 3f 80 00       	push   $0x803ffd
  802411:	e8 5a e6 ff ff       	call   800a70 <cprintf>
  802416:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80241f:	a1 40 51 80 00       	mov    0x805140,%eax
  802424:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242b:	74 07                	je     802434 <print_mem_block_lists+0x9e>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	eb 05                	jmp    802439 <print_mem_block_lists+0xa3>
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	a3 40 51 80 00       	mov    %eax,0x805140
  80243e:	a1 40 51 80 00       	mov    0x805140,%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	75 8a                	jne    8023d1 <print_mem_block_lists+0x3b>
  802447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244b:	75 84                	jne    8023d1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80244d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802451:	75 10                	jne    802463 <print_mem_block_lists+0xcd>
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	68 0c 40 80 00       	push   $0x80400c
  80245b:	e8 10 e6 ff ff       	call   800a70 <cprintf>
  802460:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802463:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80246a:	83 ec 0c             	sub    $0xc,%esp
  80246d:	68 30 40 80 00       	push   $0x804030
  802472:	e8 f9 e5 ff ff       	call   800a70 <cprintf>
  802477:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80247a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80247e:	a1 40 50 80 00       	mov    0x805040,%eax
  802483:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802486:	eb 56                	jmp    8024de <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80248c:	74 1c                	je     8024aa <print_mem_block_lists+0x114>
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 50 08             	mov    0x8(%eax),%edx
  802494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802497:	8b 48 08             	mov    0x8(%eax),%ecx
  80249a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249d:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a0:	01 c8                	add    %ecx,%eax
  8024a2:	39 c2                	cmp    %eax,%edx
  8024a4:	73 04                	jae    8024aa <print_mem_block_lists+0x114>
			sorted = 0 ;
  8024a6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 50 08             	mov    0x8(%eax),%edx
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b6:	01 c2                	add    %eax,%edx
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 40 08             	mov    0x8(%eax),%eax
  8024be:	83 ec 04             	sub    $0x4,%esp
  8024c1:	52                   	push   %edx
  8024c2:	50                   	push   %eax
  8024c3:	68 fd 3f 80 00       	push   $0x803ffd
  8024c8:	e8 a3 e5 ff ff       	call   800a70 <cprintf>
  8024cd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024d6:	a1 48 50 80 00       	mov    0x805048,%eax
  8024db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e2:	74 07                	je     8024eb <print_mem_block_lists+0x155>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	eb 05                	jmp    8024f0 <print_mem_block_lists+0x15a>
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f0:	a3 48 50 80 00       	mov    %eax,0x805048
  8024f5:	a1 48 50 80 00       	mov    0x805048,%eax
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	75 8a                	jne    802488 <print_mem_block_lists+0xf2>
  8024fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802502:	75 84                	jne    802488 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802504:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802508:	75 10                	jne    80251a <print_mem_block_lists+0x184>
  80250a:	83 ec 0c             	sub    $0xc,%esp
  80250d:	68 48 40 80 00       	push   $0x804048
  802512:	e8 59 e5 ff ff       	call   800a70 <cprintf>
  802517:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80251a:	83 ec 0c             	sub    $0xc,%esp
  80251d:	68 bc 3f 80 00       	push   $0x803fbc
  802522:	e8 49 e5 ff ff       	call   800a70 <cprintf>
  802527:	83 c4 10             	add    $0x10,%esp

}
  80252a:	90                   	nop
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802533:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80253a:	00 00 00 
  80253d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802544:	00 00 00 
  802547:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80254e:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802551:	a1 50 50 80 00       	mov    0x805050,%eax
  802556:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802560:	e9 9e 00 00 00       	jmp    802603 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802565:	a1 50 50 80 00       	mov    0x805050,%eax
  80256a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256d:	c1 e2 04             	shl    $0x4,%edx
  802570:	01 d0                	add    %edx,%eax
  802572:	85 c0                	test   %eax,%eax
  802574:	75 14                	jne    80258a <initialize_MemBlocksList+0x5d>
  802576:	83 ec 04             	sub    $0x4,%esp
  802579:	68 70 40 80 00       	push   $0x804070
  80257e:	6a 48                	push   $0x48
  802580:	68 93 40 80 00       	push   $0x804093
  802585:	e8 32 e2 ff ff       	call   8007bc <_panic>
  80258a:	a1 50 50 80 00       	mov    0x805050,%eax
  80258f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802592:	c1 e2 04             	shl    $0x4,%edx
  802595:	01 d0                	add    %edx,%eax
  802597:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80259d:	89 10                	mov    %edx,(%eax)
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	74 18                	je     8025bd <initialize_MemBlocksList+0x90>
  8025a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8025aa:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8025b0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025b3:	c1 e1 04             	shl    $0x4,%ecx
  8025b6:	01 ca                	add    %ecx,%edx
  8025b8:	89 50 04             	mov    %edx,0x4(%eax)
  8025bb:	eb 12                	jmp    8025cf <initialize_MemBlocksList+0xa2>
  8025bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8025c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c5:	c1 e2 04             	shl    $0x4,%edx
  8025c8:	01 d0                	add    %edx,%eax
  8025ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025cf:	a1 50 50 80 00       	mov    0x805050,%eax
  8025d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d7:	c1 e2 04             	shl    $0x4,%edx
  8025da:	01 d0                	add    %edx,%eax
  8025dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8025e1:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e9:	c1 e2 04             	shl    $0x4,%edx
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8025fa:	40                   	inc    %eax
  8025fb:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802600:	ff 45 f4             	incl   -0xc(%ebp)
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	3b 45 08             	cmp    0x8(%ebp),%eax
  802609:	0f 82 56 ff ff ff    	jb     802565 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80260f:	90                   	nop
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802620:	eb 18                	jmp    80263a <find_block+0x28>
		{
			if(tmp->sva==va)
  802622:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802625:	8b 40 08             	mov    0x8(%eax),%eax
  802628:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80262b:	75 05                	jne    802632 <find_block+0x20>
			{
				return tmp;
  80262d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802630:	eb 11                	jmp    802643 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802632:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  80263a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80263e:	75 e2                	jne    802622 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802640:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  80264b:	a1 40 50 80 00       	mov    0x805040,%eax
  802650:	85 c0                	test   %eax,%eax
  802652:	0f 85 83 00 00 00    	jne    8026db <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802658:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80265f:	00 00 00 
  802662:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802669:	00 00 00 
  80266c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802673:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802676:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267a:	75 14                	jne    802690 <insert_sorted_allocList+0x4b>
  80267c:	83 ec 04             	sub    $0x4,%esp
  80267f:	68 70 40 80 00       	push   $0x804070
  802684:	6a 7f                	push   $0x7f
  802686:	68 93 40 80 00       	push   $0x804093
  80268b:	e8 2c e1 ff ff       	call   8007bc <_panic>
  802690:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	89 10                	mov    %edx,(%eax)
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	74 0d                	je     8026b1 <insert_sorted_allocList+0x6c>
  8026a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8026a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ac:	89 50 04             	mov    %edx,0x4(%eax)
  8026af:	eb 08                	jmp    8026b9 <insert_sorted_allocList+0x74>
  8026b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b4:	a3 44 50 80 00       	mov    %eax,0x805044
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	a3 40 50 80 00       	mov    %eax,0x805040
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d0:	40                   	inc    %eax
  8026d1:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8026d6:	e9 16 01 00 00       	jmp    8027f1 <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	8b 50 08             	mov    0x8(%eax),%edx
  8026e1:	a1 44 50 80 00       	mov    0x805044,%eax
  8026e6:	8b 40 08             	mov    0x8(%eax),%eax
  8026e9:	39 c2                	cmp    %eax,%edx
  8026eb:	76 68                	jbe    802755 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8026ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026f1:	75 17                	jne    80270a <insert_sorted_allocList+0xc5>
  8026f3:	83 ec 04             	sub    $0x4,%esp
  8026f6:	68 ac 40 80 00       	push   $0x8040ac
  8026fb:	68 85 00 00 00       	push   $0x85
  802700:	68 93 40 80 00       	push   $0x804093
  802705:	e8 b2 e0 ff ff       	call   8007bc <_panic>
  80270a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	89 50 04             	mov    %edx,0x4(%eax)
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	8b 40 04             	mov    0x4(%eax),%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	74 0c                	je     80272c <insert_sorted_allocList+0xe7>
  802720:	a1 44 50 80 00       	mov    0x805044,%eax
  802725:	8b 55 08             	mov    0x8(%ebp),%edx
  802728:	89 10                	mov    %edx,(%eax)
  80272a:	eb 08                	jmp    802734 <insert_sorted_allocList+0xef>
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	a3 40 50 80 00       	mov    %eax,0x805040
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	a3 44 50 80 00       	mov    %eax,0x805044
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802745:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80274a:	40                   	inc    %eax
  80274b:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802750:	e9 9c 00 00 00       	jmp    8027f1 <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802755:	a1 40 50 80 00       	mov    0x805040,%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80275d:	e9 85 00 00 00       	jmp    8027e7 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802762:	8b 45 08             	mov    0x8(%ebp),%eax
  802765:	8b 50 08             	mov    0x8(%eax),%edx
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 08             	mov    0x8(%eax),%eax
  80276e:	39 c2                	cmp    %eax,%edx
  802770:	73 6d                	jae    8027df <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802776:	74 06                	je     80277e <insert_sorted_allocList+0x139>
  802778:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80277c:	75 17                	jne    802795 <insert_sorted_allocList+0x150>
  80277e:	83 ec 04             	sub    $0x4,%esp
  802781:	68 d0 40 80 00       	push   $0x8040d0
  802786:	68 90 00 00 00       	push   $0x90
  80278b:	68 93 40 80 00       	push   $0x804093
  802790:	e8 27 e0 ff ff       	call   8007bc <_panic>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 50 04             	mov    0x4(%eax),%edx
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	89 50 04             	mov    %edx,0x4(%eax)
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a7:	89 10                	mov    %edx,(%eax)
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 40 04             	mov    0x4(%eax),%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	74 0d                	je     8027c0 <insert_sorted_allocList+0x17b>
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bc:	89 10                	mov    %edx,(%eax)
  8027be:	eb 08                	jmp    8027c8 <insert_sorted_allocList+0x183>
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	a3 40 50 80 00       	mov    %eax,0x805040
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ce:	89 50 04             	mov    %edx,0x4(%eax)
  8027d1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027d6:	40                   	inc    %eax
  8027d7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027dc:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8027dd:	eb 12                	jmp    8027f1 <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	0f 85 71 ff ff ff    	jne    802762 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8027f1:	90                   	nop
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8027fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8027ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802802:	e9 76 01 00 00       	jmp    80297d <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 40 0c             	mov    0xc(%eax),%eax
  80280d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802810:	0f 85 8a 00 00 00    	jne    8028a0 <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281a:	75 17                	jne    802833 <alloc_block_FF+0x3f>
  80281c:	83 ec 04             	sub    $0x4,%esp
  80281f:	68 05 41 80 00       	push   $0x804105
  802824:	68 a8 00 00 00       	push   $0xa8
  802829:	68 93 40 80 00       	push   $0x804093
  80282e:	e8 89 df ff ff       	call   8007bc <_panic>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	74 10                	je     80284c <alloc_block_FF+0x58>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 00                	mov    (%eax),%eax
  802841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802844:	8b 52 04             	mov    0x4(%edx),%edx
  802847:	89 50 04             	mov    %edx,0x4(%eax)
  80284a:	eb 0b                	jmp    802857 <alloc_block_FF+0x63>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 40 04             	mov    0x4(%eax),%eax
  802852:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 04             	mov    0x4(%eax),%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 0f                	je     802870 <alloc_block_FF+0x7c>
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 40 04             	mov    0x4(%eax),%eax
  802867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286a:	8b 12                	mov    (%edx),%edx
  80286c:	89 10                	mov    %edx,(%eax)
  80286e:	eb 0a                	jmp    80287a <alloc_block_FF+0x86>
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 00                	mov    (%eax),%eax
  802875:	a3 38 51 80 00       	mov    %eax,0x805138
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288d:	a1 44 51 80 00       	mov    0x805144,%eax
  802892:	48                   	dec    %eax
  802893:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	e9 ea 00 00 00       	jmp    80298a <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a9:	0f 86 c6 00 00 00    	jbe    802975 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8028af:	a1 48 51 80 00       	mov    0x805148,%eax
  8028b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bd:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 50 08             	mov    0x8(%eax),%edx
  8028c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c9:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d5:	89 c2                	mov    %eax,%edx
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 50 08             	mov    0x8(%eax),%edx
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	01 c2                	add    %eax,%edx
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8028ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f2:	75 17                	jne    80290b <alloc_block_FF+0x117>
  8028f4:	83 ec 04             	sub    $0x4,%esp
  8028f7:	68 05 41 80 00       	push   $0x804105
  8028fc:	68 b6 00 00 00       	push   $0xb6
  802901:	68 93 40 80 00       	push   $0x804093
  802906:	e8 b1 de ff ff       	call   8007bc <_panic>
  80290b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	74 10                	je     802924 <alloc_block_FF+0x130>
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291c:	8b 52 04             	mov    0x4(%edx),%edx
  80291f:	89 50 04             	mov    %edx,0x4(%eax)
  802922:	eb 0b                	jmp    80292f <alloc_block_FF+0x13b>
  802924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	8b 40 04             	mov    0x4(%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	74 0f                	je     802948 <alloc_block_FF+0x154>
  802939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802942:	8b 12                	mov    (%edx),%edx
  802944:	89 10                	mov    %edx,(%eax)
  802946:	eb 0a                	jmp    802952 <alloc_block_FF+0x15e>
  802948:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	a3 48 51 80 00       	mov    %eax,0x805148
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802965:	a1 54 51 80 00       	mov    0x805154,%eax
  80296a:	48                   	dec    %eax
  80296b:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  802970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802973:	eb 15                	jmp    80298a <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80297d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802981:	0f 85 80 fe ff ff    	jne    802807 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802992:	a1 38 51 80 00       	mov    0x805138,%eax
  802997:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  80299a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  8029a1:	e9 c0 00 00 00       	jmp    802a66 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029af:	0f 85 8a 00 00 00    	jne    802a3f <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8029b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b9:	75 17                	jne    8029d2 <alloc_block_BF+0x46>
  8029bb:	83 ec 04             	sub    $0x4,%esp
  8029be:	68 05 41 80 00       	push   $0x804105
  8029c3:	68 cf 00 00 00       	push   $0xcf
  8029c8:	68 93 40 80 00       	push   $0x804093
  8029cd:	e8 ea dd ff ff       	call   8007bc <_panic>
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	74 10                	je     8029eb <alloc_block_BF+0x5f>
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e3:	8b 52 04             	mov    0x4(%edx),%edx
  8029e6:	89 50 04             	mov    %edx,0x4(%eax)
  8029e9:	eb 0b                	jmp    8029f6 <alloc_block_BF+0x6a>
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 40 04             	mov    0x4(%eax),%eax
  8029f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 40 04             	mov    0x4(%eax),%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	74 0f                	je     802a0f <alloc_block_BF+0x83>
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 40 04             	mov    0x4(%eax),%eax
  802a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a09:	8b 12                	mov    (%edx),%edx
  802a0b:	89 10                	mov    %edx,(%eax)
  802a0d:	eb 0a                	jmp    802a19 <alloc_block_BF+0x8d>
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	a3 38 51 80 00       	mov    %eax,0x805138
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2c:	a1 44 51 80 00       	mov    0x805144,%eax
  802a31:	48                   	dec    %eax
  802a32:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	e9 2a 01 00 00       	jmp    802b69 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 40 0c             	mov    0xc(%eax),%eax
  802a45:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a48:	73 14                	jae    802a5e <alloc_block_BF+0xd2>
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a53:	76 09                	jbe    802a5e <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	0f 85 36 ff ff ff    	jne    8029a6 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  802a70:	a1 38 51 80 00       	mov    0x805138,%eax
  802a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  802a78:	e9 dd 00 00 00       	jmp    802b5a <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 0c             	mov    0xc(%eax),%eax
  802a83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a86:	0f 85 c6 00 00 00    	jne    802b52 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802a8c:	a1 48 51 80 00       	mov    0x805148,%eax
  802a91:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 50 08             	mov    0x8(%eax),%edx
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  802aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa3:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa6:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 50 08             	mov    0x8(%eax),%edx
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	01 c2                	add    %eax,%edx
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac0:	2b 45 08             	sub    0x8(%ebp),%eax
  802ac3:	89 c2                	mov    %eax,%edx
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802acb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802acf:	75 17                	jne    802ae8 <alloc_block_BF+0x15c>
  802ad1:	83 ec 04             	sub    $0x4,%esp
  802ad4:	68 05 41 80 00       	push   $0x804105
  802ad9:	68 eb 00 00 00       	push   $0xeb
  802ade:	68 93 40 80 00       	push   $0x804093
  802ae3:	e8 d4 dc ff ff       	call   8007bc <_panic>
  802ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 10                	je     802b01 <alloc_block_BF+0x175>
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af9:	8b 52 04             	mov    0x4(%edx),%edx
  802afc:	89 50 04             	mov    %edx,0x4(%eax)
  802aff:	eb 0b                	jmp    802b0c <alloc_block_BF+0x180>
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	8b 40 04             	mov    0x4(%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	74 0f                	je     802b25 <alloc_block_BF+0x199>
  802b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b19:	8b 40 04             	mov    0x4(%eax),%eax
  802b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1f:	8b 12                	mov    (%edx),%edx
  802b21:	89 10                	mov    %edx,(%eax)
  802b23:	eb 0a                	jmp    802b2f <alloc_block_BF+0x1a3>
  802b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b42:	a1 54 51 80 00       	mov    0x805154,%eax
  802b47:	48                   	dec    %eax
  802b48:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  802b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b50:	eb 17                	jmp    802b69 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  802b5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5e:	0f 85 19 ff ff ff    	jne    802a7d <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  802b64:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
  802b6e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  802b71:	a1 40 50 80 00       	mov    0x805040,%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	75 19                	jne    802b93 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  802b7a:	83 ec 0c             	sub    $0xc,%esp
  802b7d:	ff 75 08             	pushl  0x8(%ebp)
  802b80:	e8 6f fc ff ff       	call   8027f4 <alloc_block_FF>
  802b85:	83 c4 10             	add    $0x10,%esp
  802b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	e9 e9 01 00 00       	jmp    802d7c <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  802b93:	a1 44 50 80 00       	mov    0x805044,%eax
  802b98:	8b 40 08             	mov    0x8(%eax),%eax
  802b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  802b9e:	a1 44 50 80 00       	mov    0x805044,%eax
  802ba3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba6:	a1 44 50 80 00       	mov    0x805044,%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	01 d0                	add    %edx,%eax
  802bb0:	83 ec 08             	sub    $0x8,%esp
  802bb3:	50                   	push   %eax
  802bb4:	68 38 51 80 00       	push   $0x805138
  802bb9:	e8 54 fa ff ff       	call   802612 <find_block>
  802bbe:	83 c4 10             	add    $0x10,%esp
  802bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bcd:	0f 85 9b 00 00 00    	jne    802c6e <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 08             	mov    0x8(%eax),%eax
  802bdf:	01 d0                	add    %edx,%eax
  802be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  802be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be8:	75 17                	jne    802c01 <alloc_block_NF+0x96>
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	68 05 41 80 00       	push   $0x804105
  802bf2:	68 1a 01 00 00       	push   $0x11a
  802bf7:	68 93 40 80 00       	push   $0x804093
  802bfc:	e8 bb db ff ff       	call   8007bc <_panic>
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 10                	je     802c1a <alloc_block_NF+0xaf>
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c12:	8b 52 04             	mov    0x4(%edx),%edx
  802c15:	89 50 04             	mov    %edx,0x4(%eax)
  802c18:	eb 0b                	jmp    802c25 <alloc_block_NF+0xba>
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 04             	mov    0x4(%eax),%eax
  802c20:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 40 04             	mov    0x4(%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 0f                	je     802c3e <alloc_block_NF+0xd3>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c38:	8b 12                	mov    (%edx),%edx
  802c3a:	89 10                	mov    %edx,(%eax)
  802c3c:	eb 0a                	jmp    802c48 <alloc_block_NF+0xdd>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	a3 38 51 80 00       	mov    %eax,0x805138
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c60:	48                   	dec    %eax
  802c61:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	e9 0e 01 00 00       	jmp    802d7c <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 40 0c             	mov    0xc(%eax),%eax
  802c74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c77:	0f 86 cf 00 00 00    	jbe    802d4c <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  802c7d:	a1 48 51 80 00       	mov    0x805148,%eax
  802c82:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  802c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c88:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8b:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 50 08             	mov    0x8(%eax),%edx
  802c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c97:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	01 c2                	add    %eax,%edx
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb1:	2b 45 08             	sub    0x8(%ebp),%eax
  802cb4:	89 c2                	mov    %eax,%edx
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 40 08             	mov    0x8(%eax),%eax
  802cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  802cc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cc9:	75 17                	jne    802ce2 <alloc_block_NF+0x177>
  802ccb:	83 ec 04             	sub    $0x4,%esp
  802cce:	68 05 41 80 00       	push   $0x804105
  802cd3:	68 28 01 00 00       	push   $0x128
  802cd8:	68 93 40 80 00       	push   $0x804093
  802cdd:	e8 da da ff ff       	call   8007bc <_panic>
  802ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	74 10                	je     802cfb <alloc_block_NF+0x190>
  802ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cf3:	8b 52 04             	mov    0x4(%edx),%edx
  802cf6:	89 50 04             	mov    %edx,0x4(%eax)
  802cf9:	eb 0b                	jmp    802d06 <alloc_block_NF+0x19b>
  802cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	74 0f                	je     802d1f <alloc_block_NF+0x1b4>
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d19:	8b 12                	mov    (%edx),%edx
  802d1b:	89 10                	mov    %edx,(%eax)
  802d1d:	eb 0a                	jmp    802d29 <alloc_block_NF+0x1be>
  802d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	a3 48 51 80 00       	mov    %eax,0x805148
  802d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d41:	48                   	dec    %eax
  802d42:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  802d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4a:	eb 30                	jmp    802d7c <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  802d4c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d54:	75 0a                	jne    802d60 <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  802d56:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5e:	eb 08                	jmp    802d68 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 00                	mov    (%eax),%eax
  802d65:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 40 08             	mov    0x8(%eax),%eax
  802d6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d71:	0f 85 4d fe ff ff    	jne    802bc4 <alloc_block_NF+0x59>

			return NULL;
  802d77:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  802d7c:	c9                   	leave  
  802d7d:	c3                   	ret    

00802d7e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d7e:	55                   	push   %ebp
  802d7f:	89 e5                	mov    %esp,%ebp
  802d81:	53                   	push   %ebx
  802d82:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  802d85:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	0f 85 86 00 00 00    	jne    802e18 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  802d92:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802d99:	00 00 00 
  802d9c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802da3:	00 00 00 
  802da6:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802dad:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802db0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db4:	75 17                	jne    802dcd <insert_sorted_with_merge_freeList+0x4f>
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	68 70 40 80 00       	push   $0x804070
  802dbe:	68 48 01 00 00       	push   $0x148
  802dc3:	68 93 40 80 00       	push   $0x804093
  802dc8:	e8 ef d9 ff ff       	call   8007bc <_panic>
  802dcd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	89 10                	mov    %edx,(%eax)
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0d                	je     802dee <insert_sorted_with_merge_freeList+0x70>
  802de1:	a1 38 51 80 00       	mov    0x805138,%eax
  802de6:	8b 55 08             	mov    0x8(%ebp),%edx
  802de9:	89 50 04             	mov    %edx,0x4(%eax)
  802dec:	eb 08                	jmp    802df6 <insert_sorted_with_merge_freeList+0x78>
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e08:	a1 44 51 80 00       	mov    0x805144,%eax
  802e0d:	40                   	inc    %eax
  802e0e:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  802e13:	e9 73 07 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 50 08             	mov    0x8(%eax),%edx
  802e1e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e23:	8b 40 08             	mov    0x8(%eax),%eax
  802e26:	39 c2                	cmp    %eax,%edx
  802e28:	0f 86 84 00 00 00    	jbe    802eb2 <insert_sorted_with_merge_freeList+0x134>
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 50 08             	mov    0x8(%eax),%edx
  802e34:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e39:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e3c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e41:	8b 40 08             	mov    0x8(%eax),%eax
  802e44:	01 c8                	add    %ecx,%eax
  802e46:	39 c2                	cmp    %eax,%edx
  802e48:	74 68                	je     802eb2 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  802e4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4e:	75 17                	jne    802e67 <insert_sorted_with_merge_freeList+0xe9>
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	68 ac 40 80 00       	push   $0x8040ac
  802e58:	68 4c 01 00 00       	push   $0x14c
  802e5d:	68 93 40 80 00       	push   $0x804093
  802e62:	e8 55 d9 ff ff       	call   8007bc <_panic>
  802e67:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	89 50 04             	mov    %edx,0x4(%eax)
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 40 04             	mov    0x4(%eax),%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 0c                	je     802e89 <insert_sorted_with_merge_freeList+0x10b>
  802e7d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e82:	8b 55 08             	mov    0x8(%ebp),%edx
  802e85:	89 10                	mov    %edx,(%eax)
  802e87:	eb 08                	jmp    802e91 <insert_sorted_with_merge_freeList+0x113>
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea7:	40                   	inc    %eax
  802ea8:	a3 44 51 80 00       	mov    %eax,0x805144
  802ead:	e9 d9 06 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	8b 50 08             	mov    0x8(%eax),%edx
  802eb8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ebd:	8b 40 08             	mov    0x8(%eax),%eax
  802ec0:	39 c2                	cmp    %eax,%edx
  802ec2:	0f 86 b5 00 00 00    	jbe    802f7d <insert_sorted_with_merge_freeList+0x1ff>
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	8b 50 08             	mov    0x8(%eax),%edx
  802ece:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ed3:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ed6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802edb:	8b 40 08             	mov    0x8(%eax),%eax
  802ede:	01 c8                	add    %ecx,%eax
  802ee0:	39 c2                	cmp    %eax,%edx
  802ee2:	0f 85 95 00 00 00    	jne    802f7d <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  802ee8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eed:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ef3:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef9:	8b 52 0c             	mov    0xc(%edx),%edx
  802efc:	01 ca                	add    %ecx,%edx
  802efe:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f19:	75 17                	jne    802f32 <insert_sorted_with_merge_freeList+0x1b4>
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 70 40 80 00       	push   $0x804070
  802f23:	68 54 01 00 00       	push   $0x154
  802f28:	68 93 40 80 00       	push   $0x804093
  802f2d:	e8 8a d8 ff ff       	call   8007bc <_panic>
  802f32:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	89 10                	mov    %edx,(%eax)
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	74 0d                	je     802f53 <insert_sorted_with_merge_freeList+0x1d5>
  802f46:	a1 48 51 80 00       	mov    0x805148,%eax
  802f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4e:	89 50 04             	mov    %edx,0x4(%eax)
  802f51:	eb 08                	jmp    802f5b <insert_sorted_with_merge_freeList+0x1dd>
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	a3 48 51 80 00       	mov    %eax,0x805148
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802f72:	40                   	inc    %eax
  802f73:	a3 54 51 80 00       	mov    %eax,0x805154
  802f78:	e9 0e 06 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 50 08             	mov    0x8(%eax),%edx
  802f83:	a1 38 51 80 00       	mov    0x805138,%eax
  802f88:	8b 40 08             	mov    0x8(%eax),%eax
  802f8b:	39 c2                	cmp    %eax,%edx
  802f8d:	0f 83 c1 00 00 00    	jae    803054 <insert_sorted_with_merge_freeList+0x2d6>
  802f93:	a1 38 51 80 00       	mov    0x805138,%eax
  802f98:	8b 50 08             	mov    0x8(%eax),%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 48 08             	mov    0x8(%eax),%ecx
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	01 c8                	add    %ecx,%eax
  802fa9:	39 c2                	cmp    %eax,%edx
  802fab:	0f 85 a3 00 00 00    	jne    803054 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802fb1:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb9:	8b 52 08             	mov    0x8(%edx),%edx
  802fbc:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  802fbf:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fca:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd0:	8b 52 0c             	mov    0xc(%edx),%edx
  802fd3:	01 ca                	add    %ecx,%edx
  802fd5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff0:	75 17                	jne    803009 <insert_sorted_with_merge_freeList+0x28b>
  802ff2:	83 ec 04             	sub    $0x4,%esp
  802ff5:	68 70 40 80 00       	push   $0x804070
  802ffa:	68 5d 01 00 00       	push   $0x15d
  802fff:	68 93 40 80 00       	push   $0x804093
  803004:	e8 b3 d7 ff ff       	call   8007bc <_panic>
  803009:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	89 10                	mov    %edx,(%eax)
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	85 c0                	test   %eax,%eax
  80301b:	74 0d                	je     80302a <insert_sorted_with_merge_freeList+0x2ac>
  80301d:	a1 48 51 80 00       	mov    0x805148,%eax
  803022:	8b 55 08             	mov    0x8(%ebp),%edx
  803025:	89 50 04             	mov    %edx,0x4(%eax)
  803028:	eb 08                	jmp    803032 <insert_sorted_with_merge_freeList+0x2b4>
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	a3 48 51 80 00       	mov    %eax,0x805148
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803044:	a1 54 51 80 00       	mov    0x805154,%eax
  803049:	40                   	inc    %eax
  80304a:	a3 54 51 80 00       	mov    %eax,0x805154
  80304f:	e9 37 05 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 50 08             	mov    0x8(%eax),%edx
  80305a:	a1 38 51 80 00       	mov    0x805138,%eax
  80305f:	8b 40 08             	mov    0x8(%eax),%eax
  803062:	39 c2                	cmp    %eax,%edx
  803064:	0f 83 82 00 00 00    	jae    8030ec <insert_sorted_with_merge_freeList+0x36e>
  80306a:	a1 38 51 80 00       	mov    0x805138,%eax
  80306f:	8b 50 08             	mov    0x8(%eax),%edx
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	8b 48 08             	mov    0x8(%eax),%ecx
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	8b 40 0c             	mov    0xc(%eax),%eax
  80307e:	01 c8                	add    %ecx,%eax
  803080:	39 c2                	cmp    %eax,%edx
  803082:	74 68                	je     8030ec <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803084:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803088:	75 17                	jne    8030a1 <insert_sorted_with_merge_freeList+0x323>
  80308a:	83 ec 04             	sub    $0x4,%esp
  80308d:	68 70 40 80 00       	push   $0x804070
  803092:	68 62 01 00 00       	push   $0x162
  803097:	68 93 40 80 00       	push   $0x804093
  80309c:	e8 1b d7 ff ff       	call   8007bc <_panic>
  8030a1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	89 10                	mov    %edx,(%eax)
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	74 0d                	je     8030c2 <insert_sorted_with_merge_freeList+0x344>
  8030b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bd:	89 50 04             	mov    %edx,0x4(%eax)
  8030c0:	eb 08                	jmp    8030ca <insert_sorted_with_merge_freeList+0x34c>
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e1:	40                   	inc    %eax
  8030e2:	a3 44 51 80 00       	mov    %eax,0x805144
  8030e7:	e9 9f 04 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  8030ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f1:	8b 00                	mov    (%eax),%eax
  8030f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8030f6:	e9 84 04 00 00       	jmp    80357f <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	8b 50 08             	mov    0x8(%eax),%edx
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	8b 40 08             	mov    0x8(%eax),%eax
  803107:	39 c2                	cmp    %eax,%edx
  803109:	0f 86 a9 00 00 00    	jbe    8031b8 <insert_sorted_with_merge_freeList+0x43a>
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 50 08             	mov    0x8(%eax),%edx
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	8b 48 08             	mov    0x8(%eax),%ecx
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	8b 40 0c             	mov    0xc(%eax),%eax
  803121:	01 c8                	add    %ecx,%eax
  803123:	39 c2                	cmp    %eax,%edx
  803125:	0f 84 8d 00 00 00    	je     8031b8 <insert_sorted_with_merge_freeList+0x43a>
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	8b 50 08             	mov    0x8(%eax),%edx
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 40 04             	mov    0x4(%eax),%eax
  803137:	8b 48 08             	mov    0x8(%eax),%ecx
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	8b 40 0c             	mov    0xc(%eax),%eax
  803143:	01 c8                	add    %ecx,%eax
  803145:	39 c2                	cmp    %eax,%edx
  803147:	74 6f                	je     8031b8 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803149:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314d:	74 06                	je     803155 <insert_sorted_with_merge_freeList+0x3d7>
  80314f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803153:	75 17                	jne    80316c <insert_sorted_with_merge_freeList+0x3ee>
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	68 d0 40 80 00       	push   $0x8040d0
  80315d:	68 6b 01 00 00       	push   $0x16b
  803162:	68 93 40 80 00       	push   $0x804093
  803167:	e8 50 d6 ff ff       	call   8007bc <_panic>
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	8b 50 04             	mov    0x4(%eax),%edx
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317e:	89 10                	mov    %edx,(%eax)
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 40 04             	mov    0x4(%eax),%eax
  803186:	85 c0                	test   %eax,%eax
  803188:	74 0d                	je     803197 <insert_sorted_with_merge_freeList+0x419>
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	8b 40 04             	mov    0x4(%eax),%eax
  803190:	8b 55 08             	mov    0x8(%ebp),%edx
  803193:	89 10                	mov    %edx,(%eax)
  803195:	eb 08                	jmp    80319f <insert_sorted_with_merge_freeList+0x421>
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	a3 38 51 80 00       	mov    %eax,0x805138
  80319f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a5:	89 50 04             	mov    %edx,0x4(%eax)
  8031a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ad:	40                   	inc    %eax
  8031ae:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  8031b3:	e9 d3 03 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	8b 50 08             	mov    0x8(%eax),%edx
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	8b 40 08             	mov    0x8(%eax),%eax
  8031c4:	39 c2                	cmp    %eax,%edx
  8031c6:	0f 86 da 00 00 00    	jbe    8032a6 <insert_sorted_with_merge_freeList+0x528>
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 50 08             	mov    0x8(%eax),%edx
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 48 08             	mov    0x8(%eax),%ecx
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	8b 40 0c             	mov    0xc(%eax),%eax
  8031de:	01 c8                	add    %ecx,%eax
  8031e0:	39 c2                	cmp    %eax,%edx
  8031e2:	0f 85 be 00 00 00    	jne    8032a6 <insert_sorted_with_merge_freeList+0x528>
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 40 04             	mov    0x4(%eax),%eax
  8031f4:	8b 48 08             	mov    0x8(%eax),%ecx
  8031f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fa:	8b 40 04             	mov    0x4(%eax),%eax
  8031fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803200:	01 c8                	add    %ecx,%eax
  803202:	39 c2                	cmp    %eax,%edx
  803204:	0f 84 9c 00 00 00    	je     8032a6 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	8b 50 08             	mov    0x8(%eax),%edx
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	8b 50 0c             	mov    0xc(%eax),%edx
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	8b 40 0c             	mov    0xc(%eax),%eax
  803222:	01 c2                	add    %eax,%edx
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80323e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803242:	75 17                	jne    80325b <insert_sorted_with_merge_freeList+0x4dd>
  803244:	83 ec 04             	sub    $0x4,%esp
  803247:	68 70 40 80 00       	push   $0x804070
  80324c:	68 74 01 00 00       	push   $0x174
  803251:	68 93 40 80 00       	push   $0x804093
  803256:	e8 61 d5 ff ff       	call   8007bc <_panic>
  80325b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	89 10                	mov    %edx,(%eax)
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 0d                	je     80327c <insert_sorted_with_merge_freeList+0x4fe>
  80326f:	a1 48 51 80 00       	mov    0x805148,%eax
  803274:	8b 55 08             	mov    0x8(%ebp),%edx
  803277:	89 50 04             	mov    %edx,0x4(%eax)
  80327a:	eb 08                	jmp    803284 <insert_sorted_with_merge_freeList+0x506>
  80327c:	8b 45 08             	mov    0x8(%ebp),%eax
  80327f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	a3 48 51 80 00       	mov    %eax,0x805148
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803296:	a1 54 51 80 00       	mov    0x805154,%eax
  80329b:	40                   	inc    %eax
  80329c:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  8032a1:	e9 e5 02 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 50 08             	mov    0x8(%eax),%edx
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	8b 40 08             	mov    0x8(%eax),%eax
  8032b2:	39 c2                	cmp    %eax,%edx
  8032b4:	0f 86 d7 00 00 00    	jbe    803391 <insert_sorted_with_merge_freeList+0x613>
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 50 08             	mov    0x8(%eax),%edx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	8b 48 08             	mov    0x8(%eax),%ecx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032cc:	01 c8                	add    %ecx,%eax
  8032ce:	39 c2                	cmp    %eax,%edx
  8032d0:	0f 84 bb 00 00 00    	je     803391 <insert_sorted_with_merge_freeList+0x613>
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	8b 50 08             	mov    0x8(%eax),%edx
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	8b 40 04             	mov    0x4(%eax),%eax
  8032e2:	8b 48 08             	mov    0x8(%eax),%ecx
  8032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e8:	8b 40 04             	mov    0x4(%eax),%eax
  8032eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ee:	01 c8                	add    %ecx,%eax
  8032f0:	39 c2                	cmp    %eax,%edx
  8032f2:	0f 85 99 00 00 00    	jne    803391 <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  8032f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fb:	8b 40 04             	mov    0x4(%eax),%eax
  8032fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803304:	8b 50 0c             	mov    0xc(%eax),%edx
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	8b 40 0c             	mov    0xc(%eax),%eax
  80330d:	01 c2                	add    %eax,%edx
  80330f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803312:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803329:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332d:	75 17                	jne    803346 <insert_sorted_with_merge_freeList+0x5c8>
  80332f:	83 ec 04             	sub    $0x4,%esp
  803332:	68 70 40 80 00       	push   $0x804070
  803337:	68 7d 01 00 00       	push   $0x17d
  80333c:	68 93 40 80 00       	push   $0x804093
  803341:	e8 76 d4 ff ff       	call   8007bc <_panic>
  803346:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	8b 00                	mov    (%eax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 0d                	je     803367 <insert_sorted_with_merge_freeList+0x5e9>
  80335a:	a1 48 51 80 00       	mov    0x805148,%eax
  80335f:	8b 55 08             	mov    0x8(%ebp),%edx
  803362:	89 50 04             	mov    %edx,0x4(%eax)
  803365:	eb 08                	jmp    80336f <insert_sorted_with_merge_freeList+0x5f1>
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	a3 48 51 80 00       	mov    %eax,0x805148
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803381:	a1 54 51 80 00       	mov    0x805154,%eax
  803386:	40                   	inc    %eax
  803387:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  80338c:	e9 fa 01 00 00       	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	8b 50 08             	mov    0x8(%eax),%edx
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	8b 40 08             	mov    0x8(%eax),%eax
  80339d:	39 c2                	cmp    %eax,%edx
  80339f:	0f 86 d2 01 00 00    	jbe    803577 <insert_sorted_with_merge_freeList+0x7f9>
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 50 08             	mov    0x8(%eax),%edx
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b7:	01 c8                	add    %ecx,%eax
  8033b9:	39 c2                	cmp    %eax,%edx
  8033bb:	0f 85 b6 01 00 00    	jne    803577 <insert_sorted_with_merge_freeList+0x7f9>
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	8b 50 08             	mov    0x8(%eax),%edx
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 40 04             	mov    0x4(%eax),%eax
  8033cd:	8b 48 08             	mov    0x8(%eax),%ecx
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	8b 40 04             	mov    0x4(%eax),%eax
  8033d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d9:	01 c8                	add    %ecx,%eax
  8033db:	39 c2                	cmp    %eax,%edx
  8033dd:	0f 85 94 01 00 00    	jne    803577 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  8033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e6:	8b 40 04             	mov    0x4(%eax),%eax
  8033e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ec:	8b 52 04             	mov    0x4(%edx),%edx
  8033ef:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8033f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f5:	8b 5a 0c             	mov    0xc(%edx),%ebx
  8033f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8033fe:	01 da                	add    %ebx,%edx
  803400:	01 ca                	add    %ecx,%edx
  803402:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341d:	75 17                	jne    803436 <insert_sorted_with_merge_freeList+0x6b8>
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	68 05 41 80 00       	push   $0x804105
  803427:	68 86 01 00 00       	push   $0x186
  80342c:	68 93 40 80 00       	push   $0x804093
  803431:	e8 86 d3 ff ff       	call   8007bc <_panic>
  803436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	85 c0                	test   %eax,%eax
  80343d:	74 10                	je     80344f <insert_sorted_with_merge_freeList+0x6d1>
  80343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803447:	8b 52 04             	mov    0x4(%edx),%edx
  80344a:	89 50 04             	mov    %edx,0x4(%eax)
  80344d:	eb 0b                	jmp    80345a <insert_sorted_with_merge_freeList+0x6dc>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 40 04             	mov    0x4(%eax),%eax
  803455:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 40 04             	mov    0x4(%eax),%eax
  803460:	85 c0                	test   %eax,%eax
  803462:	74 0f                	je     803473 <insert_sorted_with_merge_freeList+0x6f5>
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 40 04             	mov    0x4(%eax),%eax
  80346a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80346d:	8b 12                	mov    (%edx),%edx
  80346f:	89 10                	mov    %edx,(%eax)
  803471:	eb 0a                	jmp    80347d <insert_sorted_with_merge_freeList+0x6ff>
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	a3 38 51 80 00       	mov    %eax,0x805138
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803490:	a1 44 51 80 00       	mov    0x805144,%eax
  803495:	48                   	dec    %eax
  803496:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  80349b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349f:	75 17                	jne    8034b8 <insert_sorted_with_merge_freeList+0x73a>
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	68 70 40 80 00       	push   $0x804070
  8034a9:	68 87 01 00 00       	push   $0x187
  8034ae:	68 93 40 80 00       	push   $0x804093
  8034b3:	e8 04 d3 ff ff       	call   8007bc <_panic>
  8034b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c1:	89 10                	mov    %edx,(%eax)
  8034c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c6:	8b 00                	mov    (%eax),%eax
  8034c8:	85 c0                	test   %eax,%eax
  8034ca:	74 0d                	je     8034d9 <insert_sorted_with_merge_freeList+0x75b>
  8034cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8034d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d4:	89 50 04             	mov    %edx,0x4(%eax)
  8034d7:	eb 08                	jmp    8034e1 <insert_sorted_with_merge_freeList+0x763>
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e4:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8034f8:	40                   	inc    %eax
  8034f9:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803512:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803516:	75 17                	jne    80352f <insert_sorted_with_merge_freeList+0x7b1>
  803518:	83 ec 04             	sub    $0x4,%esp
  80351b:	68 70 40 80 00       	push   $0x804070
  803520:	68 8a 01 00 00       	push   $0x18a
  803525:	68 93 40 80 00       	push   $0x804093
  80352a:	e8 8d d2 ff ff       	call   8007bc <_panic>
  80352f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	89 10                	mov    %edx,(%eax)
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	8b 00                	mov    (%eax),%eax
  80353f:	85 c0                	test   %eax,%eax
  803541:	74 0d                	je     803550 <insert_sorted_with_merge_freeList+0x7d2>
  803543:	a1 48 51 80 00       	mov    0x805148,%eax
  803548:	8b 55 08             	mov    0x8(%ebp),%edx
  80354b:	89 50 04             	mov    %edx,0x4(%eax)
  80354e:	eb 08                	jmp    803558 <insert_sorted_with_merge_freeList+0x7da>
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	a3 48 51 80 00       	mov    %eax,0x805148
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80356a:	a1 54 51 80 00       	mov    0x805154,%eax
  80356f:	40                   	inc    %eax
  803570:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803575:	eb 14                	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80357f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803583:	0f 85 72 fb ff ff    	jne    8030fb <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803589:	eb 00                	jmp    80358b <insert_sorted_with_merge_freeList+0x80d>
  80358b:	90                   	nop
  80358c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80358f:	c9                   	leave  
  803590:	c3                   	ret    
  803591:	66 90                	xchg   %ax,%ax
  803593:	90                   	nop

00803594 <__udivdi3>:
  803594:	55                   	push   %ebp
  803595:	57                   	push   %edi
  803596:	56                   	push   %esi
  803597:	53                   	push   %ebx
  803598:	83 ec 1c             	sub    $0x1c,%esp
  80359b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80359f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035ab:	89 ca                	mov    %ecx,%edx
  8035ad:	89 f8                	mov    %edi,%eax
  8035af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035b3:	85 f6                	test   %esi,%esi
  8035b5:	75 2d                	jne    8035e4 <__udivdi3+0x50>
  8035b7:	39 cf                	cmp    %ecx,%edi
  8035b9:	77 65                	ja     803620 <__udivdi3+0x8c>
  8035bb:	89 fd                	mov    %edi,%ebp
  8035bd:	85 ff                	test   %edi,%edi
  8035bf:	75 0b                	jne    8035cc <__udivdi3+0x38>
  8035c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8035c6:	31 d2                	xor    %edx,%edx
  8035c8:	f7 f7                	div    %edi
  8035ca:	89 c5                	mov    %eax,%ebp
  8035cc:	31 d2                	xor    %edx,%edx
  8035ce:	89 c8                	mov    %ecx,%eax
  8035d0:	f7 f5                	div    %ebp
  8035d2:	89 c1                	mov    %eax,%ecx
  8035d4:	89 d8                	mov    %ebx,%eax
  8035d6:	f7 f5                	div    %ebp
  8035d8:	89 cf                	mov    %ecx,%edi
  8035da:	89 fa                	mov    %edi,%edx
  8035dc:	83 c4 1c             	add    $0x1c,%esp
  8035df:	5b                   	pop    %ebx
  8035e0:	5e                   	pop    %esi
  8035e1:	5f                   	pop    %edi
  8035e2:	5d                   	pop    %ebp
  8035e3:	c3                   	ret    
  8035e4:	39 ce                	cmp    %ecx,%esi
  8035e6:	77 28                	ja     803610 <__udivdi3+0x7c>
  8035e8:	0f bd fe             	bsr    %esi,%edi
  8035eb:	83 f7 1f             	xor    $0x1f,%edi
  8035ee:	75 40                	jne    803630 <__udivdi3+0x9c>
  8035f0:	39 ce                	cmp    %ecx,%esi
  8035f2:	72 0a                	jb     8035fe <__udivdi3+0x6a>
  8035f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035f8:	0f 87 9e 00 00 00    	ja     80369c <__udivdi3+0x108>
  8035fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803603:	89 fa                	mov    %edi,%edx
  803605:	83 c4 1c             	add    $0x1c,%esp
  803608:	5b                   	pop    %ebx
  803609:	5e                   	pop    %esi
  80360a:	5f                   	pop    %edi
  80360b:	5d                   	pop    %ebp
  80360c:	c3                   	ret    
  80360d:	8d 76 00             	lea    0x0(%esi),%esi
  803610:	31 ff                	xor    %edi,%edi
  803612:	31 c0                	xor    %eax,%eax
  803614:	89 fa                	mov    %edi,%edx
  803616:	83 c4 1c             	add    $0x1c,%esp
  803619:	5b                   	pop    %ebx
  80361a:	5e                   	pop    %esi
  80361b:	5f                   	pop    %edi
  80361c:	5d                   	pop    %ebp
  80361d:	c3                   	ret    
  80361e:	66 90                	xchg   %ax,%ax
  803620:	89 d8                	mov    %ebx,%eax
  803622:	f7 f7                	div    %edi
  803624:	31 ff                	xor    %edi,%edi
  803626:	89 fa                	mov    %edi,%edx
  803628:	83 c4 1c             	add    $0x1c,%esp
  80362b:	5b                   	pop    %ebx
  80362c:	5e                   	pop    %esi
  80362d:	5f                   	pop    %edi
  80362e:	5d                   	pop    %ebp
  80362f:	c3                   	ret    
  803630:	bd 20 00 00 00       	mov    $0x20,%ebp
  803635:	89 eb                	mov    %ebp,%ebx
  803637:	29 fb                	sub    %edi,%ebx
  803639:	89 f9                	mov    %edi,%ecx
  80363b:	d3 e6                	shl    %cl,%esi
  80363d:	89 c5                	mov    %eax,%ebp
  80363f:	88 d9                	mov    %bl,%cl
  803641:	d3 ed                	shr    %cl,%ebp
  803643:	89 e9                	mov    %ebp,%ecx
  803645:	09 f1                	or     %esi,%ecx
  803647:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80364b:	89 f9                	mov    %edi,%ecx
  80364d:	d3 e0                	shl    %cl,%eax
  80364f:	89 c5                	mov    %eax,%ebp
  803651:	89 d6                	mov    %edx,%esi
  803653:	88 d9                	mov    %bl,%cl
  803655:	d3 ee                	shr    %cl,%esi
  803657:	89 f9                	mov    %edi,%ecx
  803659:	d3 e2                	shl    %cl,%edx
  80365b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80365f:	88 d9                	mov    %bl,%cl
  803661:	d3 e8                	shr    %cl,%eax
  803663:	09 c2                	or     %eax,%edx
  803665:	89 d0                	mov    %edx,%eax
  803667:	89 f2                	mov    %esi,%edx
  803669:	f7 74 24 0c          	divl   0xc(%esp)
  80366d:	89 d6                	mov    %edx,%esi
  80366f:	89 c3                	mov    %eax,%ebx
  803671:	f7 e5                	mul    %ebp
  803673:	39 d6                	cmp    %edx,%esi
  803675:	72 19                	jb     803690 <__udivdi3+0xfc>
  803677:	74 0b                	je     803684 <__udivdi3+0xf0>
  803679:	89 d8                	mov    %ebx,%eax
  80367b:	31 ff                	xor    %edi,%edi
  80367d:	e9 58 ff ff ff       	jmp    8035da <__udivdi3+0x46>
  803682:	66 90                	xchg   %ax,%ax
  803684:	8b 54 24 08          	mov    0x8(%esp),%edx
  803688:	89 f9                	mov    %edi,%ecx
  80368a:	d3 e2                	shl    %cl,%edx
  80368c:	39 c2                	cmp    %eax,%edx
  80368e:	73 e9                	jae    803679 <__udivdi3+0xe5>
  803690:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803693:	31 ff                	xor    %edi,%edi
  803695:	e9 40 ff ff ff       	jmp    8035da <__udivdi3+0x46>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	31 c0                	xor    %eax,%eax
  80369e:	e9 37 ff ff ff       	jmp    8035da <__udivdi3+0x46>
  8036a3:	90                   	nop

008036a4 <__umoddi3>:
  8036a4:	55                   	push   %ebp
  8036a5:	57                   	push   %edi
  8036a6:	56                   	push   %esi
  8036a7:	53                   	push   %ebx
  8036a8:	83 ec 1c             	sub    $0x1c,%esp
  8036ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036c3:	89 f3                	mov    %esi,%ebx
  8036c5:	89 fa                	mov    %edi,%edx
  8036c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036cb:	89 34 24             	mov    %esi,(%esp)
  8036ce:	85 c0                	test   %eax,%eax
  8036d0:	75 1a                	jne    8036ec <__umoddi3+0x48>
  8036d2:	39 f7                	cmp    %esi,%edi
  8036d4:	0f 86 a2 00 00 00    	jbe    80377c <__umoddi3+0xd8>
  8036da:	89 c8                	mov    %ecx,%eax
  8036dc:	89 f2                	mov    %esi,%edx
  8036de:	f7 f7                	div    %edi
  8036e0:	89 d0                	mov    %edx,%eax
  8036e2:	31 d2                	xor    %edx,%edx
  8036e4:	83 c4 1c             	add    $0x1c,%esp
  8036e7:	5b                   	pop    %ebx
  8036e8:	5e                   	pop    %esi
  8036e9:	5f                   	pop    %edi
  8036ea:	5d                   	pop    %ebp
  8036eb:	c3                   	ret    
  8036ec:	39 f0                	cmp    %esi,%eax
  8036ee:	0f 87 ac 00 00 00    	ja     8037a0 <__umoddi3+0xfc>
  8036f4:	0f bd e8             	bsr    %eax,%ebp
  8036f7:	83 f5 1f             	xor    $0x1f,%ebp
  8036fa:	0f 84 ac 00 00 00    	je     8037ac <__umoddi3+0x108>
  803700:	bf 20 00 00 00       	mov    $0x20,%edi
  803705:	29 ef                	sub    %ebp,%edi
  803707:	89 fe                	mov    %edi,%esi
  803709:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80370d:	89 e9                	mov    %ebp,%ecx
  80370f:	d3 e0                	shl    %cl,%eax
  803711:	89 d7                	mov    %edx,%edi
  803713:	89 f1                	mov    %esi,%ecx
  803715:	d3 ef                	shr    %cl,%edi
  803717:	09 c7                	or     %eax,%edi
  803719:	89 e9                	mov    %ebp,%ecx
  80371b:	d3 e2                	shl    %cl,%edx
  80371d:	89 14 24             	mov    %edx,(%esp)
  803720:	89 d8                	mov    %ebx,%eax
  803722:	d3 e0                	shl    %cl,%eax
  803724:	89 c2                	mov    %eax,%edx
  803726:	8b 44 24 08          	mov    0x8(%esp),%eax
  80372a:	d3 e0                	shl    %cl,%eax
  80372c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803730:	8b 44 24 08          	mov    0x8(%esp),%eax
  803734:	89 f1                	mov    %esi,%ecx
  803736:	d3 e8                	shr    %cl,%eax
  803738:	09 d0                	or     %edx,%eax
  80373a:	d3 eb                	shr    %cl,%ebx
  80373c:	89 da                	mov    %ebx,%edx
  80373e:	f7 f7                	div    %edi
  803740:	89 d3                	mov    %edx,%ebx
  803742:	f7 24 24             	mull   (%esp)
  803745:	89 c6                	mov    %eax,%esi
  803747:	89 d1                	mov    %edx,%ecx
  803749:	39 d3                	cmp    %edx,%ebx
  80374b:	0f 82 87 00 00 00    	jb     8037d8 <__umoddi3+0x134>
  803751:	0f 84 91 00 00 00    	je     8037e8 <__umoddi3+0x144>
  803757:	8b 54 24 04          	mov    0x4(%esp),%edx
  80375b:	29 f2                	sub    %esi,%edx
  80375d:	19 cb                	sbb    %ecx,%ebx
  80375f:	89 d8                	mov    %ebx,%eax
  803761:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803765:	d3 e0                	shl    %cl,%eax
  803767:	89 e9                	mov    %ebp,%ecx
  803769:	d3 ea                	shr    %cl,%edx
  80376b:	09 d0                	or     %edx,%eax
  80376d:	89 e9                	mov    %ebp,%ecx
  80376f:	d3 eb                	shr    %cl,%ebx
  803771:	89 da                	mov    %ebx,%edx
  803773:	83 c4 1c             	add    $0x1c,%esp
  803776:	5b                   	pop    %ebx
  803777:	5e                   	pop    %esi
  803778:	5f                   	pop    %edi
  803779:	5d                   	pop    %ebp
  80377a:	c3                   	ret    
  80377b:	90                   	nop
  80377c:	89 fd                	mov    %edi,%ebp
  80377e:	85 ff                	test   %edi,%edi
  803780:	75 0b                	jne    80378d <__umoddi3+0xe9>
  803782:	b8 01 00 00 00       	mov    $0x1,%eax
  803787:	31 d2                	xor    %edx,%edx
  803789:	f7 f7                	div    %edi
  80378b:	89 c5                	mov    %eax,%ebp
  80378d:	89 f0                	mov    %esi,%eax
  80378f:	31 d2                	xor    %edx,%edx
  803791:	f7 f5                	div    %ebp
  803793:	89 c8                	mov    %ecx,%eax
  803795:	f7 f5                	div    %ebp
  803797:	89 d0                	mov    %edx,%eax
  803799:	e9 44 ff ff ff       	jmp    8036e2 <__umoddi3+0x3e>
  80379e:	66 90                	xchg   %ax,%ax
  8037a0:	89 c8                	mov    %ecx,%eax
  8037a2:	89 f2                	mov    %esi,%edx
  8037a4:	83 c4 1c             	add    $0x1c,%esp
  8037a7:	5b                   	pop    %ebx
  8037a8:	5e                   	pop    %esi
  8037a9:	5f                   	pop    %edi
  8037aa:	5d                   	pop    %ebp
  8037ab:	c3                   	ret    
  8037ac:	3b 04 24             	cmp    (%esp),%eax
  8037af:	72 06                	jb     8037b7 <__umoddi3+0x113>
  8037b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037b5:	77 0f                	ja     8037c6 <__umoddi3+0x122>
  8037b7:	89 f2                	mov    %esi,%edx
  8037b9:	29 f9                	sub    %edi,%ecx
  8037bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037bf:	89 14 24             	mov    %edx,(%esp)
  8037c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037ca:	8b 14 24             	mov    (%esp),%edx
  8037cd:	83 c4 1c             	add    $0x1c,%esp
  8037d0:	5b                   	pop    %ebx
  8037d1:	5e                   	pop    %esi
  8037d2:	5f                   	pop    %edi
  8037d3:	5d                   	pop    %ebp
  8037d4:	c3                   	ret    
  8037d5:	8d 76 00             	lea    0x0(%esi),%esi
  8037d8:	2b 04 24             	sub    (%esp),%eax
  8037db:	19 fa                	sbb    %edi,%edx
  8037dd:	89 d1                	mov    %edx,%ecx
  8037df:	89 c6                	mov    %eax,%esi
  8037e1:	e9 71 ff ff ff       	jmp    803757 <__umoddi3+0xb3>
  8037e6:	66 90                	xchg   %ax,%ax
  8037e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037ec:	72 ea                	jb     8037d8 <__umoddi3+0x134>
  8037ee:	89 d9                	mov    %ebx,%ecx
  8037f0:	e9 62 ff ff ff       	jmp    803757 <__umoddi3+0xb3>
