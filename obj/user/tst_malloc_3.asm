
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 f6 0d 00 00       	call   800e2c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 50 80 00       	mov    0x805020,%eax
  800055:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 50 80 00       	mov    0x805020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 c0 3f 80 00       	push   $0x803fc0
  800096:	6a 1a                	push   $0x1a
  800098:	68 dc 3f 80 00       	push   $0x803fdc
  80009d:	e8 c6 0e 00 00       	call   800f68 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 c0 20 00 00       	call   80216c <malloc>
  8000ac:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000af:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b6:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000bd:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c1:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c5:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000cb:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d1:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d8:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 ec 24 00 00       	call   8025d0 <sys_calculate_free_frames>
  8000e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 70 25 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 58 20 00 00       	call   80216c <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 f0 3f 80 00       	push   $0x803ff0
  80013c:	6a 39                	push   $0x39
  80013e:	68 dc 3f 80 00       	push   $0x803fdc
  800143:	e8 20 0e 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 23 25 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 58 40 80 00       	push   $0x804058
  80015a:	6a 3a                	push   $0x3a
  80015c:	68 dc 3f 80 00       	push   $0x803fdc
  800161:	e8 02 0e 00 00       	call   800f68 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 65 24 00 00       	call   8025d0 <sys_calculate_free_frames>
  80016b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800180:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800186:	8a 55 df             	mov    -0x21(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80018e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 de             	mov    -0x22(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019b:	e8 30 24 00 00       	call   8025d0 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 88 40 80 00       	push   $0x804088
  8001b1:	6a 41                	push   $0x41
  8001b3:	68 dc 3f 80 00       	push   $0x803fdc
  8001b8:	e8 ab 0d 00 00       	call   800f68 <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800238:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800240:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800248:	39 c1                	cmp    %eax,%ecx
  80024a:	75 03                	jne    80024f <_main+0x217>
				found++;
  80024c:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80024f:	ff 45 ec             	incl   -0x14(%ebp)
  800252:	a1 20 50 80 00       	mov    0x805020,%eax
  800257:	8b 50 74             	mov    0x74(%eax),%edx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	0f 87 6b ff ff ff    	ja     8001d0 <_main+0x198>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800265:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800269:	74 14                	je     80027f <_main+0x247>
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	68 cc 40 80 00       	push   $0x8040cc
  800273:	6a 4b                	push   $0x4b
  800275:	68 dc 3f 80 00       	push   $0x803fdc
  80027a:	e8 e9 0c 00 00       	call   800f68 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 ec 23 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 d4 1e 00 00       	call   80216c <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 f0 3f 80 00       	push   $0x803ff0
  8002d5:	6a 50                	push   $0x50
  8002d7:	68 dc 3f 80 00       	push   $0x803fdc
  8002dc:	e8 87 0c 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 8a 23 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 58 40 80 00       	push   $0x804058
  8002f3:	6a 51                	push   $0x51
  8002f5:	68 dc 3f 80 00       	push   $0x803fdc
  8002fa:	e8 69 0c 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 cc 22 00 00       	call   8025d0 <sys_calculate_free_frames>
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80030d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80033d:	e8 8e 22 00 00       	call   8025d0 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 88 40 80 00       	push   $0x804088
  800353:	6a 58                	push   $0x58
  800355:	68 dc 3f 80 00       	push   $0x803fdc
  80035a:	e8 09 0c 00 00       	call   800f68 <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800390:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80039d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003cd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003e6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 03                	jne    8003f5 <_main+0x3bd>
				found++;
  8003f2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003f5:	ff 45 ec             	incl   -0x14(%ebp)
  8003f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fd:	8b 50 74             	mov    0x74(%eax),%edx
  800400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	0f 87 67 ff ff ff    	ja     800372 <_main+0x33a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80040b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 cc 40 80 00       	push   $0x8040cc
  800419:	6a 61                	push   $0x61
  80041b:	68 dc 3f 80 00       	push   $0x803fdc
  800420:	e8 43 0b 00 00       	call   800f68 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 46 22 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  80042d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800430:	89 c2                	mov    %eax,%edx
  800432:	01 d2                	add    %edx,%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	50                   	push   %eax
  80043a:	e8 2d 1d 00 00       	call   80216c <malloc>
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800448:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80044e:	89 c2                	mov    %eax,%edx
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	c1 e0 02             	shl    $0x2,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 17                	jb     800476 <_main+0x43e>
  80045f:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800465:	89 c2                	mov    %eax,%edx
  800467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046a:	c1 e0 02             	shl    $0x2,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 f0 3f 80 00       	push   $0x803ff0
  80047e:	6a 66                	push   $0x66
  800480:	68 dc 3f 80 00       	push   $0x803fdc
  800485:	e8 de 0a 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80048a:	e8 e1 21 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  80048f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 58 40 80 00       	push   $0x804058
  80049c:	6a 67                	push   $0x67
  80049e:	68 dc 3f 80 00       	push   $0x803fdc
  8004a3:	e8 c0 0a 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 23 21 00 00       	call   8025d0 <sys_calculate_free_frames>
  8004ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b0:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004b6:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	01 c0                	add    %eax,%eax
  8004be:	c1 e8 02             	shr    $0x2,%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004c5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004cb:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004cd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004da:	01 c2                	add    %eax,%edx
  8004dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004df:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004e1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004e4:	e8 e7 20 00 00       	call   8025d0 <sys_calculate_free_frames>
  8004e9:	29 c3                	sub    %eax,%ebx
  8004eb:	89 d8                	mov    %ebx,%eax
  8004ed:	83 f8 02             	cmp    $0x2,%eax
  8004f0:	74 14                	je     800506 <_main+0x4ce>
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	68 88 40 80 00       	push   $0x804088
  8004fa:	6a 6e                	push   $0x6e
  8004fc:	68 dc 3f 80 00       	push   $0x803fdc
  800501:	e8 62 0a 00 00       	call   800f68 <_panic>
		found = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80050d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800514:	e9 8f 00 00 00       	jmp    8005a8 <_main+0x570>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800524:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	01 c0                	add    %eax,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 03             	shl    $0x3,%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	89 45 88             	mov    %eax,-0x78(%ebp)
  800537:	8b 45 88             	mov    -0x78(%ebp),%eax
  80053a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053f:	89 c2                	mov    %eax,%edx
  800541:	8b 45 90             	mov    -0x70(%ebp),%eax
  800544:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800547:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80054a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	75 03                	jne    800556 <_main+0x51e>
				found++;
  800553:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	c1 e0 03             	shl    $0x3,%eax
  80056d:	01 c8                	add    %ecx,%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
  800574:	8b 45 80             	mov    -0x80(%ebp),%eax
  800577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057c:	89 c2                	mov    %eax,%edx
  80057e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 90             	mov    -0x70(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800593:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 03                	jne    8005a5 <_main+0x56d>
				found++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a5:	ff 45 ec             	incl   -0x14(%ebp)
  8005a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ad:	8b 50 74             	mov    0x74(%eax),%edx
  8005b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	0f 87 5e ff ff ff    	ja     800519 <_main+0x4e1>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bb:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005bf:	74 14                	je     8005d5 <_main+0x59d>
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	68 cc 40 80 00       	push   $0x8040cc
  8005c9:	6a 77                	push   $0x77
  8005cb:	68 dc 3f 80 00       	push   $0x803fdc
  8005d0:	e8 93 09 00 00       	call   800f68 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d5:	e8 f6 1f 00 00       	call   8025d0 <sys_calculate_free_frames>
  8005da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005dd:	e8 8e 20 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  8005e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	89 c2                	mov    %eax,%edx
  8005ea:	01 d2                	add    %edx,%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	50                   	push   %eax
  8005f2:	e8 75 1b 00 00       	call   80216c <malloc>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800600:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060b:	c1 e0 02             	shl    $0x2,%eax
  80060e:	89 c1                	mov    %eax,%ecx
  800610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800613:	c1 e0 02             	shl    $0x2,%eax
  800616:	01 c8                	add    %ecx,%eax
  800618:	05 00 00 00 80       	add    $0x80000000,%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	72 21                	jb     800642 <_main+0x60a>
  800621:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800627:	89 c2                	mov    %eax,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	c1 e0 02             	shl    $0x2,%eax
  80062f:	89 c1                	mov    %eax,%ecx
  800631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	01 c8                	add    %ecx,%eax
  800639:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	76 14                	jbe    800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 f0 3f 80 00       	push   $0x803ff0
  80064a:	6a 7d                	push   $0x7d
  80064c:	68 dc 3f 80 00       	push   $0x803fdc
  800651:	e8 12 09 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800656:	e8 15 20 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  80065b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80065e:	74 14                	je     800674 <_main+0x63c>
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	68 58 40 80 00       	push   $0x804058
  800668:	6a 7e                	push   $0x7e
  80066a:	68 dc 3f 80 00       	push   $0x803fdc
  80066f:	e8 f4 08 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800674:	e8 f7 1f 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  800679:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	01 c0                	add    %eax,%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	01 c0                	add    %eax,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	50                   	push   %eax
  80068d:	e8 da 1a 00 00       	call   80216c <malloc>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80069b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a6:	c1 e0 02             	shl    $0x2,%eax
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ae:	c1 e0 03             	shl    $0x3,%eax
  8006b1:	01 c8                	add    %ecx,%eax
  8006b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	72 21                	jb     8006dd <_main+0x6a5>
  8006bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006c2:	89 c2                	mov    %eax,%edx
  8006c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c7:	c1 e0 02             	shl    $0x2,%eax
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cf:	c1 e0 03             	shl    $0x3,%eax
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d9:	39 c2                	cmp    %eax,%edx
  8006db:	76 17                	jbe    8006f4 <_main+0x6bc>
  8006dd:	83 ec 04             	sub    $0x4,%esp
  8006e0:	68 f0 3f 80 00       	push   $0x803ff0
  8006e5:	68 84 00 00 00       	push   $0x84
  8006ea:	68 dc 3f 80 00       	push   $0x803fdc
  8006ef:	e8 74 08 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f4:	e8 77 1f 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 58 40 80 00       	push   $0x804058
  800706:	68 85 00 00 00       	push   $0x85
  80070b:	68 dc 3f 80 00       	push   $0x803fdc
  800710:	e8 53 08 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800715:	e8 b6 1e 00 00       	call   8025d0 <sys_calculate_free_frames>
  80071a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800723:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800729:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072c:	89 d0                	mov    %edx,%eax
  80072e:	01 c0                	add    %eax,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	01 c0                	add    %eax,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	c1 e8 03             	shr    $0x3,%eax
  800739:	48                   	dec    %eax
  80073a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800740:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800746:	8a 55 df             	mov    -0x21(%ebp),%dl
  800749:	88 10                	mov    %dl,(%eax)
  80074b:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800751:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800754:	66 89 42 02          	mov    %ax,0x2(%edx)
  800758:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80075e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800761:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800764:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800771:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800777:	01 c2                	add    %eax,%edx
  800779:	8a 45 de             	mov    -0x22(%ebp),%al
  80077c:	88 02                	mov    %al,(%edx)
  80077e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80078b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800791:	01 c2                	add    %eax,%edx
  800793:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800797:	66 89 42 02          	mov    %ax,0x2(%edx)
  80079b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ae:	01 c2                	add    %eax,%edx
  8007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b3:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b6:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007b9:	e8 12 1e 00 00       	call   8025d0 <sys_calculate_free_frames>
  8007be:	29 c3                	sub    %eax,%ebx
  8007c0:	89 d8                	mov    %ebx,%eax
  8007c2:	83 f8 02             	cmp    $0x2,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 88 40 80 00       	push   $0x804088
  8007cf:	68 8c 00 00 00       	push   $0x8c
  8007d4:	68 dc 3f 80 00       	push   $0x803fdc
  8007d9:	e8 8a 07 00 00       	call   800f68 <_panic>
		found = 0;
  8007de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ec:	e9 aa 00 00 00       	jmp    80089b <_main+0x863>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007ff:	89 d0                	mov    %edx,%eax
  800801:	01 c0                	add    %eax,%eax
  800803:	01 d0                	add    %edx,%eax
  800805:	c1 e0 03             	shl    $0x3,%eax
  800808:	01 c8                	add    %ecx,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800812:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800818:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800825:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80082b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800831:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	75 03                	jne    80083d <_main+0x805>
				found++;
  80083a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083d:	a1 20 50 80 00       	mov    0x805020,%eax
  800842:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	01 c0                	add    %eax,%eax
  80084f:	01 d0                	add    %edx,%eax
  800851:	c1 e0 03             	shl    $0x3,%eax
  800854:	01 c8                	add    %ecx,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80085e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800864:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800871:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800878:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800886:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80088c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	75 03                	jne    800898 <_main+0x860>
				found++;
  800895:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800898:	ff 45 ec             	incl   -0x14(%ebp)
  80089b:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a0:	8b 50 74             	mov    0x74(%eax),%edx
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	0f 87 43 ff ff ff    	ja     8007f1 <_main+0x7b9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ae:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b2:	74 17                	je     8008cb <_main+0x893>
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 cc 40 80 00       	push   $0x8040cc
  8008bc:	68 95 00 00 00       	push   $0x95
  8008c1:	68 dc 3f 80 00       	push   $0x803fdc
  8008c6:	e8 9d 06 00 00       	call   800f68 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 00 1d 00 00       	call   8025d0 <sys_calculate_free_frames>
  8008d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 98 1d 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  8008d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	01 d2                	add    %edx,%edx
  8008e2:	01 d0                	add    %edx,%eax
  8008e4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	50                   	push   %eax
  8008eb:	e8 7c 18 00 00       	call   80216c <malloc>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800904:	c1 e0 02             	shl    $0x2,%eax
  800907:	89 c1                	mov    %eax,%ecx
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	c1 e0 04             	shl    $0x4,%eax
  80090f:	01 c8                	add    %ecx,%eax
  800911:	05 00 00 00 80       	add    $0x80000000,%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	72 21                	jb     80093b <_main+0x903>
  80091a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800920:	89 c2                	mov    %eax,%edx
  800922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	89 c1                	mov    %eax,%ecx
  80092a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092d:	c1 e0 04             	shl    $0x4,%eax
  800930:	01 c8                	add    %ecx,%eax
  800932:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 17                	jbe    800952 <_main+0x91a>
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 f0 3f 80 00       	push   $0x803ff0
  800943:	68 9b 00 00 00       	push   $0x9b
  800948:	68 dc 3f 80 00       	push   $0x803fdc
  80094d:	e8 16 06 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800952:	e8 19 1d 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  800957:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 58 40 80 00       	push   $0x804058
  800964:	68 9c 00 00 00       	push   $0x9c
  800969:	68 dc 3f 80 00       	push   $0x803fdc
  80096e:	e8 f5 05 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800973:	e8 f8 1c 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  800978:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80097b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097e:	89 d0                	mov    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d0                	add    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 da 17 00 00       	call   80216c <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009a1:	89 c1                	mov    %eax,%ecx
  8009a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b5:	c1 e0 04             	shl    $0x4,%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bf:	39 c1                	cmp    %eax,%ecx
  8009c1:	72 28                	jb     8009eb <_main+0x9b3>
  8009c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dd:	c1 e0 04             	shl    $0x4,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	76 17                	jbe    800a02 <_main+0x9ca>
  8009eb:	83 ec 04             	sub    $0x4,%esp
  8009ee:	68 f0 3f 80 00       	push   $0x803ff0
  8009f3:	68 a2 00 00 00       	push   $0xa2
  8009f8:	68 dc 3f 80 00       	push   $0x803fdc
  8009fd:	e8 66 05 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a02:	e8 69 1c 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  800a07:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a0a:	74 17                	je     800a23 <_main+0x9eb>
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 58 40 80 00       	push   $0x804058
  800a14:	68 a3 00 00 00       	push   $0xa3
  800a19:	68 dc 3f 80 00       	push   $0x803fdc
  800a1e:	e8 45 05 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a23:	e8 a8 1b 00 00       	call   8025d0 <sys_calculate_free_frames>
  800a28:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a39:	48                   	dec    %eax
  800a3a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a46:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a4c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a52:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a55:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a57:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	c1 ea 1f             	shr    $0x1f,%edx
  800a62:	01 d0                	add    %edx,%eax
  800a64:	d1 f8                	sar    %eax
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a6e:	01 c2                	add    %eax,%edx
  800a70:	8a 45 de             	mov    -0x22(%ebp),%al
  800a73:	88 c1                	mov    %al,%cl
  800a75:	c0 e9 07             	shr    $0x7,%cl
  800a78:	01 c8                	add    %ecx,%eax
  800a7a:	d0 f8                	sar    %al
  800a7c:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7e:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a84:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a8a:	01 c2                	add    %eax,%edx
  800a8c:	8a 45 de             	mov    -0x22(%ebp),%al
  800a8f:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a91:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a94:	e8 37 1b 00 00       	call   8025d0 <sys_calculate_free_frames>
  800a99:	29 c3                	sub    %eax,%ebx
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	83 f8 05             	cmp    $0x5,%eax
  800aa0:	74 17                	je     800ab9 <_main+0xa81>
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	68 88 40 80 00       	push   $0x804088
  800aaa:	68 ab 00 00 00       	push   $0xab
  800aaf:	68 dc 3f 80 00       	push   $0x803fdc
  800ab4:	e8 af 04 00 00       	call   800f68 <_panic>
		found = 0;
  800ab9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ac0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac7:	e9 02 01 00 00       	jmp    800bce <_main+0xb96>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800acc:	a1 20 50 80 00       	mov    0x805020,%eax
  800ad1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	c1 e0 03             	shl    $0x3,%eax
  800ae3:	01 c8                	add    %ecx,%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800aed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800af3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b00:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b06:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	75 03                	jne    800b18 <_main+0xae0>
				found++;
  800b15:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b18:	a1 20 50 80 00       	mov    0x805020,%eax
  800b1d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b26:	89 d0                	mov    %edx,%eax
  800b28:	01 c0                	add    %eax,%eax
  800b2a:	01 d0                	add    %edx,%eax
  800b2c:	c1 e0 03             	shl    $0x3,%eax
  800b2f:	01 c8                	add    %ecx,%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b39:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	c1 e9 1f             	shr    $0x1f,%ecx
  800b51:	01 c8                	add    %ecx,%eax
  800b53:	d1 f8                	sar    %eax
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b5d:	01 c8                	add    %ecx,%eax
  800b5f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b65:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	75 03                	jne    800b77 <_main+0xb3f>
				found++;
  800b74:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b77:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b85:	89 d0                	mov    %edx,%eax
  800b87:	01 c0                	add    %eax,%eax
  800b89:	01 d0                	add    %edx,%eax
  800b8b:	c1 e0 03             	shl    $0x3,%eax
  800b8e:	01 c8                	add    %ecx,%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b98:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba3:	89 c1                	mov    %eax,%ecx
  800ba5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bab:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bb9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc4:	39 c1                	cmp    %eax,%ecx
  800bc6:	75 03                	jne    800bcb <_main+0xb93>
				found++;
  800bc8:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bcb:	ff 45 ec             	incl   -0x14(%ebp)
  800bce:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd3:	8b 50 74             	mov    0x74(%eax),%edx
  800bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	0f 87 eb fe ff ff    	ja     800acc <_main+0xa94>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800be1:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be5:	74 17                	je     800bfe <_main+0xbc6>
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	68 cc 40 80 00       	push   $0x8040cc
  800bef:	68 b6 00 00 00       	push   $0xb6
  800bf4:	68 dc 3f 80 00       	push   $0x803fdc
  800bf9:	e8 6a 03 00 00       	call   800f68 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfe:	e8 6d 1a 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  800c03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	01 c0                	add    %eax,%eax
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	e8 4e 15 00 00       	call   80216c <malloc>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c27:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c2d:	89 c1                	mov    %eax,%ecx
  800c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c42:	c1 e0 04             	shl    $0x4,%eax
  800c45:	01 d0                	add    %edx,%eax
  800c47:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4c:	39 c1                	cmp    %eax,%ecx
  800c4e:	72 29                	jb     800c79 <_main+0xc41>
  800c50:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c56:	89 c1                	mov    %eax,%ecx
  800c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	01 c0                	add    %eax,%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	c1 e0 02             	shl    $0x2,%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	89 c2                	mov    %eax,%edx
  800c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c6b:	c1 e0 04             	shl    $0x4,%eax
  800c6e:	01 d0                	add    %edx,%eax
  800c70:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c75:	39 c1                	cmp    %eax,%ecx
  800c77:	76 17                	jbe    800c90 <_main+0xc58>
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	68 f0 3f 80 00       	push   $0x803ff0
  800c81:	68 bb 00 00 00       	push   $0xbb
  800c86:	68 dc 3f 80 00       	push   $0x803fdc
  800c8b:	e8 d8 02 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c90:	e8 db 19 00 00       	call   802670 <sys_pf_calculate_allocated_pages>
  800c95:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c98:	74 17                	je     800cb1 <_main+0xc79>
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	68 58 40 80 00       	push   $0x804058
  800ca2:	68 bc 00 00 00       	push   $0xbc
  800ca7:	68 dc 3f 80 00       	push   $0x803fdc
  800cac:	e8 b7 02 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cb1:	e8 1a 19 00 00       	call   8025d0 <sys_calculate_free_frames>
  800cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cbf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	01 c0                	add    %eax,%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	01 c0                	add    %eax,%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	01 c0                	add    %eax,%eax
  800cd4:	d1 e8                	shr    %eax
  800cd6:	48                   	dec    %eax
  800cd7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cdd:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce6:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cef:	01 c0                	add    %eax,%eax
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf9:	01 c2                	add    %eax,%edx
  800cfb:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cff:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d02:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d05:	e8 c6 18 00 00       	call   8025d0 <sys_calculate_free_frames>
  800d0a:	29 c3                	sub    %eax,%ebx
  800d0c:	89 d8                	mov    %ebx,%eax
  800d0e:	83 f8 02             	cmp    $0x2,%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 88 40 80 00       	push   $0x804088
  800d1b:	68 c3 00 00 00       	push   $0xc3
  800d20:	68 dc 3f 80 00       	push   $0x803fdc
  800d25:	e8 3e 02 00 00       	call   800f68 <_panic>
		found = 0;
  800d2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d38:	e9 a7 00 00 00       	jmp    800de4 <_main+0xdac>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d4b:	89 d0                	mov    %edx,%eax
  800d4d:	01 c0                	add    %eax,%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	c1 e0 03             	shl    $0x3,%eax
  800d54:	01 c8                	add    %ecx,%eax
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d5e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d71:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d77:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	75 03                	jne    800d89 <_main+0xd51>
				found++;
  800d86:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d89:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	01 c0                	add    %eax,%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	c1 e0 03             	shl    $0x3,%eax
  800da0:	01 c8                	add    %ecx,%eax
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800daa:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dbd:	01 c0                	add    %eax,%eax
  800dbf:	89 c1                	mov    %eax,%ecx
  800dc1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dc7:	01 c8                	add    %ecx,%eax
  800dc9:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800dcf:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	75 03                	jne    800de1 <_main+0xda9>
				found++;
  800dde:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800de1:	ff 45 ec             	incl   -0x14(%ebp)
  800de4:	a1 20 50 80 00       	mov    0x805020,%eax
  800de9:	8b 50 74             	mov    0x74(%eax),%edx
  800dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800def:	39 c2                	cmp    %eax,%edx
  800df1:	0f 87 46 ff ff ff    	ja     800d3d <_main+0xd05>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800dfb:	74 17                	je     800e14 <_main+0xddc>
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	68 cc 40 80 00       	push   $0x8040cc
  800e05:	68 cc 00 00 00       	push   $0xcc
  800e0a:	68 dc 3f 80 00       	push   $0x803fdc
  800e0f:	e8 54 01 00 00       	call   800f68 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	68 ec 40 80 00       	push   $0x8040ec
  800e1c:	e8 fb 03 00 00       	call   80121c <cprintf>
  800e21:	83 c4 10             	add    $0x10,%esp

	return;
  800e24:	90                   	nop
}
  800e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e32:	e8 79 1a 00 00       	call   8028b0 <sys_getenvindex>
  800e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 d0                	mov    %edx,%eax
  800e3f:	c1 e0 03             	shl    $0x3,%eax
  800e42:	01 d0                	add    %edx,%eax
  800e44:	01 c0                	add    %eax,%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	c1 e0 04             	shl    $0x4,%eax
  800e54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e59:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e5e:	a1 20 50 80 00       	mov    0x805020,%eax
  800e63:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	74 0f                	je     800e7c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800e6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800e72:	05 5c 05 00 00       	add    $0x55c,%eax
  800e77:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e80:	7e 0a                	jle    800e8c <libmain+0x60>
		binaryname = argv[0];
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 9e f1 ff ff       	call   800038 <_main>
  800e9a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e9d:	e8 1b 18 00 00       	call   8026bd <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	68 40 41 80 00       	push   $0x804140
  800eaa:	e8 6d 03 00 00       	call   80121c <cprintf>
  800eaf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800eb2:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800ebd:	a1 20 50 80 00       	mov    0x805020,%eax
  800ec2:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	52                   	push   %edx
  800ecc:	50                   	push   %eax
  800ecd:	68 68 41 80 00       	push   $0x804168
  800ed2:	e8 45 03 00 00       	call   80121c <cprintf>
  800ed7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ee5:	a1 20 50 80 00       	mov    0x805020,%eax
  800eea:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800ef0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800efb:	51                   	push   %ecx
  800efc:	52                   	push   %edx
  800efd:	50                   	push   %eax
  800efe:	68 90 41 80 00       	push   $0x804190
  800f03:	e8 14 03 00 00       	call   80121c <cprintf>
  800f08:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	50                   	push   %eax
  800f1a:	68 e8 41 80 00       	push   $0x8041e8
  800f1f:	e8 f8 02 00 00       	call   80121c <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	68 40 41 80 00       	push   $0x804140
  800f2f:	e8 e8 02 00 00       	call   80121c <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f37:	e8 9b 17 00 00       	call   8026d7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f3c:	e8 19 00 00 00       	call   800f5a <exit>
}
  800f41:	90                   	nop
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	6a 00                	push   $0x0
  800f4f:	e8 28 19 00 00       	call   80287c <sys_destroy_env>
  800f54:	83 c4 10             	add    $0x10,%esp
}
  800f57:	90                   	nop
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <exit>:

void
exit(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f60:	e8 7d 19 00 00       	call   8028e2 <sys_exit_env>
}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f71:	83 c0 04             	add    $0x4,%eax
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f77:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	74 16                	je     800f96 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f80:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	50                   	push   %eax
  800f89:	68 fc 41 80 00       	push   $0x8041fc
  800f8e:	e8 89 02 00 00       	call   80121c <cprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f96:	a1 00 50 80 00       	mov    0x805000,%eax
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	68 01 42 80 00       	push   $0x804201
  800fa7:	e8 70 02 00 00       	call   80121c <cprintf>
  800fac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb8:	50                   	push   %eax
  800fb9:	e8 f3 01 00 00       	call   8011b1 <vcprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	6a 00                	push   $0x0
  800fc6:	68 1d 42 80 00       	push   $0x80421d
  800fcb:	e8 e1 01 00 00       	call   8011b1 <vcprintf>
  800fd0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fd3:	e8 82 ff ff ff       	call   800f5a <exit>

	// should not return here
	while (1) ;
  800fd8:	eb fe                	jmp    800fd8 <_panic+0x70>

00800fda <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fe0:	a1 20 50 80 00       	mov    0x805020,%eax
  800fe5:	8b 50 74             	mov    0x74(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	74 14                	je     801003 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 20 42 80 00       	push   $0x804220
  800ff7:	6a 26                	push   $0x26
  800ff9:	68 6c 42 80 00       	push   $0x80426c
  800ffe:	e8 65 ff ff ff       	call   800f68 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80100a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801011:	e9 c2 00 00 00       	jmp    8010d8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	85 c0                	test   %eax,%eax
  801029:	75 08                	jne    801033 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80102b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80102e:	e9 a2 00 00 00       	jmp    8010d5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801033:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80103a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801041:	eb 69                	jmp    8010ac <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801043:	a1 20 50 80 00       	mov    0x805020,%eax
  801048:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80104e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	01 c0                	add    %eax,%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c1 e0 03             	shl    $0x3,%eax
  80105a:	01 c8                	add    %ecx,%eax
  80105c:	8a 40 04             	mov    0x4(%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 46                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801063:	a1 20 50 80 00       	mov    0x805020,%eax
  801068:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80106e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801071:	89 d0                	mov    %edx,%eax
  801073:	01 c0                	add    %eax,%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	c1 e0 03             	shl    $0x3,%eax
  80107a:	01 c8                	add    %ecx,%eax
  80107c:	8b 00                	mov    (%eax),%eax
  80107e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801089:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80108b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	01 c8                	add    %ecx,%eax
  80109a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	75 09                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010a7:	eb 12                	jmp    8010bb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010a9:	ff 45 e8             	incl   -0x18(%ebp)
  8010ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8010b1:	8b 50 74             	mov    0x74(%eax),%edx
  8010b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	77 88                	ja     801043 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010bf:	75 14                	jne    8010d5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 78 42 80 00       	push   $0x804278
  8010c9:	6a 3a                	push   $0x3a
  8010cb:	68 6c 42 80 00       	push   $0x80426c
  8010d0:	e8 93 fe ff ff       	call   800f68 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010d5:	ff 45 f0             	incl   -0x10(%ebp)
  8010d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010de:	0f 8c 32 ff ff ff    	jl     801016 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010f2:	eb 26                	jmp    80111a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	c1 e0 03             	shl    $0x3,%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 40 04             	mov    0x4(%eax),%al
  801110:	3c 01                	cmp    $0x1,%al
  801112:	75 03                	jne    801117 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801114:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	ff 45 e0             	incl   -0x20(%ebp)
  80111a:	a1 20 50 80 00       	mov    0x805020,%eax
  80111f:	8b 50 74             	mov    0x74(%eax),%edx
  801122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801125:	39 c2                	cmp    %eax,%edx
  801127:	77 cb                	ja     8010f4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80112f:	74 14                	je     801145 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	68 cc 42 80 00       	push   $0x8042cc
  801139:	6a 44                	push   $0x44
  80113b:	68 6c 42 80 00       	push   $0x80426c
  801140:	e8 23 fe ff ff       	call   800f68 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801145:	90                   	nop
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	8d 48 01             	lea    0x1(%eax),%ecx
  801156:	8b 55 0c             	mov    0xc(%ebp),%edx
  801159:	89 0a                	mov    %ecx,(%edx)
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	88 d1                	mov    %dl,%cl
  801160:	8b 55 0c             	mov    0xc(%ebp),%edx
  801163:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801171:	75 2c                	jne    80119f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801173:	a0 24 50 80 00       	mov    0x805024,%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117e:	8b 12                	mov    (%edx),%edx
  801180:	89 d1                	mov    %edx,%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	83 c2 08             	add    $0x8,%edx
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	50                   	push   %eax
  80118c:	51                   	push   %ecx
  80118d:	52                   	push   %edx
  80118e:	e8 7c 13 00 00       	call   80250f <sys_cputs>
  801193:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8b 40 04             	mov    0x4(%eax),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011c1:	00 00 00 
	b.cnt = 0;
  8011c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	68 48 11 80 00       	push   $0x801148
  8011e0:	e8 11 02 00 00       	call   8013f6 <vprintfmt>
  8011e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011e8:	a0 24 50 80 00       	mov    0x805024,%al
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801201:	83 c0 08             	add    $0x8,%eax
  801204:	50                   	push   %eax
  801205:	e8 05 13 00 00       	call   80250f <sys_cputs>
  80120a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80120d:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <cprintf>:

int cprintf(const char *fmt, ...) {
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801222:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801229:	8d 45 0c             	lea    0xc(%ebp),%eax
  80122c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	e8 73 ff ff ff       	call   8011b1 <vcprintf>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801244:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80124f:	e8 69 14 00 00       	call   8026bd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801254:	8d 45 0c             	lea    0xc(%ebp),%eax
  801257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	ff 75 f4             	pushl  -0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	e8 48 ff ff ff       	call   8011b1 <vcprintf>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80126f:	e8 63 14 00 00       	call   8026d7 <sys_enable_interrupt>
	return cnt;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	53                   	push   %ebx
  80127d:	83 ec 14             	sub    $0x14,%esp
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80128c:	8b 45 18             	mov    0x18(%ebp),%eax
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
  801294:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801297:	77 55                	ja     8012ee <printnum+0x75>
  801299:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80129c:	72 05                	jb     8012a3 <printnum+0x2a>
  80129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a1:	77 4b                	ja     8012ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8012ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b1:	52                   	push   %edx
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b9:	e8 82 2a 00 00       	call   803d40 <__udivdi3>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	ff 75 20             	pushl  0x20(%ebp)
  8012c7:	53                   	push   %ebx
  8012c8:	ff 75 18             	pushl  0x18(%ebp)
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 a1 ff ff ff       	call   801279 <printnum>
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	eb 1a                	jmp    8012f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	ff 75 20             	pushl  0x20(%ebp)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	ff d0                	call   *%eax
  8012eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8012f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012f5:	7f e6                	jg     8012dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	53                   	push   %ebx
  801306:	51                   	push   %ecx
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	e8 42 2b 00 00       	call   803e50 <__umoddi3>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	05 34 45 80 00       	add    $0x804534,%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	ff d0                	call   *%eax
  801327:	83 c4 10             	add    $0x10,%esp
}
  80132a:	90                   	nop
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801333:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801337:	7e 1c                	jle    801355 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 50 08             	lea    0x8(%eax),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	89 10                	mov    %edx,(%eax)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 e8 08             	sub    $0x8,%eax
  80134e:	8b 50 04             	mov    0x4(%eax),%edx
  801351:	8b 00                	mov    (%eax),%eax
  801353:	eb 40                	jmp    801395 <getuint+0x65>
	else if (lflag)
  801355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801359:	74 1e                	je     801379 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 50 04             	lea    0x4(%eax),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 10                	mov    %edx,(%eax)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 e8 04             	sub    $0x4,%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	eb 1c                	jmp    801395 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 50 04             	lea    0x4(%eax),%edx
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 10                	mov    %edx,(%eax)
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	83 e8 04             	sub    $0x4,%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80139a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80139e:	7e 1c                	jle    8013bc <getint+0x25>
		return va_arg(*ap, long long);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 08             	lea    0x8(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 08             	sub    $0x8,%eax
  8013b5:	8b 50 04             	mov    0x4(%eax),%edx
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	eb 38                	jmp    8013f4 <getint+0x5d>
	else if (lflag)
  8013bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c0:	74 1a                	je     8013dc <getint+0x45>
		return va_arg(*ap, long);
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 50 04             	lea    0x4(%eax),%edx
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	89 10                	mov    %edx,(%eax)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 e8 04             	sub    $0x4,%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	99                   	cltd   
  8013da:	eb 18                	jmp    8013f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 50 04             	lea    0x4(%eax),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 10                	mov    %edx,(%eax)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 e8 04             	sub    $0x4,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	99                   	cltd   
}
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013fe:	eb 17                	jmp    801417 <vprintfmt+0x21>
			if (ch == '\0')
  801400:	85 db                	test   %ebx,%ebx
  801402:	0f 84 af 03 00 00    	je     8017b7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	53                   	push   %ebx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	ff d0                	call   *%eax
  801414:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 10             	mov    %edx,0x10(%ebp)
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f b6 d8             	movzbl %al,%ebx
  801425:	83 fb 25             	cmp    $0x25,%ebx
  801428:	75 d6                	jne    801400 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80142a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80142e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80143c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801443:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 10             	mov    %edx,0x10(%ebp)
  801453:	8a 00                	mov    (%eax),%al
  801455:	0f b6 d8             	movzbl %al,%ebx
  801458:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80145b:	83 f8 55             	cmp    $0x55,%eax
  80145e:	0f 87 2b 03 00 00    	ja     80178f <vprintfmt+0x399>
  801464:	8b 04 85 58 45 80 00 	mov    0x804558(,%eax,4),%eax
  80146b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80146d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801471:	eb d7                	jmp    80144a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801473:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801477:	eb d1                	jmp    80144a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801483:	89 d0                	mov    %edx,%eax
  801485:	c1 e0 02             	shl    $0x2,%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	01 c0                	add    %eax,%eax
  80148c:	01 d8                	add    %ebx,%eax
  80148e:	83 e8 30             	sub    $0x30,%eax
  801491:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80149c:	83 fb 2f             	cmp    $0x2f,%ebx
  80149f:	7e 3e                	jle    8014df <vprintfmt+0xe9>
  8014a1:	83 fb 39             	cmp    $0x39,%ebx
  8014a4:	7f 39                	jg     8014df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014a9:	eb d5                	jmp    801480 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ae:	83 c0 04             	add    $0x4,%eax
  8014b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8014b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b7:	83 e8 04             	sub    $0x4,%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014bf:	eb 1f                	jmp    8014e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c5:	79 83                	jns    80144a <vprintfmt+0x54>
				width = 0;
  8014c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014ce:	e9 77 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014da:	e9 6b ff ff ff       	jmp    80144a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e4:	0f 89 60 ff ff ff    	jns    80144a <vprintfmt+0x54>
				width = precision, precision = -1;
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014f7:	e9 4e ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014ff:	e9 46 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	83 c0 04             	add    $0x4,%eax
  80150a:	89 45 14             	mov    %eax,0x14(%ebp)
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	83 e8 04             	sub    $0x4,%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	50                   	push   %eax
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	ff d0                	call   *%eax
  801521:	83 c4 10             	add    $0x10,%esp
			break;
  801524:	e9 89 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	83 c0 04             	add    $0x4,%eax
  80152f:	89 45 14             	mov    %eax,0x14(%ebp)
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	83 e8 04             	sub    $0x4,%eax
  801538:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	79 02                	jns    801540 <vprintfmt+0x14a>
				err = -err;
  80153e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801540:	83 fb 64             	cmp    $0x64,%ebx
  801543:	7f 0b                	jg     801550 <vprintfmt+0x15a>
  801545:	8b 34 9d a0 43 80 00 	mov    0x8043a0(,%ebx,4),%esi
  80154c:	85 f6                	test   %esi,%esi
  80154e:	75 19                	jne    801569 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801550:	53                   	push   %ebx
  801551:	68 45 45 80 00       	push   $0x804545
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 5e 02 00 00       	call   8017bf <printfmt>
  801561:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801564:	e9 49 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801569:	56                   	push   %esi
  80156a:	68 4e 45 80 00       	push   $0x80454e
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 45 02 00 00       	call   8017bf <printfmt>
  80157a:	83 c4 10             	add    $0x10,%esp
			break;
  80157d:	e9 30 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	83 c0 04             	add    $0x4,%eax
  801588:	89 45 14             	mov    %eax,0x14(%ebp)
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	83 e8 04             	sub    $0x4,%eax
  801591:	8b 30                	mov    (%eax),%esi
  801593:	85 f6                	test   %esi,%esi
  801595:	75 05                	jne    80159c <vprintfmt+0x1a6>
				p = "(null)";
  801597:	be 51 45 80 00       	mov    $0x804551,%esi
			if (width > 0 && padc != '-')
  80159c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015a0:	7e 6d                	jle    80160f <vprintfmt+0x219>
  8015a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015a6:	74 67                	je     80160f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	50                   	push   %eax
  8015af:	56                   	push   %esi
  8015b0:	e8 0c 03 00 00       	call   8018c1 <strnlen>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015bb:	eb 16                	jmp    8015d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	ff d0                	call   *%eax
  8015cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8015d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d7:	7f e4                	jg     8015bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d9:	eb 34                	jmp    80160f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015df:	74 1c                	je     8015fd <vprintfmt+0x207>
  8015e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015e4:	7e 05                	jle    8015eb <vprintfmt+0x1f5>
  8015e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8015e9:	7e 12                	jle    8015fd <vprintfmt+0x207>
					putch('?', putdat);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	6a 3f                	push   $0x3f
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	ff d0                	call   *%eax
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb 0f                	jmp    80160c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	53                   	push   %ebx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	ff d0                	call   *%eax
  801609:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80160c:	ff 4d e4             	decl   -0x1c(%ebp)
  80160f:	89 f0                	mov    %esi,%eax
  801611:	8d 70 01             	lea    0x1(%eax),%esi
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f be d8             	movsbl %al,%ebx
  801619:	85 db                	test   %ebx,%ebx
  80161b:	74 24                	je     801641 <vprintfmt+0x24b>
  80161d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801621:	78 b8                	js     8015db <vprintfmt+0x1e5>
  801623:	ff 4d e0             	decl   -0x20(%ebp)
  801626:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80162a:	79 af                	jns    8015db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80162c:	eb 13                	jmp    801641 <vprintfmt+0x24b>
				putch(' ', putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	6a 20                	push   $0x20
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	ff d0                	call   *%eax
  80163b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80163e:	ff 4d e4             	decl   -0x1c(%ebp)
  801641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801645:	7f e7                	jg     80162e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801647:	e9 66 01 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 e8             	pushl  -0x18(%ebp)
  801652:	8d 45 14             	lea    0x14(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	e8 3c fd ff ff       	call   801397 <getint>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801661:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	85 d2                	test   %edx,%edx
  80166c:	79 23                	jns    801691 <vprintfmt+0x29b>
				putch('-', putdat);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	6a 2d                	push   $0x2d
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	ff d0                	call   *%eax
  80167b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801684:	f7 d8                	neg    %eax
  801686:	83 d2 00             	adc    $0x0,%edx
  801689:	f7 da                	neg    %edx
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801691:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801698:	e9 bc 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	e8 84 fc ff ff       	call   801330 <getuint>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016bc:	e9 98 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	6a 58                	push   $0x58
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	ff d0                	call   *%eax
  8016ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	6a 58                	push   $0x58
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	ff d0                	call   *%eax
  8016de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	6a 58                	push   $0x58
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	ff d0                	call   *%eax
  8016ee:	83 c4 10             	add    $0x10,%esp
			break;
  8016f1:	e9 bc 00 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	6a 30                	push   $0x30
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	ff d0                	call   *%eax
  801703:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	6a 78                	push   $0x78
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	ff d0                	call   *%eax
  801713:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	83 e8 04             	sub    $0x4,%eax
  801725:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801731:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801738:	eb 1f                	jmp    801759 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	8d 45 14             	lea    0x14(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	e8 e7 fb ff ff       	call   801330 <getuint>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801752:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801759:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	52                   	push   %edx
  801764:	ff 75 e4             	pushl  -0x1c(%ebp)
  801767:	50                   	push   %eax
  801768:	ff 75 f4             	pushl  -0xc(%ebp)
  80176b:	ff 75 f0             	pushl  -0x10(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	e8 00 fb ff ff       	call   801279 <printnum>
  801779:	83 c4 20             	add    $0x20,%esp
			break;
  80177c:	eb 34                	jmp    8017b2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	53                   	push   %ebx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff d0                	call   *%eax
  80178a:	83 c4 10             	add    $0x10,%esp
			break;
  80178d:	eb 23                	jmp    8017b2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	6a 25                	push   $0x25
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	ff d0                	call   *%eax
  80179c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80179f:	ff 4d 10             	decl   0x10(%ebp)
  8017a2:	eb 03                	jmp    8017a7 <vprintfmt+0x3b1>
  8017a4:	ff 4d 10             	decl   0x10(%ebp)
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	48                   	dec    %eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 25                	cmp    $0x25,%al
  8017af:	75 f3                	jne    8017a4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017b1:	90                   	nop
		}
	}
  8017b2:	e9 47 fc ff ff       	jmp    8013fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017b7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8017c8:	83 c0 04             	add    $0x4,%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	e8 16 fc ff ff       	call   8013f6 <vprintfmt>
  8017e0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017e3:	90                   	nop
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	8d 50 01             	lea    0x1(%eax),%edx
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	8b 10                	mov    (%eax),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	8b 40 04             	mov    0x4(%eax),%eax
  801803:	39 c2                	cmp    %eax,%edx
  801805:	73 12                	jae    801819 <sprintputch+0x33>
		*b->buf++ = ch;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	8d 48 01             	lea    0x1(%eax),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 0a                	mov    %ecx,(%edx)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	88 10                	mov    %dl,(%eax)
}
  801819:	90                   	nop
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80183d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801841:	74 06                	je     801849 <vsnprintf+0x2d>
  801843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801847:	7f 07                	jg     801850 <vsnprintf+0x34>
		return -E_INVAL;
  801849:	b8 03 00 00 00       	mov    $0x3,%eax
  80184e:	eb 20                	jmp    801870 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801850:	ff 75 14             	pushl  0x14(%ebp)
  801853:	ff 75 10             	pushl  0x10(%ebp)
  801856:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	68 e6 17 80 00       	push   $0x8017e6
  80185f:	e8 92 fb ff ff       	call   8013f6 <vprintfmt>
  801864:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801878:	8d 45 10             	lea    0x10(%ebp),%eax
  80187b:	83 c0 04             	add    $0x4,%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 89 ff ff ff       	call   80181c <vsnprintf>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ab:	eb 06                	jmp    8018b3 <strlen+0x15>
		n++;
  8018ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b0:	ff 45 08             	incl   0x8(%ebp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	84 c0                	test   %al,%al
  8018ba:	75 f1                	jne    8018ad <strlen+0xf>
		n++;
	return n;
  8018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ce:	eb 09                	jmp    8018d9 <strnlen+0x18>
		n++;
  8018d0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018d3:	ff 45 08             	incl   0x8(%ebp)
  8018d6:	ff 4d 0c             	decl   0xc(%ebp)
  8018d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018dd:	74 09                	je     8018e8 <strnlen+0x27>
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	84 c0                	test   %al,%al
  8018e6:	75 e8                	jne    8018d0 <strnlen+0xf>
		n++;
	return n;
  8018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018f9:	90                   	nop
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8d 50 01             	lea    0x1(%eax),%edx
  801900:	89 55 08             	mov    %edx,0x8(%ebp)
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8d 4a 01             	lea    0x1(%edx),%ecx
  801909:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80190c:	8a 12                	mov    (%edx),%dl
  80190e:	88 10                	mov    %dl,(%eax)
  801910:	8a 00                	mov    (%eax),%al
  801912:	84 c0                	test   %al,%al
  801914:	75 e4                	jne    8018fa <strcpy+0xd>
		/* do nothing */;
	return ret;
  801916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192e:	eb 1f                	jmp    80194f <strncpy+0x34>
		*dst++ = *src;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8d 50 01             	lea    0x1(%eax),%edx
  801936:	89 55 08             	mov    %edx,0x8(%ebp)
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8a 12                	mov    (%edx),%dl
  80193e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 03                	je     80194c <strncpy+0x31>
			src++;
  801949:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80194c:	ff 45 fc             	incl   -0x4(%ebp)
  80194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801952:	3b 45 10             	cmp    0x10(%ebp),%eax
  801955:	72 d9                	jb     801930 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801968:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196c:	74 30                	je     80199e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80196e:	eb 16                	jmp    801986 <strlcpy+0x2a>
			*dst++ = *src++;
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8d 50 01             	lea    0x1(%eax),%edx
  801976:	89 55 08             	mov    %edx,0x8(%ebp)
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80197f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801982:	8a 12                	mov    (%edx),%dl
  801984:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801986:	ff 4d 10             	decl   0x10(%ebp)
  801989:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198d:	74 09                	je     801998 <strlcpy+0x3c>
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	75 d8                	jne    801970 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 d0                	mov    %edx,%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019ad:	eb 06                	jmp    8019b5 <strcmp+0xb>
		p++, q++;
  8019af:	ff 45 08             	incl   0x8(%ebp)
  8019b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	84 c0                	test   %al,%al
  8019bc:	74 0e                	je     8019cc <strcmp+0x22>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	38 c2                	cmp    %al,%dl
  8019ca:	74 e3                	je     8019af <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	0f b6 d0             	movzbl %al,%edx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	0f b6 c0             	movzbl %al,%eax
  8019dc:	29 c2                	sub    %eax,%edx
  8019de:	89 d0                	mov    %edx,%eax
}
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019e5:	eb 09                	jmp    8019f0 <strncmp+0xe>
		n--, p++, q++;
  8019e7:	ff 4d 10             	decl   0x10(%ebp)
  8019ea:	ff 45 08             	incl   0x8(%ebp)
  8019ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f4:	74 17                	je     801a0d <strncmp+0x2b>
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 0e                	je     801a0d <strncmp+0x2b>
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 10                	mov    (%eax),%dl
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 da                	je     8019e7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a11:	75 07                	jne    801a1a <strncmp+0x38>
		return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 14                	jmp    801a2e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	0f b6 d0             	movzbl %al,%edx
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f b6 c0             	movzbl %al,%eax
  801a2a:	29 c2                	sub    %eax,%edx
  801a2c:	89 d0                	mov    %edx,%eax
}
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a3c:	eb 12                	jmp    801a50 <strchr+0x20>
		if (*s == c)
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a46:	75 05                	jne    801a4d <strchr+0x1d>
			return (char *) s;
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	eb 11                	jmp    801a5e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a4d:	ff 45 08             	incl   0x8(%ebp)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	75 e5                	jne    801a3e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6c:	eb 0d                	jmp    801a7b <strfind+0x1b>
		if (*s == c)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a76:	74 0e                	je     801a86 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a78:	ff 45 08             	incl   0x8(%ebp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 ea                	jne    801a6e <strfind+0xe>
  801a84:	eb 01                	jmp    801a87 <strfind+0x27>
		if (*s == c)
			break;
  801a86:	90                   	nop
	return (char *) s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a9e:	eb 0e                	jmp    801aae <memset+0x22>
		*p++ = c;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8d 50 01             	lea    0x1(%eax),%edx
  801aa6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801aae:	ff 4d f8             	decl   -0x8(%ebp)
  801ab1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ab5:	79 e9                	jns    801aa0 <memset+0x14>
		*p++ = c;

	return v;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ace:	eb 16                	jmp    801ae6 <memcpy+0x2a>
		*d++ = *s++;
  801ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad3:	8d 50 01             	lea    0x1(%eax),%edx
  801ad6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ad9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801adf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ae2:	8a 12                	mov    (%edx),%dl
  801ae4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aec:	89 55 10             	mov    %edx,0x10(%ebp)
  801aef:	85 c0                	test   %eax,%eax
  801af1:	75 dd                	jne    801ad0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b10:	73 50                	jae    801b62 <memmove+0x6a>
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b1d:	76 43                	jbe    801b62 <memmove+0x6a>
		s += n;
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b2b:	eb 10                	jmp    801b3d <memmove+0x45>
			*--d = *--s;
  801b2d:	ff 4d f8             	decl   -0x8(%ebp)
  801b30:	ff 4d fc             	decl   -0x4(%ebp)
  801b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b36:	8a 10                	mov    (%eax),%dl
  801b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b43:	89 55 10             	mov    %edx,0x10(%ebp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 e3                	jne    801b2d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b4a:	eb 23                	jmp    801b6f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4f:	8d 50 01             	lea    0x1(%eax),%edx
  801b52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b5e:	8a 12                	mov    (%edx),%dl
  801b60:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b68:	89 55 10             	mov    %edx,0x10(%ebp)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 dd                	jne    801b4c <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b86:	eb 2a                	jmp    801bb2 <memcmp+0x3e>
		if (*s1 != *s2)
  801b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8b:	8a 10                	mov    (%eax),%dl
  801b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	38 c2                	cmp    %al,%dl
  801b94:	74 16                	je     801bac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	0f b6 d0             	movzbl %al,%edx
  801b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba1:	8a 00                	mov    (%eax),%al
  801ba3:	0f b6 c0             	movzbl %al,%eax
  801ba6:	29 c2                	sub    %eax,%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	eb 18                	jmp    801bc4 <memcmp+0x50>
		s1++, s2++;
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
  801baf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	75 c9                	jne    801b88 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	0f b6 d0             	movzbl %al,%edx
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	0f b6 c0             	movzbl %al,%eax
  801be7:	39 c2                	cmp    %eax,%edx
  801be9:	74 0d                	je     801bf8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801beb:	ff 45 08             	incl   0x8(%ebp)
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bf4:	72 e3                	jb     801bd9 <memfind+0x13>
  801bf6:	eb 01                	jmp    801bf9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bf8:	90                   	nop
	return (void *) s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c12:	eb 03                	jmp    801c17 <strtol+0x19>
		s++;
  801c14:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	8a 00                	mov    (%eax),%al
  801c1c:	3c 20                	cmp    $0x20,%al
  801c1e:	74 f4                	je     801c14 <strtol+0x16>
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	3c 09                	cmp    $0x9,%al
  801c27:	74 eb                	je     801c14 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	3c 2b                	cmp    $0x2b,%al
  801c30:	75 05                	jne    801c37 <strtol+0x39>
		s++;
  801c32:	ff 45 08             	incl   0x8(%ebp)
  801c35:	eb 13                	jmp    801c4a <strtol+0x4c>
	else if (*s == '-')
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	3c 2d                	cmp    $0x2d,%al
  801c3e:	75 0a                	jne    801c4a <strtol+0x4c>
		s++, neg = 1;
  801c40:	ff 45 08             	incl   0x8(%ebp)
  801c43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4e:	74 06                	je     801c56 <strtol+0x58>
  801c50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c54:	75 20                	jne    801c76 <strtol+0x78>
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8a 00                	mov    (%eax),%al
  801c5b:	3c 30                	cmp    $0x30,%al
  801c5d:	75 17                	jne    801c76 <strtol+0x78>
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	40                   	inc    %eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	3c 78                	cmp    $0x78,%al
  801c67:	75 0d                	jne    801c76 <strtol+0x78>
		s += 2, base = 16;
  801c69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c74:	eb 28                	jmp    801c9e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7a:	75 15                	jne    801c91 <strtol+0x93>
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 30                	cmp    $0x30,%al
  801c83:	75 0c                	jne    801c91 <strtol+0x93>
		s++, base = 8;
  801c85:	ff 45 08             	incl   0x8(%ebp)
  801c88:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c8f:	eb 0d                	jmp    801c9e <strtol+0xa0>
	else if (base == 0)
  801c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c95:	75 07                	jne    801c9e <strtol+0xa0>
		base = 10;
  801c97:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8a 00                	mov    (%eax),%al
  801ca3:	3c 2f                	cmp    $0x2f,%al
  801ca5:	7e 19                	jle    801cc0 <strtol+0xc2>
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	3c 39                	cmp    $0x39,%al
  801cae:	7f 10                	jg     801cc0 <strtol+0xc2>
			dig = *s - '0';
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	8a 00                	mov    (%eax),%al
  801cb5:	0f be c0             	movsbl %al,%eax
  801cb8:	83 e8 30             	sub    $0x30,%eax
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbe:	eb 42                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	3c 60                	cmp    $0x60,%al
  801cc7:	7e 19                	jle    801ce2 <strtol+0xe4>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	3c 7a                	cmp    $0x7a,%al
  801cd0:	7f 10                	jg     801ce2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	0f be c0             	movsbl %al,%eax
  801cda:	83 e8 57             	sub    $0x57,%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce0:	eb 20                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8a 00                	mov    (%eax),%al
  801ce7:	3c 40                	cmp    $0x40,%al
  801ce9:	7e 39                	jle    801d24 <strtol+0x126>
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	3c 5a                	cmp    $0x5a,%al
  801cf2:	7f 30                	jg     801d24 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	0f be c0             	movsbl %al,%eax
  801cfc:	83 e8 37             	sub    $0x37,%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d08:	7d 19                	jge    801d23 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d0a:	ff 45 08             	incl   0x8(%ebp)
  801d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d10:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d1e:	e9 7b ff ff ff       	jmp    801c9e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d23:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d28:	74 08                	je     801d32 <strtol+0x134>
		*endptr = (char *) s;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d30:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d36:	74 07                	je     801d3f <strtol+0x141>
  801d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3b:	f7 d8                	neg    %eax
  801d3d:	eb 03                	jmp    801d42 <strtol+0x144>
  801d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <ltostr>:

void
ltostr(long value, char *str)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5c:	79 13                	jns    801d71 <ltostr+0x2d>
	{
		neg = 1;
  801d5e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d6b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d6e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d79:	99                   	cltd   
  801d7a:	f7 f9                	idiv   %ecx
  801d7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d82:	8d 50 01             	lea    0x1(%eax),%edx
  801d85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d92:	83 c2 30             	add    $0x30,%edx
  801d95:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d9f:	f7 e9                	imul   %ecx
  801da1:	c1 fa 02             	sar    $0x2,%edx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	c1 f8 1f             	sar    $0x1f,%eax
  801da9:	29 c2                	sub    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801db0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801db8:	f7 e9                	imul   %ecx
  801dba:	c1 fa 02             	sar    $0x2,%edx
  801dbd:	89 c8                	mov    %ecx,%eax
  801dbf:	c1 f8 1f             	sar    $0x1f,%eax
  801dc2:	29 c2                	sub    %eax,%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	01 c0                	add    %eax,%eax
  801dcd:	29 c1                	sub    %eax,%ecx
  801dcf:	89 ca                	mov    %ecx,%edx
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	75 9c                	jne    801d71 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ddf:	48                   	dec    %eax
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801de7:	74 3d                	je     801e26 <ltostr+0xe2>
		start = 1 ;
  801de9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801df0:	eb 34                	jmp    801e26 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	8a 00                	mov    (%eax),%al
  801dfc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c2                	add    %eax,%edx
  801e1b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e1e:	88 02                	mov    %al,(%edx)
		start++ ;
  801e20:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e23:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e2c:	7c c4                	jl     801df2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	e8 54 fa ff ff       	call   80189e <strlen>
  801e4a:	83 c4 04             	add    $0x4,%esp
  801e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	e8 46 fa ff ff       	call   80189e <strlen>
  801e58:	83 c4 04             	add    $0x4,%esp
  801e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e6c:	eb 17                	jmp    801e85 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	01 c8                	add    %ecx,%eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e82:	ff 45 fc             	incl   -0x4(%ebp)
  801e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e8b:	7c e1                	jl     801e6e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e9b:	eb 1f                	jmp    801ebc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea0:	8d 50 01             	lea    0x1(%eax),%edx
  801ea3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ea6:	89 c2                	mov    %eax,%edx
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	01 c2                	add    %eax,%edx
  801ead:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	8a 00                	mov    (%eax),%al
  801eb7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801eb9:	ff 45 f8             	incl   -0x8(%ebp)
  801ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ebf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ec2:	7c d9                	jl     801e9d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c6 00 00             	movb   $0x0,(%eax)
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ef5:	eb 0c                	jmp    801f03 <strsplit+0x31>
			*string++ = 0;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	8d 50 01             	lea    0x1(%eax),%edx
  801efd:	89 55 08             	mov    %edx,0x8(%ebp)
  801f00:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	74 18                	je     801f24 <strsplit+0x52>
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	0f be c0             	movsbl %al,%eax
  801f14:	50                   	push   %eax
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	e8 13 fb ff ff       	call   801a30 <strchr>
  801f1d:	83 c4 08             	add    $0x8,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 d3                	jne    801ef7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	84 c0                	test   %al,%al
  801f2b:	74 5a                	je     801f87 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8b 00                	mov    (%eax),%eax
  801f32:	83 f8 0f             	cmp    $0xf,%eax
  801f35:	75 07                	jne    801f3e <strsplit+0x6c>
		{
			return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 66                	jmp    801fa4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	8d 48 01             	lea    0x1(%eax),%ecx
  801f46:	8b 55 14             	mov    0x14(%ebp),%edx
  801f49:	89 0a                	mov    %ecx,(%edx)
  801f4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f5c:	eb 03                	jmp    801f61 <strsplit+0x8f>
			string++;
  801f5e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8a 00                	mov    (%eax),%al
  801f66:	84 c0                	test   %al,%al
  801f68:	74 8b                	je     801ef5 <strsplit+0x23>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8a 00                	mov    (%eax),%al
  801f6f:	0f be c0             	movsbl %al,%eax
  801f72:	50                   	push   %eax
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	e8 b5 fa ff ff       	call   801a30 <strchr>
  801f7b:	83 c4 08             	add    $0x8,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 dc                	je     801f5e <strsplit+0x8c>
			string++;
	}
  801f82:	e9 6e ff ff ff       	jmp    801ef5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f87:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f88:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801fac:	a1 04 50 80 00       	mov    0x805004,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 1f                	je     801fd4 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801fb5:	e8 1d 00 00 00       	call   801fd7 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 b0 46 80 00       	push   $0x8046b0
  801fc2:	e8 55 f2 ff ff       	call   80121c <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801fca:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801fd1:	00 00 00 
	}
}
  801fd4:	90                   	nop
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  801fdd:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801fe4:	00 00 00 
  801fe7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801fee:	00 00 00 
  801ff1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ff8:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  801ffb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802002:	00 00 00 
  802005:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80200c:	00 00 00 
  80200f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802016:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  802019:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802020:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  802023:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80202a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802034:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802039:	2d 00 10 00 00       	sub    $0x1000,%eax
  80203e:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  802043:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80204a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802052:	2d 00 10 00 00       	sub    $0x1000,%eax
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	6a 06                	push   $0x6
  80205c:	ff 75 f4             	pushl  -0xc(%ebp)
  80205f:	50                   	push   %eax
  802060:	e8 ee 05 00 00       	call   802653 <sys_allocate_chunk>
  802065:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802068:	a1 20 51 80 00       	mov    0x805120,%eax
  80206d:	83 ec 0c             	sub    $0xc,%esp
  802070:	50                   	push   %eax
  802071:	e8 63 0c 00 00       	call   802cd9 <initialize_MemBlocksList>
  802076:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  802079:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80207e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  802081:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802084:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80208b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80208e:	8b 40 0c             	mov    0xc(%eax),%eax
  802091:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802097:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80209c:	89 c2                	mov    %eax,%edx
  80209e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a1:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8020a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8020ae:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8020b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b8:	8b 50 08             	mov    0x8(%eax),%edx
  8020bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020be:	01 d0                	add    %edx,%eax
  8020c0:	48                   	dec    %eax
  8020c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8020c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020cc:	f7 75 e0             	divl   -0x20(%ebp)
  8020cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020d2:	29 d0                	sub    %edx,%eax
  8020d4:	89 c2                	mov    %eax,%edx
  8020d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020d9:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  8020dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020e0:	75 14                	jne    8020f6 <initialize_dyn_block_system+0x11f>
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	68 d5 46 80 00       	push   $0x8046d5
  8020ea:	6a 34                	push   $0x34
  8020ec:	68 f3 46 80 00       	push   $0x8046f3
  8020f1:	e8 72 ee ff ff       	call   800f68 <_panic>
  8020f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	74 10                	je     80210f <initialize_dyn_block_system+0x138>
  8020ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802102:	8b 00                	mov    (%eax),%eax
  802104:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802107:	8b 52 04             	mov    0x4(%edx),%edx
  80210a:	89 50 04             	mov    %edx,0x4(%eax)
  80210d:	eb 0b                	jmp    80211a <initialize_dyn_block_system+0x143>
  80210f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802112:	8b 40 04             	mov    0x4(%eax),%eax
  802115:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80211a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80211d:	8b 40 04             	mov    0x4(%eax),%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	74 0f                	je     802133 <initialize_dyn_block_system+0x15c>
  802124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802127:	8b 40 04             	mov    0x4(%eax),%eax
  80212a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80212d:	8b 12                	mov    (%edx),%edx
  80212f:	89 10                	mov    %edx,(%eax)
  802131:	eb 0a                	jmp    80213d <initialize_dyn_block_system+0x166>
  802133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	a3 48 51 80 00       	mov    %eax,0x805148
  80213d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802146:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802149:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802150:	a1 54 51 80 00       	mov    0x805154,%eax
  802155:	48                   	dec    %eax
  802156:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	ff 75 e8             	pushl  -0x18(%ebp)
  802161:	e8 c4 13 00 00       	call   80352a <insert_sorted_with_merge_freeList>
  802166:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802169:	90                   	nop
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <malloc>:
//=================================



void* malloc(uint32 size)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802172:	e8 2f fe ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  802177:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217b:	75 07                	jne    802184 <malloc+0x18>
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
  802182:	eb 71                	jmp    8021f5 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  802184:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80218b:	76 07                	jbe    802194 <malloc+0x28>
	return NULL;
  80218d:	b8 00 00 00 00       	mov    $0x0,%eax
  802192:	eb 61                	jmp    8021f5 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802194:	e8 88 08 00 00       	call   802a21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802199:	85 c0                	test   %eax,%eax
  80219b:	74 53                	je     8021f0 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80219d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8021a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	01 d0                	add    %edx,%eax
  8021ac:	48                   	dec    %eax
  8021ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b8:	f7 75 f4             	divl   -0xc(%ebp)
  8021bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021be:	29 d0                	sub    %edx,%eax
  8021c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  8021c3:	83 ec 0c             	sub    $0xc,%esp
  8021c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8021c9:	e8 d2 0d 00 00       	call   802fa0 <alloc_block_FF>
  8021ce:	83 c4 10             	add    $0x10,%esp
  8021d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  8021d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021d8:	74 16                	je     8021f0 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  8021da:	83 ec 0c             	sub    $0xc,%esp
  8021dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8021e0:	e8 0c 0c 00 00       	call   802df1 <insert_sorted_allocList>
  8021e5:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8021e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021eb:	8b 40 08             	mov    0x8(%eax),%eax
  8021ee:	eb 05                	jmp    8021f5 <malloc+0x89>
    }

			}


	return NULL;
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802206:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80220b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  80220e:	83 ec 08             	sub    $0x8,%esp
  802211:	ff 75 f0             	pushl  -0x10(%ebp)
  802214:	68 40 50 80 00       	push   $0x805040
  802219:	e8 a0 0b 00 00       	call   802dbe <find_block>
  80221e:	83 c4 10             	add    $0x10,%esp
  802221:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  802224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802227:	8b 50 0c             	mov    0xc(%eax),%edx
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	83 ec 08             	sub    $0x8,%esp
  802230:	52                   	push   %edx
  802231:	50                   	push   %eax
  802232:	e8 e4 03 00 00       	call   80261b <sys_free_user_mem>
  802237:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80223a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80223e:	75 17                	jne    802257 <free+0x60>
  802240:	83 ec 04             	sub    $0x4,%esp
  802243:	68 d5 46 80 00       	push   $0x8046d5
  802248:	68 84 00 00 00       	push   $0x84
  80224d:	68 f3 46 80 00       	push   $0x8046f3
  802252:	e8 11 ed ff ff       	call   800f68 <_panic>
  802257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225a:	8b 00                	mov    (%eax),%eax
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 10                	je     802270 <free+0x79>
  802260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802263:	8b 00                	mov    (%eax),%eax
  802265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802268:	8b 52 04             	mov    0x4(%edx),%edx
  80226b:	89 50 04             	mov    %edx,0x4(%eax)
  80226e:	eb 0b                	jmp    80227b <free+0x84>
  802270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802273:	8b 40 04             	mov    0x4(%eax),%eax
  802276:	a3 44 50 80 00       	mov    %eax,0x805044
  80227b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227e:	8b 40 04             	mov    0x4(%eax),%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	74 0f                	je     802294 <free+0x9d>
  802285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802288:	8b 40 04             	mov    0x4(%eax),%eax
  80228b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80228e:	8b 12                	mov    (%edx),%edx
  802290:	89 10                	mov    %edx,(%eax)
  802292:	eb 0a                	jmp    80229e <free+0xa7>
  802294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802297:	8b 00                	mov    (%eax),%eax
  802299:	a3 40 50 80 00       	mov    %eax,0x805040
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022b6:	48                   	dec    %eax
  8022b7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  8022bc:	83 ec 0c             	sub    $0xc,%esp
  8022bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8022c2:	e8 63 12 00 00       	call   80352a <insert_sorted_with_merge_freeList>
  8022c7:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  8022ca:	90                   	nop
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	83 ec 38             	sub    $0x38,%esp
  8022d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022d9:	e8 c8 fc ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  8022de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022e2:	75 0a                	jne    8022ee <smalloc+0x21>
  8022e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e9:	e9 a0 00 00 00       	jmp    80238e <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8022ee:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8022f5:	76 0a                	jbe    802301 <smalloc+0x34>
		return NULL;
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	e9 8d 00 00 00       	jmp    80238e <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802301:	e8 1b 07 00 00       	call   802a21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802306:	85 c0                	test   %eax,%eax
  802308:	74 7f                	je     802389 <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80230a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802311:	8b 55 0c             	mov    0xc(%ebp),%edx
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	01 d0                	add    %edx,%eax
  802319:	48                   	dec    %eax
  80231a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	ba 00 00 00 00       	mov    $0x0,%edx
  802325:	f7 75 f4             	divl   -0xc(%ebp)
  802328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232b:	29 d0                	sub    %edx,%eax
  80232d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802330:	83 ec 0c             	sub    $0xc,%esp
  802333:	ff 75 ec             	pushl  -0x14(%ebp)
  802336:	e8 65 0c 00 00       	call   802fa0 <alloc_block_FF>
  80233b:	83 c4 10             	add    $0x10,%esp
  80233e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  802341:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802345:	74 42                	je     802389 <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  802347:	83 ec 0c             	sub    $0xc,%esp
  80234a:	ff 75 e8             	pushl  -0x18(%ebp)
  80234d:	e8 9f 0a 00 00       	call   802df1 <insert_sorted_allocList>
  802352:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  802355:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802358:	8b 40 08             	mov    0x8(%eax),%eax
  80235b:	89 c2                	mov    %eax,%edx
  80235d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802361:	52                   	push   %edx
  802362:	50                   	push   %eax
  802363:	ff 75 0c             	pushl  0xc(%ebp)
  802366:	ff 75 08             	pushl  0x8(%ebp)
  802369:	e8 38 04 00 00       	call   8027a6 <sys_createSharedObject>
  80236e:	83 c4 10             	add    $0x10,%esp
  802371:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  802374:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802378:	79 07                	jns    802381 <smalloc+0xb4>
	    		  return NULL;
  80237a:	b8 00 00 00 00       	mov    $0x0,%eax
  80237f:	eb 0d                	jmp    80238e <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  802381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802384:	8b 40 08             	mov    0x8(%eax),%eax
  802387:	eb 05                	jmp    80238e <smalloc+0xc1>


				}


		return NULL;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802396:	e8 0b fc ff ff       	call   801fa6 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80239b:	e8 81 06 00 00       	call   802a21 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	0f 84 9f 00 00 00    	je     802447 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8023a8:	83 ec 08             	sub    $0x8,%esp
  8023ab:	ff 75 0c             	pushl  0xc(%ebp)
  8023ae:	ff 75 08             	pushl  0x8(%ebp)
  8023b1:	e8 1a 04 00 00       	call   8027d0 <sys_getSizeOfSharedObject>
  8023b6:	83 c4 10             	add    $0x10,%esp
  8023b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8023bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c0:	79 0a                	jns    8023cc <sget+0x3c>
		return NULL;
  8023c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c7:	e9 80 00 00 00       	jmp    80244c <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8023cc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8023d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	01 d0                	add    %edx,%eax
  8023db:	48                   	dec    %eax
  8023dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8023df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e7:	f7 75 f0             	divl   -0x10(%ebp)
  8023ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ed:	29 d0                	sub    %edx,%eax
  8023ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8023f2:	83 ec 0c             	sub    $0xc,%esp
  8023f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8023f8:	e8 a3 0b 00 00       	call   802fa0 <alloc_block_FF>
  8023fd:	83 c4 10             	add    $0x10,%esp
  802400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  802403:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802407:	74 3e                	je     802447 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  802409:	83 ec 0c             	sub    $0xc,%esp
  80240c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80240f:	e8 dd 09 00 00       	call   802df1 <insert_sorted_allocList>
  802414:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  802417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241a:	8b 40 08             	mov    0x8(%eax),%eax
  80241d:	83 ec 04             	sub    $0x4,%esp
  802420:	50                   	push   %eax
  802421:	ff 75 0c             	pushl  0xc(%ebp)
  802424:	ff 75 08             	pushl  0x8(%ebp)
  802427:	e8 c1 03 00 00       	call   8027ed <sys_getSharedObject>
  80242c:	83 c4 10             	add    $0x10,%esp
  80242f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  802432:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802436:	79 07                	jns    80243f <sget+0xaf>
	    		  return NULL;
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
  80243d:	eb 0d                	jmp    80244c <sget+0xbc>
	  	return(void*) returned_block->sva;
  80243f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802442:	8b 40 08             	mov    0x8(%eax),%eax
  802445:	eb 05                	jmp    80244c <sget+0xbc>
	      }
	}
	   return NULL;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802454:	e8 4d fb ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	68 00 47 80 00       	push   $0x804700
  802461:	68 12 01 00 00       	push   $0x112
  802466:	68 f3 46 80 00       	push   $0x8046f3
  80246b:	e8 f8 ea ff ff       	call   800f68 <_panic>

00802470 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	68 28 47 80 00       	push   $0x804728
  80247e:	68 26 01 00 00       	push   $0x126
  802483:	68 f3 46 80 00       	push   $0x8046f3
  802488:	e8 db ea ff ff       	call   800f68 <_panic>

0080248d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802493:	83 ec 04             	sub    $0x4,%esp
  802496:	68 4c 47 80 00       	push   $0x80474c
  80249b:	68 31 01 00 00       	push   $0x131
  8024a0:	68 f3 46 80 00       	push   $0x8046f3
  8024a5:	e8 be ea ff ff       	call   800f68 <_panic>

008024aa <shrink>:

}
void shrink(uint32 newSize)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 4c 47 80 00       	push   $0x80474c
  8024b8:	68 36 01 00 00       	push   $0x136
  8024bd:	68 f3 46 80 00       	push   $0x8046f3
  8024c2:	e8 a1 ea ff ff       	call   800f68 <_panic>

008024c7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024cd:	83 ec 04             	sub    $0x4,%esp
  8024d0:	68 4c 47 80 00       	push   $0x80474c
  8024d5:	68 3b 01 00 00       	push   $0x13b
  8024da:	68 f3 46 80 00       	push   $0x8046f3
  8024df:	e8 84 ea ff ff       	call   800f68 <_panic>

008024e4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	57                   	push   %edi
  8024e8:	56                   	push   %esi
  8024e9:	53                   	push   %ebx
  8024ea:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024f9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8024fc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8024ff:	cd 30                	int    $0x30
  802501:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802507:	83 c4 10             	add    $0x10,%esp
  80250a:	5b                   	pop    %ebx
  80250b:	5e                   	pop    %esi
  80250c:	5f                   	pop    %edi
  80250d:	5d                   	pop    %ebp
  80250e:	c3                   	ret    

0080250f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
  802512:	83 ec 04             	sub    $0x4,%esp
  802515:	8b 45 10             	mov    0x10(%ebp),%eax
  802518:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80251b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	52                   	push   %edx
  802527:	ff 75 0c             	pushl  0xc(%ebp)
  80252a:	50                   	push   %eax
  80252b:	6a 00                	push   $0x0
  80252d:	e8 b2 ff ff ff       	call   8024e4 <syscall>
  802532:	83 c4 18             	add    $0x18,%esp
}
  802535:	90                   	nop
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_cgetc>:

int
sys_cgetc(void)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 01                	push   $0x1
  802547:	e8 98 ff ff ff       	call   8024e4 <syscall>
  80254c:	83 c4 18             	add    $0x18,%esp
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802554:	8b 55 0c             	mov    0xc(%ebp),%edx
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	52                   	push   %edx
  802561:	50                   	push   %eax
  802562:	6a 05                	push   $0x5
  802564:	e8 7b ff ff ff       	call   8024e4 <syscall>
  802569:	83 c4 18             	add    $0x18,%esp
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
  802571:	56                   	push   %esi
  802572:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802573:	8b 75 18             	mov    0x18(%ebp),%esi
  802576:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802579:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80257c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	56                   	push   %esi
  802583:	53                   	push   %ebx
  802584:	51                   	push   %ecx
  802585:	52                   	push   %edx
  802586:	50                   	push   %eax
  802587:	6a 06                	push   $0x6
  802589:	e8 56 ff ff ff       	call   8024e4 <syscall>
  80258e:	83 c4 18             	add    $0x18,%esp
}
  802591:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802594:	5b                   	pop    %ebx
  802595:	5e                   	pop    %esi
  802596:	5d                   	pop    %ebp
  802597:	c3                   	ret    

00802598 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80259b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	52                   	push   %edx
  8025a8:	50                   	push   %eax
  8025a9:	6a 07                	push   $0x7
  8025ab:	e8 34 ff ff ff       	call   8024e4 <syscall>
  8025b0:	83 c4 18             	add    $0x18,%esp
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	ff 75 0c             	pushl  0xc(%ebp)
  8025c1:	ff 75 08             	pushl  0x8(%ebp)
  8025c4:	6a 08                	push   $0x8
  8025c6:	e8 19 ff ff ff       	call   8024e4 <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 09                	push   $0x9
  8025df:	e8 00 ff ff ff       	call   8024e4 <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 0a                	push   $0xa
  8025f8:	e8 e7 fe ff ff       	call   8024e4 <syscall>
  8025fd:	83 c4 18             	add    $0x18,%esp
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 0b                	push   $0xb
  802611:	e8 ce fe ff ff       	call   8024e4 <syscall>
  802616:	83 c4 18             	add    $0x18,%esp
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	ff 75 0c             	pushl  0xc(%ebp)
  802627:	ff 75 08             	pushl  0x8(%ebp)
  80262a:	6a 0f                	push   $0xf
  80262c:	e8 b3 fe ff ff       	call   8024e4 <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
	return;
  802634:	90                   	nop
}
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	ff 75 0c             	pushl  0xc(%ebp)
  802643:	ff 75 08             	pushl  0x8(%ebp)
  802646:	6a 10                	push   $0x10
  802648:	e8 97 fe ff ff       	call   8024e4 <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
	return ;
  802650:	90                   	nop
}
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	ff 75 10             	pushl  0x10(%ebp)
  80265d:	ff 75 0c             	pushl  0xc(%ebp)
  802660:	ff 75 08             	pushl  0x8(%ebp)
  802663:	6a 11                	push   $0x11
  802665:	e8 7a fe ff ff       	call   8024e4 <syscall>
  80266a:	83 c4 18             	add    $0x18,%esp
	return ;
  80266d:	90                   	nop
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 0c                	push   $0xc
  80267f:	e8 60 fe ff ff       	call   8024e4 <syscall>
  802684:	83 c4 18             	add    $0x18,%esp
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	ff 75 08             	pushl  0x8(%ebp)
  802697:	6a 0d                	push   $0xd
  802699:	e8 46 fe ff ff       	call   8024e4 <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 0e                	push   $0xe
  8026b2:	e8 2d fe ff ff       	call   8024e4 <syscall>
  8026b7:	83 c4 18             	add    $0x18,%esp
}
  8026ba:	90                   	nop
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 13                	push   $0x13
  8026cc:	e8 13 fe ff ff       	call   8024e4 <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	90                   	nop
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 14                	push   $0x14
  8026e6:	e8 f9 fd ff ff       	call   8024e4 <syscall>
  8026eb:	83 c4 18             	add    $0x18,%esp
}
  8026ee:	90                   	nop
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	50                   	push   %eax
  80270a:	6a 15                	push   $0x15
  80270c:	e8 d3 fd ff ff       	call   8024e4 <syscall>
  802711:	83 c4 18             	add    $0x18,%esp
}
  802714:	90                   	nop
  802715:	c9                   	leave  
  802716:	c3                   	ret    

00802717 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 16                	push   $0x16
  802726:	e8 b9 fd ff ff       	call   8024e4 <syscall>
  80272b:	83 c4 18             	add    $0x18,%esp
}
  80272e:	90                   	nop
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	ff 75 0c             	pushl  0xc(%ebp)
  802740:	50                   	push   %eax
  802741:	6a 17                	push   $0x17
  802743:	e8 9c fd ff ff       	call   8024e4 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802750:	8b 55 0c             	mov    0xc(%ebp),%edx
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	52                   	push   %edx
  80275d:	50                   	push   %eax
  80275e:	6a 1a                	push   $0x1a
  802760:	e8 7f fd ff ff       	call   8024e4 <syscall>
  802765:	83 c4 18             	add    $0x18,%esp
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80276d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802770:	8b 45 08             	mov    0x8(%ebp),%eax
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	52                   	push   %edx
  80277a:	50                   	push   %eax
  80277b:	6a 18                	push   $0x18
  80277d:	e8 62 fd ff ff       	call   8024e4 <syscall>
  802782:	83 c4 18             	add    $0x18,%esp
}
  802785:	90                   	nop
  802786:	c9                   	leave  
  802787:	c3                   	ret    

00802788 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802788:	55                   	push   %ebp
  802789:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80278b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	52                   	push   %edx
  802798:	50                   	push   %eax
  802799:	6a 19                	push   $0x19
  80279b:	e8 44 fd ff ff       	call   8024e4 <syscall>
  8027a0:	83 c4 18             	add    $0x18,%esp
}
  8027a3:	90                   	nop
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8027af:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8027b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027b5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bc:	6a 00                	push   $0x0
  8027be:	51                   	push   %ecx
  8027bf:	52                   	push   %edx
  8027c0:	ff 75 0c             	pushl  0xc(%ebp)
  8027c3:	50                   	push   %eax
  8027c4:	6a 1b                	push   $0x1b
  8027c6:	e8 19 fd ff ff       	call   8024e4 <syscall>
  8027cb:	83 c4 18             	add    $0x18,%esp
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	52                   	push   %edx
  8027e0:	50                   	push   %eax
  8027e1:	6a 1c                	push   $0x1c
  8027e3:	e8 fc fc ff ff       	call   8024e4 <syscall>
  8027e8:	83 c4 18             	add    $0x18,%esp
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	51                   	push   %ecx
  8027fe:	52                   	push   %edx
  8027ff:	50                   	push   %eax
  802800:	6a 1d                	push   $0x1d
  802802:	e8 dd fc ff ff       	call   8024e4 <syscall>
  802807:	83 c4 18             	add    $0x18,%esp
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80280f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	52                   	push   %edx
  80281c:	50                   	push   %eax
  80281d:	6a 1e                	push   $0x1e
  80281f:	e8 c0 fc ff ff       	call   8024e4 <syscall>
  802824:	83 c4 18             	add    $0x18,%esp
}
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	6a 1f                	push   $0x1f
  802838:	e8 a7 fc ff ff       	call   8024e4 <syscall>
  80283d:	83 c4 18             	add    $0x18,%esp
}
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802845:	8b 45 08             	mov    0x8(%ebp),%eax
  802848:	6a 00                	push   $0x0
  80284a:	ff 75 14             	pushl  0x14(%ebp)
  80284d:	ff 75 10             	pushl  0x10(%ebp)
  802850:	ff 75 0c             	pushl  0xc(%ebp)
  802853:	50                   	push   %eax
  802854:	6a 20                	push   $0x20
  802856:	e8 89 fc ff ff       	call   8024e4 <syscall>
  80285b:	83 c4 18             	add    $0x18,%esp
}
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	50                   	push   %eax
  80286f:	6a 21                	push   $0x21
  802871:	e8 6e fc ff ff       	call   8024e4 <syscall>
  802876:	83 c4 18             	add    $0x18,%esp
}
  802879:	90                   	nop
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	50                   	push   %eax
  80288b:	6a 22                	push   $0x22
  80288d:	e8 52 fc ff ff       	call   8024e4 <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 02                	push   $0x2
  8028a6:	e8 39 fc ff ff       	call   8024e4 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 03                	push   $0x3
  8028bf:	e8 20 fc ff ff       	call   8024e4 <syscall>
  8028c4:	83 c4 18             	add    $0x18,%esp
}
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 04                	push   $0x4
  8028d8:	e8 07 fc ff ff       	call   8024e4 <syscall>
  8028dd:	83 c4 18             	add    $0x18,%esp
}
  8028e0:	c9                   	leave  
  8028e1:	c3                   	ret    

008028e2 <sys_exit_env>:


void sys_exit_env(void)
{
  8028e2:	55                   	push   %ebp
  8028e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 23                	push   $0x23
  8028f1:	e8 ee fb ff ff       	call   8024e4 <syscall>
  8028f6:	83 c4 18             	add    $0x18,%esp
}
  8028f9:	90                   	nop
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802902:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802905:	8d 50 04             	lea    0x4(%eax),%edx
  802908:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	52                   	push   %edx
  802912:	50                   	push   %eax
  802913:	6a 24                	push   $0x24
  802915:	e8 ca fb ff ff       	call   8024e4 <syscall>
  80291a:	83 c4 18             	add    $0x18,%esp
	return result;
  80291d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802920:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802923:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802926:	89 01                	mov    %eax,(%ecx)
  802928:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	c9                   	leave  
  80292f:	c2 04 00             	ret    $0x4

00802932 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	ff 75 10             	pushl  0x10(%ebp)
  80293c:	ff 75 0c             	pushl  0xc(%ebp)
  80293f:	ff 75 08             	pushl  0x8(%ebp)
  802942:	6a 12                	push   $0x12
  802944:	e8 9b fb ff ff       	call   8024e4 <syscall>
  802949:	83 c4 18             	add    $0x18,%esp
	return ;
  80294c:	90                   	nop
}
  80294d:	c9                   	leave  
  80294e:	c3                   	ret    

0080294f <sys_rcr2>:
uint32 sys_rcr2()
{
  80294f:	55                   	push   %ebp
  802950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802952:	6a 00                	push   $0x0
  802954:	6a 00                	push   $0x0
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 25                	push   $0x25
  80295e:	e8 81 fb ff ff       	call   8024e4 <syscall>
  802963:	83 c4 18             	add    $0x18,%esp
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	83 ec 04             	sub    $0x4,%esp
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802974:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	50                   	push   %eax
  802981:	6a 26                	push   $0x26
  802983:	e8 5c fb ff ff       	call   8024e4 <syscall>
  802988:	83 c4 18             	add    $0x18,%esp
	return ;
  80298b:	90                   	nop
}
  80298c:	c9                   	leave  
  80298d:	c3                   	ret    

0080298e <rsttst>:
void rsttst()
{
  80298e:	55                   	push   %ebp
  80298f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802991:	6a 00                	push   $0x0
  802993:	6a 00                	push   $0x0
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 28                	push   $0x28
  80299d:	e8 42 fb ff ff       	call   8024e4 <syscall>
  8029a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8029a5:	90                   	nop
}
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8029b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8029b4:	8b 55 18             	mov    0x18(%ebp),%edx
  8029b7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029bb:	52                   	push   %edx
  8029bc:	50                   	push   %eax
  8029bd:	ff 75 10             	pushl  0x10(%ebp)
  8029c0:	ff 75 0c             	pushl  0xc(%ebp)
  8029c3:	ff 75 08             	pushl  0x8(%ebp)
  8029c6:	6a 27                	push   $0x27
  8029c8:	e8 17 fb ff ff       	call   8024e4 <syscall>
  8029cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d0:	90                   	nop
}
  8029d1:	c9                   	leave  
  8029d2:	c3                   	ret    

008029d3 <chktst>:
void chktst(uint32 n)
{
  8029d3:	55                   	push   %ebp
  8029d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	ff 75 08             	pushl  0x8(%ebp)
  8029e1:	6a 29                	push   $0x29
  8029e3:	e8 fc fa ff ff       	call   8024e4 <syscall>
  8029e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8029eb:	90                   	nop
}
  8029ec:	c9                   	leave  
  8029ed:	c3                   	ret    

008029ee <inctst>:

void inctst()
{
  8029ee:	55                   	push   %ebp
  8029ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 2a                	push   $0x2a
  8029fd:	e8 e2 fa ff ff       	call   8024e4 <syscall>
  802a02:	83 c4 18             	add    $0x18,%esp
	return ;
  802a05:	90                   	nop
}
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <gettst>:
uint32 gettst()
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a0b:	6a 00                	push   $0x0
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 2b                	push   $0x2b
  802a17:	e8 c8 fa ff ff       	call   8024e4 <syscall>
  802a1c:	83 c4 18             	add    $0x18,%esp
}
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    

00802a21 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a21:	55                   	push   %ebp
  802a22:	89 e5                	mov    %esp,%ebp
  802a24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a27:	6a 00                	push   $0x0
  802a29:	6a 00                	push   $0x0
  802a2b:	6a 00                	push   $0x0
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 2c                	push   $0x2c
  802a33:	e8 ac fa ff ff       	call   8024e4 <syscall>
  802a38:	83 c4 18             	add    $0x18,%esp
  802a3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a3e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a42:	75 07                	jne    802a4b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a44:	b8 01 00 00 00       	mov    $0x1,%eax
  802a49:	eb 05                	jmp    802a50 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a50:	c9                   	leave  
  802a51:	c3                   	ret    

00802a52 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a52:	55                   	push   %ebp
  802a53:	89 e5                	mov    %esp,%ebp
  802a55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 00                	push   $0x0
  802a62:	6a 2c                	push   $0x2c
  802a64:	e8 7b fa ff ff       	call   8024e4 <syscall>
  802a69:	83 c4 18             	add    $0x18,%esp
  802a6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a6f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a73:	75 07                	jne    802a7c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a75:	b8 01 00 00 00       	mov    $0x1,%eax
  802a7a:	eb 05                	jmp    802a81 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a81:	c9                   	leave  
  802a82:	c3                   	ret    

00802a83 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a83:	55                   	push   %ebp
  802a84:	89 e5                	mov    %esp,%ebp
  802a86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a89:	6a 00                	push   $0x0
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 2c                	push   $0x2c
  802a95:	e8 4a fa ff ff       	call   8024e4 <syscall>
  802a9a:	83 c4 18             	add    $0x18,%esp
  802a9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802aa0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802aa4:	75 07                	jne    802aad <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802aa6:	b8 01 00 00 00       	mov    $0x1,%eax
  802aab:	eb 05                	jmp    802ab2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aba:	6a 00                	push   $0x0
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 2c                	push   $0x2c
  802ac6:	e8 19 fa ff ff       	call   8024e4 <syscall>
  802acb:	83 c4 18             	add    $0x18,%esp
  802ace:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ad1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ad5:	75 07                	jne    802ade <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ad7:	b8 01 00 00 00       	mov    $0x1,%eax
  802adc:	eb 05                	jmp    802ae3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ade:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae3:	c9                   	leave  
  802ae4:	c3                   	ret    

00802ae5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ae5:	55                   	push   %ebp
  802ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ae8:	6a 00                	push   $0x0
  802aea:	6a 00                	push   $0x0
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	ff 75 08             	pushl  0x8(%ebp)
  802af3:	6a 2d                	push   $0x2d
  802af5:	e8 ea f9 ff ff       	call   8024e4 <syscall>
  802afa:	83 c4 18             	add    $0x18,%esp
	return ;
  802afd:	90                   	nop
}
  802afe:	c9                   	leave  
  802aff:	c3                   	ret    

00802b00 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b00:	55                   	push   %ebp
  802b01:	89 e5                	mov    %esp,%ebp
  802b03:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b04:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	6a 00                	push   $0x0
  802b12:	53                   	push   %ebx
  802b13:	51                   	push   %ecx
  802b14:	52                   	push   %edx
  802b15:	50                   	push   %eax
  802b16:	6a 2e                	push   $0x2e
  802b18:	e8 c7 f9 ff ff       	call   8024e4 <syscall>
  802b1d:	83 c4 18             	add    $0x18,%esp
}
  802b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b23:	c9                   	leave  
  802b24:	c3                   	ret    

00802b25 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b25:	55                   	push   %ebp
  802b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	6a 00                	push   $0x0
  802b30:	6a 00                	push   $0x0
  802b32:	6a 00                	push   $0x0
  802b34:	52                   	push   %edx
  802b35:	50                   	push   %eax
  802b36:	6a 2f                	push   $0x2f
  802b38:	e8 a7 f9 ff ff       	call   8024e4 <syscall>
  802b3d:	83 c4 18             	add    $0x18,%esp
}
  802b40:	c9                   	leave  
  802b41:	c3                   	ret    

00802b42 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802b42:	55                   	push   %ebp
  802b43:	89 e5                	mov    %esp,%ebp
  802b45:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802b48:	83 ec 0c             	sub    $0xc,%esp
  802b4b:	68 5c 47 80 00       	push   $0x80475c
  802b50:	e8 c7 e6 ff ff       	call   80121c <cprintf>
  802b55:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802b58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802b5f:	83 ec 0c             	sub    $0xc,%esp
  802b62:	68 88 47 80 00       	push   $0x804788
  802b67:	e8 b0 e6 ff ff       	call   80121c <cprintf>
  802b6c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802b6f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b73:	a1 38 51 80 00       	mov    0x805138,%eax
  802b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b7b:	eb 56                	jmp    802bd3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b81:	74 1c                	je     802b9f <print_mem_block_lists+0x5d>
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 50 08             	mov    0x8(%eax),%edx
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 48 08             	mov    0x8(%eax),%ecx
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 40 0c             	mov    0xc(%eax),%eax
  802b95:	01 c8                	add    %ecx,%eax
  802b97:	39 c2                	cmp    %eax,%edx
  802b99:	73 04                	jae    802b9f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802b9b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 50 08             	mov    0x8(%eax),%edx
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bab:	01 c2                	add    %eax,%edx
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 40 08             	mov    0x8(%eax),%eax
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	52                   	push   %edx
  802bb7:	50                   	push   %eax
  802bb8:	68 9d 47 80 00       	push   $0x80479d
  802bbd:	e8 5a e6 ff ff       	call   80121c <cprintf>
  802bc2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bcb:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd7:	74 07                	je     802be0 <print_mem_block_lists+0x9e>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	eb 05                	jmp    802be5 <print_mem_block_lists+0xa3>
  802be0:	b8 00 00 00 00       	mov    $0x0,%eax
  802be5:	a3 40 51 80 00       	mov    %eax,0x805140
  802bea:	a1 40 51 80 00       	mov    0x805140,%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	75 8a                	jne    802b7d <print_mem_block_lists+0x3b>
  802bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf7:	75 84                	jne    802b7d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802bf9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802bfd:	75 10                	jne    802c0f <print_mem_block_lists+0xcd>
  802bff:	83 ec 0c             	sub    $0xc,%esp
  802c02:	68 ac 47 80 00       	push   $0x8047ac
  802c07:	e8 10 e6 ff ff       	call   80121c <cprintf>
  802c0c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802c16:	83 ec 0c             	sub    $0xc,%esp
  802c19:	68 d0 47 80 00       	push   $0x8047d0
  802c1e:	e8 f9 e5 ff ff       	call   80121c <cprintf>
  802c23:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802c26:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c2a:	a1 40 50 80 00       	mov    0x805040,%eax
  802c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c32:	eb 56                	jmp    802c8a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802c34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c38:	74 1c                	je     802c56 <print_mem_block_lists+0x114>
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 50 08             	mov    0x8(%eax),%edx
  802c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c43:	8b 48 08             	mov    0x8(%eax),%ecx
  802c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c49:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4c:	01 c8                	add    %ecx,%eax
  802c4e:	39 c2                	cmp    %eax,%edx
  802c50:	73 04                	jae    802c56 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802c52:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 50 08             	mov    0x8(%eax),%edx
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	01 c2                	add    %eax,%edx
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 40 08             	mov    0x8(%eax),%eax
  802c6a:	83 ec 04             	sub    $0x4,%esp
  802c6d:	52                   	push   %edx
  802c6e:	50                   	push   %eax
  802c6f:	68 9d 47 80 00       	push   $0x80479d
  802c74:	e8 a3 e5 ff ff       	call   80121c <cprintf>
  802c79:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c82:	a1 48 50 80 00       	mov    0x805048,%eax
  802c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8e:	74 07                	je     802c97 <print_mem_block_lists+0x155>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	eb 05                	jmp    802c9c <print_mem_block_lists+0x15a>
  802c97:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9c:	a3 48 50 80 00       	mov    %eax,0x805048
  802ca1:	a1 48 50 80 00       	mov    0x805048,%eax
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	75 8a                	jne    802c34 <print_mem_block_lists+0xf2>
  802caa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cae:	75 84                	jne    802c34 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802cb0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802cb4:	75 10                	jne    802cc6 <print_mem_block_lists+0x184>
  802cb6:	83 ec 0c             	sub    $0xc,%esp
  802cb9:	68 e8 47 80 00       	push   $0x8047e8
  802cbe:	e8 59 e5 ff ff       	call   80121c <cprintf>
  802cc3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802cc6:	83 ec 0c             	sub    $0xc,%esp
  802cc9:	68 5c 47 80 00       	push   $0x80475c
  802cce:	e8 49 e5 ff ff       	call   80121c <cprintf>
  802cd3:	83 c4 10             	add    $0x10,%esp

}
  802cd6:	90                   	nop
  802cd7:	c9                   	leave  
  802cd8:	c3                   	ret    

00802cd9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802cd9:	55                   	push   %ebp
  802cda:	89 e5                	mov    %esp,%ebp
  802cdc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  802cdf:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802ce6:	00 00 00 
  802ce9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802cf0:	00 00 00 
  802cf3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802cfa:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  802cfd:	a1 50 50 80 00       	mov    0x805050,%eax
  802d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  802d05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d0c:	e9 9e 00 00 00       	jmp    802daf <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802d11:	a1 50 50 80 00       	mov    0x805050,%eax
  802d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d19:	c1 e2 04             	shl    $0x4,%edx
  802d1c:	01 d0                	add    %edx,%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	75 14                	jne    802d36 <initialize_MemBlocksList+0x5d>
  802d22:	83 ec 04             	sub    $0x4,%esp
  802d25:	68 10 48 80 00       	push   $0x804810
  802d2a:	6a 48                	push   $0x48
  802d2c:	68 33 48 80 00       	push   $0x804833
  802d31:	e8 32 e2 ff ff       	call   800f68 <_panic>
  802d36:	a1 50 50 80 00       	mov    0x805050,%eax
  802d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3e:	c1 e2 04             	shl    $0x4,%edx
  802d41:	01 d0                	add    %edx,%eax
  802d43:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	74 18                	je     802d69 <initialize_MemBlocksList+0x90>
  802d51:	a1 48 51 80 00       	mov    0x805148,%eax
  802d56:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802d5c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d5f:	c1 e1 04             	shl    $0x4,%ecx
  802d62:	01 ca                	add    %ecx,%edx
  802d64:	89 50 04             	mov    %edx,0x4(%eax)
  802d67:	eb 12                	jmp    802d7b <initialize_MemBlocksList+0xa2>
  802d69:	a1 50 50 80 00       	mov    0x805050,%eax
  802d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d71:	c1 e2 04             	shl    $0x4,%edx
  802d74:	01 d0                	add    %edx,%eax
  802d76:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d7b:	a1 50 50 80 00       	mov    0x805050,%eax
  802d80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d83:	c1 e2 04             	shl    $0x4,%edx
  802d86:	01 d0                	add    %edx,%eax
  802d88:	a3 48 51 80 00       	mov    %eax,0x805148
  802d8d:	a1 50 50 80 00       	mov    0x805050,%eax
  802d92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d95:	c1 e2 04             	shl    $0x4,%edx
  802d98:	01 d0                	add    %edx,%eax
  802d9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da1:	a1 54 51 80 00       	mov    0x805154,%eax
  802da6:	40                   	inc    %eax
  802da7:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  802dac:	ff 45 f4             	incl   -0xc(%ebp)
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db5:	0f 82 56 ff ff ff    	jb     802d11 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  802dbb:	90                   	nop
  802dbc:	c9                   	leave  
  802dbd:	c3                   	ret    

00802dbe <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802dbe:	55                   	push   %ebp
  802dbf:	89 e5                	mov    %esp,%ebp
  802dc1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  802dcc:	eb 18                	jmp    802de6 <find_block+0x28>
		{
			if(tmp->sva==va)
  802dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dd1:	8b 40 08             	mov    0x8(%eax),%eax
  802dd4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dd7:	75 05                	jne    802dde <find_block+0x20>
			{
				return tmp;
  802dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ddc:	eb 11                	jmp    802def <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  802dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  802de6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802dea:	75 e2                	jne    802dce <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  802dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  802def:	c9                   	leave  
  802df0:	c3                   	ret    

00802df1 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802df1:	55                   	push   %ebp
  802df2:	89 e5                	mov    %esp,%ebp
  802df4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  802df7:	a1 40 50 80 00       	mov    0x805040,%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	0f 85 83 00 00 00    	jne    802e87 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  802e04:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802e0b:	00 00 00 
  802e0e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802e15:	00 00 00 
  802e18:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802e1f:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802e22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e26:	75 14                	jne    802e3c <insert_sorted_allocList+0x4b>
  802e28:	83 ec 04             	sub    $0x4,%esp
  802e2b:	68 10 48 80 00       	push   $0x804810
  802e30:	6a 7f                	push   $0x7f
  802e32:	68 33 48 80 00       	push   $0x804833
  802e37:	e8 2c e1 ff ff       	call   800f68 <_panic>
  802e3c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	89 10                	mov    %edx,(%eax)
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0d                	je     802e5d <insert_sorted_allocList+0x6c>
  802e50:	a1 40 50 80 00       	mov    0x805040,%eax
  802e55:	8b 55 08             	mov    0x8(%ebp),%edx
  802e58:	89 50 04             	mov    %edx,0x4(%eax)
  802e5b:	eb 08                	jmp    802e65 <insert_sorted_allocList+0x74>
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	a3 44 50 80 00       	mov    %eax,0x805044
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	a3 40 50 80 00       	mov    %eax,0x805040
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e77:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e7c:	40                   	inc    %eax
  802e7d:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802e82:	e9 16 01 00 00       	jmp    802f9d <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	a1 44 50 80 00       	mov    0x805044,%eax
  802e92:	8b 40 08             	mov    0x8(%eax),%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	76 68                	jbe    802f01 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  802e99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9d:	75 17                	jne    802eb6 <insert_sorted_allocList+0xc5>
  802e9f:	83 ec 04             	sub    $0x4,%esp
  802ea2:	68 4c 48 80 00       	push   $0x80484c
  802ea7:	68 85 00 00 00       	push   $0x85
  802eac:	68 33 48 80 00       	push   $0x804833
  802eb1:	e8 b2 e0 ff ff       	call   800f68 <_panic>
  802eb6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	89 50 04             	mov    %edx,0x4(%eax)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 40 04             	mov    0x4(%eax),%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 0c                	je     802ed8 <insert_sorted_allocList+0xe7>
  802ecc:	a1 44 50 80 00       	mov    0x805044,%eax
  802ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed4:	89 10                	mov    %edx,(%eax)
  802ed6:	eb 08                	jmp    802ee0 <insert_sorted_allocList+0xef>
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 40 50 80 00       	mov    %eax,0x805040
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	a3 44 50 80 00       	mov    %eax,0x805044
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ef6:	40                   	inc    %eax
  802ef7:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802efc:	e9 9c 00 00 00       	jmp    802f9d <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  802f01:	a1 40 50 80 00       	mov    0x805040,%eax
  802f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  802f09:	e9 85 00 00 00       	jmp    802f93 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 50 08             	mov    0x8(%eax),%edx
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 08             	mov    0x8(%eax),%eax
  802f1a:	39 c2                	cmp    %eax,%edx
  802f1c:	73 6d                	jae    802f8b <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  802f1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f22:	74 06                	je     802f2a <insert_sorted_allocList+0x139>
  802f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f28:	75 17                	jne    802f41 <insert_sorted_allocList+0x150>
  802f2a:	83 ec 04             	sub    $0x4,%esp
  802f2d:	68 70 48 80 00       	push   $0x804870
  802f32:	68 90 00 00 00       	push   $0x90
  802f37:	68 33 48 80 00       	push   $0x804833
  802f3c:	e8 27 e0 ff ff       	call   800f68 <_panic>
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 50 04             	mov    0x4(%eax),%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	89 50 04             	mov    %edx,0x4(%eax)
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f53:	89 10                	mov    %edx,(%eax)
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 40 04             	mov    0x4(%eax),%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	74 0d                	je     802f6c <insert_sorted_allocList+0x17b>
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 40 04             	mov    0x4(%eax),%eax
  802f65:	8b 55 08             	mov    0x8(%ebp),%edx
  802f68:	89 10                	mov    %edx,(%eax)
  802f6a:	eb 08                	jmp    802f74 <insert_sorted_allocList+0x183>
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	a3 40 50 80 00       	mov    %eax,0x805040
  802f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f77:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f82:	40                   	inc    %eax
  802f83:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802f88:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802f89:	eb 12                	jmp    802f9d <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  802f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f97:	0f 85 71 ff ff ff    	jne    802f0e <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  802f9d:	90                   	nop
  802f9e:	c9                   	leave  
  802f9f:	c3                   	ret    

00802fa0 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  802fa0:	55                   	push   %ebp
  802fa1:	89 e5                	mov    %esp,%ebp
  802fa3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  802fa6:	a1 38 51 80 00       	mov    0x805138,%eax
  802fab:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  802fae:	e9 76 01 00 00       	jmp    803129 <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fbc:	0f 85 8a 00 00 00    	jne    80304c <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  802fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc6:	75 17                	jne    802fdf <alloc_block_FF+0x3f>
  802fc8:	83 ec 04             	sub    $0x4,%esp
  802fcb:	68 a5 48 80 00       	push   $0x8048a5
  802fd0:	68 a8 00 00 00       	push   $0xa8
  802fd5:	68 33 48 80 00       	push   $0x804833
  802fda:	e8 89 df ff ff       	call   800f68 <_panic>
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	85 c0                	test   %eax,%eax
  802fe6:	74 10                	je     802ff8 <alloc_block_FF+0x58>
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff0:	8b 52 04             	mov    0x4(%edx),%edx
  802ff3:	89 50 04             	mov    %edx,0x4(%eax)
  802ff6:	eb 0b                	jmp    803003 <alloc_block_FF+0x63>
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 40 04             	mov    0x4(%eax),%eax
  802ffe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 40 04             	mov    0x4(%eax),%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	74 0f                	je     80301c <alloc_block_FF+0x7c>
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803016:	8b 12                	mov    (%edx),%edx
  803018:	89 10                	mov    %edx,(%eax)
  80301a:	eb 0a                	jmp    803026 <alloc_block_FF+0x86>
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	a3 38 51 80 00       	mov    %eax,0x805138
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803039:	a1 44 51 80 00       	mov    0x805144,%eax
  80303e:	48                   	dec    %eax
  80303f:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	e9 ea 00 00 00       	jmp    803136 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	8b 40 0c             	mov    0xc(%eax),%eax
  803052:	3b 45 08             	cmp    0x8(%ebp),%eax
  803055:	0f 86 c6 00 00 00    	jbe    803121 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80305b:	a1 48 51 80 00       	mov    0x805148,%eax
  803060:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  803063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803066:	8b 55 08             	mov    0x8(%ebp),%edx
  803069:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 50 08             	mov    0x8(%eax),%edx
  803072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803075:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	8b 40 0c             	mov    0xc(%eax),%eax
  80307e:	2b 45 08             	sub    0x8(%ebp),%eax
  803081:	89 c2                	mov    %eax,%edx
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 50 08             	mov    0x8(%eax),%edx
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	01 c2                	add    %eax,%edx
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80309a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80309e:	75 17                	jne    8030b7 <alloc_block_FF+0x117>
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	68 a5 48 80 00       	push   $0x8048a5
  8030a8:	68 b6 00 00 00       	push   $0xb6
  8030ad:	68 33 48 80 00       	push   $0x804833
  8030b2:	e8 b1 de ff ff       	call   800f68 <_panic>
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	74 10                	je     8030d0 <alloc_block_FF+0x130>
  8030c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c8:	8b 52 04             	mov    0x4(%edx),%edx
  8030cb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ce:	eb 0b                	jmp    8030db <alloc_block_FF+0x13b>
  8030d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d3:	8b 40 04             	mov    0x4(%eax),%eax
  8030d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030de:	8b 40 04             	mov    0x4(%eax),%eax
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	74 0f                	je     8030f4 <alloc_block_FF+0x154>
  8030e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ee:	8b 12                	mov    (%edx),%edx
  8030f0:	89 10                	mov    %edx,(%eax)
  8030f2:	eb 0a                	jmp    8030fe <alloc_block_FF+0x15e>
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8030fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803101:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803111:	a1 54 51 80 00       	mov    0x805154,%eax
  803116:	48                   	dec    %eax
  803117:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  80311c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311f:	eb 15                	jmp    803136 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  803129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312d:	0f 85 80 fe ff ff    	jne    802fb3 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803136:	c9                   	leave  
  803137:	c3                   	ret    

00803138 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803138:	55                   	push   %ebp
  803139:	89 e5                	mov    %esp,%ebp
  80313b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  80313e:	a1 38 51 80 00       	mov    0x805138,%eax
  803143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  803146:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80314d:	e9 c0 00 00 00       	jmp    803212 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 40 0c             	mov    0xc(%eax),%eax
  803158:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315b:	0f 85 8a 00 00 00    	jne    8031eb <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803165:	75 17                	jne    80317e <alloc_block_BF+0x46>
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	68 a5 48 80 00       	push   $0x8048a5
  80316f:	68 cf 00 00 00       	push   $0xcf
  803174:	68 33 48 80 00       	push   $0x804833
  803179:	e8 ea dd ff ff       	call   800f68 <_panic>
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 10                	je     803197 <alloc_block_BF+0x5f>
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80318f:	8b 52 04             	mov    0x4(%edx),%edx
  803192:	89 50 04             	mov    %edx,0x4(%eax)
  803195:	eb 0b                	jmp    8031a2 <alloc_block_BF+0x6a>
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	8b 40 04             	mov    0x4(%eax),%eax
  80319d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a5:	8b 40 04             	mov    0x4(%eax),%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	74 0f                	je     8031bb <alloc_block_BF+0x83>
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 40 04             	mov    0x4(%eax),%eax
  8031b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b5:	8b 12                	mov    (%edx),%edx
  8031b7:	89 10                	mov    %edx,(%eax)
  8031b9:	eb 0a                	jmp    8031c5 <alloc_block_BF+0x8d>
  8031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031be:	8b 00                	mov    (%eax),%eax
  8031c0:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031dd:	48                   	dec    %eax
  8031de:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	e9 2a 01 00 00       	jmp    803315 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031f4:	73 14                	jae    80320a <alloc_block_BF+0xd2>
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ff:	76 09                	jbe    80320a <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 40 0c             	mov    0xc(%eax),%eax
  803207:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 00                	mov    (%eax),%eax
  80320f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  803212:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803216:	0f 85 36 ff ff ff    	jne    803152 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80321c:	a1 38 51 80 00       	mov    0x805138,%eax
  803221:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  803224:	e9 dd 00 00 00       	jmp    803306 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 40 0c             	mov    0xc(%eax),%eax
  80322f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803232:	0f 85 c6 00 00 00    	jne    8032fe <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803238:	a1 48 51 80 00       	mov    0x805148,%eax
  80323d:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  803240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803243:	8b 50 08             	mov    0x8(%eax),%edx
  803246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803249:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80324c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324f:	8b 55 08             	mov    0x8(%ebp),%edx
  803252:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  803255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803258:	8b 50 08             	mov    0x8(%eax),%edx
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	01 c2                	add    %eax,%edx
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 40 0c             	mov    0xc(%eax),%eax
  80326c:	2b 45 08             	sub    0x8(%ebp),%eax
  80326f:	89 c2                	mov    %eax,%edx
  803271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803274:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803277:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80327b:	75 17                	jne    803294 <alloc_block_BF+0x15c>
  80327d:	83 ec 04             	sub    $0x4,%esp
  803280:	68 a5 48 80 00       	push   $0x8048a5
  803285:	68 eb 00 00 00       	push   $0xeb
  80328a:	68 33 48 80 00       	push   $0x804833
  80328f:	e8 d4 dc ff ff       	call   800f68 <_panic>
  803294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	85 c0                	test   %eax,%eax
  80329b:	74 10                	je     8032ad <alloc_block_BF+0x175>
  80329d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032a5:	8b 52 04             	mov    0x4(%edx),%edx
  8032a8:	89 50 04             	mov    %edx,0x4(%eax)
  8032ab:	eb 0b                	jmp    8032b8 <alloc_block_BF+0x180>
  8032ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b0:	8b 40 04             	mov    0x4(%eax),%eax
  8032b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bb:	8b 40 04             	mov    0x4(%eax),%eax
  8032be:	85 c0                	test   %eax,%eax
  8032c0:	74 0f                	je     8032d1 <alloc_block_BF+0x199>
  8032c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c5:	8b 40 04             	mov    0x4(%eax),%eax
  8032c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032cb:	8b 12                	mov    (%edx),%edx
  8032cd:	89 10                	mov    %edx,(%eax)
  8032cf:	eb 0a                	jmp    8032db <alloc_block_BF+0x1a3>
  8032d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	a3 48 51 80 00       	mov    %eax,0x805148
  8032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ee:	a1 54 51 80 00       	mov    0x805154,%eax
  8032f3:	48                   	dec    %eax
  8032f4:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  8032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fc:	eb 17                	jmp    803315 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  803306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330a:	0f 85 19 ff ff ff    	jne    803229 <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  803310:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803315:	c9                   	leave  
  803316:	c3                   	ret    

00803317 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  803317:	55                   	push   %ebp
  803318:	89 e5                	mov    %esp,%ebp
  80331a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80331d:	a1 40 50 80 00       	mov    0x805040,%eax
  803322:	85 c0                	test   %eax,%eax
  803324:	75 19                	jne    80333f <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  803326:	83 ec 0c             	sub    $0xc,%esp
  803329:	ff 75 08             	pushl  0x8(%ebp)
  80332c:	e8 6f fc ff ff       	call   802fa0 <alloc_block_FF>
  803331:	83 c4 10             	add    $0x10,%esp
  803334:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  803337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333a:	e9 e9 01 00 00       	jmp    803528 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  80333f:	a1 44 50 80 00       	mov    0x805044,%eax
  803344:	8b 40 08             	mov    0x8(%eax),%eax
  803347:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80334a:	a1 44 50 80 00       	mov    0x805044,%eax
  80334f:	8b 50 0c             	mov    0xc(%eax),%edx
  803352:	a1 44 50 80 00       	mov    0x805044,%eax
  803357:	8b 40 08             	mov    0x8(%eax),%eax
  80335a:	01 d0                	add    %edx,%eax
  80335c:	83 ec 08             	sub    $0x8,%esp
  80335f:	50                   	push   %eax
  803360:	68 38 51 80 00       	push   $0x805138
  803365:	e8 54 fa ff ff       	call   802dbe <find_block>
  80336a:	83 c4 10             	add    $0x10,%esp
  80336d:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 40 0c             	mov    0xc(%eax),%eax
  803376:	3b 45 08             	cmp    0x8(%ebp),%eax
  803379:	0f 85 9b 00 00 00    	jne    80341a <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	8b 50 0c             	mov    0xc(%eax),%edx
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 40 08             	mov    0x8(%eax),%eax
  80338b:	01 d0                	add    %edx,%eax
  80338d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  803390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803394:	75 17                	jne    8033ad <alloc_block_NF+0x96>
  803396:	83 ec 04             	sub    $0x4,%esp
  803399:	68 a5 48 80 00       	push   $0x8048a5
  80339e:	68 1a 01 00 00       	push   $0x11a
  8033a3:	68 33 48 80 00       	push   $0x804833
  8033a8:	e8 bb db ff ff       	call   800f68 <_panic>
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	8b 00                	mov    (%eax),%eax
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	74 10                	je     8033c6 <alloc_block_NF+0xaf>
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033be:	8b 52 04             	mov    0x4(%edx),%edx
  8033c1:	89 50 04             	mov    %edx,0x4(%eax)
  8033c4:	eb 0b                	jmp    8033d1 <alloc_block_NF+0xba>
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 40 04             	mov    0x4(%eax),%eax
  8033cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	8b 40 04             	mov    0x4(%eax),%eax
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	74 0f                	je     8033ea <alloc_block_NF+0xd3>
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	8b 40 04             	mov    0x4(%eax),%eax
  8033e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e4:	8b 12                	mov    (%edx),%edx
  8033e6:	89 10                	mov    %edx,(%eax)
  8033e8:	eb 0a                	jmp    8033f4 <alloc_block_NF+0xdd>
  8033ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ed:	8b 00                	mov    (%eax),%eax
  8033ef:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803400:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803407:	a1 44 51 80 00       	mov    0x805144,%eax
  80340c:	48                   	dec    %eax
  80340d:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	e9 0e 01 00 00       	jmp    803528 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	8b 40 0c             	mov    0xc(%eax),%eax
  803420:	3b 45 08             	cmp    0x8(%ebp),%eax
  803423:	0f 86 cf 00 00 00    	jbe    8034f8 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803429:	a1 48 51 80 00       	mov    0x805148,%eax
  80342e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  803431:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803434:	8b 55 08             	mov    0x8(%ebp),%edx
  803437:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	8b 50 08             	mov    0x8(%eax),%edx
  803440:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803443:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	8b 50 08             	mov    0x8(%eax),%edx
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	01 c2                	add    %eax,%edx
  803451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803454:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	8b 40 0c             	mov    0xc(%eax),%eax
  80345d:	2b 45 08             	sub    0x8(%ebp),%eax
  803460:	89 c2                	mov    %eax,%edx
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 40 08             	mov    0x8(%eax),%eax
  80346e:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803471:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803475:	75 17                	jne    80348e <alloc_block_NF+0x177>
  803477:	83 ec 04             	sub    $0x4,%esp
  80347a:	68 a5 48 80 00       	push   $0x8048a5
  80347f:	68 28 01 00 00       	push   $0x128
  803484:	68 33 48 80 00       	push   $0x804833
  803489:	e8 da da ff ff       	call   800f68 <_panic>
  80348e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803491:	8b 00                	mov    (%eax),%eax
  803493:	85 c0                	test   %eax,%eax
  803495:	74 10                	je     8034a7 <alloc_block_NF+0x190>
  803497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80349f:	8b 52 04             	mov    0x4(%edx),%edx
  8034a2:	89 50 04             	mov    %edx,0x4(%eax)
  8034a5:	eb 0b                	jmp    8034b2 <alloc_block_NF+0x19b>
  8034a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034aa:	8b 40 04             	mov    0x4(%eax),%eax
  8034ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b5:	8b 40 04             	mov    0x4(%eax),%eax
  8034b8:	85 c0                	test   %eax,%eax
  8034ba:	74 0f                	je     8034cb <alloc_block_NF+0x1b4>
  8034bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034bf:	8b 40 04             	mov    0x4(%eax),%eax
  8034c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034c5:	8b 12                	mov    (%edx),%edx
  8034c7:	89 10                	mov    %edx,(%eax)
  8034c9:	eb 0a                	jmp    8034d5 <alloc_block_NF+0x1be>
  8034cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8034d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ed:	48                   	dec    %eax
  8034ee:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  8034f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f6:	eb 30                	jmp    803528 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8034f8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803500:	75 0a                	jne    80350c <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  803502:	a1 38 51 80 00       	mov    0x805138,%eax
  803507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350a:	eb 08                	jmp    803514 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80350c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350f:	8b 00                	mov    (%eax),%eax
  803511:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	8b 40 08             	mov    0x8(%eax),%eax
  80351a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80351d:	0f 85 4d fe ff ff    	jne    803370 <alloc_block_NF+0x59>

			return NULL;
  803523:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  803528:	c9                   	leave  
  803529:	c3                   	ret    

0080352a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80352a:	55                   	push   %ebp
  80352b:	89 e5                	mov    %esp,%ebp
  80352d:	53                   	push   %ebx
  80352e:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  803531:	a1 38 51 80 00       	mov    0x805138,%eax
  803536:	85 c0                	test   %eax,%eax
  803538:	0f 85 86 00 00 00    	jne    8035c4 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  80353e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803545:	00 00 00 
  803548:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80354f:	00 00 00 
  803552:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  803559:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80355c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803560:	75 17                	jne    803579 <insert_sorted_with_merge_freeList+0x4f>
  803562:	83 ec 04             	sub    $0x4,%esp
  803565:	68 10 48 80 00       	push   $0x804810
  80356a:	68 48 01 00 00       	push   $0x148
  80356f:	68 33 48 80 00       	push   $0x804833
  803574:	e8 ef d9 ff ff       	call   800f68 <_panic>
  803579:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	89 10                	mov    %edx,(%eax)
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	85 c0                	test   %eax,%eax
  80358b:	74 0d                	je     80359a <insert_sorted_with_merge_freeList+0x70>
  80358d:	a1 38 51 80 00       	mov    0x805138,%eax
  803592:	8b 55 08             	mov    0x8(%ebp),%edx
  803595:	89 50 04             	mov    %edx,0x4(%eax)
  803598:	eb 08                	jmp    8035a2 <insert_sorted_with_merge_freeList+0x78>
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b4:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b9:	40                   	inc    %eax
  8035ba:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8035bf:	e9 73 07 00 00       	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	8b 50 08             	mov    0x8(%eax),%edx
  8035ca:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035cf:	8b 40 08             	mov    0x8(%eax),%eax
  8035d2:	39 c2                	cmp    %eax,%edx
  8035d4:	0f 86 84 00 00 00    	jbe    80365e <insert_sorted_with_merge_freeList+0x134>
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	8b 50 08             	mov    0x8(%eax),%edx
  8035e0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035e5:	8b 48 0c             	mov    0xc(%eax),%ecx
  8035e8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035ed:	8b 40 08             	mov    0x8(%eax),%eax
  8035f0:	01 c8                	add    %ecx,%eax
  8035f2:	39 c2                	cmp    %eax,%edx
  8035f4:	74 68                	je     80365e <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  8035f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035fa:	75 17                	jne    803613 <insert_sorted_with_merge_freeList+0xe9>
  8035fc:	83 ec 04             	sub    $0x4,%esp
  8035ff:	68 4c 48 80 00       	push   $0x80484c
  803604:	68 4c 01 00 00       	push   $0x14c
  803609:	68 33 48 80 00       	push   $0x804833
  80360e:	e8 55 d9 ff ff       	call   800f68 <_panic>
  803613:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	89 50 04             	mov    %edx,0x4(%eax)
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	8b 40 04             	mov    0x4(%eax),%eax
  803625:	85 c0                	test   %eax,%eax
  803627:	74 0c                	je     803635 <insert_sorted_with_merge_freeList+0x10b>
  803629:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80362e:	8b 55 08             	mov    0x8(%ebp),%edx
  803631:	89 10                	mov    %edx,(%eax)
  803633:	eb 08                	jmp    80363d <insert_sorted_with_merge_freeList+0x113>
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	a3 38 51 80 00       	mov    %eax,0x805138
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80364e:	a1 44 51 80 00       	mov    0x805144,%eax
  803653:	40                   	inc    %eax
  803654:	a3 44 51 80 00       	mov    %eax,0x805144
  803659:	e9 d9 06 00 00       	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	8b 50 08             	mov    0x8(%eax),%edx
  803664:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803669:	8b 40 08             	mov    0x8(%eax),%eax
  80366c:	39 c2                	cmp    %eax,%edx
  80366e:	0f 86 b5 00 00 00    	jbe    803729 <insert_sorted_with_merge_freeList+0x1ff>
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	8b 50 08             	mov    0x8(%eax),%edx
  80367a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80367f:	8b 48 0c             	mov    0xc(%eax),%ecx
  803682:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803687:	8b 40 08             	mov    0x8(%eax),%eax
  80368a:	01 c8                	add    %ecx,%eax
  80368c:	39 c2                	cmp    %eax,%edx
  80368e:	0f 85 95 00 00 00    	jne    803729 <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803694:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803699:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80369f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8036a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a5:	8b 52 0c             	mov    0xc(%edx),%edx
  8036a8:	01 ca                	add    %ecx,%edx
  8036aa:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c5:	75 17                	jne    8036de <insert_sorted_with_merge_freeList+0x1b4>
  8036c7:	83 ec 04             	sub    $0x4,%esp
  8036ca:	68 10 48 80 00       	push   $0x804810
  8036cf:	68 54 01 00 00       	push   $0x154
  8036d4:	68 33 48 80 00       	push   $0x804833
  8036d9:	e8 8a d8 ff ff       	call   800f68 <_panic>
  8036de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	89 10                	mov    %edx,(%eax)
  8036e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ec:	8b 00                	mov    (%eax),%eax
  8036ee:	85 c0                	test   %eax,%eax
  8036f0:	74 0d                	je     8036ff <insert_sorted_with_merge_freeList+0x1d5>
  8036f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8036f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8036fa:	89 50 04             	mov    %edx,0x4(%eax)
  8036fd:	eb 08                	jmp    803707 <insert_sorted_with_merge_freeList+0x1dd>
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	a3 48 51 80 00       	mov    %eax,0x805148
  80370f:	8b 45 08             	mov    0x8(%ebp),%eax
  803712:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803719:	a1 54 51 80 00       	mov    0x805154,%eax
  80371e:	40                   	inc    %eax
  80371f:	a3 54 51 80 00       	mov    %eax,0x805154
  803724:	e9 0e 06 00 00       	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	8b 50 08             	mov    0x8(%eax),%edx
  80372f:	a1 38 51 80 00       	mov    0x805138,%eax
  803734:	8b 40 08             	mov    0x8(%eax),%eax
  803737:	39 c2                	cmp    %eax,%edx
  803739:	0f 83 c1 00 00 00    	jae    803800 <insert_sorted_with_merge_freeList+0x2d6>
  80373f:	a1 38 51 80 00       	mov    0x805138,%eax
  803744:	8b 50 08             	mov    0x8(%eax),%edx
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	8b 48 08             	mov    0x8(%eax),%ecx
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	8b 40 0c             	mov    0xc(%eax),%eax
  803753:	01 c8                	add    %ecx,%eax
  803755:	39 c2                	cmp    %eax,%edx
  803757:	0f 85 a3 00 00 00    	jne    803800 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80375d:	a1 38 51 80 00       	mov    0x805138,%eax
  803762:	8b 55 08             	mov    0x8(%ebp),%edx
  803765:	8b 52 08             	mov    0x8(%edx),%edx
  803768:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80376b:	a1 38 51 80 00       	mov    0x805138,%eax
  803770:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803776:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803779:	8b 55 08             	mov    0x8(%ebp),%edx
  80377c:	8b 52 0c             	mov    0xc(%edx),%edx
  80377f:	01 ca                	add    %ecx,%edx
  803781:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  80378e:	8b 45 08             	mov    0x8(%ebp),%eax
  803791:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803798:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80379c:	75 17                	jne    8037b5 <insert_sorted_with_merge_freeList+0x28b>
  80379e:	83 ec 04             	sub    $0x4,%esp
  8037a1:	68 10 48 80 00       	push   $0x804810
  8037a6:	68 5d 01 00 00       	push   $0x15d
  8037ab:	68 33 48 80 00       	push   $0x804833
  8037b0:	e8 b3 d7 ff ff       	call   800f68 <_panic>
  8037b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	89 10                	mov    %edx,(%eax)
  8037c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c3:	8b 00                	mov    (%eax),%eax
  8037c5:	85 c0                	test   %eax,%eax
  8037c7:	74 0d                	je     8037d6 <insert_sorted_with_merge_freeList+0x2ac>
  8037c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8037ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d1:	89 50 04             	mov    %edx,0x4(%eax)
  8037d4:	eb 08                	jmp    8037de <insert_sorted_with_merge_freeList+0x2b4>
  8037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8037f5:	40                   	inc    %eax
  8037f6:	a3 54 51 80 00       	mov    %eax,0x805154
  8037fb:	e9 37 05 00 00       	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  803800:	8b 45 08             	mov    0x8(%ebp),%eax
  803803:	8b 50 08             	mov    0x8(%eax),%edx
  803806:	a1 38 51 80 00       	mov    0x805138,%eax
  80380b:	8b 40 08             	mov    0x8(%eax),%eax
  80380e:	39 c2                	cmp    %eax,%edx
  803810:	0f 83 82 00 00 00    	jae    803898 <insert_sorted_with_merge_freeList+0x36e>
  803816:	a1 38 51 80 00       	mov    0x805138,%eax
  80381b:	8b 50 08             	mov    0x8(%eax),%edx
  80381e:	8b 45 08             	mov    0x8(%ebp),%eax
  803821:	8b 48 08             	mov    0x8(%eax),%ecx
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	8b 40 0c             	mov    0xc(%eax),%eax
  80382a:	01 c8                	add    %ecx,%eax
  80382c:	39 c2                	cmp    %eax,%edx
  80382e:	74 68                	je     803898 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803830:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803834:	75 17                	jne    80384d <insert_sorted_with_merge_freeList+0x323>
  803836:	83 ec 04             	sub    $0x4,%esp
  803839:	68 10 48 80 00       	push   $0x804810
  80383e:	68 62 01 00 00       	push   $0x162
  803843:	68 33 48 80 00       	push   $0x804833
  803848:	e8 1b d7 ff ff       	call   800f68 <_panic>
  80384d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803853:	8b 45 08             	mov    0x8(%ebp),%eax
  803856:	89 10                	mov    %edx,(%eax)
  803858:	8b 45 08             	mov    0x8(%ebp),%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	85 c0                	test   %eax,%eax
  80385f:	74 0d                	je     80386e <insert_sorted_with_merge_freeList+0x344>
  803861:	a1 38 51 80 00       	mov    0x805138,%eax
  803866:	8b 55 08             	mov    0x8(%ebp),%edx
  803869:	89 50 04             	mov    %edx,0x4(%eax)
  80386c:	eb 08                	jmp    803876 <insert_sorted_with_merge_freeList+0x34c>
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803876:	8b 45 08             	mov    0x8(%ebp),%eax
  803879:	a3 38 51 80 00       	mov    %eax,0x805138
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
  803881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803888:	a1 44 51 80 00       	mov    0x805144,%eax
  80388d:	40                   	inc    %eax
  80388e:	a3 44 51 80 00       	mov    %eax,0x805144
  803893:	e9 9f 04 00 00       	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803898:	a1 38 51 80 00       	mov    0x805138,%eax
  80389d:	8b 00                	mov    (%eax),%eax
  80389f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8038a2:	e9 84 04 00 00       	jmp    803d2b <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  8038a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038aa:	8b 50 08             	mov    0x8(%eax),%edx
  8038ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b0:	8b 40 08             	mov    0x8(%eax),%eax
  8038b3:	39 c2                	cmp    %eax,%edx
  8038b5:	0f 86 a9 00 00 00    	jbe    803964 <insert_sorted_with_merge_freeList+0x43a>
  8038bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038be:	8b 50 08             	mov    0x8(%eax),%edx
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	8b 48 08             	mov    0x8(%eax),%ecx
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8038cd:	01 c8                	add    %ecx,%eax
  8038cf:	39 c2                	cmp    %eax,%edx
  8038d1:	0f 84 8d 00 00 00    	je     803964 <insert_sorted_with_merge_freeList+0x43a>
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	8b 50 08             	mov    0x8(%eax),%edx
  8038dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e0:	8b 40 04             	mov    0x4(%eax),%eax
  8038e3:	8b 48 08             	mov    0x8(%eax),%ecx
  8038e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e9:	8b 40 04             	mov    0x4(%eax),%eax
  8038ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8038ef:	01 c8                	add    %ecx,%eax
  8038f1:	39 c2                	cmp    %eax,%edx
  8038f3:	74 6f                	je     803964 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  8038f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f9:	74 06                	je     803901 <insert_sorted_with_merge_freeList+0x3d7>
  8038fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ff:	75 17                	jne    803918 <insert_sorted_with_merge_freeList+0x3ee>
  803901:	83 ec 04             	sub    $0x4,%esp
  803904:	68 70 48 80 00       	push   $0x804870
  803909:	68 6b 01 00 00       	push   $0x16b
  80390e:	68 33 48 80 00       	push   $0x804833
  803913:	e8 50 d6 ff ff       	call   800f68 <_panic>
  803918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391b:	8b 50 04             	mov    0x4(%eax),%edx
  80391e:	8b 45 08             	mov    0x8(%ebp),%eax
  803921:	89 50 04             	mov    %edx,0x4(%eax)
  803924:	8b 45 08             	mov    0x8(%ebp),%eax
  803927:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	8b 40 04             	mov    0x4(%eax),%eax
  803932:	85 c0                	test   %eax,%eax
  803934:	74 0d                	je     803943 <insert_sorted_with_merge_freeList+0x419>
  803936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803939:	8b 40 04             	mov    0x4(%eax),%eax
  80393c:	8b 55 08             	mov    0x8(%ebp),%edx
  80393f:	89 10                	mov    %edx,(%eax)
  803941:	eb 08                	jmp    80394b <insert_sorted_with_merge_freeList+0x421>
  803943:	8b 45 08             	mov    0x8(%ebp),%eax
  803946:	a3 38 51 80 00       	mov    %eax,0x805138
  80394b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394e:	8b 55 08             	mov    0x8(%ebp),%edx
  803951:	89 50 04             	mov    %edx,0x4(%eax)
  803954:	a1 44 51 80 00       	mov    0x805144,%eax
  803959:	40                   	inc    %eax
  80395a:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  80395f:	e9 d3 03 00 00       	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803967:	8b 50 08             	mov    0x8(%eax),%edx
  80396a:	8b 45 08             	mov    0x8(%ebp),%eax
  80396d:	8b 40 08             	mov    0x8(%eax),%eax
  803970:	39 c2                	cmp    %eax,%edx
  803972:	0f 86 da 00 00 00    	jbe    803a52 <insert_sorted_with_merge_freeList+0x528>
  803978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397b:	8b 50 08             	mov    0x8(%eax),%edx
  80397e:	8b 45 08             	mov    0x8(%ebp),%eax
  803981:	8b 48 08             	mov    0x8(%eax),%ecx
  803984:	8b 45 08             	mov    0x8(%ebp),%eax
  803987:	8b 40 0c             	mov    0xc(%eax),%eax
  80398a:	01 c8                	add    %ecx,%eax
  80398c:	39 c2                	cmp    %eax,%edx
  80398e:	0f 85 be 00 00 00    	jne    803a52 <insert_sorted_with_merge_freeList+0x528>
  803994:	8b 45 08             	mov    0x8(%ebp),%eax
  803997:	8b 50 08             	mov    0x8(%eax),%edx
  80399a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399d:	8b 40 04             	mov    0x4(%eax),%eax
  8039a0:	8b 48 08             	mov    0x8(%eax),%ecx
  8039a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a6:	8b 40 04             	mov    0x4(%eax),%eax
  8039a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ac:	01 c8                	add    %ecx,%eax
  8039ae:	39 c2                	cmp    %eax,%edx
  8039b0:	0f 84 9c 00 00 00    	je     803a52 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  8039b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b9:	8b 50 08             	mov    0x8(%eax),%edx
  8039bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bf:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  8039c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8039c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ce:	01 c2                	add    %eax,%edx
  8039d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d3:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  8039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  8039e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8039ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039ee:	75 17                	jne    803a07 <insert_sorted_with_merge_freeList+0x4dd>
  8039f0:	83 ec 04             	sub    $0x4,%esp
  8039f3:	68 10 48 80 00       	push   $0x804810
  8039f8:	68 74 01 00 00       	push   $0x174
  8039fd:	68 33 48 80 00       	push   $0x804833
  803a02:	e8 61 d5 ff ff       	call   800f68 <_panic>
  803a07:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	89 10                	mov    %edx,(%eax)
  803a12:	8b 45 08             	mov    0x8(%ebp),%eax
  803a15:	8b 00                	mov    (%eax),%eax
  803a17:	85 c0                	test   %eax,%eax
  803a19:	74 0d                	je     803a28 <insert_sorted_with_merge_freeList+0x4fe>
  803a1b:	a1 48 51 80 00       	mov    0x805148,%eax
  803a20:	8b 55 08             	mov    0x8(%ebp),%edx
  803a23:	89 50 04             	mov    %edx,0x4(%eax)
  803a26:	eb 08                	jmp    803a30 <insert_sorted_with_merge_freeList+0x506>
  803a28:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a30:	8b 45 08             	mov    0x8(%ebp),%eax
  803a33:	a3 48 51 80 00       	mov    %eax,0x805148
  803a38:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a42:	a1 54 51 80 00       	mov    0x805154,%eax
  803a47:	40                   	inc    %eax
  803a48:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803a4d:	e9 e5 02 00 00       	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a55:	8b 50 08             	mov    0x8(%eax),%edx
  803a58:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5b:	8b 40 08             	mov    0x8(%eax),%eax
  803a5e:	39 c2                	cmp    %eax,%edx
  803a60:	0f 86 d7 00 00 00    	jbe    803b3d <insert_sorted_with_merge_freeList+0x613>
  803a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a69:	8b 50 08             	mov    0x8(%eax),%edx
  803a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6f:	8b 48 08             	mov    0x8(%eax),%ecx
  803a72:	8b 45 08             	mov    0x8(%ebp),%eax
  803a75:	8b 40 0c             	mov    0xc(%eax),%eax
  803a78:	01 c8                	add    %ecx,%eax
  803a7a:	39 c2                	cmp    %eax,%edx
  803a7c:	0f 84 bb 00 00 00    	je     803b3d <insert_sorted_with_merge_freeList+0x613>
  803a82:	8b 45 08             	mov    0x8(%ebp),%eax
  803a85:	8b 50 08             	mov    0x8(%eax),%edx
  803a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8b:	8b 40 04             	mov    0x4(%eax),%eax
  803a8e:	8b 48 08             	mov    0x8(%eax),%ecx
  803a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a94:	8b 40 04             	mov    0x4(%eax),%eax
  803a97:	8b 40 0c             	mov    0xc(%eax),%eax
  803a9a:	01 c8                	add    %ecx,%eax
  803a9c:	39 c2                	cmp    %eax,%edx
  803a9e:	0f 85 99 00 00 00    	jne    803b3d <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	8b 40 04             	mov    0x4(%eax),%eax
  803aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab0:	8b 50 0c             	mov    0xc(%eax),%edx
  803ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab9:	01 c2                	add    %eax,%edx
  803abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803abe:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803acb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ace:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803ad5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ad9:	75 17                	jne    803af2 <insert_sorted_with_merge_freeList+0x5c8>
  803adb:	83 ec 04             	sub    $0x4,%esp
  803ade:	68 10 48 80 00       	push   $0x804810
  803ae3:	68 7d 01 00 00       	push   $0x17d
  803ae8:	68 33 48 80 00       	push   $0x804833
  803aed:	e8 76 d4 ff ff       	call   800f68 <_panic>
  803af2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803af8:	8b 45 08             	mov    0x8(%ebp),%eax
  803afb:	89 10                	mov    %edx,(%eax)
  803afd:	8b 45 08             	mov    0x8(%ebp),%eax
  803b00:	8b 00                	mov    (%eax),%eax
  803b02:	85 c0                	test   %eax,%eax
  803b04:	74 0d                	je     803b13 <insert_sorted_with_merge_freeList+0x5e9>
  803b06:	a1 48 51 80 00       	mov    0x805148,%eax
  803b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b0e:	89 50 04             	mov    %edx,0x4(%eax)
  803b11:	eb 08                	jmp    803b1b <insert_sorted_with_merge_freeList+0x5f1>
  803b13:	8b 45 08             	mov    0x8(%ebp),%eax
  803b16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1e:	a3 48 51 80 00       	mov    %eax,0x805148
  803b23:	8b 45 08             	mov    0x8(%ebp),%eax
  803b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2d:	a1 54 51 80 00       	mov    0x805154,%eax
  803b32:	40                   	inc    %eax
  803b33:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803b38:	e9 fa 01 00 00       	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b40:	8b 50 08             	mov    0x8(%eax),%edx
  803b43:	8b 45 08             	mov    0x8(%ebp),%eax
  803b46:	8b 40 08             	mov    0x8(%eax),%eax
  803b49:	39 c2                	cmp    %eax,%edx
  803b4b:	0f 86 d2 01 00 00    	jbe    803d23 <insert_sorted_with_merge_freeList+0x7f9>
  803b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b54:	8b 50 08             	mov    0x8(%eax),%edx
  803b57:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5a:	8b 48 08             	mov    0x8(%eax),%ecx
  803b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b60:	8b 40 0c             	mov    0xc(%eax),%eax
  803b63:	01 c8                	add    %ecx,%eax
  803b65:	39 c2                	cmp    %eax,%edx
  803b67:	0f 85 b6 01 00 00    	jne    803d23 <insert_sorted_with_merge_freeList+0x7f9>
  803b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b70:	8b 50 08             	mov    0x8(%eax),%edx
  803b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b76:	8b 40 04             	mov    0x4(%eax),%eax
  803b79:	8b 48 08             	mov    0x8(%eax),%ecx
  803b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7f:	8b 40 04             	mov    0x4(%eax),%eax
  803b82:	8b 40 0c             	mov    0xc(%eax),%eax
  803b85:	01 c8                	add    %ecx,%eax
  803b87:	39 c2                	cmp    %eax,%edx
  803b89:	0f 85 94 01 00 00    	jne    803d23 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b92:	8b 40 04             	mov    0x4(%eax),%eax
  803b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b98:	8b 52 04             	mov    0x4(%edx),%edx
  803b9b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  803ba1:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ba7:	8b 52 0c             	mov    0xc(%edx),%edx
  803baa:	01 da                	add    %ebx,%edx
  803bac:	01 ca                	add    %ecx,%edx
  803bae:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc9:	75 17                	jne    803be2 <insert_sorted_with_merge_freeList+0x6b8>
  803bcb:	83 ec 04             	sub    $0x4,%esp
  803bce:	68 a5 48 80 00       	push   $0x8048a5
  803bd3:	68 86 01 00 00       	push   $0x186
  803bd8:	68 33 48 80 00       	push   $0x804833
  803bdd:	e8 86 d3 ff ff       	call   800f68 <_panic>
  803be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be5:	8b 00                	mov    (%eax),%eax
  803be7:	85 c0                	test   %eax,%eax
  803be9:	74 10                	je     803bfb <insert_sorted_with_merge_freeList+0x6d1>
  803beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bee:	8b 00                	mov    (%eax),%eax
  803bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bf3:	8b 52 04             	mov    0x4(%edx),%edx
  803bf6:	89 50 04             	mov    %edx,0x4(%eax)
  803bf9:	eb 0b                	jmp    803c06 <insert_sorted_with_merge_freeList+0x6dc>
  803bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfe:	8b 40 04             	mov    0x4(%eax),%eax
  803c01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c09:	8b 40 04             	mov    0x4(%eax),%eax
  803c0c:	85 c0                	test   %eax,%eax
  803c0e:	74 0f                	je     803c1f <insert_sorted_with_merge_freeList+0x6f5>
  803c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c13:	8b 40 04             	mov    0x4(%eax),%eax
  803c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c19:	8b 12                	mov    (%edx),%edx
  803c1b:	89 10                	mov    %edx,(%eax)
  803c1d:	eb 0a                	jmp    803c29 <insert_sorted_with_merge_freeList+0x6ff>
  803c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c22:	8b 00                	mov    (%eax),%eax
  803c24:	a3 38 51 80 00       	mov    %eax,0x805138
  803c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3c:	a1 44 51 80 00       	mov    0x805144,%eax
  803c41:	48                   	dec    %eax
  803c42:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c4b:	75 17                	jne    803c64 <insert_sorted_with_merge_freeList+0x73a>
  803c4d:	83 ec 04             	sub    $0x4,%esp
  803c50:	68 10 48 80 00       	push   $0x804810
  803c55:	68 87 01 00 00       	push   $0x187
  803c5a:	68 33 48 80 00       	push   $0x804833
  803c5f:	e8 04 d3 ff ff       	call   800f68 <_panic>
  803c64:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6d:	89 10                	mov    %edx,(%eax)
  803c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c72:	8b 00                	mov    (%eax),%eax
  803c74:	85 c0                	test   %eax,%eax
  803c76:	74 0d                	je     803c85 <insert_sorted_with_merge_freeList+0x75b>
  803c78:	a1 48 51 80 00       	mov    0x805148,%eax
  803c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c80:	89 50 04             	mov    %edx,0x4(%eax)
  803c83:	eb 08                	jmp    803c8d <insert_sorted_with_merge_freeList+0x763>
  803c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c88:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c90:	a3 48 51 80 00       	mov    %eax,0x805148
  803c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c9f:	a1 54 51 80 00       	mov    0x805154,%eax
  803ca4:	40                   	inc    %eax
  803ca5:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803caa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803cbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cc2:	75 17                	jne    803cdb <insert_sorted_with_merge_freeList+0x7b1>
  803cc4:	83 ec 04             	sub    $0x4,%esp
  803cc7:	68 10 48 80 00       	push   $0x804810
  803ccc:	68 8a 01 00 00       	push   $0x18a
  803cd1:	68 33 48 80 00       	push   $0x804833
  803cd6:	e8 8d d2 ff ff       	call   800f68 <_panic>
  803cdb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce4:	89 10                	mov    %edx,(%eax)
  803ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce9:	8b 00                	mov    (%eax),%eax
  803ceb:	85 c0                	test   %eax,%eax
  803ced:	74 0d                	je     803cfc <insert_sorted_with_merge_freeList+0x7d2>
  803cef:	a1 48 51 80 00       	mov    0x805148,%eax
  803cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  803cf7:	89 50 04             	mov    %edx,0x4(%eax)
  803cfa:	eb 08                	jmp    803d04 <insert_sorted_with_merge_freeList+0x7da>
  803cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d04:	8b 45 08             	mov    0x8(%ebp),%eax
  803d07:	a3 48 51 80 00       	mov    %eax,0x805148
  803d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d16:	a1 54 51 80 00       	mov    0x805154,%eax
  803d1b:	40                   	inc    %eax
  803d1c:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  803d21:	eb 14                	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  803d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d26:	8b 00                	mov    (%eax),%eax
  803d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  803d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d2f:	0f 85 72 fb ff ff    	jne    8038a7 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803d35:	eb 00                	jmp    803d37 <insert_sorted_with_merge_freeList+0x80d>
  803d37:	90                   	nop
  803d38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803d3b:	c9                   	leave  
  803d3c:	c3                   	ret    
  803d3d:	66 90                	xchg   %ax,%ax
  803d3f:	90                   	nop

00803d40 <__udivdi3>:
  803d40:	55                   	push   %ebp
  803d41:	57                   	push   %edi
  803d42:	56                   	push   %esi
  803d43:	53                   	push   %ebx
  803d44:	83 ec 1c             	sub    $0x1c,%esp
  803d47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d57:	89 ca                	mov    %ecx,%edx
  803d59:	89 f8                	mov    %edi,%eax
  803d5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d5f:	85 f6                	test   %esi,%esi
  803d61:	75 2d                	jne    803d90 <__udivdi3+0x50>
  803d63:	39 cf                	cmp    %ecx,%edi
  803d65:	77 65                	ja     803dcc <__udivdi3+0x8c>
  803d67:	89 fd                	mov    %edi,%ebp
  803d69:	85 ff                	test   %edi,%edi
  803d6b:	75 0b                	jne    803d78 <__udivdi3+0x38>
  803d6d:	b8 01 00 00 00       	mov    $0x1,%eax
  803d72:	31 d2                	xor    %edx,%edx
  803d74:	f7 f7                	div    %edi
  803d76:	89 c5                	mov    %eax,%ebp
  803d78:	31 d2                	xor    %edx,%edx
  803d7a:	89 c8                	mov    %ecx,%eax
  803d7c:	f7 f5                	div    %ebp
  803d7e:	89 c1                	mov    %eax,%ecx
  803d80:	89 d8                	mov    %ebx,%eax
  803d82:	f7 f5                	div    %ebp
  803d84:	89 cf                	mov    %ecx,%edi
  803d86:	89 fa                	mov    %edi,%edx
  803d88:	83 c4 1c             	add    $0x1c,%esp
  803d8b:	5b                   	pop    %ebx
  803d8c:	5e                   	pop    %esi
  803d8d:	5f                   	pop    %edi
  803d8e:	5d                   	pop    %ebp
  803d8f:	c3                   	ret    
  803d90:	39 ce                	cmp    %ecx,%esi
  803d92:	77 28                	ja     803dbc <__udivdi3+0x7c>
  803d94:	0f bd fe             	bsr    %esi,%edi
  803d97:	83 f7 1f             	xor    $0x1f,%edi
  803d9a:	75 40                	jne    803ddc <__udivdi3+0x9c>
  803d9c:	39 ce                	cmp    %ecx,%esi
  803d9e:	72 0a                	jb     803daa <__udivdi3+0x6a>
  803da0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803da4:	0f 87 9e 00 00 00    	ja     803e48 <__udivdi3+0x108>
  803daa:	b8 01 00 00 00       	mov    $0x1,%eax
  803daf:	89 fa                	mov    %edi,%edx
  803db1:	83 c4 1c             	add    $0x1c,%esp
  803db4:	5b                   	pop    %ebx
  803db5:	5e                   	pop    %esi
  803db6:	5f                   	pop    %edi
  803db7:	5d                   	pop    %ebp
  803db8:	c3                   	ret    
  803db9:	8d 76 00             	lea    0x0(%esi),%esi
  803dbc:	31 ff                	xor    %edi,%edi
  803dbe:	31 c0                	xor    %eax,%eax
  803dc0:	89 fa                	mov    %edi,%edx
  803dc2:	83 c4 1c             	add    $0x1c,%esp
  803dc5:	5b                   	pop    %ebx
  803dc6:	5e                   	pop    %esi
  803dc7:	5f                   	pop    %edi
  803dc8:	5d                   	pop    %ebp
  803dc9:	c3                   	ret    
  803dca:	66 90                	xchg   %ax,%ax
  803dcc:	89 d8                	mov    %ebx,%eax
  803dce:	f7 f7                	div    %edi
  803dd0:	31 ff                	xor    %edi,%edi
  803dd2:	89 fa                	mov    %edi,%edx
  803dd4:	83 c4 1c             	add    $0x1c,%esp
  803dd7:	5b                   	pop    %ebx
  803dd8:	5e                   	pop    %esi
  803dd9:	5f                   	pop    %edi
  803dda:	5d                   	pop    %ebp
  803ddb:	c3                   	ret    
  803ddc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803de1:	89 eb                	mov    %ebp,%ebx
  803de3:	29 fb                	sub    %edi,%ebx
  803de5:	89 f9                	mov    %edi,%ecx
  803de7:	d3 e6                	shl    %cl,%esi
  803de9:	89 c5                	mov    %eax,%ebp
  803deb:	88 d9                	mov    %bl,%cl
  803ded:	d3 ed                	shr    %cl,%ebp
  803def:	89 e9                	mov    %ebp,%ecx
  803df1:	09 f1                	or     %esi,%ecx
  803df3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803df7:	89 f9                	mov    %edi,%ecx
  803df9:	d3 e0                	shl    %cl,%eax
  803dfb:	89 c5                	mov    %eax,%ebp
  803dfd:	89 d6                	mov    %edx,%esi
  803dff:	88 d9                	mov    %bl,%cl
  803e01:	d3 ee                	shr    %cl,%esi
  803e03:	89 f9                	mov    %edi,%ecx
  803e05:	d3 e2                	shl    %cl,%edx
  803e07:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e0b:	88 d9                	mov    %bl,%cl
  803e0d:	d3 e8                	shr    %cl,%eax
  803e0f:	09 c2                	or     %eax,%edx
  803e11:	89 d0                	mov    %edx,%eax
  803e13:	89 f2                	mov    %esi,%edx
  803e15:	f7 74 24 0c          	divl   0xc(%esp)
  803e19:	89 d6                	mov    %edx,%esi
  803e1b:	89 c3                	mov    %eax,%ebx
  803e1d:	f7 e5                	mul    %ebp
  803e1f:	39 d6                	cmp    %edx,%esi
  803e21:	72 19                	jb     803e3c <__udivdi3+0xfc>
  803e23:	74 0b                	je     803e30 <__udivdi3+0xf0>
  803e25:	89 d8                	mov    %ebx,%eax
  803e27:	31 ff                	xor    %edi,%edi
  803e29:	e9 58 ff ff ff       	jmp    803d86 <__udivdi3+0x46>
  803e2e:	66 90                	xchg   %ax,%ax
  803e30:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e34:	89 f9                	mov    %edi,%ecx
  803e36:	d3 e2                	shl    %cl,%edx
  803e38:	39 c2                	cmp    %eax,%edx
  803e3a:	73 e9                	jae    803e25 <__udivdi3+0xe5>
  803e3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e3f:	31 ff                	xor    %edi,%edi
  803e41:	e9 40 ff ff ff       	jmp    803d86 <__udivdi3+0x46>
  803e46:	66 90                	xchg   %ax,%ax
  803e48:	31 c0                	xor    %eax,%eax
  803e4a:	e9 37 ff ff ff       	jmp    803d86 <__udivdi3+0x46>
  803e4f:	90                   	nop

00803e50 <__umoddi3>:
  803e50:	55                   	push   %ebp
  803e51:	57                   	push   %edi
  803e52:	56                   	push   %esi
  803e53:	53                   	push   %ebx
  803e54:	83 ec 1c             	sub    $0x1c,%esp
  803e57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e6f:	89 f3                	mov    %esi,%ebx
  803e71:	89 fa                	mov    %edi,%edx
  803e73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e77:	89 34 24             	mov    %esi,(%esp)
  803e7a:	85 c0                	test   %eax,%eax
  803e7c:	75 1a                	jne    803e98 <__umoddi3+0x48>
  803e7e:	39 f7                	cmp    %esi,%edi
  803e80:	0f 86 a2 00 00 00    	jbe    803f28 <__umoddi3+0xd8>
  803e86:	89 c8                	mov    %ecx,%eax
  803e88:	89 f2                	mov    %esi,%edx
  803e8a:	f7 f7                	div    %edi
  803e8c:	89 d0                	mov    %edx,%eax
  803e8e:	31 d2                	xor    %edx,%edx
  803e90:	83 c4 1c             	add    $0x1c,%esp
  803e93:	5b                   	pop    %ebx
  803e94:	5e                   	pop    %esi
  803e95:	5f                   	pop    %edi
  803e96:	5d                   	pop    %ebp
  803e97:	c3                   	ret    
  803e98:	39 f0                	cmp    %esi,%eax
  803e9a:	0f 87 ac 00 00 00    	ja     803f4c <__umoddi3+0xfc>
  803ea0:	0f bd e8             	bsr    %eax,%ebp
  803ea3:	83 f5 1f             	xor    $0x1f,%ebp
  803ea6:	0f 84 ac 00 00 00    	je     803f58 <__umoddi3+0x108>
  803eac:	bf 20 00 00 00       	mov    $0x20,%edi
  803eb1:	29 ef                	sub    %ebp,%edi
  803eb3:	89 fe                	mov    %edi,%esi
  803eb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803eb9:	89 e9                	mov    %ebp,%ecx
  803ebb:	d3 e0                	shl    %cl,%eax
  803ebd:	89 d7                	mov    %edx,%edi
  803ebf:	89 f1                	mov    %esi,%ecx
  803ec1:	d3 ef                	shr    %cl,%edi
  803ec3:	09 c7                	or     %eax,%edi
  803ec5:	89 e9                	mov    %ebp,%ecx
  803ec7:	d3 e2                	shl    %cl,%edx
  803ec9:	89 14 24             	mov    %edx,(%esp)
  803ecc:	89 d8                	mov    %ebx,%eax
  803ece:	d3 e0                	shl    %cl,%eax
  803ed0:	89 c2                	mov    %eax,%edx
  803ed2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ed6:	d3 e0                	shl    %cl,%eax
  803ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803edc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ee0:	89 f1                	mov    %esi,%ecx
  803ee2:	d3 e8                	shr    %cl,%eax
  803ee4:	09 d0                	or     %edx,%eax
  803ee6:	d3 eb                	shr    %cl,%ebx
  803ee8:	89 da                	mov    %ebx,%edx
  803eea:	f7 f7                	div    %edi
  803eec:	89 d3                	mov    %edx,%ebx
  803eee:	f7 24 24             	mull   (%esp)
  803ef1:	89 c6                	mov    %eax,%esi
  803ef3:	89 d1                	mov    %edx,%ecx
  803ef5:	39 d3                	cmp    %edx,%ebx
  803ef7:	0f 82 87 00 00 00    	jb     803f84 <__umoddi3+0x134>
  803efd:	0f 84 91 00 00 00    	je     803f94 <__umoddi3+0x144>
  803f03:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f07:	29 f2                	sub    %esi,%edx
  803f09:	19 cb                	sbb    %ecx,%ebx
  803f0b:	89 d8                	mov    %ebx,%eax
  803f0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f11:	d3 e0                	shl    %cl,%eax
  803f13:	89 e9                	mov    %ebp,%ecx
  803f15:	d3 ea                	shr    %cl,%edx
  803f17:	09 d0                	or     %edx,%eax
  803f19:	89 e9                	mov    %ebp,%ecx
  803f1b:	d3 eb                	shr    %cl,%ebx
  803f1d:	89 da                	mov    %ebx,%edx
  803f1f:	83 c4 1c             	add    $0x1c,%esp
  803f22:	5b                   	pop    %ebx
  803f23:	5e                   	pop    %esi
  803f24:	5f                   	pop    %edi
  803f25:	5d                   	pop    %ebp
  803f26:	c3                   	ret    
  803f27:	90                   	nop
  803f28:	89 fd                	mov    %edi,%ebp
  803f2a:	85 ff                	test   %edi,%edi
  803f2c:	75 0b                	jne    803f39 <__umoddi3+0xe9>
  803f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f33:	31 d2                	xor    %edx,%edx
  803f35:	f7 f7                	div    %edi
  803f37:	89 c5                	mov    %eax,%ebp
  803f39:	89 f0                	mov    %esi,%eax
  803f3b:	31 d2                	xor    %edx,%edx
  803f3d:	f7 f5                	div    %ebp
  803f3f:	89 c8                	mov    %ecx,%eax
  803f41:	f7 f5                	div    %ebp
  803f43:	89 d0                	mov    %edx,%eax
  803f45:	e9 44 ff ff ff       	jmp    803e8e <__umoddi3+0x3e>
  803f4a:	66 90                	xchg   %ax,%ax
  803f4c:	89 c8                	mov    %ecx,%eax
  803f4e:	89 f2                	mov    %esi,%edx
  803f50:	83 c4 1c             	add    $0x1c,%esp
  803f53:	5b                   	pop    %ebx
  803f54:	5e                   	pop    %esi
  803f55:	5f                   	pop    %edi
  803f56:	5d                   	pop    %ebp
  803f57:	c3                   	ret    
  803f58:	3b 04 24             	cmp    (%esp),%eax
  803f5b:	72 06                	jb     803f63 <__umoddi3+0x113>
  803f5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f61:	77 0f                	ja     803f72 <__umoddi3+0x122>
  803f63:	89 f2                	mov    %esi,%edx
  803f65:	29 f9                	sub    %edi,%ecx
  803f67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f6b:	89 14 24             	mov    %edx,(%esp)
  803f6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f72:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f76:	8b 14 24             	mov    (%esp),%edx
  803f79:	83 c4 1c             	add    $0x1c,%esp
  803f7c:	5b                   	pop    %ebx
  803f7d:	5e                   	pop    %esi
  803f7e:	5f                   	pop    %edi
  803f7f:	5d                   	pop    %ebp
  803f80:	c3                   	ret    
  803f81:	8d 76 00             	lea    0x0(%esi),%esi
  803f84:	2b 04 24             	sub    (%esp),%eax
  803f87:	19 fa                	sbb    %edi,%edx
  803f89:	89 d1                	mov    %edx,%ecx
  803f8b:	89 c6                	mov    %eax,%esi
  803f8d:	e9 71 ff ff ff       	jmp    803f03 <__umoddi3+0xb3>
  803f92:	66 90                	xchg   %ax,%ax
  803f94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f98:	72 ea                	jb     803f84 <__umoddi3+0x134>
  803f9a:	89 d9                	mov    %ebx,%ecx
  803f9c:	e9 62 ff ff ff       	jmp    803f03 <__umoddi3+0xb3>
