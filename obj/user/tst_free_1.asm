
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 c7 17 00 00       	call   8017fd <libmain>
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
  80003d:	81 ec 90 01 00 00    	sub    $0x190,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800079:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800091:	68 80 49 80 00       	push   $0x804980
  800096:	6a 1a                	push   $0x1a
  800098:	68 9c 49 80 00       	push   $0x80499c
  80009d:	e8 97 18 00 00       	call   801939 <_panic>





	int Mega = 1024*1024;
  8000a2:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  8000a9:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	char minByte = 1<<7;
  8000b0:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
	char maxByte = 0x7F;
  8000b4:	c6 45 da 7f          	movb   $0x7f,-0x26(%ebp)
	short minShort = 1<<15 ;
  8000b8:	66 c7 45 d8 00 80    	movw   $0x8000,-0x28(%ebp)
	short maxShort = 0x7FFF;
  8000be:	66 c7 45 d6 ff 7f    	movw   $0x7fff,-0x2a(%ebp)
	int minInt = 1<<31 ;
  8000c4:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000cb:	c7 45 cc ff ff ff 7f 	movl   $0x7fffffff,-0x34(%ebp)
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 61 2a 00 00       	call   802b3d <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 bd 2e 00 00       	call   802fa1 <sys_calculate_free_frames>
  8000e4:	89 45 c8             	mov    %eax,-0x38(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 41 2f 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 29 2a 00 00       	call   802b3d <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 b0 49 80 00       	push   $0x8049b0
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 9c 49 80 00       	push   $0x80499c
  800143:	e8 f1 17 00 00       	call   801939 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 f4 2e 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 18 4a 80 00       	push   $0x804a18
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 9c 49 80 00       	push   $0x80499c
  800161:	e8 d3 17 00 00       	call   801939 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 36 2e 00 00       	call   802fa1 <sys_calculate_free_frames>
  80016b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800180:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800186:	8a 55 db             	mov    -0x25(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 da             	mov    -0x26(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80019b:	e8 01 2e 00 00       	call   802fa1 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 48 4a 80 00       	push   $0x804a48
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 9c 49 80 00       	push   $0x80499c
  8001b8:	e8 7c 17 00 00       	call   801939 <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001fb:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 60 80 00       	mov    0x806020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80022b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800238:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800240:	8b 45 a8             	mov    -0x58(%ebp),%eax
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
  800252:	a1 20 60 80 00       	mov    0x806020,%eax
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
  80026e:	68 8c 4a 80 00       	push   $0x804a8c
  800273:	6a 4c                	push   $0x4c
  800275:	68 9c 49 80 00       	push   $0x80499c
  80027a:	e8 ba 16 00 00       	call   801939 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 bd 2d 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 a5 28 00 00       	call   802b3d <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 b0 49 80 00       	push   $0x8049b0
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 9c 49 80 00       	push   $0x80499c
  8002dc:	e8 58 16 00 00       	call   801939 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 5b 2d 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 18 4a 80 00       	push   $0x804a18
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 9c 49 80 00       	push   $0x80499c
  8002fa:	e8 3a 16 00 00       	call   801939 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 9d 2c 00 00       	call   802fa1 <sys_calculate_free_frames>
  800304:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  80030d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80033d:	e8 5f 2c 00 00       	call   802fa1 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 48 4a 80 00       	push   $0x804a48
  800353:	6a 59                	push   $0x59
  800355:	68 9c 49 80 00       	push   $0x80499c
  80035a:	e8 da 15 00 00       	call   801939 <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 60 80 00       	mov    0x806020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800390:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039d:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003a0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 60 80 00       	mov    0x806020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003cd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003e6:	8b 45 90             	mov    -0x70(%ebp),%eax
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
  8003f8:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800414:	68 8c 4a 80 00       	push   $0x804a8c
  800419:	6a 62                	push   $0x62
  80041b:	68 9c 49 80 00       	push   $0x80499c
  800420:	e8 14 15 00 00       	call   801939 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 17 2c 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  80042d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	50                   	push   %eax
  800436:	e8 02 27 00 00       	call   802b3d <malloc>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800444:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80044a:	89 c2                	mov    %eax,%edx
  80044c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044f:	c1 e0 02             	shl    $0x2,%eax
  800452:	05 00 00 00 80       	add    $0x80000000,%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	72 17                	jb     800472 <_main+0x43a>
  80045b:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  800461:	89 c2                	mov    %eax,%edx
  800463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800466:	c1 e0 02             	shl    $0x2,%eax
  800469:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	76 14                	jbe    800486 <_main+0x44e>
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 b0 49 80 00       	push   $0x8049b0
  80047a:	6a 67                	push   $0x67
  80047c:	68 9c 49 80 00       	push   $0x80499c
  800481:	e8 b3 14 00 00       	call   801939 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 b6 2b 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 18 4a 80 00       	push   $0x804a18
  800498:	6a 68                	push   $0x68
  80049a:	68 9c 49 80 00       	push   $0x80499c
  80049f:	e8 95 14 00 00       	call   801939 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 f8 2a 00 00       	call   802fa1 <sys_calculate_free_frames>
  8004a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004ac:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8004b2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b8:	01 c0                	add    %eax,%eax
  8004ba:	c1 e8 02             	shr    $0x2,%eax
  8004bd:	48                   	dec    %eax
  8004be:	89 45 88             	mov    %eax,-0x78(%ebp)
		intArr[0] = minInt;
  8004c1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004c7:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004c9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d6:	01 c2                	add    %eax,%edx
  8004d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004db:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004dd:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004e0:	e8 bc 2a 00 00       	call   802fa1 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 48 4a 80 00       	push   $0x804a48
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 9c 49 80 00       	push   $0x80499c
  8004fd:	e8 37 14 00 00       	call   801939 <_panic>
		found = 0;
  800502:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800509:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800510:	e9 95 00 00 00       	jmp    8005aa <_main+0x572>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800515:	a1 20 60 80 00       	mov    0x806020,%eax
  80051a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800523:	89 d0                	mov    %edx,%eax
  800525:	01 c0                	add    %eax,%eax
  800527:	01 d0                	add    %edx,%eax
  800529:	c1 e0 03             	shl    $0x3,%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800533:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800536:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053b:	89 c2                	mov    %eax,%edx
  80053d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800540:	89 45 80             	mov    %eax,-0x80(%ebp)
  800543:	8b 45 80             	mov    -0x80(%ebp),%eax
  800546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	75 03                	jne    800552 <_main+0x51a>
				found++;
  80054f:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800552:	a1 20 60 80 00       	mov    0x806020,%eax
  800557:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	01 c0                	add    %eax,%eax
  800564:	01 d0                	add    %edx,%eax
  800566:	c1 e0 03             	shl    $0x3,%eax
  800569:	01 c8                	add    %ecx,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800573:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800579:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057e:	89 c2                	mov    %eax,%edx
  800580:	8b 45 88             	mov    -0x78(%ebp),%eax
  800583:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058d:	01 c8                	add    %ecx,%eax
  80058f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800595:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80059b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a0:	39 c2                	cmp    %eax,%edx
  8005a2:	75 03                	jne    8005a7 <_main+0x56f>
				found++;
  8005a4:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a7:	ff 45 ec             	incl   -0x14(%ebp)
  8005aa:	a1 20 60 80 00       	mov    0x806020,%eax
  8005af:	8b 50 74             	mov    0x74(%eax),%edx
  8005b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b5:	39 c2                	cmp    %eax,%edx
  8005b7:	0f 87 58 ff ff ff    	ja     800515 <_main+0x4dd>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bd:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005c1:	74 14                	je     8005d7 <_main+0x59f>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 8c 4a 80 00       	push   $0x804a8c
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 9c 49 80 00       	push   $0x80499c
  8005d2:	e8 62 13 00 00       	call   801939 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 c5 29 00 00       	call   802fa1 <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 5d 2a 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8005e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8005e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	50                   	push   %eax
  8005f0:	e8 48 25 00 00       	call   802b3d <malloc>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005fe:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800604:	89 c2                	mov    %eax,%edx
  800606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800609:	c1 e0 02             	shl    $0x2,%eax
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800611:	c1 e0 02             	shl    $0x2,%eax
  800614:	01 c8                	add    %ecx,%eax
  800616:	05 00 00 00 80       	add    $0x80000000,%eax
  80061b:	39 c2                	cmp    %eax,%edx
  80061d:	72 21                	jb     800640 <_main+0x608>
  80061f:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800625:	89 c2                	mov    %eax,%edx
  800627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062a:	c1 e0 02             	shl    $0x2,%eax
  80062d:	89 c1                	mov    %eax,%ecx
  80062f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800632:	c1 e0 02             	shl    $0x2,%eax
  800635:	01 c8                	add    %ecx,%eax
  800637:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	76 14                	jbe    800654 <_main+0x61c>
  800640:	83 ec 04             	sub    $0x4,%esp
  800643:	68 b0 49 80 00       	push   $0x8049b0
  800648:	6a 7e                	push   $0x7e
  80064a:	68 9c 49 80 00       	push   $0x80499c
  80064f:	e8 e5 12 00 00       	call   801939 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 e8 29 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 18 4a 80 00       	push   $0x804a18
  800666:	6a 7f                	push   $0x7f
  800668:	68 9c 49 80 00       	push   $0x80499c
  80066d:	e8 c7 12 00 00       	call   801939 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 ca 29 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800677:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80067d:	89 d0                	mov    %edx,%eax
  80067f:	01 c0                	add    %eax,%eax
  800681:	01 d0                	add    %edx,%eax
  800683:	01 c0                	add    %eax,%eax
  800685:	01 d0                	add    %edx,%eax
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	50                   	push   %eax
  80068b:	e8 ad 24 00 00       	call   802b3d <malloc>
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800699:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a4:	c1 e0 02             	shl    $0x2,%eax
  8006a7:	89 c1                	mov    %eax,%ecx
  8006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ac:	c1 e0 03             	shl    $0x3,%eax
  8006af:	01 c8                	add    %ecx,%eax
  8006b1:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b6:	39 c2                	cmp    %eax,%edx
  8006b8:	72 21                	jb     8006db <_main+0x6a3>
  8006ba:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	c1 e0 02             	shl    $0x2,%eax
  8006c8:	89 c1                	mov    %eax,%ecx
  8006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cd:	c1 e0 03             	shl    $0x3,%eax
  8006d0:	01 c8                	add    %ecx,%eax
  8006d2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d7:	39 c2                	cmp    %eax,%edx
  8006d9:	76 17                	jbe    8006f2 <_main+0x6ba>
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	68 b0 49 80 00       	push   $0x8049b0
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 9c 49 80 00       	push   $0x80499c
  8006ed:	e8 47 12 00 00       	call   801939 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 4a 29 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 18 4a 80 00       	push   $0x804a18
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 9c 49 80 00       	push   $0x80499c
  80070e:	e8 26 12 00 00       	call   801939 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 89 28 00 00       	call   802fa1 <sys_calculate_free_frames>
  800718:	89 45 c0             	mov    %eax,-0x40(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071b:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800721:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800727:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80072a:	89 d0                	mov    %edx,%eax
  80072c:	01 c0                	add    %eax,%eax
  80072e:	01 d0                	add    %edx,%eax
  800730:	01 c0                	add    %eax,%eax
  800732:	01 d0                	add    %edx,%eax
  800734:	c1 e8 03             	shr    $0x3,%eax
  800737:	48                   	dec    %eax
  800738:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80073e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800744:	8a 55 db             	mov    -0x25(%ebp),%dl
  800747:	88 10                	mov    %dl,(%eax)
  800749:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  80074f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800752:	66 89 42 02          	mov    %ax,0x2(%edx)
  800756:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80075c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075f:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800762:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80076f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800775:	01 c2                	add    %eax,%edx
  800777:	8a 45 da             	mov    -0x26(%ebp),%al
  80077a:	88 02                	mov    %al,(%edx)
  80077c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800782:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800789:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80078f:	01 c2                	add    %eax,%edx
  800791:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800795:	66 89 42 02          	mov    %ax,0x2(%edx)
  800799:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80079f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007ac:	01 c2                	add    %eax,%edx
  8007ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007b1:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007b7:	e8 e5 27 00 00       	call   802fa1 <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 48 4a 80 00       	push   $0x804a48
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 9c 49 80 00       	push   $0x80499c
  8007d7:	e8 5d 11 00 00       	call   801939 <_panic>
		found = 0;
  8007dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ea:	e9 aa 00 00 00       	jmp    800899 <_main+0x861>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007ef:	a1 20 60 80 00       	mov    0x806020,%eax
  8007f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	01 c0                	add    %eax,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	c1 e0 03             	shl    $0x3,%eax
  800806:	01 c8                	add    %ecx,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800810:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800816:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800823:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800829:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80082f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800834:	39 c2                	cmp    %eax,%edx
  800836:	75 03                	jne    80083b <_main+0x803>
				found++;
  800838:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083b:	a1 20 60 80 00       	mov    0x806020,%eax
  800840:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800846:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800849:	89 d0                	mov    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	c1 e0 03             	shl    $0x3,%eax
  800852:	01 c8                	add    %ecx,%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80085c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800867:	89 c2                	mov    %eax,%edx
  800869:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80086f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800876:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80087c:	01 c8                	add    %ecx,%eax
  80087e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800884:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80088a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80088f:	39 c2                	cmp    %eax,%edx
  800891:	75 03                	jne    800896 <_main+0x85e>
				found++;
  800893:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800896:	ff 45 ec             	incl   -0x14(%ebp)
  800899:	a1 20 60 80 00       	mov    0x806020,%eax
  80089e:	8b 50 74             	mov    0x74(%eax),%edx
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	0f 87 43 ff ff ff    	ja     8007ef <_main+0x7b7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ac:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 8c 4a 80 00       	push   $0x804a8c
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 9c 49 80 00       	push   $0x80499c
  8008c4:	e8 70 10 00 00       	call   801939 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 d3 26 00 00       	call   802fa1 <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 6b 27 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dc:	89 c2                	mov    %eax,%edx
  8008de:	01 d2                	add    %edx,%edx
  8008e0:	01 d0                	add    %edx,%eax
  8008e2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008e5:	83 ec 0c             	sub    $0xc,%esp
  8008e8:	50                   	push   %eax
  8008e9:	e8 4f 22 00 00       	call   802b3d <malloc>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f7:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8008fd:	89 c2                	mov    %eax,%edx
  8008ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800902:	c1 e0 02             	shl    $0x2,%eax
  800905:	89 c1                	mov    %eax,%ecx
  800907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80090a:	c1 e0 04             	shl    $0x4,%eax
  80090d:	01 c8                	add    %ecx,%eax
  80090f:	05 00 00 00 80       	add    $0x80000000,%eax
  800914:	39 c2                	cmp    %eax,%edx
  800916:	72 21                	jb     800939 <_main+0x901>
  800918:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	c1 e0 02             	shl    $0x2,%eax
  800926:	89 c1                	mov    %eax,%ecx
  800928:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80092b:	c1 e0 04             	shl    $0x4,%eax
  80092e:	01 c8                	add    %ecx,%eax
  800930:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800935:	39 c2                	cmp    %eax,%edx
  800937:	76 17                	jbe    800950 <_main+0x918>
  800939:	83 ec 04             	sub    $0x4,%esp
  80093c:	68 b0 49 80 00       	push   $0x8049b0
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 9c 49 80 00       	push   $0x80499c
  80094b:	e8 e9 0f 00 00       	call   801939 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 ec 26 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 18 4a 80 00       	push   $0x804a18
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 9c 49 80 00       	push   $0x80499c
  80096c:	e8 c8 0f 00 00       	call   801939 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 cb 26 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800976:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800979:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097c:	89 d0                	mov    %edx,%eax
  80097e:	01 c0                	add    %eax,%eax
  800980:	01 d0                	add    %edx,%eax
  800982:	01 c0                	add    %eax,%eax
  800984:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800987:	83 ec 0c             	sub    $0xc,%esp
  80098a:	50                   	push   %eax
  80098b:	e8 ad 21 00 00       	call   802b3d <malloc>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800999:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  80099f:	89 c1                	mov    %eax,%ecx
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	01 c0                	add    %eax,%eax
  8009a8:	01 d0                	add    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b3:	c1 e0 04             	shl    $0x4,%eax
  8009b6:	01 d0                	add    %edx,%eax
  8009b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bd:	39 c1                	cmp    %eax,%ecx
  8009bf:	72 28                	jb     8009e9 <_main+0x9b1>
  8009c1:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009c7:	89 c1                	mov    %eax,%ecx
  8009c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cc:	89 d0                	mov    %edx,%eax
  8009ce:	01 c0                	add    %eax,%eax
  8009d0:	01 d0                	add    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009db:	c1 e0 04             	shl    $0x4,%eax
  8009de:	01 d0                	add    %edx,%eax
  8009e0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e5:	39 c1                	cmp    %eax,%ecx
  8009e7:	76 17                	jbe    800a00 <_main+0x9c8>
  8009e9:	83 ec 04             	sub    $0x4,%esp
  8009ec:	68 b0 49 80 00       	push   $0x8049b0
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 9c 49 80 00       	push   $0x80499c
  8009fb:	e8 39 0f 00 00       	call   801939 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 3c 26 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 18 4a 80 00       	push   $0x804a18
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 9c 49 80 00       	push   $0x80499c
  800a1c:	e8 18 0f 00 00       	call   801939 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 7b 25 00 00       	call   802fa1 <sys_calculate_free_frames>
  800a26:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a2c:	89 d0                	mov    %edx,%eax
  800a2e:	01 c0                	add    %eax,%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	01 c0                	add    %eax,%eax
  800a34:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a37:	48                   	dec    %eax
  800a38:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a3e:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a44:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2[0] = minByte ;
  800a4a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a50:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a53:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a55:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	c1 ea 1f             	shr    $0x1f,%edx
  800a60:	01 d0                	add    %edx,%eax
  800a62:	d1 f8                	sar    %eax
  800a64:	89 c2                	mov    %eax,%edx
  800a66:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a6c:	01 c2                	add    %eax,%edx
  800a6e:	8a 45 da             	mov    -0x26(%ebp),%al
  800a71:	88 c1                	mov    %al,%cl
  800a73:	c0 e9 07             	shr    $0x7,%cl
  800a76:	01 c8                	add    %ecx,%eax
  800a78:	d0 f8                	sar    %al
  800a7a:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7c:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800a82:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a88:	01 c2                	add    %eax,%edx
  800a8a:	8a 45 da             	mov    -0x26(%ebp),%al
  800a8d:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8f:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800a92:	e8 0a 25 00 00       	call   802fa1 <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 48 4a 80 00       	push   $0x804a48
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 9c 49 80 00       	push   $0x80499c
  800ab2:	e8 82 0e 00 00       	call   801939 <_panic>
		found = 0;
  800ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800abe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac5:	e9 02 01 00 00       	jmp    800bcc <_main+0xb94>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800aca:	a1 20 60 80 00       	mov    0x806020,%eax
  800acf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ad8:	89 d0                	mov    %edx,%eax
  800ada:	01 c0                	add    %eax,%eax
  800adc:	01 d0                	add    %edx,%eax
  800ade:	c1 e0 03             	shl    $0x3,%eax
  800ae1:	01 c8                	add    %ecx,%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800aeb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800af1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800afe:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b04:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	75 03                	jne    800b16 <_main+0xade>
				found++;
  800b13:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b16:	a1 20 60 80 00       	mov    0x806020,%eax
  800b1b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b24:	89 d0                	mov    %edx,%eax
  800b26:	01 c0                	add    %eax,%eax
  800b28:	01 d0                	add    %edx,%eax
  800b2a:	c1 e0 03             	shl    $0x3,%eax
  800b2d:	01 c8                	add    %ecx,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b37:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b4a:	89 c1                	mov    %eax,%ecx
  800b4c:	c1 e9 1f             	shr    $0x1f,%ecx
  800b4f:	01 c8                	add    %ecx,%eax
  800b51:	d1 f8                	sar    %eax
  800b53:	89 c1                	mov    %eax,%ecx
  800b55:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b5b:	01 c8                	add    %ecx,%eax
  800b5d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b63:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b6e:	39 c2                	cmp    %eax,%edx
  800b70:	75 03                	jne    800b75 <_main+0xb3d>
				found++;
  800b72:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b75:	a1 20 60 80 00       	mov    0x806020,%eax
  800b7a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b83:	89 d0                	mov    %edx,%eax
  800b85:	01 c0                	add    %eax,%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	c1 e0 03             	shl    $0x3,%eax
  800b8c:	01 c8                	add    %ecx,%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b96:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800b9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba1:	89 c1                	mov    %eax,%ecx
  800ba3:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800ba9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800baf:	01 d0                	add    %edx,%eax
  800bb1:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800bb7:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc2:	39 c1                	cmp    %eax,%ecx
  800bc4:	75 03                	jne    800bc9 <_main+0xb91>
				found++;
  800bc6:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bc9:	ff 45 ec             	incl   -0x14(%ebp)
  800bcc:	a1 20 60 80 00       	mov    0x806020,%eax
  800bd1:	8b 50 74             	mov    0x74(%eax),%edx
  800bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd7:	39 c2                	cmp    %eax,%edx
  800bd9:	0f 87 eb fe ff ff    	ja     800aca <_main+0xa92>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bdf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be3:	74 17                	je     800bfc <_main+0xbc4>
  800be5:	83 ec 04             	sub    $0x4,%esp
  800be8:	68 8c 4a 80 00       	push   $0x804a8c
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 9c 49 80 00       	push   $0x80499c
  800bf7:	e8 3d 0d 00 00       	call   801939 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 40 24 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c07:	89 d0                	mov    %edx,%eax
  800c09:	01 c0                	add    %eax,%eax
  800c0b:	01 d0                	add    %edx,%eax
  800c0d:	01 c0                	add    %eax,%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	01 c0                	add    %eax,%eax
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	50                   	push   %eax
  800c17:	e8 21 1f 00 00       	call   802b3d <malloc>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c25:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c2b:	89 c1                	mov    %eax,%ecx
  800c2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c30:	89 d0                	mov    %edx,%eax
  800c32:	01 c0                	add    %eax,%eax
  800c34:	01 d0                	add    %edx,%eax
  800c36:	c1 e0 02             	shl    $0x2,%eax
  800c39:	01 d0                	add    %edx,%eax
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c40:	c1 e0 04             	shl    $0x4,%eax
  800c43:	01 d0                	add    %edx,%eax
  800c45:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4a:	39 c1                	cmp    %eax,%ecx
  800c4c:	72 29                	jb     800c77 <_main+0xc3f>
  800c4e:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c54:	89 c1                	mov    %eax,%ecx
  800c56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c59:	89 d0                	mov    %edx,%eax
  800c5b:	01 c0                	add    %eax,%eax
  800c5d:	01 d0                	add    %edx,%eax
  800c5f:	c1 e0 02             	shl    $0x2,%eax
  800c62:	01 d0                	add    %edx,%eax
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c69:	c1 e0 04             	shl    $0x4,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c73:	39 c1                	cmp    %eax,%ecx
  800c75:	76 17                	jbe    800c8e <_main+0xc56>
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	68 b0 49 80 00       	push   $0x8049b0
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 9c 49 80 00       	push   $0x80499c
  800c89:	e8 ab 0c 00 00       	call   801939 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 ae 23 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 18 4a 80 00       	push   $0x804a18
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 9c 49 80 00       	push   $0x80499c
  800caa:	e8 8a 0c 00 00       	call   801939 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 ed 22 00 00       	call   802fa1 <sys_calculate_free_frames>
  800cb4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb7:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800cbd:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800cc6:	89 d0                	mov    %edx,%eax
  800cc8:	01 c0                	add    %eax,%eax
  800cca:	01 d0                	add    %edx,%eax
  800ccc:	01 c0                	add    %eax,%eax
  800cce:	01 d0                	add    %edx,%eax
  800cd0:	01 c0                	add    %eax,%eax
  800cd2:	d1 e8                	shr    %eax
  800cd4:	48                   	dec    %eax
  800cd5:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		shortArr2[0] = minShort;
  800cdb:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800ce1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ce4:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce7:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800ced:	01 c0                	add    %eax,%eax
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cf7:	01 c2                	add    %eax,%edx
  800cf9:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800cfd:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d00:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800d03:	e8 99 22 00 00       	call   802fa1 <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 48 4a 80 00       	push   $0x804a48
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 9c 49 80 00       	push   $0x80499c
  800d23:	e8 11 0c 00 00       	call   801939 <_panic>
		found = 0;
  800d28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d36:	e9 a7 00 00 00       	jmp    800de2 <_main+0xdaa>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3b:	a1 20 60 80 00       	mov    0x806020,%eax
  800d40:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d49:	89 d0                	mov    %edx,%eax
  800d4b:	01 c0                	add    %eax,%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	c1 e0 03             	shl    $0x3,%eax
  800d52:	01 c8                	add    %ecx,%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d5c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d67:	89 c2                	mov    %eax,%edx
  800d69:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d6f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d75:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d80:	39 c2                	cmp    %eax,%edx
  800d82:	75 03                	jne    800d87 <_main+0xd4f>
				found++;
  800d84:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d87:	a1 20 60 80 00       	mov    0x806020,%eax
  800d8c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d95:	89 d0                	mov    %edx,%eax
  800d97:	01 c0                	add    %eax,%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	c1 e0 03             	shl    $0x3,%eax
  800d9e:	01 c8                	add    %ecx,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800da8:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dbb:	01 c0                	add    %eax,%eax
  800dbd:	89 c1                	mov    %eax,%ecx
  800dbf:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dc5:	01 c8                	add    %ecx,%eax
  800dc7:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800dcd:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dd8:	39 c2                	cmp    %eax,%edx
  800dda:	75 03                	jne    800ddf <_main+0xda7>
				found++;
  800ddc:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ddf:	ff 45 ec             	incl   -0x14(%ebp)
  800de2:	a1 20 60 80 00       	mov    0x806020,%eax
  800de7:	8b 50 74             	mov    0x74(%eax),%edx
  800dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ded:	39 c2                	cmp    %eax,%edx
  800def:	0f 87 46 ff ff ff    	ja     800d3b <_main+0xd03>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df5:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800df9:	74 17                	je     800e12 <_main+0xdda>
  800dfb:	83 ec 04             	sub    $0x4,%esp
  800dfe:	68 8c 4a 80 00       	push   $0x804a8c
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 9c 49 80 00       	push   $0x80499c
  800e0d:	e8 27 0b 00 00       	call   801939 <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 8a 21 00 00       	call   802fa1 <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 1f 22 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 91 1d 00 00       	call   802bc8 <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 02 22 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 ac 4a 80 00       	push   $0x804aac
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 9c 49 80 00       	push   $0x80499c
  800e59:	e8 db 0a 00 00       	call   801939 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 3e 21 00 00       	call   802fa1 <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 e8 4a 80 00       	push   $0x804ae8
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 9c 49 80 00       	push   $0x80499c
  800e86:	e8 ae 0a 00 00       	call   801939 <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800e92:	e9 c2 00 00 00       	jmp    800f59 <_main+0xf21>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800e97:	a1 20 60 80 00       	mov    0x806020,%eax
  800e9c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ea2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ea5:	89 d0                	mov    %edx,%eax
  800ea7:	01 c0                	add    %eax,%eax
  800ea9:	01 d0                	add    %edx,%eax
  800eab:	c1 e0 03             	shl    $0x3,%eax
  800eae:	01 c8                	add    %ecx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800eb8:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ebe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec3:	89 c2                	mov    %eax,%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800ece:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800ed4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed9:	39 c2                	cmp    %eax,%edx
  800edb:	75 17                	jne    800ef4 <_main+0xebc>
				panic("free: page is not removed from WS");
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	68 34 4b 80 00       	push   $0x804b34
  800ee5:	68 dc 00 00 00       	push   $0xdc
  800eea:	68 9c 49 80 00       	push   $0x80499c
  800eef:	e8 45 0a 00 00       	call   801939 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800ef4:	a1 20 60 80 00       	mov    0x806020,%eax
  800ef9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f02:	89 d0                	mov    %edx,%eax
  800f04:	01 c0                	add    %eax,%eax
  800f06:	01 d0                	add    %edx,%eax
  800f08:	c1 e0 03             	shl    $0x3,%eax
  800f0b:	01 c8                	add    %ecx,%eax
  800f0d:	8b 00                	mov    (%eax),%eax
  800f0f:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f15:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f20:	89 c1                	mov    %eax,%ecx
  800f22:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800f25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800f30:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f3b:	39 c1                	cmp    %eax,%ecx
  800f3d:	75 17                	jne    800f56 <_main+0xf1e>
				panic("free: page is not removed from WS");
  800f3f:	83 ec 04             	sub    $0x4,%esp
  800f42:	68 34 4b 80 00       	push   $0x804b34
  800f47:	68 de 00 00 00       	push   $0xde
  800f4c:	68 9c 49 80 00       	push   $0x80499c
  800f51:	e8 e3 09 00 00       	call   801939 <_panic>
		free(ptr_allocations[0]);

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800f56:	ff 45 e4             	incl   -0x1c(%ebp)
  800f59:	a1 20 60 80 00       	mov    0x806020,%eax
  800f5e:	8b 50 74             	mov    0x74(%eax),%edx
  800f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f64:	39 c2                	cmp    %eax,%edx
  800f66:	0f 87 2b ff ff ff    	ja     800e97 <_main+0xe5f>
				panic("free: page is not removed from WS");
		}


		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800f6c:	e8 30 20 00 00       	call   802fa1 <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 c5 20 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 37 1c 00 00       	call   802bc8 <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 a8 20 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 ac 4a 80 00       	push   $0x804aac
  800fa9:	68 e6 00 00 00       	push   $0xe6
  800fae:	68 9c 49 80 00       	push   $0x80499c
  800fb3:	e8 81 09 00 00       	call   801939 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly    %d",(sys_calculate_free_frames() - freeFrames));
  800fb8:	e8 e4 1f 00 00       	call   802fa1 <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 26                	je     800ff4 <_main+0xfbc>
  800fce:	e8 ce 1f 00 00       	call   802fa1 <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	50                   	push   %eax
  800fe0:	68 58 4b 80 00       	push   $0x804b58
  800fe5:	68 e7 00 00 00       	push   $0xe7
  800fea:	68 9c 49 80 00       	push   $0x80499c
  800fef:	e8 45 09 00 00       	call   801939 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ff4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ffb:	e9 c6 00 00 00       	jmp    8010c6 <_main+0x108e>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  801000:	a1 20 60 80 00       	mov    0x806020,%eax
  801005:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80100b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80100e:	89 d0                	mov    %edx,%eax
  801010:	01 c0                	add    %eax,%eax
  801012:	01 d0                	add    %edx,%eax
  801014:	c1 e0 03             	shl    $0x3,%eax
  801017:	01 c8                	add    %ecx,%eax
  801019:	8b 00                	mov    (%eax),%eax
  80101b:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  801021:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801027:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80102c:	89 c2                	mov    %eax,%edx
  80102e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801031:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801037:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80103d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801042:	39 c2                	cmp    %eax,%edx
  801044:	75 17                	jne    80105d <_main+0x1025>
				panic("free: page is not removed from WS");
  801046:	83 ec 04             	sub    $0x4,%esp
  801049:	68 34 4b 80 00       	push   $0x804b34
  80104e:	68 eb 00 00 00       	push   $0xeb
  801053:	68 9c 49 80 00       	push   $0x80499c
  801058:	e8 dc 08 00 00       	call   801939 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80105d:	a1 20 60 80 00       	mov    0x806020,%eax
  801062:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801068:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80106b:	89 d0                	mov    %edx,%eax
  80106d:	01 c0                	add    %eax,%eax
  80106f:	01 d0                	add    %edx,%eax
  801071:	c1 e0 03             	shl    $0x3,%eax
  801074:	01 c8                	add    %ecx,%eax
  801076:	8b 00                	mov    (%eax),%eax
  801078:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  80107e:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  801084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801089:	89 c2                	mov    %eax,%edx
  80108b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80108e:	01 c0                	add    %eax,%eax
  801090:	89 c1                	mov    %eax,%ecx
  801092:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801095:	01 c8                	add    %ecx,%eax
  801097:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  80109d:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8010a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a8:	39 c2                	cmp    %eax,%edx
  8010aa:	75 17                	jne    8010c3 <_main+0x108b>
				panic("free: page is not removed from WS");
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	68 34 4b 80 00       	push   $0x804b34
  8010b4:	68 ed 00 00 00       	push   $0xed
  8010b9:	68 9c 49 80 00       	push   $0x80499c
  8010be:	e8 76 08 00 00       	call   801939 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[1]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly    %d",(sys_calculate_free_frames() - freeFrames));
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010c3:	ff 45 e4             	incl   -0x1c(%ebp)
  8010c6:	a1 20 60 80 00       	mov    0x806020,%eax
  8010cb:	8b 50 74             	mov    0x74(%eax),%edx
  8010ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010d1:	39 c2                	cmp    %eax,%edx
  8010d3:	0f 87 27 ff ff ff    	ja     801000 <_main+0xfc8>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 6 MB
		freeFrames = sys_calculate_free_frames() ;
  8010d9:	e8 c3 1e 00 00       	call   802fa1 <sys_calculate_free_frames>
  8010de:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010e4:	e8 58 1f 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8010e9:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010ef:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010f5:	83 ec 0c             	sub    $0xc,%esp
  8010f8:	50                   	push   %eax
  8010f9:	e8 ca 1a 00 00       	call   802bc8 <free>
  8010fe:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801101:	e8 3b 1f 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  801106:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80110c:	74 17                	je     801125 <_main+0x10ed>
  80110e:	83 ec 04             	sub    $0x4,%esp
  801111:	68 ac 4a 80 00       	push   $0x804aac
  801116:	68 f4 00 00 00       	push   $0xf4
  80111b:	68 9c 49 80 00       	push   $0x80499c
  801120:	e8 14 08 00 00       	call   801939 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801125:	e8 77 1e 00 00       	call   802fa1 <sys_calculate_free_frames>
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801132:	29 c2                	sub    %eax,%edx
  801134:	89 d0                	mov    %edx,%eax
  801136:	83 f8 04             	cmp    $0x4,%eax
  801139:	74 17                	je     801152 <_main+0x111a>
  80113b:	83 ec 04             	sub    $0x4,%esp
  80113e:	68 e8 4a 80 00       	push   $0x804ae8
  801143:	68 f5 00 00 00       	push   $0xf5
  801148:	68 9c 49 80 00       	push   $0x80499c
  80114d:	e8 e7 07 00 00       	call   801939 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801152:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801159:	e9 3e 01 00 00       	jmp    80129c <_main+0x1264>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80115e:	a1 20 60 80 00       	mov    0x806020,%eax
  801163:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801169:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80116c:	89 d0                	mov    %edx,%eax
  80116e:	01 c0                	add    %eax,%eax
  801170:	01 d0                	add    %edx,%eax
  801172:	c1 e0 03             	shl    $0x3,%eax
  801175:	01 c8                	add    %ecx,%eax
  801177:	8b 00                	mov    (%eax),%eax
  801179:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  80117f:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  801185:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801192:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  801198:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  80119e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a3:	39 c2                	cmp    %eax,%edx
  8011a5:	75 17                	jne    8011be <_main+0x1186>
				panic("free: page is not removed from WS");
  8011a7:	83 ec 04             	sub    $0x4,%esp
  8011aa:	68 34 4b 80 00       	push   $0x804b34
  8011af:	68 f9 00 00 00       	push   $0xf9
  8011b4:	68 9c 49 80 00       	push   $0x80499c
  8011b9:	e8 7b 07 00 00       	call   801939 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  8011be:	a1 20 60 80 00       	mov    0x806020,%eax
  8011c3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011cc:	89 d0                	mov    %edx,%eax
  8011ce:	01 c0                	add    %eax,%eax
  8011d0:	01 d0                	add    %edx,%eax
  8011d2:	c1 e0 03             	shl    $0x3,%eax
  8011d5:	01 c8                	add    %ecx,%eax
  8011d7:	8b 00                	mov    (%eax),%eax
  8011d9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  8011df:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ea:	89 c2                	mov    %eax,%edx
  8011ec:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011f2:	89 c1                	mov    %eax,%ecx
  8011f4:	c1 e9 1f             	shr    $0x1f,%ecx
  8011f7:	01 c8                	add    %ecx,%eax
  8011f9:	d1 f8                	sar    %eax
  8011fb:	89 c1                	mov    %eax,%ecx
  8011fd:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801203:	01 c8                	add    %ecx,%eax
  801205:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  80120b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801211:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801216:	39 c2                	cmp    %eax,%edx
  801218:	75 17                	jne    801231 <_main+0x11f9>
				panic("free: page is not removed from WS");
  80121a:	83 ec 04             	sub    $0x4,%esp
  80121d:	68 34 4b 80 00       	push   $0x804b34
  801222:	68 fb 00 00 00       	push   $0xfb
  801227:	68 9c 49 80 00       	push   $0x80499c
  80122c:	e8 08 07 00 00       	call   801939 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  801231:	a1 20 60 80 00       	mov    0x806020,%eax
  801236:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80123c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80123f:	89 d0                	mov    %edx,%eax
  801241:	01 c0                	add    %eax,%eax
  801243:	01 d0                	add    %edx,%eax
  801245:	c1 e0 03             	shl    $0x3,%eax
  801248:	01 c8                	add    %ecx,%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  801252:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  801258:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80125d:	89 c1                	mov    %eax,%ecx
  80125f:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  801265:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  801273:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  801279:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80127e:	39 c1                	cmp    %eax,%ecx
  801280:	75 17                	jne    801299 <_main+0x1261>
				panic("free: page is not removed from WS");
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	68 34 4b 80 00       	push   $0x804b34
  80128a:	68 fd 00 00 00       	push   $0xfd
  80128f:	68 9c 49 80 00       	push   $0x80499c
  801294:	e8 a0 06 00 00       	call   801939 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801299:	ff 45 e4             	incl   -0x1c(%ebp)
  80129c:	a1 20 60 80 00       	mov    0x806020,%eax
  8012a1:	8b 50 74             	mov    0x74(%eax),%edx
  8012a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a7:	39 c2                	cmp    %eax,%edx
  8012a9:	0f 87 af fe ff ff    	ja     80115e <_main+0x1126>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  8012af:	e8 ed 1c 00 00       	call   802fa1 <sys_calculate_free_frames>
  8012b4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012ba:	e8 82 1d 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8012bf:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012c5:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012cb:	83 ec 0c             	sub    $0xc,%esp
  8012ce:	50                   	push   %eax
  8012cf:	e8 f4 18 00 00       	call   802bc8 <free>
  8012d4:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012d7:	e8 65 1d 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8012dc:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012e2:	74 17                	je     8012fb <_main+0x12c3>
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 ac 4a 80 00       	push   $0x804aac
  8012ec:	68 04 01 00 00       	push   $0x104
  8012f1:	68 9c 49 80 00       	push   $0x80499c
  8012f6:	e8 3e 06 00 00       	call   801939 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012fb:	e8 a1 1c 00 00       	call   802fa1 <sys_calculate_free_frames>
  801300:	89 c2                	mov    %eax,%edx
  801302:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801308:	29 c2                	sub    %eax,%edx
  80130a:	89 d0                	mov    %edx,%eax
  80130c:	83 f8 02             	cmp    $0x2,%eax
  80130f:	74 17                	je     801328 <_main+0x12f0>
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	68 e8 4a 80 00       	push   $0x804ae8
  801319:	68 05 01 00 00       	push   $0x105
  80131e:	68 9c 49 80 00       	push   $0x80499c
  801323:	e8 11 06 00 00       	call   801939 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801328:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80132f:	e9 d2 00 00 00       	jmp    801406 <_main+0x13ce>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  801334:	a1 20 60 80 00       	mov    0x806020,%eax
  801339:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801342:	89 d0                	mov    %edx,%eax
  801344:	01 c0                	add    %eax,%eax
  801346:	01 d0                	add    %edx,%eax
  801348:	c1 e0 03             	shl    $0x3,%eax
  80134b:	01 c8                	add    %ecx,%eax
  80134d:	8b 00                	mov    (%eax),%eax
  80134f:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  801355:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80135b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801360:	89 c2                	mov    %eax,%edx
  801362:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801368:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  80136e:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  801374:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801379:	39 c2                	cmp    %eax,%edx
  80137b:	75 17                	jne    801394 <_main+0x135c>
				panic("free: page is not removed from WS");
  80137d:	83 ec 04             	sub    $0x4,%esp
  801380:	68 34 4b 80 00       	push   $0x804b34
  801385:	68 09 01 00 00       	push   $0x109
  80138a:	68 9c 49 80 00       	push   $0x80499c
  80138f:	e8 a5 05 00 00       	call   801939 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  801394:	a1 20 60 80 00       	mov    0x806020,%eax
  801399:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80139f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013a2:	89 d0                	mov    %edx,%eax
  8013a4:	01 c0                	add    %eax,%eax
  8013a6:	01 d0                	add    %edx,%eax
  8013a8:	c1 e0 03             	shl    $0x3,%eax
  8013ab:	01 c8                	add    %ecx,%eax
  8013ad:	8b 00                	mov    (%eax),%eax
  8013af:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  8013b5:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8013bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c0:	89 c2                	mov    %eax,%edx
  8013c2:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8013c8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8013cf:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013d5:	01 c8                	add    %ecx,%eax
  8013d7:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8013dd:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8013e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e8:	39 c2                	cmp    %eax,%edx
  8013ea:	75 17                	jne    801403 <_main+0x13cb>
				panic("free: page is not removed from WS");
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	68 34 4b 80 00       	push   $0x804b34
  8013f4:	68 0b 01 00 00       	push   $0x10b
  8013f9:	68 9c 49 80 00       	push   $0x80499c
  8013fe:	e8 36 05 00 00       	call   801939 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801403:	ff 45 e4             	incl   -0x1c(%ebp)
  801406:	a1 20 60 80 00       	mov    0x806020,%eax
  80140b:	8b 50 74             	mov    0x74(%eax),%edx
  80140e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801411:	39 c2                	cmp    %eax,%edx
  801413:	0f 87 1b ff ff ff    	ja     801334 <_main+0x12fc>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  801419:	e8 83 1b 00 00       	call   802fa1 <sys_calculate_free_frames>
  80141e:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801424:	e8 18 1c 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  801429:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  80142f:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801435:	83 ec 0c             	sub    $0xc,%esp
  801438:	50                   	push   %eax
  801439:	e8 8a 17 00 00       	call   802bc8 <free>
  80143e:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801441:	e8 fb 1b 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  801446:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80144c:	74 17                	je     801465 <_main+0x142d>
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	68 ac 4a 80 00       	push   $0x804aac
  801456:	68 12 01 00 00       	push   $0x112
  80145b:	68 9c 49 80 00       	push   $0x80499c
  801460:	e8 d4 04 00 00       	call   801939 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801465:	e8 37 1b 00 00       	call   802fa1 <sys_calculate_free_frames>
  80146a:	89 c2                	mov    %eax,%edx
  80146c:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801472:	39 c2                	cmp    %eax,%edx
  801474:	74 17                	je     80148d <_main+0x1455>
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	68 e8 4a 80 00       	push   $0x804ae8
  80147e:	68 13 01 00 00       	push   $0x113
  801483:	68 9c 49 80 00       	push   $0x80499c
  801488:	e8 ac 04 00 00       	call   801939 <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80148d:	e8 0f 1b 00 00       	call   802fa1 <sys_calculate_free_frames>
  801492:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801498:	e8 a4 1b 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  80149d:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  8014a3:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	50                   	push   %eax
  8014ad:	e8 16 17 00 00       	call   802bc8 <free>
  8014b2:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014b5:	e8 87 1b 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8014ba:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014c0:	74 17                	je     8014d9 <_main+0x14a1>
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	68 ac 4a 80 00       	push   $0x804aac
  8014ca:	68 19 01 00 00       	push   $0x119
  8014cf:	68 9c 49 80 00       	push   $0x80499c
  8014d4:	e8 60 04 00 00       	call   801939 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014d9:	e8 c3 1a 00 00       	call   802fa1 <sys_calculate_free_frames>
  8014de:	89 c2                	mov    %eax,%edx
  8014e0:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014e6:	29 c2                	sub    %eax,%edx
  8014e8:	89 d0                	mov    %edx,%eax
  8014ea:	83 f8 02             	cmp    $0x2,%eax
  8014ed:	74 17                	je     801506 <_main+0x14ce>
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	68 e8 4a 80 00       	push   $0x804ae8
  8014f7:	68 1a 01 00 00       	push   $0x11a
  8014fc:	68 9c 49 80 00       	push   $0x80499c
  801501:	e8 33 04 00 00       	call   801939 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801506:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80150d:	e9 c9 00 00 00       	jmp    8015db <_main+0x15a3>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  801512:	a1 20 60 80 00       	mov    0x806020,%eax
  801517:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80151d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801520:	89 d0                	mov    %edx,%eax
  801522:	01 c0                	add    %eax,%eax
  801524:	01 d0                	add    %edx,%eax
  801526:	c1 e0 03             	shl    $0x3,%eax
  801529:	01 c8                	add    %ecx,%eax
  80152b:	8b 00                	mov    (%eax),%eax
  80152d:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801533:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801539:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 8c             	mov    -0x74(%ebp),%eax
  801543:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  801549:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80154f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801554:	39 c2                	cmp    %eax,%edx
  801556:	75 17                	jne    80156f <_main+0x1537>
				panic("free: page is not removed from WS");
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	68 34 4b 80 00       	push   $0x804b34
  801560:	68 1e 01 00 00       	push   $0x11e
  801565:	68 9c 49 80 00       	push   $0x80499c
  80156a:	e8 ca 03 00 00       	call   801939 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  80156f:	a1 20 60 80 00       	mov    0x806020,%eax
  801574:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80157a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80157d:	89 d0                	mov    %edx,%eax
  80157f:	01 c0                	add    %eax,%eax
  801581:	01 d0                	add    %edx,%eax
  801583:	c1 e0 03             	shl    $0x3,%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  801590:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801596:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159b:	89 c2                	mov    %eax,%edx
  80159d:	8b 45 88             	mov    -0x78(%ebp),%eax
  8015a0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8015a7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8015aa:	01 c8                	add    %ecx,%eax
  8015ac:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  8015b2:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8015b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015bd:	39 c2                	cmp    %eax,%edx
  8015bf:	75 17                	jne    8015d8 <_main+0x15a0>
				panic("free: page is not removed from WS");
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 34 4b 80 00       	push   $0x804b34
  8015c9:	68 20 01 00 00       	push   $0x120
  8015ce:	68 9c 49 80 00       	push   $0x80499c
  8015d3:	e8 61 03 00 00       	call   801939 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8015d8:	ff 45 e4             	incl   -0x1c(%ebp)
  8015db:	a1 20 60 80 00       	mov    0x806020,%eax
  8015e0:	8b 50 74             	mov    0x74(%eax),%edx
  8015e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e6:	39 c2                	cmp    %eax,%edx
  8015e8:	0f 87 24 ff ff ff    	ja     801512 <_main+0x14da>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8015ee:	e8 ae 19 00 00       	call   802fa1 <sys_calculate_free_frames>
  8015f3:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015f9:	e8 43 1a 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  8015fe:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  801604:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	50                   	push   %eax
  80160e:	e8 b5 15 00 00       	call   802bc8 <free>
  801613:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801616:	e8 26 1a 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  80161b:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801621:	74 17                	je     80163a <_main+0x1602>
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 ac 4a 80 00       	push   $0x804aac
  80162b:	68 27 01 00 00       	push   $0x127
  801630:	68 9c 49 80 00       	push   $0x80499c
  801635:	e8 ff 02 00 00       	call   801939 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80163a:	e8 62 19 00 00       	call   802fa1 <sys_calculate_free_frames>
  80163f:	89 c2                	mov    %eax,%edx
  801641:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801647:	39 c2                	cmp    %eax,%edx
  801649:	74 17                	je     801662 <_main+0x162a>
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	68 e8 4a 80 00       	push   $0x804ae8
  801653:	68 28 01 00 00       	push   $0x128
  801658:	68 9c 49 80 00       	push   $0x80499c
  80165d:	e8 d7 02 00 00       	call   801939 <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801662:	e8 3a 19 00 00       	call   802fa1 <sys_calculate_free_frames>
  801667:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80166d:	e8 cf 19 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  801672:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801678:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80167e:	83 ec 0c             	sub    $0xc,%esp
  801681:	50                   	push   %eax
  801682:	e8 41 15 00 00       	call   802bc8 <free>
  801687:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80168a:	e8 b2 19 00 00       	call   803041 <sys_pf_calculate_allocated_pages>
  80168f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801695:	74 17                	je     8016ae <_main+0x1676>
  801697:	83 ec 04             	sub    $0x4,%esp
  80169a:	68 ac 4a 80 00       	push   $0x804aac
  80169f:	68 2f 01 00 00       	push   $0x12f
  8016a4:	68 9c 49 80 00       	push   $0x80499c
  8016a9:	e8 8b 02 00 00       	call   801939 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8016ae:	e8 ee 18 00 00       	call   802fa1 <sys_calculate_free_frames>
  8016b3:	89 c2                	mov    %eax,%edx
  8016b5:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016bb:	29 c2                	sub    %eax,%edx
  8016bd:	89 d0                	mov    %edx,%eax
  8016bf:	83 f8 03             	cmp    $0x3,%eax
  8016c2:	74 17                	je     8016db <_main+0x16a3>
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	68 e8 4a 80 00       	push   $0x804ae8
  8016cc:	68 30 01 00 00       	push   $0x130
  8016d1:	68 9c 49 80 00       	push   $0x80499c
  8016d6:	e8 5e 02 00 00       	call   801939 <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8016db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016e2:	e9 c6 00 00 00       	jmp    8017ad <_main+0x1775>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  8016e7:	a1 20 60 80 00       	mov    0x806020,%eax
  8016ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8016f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	01 c0                	add    %eax,%eax
  8016f9:	01 d0                	add    %edx,%eax
  8016fb:	c1 e0 03             	shl    $0x3,%eax
  8016fe:	01 c8                	add    %ecx,%eax
  801700:	8b 00                	mov    (%eax),%eax
  801702:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  801708:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  80170e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801713:	89 c2                	mov    %eax,%edx
  801715:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801718:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  80171e:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  801724:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801729:	39 c2                	cmp    %eax,%edx
  80172b:	75 17                	jne    801744 <_main+0x170c>
				panic("free: page is not removed from WS");
  80172d:	83 ec 04             	sub    $0x4,%esp
  801730:	68 34 4b 80 00       	push   $0x804b34
  801735:	68 34 01 00 00       	push   $0x134
  80173a:	68 9c 49 80 00       	push   $0x80499c
  80173f:	e8 f5 01 00 00       	call   801939 <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  801744:	a1 20 60 80 00       	mov    0x806020,%eax
  801749:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80174f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801752:	89 d0                	mov    %edx,%eax
  801754:	01 c0                	add    %eax,%eax
  801756:	01 d0                	add    %edx,%eax
  801758:	c1 e0 03             	shl    $0x3,%eax
  80175b:	01 c8                	add    %ecx,%eax
  80175d:	8b 00                	mov    (%eax),%eax
  80175f:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  801765:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  80176b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801770:	89 c2                	mov    %eax,%edx
  801772:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801775:	01 c0                	add    %eax,%eax
  801777:	89 c1                	mov    %eax,%ecx
  801779:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80177c:	01 c8                	add    %ecx,%eax
  80177e:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  801784:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  80178a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80178f:	39 c2                	cmp    %eax,%edx
  801791:	75 17                	jne    8017aa <_main+0x1772>
				panic("free: page is not removed from WS");
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 34 4b 80 00       	push   $0x804b34
  80179b:	68 36 01 00 00       	push   $0x136
  8017a0:	68 9c 49 80 00       	push   $0x80499c
  8017a5:	e8 8f 01 00 00       	call   801939 <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8017aa:	ff 45 e4             	incl   -0x1c(%ebp)
  8017ad:	a1 20 60 80 00       	mov    0x806020,%eax
  8017b2:	8b 50 74             	mov    0x74(%eax),%edx
  8017b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b8:	39 c2                	cmp    %eax,%edx
  8017ba:	0f 87 27 ff ff ff    	ja     8016e7 <_main+0x16af>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames())) {panic("Wrong free: not all pages removed correctly at end");}
  8017c0:	e8 dc 17 00 00       	call   802fa1 <sys_calculate_free_frames>
  8017c5:	89 c2                	mov    %eax,%edx
  8017c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017ca:	39 c2                	cmp    %eax,%edx
  8017cc:	74 17                	je     8017e5 <_main+0x17ad>
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	68 a8 4b 80 00       	push   $0x804ba8
  8017d6:	68 39 01 00 00       	push   $0x139
  8017db:	68 9c 49 80 00       	push   $0x80499c
  8017e0:	e8 54 01 00 00       	call   801939 <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	68 dc 4b 80 00       	push   $0x804bdc
  8017ed:	e8 fb 03 00 00       	call   801bed <cprintf>
  8017f2:	83 c4 10             	add    $0x10,%esp

	return;
  8017f5:	90                   	nop
}
  8017f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5f                   	pop    %edi
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801803:	e8 79 1a 00 00       	call   803281 <sys_getenvindex>
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80180b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180e:	89 d0                	mov    %edx,%eax
  801810:	c1 e0 03             	shl    $0x3,%eax
  801813:	01 d0                	add    %edx,%eax
  801815:	01 c0                	add    %eax,%eax
  801817:	01 d0                	add    %edx,%eax
  801819:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801820:	01 d0                	add    %edx,%eax
  801822:	c1 e0 04             	shl    $0x4,%eax
  801825:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80182a:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80182f:	a1 20 60 80 00       	mov    0x806020,%eax
  801834:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80183a:	84 c0                	test   %al,%al
  80183c:	74 0f                	je     80184d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80183e:	a1 20 60 80 00       	mov    0x806020,%eax
  801843:	05 5c 05 00 00       	add    $0x55c,%eax
  801848:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80184d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801851:	7e 0a                	jle    80185d <libmain+0x60>
		binaryname = argv[0];
  801853:	8b 45 0c             	mov    0xc(%ebp),%eax
  801856:	8b 00                	mov    (%eax),%eax
  801858:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80185d:	83 ec 08             	sub    $0x8,%esp
  801860:	ff 75 0c             	pushl  0xc(%ebp)
  801863:	ff 75 08             	pushl  0x8(%ebp)
  801866:	e8 cd e7 ff ff       	call   800038 <_main>
  80186b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80186e:	e8 1b 18 00 00       	call   80308e <sys_disable_interrupt>
	cprintf("**************************************\n");
  801873:	83 ec 0c             	sub    $0xc,%esp
  801876:	68 30 4c 80 00       	push   $0x804c30
  80187b:	e8 6d 03 00 00       	call   801bed <cprintf>
  801880:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801883:	a1 20 60 80 00       	mov    0x806020,%eax
  801888:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80188e:	a1 20 60 80 00       	mov    0x806020,%eax
  801893:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	68 58 4c 80 00       	push   $0x804c58
  8018a3:	e8 45 03 00 00       	call   801bed <cprintf>
  8018a8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8018ab:	a1 20 60 80 00       	mov    0x806020,%eax
  8018b0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8018b6:	a1 20 60 80 00       	mov    0x806020,%eax
  8018bb:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8018c1:	a1 20 60 80 00       	mov    0x806020,%eax
  8018c6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8018cc:	51                   	push   %ecx
  8018cd:	52                   	push   %edx
  8018ce:	50                   	push   %eax
  8018cf:	68 80 4c 80 00       	push   $0x804c80
  8018d4:	e8 14 03 00 00       	call   801bed <cprintf>
  8018d9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018dc:	a1 20 60 80 00       	mov    0x806020,%eax
  8018e1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	50                   	push   %eax
  8018eb:	68 d8 4c 80 00       	push   $0x804cd8
  8018f0:	e8 f8 02 00 00       	call   801bed <cprintf>
  8018f5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8018f8:	83 ec 0c             	sub    $0xc,%esp
  8018fb:	68 30 4c 80 00       	push   $0x804c30
  801900:	e8 e8 02 00 00       	call   801bed <cprintf>
  801905:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801908:	e8 9b 17 00 00       	call   8030a8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80190d:	e8 19 00 00 00       	call   80192b <exit>
}
  801912:	90                   	nop
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80191b:	83 ec 0c             	sub    $0xc,%esp
  80191e:	6a 00                	push   $0x0
  801920:	e8 28 19 00 00       	call   80324d <sys_destroy_env>
  801925:	83 c4 10             	add    $0x10,%esp
}
  801928:	90                   	nop
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <exit>:

void
exit(void)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801931:	e8 7d 19 00 00       	call   8032b3 <sys_exit_env>
}
  801936:	90                   	nop
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80193f:	8d 45 10             	lea    0x10(%ebp),%eax
  801942:	83 c0 04             	add    $0x4,%eax
  801945:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801948:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80194d:	85 c0                	test   %eax,%eax
  80194f:	74 16                	je     801967 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801951:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801956:	83 ec 08             	sub    $0x8,%esp
  801959:	50                   	push   %eax
  80195a:	68 ec 4c 80 00       	push   $0x804cec
  80195f:	e8 89 02 00 00       	call   801bed <cprintf>
  801964:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801967:	a1 00 60 80 00       	mov    0x806000,%eax
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	50                   	push   %eax
  801973:	68 f1 4c 80 00       	push   $0x804cf1
  801978:	e8 70 02 00 00       	call   801bed <cprintf>
  80197d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801980:	8b 45 10             	mov    0x10(%ebp),%eax
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	ff 75 f4             	pushl  -0xc(%ebp)
  801989:	50                   	push   %eax
  80198a:	e8 f3 01 00 00       	call   801b82 <vcprintf>
  80198f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	6a 00                	push   $0x0
  801997:	68 0d 4d 80 00       	push   $0x804d0d
  80199c:	e8 e1 01 00 00       	call   801b82 <vcprintf>
  8019a1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019a4:	e8 82 ff ff ff       	call   80192b <exit>

	// should not return here
	while (1) ;
  8019a9:	eb fe                	jmp    8019a9 <_panic+0x70>

008019ab <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8019b6:	8b 50 74             	mov    0x74(%eax),%edx
  8019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bc:	39 c2                	cmp    %eax,%edx
  8019be:	74 14                	je     8019d4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	68 10 4d 80 00       	push   $0x804d10
  8019c8:	6a 26                	push   $0x26
  8019ca:	68 5c 4d 80 00       	push   $0x804d5c
  8019cf:	e8 65 ff ff ff       	call   801939 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019e2:	e9 c2 00 00 00       	jmp    801aa9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8019e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	01 d0                	add    %edx,%eax
  8019f6:	8b 00                	mov    (%eax),%eax
  8019f8:	85 c0                	test   %eax,%eax
  8019fa:	75 08                	jne    801a04 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8019fc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019ff:	e9 a2 00 00 00       	jmp    801aa6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801a04:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a0b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a12:	eb 69                	jmp    801a7d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a14:	a1 20 60 80 00       	mov    0x806020,%eax
  801a19:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a22:	89 d0                	mov    %edx,%eax
  801a24:	01 c0                	add    %eax,%eax
  801a26:	01 d0                	add    %edx,%eax
  801a28:	c1 e0 03             	shl    $0x3,%eax
  801a2b:	01 c8                	add    %ecx,%eax
  801a2d:	8a 40 04             	mov    0x4(%eax),%al
  801a30:	84 c0                	test   %al,%al
  801a32:	75 46                	jne    801a7a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a34:	a1 20 60 80 00       	mov    0x806020,%eax
  801a39:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a42:	89 d0                	mov    %edx,%eax
  801a44:	01 c0                	add    %eax,%eax
  801a46:	01 d0                	add    %edx,%eax
  801a48:	c1 e0 03             	shl    $0x3,%eax
  801a4b:	01 c8                	add    %ecx,%eax
  801a4d:	8b 00                	mov    (%eax),%eax
  801a4f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a5a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	01 c8                	add    %ecx,%eax
  801a6b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a6d:	39 c2                	cmp    %eax,%edx
  801a6f:	75 09                	jne    801a7a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801a71:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a78:	eb 12                	jmp    801a8c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a7a:	ff 45 e8             	incl   -0x18(%ebp)
  801a7d:	a1 20 60 80 00       	mov    0x806020,%eax
  801a82:	8b 50 74             	mov    0x74(%eax),%edx
  801a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a88:	39 c2                	cmp    %eax,%edx
  801a8a:	77 88                	ja     801a14 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a90:	75 14                	jne    801aa6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	68 68 4d 80 00       	push   $0x804d68
  801a9a:	6a 3a                	push   $0x3a
  801a9c:	68 5c 4d 80 00       	push   $0x804d5c
  801aa1:	e8 93 fe ff ff       	call   801939 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801aa6:	ff 45 f0             	incl   -0x10(%ebp)
  801aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801aaf:	0f 8c 32 ff ff ff    	jl     8019e7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ab5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801abc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ac3:	eb 26                	jmp    801aeb <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ac5:	a1 20 60 80 00       	mov    0x806020,%eax
  801aca:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801ad0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ad3:	89 d0                	mov    %edx,%eax
  801ad5:	01 c0                	add    %eax,%eax
  801ad7:	01 d0                	add    %edx,%eax
  801ad9:	c1 e0 03             	shl    $0x3,%eax
  801adc:	01 c8                	add    %ecx,%eax
  801ade:	8a 40 04             	mov    0x4(%eax),%al
  801ae1:	3c 01                	cmp    $0x1,%al
  801ae3:	75 03                	jne    801ae8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801ae5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ae8:	ff 45 e0             	incl   -0x20(%ebp)
  801aeb:	a1 20 60 80 00       	mov    0x806020,%eax
  801af0:	8b 50 74             	mov    0x74(%eax),%edx
  801af3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af6:	39 c2                	cmp    %eax,%edx
  801af8:	77 cb                	ja     801ac5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b00:	74 14                	je     801b16 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	68 bc 4d 80 00       	push   $0x804dbc
  801b0a:	6a 44                	push   $0x44
  801b0c:	68 5c 4d 80 00       	push   $0x804d5c
  801b11:	e8 23 fe ff ff       	call   801939 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b16:	90                   	nop
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b22:	8b 00                	mov    (%eax),%eax
  801b24:	8d 48 01             	lea    0x1(%eax),%ecx
  801b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2a:	89 0a                	mov    %ecx,(%edx)
  801b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  801b2f:	88 d1                	mov    %dl,%cl
  801b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b34:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	8b 00                	mov    (%eax),%eax
  801b3d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b42:	75 2c                	jne    801b70 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801b44:	a0 24 60 80 00       	mov    0x806024,%al
  801b49:	0f b6 c0             	movzbl %al,%eax
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 12                	mov    (%edx),%edx
  801b51:	89 d1                	mov    %edx,%ecx
  801b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b56:	83 c2 08             	add    $0x8,%edx
  801b59:	83 ec 04             	sub    $0x4,%esp
  801b5c:	50                   	push   %eax
  801b5d:	51                   	push   %ecx
  801b5e:	52                   	push   %edx
  801b5f:	e8 7c 13 00 00       	call   802ee0 <sys_cputs>
  801b64:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b73:	8b 40 04             	mov    0x4(%eax),%eax
  801b76:	8d 50 01             	lea    0x1(%eax),%edx
  801b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7c:	89 50 04             	mov    %edx,0x4(%eax)
}
  801b7f:	90                   	nop
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b8b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b92:	00 00 00 
	b.cnt = 0;
  801b95:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801b9c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bab:	50                   	push   %eax
  801bac:	68 19 1b 80 00       	push   $0x801b19
  801bb1:	e8 11 02 00 00       	call   801dc7 <vprintfmt>
  801bb6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801bb9:	a0 24 60 80 00       	mov    0x806024,%al
  801bbe:	0f b6 c0             	movzbl %al,%eax
  801bc1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	50                   	push   %eax
  801bcb:	52                   	push   %edx
  801bcc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bd2:	83 c0 08             	add    $0x8,%eax
  801bd5:	50                   	push   %eax
  801bd6:	e8 05 13 00 00       	call   802ee0 <sys_cputs>
  801bdb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801bde:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  801be5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <cprintf>:

int cprintf(const char *fmt, ...) {
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801bf3:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  801bfa:	8d 45 0c             	lea    0xc(%ebp),%eax
  801bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	83 ec 08             	sub    $0x8,%esp
  801c06:	ff 75 f4             	pushl  -0xc(%ebp)
  801c09:	50                   	push   %eax
  801c0a:	e8 73 ff ff ff       	call   801b82 <vcprintf>
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801c20:	e8 69 14 00 00       	call   80308e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c25:	8d 45 0c             	lea    0xc(%ebp),%eax
  801c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	83 ec 08             	sub    $0x8,%esp
  801c31:	ff 75 f4             	pushl  -0xc(%ebp)
  801c34:	50                   	push   %eax
  801c35:	e8 48 ff ff ff       	call   801b82 <vcprintf>
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801c40:	e8 63 14 00 00       	call   8030a8 <sys_enable_interrupt>
	return cnt;
  801c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	53                   	push   %ebx
  801c4e:	83 ec 14             	sub    $0x14,%esp
  801c51:	8b 45 10             	mov    0x10(%ebp),%eax
  801c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c57:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c5d:	8b 45 18             	mov    0x18(%ebp),%eax
  801c60:	ba 00 00 00 00       	mov    $0x0,%edx
  801c65:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c68:	77 55                	ja     801cbf <printnum+0x75>
  801c6a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c6d:	72 05                	jb     801c74 <printnum+0x2a>
  801c6f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c72:	77 4b                	ja     801cbf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c74:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801c77:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c7a:	8b 45 18             	mov    0x18(%ebp),%eax
  801c7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c82:	52                   	push   %edx
  801c83:	50                   	push   %eax
  801c84:	ff 75 f4             	pushl  -0xc(%ebp)
  801c87:	ff 75 f0             	pushl  -0x10(%ebp)
  801c8a:	e8 81 2a 00 00       	call   804710 <__udivdi3>
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	ff 75 20             	pushl  0x20(%ebp)
  801c98:	53                   	push   %ebx
  801c99:	ff 75 18             	pushl  0x18(%ebp)
  801c9c:	52                   	push   %edx
  801c9d:	50                   	push   %eax
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	ff 75 08             	pushl  0x8(%ebp)
  801ca4:	e8 a1 ff ff ff       	call   801c4a <printnum>
  801ca9:	83 c4 20             	add    $0x20,%esp
  801cac:	eb 1a                	jmp    801cc8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801cae:	83 ec 08             	sub    $0x8,%esp
  801cb1:	ff 75 0c             	pushl  0xc(%ebp)
  801cb4:	ff 75 20             	pushl  0x20(%ebp)
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	ff d0                	call   *%eax
  801cbc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801cbf:	ff 4d 1c             	decl   0x1c(%ebp)
  801cc2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801cc6:	7f e6                	jg     801cae <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cc8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801ccb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd6:	53                   	push   %ebx
  801cd7:	51                   	push   %ecx
  801cd8:	52                   	push   %edx
  801cd9:	50                   	push   %eax
  801cda:	e8 41 2b 00 00       	call   804820 <__umoddi3>
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	05 34 50 80 00       	add    $0x805034,%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	0f be c0             	movsbl %al,%eax
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	50                   	push   %eax
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	ff d0                	call   *%eax
  801cf8:	83 c4 10             	add    $0x10,%esp
}
  801cfb:	90                   	nop
  801cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d04:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d08:	7e 1c                	jle    801d26 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	8b 00                	mov    (%eax),%eax
  801d0f:	8d 50 08             	lea    0x8(%eax),%edx
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	89 10                	mov    %edx,(%eax)
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	8b 00                	mov    (%eax),%eax
  801d1c:	83 e8 08             	sub    $0x8,%eax
  801d1f:	8b 50 04             	mov    0x4(%eax),%edx
  801d22:	8b 00                	mov    (%eax),%eax
  801d24:	eb 40                	jmp    801d66 <getuint+0x65>
	else if (lflag)
  801d26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d2a:	74 1e                	je     801d4a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	8b 00                	mov    (%eax),%eax
  801d31:	8d 50 04             	lea    0x4(%eax),%edx
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	89 10                	mov    %edx,(%eax)
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	8b 00                	mov    (%eax),%eax
  801d3e:	83 e8 04             	sub    $0x4,%eax
  801d41:	8b 00                	mov    (%eax),%eax
  801d43:	ba 00 00 00 00       	mov    $0x0,%edx
  801d48:	eb 1c                	jmp    801d66 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	8b 00                	mov    (%eax),%eax
  801d4f:	8d 50 04             	lea    0x4(%eax),%edx
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	89 10                	mov    %edx,(%eax)
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	8b 00                	mov    (%eax),%eax
  801d5c:	83 e8 04             	sub    $0x4,%eax
  801d5f:	8b 00                	mov    (%eax),%eax
  801d61:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    

00801d68 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d6b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d6f:	7e 1c                	jle    801d8d <getint+0x25>
		return va_arg(*ap, long long);
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	8b 00                	mov    (%eax),%eax
  801d76:	8d 50 08             	lea    0x8(%eax),%edx
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	89 10                	mov    %edx,(%eax)
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	8b 00                	mov    (%eax),%eax
  801d83:	83 e8 08             	sub    $0x8,%eax
  801d86:	8b 50 04             	mov    0x4(%eax),%edx
  801d89:	8b 00                	mov    (%eax),%eax
  801d8b:	eb 38                	jmp    801dc5 <getint+0x5d>
	else if (lflag)
  801d8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d91:	74 1a                	je     801dad <getint+0x45>
		return va_arg(*ap, long);
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	8b 00                	mov    (%eax),%eax
  801d98:	8d 50 04             	lea    0x4(%eax),%edx
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	89 10                	mov    %edx,(%eax)
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8b 00                	mov    (%eax),%eax
  801da5:	83 e8 04             	sub    $0x4,%eax
  801da8:	8b 00                	mov    (%eax),%eax
  801daa:	99                   	cltd   
  801dab:	eb 18                	jmp    801dc5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	8b 00                	mov    (%eax),%eax
  801db2:	8d 50 04             	lea    0x4(%eax),%edx
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	89 10                	mov    %edx,(%eax)
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	8b 00                	mov    (%eax),%eax
  801dbf:	83 e8 04             	sub    $0x4,%eax
  801dc2:	8b 00                	mov    (%eax),%eax
  801dc4:	99                   	cltd   
}
  801dc5:	5d                   	pop    %ebp
  801dc6:	c3                   	ret    

00801dc7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	56                   	push   %esi
  801dcb:	53                   	push   %ebx
  801dcc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dcf:	eb 17                	jmp    801de8 <vprintfmt+0x21>
			if (ch == '\0')
  801dd1:	85 db                	test   %ebx,%ebx
  801dd3:	0f 84 af 03 00 00    	je     802188 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801dd9:	83 ec 08             	sub    $0x8,%esp
  801ddc:	ff 75 0c             	pushl  0xc(%ebp)
  801ddf:	53                   	push   %ebx
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	ff d0                	call   *%eax
  801de5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801de8:	8b 45 10             	mov    0x10(%ebp),%eax
  801deb:	8d 50 01             	lea    0x1(%eax),%edx
  801dee:	89 55 10             	mov    %edx,0x10(%ebp)
  801df1:	8a 00                	mov    (%eax),%al
  801df3:	0f b6 d8             	movzbl %al,%ebx
  801df6:	83 fb 25             	cmp    $0x25,%ebx
  801df9:	75 d6                	jne    801dd1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801dfb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801dff:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801e06:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801e0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801e14:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1e:	8d 50 01             	lea    0x1(%eax),%edx
  801e21:	89 55 10             	mov    %edx,0x10(%ebp)
  801e24:	8a 00                	mov    (%eax),%al
  801e26:	0f b6 d8             	movzbl %al,%ebx
  801e29:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801e2c:	83 f8 55             	cmp    $0x55,%eax
  801e2f:	0f 87 2b 03 00 00    	ja     802160 <vprintfmt+0x399>
  801e35:	8b 04 85 58 50 80 00 	mov    0x805058(,%eax,4),%eax
  801e3c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801e3e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801e42:	eb d7                	jmp    801e1b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801e44:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801e48:	eb d1                	jmp    801e1b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e4a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801e51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e54:	89 d0                	mov    %edx,%eax
  801e56:	c1 e0 02             	shl    $0x2,%eax
  801e59:	01 d0                	add    %edx,%eax
  801e5b:	01 c0                	add    %eax,%eax
  801e5d:	01 d8                	add    %ebx,%eax
  801e5f:	83 e8 30             	sub    $0x30,%eax
  801e62:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801e65:	8b 45 10             	mov    0x10(%ebp),%eax
  801e68:	8a 00                	mov    (%eax),%al
  801e6a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801e6d:	83 fb 2f             	cmp    $0x2f,%ebx
  801e70:	7e 3e                	jle    801eb0 <vprintfmt+0xe9>
  801e72:	83 fb 39             	cmp    $0x39,%ebx
  801e75:	7f 39                	jg     801eb0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e77:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801e7a:	eb d5                	jmp    801e51 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e7f:	83 c0 04             	add    $0x4,%eax
  801e82:	89 45 14             	mov    %eax,0x14(%ebp)
  801e85:	8b 45 14             	mov    0x14(%ebp),%eax
  801e88:	83 e8 04             	sub    $0x4,%eax
  801e8b:	8b 00                	mov    (%eax),%eax
  801e8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801e90:	eb 1f                	jmp    801eb1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801e92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e96:	79 83                	jns    801e1b <vprintfmt+0x54>
				width = 0;
  801e98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801e9f:	e9 77 ff ff ff       	jmp    801e1b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801ea4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801eab:	e9 6b ff ff ff       	jmp    801e1b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801eb0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801eb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801eb5:	0f 89 60 ff ff ff    	jns    801e1b <vprintfmt+0x54>
				width = precision, precision = -1;
  801ebb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ec1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801ec8:	e9 4e ff ff ff       	jmp    801e1b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ecd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ed0:	e9 46 ff ff ff       	jmp    801e1b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	83 c0 04             	add    $0x4,%eax
  801edb:	89 45 14             	mov    %eax,0x14(%ebp)
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	83 e8 04             	sub    $0x4,%eax
  801ee4:	8b 00                	mov    (%eax),%eax
  801ee6:	83 ec 08             	sub    $0x8,%esp
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	50                   	push   %eax
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	ff d0                	call   *%eax
  801ef2:	83 c4 10             	add    $0x10,%esp
			break;
  801ef5:	e9 89 02 00 00       	jmp    802183 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801efa:	8b 45 14             	mov    0x14(%ebp),%eax
  801efd:	83 c0 04             	add    $0x4,%eax
  801f00:	89 45 14             	mov    %eax,0x14(%ebp)
  801f03:	8b 45 14             	mov    0x14(%ebp),%eax
  801f06:	83 e8 04             	sub    $0x4,%eax
  801f09:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801f0b:	85 db                	test   %ebx,%ebx
  801f0d:	79 02                	jns    801f11 <vprintfmt+0x14a>
				err = -err;
  801f0f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801f11:	83 fb 64             	cmp    $0x64,%ebx
  801f14:	7f 0b                	jg     801f21 <vprintfmt+0x15a>
  801f16:	8b 34 9d a0 4e 80 00 	mov    0x804ea0(,%ebx,4),%esi
  801f1d:	85 f6                	test   %esi,%esi
  801f1f:	75 19                	jne    801f3a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f21:	53                   	push   %ebx
  801f22:	68 45 50 80 00       	push   $0x805045
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	e8 5e 02 00 00       	call   802190 <printfmt>
  801f32:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801f35:	e9 49 02 00 00       	jmp    802183 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801f3a:	56                   	push   %esi
  801f3b:	68 4e 50 80 00       	push   $0x80504e
  801f40:	ff 75 0c             	pushl  0xc(%ebp)
  801f43:	ff 75 08             	pushl  0x8(%ebp)
  801f46:	e8 45 02 00 00       	call   802190 <printfmt>
  801f4b:	83 c4 10             	add    $0x10,%esp
			break;
  801f4e:	e9 30 02 00 00       	jmp    802183 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801f53:	8b 45 14             	mov    0x14(%ebp),%eax
  801f56:	83 c0 04             	add    $0x4,%eax
  801f59:	89 45 14             	mov    %eax,0x14(%ebp)
  801f5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5f:	83 e8 04             	sub    $0x4,%eax
  801f62:	8b 30                	mov    (%eax),%esi
  801f64:	85 f6                	test   %esi,%esi
  801f66:	75 05                	jne    801f6d <vprintfmt+0x1a6>
				p = "(null)";
  801f68:	be 51 50 80 00       	mov    $0x805051,%esi
			if (width > 0 && padc != '-')
  801f6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f71:	7e 6d                	jle    801fe0 <vprintfmt+0x219>
  801f73:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801f77:	74 67                	je     801fe0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7c:	83 ec 08             	sub    $0x8,%esp
  801f7f:	50                   	push   %eax
  801f80:	56                   	push   %esi
  801f81:	e8 0c 03 00 00       	call   802292 <strnlen>
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801f8c:	eb 16                	jmp    801fa4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801f8e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801f92:	83 ec 08             	sub    $0x8,%esp
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	50                   	push   %eax
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	ff d0                	call   *%eax
  801f9e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801fa1:	ff 4d e4             	decl   -0x1c(%ebp)
  801fa4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fa8:	7f e4                	jg     801f8e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801faa:	eb 34                	jmp    801fe0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801fac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fb0:	74 1c                	je     801fce <vprintfmt+0x207>
  801fb2:	83 fb 1f             	cmp    $0x1f,%ebx
  801fb5:	7e 05                	jle    801fbc <vprintfmt+0x1f5>
  801fb7:	83 fb 7e             	cmp    $0x7e,%ebx
  801fba:	7e 12                	jle    801fce <vprintfmt+0x207>
					putch('?', putdat);
  801fbc:	83 ec 08             	sub    $0x8,%esp
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	6a 3f                	push   $0x3f
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	ff d0                	call   *%eax
  801fc9:	83 c4 10             	add    $0x10,%esp
  801fcc:	eb 0f                	jmp    801fdd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801fce:	83 ec 08             	sub    $0x8,%esp
  801fd1:	ff 75 0c             	pushl  0xc(%ebp)
  801fd4:	53                   	push   %ebx
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	ff d0                	call   *%eax
  801fda:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fdd:	ff 4d e4             	decl   -0x1c(%ebp)
  801fe0:	89 f0                	mov    %esi,%eax
  801fe2:	8d 70 01             	lea    0x1(%eax),%esi
  801fe5:	8a 00                	mov    (%eax),%al
  801fe7:	0f be d8             	movsbl %al,%ebx
  801fea:	85 db                	test   %ebx,%ebx
  801fec:	74 24                	je     802012 <vprintfmt+0x24b>
  801fee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ff2:	78 b8                	js     801fac <vprintfmt+0x1e5>
  801ff4:	ff 4d e0             	decl   -0x20(%ebp)
  801ff7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ffb:	79 af                	jns    801fac <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ffd:	eb 13                	jmp    802012 <vprintfmt+0x24b>
				putch(' ', putdat);
  801fff:	83 ec 08             	sub    $0x8,%esp
  802002:	ff 75 0c             	pushl  0xc(%ebp)
  802005:	6a 20                	push   $0x20
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	ff d0                	call   *%eax
  80200c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80200f:	ff 4d e4             	decl   -0x1c(%ebp)
  802012:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802016:	7f e7                	jg     801fff <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  802018:	e9 66 01 00 00       	jmp    802183 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80201d:	83 ec 08             	sub    $0x8,%esp
  802020:	ff 75 e8             	pushl  -0x18(%ebp)
  802023:	8d 45 14             	lea    0x14(%ebp),%eax
  802026:	50                   	push   %eax
  802027:	e8 3c fd ff ff       	call   801d68 <getint>
  80202c:	83 c4 10             	add    $0x10,%esp
  80202f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802032:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203b:	85 d2                	test   %edx,%edx
  80203d:	79 23                	jns    802062 <vprintfmt+0x29b>
				putch('-', putdat);
  80203f:	83 ec 08             	sub    $0x8,%esp
  802042:	ff 75 0c             	pushl  0xc(%ebp)
  802045:	6a 2d                	push   $0x2d
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	ff d0                	call   *%eax
  80204c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80204f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802055:	f7 d8                	neg    %eax
  802057:	83 d2 00             	adc    $0x0,%edx
  80205a:	f7 da                	neg    %edx
  80205c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80205f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802062:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802069:	e9 bc 00 00 00       	jmp    80212a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80206e:	83 ec 08             	sub    $0x8,%esp
  802071:	ff 75 e8             	pushl  -0x18(%ebp)
  802074:	8d 45 14             	lea    0x14(%ebp),%eax
  802077:	50                   	push   %eax
  802078:	e8 84 fc ff ff       	call   801d01 <getuint>
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802083:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802086:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80208d:	e9 98 00 00 00       	jmp    80212a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802092:	83 ec 08             	sub    $0x8,%esp
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	6a 58                	push   $0x58
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	ff d0                	call   *%eax
  80209f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8020a2:	83 ec 08             	sub    $0x8,%esp
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	6a 58                	push   $0x58
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	ff d0                	call   *%eax
  8020af:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8020b2:	83 ec 08             	sub    $0x8,%esp
  8020b5:	ff 75 0c             	pushl  0xc(%ebp)
  8020b8:	6a 58                	push   $0x58
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	ff d0                	call   *%eax
  8020bf:	83 c4 10             	add    $0x10,%esp
			break;
  8020c2:	e9 bc 00 00 00       	jmp    802183 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8020c7:	83 ec 08             	sub    $0x8,%esp
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	6a 30                	push   $0x30
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	ff d0                	call   *%eax
  8020d4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8020d7:	83 ec 08             	sub    $0x8,%esp
  8020da:	ff 75 0c             	pushl  0xc(%ebp)
  8020dd:	6a 78                	push   $0x78
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	ff d0                	call   *%eax
  8020e4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8020e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ea:	83 c0 04             	add    $0x4,%eax
  8020ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8020f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f3:	83 e8 04             	sub    $0x4,%eax
  8020f6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8020f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  802102:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  802109:	eb 1f                	jmp    80212a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80210b:	83 ec 08             	sub    $0x8,%esp
  80210e:	ff 75 e8             	pushl  -0x18(%ebp)
  802111:	8d 45 14             	lea    0x14(%ebp),%eax
  802114:	50                   	push   %eax
  802115:	e8 e7 fb ff ff       	call   801d01 <getuint>
  80211a:	83 c4 10             	add    $0x10,%esp
  80211d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802120:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802123:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80212a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80212e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802131:	83 ec 04             	sub    $0x4,%esp
  802134:	52                   	push   %edx
  802135:	ff 75 e4             	pushl  -0x1c(%ebp)
  802138:	50                   	push   %eax
  802139:	ff 75 f4             	pushl  -0xc(%ebp)
  80213c:	ff 75 f0             	pushl  -0x10(%ebp)
  80213f:	ff 75 0c             	pushl  0xc(%ebp)
  802142:	ff 75 08             	pushl  0x8(%ebp)
  802145:	e8 00 fb ff ff       	call   801c4a <printnum>
  80214a:	83 c4 20             	add    $0x20,%esp
			break;
  80214d:	eb 34                	jmp    802183 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80214f:	83 ec 08             	sub    $0x8,%esp
  802152:	ff 75 0c             	pushl  0xc(%ebp)
  802155:	53                   	push   %ebx
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	ff d0                	call   *%eax
  80215b:	83 c4 10             	add    $0x10,%esp
			break;
  80215e:	eb 23                	jmp    802183 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802160:	83 ec 08             	sub    $0x8,%esp
  802163:	ff 75 0c             	pushl  0xc(%ebp)
  802166:	6a 25                	push   $0x25
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	ff d0                	call   *%eax
  80216d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802170:	ff 4d 10             	decl   0x10(%ebp)
  802173:	eb 03                	jmp    802178 <vprintfmt+0x3b1>
  802175:	ff 4d 10             	decl   0x10(%ebp)
  802178:	8b 45 10             	mov    0x10(%ebp),%eax
  80217b:	48                   	dec    %eax
  80217c:	8a 00                	mov    (%eax),%al
  80217e:	3c 25                	cmp    $0x25,%al
  802180:	75 f3                	jne    802175 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  802182:	90                   	nop
		}
	}
  802183:	e9 47 fc ff ff       	jmp    801dcf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802188:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802189:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5d                   	pop    %ebp
  80218f:	c3                   	ret    

00802190 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802196:	8d 45 10             	lea    0x10(%ebp),%eax
  802199:	83 c0 04             	add    $0x4,%eax
  80219c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80219f:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a5:	50                   	push   %eax
  8021a6:	ff 75 0c             	pushl  0xc(%ebp)
  8021a9:	ff 75 08             	pushl  0x8(%ebp)
  8021ac:	e8 16 fc ff ff       	call   801dc7 <vprintfmt>
  8021b1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8021b4:	90                   	nop
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	8b 40 08             	mov    0x8(%eax),%eax
  8021c0:	8d 50 01             	lea    0x1(%eax),%edx
  8021c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8021c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cc:	8b 10                	mov    (%eax),%edx
  8021ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d1:	8b 40 04             	mov    0x4(%eax),%eax
  8021d4:	39 c2                	cmp    %eax,%edx
  8021d6:	73 12                	jae    8021ea <sprintputch+0x33>
		*b->buf++ = ch;
  8021d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8021e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e3:	89 0a                	mov    %ecx,(%edx)
  8021e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e8:	88 10                	mov    %dl,(%eax)
}
  8021ea:	90                   	nop
  8021eb:	5d                   	pop    %ebp
  8021ec:	c3                   	ret    

008021ed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	01 d0                	add    %edx,%eax
  802204:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802207:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80220e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802212:	74 06                	je     80221a <vsnprintf+0x2d>
  802214:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802218:	7f 07                	jg     802221 <vsnprintf+0x34>
		return -E_INVAL;
  80221a:	b8 03 00 00 00       	mov    $0x3,%eax
  80221f:	eb 20                	jmp    802241 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802221:	ff 75 14             	pushl  0x14(%ebp)
  802224:	ff 75 10             	pushl  0x10(%ebp)
  802227:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80222a:	50                   	push   %eax
  80222b:	68 b7 21 80 00       	push   $0x8021b7
  802230:	e8 92 fb ff ff       	call   801dc7 <vprintfmt>
  802235:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802249:	8d 45 10             	lea    0x10(%ebp),%eax
  80224c:	83 c0 04             	add    $0x4,%eax
  80224f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802252:	8b 45 10             	mov    0x10(%ebp),%eax
  802255:	ff 75 f4             	pushl  -0xc(%ebp)
  802258:	50                   	push   %eax
  802259:	ff 75 0c             	pushl  0xc(%ebp)
  80225c:	ff 75 08             	pushl  0x8(%ebp)
  80225f:	e8 89 ff ff ff       	call   8021ed <vsnprintf>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80226a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802275:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80227c:	eb 06                	jmp    802284 <strlen+0x15>
		n++;
  80227e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802281:	ff 45 08             	incl   0x8(%ebp)
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	8a 00                	mov    (%eax),%al
  802289:	84 c0                	test   %al,%al
  80228b:	75 f1                	jne    80227e <strlen+0xf>
		n++;
	return n;
  80228d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80229f:	eb 09                	jmp    8022aa <strnlen+0x18>
		n++;
  8022a1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8022a4:	ff 45 08             	incl   0x8(%ebp)
  8022a7:	ff 4d 0c             	decl   0xc(%ebp)
  8022aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022ae:	74 09                	je     8022b9 <strnlen+0x27>
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	8a 00                	mov    (%eax),%al
  8022b5:	84 c0                	test   %al,%al
  8022b7:	75 e8                	jne    8022a1 <strnlen+0xf>
		n++;
	return n;
  8022b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8022ca:	90                   	nop
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	8d 50 01             	lea    0x1(%eax),%edx
  8022d1:	89 55 08             	mov    %edx,0x8(%ebp)
  8022d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022da:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8022dd:	8a 12                	mov    (%edx),%dl
  8022df:	88 10                	mov    %dl,(%eax)
  8022e1:	8a 00                	mov    (%eax),%al
  8022e3:	84 c0                	test   %al,%al
  8022e5:	75 e4                	jne    8022cb <strcpy+0xd>
		/* do nothing */;
	return ret;
  8022e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8022f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022ff:	eb 1f                	jmp    802320 <strncpy+0x34>
		*dst++ = *src;
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	8d 50 01             	lea    0x1(%eax),%edx
  802307:	89 55 08             	mov    %edx,0x8(%ebp)
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	8a 12                	mov    (%edx),%dl
  80230f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802311:	8b 45 0c             	mov    0xc(%ebp),%eax
  802314:	8a 00                	mov    (%eax),%al
  802316:	84 c0                	test   %al,%al
  802318:	74 03                	je     80231d <strncpy+0x31>
			src++;
  80231a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80231d:	ff 45 fc             	incl   -0x4(%ebp)
  802320:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802323:	3b 45 10             	cmp    0x10(%ebp),%eax
  802326:	72 d9                	jb     802301 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802328:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80233d:	74 30                	je     80236f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80233f:	eb 16                	jmp    802357 <strlcpy+0x2a>
			*dst++ = *src++;
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	8d 50 01             	lea    0x1(%eax),%edx
  802347:	89 55 08             	mov    %edx,0x8(%ebp)
  80234a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234d:	8d 4a 01             	lea    0x1(%edx),%ecx
  802350:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802353:	8a 12                	mov    (%edx),%dl
  802355:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802357:	ff 4d 10             	decl   0x10(%ebp)
  80235a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80235e:	74 09                	je     802369 <strlcpy+0x3c>
  802360:	8b 45 0c             	mov    0xc(%ebp),%eax
  802363:	8a 00                	mov    (%eax),%al
  802365:	84 c0                	test   %al,%al
  802367:	75 d8                	jne    802341 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80236f:	8b 55 08             	mov    0x8(%ebp),%edx
  802372:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802375:	29 c2                	sub    %eax,%edx
  802377:	89 d0                	mov    %edx,%eax
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80237e:	eb 06                	jmp    802386 <strcmp+0xb>
		p++, q++;
  802380:	ff 45 08             	incl   0x8(%ebp)
  802383:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	8a 00                	mov    (%eax),%al
  80238b:	84 c0                	test   %al,%al
  80238d:	74 0e                	je     80239d <strcmp+0x22>
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	8a 10                	mov    (%eax),%dl
  802394:	8b 45 0c             	mov    0xc(%ebp),%eax
  802397:	8a 00                	mov    (%eax),%al
  802399:	38 c2                	cmp    %al,%dl
  80239b:	74 e3                	je     802380 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	8a 00                	mov    (%eax),%al
  8023a2:	0f b6 d0             	movzbl %al,%edx
  8023a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a8:	8a 00                	mov    (%eax),%al
  8023aa:	0f b6 c0             	movzbl %al,%eax
  8023ad:	29 c2                	sub    %eax,%edx
  8023af:	89 d0                	mov    %edx,%eax
}
  8023b1:	5d                   	pop    %ebp
  8023b2:	c3                   	ret    

008023b3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8023b6:	eb 09                	jmp    8023c1 <strncmp+0xe>
		n--, p++, q++;
  8023b8:	ff 4d 10             	decl   0x10(%ebp)
  8023bb:	ff 45 08             	incl   0x8(%ebp)
  8023be:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8023c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023c5:	74 17                	je     8023de <strncmp+0x2b>
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	8a 00                	mov    (%eax),%al
  8023cc:	84 c0                	test   %al,%al
  8023ce:	74 0e                	je     8023de <strncmp+0x2b>
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	8a 10                	mov    (%eax),%dl
  8023d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d8:	8a 00                	mov    (%eax),%al
  8023da:	38 c2                	cmp    %al,%dl
  8023dc:	74 da                	je     8023b8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8023de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023e2:	75 07                	jne    8023eb <strncmp+0x38>
		return 0;
  8023e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e9:	eb 14                	jmp    8023ff <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8a 00                	mov    (%eax),%al
  8023f0:	0f b6 d0             	movzbl %al,%edx
  8023f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f6:	8a 00                	mov    (%eax),%al
  8023f8:	0f b6 c0             	movzbl %al,%eax
  8023fb:	29 c2                	sub    %eax,%edx
  8023fd:	89 d0                	mov    %edx,%eax
}
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    

00802401 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	83 ec 04             	sub    $0x4,%esp
  802407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80240d:	eb 12                	jmp    802421 <strchr+0x20>
		if (*s == c)
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	8a 00                	mov    (%eax),%al
  802414:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802417:	75 05                	jne    80241e <strchr+0x1d>
			return (char *) s;
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	eb 11                	jmp    80242f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80241e:	ff 45 08             	incl   0x8(%ebp)
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	8a 00                	mov    (%eax),%al
  802426:	84 c0                	test   %al,%al
  802428:	75 e5                	jne    80240f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 04             	sub    $0x4,%esp
  802437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80243d:	eb 0d                	jmp    80244c <strfind+0x1b>
		if (*s == c)
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	8a 00                	mov    (%eax),%al
  802444:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802447:	74 0e                	je     802457 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802449:	ff 45 08             	incl   0x8(%ebp)
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	8a 00                	mov    (%eax),%al
  802451:	84 c0                	test   %al,%al
  802453:	75 ea                	jne    80243f <strfind+0xe>
  802455:	eb 01                	jmp    802458 <strfind+0x27>
		if (*s == c)
			break;
  802457:	90                   	nop
	return (char *) s;
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
  802460:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  802469:	8b 45 10             	mov    0x10(%ebp),%eax
  80246c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80246f:	eb 0e                	jmp    80247f <memset+0x22>
		*p++ = c;
  802471:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802474:	8d 50 01             	lea    0x1(%eax),%edx
  802477:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80247a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80247f:	ff 4d f8             	decl   -0x8(%ebp)
  802482:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802486:	79 e9                	jns    802471 <memset+0x14>
		*p++ = c;

	return v;
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802493:	8b 45 0c             	mov    0xc(%ebp),%eax
  802496:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80249f:	eb 16                	jmp    8024b7 <memcpy+0x2a>
		*d++ = *s++;
  8024a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a4:	8d 50 01             	lea    0x1(%eax),%edx
  8024a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024b0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024b3:	8a 12                	mov    (%edx),%dl
  8024b5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8024b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	75 dd                	jne    8024a1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8024cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8024db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024e1:	73 50                	jae    802533 <memmove+0x6a>
  8024e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024ee:	76 43                	jbe    802533 <memmove+0x6a>
		s += n;
  8024f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8024f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8024fc:	eb 10                	jmp    80250e <memmove+0x45>
			*--d = *--s;
  8024fe:	ff 4d f8             	decl   -0x8(%ebp)
  802501:	ff 4d fc             	decl   -0x4(%ebp)
  802504:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802507:	8a 10                	mov    (%eax),%dl
  802509:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80250c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80250e:	8b 45 10             	mov    0x10(%ebp),%eax
  802511:	8d 50 ff             	lea    -0x1(%eax),%edx
  802514:	89 55 10             	mov    %edx,0x10(%ebp)
  802517:	85 c0                	test   %eax,%eax
  802519:	75 e3                	jne    8024fe <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80251b:	eb 23                	jmp    802540 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80251d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802520:	8d 50 01             	lea    0x1(%eax),%edx
  802523:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802526:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802529:	8d 4a 01             	lea    0x1(%edx),%ecx
  80252c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80252f:	8a 12                	mov    (%edx),%dl
  802531:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802533:	8b 45 10             	mov    0x10(%ebp),%eax
  802536:	8d 50 ff             	lea    -0x1(%eax),%edx
  802539:	89 55 10             	mov    %edx,0x10(%ebp)
  80253c:	85 c0                	test   %eax,%eax
  80253e:	75 dd                	jne    80251d <memmove+0x54>
			*d++ = *s++;

	return dst;
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
  802548:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802551:	8b 45 0c             	mov    0xc(%ebp),%eax
  802554:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802557:	eb 2a                	jmp    802583 <memcmp+0x3e>
		if (*s1 != *s2)
  802559:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80255c:	8a 10                	mov    (%eax),%dl
  80255e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802561:	8a 00                	mov    (%eax),%al
  802563:	38 c2                	cmp    %al,%dl
  802565:	74 16                	je     80257d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80256a:	8a 00                	mov    (%eax),%al
  80256c:	0f b6 d0             	movzbl %al,%edx
  80256f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802572:	8a 00                	mov    (%eax),%al
  802574:	0f b6 c0             	movzbl %al,%eax
  802577:	29 c2                	sub    %eax,%edx
  802579:	89 d0                	mov    %edx,%eax
  80257b:	eb 18                	jmp    802595 <memcmp+0x50>
		s1++, s2++;
  80257d:	ff 45 fc             	incl   -0x4(%ebp)
  802580:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802583:	8b 45 10             	mov    0x10(%ebp),%eax
  802586:	8d 50 ff             	lea    -0x1(%eax),%edx
  802589:	89 55 10             	mov    %edx,0x10(%ebp)
  80258c:	85 c0                	test   %eax,%eax
  80258e:	75 c9                	jne    802559 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80259d:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a3:	01 d0                	add    %edx,%eax
  8025a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8025a8:	eb 15                	jmp    8025bf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	8a 00                	mov    (%eax),%al
  8025af:	0f b6 d0             	movzbl %al,%edx
  8025b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b5:	0f b6 c0             	movzbl %al,%eax
  8025b8:	39 c2                	cmp    %eax,%edx
  8025ba:	74 0d                	je     8025c9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8025bc:	ff 45 08             	incl   0x8(%ebp)
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8025c5:	72 e3                	jb     8025aa <memfind+0x13>
  8025c7:	eb 01                	jmp    8025ca <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8025c9:	90                   	nop
	return (void *) s;
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8025d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8025dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025e3:	eb 03                	jmp    8025e8 <strtol+0x19>
		s++;
  8025e5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	8a 00                	mov    (%eax),%al
  8025ed:	3c 20                	cmp    $0x20,%al
  8025ef:	74 f4                	je     8025e5 <strtol+0x16>
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	8a 00                	mov    (%eax),%al
  8025f6:	3c 09                	cmp    $0x9,%al
  8025f8:	74 eb                	je     8025e5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	8a 00                	mov    (%eax),%al
  8025ff:	3c 2b                	cmp    $0x2b,%al
  802601:	75 05                	jne    802608 <strtol+0x39>
		s++;
  802603:	ff 45 08             	incl   0x8(%ebp)
  802606:	eb 13                	jmp    80261b <strtol+0x4c>
	else if (*s == '-')
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	8a 00                	mov    (%eax),%al
  80260d:	3c 2d                	cmp    $0x2d,%al
  80260f:	75 0a                	jne    80261b <strtol+0x4c>
		s++, neg = 1;
  802611:	ff 45 08             	incl   0x8(%ebp)
  802614:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80261b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80261f:	74 06                	je     802627 <strtol+0x58>
  802621:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802625:	75 20                	jne    802647 <strtol+0x78>
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	8a 00                	mov    (%eax),%al
  80262c:	3c 30                	cmp    $0x30,%al
  80262e:	75 17                	jne    802647 <strtol+0x78>
  802630:	8b 45 08             	mov    0x8(%ebp),%eax
  802633:	40                   	inc    %eax
  802634:	8a 00                	mov    (%eax),%al
  802636:	3c 78                	cmp    $0x78,%al
  802638:	75 0d                	jne    802647 <strtol+0x78>
		s += 2, base = 16;
  80263a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80263e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802645:	eb 28                	jmp    80266f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802647:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80264b:	75 15                	jne    802662 <strtol+0x93>
  80264d:	8b 45 08             	mov    0x8(%ebp),%eax
  802650:	8a 00                	mov    (%eax),%al
  802652:	3c 30                	cmp    $0x30,%al
  802654:	75 0c                	jne    802662 <strtol+0x93>
		s++, base = 8;
  802656:	ff 45 08             	incl   0x8(%ebp)
  802659:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802660:	eb 0d                	jmp    80266f <strtol+0xa0>
	else if (base == 0)
  802662:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802666:	75 07                	jne    80266f <strtol+0xa0>
		base = 10;
  802668:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	8a 00                	mov    (%eax),%al
  802674:	3c 2f                	cmp    $0x2f,%al
  802676:	7e 19                	jle    802691 <strtol+0xc2>
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	8a 00                	mov    (%eax),%al
  80267d:	3c 39                	cmp    $0x39,%al
  80267f:	7f 10                	jg     802691 <strtol+0xc2>
			dig = *s - '0';
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	8a 00                	mov    (%eax),%al
  802686:	0f be c0             	movsbl %al,%eax
  802689:	83 e8 30             	sub    $0x30,%eax
  80268c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268f:	eb 42                	jmp    8026d3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	8a 00                	mov    (%eax),%al
  802696:	3c 60                	cmp    $0x60,%al
  802698:	7e 19                	jle    8026b3 <strtol+0xe4>
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	8a 00                	mov    (%eax),%al
  80269f:	3c 7a                	cmp    $0x7a,%al
  8026a1:	7f 10                	jg     8026b3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	8a 00                	mov    (%eax),%al
  8026a8:	0f be c0             	movsbl %al,%eax
  8026ab:	83 e8 57             	sub    $0x57,%eax
  8026ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b1:	eb 20                	jmp    8026d3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	8a 00                	mov    (%eax),%al
  8026b8:	3c 40                	cmp    $0x40,%al
  8026ba:	7e 39                	jle    8026f5 <strtol+0x126>
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	8a 00                	mov    (%eax),%al
  8026c1:	3c 5a                	cmp    $0x5a,%al
  8026c3:	7f 30                	jg     8026f5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	8a 00                	mov    (%eax),%al
  8026ca:	0f be c0             	movsbl %al,%eax
  8026cd:	83 e8 37             	sub    $0x37,%eax
  8026d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8026d9:	7d 19                	jge    8026f4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8026db:	ff 45 08             	incl   0x8(%ebp)
  8026de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026e1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8026e5:	89 c2                	mov    %eax,%edx
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	01 d0                	add    %edx,%eax
  8026ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8026ef:	e9 7b ff ff ff       	jmp    80266f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8026f4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8026f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026f9:	74 08                	je     802703 <strtol+0x134>
		*endptr = (char *) s;
  8026fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802701:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802703:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802707:	74 07                	je     802710 <strtol+0x141>
  802709:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80270c:	f7 d8                	neg    %eax
  80270e:	eb 03                	jmp    802713 <strtol+0x144>
  802710:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <ltostr>:

void
ltostr(long value, char *str)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80271b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802722:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802729:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80272d:	79 13                	jns    802742 <ltostr+0x2d>
	{
		neg = 1;
  80272f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802736:	8b 45 0c             	mov    0xc(%ebp),%eax
  802739:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80273c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80273f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80274a:	99                   	cltd   
  80274b:	f7 f9                	idiv   %ecx
  80274d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802750:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802753:	8d 50 01             	lea    0x1(%eax),%edx
  802756:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802759:	89 c2                	mov    %eax,%edx
  80275b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275e:	01 d0                	add    %edx,%eax
  802760:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802763:	83 c2 30             	add    $0x30,%edx
  802766:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802768:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80276b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802770:	f7 e9                	imul   %ecx
  802772:	c1 fa 02             	sar    $0x2,%edx
  802775:	89 c8                	mov    %ecx,%eax
  802777:	c1 f8 1f             	sar    $0x1f,%eax
  80277a:	29 c2                	sub    %eax,%edx
  80277c:	89 d0                	mov    %edx,%eax
  80277e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802781:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802784:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802789:	f7 e9                	imul   %ecx
  80278b:	c1 fa 02             	sar    $0x2,%edx
  80278e:	89 c8                	mov    %ecx,%eax
  802790:	c1 f8 1f             	sar    $0x1f,%eax
  802793:	29 c2                	sub    %eax,%edx
  802795:	89 d0                	mov    %edx,%eax
  802797:	c1 e0 02             	shl    $0x2,%eax
  80279a:	01 d0                	add    %edx,%eax
  80279c:	01 c0                	add    %eax,%eax
  80279e:	29 c1                	sub    %eax,%ecx
  8027a0:	89 ca                	mov    %ecx,%edx
  8027a2:	85 d2                	test   %edx,%edx
  8027a4:	75 9c                	jne    802742 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8027a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8027ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027b0:	48                   	dec    %eax
  8027b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8027b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027b8:	74 3d                	je     8027f7 <ltostr+0xe2>
		start = 1 ;
  8027ba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8027c1:	eb 34                	jmp    8027f7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8027c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c9:	01 d0                	add    %edx,%eax
  8027cb:	8a 00                	mov    (%eax),%al
  8027cd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8027d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d6:	01 c2                	add    %eax,%edx
  8027d8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027de:	01 c8                	add    %ecx,%eax
  8027e0:	8a 00                	mov    (%eax),%al
  8027e2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8027e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ea:	01 c2                	add    %eax,%edx
  8027ec:	8a 45 eb             	mov    -0x15(%ebp),%al
  8027ef:	88 02                	mov    %al,(%edx)
		start++ ;
  8027f1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8027f4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027fd:	7c c4                	jl     8027c3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8027ff:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802802:	8b 45 0c             	mov    0xc(%ebp),%eax
  802805:	01 d0                	add    %edx,%eax
  802807:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80280a:	90                   	nop
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802813:	ff 75 08             	pushl  0x8(%ebp)
  802816:	e8 54 fa ff ff       	call   80226f <strlen>
  80281b:	83 c4 04             	add    $0x4,%esp
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802821:	ff 75 0c             	pushl  0xc(%ebp)
  802824:	e8 46 fa ff ff       	call   80226f <strlen>
  802829:	83 c4 04             	add    $0x4,%esp
  80282c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80282f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802836:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80283d:	eb 17                	jmp    802856 <strcconcat+0x49>
		final[s] = str1[s] ;
  80283f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802842:	8b 45 10             	mov    0x10(%ebp),%eax
  802845:	01 c2                	add    %eax,%edx
  802847:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	01 c8                	add    %ecx,%eax
  80284f:	8a 00                	mov    (%eax),%al
  802851:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802853:	ff 45 fc             	incl   -0x4(%ebp)
  802856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802859:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80285c:	7c e1                	jl     80283f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80285e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802865:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80286c:	eb 1f                	jmp    80288d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80286e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802871:	8d 50 01             	lea    0x1(%eax),%edx
  802874:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802877:	89 c2                	mov    %eax,%edx
  802879:	8b 45 10             	mov    0x10(%ebp),%eax
  80287c:	01 c2                	add    %eax,%edx
  80287e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802881:	8b 45 0c             	mov    0xc(%ebp),%eax
  802884:	01 c8                	add    %ecx,%eax
  802886:	8a 00                	mov    (%eax),%al
  802888:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80288a:	ff 45 f8             	incl   -0x8(%ebp)
  80288d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802890:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802893:	7c d9                	jl     80286e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802895:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802898:	8b 45 10             	mov    0x10(%ebp),%eax
  80289b:	01 d0                	add    %edx,%eax
  80289d:	c6 00 00             	movb   $0x0,(%eax)
}
  8028a0:	90                   	nop
  8028a1:	c9                   	leave  
  8028a2:	c3                   	ret    

008028a3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8028a3:	55                   	push   %ebp
  8028a4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8028a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8028a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8028af:	8b 45 14             	mov    0x14(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8028be:	01 d0                	add    %edx,%eax
  8028c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028c6:	eb 0c                	jmp    8028d4 <strsplit+0x31>
			*string++ = 0;
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	8d 50 01             	lea    0x1(%eax),%edx
  8028ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8028d1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	8a 00                	mov    (%eax),%al
  8028d9:	84 c0                	test   %al,%al
  8028db:	74 18                	je     8028f5 <strsplit+0x52>
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	8a 00                	mov    (%eax),%al
  8028e2:	0f be c0             	movsbl %al,%eax
  8028e5:	50                   	push   %eax
  8028e6:	ff 75 0c             	pushl  0xc(%ebp)
  8028e9:	e8 13 fb ff ff       	call   802401 <strchr>
  8028ee:	83 c4 08             	add    $0x8,%esp
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	75 d3                	jne    8028c8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	8a 00                	mov    (%eax),%al
  8028fa:	84 c0                	test   %al,%al
  8028fc:	74 5a                	je     802958 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8028fe:	8b 45 14             	mov    0x14(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	83 f8 0f             	cmp    $0xf,%eax
  802906:	75 07                	jne    80290f <strsplit+0x6c>
		{
			return 0;
  802908:	b8 00 00 00 00       	mov    $0x0,%eax
  80290d:	eb 66                	jmp    802975 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80290f:	8b 45 14             	mov    0x14(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	8d 48 01             	lea    0x1(%eax),%ecx
  802917:	8b 55 14             	mov    0x14(%ebp),%edx
  80291a:	89 0a                	mov    %ecx,(%edx)
  80291c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802923:	8b 45 10             	mov    0x10(%ebp),%eax
  802926:	01 c2                	add    %eax,%edx
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80292d:	eb 03                	jmp    802932 <strsplit+0x8f>
			string++;
  80292f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	8a 00                	mov    (%eax),%al
  802937:	84 c0                	test   %al,%al
  802939:	74 8b                	je     8028c6 <strsplit+0x23>
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	8a 00                	mov    (%eax),%al
  802940:	0f be c0             	movsbl %al,%eax
  802943:	50                   	push   %eax
  802944:	ff 75 0c             	pushl  0xc(%ebp)
  802947:	e8 b5 fa ff ff       	call   802401 <strchr>
  80294c:	83 c4 08             	add    $0x8,%esp
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 dc                	je     80292f <strsplit+0x8c>
			string++;
	}
  802953:	e9 6e ff ff ff       	jmp    8028c6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802958:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802959:	8b 45 14             	mov    0x14(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802965:	8b 45 10             	mov    0x10(%ebp),%eax
  802968:	01 d0                	add    %edx,%eax
  80296a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802970:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802975:	c9                   	leave  
  802976:	c3                   	ret    

00802977 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802977:	55                   	push   %ebp
  802978:	89 e5                	mov    %esp,%ebp
  80297a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80297d:	a1 04 60 80 00       	mov    0x806004,%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	74 1f                	je     8029a5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802986:	e8 1d 00 00 00       	call   8029a8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80298b:	83 ec 0c             	sub    $0xc,%esp
  80298e:	68 b0 51 80 00       	push   $0x8051b0
  802993:	e8 55 f2 ff ff       	call   801bed <cprintf>
  802998:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80299b:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  8029a2:	00 00 00 
	}
}
  8029a5:	90                   	nop
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  8029ae:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8029b5:	00 00 00 
  8029b8:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8029bf:	00 00 00 
  8029c2:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8029c9:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8029cc:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8029d3:	00 00 00 
  8029d6:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8029dd:	00 00 00 
  8029e0:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8029e7:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8029ea:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  8029f1:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8029f4:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8029fb:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a0a:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a0f:	a3 50 60 80 00       	mov    %eax,0x806050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  802a14:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  802a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a23:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a28:	83 ec 04             	sub    $0x4,%esp
  802a2b:	6a 06                	push   $0x6
  802a2d:	ff 75 f4             	pushl  -0xc(%ebp)
  802a30:	50                   	push   %eax
  802a31:	e8 ee 05 00 00       	call   803024 <sys_allocate_chunk>
  802a36:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a39:	a1 20 61 80 00       	mov    0x806120,%eax
  802a3e:	83 ec 0c             	sub    $0xc,%esp
  802a41:	50                   	push   %eax
  802a42:	e8 63 0c 00 00       	call   8036aa <initialize_MemBlocksList>
  802a47:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  802a4a:	a1 4c 61 80 00       	mov    0x80614c,%eax
  802a4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  802a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a55:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  802a5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a6d:	89 c2                	mov    %eax,%edx
  802a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a72:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  802a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a78:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  802a7f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a89:	8b 50 08             	mov    0x8(%eax),%edx
  802a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a8f:	01 d0                	add    %edx,%eax
  802a91:	48                   	dec    %eax
  802a92:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a98:	ba 00 00 00 00       	mov    $0x0,%edx
  802a9d:	f7 75 e0             	divl   -0x20(%ebp)
  802aa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa3:	29 d0                	sub    %edx,%eax
  802aa5:	89 c2                	mov    %eax,%edx
  802aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aaa:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  802aad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab1:	75 14                	jne    802ac7 <initialize_dyn_block_system+0x11f>
  802ab3:	83 ec 04             	sub    $0x4,%esp
  802ab6:	68 d5 51 80 00       	push   $0x8051d5
  802abb:	6a 34                	push   $0x34
  802abd:	68 f3 51 80 00       	push   $0x8051f3
  802ac2:	e8 72 ee ff ff       	call   801939 <_panic>
  802ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aca:	8b 00                	mov    (%eax),%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	74 10                	je     802ae0 <initialize_dyn_block_system+0x138>
  802ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad3:	8b 00                	mov    (%eax),%eax
  802ad5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad8:	8b 52 04             	mov    0x4(%edx),%edx
  802adb:	89 50 04             	mov    %edx,0x4(%eax)
  802ade:	eb 0b                	jmp    802aeb <initialize_dyn_block_system+0x143>
  802ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae3:	8b 40 04             	mov    0x4(%eax),%eax
  802ae6:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aee:	8b 40 04             	mov    0x4(%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 0f                	je     802b04 <initialize_dyn_block_system+0x15c>
  802af5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802afe:	8b 12                	mov    (%edx),%edx
  802b00:	89 10                	mov    %edx,(%eax)
  802b02:	eb 0a                	jmp    802b0e <initialize_dyn_block_system+0x166>
  802b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	a3 48 61 80 00       	mov    %eax,0x806148
  802b0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b21:	a1 54 61 80 00       	mov    0x806154,%eax
  802b26:	48                   	dec    %eax
  802b27:	a3 54 61 80 00       	mov    %eax,0x806154
			insert_sorted_with_merge_freeList(freeSva);
  802b2c:	83 ec 0c             	sub    $0xc,%esp
  802b2f:	ff 75 e8             	pushl  -0x18(%ebp)
  802b32:	e8 c4 13 00 00       	call   803efb <insert_sorted_with_merge_freeList>
  802b37:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802b3a:	90                   	nop
  802b3b:	c9                   	leave  
  802b3c:	c3                   	ret    

00802b3d <malloc>:
//=================================



void* malloc(uint32 size)
{
  802b3d:	55                   	push   %ebp
  802b3e:	89 e5                	mov    %esp,%ebp
  802b40:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802b43:	e8 2f fe ff ff       	call   802977 <InitializeUHeap>
	if (size == 0) return NULL ;
  802b48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4c:	75 07                	jne    802b55 <malloc+0x18>
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b53:	eb 71                	jmp    802bc6 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  802b55:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802b5c:	76 07                	jbe    802b65 <malloc+0x28>
	return NULL;
  802b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b63:	eb 61                	jmp    802bc6 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802b65:	e8 88 08 00 00       	call   8033f2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	74 53                	je     802bc1 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802b6e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802b75:	8b 55 08             	mov    0x8(%ebp),%edx
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	01 d0                	add    %edx,%eax
  802b7d:	48                   	dec    %eax
  802b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	ba 00 00 00 00       	mov    $0x0,%edx
  802b89:	f7 75 f4             	divl   -0xc(%ebp)
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	29 d0                	sub    %edx,%eax
  802b91:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  802b94:	83 ec 0c             	sub    $0xc,%esp
  802b97:	ff 75 ec             	pushl  -0x14(%ebp)
  802b9a:	e8 d2 0d 00 00       	call   803971 <alloc_block_FF>
  802b9f:	83 c4 10             	add    $0x10,%esp
  802ba2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  802ba5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ba9:	74 16                	je     802bc1 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  802bab:	83 ec 0c             	sub    $0xc,%esp
  802bae:	ff 75 e8             	pushl  -0x18(%ebp)
  802bb1:	e8 0c 0c 00 00       	call   8037c2 <insert_sorted_allocList>
  802bb6:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  802bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbc:	8b 40 08             	mov    0x8(%eax),%eax
  802bbf:	eb 05                	jmp    802bc6 <malloc+0x89>
    }

			}


	return NULL;
  802bc1:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802bc6:	c9                   	leave  
  802bc7:	c3                   	ret    

00802bc8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802bc8:	55                   	push   %ebp
  802bc9:	89 e5                	mov    %esp,%ebp
  802bcb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  802bdf:	83 ec 08             	sub    $0x8,%esp
  802be2:	ff 75 f0             	pushl  -0x10(%ebp)
  802be5:	68 40 60 80 00       	push   $0x806040
  802bea:	e8 a0 0b 00 00       	call   80378f <find_block>
  802bef:	83 c4 10             	add    $0x10,%esp
  802bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  802bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf8:	8b 50 0c             	mov    0xc(%eax),%edx
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	83 ec 08             	sub    $0x8,%esp
  802c01:	52                   	push   %edx
  802c02:	50                   	push   %eax
  802c03:	e8 e4 03 00 00       	call   802fec <sys_free_user_mem>
  802c08:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  802c0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c0f:	75 17                	jne    802c28 <free+0x60>
  802c11:	83 ec 04             	sub    $0x4,%esp
  802c14:	68 d5 51 80 00       	push   $0x8051d5
  802c19:	68 84 00 00 00       	push   $0x84
  802c1e:	68 f3 51 80 00       	push   $0x8051f3
  802c23:	e8 11 ed ff ff       	call   801939 <_panic>
  802c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 10                	je     802c41 <free+0x79>
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c39:	8b 52 04             	mov    0x4(%edx),%edx
  802c3c:	89 50 04             	mov    %edx,0x4(%eax)
  802c3f:	eb 0b                	jmp    802c4c <free+0x84>
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	a3 44 60 80 00       	mov    %eax,0x806044
  802c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4f:	8b 40 04             	mov    0x4(%eax),%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	74 0f                	je     802c65 <free+0x9d>
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	8b 40 04             	mov    0x4(%eax),%eax
  802c5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c5f:	8b 12                	mov    (%edx),%edx
  802c61:	89 10                	mov    %edx,(%eax)
  802c63:	eb 0a                	jmp    802c6f <free+0xa7>
  802c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	a3 40 60 80 00       	mov    %eax,0x806040
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c82:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802c87:	48                   	dec    %eax
  802c88:	a3 4c 60 80 00       	mov    %eax,0x80604c
	insert_sorted_with_merge_freeList(returned_block);
  802c8d:	83 ec 0c             	sub    $0xc,%esp
  802c90:	ff 75 ec             	pushl  -0x14(%ebp)
  802c93:	e8 63 12 00 00       	call   803efb <insert_sorted_with_merge_freeList>
  802c98:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  802c9b:	90                   	nop
  802c9c:	c9                   	leave  
  802c9d:	c3                   	ret    

00802c9e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
  802ca1:	83 ec 38             	sub    $0x38,%esp
  802ca4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ca7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802caa:	e8 c8 fc ff ff       	call   802977 <InitializeUHeap>
	if (size == 0) return NULL ;
  802caf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cb3:	75 0a                	jne    802cbf <smalloc+0x21>
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cba:	e9 a0 00 00 00       	jmp    802d5f <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  802cbf:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  802cc6:	76 0a                	jbe    802cd2 <smalloc+0x34>
		return NULL;
  802cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccd:	e9 8d 00 00 00       	jmp    802d5f <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802cd2:	e8 1b 07 00 00       	call   8033f2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 7f                	je     802d5a <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802cdb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	48                   	dec    %eax
  802ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf6:	f7 75 f4             	divl   -0xc(%ebp)
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	29 d0                	sub    %edx,%eax
  802cfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802d01:	83 ec 0c             	sub    $0xc,%esp
  802d04:	ff 75 ec             	pushl  -0x14(%ebp)
  802d07:	e8 65 0c 00 00       	call   803971 <alloc_block_FF>
  802d0c:	83 c4 10             	add    $0x10,%esp
  802d0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  802d12:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d16:	74 42                	je     802d5a <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  802d18:	83 ec 0c             	sub    $0xc,%esp
  802d1b:	ff 75 e8             	pushl  -0x18(%ebp)
  802d1e:	e8 9f 0a 00 00       	call   8037c2 <insert_sorted_allocList>
  802d23:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  802d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d29:	8b 40 08             	mov    0x8(%eax),%eax
  802d2c:	89 c2                	mov    %eax,%edx
  802d2e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802d32:	52                   	push   %edx
  802d33:	50                   	push   %eax
  802d34:	ff 75 0c             	pushl  0xc(%ebp)
  802d37:	ff 75 08             	pushl  0x8(%ebp)
  802d3a:	e8 38 04 00 00       	call   803177 <sys_createSharedObject>
  802d3f:	83 c4 10             	add    $0x10,%esp
  802d42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  802d45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d49:	79 07                	jns    802d52 <smalloc+0xb4>
	    		  return NULL;
  802d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d50:	eb 0d                	jmp    802d5f <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  802d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d55:	8b 40 08             	mov    0x8(%eax),%eax
  802d58:	eb 05                	jmp    802d5f <smalloc+0xc1>


				}


		return NULL;
  802d5a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802d5f:	c9                   	leave  
  802d60:	c3                   	ret    

00802d61 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
  802d64:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802d67:	e8 0b fc ff ff       	call   802977 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802d6c:	e8 81 06 00 00       	call   8033f2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802d71:	85 c0                	test   %eax,%eax
  802d73:	0f 84 9f 00 00 00    	je     802e18 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802d79:	83 ec 08             	sub    $0x8,%esp
  802d7c:	ff 75 0c             	pushl  0xc(%ebp)
  802d7f:	ff 75 08             	pushl  0x8(%ebp)
  802d82:	e8 1a 04 00 00       	call   8031a1 <sys_getSizeOfSharedObject>
  802d87:	83 c4 10             	add    $0x10,%esp
  802d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  802d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d91:	79 0a                	jns    802d9d <sget+0x3c>
		return NULL;
  802d93:	b8 00 00 00 00       	mov    $0x0,%eax
  802d98:	e9 80 00 00 00       	jmp    802e1d <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  802d9d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802da4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daa:	01 d0                	add    %edx,%eax
  802dac:	48                   	dec    %eax
  802dad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db3:	ba 00 00 00 00       	mov    $0x0,%edx
  802db8:	f7 75 f0             	divl   -0x10(%ebp)
  802dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbe:	29 d0                	sub    %edx,%eax
  802dc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802dc3:	83 ec 0c             	sub    $0xc,%esp
  802dc6:	ff 75 e8             	pushl  -0x18(%ebp)
  802dc9:	e8 a3 0b 00 00       	call   803971 <alloc_block_FF>
  802dce:	83 c4 10             	add    $0x10,%esp
  802dd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  802dd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dd8:	74 3e                	je     802e18 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  802dda:	83 ec 0c             	sub    $0xc,%esp
  802ddd:	ff 75 e4             	pushl  -0x1c(%ebp)
  802de0:	e8 dd 09 00 00       	call   8037c2 <insert_sorted_allocList>
  802de5:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  802de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802deb:	8b 40 08             	mov    0x8(%eax),%eax
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	50                   	push   %eax
  802df2:	ff 75 0c             	pushl  0xc(%ebp)
  802df5:	ff 75 08             	pushl  0x8(%ebp)
  802df8:	e8 c1 03 00 00       	call   8031be <sys_getSharedObject>
  802dfd:	83 c4 10             	add    $0x10,%esp
  802e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  802e03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e07:	79 07                	jns    802e10 <sget+0xaf>
	    		  return NULL;
  802e09:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0e:	eb 0d                	jmp    802e1d <sget+0xbc>
	  	return(void*) returned_block->sva;
  802e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e13:	8b 40 08             	mov    0x8(%eax),%eax
  802e16:	eb 05                	jmp    802e1d <sget+0xbc>
	      }
	}
	   return NULL;
  802e18:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802e1d:	c9                   	leave  
  802e1e:	c3                   	ret    

00802e1f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802e1f:	55                   	push   %ebp
  802e20:	89 e5                	mov    %esp,%ebp
  802e22:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802e25:	e8 4d fb ff ff       	call   802977 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	68 00 52 80 00       	push   $0x805200
  802e32:	68 12 01 00 00       	push   $0x112
  802e37:	68 f3 51 80 00       	push   $0x8051f3
  802e3c:	e8 f8 ea ff ff       	call   801939 <_panic>

00802e41 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802e41:	55                   	push   %ebp
  802e42:	89 e5                	mov    %esp,%ebp
  802e44:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802e47:	83 ec 04             	sub    $0x4,%esp
  802e4a:	68 28 52 80 00       	push   $0x805228
  802e4f:	68 26 01 00 00       	push   $0x126
  802e54:	68 f3 51 80 00       	push   $0x8051f3
  802e59:	e8 db ea ff ff       	call   801939 <_panic>

00802e5e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802e5e:	55                   	push   %ebp
  802e5f:	89 e5                	mov    %esp,%ebp
  802e61:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e64:	83 ec 04             	sub    $0x4,%esp
  802e67:	68 4c 52 80 00       	push   $0x80524c
  802e6c:	68 31 01 00 00       	push   $0x131
  802e71:	68 f3 51 80 00       	push   $0x8051f3
  802e76:	e8 be ea ff ff       	call   801939 <_panic>

00802e7b <shrink>:

}
void shrink(uint32 newSize)
{
  802e7b:	55                   	push   %ebp
  802e7c:	89 e5                	mov    %esp,%ebp
  802e7e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e81:	83 ec 04             	sub    $0x4,%esp
  802e84:	68 4c 52 80 00       	push   $0x80524c
  802e89:	68 36 01 00 00       	push   $0x136
  802e8e:	68 f3 51 80 00       	push   $0x8051f3
  802e93:	e8 a1 ea ff ff       	call   801939 <_panic>

00802e98 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802e98:	55                   	push   %ebp
  802e99:	89 e5                	mov    %esp,%ebp
  802e9b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e9e:	83 ec 04             	sub    $0x4,%esp
  802ea1:	68 4c 52 80 00       	push   $0x80524c
  802ea6:	68 3b 01 00 00       	push   $0x13b
  802eab:	68 f3 51 80 00       	push   $0x8051f3
  802eb0:	e8 84 ea ff ff       	call   801939 <_panic>

00802eb5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802eb5:	55                   	push   %ebp
  802eb6:	89 e5                	mov    %esp,%ebp
  802eb8:	57                   	push   %edi
  802eb9:	56                   	push   %esi
  802eba:	53                   	push   %ebx
  802ebb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ec7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eca:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ecd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ed0:	cd 30                	int    $0x30
  802ed2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ed8:	83 c4 10             	add    $0x10,%esp
  802edb:	5b                   	pop    %ebx
  802edc:	5e                   	pop    %esi
  802edd:	5f                   	pop    %edi
  802ede:	5d                   	pop    %ebp
  802edf:	c3                   	ret    

00802ee0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802ee0:	55                   	push   %ebp
  802ee1:	89 e5                	mov    %esp,%ebp
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802eec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 00                	push   $0x0
  802ef7:	52                   	push   %edx
  802ef8:	ff 75 0c             	pushl  0xc(%ebp)
  802efb:	50                   	push   %eax
  802efc:	6a 00                	push   $0x0
  802efe:	e8 b2 ff ff ff       	call   802eb5 <syscall>
  802f03:	83 c4 18             	add    $0x18,%esp
}
  802f06:	90                   	nop
  802f07:	c9                   	leave  
  802f08:	c3                   	ret    

00802f09 <sys_cgetc>:

int
sys_cgetc(void)
{
  802f09:	55                   	push   %ebp
  802f0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 01                	push   $0x1
  802f18:	e8 98 ff ff ff       	call   802eb5 <syscall>
  802f1d:	83 c4 18             	add    $0x18,%esp
}
  802f20:	c9                   	leave  
  802f21:	c3                   	ret    

00802f22 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f22:	55                   	push   %ebp
  802f23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	52                   	push   %edx
  802f32:	50                   	push   %eax
  802f33:	6a 05                	push   $0x5
  802f35:	e8 7b ff ff ff       	call   802eb5 <syscall>
  802f3a:	83 c4 18             	add    $0x18,%esp
}
  802f3d:	c9                   	leave  
  802f3e:	c3                   	ret    

00802f3f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f3f:	55                   	push   %ebp
  802f40:	89 e5                	mov    %esp,%ebp
  802f42:	56                   	push   %esi
  802f43:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f44:	8b 75 18             	mov    0x18(%ebp),%esi
  802f47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	56                   	push   %esi
  802f54:	53                   	push   %ebx
  802f55:	51                   	push   %ecx
  802f56:	52                   	push   %edx
  802f57:	50                   	push   %eax
  802f58:	6a 06                	push   $0x6
  802f5a:	e8 56 ff ff ff       	call   802eb5 <syscall>
  802f5f:	83 c4 18             	add    $0x18,%esp
}
  802f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f65:	5b                   	pop    %ebx
  802f66:	5e                   	pop    %esi
  802f67:	5d                   	pop    %ebp
  802f68:	c3                   	ret    

00802f69 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802f69:	55                   	push   %ebp
  802f6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	6a 00                	push   $0x0
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	52                   	push   %edx
  802f79:	50                   	push   %eax
  802f7a:	6a 07                	push   $0x7
  802f7c:	e8 34 ff ff ff       	call   802eb5 <syscall>
  802f81:	83 c4 18             	add    $0x18,%esp
}
  802f84:	c9                   	leave  
  802f85:	c3                   	ret    

00802f86 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f86:	55                   	push   %ebp
  802f87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f89:	6a 00                	push   $0x0
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	ff 75 0c             	pushl  0xc(%ebp)
  802f92:	ff 75 08             	pushl  0x8(%ebp)
  802f95:	6a 08                	push   $0x8
  802f97:	e8 19 ff ff ff       	call   802eb5 <syscall>
  802f9c:	83 c4 18             	add    $0x18,%esp
}
  802f9f:	c9                   	leave  
  802fa0:	c3                   	ret    

00802fa1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802fa1:	55                   	push   %ebp
  802fa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 00                	push   $0x0
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	6a 09                	push   $0x9
  802fb0:	e8 00 ff ff ff       	call   802eb5 <syscall>
  802fb5:	83 c4 18             	add    $0x18,%esp
}
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fbd:	6a 00                	push   $0x0
  802fbf:	6a 00                	push   $0x0
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 0a                	push   $0xa
  802fc9:	e8 e7 fe ff ff       	call   802eb5 <syscall>
  802fce:	83 c4 18             	add    $0x18,%esp
}
  802fd1:	c9                   	leave  
  802fd2:	c3                   	ret    

00802fd3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fd3:	55                   	push   %ebp
  802fd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fd6:	6a 00                	push   $0x0
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 0b                	push   $0xb
  802fe2:	e8 ce fe ff ff       	call   802eb5 <syscall>
  802fe7:	83 c4 18             	add    $0x18,%esp
}
  802fea:	c9                   	leave  
  802feb:	c3                   	ret    

00802fec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802fec:	55                   	push   %ebp
  802fed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802fef:	6a 00                	push   $0x0
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	ff 75 0c             	pushl  0xc(%ebp)
  802ff8:	ff 75 08             	pushl  0x8(%ebp)
  802ffb:	6a 0f                	push   $0xf
  802ffd:	e8 b3 fe ff ff       	call   802eb5 <syscall>
  803002:	83 c4 18             	add    $0x18,%esp
	return;
  803005:	90                   	nop
}
  803006:	c9                   	leave  
  803007:	c3                   	ret    

00803008 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803008:	55                   	push   %ebp
  803009:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80300b:	6a 00                	push   $0x0
  80300d:	6a 00                	push   $0x0
  80300f:	6a 00                	push   $0x0
  803011:	ff 75 0c             	pushl  0xc(%ebp)
  803014:	ff 75 08             	pushl  0x8(%ebp)
  803017:	6a 10                	push   $0x10
  803019:	e8 97 fe ff ff       	call   802eb5 <syscall>
  80301e:	83 c4 18             	add    $0x18,%esp
	return ;
  803021:	90                   	nop
}
  803022:	c9                   	leave  
  803023:	c3                   	ret    

00803024 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803024:	55                   	push   %ebp
  803025:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803027:	6a 00                	push   $0x0
  803029:	6a 00                	push   $0x0
  80302b:	ff 75 10             	pushl  0x10(%ebp)
  80302e:	ff 75 0c             	pushl  0xc(%ebp)
  803031:	ff 75 08             	pushl  0x8(%ebp)
  803034:	6a 11                	push   $0x11
  803036:	e8 7a fe ff ff       	call   802eb5 <syscall>
  80303b:	83 c4 18             	add    $0x18,%esp
	return ;
  80303e:	90                   	nop
}
  80303f:	c9                   	leave  
  803040:	c3                   	ret    

00803041 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803041:	55                   	push   %ebp
  803042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 0c                	push   $0xc
  803050:	e8 60 fe ff ff       	call   802eb5 <syscall>
  803055:	83 c4 18             	add    $0x18,%esp
}
  803058:	c9                   	leave  
  803059:	c3                   	ret    

0080305a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80305a:	55                   	push   %ebp
  80305b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80305d:	6a 00                	push   $0x0
  80305f:	6a 00                	push   $0x0
  803061:	6a 00                	push   $0x0
  803063:	6a 00                	push   $0x0
  803065:	ff 75 08             	pushl  0x8(%ebp)
  803068:	6a 0d                	push   $0xd
  80306a:	e8 46 fe ff ff       	call   802eb5 <syscall>
  80306f:	83 c4 18             	add    $0x18,%esp
}
  803072:	c9                   	leave  
  803073:	c3                   	ret    

00803074 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803074:	55                   	push   %ebp
  803075:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803077:	6a 00                	push   $0x0
  803079:	6a 00                	push   $0x0
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 0e                	push   $0xe
  803083:	e8 2d fe ff ff       	call   802eb5 <syscall>
  803088:	83 c4 18             	add    $0x18,%esp
}
  80308b:	90                   	nop
  80308c:	c9                   	leave  
  80308d:	c3                   	ret    

0080308e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80308e:	55                   	push   %ebp
  80308f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  803091:	6a 00                	push   $0x0
  803093:	6a 00                	push   $0x0
  803095:	6a 00                	push   $0x0
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	6a 13                	push   $0x13
  80309d:	e8 13 fe ff ff       	call   802eb5 <syscall>
  8030a2:	83 c4 18             	add    $0x18,%esp
}
  8030a5:	90                   	nop
  8030a6:	c9                   	leave  
  8030a7:	c3                   	ret    

008030a8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8030a8:	55                   	push   %ebp
  8030a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8030ab:	6a 00                	push   $0x0
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 14                	push   $0x14
  8030b7:	e8 f9 fd ff ff       	call   802eb5 <syscall>
  8030bc:	83 c4 18             	add    $0x18,%esp
}
  8030bf:	90                   	nop
  8030c0:	c9                   	leave  
  8030c1:	c3                   	ret    

008030c2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8030c2:	55                   	push   %ebp
  8030c3:	89 e5                	mov    %esp,%ebp
  8030c5:	83 ec 04             	sub    $0x4,%esp
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8030ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 00                	push   $0x0
  8030d6:	6a 00                	push   $0x0
  8030d8:	6a 00                	push   $0x0
  8030da:	50                   	push   %eax
  8030db:	6a 15                	push   $0x15
  8030dd:	e8 d3 fd ff ff       	call   802eb5 <syscall>
  8030e2:	83 c4 18             	add    $0x18,%esp
}
  8030e5:	90                   	nop
  8030e6:	c9                   	leave  
  8030e7:	c3                   	ret    

008030e8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8030e8:	55                   	push   %ebp
  8030e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 00                	push   $0x0
  8030f1:	6a 00                	push   $0x0
  8030f3:	6a 00                	push   $0x0
  8030f5:	6a 16                	push   $0x16
  8030f7:	e8 b9 fd ff ff       	call   802eb5 <syscall>
  8030fc:	83 c4 18             	add    $0x18,%esp
}
  8030ff:	90                   	nop
  803100:	c9                   	leave  
  803101:	c3                   	ret    

00803102 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	6a 00                	push   $0x0
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	ff 75 0c             	pushl  0xc(%ebp)
  803111:	50                   	push   %eax
  803112:	6a 17                	push   $0x17
  803114:	e8 9c fd ff ff       	call   802eb5 <syscall>
  803119:	83 c4 18             	add    $0x18,%esp
}
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    

0080311e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80311e:	55                   	push   %ebp
  80311f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803121:	8b 55 0c             	mov    0xc(%ebp),%edx
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	6a 00                	push   $0x0
  803129:	6a 00                	push   $0x0
  80312b:	6a 00                	push   $0x0
  80312d:	52                   	push   %edx
  80312e:	50                   	push   %eax
  80312f:	6a 1a                	push   $0x1a
  803131:	e8 7f fd ff ff       	call   802eb5 <syscall>
  803136:	83 c4 18             	add    $0x18,%esp
}
  803139:	c9                   	leave  
  80313a:	c3                   	ret    

0080313b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80313b:	55                   	push   %ebp
  80313c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80313e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	6a 00                	push   $0x0
  80314a:	52                   	push   %edx
  80314b:	50                   	push   %eax
  80314c:	6a 18                	push   $0x18
  80314e:	e8 62 fd ff ff       	call   802eb5 <syscall>
  803153:	83 c4 18             	add    $0x18,%esp
}
  803156:	90                   	nop
  803157:	c9                   	leave  
  803158:	c3                   	ret    

00803159 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  803159:	55                   	push   %ebp
  80315a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80315c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	6a 00                	push   $0x0
  803164:	6a 00                	push   $0x0
  803166:	6a 00                	push   $0x0
  803168:	52                   	push   %edx
  803169:	50                   	push   %eax
  80316a:	6a 19                	push   $0x19
  80316c:	e8 44 fd ff ff       	call   802eb5 <syscall>
  803171:	83 c4 18             	add    $0x18,%esp
}
  803174:	90                   	nop
  803175:	c9                   	leave  
  803176:	c3                   	ret    

00803177 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803177:	55                   	push   %ebp
  803178:	89 e5                	mov    %esp,%ebp
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	8b 45 10             	mov    0x10(%ebp),%eax
  803180:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803183:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803186:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	6a 00                	push   $0x0
  80318f:	51                   	push   %ecx
  803190:	52                   	push   %edx
  803191:	ff 75 0c             	pushl  0xc(%ebp)
  803194:	50                   	push   %eax
  803195:	6a 1b                	push   $0x1b
  803197:	e8 19 fd ff ff       	call   802eb5 <syscall>
  80319c:	83 c4 18             	add    $0x18,%esp
}
  80319f:	c9                   	leave  
  8031a0:	c3                   	ret    

008031a1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8031a1:	55                   	push   %ebp
  8031a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	6a 00                	push   $0x0
  8031ac:	6a 00                	push   $0x0
  8031ae:	6a 00                	push   $0x0
  8031b0:	52                   	push   %edx
  8031b1:	50                   	push   %eax
  8031b2:	6a 1c                	push   $0x1c
  8031b4:	e8 fc fc ff ff       	call   802eb5 <syscall>
  8031b9:	83 c4 18             	add    $0x18,%esp
}
  8031bc:	c9                   	leave  
  8031bd:	c3                   	ret    

008031be <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8031c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	6a 00                	push   $0x0
  8031cc:	6a 00                	push   $0x0
  8031ce:	51                   	push   %ecx
  8031cf:	52                   	push   %edx
  8031d0:	50                   	push   %eax
  8031d1:	6a 1d                	push   $0x1d
  8031d3:	e8 dd fc ff ff       	call   802eb5 <syscall>
  8031d8:	83 c4 18             	add    $0x18,%esp
}
  8031db:	c9                   	leave  
  8031dc:	c3                   	ret    

008031dd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8031dd:	55                   	push   %ebp
  8031de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8031e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	6a 00                	push   $0x0
  8031e8:	6a 00                	push   $0x0
  8031ea:	6a 00                	push   $0x0
  8031ec:	52                   	push   %edx
  8031ed:	50                   	push   %eax
  8031ee:	6a 1e                	push   $0x1e
  8031f0:	e8 c0 fc ff ff       	call   802eb5 <syscall>
  8031f5:	83 c4 18             	add    $0x18,%esp
}
  8031f8:	c9                   	leave  
  8031f9:	c3                   	ret    

008031fa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8031fa:	55                   	push   %ebp
  8031fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8031fd:	6a 00                	push   $0x0
  8031ff:	6a 00                	push   $0x0
  803201:	6a 00                	push   $0x0
  803203:	6a 00                	push   $0x0
  803205:	6a 00                	push   $0x0
  803207:	6a 1f                	push   $0x1f
  803209:	e8 a7 fc ff ff       	call   802eb5 <syscall>
  80320e:	83 c4 18             	add    $0x18,%esp
}
  803211:	c9                   	leave  
  803212:	c3                   	ret    

00803213 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803213:	55                   	push   %ebp
  803214:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	6a 00                	push   $0x0
  80321b:	ff 75 14             	pushl  0x14(%ebp)
  80321e:	ff 75 10             	pushl  0x10(%ebp)
  803221:	ff 75 0c             	pushl  0xc(%ebp)
  803224:	50                   	push   %eax
  803225:	6a 20                	push   $0x20
  803227:	e8 89 fc ff ff       	call   802eb5 <syscall>
  80322c:	83 c4 18             	add    $0x18,%esp
}
  80322f:	c9                   	leave  
  803230:	c3                   	ret    

00803231 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  803231:	55                   	push   %ebp
  803232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	6a 00                	push   $0x0
  803239:	6a 00                	push   $0x0
  80323b:	6a 00                	push   $0x0
  80323d:	6a 00                	push   $0x0
  80323f:	50                   	push   %eax
  803240:	6a 21                	push   $0x21
  803242:	e8 6e fc ff ff       	call   802eb5 <syscall>
  803247:	83 c4 18             	add    $0x18,%esp
}
  80324a:	90                   	nop
  80324b:	c9                   	leave  
  80324c:	c3                   	ret    

0080324d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80324d:	55                   	push   %ebp
  80324e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	6a 00                	push   $0x0
  803255:	6a 00                	push   $0x0
  803257:	6a 00                	push   $0x0
  803259:	6a 00                	push   $0x0
  80325b:	50                   	push   %eax
  80325c:	6a 22                	push   $0x22
  80325e:	e8 52 fc ff ff       	call   802eb5 <syscall>
  803263:	83 c4 18             	add    $0x18,%esp
}
  803266:	c9                   	leave  
  803267:	c3                   	ret    

00803268 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803268:	55                   	push   %ebp
  803269:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80326b:	6a 00                	push   $0x0
  80326d:	6a 00                	push   $0x0
  80326f:	6a 00                	push   $0x0
  803271:	6a 00                	push   $0x0
  803273:	6a 00                	push   $0x0
  803275:	6a 02                	push   $0x2
  803277:	e8 39 fc ff ff       	call   802eb5 <syscall>
  80327c:	83 c4 18             	add    $0x18,%esp
}
  80327f:	c9                   	leave  
  803280:	c3                   	ret    

00803281 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803281:	55                   	push   %ebp
  803282:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803284:	6a 00                	push   $0x0
  803286:	6a 00                	push   $0x0
  803288:	6a 00                	push   $0x0
  80328a:	6a 00                	push   $0x0
  80328c:	6a 00                	push   $0x0
  80328e:	6a 03                	push   $0x3
  803290:	e8 20 fc ff ff       	call   802eb5 <syscall>
  803295:	83 c4 18             	add    $0x18,%esp
}
  803298:	c9                   	leave  
  803299:	c3                   	ret    

0080329a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80329a:	55                   	push   %ebp
  80329b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80329d:	6a 00                	push   $0x0
  80329f:	6a 00                	push   $0x0
  8032a1:	6a 00                	push   $0x0
  8032a3:	6a 00                	push   $0x0
  8032a5:	6a 00                	push   $0x0
  8032a7:	6a 04                	push   $0x4
  8032a9:	e8 07 fc ff ff       	call   802eb5 <syscall>
  8032ae:	83 c4 18             	add    $0x18,%esp
}
  8032b1:	c9                   	leave  
  8032b2:	c3                   	ret    

008032b3 <sys_exit_env>:


void sys_exit_env(void)
{
  8032b3:	55                   	push   %ebp
  8032b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032b6:	6a 00                	push   $0x0
  8032b8:	6a 00                	push   $0x0
  8032ba:	6a 00                	push   $0x0
  8032bc:	6a 00                	push   $0x0
  8032be:	6a 00                	push   $0x0
  8032c0:	6a 23                	push   $0x23
  8032c2:	e8 ee fb ff ff       	call   802eb5 <syscall>
  8032c7:	83 c4 18             	add    $0x18,%esp
}
  8032ca:	90                   	nop
  8032cb:	c9                   	leave  
  8032cc:	c3                   	ret    

008032cd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8032cd:	55                   	push   %ebp
  8032ce:	89 e5                	mov    %esp,%ebp
  8032d0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032d6:	8d 50 04             	lea    0x4(%eax),%edx
  8032d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032dc:	6a 00                	push   $0x0
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 00                	push   $0x0
  8032e2:	52                   	push   %edx
  8032e3:	50                   	push   %eax
  8032e4:	6a 24                	push   $0x24
  8032e6:	e8 ca fb ff ff       	call   802eb5 <syscall>
  8032eb:	83 c4 18             	add    $0x18,%esp
	return result;
  8032ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8032f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032f7:	89 01                	mov    %eax,(%ecx)
  8032f9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	c9                   	leave  
  803300:	c2 04 00             	ret    $0x4

00803303 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803303:	55                   	push   %ebp
  803304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803306:	6a 00                	push   $0x0
  803308:	6a 00                	push   $0x0
  80330a:	ff 75 10             	pushl  0x10(%ebp)
  80330d:	ff 75 0c             	pushl  0xc(%ebp)
  803310:	ff 75 08             	pushl  0x8(%ebp)
  803313:	6a 12                	push   $0x12
  803315:	e8 9b fb ff ff       	call   802eb5 <syscall>
  80331a:	83 c4 18             	add    $0x18,%esp
	return ;
  80331d:	90                   	nop
}
  80331e:	c9                   	leave  
  80331f:	c3                   	ret    

00803320 <sys_rcr2>:
uint32 sys_rcr2()
{
  803320:	55                   	push   %ebp
  803321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803323:	6a 00                	push   $0x0
  803325:	6a 00                	push   $0x0
  803327:	6a 00                	push   $0x0
  803329:	6a 00                	push   $0x0
  80332b:	6a 00                	push   $0x0
  80332d:	6a 25                	push   $0x25
  80332f:	e8 81 fb ff ff       	call   802eb5 <syscall>
  803334:	83 c4 18             	add    $0x18,%esp
}
  803337:	c9                   	leave  
  803338:	c3                   	ret    

00803339 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  803339:	55                   	push   %ebp
  80333a:	89 e5                	mov    %esp,%ebp
  80333c:	83 ec 04             	sub    $0x4,%esp
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803345:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803349:	6a 00                	push   $0x0
  80334b:	6a 00                	push   $0x0
  80334d:	6a 00                	push   $0x0
  80334f:	6a 00                	push   $0x0
  803351:	50                   	push   %eax
  803352:	6a 26                	push   $0x26
  803354:	e8 5c fb ff ff       	call   802eb5 <syscall>
  803359:	83 c4 18             	add    $0x18,%esp
	return ;
  80335c:	90                   	nop
}
  80335d:	c9                   	leave  
  80335e:	c3                   	ret    

0080335f <rsttst>:
void rsttst()
{
  80335f:	55                   	push   %ebp
  803360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803362:	6a 00                	push   $0x0
  803364:	6a 00                	push   $0x0
  803366:	6a 00                	push   $0x0
  803368:	6a 00                	push   $0x0
  80336a:	6a 00                	push   $0x0
  80336c:	6a 28                	push   $0x28
  80336e:	e8 42 fb ff ff       	call   802eb5 <syscall>
  803373:	83 c4 18             	add    $0x18,%esp
	return ;
  803376:	90                   	nop
}
  803377:	c9                   	leave  
  803378:	c3                   	ret    

00803379 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803379:	55                   	push   %ebp
  80337a:	89 e5                	mov    %esp,%ebp
  80337c:	83 ec 04             	sub    $0x4,%esp
  80337f:	8b 45 14             	mov    0x14(%ebp),%eax
  803382:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803385:	8b 55 18             	mov    0x18(%ebp),%edx
  803388:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80338c:	52                   	push   %edx
  80338d:	50                   	push   %eax
  80338e:	ff 75 10             	pushl  0x10(%ebp)
  803391:	ff 75 0c             	pushl  0xc(%ebp)
  803394:	ff 75 08             	pushl  0x8(%ebp)
  803397:	6a 27                	push   $0x27
  803399:	e8 17 fb ff ff       	call   802eb5 <syscall>
  80339e:	83 c4 18             	add    $0x18,%esp
	return ;
  8033a1:	90                   	nop
}
  8033a2:	c9                   	leave  
  8033a3:	c3                   	ret    

008033a4 <chktst>:
void chktst(uint32 n)
{
  8033a4:	55                   	push   %ebp
  8033a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033a7:	6a 00                	push   $0x0
  8033a9:	6a 00                	push   $0x0
  8033ab:	6a 00                	push   $0x0
  8033ad:	6a 00                	push   $0x0
  8033af:	ff 75 08             	pushl  0x8(%ebp)
  8033b2:	6a 29                	push   $0x29
  8033b4:	e8 fc fa ff ff       	call   802eb5 <syscall>
  8033b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8033bc:	90                   	nop
}
  8033bd:	c9                   	leave  
  8033be:	c3                   	ret    

008033bf <inctst>:

void inctst()
{
  8033bf:	55                   	push   %ebp
  8033c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033c2:	6a 00                	push   $0x0
  8033c4:	6a 00                	push   $0x0
  8033c6:	6a 00                	push   $0x0
  8033c8:	6a 00                	push   $0x0
  8033ca:	6a 00                	push   $0x0
  8033cc:	6a 2a                	push   $0x2a
  8033ce:	e8 e2 fa ff ff       	call   802eb5 <syscall>
  8033d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8033d6:	90                   	nop
}
  8033d7:	c9                   	leave  
  8033d8:	c3                   	ret    

008033d9 <gettst>:
uint32 gettst()
{
  8033d9:	55                   	push   %ebp
  8033da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033dc:	6a 00                	push   $0x0
  8033de:	6a 00                	push   $0x0
  8033e0:	6a 00                	push   $0x0
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 2b                	push   $0x2b
  8033e8:	e8 c8 fa ff ff       	call   802eb5 <syscall>
  8033ed:	83 c4 18             	add    $0x18,%esp
}
  8033f0:	c9                   	leave  
  8033f1:	c3                   	ret    

008033f2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8033f2:	55                   	push   %ebp
  8033f3:	89 e5                	mov    %esp,%ebp
  8033f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033f8:	6a 00                	push   $0x0
  8033fa:	6a 00                	push   $0x0
  8033fc:	6a 00                	push   $0x0
  8033fe:	6a 00                	push   $0x0
  803400:	6a 00                	push   $0x0
  803402:	6a 2c                	push   $0x2c
  803404:	e8 ac fa ff ff       	call   802eb5 <syscall>
  803409:	83 c4 18             	add    $0x18,%esp
  80340c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80340f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  803413:	75 07                	jne    80341c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803415:	b8 01 00 00 00       	mov    $0x1,%eax
  80341a:	eb 05                	jmp    803421 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80341c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803421:	c9                   	leave  
  803422:	c3                   	ret    

00803423 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  803423:	55                   	push   %ebp
  803424:	89 e5                	mov    %esp,%ebp
  803426:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803429:	6a 00                	push   $0x0
  80342b:	6a 00                	push   $0x0
  80342d:	6a 00                	push   $0x0
  80342f:	6a 00                	push   $0x0
  803431:	6a 00                	push   $0x0
  803433:	6a 2c                	push   $0x2c
  803435:	e8 7b fa ff ff       	call   802eb5 <syscall>
  80343a:	83 c4 18             	add    $0x18,%esp
  80343d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803440:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803444:	75 07                	jne    80344d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803446:	b8 01 00 00 00       	mov    $0x1,%eax
  80344b:	eb 05                	jmp    803452 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80344d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803452:	c9                   	leave  
  803453:	c3                   	ret    

00803454 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803454:	55                   	push   %ebp
  803455:	89 e5                	mov    %esp,%ebp
  803457:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80345a:	6a 00                	push   $0x0
  80345c:	6a 00                	push   $0x0
  80345e:	6a 00                	push   $0x0
  803460:	6a 00                	push   $0x0
  803462:	6a 00                	push   $0x0
  803464:	6a 2c                	push   $0x2c
  803466:	e8 4a fa ff ff       	call   802eb5 <syscall>
  80346b:	83 c4 18             	add    $0x18,%esp
  80346e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803471:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803475:	75 07                	jne    80347e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803477:	b8 01 00 00 00       	mov    $0x1,%eax
  80347c:	eb 05                	jmp    803483 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80347e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803483:	c9                   	leave  
  803484:	c3                   	ret    

00803485 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803485:	55                   	push   %ebp
  803486:	89 e5                	mov    %esp,%ebp
  803488:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80348b:	6a 00                	push   $0x0
  80348d:	6a 00                	push   $0x0
  80348f:	6a 00                	push   $0x0
  803491:	6a 00                	push   $0x0
  803493:	6a 00                	push   $0x0
  803495:	6a 2c                	push   $0x2c
  803497:	e8 19 fa ff ff       	call   802eb5 <syscall>
  80349c:	83 c4 18             	add    $0x18,%esp
  80349f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8034a2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8034a6:	75 07                	jne    8034af <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8034a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ad:	eb 05                	jmp    8034b4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8034af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034b4:	c9                   	leave  
  8034b5:	c3                   	ret    

008034b6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8034b6:	55                   	push   %ebp
  8034b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8034b9:	6a 00                	push   $0x0
  8034bb:	6a 00                	push   $0x0
  8034bd:	6a 00                	push   $0x0
  8034bf:	6a 00                	push   $0x0
  8034c1:	ff 75 08             	pushl  0x8(%ebp)
  8034c4:	6a 2d                	push   $0x2d
  8034c6:	e8 ea f9 ff ff       	call   802eb5 <syscall>
  8034cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8034ce:	90                   	nop
}
  8034cf:	c9                   	leave  
  8034d0:	c3                   	ret    

008034d1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8034d1:	55                   	push   %ebp
  8034d2:	89 e5                	mov    %esp,%ebp
  8034d4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8034d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	6a 00                	push   $0x0
  8034e3:	53                   	push   %ebx
  8034e4:	51                   	push   %ecx
  8034e5:	52                   	push   %edx
  8034e6:	50                   	push   %eax
  8034e7:	6a 2e                	push   $0x2e
  8034e9:	e8 c7 f9 ff ff       	call   802eb5 <syscall>
  8034ee:	83 c4 18             	add    $0x18,%esp
}
  8034f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034f4:	c9                   	leave  
  8034f5:	c3                   	ret    

008034f6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8034f6:	55                   	push   %ebp
  8034f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8034f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	6a 00                	push   $0x0
  803501:	6a 00                	push   $0x0
  803503:	6a 00                	push   $0x0
  803505:	52                   	push   %edx
  803506:	50                   	push   %eax
  803507:	6a 2f                	push   $0x2f
  803509:	e8 a7 f9 ff ff       	call   802eb5 <syscall>
  80350e:	83 c4 18             	add    $0x18,%esp
}
  803511:	c9                   	leave  
  803512:	c3                   	ret    

00803513 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  803513:	55                   	push   %ebp
  803514:	89 e5                	mov    %esp,%ebp
  803516:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  803519:	83 ec 0c             	sub    $0xc,%esp
  80351c:	68 5c 52 80 00       	push   $0x80525c
  803521:	e8 c7 e6 ff ff       	call   801bed <cprintf>
  803526:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803529:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  803530:	83 ec 0c             	sub    $0xc,%esp
  803533:	68 88 52 80 00       	push   $0x805288
  803538:	e8 b0 e6 ff ff       	call   801bed <cprintf>
  80353d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  803540:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803544:	a1 38 61 80 00       	mov    0x806138,%eax
  803549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80354c:	eb 56                	jmp    8035a4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80354e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803552:	74 1c                	je     803570 <print_mem_block_lists+0x5d>
  803554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803557:	8b 50 08             	mov    0x8(%eax),%edx
  80355a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355d:	8b 48 08             	mov    0x8(%eax),%ecx
  803560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803563:	8b 40 0c             	mov    0xc(%eax),%eax
  803566:	01 c8                	add    %ecx,%eax
  803568:	39 c2                	cmp    %eax,%edx
  80356a:	73 04                	jae    803570 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80356c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803573:	8b 50 08             	mov    0x8(%eax),%edx
  803576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803579:	8b 40 0c             	mov    0xc(%eax),%eax
  80357c:	01 c2                	add    %eax,%edx
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	8b 40 08             	mov    0x8(%eax),%eax
  803584:	83 ec 04             	sub    $0x4,%esp
  803587:	52                   	push   %edx
  803588:	50                   	push   %eax
  803589:	68 9d 52 80 00       	push   $0x80529d
  80358e:	e8 5a e6 ff ff       	call   801bed <cprintf>
  803593:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803599:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80359c:	a1 40 61 80 00       	mov    0x806140,%eax
  8035a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a8:	74 07                	je     8035b1 <print_mem_block_lists+0x9e>
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	8b 00                	mov    (%eax),%eax
  8035af:	eb 05                	jmp    8035b6 <print_mem_block_lists+0xa3>
  8035b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b6:	a3 40 61 80 00       	mov    %eax,0x806140
  8035bb:	a1 40 61 80 00       	mov    0x806140,%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	75 8a                	jne    80354e <print_mem_block_lists+0x3b>
  8035c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c8:	75 84                	jne    80354e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8035ca:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8035ce:	75 10                	jne    8035e0 <print_mem_block_lists+0xcd>
  8035d0:	83 ec 0c             	sub    $0xc,%esp
  8035d3:	68 ac 52 80 00       	push   $0x8052ac
  8035d8:	e8 10 e6 ff ff       	call   801bed <cprintf>
  8035dd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8035e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8035e7:	83 ec 0c             	sub    $0xc,%esp
  8035ea:	68 d0 52 80 00       	push   $0x8052d0
  8035ef:	e8 f9 e5 ff ff       	call   801bed <cprintf>
  8035f4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8035f7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8035fb:	a1 40 60 80 00       	mov    0x806040,%eax
  803600:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803603:	eb 56                	jmp    80365b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803605:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803609:	74 1c                	je     803627 <print_mem_block_lists+0x114>
  80360b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360e:	8b 50 08             	mov    0x8(%eax),%edx
  803611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803614:	8b 48 08             	mov    0x8(%eax),%ecx
  803617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361a:	8b 40 0c             	mov    0xc(%eax),%eax
  80361d:	01 c8                	add    %ecx,%eax
  80361f:	39 c2                	cmp    %eax,%edx
  803621:	73 04                	jae    803627 <print_mem_block_lists+0x114>
			sorted = 0 ;
  803623:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362a:	8b 50 08             	mov    0x8(%eax),%edx
  80362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803630:	8b 40 0c             	mov    0xc(%eax),%eax
  803633:	01 c2                	add    %eax,%edx
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	8b 40 08             	mov    0x8(%eax),%eax
  80363b:	83 ec 04             	sub    $0x4,%esp
  80363e:	52                   	push   %edx
  80363f:	50                   	push   %eax
  803640:	68 9d 52 80 00       	push   $0x80529d
  803645:	e8 a3 e5 ff ff       	call   801bed <cprintf>
  80364a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803653:	a1 48 60 80 00       	mov    0x806048,%eax
  803658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80365b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365f:	74 07                	je     803668 <print_mem_block_lists+0x155>
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	8b 00                	mov    (%eax),%eax
  803666:	eb 05                	jmp    80366d <print_mem_block_lists+0x15a>
  803668:	b8 00 00 00 00       	mov    $0x0,%eax
  80366d:	a3 48 60 80 00       	mov    %eax,0x806048
  803672:	a1 48 60 80 00       	mov    0x806048,%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	75 8a                	jne    803605 <print_mem_block_lists+0xf2>
  80367b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367f:	75 84                	jne    803605 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803681:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803685:	75 10                	jne    803697 <print_mem_block_lists+0x184>
  803687:	83 ec 0c             	sub    $0xc,%esp
  80368a:	68 e8 52 80 00       	push   $0x8052e8
  80368f:	e8 59 e5 ff ff       	call   801bed <cprintf>
  803694:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803697:	83 ec 0c             	sub    $0xc,%esp
  80369a:	68 5c 52 80 00       	push   $0x80525c
  80369f:	e8 49 e5 ff ff       	call   801bed <cprintf>
  8036a4:	83 c4 10             	add    $0x10,%esp

}
  8036a7:	90                   	nop
  8036a8:	c9                   	leave  
  8036a9:	c3                   	ret    

008036aa <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8036aa:	55                   	push   %ebp
  8036ab:	89 e5                	mov    %esp,%ebp
  8036ad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8036b0:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  8036b7:	00 00 00 
  8036ba:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8036c1:	00 00 00 
  8036c4:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8036cb:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8036ce:	a1 50 60 80 00       	mov    0x806050,%eax
  8036d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8036d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036dd:	e9 9e 00 00 00       	jmp    803780 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8036e2:	a1 50 60 80 00       	mov    0x806050,%eax
  8036e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ea:	c1 e2 04             	shl    $0x4,%edx
  8036ed:	01 d0                	add    %edx,%eax
  8036ef:	85 c0                	test   %eax,%eax
  8036f1:	75 14                	jne    803707 <initialize_MemBlocksList+0x5d>
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 10 53 80 00       	push   $0x805310
  8036fb:	6a 48                	push   $0x48
  8036fd:	68 33 53 80 00       	push   $0x805333
  803702:	e8 32 e2 ff ff       	call   801939 <_panic>
  803707:	a1 50 60 80 00       	mov    0x806050,%eax
  80370c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80370f:	c1 e2 04             	shl    $0x4,%edx
  803712:	01 d0                	add    %edx,%eax
  803714:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80371a:	89 10                	mov    %edx,(%eax)
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	85 c0                	test   %eax,%eax
  803720:	74 18                	je     80373a <initialize_MemBlocksList+0x90>
  803722:	a1 48 61 80 00       	mov    0x806148,%eax
  803727:	8b 15 50 60 80 00    	mov    0x806050,%edx
  80372d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803730:	c1 e1 04             	shl    $0x4,%ecx
  803733:	01 ca                	add    %ecx,%edx
  803735:	89 50 04             	mov    %edx,0x4(%eax)
  803738:	eb 12                	jmp    80374c <initialize_MemBlocksList+0xa2>
  80373a:	a1 50 60 80 00       	mov    0x806050,%eax
  80373f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803742:	c1 e2 04             	shl    $0x4,%edx
  803745:	01 d0                	add    %edx,%eax
  803747:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80374c:	a1 50 60 80 00       	mov    0x806050,%eax
  803751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803754:	c1 e2 04             	shl    $0x4,%edx
  803757:	01 d0                	add    %edx,%eax
  803759:	a3 48 61 80 00       	mov    %eax,0x806148
  80375e:	a1 50 60 80 00       	mov    0x806050,%eax
  803763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803766:	c1 e2 04             	shl    $0x4,%edx
  803769:	01 d0                	add    %edx,%eax
  80376b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803772:	a1 54 61 80 00       	mov    0x806154,%eax
  803777:	40                   	inc    %eax
  803778:	a3 54 61 80 00       	mov    %eax,0x806154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80377d:	ff 45 f4             	incl   -0xc(%ebp)
  803780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803783:	3b 45 08             	cmp    0x8(%ebp),%eax
  803786:	0f 82 56 ff ff ff    	jb     8036e2 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80378c:	90                   	nop
  80378d:	c9                   	leave  
  80378e:	c3                   	ret    

0080378f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80378f:	55                   	push   %ebp
  803790:	89 e5                	mov    %esp,%ebp
  803792:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  803795:	8b 45 08             	mov    0x8(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80379d:	eb 18                	jmp    8037b7 <find_block+0x28>
		{
			if(tmp->sva==va)
  80379f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037a2:	8b 40 08             	mov    0x8(%eax),%eax
  8037a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037a8:	75 05                	jne    8037af <find_block+0x20>
			{
				return tmp;
  8037aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037ad:	eb 11                	jmp    8037c0 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  8037af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037b2:	8b 00                	mov    (%eax),%eax
  8037b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8037b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8037bb:	75 e2                	jne    80379f <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8037bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8037c0:	c9                   	leave  
  8037c1:	c3                   	ret    

008037c2 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8037c2:	55                   	push   %ebp
  8037c3:	89 e5                	mov    %esp,%ebp
  8037c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8037c8:	a1 40 60 80 00       	mov    0x806040,%eax
  8037cd:	85 c0                	test   %eax,%eax
  8037cf:	0f 85 83 00 00 00    	jne    803858 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8037d5:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8037dc:	00 00 00 
  8037df:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8037e6:	00 00 00 
  8037e9:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8037f0:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8037f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037f7:	75 14                	jne    80380d <insert_sorted_allocList+0x4b>
  8037f9:	83 ec 04             	sub    $0x4,%esp
  8037fc:	68 10 53 80 00       	push   $0x805310
  803801:	6a 7f                	push   $0x7f
  803803:	68 33 53 80 00       	push   $0x805333
  803808:	e8 2c e1 ff ff       	call   801939 <_panic>
  80380d:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803813:	8b 45 08             	mov    0x8(%ebp),%eax
  803816:	89 10                	mov    %edx,(%eax)
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	8b 00                	mov    (%eax),%eax
  80381d:	85 c0                	test   %eax,%eax
  80381f:	74 0d                	je     80382e <insert_sorted_allocList+0x6c>
  803821:	a1 40 60 80 00       	mov    0x806040,%eax
  803826:	8b 55 08             	mov    0x8(%ebp),%edx
  803829:	89 50 04             	mov    %edx,0x4(%eax)
  80382c:	eb 08                	jmp    803836 <insert_sorted_allocList+0x74>
  80382e:	8b 45 08             	mov    0x8(%ebp),%eax
  803831:	a3 44 60 80 00       	mov    %eax,0x806044
  803836:	8b 45 08             	mov    0x8(%ebp),%eax
  803839:	a3 40 60 80 00       	mov    %eax,0x806040
  80383e:	8b 45 08             	mov    0x8(%ebp),%eax
  803841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803848:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80384d:	40                   	inc    %eax
  80384e:	a3 4c 60 80 00       	mov    %eax,0x80604c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  803853:	e9 16 01 00 00       	jmp    80396e <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  803858:	8b 45 08             	mov    0x8(%ebp),%eax
  80385b:	8b 50 08             	mov    0x8(%eax),%edx
  80385e:	a1 44 60 80 00       	mov    0x806044,%eax
  803863:	8b 40 08             	mov    0x8(%eax),%eax
  803866:	39 c2                	cmp    %eax,%edx
  803868:	76 68                	jbe    8038d2 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80386a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80386e:	75 17                	jne    803887 <insert_sorted_allocList+0xc5>
  803870:	83 ec 04             	sub    $0x4,%esp
  803873:	68 4c 53 80 00       	push   $0x80534c
  803878:	68 85 00 00 00       	push   $0x85
  80387d:	68 33 53 80 00       	push   $0x805333
  803882:	e8 b2 e0 ff ff       	call   801939 <_panic>
  803887:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	89 50 04             	mov    %edx,0x4(%eax)
  803893:	8b 45 08             	mov    0x8(%ebp),%eax
  803896:	8b 40 04             	mov    0x4(%eax),%eax
  803899:	85 c0                	test   %eax,%eax
  80389b:	74 0c                	je     8038a9 <insert_sorted_allocList+0xe7>
  80389d:	a1 44 60 80 00       	mov    0x806044,%eax
  8038a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8038a5:	89 10                	mov    %edx,(%eax)
  8038a7:	eb 08                	jmp    8038b1 <insert_sorted_allocList+0xef>
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	a3 40 60 80 00       	mov    %eax,0x806040
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	a3 44 60 80 00       	mov    %eax,0x806044
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c2:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8038c7:	40                   	inc    %eax
  8038c8:	a3 4c 60 80 00       	mov    %eax,0x80604c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8038cd:	e9 9c 00 00 00       	jmp    80396e <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8038d2:	a1 40 60 80 00       	mov    0x806040,%eax
  8038d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8038da:	e9 85 00 00 00       	jmp    803964 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8038df:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e2:	8b 50 08             	mov    0x8(%eax),%edx
  8038e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e8:	8b 40 08             	mov    0x8(%eax),%eax
  8038eb:	39 c2                	cmp    %eax,%edx
  8038ed:	73 6d                	jae    80395c <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8038ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f3:	74 06                	je     8038fb <insert_sorted_allocList+0x139>
  8038f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038f9:	75 17                	jne    803912 <insert_sorted_allocList+0x150>
  8038fb:	83 ec 04             	sub    $0x4,%esp
  8038fe:	68 70 53 80 00       	push   $0x805370
  803903:	68 90 00 00 00       	push   $0x90
  803908:	68 33 53 80 00       	push   $0x805333
  80390d:	e8 27 e0 ff ff       	call   801939 <_panic>
  803912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803915:	8b 50 04             	mov    0x4(%eax),%edx
  803918:	8b 45 08             	mov    0x8(%ebp),%eax
  80391b:	89 50 04             	mov    %edx,0x4(%eax)
  80391e:	8b 45 08             	mov    0x8(%ebp),%eax
  803921:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803924:	89 10                	mov    %edx,(%eax)
  803926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803929:	8b 40 04             	mov    0x4(%eax),%eax
  80392c:	85 c0                	test   %eax,%eax
  80392e:	74 0d                	je     80393d <insert_sorted_allocList+0x17b>
  803930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803933:	8b 40 04             	mov    0x4(%eax),%eax
  803936:	8b 55 08             	mov    0x8(%ebp),%edx
  803939:	89 10                	mov    %edx,(%eax)
  80393b:	eb 08                	jmp    803945 <insert_sorted_allocList+0x183>
  80393d:	8b 45 08             	mov    0x8(%ebp),%eax
  803940:	a3 40 60 80 00       	mov    %eax,0x806040
  803945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803948:	8b 55 08             	mov    0x8(%ebp),%edx
  80394b:	89 50 04             	mov    %edx,0x4(%eax)
  80394e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803953:	40                   	inc    %eax
  803954:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803959:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80395a:	eb 12                	jmp    80396e <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80395c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  803964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803968:	0f 85 71 ff ff ff    	jne    8038df <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80396e:	90                   	nop
  80396f:	c9                   	leave  
  803970:	c3                   	ret    

00803971 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  803971:	55                   	push   %ebp
  803972:	89 e5                	mov    %esp,%ebp
  803974:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  803977:	a1 38 61 80 00       	mov    0x806138,%eax
  80397c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80397f:	e9 76 01 00 00       	jmp    803afa <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  803984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803987:	8b 40 0c             	mov    0xc(%eax),%eax
  80398a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80398d:	0f 85 8a 00 00 00    	jne    803a1d <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  803993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803997:	75 17                	jne    8039b0 <alloc_block_FF+0x3f>
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 a5 53 80 00       	push   $0x8053a5
  8039a1:	68 a8 00 00 00       	push   $0xa8
  8039a6:	68 33 53 80 00       	push   $0x805333
  8039ab:	e8 89 df ff ff       	call   801939 <_panic>
  8039b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b3:	8b 00                	mov    (%eax),%eax
  8039b5:	85 c0                	test   %eax,%eax
  8039b7:	74 10                	je     8039c9 <alloc_block_FF+0x58>
  8039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bc:	8b 00                	mov    (%eax),%eax
  8039be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039c1:	8b 52 04             	mov    0x4(%edx),%edx
  8039c4:	89 50 04             	mov    %edx,0x4(%eax)
  8039c7:	eb 0b                	jmp    8039d4 <alloc_block_FF+0x63>
  8039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cc:	8b 40 04             	mov    0x4(%eax),%eax
  8039cf:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d7:	8b 40 04             	mov    0x4(%eax),%eax
  8039da:	85 c0                	test   %eax,%eax
  8039dc:	74 0f                	je     8039ed <alloc_block_FF+0x7c>
  8039de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e1:	8b 40 04             	mov    0x4(%eax),%eax
  8039e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039e7:	8b 12                	mov    (%edx),%edx
  8039e9:	89 10                	mov    %edx,(%eax)
  8039eb:	eb 0a                	jmp    8039f7 <alloc_block_FF+0x86>
  8039ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f0:	8b 00                	mov    (%eax),%eax
  8039f2:	a3 38 61 80 00       	mov    %eax,0x806138
  8039f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a0a:	a1 44 61 80 00       	mov    0x806144,%eax
  803a0f:	48                   	dec    %eax
  803a10:	a3 44 61 80 00       	mov    %eax,0x806144

			return tmp;
  803a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a18:	e9 ea 00 00 00       	jmp    803b07 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  803a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a20:	8b 40 0c             	mov    0xc(%eax),%eax
  803a23:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a26:	0f 86 c6 00 00 00    	jbe    803af2 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803a2c:	a1 48 61 80 00       	mov    0x806148,%eax
  803a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  803a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a37:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3a:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  803a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a40:	8b 50 08             	mov    0x8(%eax),%edx
  803a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a46:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  803a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a4f:	2b 45 08             	sub    0x8(%ebp),%eax
  803a52:	89 c2                	mov    %eax,%edx
  803a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a57:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  803a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5d:	8b 50 08             	mov    0x8(%eax),%edx
  803a60:	8b 45 08             	mov    0x8(%ebp),%eax
  803a63:	01 c2                	add    %eax,%edx
  803a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a68:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803a6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a6f:	75 17                	jne    803a88 <alloc_block_FF+0x117>
  803a71:	83 ec 04             	sub    $0x4,%esp
  803a74:	68 a5 53 80 00       	push   $0x8053a5
  803a79:	68 b6 00 00 00       	push   $0xb6
  803a7e:	68 33 53 80 00       	push   $0x805333
  803a83:	e8 b1 de ff ff       	call   801939 <_panic>
  803a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8b:	8b 00                	mov    (%eax),%eax
  803a8d:	85 c0                	test   %eax,%eax
  803a8f:	74 10                	je     803aa1 <alloc_block_FF+0x130>
  803a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a94:	8b 00                	mov    (%eax),%eax
  803a96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a99:	8b 52 04             	mov    0x4(%edx),%edx
  803a9c:	89 50 04             	mov    %edx,0x4(%eax)
  803a9f:	eb 0b                	jmp    803aac <alloc_block_FF+0x13b>
  803aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa4:	8b 40 04             	mov    0x4(%eax),%eax
  803aa7:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aaf:	8b 40 04             	mov    0x4(%eax),%eax
  803ab2:	85 c0                	test   %eax,%eax
  803ab4:	74 0f                	je     803ac5 <alloc_block_FF+0x154>
  803ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab9:	8b 40 04             	mov    0x4(%eax),%eax
  803abc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803abf:	8b 12                	mov    (%edx),%edx
  803ac1:	89 10                	mov    %edx,(%eax)
  803ac3:	eb 0a                	jmp    803acf <alloc_block_FF+0x15e>
  803ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac8:	8b 00                	mov    (%eax),%eax
  803aca:	a3 48 61 80 00       	mov    %eax,0x806148
  803acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803adb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ae2:	a1 54 61 80 00       	mov    0x806154,%eax
  803ae7:	48                   	dec    %eax
  803ae8:	a3 54 61 80 00       	mov    %eax,0x806154
			 return newBlock;
  803aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af0:	eb 15                	jmp    803b07 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  803af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af5:	8b 00                	mov    (%eax),%eax
  803af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  803afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803afe:	0f 85 80 fe ff ff    	jne    803984 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  803b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803b07:	c9                   	leave  
  803b08:	c3                   	ret    

00803b09 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803b09:	55                   	push   %ebp
  803b0a:	89 e5                	mov    %esp,%ebp
  803b0c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  803b0f:	a1 38 61 80 00       	mov    0x806138,%eax
  803b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  803b17:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  803b1e:	e9 c0 00 00 00       	jmp    803be3 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  803b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b26:	8b 40 0c             	mov    0xc(%eax),%eax
  803b29:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b2c:	0f 85 8a 00 00 00    	jne    803bbc <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803b32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b36:	75 17                	jne    803b4f <alloc_block_BF+0x46>
  803b38:	83 ec 04             	sub    $0x4,%esp
  803b3b:	68 a5 53 80 00       	push   $0x8053a5
  803b40:	68 cf 00 00 00       	push   $0xcf
  803b45:	68 33 53 80 00       	push   $0x805333
  803b4a:	e8 ea dd ff ff       	call   801939 <_panic>
  803b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b52:	8b 00                	mov    (%eax),%eax
  803b54:	85 c0                	test   %eax,%eax
  803b56:	74 10                	je     803b68 <alloc_block_BF+0x5f>
  803b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5b:	8b 00                	mov    (%eax),%eax
  803b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b60:	8b 52 04             	mov    0x4(%edx),%edx
  803b63:	89 50 04             	mov    %edx,0x4(%eax)
  803b66:	eb 0b                	jmp    803b73 <alloc_block_BF+0x6a>
  803b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6b:	8b 40 04             	mov    0x4(%eax),%eax
  803b6e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b76:	8b 40 04             	mov    0x4(%eax),%eax
  803b79:	85 c0                	test   %eax,%eax
  803b7b:	74 0f                	je     803b8c <alloc_block_BF+0x83>
  803b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b80:	8b 40 04             	mov    0x4(%eax),%eax
  803b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b86:	8b 12                	mov    (%edx),%edx
  803b88:	89 10                	mov    %edx,(%eax)
  803b8a:	eb 0a                	jmp    803b96 <alloc_block_BF+0x8d>
  803b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8f:	8b 00                	mov    (%eax),%eax
  803b91:	a3 38 61 80 00       	mov    %eax,0x806138
  803b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ba9:	a1 44 61 80 00       	mov    0x806144,%eax
  803bae:	48                   	dec    %eax
  803baf:	a3 44 61 80 00       	mov    %eax,0x806144
				return tmp;
  803bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb7:	e9 2a 01 00 00       	jmp    803ce6 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  803bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbf:	8b 40 0c             	mov    0xc(%eax),%eax
  803bc2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803bc5:	73 14                	jae    803bdb <alloc_block_BF+0xd2>
  803bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bca:	8b 40 0c             	mov    0xc(%eax),%eax
  803bcd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bd0:	76 09                	jbe    803bdb <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  803bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  803bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  803bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bde:	8b 00                	mov    (%eax),%eax
  803be0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  803be3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803be7:	0f 85 36 ff ff ff    	jne    803b23 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  803bed:	a1 38 61 80 00       	mov    0x806138,%eax
  803bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  803bf5:	e9 dd 00 00 00       	jmp    803cd7 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  803c00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803c03:	0f 85 c6 00 00 00    	jne    803ccf <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803c09:	a1 48 61 80 00       	mov    0x806148,%eax
  803c0e:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  803c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c14:	8b 50 08             	mov    0x8(%eax),%edx
  803c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c1a:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  803c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c20:	8b 55 08             	mov    0x8(%ebp),%edx
  803c23:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  803c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c29:	8b 50 08             	mov    0x8(%eax),%edx
  803c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2f:	01 c2                	add    %eax,%edx
  803c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c34:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  803c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  803c3d:	2b 45 08             	sub    0x8(%ebp),%eax
  803c40:	89 c2                	mov    %eax,%edx
  803c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c45:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c4c:	75 17                	jne    803c65 <alloc_block_BF+0x15c>
  803c4e:	83 ec 04             	sub    $0x4,%esp
  803c51:	68 a5 53 80 00       	push   $0x8053a5
  803c56:	68 eb 00 00 00       	push   $0xeb
  803c5b:	68 33 53 80 00       	push   $0x805333
  803c60:	e8 d4 dc ff ff       	call   801939 <_panic>
  803c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c68:	8b 00                	mov    (%eax),%eax
  803c6a:	85 c0                	test   %eax,%eax
  803c6c:	74 10                	je     803c7e <alloc_block_BF+0x175>
  803c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c71:	8b 00                	mov    (%eax),%eax
  803c73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c76:	8b 52 04             	mov    0x4(%edx),%edx
  803c79:	89 50 04             	mov    %edx,0x4(%eax)
  803c7c:	eb 0b                	jmp    803c89 <alloc_block_BF+0x180>
  803c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c81:	8b 40 04             	mov    0x4(%eax),%eax
  803c84:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c8c:	8b 40 04             	mov    0x4(%eax),%eax
  803c8f:	85 c0                	test   %eax,%eax
  803c91:	74 0f                	je     803ca2 <alloc_block_BF+0x199>
  803c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c96:	8b 40 04             	mov    0x4(%eax),%eax
  803c99:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c9c:	8b 12                	mov    (%edx),%edx
  803c9e:	89 10                	mov    %edx,(%eax)
  803ca0:	eb 0a                	jmp    803cac <alloc_block_BF+0x1a3>
  803ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ca5:	8b 00                	mov    (%eax),%eax
  803ca7:	a3 48 61 80 00       	mov    %eax,0x806148
  803cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cbf:	a1 54 61 80 00       	mov    0x806154,%eax
  803cc4:	48                   	dec    %eax
  803cc5:	a3 54 61 80 00       	mov    %eax,0x806154
											 return newBlock;
  803cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ccd:	eb 17                	jmp    803ce6 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  803ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd2:	8b 00                	mov    (%eax),%eax
  803cd4:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  803cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cdb:	0f 85 19 ff ff ff    	jne    803bfa <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  803ce1:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803ce6:	c9                   	leave  
  803ce7:	c3                   	ret    

00803ce8 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  803ce8:	55                   	push   %ebp
  803ce9:	89 e5                	mov    %esp,%ebp
  803ceb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  803cee:	a1 40 60 80 00       	mov    0x806040,%eax
  803cf3:	85 c0                	test   %eax,%eax
  803cf5:	75 19                	jne    803d10 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  803cf7:	83 ec 0c             	sub    $0xc,%esp
  803cfa:	ff 75 08             	pushl  0x8(%ebp)
  803cfd:	e8 6f fc ff ff       	call   803971 <alloc_block_FF>
  803d02:	83 c4 10             	add    $0x10,%esp
  803d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  803d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0b:	e9 e9 01 00 00       	jmp    803ef9 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  803d10:	a1 44 60 80 00       	mov    0x806044,%eax
  803d15:	8b 40 08             	mov    0x8(%eax),%eax
  803d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  803d1b:	a1 44 60 80 00       	mov    0x806044,%eax
  803d20:	8b 50 0c             	mov    0xc(%eax),%edx
  803d23:	a1 44 60 80 00       	mov    0x806044,%eax
  803d28:	8b 40 08             	mov    0x8(%eax),%eax
  803d2b:	01 d0                	add    %edx,%eax
  803d2d:	83 ec 08             	sub    $0x8,%esp
  803d30:	50                   	push   %eax
  803d31:	68 38 61 80 00       	push   $0x806138
  803d36:	e8 54 fa ff ff       	call   80378f <find_block>
  803d3b:	83 c4 10             	add    $0x10,%esp
  803d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  803d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d44:	8b 40 0c             	mov    0xc(%eax),%eax
  803d47:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d4a:	0f 85 9b 00 00 00    	jne    803deb <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  803d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d53:	8b 50 0c             	mov    0xc(%eax),%edx
  803d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d59:	8b 40 08             	mov    0x8(%eax),%eax
  803d5c:	01 d0                	add    %edx,%eax
  803d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  803d61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d65:	75 17                	jne    803d7e <alloc_block_NF+0x96>
  803d67:	83 ec 04             	sub    $0x4,%esp
  803d6a:	68 a5 53 80 00       	push   $0x8053a5
  803d6f:	68 1a 01 00 00       	push   $0x11a
  803d74:	68 33 53 80 00       	push   $0x805333
  803d79:	e8 bb db ff ff       	call   801939 <_panic>
  803d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d81:	8b 00                	mov    (%eax),%eax
  803d83:	85 c0                	test   %eax,%eax
  803d85:	74 10                	je     803d97 <alloc_block_NF+0xaf>
  803d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8a:	8b 00                	mov    (%eax),%eax
  803d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d8f:	8b 52 04             	mov    0x4(%edx),%edx
  803d92:	89 50 04             	mov    %edx,0x4(%eax)
  803d95:	eb 0b                	jmp    803da2 <alloc_block_NF+0xba>
  803d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9a:	8b 40 04             	mov    0x4(%eax),%eax
  803d9d:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da5:	8b 40 04             	mov    0x4(%eax),%eax
  803da8:	85 c0                	test   %eax,%eax
  803daa:	74 0f                	je     803dbb <alloc_block_NF+0xd3>
  803dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803daf:	8b 40 04             	mov    0x4(%eax),%eax
  803db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db5:	8b 12                	mov    (%edx),%edx
  803db7:	89 10                	mov    %edx,(%eax)
  803db9:	eb 0a                	jmp    803dc5 <alloc_block_NF+0xdd>
  803dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbe:	8b 00                	mov    (%eax),%eax
  803dc0:	a3 38 61 80 00       	mov    %eax,0x806138
  803dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd8:	a1 44 61 80 00       	mov    0x806144,%eax
  803ddd:	48                   	dec    %eax
  803dde:	a3 44 61 80 00       	mov    %eax,0x806144
					return tmp1;
  803de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de6:	e9 0e 01 00 00       	jmp    803ef9 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  803deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dee:	8b 40 0c             	mov    0xc(%eax),%eax
  803df1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803df4:	0f 86 cf 00 00 00    	jbe    803ec9 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  803dfa:	a1 48 61 80 00       	mov    0x806148,%eax
  803dff:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  803e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e05:	8b 55 08             	mov    0x8(%ebp),%edx
  803e08:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  803e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0e:	8b 50 08             	mov    0x8(%eax),%edx
  803e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e14:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1a:	8b 50 08             	mov    0x8(%eax),%edx
  803e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e20:	01 c2                	add    %eax,%edx
  803e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e25:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  803e2e:	2b 45 08             	sub    0x8(%ebp),%eax
  803e31:	89 c2                	mov    %eax,%edx
  803e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e36:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  803e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3c:	8b 40 08             	mov    0x8(%eax),%eax
  803e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803e42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e46:	75 17                	jne    803e5f <alloc_block_NF+0x177>
  803e48:	83 ec 04             	sub    $0x4,%esp
  803e4b:	68 a5 53 80 00       	push   $0x8053a5
  803e50:	68 28 01 00 00       	push   $0x128
  803e55:	68 33 53 80 00       	push   $0x805333
  803e5a:	e8 da da ff ff       	call   801939 <_panic>
  803e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e62:	8b 00                	mov    (%eax),%eax
  803e64:	85 c0                	test   %eax,%eax
  803e66:	74 10                	je     803e78 <alloc_block_NF+0x190>
  803e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e6b:	8b 00                	mov    (%eax),%eax
  803e6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e70:	8b 52 04             	mov    0x4(%edx),%edx
  803e73:	89 50 04             	mov    %edx,0x4(%eax)
  803e76:	eb 0b                	jmp    803e83 <alloc_block_NF+0x19b>
  803e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e7b:	8b 40 04             	mov    0x4(%eax),%eax
  803e7e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e86:	8b 40 04             	mov    0x4(%eax),%eax
  803e89:	85 c0                	test   %eax,%eax
  803e8b:	74 0f                	je     803e9c <alloc_block_NF+0x1b4>
  803e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e90:	8b 40 04             	mov    0x4(%eax),%eax
  803e93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e96:	8b 12                	mov    (%edx),%edx
  803e98:	89 10                	mov    %edx,(%eax)
  803e9a:	eb 0a                	jmp    803ea6 <alloc_block_NF+0x1be>
  803e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e9f:	8b 00                	mov    (%eax),%eax
  803ea1:	a3 48 61 80 00       	mov    %eax,0x806148
  803ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ea9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb9:	a1 54 61 80 00       	mov    0x806154,%eax
  803ebe:	48                   	dec    %eax
  803ebf:	a3 54 61 80 00       	mov    %eax,0x806154
					 return newBlock;
  803ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ec7:	eb 30                	jmp    803ef9 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  803ec9:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803ece:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803ed1:	75 0a                	jne    803edd <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  803ed3:	a1 38 61 80 00       	mov    0x806138,%eax
  803ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803edb:	eb 08                	jmp    803ee5 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  803edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee0:	8b 00                	mov    (%eax),%eax
  803ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  803ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee8:	8b 40 08             	mov    0x8(%eax),%eax
  803eeb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803eee:	0f 85 4d fe ff ff    	jne    803d41 <alloc_block_NF+0x59>

			return NULL;
  803ef4:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  803ef9:	c9                   	leave  
  803efa:	c3                   	ret    

00803efb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803efb:	55                   	push   %ebp
  803efc:	89 e5                	mov    %esp,%ebp
  803efe:	53                   	push   %ebx
  803eff:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  803f02:	a1 38 61 80 00       	mov    0x806138,%eax
  803f07:	85 c0                	test   %eax,%eax
  803f09:	0f 85 86 00 00 00    	jne    803f95 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  803f0f:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  803f16:	00 00 00 
  803f19:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  803f20:	00 00 00 
  803f23:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  803f2a:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803f2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f31:	75 17                	jne    803f4a <insert_sorted_with_merge_freeList+0x4f>
  803f33:	83 ec 04             	sub    $0x4,%esp
  803f36:	68 10 53 80 00       	push   $0x805310
  803f3b:	68 48 01 00 00       	push   $0x148
  803f40:	68 33 53 80 00       	push   $0x805333
  803f45:	e8 ef d9 ff ff       	call   801939 <_panic>
  803f4a:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803f50:	8b 45 08             	mov    0x8(%ebp),%eax
  803f53:	89 10                	mov    %edx,(%eax)
  803f55:	8b 45 08             	mov    0x8(%ebp),%eax
  803f58:	8b 00                	mov    (%eax),%eax
  803f5a:	85 c0                	test   %eax,%eax
  803f5c:	74 0d                	je     803f6b <insert_sorted_with_merge_freeList+0x70>
  803f5e:	a1 38 61 80 00       	mov    0x806138,%eax
  803f63:	8b 55 08             	mov    0x8(%ebp),%edx
  803f66:	89 50 04             	mov    %edx,0x4(%eax)
  803f69:	eb 08                	jmp    803f73 <insert_sorted_with_merge_freeList+0x78>
  803f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f73:	8b 45 08             	mov    0x8(%ebp),%eax
  803f76:	a3 38 61 80 00       	mov    %eax,0x806138
  803f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f85:	a1 44 61 80 00       	mov    0x806144,%eax
  803f8a:	40                   	inc    %eax
  803f8b:	a3 44 61 80 00       	mov    %eax,0x806144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803f90:	e9 73 07 00 00       	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803f95:	8b 45 08             	mov    0x8(%ebp),%eax
  803f98:	8b 50 08             	mov    0x8(%eax),%edx
  803f9b:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803fa0:	8b 40 08             	mov    0x8(%eax),%eax
  803fa3:	39 c2                	cmp    %eax,%edx
  803fa5:	0f 86 84 00 00 00    	jbe    80402f <insert_sorted_with_merge_freeList+0x134>
  803fab:	8b 45 08             	mov    0x8(%ebp),%eax
  803fae:	8b 50 08             	mov    0x8(%eax),%edx
  803fb1:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803fb6:	8b 48 0c             	mov    0xc(%eax),%ecx
  803fb9:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803fbe:	8b 40 08             	mov    0x8(%eax),%eax
  803fc1:	01 c8                	add    %ecx,%eax
  803fc3:	39 c2                	cmp    %eax,%edx
  803fc5:	74 68                	je     80402f <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803fc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fcb:	75 17                	jne    803fe4 <insert_sorted_with_merge_freeList+0xe9>
  803fcd:	83 ec 04             	sub    $0x4,%esp
  803fd0:	68 4c 53 80 00       	push   $0x80534c
  803fd5:	68 4c 01 00 00       	push   $0x14c
  803fda:	68 33 53 80 00       	push   $0x805333
  803fdf:	e8 55 d9 ff ff       	call   801939 <_panic>
  803fe4:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803fea:	8b 45 08             	mov    0x8(%ebp),%eax
  803fed:	89 50 04             	mov    %edx,0x4(%eax)
  803ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff3:	8b 40 04             	mov    0x4(%eax),%eax
  803ff6:	85 c0                	test   %eax,%eax
  803ff8:	74 0c                	je     804006 <insert_sorted_with_merge_freeList+0x10b>
  803ffa:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803fff:	8b 55 08             	mov    0x8(%ebp),%edx
  804002:	89 10                	mov    %edx,(%eax)
  804004:	eb 08                	jmp    80400e <insert_sorted_with_merge_freeList+0x113>
  804006:	8b 45 08             	mov    0x8(%ebp),%eax
  804009:	a3 38 61 80 00       	mov    %eax,0x806138
  80400e:	8b 45 08             	mov    0x8(%ebp),%eax
  804011:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804016:	8b 45 08             	mov    0x8(%ebp),%eax
  804019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80401f:	a1 44 61 80 00       	mov    0x806144,%eax
  804024:	40                   	inc    %eax
  804025:	a3 44 61 80 00       	mov    %eax,0x806144
  80402a:	e9 d9 06 00 00       	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  80402f:	8b 45 08             	mov    0x8(%ebp),%eax
  804032:	8b 50 08             	mov    0x8(%eax),%edx
  804035:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80403a:	8b 40 08             	mov    0x8(%eax),%eax
  80403d:	39 c2                	cmp    %eax,%edx
  80403f:	0f 86 b5 00 00 00    	jbe    8040fa <insert_sorted_with_merge_freeList+0x1ff>
  804045:	8b 45 08             	mov    0x8(%ebp),%eax
  804048:	8b 50 08             	mov    0x8(%eax),%edx
  80404b:	a1 3c 61 80 00       	mov    0x80613c,%eax
  804050:	8b 48 0c             	mov    0xc(%eax),%ecx
  804053:	a1 3c 61 80 00       	mov    0x80613c,%eax
  804058:	8b 40 08             	mov    0x8(%eax),%eax
  80405b:	01 c8                	add    %ecx,%eax
  80405d:	39 c2                	cmp    %eax,%edx
  80405f:	0f 85 95 00 00 00    	jne    8040fa <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  804065:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80406a:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  804070:	8b 4a 0c             	mov    0xc(%edx),%ecx
  804073:	8b 55 08             	mov    0x8(%ebp),%edx
  804076:	8b 52 0c             	mov    0xc(%edx),%edx
  804079:	01 ca                	add    %ecx,%edx
  80407b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80407e:	8b 45 08             	mov    0x8(%ebp),%eax
  804081:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  804088:	8b 45 08             	mov    0x8(%ebp),%eax
  80408b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  804092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804096:	75 17                	jne    8040af <insert_sorted_with_merge_freeList+0x1b4>
  804098:	83 ec 04             	sub    $0x4,%esp
  80409b:	68 10 53 80 00       	push   $0x805310
  8040a0:	68 54 01 00 00       	push   $0x154
  8040a5:	68 33 53 80 00       	push   $0x805333
  8040aa:	e8 8a d8 ff ff       	call   801939 <_panic>
  8040af:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8040b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b8:	89 10                	mov    %edx,(%eax)
  8040ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bd:	8b 00                	mov    (%eax),%eax
  8040bf:	85 c0                	test   %eax,%eax
  8040c1:	74 0d                	je     8040d0 <insert_sorted_with_merge_freeList+0x1d5>
  8040c3:	a1 48 61 80 00       	mov    0x806148,%eax
  8040c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8040cb:	89 50 04             	mov    %edx,0x4(%eax)
  8040ce:	eb 08                	jmp    8040d8 <insert_sorted_with_merge_freeList+0x1dd>
  8040d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8040db:	a3 48 61 80 00       	mov    %eax,0x806148
  8040e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040ea:	a1 54 61 80 00       	mov    0x806154,%eax
  8040ef:	40                   	inc    %eax
  8040f0:	a3 54 61 80 00       	mov    %eax,0x806154
  8040f5:	e9 0e 06 00 00       	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  8040fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8040fd:	8b 50 08             	mov    0x8(%eax),%edx
  804100:	a1 38 61 80 00       	mov    0x806138,%eax
  804105:	8b 40 08             	mov    0x8(%eax),%eax
  804108:	39 c2                	cmp    %eax,%edx
  80410a:	0f 83 c1 00 00 00    	jae    8041d1 <insert_sorted_with_merge_freeList+0x2d6>
  804110:	a1 38 61 80 00       	mov    0x806138,%eax
  804115:	8b 50 08             	mov    0x8(%eax),%edx
  804118:	8b 45 08             	mov    0x8(%ebp),%eax
  80411b:	8b 48 08             	mov    0x8(%eax),%ecx
  80411e:	8b 45 08             	mov    0x8(%ebp),%eax
  804121:	8b 40 0c             	mov    0xc(%eax),%eax
  804124:	01 c8                	add    %ecx,%eax
  804126:	39 c2                	cmp    %eax,%edx
  804128:	0f 85 a3 00 00 00    	jne    8041d1 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80412e:	a1 38 61 80 00       	mov    0x806138,%eax
  804133:	8b 55 08             	mov    0x8(%ebp),%edx
  804136:	8b 52 08             	mov    0x8(%edx),%edx
  804139:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  80413c:	a1 38 61 80 00       	mov    0x806138,%eax
  804141:	8b 15 38 61 80 00    	mov    0x806138,%edx
  804147:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80414a:	8b 55 08             	mov    0x8(%ebp),%edx
  80414d:	8b 52 0c             	mov    0xc(%edx),%edx
  804150:	01 ca                	add    %ecx,%edx
  804152:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  804155:	8b 45 08             	mov    0x8(%ebp),%eax
  804158:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  80415f:	8b 45 08             	mov    0x8(%ebp),%eax
  804162:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  804169:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80416d:	75 17                	jne    804186 <insert_sorted_with_merge_freeList+0x28b>
  80416f:	83 ec 04             	sub    $0x4,%esp
  804172:	68 10 53 80 00       	push   $0x805310
  804177:	68 5d 01 00 00       	push   $0x15d
  80417c:	68 33 53 80 00       	push   $0x805333
  804181:	e8 b3 d7 ff ff       	call   801939 <_panic>
  804186:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80418c:	8b 45 08             	mov    0x8(%ebp),%eax
  80418f:	89 10                	mov    %edx,(%eax)
  804191:	8b 45 08             	mov    0x8(%ebp),%eax
  804194:	8b 00                	mov    (%eax),%eax
  804196:	85 c0                	test   %eax,%eax
  804198:	74 0d                	je     8041a7 <insert_sorted_with_merge_freeList+0x2ac>
  80419a:	a1 48 61 80 00       	mov    0x806148,%eax
  80419f:	8b 55 08             	mov    0x8(%ebp),%edx
  8041a2:	89 50 04             	mov    %edx,0x4(%eax)
  8041a5:	eb 08                	jmp    8041af <insert_sorted_with_merge_freeList+0x2b4>
  8041a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041aa:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8041af:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b2:	a3 48 61 80 00       	mov    %eax,0x806148
  8041b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041c1:	a1 54 61 80 00       	mov    0x806154,%eax
  8041c6:	40                   	inc    %eax
  8041c7:	a3 54 61 80 00       	mov    %eax,0x806154
  8041cc:	e9 37 05 00 00       	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  8041d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d4:	8b 50 08             	mov    0x8(%eax),%edx
  8041d7:	a1 38 61 80 00       	mov    0x806138,%eax
  8041dc:	8b 40 08             	mov    0x8(%eax),%eax
  8041df:	39 c2                	cmp    %eax,%edx
  8041e1:	0f 83 82 00 00 00    	jae    804269 <insert_sorted_with_merge_freeList+0x36e>
  8041e7:	a1 38 61 80 00       	mov    0x806138,%eax
  8041ec:	8b 50 08             	mov    0x8(%eax),%edx
  8041ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f2:	8b 48 08             	mov    0x8(%eax),%ecx
  8041f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8041fb:	01 c8                	add    %ecx,%eax
  8041fd:	39 c2                	cmp    %eax,%edx
  8041ff:	74 68                	je     804269 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  804201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804205:	75 17                	jne    80421e <insert_sorted_with_merge_freeList+0x323>
  804207:	83 ec 04             	sub    $0x4,%esp
  80420a:	68 10 53 80 00       	push   $0x805310
  80420f:	68 62 01 00 00       	push   $0x162
  804214:	68 33 53 80 00       	push   $0x805333
  804219:	e8 1b d7 ff ff       	call   801939 <_panic>
  80421e:	8b 15 38 61 80 00    	mov    0x806138,%edx
  804224:	8b 45 08             	mov    0x8(%ebp),%eax
  804227:	89 10                	mov    %edx,(%eax)
  804229:	8b 45 08             	mov    0x8(%ebp),%eax
  80422c:	8b 00                	mov    (%eax),%eax
  80422e:	85 c0                	test   %eax,%eax
  804230:	74 0d                	je     80423f <insert_sorted_with_merge_freeList+0x344>
  804232:	a1 38 61 80 00       	mov    0x806138,%eax
  804237:	8b 55 08             	mov    0x8(%ebp),%edx
  80423a:	89 50 04             	mov    %edx,0x4(%eax)
  80423d:	eb 08                	jmp    804247 <insert_sorted_with_merge_freeList+0x34c>
  80423f:	8b 45 08             	mov    0x8(%ebp),%eax
  804242:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804247:	8b 45 08             	mov    0x8(%ebp),%eax
  80424a:	a3 38 61 80 00       	mov    %eax,0x806138
  80424f:	8b 45 08             	mov    0x8(%ebp),%eax
  804252:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804259:	a1 44 61 80 00       	mov    0x806144,%eax
  80425e:	40                   	inc    %eax
  80425f:	a3 44 61 80 00       	mov    %eax,0x806144
  804264:	e9 9f 04 00 00       	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  804269:	a1 38 61 80 00       	mov    0x806138,%eax
  80426e:	8b 00                	mov    (%eax),%eax
  804270:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  804273:	e9 84 04 00 00       	jmp    8046fc <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  804278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80427b:	8b 50 08             	mov    0x8(%eax),%edx
  80427e:	8b 45 08             	mov    0x8(%ebp),%eax
  804281:	8b 40 08             	mov    0x8(%eax),%eax
  804284:	39 c2                	cmp    %eax,%edx
  804286:	0f 86 a9 00 00 00    	jbe    804335 <insert_sorted_with_merge_freeList+0x43a>
  80428c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80428f:	8b 50 08             	mov    0x8(%eax),%edx
  804292:	8b 45 08             	mov    0x8(%ebp),%eax
  804295:	8b 48 08             	mov    0x8(%eax),%ecx
  804298:	8b 45 08             	mov    0x8(%ebp),%eax
  80429b:	8b 40 0c             	mov    0xc(%eax),%eax
  80429e:	01 c8                	add    %ecx,%eax
  8042a0:	39 c2                	cmp    %eax,%edx
  8042a2:	0f 84 8d 00 00 00    	je     804335 <insert_sorted_with_merge_freeList+0x43a>
  8042a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ab:	8b 50 08             	mov    0x8(%eax),%edx
  8042ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b1:	8b 40 04             	mov    0x4(%eax),%eax
  8042b4:	8b 48 08             	mov    0x8(%eax),%ecx
  8042b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ba:	8b 40 04             	mov    0x4(%eax),%eax
  8042bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8042c0:	01 c8                	add    %ecx,%eax
  8042c2:	39 c2                	cmp    %eax,%edx
  8042c4:	74 6f                	je     804335 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  8042c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042ca:	74 06                	je     8042d2 <insert_sorted_with_merge_freeList+0x3d7>
  8042cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042d0:	75 17                	jne    8042e9 <insert_sorted_with_merge_freeList+0x3ee>
  8042d2:	83 ec 04             	sub    $0x4,%esp
  8042d5:	68 70 53 80 00       	push   $0x805370
  8042da:	68 6b 01 00 00       	push   $0x16b
  8042df:	68 33 53 80 00       	push   $0x805333
  8042e4:	e8 50 d6 ff ff       	call   801939 <_panic>
  8042e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ec:	8b 50 04             	mov    0x4(%eax),%edx
  8042ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f2:	89 50 04             	mov    %edx,0x4(%eax)
  8042f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042fb:	89 10                	mov    %edx,(%eax)
  8042fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804300:	8b 40 04             	mov    0x4(%eax),%eax
  804303:	85 c0                	test   %eax,%eax
  804305:	74 0d                	je     804314 <insert_sorted_with_merge_freeList+0x419>
  804307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80430a:	8b 40 04             	mov    0x4(%eax),%eax
  80430d:	8b 55 08             	mov    0x8(%ebp),%edx
  804310:	89 10                	mov    %edx,(%eax)
  804312:	eb 08                	jmp    80431c <insert_sorted_with_merge_freeList+0x421>
  804314:	8b 45 08             	mov    0x8(%ebp),%eax
  804317:	a3 38 61 80 00       	mov    %eax,0x806138
  80431c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80431f:	8b 55 08             	mov    0x8(%ebp),%edx
  804322:	89 50 04             	mov    %edx,0x4(%eax)
  804325:	a1 44 61 80 00       	mov    0x806144,%eax
  80432a:	40                   	inc    %eax
  80432b:	a3 44 61 80 00       	mov    %eax,0x806144
				break;
  804330:	e9 d3 03 00 00       	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  804335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804338:	8b 50 08             	mov    0x8(%eax),%edx
  80433b:	8b 45 08             	mov    0x8(%ebp),%eax
  80433e:	8b 40 08             	mov    0x8(%eax),%eax
  804341:	39 c2                	cmp    %eax,%edx
  804343:	0f 86 da 00 00 00    	jbe    804423 <insert_sorted_with_merge_freeList+0x528>
  804349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80434c:	8b 50 08             	mov    0x8(%eax),%edx
  80434f:	8b 45 08             	mov    0x8(%ebp),%eax
  804352:	8b 48 08             	mov    0x8(%eax),%ecx
  804355:	8b 45 08             	mov    0x8(%ebp),%eax
  804358:	8b 40 0c             	mov    0xc(%eax),%eax
  80435b:	01 c8                	add    %ecx,%eax
  80435d:	39 c2                	cmp    %eax,%edx
  80435f:	0f 85 be 00 00 00    	jne    804423 <insert_sorted_with_merge_freeList+0x528>
  804365:	8b 45 08             	mov    0x8(%ebp),%eax
  804368:	8b 50 08             	mov    0x8(%eax),%edx
  80436b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80436e:	8b 40 04             	mov    0x4(%eax),%eax
  804371:	8b 48 08             	mov    0x8(%eax),%ecx
  804374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804377:	8b 40 04             	mov    0x4(%eax),%eax
  80437a:	8b 40 0c             	mov    0xc(%eax),%eax
  80437d:	01 c8                	add    %ecx,%eax
  80437f:	39 c2                	cmp    %eax,%edx
  804381:	0f 84 9c 00 00 00    	je     804423 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  804387:	8b 45 08             	mov    0x8(%ebp),%eax
  80438a:	8b 50 08             	mov    0x8(%eax),%edx
  80438d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804390:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  804393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804396:	8b 50 0c             	mov    0xc(%eax),%edx
  804399:	8b 45 08             	mov    0x8(%ebp),%eax
  80439c:	8b 40 0c             	mov    0xc(%eax),%eax
  80439f:	01 c2                	add    %eax,%edx
  8043a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a4:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  8043a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8043aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  8043b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8043bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043bf:	75 17                	jne    8043d8 <insert_sorted_with_merge_freeList+0x4dd>
  8043c1:	83 ec 04             	sub    $0x4,%esp
  8043c4:	68 10 53 80 00       	push   $0x805310
  8043c9:	68 74 01 00 00       	push   $0x174
  8043ce:	68 33 53 80 00       	push   $0x805333
  8043d3:	e8 61 d5 ff ff       	call   801939 <_panic>
  8043d8:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8043de:	8b 45 08             	mov    0x8(%ebp),%eax
  8043e1:	89 10                	mov    %edx,(%eax)
  8043e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043e6:	8b 00                	mov    (%eax),%eax
  8043e8:	85 c0                	test   %eax,%eax
  8043ea:	74 0d                	je     8043f9 <insert_sorted_with_merge_freeList+0x4fe>
  8043ec:	a1 48 61 80 00       	mov    0x806148,%eax
  8043f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8043f4:	89 50 04             	mov    %edx,0x4(%eax)
  8043f7:	eb 08                	jmp    804401 <insert_sorted_with_merge_freeList+0x506>
  8043f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8043fc:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804401:	8b 45 08             	mov    0x8(%ebp),%eax
  804404:	a3 48 61 80 00       	mov    %eax,0x806148
  804409:	8b 45 08             	mov    0x8(%ebp),%eax
  80440c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804413:	a1 54 61 80 00       	mov    0x806154,%eax
  804418:	40                   	inc    %eax
  804419:	a3 54 61 80 00       	mov    %eax,0x806154
break;
  80441e:	e9 e5 02 00 00       	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  804423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804426:	8b 50 08             	mov    0x8(%eax),%edx
  804429:	8b 45 08             	mov    0x8(%ebp),%eax
  80442c:	8b 40 08             	mov    0x8(%eax),%eax
  80442f:	39 c2                	cmp    %eax,%edx
  804431:	0f 86 d7 00 00 00    	jbe    80450e <insert_sorted_with_merge_freeList+0x613>
  804437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80443a:	8b 50 08             	mov    0x8(%eax),%edx
  80443d:	8b 45 08             	mov    0x8(%ebp),%eax
  804440:	8b 48 08             	mov    0x8(%eax),%ecx
  804443:	8b 45 08             	mov    0x8(%ebp),%eax
  804446:	8b 40 0c             	mov    0xc(%eax),%eax
  804449:	01 c8                	add    %ecx,%eax
  80444b:	39 c2                	cmp    %eax,%edx
  80444d:	0f 84 bb 00 00 00    	je     80450e <insert_sorted_with_merge_freeList+0x613>
  804453:	8b 45 08             	mov    0x8(%ebp),%eax
  804456:	8b 50 08             	mov    0x8(%eax),%edx
  804459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80445c:	8b 40 04             	mov    0x4(%eax),%eax
  80445f:	8b 48 08             	mov    0x8(%eax),%ecx
  804462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804465:	8b 40 04             	mov    0x4(%eax),%eax
  804468:	8b 40 0c             	mov    0xc(%eax),%eax
  80446b:	01 c8                	add    %ecx,%eax
  80446d:	39 c2                	cmp    %eax,%edx
  80446f:	0f 85 99 00 00 00    	jne    80450e <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  804475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804478:	8b 40 04             	mov    0x4(%eax),%eax
  80447b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  80447e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804481:	8b 50 0c             	mov    0xc(%eax),%edx
  804484:	8b 45 08             	mov    0x8(%ebp),%eax
  804487:	8b 40 0c             	mov    0xc(%eax),%eax
  80448a:	01 c2                	add    %eax,%edx
  80448c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80448f:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  804492:	8b 45 08             	mov    0x8(%ebp),%eax
  804495:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  80449c:	8b 45 08             	mov    0x8(%ebp),%eax
  80449f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8044a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044aa:	75 17                	jne    8044c3 <insert_sorted_with_merge_freeList+0x5c8>
  8044ac:	83 ec 04             	sub    $0x4,%esp
  8044af:	68 10 53 80 00       	push   $0x805310
  8044b4:	68 7d 01 00 00       	push   $0x17d
  8044b9:	68 33 53 80 00       	push   $0x805333
  8044be:	e8 76 d4 ff ff       	call   801939 <_panic>
  8044c3:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8044c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8044cc:	89 10                	mov    %edx,(%eax)
  8044ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8044d1:	8b 00                	mov    (%eax),%eax
  8044d3:	85 c0                	test   %eax,%eax
  8044d5:	74 0d                	je     8044e4 <insert_sorted_with_merge_freeList+0x5e9>
  8044d7:	a1 48 61 80 00       	mov    0x806148,%eax
  8044dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8044df:	89 50 04             	mov    %edx,0x4(%eax)
  8044e2:	eb 08                	jmp    8044ec <insert_sorted_with_merge_freeList+0x5f1>
  8044e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044e7:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8044ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ef:	a3 48 61 80 00       	mov    %eax,0x806148
  8044f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044fe:	a1 54 61 80 00       	mov    0x806154,%eax
  804503:	40                   	inc    %eax
  804504:	a3 54 61 80 00       	mov    %eax,0x806154
break;
  804509:	e9 fa 01 00 00       	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  80450e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804511:	8b 50 08             	mov    0x8(%eax),%edx
  804514:	8b 45 08             	mov    0x8(%ebp),%eax
  804517:	8b 40 08             	mov    0x8(%eax),%eax
  80451a:	39 c2                	cmp    %eax,%edx
  80451c:	0f 86 d2 01 00 00    	jbe    8046f4 <insert_sorted_with_merge_freeList+0x7f9>
  804522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804525:	8b 50 08             	mov    0x8(%eax),%edx
  804528:	8b 45 08             	mov    0x8(%ebp),%eax
  80452b:	8b 48 08             	mov    0x8(%eax),%ecx
  80452e:	8b 45 08             	mov    0x8(%ebp),%eax
  804531:	8b 40 0c             	mov    0xc(%eax),%eax
  804534:	01 c8                	add    %ecx,%eax
  804536:	39 c2                	cmp    %eax,%edx
  804538:	0f 85 b6 01 00 00    	jne    8046f4 <insert_sorted_with_merge_freeList+0x7f9>
  80453e:	8b 45 08             	mov    0x8(%ebp),%eax
  804541:	8b 50 08             	mov    0x8(%eax),%edx
  804544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804547:	8b 40 04             	mov    0x4(%eax),%eax
  80454a:	8b 48 08             	mov    0x8(%eax),%ecx
  80454d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804550:	8b 40 04             	mov    0x4(%eax),%eax
  804553:	8b 40 0c             	mov    0xc(%eax),%eax
  804556:	01 c8                	add    %ecx,%eax
  804558:	39 c2                	cmp    %eax,%edx
  80455a:	0f 85 94 01 00 00    	jne    8046f4 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  804560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804563:	8b 40 04             	mov    0x4(%eax),%eax
  804566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804569:	8b 52 04             	mov    0x4(%edx),%edx
  80456c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80456f:	8b 55 08             	mov    0x8(%ebp),%edx
  804572:	8b 5a 0c             	mov    0xc(%edx),%ebx
  804575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804578:	8b 52 0c             	mov    0xc(%edx),%edx
  80457b:	01 da                	add    %ebx,%edx
  80457d:	01 ca                	add    %ecx,%edx
  80457f:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  804582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804585:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80458c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80458f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  804596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80459a:	75 17                	jne    8045b3 <insert_sorted_with_merge_freeList+0x6b8>
  80459c:	83 ec 04             	sub    $0x4,%esp
  80459f:	68 a5 53 80 00       	push   $0x8053a5
  8045a4:	68 86 01 00 00       	push   $0x186
  8045a9:	68 33 53 80 00       	push   $0x805333
  8045ae:	e8 86 d3 ff ff       	call   801939 <_panic>
  8045b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045b6:	8b 00                	mov    (%eax),%eax
  8045b8:	85 c0                	test   %eax,%eax
  8045ba:	74 10                	je     8045cc <insert_sorted_with_merge_freeList+0x6d1>
  8045bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045bf:	8b 00                	mov    (%eax),%eax
  8045c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8045c4:	8b 52 04             	mov    0x4(%edx),%edx
  8045c7:	89 50 04             	mov    %edx,0x4(%eax)
  8045ca:	eb 0b                	jmp    8045d7 <insert_sorted_with_merge_freeList+0x6dc>
  8045cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045cf:	8b 40 04             	mov    0x4(%eax),%eax
  8045d2:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045da:	8b 40 04             	mov    0x4(%eax),%eax
  8045dd:	85 c0                	test   %eax,%eax
  8045df:	74 0f                	je     8045f0 <insert_sorted_with_merge_freeList+0x6f5>
  8045e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e4:	8b 40 04             	mov    0x4(%eax),%eax
  8045e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8045ea:	8b 12                	mov    (%edx),%edx
  8045ec:	89 10                	mov    %edx,(%eax)
  8045ee:	eb 0a                	jmp    8045fa <insert_sorted_with_merge_freeList+0x6ff>
  8045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045f3:	8b 00                	mov    (%eax),%eax
  8045f5:	a3 38 61 80 00       	mov    %eax,0x806138
  8045fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80460d:	a1 44 61 80 00       	mov    0x806144,%eax
  804612:	48                   	dec    %eax
  804613:	a3 44 61 80 00       	mov    %eax,0x806144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  804618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80461c:	75 17                	jne    804635 <insert_sorted_with_merge_freeList+0x73a>
  80461e:	83 ec 04             	sub    $0x4,%esp
  804621:	68 10 53 80 00       	push   $0x805310
  804626:	68 87 01 00 00       	push   $0x187
  80462b:	68 33 53 80 00       	push   $0x805333
  804630:	e8 04 d3 ff ff       	call   801939 <_panic>
  804635:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80463b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80463e:	89 10                	mov    %edx,(%eax)
  804640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804643:	8b 00                	mov    (%eax),%eax
  804645:	85 c0                	test   %eax,%eax
  804647:	74 0d                	je     804656 <insert_sorted_with_merge_freeList+0x75b>
  804649:	a1 48 61 80 00       	mov    0x806148,%eax
  80464e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804651:	89 50 04             	mov    %edx,0x4(%eax)
  804654:	eb 08                	jmp    80465e <insert_sorted_with_merge_freeList+0x763>
  804656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804659:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80465e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804661:	a3 48 61 80 00       	mov    %eax,0x806148
  804666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804670:	a1 54 61 80 00       	mov    0x806154,%eax
  804675:	40                   	inc    %eax
  804676:	a3 54 61 80 00       	mov    %eax,0x806154
				blockToInsert->sva=0;
  80467b:	8b 45 08             	mov    0x8(%ebp),%eax
  80467e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  804685:	8b 45 08             	mov    0x8(%ebp),%eax
  804688:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80468f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804693:	75 17                	jne    8046ac <insert_sorted_with_merge_freeList+0x7b1>
  804695:	83 ec 04             	sub    $0x4,%esp
  804698:	68 10 53 80 00       	push   $0x805310
  80469d:	68 8a 01 00 00       	push   $0x18a
  8046a2:	68 33 53 80 00       	push   $0x805333
  8046a7:	e8 8d d2 ff ff       	call   801939 <_panic>
  8046ac:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8046b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8046b5:	89 10                	mov    %edx,(%eax)
  8046b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8046ba:	8b 00                	mov    (%eax),%eax
  8046bc:	85 c0                	test   %eax,%eax
  8046be:	74 0d                	je     8046cd <insert_sorted_with_merge_freeList+0x7d2>
  8046c0:	a1 48 61 80 00       	mov    0x806148,%eax
  8046c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8046c8:	89 50 04             	mov    %edx,0x4(%eax)
  8046cb:	eb 08                	jmp    8046d5 <insert_sorted_with_merge_freeList+0x7da>
  8046cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8046d0:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8046d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8046d8:	a3 48 61 80 00       	mov    %eax,0x806148
  8046dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8046e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046e7:	a1 54 61 80 00       	mov    0x806154,%eax
  8046ec:	40                   	inc    %eax
  8046ed:	a3 54 61 80 00       	mov    %eax,0x806154
				break;
  8046f2:	eb 14                	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8046f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046f7:	8b 00                	mov    (%eax),%eax
  8046f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8046fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804700:	0f 85 72 fb ff ff    	jne    804278 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  804706:	eb 00                	jmp    804708 <insert_sorted_with_merge_freeList+0x80d>
  804708:	90                   	nop
  804709:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80470c:	c9                   	leave  
  80470d:	c3                   	ret    
  80470e:	66 90                	xchg   %ax,%ax

00804710 <__udivdi3>:
  804710:	55                   	push   %ebp
  804711:	57                   	push   %edi
  804712:	56                   	push   %esi
  804713:	53                   	push   %ebx
  804714:	83 ec 1c             	sub    $0x1c,%esp
  804717:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80471b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80471f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804723:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804727:	89 ca                	mov    %ecx,%edx
  804729:	89 f8                	mov    %edi,%eax
  80472b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80472f:	85 f6                	test   %esi,%esi
  804731:	75 2d                	jne    804760 <__udivdi3+0x50>
  804733:	39 cf                	cmp    %ecx,%edi
  804735:	77 65                	ja     80479c <__udivdi3+0x8c>
  804737:	89 fd                	mov    %edi,%ebp
  804739:	85 ff                	test   %edi,%edi
  80473b:	75 0b                	jne    804748 <__udivdi3+0x38>
  80473d:	b8 01 00 00 00       	mov    $0x1,%eax
  804742:	31 d2                	xor    %edx,%edx
  804744:	f7 f7                	div    %edi
  804746:	89 c5                	mov    %eax,%ebp
  804748:	31 d2                	xor    %edx,%edx
  80474a:	89 c8                	mov    %ecx,%eax
  80474c:	f7 f5                	div    %ebp
  80474e:	89 c1                	mov    %eax,%ecx
  804750:	89 d8                	mov    %ebx,%eax
  804752:	f7 f5                	div    %ebp
  804754:	89 cf                	mov    %ecx,%edi
  804756:	89 fa                	mov    %edi,%edx
  804758:	83 c4 1c             	add    $0x1c,%esp
  80475b:	5b                   	pop    %ebx
  80475c:	5e                   	pop    %esi
  80475d:	5f                   	pop    %edi
  80475e:	5d                   	pop    %ebp
  80475f:	c3                   	ret    
  804760:	39 ce                	cmp    %ecx,%esi
  804762:	77 28                	ja     80478c <__udivdi3+0x7c>
  804764:	0f bd fe             	bsr    %esi,%edi
  804767:	83 f7 1f             	xor    $0x1f,%edi
  80476a:	75 40                	jne    8047ac <__udivdi3+0x9c>
  80476c:	39 ce                	cmp    %ecx,%esi
  80476e:	72 0a                	jb     80477a <__udivdi3+0x6a>
  804770:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804774:	0f 87 9e 00 00 00    	ja     804818 <__udivdi3+0x108>
  80477a:	b8 01 00 00 00       	mov    $0x1,%eax
  80477f:	89 fa                	mov    %edi,%edx
  804781:	83 c4 1c             	add    $0x1c,%esp
  804784:	5b                   	pop    %ebx
  804785:	5e                   	pop    %esi
  804786:	5f                   	pop    %edi
  804787:	5d                   	pop    %ebp
  804788:	c3                   	ret    
  804789:	8d 76 00             	lea    0x0(%esi),%esi
  80478c:	31 ff                	xor    %edi,%edi
  80478e:	31 c0                	xor    %eax,%eax
  804790:	89 fa                	mov    %edi,%edx
  804792:	83 c4 1c             	add    $0x1c,%esp
  804795:	5b                   	pop    %ebx
  804796:	5e                   	pop    %esi
  804797:	5f                   	pop    %edi
  804798:	5d                   	pop    %ebp
  804799:	c3                   	ret    
  80479a:	66 90                	xchg   %ax,%ax
  80479c:	89 d8                	mov    %ebx,%eax
  80479e:	f7 f7                	div    %edi
  8047a0:	31 ff                	xor    %edi,%edi
  8047a2:	89 fa                	mov    %edi,%edx
  8047a4:	83 c4 1c             	add    $0x1c,%esp
  8047a7:	5b                   	pop    %ebx
  8047a8:	5e                   	pop    %esi
  8047a9:	5f                   	pop    %edi
  8047aa:	5d                   	pop    %ebp
  8047ab:	c3                   	ret    
  8047ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8047b1:	89 eb                	mov    %ebp,%ebx
  8047b3:	29 fb                	sub    %edi,%ebx
  8047b5:	89 f9                	mov    %edi,%ecx
  8047b7:	d3 e6                	shl    %cl,%esi
  8047b9:	89 c5                	mov    %eax,%ebp
  8047bb:	88 d9                	mov    %bl,%cl
  8047bd:	d3 ed                	shr    %cl,%ebp
  8047bf:	89 e9                	mov    %ebp,%ecx
  8047c1:	09 f1                	or     %esi,%ecx
  8047c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8047c7:	89 f9                	mov    %edi,%ecx
  8047c9:	d3 e0                	shl    %cl,%eax
  8047cb:	89 c5                	mov    %eax,%ebp
  8047cd:	89 d6                	mov    %edx,%esi
  8047cf:	88 d9                	mov    %bl,%cl
  8047d1:	d3 ee                	shr    %cl,%esi
  8047d3:	89 f9                	mov    %edi,%ecx
  8047d5:	d3 e2                	shl    %cl,%edx
  8047d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047db:	88 d9                	mov    %bl,%cl
  8047dd:	d3 e8                	shr    %cl,%eax
  8047df:	09 c2                	or     %eax,%edx
  8047e1:	89 d0                	mov    %edx,%eax
  8047e3:	89 f2                	mov    %esi,%edx
  8047e5:	f7 74 24 0c          	divl   0xc(%esp)
  8047e9:	89 d6                	mov    %edx,%esi
  8047eb:	89 c3                	mov    %eax,%ebx
  8047ed:	f7 e5                	mul    %ebp
  8047ef:	39 d6                	cmp    %edx,%esi
  8047f1:	72 19                	jb     80480c <__udivdi3+0xfc>
  8047f3:	74 0b                	je     804800 <__udivdi3+0xf0>
  8047f5:	89 d8                	mov    %ebx,%eax
  8047f7:	31 ff                	xor    %edi,%edi
  8047f9:	e9 58 ff ff ff       	jmp    804756 <__udivdi3+0x46>
  8047fe:	66 90                	xchg   %ax,%ax
  804800:	8b 54 24 08          	mov    0x8(%esp),%edx
  804804:	89 f9                	mov    %edi,%ecx
  804806:	d3 e2                	shl    %cl,%edx
  804808:	39 c2                	cmp    %eax,%edx
  80480a:	73 e9                	jae    8047f5 <__udivdi3+0xe5>
  80480c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80480f:	31 ff                	xor    %edi,%edi
  804811:	e9 40 ff ff ff       	jmp    804756 <__udivdi3+0x46>
  804816:	66 90                	xchg   %ax,%ax
  804818:	31 c0                	xor    %eax,%eax
  80481a:	e9 37 ff ff ff       	jmp    804756 <__udivdi3+0x46>
  80481f:	90                   	nop

00804820 <__umoddi3>:
  804820:	55                   	push   %ebp
  804821:	57                   	push   %edi
  804822:	56                   	push   %esi
  804823:	53                   	push   %ebx
  804824:	83 ec 1c             	sub    $0x1c,%esp
  804827:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80482b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80482f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804833:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804837:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80483b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80483f:	89 f3                	mov    %esi,%ebx
  804841:	89 fa                	mov    %edi,%edx
  804843:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804847:	89 34 24             	mov    %esi,(%esp)
  80484a:	85 c0                	test   %eax,%eax
  80484c:	75 1a                	jne    804868 <__umoddi3+0x48>
  80484e:	39 f7                	cmp    %esi,%edi
  804850:	0f 86 a2 00 00 00    	jbe    8048f8 <__umoddi3+0xd8>
  804856:	89 c8                	mov    %ecx,%eax
  804858:	89 f2                	mov    %esi,%edx
  80485a:	f7 f7                	div    %edi
  80485c:	89 d0                	mov    %edx,%eax
  80485e:	31 d2                	xor    %edx,%edx
  804860:	83 c4 1c             	add    $0x1c,%esp
  804863:	5b                   	pop    %ebx
  804864:	5e                   	pop    %esi
  804865:	5f                   	pop    %edi
  804866:	5d                   	pop    %ebp
  804867:	c3                   	ret    
  804868:	39 f0                	cmp    %esi,%eax
  80486a:	0f 87 ac 00 00 00    	ja     80491c <__umoddi3+0xfc>
  804870:	0f bd e8             	bsr    %eax,%ebp
  804873:	83 f5 1f             	xor    $0x1f,%ebp
  804876:	0f 84 ac 00 00 00    	je     804928 <__umoddi3+0x108>
  80487c:	bf 20 00 00 00       	mov    $0x20,%edi
  804881:	29 ef                	sub    %ebp,%edi
  804883:	89 fe                	mov    %edi,%esi
  804885:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804889:	89 e9                	mov    %ebp,%ecx
  80488b:	d3 e0                	shl    %cl,%eax
  80488d:	89 d7                	mov    %edx,%edi
  80488f:	89 f1                	mov    %esi,%ecx
  804891:	d3 ef                	shr    %cl,%edi
  804893:	09 c7                	or     %eax,%edi
  804895:	89 e9                	mov    %ebp,%ecx
  804897:	d3 e2                	shl    %cl,%edx
  804899:	89 14 24             	mov    %edx,(%esp)
  80489c:	89 d8                	mov    %ebx,%eax
  80489e:	d3 e0                	shl    %cl,%eax
  8048a0:	89 c2                	mov    %eax,%edx
  8048a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048a6:	d3 e0                	shl    %cl,%eax
  8048a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048b0:	89 f1                	mov    %esi,%ecx
  8048b2:	d3 e8                	shr    %cl,%eax
  8048b4:	09 d0                	or     %edx,%eax
  8048b6:	d3 eb                	shr    %cl,%ebx
  8048b8:	89 da                	mov    %ebx,%edx
  8048ba:	f7 f7                	div    %edi
  8048bc:	89 d3                	mov    %edx,%ebx
  8048be:	f7 24 24             	mull   (%esp)
  8048c1:	89 c6                	mov    %eax,%esi
  8048c3:	89 d1                	mov    %edx,%ecx
  8048c5:	39 d3                	cmp    %edx,%ebx
  8048c7:	0f 82 87 00 00 00    	jb     804954 <__umoddi3+0x134>
  8048cd:	0f 84 91 00 00 00    	je     804964 <__umoddi3+0x144>
  8048d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8048d7:	29 f2                	sub    %esi,%edx
  8048d9:	19 cb                	sbb    %ecx,%ebx
  8048db:	89 d8                	mov    %ebx,%eax
  8048dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8048e1:	d3 e0                	shl    %cl,%eax
  8048e3:	89 e9                	mov    %ebp,%ecx
  8048e5:	d3 ea                	shr    %cl,%edx
  8048e7:	09 d0                	or     %edx,%eax
  8048e9:	89 e9                	mov    %ebp,%ecx
  8048eb:	d3 eb                	shr    %cl,%ebx
  8048ed:	89 da                	mov    %ebx,%edx
  8048ef:	83 c4 1c             	add    $0x1c,%esp
  8048f2:	5b                   	pop    %ebx
  8048f3:	5e                   	pop    %esi
  8048f4:	5f                   	pop    %edi
  8048f5:	5d                   	pop    %ebp
  8048f6:	c3                   	ret    
  8048f7:	90                   	nop
  8048f8:	89 fd                	mov    %edi,%ebp
  8048fa:	85 ff                	test   %edi,%edi
  8048fc:	75 0b                	jne    804909 <__umoddi3+0xe9>
  8048fe:	b8 01 00 00 00       	mov    $0x1,%eax
  804903:	31 d2                	xor    %edx,%edx
  804905:	f7 f7                	div    %edi
  804907:	89 c5                	mov    %eax,%ebp
  804909:	89 f0                	mov    %esi,%eax
  80490b:	31 d2                	xor    %edx,%edx
  80490d:	f7 f5                	div    %ebp
  80490f:	89 c8                	mov    %ecx,%eax
  804911:	f7 f5                	div    %ebp
  804913:	89 d0                	mov    %edx,%eax
  804915:	e9 44 ff ff ff       	jmp    80485e <__umoddi3+0x3e>
  80491a:	66 90                	xchg   %ax,%ax
  80491c:	89 c8                	mov    %ecx,%eax
  80491e:	89 f2                	mov    %esi,%edx
  804920:	83 c4 1c             	add    $0x1c,%esp
  804923:	5b                   	pop    %ebx
  804924:	5e                   	pop    %esi
  804925:	5f                   	pop    %edi
  804926:	5d                   	pop    %ebp
  804927:	c3                   	ret    
  804928:	3b 04 24             	cmp    (%esp),%eax
  80492b:	72 06                	jb     804933 <__umoddi3+0x113>
  80492d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804931:	77 0f                	ja     804942 <__umoddi3+0x122>
  804933:	89 f2                	mov    %esi,%edx
  804935:	29 f9                	sub    %edi,%ecx
  804937:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80493b:	89 14 24             	mov    %edx,(%esp)
  80493e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804942:	8b 44 24 04          	mov    0x4(%esp),%eax
  804946:	8b 14 24             	mov    (%esp),%edx
  804949:	83 c4 1c             	add    $0x1c,%esp
  80494c:	5b                   	pop    %ebx
  80494d:	5e                   	pop    %esi
  80494e:	5f                   	pop    %edi
  80494f:	5d                   	pop    %ebp
  804950:	c3                   	ret    
  804951:	8d 76 00             	lea    0x0(%esi),%esi
  804954:	2b 04 24             	sub    (%esp),%eax
  804957:	19 fa                	sbb    %edi,%edx
  804959:	89 d1                	mov    %edx,%ecx
  80495b:	89 c6                	mov    %eax,%esi
  80495d:	e9 71 ff ff ff       	jmp    8048d3 <__umoddi3+0xb3>
  804962:	66 90                	xchg   %ax,%ax
  804964:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804968:	72 ea                	jb     804954 <__umoddi3+0x134>
  80496a:	89 d9                	mov    %ebx,%ecx
  80496c:	e9 62 ff ff ff       	jmp    8048d3 <__umoddi3+0xb3>
