
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 38 11 00 00       	call   80116e <libmain>
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
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 55 80             	lea    -0x80(%ebp),%edx
  800051:	b9 14 00 00 00       	mov    $0x14,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 00 43 80 00       	push   $0x804300
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 9e 28 00 00       	call   802912 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 36 29 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80007f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800082:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	e8 20 24 00 00       	call   8024ae <malloc>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800094:	8b 45 80             	mov    -0x80(%ebp),%eax
  800097:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 24 43 80 00       	push   $0x804324
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 54 43 80 00       	push   $0x804354
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 58 28 00 00       	call   802912 <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 6c 43 80 00       	push   $0x80436c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 54 43 80 00       	push   $0x804354
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 d6 28 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 d8 43 80 00       	push   $0x8043d8
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 54 43 80 00       	push   $0x804354
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 13 28 00 00       	call   802912 <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 ab 28 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80010a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 95 23 00 00       	call   8024ae <malloc>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80011f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	05 00 00 00 80       	add    $0x80000000,%eax
  80012c:	39 c2                	cmp    %eax,%edx
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 24 43 80 00       	push   $0x804324
  800138:	6a 19                	push   $0x19
  80013a:	68 54 43 80 00       	push   $0x804354
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 c9 27 00 00       	call   802912 <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 6c 43 80 00       	push   $0x80436c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 54 43 80 00       	push   $0x804354
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 47 28 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 d8 43 80 00       	push   $0x8043d8
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 54 43 80 00       	push   $0x804354
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 84 27 00 00       	call   802912 <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 1c 28 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	50                   	push   %eax
  8001a3:	e8 06 23 00 00       	call   8024ae <malloc>
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b1:	89 c2                	mov    %eax,%edx
  8001b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 24 43 80 00       	push   $0x804324
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 54 43 80 00       	push   $0x804354
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 38 27 00 00       	call   802912 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 6c 43 80 00       	push   $0x80436c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 54 43 80 00       	push   $0x804354
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 b6 27 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 d8 43 80 00       	push   $0x8043d8
  80020e:	6a 24                	push   $0x24
  800210:	68 54 43 80 00       	push   $0x804354
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 f3 26 00 00       	call   802912 <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 8b 27 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80022a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	e8 75 22 00 00       	call   8024ae <malloc>
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80023f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	05 00 00 00 80       	add    $0x80000000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 24 43 80 00       	push   $0x804324
  80025e:	6a 2a                	push   $0x2a
  800260:	68 54 43 80 00       	push   $0x804354
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 a3 26 00 00       	call   802912 <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 6c 43 80 00       	push   $0x80436c
  800280:	6a 2c                	push   $0x2c
  800282:	68 54 43 80 00       	push   $0x804354
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 21 27 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 d8 43 80 00       	push   $0x8043d8
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 54 43 80 00       	push   $0x804354
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 5e 26 00 00       	call   802912 <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 f6 26 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	e8 de 21 00 00       	call   8024ae <malloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002d6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d9:	89 c2                	mov    %eax,%edx
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	c1 e0 02             	shl    $0x2,%eax
  8002e1:	05 00 00 00 80       	add    $0x80000000,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 24 43 80 00       	push   $0x804324
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 54 43 80 00       	push   $0x804354
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 0c 26 00 00       	call   802912 <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 6c 43 80 00       	push   $0x80436c
  800317:	6a 35                	push   $0x35
  800319:	68 54 43 80 00       	push   $0x804354
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 8a 26 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 d8 43 80 00       	push   $0x8043d8
  80033a:	6a 36                	push   $0x36
  80033c:	68 54 43 80 00       	push   $0x804354
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 c7 25 00 00       	call   802912 <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 5f 26 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	50                   	push   %eax
  800362:	e8 47 21 00 00       	call   8024ae <malloc>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80036d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800370:	89 c1                	mov    %eax,%ecx
  800372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	05 00 00 00 80       	add    $0x80000000,%eax
  800382:	39 c1                	cmp    %eax,%ecx
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 24 43 80 00       	push   $0x804324
  80038e:	6a 3c                	push   $0x3c
  800390:	68 54 43 80 00       	push   $0x804354
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 73 25 00 00       	call   802912 <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 6c 43 80 00       	push   $0x80436c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 54 43 80 00       	push   $0x804354
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 f1 25 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 d8 43 80 00       	push   $0x8043d8
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 54 43 80 00       	push   $0x804354
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 2e 25 00 00       	call   802912 <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 c6 25 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 aa 20 00 00       	call   8024ae <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800412:	c1 e0 03             	shl    $0x3,%eax
  800415:	05 00 00 00 80       	add    $0x80000000,%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	74 14                	je     800432 <_main+0x3fa>
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	68 24 43 80 00       	push   $0x804324
  800426:	6a 45                	push   $0x45
  800428:	68 54 43 80 00       	push   $0x804354
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 d8 24 00 00       	call   802912 <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 6c 43 80 00       	push   $0x80436c
  80044b:	6a 47                	push   $0x47
  80044d:	68 54 43 80 00       	push   $0x804354
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 56 25 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 d8 43 80 00       	push   $0x8043d8
  80046e:	6a 48                	push   $0x48
  800470:	68 54 43 80 00       	push   $0x804354
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 93 24 00 00       	call   802912 <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 2b 25 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	01 d2                	add    %edx,%edx
  800491:	01 d0                	add    %edx,%eax
  800493:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 0f 20 00 00       	call   8024ae <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004a8:	89 c1                	mov    %eax,%ecx
  8004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	c1 e0 02             	shl    $0x2,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004bd:	39 c1                	cmp    %eax,%ecx
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 24 43 80 00       	push   $0x804324
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 54 43 80 00       	push   $0x804354
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 35 24 00 00       	call   802912 <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 6c 43 80 00       	push   $0x80436c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 54 43 80 00       	push   $0x804354
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 b3 24 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 d8 43 80 00       	push   $0x8043d8
  800511:	6a 51                	push   $0x51
  800513:	68 54 43 80 00       	push   $0x804354
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 f0 23 00 00       	call   802912 <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 88 24 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  80052a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 remainingSpaceInUHeap = (USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega;
  80052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	f7 d8                	neg    %eax
  80053e:	05 00 00 00 20       	add    $0x20000000,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(remainingSpaceInUHeap - kilo);
  800546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 55 1f 00 00       	call   8024ae <malloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80055f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800562:	89 c1                	mov    %eax,%ecx
  800564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	05 00 00 00 80       	add    $0x80000000,%eax
  800578:	39 c1                	cmp    %eax,%ecx
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 24 43 80 00       	push   $0x804324
  800584:	6a 5a                	push   $0x5a
  800586:	68 54 43 80 00       	push   $0x804354
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 7a 23 00 00       	call   802912 <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 6c 43 80 00       	push   $0x80436c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 54 43 80 00       	push   $0x804354
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 f8 23 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 d8 43 80 00       	push   $0x8043d8
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 54 43 80 00       	push   $0x804354
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 35 23 00 00       	call   802912 <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 cd 23 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 45 1f 00 00       	call   802539 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 b6 23 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 08 44 80 00       	push   $0x804408
  800612:	6a 68                	push   $0x68
  800614:	68 54 43 80 00       	push   $0x804354
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 ef 22 00 00       	call   802912 <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 44 44 80 00       	push   $0x804444
  800634:	6a 69                	push   $0x69
  800636:	68 54 43 80 00       	push   $0x804354
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 cd 22 00 00       	call   802912 <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 65 23 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 dd 1e 00 00       	call   802539 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 4e 23 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 08 44 80 00       	push   $0x804408
  80067a:	6a 70                	push   $0x70
  80067c:	68 54 43 80 00       	push   $0x804354
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 87 22 00 00       	call   802912 <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 44 44 80 00       	push   $0x804444
  80069c:	6a 71                	push   $0x71
  80069e:	68 54 43 80 00       	push   $0x804354
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 65 22 00 00       	call   802912 <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 fd 22 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 75 1e 00 00       	call   802539 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 e6 22 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 08 44 80 00       	push   $0x804408
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 54 43 80 00       	push   $0x804354
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 1f 22 00 00       	call   802912 <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 44 44 80 00       	push   $0x804444
  800704:	6a 79                	push   $0x79
  800706:	68 54 43 80 00       	push   $0x804354
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 fd 21 00 00       	call   802912 <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 95 22 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 0d 1e 00 00       	call   802539 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 7e 22 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 08 44 80 00       	push   $0x804408
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 54 43 80 00       	push   $0x804354
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 b4 21 00 00       	call   802912 <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 44 44 80 00       	push   $0x804444
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 54 43 80 00       	push   $0x804354
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 88 21 00 00       	call   802912 <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 20 22 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(512*kilo - kilo);
  800795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 09             	shl    $0x9,%eax
  80079d:	29 d0                	sub    %edx,%eax
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	50                   	push   %eax
  8007a3:	e8 06 1d 00 00       	call   8024ae <malloc>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8007ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 24 43 80 00       	push   $0x804324
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 54 43 80 00       	push   $0x804354
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 37 21 00 00       	call   802912 <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 6c 43 80 00       	push   $0x80436c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 54 43 80 00       	push   $0x804354
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 b2 21 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 d8 43 80 00       	push   $0x8043d8
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 54 43 80 00       	push   $0x804354
  80081c:	e8 89 0a 00 00       	call   8012aa <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[9];
  800821:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c1 e0 09             	shl    $0x9,%eax
  80082d:	c1 e8 02             	shr    $0x2,%eax
  800830:	48                   	dec    %eax
  800831:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800842:	eb 17                	jmp    80085b <_main+0x823>
		{
			intArr[i] = i ;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	01 c2                	add    %eax,%edx
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800858:	ff 45 f4             	incl   -0xc(%ebp)
  80085b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80085f:	7e e3                	jle    800844 <_main+0x80c>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800867:	eb 17                	jmp    800880 <_main+0x848>
		{
			intArr[i] = i ;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	01 c2                	add    %eax,%edx
  800878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  80087d:	ff 4d f4             	decl   -0xc(%ebp)
  800880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800883:	83 e8 64             	sub    $0x64,%eax
  800886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800889:	7c de                	jl     800869 <_main+0x831>
		{
			intArr[i] = i ;
		}

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  80088b:	e8 82 20 00 00       	call   802912 <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 1a 21 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 512*kilo + 256*kilo - kilo);
  80089b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80089e:	89 d0                	mov    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	c1 e0 08             	shl    $0x8,%eax
  8008a7:	29 d0                	sub    %edx,%eax
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	52                   	push   %edx
  8008b2:	50                   	push   %eax
  8008b3:	e8 d8 1e 00 00       	call   802790 <realloc>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  8008be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 90 44 80 00       	push   $0x804490
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 54 43 80 00       	push   $0x804354
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 27 20 00 00       	call   802912 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 c4 44 80 00       	push   $0x8044c4
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 54 43 80 00       	push   $0x804354
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 a2 20 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 34 45 80 00       	push   $0x804534
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 54 43 80 00       	push   $0x804354
  80092a:	e8 7b 09 00 00       	call   8012aa <_panic>


		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  80092f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 08             	shl    $0x8,%eax
  80093b:	c1 e8 02             	shr    $0x2,%eax
  80093e:	48                   	dec    %eax
  80093f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800945:	40                   	inc    %eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800949:	eb 17                	jmp    800962 <_main+0x92a>
		{
			intArr[i] = i;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	01 c2                	add    %eax,%edx
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  80095f:	ff 45 f4             	incl   -0xc(%ebp)
  800962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800965:	83 c0 65             	add    $0x65,%eax
  800968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80096b:	7f de                	jg     80094b <_main+0x913>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80096d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800973:	eb 17                	jmp    80098c <_main+0x954>
		{
			intArr[i] = i;
  800975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	01 c2                	add    %eax,%edx
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800989:	ff 4d f4             	decl   -0xc(%ebp)
  80098c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80098f:	83 e8 64             	sub    $0x64,%eax
  800992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800995:	7c de                	jl     800975 <_main+0x93d>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80099e:	eb 30                	jmp    8009d0 <_main+0x998>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ad:	01 d0                	add    %edx,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 68 45 80 00       	push   $0x804568
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 54 43 80 00       	push   $0x804354
  8009c8:	e8 dd 08 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
  8009d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  8009d4:	7e ca                	jle    8009a0 <_main+0x968>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  8009d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009dc:	eb 30                	jmp    800a0e <_main+0x9d6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 68 45 80 00       	push   $0x804568
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 54 43 80 00       	push   $0x804354
  800a06:	e8 9f 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800a0b:	ff 4d f4             	decl   -0xc(%ebp)
  800a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a11:	83 e8 64             	sub    $0x64,%eax
  800a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a17:	7c c5                	jl     8009de <_main+0x9a6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1c:	40                   	inc    %eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a20:	eb 30                	jmp    800a52 <_main+0xa1a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 68 45 80 00       	push   $0x804568
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 54 43 80 00       	push   $0x804354
  800a4a:	e8 5b 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a4f:	ff 45 f4             	incl   -0xc(%ebp)
  800a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a55:	83 c0 65             	add    $0x65,%eax
  800a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a5b:	7f c5                	jg     800a22 <_main+0x9ea>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a63:	eb 30                	jmp    800a95 <_main+0xa5d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 68 45 80 00       	push   $0x804568
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 54 43 80 00       	push   $0x804354
  800a8d:	e8 18 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a92:	ff 4d f4             	decl   -0xc(%ebp)
  800a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a98:	83 e8 64             	sub    $0x64,%eax
  800a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a9e:	7c c5                	jl     800a65 <_main+0xa2d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800aa0:	e8 6d 1e 00 00       	call   802912 <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 05 1f 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 7d 1a 00 00       	call   802539 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 ee 1e 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 a0 45 80 00       	push   $0x8045a0
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 54 43 80 00       	push   $0x804354
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 24 1e 00 00       	call   802912 <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 44 44 80 00       	push   $0x804444
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 54 43 80 00       	push   $0x804354
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 f4 45 80 00       	push   $0x8045f4
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 e8 1d 00 00       	call   802912 <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 80 1e 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega + 512*kilo - kilo);
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c1 e0 09             	shl    $0x9,%eax
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	e8 60 19 00 00       	call   8024ae <malloc>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	c1 e0 02             	shl    $0x2,%eax
  800b5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	74 17                	je     800b7f <_main+0xb47>
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	68 24 43 80 00       	push   $0x804324
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 54 43 80 00       	push   $0x804354
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 8e 1d 00 00       	call   802912 <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 6c 43 80 00       	push   $0x80436c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 54 43 80 00       	push   $0x804354
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 09 1e 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 d8 43 80 00       	push   $0x8043d8
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 54 43 80 00       	push   $0x804354
  800bc5:	e8 e0 06 00 00       	call   8012aa <_panic>

		//Fill it with data
		intArr = (int*) ptr_allocations[9];
  800bca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c1 e0 09             	shl    $0x9,%eax
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	c1 e8 02             	shr    $0x2,%eax
  800be0:	48                   	dec    %eax
  800be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		i = 0;
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800bf2:	eb 17                	jmp    800c0b <_main+0xbd3>
		{
			intArr[i] = i ;
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	01 c2                	add    %eax,%edx
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
  800c0b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800c0f:	7e e3                	jle    800bf4 <_main+0xbbc>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c17:	eb 17                	jmp    800c30 <_main+0xbf8>
		{
			intArr[i] = i ;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c26:	01 c2                	add    %eax,%edx
  800c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c2d:	ff 4d f4             	decl   -0xc(%ebp)
  800c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c33:	83 e8 64             	sub    $0x64,%eax
  800c36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800c39:	7c de                	jl     800c19 <_main+0xbe1>
		{
			intArr[i] = i ;
		}

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 d2 1c 00 00       	call   802912 <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 6a 1d 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 1*Mega + 512*kilo + 1*Mega - kilo);
  800c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4e:	c1 e0 09             	shl    $0x9,%eax
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	01 c2                	add    %eax,%edx
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	e8 21 1b 00 00       	call   802790 <realloc>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800c75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	c1 e0 03             	shl    $0x3,%eax
  800c80:	05 00 00 00 80       	add    $0x80000000,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 90 44 80 00       	push   $0x804490
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 54 43 80 00       	push   $0x804354
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 0d 1d 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 34 45 80 00       	push   $0x804534
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 54 43 80 00       	push   $0x804354
  800cc1:	e8 e4 05 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	c1 e8 02             	shr    $0x2,%eax
  800cd8:	48                   	dec    %eax
  800cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[9];
  800cdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%ebp)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce5:	40                   	inc    %eax
  800ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce9:	eb 17                	jmp    800d02 <_main+0xcca>
		{
			intArr[i] = i;
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf8:	01 c2                	add    %eax,%edx
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800cff:	ff 45 f4             	incl   -0xc(%ebp)
  800d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d05:	83 c0 65             	add    $0x65,%eax
  800d08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d0b:	7f de                	jg     800ceb <_main+0xcb3>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 17                	jmp    800d2c <_main+0xcf4>
		{
			intArr[i] = i;
  800d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d22:	01 c2                	add    %eax,%edx
  800d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d27:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d29:	ff 4d f4             	decl   -0xc(%ebp)
  800d2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d2f:	83 e8 64             	sub    $0x64,%eax
  800d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d35:	7c de                	jl     800d15 <_main+0xcdd>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d3e:	eb 30                	jmp    800d70 <_main+0xd38>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	68 68 45 80 00       	push   $0x804568
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 54 43 80 00       	push   $0x804354
  800d68:	e8 3d 05 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
  800d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800d74:	7e ca                	jle    800d40 <_main+0xd08>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 30                	jmp    800dae <_main+0xd76>
		{
			if (intArr[i] != i)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8b:	01 d0                	add    %edx,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d92:	74 17                	je     800dab <_main+0xd73>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 68 45 80 00       	push   $0x804568
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 54 43 80 00       	push   $0x804354
  800da6:	e8 ff 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800dab:	ff 4d f4             	decl   -0xc(%ebp)
  800dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db1:	83 e8 64             	sub    $0x64,%eax
  800db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800db7:	7c c5                	jl     800d7e <_main+0xd46>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbc:	40                   	inc    %eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 30                	jmp    800df2 <_main+0xdba>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dd6:	74 17                	je     800def <_main+0xdb7>
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 68 45 80 00       	push   $0x804568
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 54 43 80 00       	push   $0x804354
  800dea:	e8 bb 04 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800def:	ff 45 f4             	incl   -0xc(%ebp)
  800df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df5:	83 c0 65             	add    $0x65,%eax
  800df8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dfb:	7f c5                	jg     800dc2 <_main+0xd8a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800dfd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e03:	eb 30                	jmp    800e35 <_main+0xdfd>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e19:	74 17                	je     800e32 <_main+0xdfa>
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 68 45 80 00       	push   $0x804568
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 54 43 80 00       	push   $0x804354
  800e2d:	e8 78 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800e32:	ff 4d f4             	decl   -0xc(%ebp)
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e38:	83 e8 64             	sub    $0x64,%eax
  800e3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e3e:	7c c5                	jl     800e05 <_main+0xdcd>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800e40:	e8 cd 1a 00 00       	call   802912 <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 65 1b 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 dd 16 00 00       	call   802539 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 4e 1b 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 a0 45 80 00       	push   $0x8045a0
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 54 43 80 00       	push   $0x804354
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 fb 45 80 00       	push   $0x8045fb
  800e93:	e8 5b 06 00 00       	call   8014f3 <vcprintf>
  800e98:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		intArr = (int*) ptr_allocations[0];
  800e9b:	8b 45 80             	mov    -0x80(%ebp),%eax
  800e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c1 e8 02             	shr    $0x2,%eax
  800ea7:	48                   	dec    %eax
  800ea8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		i = 0;
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <_main+0xe9a>
		{
			intArr[i] = i ;
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ec8:	01 c2                	add    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	89 02                	mov    %eax,(%edx)

		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800ecf:	ff 45 f4             	incl   -0xc(%ebp)
  800ed2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800ed6:	7e e3                	jle    800ebb <_main+0xe83>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ede:	eb 17                	jmp    800ef7 <_main+0xebf>
		{
			intArr[i] = i ;
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ef4:	ff 4d f4             	decl   -0xc(%ebp)
  800ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800efa:	83 e8 64             	sub    $0x64,%eax
  800efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f00:	7c de                	jl     800ee0 <_main+0xea8>
			intArr[i] = i ;
		}


		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800f02:	e8 0b 1a 00 00       	call   802912 <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 a3 1a 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	c1 e0 02             	shl    $0x2,%eax
  800f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	52                   	push   %edx
  800f24:	50                   	push   %eax
  800f25:	e8 66 18 00 00       	call   802790 <realloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 80             	mov    %eax,-0x80(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800f30:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f33:	89 c1                	mov    %eax,%ecx
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	01 c0                	add    %eax,%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	01 c0                	add    %eax,%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	01 c0                	add    %eax,%eax
  800f44:	05 00 00 00 80       	add    $0x80000000,%eax
  800f49:	39 c1                	cmp    %eax,%ecx
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 90 44 80 00       	push   $0x804490
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 54 43 80 00       	push   $0x804354
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 49 1a 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 34 45 80 00       	push   $0x804534
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 54 43 80 00       	push   $0x804354
  800f85:	e8 20 03 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8d:	c1 e0 02             	shl    $0x2,%eax
  800f90:	c1 e8 02             	shr    $0x2,%eax
  800f93:	48                   	dec    %eax
  800f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[0];
  800f97:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fa0:	40                   	inc    %eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa4:	eb 17                	jmp    800fbd <_main+0xf85>
		{
			intArr[i] = i;
  800fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800fba:	ff 45 f4             	incl   -0xc(%ebp)
  800fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fc0:	83 c0 65             	add    $0x65,%eax
  800fc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc6:	7f de                	jg     800fa6 <_main+0xf6e>
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 17                	jmp    800fe7 <_main+0xfaf>
		{
			intArr[i] = i;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fea:	83 e8 64             	sub    $0x64,%eax
  800fed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff0:	7c de                	jl     800fd0 <_main+0xf98>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ff9:	eb 30                	jmp    80102b <_main+0xff3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80100f:	74 17                	je     801028 <_main+0xff0>
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	68 68 45 80 00       	push   $0x804568
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 54 43 80 00       	push   $0x804354
  801023:	e8 82 02 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  801028:	ff 45 f4             	incl   -0xc(%ebp)
  80102b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80102f:	7e ca                	jle    800ffb <_main+0xfc3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801031:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 30                	jmp    801069 <_main+0x1031>
		{
			if (intArr[i] != i)
  801039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801043:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	74 17                	je     801066 <_main+0x102e>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 68 45 80 00       	push   $0x804568
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 54 43 80 00       	push   $0x804354
  801061:	e8 44 02 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801066:	ff 4d f4             	decl   -0xc(%ebp)
  801069:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80106c:	83 e8 64             	sub    $0x64,%eax
  80106f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801072:	7c c5                	jl     801039 <_main+0x1001>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  801074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801077:	40                   	inc    %eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 30                	jmp    8010ad <_main+0x1075>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801091:	74 17                	je     8010aa <_main+0x1072>
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 68 45 80 00       	push   $0x804568
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 54 43 80 00       	push   $0x804354
  8010a5:	e8 00 02 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  8010aa:	ff 45 f4             	incl   -0xc(%ebp)
  8010ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b0:	83 c0 65             	add    $0x65,%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7f c5                	jg     80107d <_main+0x1045>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010be:	eb 30                	jmp    8010f0 <_main+0x10b8>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d4:	74 17                	je     8010ed <_main+0x10b5>
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 68 45 80 00       	push   $0x804568
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 54 43 80 00       	push   $0x804354
  8010e8:	e8 bd 01 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010ed:	ff 4d f4             	decl   -0xc(%ebp)
  8010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f3:	83 e8 64             	sub    $0x64,%eax
  8010f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f9:	7c c5                	jl     8010c0 <_main+0x1088>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8010fb:	e8 12 18 00 00       	call   802912 <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 aa 18 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 22 14 00 00       	call   802539 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 93 18 00 00       	call   8029b2 <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 a0 45 80 00       	push   $0x8045a0
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 54 43 80 00       	push   $0x804354
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 02 46 80 00       	push   $0x804602
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 0c 46 80 00       	push   $0x80460c
  80115e:	e8 fb 03 00 00       	call   80155e <cprintf>
  801163:	83 c4 10             	add    $0x10,%esp

	return;
  801166:	90                   	nop
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801174:	e8 79 1a 00 00       	call   802bf2 <sys_getenvindex>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 03             	shl    $0x3,%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	01 c0                	add    %eax,%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	01 d0                	add    %edx,%eax
  801193:	c1 e0 04             	shl    $0x4,%eax
  801196:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8011a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8011a5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0f                	je     8011be <libmain+0x50>
		binaryname = myEnv->prog_name;
  8011af:	a1 20 50 80 00       	mov    0x805020,%eax
  8011b4:	05 5c 05 00 00       	add    $0x55c,%eax
  8011b9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	7e 0a                	jle    8011ce <libmain+0x60>
		binaryname = argv[0];
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 5c ee ff ff       	call   800038 <_main>
  8011dc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8011df:	e8 1b 18 00 00       	call   8029ff <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 60 46 80 00       	push   $0x804660
  8011ec:	e8 6d 03 00 00       	call   80155e <cprintf>
  8011f1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8011ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801204:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	52                   	push   %edx
  80120e:	50                   	push   %eax
  80120f:	68 88 46 80 00       	push   $0x804688
  801214:	e8 45 03 00 00       	call   80155e <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80121c:	a1 20 50 80 00       	mov    0x805020,%eax
  801221:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801227:	a1 20 50 80 00       	mov    0x805020,%eax
  80122c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801232:	a1 20 50 80 00       	mov    0x805020,%eax
  801237:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80123d:	51                   	push   %ecx
  80123e:	52                   	push   %edx
  80123f:	50                   	push   %eax
  801240:	68 b0 46 80 00       	push   $0x8046b0
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 50 80 00       	mov    0x805020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 08 47 80 00       	push   $0x804708
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 60 46 80 00       	push   $0x804660
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 9b 17 00 00       	call   802a19 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80127e:	e8 19 00 00 00       	call   80129c <exit>
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	6a 00                	push   $0x0
  801291:	e8 28 19 00 00       	call   802bbe <sys_destroy_env>
  801296:	83 c4 10             	add    $0x10,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <exit>:

void
exit(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012a2:	e8 7d 19 00 00       	call   802c24 <sys_exit_env>
}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b3:	83 c0 04             	add    $0x4,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012b9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 16                	je     8012d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	50                   	push   %eax
  8012cb:	68 1c 47 80 00       	push   $0x80471c
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 50 80 00       	mov    0x805000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 21 47 80 00       	push   $0x804721
  8012e9:	e8 70 02 00 00       	call   80155e <cprintf>
  8012ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fa:	50                   	push   %eax
  8012fb:	e8 f3 01 00 00       	call   8014f3 <vcprintf>
  801300:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	6a 00                	push   $0x0
  801308:	68 3d 47 80 00       	push   $0x80473d
  80130d:	e8 e1 01 00 00       	call   8014f3 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801315:	e8 82 ff ff ff       	call   80129c <exit>

	// should not return here
	while (1) ;
  80131a:	eb fe                	jmp    80131a <_panic+0x70>

0080131c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801322:	a1 20 50 80 00       	mov    0x805020,%eax
  801327:	8b 50 74             	mov    0x74(%eax),%edx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	39 c2                	cmp    %eax,%edx
  80132f:	74 14                	je     801345 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	68 40 47 80 00       	push   $0x804740
  801339:	6a 26                	push   $0x26
  80133b:	68 8c 47 80 00       	push   $0x80478c
  801340:	e8 65 ff ff ff       	call   8012aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80134c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801353:	e9 c2 00 00 00       	jmp    80141a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	85 c0                	test   %eax,%eax
  80136b:	75 08                	jne    801375 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80136d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801370:	e9 a2 00 00 00       	jmp    801417 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80137c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801383:	eb 69                	jmp    8013ee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801385:	a1 20 50 80 00       	mov    0x805020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 40 04             	mov    0x4(%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	75 46                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8013aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	01 c8                	add    %ecx,%eax
  8013dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013de:	39 c2                	cmp    %eax,%edx
  8013e0:	75 09                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8013e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013e9:	eb 12                	jmp    8013fd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013eb:	ff 45 e8             	incl   -0x18(%ebp)
  8013ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8013f3:	8b 50 74             	mov    0x74(%eax),%edx
  8013f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f9:	39 c2                	cmp    %eax,%edx
  8013fb:	77 88                	ja     801385 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8013fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801401:	75 14                	jne    801417 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 98 47 80 00       	push   $0x804798
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 8c 47 80 00       	push   $0x80478c
  801412:	e8 93 fe ff ff       	call   8012aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801417:	ff 45 f0             	incl   -0x10(%ebp)
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801420:	0f 8c 32 ff ff ff    	jl     801358 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80142d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801434:	eb 26                	jmp    80145c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801436:	a1 20 50 80 00       	mov    0x805020,%eax
  80143b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	01 c0                	add    %eax,%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	c1 e0 03             	shl    $0x3,%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 40 04             	mov    0x4(%eax),%al
  801452:	3c 01                	cmp    $0x1,%al
  801454:	75 03                	jne    801459 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801456:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801459:	ff 45 e0             	incl   -0x20(%ebp)
  80145c:	a1 20 50 80 00       	mov    0x805020,%eax
  801461:	8b 50 74             	mov    0x74(%eax),%edx
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	39 c2                	cmp    %eax,%edx
  801469:	77 cb                	ja     801436 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801471:	74 14                	je     801487 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 ec 47 80 00       	push   $0x8047ec
  80147b:	6a 44                	push   $0x44
  80147d:	68 8c 47 80 00       	push   $0x80478c
  801482:	e8 23 fe ff ff       	call   8012aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801487:	90                   	nop
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 48 01             	lea    0x1(%eax),%ecx
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	89 0a                	mov    %ecx,(%edx)
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	88 d1                	mov    %dl,%cl
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014b3:	75 2c                	jne    8014e1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8014b5:	a0 24 50 80 00       	mov    0x805024,%al
  8014ba:	0f b6 c0             	movzbl %al,%eax
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 12                	mov    (%edx),%edx
  8014c2:	89 d1                	mov    %edx,%ecx
  8014c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c7:	83 c2 08             	add    $0x8,%edx
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	50                   	push   %eax
  8014ce:	51                   	push   %ecx
  8014cf:	52                   	push   %edx
  8014d0:	e8 7c 13 00 00       	call   802851 <sys_cputs>
  8014d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8b 40 04             	mov    0x4(%eax),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801503:	00 00 00 
	b.cnt = 0;
  801506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80150d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	68 8a 14 80 00       	push   $0x80148a
  801522:	e8 11 02 00 00       	call   801738 <vprintfmt>
  801527:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80152a:	a0 24 50 80 00       	mov    0x805024,%al
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	50                   	push   %eax
  80153c:	52                   	push   %edx
  80153d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801543:	83 c0 08             	add    $0x8,%eax
  801546:	50                   	push   %eax
  801547:	e8 05 13 00 00       	call   802851 <sys_cputs>
  80154c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80154f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <cprintf>:

int cprintf(const char *fmt, ...) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801564:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80156b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 f4             	pushl  -0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	e8 73 ff ff ff       	call   8014f3 <vcprintf>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801591:	e8 69 14 00 00       	call   8029ff <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801596:	8d 45 0c             	lea    0xc(%ebp),%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	e8 48 ff ff ff       	call   8014f3 <vcprintf>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8015b1:	e8 63 14 00 00       	call   802a19 <sys_enable_interrupt>
	return cnt;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 14             	sub    $0x14,%esp
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015d9:	77 55                	ja     801630 <printnum+0x75>
  8015db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015de:	72 05                	jb     8015e5 <printnum+0x2a>
  8015e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e3:	77 4b                	ja     801630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8015e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8015ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fb:	e8 80 2a 00 00       	call   804080 <__udivdi3>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	ff 75 20             	pushl  0x20(%ebp)
  801609:	53                   	push   %ebx
  80160a:	ff 75 18             	pushl  0x18(%ebp)
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 a1 ff ff ff       	call   8015bb <printnum>
  80161a:	83 c4 20             	add    $0x20,%esp
  80161d:	eb 1a                	jmp    801639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 20             	pushl  0x20(%ebp)
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	ff d0                	call   *%eax
  80162d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801630:	ff 4d 1c             	decl   0x1c(%ebp)
  801633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801637:	7f e6                	jg     80161f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	53                   	push   %ebx
  801648:	51                   	push   %ecx
  801649:	52                   	push   %edx
  80164a:	50                   	push   %eax
  80164b:	e8 40 2b 00 00       	call   804190 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 54 4a 80 00       	add    $0x804a54,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	50                   	push   %eax
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	ff d0                	call   *%eax
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	90                   	nop
  80166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801679:	7e 1c                	jle    801697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	8d 50 08             	lea    0x8(%eax),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 10                	mov    %edx,(%eax)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	83 e8 08             	sub    $0x8,%eax
  801690:	8b 50 04             	mov    0x4(%eax),%edx
  801693:	8b 00                	mov    (%eax),%eax
  801695:	eb 40                	jmp    8016d7 <getuint+0x65>
	else if (lflag)
  801697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169b:	74 1e                	je     8016bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	89 10                	mov    %edx,(%eax)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	83 e8 04             	sub    $0x4,%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	eb 1c                	jmp    8016d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	8d 50 04             	lea    0x4(%eax),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 10                	mov    %edx,(%eax)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 e8 04             	sub    $0x4,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e0:	7e 1c                	jle    8016fe <getint+0x25>
		return va_arg(*ap, long long);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	8d 50 08             	lea    0x8(%eax),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 10                	mov    %edx,(%eax)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 e8 08             	sub    $0x8,%eax
  8016f7:	8b 50 04             	mov    0x4(%eax),%edx
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	eb 38                	jmp    801736 <getint+0x5d>
	else if (lflag)
  8016fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801702:	74 1a                	je     80171e <getint+0x45>
		return va_arg(*ap, long);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	8d 50 04             	lea    0x4(%eax),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	89 10                	mov    %edx,(%eax)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	83 e8 04             	sub    $0x4,%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	99                   	cltd   
  80171c:	eb 18                	jmp    801736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	8d 50 04             	lea    0x4(%eax),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 10                	mov    %edx,(%eax)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	83 e8 04             	sub    $0x4,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	99                   	cltd   
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801740:	eb 17                	jmp    801759 <vprintfmt+0x21>
			if (ch == '\0')
  801742:	85 db                	test   %ebx,%ebx
  801744:	0f 84 af 03 00 00    	je     801af9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	53                   	push   %ebx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	ff d0                	call   *%eax
  801756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	8d 50 01             	lea    0x1(%eax),%edx
  80175f:	89 55 10             	mov    %edx,0x10(%ebp)
  801762:	8a 00                	mov    (%eax),%al
  801764:	0f b6 d8             	movzbl %al,%ebx
  801767:	83 fb 25             	cmp    $0x25,%ebx
  80176a:	75 d6                	jne    801742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80176c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80177e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 10             	mov    %edx,0x10(%ebp)
  801795:	8a 00                	mov    (%eax),%al
  801797:	0f b6 d8             	movzbl %al,%ebx
  80179a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80179d:	83 f8 55             	cmp    $0x55,%eax
  8017a0:	0f 87 2b 03 00 00    	ja     801ad1 <vprintfmt+0x399>
  8017a6:	8b 04 85 78 4a 80 00 	mov    0x804a78(,%eax,4),%eax
  8017ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8017af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8017b3:	eb d7                	jmp    80178c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8017b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8017b9:	eb d1                	jmp    80178c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8017c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	01 c0                	add    %eax,%eax
  8017ce:	01 d8                	add    %ebx,%eax
  8017d0:	83 e8 30             	sub    $0x30,%eax
  8017d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8017de:	83 fb 2f             	cmp    $0x2f,%ebx
  8017e1:	7e 3e                	jle    801821 <vprintfmt+0xe9>
  8017e3:	83 fb 39             	cmp    $0x39,%ebx
  8017e6:	7f 39                	jg     801821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8017eb:	eb d5                	jmp    8017c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	83 c0 04             	add    $0x4,%eax
  8017f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f9:	83 e8 04             	sub    $0x4,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801801:	eb 1f                	jmp    801822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801807:	79 83                	jns    80178c <vprintfmt+0x54>
				width = 0;
  801809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801810:	e9 77 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80181c:	e9 6b ff ff ff       	jmp    80178c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801826:	0f 89 60 ff ff ff    	jns    80178c <vprintfmt+0x54>
				width = precision, precision = -1;
  80182c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801839:	e9 4e ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80183e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801841:	e9 46 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	83 c0 04             	add    $0x4,%eax
  80184c:	89 45 14             	mov    %eax,0x14(%ebp)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	83 e8 04             	sub    $0x4,%eax
  801855:	8b 00                	mov    (%eax),%eax
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	ff d0                	call   *%eax
  801863:	83 c4 10             	add    $0x10,%esp
			break;
  801866:	e9 89 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80186b:	8b 45 14             	mov    0x14(%ebp),%eax
  80186e:	83 c0 04             	add    $0x4,%eax
  801871:	89 45 14             	mov    %eax,0x14(%ebp)
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	83 e8 04             	sub    $0x4,%eax
  80187a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80187c:	85 db                	test   %ebx,%ebx
  80187e:	79 02                	jns    801882 <vprintfmt+0x14a>
				err = -err;
  801880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801882:	83 fb 64             	cmp    $0x64,%ebx
  801885:	7f 0b                	jg     801892 <vprintfmt+0x15a>
  801887:	8b 34 9d c0 48 80 00 	mov    0x8048c0(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 65 4a 80 00       	push   $0x804a65
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	e8 5e 02 00 00       	call   801b01 <printfmt>
  8018a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8018a6:	e9 49 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8018ab:	56                   	push   %esi
  8018ac:	68 6e 4a 80 00       	push   $0x804a6e
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 45 02 00 00       	call   801b01 <printfmt>
  8018bc:	83 c4 10             	add    $0x10,%esp
			break;
  8018bf:	e9 30 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8018c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c7:	83 c0 04             	add    $0x4,%eax
  8018ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8018cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d0:	83 e8 04             	sub    $0x4,%eax
  8018d3:	8b 30                	mov    (%eax),%esi
  8018d5:	85 f6                	test   %esi,%esi
  8018d7:	75 05                	jne    8018de <vprintfmt+0x1a6>
				p = "(null)";
  8018d9:	be 71 4a 80 00       	mov    $0x804a71,%esi
			if (width > 0 && padc != '-')
  8018de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e2:	7e 6d                	jle    801951 <vprintfmt+0x219>
  8018e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8018e8:	74 67                	je     801951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	50                   	push   %eax
  8018f1:	56                   	push   %esi
  8018f2:	e8 0c 03 00 00       	call   801c03 <strnlen>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018fd:	eb 16                	jmp    801915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	50                   	push   %eax
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	ff d0                	call   *%eax
  80190f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801912:	ff 4d e4             	decl   -0x1c(%ebp)
  801915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801919:	7f e4                	jg     8018ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80191b:	eb 34                	jmp    801951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80191d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801921:	74 1c                	je     80193f <vprintfmt+0x207>
  801923:	83 fb 1f             	cmp    $0x1f,%ebx
  801926:	7e 05                	jle    80192d <vprintfmt+0x1f5>
  801928:	83 fb 7e             	cmp    $0x7e,%ebx
  80192b:	7e 12                	jle    80193f <vprintfmt+0x207>
					putch('?', putdat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	6a 3f                	push   $0x3f
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	ff d0                	call   *%eax
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	eb 0f                	jmp    80194e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	53                   	push   %ebx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	ff d0                	call   *%eax
  80194b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80194e:	ff 4d e4             	decl   -0x1c(%ebp)
  801951:	89 f0                	mov    %esi,%eax
  801953:	8d 70 01             	lea    0x1(%eax),%esi
  801956:	8a 00                	mov    (%eax),%al
  801958:	0f be d8             	movsbl %al,%ebx
  80195b:	85 db                	test   %ebx,%ebx
  80195d:	74 24                	je     801983 <vprintfmt+0x24b>
  80195f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801963:	78 b8                	js     80191d <vprintfmt+0x1e5>
  801965:	ff 4d e0             	decl   -0x20(%ebp)
  801968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80196c:	79 af                	jns    80191d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80196e:	eb 13                	jmp    801983 <vprintfmt+0x24b>
				putch(' ', putdat);
  801970:	83 ec 08             	sub    $0x8,%esp
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	6a 20                	push   $0x20
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	ff d0                	call   *%eax
  80197d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801980:	ff 4d e4             	decl   -0x1c(%ebp)
  801983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801987:	7f e7                	jg     801970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801989:	e9 66 01 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	8d 45 14             	lea    0x14(%ebp),%eax
  801997:	50                   	push   %eax
  801998:	e8 3c fd ff ff       	call   8016d9 <getint>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ac:	85 d2                	test   %edx,%edx
  8019ae:	79 23                	jns    8019d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	6a 2d                	push   $0x2d
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	ff d0                	call   *%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	f7 d8                	neg    %eax
  8019c8:	83 d2 00             	adc    $0x0,%edx
  8019cb:	f7 da                	neg    %edx
  8019cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8019d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019da:	e9 bc 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	e8 84 fc ff ff       	call   801672 <getuint>
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8019f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019fe:	e9 98 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	6a 58                	push   $0x58
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	ff d0                	call   *%eax
  801a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	6a 58                	push   $0x58
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	ff d0                	call   *%eax
  801a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	6a 58                	push   $0x58
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
			break;
  801a33:	e9 bc 00 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	6a 30                	push   $0x30
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	ff d0                	call   *%eax
  801a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	6a 78                	push   $0x78
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff d0                	call   *%eax
  801a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	83 c0 04             	add    $0x4,%eax
  801a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	83 e8 04             	sub    $0x4,%eax
  801a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a7a:	eb 1f                	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  801a82:	8d 45 14             	lea    0x14(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 e7 fb ff ff       	call   801672 <getuint>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	52                   	push   %edx
  801aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801aad:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	e8 00 fb ff ff       	call   8015bb <printnum>
  801abb:	83 c4 20             	add    $0x20,%esp
			break;
  801abe:	eb 34                	jmp    801af4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	53                   	push   %ebx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	ff d0                	call   *%eax
  801acc:	83 c4 10             	add    $0x10,%esp
			break;
  801acf:	eb 23                	jmp    801af4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	6a 25                	push   $0x25
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	ff d0                	call   *%eax
  801ade:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ae1:	ff 4d 10             	decl   0x10(%ebp)
  801ae4:	eb 03                	jmp    801ae9 <vprintfmt+0x3b1>
  801ae6:	ff 4d 10             	decl   0x10(%ebp)
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	48                   	dec    %eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 25                	cmp    $0x25,%al
  801af1:	75 f3                	jne    801ae6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801af3:	90                   	nop
		}
	}
  801af4:	e9 47 fc ff ff       	jmp    801740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801af9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b07:	8d 45 10             	lea    0x10(%ebp),%eax
  801b0a:	83 c0 04             	add    $0x4,%eax
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b10:	8b 45 10             	mov    0x10(%ebp),%eax
  801b13:	ff 75 f4             	pushl  -0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 16 fc ff ff       	call   801738 <vprintfmt>
  801b22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	8b 40 08             	mov    0x8(%eax),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	8b 10                	mov    (%eax),%edx
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	8b 40 04             	mov    0x4(%eax),%eax
  801b45:	39 c2                	cmp    %eax,%edx
  801b47:	73 12                	jae    801b5b <sprintputch+0x33>
		*b->buf++ = ch;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	8b 00                	mov    (%eax),%eax
  801b4e:	8d 48 01             	lea    0x1(%eax),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	89 0a                	mov    %ecx,(%edx)
  801b56:	8b 55 08             	mov    0x8(%ebp),%edx
  801b59:	88 10                	mov    %dl,(%eax)
}
  801b5b:	90                   	nop
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	01 d0                	add    %edx,%eax
  801b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b83:	74 06                	je     801b8b <vsnprintf+0x2d>
  801b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b89:	7f 07                	jg     801b92 <vsnprintf+0x34>
		return -E_INVAL;
  801b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  801b90:	eb 20                	jmp    801bb2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	68 28 1b 80 00       	push   $0x801b28
  801ba1:	e8 92 fb ff ff       	call   801738 <vprintfmt>
  801ba6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bba:	8d 45 10             	lea    0x10(%ebp),%eax
  801bbd:	83 c0 04             	add    $0x4,%eax
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 89 ff ff ff       	call   801b5e <vsnprintf>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801be6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bed:	eb 06                	jmp    801bf5 <strlen+0x15>
		n++;
  801bef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801bf2:	ff 45 08             	incl   0x8(%ebp)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8a 00                	mov    (%eax),%al
  801bfa:	84 c0                	test   %al,%al
  801bfc:	75 f1                	jne    801bef <strlen+0xf>
		n++;
	return n;
  801bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c10:	eb 09                	jmp    801c1b <strnlen+0x18>
		n++;
  801c12:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c15:	ff 45 08             	incl   0x8(%ebp)
  801c18:	ff 4d 0c             	decl   0xc(%ebp)
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	74 09                	je     801c2a <strnlen+0x27>
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	84 c0                	test   %al,%al
  801c28:	75 e8                	jne    801c12 <strnlen+0xf>
		n++;
	return n;
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801c3b:	90                   	nop
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8d 50 01             	lea    0x1(%eax),%edx
  801c42:	89 55 08             	mov    %edx,0x8(%ebp)
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c4e:	8a 12                	mov    (%edx),%dl
  801c50:	88 10                	mov    %dl,(%eax)
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	84 c0                	test   %al,%al
  801c56:	75 e4                	jne    801c3c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c70:	eb 1f                	jmp    801c91 <strncpy+0x34>
		*dst++ = *src;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8d 50 01             	lea    0x1(%eax),%edx
  801c78:	89 55 08             	mov    %edx,0x8(%ebp)
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8a 12                	mov    (%edx),%dl
  801c80:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	84 c0                	test   %al,%al
  801c89:	74 03                	je     801c8e <strncpy+0x31>
			src++;
  801c8b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8e:	ff 45 fc             	incl   -0x4(%ebp)
  801c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c94:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c97:	72 d9                	jb     801c72 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cae:	74 30                	je     801ce0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801cb0:	eb 16                	jmp    801cc8 <strlcpy+0x2a>
			*dst++ = *src++;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8d 50 01             	lea    0x1(%eax),%edx
  801cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cc4:	8a 12                	mov    (%edx),%dl
  801cc6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801cc8:	ff 4d 10             	decl   0x10(%ebp)
  801ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccf:	74 09                	je     801cda <strlcpy+0x3c>
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	84 c0                	test   %al,%al
  801cd8:	75 d8                	jne    801cb2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce6:	29 c2                	sub    %eax,%edx
  801ce8:	89 d0                	mov    %edx,%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801cef:	eb 06                	jmp    801cf7 <strcmp+0xb>
		p++, q++;
  801cf1:	ff 45 08             	incl   0x8(%ebp)
  801cf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	74 0e                	je     801d0e <strcmp+0x22>
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	8a 10                	mov    (%eax),%dl
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	38 c2                	cmp    %al,%dl
  801d0c:	74 e3                	je     801cf1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8a 00                	mov    (%eax),%al
  801d13:	0f b6 d0             	movzbl %al,%edx
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	8a 00                	mov    (%eax),%al
  801d1b:	0f b6 c0             	movzbl %al,%eax
  801d1e:	29 c2                	sub    %eax,%edx
  801d20:	89 d0                	mov    %edx,%eax
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801d27:	eb 09                	jmp    801d32 <strncmp+0xe>
		n--, p++, q++;
  801d29:	ff 4d 10             	decl   0x10(%ebp)
  801d2c:	ff 45 08             	incl   0x8(%ebp)
  801d2f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d36:	74 17                	je     801d4f <strncmp+0x2b>
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	84 c0                	test   %al,%al
  801d3f:	74 0e                	je     801d4f <strncmp+0x2b>
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 10                	mov    (%eax),%dl
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	8a 00                	mov    (%eax),%al
  801d4b:	38 c2                	cmp    %al,%dl
  801d4d:	74 da                	je     801d29 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d53:	75 07                	jne    801d5c <strncmp+0x38>
		return 0;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	eb 14                	jmp    801d70 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	8a 00                	mov    (%eax),%al
  801d61:	0f b6 d0             	movzbl %al,%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	0f b6 c0             	movzbl %al,%eax
  801d6c:	29 c2                	sub    %eax,%edx
  801d6e:	89 d0                	mov    %edx,%eax
}
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d7e:	eb 12                	jmp    801d92 <strchr+0x20>
		if (*s == c)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8a 00                	mov    (%eax),%al
  801d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d88:	75 05                	jne    801d8f <strchr+0x1d>
			return (char *) s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	eb 11                	jmp    801da0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d8f:	ff 45 08             	incl   0x8(%ebp)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	84 c0                	test   %al,%al
  801d99:	75 e5                	jne    801d80 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dae:	eb 0d                	jmp    801dbd <strfind+0x1b>
		if (*s == c)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8a 00                	mov    (%eax),%al
  801db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801db8:	74 0e                	je     801dc8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dba:	ff 45 08             	incl   0x8(%ebp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	84 c0                	test   %al,%al
  801dc4:	75 ea                	jne    801db0 <strfind+0xe>
  801dc6:	eb 01                	jmp    801dc9 <strfind+0x27>
		if (*s == c)
			break;
  801dc8:	90                   	nop
	return (char *) s;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801de0:	eb 0e                	jmp    801df0 <memset+0x22>
		*p++ = c;
  801de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de5:	8d 50 01             	lea    0x1(%eax),%edx
  801de8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801df0:	ff 4d f8             	decl   -0x8(%ebp)
  801df3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801df7:	79 e9                	jns    801de2 <memset+0x14>
		*p++ = c;

	return v;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801e10:	eb 16                	jmp    801e28 <memcpy+0x2a>
		*d++ = *s++;
  801e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e15:	8d 50 01             	lea    0x1(%eax),%edx
  801e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e24:	8a 12                	mov    (%edx),%dl
  801e26:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801e28:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 dd                	jne    801e12 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e52:	73 50                	jae    801ea4 <memmove+0x6a>
  801e54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e57:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5a:	01 d0                	add    %edx,%eax
  801e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e5f:	76 43                	jbe    801ea4 <memmove+0x6a>
		s += n;
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e6d:	eb 10                	jmp    801e7f <memmove+0x45>
			*--d = *--s;
  801e6f:	ff 4d f8             	decl   -0x8(%ebp)
  801e72:	ff 4d fc             	decl   -0x4(%ebp)
  801e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e78:	8a 10                	mov    (%eax),%dl
  801e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e85:	89 55 10             	mov    %edx,0x10(%ebp)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 e3                	jne    801e6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e8c:	eb 23                	jmp    801eb1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e91:	8d 50 01             	lea    0x1(%eax),%edx
  801e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ea0:	8a 12                	mov    (%edx),%dl
  801ea2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	75 dd                	jne    801e8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ec8:	eb 2a                	jmp    801ef4 <memcmp+0x3e>
		if (*s1 != *s2)
  801eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecd:	8a 10                	mov    (%eax),%dl
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	38 c2                	cmp    %al,%dl
  801ed6:	74 16                	je     801eee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	0f b6 d0             	movzbl %al,%edx
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee3:	8a 00                	mov    (%eax),%al
  801ee5:	0f b6 c0             	movzbl %al,%eax
  801ee8:	29 c2                	sub    %eax,%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	eb 18                	jmp    801f06 <memcmp+0x50>
		s1++, s2++;
  801eee:	ff 45 fc             	incl   -0x4(%ebp)
  801ef1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801efa:	89 55 10             	mov    %edx,0x10(%ebp)
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 c9                	jne    801eca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801f19:	eb 15                	jmp    801f30 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	0f b6 d0             	movzbl %al,%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	0f b6 c0             	movzbl %al,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	74 0d                	je     801f3a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f2d:	ff 45 08             	incl   0x8(%ebp)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f36:	72 e3                	jb     801f1b <memfind+0x13>
  801f38:	eb 01                	jmp    801f3b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801f3a:	90                   	nop
	return (void *) s;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f54:	eb 03                	jmp    801f59 <strtol+0x19>
		s++;
  801f56:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8a 00                	mov    (%eax),%al
  801f5e:	3c 20                	cmp    $0x20,%al
  801f60:	74 f4                	je     801f56 <strtol+0x16>
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8a 00                	mov    (%eax),%al
  801f67:	3c 09                	cmp    $0x9,%al
  801f69:	74 eb                	je     801f56 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	3c 2b                	cmp    $0x2b,%al
  801f72:	75 05                	jne    801f79 <strtol+0x39>
		s++;
  801f74:	ff 45 08             	incl   0x8(%ebp)
  801f77:	eb 13                	jmp    801f8c <strtol+0x4c>
	else if (*s == '-')
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8a 00                	mov    (%eax),%al
  801f7e:	3c 2d                	cmp    $0x2d,%al
  801f80:	75 0a                	jne    801f8c <strtol+0x4c>
		s++, neg = 1;
  801f82:	ff 45 08             	incl   0x8(%ebp)
  801f85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f90:	74 06                	je     801f98 <strtol+0x58>
  801f92:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f96:	75 20                	jne    801fb8 <strtol+0x78>
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8a 00                	mov    (%eax),%al
  801f9d:	3c 30                	cmp    $0x30,%al
  801f9f:	75 17                	jne    801fb8 <strtol+0x78>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	40                   	inc    %eax
  801fa5:	8a 00                	mov    (%eax),%al
  801fa7:	3c 78                	cmp    $0x78,%al
  801fa9:	75 0d                	jne    801fb8 <strtol+0x78>
		s += 2, base = 16;
  801fab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801faf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801fb6:	eb 28                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fbc:	75 15                	jne    801fd3 <strtol+0x93>
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8a 00                	mov    (%eax),%al
  801fc3:	3c 30                	cmp    $0x30,%al
  801fc5:	75 0c                	jne    801fd3 <strtol+0x93>
		s++, base = 8;
  801fc7:	ff 45 08             	incl   0x8(%ebp)
  801fca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801fd1:	eb 0d                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0)
  801fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd7:	75 07                	jne    801fe0 <strtol+0xa0>
		base = 10;
  801fd9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	3c 2f                	cmp    $0x2f,%al
  801fe7:	7e 19                	jle    802002 <strtol+0xc2>
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	8a 00                	mov    (%eax),%al
  801fee:	3c 39                	cmp    $0x39,%al
  801ff0:	7f 10                	jg     802002 <strtol+0xc2>
			dig = *s - '0';
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8a 00                	mov    (%eax),%al
  801ff7:	0f be c0             	movsbl %al,%eax
  801ffa:	83 e8 30             	sub    $0x30,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 42                	jmp    802044 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8a 00                	mov    (%eax),%al
  802007:	3c 60                	cmp    $0x60,%al
  802009:	7e 19                	jle    802024 <strtol+0xe4>
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	3c 7a                	cmp    $0x7a,%al
  802012:	7f 10                	jg     802024 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8a 00                	mov    (%eax),%al
  802019:	0f be c0             	movsbl %al,%eax
  80201c:	83 e8 57             	sub    $0x57,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	eb 20                	jmp    802044 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 00                	mov    (%eax),%al
  802029:	3c 40                	cmp    $0x40,%al
  80202b:	7e 39                	jle    802066 <strtol+0x126>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	3c 5a                	cmp    $0x5a,%al
  802034:	7f 30                	jg     802066 <strtol+0x126>
			dig = *s - 'A' + 10;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f be c0             	movsbl %al,%eax
  80203e:	83 e8 37             	sub    $0x37,%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	3b 45 10             	cmp    0x10(%ebp),%eax
  80204a:	7d 19                	jge    802065 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80204c:	ff 45 08             	incl   0x8(%ebp)
  80204f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802052:	0f af 45 10          	imul   0x10(%ebp),%eax
  802056:	89 c2                	mov    %eax,%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802060:	e9 7b ff ff ff       	jmp    801fe0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802065:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206a:	74 08                	je     802074 <strtol+0x134>
		*endptr = (char *) s;
  80206c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802074:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802078:	74 07                	je     802081 <strtol+0x141>
  80207a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207d:	f7 d8                	neg    %eax
  80207f:	eb 03                	jmp    802084 <strtol+0x144>
  802081:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <ltostr>:

void
ltostr(long value, char *str)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80208c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802093:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	79 13                	jns    8020b3 <ltostr+0x2d>
	{
		neg = 1;
  8020a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8020ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8020b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020bb:	99                   	cltd   
  8020bc:	f7 f9                	idiv   %ecx
  8020be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8020c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c4:	8d 50 01             	lea    0x1(%eax),%edx
  8020c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020ca:	89 c2                	mov    %eax,%edx
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020d4:	83 c2 30             	add    $0x30,%edx
  8020d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020e1:	f7 e9                	imul   %ecx
  8020e3:	c1 fa 02             	sar    $0x2,%edx
  8020e6:	89 c8                	mov    %ecx,%eax
  8020e8:	c1 f8 1f             	sar    $0x1f,%eax
  8020eb:	29 c2                	sub    %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020fa:	f7 e9                	imul   %ecx
  8020fc:	c1 fa 02             	sar    $0x2,%edx
  8020ff:	89 c8                	mov    %ecx,%eax
  802101:	c1 f8 1f             	sar    $0x1f,%eax
  802104:	29 c2                	sub    %eax,%edx
  802106:	89 d0                	mov    %edx,%eax
  802108:	c1 e0 02             	shl    $0x2,%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	01 c0                	add    %eax,%eax
  80210f:	29 c1                	sub    %eax,%ecx
  802111:	89 ca                	mov    %ecx,%edx
  802113:	85 d2                	test   %edx,%edx
  802115:	75 9c                	jne    8020b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80211e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802121:	48                   	dec    %eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	74 3d                	je     802168 <ltostr+0xe2>
		start = 1 ;
  80212b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802132:	eb 34                	jmp    802168 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	8a 00                	mov    (%eax),%al
  80213e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	01 c2                	add    %eax,%edx
  802149:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	01 c8                	add    %ecx,%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	01 c2                	add    %eax,%edx
  80215d:	8a 45 eb             	mov    -0x15(%ebp),%al
  802160:	88 02                	mov    %al,(%edx)
		start++ ;
  802162:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802165:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216e:	7c c4                	jl     802134 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802170:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 54 fa ff ff       	call   801be0 <strlen>
  80218c:	83 c4 04             	add    $0x4,%esp
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	e8 46 fa ff ff       	call   801be0 <strlen>
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8021a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8021a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021ae:	eb 17                	jmp    8021c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8021b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b6:	01 c2                	add    %eax,%edx
  8021b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8021c4:	ff 45 fc             	incl   -0x4(%ebp)
  8021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021cd:	7c e1                	jl     8021b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8021cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8021d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8021dd:	eb 1f                	jmp    8021fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8d 50 01             	lea    0x1(%eax),%edx
  8021e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	01 c2                	add    %eax,%edx
  8021ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f5:	01 c8                	add    %ecx,%eax
  8021f7:	8a 00                	mov    (%eax),%al
  8021f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8021fb:	ff 45 f8             	incl   -0x8(%ebp)
  8021fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802201:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802204:	7c d9                	jl     8021df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c6 00 00             	movb   $0x0,(%eax)
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802217:	8b 45 14             	mov    0x14(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802220:	8b 45 14             	mov    0x14(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	01 d0                	add    %edx,%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802237:	eb 0c                	jmp    802245 <strsplit+0x31>
			*string++ = 0;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8d 50 01             	lea    0x1(%eax),%edx
  80223f:	89 55 08             	mov    %edx,0x8(%ebp)
  802242:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8a 00                	mov    (%eax),%al
  80224a:	84 c0                	test   %al,%al
  80224c:	74 18                	je     802266 <strsplit+0x52>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8a 00                	mov    (%eax),%al
  802253:	0f be c0             	movsbl %al,%eax
  802256:	50                   	push   %eax
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	e8 13 fb ff ff       	call   801d72 <strchr>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	75 d3                	jne    802239 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8a 00                	mov    (%eax),%al
  80226b:	84 c0                	test   %al,%al
  80226d:	74 5a                	je     8022c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80226f:	8b 45 14             	mov    0x14(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	83 f8 0f             	cmp    $0xf,%eax
  802277:	75 07                	jne    802280 <strsplit+0x6c>
		{
			return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 66                	jmp    8022e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802280:	8b 45 14             	mov    0x14(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8d 48 01             	lea    0x1(%eax),%ecx
  802288:	8b 55 14             	mov    0x14(%ebp),%edx
  80228b:	89 0a                	mov    %ecx,(%edx)
  80228d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	01 c2                	add    %eax,%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80229e:	eb 03                	jmp    8022a3 <strsplit+0x8f>
			string++;
  8022a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	84 c0                	test   %al,%al
  8022aa:	74 8b                	je     802237 <strsplit+0x23>
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8a 00                	mov    (%eax),%al
  8022b1:	0f be c0             	movsbl %al,%eax
  8022b4:	50                   	push   %eax
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	e8 b5 fa ff ff       	call   801d72 <strchr>
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 dc                	je     8022a0 <strsplit+0x8c>
			string++;
	}
  8022c4:	e9 6e ff ff ff       	jmp    802237 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8022c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8022ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8022ee:	a1 04 50 80 00       	mov    0x805004,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 1f                	je     802316 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8022f7:	e8 1d 00 00 00       	call   802319 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 d0 4b 80 00       	push   $0x804bd0
  802304:	e8 55 f2 ff ff       	call   80155e <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80230c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802313:	00 00 00 
	}
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80231f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802326:	00 00 00 
  802329:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802330:	00 00 00 
  802333:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80233a:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  80233d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802344:	00 00 00 
  802347:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80234e:	00 00 00 
  802351:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802358:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80235b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802362:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  802365:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80236c:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80237b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802380:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  802385:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80238c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802394:	2d 00 10 00 00       	sub    $0x1000,%eax
  802399:	83 ec 04             	sub    $0x4,%esp
  80239c:	6a 06                	push   $0x6
  80239e:	ff 75 f4             	pushl  -0xc(%ebp)
  8023a1:	50                   	push   %eax
  8023a2:	e8 ee 05 00 00       	call   802995 <sys_allocate_chunk>
  8023a7:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023aa:	a1 20 51 80 00       	mov    0x805120,%eax
  8023af:	83 ec 0c             	sub    $0xc,%esp
  8023b2:	50                   	push   %eax
  8023b3:	e8 63 0c 00 00       	call   80301b <initialize_MemBlocksList>
  8023b8:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  8023bb:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8023c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  8023c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  8023cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023de:	89 c2                	mov    %eax,%edx
  8023e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e3:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  8023e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e9:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  8023f0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8023f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023fa:	8b 50 08             	mov    0x8(%eax),%edx
  8023fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802400:	01 d0                	add    %edx,%eax
  802402:	48                   	dec    %eax
  802403:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802406:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802409:	ba 00 00 00 00       	mov    $0x0,%edx
  80240e:	f7 75 e0             	divl   -0x20(%ebp)
  802411:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802414:	29 d0                	sub    %edx,%eax
  802416:	89 c2                	mov    %eax,%edx
  802418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80241b:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80241e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802422:	75 14                	jne    802438 <initialize_dyn_block_system+0x11f>
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	68 f5 4b 80 00       	push   $0x804bf5
  80242c:	6a 34                	push   $0x34
  80242e:	68 13 4c 80 00       	push   $0x804c13
  802433:	e8 72 ee ff ff       	call   8012aa <_panic>
  802438:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	85 c0                	test   %eax,%eax
  80243f:	74 10                	je     802451 <initialize_dyn_block_system+0x138>
  802441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802444:	8b 00                	mov    (%eax),%eax
  802446:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802449:	8b 52 04             	mov    0x4(%edx),%edx
  80244c:	89 50 04             	mov    %edx,0x4(%eax)
  80244f:	eb 0b                	jmp    80245c <initialize_dyn_block_system+0x143>
  802451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802454:	8b 40 04             	mov    0x4(%eax),%eax
  802457:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80245c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	85 c0                	test   %eax,%eax
  802464:	74 0f                	je     802475 <initialize_dyn_block_system+0x15c>
  802466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802469:	8b 40 04             	mov    0x4(%eax),%eax
  80246c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80246f:	8b 12                	mov    (%edx),%edx
  802471:	89 10                	mov    %edx,(%eax)
  802473:	eb 0a                	jmp    80247f <initialize_dyn_block_system+0x166>
  802475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	a3 48 51 80 00       	mov    %eax,0x805148
  80247f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80248b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802492:	a1 54 51 80 00       	mov    0x805154,%eax
  802497:	48                   	dec    %eax
  802498:	a3 54 51 80 00       	mov    %eax,0x805154
			insert_sorted_with_merge_freeList(freeSva);
  80249d:	83 ec 0c             	sub    $0xc,%esp
  8024a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8024a3:	e8 c4 13 00 00       	call   80386c <insert_sorted_with_merge_freeList>
  8024a8:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8024ab:	90                   	nop
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <malloc>:
//=================================



void* malloc(uint32 size)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8024b4:	e8 2f fe ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8024b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024bd:	75 07                	jne    8024c6 <malloc+0x18>
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c4:	eb 71                	jmp    802537 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8024c6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8024cd:	76 07                	jbe    8024d6 <malloc+0x28>
	return NULL;
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	eb 61                	jmp    802537 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8024d6:	e8 88 08 00 00       	call   802d63 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	74 53                	je     802532 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8024df:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8024e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	01 d0                	add    %edx,%eax
  8024ee:	48                   	dec    %eax
  8024ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8024f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fa:	f7 75 f4             	divl   -0xc(%ebp)
  8024fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802500:	29 d0                	sub    %edx,%eax
  802502:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  802505:	83 ec 0c             	sub    $0xc,%esp
  802508:	ff 75 ec             	pushl  -0x14(%ebp)
  80250b:	e8 d2 0d 00 00       	call   8032e2 <alloc_block_FF>
  802510:	83 c4 10             	add    $0x10,%esp
  802513:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  802516:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80251a:	74 16                	je     802532 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  80251c:	83 ec 0c             	sub    $0xc,%esp
  80251f:	ff 75 e8             	pushl  -0x18(%ebp)
  802522:	e8 0c 0c 00 00       	call   803133 <insert_sorted_allocList>
  802527:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  80252a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80252d:	8b 40 08             	mov    0x8(%eax),%eax
  802530:	eb 05                	jmp    802537 <malloc+0x89>
    }

			}


	return NULL;
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
  80253c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80254d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  802550:	83 ec 08             	sub    $0x8,%esp
  802553:	ff 75 f0             	pushl  -0x10(%ebp)
  802556:	68 40 50 80 00       	push   $0x805040
  80255b:	e8 a0 0b 00 00       	call   803100 <find_block>
  802560:	83 c4 10             	add    $0x10,%esp
  802563:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  802566:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802569:	8b 50 0c             	mov    0xc(%eax),%edx
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	83 ec 08             	sub    $0x8,%esp
  802572:	52                   	push   %edx
  802573:	50                   	push   %eax
  802574:	e8 e4 03 00 00       	call   80295d <sys_free_user_mem>
  802579:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  80257c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802580:	75 17                	jne    802599 <free+0x60>
  802582:	83 ec 04             	sub    $0x4,%esp
  802585:	68 f5 4b 80 00       	push   $0x804bf5
  80258a:	68 84 00 00 00       	push   $0x84
  80258f:	68 13 4c 80 00       	push   $0x804c13
  802594:	e8 11 ed ff ff       	call   8012aa <_panic>
  802599:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	74 10                	je     8025b2 <free+0x79>
  8025a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a5:	8b 00                	mov    (%eax),%eax
  8025a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025aa:	8b 52 04             	mov    0x4(%edx),%edx
  8025ad:	89 50 04             	mov    %edx,0x4(%eax)
  8025b0:	eb 0b                	jmp    8025bd <free+0x84>
  8025b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	a3 44 50 80 00       	mov    %eax,0x805044
  8025bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c0:	8b 40 04             	mov    0x4(%eax),%eax
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	74 0f                	je     8025d6 <free+0x9d>
  8025c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d0:	8b 12                	mov    (%edx),%edx
  8025d2:	89 10                	mov    %edx,(%eax)
  8025d4:	eb 0a                	jmp    8025e0 <free+0xa7>
  8025d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d9:	8b 00                	mov    (%eax),%eax
  8025db:	a3 40 50 80 00       	mov    %eax,0x805040
  8025e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025f8:	48                   	dec    %eax
  8025f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(returned_block);
  8025fe:	83 ec 0c             	sub    $0xc,%esp
  802601:	ff 75 ec             	pushl  -0x14(%ebp)
  802604:	e8 63 12 00 00       	call   80386c <insert_sorted_with_merge_freeList>
  802609:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80260c:	90                   	nop
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	83 ec 38             	sub    $0x38,%esp
  802615:	8b 45 10             	mov    0x10(%ebp),%eax
  802618:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80261b:	e8 c8 fc ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802620:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802624:	75 0a                	jne    802630 <smalloc+0x21>
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
  80262b:	e9 a0 00 00 00       	jmp    8026d0 <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  802630:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  802637:	76 0a                	jbe    802643 <smalloc+0x34>
		return NULL;
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
  80263e:	e9 8d 00 00 00       	jmp    8026d0 <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802643:	e8 1b 07 00 00       	call   802d63 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802648:	85 c0                	test   %eax,%eax
  80264a:	74 7f                	je     8026cb <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80264c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802653:	8b 55 0c             	mov    0xc(%ebp),%edx
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	01 d0                	add    %edx,%eax
  80265b:	48                   	dec    %eax
  80265c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	ba 00 00 00 00       	mov    $0x0,%edx
  802667:	f7 75 f4             	divl   -0xc(%ebp)
  80266a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266d:	29 d0                	sub    %edx,%eax
  80266f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	ff 75 ec             	pushl  -0x14(%ebp)
  802678:	e8 65 0c 00 00       	call   8032e2 <alloc_block_FF>
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  802683:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802687:	74 42                	je     8026cb <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  802689:	83 ec 0c             	sub    $0xc,%esp
  80268c:	ff 75 e8             	pushl  -0x18(%ebp)
  80268f:	e8 9f 0a 00 00       	call   803133 <insert_sorted_allocList>
  802694:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  802697:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269a:	8b 40 08             	mov    0x8(%eax),%eax
  80269d:	89 c2                	mov    %eax,%edx
  80269f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8026a3:	52                   	push   %edx
  8026a4:	50                   	push   %eax
  8026a5:	ff 75 0c             	pushl  0xc(%ebp)
  8026a8:	ff 75 08             	pushl  0x8(%ebp)
  8026ab:	e8 38 04 00 00       	call   802ae8 <sys_createSharedObject>
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  8026b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026ba:	79 07                	jns    8026c3 <smalloc+0xb4>
	    		  return NULL;
  8026bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c1:	eb 0d                	jmp    8026d0 <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  8026c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c6:	8b 40 08             	mov    0x8(%eax),%eax
  8026c9:	eb 05                	jmp    8026d0 <smalloc+0xc1>


				}


		return NULL;
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    

008026d2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8026d8:	e8 0b fc ff ff       	call   8022e8 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8026dd:	e8 81 06 00 00       	call   802d63 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	0f 84 9f 00 00 00    	je     802789 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8026ea:	83 ec 08             	sub    $0x8,%esp
  8026ed:	ff 75 0c             	pushl  0xc(%ebp)
  8026f0:	ff 75 08             	pushl  0x8(%ebp)
  8026f3:	e8 1a 04 00 00       	call   802b12 <sys_getSizeOfSharedObject>
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  8026fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802702:	79 0a                	jns    80270e <sget+0x3c>
		return NULL;
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
  802709:	e9 80 00 00 00       	jmp    80278e <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80270e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802715:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271b:	01 d0                	add    %edx,%eax
  80271d:	48                   	dec    %eax
  80271e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802724:	ba 00 00 00 00       	mov    $0x0,%edx
  802729:	f7 75 f0             	divl   -0x10(%ebp)
  80272c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272f:	29 d0                	sub    %edx,%eax
  802731:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	ff 75 e8             	pushl  -0x18(%ebp)
  80273a:	e8 a3 0b 00 00       	call   8032e2 <alloc_block_FF>
  80273f:	83 c4 10             	add    $0x10,%esp
  802742:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  802745:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802749:	74 3e                	je     802789 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  80274b:	83 ec 0c             	sub    $0xc,%esp
  80274e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802751:	e8 dd 09 00 00       	call   803133 <insert_sorted_allocList>
  802756:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  802759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275c:	8b 40 08             	mov    0x8(%eax),%eax
  80275f:	83 ec 04             	sub    $0x4,%esp
  802762:	50                   	push   %eax
  802763:	ff 75 0c             	pushl  0xc(%ebp)
  802766:	ff 75 08             	pushl  0x8(%ebp)
  802769:	e8 c1 03 00 00       	call   802b2f <sys_getSharedObject>
  80276e:	83 c4 10             	add    $0x10,%esp
  802771:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  802774:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802778:	79 07                	jns    802781 <sget+0xaf>
	    		  return NULL;
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax
  80277f:	eb 0d                	jmp    80278e <sget+0xbc>
	  	return(void*) returned_block->sva;
  802781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802784:	8b 40 08             	mov    0x8(%eax),%eax
  802787:	eb 05                	jmp    80278e <sget+0xbc>
	      }
	}
	   return NULL;
  802789:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802796:	e8 4d fb ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	68 20 4c 80 00       	push   $0x804c20
  8027a3:	68 12 01 00 00       	push   $0x112
  8027a8:	68 13 4c 80 00       	push   $0x804c13
  8027ad:	e8 f8 ea ff ff       	call   8012aa <_panic>

008027b2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
  8027b5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8027b8:	83 ec 04             	sub    $0x4,%esp
  8027bb:	68 48 4c 80 00       	push   $0x804c48
  8027c0:	68 26 01 00 00       	push   $0x126
  8027c5:	68 13 4c 80 00       	push   $0x804c13
  8027ca:	e8 db ea ff ff       	call   8012aa <_panic>

008027cf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8027cf:	55                   	push   %ebp
  8027d0:	89 e5                	mov    %esp,%ebp
  8027d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027d5:	83 ec 04             	sub    $0x4,%esp
  8027d8:	68 6c 4c 80 00       	push   $0x804c6c
  8027dd:	68 31 01 00 00       	push   $0x131
  8027e2:	68 13 4c 80 00       	push   $0x804c13
  8027e7:	e8 be ea ff ff       	call   8012aa <_panic>

008027ec <shrink>:

}
void shrink(uint32 newSize)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 6c 4c 80 00       	push   $0x804c6c
  8027fa:	68 36 01 00 00       	push   $0x136
  8027ff:	68 13 4c 80 00       	push   $0x804c13
  802804:	e8 a1 ea ff ff       	call   8012aa <_panic>

00802809 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	68 6c 4c 80 00       	push   $0x804c6c
  802817:	68 3b 01 00 00       	push   $0x13b
  80281c:	68 13 4c 80 00       	push   $0x804c13
  802821:	e8 84 ea ff ff       	call   8012aa <_panic>

00802826 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	57                   	push   %edi
  80282a:	56                   	push   %esi
  80282b:	53                   	push   %ebx
  80282c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	8b 55 0c             	mov    0xc(%ebp),%edx
  802835:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802838:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80283b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80283e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802841:	cd 30                	int    $0x30
  802843:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802846:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802849:	83 c4 10             	add    $0x10,%esp
  80284c:	5b                   	pop    %ebx
  80284d:	5e                   	pop    %esi
  80284e:	5f                   	pop    %edi
  80284f:	5d                   	pop    %ebp
  802850:	c3                   	ret    

00802851 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 04             	sub    $0x4,%esp
  802857:	8b 45 10             	mov    0x10(%ebp),%eax
  80285a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80285d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	52                   	push   %edx
  802869:	ff 75 0c             	pushl  0xc(%ebp)
  80286c:	50                   	push   %eax
  80286d:	6a 00                	push   $0x0
  80286f:	e8 b2 ff ff ff       	call   802826 <syscall>
  802874:	83 c4 18             	add    $0x18,%esp
}
  802877:	90                   	nop
  802878:	c9                   	leave  
  802879:	c3                   	ret    

0080287a <sys_cgetc>:

int
sys_cgetc(void)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 01                	push   $0x1
  802889:	e8 98 ff ff ff       	call   802826 <syscall>
  80288e:	83 c4 18             	add    $0x18,%esp
}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802896:	8b 55 0c             	mov    0xc(%ebp),%edx
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	52                   	push   %edx
  8028a3:	50                   	push   %eax
  8028a4:	6a 05                	push   $0x5
  8028a6:	e8 7b ff ff ff       	call   802826 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	56                   	push   %esi
  8028b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8028b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	56                   	push   %esi
  8028c5:	53                   	push   %ebx
  8028c6:	51                   	push   %ecx
  8028c7:	52                   	push   %edx
  8028c8:	50                   	push   %eax
  8028c9:	6a 06                	push   $0x6
  8028cb:	e8 56 ff ff ff       	call   802826 <syscall>
  8028d0:	83 c4 18             	add    $0x18,%esp
}
  8028d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028d6:	5b                   	pop    %ebx
  8028d7:	5e                   	pop    %esi
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    

008028da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8028dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	52                   	push   %edx
  8028ea:	50                   	push   %eax
  8028eb:	6a 07                	push   $0x7
  8028ed:	e8 34 ff ff ff       	call   802826 <syscall>
  8028f2:	83 c4 18             	add    $0x18,%esp
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	ff 75 0c             	pushl  0xc(%ebp)
  802903:	ff 75 08             	pushl  0x8(%ebp)
  802906:	6a 08                	push   $0x8
  802908:	e8 19 ff ff ff       	call   802826 <syscall>
  80290d:	83 c4 18             	add    $0x18,%esp
}
  802910:	c9                   	leave  
  802911:	c3                   	ret    

00802912 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802912:	55                   	push   %ebp
  802913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 00                	push   $0x0
  80291f:	6a 09                	push   $0x9
  802921:	e8 00 ff ff ff       	call   802826 <syscall>
  802926:	83 c4 18             	add    $0x18,%esp
}
  802929:	c9                   	leave  
  80292a:	c3                   	ret    

0080292b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	6a 00                	push   $0x0
  802934:	6a 00                	push   $0x0
  802936:	6a 00                	push   $0x0
  802938:	6a 0a                	push   $0xa
  80293a:	e8 e7 fe ff ff       	call   802826 <syscall>
  80293f:	83 c4 18             	add    $0x18,%esp
}
  802942:	c9                   	leave  
  802943:	c3                   	ret    

00802944 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	6a 0b                	push   $0xb
  802953:	e8 ce fe ff ff       	call   802826 <syscall>
  802958:	83 c4 18             	add    $0x18,%esp
}
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	ff 75 0c             	pushl  0xc(%ebp)
  802969:	ff 75 08             	pushl  0x8(%ebp)
  80296c:	6a 0f                	push   $0xf
  80296e:	e8 b3 fe ff ff       	call   802826 <syscall>
  802973:	83 c4 18             	add    $0x18,%esp
	return;
  802976:	90                   	nop
}
  802977:	c9                   	leave  
  802978:	c3                   	ret    

00802979 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802979:	55                   	push   %ebp
  80297a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	ff 75 0c             	pushl  0xc(%ebp)
  802985:	ff 75 08             	pushl  0x8(%ebp)
  802988:	6a 10                	push   $0x10
  80298a:	e8 97 fe ff ff       	call   802826 <syscall>
  80298f:	83 c4 18             	add    $0x18,%esp
	return ;
  802992:	90                   	nop
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802998:	6a 00                	push   $0x0
  80299a:	6a 00                	push   $0x0
  80299c:	ff 75 10             	pushl  0x10(%ebp)
  80299f:	ff 75 0c             	pushl  0xc(%ebp)
  8029a2:	ff 75 08             	pushl  0x8(%ebp)
  8029a5:	6a 11                	push   $0x11
  8029a7:	e8 7a fe ff ff       	call   802826 <syscall>
  8029ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8029af:	90                   	nop
}
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 0c                	push   $0xc
  8029c1:	e8 60 fe ff ff       	call   802826 <syscall>
  8029c6:	83 c4 18             	add    $0x18,%esp
}
  8029c9:	c9                   	leave  
  8029ca:	c3                   	ret    

008029cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	ff 75 08             	pushl  0x8(%ebp)
  8029d9:	6a 0d                	push   $0xd
  8029db:	e8 46 fe ff ff       	call   802826 <syscall>
  8029e0:	83 c4 18             	add    $0x18,%esp
}
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 0e                	push   $0xe
  8029f4:	e8 2d fe ff ff       	call   802826 <syscall>
  8029f9:	83 c4 18             	add    $0x18,%esp
}
  8029fc:	90                   	nop
  8029fd:	c9                   	leave  
  8029fe:	c3                   	ret    

008029ff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 13                	push   $0x13
  802a0e:	e8 13 fe ff ff       	call   802826 <syscall>
  802a13:	83 c4 18             	add    $0x18,%esp
}
  802a16:	90                   	nop
  802a17:	c9                   	leave  
  802a18:	c3                   	ret    

00802a19 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 00                	push   $0x0
  802a26:	6a 14                	push   $0x14
  802a28:	e8 f9 fd ff ff       	call   802826 <syscall>
  802a2d:	83 c4 18             	add    $0x18,%esp
}
  802a30:	90                   	nop
  802a31:	c9                   	leave  
  802a32:	c3                   	ret    

00802a33 <sys_cputc>:


void
sys_cputc(const char c)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
  802a36:	83 ec 04             	sub    $0x4,%esp
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a3f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a43:	6a 00                	push   $0x0
  802a45:	6a 00                	push   $0x0
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	50                   	push   %eax
  802a4c:	6a 15                	push   $0x15
  802a4e:	e8 d3 fd ff ff       	call   802826 <syscall>
  802a53:	83 c4 18             	add    $0x18,%esp
}
  802a56:	90                   	nop
  802a57:	c9                   	leave  
  802a58:	c3                   	ret    

00802a59 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	6a 16                	push   $0x16
  802a68:	e8 b9 fd ff ff       	call   802826 <syscall>
  802a6d:	83 c4 18             	add    $0x18,%esp
}
  802a70:	90                   	nop
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 00                	push   $0x0
  802a7f:	ff 75 0c             	pushl  0xc(%ebp)
  802a82:	50                   	push   %eax
  802a83:	6a 17                	push   $0x17
  802a85:	e8 9c fd ff ff       	call   802826 <syscall>
  802a8a:	83 c4 18             	add    $0x18,%esp
}
  802a8d:	c9                   	leave  
  802a8e:	c3                   	ret    

00802a8f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802a8f:	55                   	push   %ebp
  802a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	52                   	push   %edx
  802a9f:	50                   	push   %eax
  802aa0:	6a 1a                	push   $0x1a
  802aa2:	e8 7f fd ff ff       	call   802826 <syscall>
  802aa7:	83 c4 18             	add    $0x18,%esp
}
  802aaa:	c9                   	leave  
  802aab:	c3                   	ret    

00802aac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802aac:	55                   	push   %ebp
  802aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	6a 00                	push   $0x0
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	52                   	push   %edx
  802abc:	50                   	push   %eax
  802abd:	6a 18                	push   $0x18
  802abf:	e8 62 fd ff ff       	call   802826 <syscall>
  802ac4:	83 c4 18             	add    $0x18,%esp
}
  802ac7:	90                   	nop
  802ac8:	c9                   	leave  
  802ac9:	c3                   	ret    

00802aca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802aca:	55                   	push   %ebp
  802acb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 00                	push   $0x0
  802ad9:	52                   	push   %edx
  802ada:	50                   	push   %eax
  802adb:	6a 19                	push   $0x19
  802add:	e8 44 fd ff ff       	call   802826 <syscall>
  802ae2:	83 c4 18             	add    $0x18,%esp
}
  802ae5:	90                   	nop
  802ae6:	c9                   	leave  
  802ae7:	c3                   	ret    

00802ae8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ae8:	55                   	push   %ebp
  802ae9:	89 e5                	mov    %esp,%ebp
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	8b 45 10             	mov    0x10(%ebp),%eax
  802af1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802af4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802af7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	6a 00                	push   $0x0
  802b00:	51                   	push   %ecx
  802b01:	52                   	push   %edx
  802b02:	ff 75 0c             	pushl  0xc(%ebp)
  802b05:	50                   	push   %eax
  802b06:	6a 1b                	push   $0x1b
  802b08:	e8 19 fd ff ff       	call   802826 <syscall>
  802b0d:	83 c4 18             	add    $0x18,%esp
}
  802b10:	c9                   	leave  
  802b11:	c3                   	ret    

00802b12 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802b12:	55                   	push   %ebp
  802b13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	6a 00                	push   $0x0
  802b1d:	6a 00                	push   $0x0
  802b1f:	6a 00                	push   $0x0
  802b21:	52                   	push   %edx
  802b22:	50                   	push   %eax
  802b23:	6a 1c                	push   $0x1c
  802b25:	e8 fc fc ff ff       	call   802826 <syscall>
  802b2a:	83 c4 18             	add    $0x18,%esp
}
  802b2d:	c9                   	leave  
  802b2e:	c3                   	ret    

00802b2f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	51                   	push   %ecx
  802b40:	52                   	push   %edx
  802b41:	50                   	push   %eax
  802b42:	6a 1d                	push   $0x1d
  802b44:	e8 dd fc ff ff       	call   802826 <syscall>
  802b49:	83 c4 18             	add    $0x18,%esp
}
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	6a 00                	push   $0x0
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	52                   	push   %edx
  802b5e:	50                   	push   %eax
  802b5f:	6a 1e                	push   $0x1e
  802b61:	e8 c0 fc ff ff       	call   802826 <syscall>
  802b66:	83 c4 18             	add    $0x18,%esp
}
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	6a 1f                	push   $0x1f
  802b7a:	e8 a7 fc ff ff       	call   802826 <syscall>
  802b7f:	83 c4 18             	add    $0x18,%esp
}
  802b82:	c9                   	leave  
  802b83:	c3                   	ret    

00802b84 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	6a 00                	push   $0x0
  802b8c:	ff 75 14             	pushl  0x14(%ebp)
  802b8f:	ff 75 10             	pushl  0x10(%ebp)
  802b92:	ff 75 0c             	pushl  0xc(%ebp)
  802b95:	50                   	push   %eax
  802b96:	6a 20                	push   $0x20
  802b98:	e8 89 fc ff ff       	call   802826 <syscall>
  802b9d:	83 c4 18             	add    $0x18,%esp
}
  802ba0:	c9                   	leave  
  802ba1:	c3                   	ret    

00802ba2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802ba2:	55                   	push   %ebp
  802ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	50                   	push   %eax
  802bb1:	6a 21                	push   $0x21
  802bb3:	e8 6e fc ff ff       	call   802826 <syscall>
  802bb8:	83 c4 18             	add    $0x18,%esp
}
  802bbb:	90                   	nop
  802bbc:	c9                   	leave  
  802bbd:	c3                   	ret    

00802bbe <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802bbe:	55                   	push   %ebp
  802bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 00                	push   $0x0
  802bc8:	6a 00                	push   $0x0
  802bca:	6a 00                	push   $0x0
  802bcc:	50                   	push   %eax
  802bcd:	6a 22                	push   $0x22
  802bcf:	e8 52 fc ff ff       	call   802826 <syscall>
  802bd4:	83 c4 18             	add    $0x18,%esp
}
  802bd7:	c9                   	leave  
  802bd8:	c3                   	ret    

00802bd9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802bd9:	55                   	push   %ebp
  802bda:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	6a 00                	push   $0x0
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	6a 02                	push   $0x2
  802be8:	e8 39 fc ff ff       	call   802826 <syscall>
  802bed:	83 c4 18             	add    $0x18,%esp
}
  802bf0:	c9                   	leave  
  802bf1:	c3                   	ret    

00802bf2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802bf2:	55                   	push   %ebp
  802bf3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 00                	push   $0x0
  802bf9:	6a 00                	push   $0x0
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 03                	push   $0x3
  802c01:	e8 20 fc ff ff       	call   802826 <syscall>
  802c06:	83 c4 18             	add    $0x18,%esp
}
  802c09:	c9                   	leave  
  802c0a:	c3                   	ret    

00802c0b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 00                	push   $0x0
  802c12:	6a 00                	push   $0x0
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 04                	push   $0x4
  802c1a:	e8 07 fc ff ff       	call   802826 <syscall>
  802c1f:	83 c4 18             	add    $0x18,%esp
}
  802c22:	c9                   	leave  
  802c23:	c3                   	ret    

00802c24 <sys_exit_env>:


void sys_exit_env(void)
{
  802c24:	55                   	push   %ebp
  802c25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	6a 23                	push   $0x23
  802c33:	e8 ee fb ff ff       	call   802826 <syscall>
  802c38:	83 c4 18             	add    $0x18,%esp
}
  802c3b:	90                   	nop
  802c3c:	c9                   	leave  
  802c3d:	c3                   	ret    

00802c3e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802c3e:	55                   	push   %ebp
  802c3f:	89 e5                	mov    %esp,%ebp
  802c41:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c44:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c47:	8d 50 04             	lea    0x4(%eax),%edx
  802c4a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c4d:	6a 00                	push   $0x0
  802c4f:	6a 00                	push   $0x0
  802c51:	6a 00                	push   $0x0
  802c53:	52                   	push   %edx
  802c54:	50                   	push   %eax
  802c55:	6a 24                	push   $0x24
  802c57:	e8 ca fb ff ff       	call   802826 <syscall>
  802c5c:	83 c4 18             	add    $0x18,%esp
	return result;
  802c5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c68:	89 01                	mov    %eax,(%ecx)
  802c6a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	c9                   	leave  
  802c71:	c2 04 00             	ret    $0x4

00802c74 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c74:	55                   	push   %ebp
  802c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	ff 75 10             	pushl  0x10(%ebp)
  802c7e:	ff 75 0c             	pushl  0xc(%ebp)
  802c81:	ff 75 08             	pushl  0x8(%ebp)
  802c84:	6a 12                	push   $0x12
  802c86:	e8 9b fb ff ff       	call   802826 <syscall>
  802c8b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c8e:	90                   	nop
}
  802c8f:	c9                   	leave  
  802c90:	c3                   	ret    

00802c91 <sys_rcr2>:
uint32 sys_rcr2()
{
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c94:	6a 00                	push   $0x0
  802c96:	6a 00                	push   $0x0
  802c98:	6a 00                	push   $0x0
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 25                	push   $0x25
  802ca0:	e8 81 fb ff ff       	call   802826 <syscall>
  802ca5:	83 c4 18             	add    $0x18,%esp
}
  802ca8:	c9                   	leave  
  802ca9:	c3                   	ret    

00802caa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802caa:	55                   	push   %ebp
  802cab:	89 e5                	mov    %esp,%ebp
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802cb6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	6a 00                	push   $0x0
  802cc0:	6a 00                	push   $0x0
  802cc2:	50                   	push   %eax
  802cc3:	6a 26                	push   $0x26
  802cc5:	e8 5c fb ff ff       	call   802826 <syscall>
  802cca:	83 c4 18             	add    $0x18,%esp
	return ;
  802ccd:	90                   	nop
}
  802cce:	c9                   	leave  
  802ccf:	c3                   	ret    

00802cd0 <rsttst>:
void rsttst()
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802cd3:	6a 00                	push   $0x0
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 28                	push   $0x28
  802cdf:	e8 42 fb ff ff       	call   802826 <syscall>
  802ce4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ce7:	90                   	nop
}
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
  802ced:	83 ec 04             	sub    $0x4,%esp
  802cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  802cf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802cf6:	8b 55 18             	mov    0x18(%ebp),%edx
  802cf9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802cfd:	52                   	push   %edx
  802cfe:	50                   	push   %eax
  802cff:	ff 75 10             	pushl  0x10(%ebp)
  802d02:	ff 75 0c             	pushl  0xc(%ebp)
  802d05:	ff 75 08             	pushl  0x8(%ebp)
  802d08:	6a 27                	push   $0x27
  802d0a:	e8 17 fb ff ff       	call   802826 <syscall>
  802d0f:	83 c4 18             	add    $0x18,%esp
	return ;
  802d12:	90                   	nop
}
  802d13:	c9                   	leave  
  802d14:	c3                   	ret    

00802d15 <chktst>:
void chktst(uint32 n)
{
  802d15:	55                   	push   %ebp
  802d16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d18:	6a 00                	push   $0x0
  802d1a:	6a 00                	push   $0x0
  802d1c:	6a 00                	push   $0x0
  802d1e:	6a 00                	push   $0x0
  802d20:	ff 75 08             	pushl  0x8(%ebp)
  802d23:	6a 29                	push   $0x29
  802d25:	e8 fc fa ff ff       	call   802826 <syscall>
  802d2a:	83 c4 18             	add    $0x18,%esp
	return ;
  802d2d:	90                   	nop
}
  802d2e:	c9                   	leave  
  802d2f:	c3                   	ret    

00802d30 <inctst>:

void inctst()
{
  802d30:	55                   	push   %ebp
  802d31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d33:	6a 00                	push   $0x0
  802d35:	6a 00                	push   $0x0
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 2a                	push   $0x2a
  802d3f:	e8 e2 fa ff ff       	call   802826 <syscall>
  802d44:	83 c4 18             	add    $0x18,%esp
	return ;
  802d47:	90                   	nop
}
  802d48:	c9                   	leave  
  802d49:	c3                   	ret    

00802d4a <gettst>:
uint32 gettst()
{
  802d4a:	55                   	push   %ebp
  802d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 2b                	push   $0x2b
  802d59:	e8 c8 fa ff ff       	call   802826 <syscall>
  802d5e:	83 c4 18             	add    $0x18,%esp
}
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
  802d66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 00                	push   $0x0
  802d71:	6a 00                	push   $0x0
  802d73:	6a 2c                	push   $0x2c
  802d75:	e8 ac fa ff ff       	call   802826 <syscall>
  802d7a:	83 c4 18             	add    $0x18,%esp
  802d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802d80:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802d84:	75 07                	jne    802d8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802d86:	b8 01 00 00 00       	mov    $0x1,%eax
  802d8b:	eb 05                	jmp    802d92 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d92:	c9                   	leave  
  802d93:	c3                   	ret    

00802d94 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802d94:	55                   	push   %ebp
  802d95:	89 e5                	mov    %esp,%ebp
  802d97:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	6a 00                	push   $0x0
  802da4:	6a 2c                	push   $0x2c
  802da6:	e8 7b fa ff ff       	call   802826 <syscall>
  802dab:	83 c4 18             	add    $0x18,%esp
  802dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802db1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802db5:	75 07                	jne    802dbe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802db7:	b8 01 00 00 00       	mov    $0x1,%eax
  802dbc:	eb 05                	jmp    802dc3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc3:	c9                   	leave  
  802dc4:	c3                   	ret    

00802dc5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802dc5:	55                   	push   %ebp
  802dc6:	89 e5                	mov    %esp,%ebp
  802dc8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dcb:	6a 00                	push   $0x0
  802dcd:	6a 00                	push   $0x0
  802dcf:	6a 00                	push   $0x0
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	6a 2c                	push   $0x2c
  802dd7:	e8 4a fa ff ff       	call   802826 <syscall>
  802ddc:	83 c4 18             	add    $0x18,%esp
  802ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802de2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802de6:	75 07                	jne    802def <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802de8:	b8 01 00 00 00       	mov    $0x1,%eax
  802ded:	eb 05                	jmp    802df4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df4:	c9                   	leave  
  802df5:	c3                   	ret    

00802df6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802df6:	55                   	push   %ebp
  802df7:	89 e5                	mov    %esp,%ebp
  802df9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dfc:	6a 00                	push   $0x0
  802dfe:	6a 00                	push   $0x0
  802e00:	6a 00                	push   $0x0
  802e02:	6a 00                	push   $0x0
  802e04:	6a 00                	push   $0x0
  802e06:	6a 2c                	push   $0x2c
  802e08:	e8 19 fa ff ff       	call   802826 <syscall>
  802e0d:	83 c4 18             	add    $0x18,%esp
  802e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802e13:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802e17:	75 07                	jne    802e20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802e19:	b8 01 00 00 00       	mov    $0x1,%eax
  802e1e:	eb 05                	jmp    802e25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e25:	c9                   	leave  
  802e26:	c3                   	ret    

00802e27 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802e27:	55                   	push   %ebp
  802e28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	ff 75 08             	pushl  0x8(%ebp)
  802e35:	6a 2d                	push   $0x2d
  802e37:	e8 ea f9 ff ff       	call   802826 <syscall>
  802e3c:	83 c4 18             	add    $0x18,%esp
	return ;
  802e3f:	90                   	nop
}
  802e40:	c9                   	leave  
  802e41:	c3                   	ret    

00802e42 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802e42:	55                   	push   %ebp
  802e43:	89 e5                	mov    %esp,%ebp
  802e45:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802e46:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	6a 00                	push   $0x0
  802e54:	53                   	push   %ebx
  802e55:	51                   	push   %ecx
  802e56:	52                   	push   %edx
  802e57:	50                   	push   %eax
  802e58:	6a 2e                	push   $0x2e
  802e5a:	e8 c7 f9 ff ff       	call   802826 <syscall>
  802e5f:	83 c4 18             	add    $0x18,%esp
}
  802e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e65:	c9                   	leave  
  802e66:	c3                   	ret    

00802e67 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e67:	55                   	push   %ebp
  802e68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	6a 00                	push   $0x0
  802e76:	52                   	push   %edx
  802e77:	50                   	push   %eax
  802e78:	6a 2f                	push   $0x2f
  802e7a:	e8 a7 f9 ff ff       	call   802826 <syscall>
  802e7f:	83 c4 18             	add    $0x18,%esp
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802e8a:	83 ec 0c             	sub    $0xc,%esp
  802e8d:	68 7c 4c 80 00       	push   $0x804c7c
  802e92:	e8 c7 e6 ff ff       	call   80155e <cprintf>
  802e97:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802e9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802ea1:	83 ec 0c             	sub    $0xc,%esp
  802ea4:	68 a8 4c 80 00       	push   $0x804ca8
  802ea9:	e8 b0 e6 ff ff       	call   80155e <cprintf>
  802eae:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802eb1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802eb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebd:	eb 56                	jmp    802f15 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ebf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec3:	74 1c                	je     802ee1 <print_mem_block_lists+0x5d>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 50 08             	mov    0x8(%eax),%edx
  802ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ece:	8b 48 08             	mov    0x8(%eax),%ecx
  802ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed7:	01 c8                	add    %ecx,%eax
  802ed9:	39 c2                	cmp    %eax,%edx
  802edb:	73 04                	jae    802ee1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802edd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 50 08             	mov    0x8(%eax),%edx
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 40 0c             	mov    0xc(%eax),%eax
  802eed:	01 c2                	add    %eax,%edx
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	8b 40 08             	mov    0x8(%eax),%eax
  802ef5:	83 ec 04             	sub    $0x4,%esp
  802ef8:	52                   	push   %edx
  802ef9:	50                   	push   %eax
  802efa:	68 bd 4c 80 00       	push   $0x804cbd
  802eff:	e8 5a e6 ff ff       	call   80155e <cprintf>
  802f04:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f19:	74 07                	je     802f22 <print_mem_block_lists+0x9e>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	eb 05                	jmp    802f27 <print_mem_block_lists+0xa3>
  802f22:	b8 00 00 00 00       	mov    $0x0,%eax
  802f27:	a3 40 51 80 00       	mov    %eax,0x805140
  802f2c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	75 8a                	jne    802ebf <print_mem_block_lists+0x3b>
  802f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f39:	75 84                	jne    802ebf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802f3b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802f3f:	75 10                	jne    802f51 <print_mem_block_lists+0xcd>
  802f41:	83 ec 0c             	sub    $0xc,%esp
  802f44:	68 cc 4c 80 00       	push   $0x804ccc
  802f49:	e8 10 e6 ff ff       	call   80155e <cprintf>
  802f4e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802f51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802f58:	83 ec 0c             	sub    $0xc,%esp
  802f5b:	68 f0 4c 80 00       	push   $0x804cf0
  802f60:	e8 f9 e5 ff ff       	call   80155e <cprintf>
  802f65:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802f68:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802f6c:	a1 40 50 80 00       	mov    0x805040,%eax
  802f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f74:	eb 56                	jmp    802fcc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7a:	74 1c                	je     802f98 <print_mem_block_lists+0x114>
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 50 08             	mov    0x8(%eax),%edx
  802f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f85:	8b 48 08             	mov    0x8(%eax),%ecx
  802f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	01 c8                	add    %ecx,%eax
  802f90:	39 c2                	cmp    %eax,%edx
  802f92:	73 04                	jae    802f98 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802f94:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 50 08             	mov    0x8(%eax),%edx
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa4:	01 c2                	add    %eax,%edx
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 40 08             	mov    0x8(%eax),%eax
  802fac:	83 ec 04             	sub    $0x4,%esp
  802faf:	52                   	push   %edx
  802fb0:	50                   	push   %eax
  802fb1:	68 bd 4c 80 00       	push   $0x804cbd
  802fb6:	e8 a3 e5 ff ff       	call   80155e <cprintf>
  802fbb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802fc4:	a1 48 50 80 00       	mov    0x805048,%eax
  802fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd0:	74 07                	je     802fd9 <print_mem_block_lists+0x155>
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	eb 05                	jmp    802fde <print_mem_block_lists+0x15a>
  802fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fde:	a3 48 50 80 00       	mov    %eax,0x805048
  802fe3:	a1 48 50 80 00       	mov    0x805048,%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	75 8a                	jne    802f76 <print_mem_block_lists+0xf2>
  802fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff0:	75 84                	jne    802f76 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802ff2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802ff6:	75 10                	jne    803008 <print_mem_block_lists+0x184>
  802ff8:	83 ec 0c             	sub    $0xc,%esp
  802ffb:	68 08 4d 80 00       	push   $0x804d08
  803000:	e8 59 e5 ff ff       	call   80155e <cprintf>
  803005:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803008:	83 ec 0c             	sub    $0xc,%esp
  80300b:	68 7c 4c 80 00       	push   $0x804c7c
  803010:	e8 49 e5 ff ff       	call   80155e <cprintf>
  803015:	83 c4 10             	add    $0x10,%esp

}
  803018:	90                   	nop
  803019:	c9                   	leave  
  80301a:	c3                   	ret    

0080301b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  803021:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  803028:	00 00 00 
  80302b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  803032:	00 00 00 
  803035:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80303c:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  80303f:	a1 50 50 80 00       	mov    0x805050,%eax
  803044:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  803047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80304e:	e9 9e 00 00 00       	jmp    8030f1 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  803053:	a1 50 50 80 00       	mov    0x805050,%eax
  803058:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305b:	c1 e2 04             	shl    $0x4,%edx
  80305e:	01 d0                	add    %edx,%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	75 14                	jne    803078 <initialize_MemBlocksList+0x5d>
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	68 30 4d 80 00       	push   $0x804d30
  80306c:	6a 48                	push   $0x48
  80306e:	68 53 4d 80 00       	push   $0x804d53
  803073:	e8 32 e2 ff ff       	call   8012aa <_panic>
  803078:	a1 50 50 80 00       	mov    0x805050,%eax
  80307d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803080:	c1 e2 04             	shl    $0x4,%edx
  803083:	01 d0                	add    %edx,%eax
  803085:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80308b:	89 10                	mov    %edx,(%eax)
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 18                	je     8030ab <initialize_MemBlocksList+0x90>
  803093:	a1 48 51 80 00       	mov    0x805148,%eax
  803098:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80309e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8030a1:	c1 e1 04             	shl    $0x4,%ecx
  8030a4:	01 ca                	add    %ecx,%edx
  8030a6:	89 50 04             	mov    %edx,0x4(%eax)
  8030a9:	eb 12                	jmp    8030bd <initialize_MemBlocksList+0xa2>
  8030ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8030b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b3:	c1 e2 04             	shl    $0x4,%edx
  8030b6:	01 d0                	add    %edx,%eax
  8030b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8030c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c5:	c1 e2 04             	shl    $0x4,%edx
  8030c8:	01 d0                	add    %edx,%eax
  8030ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8030cf:	a1 50 50 80 00       	mov    0x805050,%eax
  8030d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d7:	c1 e2 04             	shl    $0x4,%edx
  8030da:	01 d0                	add    %edx,%eax
  8030dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e8:	40                   	inc    %eax
  8030e9:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  8030ee:	ff 45 f4             	incl   -0xc(%ebp)
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f7:	0f 82 56 ff ff ff    	jb     803053 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  8030fd:	90                   	nop
  8030fe:	c9                   	leave  
  8030ff:	c3                   	ret    

00803100 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
  803103:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80310e:	eb 18                	jmp    803128 <find_block+0x28>
		{
			if(tmp->sva==va)
  803110:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803113:	8b 40 08             	mov    0x8(%eax),%eax
  803116:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803119:	75 05                	jne    803120 <find_block+0x20>
			{
				return tmp;
  80311b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80311e:	eb 11                	jmp    803131 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  803120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  803128:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80312c:	75 e2                	jne    803110 <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  80312e:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  803131:	c9                   	leave  
  803132:	c3                   	ret    

00803133 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803133:	55                   	push   %ebp
  803134:	89 e5                	mov    %esp,%ebp
  803136:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  803139:	a1 40 50 80 00       	mov    0x805040,%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	0f 85 83 00 00 00    	jne    8031c9 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  803146:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80314d:	00 00 00 
  803150:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  803157:	00 00 00 
  80315a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  803161:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  803164:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803168:	75 14                	jne    80317e <insert_sorted_allocList+0x4b>
  80316a:	83 ec 04             	sub    $0x4,%esp
  80316d:	68 30 4d 80 00       	push   $0x804d30
  803172:	6a 7f                	push   $0x7f
  803174:	68 53 4d 80 00       	push   $0x804d53
  803179:	e8 2c e1 ff ff       	call   8012aa <_panic>
  80317e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	89 10                	mov    %edx,(%eax)
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	85 c0                	test   %eax,%eax
  803190:	74 0d                	je     80319f <insert_sorted_allocList+0x6c>
  803192:	a1 40 50 80 00       	mov    0x805040,%eax
  803197:	8b 55 08             	mov    0x8(%ebp),%edx
  80319a:	89 50 04             	mov    %edx,0x4(%eax)
  80319d:	eb 08                	jmp    8031a7 <insert_sorted_allocList+0x74>
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	a3 44 50 80 00       	mov    %eax,0x805044
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	a3 40 50 80 00       	mov    %eax,0x805040
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8031be:	40                   	inc    %eax
  8031bf:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8031c4:	e9 16 01 00 00       	jmp    8032df <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	8b 50 08             	mov    0x8(%eax),%edx
  8031cf:	a1 44 50 80 00       	mov    0x805044,%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	39 c2                	cmp    %eax,%edx
  8031d9:	76 68                	jbe    803243 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  8031db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031df:	75 17                	jne    8031f8 <insert_sorted_allocList+0xc5>
  8031e1:	83 ec 04             	sub    $0x4,%esp
  8031e4:	68 6c 4d 80 00       	push   $0x804d6c
  8031e9:	68 85 00 00 00       	push   $0x85
  8031ee:	68 53 4d 80 00       	push   $0x804d53
  8031f3:	e8 b2 e0 ff ff       	call   8012aa <_panic>
  8031f8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	89 50 04             	mov    %edx,0x4(%eax)
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	8b 40 04             	mov    0x4(%eax),%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	74 0c                	je     80321a <insert_sorted_allocList+0xe7>
  80320e:	a1 44 50 80 00       	mov    0x805044,%eax
  803213:	8b 55 08             	mov    0x8(%ebp),%edx
  803216:	89 10                	mov    %edx,(%eax)
  803218:	eb 08                	jmp    803222 <insert_sorted_allocList+0xef>
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	a3 40 50 80 00       	mov    %eax,0x805040
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	a3 44 50 80 00       	mov    %eax,0x805044
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803233:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803238:	40                   	inc    %eax
  803239:	a3 4c 50 80 00       	mov    %eax,0x80504c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80323e:	e9 9c 00 00 00       	jmp    8032df <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  803243:	a1 40 50 80 00       	mov    0x805040,%eax
  803248:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  80324b:	e9 85 00 00 00       	jmp    8032d5 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	8b 50 08             	mov    0x8(%eax),%edx
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 40 08             	mov    0x8(%eax),%eax
  80325c:	39 c2                	cmp    %eax,%edx
  80325e:	73 6d                	jae    8032cd <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  803260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803264:	74 06                	je     80326c <insert_sorted_allocList+0x139>
  803266:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326a:	75 17                	jne    803283 <insert_sorted_allocList+0x150>
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	68 90 4d 80 00       	push   $0x804d90
  803274:	68 90 00 00 00       	push   $0x90
  803279:	68 53 4d 80 00       	push   $0x804d53
  80327e:	e8 27 e0 ff ff       	call   8012aa <_panic>
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 50 04             	mov    0x4(%eax),%edx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	89 50 04             	mov    %edx,0x4(%eax)
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803295:	89 10                	mov    %edx,(%eax)
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 40 04             	mov    0x4(%eax),%eax
  80329d:	85 c0                	test   %eax,%eax
  80329f:	74 0d                	je     8032ae <insert_sorted_allocList+0x17b>
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	8b 40 04             	mov    0x4(%eax),%eax
  8032a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032aa:	89 10                	mov    %edx,(%eax)
  8032ac:	eb 08                	jmp    8032b6 <insert_sorted_allocList+0x183>
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	a3 40 50 80 00       	mov    %eax,0x805040
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bc:	89 50 04             	mov    %edx,0x4(%eax)
  8032bf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8032c4:	40                   	inc    %eax
  8032c5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8032ca:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8032cb:	eb 12                	jmp    8032df <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  8032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  8032d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d9:	0f 85 71 ff ff ff    	jne    803250 <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8032df:	90                   	nop
  8032e0:	c9                   	leave  
  8032e1:	c3                   	ret    

008032e2 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  8032e2:	55                   	push   %ebp
  8032e3:	89 e5                	mov    %esp,%ebp
  8032e5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8032e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ed:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  8032f0:	e9 76 01 00 00       	jmp    80346b <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032fe:	0f 85 8a 00 00 00    	jne    80338e <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  803304:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803308:	75 17                	jne    803321 <alloc_block_FF+0x3f>
  80330a:	83 ec 04             	sub    $0x4,%esp
  80330d:	68 c5 4d 80 00       	push   $0x804dc5
  803312:	68 a8 00 00 00       	push   $0xa8
  803317:	68 53 4d 80 00       	push   $0x804d53
  80331c:	e8 89 df ff ff       	call   8012aa <_panic>
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	85 c0                	test   %eax,%eax
  803328:	74 10                	je     80333a <alloc_block_FF+0x58>
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803332:	8b 52 04             	mov    0x4(%edx),%edx
  803335:	89 50 04             	mov    %edx,0x4(%eax)
  803338:	eb 0b                	jmp    803345 <alloc_block_FF+0x63>
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 40 04             	mov    0x4(%eax),%eax
  803340:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 40 04             	mov    0x4(%eax),%eax
  80334b:	85 c0                	test   %eax,%eax
  80334d:	74 0f                	je     80335e <alloc_block_FF+0x7c>
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	8b 40 04             	mov    0x4(%eax),%eax
  803355:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803358:	8b 12                	mov    (%edx),%edx
  80335a:	89 10                	mov    %edx,(%eax)
  80335c:	eb 0a                	jmp    803368 <alloc_block_FF+0x86>
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 00                	mov    (%eax),%eax
  803363:	a3 38 51 80 00       	mov    %eax,0x805138
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337b:	a1 44 51 80 00       	mov    0x805144,%eax
  803380:	48                   	dec    %eax
  803381:	a3 44 51 80 00       	mov    %eax,0x805144

			return tmp;
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	e9 ea 00 00 00       	jmp    803478 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 40 0c             	mov    0xc(%eax),%eax
  803394:	3b 45 08             	cmp    0x8(%ebp),%eax
  803397:	0f 86 c6 00 00 00    	jbe    803463 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80339d:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  8033a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ab:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 50 08             	mov    0x8(%eax),%edx
  8033b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b7:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8033c3:	89 c2                	mov    %eax,%edx
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 50 08             	mov    0x8(%eax),%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	01 c2                	add    %eax,%edx
  8033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d9:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8033dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033e0:	75 17                	jne    8033f9 <alloc_block_FF+0x117>
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 c5 4d 80 00       	push   $0x804dc5
  8033ea:	68 b6 00 00 00       	push   $0xb6
  8033ef:	68 53 4d 80 00       	push   $0x804d53
  8033f4:	e8 b1 de ff ff       	call   8012aa <_panic>
  8033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	74 10                	je     803412 <alloc_block_FF+0x130>
  803402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340a:	8b 52 04             	mov    0x4(%edx),%edx
  80340d:	89 50 04             	mov    %edx,0x4(%eax)
  803410:	eb 0b                	jmp    80341d <alloc_block_FF+0x13b>
  803412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803415:	8b 40 04             	mov    0x4(%eax),%eax
  803418:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803420:	8b 40 04             	mov    0x4(%eax),%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	74 0f                	je     803436 <alloc_block_FF+0x154>
  803427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342a:	8b 40 04             	mov    0x4(%eax),%eax
  80342d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803430:	8b 12                	mov    (%edx),%edx
  803432:	89 10                	mov    %edx,(%eax)
  803434:	eb 0a                	jmp    803440 <alloc_block_FF+0x15e>
  803436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	a3 48 51 80 00       	mov    %eax,0x805148
  803440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803443:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803453:	a1 54 51 80 00       	mov    0x805154,%eax
  803458:	48                   	dec    %eax
  803459:	a3 54 51 80 00       	mov    %eax,0x805154
			 return newBlock;
  80345e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803461:	eb 15                	jmp    803478 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  80346b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346f:	0f 85 80 fe ff ff    	jne    8032f5 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803478:	c9                   	leave  
  803479:	c3                   	ret    

0080347a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80347a:	55                   	push   %ebp
  80347b:	89 e5                	mov    %esp,%ebp
  80347d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  803480:	a1 38 51 80 00       	mov    0x805138,%eax
  803485:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  803488:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80348f:	e9 c0 00 00 00       	jmp    803554 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	8b 40 0c             	mov    0xc(%eax),%eax
  80349a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80349d:	0f 85 8a 00 00 00    	jne    80352d <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  8034a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a7:	75 17                	jne    8034c0 <alloc_block_BF+0x46>
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	68 c5 4d 80 00       	push   $0x804dc5
  8034b1:	68 cf 00 00 00       	push   $0xcf
  8034b6:	68 53 4d 80 00       	push   $0x804d53
  8034bb:	e8 ea dd ff ff       	call   8012aa <_panic>
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 10                	je     8034d9 <alloc_block_BF+0x5f>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d1:	8b 52 04             	mov    0x4(%edx),%edx
  8034d4:	89 50 04             	mov    %edx,0x4(%eax)
  8034d7:	eb 0b                	jmp    8034e4 <alloc_block_BF+0x6a>
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	8b 40 04             	mov    0x4(%eax),%eax
  8034df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	74 0f                	je     8034fd <alloc_block_BF+0x83>
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	8b 40 04             	mov    0x4(%eax),%eax
  8034f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f7:	8b 12                	mov    (%edx),%edx
  8034f9:	89 10                	mov    %edx,(%eax)
  8034fb:	eb 0a                	jmp    803507 <alloc_block_BF+0x8d>
  8034fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	a3 38 51 80 00       	mov    %eax,0x805138
  803507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803513:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351a:	a1 44 51 80 00       	mov    0x805144,%eax
  80351f:	48                   	dec    %eax
  803520:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp;
  803525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803528:	e9 2a 01 00 00       	jmp    803657 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	8b 40 0c             	mov    0xc(%eax),%eax
  803533:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803536:	73 14                	jae    80354c <alloc_block_BF+0xd2>
  803538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353b:	8b 40 0c             	mov    0xc(%eax),%eax
  80353e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803541:	76 09                	jbe    80354c <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  803543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803546:	8b 40 0c             	mov    0xc(%eax),%eax
  803549:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  80354c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  803554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803558:	0f 85 36 ff ff ff    	jne    803494 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  80355e:	a1 38 51 80 00       	mov    0x805138,%eax
  803563:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  803566:	e9 dd 00 00 00       	jmp    803648 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	8b 40 0c             	mov    0xc(%eax),%eax
  803571:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803574:	0f 85 c6 00 00 00    	jne    803640 <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80357a:	a1 48 51 80 00       	mov    0x805148,%eax
  80357f:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	8b 50 08             	mov    0x8(%eax),%edx
  803588:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358b:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80358e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803591:	8b 55 08             	mov    0x8(%ebp),%edx
  803594:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	8b 50 08             	mov    0x8(%eax),%edx
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	01 c2                	add    %eax,%edx
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  8035a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ae:	2b 45 08             	sub    0x8(%ebp),%eax
  8035b1:	89 c2                	mov    %eax,%edx
  8035b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b6:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8035b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035bd:	75 17                	jne    8035d6 <alloc_block_BF+0x15c>
  8035bf:	83 ec 04             	sub    $0x4,%esp
  8035c2:	68 c5 4d 80 00       	push   $0x804dc5
  8035c7:	68 eb 00 00 00       	push   $0xeb
  8035cc:	68 53 4d 80 00       	push   $0x804d53
  8035d1:	e8 d4 dc ff ff       	call   8012aa <_panic>
  8035d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d9:	8b 00                	mov    (%eax),%eax
  8035db:	85 c0                	test   %eax,%eax
  8035dd:	74 10                	je     8035ef <alloc_block_BF+0x175>
  8035df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035e7:	8b 52 04             	mov    0x4(%edx),%edx
  8035ea:	89 50 04             	mov    %edx,0x4(%eax)
  8035ed:	eb 0b                	jmp    8035fa <alloc_block_BF+0x180>
  8035ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f2:	8b 40 04             	mov    0x4(%eax),%eax
  8035f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fd:	8b 40 04             	mov    0x4(%eax),%eax
  803600:	85 c0                	test   %eax,%eax
  803602:	74 0f                	je     803613 <alloc_block_BF+0x199>
  803604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803607:	8b 40 04             	mov    0x4(%eax),%eax
  80360a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80360d:	8b 12                	mov    (%edx),%edx
  80360f:	89 10                	mov    %edx,(%eax)
  803611:	eb 0a                	jmp    80361d <alloc_block_BF+0x1a3>
  803613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	a3 48 51 80 00       	mov    %eax,0x805148
  80361d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803630:	a1 54 51 80 00       	mov    0x805154,%eax
  803635:	48                   	dec    %eax
  803636:	a3 54 51 80 00       	mov    %eax,0x805154
											 return newBlock;
  80363b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363e:	eb 17                	jmp    803657 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  803640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803643:	8b 00                	mov    (%eax),%eax
  803645:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  803648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364c:	0f 85 19 ff ff ff    	jne    80356b <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  803652:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803657:	c9                   	leave  
  803658:	c3                   	ret    

00803659 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  803659:	55                   	push   %ebp
  80365a:	89 e5                	mov    %esp,%ebp
  80365c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  80365f:	a1 40 50 80 00       	mov    0x805040,%eax
  803664:	85 c0                	test   %eax,%eax
  803666:	75 19                	jne    803681 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  803668:	83 ec 0c             	sub    $0xc,%esp
  80366b:	ff 75 08             	pushl  0x8(%ebp)
  80366e:	e8 6f fc ff ff       	call   8032e2 <alloc_block_FF>
  803673:	83 c4 10             	add    $0x10,%esp
  803676:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  803679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367c:	e9 e9 01 00 00       	jmp    80386a <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  803681:	a1 44 50 80 00       	mov    0x805044,%eax
  803686:	8b 40 08             	mov    0x8(%eax),%eax
  803689:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80368c:	a1 44 50 80 00       	mov    0x805044,%eax
  803691:	8b 50 0c             	mov    0xc(%eax),%edx
  803694:	a1 44 50 80 00       	mov    0x805044,%eax
  803699:	8b 40 08             	mov    0x8(%eax),%eax
  80369c:	01 d0                	add    %edx,%eax
  80369e:	83 ec 08             	sub    $0x8,%esp
  8036a1:	50                   	push   %eax
  8036a2:	68 38 51 80 00       	push   $0x805138
  8036a7:	e8 54 fa ff ff       	call   803100 <find_block>
  8036ac:	83 c4 10             	add    $0x10,%esp
  8036af:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  8036b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036bb:	0f 85 9b 00 00 00    	jne    80375c <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  8036c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	8b 40 08             	mov    0x8(%eax),%eax
  8036cd:	01 d0                	add    %edx,%eax
  8036cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  8036d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d6:	75 17                	jne    8036ef <alloc_block_NF+0x96>
  8036d8:	83 ec 04             	sub    $0x4,%esp
  8036db:	68 c5 4d 80 00       	push   $0x804dc5
  8036e0:	68 1a 01 00 00       	push   $0x11a
  8036e5:	68 53 4d 80 00       	push   $0x804d53
  8036ea:	e8 bb db ff ff       	call   8012aa <_panic>
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	8b 00                	mov    (%eax),%eax
  8036f4:	85 c0                	test   %eax,%eax
  8036f6:	74 10                	je     803708 <alloc_block_NF+0xaf>
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	8b 00                	mov    (%eax),%eax
  8036fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803700:	8b 52 04             	mov    0x4(%edx),%edx
  803703:	89 50 04             	mov    %edx,0x4(%eax)
  803706:	eb 0b                	jmp    803713 <alloc_block_NF+0xba>
  803708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370b:	8b 40 04             	mov    0x4(%eax),%eax
  80370e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	8b 40 04             	mov    0x4(%eax),%eax
  803719:	85 c0                	test   %eax,%eax
  80371b:	74 0f                	je     80372c <alloc_block_NF+0xd3>
  80371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803720:	8b 40 04             	mov    0x4(%eax),%eax
  803723:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803726:	8b 12                	mov    (%edx),%edx
  803728:	89 10                	mov    %edx,(%eax)
  80372a:	eb 0a                	jmp    803736 <alloc_block_NF+0xdd>
  80372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	a3 38 51 80 00       	mov    %eax,0x805138
  803736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803742:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803749:	a1 44 51 80 00       	mov    0x805144,%eax
  80374e:	48                   	dec    %eax
  80374f:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp1;
  803754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803757:	e9 0e 01 00 00       	jmp    80386a <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  80375c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375f:	8b 40 0c             	mov    0xc(%eax),%eax
  803762:	3b 45 08             	cmp    0x8(%ebp),%eax
  803765:	0f 86 cf 00 00 00    	jbe    80383a <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80376b:	a1 48 51 80 00       	mov    0x805148,%eax
  803770:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  803773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803776:	8b 55 08             	mov    0x8(%ebp),%edx
  803779:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  80377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377f:	8b 50 08             	mov    0x8(%eax),%edx
  803782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803785:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378b:	8b 50 08             	mov    0x8(%eax),%edx
  80378e:	8b 45 08             	mov    0x8(%ebp),%eax
  803791:	01 c2                	add    %eax,%edx
  803793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803796:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379c:	8b 40 0c             	mov    0xc(%eax),%eax
  80379f:	2b 45 08             	sub    0x8(%ebp),%eax
  8037a2:	89 c2                	mov    %eax,%edx
  8037a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a7:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  8037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ad:	8b 40 08             	mov    0x8(%eax),%eax
  8037b0:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  8037b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037b7:	75 17                	jne    8037d0 <alloc_block_NF+0x177>
  8037b9:	83 ec 04             	sub    $0x4,%esp
  8037bc:	68 c5 4d 80 00       	push   $0x804dc5
  8037c1:	68 28 01 00 00       	push   $0x128
  8037c6:	68 53 4d 80 00       	push   $0x804d53
  8037cb:	e8 da da ff ff       	call   8012aa <_panic>
  8037d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d3:	8b 00                	mov    (%eax),%eax
  8037d5:	85 c0                	test   %eax,%eax
  8037d7:	74 10                	je     8037e9 <alloc_block_NF+0x190>
  8037d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037dc:	8b 00                	mov    (%eax),%eax
  8037de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037e1:	8b 52 04             	mov    0x4(%edx),%edx
  8037e4:	89 50 04             	mov    %edx,0x4(%eax)
  8037e7:	eb 0b                	jmp    8037f4 <alloc_block_NF+0x19b>
  8037e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ec:	8b 40 04             	mov    0x4(%eax),%eax
  8037ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f7:	8b 40 04             	mov    0x4(%eax),%eax
  8037fa:	85 c0                	test   %eax,%eax
  8037fc:	74 0f                	je     80380d <alloc_block_NF+0x1b4>
  8037fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803801:	8b 40 04             	mov    0x4(%eax),%eax
  803804:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803807:	8b 12                	mov    (%edx),%edx
  803809:	89 10                	mov    %edx,(%eax)
  80380b:	eb 0a                	jmp    803817 <alloc_block_NF+0x1be>
  80380d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803810:	8b 00                	mov    (%eax),%eax
  803812:	a3 48 51 80 00       	mov    %eax,0x805148
  803817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803823:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382a:	a1 54 51 80 00       	mov    0x805154,%eax
  80382f:	48                   	dec    %eax
  803830:	a3 54 51 80 00       	mov    %eax,0x805154
					 return newBlock;
  803835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803838:	eb 30                	jmp    80386a <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  80383a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80383f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803842:	75 0a                	jne    80384e <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  803844:	a1 38 51 80 00       	mov    0x805138,%eax
  803849:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80384c:	eb 08                	jmp    803856 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  80384e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803851:	8b 00                	mov    (%eax),%eax
  803853:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  803856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803859:	8b 40 08             	mov    0x8(%eax),%eax
  80385c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80385f:	0f 85 4d fe ff ff    	jne    8036b2 <alloc_block_NF+0x59>

			return NULL;
  803865:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  80386a:	c9                   	leave  
  80386b:	c3                   	ret    

0080386c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80386c:	55                   	push   %ebp
  80386d:	89 e5                	mov    %esp,%ebp
  80386f:	53                   	push   %ebx
  803870:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  803873:	a1 38 51 80 00       	mov    0x805138,%eax
  803878:	85 c0                	test   %eax,%eax
  80387a:	0f 85 86 00 00 00    	jne    803906 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  803880:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  803887:	00 00 00 
  80388a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  803891:	00 00 00 
  803894:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80389b:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80389e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a2:	75 17                	jne    8038bb <insert_sorted_with_merge_freeList+0x4f>
  8038a4:	83 ec 04             	sub    $0x4,%esp
  8038a7:	68 30 4d 80 00       	push   $0x804d30
  8038ac:	68 48 01 00 00       	push   $0x148
  8038b1:	68 53 4d 80 00       	push   $0x804d53
  8038b6:	e8 ef d9 ff ff       	call   8012aa <_panic>
  8038bb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	89 10                	mov    %edx,(%eax)
  8038c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c9:	8b 00                	mov    (%eax),%eax
  8038cb:	85 c0                	test   %eax,%eax
  8038cd:	74 0d                	je     8038dc <insert_sorted_with_merge_freeList+0x70>
  8038cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8038d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d7:	89 50 04             	mov    %edx,0x4(%eax)
  8038da:	eb 08                	jmp    8038e4 <insert_sorted_with_merge_freeList+0x78>
  8038dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8038ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8038fb:	40                   	inc    %eax
  8038fc:	a3 44 51 80 00       	mov    %eax,0x805144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803901:	e9 73 07 00 00       	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803906:	8b 45 08             	mov    0x8(%ebp),%eax
  803909:	8b 50 08             	mov    0x8(%eax),%edx
  80390c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803911:	8b 40 08             	mov    0x8(%eax),%eax
  803914:	39 c2                	cmp    %eax,%edx
  803916:	0f 86 84 00 00 00    	jbe    8039a0 <insert_sorted_with_merge_freeList+0x134>
  80391c:	8b 45 08             	mov    0x8(%ebp),%eax
  80391f:	8b 50 08             	mov    0x8(%eax),%edx
  803922:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803927:	8b 48 0c             	mov    0xc(%eax),%ecx
  80392a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80392f:	8b 40 08             	mov    0x8(%eax),%eax
  803932:	01 c8                	add    %ecx,%eax
  803934:	39 c2                	cmp    %eax,%edx
  803936:	74 68                	je     8039a0 <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803938:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80393c:	75 17                	jne    803955 <insert_sorted_with_merge_freeList+0xe9>
  80393e:	83 ec 04             	sub    $0x4,%esp
  803941:	68 6c 4d 80 00       	push   $0x804d6c
  803946:	68 4c 01 00 00       	push   $0x14c
  80394b:	68 53 4d 80 00       	push   $0x804d53
  803950:	e8 55 d9 ff ff       	call   8012aa <_panic>
  803955:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	89 50 04             	mov    %edx,0x4(%eax)
  803961:	8b 45 08             	mov    0x8(%ebp),%eax
  803964:	8b 40 04             	mov    0x4(%eax),%eax
  803967:	85 c0                	test   %eax,%eax
  803969:	74 0c                	je     803977 <insert_sorted_with_merge_freeList+0x10b>
  80396b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803970:	8b 55 08             	mov    0x8(%ebp),%edx
  803973:	89 10                	mov    %edx,(%eax)
  803975:	eb 08                	jmp    80397f <insert_sorted_with_merge_freeList+0x113>
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	a3 38 51 80 00       	mov    %eax,0x805138
  80397f:	8b 45 08             	mov    0x8(%ebp),%eax
  803982:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803987:	8b 45 08             	mov    0x8(%ebp),%eax
  80398a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803990:	a1 44 51 80 00       	mov    0x805144,%eax
  803995:	40                   	inc    %eax
  803996:	a3 44 51 80 00       	mov    %eax,0x805144
  80399b:	e9 d9 06 00 00       	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  8039a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a3:	8b 50 08             	mov    0x8(%eax),%edx
  8039a6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8039ab:	8b 40 08             	mov    0x8(%eax),%eax
  8039ae:	39 c2                	cmp    %eax,%edx
  8039b0:	0f 86 b5 00 00 00    	jbe    803a6b <insert_sorted_with_merge_freeList+0x1ff>
  8039b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b9:	8b 50 08             	mov    0x8(%eax),%edx
  8039bc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8039c1:	8b 48 0c             	mov    0xc(%eax),%ecx
  8039c4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8039c9:	8b 40 08             	mov    0x8(%eax),%eax
  8039cc:	01 c8                	add    %ecx,%eax
  8039ce:	39 c2                	cmp    %eax,%edx
  8039d0:	0f 85 95 00 00 00    	jne    803a6b <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  8039d6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8039db:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8039e1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8039e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8039e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8039ea:	01 ca                	add    %ecx,%edx
  8039ec:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8039ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8039f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803a03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a07:	75 17                	jne    803a20 <insert_sorted_with_merge_freeList+0x1b4>
  803a09:	83 ec 04             	sub    $0x4,%esp
  803a0c:	68 30 4d 80 00       	push   $0x804d30
  803a11:	68 54 01 00 00       	push   $0x154
  803a16:	68 53 4d 80 00       	push   $0x804d53
  803a1b:	e8 8a d8 ff ff       	call   8012aa <_panic>
  803a20:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a26:	8b 45 08             	mov    0x8(%ebp),%eax
  803a29:	89 10                	mov    %edx,(%eax)
  803a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2e:	8b 00                	mov    (%eax),%eax
  803a30:	85 c0                	test   %eax,%eax
  803a32:	74 0d                	je     803a41 <insert_sorted_with_merge_freeList+0x1d5>
  803a34:	a1 48 51 80 00       	mov    0x805148,%eax
  803a39:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3c:	89 50 04             	mov    %edx,0x4(%eax)
  803a3f:	eb 08                	jmp    803a49 <insert_sorted_with_merge_freeList+0x1dd>
  803a41:	8b 45 08             	mov    0x8(%ebp),%eax
  803a44:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a49:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4c:	a3 48 51 80 00       	mov    %eax,0x805148
  803a51:	8b 45 08             	mov    0x8(%ebp),%eax
  803a54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5b:	a1 54 51 80 00       	mov    0x805154,%eax
  803a60:	40                   	inc    %eax
  803a61:	a3 54 51 80 00       	mov    %eax,0x805154
  803a66:	e9 0e 06 00 00       	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6e:	8b 50 08             	mov    0x8(%eax),%edx
  803a71:	a1 38 51 80 00       	mov    0x805138,%eax
  803a76:	8b 40 08             	mov    0x8(%eax),%eax
  803a79:	39 c2                	cmp    %eax,%edx
  803a7b:	0f 83 c1 00 00 00    	jae    803b42 <insert_sorted_with_merge_freeList+0x2d6>
  803a81:	a1 38 51 80 00       	mov    0x805138,%eax
  803a86:	8b 50 08             	mov    0x8(%eax),%edx
  803a89:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8c:	8b 48 08             	mov    0x8(%eax),%ecx
  803a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a92:	8b 40 0c             	mov    0xc(%eax),%eax
  803a95:	01 c8                	add    %ecx,%eax
  803a97:	39 c2                	cmp    %eax,%edx
  803a99:	0f 85 a3 00 00 00    	jne    803b42 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803a9f:	a1 38 51 80 00       	mov    0x805138,%eax
  803aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa7:	8b 52 08             	mov    0x8(%edx),%edx
  803aaa:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  803aad:	a1 38 51 80 00       	mov    0x805138,%eax
  803ab2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803ab8:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803abb:	8b 55 08             	mov    0x8(%ebp),%edx
  803abe:	8b 52 0c             	mov    0xc(%edx),%edx
  803ac1:	01 ca                	add    %ecx,%edx
  803ac3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  803ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803ada:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ade:	75 17                	jne    803af7 <insert_sorted_with_merge_freeList+0x28b>
  803ae0:	83 ec 04             	sub    $0x4,%esp
  803ae3:	68 30 4d 80 00       	push   $0x804d30
  803ae8:	68 5d 01 00 00       	push   $0x15d
  803aed:	68 53 4d 80 00       	push   $0x804d53
  803af2:	e8 b3 d7 ff ff       	call   8012aa <_panic>
  803af7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803afd:	8b 45 08             	mov    0x8(%ebp),%eax
  803b00:	89 10                	mov    %edx,(%eax)
  803b02:	8b 45 08             	mov    0x8(%ebp),%eax
  803b05:	8b 00                	mov    (%eax),%eax
  803b07:	85 c0                	test   %eax,%eax
  803b09:	74 0d                	je     803b18 <insert_sorted_with_merge_freeList+0x2ac>
  803b0b:	a1 48 51 80 00       	mov    0x805148,%eax
  803b10:	8b 55 08             	mov    0x8(%ebp),%edx
  803b13:	89 50 04             	mov    %edx,0x4(%eax)
  803b16:	eb 08                	jmp    803b20 <insert_sorted_with_merge_freeList+0x2b4>
  803b18:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b20:	8b 45 08             	mov    0x8(%ebp),%eax
  803b23:	a3 48 51 80 00       	mov    %eax,0x805148
  803b28:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b32:	a1 54 51 80 00       	mov    0x805154,%eax
  803b37:	40                   	inc    %eax
  803b38:	a3 54 51 80 00       	mov    %eax,0x805154
  803b3d:	e9 37 05 00 00       	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  803b42:	8b 45 08             	mov    0x8(%ebp),%eax
  803b45:	8b 50 08             	mov    0x8(%eax),%edx
  803b48:	a1 38 51 80 00       	mov    0x805138,%eax
  803b4d:	8b 40 08             	mov    0x8(%eax),%eax
  803b50:	39 c2                	cmp    %eax,%edx
  803b52:	0f 83 82 00 00 00    	jae    803bda <insert_sorted_with_merge_freeList+0x36e>
  803b58:	a1 38 51 80 00       	mov    0x805138,%eax
  803b5d:	8b 50 08             	mov    0x8(%eax),%edx
  803b60:	8b 45 08             	mov    0x8(%ebp),%eax
  803b63:	8b 48 08             	mov    0x8(%eax),%ecx
  803b66:	8b 45 08             	mov    0x8(%ebp),%eax
  803b69:	8b 40 0c             	mov    0xc(%eax),%eax
  803b6c:	01 c8                	add    %ecx,%eax
  803b6e:	39 c2                	cmp    %eax,%edx
  803b70:	74 68                	je     803bda <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803b72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b76:	75 17                	jne    803b8f <insert_sorted_with_merge_freeList+0x323>
  803b78:	83 ec 04             	sub    $0x4,%esp
  803b7b:	68 30 4d 80 00       	push   $0x804d30
  803b80:	68 62 01 00 00       	push   $0x162
  803b85:	68 53 4d 80 00       	push   $0x804d53
  803b8a:	e8 1b d7 ff ff       	call   8012aa <_panic>
  803b8f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803b95:	8b 45 08             	mov    0x8(%ebp),%eax
  803b98:	89 10                	mov    %edx,(%eax)
  803b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9d:	8b 00                	mov    (%eax),%eax
  803b9f:	85 c0                	test   %eax,%eax
  803ba1:	74 0d                	je     803bb0 <insert_sorted_with_merge_freeList+0x344>
  803ba3:	a1 38 51 80 00       	mov    0x805138,%eax
  803ba8:	8b 55 08             	mov    0x8(%ebp),%edx
  803bab:	89 50 04             	mov    %edx,0x4(%eax)
  803bae:	eb 08                	jmp    803bb8 <insert_sorted_with_merge_freeList+0x34c>
  803bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbb:	a3 38 51 80 00       	mov    %eax,0x805138
  803bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bca:	a1 44 51 80 00       	mov    0x805144,%eax
  803bcf:	40                   	inc    %eax
  803bd0:	a3 44 51 80 00       	mov    %eax,0x805144
  803bd5:	e9 9f 04 00 00       	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803bda:	a1 38 51 80 00       	mov    0x805138,%eax
  803bdf:	8b 00                	mov    (%eax),%eax
  803be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803be4:	e9 84 04 00 00       	jmp    80406d <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bec:	8b 50 08             	mov    0x8(%eax),%edx
  803bef:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf2:	8b 40 08             	mov    0x8(%eax),%eax
  803bf5:	39 c2                	cmp    %eax,%edx
  803bf7:	0f 86 a9 00 00 00    	jbe    803ca6 <insert_sorted_with_merge_freeList+0x43a>
  803bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c00:	8b 50 08             	mov    0x8(%eax),%edx
  803c03:	8b 45 08             	mov    0x8(%ebp),%eax
  803c06:	8b 48 08             	mov    0x8(%eax),%ecx
  803c09:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  803c0f:	01 c8                	add    %ecx,%eax
  803c11:	39 c2                	cmp    %eax,%edx
  803c13:	0f 84 8d 00 00 00    	je     803ca6 <insert_sorted_with_merge_freeList+0x43a>
  803c19:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1c:	8b 50 08             	mov    0x8(%eax),%edx
  803c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c22:	8b 40 04             	mov    0x4(%eax),%eax
  803c25:	8b 48 08             	mov    0x8(%eax),%ecx
  803c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2b:	8b 40 04             	mov    0x4(%eax),%eax
  803c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c31:	01 c8                	add    %ecx,%eax
  803c33:	39 c2                	cmp    %eax,%edx
  803c35:	74 6f                	je     803ca6 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c3b:	74 06                	je     803c43 <insert_sorted_with_merge_freeList+0x3d7>
  803c3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c41:	75 17                	jne    803c5a <insert_sorted_with_merge_freeList+0x3ee>
  803c43:	83 ec 04             	sub    $0x4,%esp
  803c46:	68 90 4d 80 00       	push   $0x804d90
  803c4b:	68 6b 01 00 00       	push   $0x16b
  803c50:	68 53 4d 80 00       	push   $0x804d53
  803c55:	e8 50 d6 ff ff       	call   8012aa <_panic>
  803c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5d:	8b 50 04             	mov    0x4(%eax),%edx
  803c60:	8b 45 08             	mov    0x8(%ebp),%eax
  803c63:	89 50 04             	mov    %edx,0x4(%eax)
  803c66:	8b 45 08             	mov    0x8(%ebp),%eax
  803c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c6c:	89 10                	mov    %edx,(%eax)
  803c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c71:	8b 40 04             	mov    0x4(%eax),%eax
  803c74:	85 c0                	test   %eax,%eax
  803c76:	74 0d                	je     803c85 <insert_sorted_with_merge_freeList+0x419>
  803c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7b:	8b 40 04             	mov    0x4(%eax),%eax
  803c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  803c81:	89 10                	mov    %edx,(%eax)
  803c83:	eb 08                	jmp    803c8d <insert_sorted_with_merge_freeList+0x421>
  803c85:	8b 45 08             	mov    0x8(%ebp),%eax
  803c88:	a3 38 51 80 00       	mov    %eax,0x805138
  803c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c90:	8b 55 08             	mov    0x8(%ebp),%edx
  803c93:	89 50 04             	mov    %edx,0x4(%eax)
  803c96:	a1 44 51 80 00       	mov    0x805144,%eax
  803c9b:	40                   	inc    %eax
  803c9c:	a3 44 51 80 00       	mov    %eax,0x805144
				break;
  803ca1:	e9 d3 03 00 00       	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca9:	8b 50 08             	mov    0x8(%eax),%edx
  803cac:	8b 45 08             	mov    0x8(%ebp),%eax
  803caf:	8b 40 08             	mov    0x8(%eax),%eax
  803cb2:	39 c2                	cmp    %eax,%edx
  803cb4:	0f 86 da 00 00 00    	jbe    803d94 <insert_sorted_with_merge_freeList+0x528>
  803cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbd:	8b 50 08             	mov    0x8(%eax),%edx
  803cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc3:	8b 48 08             	mov    0x8(%eax),%ecx
  803cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc9:	8b 40 0c             	mov    0xc(%eax),%eax
  803ccc:	01 c8                	add    %ecx,%eax
  803cce:	39 c2                	cmp    %eax,%edx
  803cd0:	0f 85 be 00 00 00    	jne    803d94 <insert_sorted_with_merge_freeList+0x528>
  803cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd9:	8b 50 08             	mov    0x8(%eax),%edx
  803cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdf:	8b 40 04             	mov    0x4(%eax),%eax
  803ce2:	8b 48 08             	mov    0x8(%eax),%ecx
  803ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce8:	8b 40 04             	mov    0x4(%eax),%eax
  803ceb:	8b 40 0c             	mov    0xc(%eax),%eax
  803cee:	01 c8                	add    %ecx,%eax
  803cf0:	39 c2                	cmp    %eax,%edx
  803cf2:	0f 84 9c 00 00 00    	je     803d94 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfb:	8b 50 08             	mov    0x8(%eax),%edx
  803cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d01:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d07:	8b 50 0c             	mov    0xc(%eax),%edx
  803d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  803d10:	01 c2                	add    %eax,%edx
  803d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d15:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803d18:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803d22:	8b 45 08             	mov    0x8(%ebp),%eax
  803d25:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d30:	75 17                	jne    803d49 <insert_sorted_with_merge_freeList+0x4dd>
  803d32:	83 ec 04             	sub    $0x4,%esp
  803d35:	68 30 4d 80 00       	push   $0x804d30
  803d3a:	68 74 01 00 00       	push   $0x174
  803d3f:	68 53 4d 80 00       	push   $0x804d53
  803d44:	e8 61 d5 ff ff       	call   8012aa <_panic>
  803d49:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d52:	89 10                	mov    %edx,(%eax)
  803d54:	8b 45 08             	mov    0x8(%ebp),%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	85 c0                	test   %eax,%eax
  803d5b:	74 0d                	je     803d6a <insert_sorted_with_merge_freeList+0x4fe>
  803d5d:	a1 48 51 80 00       	mov    0x805148,%eax
  803d62:	8b 55 08             	mov    0x8(%ebp),%edx
  803d65:	89 50 04             	mov    %edx,0x4(%eax)
  803d68:	eb 08                	jmp    803d72 <insert_sorted_with_merge_freeList+0x506>
  803d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d72:	8b 45 08             	mov    0x8(%ebp),%eax
  803d75:	a3 48 51 80 00       	mov    %eax,0x805148
  803d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d84:	a1 54 51 80 00       	mov    0x805154,%eax
  803d89:	40                   	inc    %eax
  803d8a:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803d8f:	e9 e5 02 00 00       	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d97:	8b 50 08             	mov    0x8(%eax),%edx
  803d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9d:	8b 40 08             	mov    0x8(%eax),%eax
  803da0:	39 c2                	cmp    %eax,%edx
  803da2:	0f 86 d7 00 00 00    	jbe    803e7f <insert_sorted_with_merge_freeList+0x613>
  803da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dab:	8b 50 08             	mov    0x8(%eax),%edx
  803dae:	8b 45 08             	mov    0x8(%ebp),%eax
  803db1:	8b 48 08             	mov    0x8(%eax),%ecx
  803db4:	8b 45 08             	mov    0x8(%ebp),%eax
  803db7:	8b 40 0c             	mov    0xc(%eax),%eax
  803dba:	01 c8                	add    %ecx,%eax
  803dbc:	39 c2                	cmp    %eax,%edx
  803dbe:	0f 84 bb 00 00 00    	je     803e7f <insert_sorted_with_merge_freeList+0x613>
  803dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc7:	8b 50 08             	mov    0x8(%eax),%edx
  803dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dcd:	8b 40 04             	mov    0x4(%eax),%eax
  803dd0:	8b 48 08             	mov    0x8(%eax),%ecx
  803dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd6:	8b 40 04             	mov    0x4(%eax),%eax
  803dd9:	8b 40 0c             	mov    0xc(%eax),%eax
  803ddc:	01 c8                	add    %ecx,%eax
  803dde:	39 c2                	cmp    %eax,%edx
  803de0:	0f 85 99 00 00 00    	jne    803e7f <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de9:	8b 40 04             	mov    0x4(%eax),%eax
  803dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df2:	8b 50 0c             	mov    0xc(%eax),%edx
  803df5:	8b 45 08             	mov    0x8(%ebp),%eax
  803df8:	8b 40 0c             	mov    0xc(%eax),%eax
  803dfb:	01 c2                	add    %eax,%edx
  803dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e00:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803e03:	8b 45 08             	mov    0x8(%ebp),%eax
  803e06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803e17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e1b:	75 17                	jne    803e34 <insert_sorted_with_merge_freeList+0x5c8>
  803e1d:	83 ec 04             	sub    $0x4,%esp
  803e20:	68 30 4d 80 00       	push   $0x804d30
  803e25:	68 7d 01 00 00       	push   $0x17d
  803e2a:	68 53 4d 80 00       	push   $0x804d53
  803e2f:	e8 76 d4 ff ff       	call   8012aa <_panic>
  803e34:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3d:	89 10                	mov    %edx,(%eax)
  803e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e42:	8b 00                	mov    (%eax),%eax
  803e44:	85 c0                	test   %eax,%eax
  803e46:	74 0d                	je     803e55 <insert_sorted_with_merge_freeList+0x5e9>
  803e48:	a1 48 51 80 00       	mov    0x805148,%eax
  803e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  803e50:	89 50 04             	mov    %edx,0x4(%eax)
  803e53:	eb 08                	jmp    803e5d <insert_sorted_with_merge_freeList+0x5f1>
  803e55:	8b 45 08             	mov    0x8(%ebp),%eax
  803e58:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e60:	a3 48 51 80 00       	mov    %eax,0x805148
  803e65:	8b 45 08             	mov    0x8(%ebp),%eax
  803e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e6f:	a1 54 51 80 00       	mov    0x805154,%eax
  803e74:	40                   	inc    %eax
  803e75:	a3 54 51 80 00       	mov    %eax,0x805154
break;
  803e7a:	e9 fa 01 00 00       	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e82:	8b 50 08             	mov    0x8(%eax),%edx
  803e85:	8b 45 08             	mov    0x8(%ebp),%eax
  803e88:	8b 40 08             	mov    0x8(%eax),%eax
  803e8b:	39 c2                	cmp    %eax,%edx
  803e8d:	0f 86 d2 01 00 00    	jbe    804065 <insert_sorted_with_merge_freeList+0x7f9>
  803e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e96:	8b 50 08             	mov    0x8(%eax),%edx
  803e99:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9c:	8b 48 08             	mov    0x8(%eax),%ecx
  803e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ea5:	01 c8                	add    %ecx,%eax
  803ea7:	39 c2                	cmp    %eax,%edx
  803ea9:	0f 85 b6 01 00 00    	jne    804065 <insert_sorted_with_merge_freeList+0x7f9>
  803eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb2:	8b 50 08             	mov    0x8(%eax),%edx
  803eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb8:	8b 40 04             	mov    0x4(%eax),%eax
  803ebb:	8b 48 08             	mov    0x8(%eax),%ecx
  803ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec1:	8b 40 04             	mov    0x4(%eax),%eax
  803ec4:	8b 40 0c             	mov    0xc(%eax),%eax
  803ec7:	01 c8                	add    %ecx,%eax
  803ec9:	39 c2                	cmp    %eax,%edx
  803ecb:	0f 85 94 01 00 00    	jne    804065 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  803ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed4:	8b 40 04             	mov    0x4(%eax),%eax
  803ed7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eda:	8b 52 04             	mov    0x4(%edx),%edx
  803edd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  803ee3:	8b 5a 0c             	mov    0xc(%edx),%ebx
  803ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ee9:	8b 52 0c             	mov    0xc(%edx),%edx
  803eec:	01 da                	add    %ebx,%edx
  803eee:	01 ca                	add    %ecx,%edx
  803ef0:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  803ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  803efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f0b:	75 17                	jne    803f24 <insert_sorted_with_merge_freeList+0x6b8>
  803f0d:	83 ec 04             	sub    $0x4,%esp
  803f10:	68 c5 4d 80 00       	push   $0x804dc5
  803f15:	68 86 01 00 00       	push   $0x186
  803f1a:	68 53 4d 80 00       	push   $0x804d53
  803f1f:	e8 86 d3 ff ff       	call   8012aa <_panic>
  803f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f27:	8b 00                	mov    (%eax),%eax
  803f29:	85 c0                	test   %eax,%eax
  803f2b:	74 10                	je     803f3d <insert_sorted_with_merge_freeList+0x6d1>
  803f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f30:	8b 00                	mov    (%eax),%eax
  803f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f35:	8b 52 04             	mov    0x4(%edx),%edx
  803f38:	89 50 04             	mov    %edx,0x4(%eax)
  803f3b:	eb 0b                	jmp    803f48 <insert_sorted_with_merge_freeList+0x6dc>
  803f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f40:	8b 40 04             	mov    0x4(%eax),%eax
  803f43:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4b:	8b 40 04             	mov    0x4(%eax),%eax
  803f4e:	85 c0                	test   %eax,%eax
  803f50:	74 0f                	je     803f61 <insert_sorted_with_merge_freeList+0x6f5>
  803f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f55:	8b 40 04             	mov    0x4(%eax),%eax
  803f58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f5b:	8b 12                	mov    (%edx),%edx
  803f5d:	89 10                	mov    %edx,(%eax)
  803f5f:	eb 0a                	jmp    803f6b <insert_sorted_with_merge_freeList+0x6ff>
  803f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f64:	8b 00                	mov    (%eax),%eax
  803f66:	a3 38 51 80 00       	mov    %eax,0x805138
  803f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f7e:	a1 44 51 80 00       	mov    0x805144,%eax
  803f83:	48                   	dec    %eax
  803f84:	a3 44 51 80 00       	mov    %eax,0x805144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  803f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f8d:	75 17                	jne    803fa6 <insert_sorted_with_merge_freeList+0x73a>
  803f8f:	83 ec 04             	sub    $0x4,%esp
  803f92:	68 30 4d 80 00       	push   $0x804d30
  803f97:	68 87 01 00 00       	push   $0x187
  803f9c:	68 53 4d 80 00       	push   $0x804d53
  803fa1:	e8 04 d3 ff ff       	call   8012aa <_panic>
  803fa6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803faf:	89 10                	mov    %edx,(%eax)
  803fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb4:	8b 00                	mov    (%eax),%eax
  803fb6:	85 c0                	test   %eax,%eax
  803fb8:	74 0d                	je     803fc7 <insert_sorted_with_merge_freeList+0x75b>
  803fba:	a1 48 51 80 00       	mov    0x805148,%eax
  803fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fc2:	89 50 04             	mov    %edx,0x4(%eax)
  803fc5:	eb 08                	jmp    803fcf <insert_sorted_with_merge_freeList+0x763>
  803fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd2:	a3 48 51 80 00       	mov    %eax,0x805148
  803fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fe1:	a1 54 51 80 00       	mov    0x805154,%eax
  803fe6:	40                   	inc    %eax
  803fe7:	a3 54 51 80 00       	mov    %eax,0x805154
				blockToInsert->sva=0;
  803fec:	8b 45 08             	mov    0x8(%ebp),%eax
  803fef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  803ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  804000:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804004:	75 17                	jne    80401d <insert_sorted_with_merge_freeList+0x7b1>
  804006:	83 ec 04             	sub    $0x4,%esp
  804009:	68 30 4d 80 00       	push   $0x804d30
  80400e:	68 8a 01 00 00       	push   $0x18a
  804013:	68 53 4d 80 00       	push   $0x804d53
  804018:	e8 8d d2 ff ff       	call   8012aa <_panic>
  80401d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  804023:	8b 45 08             	mov    0x8(%ebp),%eax
  804026:	89 10                	mov    %edx,(%eax)
  804028:	8b 45 08             	mov    0x8(%ebp),%eax
  80402b:	8b 00                	mov    (%eax),%eax
  80402d:	85 c0                	test   %eax,%eax
  80402f:	74 0d                	je     80403e <insert_sorted_with_merge_freeList+0x7d2>
  804031:	a1 48 51 80 00       	mov    0x805148,%eax
  804036:	8b 55 08             	mov    0x8(%ebp),%edx
  804039:	89 50 04             	mov    %edx,0x4(%eax)
  80403c:	eb 08                	jmp    804046 <insert_sorted_with_merge_freeList+0x7da>
  80403e:	8b 45 08             	mov    0x8(%ebp),%eax
  804041:	a3 4c 51 80 00       	mov    %eax,0x80514c
  804046:	8b 45 08             	mov    0x8(%ebp),%eax
  804049:	a3 48 51 80 00       	mov    %eax,0x805148
  80404e:	8b 45 08             	mov    0x8(%ebp),%eax
  804051:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804058:	a1 54 51 80 00       	mov    0x805154,%eax
  80405d:	40                   	inc    %eax
  80405e:	a3 54 51 80 00       	mov    %eax,0x805154
				break;
  804063:	eb 14                	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  804065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804068:	8b 00                	mov    (%eax),%eax
  80406a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  80406d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804071:	0f 85 72 fb ff ff    	jne    803be9 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  804077:	eb 00                	jmp    804079 <insert_sorted_with_merge_freeList+0x80d>
  804079:	90                   	nop
  80407a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80407d:	c9                   	leave  
  80407e:	c3                   	ret    
  80407f:	90                   	nop

00804080 <__udivdi3>:
  804080:	55                   	push   %ebp
  804081:	57                   	push   %edi
  804082:	56                   	push   %esi
  804083:	53                   	push   %ebx
  804084:	83 ec 1c             	sub    $0x1c,%esp
  804087:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80408b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80408f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804093:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804097:	89 ca                	mov    %ecx,%edx
  804099:	89 f8                	mov    %edi,%eax
  80409b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80409f:	85 f6                	test   %esi,%esi
  8040a1:	75 2d                	jne    8040d0 <__udivdi3+0x50>
  8040a3:	39 cf                	cmp    %ecx,%edi
  8040a5:	77 65                	ja     80410c <__udivdi3+0x8c>
  8040a7:	89 fd                	mov    %edi,%ebp
  8040a9:	85 ff                	test   %edi,%edi
  8040ab:	75 0b                	jne    8040b8 <__udivdi3+0x38>
  8040ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8040b2:	31 d2                	xor    %edx,%edx
  8040b4:	f7 f7                	div    %edi
  8040b6:	89 c5                	mov    %eax,%ebp
  8040b8:	31 d2                	xor    %edx,%edx
  8040ba:	89 c8                	mov    %ecx,%eax
  8040bc:	f7 f5                	div    %ebp
  8040be:	89 c1                	mov    %eax,%ecx
  8040c0:	89 d8                	mov    %ebx,%eax
  8040c2:	f7 f5                	div    %ebp
  8040c4:	89 cf                	mov    %ecx,%edi
  8040c6:	89 fa                	mov    %edi,%edx
  8040c8:	83 c4 1c             	add    $0x1c,%esp
  8040cb:	5b                   	pop    %ebx
  8040cc:	5e                   	pop    %esi
  8040cd:	5f                   	pop    %edi
  8040ce:	5d                   	pop    %ebp
  8040cf:	c3                   	ret    
  8040d0:	39 ce                	cmp    %ecx,%esi
  8040d2:	77 28                	ja     8040fc <__udivdi3+0x7c>
  8040d4:	0f bd fe             	bsr    %esi,%edi
  8040d7:	83 f7 1f             	xor    $0x1f,%edi
  8040da:	75 40                	jne    80411c <__udivdi3+0x9c>
  8040dc:	39 ce                	cmp    %ecx,%esi
  8040de:	72 0a                	jb     8040ea <__udivdi3+0x6a>
  8040e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040e4:	0f 87 9e 00 00 00    	ja     804188 <__udivdi3+0x108>
  8040ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8040ef:	89 fa                	mov    %edi,%edx
  8040f1:	83 c4 1c             	add    $0x1c,%esp
  8040f4:	5b                   	pop    %ebx
  8040f5:	5e                   	pop    %esi
  8040f6:	5f                   	pop    %edi
  8040f7:	5d                   	pop    %ebp
  8040f8:	c3                   	ret    
  8040f9:	8d 76 00             	lea    0x0(%esi),%esi
  8040fc:	31 ff                	xor    %edi,%edi
  8040fe:	31 c0                	xor    %eax,%eax
  804100:	89 fa                	mov    %edi,%edx
  804102:	83 c4 1c             	add    $0x1c,%esp
  804105:	5b                   	pop    %ebx
  804106:	5e                   	pop    %esi
  804107:	5f                   	pop    %edi
  804108:	5d                   	pop    %ebp
  804109:	c3                   	ret    
  80410a:	66 90                	xchg   %ax,%ax
  80410c:	89 d8                	mov    %ebx,%eax
  80410e:	f7 f7                	div    %edi
  804110:	31 ff                	xor    %edi,%edi
  804112:	89 fa                	mov    %edi,%edx
  804114:	83 c4 1c             	add    $0x1c,%esp
  804117:	5b                   	pop    %ebx
  804118:	5e                   	pop    %esi
  804119:	5f                   	pop    %edi
  80411a:	5d                   	pop    %ebp
  80411b:	c3                   	ret    
  80411c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804121:	89 eb                	mov    %ebp,%ebx
  804123:	29 fb                	sub    %edi,%ebx
  804125:	89 f9                	mov    %edi,%ecx
  804127:	d3 e6                	shl    %cl,%esi
  804129:	89 c5                	mov    %eax,%ebp
  80412b:	88 d9                	mov    %bl,%cl
  80412d:	d3 ed                	shr    %cl,%ebp
  80412f:	89 e9                	mov    %ebp,%ecx
  804131:	09 f1                	or     %esi,%ecx
  804133:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804137:	89 f9                	mov    %edi,%ecx
  804139:	d3 e0                	shl    %cl,%eax
  80413b:	89 c5                	mov    %eax,%ebp
  80413d:	89 d6                	mov    %edx,%esi
  80413f:	88 d9                	mov    %bl,%cl
  804141:	d3 ee                	shr    %cl,%esi
  804143:	89 f9                	mov    %edi,%ecx
  804145:	d3 e2                	shl    %cl,%edx
  804147:	8b 44 24 08          	mov    0x8(%esp),%eax
  80414b:	88 d9                	mov    %bl,%cl
  80414d:	d3 e8                	shr    %cl,%eax
  80414f:	09 c2                	or     %eax,%edx
  804151:	89 d0                	mov    %edx,%eax
  804153:	89 f2                	mov    %esi,%edx
  804155:	f7 74 24 0c          	divl   0xc(%esp)
  804159:	89 d6                	mov    %edx,%esi
  80415b:	89 c3                	mov    %eax,%ebx
  80415d:	f7 e5                	mul    %ebp
  80415f:	39 d6                	cmp    %edx,%esi
  804161:	72 19                	jb     80417c <__udivdi3+0xfc>
  804163:	74 0b                	je     804170 <__udivdi3+0xf0>
  804165:	89 d8                	mov    %ebx,%eax
  804167:	31 ff                	xor    %edi,%edi
  804169:	e9 58 ff ff ff       	jmp    8040c6 <__udivdi3+0x46>
  80416e:	66 90                	xchg   %ax,%ax
  804170:	8b 54 24 08          	mov    0x8(%esp),%edx
  804174:	89 f9                	mov    %edi,%ecx
  804176:	d3 e2                	shl    %cl,%edx
  804178:	39 c2                	cmp    %eax,%edx
  80417a:	73 e9                	jae    804165 <__udivdi3+0xe5>
  80417c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80417f:	31 ff                	xor    %edi,%edi
  804181:	e9 40 ff ff ff       	jmp    8040c6 <__udivdi3+0x46>
  804186:	66 90                	xchg   %ax,%ax
  804188:	31 c0                	xor    %eax,%eax
  80418a:	e9 37 ff ff ff       	jmp    8040c6 <__udivdi3+0x46>
  80418f:	90                   	nop

00804190 <__umoddi3>:
  804190:	55                   	push   %ebp
  804191:	57                   	push   %edi
  804192:	56                   	push   %esi
  804193:	53                   	push   %ebx
  804194:	83 ec 1c             	sub    $0x1c,%esp
  804197:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80419b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80419f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041af:	89 f3                	mov    %esi,%ebx
  8041b1:	89 fa                	mov    %edi,%edx
  8041b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041b7:	89 34 24             	mov    %esi,(%esp)
  8041ba:	85 c0                	test   %eax,%eax
  8041bc:	75 1a                	jne    8041d8 <__umoddi3+0x48>
  8041be:	39 f7                	cmp    %esi,%edi
  8041c0:	0f 86 a2 00 00 00    	jbe    804268 <__umoddi3+0xd8>
  8041c6:	89 c8                	mov    %ecx,%eax
  8041c8:	89 f2                	mov    %esi,%edx
  8041ca:	f7 f7                	div    %edi
  8041cc:	89 d0                	mov    %edx,%eax
  8041ce:	31 d2                	xor    %edx,%edx
  8041d0:	83 c4 1c             	add    $0x1c,%esp
  8041d3:	5b                   	pop    %ebx
  8041d4:	5e                   	pop    %esi
  8041d5:	5f                   	pop    %edi
  8041d6:	5d                   	pop    %ebp
  8041d7:	c3                   	ret    
  8041d8:	39 f0                	cmp    %esi,%eax
  8041da:	0f 87 ac 00 00 00    	ja     80428c <__umoddi3+0xfc>
  8041e0:	0f bd e8             	bsr    %eax,%ebp
  8041e3:	83 f5 1f             	xor    $0x1f,%ebp
  8041e6:	0f 84 ac 00 00 00    	je     804298 <__umoddi3+0x108>
  8041ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8041f1:	29 ef                	sub    %ebp,%edi
  8041f3:	89 fe                	mov    %edi,%esi
  8041f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041f9:	89 e9                	mov    %ebp,%ecx
  8041fb:	d3 e0                	shl    %cl,%eax
  8041fd:	89 d7                	mov    %edx,%edi
  8041ff:	89 f1                	mov    %esi,%ecx
  804201:	d3 ef                	shr    %cl,%edi
  804203:	09 c7                	or     %eax,%edi
  804205:	89 e9                	mov    %ebp,%ecx
  804207:	d3 e2                	shl    %cl,%edx
  804209:	89 14 24             	mov    %edx,(%esp)
  80420c:	89 d8                	mov    %ebx,%eax
  80420e:	d3 e0                	shl    %cl,%eax
  804210:	89 c2                	mov    %eax,%edx
  804212:	8b 44 24 08          	mov    0x8(%esp),%eax
  804216:	d3 e0                	shl    %cl,%eax
  804218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80421c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804220:	89 f1                	mov    %esi,%ecx
  804222:	d3 e8                	shr    %cl,%eax
  804224:	09 d0                	or     %edx,%eax
  804226:	d3 eb                	shr    %cl,%ebx
  804228:	89 da                	mov    %ebx,%edx
  80422a:	f7 f7                	div    %edi
  80422c:	89 d3                	mov    %edx,%ebx
  80422e:	f7 24 24             	mull   (%esp)
  804231:	89 c6                	mov    %eax,%esi
  804233:	89 d1                	mov    %edx,%ecx
  804235:	39 d3                	cmp    %edx,%ebx
  804237:	0f 82 87 00 00 00    	jb     8042c4 <__umoddi3+0x134>
  80423d:	0f 84 91 00 00 00    	je     8042d4 <__umoddi3+0x144>
  804243:	8b 54 24 04          	mov    0x4(%esp),%edx
  804247:	29 f2                	sub    %esi,%edx
  804249:	19 cb                	sbb    %ecx,%ebx
  80424b:	89 d8                	mov    %ebx,%eax
  80424d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804251:	d3 e0                	shl    %cl,%eax
  804253:	89 e9                	mov    %ebp,%ecx
  804255:	d3 ea                	shr    %cl,%edx
  804257:	09 d0                	or     %edx,%eax
  804259:	89 e9                	mov    %ebp,%ecx
  80425b:	d3 eb                	shr    %cl,%ebx
  80425d:	89 da                	mov    %ebx,%edx
  80425f:	83 c4 1c             	add    $0x1c,%esp
  804262:	5b                   	pop    %ebx
  804263:	5e                   	pop    %esi
  804264:	5f                   	pop    %edi
  804265:	5d                   	pop    %ebp
  804266:	c3                   	ret    
  804267:	90                   	nop
  804268:	89 fd                	mov    %edi,%ebp
  80426a:	85 ff                	test   %edi,%edi
  80426c:	75 0b                	jne    804279 <__umoddi3+0xe9>
  80426e:	b8 01 00 00 00       	mov    $0x1,%eax
  804273:	31 d2                	xor    %edx,%edx
  804275:	f7 f7                	div    %edi
  804277:	89 c5                	mov    %eax,%ebp
  804279:	89 f0                	mov    %esi,%eax
  80427b:	31 d2                	xor    %edx,%edx
  80427d:	f7 f5                	div    %ebp
  80427f:	89 c8                	mov    %ecx,%eax
  804281:	f7 f5                	div    %ebp
  804283:	89 d0                	mov    %edx,%eax
  804285:	e9 44 ff ff ff       	jmp    8041ce <__umoddi3+0x3e>
  80428a:	66 90                	xchg   %ax,%ax
  80428c:	89 c8                	mov    %ecx,%eax
  80428e:	89 f2                	mov    %esi,%edx
  804290:	83 c4 1c             	add    $0x1c,%esp
  804293:	5b                   	pop    %ebx
  804294:	5e                   	pop    %esi
  804295:	5f                   	pop    %edi
  804296:	5d                   	pop    %ebp
  804297:	c3                   	ret    
  804298:	3b 04 24             	cmp    (%esp),%eax
  80429b:	72 06                	jb     8042a3 <__umoddi3+0x113>
  80429d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042a1:	77 0f                	ja     8042b2 <__umoddi3+0x122>
  8042a3:	89 f2                	mov    %esi,%edx
  8042a5:	29 f9                	sub    %edi,%ecx
  8042a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042ab:	89 14 24             	mov    %edx,(%esp)
  8042ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042b6:	8b 14 24             	mov    (%esp),%edx
  8042b9:	83 c4 1c             	add    $0x1c,%esp
  8042bc:	5b                   	pop    %ebx
  8042bd:	5e                   	pop    %esi
  8042be:	5f                   	pop    %edi
  8042bf:	5d                   	pop    %ebp
  8042c0:	c3                   	ret    
  8042c1:	8d 76 00             	lea    0x0(%esi),%esi
  8042c4:	2b 04 24             	sub    (%esp),%eax
  8042c7:	19 fa                	sbb    %edi,%edx
  8042c9:	89 d1                	mov    %edx,%ecx
  8042cb:	89 c6                	mov    %eax,%esi
  8042cd:	e9 71 ff ff ff       	jmp    804243 <__umoddi3+0xb3>
  8042d2:	66 90                	xchg   %ax,%ax
  8042d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042d8:	72 ea                	jb     8042c4 <__umoddi3+0x134>
  8042da:	89 d9                	mov    %ebx,%ecx
  8042dc:	e9 62 ff ff ff       	jmp    804243 <__umoddi3+0xb3>
