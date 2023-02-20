
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
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
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 80 44 80 00       	push   $0x804480
  80006a:	e8 6e 16 00 00       	call   8016dd <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 1a 2a 00 00       	call   802a91 <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 b2 2a 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 9c 25 00 00       	call   80262d <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 a4 44 80 00       	push   $0x8044a4
  8000af:	6a 11                	push   $0x11
  8000b1:	68 d4 44 80 00       	push   $0x8044d4
  8000b6:	e8 6e 13 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 ce 29 00 00       	call   802a91 <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 ec 44 80 00       	push   $0x8044ec
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 d4 44 80 00       	push   $0x8044d4
  8000db:	e8 49 13 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 4c 2a 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 58 45 80 00       	push   $0x804558
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 d4 44 80 00       	push   $0x8044d4
  8000fe:	e8 26 13 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 89 29 00 00       	call   802a91 <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 21 2a 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 0b 25 00 00       	call   80262d <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 a4 44 80 00       	push   $0x8044a4
  800147:	6a 1a                	push   $0x1a
  800149:	68 d4 44 80 00       	push   $0x8044d4
  80014e:	e8 d6 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 39 29 00 00       	call   802a91 <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 ec 44 80 00       	push   $0x8044ec
  800169:	6a 1c                	push   $0x1c
  80016b:	68 d4 44 80 00       	push   $0x8044d4
  800170:	e8 b4 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 b7 29 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 58 45 80 00       	push   $0x804558
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 d4 44 80 00       	push   $0x8044d4
  800193:	e8 91 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 f4 28 00 00       	call   802a91 <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 8c 29 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 76 24 00 00       	call   80262d <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 a4 44 80 00       	push   $0x8044a4
  8001d8:	6a 23                	push   $0x23
  8001da:	68 d4 44 80 00       	push   $0x8044d4
  8001df:	e8 45 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 a8 28 00 00       	call   802a91 <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 ec 44 80 00       	push   $0x8044ec
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 d4 44 80 00       	push   $0x8044d4
  800201:	e8 23 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 26 29 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 58 45 80 00       	push   $0x804558
  80021d:	6a 26                	push   $0x26
  80021f:	68 d4 44 80 00       	push   $0x8044d4
  800224:	e8 00 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 63 28 00 00       	call   802a91 <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 fb 28 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 e5 23 00 00       	call   80262d <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 a4 44 80 00       	push   $0x8044a4
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 d4 44 80 00       	push   $0x8044d4
  800274:	e8 b0 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 13 28 00 00       	call   802a91 <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 ec 44 80 00       	push   $0x8044ec
  80028f:	6a 2e                	push   $0x2e
  800291:	68 d4 44 80 00       	push   $0x8044d4
  800296:	e8 8e 11 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 91 28 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 58 45 80 00       	push   $0x804558
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 d4 44 80 00       	push   $0x8044d4
  8002b9:	e8 6b 11 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 ce 27 00 00       	call   802a91 <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 66 28 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 4e 23 00 00       	call   80262d <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 a4 44 80 00       	push   $0x8044a4
  800301:	6a 35                	push   $0x35
  800303:	68 d4 44 80 00       	push   $0x8044d4
  800308:	e8 1c 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 7c 27 00 00       	call   802a91 <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 ec 44 80 00       	push   $0x8044ec
  800326:	6a 37                	push   $0x37
  800328:	68 d4 44 80 00       	push   $0x8044d4
  80032d:	e8 f7 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 fa 27 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 58 45 80 00       	push   $0x804558
  800349:	6a 38                	push   $0x38
  80034b:	68 d4 44 80 00       	push   $0x8044d4
  800350:	e8 d4 10 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 37 27 00 00       	call   802a91 <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 cf 27 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 b7 22 00 00       	call   80262d <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 a4 44 80 00       	push   $0x8044a4
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 d4 44 80 00       	push   $0x8044d4
  8003a4:	e8 80 10 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 e3 26 00 00       	call   802a91 <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 ec 44 80 00       	push   $0x8044ec
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 d4 44 80 00       	push   $0x8044d4
  8003c6:	e8 5e 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 61 27 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 58 45 80 00       	push   $0x804558
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 d4 44 80 00       	push   $0x8044d4
  8003e9:	e8 3b 10 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 9e 26 00 00       	call   802a91 <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 36 27 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 1a 22 00 00       	call   80262d <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 a4 44 80 00       	push   $0x8044a4
  800435:	6a 47                	push   $0x47
  800437:	68 d4 44 80 00       	push   $0x8044d4
  80043c:	e8 e8 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 48 26 00 00       	call   802a91 <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 ec 44 80 00       	push   $0x8044ec
  80045a:	6a 49                	push   $0x49
  80045c:	68 d4 44 80 00       	push   $0x8044d4
  800461:	e8 c3 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 c6 26 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 58 45 80 00       	push   $0x804558
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 d4 44 80 00       	push   $0x8044d4
  800484:	e8 a0 0f 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 03 26 00 00       	call   802a91 <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 9b 26 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 7f 21 00 00       	call   80262d <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 a4 44 80 00       	push   $0x8044a4
  8004d8:	6a 50                	push   $0x50
  8004da:	68 d4 44 80 00       	push   $0x8044d4
  8004df:	e8 45 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 a5 25 00 00       	call   802a91 <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 ec 44 80 00       	push   $0x8044ec
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 d4 44 80 00       	push   $0x8044d4
  800504:	e8 20 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 23 26 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 58 45 80 00       	push   $0x804558
  800520:	6a 53                	push   $0x53
  800522:	68 d4 44 80 00       	push   $0x8044d4
  800527:	e8 fd 0e 00 00       	call   801429 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 60 25 00 00       	call   802a91 <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 f8 25 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 c9 20 00 00       	call   80262d <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 a4 44 80 00       	push   $0x8044a4
  80058f:	6a 59                	push   $0x59
  800591:	68 d4 44 80 00       	push   $0x8044d4
  800596:	e8 8e 0e 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 ee 24 00 00       	call   802a91 <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 ec 44 80 00       	push   $0x8044ec
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 d4 44 80 00       	push   $0x8044d4
  8005bb:	e8 69 0e 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 6c 25 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 58 45 80 00       	push   $0x804558
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 d4 44 80 00       	push   $0x8044d4
  8005de:	e8 46 0e 00 00       	call   801429 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 a9 24 00 00       	call   802a91 <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 41 25 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 b6 20 00 00       	call   8026b8 <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 27 25 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 88 45 80 00       	push   $0x804588
  800620:	6a 67                	push   $0x67
  800622:	68 d4 44 80 00       	push   $0x8044d4
  800627:	e8 fd 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 60 24 00 00       	call   802a91 <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 c4 45 80 00       	push   $0x8045c4
  800642:	6a 68                	push   $0x68
  800644:	68 d4 44 80 00       	push   $0x8044d4
  800649:	e8 db 0d 00 00       	call   801429 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 3e 24 00 00       	call   802a91 <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 d6 24 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 4e 20 00 00       	call   8026b8 <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 bf 24 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 88 45 80 00       	push   $0x804588
  800688:	6a 6f                	push   $0x6f
  80068a:	68 d4 44 80 00       	push   $0x8044d4
  80068f:	e8 95 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 f8 23 00 00       	call   802a91 <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 c4 45 80 00       	push   $0x8045c4
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 d4 44 80 00       	push   $0x8044d4
  8006b1:	e8 73 0d 00 00       	call   801429 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 d6 23 00 00       	call   802a91 <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 6e 24 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 e6 1f 00 00       	call   8026b8 <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 57 24 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 88 45 80 00       	push   $0x804588
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 d4 44 80 00       	push   $0x8044d4
  8006f7:	e8 2d 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 90 23 00 00       	call   802a91 <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 c4 45 80 00       	push   $0x8045c4
  800712:	6a 78                	push   $0x78
  800714:	68 d4 44 80 00       	push   $0x8044d4
  800719:	e8 0b 0d 00 00       	call   801429 <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 fa 26 00 00       	call   802e29 <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 51 23 00 00       	call   802a91 <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 e9 23 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 b3 21 00 00       	call   80290f <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 10 46 80 00       	push   $0x804610
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 d4 44 80 00       	push   $0x8044d4
  800781:	e8 a3 0c 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 06 23 00 00       	call   802a91 <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 58 46 80 00       	push   $0x804658
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 d4 44 80 00       	push   $0x8044d4
  8007a6:	e8 7e 0c 00 00       	call   801429 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 81 23 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 c8 46 80 00       	push   $0x8046c8
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 d4 44 80 00       	push   $0x8044d4
  8007d0:	e8 54 0c 00 00       	call   801429 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 30 26 00 00       	call   802e10 <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 fc 46 80 00       	push   $0x8046fc
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 d4 44 80 00       	push   $0x8044d4
  8007fb:	e8 29 0c 00 00       	call   801429 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 fa 25 00 00       	call   802e10 <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 50 47 80 00       	push   $0x804750
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 d4 44 80 00       	push   $0x8044d4
  80083c:	e8 e8 0b 00 00       	call   801429 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 de 25 00 00       	call   802e29 <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 9e 47 80 00       	push   $0x80479e
  800858:	e8 15 0e 00 00       	call   801672 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 2c 22 00 00       	call   802a91 <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 c4 22 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 81 20 00 00       	call   80290f <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 a4 44 80 00       	push   $0x8044a4
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 d4 44 80 00       	push   $0x8044d4
  8008ba:	e8 6a 0b 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 cd 21 00 00       	call   802a91 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 58 46 80 00       	push   $0x804658
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 d4 44 80 00       	push   $0x8044d4
  8008df:	e8 45 0b 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 48 22 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 c8 46 80 00       	push   $0x8046c8
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 d4 44 80 00       	push   $0x8044d4
  800905:	e8 1f 0b 00 00       	call   801429 <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 a8 47 80 00       	push   $0x8047a8
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 d4 44 80 00       	push   $0x8044d4
  8009b5:	e8 6f 0a 00 00       	call   801429 <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 a8 47 80 00       	push   $0x8047a8
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 d4 44 80 00       	push   $0x8044d4
  8009f6:	e8 2e 0a 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 e0 47 80 00       	push   $0x8047e0
  800a13:	e8 5a 0c 00 00       	call   801672 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 71 20 00 00       	call   802a91 <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 09 21 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 bb 1e 00 00       	call   80290f <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 e8 47 80 00       	push   $0x8047e8
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 d4 44 80 00       	push   $0x8044d4
  800a80:	e8 a4 09 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 07 20 00 00       	call   802a91 <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 58 46 80 00       	push   $0x804658
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 d4 44 80 00       	push   $0x8044d4
  800aa5:	e8 7f 09 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 82 20 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 c8 46 80 00       	push   $0x8046c8
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 d4 44 80 00       	push   $0x8044d4
  800ac6:	e8 5e 09 00 00       	call   801429 <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 a8 47 80 00       	push   $0x8047a8
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 d4 44 80 00       	push   $0x8044d4
  800b75:	e8 af 08 00 00       	call   801429 <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 a8 47 80 00       	push   $0x8047a8
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 d4 44 80 00       	push   $0x8044d4
  800bb7:	e8 6d 08 00 00       	call   801429 <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 a8 47 80 00       	push   $0x8047a8
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 d4 44 80 00       	push   $0x8044d4
  800bfe:	e8 26 08 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 a8 47 80 00       	push   $0x8047a8
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 d4 44 80 00       	push   $0x8044d4
  800c44:	e8 e0 07 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 35 1e 00 00       	call   802a91 <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 cd 1e 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 45 1a 00 00       	call   8026b8 <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 b6 1e 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 1c 48 80 00       	push   $0x80481c
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 d4 44 80 00       	push   $0x8044d4
  800c9b:	e8 89 07 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 ec 1d 00 00       	call   802a91 <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 70 48 80 00       	push   $0x804870
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 d4 44 80 00       	push   $0x8044d4
  800cc5:	e8 5f 07 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 d4 48 80 00       	push   $0x8048d4
  800cd4:	e8 99 09 00 00       	call   801672 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 49 1d 00 00       	call   802a91 <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 e1 1d 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 93 1b 00 00       	call   80290f <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 e8 47 80 00       	push   $0x8047e8
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 d4 44 80 00       	push   $0x8044d4
  800d9b:	e8 89 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 ec 1c 00 00       	call   802a91 <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 58 46 80 00       	push   $0x804658
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 d4 44 80 00       	push   $0x8044d4
  800dc0:	e8 64 06 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 67 1d 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 c8 46 80 00       	push   $0x8046c8
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 d4 44 80 00       	push   $0x8044d4
  800de1:	e8 43 06 00 00       	call   801429 <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 a8 47 80 00       	push   $0x8047a8
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 d4 44 80 00       	push   $0x8044d4
  800e1a:	e8 0a 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 a8 47 80 00       	push   $0x8047a8
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 d4 44 80 00       	push   $0x8044d4
  800e5b:	e8 c9 05 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 1e 1c 00 00       	call   802a91 <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 b6 1c 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 2f 18 00 00       	call   8026b8 <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 a0 1c 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 1c 48 80 00       	push   $0x80481c
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 d4 44 80 00       	push   $0x8044d4
  800eb1:	e8 73 05 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 d6 1b 00 00       	call   802a91 <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 70 48 80 00       	push   $0x804870
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 d4 44 80 00       	push   $0x8044d4
  800edb:	e8 49 05 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 db 48 80 00       	push   $0x8048db
  800eea:	e8 83 07 00 00       	call   801672 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 9a 1b 00 00       	call   802a91 <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 32 1c 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 1a 17 00 00       	call   80262d <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 a4 44 80 00       	push   $0x8044a4
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 d4 44 80 00       	push   $0x8044d4
  800f35:	e8 ef 04 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 52 1b 00 00       	call   802a91 <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 ec 44 80 00       	push   $0x8044ec
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 d4 44 80 00       	push   $0x8044d4
  800f5a:	e8 ca 04 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 cd 1b 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 58 45 80 00       	push   $0x804558
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 d4 44 80 00       	push   $0x8044d4
  800f80:	e8 a4 04 00 00       	call   801429 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 07 1b 00 00       	call   802a91 <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 9f 1b 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 17 17 00 00       	call   8026b8 <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 88 1b 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 88 45 80 00       	push   $0x804588
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 d4 44 80 00       	push   $0x8044d4
  800fc9:	e8 5b 04 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 be 1a 00 00       	call   802a91 <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 c4 45 80 00       	push   $0x8045c4
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 d4 44 80 00       	push   $0x8044d4
  800fee:	e8 36 04 00 00       	call   801429 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 24 16 00 00       	call   80262d <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 10 1a 00 00       	call   802a91 <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 a8 1a 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 6b 18 00 00       	call   80290f <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 e8 47 80 00       	push   $0x8047e8
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 d4 44 80 00       	push   $0x8044d4
  8010cf:	e8 55 03 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 58 1a 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 c8 46 80 00       	push   $0x8046c8
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 d4 44 80 00       	push   $0x8044d4
  8010f5:	e8 2f 03 00 00       	call   801429 <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 a8 47 80 00       	push   $0x8047a8
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 d4 44 80 00       	push   $0x8044d4
  801199:	e8 8b 02 00 00       	call   801429 <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 a8 47 80 00       	push   $0x8047a8
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 d4 44 80 00       	push   $0x8044d4
  8011da:	e8 4a 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 a8 47 80 00       	push   $0x8047a8
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 d4 44 80 00       	push   $0x8044d4
  801221:	e8 03 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 a8 47 80 00       	push   $0x8047a8
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 d4 44 80 00       	push   $0x8044d4
  801267:	e8 bd 01 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 12 18 00 00       	call   802a91 <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 aa 18 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 22 14 00 00       	call   8026b8 <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 93 18 00 00       	call   802b31 <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 1c 48 80 00       	push   $0x80481c
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 d4 44 80 00       	push   $0x8044d4
  8012be:	e8 66 01 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 e2 48 80 00       	push   $0x8048e2
  8012cd:	e8 a0 03 00 00       	call   801672 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 ec 48 80 00       	push   $0x8048ec
  8012dd:	e8 fb 03 00 00       	call   8016dd <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 79 1a 00 00       	call   802d71 <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	c1 e0 03             	shl    $0x3,%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	01 c0                	add    %eax,%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	01 d0                	add    %edx,%eax
  801312:	c1 e0 04             	shl    $0x4,%eax
  801315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131a:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80131f:	a1 20 60 80 00       	mov    0x806020,%eax
  801324:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80132a:	84 c0                	test   %al,%al
  80132c:	74 0f                	je     80133d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80132e:	a1 20 60 80 00       	mov    0x806020,%eax
  801333:	05 5c 05 00 00       	add    $0x55c,%eax
  801338:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80133d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801341:	7e 0a                	jle    80134d <libmain+0x60>
		binaryname = argv[0];
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 dd ec ff ff       	call   800038 <_main>
  80135b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80135e:	e8 1b 18 00 00       	call   802b7e <sys_disable_interrupt>
	cprintf("**************************************\n");
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	68 40 49 80 00       	push   $0x804940
  80136b:	e8 6d 03 00 00       	call   8016dd <cprintf>
  801370:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801373:	a1 20 60 80 00       	mov    0x806020,%eax
  801378:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80137e:	a1 20 60 80 00       	mov    0x806020,%eax
  801383:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	52                   	push   %edx
  80138d:	50                   	push   %eax
  80138e:	68 68 49 80 00       	push   $0x804968
  801393:	e8 45 03 00 00       	call   8016dd <cprintf>
  801398:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80139b:	a1 20 60 80 00       	mov    0x806020,%eax
  8013a0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8013a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8013ab:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8013b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8013b6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8013bc:	51                   	push   %ecx
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	68 90 49 80 00       	push   $0x804990
  8013c4:	e8 14 03 00 00       	call   8016dd <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8013d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	50                   	push   %eax
  8013db:	68 e8 49 80 00       	push   $0x8049e8
  8013e0:	e8 f8 02 00 00       	call   8016dd <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	68 40 49 80 00       	push   $0x804940
  8013f0:	e8 e8 02 00 00       	call   8016dd <cprintf>
  8013f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8013f8:	e8 9b 17 00 00       	call   802b98 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8013fd:	e8 19 00 00 00       	call   80141b <exit>
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	6a 00                	push   $0x0
  801410:	e8 28 19 00 00       	call   802d3d <sys_destroy_env>
  801415:	83 c4 10             	add    $0x10,%esp
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <exit>:

void
exit(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801421:	e8 7d 19 00 00       	call   802da3 <sys_exit_env>
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80142f:	8d 45 10             	lea    0x10(%ebp),%eax
  801432:	83 c0 04             	add    $0x4,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801438:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 16                	je     801457 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801441:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	50                   	push   %eax
  80144a:	68 fc 49 80 00       	push   $0x8049fc
  80144f:	e8 89 02 00 00       	call   8016dd <cprintf>
  801454:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801457:	a1 00 60 80 00       	mov    0x806000,%eax
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	50                   	push   %eax
  801463:	68 01 4a 80 00       	push   $0x804a01
  801468:	e8 70 02 00 00       	call   8016dd <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	ff 75 f4             	pushl  -0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	e8 f3 01 00 00       	call   801672 <vcprintf>
  80147f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	6a 00                	push   $0x0
  801487:	68 1d 4a 80 00       	push   $0x804a1d
  80148c:	e8 e1 01 00 00       	call   801672 <vcprintf>
  801491:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801494:	e8 82 ff ff ff       	call   80141b <exit>

	// should not return here
	while (1) ;
  801499:	eb fe                	jmp    801499 <_panic+0x70>

0080149b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8014a6:	8b 50 74             	mov    0x74(%eax),%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	39 c2                	cmp    %eax,%edx
  8014ae:	74 14                	je     8014c4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 20 4a 80 00       	push   $0x804a20
  8014b8:	6a 26                	push   $0x26
  8014ba:	68 6c 4a 80 00       	push   $0x804a6c
  8014bf:	e8 65 ff ff ff       	call   801429 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014d2:	e9 c2 00 00 00       	jmp    801599 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 08                	jne    8014f4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8014ef:	e9 a2 00 00 00       	jmp    801596 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8014f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801502:	eb 69                	jmp    80156d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801504:	a1 20 60 80 00       	mov    0x806020,%eax
  801509:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	01 c0                	add    %eax,%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c1 e0 03             	shl    $0x3,%eax
  80151b:	01 c8                	add    %ecx,%eax
  80151d:	8a 40 04             	mov    0x4(%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 46                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801524:	a1 20 60 80 00       	mov    0x806020,%eax
  801529:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80152f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	01 c0                	add    %eax,%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	c1 e0 03             	shl    $0x3,%eax
  80153b:	01 c8                	add    %ecx,%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801545:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	01 c8                	add    %ecx,%eax
  80155b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80155d:	39 c2                	cmp    %eax,%edx
  80155f:	75 09                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801561:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801568:	eb 12                	jmp    80157c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80156a:	ff 45 e8             	incl   -0x18(%ebp)
  80156d:	a1 20 60 80 00       	mov    0x806020,%eax
  801572:	8b 50 74             	mov    0x74(%eax),%edx
  801575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801578:	39 c2                	cmp    %eax,%edx
  80157a:	77 88                	ja     801504 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801580:	75 14                	jne    801596 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 78 4a 80 00       	push   $0x804a78
  80158a:	6a 3a                	push   $0x3a
  80158c:	68 6c 4a 80 00       	push   $0x804a6c
  801591:	e8 93 fe ff ff       	call   801429 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801596:	ff 45 f0             	incl   -0x10(%ebp)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80159f:	0f 8c 32 ff ff ff    	jl     8014d7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015b3:	eb 26                	jmp    8015db <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8015ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8015c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	01 c0                	add    %eax,%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c1 e0 03             	shl    $0x3,%eax
  8015cc:	01 c8                	add    %ecx,%eax
  8015ce:	8a 40 04             	mov    0x4(%eax),%al
  8015d1:	3c 01                	cmp    $0x1,%al
  8015d3:	75 03                	jne    8015d8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8015d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015d8:	ff 45 e0             	incl   -0x20(%ebp)
  8015db:	a1 20 60 80 00       	mov    0x806020,%eax
  8015e0:	8b 50 74             	mov    0x74(%eax),%edx
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	39 c2                	cmp    %eax,%edx
  8015e8:	77 cb                	ja     8015b5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015f0:	74 14                	je     801606 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 cc 4a 80 00       	push   $0x804acc
  8015fa:	6a 44                	push   $0x44
  8015fc:	68 6c 4a 80 00       	push   $0x804a6c
  801601:	e8 23 fe ff ff       	call   801429 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	8d 48 01             	lea    0x1(%eax),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	89 0a                	mov    %ecx,(%edx)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	88 d1                	mov    %dl,%cl
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801632:	75 2c                	jne    801660 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801634:	a0 24 60 80 00       	mov    0x806024,%al
  801639:	0f b6 c0             	movzbl %al,%eax
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 12                	mov    (%edx),%edx
  801641:	89 d1                	mov    %edx,%ecx
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	83 c2 08             	add    $0x8,%edx
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	50                   	push   %eax
  80164d:	51                   	push   %ecx
  80164e:	52                   	push   %edx
  80164f:	e8 7c 13 00 00       	call   8029d0 <sys_cputs>
  801654:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	8b 40 04             	mov    0x4(%eax),%eax
  801666:	8d 50 01             	lea    0x1(%eax),%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80167b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801682:	00 00 00 
	b.cnt = 0;
  801685:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80168c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	68 09 16 80 00       	push   $0x801609
  8016a1:	e8 11 02 00 00       	call   8018b7 <vprintfmt>
  8016a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016a9:	a0 24 60 80 00       	mov    0x806024,%al
  8016ae:	0f b6 c0             	movzbl %al,%eax
  8016b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	50                   	push   %eax
  8016bb:	52                   	push   %edx
  8016bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016c2:	83 c0 08             	add    $0x8,%eax
  8016c5:	50                   	push   %eax
  8016c6:	e8 05 13 00 00       	call   8029d0 <sys_cputs>
  8016cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016ce:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  8016d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016e3:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  8016ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	e8 73 ff ff ff       	call   801672 <vcprintf>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801710:	e8 69 14 00 00       	call   802b7e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801715:	8d 45 0c             	lea    0xc(%ebp),%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	e8 48 ff ff ff       	call   801672 <vcprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801730:	e8 63 14 00 00       	call   802b98 <sys_enable_interrupt>
	return cnt;
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
  801741:	8b 45 10             	mov    0x10(%ebp),%eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80174d:	8b 45 18             	mov    0x18(%ebp),%eax
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801758:	77 55                	ja     8017af <printnum+0x75>
  80175a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80175d:	72 05                	jb     801764 <printnum+0x2a>
  80175f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801762:	77 4b                	ja     8017af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801764:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80176a:	8b 45 18             	mov    0x18(%ebp),%eax
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	ff 75 f4             	pushl  -0xc(%ebp)
  801777:	ff 75 f0             	pushl  -0x10(%ebp)
  80177a:	e8 81 2a 00 00       	call   804200 <__udivdi3>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	ff 75 20             	pushl  0x20(%ebp)
  801788:	53                   	push   %ebx
  801789:	ff 75 18             	pushl  0x18(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 a1 ff ff ff       	call   80173a <printnum>
  801799:	83 c4 20             	add    $0x20,%esp
  80179c:	eb 1a                	jmp    8017b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 20             	pushl  0x20(%ebp)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	ff d0                	call   *%eax
  8017ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017af:	ff 4d 1c             	decl   0x1c(%ebp)
  8017b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017b6:	7f e6                	jg     80179e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	53                   	push   %ebx
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	e8 41 2b 00 00       	call   804310 <__umoddi3>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	05 34 4d 80 00       	add    $0x804d34,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	ff d0                	call   *%eax
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	90                   	nop
  8017ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017f8:	7e 1c                	jle    801816 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 00                	mov    (%eax),%eax
  8017ff:	8d 50 08             	lea    0x8(%eax),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	89 10                	mov    %edx,(%eax)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	83 e8 08             	sub    $0x8,%eax
  80180f:	8b 50 04             	mov    0x4(%eax),%edx
  801812:	8b 00                	mov    (%eax),%eax
  801814:	eb 40                	jmp    801856 <getuint+0x65>
	else if (lflag)
  801816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181a:	74 1e                	je     80183a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	8d 50 04             	lea    0x4(%eax),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 10                	mov    %edx,(%eax)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	83 e8 04             	sub    $0x4,%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	eb 1c                	jmp    801856 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	8d 50 04             	lea    0x4(%eax),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	89 10                	mov    %edx,(%eax)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	83 e8 04             	sub    $0x4,%eax
  80184f:	8b 00                	mov    (%eax),%eax
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80185b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80185f:	7e 1c                	jle    80187d <getint+0x25>
		return va_arg(*ap, long long);
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 00                	mov    (%eax),%eax
  801866:	8d 50 08             	lea    0x8(%eax),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 10                	mov    %edx,(%eax)
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	83 e8 08             	sub    $0x8,%eax
  801876:	8b 50 04             	mov    0x4(%eax),%edx
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	eb 38                	jmp    8018b5 <getint+0x5d>
	else if (lflag)
  80187d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801881:	74 1a                	je     80189d <getint+0x45>
		return va_arg(*ap, long);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	8d 50 04             	lea    0x4(%eax),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 10                	mov    %edx,(%eax)
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	83 e8 04             	sub    $0x4,%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	99                   	cltd   
  80189b:	eb 18                	jmp    8018b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 00                	mov    (%eax),%eax
  8018a2:	8d 50 04             	lea    0x4(%eax),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	83 e8 04             	sub    $0x4,%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	99                   	cltd   
}
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018bf:	eb 17                	jmp    8018d8 <vprintfmt+0x21>
			if (ch == '\0')
  8018c1:	85 db                	test   %ebx,%ebx
  8018c3:	0f 84 af 03 00 00    	je     801c78 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	53                   	push   %ebx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	ff d0                	call   *%eax
  8018d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	8d 50 01             	lea    0x1(%eax),%edx
  8018de:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f b6 d8             	movzbl %al,%ebx
  8018e6:	83 fb 25             	cmp    $0x25,%ebx
  8018e9:	75 d6                	jne    8018c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8018ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8018f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801904:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	8d 50 01             	lea    0x1(%eax),%edx
  801911:	89 55 10             	mov    %edx,0x10(%ebp)
  801914:	8a 00                	mov    (%eax),%al
  801916:	0f b6 d8             	movzbl %al,%ebx
  801919:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80191c:	83 f8 55             	cmp    $0x55,%eax
  80191f:	0f 87 2b 03 00 00    	ja     801c50 <vprintfmt+0x399>
  801925:	8b 04 85 58 4d 80 00 	mov    0x804d58(,%eax,4),%eax
  80192c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80192e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801932:	eb d7                	jmp    80190b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801934:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801938:	eb d1                	jmp    80190b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80193a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	c1 e0 02             	shl    $0x2,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d8                	add    %ebx,%eax
  80194f:	83 e8 30             	sub    $0x30,%eax
  801952:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80195d:	83 fb 2f             	cmp    $0x2f,%ebx
  801960:	7e 3e                	jle    8019a0 <vprintfmt+0xe9>
  801962:	83 fb 39             	cmp    $0x39,%ebx
  801965:	7f 39                	jg     8019a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801967:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80196a:	eb d5                	jmp    801941 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	83 c0 04             	add    $0x4,%eax
  801972:	89 45 14             	mov    %eax,0x14(%ebp)
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	83 e8 04             	sub    $0x4,%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801980:	eb 1f                	jmp    8019a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801986:	79 83                	jns    80190b <vprintfmt+0x54>
				width = 0;
  801988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80198f:	e9 77 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801994:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80199b:	e9 6b ff ff ff       	jmp    80190b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8019a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8019a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019a5:	0f 89 60 ff ff ff    	jns    80190b <vprintfmt+0x54>
				width = precision, precision = -1;
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019b8:	e9 4e ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019c0:	e9 46 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	83 c0 04             	add    $0x4,%eax
  8019cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	83 e8 04             	sub    $0x4,%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	ff d0                	call   *%eax
  8019e2:	83 c4 10             	add    $0x10,%esp
			break;
  8019e5:	e9 89 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	83 c0 04             	add    $0x4,%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	83 e8 04             	sub    $0x4,%eax
  8019f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019fb:	85 db                	test   %ebx,%ebx
  8019fd:	79 02                	jns    801a01 <vprintfmt+0x14a>
				err = -err;
  8019ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801a01:	83 fb 64             	cmp    $0x64,%ebx
  801a04:	7f 0b                	jg     801a11 <vprintfmt+0x15a>
  801a06:	8b 34 9d a0 4b 80 00 	mov    0x804ba0(,%ebx,4),%esi
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	75 19                	jne    801a2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a11:	53                   	push   %ebx
  801a12:	68 45 4d 80 00       	push   $0x804d45
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 5e 02 00 00       	call   801c80 <printfmt>
  801a22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a25:	e9 49 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a2a:	56                   	push   %esi
  801a2b:	68 4e 4d 80 00       	push   $0x804d4e
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 45 02 00 00       	call   801c80 <printfmt>
  801a3b:	83 c4 10             	add    $0x10,%esp
			break;
  801a3e:	e9 30 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	83 c0 04             	add    $0x4,%eax
  801a49:	89 45 14             	mov    %eax,0x14(%ebp)
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	83 e8 04             	sub    $0x4,%eax
  801a52:	8b 30                	mov    (%eax),%esi
  801a54:	85 f6                	test   %esi,%esi
  801a56:	75 05                	jne    801a5d <vprintfmt+0x1a6>
				p = "(null)";
  801a58:	be 51 4d 80 00       	mov    $0x804d51,%esi
			if (width > 0 && padc != '-')
  801a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a61:	7e 6d                	jle    801ad0 <vprintfmt+0x219>
  801a63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a67:	74 67                	je     801ad0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	50                   	push   %eax
  801a70:	56                   	push   %esi
  801a71:	e8 0c 03 00 00       	call   801d82 <strnlen>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a7c:	eb 16                	jmp    801a94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	ff d0                	call   *%eax
  801a8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a91:	ff 4d e4             	decl   -0x1c(%ebp)
  801a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a98:	7f e4                	jg     801a7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a9a:	eb 34                	jmp    801ad0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801aa0:	74 1c                	je     801abe <vprintfmt+0x207>
  801aa2:	83 fb 1f             	cmp    $0x1f,%ebx
  801aa5:	7e 05                	jle    801aac <vprintfmt+0x1f5>
  801aa7:	83 fb 7e             	cmp    $0x7e,%ebx
  801aaa:	7e 12                	jle    801abe <vprintfmt+0x207>
					putch('?', putdat);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	6a 3f                	push   $0x3f
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	eb 0f                	jmp    801acd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	53                   	push   %ebx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	ff d0                	call   *%eax
  801aca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801acd:	ff 4d e4             	decl   -0x1c(%ebp)
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	8d 70 01             	lea    0x1(%eax),%esi
  801ad5:	8a 00                	mov    (%eax),%al
  801ad7:	0f be d8             	movsbl %al,%ebx
  801ada:	85 db                	test   %ebx,%ebx
  801adc:	74 24                	je     801b02 <vprintfmt+0x24b>
  801ade:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae2:	78 b8                	js     801a9c <vprintfmt+0x1e5>
  801ae4:	ff 4d e0             	decl   -0x20(%ebp)
  801ae7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aeb:	79 af                	jns    801a9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aed:	eb 13                	jmp    801b02 <vprintfmt+0x24b>
				putch(' ', putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	6a 20                	push   $0x20
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	ff d0                	call   *%eax
  801afc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aff:	ff 4d e4             	decl   -0x1c(%ebp)
  801b02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b06:	7f e7                	jg     801aef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801b08:	e9 66 01 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 e8             	pushl  -0x18(%ebp)
  801b13:	8d 45 14             	lea    0x14(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 3c fd ff ff       	call   801858 <getint>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	79 23                	jns    801b52 <vprintfmt+0x29b>
				putch('-', putdat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	6a 2d                	push   $0x2d
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	ff d0                	call   *%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b45:	f7 d8                	neg    %eax
  801b47:	83 d2 00             	adc    $0x0,%edx
  801b4a:	f7 da                	neg    %edx
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b59:	e9 bc 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 e8             	pushl  -0x18(%ebp)
  801b64:	8d 45 14             	lea    0x14(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	e8 84 fc ff ff       	call   8017f1 <getuint>
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b7d:	e9 98 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	6a 58                	push   $0x58
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff d0                	call   *%eax
  801b8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	6a 58                	push   $0x58
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	ff d0                	call   *%eax
  801b9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	6a 58                	push   $0x58
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	ff d0                	call   *%eax
  801baf:	83 c4 10             	add    $0x10,%esp
			break;
  801bb2:	e9 bc 00 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	6a 30                	push   $0x30
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	ff d0                	call   *%eax
  801bc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	6a 78                	push   $0x78
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	ff d0                	call   *%eax
  801bd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 c0 04             	add    $0x4,%eax
  801bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  801be0:	8b 45 14             	mov    0x14(%ebp),%eax
  801be3:	83 e8 04             	sub    $0x4,%eax
  801be6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bf9:	eb 1f                	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  801c01:	8d 45 14             	lea    0x14(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	e8 e7 fb ff ff       	call   8017f1 <getuint>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	52                   	push   %edx
  801c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c28:	50                   	push   %eax
  801c29:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	e8 00 fb ff ff       	call   80173a <printnum>
  801c3a:	83 c4 20             	add    $0x20,%esp
			break;
  801c3d:	eb 34                	jmp    801c73 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	53                   	push   %ebx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	ff d0                	call   *%eax
  801c4b:	83 c4 10             	add    $0x10,%esp
			break;
  801c4e:	eb 23                	jmp    801c73 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	6a 25                	push   $0x25
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	ff d0                	call   *%eax
  801c5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c60:	ff 4d 10             	decl   0x10(%ebp)
  801c63:	eb 03                	jmp    801c68 <vprintfmt+0x3b1>
  801c65:	ff 4d 10             	decl   0x10(%ebp)
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	48                   	dec    %eax
  801c6c:	8a 00                	mov    (%eax),%al
  801c6e:	3c 25                	cmp    $0x25,%al
  801c70:	75 f3                	jne    801c65 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c72:	90                   	nop
		}
	}
  801c73:	e9 47 fc ff ff       	jmp    8018bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c86:	8d 45 10             	lea    0x10(%ebp),%eax
  801c89:	83 c0 04             	add    $0x4,%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	ff 75 f4             	pushl  -0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	e8 16 fc ff ff       	call   8018b7 <vprintfmt>
  801ca1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	8b 40 08             	mov    0x8(%eax),%eax
  801cb0:	8d 50 01             	lea    0x1(%eax),%edx
  801cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	8b 10                	mov    (%eax),%edx
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	8b 40 04             	mov    0x4(%eax),%eax
  801cc4:	39 c2                	cmp    %eax,%edx
  801cc6:	73 12                	jae    801cda <sprintputch+0x33>
		*b->buf++ = ch;
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	89 0a                	mov    %ecx,(%edx)
  801cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd8:	88 10                	mov    %dl,(%eax)
}
  801cda:	90                   	nop
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d02:	74 06                	je     801d0a <vsnprintf+0x2d>
  801d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d08:	7f 07                	jg     801d11 <vsnprintf+0x34>
		return -E_INVAL;
  801d0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0f:	eb 20                	jmp    801d31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d11:	ff 75 14             	pushl  0x14(%ebp)
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	68 a7 1c 80 00       	push   $0x801ca7
  801d20:	e8 92 fb ff ff       	call   8018b7 <vprintfmt>
  801d25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d39:	8d 45 10             	lea    0x10(%ebp),%eax
  801d3c:	83 c0 04             	add    $0x4,%eax
  801d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	50                   	push   %eax
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 89 ff ff ff       	call   801cdd <vsnprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6c:	eb 06                	jmp    801d74 <strlen+0x15>
		n++;
  801d6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d71:	ff 45 08             	incl   0x8(%ebp)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	84 c0                	test   %al,%al
  801d7b:	75 f1                	jne    801d6e <strlen+0xf>
		n++;
	return n;
  801d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d8f:	eb 09                	jmp    801d9a <strnlen+0x18>
		n++;
  801d91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d94:	ff 45 08             	incl   0x8(%ebp)
  801d97:	ff 4d 0c             	decl   0xc(%ebp)
  801d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d9e:	74 09                	je     801da9 <strnlen+0x27>
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	84 c0                	test   %al,%al
  801da7:	75 e8                	jne    801d91 <strnlen+0xf>
		n++;
	return n;
  801da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dba:	90                   	nop
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8d 50 01             	lea    0x1(%eax),%edx
  801dc1:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dcd:	8a 12                	mov    (%edx),%dl
  801dcf:	88 10                	mov    %dl,(%eax)
  801dd1:	8a 00                	mov    (%eax),%al
  801dd3:	84 c0                	test   %al,%al
  801dd5:	75 e4                	jne    801dbb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801def:	eb 1f                	jmp    801e10 <strncpy+0x34>
		*dst++ = *src;
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8d 50 01             	lea    0x1(%eax),%edx
  801df7:	89 55 08             	mov    %edx,0x8(%ebp)
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8a 12                	mov    (%edx),%dl
  801dff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	84 c0                	test   %al,%al
  801e08:	74 03                	je     801e0d <strncpy+0x31>
			src++;
  801e0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e0d:	ff 45 fc             	incl   -0x4(%ebp)
  801e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e13:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e16:	72 d9                	jb     801df1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2d:	74 30                	je     801e5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e2f:	eb 16                	jmp    801e47 <strlcpy+0x2a>
			*dst++ = *src++;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8d 50 01             	lea    0x1(%eax),%edx
  801e37:	89 55 08             	mov    %edx,0x8(%ebp)
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e43:	8a 12                	mov    (%edx),%dl
  801e45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e47:	ff 4d 10             	decl   0x10(%ebp)
  801e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4e:	74 09                	je     801e59 <strlcpy+0x3c>
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	8a 00                	mov    (%eax),%al
  801e55:	84 c0                	test   %al,%al
  801e57:	75 d8                	jne    801e31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e65:	29 c2                	sub    %eax,%edx
  801e67:	89 d0                	mov    %edx,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e6e:	eb 06                	jmp    801e76 <strcmp+0xb>
		p++, q++;
  801e70:	ff 45 08             	incl   0x8(%ebp)
  801e73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	84 c0                	test   %al,%al
  801e7d:	74 0e                	je     801e8d <strcmp+0x22>
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8a 10                	mov    (%eax),%dl
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	38 c2                	cmp    %al,%dl
  801e8b:	74 e3                	je     801e70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8a 00                	mov    (%eax),%al
  801e92:	0f b6 d0             	movzbl %al,%edx
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	0f b6 c0             	movzbl %al,%eax
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ea6:	eb 09                	jmp    801eb1 <strncmp+0xe>
		n--, p++, q++;
  801ea8:	ff 4d 10             	decl   0x10(%ebp)
  801eab:	ff 45 08             	incl   0x8(%ebp)
  801eae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb5:	74 17                	je     801ece <strncmp+0x2b>
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 00                	mov    (%eax),%al
  801ebc:	84 c0                	test   %al,%al
  801ebe:	74 0e                	je     801ece <strncmp+0x2b>
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	8a 10                	mov    (%eax),%dl
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	8a 00                	mov    (%eax),%al
  801eca:	38 c2                	cmp    %al,%dl
  801ecc:	74 da                	je     801ea8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed2:	75 07                	jne    801edb <strncmp+0x38>
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 14                	jmp    801eef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	8a 00                	mov    (%eax),%al
  801ee0:	0f b6 d0             	movzbl %al,%edx
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	8a 00                	mov    (%eax),%al
  801ee8:	0f b6 c0             	movzbl %al,%eax
  801eeb:	29 c2                	sub    %eax,%edx
  801eed:	89 d0                	mov    %edx,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801efd:	eb 12                	jmp    801f11 <strchr+0x20>
		if (*s == c)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f07:	75 05                	jne    801f0e <strchr+0x1d>
			return (char *) s;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	eb 11                	jmp    801f1f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f0e:	ff 45 08             	incl   0x8(%ebp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	84 c0                	test   %al,%al
  801f18:	75 e5                	jne    801eff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f2d:	eb 0d                	jmp    801f3c <strfind+0x1b>
		if (*s == c)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8a 00                	mov    (%eax),%al
  801f34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f37:	74 0e                	je     801f47 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	8a 00                	mov    (%eax),%al
  801f41:	84 c0                	test   %al,%al
  801f43:	75 ea                	jne    801f2f <strfind+0xe>
  801f45:	eb 01                	jmp    801f48 <strfind+0x27>
		if (*s == c)
			break;
  801f47:	90                   	nop
	return (char *) s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f59:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f5f:	eb 0e                	jmp    801f6f <memset+0x22>
		*p++ = c;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8d 50 01             	lea    0x1(%eax),%edx
  801f67:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f6f:	ff 4d f8             	decl   -0x8(%ebp)
  801f72:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f76:	79 e9                	jns    801f61 <memset+0x14>
		*p++ = c;

	return v;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f8f:	eb 16                	jmp    801fa7 <memcpy+0x2a>
		*d++ = *s++;
  801f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f94:	8d 50 01             	lea    0x1(%eax),%edx
  801f97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fa3:	8a 12                	mov    (%edx),%dl
  801fa5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fad:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	75 dd                	jne    801f91 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd1:	73 50                	jae    802023 <memmove+0x6a>
  801fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fde:	76 43                	jbe    802023 <memmove+0x6a>
		s += n;
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fec:	eb 10                	jmp    801ffe <memmove+0x45>
			*--d = *--s;
  801fee:	ff 4d f8             	decl   -0x8(%ebp)
  801ff1:	ff 4d fc             	decl   -0x4(%ebp)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8a 10                	mov    (%eax),%dl
  801ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ffc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	8d 50 ff             	lea    -0x1(%eax),%edx
  802004:	89 55 10             	mov    %edx,0x10(%ebp)
  802007:	85 c0                	test   %eax,%eax
  802009:	75 e3                	jne    801fee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80200b:	eb 23                	jmp    802030 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8d 50 01             	lea    0x1(%eax),%edx
  802013:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80201f:	8a 12                	mov    (%edx),%dl
  802021:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802023:	8b 45 10             	mov    0x10(%ebp),%eax
  802026:	8d 50 ff             	lea    -0x1(%eax),%edx
  802029:	89 55 10             	mov    %edx,0x10(%ebp)
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 dd                	jne    80200d <memmove+0x54>
			*d++ = *s++;

	return dst;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802047:	eb 2a                	jmp    802073 <memcmp+0x3e>
		if (*s1 != *s2)
  802049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204c:	8a 10                	mov    (%eax),%dl
  80204e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	38 c2                	cmp    %al,%dl
  802055:	74 16                	je     80206d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	0f b6 d0             	movzbl %al,%edx
  80205f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802062:	8a 00                	mov    (%eax),%al
  802064:	0f b6 c0             	movzbl %al,%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	eb 18                	jmp    802085 <memcmp+0x50>
		s1++, s2++;
  80206d:	ff 45 fc             	incl   -0x4(%ebp)
  802070:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802073:	8b 45 10             	mov    0x10(%ebp),%eax
  802076:	8d 50 ff             	lea    -0x1(%eax),%edx
  802079:	89 55 10             	mov    %edx,0x10(%ebp)
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 c9                	jne    802049 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802098:	eb 15                	jmp    8020af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	0f b6 d0             	movzbl %al,%edx
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	0f b6 c0             	movzbl %al,%eax
  8020a8:	39 c2                	cmp    %eax,%edx
  8020aa:	74 0d                	je     8020b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020ac:	ff 45 08             	incl   0x8(%ebp)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020b5:	72 e3                	jb     80209a <memfind+0x13>
  8020b7:	eb 01                	jmp    8020ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020b9:	90                   	nop
	return (void *) s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d3:	eb 03                	jmp    8020d8 <strtol+0x19>
		s++;
  8020d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	3c 20                	cmp    $0x20,%al
  8020df:	74 f4                	je     8020d5 <strtol+0x16>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	3c 09                	cmp    $0x9,%al
  8020e8:	74 eb                	je     8020d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	3c 2b                	cmp    $0x2b,%al
  8020f1:	75 05                	jne    8020f8 <strtol+0x39>
		s++;
  8020f3:	ff 45 08             	incl   0x8(%ebp)
  8020f6:	eb 13                	jmp    80210b <strtol+0x4c>
	else if (*s == '-')
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8a 00                	mov    (%eax),%al
  8020fd:	3c 2d                	cmp    $0x2d,%al
  8020ff:	75 0a                	jne    80210b <strtol+0x4c>
		s++, neg = 1;
  802101:	ff 45 08             	incl   0x8(%ebp)
  802104:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	74 06                	je     802117 <strtol+0x58>
  802111:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802115:	75 20                	jne    802137 <strtol+0x78>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8a 00                	mov    (%eax),%al
  80211c:	3c 30                	cmp    $0x30,%al
  80211e:	75 17                	jne    802137 <strtol+0x78>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	40                   	inc    %eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	3c 78                	cmp    $0x78,%al
  802128:	75 0d                	jne    802137 <strtol+0x78>
		s += 2, base = 16;
  80212a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80212e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802135:	eb 28                	jmp    80215f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213b:	75 15                	jne    802152 <strtol+0x93>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	3c 30                	cmp    $0x30,%al
  802144:	75 0c                	jne    802152 <strtol+0x93>
		s++, base = 8;
  802146:	ff 45 08             	incl   0x8(%ebp)
  802149:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802150:	eb 0d                	jmp    80215f <strtol+0xa0>
	else if (base == 0)
  802152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802156:	75 07                	jne    80215f <strtol+0xa0>
		base = 10;
  802158:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 2f                	cmp    $0x2f,%al
  802166:	7e 19                	jle    802181 <strtol+0xc2>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	3c 39                	cmp    $0x39,%al
  80216f:	7f 10                	jg     802181 <strtol+0xc2>
			dig = *s - '0';
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8a 00                	mov    (%eax),%al
  802176:	0f be c0             	movsbl %al,%eax
  802179:	83 e8 30             	sub    $0x30,%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217f:	eb 42                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 60                	cmp    $0x60,%al
  802188:	7e 19                	jle    8021a3 <strtol+0xe4>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	3c 7a                	cmp    $0x7a,%al
  802191:	7f 10                	jg     8021a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8a 00                	mov    (%eax),%al
  802198:	0f be c0             	movsbl %al,%eax
  80219b:	83 e8 57             	sub    $0x57,%eax
  80219e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a1:	eb 20                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8a 00                	mov    (%eax),%al
  8021a8:	3c 40                	cmp    $0x40,%al
  8021aa:	7e 39                	jle    8021e5 <strtol+0x126>
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	3c 5a                	cmp    $0x5a,%al
  8021b3:	7f 30                	jg     8021e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8a 00                	mov    (%eax),%al
  8021ba:	0f be c0             	movsbl %al,%eax
  8021bd:	83 e8 37             	sub    $0x37,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c9:	7d 19                	jge    8021e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021cb:	ff 45 08             	incl   0x8(%ebp)
  8021ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021df:	e9 7b ff ff ff       	jmp    80215f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e9:	74 08                	je     8021f3 <strtol+0x134>
		*endptr = (char *) s;
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f7:	74 07                	je     802200 <strtol+0x141>
  8021f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fc:	f7 d8                	neg    %eax
  8021fe:	eb 03                	jmp    802203 <strtol+0x144>
  802200:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ltostr>:

void
ltostr(long value, char *str)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80220b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802212:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	79 13                	jns    802232 <ltostr+0x2d>
	{
		neg = 1;
  80221f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80222c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80222f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80223a:	99                   	cltd   
  80223b:	f7 f9                	idiv   %ecx
  80223d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8d 50 01             	lea    0x1(%eax),%edx
  802246:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802249:	89 c2                	mov    %eax,%edx
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802253:	83 c2 30             	add    $0x30,%edx
  802256:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802260:	f7 e9                	imul   %ecx
  802262:	c1 fa 02             	sar    $0x2,%edx
  802265:	89 c8                	mov    %ecx,%eax
  802267:	c1 f8 1f             	sar    $0x1f,%eax
  80226a:	29 c2                	sub    %eax,%edx
  80226c:	89 d0                	mov    %edx,%eax
  80226e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802274:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802279:	f7 e9                	imul   %ecx
  80227b:	c1 fa 02             	sar    $0x2,%edx
  80227e:	89 c8                	mov    %ecx,%eax
  802280:	c1 f8 1f             	sar    $0x1f,%eax
  802283:	29 c2                	sub    %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	c1 e0 02             	shl    $0x2,%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	29 c1                	sub    %eax,%ecx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	75 9c                	jne    802232 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802296:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80229d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a0:	48                   	dec    %eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	74 3d                	je     8022e7 <ltostr+0xe2>
		start = 1 ;
  8022aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022b1:	eb 34                	jmp    8022e7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	01 c2                	add    %eax,%edx
  8022c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	01 c8                	add    %ecx,%eax
  8022d0:	8a 00                	mov    (%eax),%al
  8022d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	01 c2                	add    %eax,%edx
  8022dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022df:	88 02                	mov    %al,(%edx)
		start++ ;
  8022e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022ed:	7c c4                	jl     8022b3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	e8 54 fa ff ff       	call   801d5f <strlen>
  80230b:	83 c4 04             	add    $0x4,%esp
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	e8 46 fa ff ff       	call   801d5f <strlen>
  802319:	83 c4 04             	add    $0x4,%esp
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80231f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80232d:	eb 17                	jmp    802346 <strcconcat+0x49>
		final[s] = str1[s] ;
  80232f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	01 c2                	add    %eax,%edx
  802337:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	8a 00                	mov    (%eax),%al
  802341:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802343:	ff 45 fc             	incl   -0x4(%ebp)
  802346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802349:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80234c:	7c e1                	jl     80232f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80234e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802355:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80235c:	eb 1f                	jmp    80237d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802361:	8d 50 01             	lea    0x1(%eax),%edx
  802364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 10             	mov    0x10(%ebp),%eax
  80236c:	01 c2                	add    %eax,%edx
  80236e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	01 c8                	add    %ecx,%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80237a:	ff 45 f8             	incl   -0x8(%ebp)
  80237d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802383:	7c d9                	jl     80235e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802388:	8b 45 10             	mov    0x10(%ebp),%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	c6 00 00             	movb   $0x0,(%eax)
}
  802390:	90                   	nop
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80239f:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023b6:	eb 0c                	jmp    8023c4 <strsplit+0x31>
			*string++ = 0;
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8d 50 01             	lea    0x1(%eax),%edx
  8023be:	89 55 08             	mov    %edx,0x8(%ebp)
  8023c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	84 c0                	test   %al,%al
  8023cb:	74 18                	je     8023e5 <strsplit+0x52>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	0f be c0             	movsbl %al,%eax
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 0c             	pushl  0xc(%ebp)
  8023d9:	e8 13 fb ff ff       	call   801ef1 <strchr>
  8023de:	83 c4 08             	add    $0x8,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 d3                	jne    8023b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	84 c0                	test   %al,%al
  8023ec:	74 5a                	je     802448 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	83 f8 0f             	cmp    $0xf,%eax
  8023f6:	75 07                	jne    8023ff <strsplit+0x6c>
		{
			return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb 66                	jmp    802465 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 48 01             	lea    0x1(%eax),%ecx
  802407:	8b 55 14             	mov    0x14(%ebp),%edx
  80240a:	89 0a                	mov    %ecx,(%edx)
  80240c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802413:	8b 45 10             	mov    0x10(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80241d:	eb 03                	jmp    802422 <strsplit+0x8f>
			string++;
  80241f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	84 c0                	test   %al,%al
  802429:	74 8b                	je     8023b6 <strsplit+0x23>
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	0f be c0             	movsbl %al,%eax
  802433:	50                   	push   %eax
  802434:	ff 75 0c             	pushl  0xc(%ebp)
  802437:	e8 b5 fa ff ff       	call   801ef1 <strchr>
  80243c:	83 c4 08             	add    $0x8,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 dc                	je     80241f <strsplit+0x8c>
			string++;
	}
  802443:	e9 6e ff ff ff       	jmp    8023b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802448:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802449:	8b 45 14             	mov    0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802455:	8b 45 10             	mov    0x10(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802460:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80246d:	a1 04 60 80 00       	mov    0x806004,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 1f                	je     802495 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802476:	e8 1d 00 00 00       	call   802498 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	68 b0 4e 80 00       	push   $0x804eb0
  802483:	e8 55 f2 ff ff       	call   8016dd <cprintf>
  802488:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80248b:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802492:	00 00 00 
	}
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");
LIST_INIT(&AllocMemBlocksList);
  80249e:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8024a5:	00 00 00 
  8024a8:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8024af:	00 00 00 
  8024b2:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8024b9:	00 00 00 
LIST_INIT(&FreeMemBlocksList);
  8024bc:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8024c3:	00 00 00 
  8024c6:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8024cd:	00 00 00 
  8024d0:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8024d7:	00 00 00 
MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8024da:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  8024e1:	00 02 00 
uint32 requiredSpace=sizeof(struct MemBlock)*NUM_OF_UHEAP_PAGES;
  8024e4:	c7 45 f4 00 00 20 00 	movl   $0x200000,-0xc(%ebp)
		MemBlockNodes=(struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8024eb:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8024f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024fa:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024ff:	a3 50 60 80 00       	mov    %eax,0x806050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,requiredSpace,PERM_WRITEABLE|PERM_USER);
  802504:	c7 45 ec 00 00 e0 7f 	movl   $0x7fe00000,-0x14(%ebp)
  80250b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802513:	2d 00 10 00 00       	sub    $0x1000,%eax
  802518:	83 ec 04             	sub    $0x4,%esp
  80251b:	6a 06                	push   $0x6
  80251d:	ff 75 f4             	pushl  -0xc(%ebp)
  802520:	50                   	push   %eax
  802521:	e8 ee 05 00 00       	call   802b14 <sys_allocate_chunk>
  802526:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802529:	a1 20 61 80 00       	mov    0x806120,%eax
  80252e:	83 ec 0c             	sub    $0xc,%esp
  802531:	50                   	push   %eax
  802532:	e8 63 0c 00 00       	call   80319a <initialize_MemBlocksList>
  802537:	83 c4 10             	add    $0x10,%esp
			struct MemBlock *freeSva=AvailableMemBlocksList.lh_last;
  80253a:	a1 4c 61 80 00       	mov    0x80614c,%eax
  80253f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			freeSva->size=USER_HEAP_MAX-USER_HEAP_START;
  802542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802545:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
			freeSva->size=ROUNDDOWN(freeSva->size,PAGE_SIZE);
  80254c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254f:	8b 40 0c             	mov    0xc(%eax),%eax
  802552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802558:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80255d:	89 c2                	mov    %eax,%edx
  80255f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802562:	89 50 0c             	mov    %edx,0xc(%eax)

			freeSva->sva=USER_HEAP_START;
  802565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802568:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
			freeSva->sva=ROUNDUP(freeSva->sva,PAGE_SIZE);
  80256f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802579:	8b 50 08             	mov    0x8(%eax),%edx
  80257c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257f:	01 d0                	add    %edx,%eax
  802581:	48                   	dec    %eax
  802582:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802585:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802588:	ba 00 00 00 00       	mov    $0x0,%edx
  80258d:	f7 75 e0             	divl   -0x20(%ebp)
  802590:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802593:	29 d0                	sub    %edx,%eax
  802595:	89 c2                	mov    %eax,%edx
  802597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80259a:	89 50 08             	mov    %edx,0x8(%eax)




			LIST_REMOVE(&AvailableMemBlocksList,freeSva);
  80259d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025a1:	75 14                	jne    8025b7 <initialize_dyn_block_system+0x11f>
  8025a3:	83 ec 04             	sub    $0x4,%esp
  8025a6:	68 d5 4e 80 00       	push   $0x804ed5
  8025ab:	6a 34                	push   $0x34
  8025ad:	68 f3 4e 80 00       	push   $0x804ef3
  8025b2:	e8 72 ee ff ff       	call   801429 <_panic>
  8025b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 10                	je     8025d0 <initialize_dyn_block_system+0x138>
  8025c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025c8:	8b 52 04             	mov    0x4(%edx),%edx
  8025cb:	89 50 04             	mov    %edx,0x4(%eax)
  8025ce:	eb 0b                	jmp    8025db <initialize_dyn_block_system+0x143>
  8025d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025d3:	8b 40 04             	mov    0x4(%eax),%eax
  8025d6:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8025db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	74 0f                	je     8025f4 <initialize_dyn_block_system+0x15c>
  8025e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025e8:	8b 40 04             	mov    0x4(%eax),%eax
  8025eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025ee:	8b 12                	mov    (%edx),%edx
  8025f0:	89 10                	mov    %edx,(%eax)
  8025f2:	eb 0a                	jmp    8025fe <initialize_dyn_block_system+0x166>
  8025f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	a3 48 61 80 00       	mov    %eax,0x806148
  8025fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802611:	a1 54 61 80 00       	mov    0x806154,%eax
  802616:	48                   	dec    %eax
  802617:	a3 54 61 80 00       	mov    %eax,0x806154
			insert_sorted_with_merge_freeList(freeSva);
  80261c:	83 ec 0c             	sub    $0xc,%esp
  80261f:	ff 75 e8             	pushl  -0x18(%ebp)
  802622:	e8 c4 13 00 00       	call   8039eb <insert_sorted_with_merge_freeList>
  802627:	83 c4 10             	add    $0x10,%esp
//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80262a:	90                   	nop
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <malloc>:
//=================================



void* malloc(uint32 size)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802633:	e8 2f fe ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  802638:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80263c:	75 07                	jne    802645 <malloc+0x18>
  80263e:	b8 00 00 00 00       	mov    $0x0,%eax
  802643:	eb 71                	jmp    8026b6 <malloc+0x89>
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  802645:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80264c:	76 07                	jbe    802655 <malloc+0x28>
	return NULL;
  80264e:	b8 00 00 00 00       	mov    $0x0,%eax
  802653:	eb 61                	jmp    8026b6 <malloc+0x89>

	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802655:	e8 88 08 00 00       	call   802ee2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80265a:	85 c0                	test   %eax,%eax
  80265c:	74 53                	je     8026b1 <malloc+0x84>
	        {
		struct MemBlock *returned_block;
		uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80265e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802665:	8b 55 08             	mov    0x8(%ebp),%edx
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	01 d0                	add    %edx,%eax
  80266d:	48                   	dec    %eax
  80266e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802674:	ba 00 00 00 00       	mov    $0x0,%edx
  802679:	f7 75 f4             	divl   -0xc(%ebp)
  80267c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267f:	29 d0                	sub    %edx,%eax
  802681:	89 45 ec             	mov    %eax,-0x14(%ebp)
   returned_block=alloc_block_FF(newSize);
  802684:	83 ec 0c             	sub    $0xc,%esp
  802687:	ff 75 ec             	pushl  -0x14(%ebp)
  80268a:	e8 d2 0d 00 00       	call   803461 <alloc_block_FF>
  80268f:	83 c4 10             	add    $0x10,%esp
  802692:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(returned_block!=NULL)
  802695:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802699:	74 16                	je     8026b1 <malloc+0x84>
    {
    	insert_sorted_allocList(returned_block);
  80269b:	83 ec 0c             	sub    $0xc,%esp
  80269e:	ff 75 e8             	pushl  -0x18(%ebp)
  8026a1:	e8 0c 0c 00 00       	call   8032b2 <insert_sorted_allocList>
  8026a6:	83 c4 10             	add    $0x10,%esp
	return(void*) returned_block->sva;
  8026a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ac:	8b 40 08             	mov    0x8(%eax),%eax
  8026af:	eb 05                	jmp    8026b6 <malloc+0x89>
    }

			}


	return NULL;
  8026b1:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	//you should get the size of the given allocation using its address
	uint32 va=ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8026cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *returned_block=find_block(&AllocMemBlocksList,va);
  8026cf:	83 ec 08             	sub    $0x8,%esp
  8026d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8026d5:	68 40 60 80 00       	push   $0x806040
  8026da:	e8 a0 0b 00 00       	call   80327f <find_block>
  8026df:	83 c4 10             	add    $0x10,%esp
  8026e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_free_user_mem((uint32)virtual_address,returned_block->size);
  8026e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e8:	8b 50 0c             	mov    0xc(%eax),%edx
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	83 ec 08             	sub    $0x8,%esp
  8026f1:	52                   	push   %edx
  8026f2:	50                   	push   %eax
  8026f3:	e8 e4 03 00 00       	call   802adc <sys_free_user_mem>
  8026f8:	83 c4 10             	add    $0x10,%esp

    LIST_REMOVE(&AllocMemBlocksList,returned_block);
  8026fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026ff:	75 17                	jne    802718 <free+0x60>
  802701:	83 ec 04             	sub    $0x4,%esp
  802704:	68 d5 4e 80 00       	push   $0x804ed5
  802709:	68 84 00 00 00       	push   $0x84
  80270e:	68 f3 4e 80 00       	push   $0x804ef3
  802713:	e8 11 ed ff ff       	call   801429 <_panic>
  802718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	74 10                	je     802731 <free+0x79>
  802721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802729:	8b 52 04             	mov    0x4(%edx),%edx
  80272c:	89 50 04             	mov    %edx,0x4(%eax)
  80272f:	eb 0b                	jmp    80273c <free+0x84>
  802731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	a3 44 60 80 00       	mov    %eax,0x806044
  80273c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273f:	8b 40 04             	mov    0x4(%eax),%eax
  802742:	85 c0                	test   %eax,%eax
  802744:	74 0f                	je     802755 <free+0x9d>
  802746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80274f:	8b 12                	mov    (%edx),%edx
  802751:	89 10                	mov    %edx,(%eax)
  802753:	eb 0a                	jmp    80275f <free+0xa7>
  802755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802758:	8b 00                	mov    (%eax),%eax
  80275a:	a3 40 60 80 00       	mov    %eax,0x806040
  80275f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802762:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802772:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802777:	48                   	dec    %eax
  802778:	a3 4c 60 80 00       	mov    %eax,0x80604c
	insert_sorted_with_merge_freeList(returned_block);
  80277d:	83 ec 0c             	sub    $0xc,%esp
  802780:	ff 75 ec             	pushl  -0x14(%ebp)
  802783:	e8 63 12 00 00       	call   8039eb <insert_sorted_with_merge_freeList>
  802788:	83 c4 10             	add    $0x10,%esp

	//you need to call sys_free_user_mem()
}
  80278b:	90                   	nop
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

0080278e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	83 ec 38             	sub    $0x38,%esp
  802794:	8b 45 10             	mov    0x10(%ebp),%eax
  802797:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80279a:	e8 c8 fc ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  80279f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027a3:	75 0a                	jne    8027af <smalloc+0x21>
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027aa:	e9 a0 00 00 00       	jmp    80284f <smalloc+0xc1>
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	if(size>USER_HEAP_MAX-USER_HEAP_START||size<0)
  8027af:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8027b6:	76 0a                	jbe    8027c2 <smalloc+0x34>
		return NULL;
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bd:	e9 8d 00 00 00       	jmp    80284f <smalloc+0xc1>

		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8027c2:	e8 1b 07 00 00       	call   802ee2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 7f                	je     80284a <smalloc+0xbc>
		        {
			struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  8027cb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8027d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	01 d0                	add    %edx,%eax
  8027da:	48                   	dec    %eax
  8027db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e6:	f7 75 f4             	divl   -0xc(%ebp)
  8027e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ec:	29 d0                	sub    %edx,%eax
  8027ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8027f1:	83 ec 0c             	sub    $0xc,%esp
  8027f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8027f7:	e8 65 0c 00 00       	call   803461 <alloc_block_FF>
  8027fc:	83 c4 10             	add    $0x10,%esp
  8027ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   if(returned_block!=NULL)
  802802:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802806:	74 42                	je     80284a <smalloc+0xbc>
	      {
	      	   insert_sorted_allocList(returned_block);
  802808:	83 ec 0c             	sub    $0xc,%esp
  80280b:	ff 75 e8             	pushl  -0x18(%ebp)
  80280e:	e8 9f 0a 00 00       	call   8032b2 <insert_sorted_allocList>
  802813:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_createSharedObject(sharedVarName,size,isWritable,(void*)returned_block->sva);
  802816:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802819:	8b 40 08             	mov    0x8(%eax),%eax
  80281c:	89 c2                	mov    %eax,%edx
  80281e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802822:	52                   	push   %edx
  802823:	50                   	push   %eax
  802824:	ff 75 0c             	pushl  0xc(%ebp)
  802827:	ff 75 08             	pushl  0x8(%ebp)
  80282a:	e8 38 04 00 00       	call   802c67 <sys_createSharedObject>
  80282f:	83 c4 10             	add    $0x10,%esp
  802832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    	     if(ID<0)
  802835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802839:	79 07                	jns    802842 <smalloc+0xb4>
	    		  return NULL;
  80283b:	b8 00 00 00 00       	mov    $0x0,%eax
  802840:	eb 0d                	jmp    80284f <smalloc+0xc1>
	  	return(void*) returned_block->sva;
  802842:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802845:	8b 40 08             	mov    0x8(%eax),%eax
  802848:	eb 05                	jmp    80284f <smalloc+0xc1>


				}


		return NULL;
  80284a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802857:	e8 0b fc ff ff       	call   802467 <InitializeUHeap>
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80285c:	e8 81 06 00 00       	call   802ee2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802861:	85 c0                	test   %eax,%eax
  802863:	0f 84 9f 00 00 00    	je     802908 <sget+0xb7>
	int size=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802869:	83 ec 08             	sub    $0x8,%esp
  80286c:	ff 75 0c             	pushl  0xc(%ebp)
  80286f:	ff 75 08             	pushl  0x8(%ebp)
  802872:	e8 1a 04 00 00       	call   802c91 <sys_getSizeOfSharedObject>
  802877:	83 c4 10             	add    $0x10,%esp
  80287a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size<0)
  80287d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802881:	79 0a                	jns    80288d <sget+0x3c>
		return NULL;
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	e9 80 00 00 00       	jmp    80290d <sget+0xbc>
	struct MemBlock *returned_block;
			uint32 newSize=ROUNDUP(size,PAGE_SIZE);
  80288d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289a:	01 d0                	add    %edx,%eax
  80289c:	48                   	dec    %eax
  80289d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a8:	f7 75 f0             	divl   -0x10(%ebp)
  8028ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ae:	29 d0                	sub    %edx,%eax
  8028b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	   returned_block=alloc_block_FF(newSize);
  8028b3:	83 ec 0c             	sub    $0xc,%esp
  8028b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8028b9:	e8 a3 0b 00 00       	call   803461 <alloc_block_FF>
  8028be:	83 c4 10             	add    $0x10,%esp
  8028c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	   if(returned_block!=NULL)
  8028c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028c8:	74 3e                	je     802908 <sget+0xb7>
	      {
	      	   insert_sorted_allocList(returned_block);
  8028ca:	83 ec 0c             	sub    $0xc,%esp
  8028cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028d0:	e8 dd 09 00 00       	call   8032b2 <insert_sorted_allocList>
  8028d5:	83 c4 10             	add    $0x10,%esp
	    	    int ID = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)returned_block->sva);
  8028d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028db:	8b 40 08             	mov    0x8(%eax),%eax
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	50                   	push   %eax
  8028e2:	ff 75 0c             	pushl  0xc(%ebp)
  8028e5:	ff 75 08             	pushl  0x8(%ebp)
  8028e8:	e8 c1 03 00 00       	call   802cae <sys_getSharedObject>
  8028ed:	83 c4 10             	add    $0x10,%esp
  8028f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    	     if(ID<0)
  8028f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028f7:	79 07                	jns    802900 <sget+0xaf>
	    		  return NULL;
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fe:	eb 0d                	jmp    80290d <sget+0xbc>
	  	return(void*) returned_block->sva;
  802900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802903:	8b 40 08             	mov    0x8(%eax),%eax
  802906:	eb 05                	jmp    80290d <sget+0xbc>
	      }
	}
	   return NULL;
  802908:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80290d:	c9                   	leave  
  80290e:	c3                   	ret    

0080290f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80290f:	55                   	push   %ebp
  802910:	89 e5                	mov    %esp,%ebp
  802912:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802915:	e8 4d fb ff ff       	call   802467 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	68 00 4f 80 00       	push   $0x804f00
  802922:	68 12 01 00 00       	push   $0x112
  802927:	68 f3 4e 80 00       	push   $0x804ef3
  80292c:	e8 f8 ea ff ff       	call   801429 <_panic>

00802931 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 28 4f 80 00       	push   $0x804f28
  80293f:	68 26 01 00 00       	push   $0x126
  802944:	68 f3 4e 80 00       	push   $0x804ef3
  802949:	e8 db ea ff ff       	call   801429 <_panic>

0080294e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802954:	83 ec 04             	sub    $0x4,%esp
  802957:	68 4c 4f 80 00       	push   $0x804f4c
  80295c:	68 31 01 00 00       	push   $0x131
  802961:	68 f3 4e 80 00       	push   $0x804ef3
  802966:	e8 be ea ff ff       	call   801429 <_panic>

0080296b <shrink>:

}
void shrink(uint32 newSize)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802971:	83 ec 04             	sub    $0x4,%esp
  802974:	68 4c 4f 80 00       	push   $0x804f4c
  802979:	68 36 01 00 00       	push   $0x136
  80297e:	68 f3 4e 80 00       	push   $0x804ef3
  802983:	e8 a1 ea ff ff       	call   801429 <_panic>

00802988 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802988:	55                   	push   %ebp
  802989:	89 e5                	mov    %esp,%ebp
  80298b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	68 4c 4f 80 00       	push   $0x804f4c
  802996:	68 3b 01 00 00       	push   $0x13b
  80299b:	68 f3 4e 80 00       	push   $0x804ef3
  8029a0:	e8 84 ea ff ff       	call   801429 <_panic>

008029a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
  8029a8:	57                   	push   %edi
  8029a9:	56                   	push   %esi
  8029aa:	53                   	push   %ebx
  8029ab:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029ba:	8b 7d 18             	mov    0x18(%ebp),%edi
  8029bd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8029c0:	cd 30                	int    $0x30
  8029c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8029c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8029c8:	83 c4 10             	add    $0x10,%esp
  8029cb:	5b                   	pop    %ebx
  8029cc:	5e                   	pop    %esi
  8029cd:	5f                   	pop    %edi
  8029ce:	5d                   	pop    %ebp
  8029cf:	c3                   	ret    

008029d0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	83 ec 04             	sub    $0x4,%esp
  8029d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8029d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8029dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	52                   	push   %edx
  8029e8:	ff 75 0c             	pushl  0xc(%ebp)
  8029eb:	50                   	push   %eax
  8029ec:	6a 00                	push   $0x0
  8029ee:	e8 b2 ff ff ff       	call   8029a5 <syscall>
  8029f3:	83 c4 18             	add    $0x18,%esp
}
  8029f6:	90                   	nop
  8029f7:	c9                   	leave  
  8029f8:	c3                   	ret    

008029f9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029f9:	55                   	push   %ebp
  8029fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 01                	push   $0x1
  802a08:	e8 98 ff ff ff       	call   8029a5 <syscall>
  802a0d:	83 c4 18             	add    $0x18,%esp
}
  802a10:	c9                   	leave  
  802a11:	c3                   	ret    

00802a12 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a12:	55                   	push   %ebp
  802a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	52                   	push   %edx
  802a22:	50                   	push   %eax
  802a23:	6a 05                	push   $0x5
  802a25:	e8 7b ff ff ff       	call   8029a5 <syscall>
  802a2a:	83 c4 18             	add    $0x18,%esp
}
  802a2d:	c9                   	leave  
  802a2e:	c3                   	ret    

00802a2f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a2f:	55                   	push   %ebp
  802a30:	89 e5                	mov    %esp,%ebp
  802a32:	56                   	push   %esi
  802a33:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a34:	8b 75 18             	mov    0x18(%ebp),%esi
  802a37:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	56                   	push   %esi
  802a44:	53                   	push   %ebx
  802a45:	51                   	push   %ecx
  802a46:	52                   	push   %edx
  802a47:	50                   	push   %eax
  802a48:	6a 06                	push   $0x6
  802a4a:	e8 56 ff ff ff       	call   8029a5 <syscall>
  802a4f:	83 c4 18             	add    $0x18,%esp
}
  802a52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a55:	5b                   	pop    %ebx
  802a56:	5e                   	pop    %esi
  802a57:	5d                   	pop    %ebp
  802a58:	c3                   	ret    

00802a59 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	6a 00                	push   $0x0
  802a68:	52                   	push   %edx
  802a69:	50                   	push   %eax
  802a6a:	6a 07                	push   $0x7
  802a6c:	e8 34 ff ff ff       	call   8029a5 <syscall>
  802a71:	83 c4 18             	add    $0x18,%esp
}
  802a74:	c9                   	leave  
  802a75:	c3                   	ret    

00802a76 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a76:	55                   	push   %ebp
  802a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 00                	push   $0x0
  802a7f:	ff 75 0c             	pushl  0xc(%ebp)
  802a82:	ff 75 08             	pushl  0x8(%ebp)
  802a85:	6a 08                	push   $0x8
  802a87:	e8 19 ff ff ff       	call   8029a5 <syscall>
  802a8c:	83 c4 18             	add    $0x18,%esp
}
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a94:	6a 00                	push   $0x0
  802a96:	6a 00                	push   $0x0
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	6a 09                	push   $0x9
  802aa0:	e8 00 ff ff ff       	call   8029a5 <syscall>
  802aa5:	83 c4 18             	add    $0x18,%esp
}
  802aa8:	c9                   	leave  
  802aa9:	c3                   	ret    

00802aaa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802aaa:	55                   	push   %ebp
  802aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802aad:	6a 00                	push   $0x0
  802aaf:	6a 00                	push   $0x0
  802ab1:	6a 00                	push   $0x0
  802ab3:	6a 00                	push   $0x0
  802ab5:	6a 00                	push   $0x0
  802ab7:	6a 0a                	push   $0xa
  802ab9:	e8 e7 fe ff ff       	call   8029a5 <syscall>
  802abe:	83 c4 18             	add    $0x18,%esp
}
  802ac1:	c9                   	leave  
  802ac2:	c3                   	ret    

00802ac3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ac3:	55                   	push   %ebp
  802ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	6a 00                	push   $0x0
  802acc:	6a 00                	push   $0x0
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 0b                	push   $0xb
  802ad2:	e8 ce fe ff ff       	call   8029a5 <syscall>
  802ad7:	83 c4 18             	add    $0x18,%esp
}
  802ada:	c9                   	leave  
  802adb:	c3                   	ret    

00802adc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802adc:	55                   	push   %ebp
  802add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	ff 75 0c             	pushl  0xc(%ebp)
  802ae8:	ff 75 08             	pushl  0x8(%ebp)
  802aeb:	6a 0f                	push   $0xf
  802aed:	e8 b3 fe ff ff       	call   8029a5 <syscall>
  802af2:	83 c4 18             	add    $0x18,%esp
	return;
  802af5:	90                   	nop
}
  802af6:	c9                   	leave  
  802af7:	c3                   	ret    

00802af8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802af8:	55                   	push   %ebp
  802af9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802afb:	6a 00                	push   $0x0
  802afd:	6a 00                	push   $0x0
  802aff:	6a 00                	push   $0x0
  802b01:	ff 75 0c             	pushl  0xc(%ebp)
  802b04:	ff 75 08             	pushl  0x8(%ebp)
  802b07:	6a 10                	push   $0x10
  802b09:	e8 97 fe ff ff       	call   8029a5 <syscall>
  802b0e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b11:	90                   	nop
}
  802b12:	c9                   	leave  
  802b13:	c3                   	ret    

00802b14 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b14:	55                   	push   %ebp
  802b15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	ff 75 10             	pushl  0x10(%ebp)
  802b1e:	ff 75 0c             	pushl  0xc(%ebp)
  802b21:	ff 75 08             	pushl  0x8(%ebp)
  802b24:	6a 11                	push   $0x11
  802b26:	e8 7a fe ff ff       	call   8029a5 <syscall>
  802b2b:	83 c4 18             	add    $0x18,%esp
	return ;
  802b2e:	90                   	nop
}
  802b2f:	c9                   	leave  
  802b30:	c3                   	ret    

00802b31 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802b31:	55                   	push   %ebp
  802b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802b34:	6a 00                	push   $0x0
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 0c                	push   $0xc
  802b40:	e8 60 fe ff ff       	call   8029a5 <syscall>
  802b45:	83 c4 18             	add    $0x18,%esp
}
  802b48:	c9                   	leave  
  802b49:	c3                   	ret    

00802b4a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b4a:	55                   	push   %ebp
  802b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b4d:	6a 00                	push   $0x0
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	ff 75 08             	pushl  0x8(%ebp)
  802b58:	6a 0d                	push   $0xd
  802b5a:	e8 46 fe ff ff       	call   8029a5 <syscall>
  802b5f:	83 c4 18             	add    $0x18,%esp
}
  802b62:	c9                   	leave  
  802b63:	c3                   	ret    

00802b64 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b67:	6a 00                	push   $0x0
  802b69:	6a 00                	push   $0x0
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 00                	push   $0x0
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 0e                	push   $0xe
  802b73:	e8 2d fe ff ff       	call   8029a5 <syscall>
  802b78:	83 c4 18             	add    $0x18,%esp
}
  802b7b:	90                   	nop
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    

00802b7e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802b7e:	55                   	push   %ebp
  802b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802b81:	6a 00                	push   $0x0
  802b83:	6a 00                	push   $0x0
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 13                	push   $0x13
  802b8d:	e8 13 fe ff ff       	call   8029a5 <syscall>
  802b92:	83 c4 18             	add    $0x18,%esp
}
  802b95:	90                   	nop
  802b96:	c9                   	leave  
  802b97:	c3                   	ret    

00802b98 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802b98:	55                   	push   %ebp
  802b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	6a 00                	push   $0x0
  802ba3:	6a 00                	push   $0x0
  802ba5:	6a 14                	push   $0x14
  802ba7:	e8 f9 fd ff ff       	call   8029a5 <syscall>
  802bac:	83 c4 18             	add    $0x18,%esp
}
  802baf:	90                   	nop
  802bb0:	c9                   	leave  
  802bb1:	c3                   	ret    

00802bb2 <sys_cputc>:


void
sys_cputc(const char c)
{
  802bb2:	55                   	push   %ebp
  802bb3:	89 e5                	mov    %esp,%ebp
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802bbe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bc2:	6a 00                	push   $0x0
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 00                	push   $0x0
  802bc8:	6a 00                	push   $0x0
  802bca:	50                   	push   %eax
  802bcb:	6a 15                	push   $0x15
  802bcd:	e8 d3 fd ff ff       	call   8029a5 <syscall>
  802bd2:	83 c4 18             	add    $0x18,%esp
}
  802bd5:	90                   	nop
  802bd6:	c9                   	leave  
  802bd7:	c3                   	ret    

00802bd8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802bd8:	55                   	push   %ebp
  802bd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802bdb:	6a 00                	push   $0x0
  802bdd:	6a 00                	push   $0x0
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	6a 16                	push   $0x16
  802be7:	e8 b9 fd ff ff       	call   8029a5 <syscall>
  802bec:	83 c4 18             	add    $0x18,%esp
}
  802bef:	90                   	nop
  802bf0:	c9                   	leave  
  802bf1:	c3                   	ret    

00802bf2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802bf2:	55                   	push   %ebp
  802bf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	ff 75 0c             	pushl  0xc(%ebp)
  802c01:	50                   	push   %eax
  802c02:	6a 17                	push   $0x17
  802c04:	e8 9c fd ff ff       	call   8029a5 <syscall>
  802c09:	83 c4 18             	add    $0x18,%esp
}
  802c0c:	c9                   	leave  
  802c0d:	c3                   	ret    

00802c0e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802c0e:	55                   	push   %ebp
  802c0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	6a 00                	push   $0x0
  802c19:	6a 00                	push   $0x0
  802c1b:	6a 00                	push   $0x0
  802c1d:	52                   	push   %edx
  802c1e:	50                   	push   %eax
  802c1f:	6a 1a                	push   $0x1a
  802c21:	e8 7f fd ff ff       	call   8029a5 <syscall>
  802c26:	83 c4 18             	add    $0x18,%esp
}
  802c29:	c9                   	leave  
  802c2a:	c3                   	ret    

00802c2b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c2b:	55                   	push   %ebp
  802c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	6a 00                	push   $0x0
  802c36:	6a 00                	push   $0x0
  802c38:	6a 00                	push   $0x0
  802c3a:	52                   	push   %edx
  802c3b:	50                   	push   %eax
  802c3c:	6a 18                	push   $0x18
  802c3e:	e8 62 fd ff ff       	call   8029a5 <syscall>
  802c43:	83 c4 18             	add    $0x18,%esp
}
  802c46:	90                   	nop
  802c47:	c9                   	leave  
  802c48:	c3                   	ret    

00802c49 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c49:	55                   	push   %ebp
  802c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	6a 00                	push   $0x0
  802c58:	52                   	push   %edx
  802c59:	50                   	push   %eax
  802c5a:	6a 19                	push   $0x19
  802c5c:	e8 44 fd ff ff       	call   8029a5 <syscall>
  802c61:	83 c4 18             	add    $0x18,%esp
}
  802c64:	90                   	nop
  802c65:	c9                   	leave  
  802c66:	c3                   	ret    

00802c67 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c67:	55                   	push   %ebp
  802c68:	89 e5                	mov    %esp,%ebp
  802c6a:	83 ec 04             	sub    $0x4,%esp
  802c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  802c70:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c73:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c76:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	6a 00                	push   $0x0
  802c7f:	51                   	push   %ecx
  802c80:	52                   	push   %edx
  802c81:	ff 75 0c             	pushl  0xc(%ebp)
  802c84:	50                   	push   %eax
  802c85:	6a 1b                	push   $0x1b
  802c87:	e8 19 fd ff ff       	call   8029a5 <syscall>
  802c8c:	83 c4 18             	add    $0x18,%esp
}
  802c8f:	c9                   	leave  
  802c90:	c3                   	ret    

00802c91 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	52                   	push   %edx
  802ca1:	50                   	push   %eax
  802ca2:	6a 1c                	push   $0x1c
  802ca4:	e8 fc fc ff ff       	call   8029a5 <syscall>
  802ca9:	83 c4 18             	add    $0x18,%esp
}
  802cac:	c9                   	leave  
  802cad:	c3                   	ret    

00802cae <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802cae:	55                   	push   %ebp
  802caf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802cb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	51                   	push   %ecx
  802cbf:	52                   	push   %edx
  802cc0:	50                   	push   %eax
  802cc1:	6a 1d                	push   $0x1d
  802cc3:	e8 dd fc ff ff       	call   8029a5 <syscall>
  802cc8:	83 c4 18             	add    $0x18,%esp
}
  802ccb:	c9                   	leave  
  802ccc:	c3                   	ret    

00802ccd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802ccd:	55                   	push   %ebp
  802cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	52                   	push   %edx
  802cdd:	50                   	push   %eax
  802cde:	6a 1e                	push   $0x1e
  802ce0:	e8 c0 fc ff ff       	call   8029a5 <syscall>
  802ce5:	83 c4 18             	add    $0x18,%esp
}
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 1f                	push   $0x1f
  802cf9:	e8 a7 fc ff ff       	call   8029a5 <syscall>
  802cfe:	83 c4 18             	add    $0x18,%esp
}
  802d01:	c9                   	leave  
  802d02:	c3                   	ret    

00802d03 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d03:	55                   	push   %ebp
  802d04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	6a 00                	push   $0x0
  802d0b:	ff 75 14             	pushl  0x14(%ebp)
  802d0e:	ff 75 10             	pushl  0x10(%ebp)
  802d11:	ff 75 0c             	pushl  0xc(%ebp)
  802d14:	50                   	push   %eax
  802d15:	6a 20                	push   $0x20
  802d17:	e8 89 fc ff ff       	call   8029a5 <syscall>
  802d1c:	83 c4 18             	add    $0x18,%esp
}
  802d1f:	c9                   	leave  
  802d20:	c3                   	ret    

00802d21 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802d21:	55                   	push   %ebp
  802d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	6a 00                	push   $0x0
  802d29:	6a 00                	push   $0x0
  802d2b:	6a 00                	push   $0x0
  802d2d:	6a 00                	push   $0x0
  802d2f:	50                   	push   %eax
  802d30:	6a 21                	push   $0x21
  802d32:	e8 6e fc ff ff       	call   8029a5 <syscall>
  802d37:	83 c4 18             	add    $0x18,%esp
}
  802d3a:	90                   	nop
  802d3b:	c9                   	leave  
  802d3c:	c3                   	ret    

00802d3d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d3d:	55                   	push   %ebp
  802d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	6a 00                	push   $0x0
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	6a 00                	push   $0x0
  802d4b:	50                   	push   %eax
  802d4c:	6a 22                	push   $0x22
  802d4e:	e8 52 fc ff ff       	call   8029a5 <syscall>
  802d53:	83 c4 18             	add    $0x18,%esp
}
  802d56:	c9                   	leave  
  802d57:	c3                   	ret    

00802d58 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d58:	55                   	push   %ebp
  802d59:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 00                	push   $0x0
  802d5f:	6a 00                	push   $0x0
  802d61:	6a 00                	push   $0x0
  802d63:	6a 00                	push   $0x0
  802d65:	6a 02                	push   $0x2
  802d67:	e8 39 fc ff ff       	call   8029a5 <syscall>
  802d6c:	83 c4 18             	add    $0x18,%esp
}
  802d6f:	c9                   	leave  
  802d70:	c3                   	ret    

00802d71 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d71:	55                   	push   %ebp
  802d72:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d74:	6a 00                	push   $0x0
  802d76:	6a 00                	push   $0x0
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	6a 03                	push   $0x3
  802d80:	e8 20 fc ff ff       	call   8029a5 <syscall>
  802d85:	83 c4 18             	add    $0x18,%esp
}
  802d88:	c9                   	leave  
  802d89:	c3                   	ret    

00802d8a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	6a 00                	push   $0x0
  802d97:	6a 04                	push   $0x4
  802d99:	e8 07 fc ff ff       	call   8029a5 <syscall>
  802d9e:	83 c4 18             	add    $0x18,%esp
}
  802da1:	c9                   	leave  
  802da2:	c3                   	ret    

00802da3 <sys_exit_env>:


void sys_exit_env(void)
{
  802da3:	55                   	push   %ebp
  802da4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802da6:	6a 00                	push   $0x0
  802da8:	6a 00                	push   $0x0
  802daa:	6a 00                	push   $0x0
  802dac:	6a 00                	push   $0x0
  802dae:	6a 00                	push   $0x0
  802db0:	6a 23                	push   $0x23
  802db2:	e8 ee fb ff ff       	call   8029a5 <syscall>
  802db7:	83 c4 18             	add    $0x18,%esp
}
  802dba:	90                   	nop
  802dbb:	c9                   	leave  
  802dbc:	c3                   	ret    

00802dbd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802dbd:	55                   	push   %ebp
  802dbe:	89 e5                	mov    %esp,%ebp
  802dc0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802dc3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dc6:	8d 50 04             	lea    0x4(%eax),%edx
  802dc9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	52                   	push   %edx
  802dd3:	50                   	push   %eax
  802dd4:	6a 24                	push   $0x24
  802dd6:	e8 ca fb ff ff       	call   8029a5 <syscall>
  802ddb:	83 c4 18             	add    $0x18,%esp
	return result;
  802dde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802de1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802de4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802de7:	89 01                	mov    %eax,(%ecx)
  802de9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	c9                   	leave  
  802df0:	c2 04 00             	ret    $0x4

00802df3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802df3:	55                   	push   %ebp
  802df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802df6:	6a 00                	push   $0x0
  802df8:	6a 00                	push   $0x0
  802dfa:	ff 75 10             	pushl  0x10(%ebp)
  802dfd:	ff 75 0c             	pushl  0xc(%ebp)
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	6a 12                	push   $0x12
  802e05:	e8 9b fb ff ff       	call   8029a5 <syscall>
  802e0a:	83 c4 18             	add    $0x18,%esp
	return ;
  802e0d:	90                   	nop
}
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    

00802e10 <sys_rcr2>:
uint32 sys_rcr2()
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	6a 00                	push   $0x0
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 25                	push   $0x25
  802e1f:	e8 81 fb ff ff       	call   8029a5 <syscall>
  802e24:	83 c4 18             	add    $0x18,%esp
}
  802e27:	c9                   	leave  
  802e28:	c3                   	ret    

00802e29 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802e29:	55                   	push   %ebp
  802e2a:	89 e5                	mov    %esp,%ebp
  802e2c:	83 ec 04             	sub    $0x4,%esp
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e35:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e39:	6a 00                	push   $0x0
  802e3b:	6a 00                	push   $0x0
  802e3d:	6a 00                	push   $0x0
  802e3f:	6a 00                	push   $0x0
  802e41:	50                   	push   %eax
  802e42:	6a 26                	push   $0x26
  802e44:	e8 5c fb ff ff       	call   8029a5 <syscall>
  802e49:	83 c4 18             	add    $0x18,%esp
	return ;
  802e4c:	90                   	nop
}
  802e4d:	c9                   	leave  
  802e4e:	c3                   	ret    

00802e4f <rsttst>:
void rsttst()
{
  802e4f:	55                   	push   %ebp
  802e50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e52:	6a 00                	push   $0x0
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 28                	push   $0x28
  802e5e:	e8 42 fb ff ff       	call   8029a5 <syscall>
  802e63:	83 c4 18             	add    $0x18,%esp
	return ;
  802e66:	90                   	nop
}
  802e67:	c9                   	leave  
  802e68:	c3                   	ret    

00802e69 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e69:	55                   	push   %ebp
  802e6a:	89 e5                	mov    %esp,%ebp
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	8b 45 14             	mov    0x14(%ebp),%eax
  802e72:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e75:	8b 55 18             	mov    0x18(%ebp),%edx
  802e78:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e7c:	52                   	push   %edx
  802e7d:	50                   	push   %eax
  802e7e:	ff 75 10             	pushl  0x10(%ebp)
  802e81:	ff 75 0c             	pushl  0xc(%ebp)
  802e84:	ff 75 08             	pushl  0x8(%ebp)
  802e87:	6a 27                	push   $0x27
  802e89:	e8 17 fb ff ff       	call   8029a5 <syscall>
  802e8e:	83 c4 18             	add    $0x18,%esp
	return ;
  802e91:	90                   	nop
}
  802e92:	c9                   	leave  
  802e93:	c3                   	ret    

00802e94 <chktst>:
void chktst(uint32 n)
{
  802e94:	55                   	push   %ebp
  802e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 00                	push   $0x0
  802e9f:	ff 75 08             	pushl  0x8(%ebp)
  802ea2:	6a 29                	push   $0x29
  802ea4:	e8 fc fa ff ff       	call   8029a5 <syscall>
  802ea9:	83 c4 18             	add    $0x18,%esp
	return ;
  802eac:	90                   	nop
}
  802ead:	c9                   	leave  
  802eae:	c3                   	ret    

00802eaf <inctst>:

void inctst()
{
  802eaf:	55                   	push   %ebp
  802eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 2a                	push   $0x2a
  802ebe:	e8 e2 fa ff ff       	call   8029a5 <syscall>
  802ec3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ec6:	90                   	nop
}
  802ec7:	c9                   	leave  
  802ec8:	c3                   	ret    

00802ec9 <gettst>:
uint32 gettst()
{
  802ec9:	55                   	push   %ebp
  802eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 2b                	push   $0x2b
  802ed8:	e8 c8 fa ff ff       	call   8029a5 <syscall>
  802edd:	83 c4 18             	add    $0x18,%esp
}
  802ee0:	c9                   	leave  
  802ee1:	c3                   	ret    

00802ee2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802ee2:	55                   	push   %ebp
  802ee3:	89 e5                	mov    %esp,%ebp
  802ee5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ee8:	6a 00                	push   $0x0
  802eea:	6a 00                	push   $0x0
  802eec:	6a 00                	push   $0x0
  802eee:	6a 00                	push   $0x0
  802ef0:	6a 00                	push   $0x0
  802ef2:	6a 2c                	push   $0x2c
  802ef4:	e8 ac fa ff ff       	call   8029a5 <syscall>
  802ef9:	83 c4 18             	add    $0x18,%esp
  802efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802eff:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802f03:	75 07                	jne    802f0c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802f05:	b8 01 00 00 00       	mov    $0x1,%eax
  802f0a:	eb 05                	jmp    802f11 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f11:	c9                   	leave  
  802f12:	c3                   	ret    

00802f13 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802f13:	55                   	push   %ebp
  802f14:	89 e5                	mov    %esp,%ebp
  802f16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f19:	6a 00                	push   $0x0
  802f1b:	6a 00                	push   $0x0
  802f1d:	6a 00                	push   $0x0
  802f1f:	6a 00                	push   $0x0
  802f21:	6a 00                	push   $0x0
  802f23:	6a 2c                	push   $0x2c
  802f25:	e8 7b fa ff ff       	call   8029a5 <syscall>
  802f2a:	83 c4 18             	add    $0x18,%esp
  802f2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f30:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f34:	75 07                	jne    802f3d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f36:	b8 01 00 00 00       	mov    $0x1,%eax
  802f3b:	eb 05                	jmp    802f42 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f42:	c9                   	leave  
  802f43:	c3                   	ret    

00802f44 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
  802f47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	6a 00                	push   $0x0
  802f54:	6a 2c                	push   $0x2c
  802f56:	e8 4a fa ff ff       	call   8029a5 <syscall>
  802f5b:	83 c4 18             	add    $0x18,%esp
  802f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f61:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f65:	75 07                	jne    802f6e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f67:	b8 01 00 00 00       	mov    $0x1,%eax
  802f6c:	eb 05                	jmp    802f73 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f73:	c9                   	leave  
  802f74:	c3                   	ret    

00802f75 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f75:	55                   	push   %ebp
  802f76:	89 e5                	mov    %esp,%ebp
  802f78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 2c                	push   $0x2c
  802f87:	e8 19 fa ff ff       	call   8029a5 <syscall>
  802f8c:	83 c4 18             	add    $0x18,%esp
  802f8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f92:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f96:	75 07                	jne    802f9f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f98:	b8 01 00 00 00       	mov    $0x1,%eax
  802f9d:	eb 05                	jmp    802fa4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fa4:	c9                   	leave  
  802fa5:	c3                   	ret    

00802fa6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	6a 00                	push   $0x0
  802fb1:	ff 75 08             	pushl  0x8(%ebp)
  802fb4:	6a 2d                	push   $0x2d
  802fb6:	e8 ea f9 ff ff       	call   8029a5 <syscall>
  802fbb:	83 c4 18             	add    $0x18,%esp
	return ;
  802fbe:	90                   	nop
}
  802fbf:	c9                   	leave  
  802fc0:	c3                   	ret    

00802fc1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802fc1:	55                   	push   %ebp
  802fc2:	89 e5                	mov    %esp,%ebp
  802fc4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802fc5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	6a 00                	push   $0x0
  802fd3:	53                   	push   %ebx
  802fd4:	51                   	push   %ecx
  802fd5:	52                   	push   %edx
  802fd6:	50                   	push   %eax
  802fd7:	6a 2e                	push   $0x2e
  802fd9:	e8 c7 f9 ff ff       	call   8029a5 <syscall>
  802fde:	83 c4 18             	add    $0x18,%esp
}
  802fe1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fe4:	c9                   	leave  
  802fe5:	c3                   	ret    

00802fe6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802fe6:	55                   	push   %ebp
  802fe7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	6a 00                	push   $0x0
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	52                   	push   %edx
  802ff6:	50                   	push   %eax
  802ff7:	6a 2f                	push   $0x2f
  802ff9:	e8 a7 f9 ff ff       	call   8029a5 <syscall>
  802ffe:	83 c4 18             	add    $0x18,%esp
}
  803001:	c9                   	leave  
  803002:	c3                   	ret    

00803003 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  803003:	55                   	push   %ebp
  803004:	89 e5                	mov    %esp,%ebp
  803006:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  803009:	83 ec 0c             	sub    $0xc,%esp
  80300c:	68 5c 4f 80 00       	push   $0x804f5c
  803011:	e8 c7 e6 ff ff       	call   8016dd <cprintf>
  803016:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803019:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  803020:	83 ec 0c             	sub    $0xc,%esp
  803023:	68 88 4f 80 00       	push   $0x804f88
  803028:	e8 b0 e6 ff ff       	call   8016dd <cprintf>
  80302d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  803030:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803034:	a1 38 61 80 00       	mov    0x806138,%eax
  803039:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303c:	eb 56                	jmp    803094 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80303e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803042:	74 1c                	je     803060 <print_mem_block_lists+0x5d>
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	8b 50 08             	mov    0x8(%eax),%edx
  80304a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304d:	8b 48 08             	mov    0x8(%eax),%ecx
  803050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803053:	8b 40 0c             	mov    0xc(%eax),%eax
  803056:	01 c8                	add    %ecx,%eax
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	73 04                	jae    803060 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80305c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 50 08             	mov    0x8(%eax),%edx
  803066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803069:	8b 40 0c             	mov    0xc(%eax),%eax
  80306c:	01 c2                	add    %eax,%edx
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 40 08             	mov    0x8(%eax),%eax
  803074:	83 ec 04             	sub    $0x4,%esp
  803077:	52                   	push   %edx
  803078:	50                   	push   %eax
  803079:	68 9d 4f 80 00       	push   $0x804f9d
  80307e:	e8 5a e6 ff ff       	call   8016dd <cprintf>
  803083:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80308c:	a1 40 61 80 00       	mov    0x806140,%eax
  803091:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803098:	74 07                	je     8030a1 <print_mem_block_lists+0x9e>
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	8b 00                	mov    (%eax),%eax
  80309f:	eb 05                	jmp    8030a6 <print_mem_block_lists+0xa3>
  8030a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a6:	a3 40 61 80 00       	mov    %eax,0x806140
  8030ab:	a1 40 61 80 00       	mov    0x806140,%eax
  8030b0:	85 c0                	test   %eax,%eax
  8030b2:	75 8a                	jne    80303e <print_mem_block_lists+0x3b>
  8030b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b8:	75 84                	jne    80303e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8030ba:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8030be:	75 10                	jne    8030d0 <print_mem_block_lists+0xcd>
  8030c0:	83 ec 0c             	sub    $0xc,%esp
  8030c3:	68 ac 4f 80 00       	push   $0x804fac
  8030c8:	e8 10 e6 ff ff       	call   8016dd <cprintf>
  8030cd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8030d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8030d7:	83 ec 0c             	sub    $0xc,%esp
  8030da:	68 d0 4f 80 00       	push   $0x804fd0
  8030df:	e8 f9 e5 ff ff       	call   8016dd <cprintf>
  8030e4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8030e7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8030eb:	a1 40 60 80 00       	mov    0x806040,%eax
  8030f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f3:	eb 56                	jmp    80314b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8030f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f9:	74 1c                	je     803117 <print_mem_block_lists+0x114>
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	8b 50 08             	mov    0x8(%eax),%edx
  803101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803104:	8b 48 08             	mov    0x8(%eax),%ecx
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	8b 40 0c             	mov    0xc(%eax),%eax
  80310d:	01 c8                	add    %ecx,%eax
  80310f:	39 c2                	cmp    %eax,%edx
  803111:	73 04                	jae    803117 <print_mem_block_lists+0x114>
			sorted = 0 ;
  803113:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 50 08             	mov    0x8(%eax),%edx
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 40 0c             	mov    0xc(%eax),%eax
  803123:	01 c2                	add    %eax,%edx
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	8b 40 08             	mov    0x8(%eax),%eax
  80312b:	83 ec 04             	sub    $0x4,%esp
  80312e:	52                   	push   %edx
  80312f:	50                   	push   %eax
  803130:	68 9d 4f 80 00       	push   $0x804f9d
  803135:	e8 a3 e5 ff ff       	call   8016dd <cprintf>
  80313a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803143:	a1 48 60 80 00       	mov    0x806048,%eax
  803148:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314f:	74 07                	je     803158 <print_mem_block_lists+0x155>
  803151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803154:	8b 00                	mov    (%eax),%eax
  803156:	eb 05                	jmp    80315d <print_mem_block_lists+0x15a>
  803158:	b8 00 00 00 00       	mov    $0x0,%eax
  80315d:	a3 48 60 80 00       	mov    %eax,0x806048
  803162:	a1 48 60 80 00       	mov    0x806048,%eax
  803167:	85 c0                	test   %eax,%eax
  803169:	75 8a                	jne    8030f5 <print_mem_block_lists+0xf2>
  80316b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316f:	75 84                	jne    8030f5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803171:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803175:	75 10                	jne    803187 <print_mem_block_lists+0x184>
  803177:	83 ec 0c             	sub    $0xc,%esp
  80317a:	68 e8 4f 80 00       	push   $0x804fe8
  80317f:	e8 59 e5 ff ff       	call   8016dd <cprintf>
  803184:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803187:	83 ec 0c             	sub    $0xc,%esp
  80318a:	68 5c 4f 80 00       	push   $0x804f5c
  80318f:	e8 49 e5 ff ff       	call   8016dd <cprintf>
  803194:	83 c4 10             	add    $0x10,%esp

}
  803197:	90                   	nop
  803198:	c9                   	leave  
  803199:	c3                   	ret    

0080319a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80319a:	55                   	push   %ebp
  80319b:	89 e5                	mov    %esp,%ebp
  80319d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);
  8031a0:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  8031a7:	00 00 00 
  8031aa:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8031b1:	00 00 00 
  8031b4:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8031bb:	00 00 00 

		struct MemBlock *tmp=MemBlockNodes;
  8031be:	a1 50 60 80 00       	mov    0x806050,%eax
  8031c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (int i=0;i<numOfBlocks;i++)
  8031c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031cd:	e9 9e 00 00 00       	jmp    803270 <initialize_MemBlocksList+0xd6>
		{

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8031d2:	a1 50 60 80 00       	mov    0x806050,%eax
  8031d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031da:	c1 e2 04             	shl    $0x4,%edx
  8031dd:	01 d0                	add    %edx,%eax
  8031df:	85 c0                	test   %eax,%eax
  8031e1:	75 14                	jne    8031f7 <initialize_MemBlocksList+0x5d>
  8031e3:	83 ec 04             	sub    $0x4,%esp
  8031e6:	68 10 50 80 00       	push   $0x805010
  8031eb:	6a 48                	push   $0x48
  8031ed:	68 33 50 80 00       	push   $0x805033
  8031f2:	e8 32 e2 ff ff       	call   801429 <_panic>
  8031f7:	a1 50 60 80 00       	mov    0x806050,%eax
  8031fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ff:	c1 e2 04             	shl    $0x4,%edx
  803202:	01 d0                	add    %edx,%eax
  803204:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80320a:	89 10                	mov    %edx,(%eax)
  80320c:	8b 00                	mov    (%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 18                	je     80322a <initialize_MemBlocksList+0x90>
  803212:	a1 48 61 80 00       	mov    0x806148,%eax
  803217:	8b 15 50 60 80 00    	mov    0x806050,%edx
  80321d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803220:	c1 e1 04             	shl    $0x4,%ecx
  803223:	01 ca                	add    %ecx,%edx
  803225:	89 50 04             	mov    %edx,0x4(%eax)
  803228:	eb 12                	jmp    80323c <initialize_MemBlocksList+0xa2>
  80322a:	a1 50 60 80 00       	mov    0x806050,%eax
  80322f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803232:	c1 e2 04             	shl    $0x4,%edx
  803235:	01 d0                	add    %edx,%eax
  803237:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80323c:	a1 50 60 80 00       	mov    0x806050,%eax
  803241:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803244:	c1 e2 04             	shl    $0x4,%edx
  803247:	01 d0                	add    %edx,%eax
  803249:	a3 48 61 80 00       	mov    %eax,0x806148
  80324e:	a1 50 60 80 00       	mov    0x806050,%eax
  803253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803256:	c1 e2 04             	shl    $0x4,%edx
  803259:	01 d0                	add    %edx,%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 54 61 80 00       	mov    0x806154,%eax
  803267:	40                   	inc    %eax
  803268:	a3 54 61 80 00       	mov    %eax,0x806154
	// Write your code here, remove the panic and write your code

	LIST_INIT(&AvailableMemBlocksList);

		struct MemBlock *tmp=MemBlockNodes;
		for (int i=0;i<numOfBlocks;i++)
  80326d:	ff 45 f4             	incl   -0xc(%ebp)
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	3b 45 08             	cmp    0x8(%ebp),%eax
  803276:	0f 82 56 ff ff ff    	jb     8031d2 <initialize_MemBlocksList+0x38>

			LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
		}


}
  80327c:	90                   	nop
  80327d:	c9                   	leave  
  80327e:	c3                   	ret    

0080327f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80327f:	55                   	push   %ebp
  803280:	89 e5                	mov    %esp,%ebp
  803282:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	8b 00                	mov    (%eax),%eax
  80328a:	89 45 fc             	mov    %eax,-0x4(%ebp)

	while(tmp!=NULL)
  80328d:	eb 18                	jmp    8032a7 <find_block+0x28>
		{
			if(tmp->sva==va)
  80328f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803292:	8b 40 08             	mov    0x8(%eax),%eax
  803295:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803298:	75 05                	jne    80329f <find_block+0x20>
			{
				return tmp;
  80329a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80329d:	eb 11                	jmp    8032b0 <find_block+0x31>

			}
		tmp=tmp->prev_next_info.le_next;
  80329f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032a2:	8b 00                	mov    (%eax),%eax
  8032a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	// Write your code here, remove the panic and write your code


	struct MemBlock *tmp=blockList->lh_first;

	while(tmp!=NULL)
  8032a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032ab:	75 e2                	jne    80328f <find_block+0x10>
				return tmp;

			}
		tmp=tmp->prev_next_info.le_next;
		}
		return tmp;
  8032ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
//
//		}
//
//		}
//			return tmp;
}
  8032b0:	c9                   	leave  
  8032b1:	c3                   	ret    

008032b2 <insert_sorted_allocList>:
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================


void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8032b2:	55                   	push   %ebp
  8032b3:	89 e5                	mov    %esp,%ebp
  8032b5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code

	if(AllocMemBlocksList.lh_first==NULL)
  8032b8:	a1 40 60 80 00       	mov    0x806040,%eax
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	0f 85 83 00 00 00    	jne    803348 <insert_sorted_allocList+0x96>
	{
		LIST_INIT(&AllocMemBlocksList);
  8032c5:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8032cc:	00 00 00 
  8032cf:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8032d6:	00 00 00 
  8032d9:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8032e0:	00 00 00 
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8032e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e7:	75 14                	jne    8032fd <insert_sorted_allocList+0x4b>
  8032e9:	83 ec 04             	sub    $0x4,%esp
  8032ec:	68 10 50 80 00       	push   $0x805010
  8032f1:	6a 7f                	push   $0x7f
  8032f3:	68 33 50 80 00       	push   $0x805033
  8032f8:	e8 2c e1 ff ff       	call   801429 <_panic>
  8032fd:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	89 10                	mov    %edx,(%eax)
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	74 0d                	je     80331e <insert_sorted_allocList+0x6c>
  803311:	a1 40 60 80 00       	mov    0x806040,%eax
  803316:	8b 55 08             	mov    0x8(%ebp),%edx
  803319:	89 50 04             	mov    %edx,0x4(%eax)
  80331c:	eb 08                	jmp    803326 <insert_sorted_allocList+0x74>
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	a3 44 60 80 00       	mov    %eax,0x806044
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	a3 40 60 80 00       	mov    %eax,0x806040
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803338:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80333d:	40                   	inc    %eax
  80333e:	a3 4c 60 80 00       	mov    %eax,0x80604c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  803343:	e9 16 01 00 00       	jmp    80345e <insert_sorted_allocList+0x1ac>
		LIST_INIT(&AllocMemBlocksList);
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}


	else if(blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	8b 50 08             	mov    0x8(%eax),%edx
  80334e:	a1 44 60 80 00       	mov    0x806044,%eax
  803353:	8b 40 08             	mov    0x8(%eax),%eax
  803356:	39 c2                	cmp    %eax,%edx
  803358:	76 68                	jbe    8033c2 <insert_sorted_allocList+0x110>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
  80335a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80335e:	75 17                	jne    803377 <insert_sorted_allocList+0xc5>
  803360:	83 ec 04             	sub    $0x4,%esp
  803363:	68 4c 50 80 00       	push   $0x80504c
  803368:	68 85 00 00 00       	push   $0x85
  80336d:	68 33 50 80 00       	push   $0x805033
  803372:	e8 b2 e0 ff ff       	call   801429 <_panic>
  803377:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	89 50 04             	mov    %edx,0x4(%eax)
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0c                	je     803399 <insert_sorted_allocList+0xe7>
  80338d:	a1 44 60 80 00       	mov    0x806044,%eax
  803392:	8b 55 08             	mov    0x8(%ebp),%edx
  803395:	89 10                	mov    %edx,(%eax)
  803397:	eb 08                	jmp    8033a1 <insert_sorted_allocList+0xef>
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	a3 40 60 80 00       	mov    %eax,0x806040
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	a3 44 60 80 00       	mov    %eax,0x806044
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b2:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033b7:	40                   	inc    %eax
  8033b8:	a3 4c 60 80 00       	mov    %eax,0x80604c
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  8033bd:	e9 9c 00 00 00       	jmp    80345e <insert_sorted_allocList+0x1ac>
		LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
  8033c2:	a1 40 60 80 00       	mov    0x806040,%eax
  8033c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  8033ca:	e9 85 00 00 00       	jmp    803454 <insert_sorted_allocList+0x1a2>
		{
			if(blockToInsert->sva<tmp->sva)
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 50 08             	mov    0x8(%eax),%edx
  8033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d8:	8b 40 08             	mov    0x8(%eax),%eax
  8033db:	39 c2                	cmp    %eax,%edx
  8033dd:	73 6d                	jae    80344c <insert_sorted_allocList+0x19a>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
  8033df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e3:	74 06                	je     8033eb <insert_sorted_allocList+0x139>
  8033e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e9:	75 17                	jne    803402 <insert_sorted_allocList+0x150>
  8033eb:	83 ec 04             	sub    $0x4,%esp
  8033ee:	68 70 50 80 00       	push   $0x805070
  8033f3:	68 90 00 00 00       	push   $0x90
  8033f8:	68 33 50 80 00       	push   $0x805033
  8033fd:	e8 27 e0 ff ff       	call   801429 <_panic>
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 50 04             	mov    0x4(%eax),%edx
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	89 50 04             	mov    %edx,0x4(%eax)
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803414:	89 10                	mov    %edx,(%eax)
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 40 04             	mov    0x4(%eax),%eax
  80341c:	85 c0                	test   %eax,%eax
  80341e:	74 0d                	je     80342d <insert_sorted_allocList+0x17b>
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	8b 40 04             	mov    0x4(%eax),%eax
  803426:	8b 55 08             	mov    0x8(%ebp),%edx
  803429:	89 10                	mov    %edx,(%eax)
  80342b:	eb 08                	jmp    803435 <insert_sorted_allocList+0x183>
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	a3 40 60 80 00       	mov    %eax,0x806040
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 55 08             	mov    0x8(%ebp),%edx
  80343b:	89 50 04             	mov    %edx,0x4(%eax)
  80343e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803443:	40                   	inc    %eax
  803444:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803449:	90                   	nop
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80344a:	eb 12                	jmp    80345e <insert_sorted_allocList+0x1ac>
			{

				LIST_INSERT_BEFORE(&AllocMemBlocksList,tmp,blockToInsert);
				break;
			}
			tmp=tmp->prev_next_info.le_next;
  80344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344f:	8b 00                	mov    (%eax),%eax
  803451:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	else
	{
		struct MemBlock *tmp=AllocMemBlocksList.lh_first;
		while(tmp!=NULL)
  803454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803458:	0f 85 71 ff ff ff    	jne    8033cf <insert_sorted_allocList+0x11d>
			}
			tmp=tmp->prev_next_info.le_next;
		}

	}
}
  80345e:	90                   	nop
  80345f:	c9                   	leave  
  803460:	c3                   	ret    

00803461 <alloc_block_FF>:
//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

struct MemBlock *alloc_block_FF(uint32 size)
{
  803461:	55                   	push   %ebp
  803462:	89 e5                	mov    %esp,%ebp
  803464:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  803467:	a1 38 61 80 00       	mov    0x806138,%eax
  80346c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(tmp!=NULL)
  80346f:	e9 76 01 00 00       	jmp    8035ea <alloc_block_FF+0x189>
	{
		if(size==(tmp->size))
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	8b 40 0c             	mov    0xc(%eax),%eax
  80347a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80347d:	0f 85 8a 00 00 00    	jne    80350d <alloc_block_FF+0xac>
		{

			LIST_REMOVE(&FreeMemBlocksList,tmp);
  803483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803487:	75 17                	jne    8034a0 <alloc_block_FF+0x3f>
  803489:	83 ec 04             	sub    $0x4,%esp
  80348c:	68 a5 50 80 00       	push   $0x8050a5
  803491:	68 a8 00 00 00       	push   $0xa8
  803496:	68 33 50 80 00       	push   $0x805033
  80349b:	e8 89 df ff ff       	call   801429 <_panic>
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	74 10                	je     8034b9 <alloc_block_FF+0x58>
  8034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ac:	8b 00                	mov    (%eax),%eax
  8034ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b1:	8b 52 04             	mov    0x4(%edx),%edx
  8034b4:	89 50 04             	mov    %edx,0x4(%eax)
  8034b7:	eb 0b                	jmp    8034c4 <alloc_block_FF+0x63>
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 40 04             	mov    0x4(%eax),%eax
  8034bf:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8034c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	74 0f                	je     8034dd <alloc_block_FF+0x7c>
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	8b 40 04             	mov    0x4(%eax),%eax
  8034d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d7:	8b 12                	mov    (%edx),%edx
  8034d9:	89 10                	mov    %edx,(%eax)
  8034db:	eb 0a                	jmp    8034e7 <alloc_block_FF+0x86>
  8034dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e0:	8b 00                	mov    (%eax),%eax
  8034e2:	a3 38 61 80 00       	mov    %eax,0x806138
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fa:	a1 44 61 80 00       	mov    0x806144,%eax
  8034ff:	48                   	dec    %eax
  803500:	a3 44 61 80 00       	mov    %eax,0x806144

			return tmp;
  803505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803508:	e9 ea 00 00 00       	jmp    8035f7 <alloc_block_FF+0x196>

		}
		else if(size<tmp->size)
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	8b 40 0c             	mov    0xc(%eax),%eax
  803513:	3b 45 08             	cmp    0x8(%ebp),%eax
  803516:	0f 86 c6 00 00 00    	jbe    8035e2 <alloc_block_FF+0x181>
		{

			 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  80351c:	a1 48 61 80 00       	mov    0x806148,%eax
  803521:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 newBlock->size=size;
  803524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803527:	8b 55 08             	mov    0x8(%ebp),%edx
  80352a:	89 50 0c             	mov    %edx,0xc(%eax)
			 newBlock->sva=tmp->sva;
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	8b 50 08             	mov    0x8(%eax),%edx
  803533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803536:	89 50 08             	mov    %edx,0x8(%eax)
			 tmp->size=tmp->size-size;
  803539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353c:	8b 40 0c             	mov    0xc(%eax),%eax
  80353f:	2b 45 08             	sub    0x8(%ebp),%eax
  803542:	89 c2                	mov    %eax,%edx
  803544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803547:	89 50 0c             	mov    %edx,0xc(%eax)
			 tmp->sva=tmp->sva+size;
  80354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354d:	8b 50 08             	mov    0x8(%eax),%edx
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	01 c2                	add    %eax,%edx
  803555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803558:	89 50 08             	mov    %edx,0x8(%eax)

			 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  80355b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80355f:	75 17                	jne    803578 <alloc_block_FF+0x117>
  803561:	83 ec 04             	sub    $0x4,%esp
  803564:	68 a5 50 80 00       	push   $0x8050a5
  803569:	68 b6 00 00 00       	push   $0xb6
  80356e:	68 33 50 80 00       	push   $0x805033
  803573:	e8 b1 de ff ff       	call   801429 <_panic>
  803578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357b:	8b 00                	mov    (%eax),%eax
  80357d:	85 c0                	test   %eax,%eax
  80357f:	74 10                	je     803591 <alloc_block_FF+0x130>
  803581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803584:	8b 00                	mov    (%eax),%eax
  803586:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803589:	8b 52 04             	mov    0x4(%edx),%edx
  80358c:	89 50 04             	mov    %edx,0x4(%eax)
  80358f:	eb 0b                	jmp    80359c <alloc_block_FF+0x13b>
  803591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803594:	8b 40 04             	mov    0x4(%eax),%eax
  803597:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80359c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359f:	8b 40 04             	mov    0x4(%eax),%eax
  8035a2:	85 c0                	test   %eax,%eax
  8035a4:	74 0f                	je     8035b5 <alloc_block_FF+0x154>
  8035a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a9:	8b 40 04             	mov    0x4(%eax),%eax
  8035ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035af:	8b 12                	mov    (%edx),%edx
  8035b1:	89 10                	mov    %edx,(%eax)
  8035b3:	eb 0a                	jmp    8035bf <alloc_block_FF+0x15e>
  8035b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b8:	8b 00                	mov    (%eax),%eax
  8035ba:	a3 48 61 80 00       	mov    %eax,0x806148
  8035bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d2:	a1 54 61 80 00       	mov    0x806154,%eax
  8035d7:	48                   	dec    %eax
  8035d8:	a3 54 61 80 00       	mov    %eax,0x806154
			 return newBlock;
  8035dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e0:	eb 15                	jmp    8035f7 <alloc_block_FF+0x196>

		}
		tmp=tmp->prev_next_info.le_next;
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	8b 00                	mov    (%eax),%eax
  8035e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp=FreeMemBlocksList.lh_first;

	while(tmp!=NULL)
  8035ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ee:	0f 85 80 fe ff ff    	jne    803474 <alloc_block_FF+0x13>
			 return newBlock;

		}
		tmp=tmp->prev_next_info.le_next;
	}
	return tmp;
  8035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8035f7:	c9                   	leave  
  8035f8:	c3                   	ret    

008035f9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8035f9:	55                   	push   %ebp
  8035fa:	89 e5                	mov    %esp,%ebp
  8035fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
  8035ff:	a1 38 61 80 00       	mov    0x806138,%eax
  803604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 newSize=UINT_MAX;
  803607:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)


		while(tmp!=NULL)
  80360e:	e9 c0 00 00 00       	jmp    8036d3 <alloc_block_BF+0xda>
		{
			if(size==(tmp->size))
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 40 0c             	mov    0xc(%eax),%eax
  803619:	3b 45 08             	cmp    0x8(%ebp),%eax
  80361c:	0f 85 8a 00 00 00    	jne    8036ac <alloc_block_BF+0xb3>
			{
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  803622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803626:	75 17                	jne    80363f <alloc_block_BF+0x46>
  803628:	83 ec 04             	sub    $0x4,%esp
  80362b:	68 a5 50 80 00       	push   $0x8050a5
  803630:	68 cf 00 00 00       	push   $0xcf
  803635:	68 33 50 80 00       	push   $0x805033
  80363a:	e8 ea dd ff ff       	call   801429 <_panic>
  80363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803642:	8b 00                	mov    (%eax),%eax
  803644:	85 c0                	test   %eax,%eax
  803646:	74 10                	je     803658 <alloc_block_BF+0x5f>
  803648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364b:	8b 00                	mov    (%eax),%eax
  80364d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803650:	8b 52 04             	mov    0x4(%edx),%edx
  803653:	89 50 04             	mov    %edx,0x4(%eax)
  803656:	eb 0b                	jmp    803663 <alloc_block_BF+0x6a>
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	8b 40 04             	mov    0x4(%eax),%eax
  80365e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803666:	8b 40 04             	mov    0x4(%eax),%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	74 0f                	je     80367c <alloc_block_BF+0x83>
  80366d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803670:	8b 40 04             	mov    0x4(%eax),%eax
  803673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803676:	8b 12                	mov    (%edx),%edx
  803678:	89 10                	mov    %edx,(%eax)
  80367a:	eb 0a                	jmp    803686 <alloc_block_BF+0x8d>
  80367c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	a3 38 61 80 00       	mov    %eax,0x806138
  803686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80368f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803692:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803699:	a1 44 61 80 00       	mov    0x806144,%eax
  80369e:	48                   	dec    %eax
  80369f:	a3 44 61 80 00       	mov    %eax,0x806144
				return tmp;
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	e9 2a 01 00 00       	jmp    8037d6 <alloc_block_BF+0x1dd>

			}
			else if (tmp->size<newSize&&tmp->size>size)
  8036ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036af:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036b5:	73 14                	jae    8036cb <alloc_block_BF+0xd2>
  8036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8036bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036c0:	76 09                	jbe    8036cb <alloc_block_BF+0xd2>
			{
				newSize=tmp->size;
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c8:	89 45 f0             	mov    %eax,-0x10(%ebp)


			}
			tmp=tmp->prev_next_info.le_next;
  8036cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct MemBlock *tmp=FreeMemBlocksList.lh_first;
	uint32 newSize=UINT_MAX;


		while(tmp!=NULL)
  8036d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d7:	0f 85 36 ff ff ff    	jne    803613 <alloc_block_BF+0x1a>
		}//tmp=NULL




			tmp =FreeMemBlocksList.lh_first;
  8036dd:	a1 38 61 80 00       	mov    0x806138,%eax
  8036e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			while(tmp!=NULL)
  8036e5:	e9 dd 00 00 00       	jmp    8037c7 <alloc_block_BF+0x1ce>
			{
				if(tmp->size==newSize)
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036f3:	0f 85 c6 00 00 00    	jne    8037bf <alloc_block_BF+0x1c6>
					{
					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8036f9:	a1 48 61 80 00       	mov    0x806148,%eax
  8036fe:	89 45 ec             	mov    %eax,-0x14(%ebp)

								 newBlock->sva=tmp->sva;     //newBlock.sva=tmp.sva
  803701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803704:	8b 50 08             	mov    0x8(%eax),%edx
  803707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370a:	89 50 08             	mov    %edx,0x8(%eax)
								 newBlock->size=size;
  80370d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803710:	8b 55 08             	mov    0x8(%ebp),%edx
  803713:	89 50 0c             	mov    %edx,0xc(%eax)

											 tmp->sva+=size;
  803716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803719:	8b 50 08             	mov    0x8(%eax),%edx
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	01 c2                	add    %eax,%edx
  803721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803724:	89 50 08             	mov    %edx,0x8(%eax)
											 tmp->size-=size;
  803727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372a:	8b 40 0c             	mov    0xc(%eax),%eax
  80372d:	2b 45 08             	sub    0x8(%ebp),%eax
  803730:	89 c2                	mov    %eax,%edx
  803732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803735:	89 50 0c             	mov    %edx,0xc(%eax)
											 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803738:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80373c:	75 17                	jne    803755 <alloc_block_BF+0x15c>
  80373e:	83 ec 04             	sub    $0x4,%esp
  803741:	68 a5 50 80 00       	push   $0x8050a5
  803746:	68 eb 00 00 00       	push   $0xeb
  80374b:	68 33 50 80 00       	push   $0x805033
  803750:	e8 d4 dc ff ff       	call   801429 <_panic>
  803755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803758:	8b 00                	mov    (%eax),%eax
  80375a:	85 c0                	test   %eax,%eax
  80375c:	74 10                	je     80376e <alloc_block_BF+0x175>
  80375e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803761:	8b 00                	mov    (%eax),%eax
  803763:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803766:	8b 52 04             	mov    0x4(%edx),%edx
  803769:	89 50 04             	mov    %edx,0x4(%eax)
  80376c:	eb 0b                	jmp    803779 <alloc_block_BF+0x180>
  80376e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803771:	8b 40 04             	mov    0x4(%eax),%eax
  803774:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377c:	8b 40 04             	mov    0x4(%eax),%eax
  80377f:	85 c0                	test   %eax,%eax
  803781:	74 0f                	je     803792 <alloc_block_BF+0x199>
  803783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803786:	8b 40 04             	mov    0x4(%eax),%eax
  803789:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80378c:	8b 12                	mov    (%edx),%edx
  80378e:	89 10                	mov    %edx,(%eax)
  803790:	eb 0a                	jmp    80379c <alloc_block_BF+0x1a3>
  803792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803795:	8b 00                	mov    (%eax),%eax
  803797:	a3 48 61 80 00       	mov    %eax,0x806148
  80379c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80379f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037af:	a1 54 61 80 00       	mov    0x806154,%eax
  8037b4:	48                   	dec    %eax
  8037b5:	a3 54 61 80 00       	mov    %eax,0x806154
											 return newBlock;
  8037ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bd:	eb 17                	jmp    8037d6 <alloc_block_BF+0x1dd>

					}
				tmp=tmp->prev_next_info.le_next;
  8037bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c2:	8b 00                	mov    (%eax),%eax
  8037c4:	89 45 f4             	mov    %eax,-0xc(%ebp)




			tmp =FreeMemBlocksList.lh_first;
			while(tmp!=NULL)
  8037c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037cb:	0f 85 19 ff ff ff    	jne    8036ea <alloc_block_BF+0xf1>
			//tmp ->  block newSize,Sva




		return NULL; //return NULL
  8037d1:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8037d6:	c9                   	leave  
  8037d7:	c3                   	ret    

008037d8 <alloc_block_NF>:
//=========================================



struct MemBlock *alloc_block_NF(uint32 size)
{
  8037d8:	55                   	push   %ebp
  8037d9:	89 e5                	mov    %esp,%ebp
  8037db:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	struct MemBlock *tmp1;
	uint32 currentSva;
	if(AllocMemBlocksList.lh_first==NULL)
  8037de:	a1 40 60 80 00       	mov    0x806040,%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	75 19                	jne    803800 <alloc_block_NF+0x28>
	{
		tmp1=alloc_block_FF(size);
  8037e7:	83 ec 0c             	sub    $0xc,%esp
  8037ea:	ff 75 08             	pushl  0x8(%ebp)
  8037ed:	e8 6f fc ff ff       	call   803461 <alloc_block_FF>
  8037f2:	83 c4 10             	add    $0x10,%esp
  8037f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return tmp1;
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	e9 e9 01 00 00       	jmp    8039e9 <alloc_block_NF+0x211>
	}

			else
			{
            currentSva=AllocMemBlocksList.lh_last->sva;
  803800:	a1 44 60 80 00       	mov    0x806044,%eax
  803805:	8b 40 08             	mov    0x8(%eax),%eax
  803808:	89 45 f0             	mov    %eax,-0x10(%ebp)
			tmp1=find_block(&FreeMemBlocksList,AllocMemBlocksList.lh_last->size+AllocMemBlocksList.lh_last->sva);
  80380b:	a1 44 60 80 00       	mov    0x806044,%eax
  803810:	8b 50 0c             	mov    0xc(%eax),%edx
  803813:	a1 44 60 80 00       	mov    0x806044,%eax
  803818:	8b 40 08             	mov    0x8(%eax),%eax
  80381b:	01 d0                	add    %edx,%eax
  80381d:	83 ec 08             	sub    $0x8,%esp
  803820:	50                   	push   %eax
  803821:	68 38 61 80 00       	push   $0x806138
  803826:	e8 54 fa ff ff       	call   80327f <find_block>
  80382b:	83 c4 10             	add    $0x10,%esp
  80382e:	89 45 f4             	mov    %eax,-0xc(%ebp)


do
	{

		if(size==(tmp1->size))
  803831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803834:	8b 40 0c             	mov    0xc(%eax),%eax
  803837:	3b 45 08             	cmp    0x8(%ebp),%eax
  80383a:	0f 85 9b 00 00 00    	jne    8038db <alloc_block_NF+0x103>
				{
			currentSva=tmp1->size+tmp1->sva;
  803840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803843:	8b 50 0c             	mov    0xc(%eax),%edx
  803846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803849:	8b 40 08             	mov    0x8(%eax),%eax
  80384c:	01 d0                	add    %edx,%eax
  80384e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,tmp1);
  803851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803855:	75 17                	jne    80386e <alloc_block_NF+0x96>
  803857:	83 ec 04             	sub    $0x4,%esp
  80385a:	68 a5 50 80 00       	push   $0x8050a5
  80385f:	68 1a 01 00 00       	push   $0x11a
  803864:	68 33 50 80 00       	push   $0x805033
  803869:	e8 bb db ff ff       	call   801429 <_panic>
  80386e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	85 c0                	test   %eax,%eax
  803875:	74 10                	je     803887 <alloc_block_NF+0xaf>
  803877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387a:	8b 00                	mov    (%eax),%eax
  80387c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80387f:	8b 52 04             	mov    0x4(%edx),%edx
  803882:	89 50 04             	mov    %edx,0x4(%eax)
  803885:	eb 0b                	jmp    803892 <alloc_block_NF+0xba>
  803887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388a:	8b 40 04             	mov    0x4(%eax),%eax
  80388d:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	85 c0                	test   %eax,%eax
  80389a:	74 0f                	je     8038ab <alloc_block_NF+0xd3>
  80389c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389f:	8b 40 04             	mov    0x4(%eax),%eax
  8038a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038a5:	8b 12                	mov    (%edx),%edx
  8038a7:	89 10                	mov    %edx,(%eax)
  8038a9:	eb 0a                	jmp    8038b5 <alloc_block_NF+0xdd>
  8038ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	a3 38 61 80 00       	mov    %eax,0x806138
  8038b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c8:	a1 44 61 80 00       	mov    0x806144,%eax
  8038cd:	48                   	dec    %eax
  8038ce:	a3 44 61 80 00       	mov    %eax,0x806144
					return tmp1;
  8038d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d6:	e9 0e 01 00 00       	jmp    8039e9 <alloc_block_NF+0x211>

				}
				else if(size<tmp1->size)
  8038db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038de:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038e4:	0f 86 cf 00 00 00    	jbe    8039b9 <alloc_block_NF+0x1e1>
				{

					 struct MemBlock *newBlock=LIST_FIRST(&(AvailableMemBlocksList));
  8038ea:	a1 48 61 80 00       	mov    0x806148,%eax
  8038ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 newBlock->size=size;
  8038f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f8:	89 50 0c             	mov    %edx,0xc(%eax)
					 newBlock->sva=tmp1->sva;
  8038fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fe:	8b 50 08             	mov    0x8(%eax),%edx
  803901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803904:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->sva+=size;
  803907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390a:	8b 50 08             	mov    0x8(%eax),%edx
  80390d:	8b 45 08             	mov    0x8(%ebp),%eax
  803910:	01 c2                	add    %eax,%edx
  803912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803915:	89 50 08             	mov    %edx,0x8(%eax)
					 tmp1->size-=size;
  803918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391b:	8b 40 0c             	mov    0xc(%eax),%eax
  80391e:	2b 45 08             	sub    0x8(%ebp),%eax
  803921:	89 c2                	mov    %eax,%edx
  803923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803926:	89 50 0c             	mov    %edx,0xc(%eax)
                     currentSva=tmp1->sva;
  803929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392c:	8b 40 08             	mov    0x8(%eax),%eax
  80392f:	89 45 f0             	mov    %eax,-0x10(%ebp)

					 LIST_REMOVE(&AvailableMemBlocksList,newBlock);
  803932:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803936:	75 17                	jne    80394f <alloc_block_NF+0x177>
  803938:	83 ec 04             	sub    $0x4,%esp
  80393b:	68 a5 50 80 00       	push   $0x8050a5
  803940:	68 28 01 00 00       	push   $0x128
  803945:	68 33 50 80 00       	push   $0x805033
  80394a:	e8 da da ff ff       	call   801429 <_panic>
  80394f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803952:	8b 00                	mov    (%eax),%eax
  803954:	85 c0                	test   %eax,%eax
  803956:	74 10                	je     803968 <alloc_block_NF+0x190>
  803958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395b:	8b 00                	mov    (%eax),%eax
  80395d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803960:	8b 52 04             	mov    0x4(%edx),%edx
  803963:	89 50 04             	mov    %edx,0x4(%eax)
  803966:	eb 0b                	jmp    803973 <alloc_block_NF+0x19b>
  803968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396b:	8b 40 04             	mov    0x4(%eax),%eax
  80396e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803976:	8b 40 04             	mov    0x4(%eax),%eax
  803979:	85 c0                	test   %eax,%eax
  80397b:	74 0f                	je     80398c <alloc_block_NF+0x1b4>
  80397d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803980:	8b 40 04             	mov    0x4(%eax),%eax
  803983:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803986:	8b 12                	mov    (%edx),%edx
  803988:	89 10                	mov    %edx,(%eax)
  80398a:	eb 0a                	jmp    803996 <alloc_block_NF+0x1be>
  80398c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80398f:	8b 00                	mov    (%eax),%eax
  803991:	a3 48 61 80 00       	mov    %eax,0x806148
  803996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803999:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80399f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a9:	a1 54 61 80 00       	mov    0x806154,%eax
  8039ae:	48                   	dec    %eax
  8039af:	a3 54 61 80 00       	mov    %eax,0x806154
					 return newBlock;
  8039b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b7:	eb 30                	jmp    8039e9 <alloc_block_NF+0x211>

				}
		if(tmp1==FreeMemBlocksList.lh_last)
  8039b9:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8039be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8039c1:	75 0a                	jne    8039cd <alloc_block_NF+0x1f5>
			tmp1=FreeMemBlocksList.lh_first;
  8039c3:	a1 38 61 80 00       	mov    0x806138,%eax
  8039c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039cb:	eb 08                	jmp    8039d5 <alloc_block_NF+0x1fd>
		else
				tmp1=tmp1->prev_next_info.le_next;
  8039cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d0:	8b 00                	mov    (%eax),%eax
  8039d2:	89 45 f4             	mov    %eax,-0xc(%ebp)


			}
while(tmp1->sva!=currentSva);
  8039d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d8:	8b 40 08             	mov    0x8(%eax),%eax
  8039db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8039de:	0f 85 4d fe ff ff    	jne    803831 <alloc_block_NF+0x59>

			return NULL;
  8039e4:	b8 00 00 00 00       	mov    $0x0,%eax

	}
  8039e9:	c9                   	leave  
  8039ea:	c3                   	ret    

008039eb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8039eb:	55                   	push   %ebp
  8039ec:	89 e5                	mov    %esp,%ebp
  8039ee:	53                   	push   %ebx
  8039ef:	83 ec 14             	sub    $0x14,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	if(FreeMemBlocksList.lh_first==NULL)
  8039f2:	a1 38 61 80 00       	mov    0x806138,%eax
  8039f7:	85 c0                	test   %eax,%eax
  8039f9:	0f 85 86 00 00 00    	jne    803a85 <insert_sorted_with_merge_freeList+0x9a>
	{
		LIST_INIT(&FreeMemBlocksList);
  8039ff:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  803a06:	00 00 00 
  803a09:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  803a10:	00 00 00 
  803a13:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  803a1a:	00 00 00 
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803a1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a21:	75 17                	jne    803a3a <insert_sorted_with_merge_freeList+0x4f>
  803a23:	83 ec 04             	sub    $0x4,%esp
  803a26:	68 10 50 80 00       	push   $0x805010
  803a2b:	68 48 01 00 00       	push   $0x148
  803a30:	68 33 50 80 00       	push   $0x805033
  803a35:	e8 ef d9 ff ff       	call   801429 <_panic>
  803a3a:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803a40:	8b 45 08             	mov    0x8(%ebp),%eax
  803a43:	89 10                	mov    %edx,(%eax)
  803a45:	8b 45 08             	mov    0x8(%ebp),%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	85 c0                	test   %eax,%eax
  803a4c:	74 0d                	je     803a5b <insert_sorted_with_merge_freeList+0x70>
  803a4e:	a1 38 61 80 00       	mov    0x806138,%eax
  803a53:	8b 55 08             	mov    0x8(%ebp),%edx
  803a56:	89 50 04             	mov    %edx,0x4(%eax)
  803a59:	eb 08                	jmp    803a63 <insert_sorted_with_merge_freeList+0x78>
  803a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a63:	8b 45 08             	mov    0x8(%ebp),%eax
  803a66:	a3 38 61 80 00       	mov    %eax,0x806138
  803a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a75:	a1 44 61 80 00       	mov    0x806144,%eax
  803a7a:	40                   	inc    %eax
  803a7b:	a3 44 61 80 00       	mov    %eax,0x806144
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  803a80:	e9 73 07 00 00       	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
	if(FreeMemBlocksList.lh_first==NULL)
	{
		LIST_INIT(&FreeMemBlocksList);
		LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva!=(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803a85:	8b 45 08             	mov    0x8(%ebp),%eax
  803a88:	8b 50 08             	mov    0x8(%eax),%edx
  803a8b:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803a90:	8b 40 08             	mov    0x8(%eax),%eax
  803a93:	39 c2                	cmp    %eax,%edx
  803a95:	0f 86 84 00 00 00    	jbe    803b1f <insert_sorted_with_merge_freeList+0x134>
  803a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9e:	8b 50 08             	mov    0x8(%eax),%edx
  803aa1:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803aa6:	8b 48 0c             	mov    0xc(%eax),%ecx
  803aa9:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803aae:	8b 40 08             	mov    0x8(%eax),%eax
  803ab1:	01 c8                	add    %ecx,%eax
  803ab3:	39 c2                	cmp    %eax,%edx
  803ab5:	74 68                	je     803b1f <insert_sorted_with_merge_freeList+0x134>
	{
		LIST_INSERT_TAIL(&FreeMemBlocksList,blockToInsert);
  803ab7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803abb:	75 17                	jne    803ad4 <insert_sorted_with_merge_freeList+0xe9>
  803abd:	83 ec 04             	sub    $0x4,%esp
  803ac0:	68 4c 50 80 00       	push   $0x80504c
  803ac5:	68 4c 01 00 00       	push   $0x14c
  803aca:	68 33 50 80 00       	push   $0x805033
  803acf:	e8 55 d9 ff ff       	call   801429 <_panic>
  803ad4:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803ada:	8b 45 08             	mov    0x8(%ebp),%eax
  803add:	89 50 04             	mov    %edx,0x4(%eax)
  803ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae3:	8b 40 04             	mov    0x4(%eax),%eax
  803ae6:	85 c0                	test   %eax,%eax
  803ae8:	74 0c                	je     803af6 <insert_sorted_with_merge_freeList+0x10b>
  803aea:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803aef:	8b 55 08             	mov    0x8(%ebp),%edx
  803af2:	89 10                	mov    %edx,(%eax)
  803af4:	eb 08                	jmp    803afe <insert_sorted_with_merge_freeList+0x113>
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	a3 38 61 80 00       	mov    %eax,0x806138
  803afe:	8b 45 08             	mov    0x8(%ebp),%eax
  803b01:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
  803b09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b0f:	a1 44 61 80 00       	mov    0x806144,%eax
  803b14:	40                   	inc    %eax
  803b15:	a3 44 61 80 00       	mov    %eax,0x806144
  803b1a:	e9 d9 06 00 00       	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva>FreeMemBlocksList.lh_last->sva&&blockToInsert->sva==(FreeMemBlocksList.lh_last->size+FreeMemBlocksList.lh_last->sva))
  803b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b22:	8b 50 08             	mov    0x8(%eax),%edx
  803b25:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803b2a:	8b 40 08             	mov    0x8(%eax),%eax
  803b2d:	39 c2                	cmp    %eax,%edx
  803b2f:	0f 86 b5 00 00 00    	jbe    803bea <insert_sorted_with_merge_freeList+0x1ff>
  803b35:	8b 45 08             	mov    0x8(%ebp),%eax
  803b38:	8b 50 08             	mov    0x8(%eax),%edx
  803b3b:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803b40:	8b 48 0c             	mov    0xc(%eax),%ecx
  803b43:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803b48:	8b 40 08             	mov    0x8(%eax),%eax
  803b4b:	01 c8                	add    %ecx,%eax
  803b4d:	39 c2                	cmp    %eax,%edx
  803b4f:	0f 85 95 00 00 00    	jne    803bea <insert_sorted_with_merge_freeList+0x1ff>

	{
		FreeMemBlocksList.lh_last->size+=blockToInsert->size;
  803b55:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803b5a:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803b60:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803b63:	8b 55 08             	mov    0x8(%ebp),%edx
  803b66:	8b 52 0c             	mov    0xc(%edx),%edx
  803b69:	01 ca                	add    %ecx,%edx
  803b6b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803b78:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803b82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b86:	75 17                	jne    803b9f <insert_sorted_with_merge_freeList+0x1b4>
  803b88:	83 ec 04             	sub    $0x4,%esp
  803b8b:	68 10 50 80 00       	push   $0x805010
  803b90:	68 54 01 00 00       	push   $0x154
  803b95:	68 33 50 80 00       	push   $0x805033
  803b9a:	e8 8a d8 ff ff       	call   801429 <_panic>
  803b9f:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba8:	89 10                	mov    %edx,(%eax)
  803baa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bad:	8b 00                	mov    (%eax),%eax
  803baf:	85 c0                	test   %eax,%eax
  803bb1:	74 0d                	je     803bc0 <insert_sorted_with_merge_freeList+0x1d5>
  803bb3:	a1 48 61 80 00       	mov    0x806148,%eax
  803bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  803bbb:	89 50 04             	mov    %edx,0x4(%eax)
  803bbe:	eb 08                	jmp    803bc8 <insert_sorted_with_merge_freeList+0x1dd>
  803bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcb:	a3 48 61 80 00       	mov    %eax,0x806148
  803bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bda:	a1 54 61 80 00       	mov    0x806154,%eax
  803bdf:	40                   	inc    %eax
  803be0:	a3 54 61 80 00       	mov    %eax,0x806154
  803be5:	e9 0e 06 00 00       	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva==(blockToInsert->sva+blockToInsert->size))
  803bea:	8b 45 08             	mov    0x8(%ebp),%eax
  803bed:	8b 50 08             	mov    0x8(%eax),%edx
  803bf0:	a1 38 61 80 00       	mov    0x806138,%eax
  803bf5:	8b 40 08             	mov    0x8(%eax),%eax
  803bf8:	39 c2                	cmp    %eax,%edx
  803bfa:	0f 83 c1 00 00 00    	jae    803cc1 <insert_sorted_with_merge_freeList+0x2d6>
  803c00:	a1 38 61 80 00       	mov    0x806138,%eax
  803c05:	8b 50 08             	mov    0x8(%eax),%edx
  803c08:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0b:	8b 48 08             	mov    0x8(%eax),%ecx
  803c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c11:	8b 40 0c             	mov    0xc(%eax),%eax
  803c14:	01 c8                	add    %ecx,%eax
  803c16:	39 c2                	cmp    %eax,%edx
  803c18:	0f 85 a3 00 00 00    	jne    803cc1 <insert_sorted_with_merge_freeList+0x2d6>
	{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803c1e:	a1 38 61 80 00       	mov    0x806138,%eax
  803c23:	8b 55 08             	mov    0x8(%ebp),%edx
  803c26:	8b 52 08             	mov    0x8(%edx),%edx
  803c29:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size+=blockToInsert->size;
  803c2c:	a1 38 61 80 00       	mov    0x806138,%eax
  803c31:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803c37:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  803c3d:	8b 52 0c             	mov    0xc(%edx),%edx
  803c40:	01 ca                	add    %ecx,%edx
  803c42:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->sva=0;
  803c45:	8b 45 08             	mov    0x8(%ebp),%eax
  803c48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		blockToInsert->size=0;
  803c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c52:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

		LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803c59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c5d:	75 17                	jne    803c76 <insert_sorted_with_merge_freeList+0x28b>
  803c5f:	83 ec 04             	sub    $0x4,%esp
  803c62:	68 10 50 80 00       	push   $0x805010
  803c67:	68 5d 01 00 00       	push   $0x15d
  803c6c:	68 33 50 80 00       	push   $0x805033
  803c71:	e8 b3 d7 ff ff       	call   801429 <_panic>
  803c76:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7f:	89 10                	mov    %edx,(%eax)
  803c81:	8b 45 08             	mov    0x8(%ebp),%eax
  803c84:	8b 00                	mov    (%eax),%eax
  803c86:	85 c0                	test   %eax,%eax
  803c88:	74 0d                	je     803c97 <insert_sorted_with_merge_freeList+0x2ac>
  803c8a:	a1 48 61 80 00       	mov    0x806148,%eax
  803c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  803c92:	89 50 04             	mov    %edx,0x4(%eax)
  803c95:	eb 08                	jmp    803c9f <insert_sorted_with_merge_freeList+0x2b4>
  803c97:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca2:	a3 48 61 80 00       	mov    %eax,0x806148
  803ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  803caa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb1:	a1 54 61 80 00       	mov    0x806154,%eax
  803cb6:	40                   	inc    %eax
  803cb7:	a3 54 61 80 00       	mov    %eax,0x806154
  803cbc:	e9 37 05 00 00       	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
	}
	else if(blockToInsert->sva<FreeMemBlocksList.lh_first->sva&&FreeMemBlocksList.lh_first->sva!=(blockToInsert->sva+blockToInsert->size))
  803cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc4:	8b 50 08             	mov    0x8(%eax),%edx
  803cc7:	a1 38 61 80 00       	mov    0x806138,%eax
  803ccc:	8b 40 08             	mov    0x8(%eax),%eax
  803ccf:	39 c2                	cmp    %eax,%edx
  803cd1:	0f 83 82 00 00 00    	jae    803d59 <insert_sorted_with_merge_freeList+0x36e>
  803cd7:	a1 38 61 80 00       	mov    0x806138,%eax
  803cdc:	8b 50 08             	mov    0x8(%eax),%edx
  803cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce2:	8b 48 08             	mov    0x8(%eax),%ecx
  803ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  803ceb:	01 c8                	add    %ecx,%eax
  803ced:	39 c2                	cmp    %eax,%edx
  803cef:	74 68                	je     803d59 <insert_sorted_with_merge_freeList+0x36e>

	{
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803cf1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cf5:	75 17                	jne    803d0e <insert_sorted_with_merge_freeList+0x323>
  803cf7:	83 ec 04             	sub    $0x4,%esp
  803cfa:	68 10 50 80 00       	push   $0x805010
  803cff:	68 62 01 00 00       	push   $0x162
  803d04:	68 33 50 80 00       	push   $0x805033
  803d09:	e8 1b d7 ff ff       	call   801429 <_panic>
  803d0e:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803d14:	8b 45 08             	mov    0x8(%ebp),%eax
  803d17:	89 10                	mov    %edx,(%eax)
  803d19:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1c:	8b 00                	mov    (%eax),%eax
  803d1e:	85 c0                	test   %eax,%eax
  803d20:	74 0d                	je     803d2f <insert_sorted_with_merge_freeList+0x344>
  803d22:	a1 38 61 80 00       	mov    0x806138,%eax
  803d27:	8b 55 08             	mov    0x8(%ebp),%edx
  803d2a:	89 50 04             	mov    %edx,0x4(%eax)
  803d2d:	eb 08                	jmp    803d37 <insert_sorted_with_merge_freeList+0x34c>
  803d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d32:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d37:	8b 45 08             	mov    0x8(%ebp),%eax
  803d3a:	a3 38 61 80 00       	mov    %eax,0x806138
  803d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d49:	a1 44 61 80 00       	mov    0x806144,%eax
  803d4e:	40                   	inc    %eax
  803d4f:	a3 44 61 80 00       	mov    %eax,0x806144
  803d54:	e9 9f 04 00 00       	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
  803d59:	a1 38 61 80 00       	mov    0x806138,%eax
  803d5e:	8b 00                	mov    (%eax),%eax
  803d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(tmp!=NULL)
  803d63:	e9 84 04 00 00       	jmp    8041ec <insert_sorted_with_merge_freeList+0x801>
		{
			if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6b:	8b 50 08             	mov    0x8(%eax),%edx
  803d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d71:	8b 40 08             	mov    0x8(%eax),%eax
  803d74:	39 c2                	cmp    %eax,%edx
  803d76:	0f 86 a9 00 00 00    	jbe    803e25 <insert_sorted_with_merge_freeList+0x43a>
  803d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7f:	8b 50 08             	mov    0x8(%eax),%edx
  803d82:	8b 45 08             	mov    0x8(%ebp),%eax
  803d85:	8b 48 08             	mov    0x8(%eax),%ecx
  803d88:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  803d8e:	01 c8                	add    %ecx,%eax
  803d90:	39 c2                	cmp    %eax,%edx
  803d92:	0f 84 8d 00 00 00    	je     803e25 <insert_sorted_with_merge_freeList+0x43a>
  803d98:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9b:	8b 50 08             	mov    0x8(%eax),%edx
  803d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da1:	8b 40 04             	mov    0x4(%eax),%eax
  803da4:	8b 48 08             	mov    0x8(%eax),%ecx
  803da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803daa:	8b 40 04             	mov    0x4(%eax),%eax
  803dad:	8b 40 0c             	mov    0xc(%eax),%eax
  803db0:	01 c8                	add    %ecx,%eax
  803db2:	39 c2                	cmp    %eax,%edx
  803db4:	74 6f                	je     803e25 <insert_sorted_with_merge_freeList+0x43a>
			{
				LIST_INSERT_BEFORE(&FreeMemBlocksList,tmp,blockToInsert);
  803db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dba:	74 06                	je     803dc2 <insert_sorted_with_merge_freeList+0x3d7>
  803dbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dc0:	75 17                	jne    803dd9 <insert_sorted_with_merge_freeList+0x3ee>
  803dc2:	83 ec 04             	sub    $0x4,%esp
  803dc5:	68 70 50 80 00       	push   $0x805070
  803dca:	68 6b 01 00 00       	push   $0x16b
  803dcf:	68 33 50 80 00       	push   $0x805033
  803dd4:	e8 50 d6 ff ff       	call   801429 <_panic>
  803dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddc:	8b 50 04             	mov    0x4(%eax),%edx
  803ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  803de2:	89 50 04             	mov    %edx,0x4(%eax)
  803de5:	8b 45 08             	mov    0x8(%ebp),%eax
  803de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803deb:	89 10                	mov    %edx,(%eax)
  803ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df0:	8b 40 04             	mov    0x4(%eax),%eax
  803df3:	85 c0                	test   %eax,%eax
  803df5:	74 0d                	je     803e04 <insert_sorted_with_merge_freeList+0x419>
  803df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfa:	8b 40 04             	mov    0x4(%eax),%eax
  803dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  803e00:	89 10                	mov    %edx,(%eax)
  803e02:	eb 08                	jmp    803e0c <insert_sorted_with_merge_freeList+0x421>
  803e04:	8b 45 08             	mov    0x8(%ebp),%eax
  803e07:	a3 38 61 80 00       	mov    %eax,0x806138
  803e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  803e12:	89 50 04             	mov    %edx,0x4(%eax)
  803e15:	a1 44 61 80 00       	mov    0x806144,%eax
  803e1a:	40                   	inc    %eax
  803e1b:	a3 44 61 80 00       	mov    %eax,0x806144
				break;
  803e20:	e9 d3 03 00 00       	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
			}// no merge
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva!=(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e28:	8b 50 08             	mov    0x8(%eax),%edx
  803e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2e:	8b 40 08             	mov    0x8(%eax),%eax
  803e31:	39 c2                	cmp    %eax,%edx
  803e33:	0f 86 da 00 00 00    	jbe    803f13 <insert_sorted_with_merge_freeList+0x528>
  803e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3c:	8b 50 08             	mov    0x8(%eax),%edx
  803e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e42:	8b 48 08             	mov    0x8(%eax),%ecx
  803e45:	8b 45 08             	mov    0x8(%ebp),%eax
  803e48:	8b 40 0c             	mov    0xc(%eax),%eax
  803e4b:	01 c8                	add    %ecx,%eax
  803e4d:	39 c2                	cmp    %eax,%edx
  803e4f:	0f 85 be 00 00 00    	jne    803f13 <insert_sorted_with_merge_freeList+0x528>
  803e55:	8b 45 08             	mov    0x8(%ebp),%eax
  803e58:	8b 50 08             	mov    0x8(%eax),%edx
  803e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5e:	8b 40 04             	mov    0x4(%eax),%eax
  803e61:	8b 48 08             	mov    0x8(%eax),%ecx
  803e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e67:	8b 40 04             	mov    0x4(%eax),%eax
  803e6a:	8b 40 0c             	mov    0xc(%eax),%eax
  803e6d:	01 c8                	add    %ecx,%eax
  803e6f:	39 c2                	cmp    %eax,%edx
  803e71:	0f 84 9c 00 00 00    	je     803f13 <insert_sorted_with_merge_freeList+0x528>
			{
tmp->sva=blockToInsert->sva;
  803e77:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7a:	8b 50 08             	mov    0x8(%eax),%edx
  803e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e80:	89 50 08             	mov    %edx,0x8(%eax)
tmp->size+=blockToInsert->size;
  803e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e86:	8b 50 0c             	mov    0xc(%eax),%edx
  803e89:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  803e8f:	01 c2                	add    %eax,%edx
  803e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e94:	89 50 0c             	mov    %edx,0xc(%eax)
blockToInsert->sva=0;
  803e97:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
blockToInsert->size=0;
  803ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803eab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803eaf:	75 17                	jne    803ec8 <insert_sorted_with_merge_freeList+0x4dd>
  803eb1:	83 ec 04             	sub    $0x4,%esp
  803eb4:	68 10 50 80 00       	push   $0x805010
  803eb9:	68 74 01 00 00       	push   $0x174
  803ebe:	68 33 50 80 00       	push   $0x805033
  803ec3:	e8 61 d5 ff ff       	call   801429 <_panic>
  803ec8:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803ece:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed1:	89 10                	mov    %edx,(%eax)
  803ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed6:	8b 00                	mov    (%eax),%eax
  803ed8:	85 c0                	test   %eax,%eax
  803eda:	74 0d                	je     803ee9 <insert_sorted_with_merge_freeList+0x4fe>
  803edc:	a1 48 61 80 00       	mov    0x806148,%eax
  803ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  803ee4:	89 50 04             	mov    %edx,0x4(%eax)
  803ee7:	eb 08                	jmp    803ef1 <insert_sorted_with_merge_freeList+0x506>
  803ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  803eec:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef4:	a3 48 61 80 00       	mov    %eax,0x806148
  803ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  803efc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f03:	a1 54 61 80 00       	mov    0x806154,%eax
  803f08:	40                   	inc    %eax
  803f09:	a3 54 61 80 00       	mov    %eax,0x806154
break;
  803f0e:	e9 e5 02 00 00       	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with the next
			else if(tmp->sva>blockToInsert->sva&&tmp->sva!=(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f16:	8b 50 08             	mov    0x8(%eax),%edx
  803f19:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1c:	8b 40 08             	mov    0x8(%eax),%eax
  803f1f:	39 c2                	cmp    %eax,%edx
  803f21:	0f 86 d7 00 00 00    	jbe    803ffe <insert_sorted_with_merge_freeList+0x613>
  803f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2a:	8b 50 08             	mov    0x8(%eax),%edx
  803f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f30:	8b 48 08             	mov    0x8(%eax),%ecx
  803f33:	8b 45 08             	mov    0x8(%ebp),%eax
  803f36:	8b 40 0c             	mov    0xc(%eax),%eax
  803f39:	01 c8                	add    %ecx,%eax
  803f3b:	39 c2                	cmp    %eax,%edx
  803f3d:	0f 84 bb 00 00 00    	je     803ffe <insert_sorted_with_merge_freeList+0x613>
  803f43:	8b 45 08             	mov    0x8(%ebp),%eax
  803f46:	8b 50 08             	mov    0x8(%eax),%edx
  803f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4c:	8b 40 04             	mov    0x4(%eax),%eax
  803f4f:	8b 48 08             	mov    0x8(%eax),%ecx
  803f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f55:	8b 40 04             	mov    0x4(%eax),%eax
  803f58:	8b 40 0c             	mov    0xc(%eax),%eax
  803f5b:	01 c8                	add    %ecx,%eax
  803f5d:	39 c2                	cmp    %eax,%edx
  803f5f:	0f 85 99 00 00 00    	jne    803ffe <insert_sorted_with_merge_freeList+0x613>
			{
				struct MemBlock *ptr=LIST_PREV(tmp);
  803f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f68:	8b 40 04             	mov    0x4(%eax),%eax
  803f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				ptr->size+=blockToInsert->size;
  803f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f71:	8b 50 0c             	mov    0xc(%eax),%edx
  803f74:	8b 45 08             	mov    0x8(%ebp),%eax
  803f77:	8b 40 0c             	mov    0xc(%eax),%eax
  803f7a:	01 c2                	add    %eax,%edx
  803f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f7f:	89 50 0c             	mov    %edx,0xc(%eax)
				blockToInsert->sva=0;
  803f82:	8b 45 08             	mov    0x8(%ebp),%eax
  803f85:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size =0;
  803f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f9a:	75 17                	jne    803fb3 <insert_sorted_with_merge_freeList+0x5c8>
  803f9c:	83 ec 04             	sub    $0x4,%esp
  803f9f:	68 10 50 80 00       	push   $0x805010
  803fa4:	68 7d 01 00 00       	push   $0x17d
  803fa9:	68 33 50 80 00       	push   $0x805033
  803fae:	e8 76 d4 ff ff       	call   801429 <_panic>
  803fb3:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbc:	89 10                	mov    %edx,(%eax)
  803fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc1:	8b 00                	mov    (%eax),%eax
  803fc3:	85 c0                	test   %eax,%eax
  803fc5:	74 0d                	je     803fd4 <insert_sorted_with_merge_freeList+0x5e9>
  803fc7:	a1 48 61 80 00       	mov    0x806148,%eax
  803fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  803fcf:	89 50 04             	mov    %edx,0x4(%eax)
  803fd2:	eb 08                	jmp    803fdc <insert_sorted_with_merge_freeList+0x5f1>
  803fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd7:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803fdf:	a3 48 61 80 00       	mov    %eax,0x806148
  803fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fee:	a1 54 61 80 00       	mov    0x806154,%eax
  803ff3:	40                   	inc    %eax
  803ff4:	a3 54 61 80 00       	mov    %eax,0x806154
break;
  803ff9:	e9 fa 01 00 00       	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
			}// merge with previous
			else if(tmp->sva>blockToInsert->sva&&tmp->sva==(blockToInsert->sva+blockToInsert->size)&&blockToInsert->sva==(LIST_PREV(tmp)->sva+LIST_PREV(tmp)->size))
  803ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804001:	8b 50 08             	mov    0x8(%eax),%edx
  804004:	8b 45 08             	mov    0x8(%ebp),%eax
  804007:	8b 40 08             	mov    0x8(%eax),%eax
  80400a:	39 c2                	cmp    %eax,%edx
  80400c:	0f 86 d2 01 00 00    	jbe    8041e4 <insert_sorted_with_merge_freeList+0x7f9>
  804012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804015:	8b 50 08             	mov    0x8(%eax),%edx
  804018:	8b 45 08             	mov    0x8(%ebp),%eax
  80401b:	8b 48 08             	mov    0x8(%eax),%ecx
  80401e:	8b 45 08             	mov    0x8(%ebp),%eax
  804021:	8b 40 0c             	mov    0xc(%eax),%eax
  804024:	01 c8                	add    %ecx,%eax
  804026:	39 c2                	cmp    %eax,%edx
  804028:	0f 85 b6 01 00 00    	jne    8041e4 <insert_sorted_with_merge_freeList+0x7f9>
  80402e:	8b 45 08             	mov    0x8(%ebp),%eax
  804031:	8b 50 08             	mov    0x8(%eax),%edx
  804034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804037:	8b 40 04             	mov    0x4(%eax),%eax
  80403a:	8b 48 08             	mov    0x8(%eax),%ecx
  80403d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804040:	8b 40 04             	mov    0x4(%eax),%eax
  804043:	8b 40 0c             	mov    0xc(%eax),%eax
  804046:	01 c8                	add    %ecx,%eax
  804048:	39 c2                	cmp    %eax,%edx
  80404a:	0f 85 94 01 00 00    	jne    8041e4 <insert_sorted_with_merge_freeList+0x7f9>
			{

				LIST_PREV(tmp)->size+=blockToInsert->size+tmp->size;
  804050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804053:	8b 40 04             	mov    0x4(%eax),%eax
  804056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804059:	8b 52 04             	mov    0x4(%edx),%edx
  80405c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80405f:	8b 55 08             	mov    0x8(%ebp),%edx
  804062:	8b 5a 0c             	mov    0xc(%edx),%ebx
  804065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804068:	8b 52 0c             	mov    0xc(%edx),%edx
  80406b:	01 da                	add    %ebx,%edx
  80406d:	01 ca                	add    %ecx,%edx
  80406f:	89 50 0c             	mov    %edx,0xc(%eax)
				tmp->size=0;
  804072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804075:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				tmp->sva=0;
  80407c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80407f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				LIST_REMOVE(&FreeMemBlocksList,tmp);
  804086:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80408a:	75 17                	jne    8040a3 <insert_sorted_with_merge_freeList+0x6b8>
  80408c:	83 ec 04             	sub    $0x4,%esp
  80408f:	68 a5 50 80 00       	push   $0x8050a5
  804094:	68 86 01 00 00       	push   $0x186
  804099:	68 33 50 80 00       	push   $0x805033
  80409e:	e8 86 d3 ff ff       	call   801429 <_panic>
  8040a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a6:	8b 00                	mov    (%eax),%eax
  8040a8:	85 c0                	test   %eax,%eax
  8040aa:	74 10                	je     8040bc <insert_sorted_with_merge_freeList+0x6d1>
  8040ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040af:	8b 00                	mov    (%eax),%eax
  8040b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040b4:	8b 52 04             	mov    0x4(%edx),%edx
  8040b7:	89 50 04             	mov    %edx,0x4(%eax)
  8040ba:	eb 0b                	jmp    8040c7 <insert_sorted_with_merge_freeList+0x6dc>
  8040bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040bf:	8b 40 04             	mov    0x4(%eax),%eax
  8040c2:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8040c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ca:	8b 40 04             	mov    0x4(%eax),%eax
  8040cd:	85 c0                	test   %eax,%eax
  8040cf:	74 0f                	je     8040e0 <insert_sorted_with_merge_freeList+0x6f5>
  8040d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d4:	8b 40 04             	mov    0x4(%eax),%eax
  8040d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040da:	8b 12                	mov    (%edx),%edx
  8040dc:	89 10                	mov    %edx,(%eax)
  8040de:	eb 0a                	jmp    8040ea <insert_sorted_with_merge_freeList+0x6ff>
  8040e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040e3:	8b 00                	mov    (%eax),%eax
  8040e5:	a3 38 61 80 00       	mov    %eax,0x806138
  8040ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040fd:	a1 44 61 80 00       	mov    0x806144,%eax
  804102:	48                   	dec    %eax
  804103:	a3 44 61 80 00       	mov    %eax,0x806144
				LIST_INSERT_HEAD(&AvailableMemBlocksList,tmp);
  804108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80410c:	75 17                	jne    804125 <insert_sorted_with_merge_freeList+0x73a>
  80410e:	83 ec 04             	sub    $0x4,%esp
  804111:	68 10 50 80 00       	push   $0x805010
  804116:	68 87 01 00 00       	push   $0x187
  80411b:	68 33 50 80 00       	push   $0x805033
  804120:	e8 04 d3 ff ff       	call   801429 <_panic>
  804125:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80412b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80412e:	89 10                	mov    %edx,(%eax)
  804130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804133:	8b 00                	mov    (%eax),%eax
  804135:	85 c0                	test   %eax,%eax
  804137:	74 0d                	je     804146 <insert_sorted_with_merge_freeList+0x75b>
  804139:	a1 48 61 80 00       	mov    0x806148,%eax
  80413e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804141:	89 50 04             	mov    %edx,0x4(%eax)
  804144:	eb 08                	jmp    80414e <insert_sorted_with_merge_freeList+0x763>
  804146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804149:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80414e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804151:	a3 48 61 80 00       	mov    %eax,0x806148
  804156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804159:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804160:	a1 54 61 80 00       	mov    0x806154,%eax
  804165:	40                   	inc    %eax
  804166:	a3 54 61 80 00       	mov    %eax,0x806154
				blockToInsert->sva=0;
  80416b:	8b 45 08             	mov    0x8(%ebp),%eax
  80416e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				blockToInsert->size=0;
  804175:	8b 45 08             	mov    0x8(%ebp),%eax
  804178:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80417f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804183:	75 17                	jne    80419c <insert_sorted_with_merge_freeList+0x7b1>
  804185:	83 ec 04             	sub    $0x4,%esp
  804188:	68 10 50 80 00       	push   $0x805010
  80418d:	68 8a 01 00 00       	push   $0x18a
  804192:	68 33 50 80 00       	push   $0x805033
  804197:	e8 8d d2 ff ff       	call   801429 <_panic>
  80419c:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8041a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a5:	89 10                	mov    %edx,(%eax)
  8041a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041aa:	8b 00                	mov    (%eax),%eax
  8041ac:	85 c0                	test   %eax,%eax
  8041ae:	74 0d                	je     8041bd <insert_sorted_with_merge_freeList+0x7d2>
  8041b0:	a1 48 61 80 00       	mov    0x806148,%eax
  8041b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8041b8:	89 50 04             	mov    %edx,0x4(%eax)
  8041bb:	eb 08                	jmp    8041c5 <insert_sorted_with_merge_freeList+0x7da>
  8041bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c0:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8041c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c8:	a3 48 61 80 00       	mov    %eax,0x806148
  8041cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041d7:	a1 54 61 80 00       	mov    0x806154,%eax
  8041dc:	40                   	inc    %eax
  8041dd:	a3 54 61 80 00       	mov    %eax,0x806154
				break;
  8041e2:	eb 14                	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
			}//merge with next and previous
			tmp=tmp->prev_next_info.le_next;
  8041e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041e7:	8b 00                	mov    (%eax),%eax
  8041e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock *tmp=FreeMemBlocksList.lh_first->prev_next_info.le_next;
		while(tmp!=NULL)
  8041ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041f0:	0f 85 72 fb ff ff    	jne    803d68 <insert_sorted_with_merge_freeList+0x37d>
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}
  8041f6:	eb 00                	jmp    8041f8 <insert_sorted_with_merge_freeList+0x80d>
  8041f8:	90                   	nop
  8041f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8041fc:	c9                   	leave  
  8041fd:	c3                   	ret    
  8041fe:	66 90                	xchg   %ax,%ax

00804200 <__udivdi3>:
  804200:	55                   	push   %ebp
  804201:	57                   	push   %edi
  804202:	56                   	push   %esi
  804203:	53                   	push   %ebx
  804204:	83 ec 1c             	sub    $0x1c,%esp
  804207:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80420b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80420f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804213:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804217:	89 ca                	mov    %ecx,%edx
  804219:	89 f8                	mov    %edi,%eax
  80421b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80421f:	85 f6                	test   %esi,%esi
  804221:	75 2d                	jne    804250 <__udivdi3+0x50>
  804223:	39 cf                	cmp    %ecx,%edi
  804225:	77 65                	ja     80428c <__udivdi3+0x8c>
  804227:	89 fd                	mov    %edi,%ebp
  804229:	85 ff                	test   %edi,%edi
  80422b:	75 0b                	jne    804238 <__udivdi3+0x38>
  80422d:	b8 01 00 00 00       	mov    $0x1,%eax
  804232:	31 d2                	xor    %edx,%edx
  804234:	f7 f7                	div    %edi
  804236:	89 c5                	mov    %eax,%ebp
  804238:	31 d2                	xor    %edx,%edx
  80423a:	89 c8                	mov    %ecx,%eax
  80423c:	f7 f5                	div    %ebp
  80423e:	89 c1                	mov    %eax,%ecx
  804240:	89 d8                	mov    %ebx,%eax
  804242:	f7 f5                	div    %ebp
  804244:	89 cf                	mov    %ecx,%edi
  804246:	89 fa                	mov    %edi,%edx
  804248:	83 c4 1c             	add    $0x1c,%esp
  80424b:	5b                   	pop    %ebx
  80424c:	5e                   	pop    %esi
  80424d:	5f                   	pop    %edi
  80424e:	5d                   	pop    %ebp
  80424f:	c3                   	ret    
  804250:	39 ce                	cmp    %ecx,%esi
  804252:	77 28                	ja     80427c <__udivdi3+0x7c>
  804254:	0f bd fe             	bsr    %esi,%edi
  804257:	83 f7 1f             	xor    $0x1f,%edi
  80425a:	75 40                	jne    80429c <__udivdi3+0x9c>
  80425c:	39 ce                	cmp    %ecx,%esi
  80425e:	72 0a                	jb     80426a <__udivdi3+0x6a>
  804260:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804264:	0f 87 9e 00 00 00    	ja     804308 <__udivdi3+0x108>
  80426a:	b8 01 00 00 00       	mov    $0x1,%eax
  80426f:	89 fa                	mov    %edi,%edx
  804271:	83 c4 1c             	add    $0x1c,%esp
  804274:	5b                   	pop    %ebx
  804275:	5e                   	pop    %esi
  804276:	5f                   	pop    %edi
  804277:	5d                   	pop    %ebp
  804278:	c3                   	ret    
  804279:	8d 76 00             	lea    0x0(%esi),%esi
  80427c:	31 ff                	xor    %edi,%edi
  80427e:	31 c0                	xor    %eax,%eax
  804280:	89 fa                	mov    %edi,%edx
  804282:	83 c4 1c             	add    $0x1c,%esp
  804285:	5b                   	pop    %ebx
  804286:	5e                   	pop    %esi
  804287:	5f                   	pop    %edi
  804288:	5d                   	pop    %ebp
  804289:	c3                   	ret    
  80428a:	66 90                	xchg   %ax,%ax
  80428c:	89 d8                	mov    %ebx,%eax
  80428e:	f7 f7                	div    %edi
  804290:	31 ff                	xor    %edi,%edi
  804292:	89 fa                	mov    %edi,%edx
  804294:	83 c4 1c             	add    $0x1c,%esp
  804297:	5b                   	pop    %ebx
  804298:	5e                   	pop    %esi
  804299:	5f                   	pop    %edi
  80429a:	5d                   	pop    %ebp
  80429b:	c3                   	ret    
  80429c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8042a1:	89 eb                	mov    %ebp,%ebx
  8042a3:	29 fb                	sub    %edi,%ebx
  8042a5:	89 f9                	mov    %edi,%ecx
  8042a7:	d3 e6                	shl    %cl,%esi
  8042a9:	89 c5                	mov    %eax,%ebp
  8042ab:	88 d9                	mov    %bl,%cl
  8042ad:	d3 ed                	shr    %cl,%ebp
  8042af:	89 e9                	mov    %ebp,%ecx
  8042b1:	09 f1                	or     %esi,%ecx
  8042b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8042b7:	89 f9                	mov    %edi,%ecx
  8042b9:	d3 e0                	shl    %cl,%eax
  8042bb:	89 c5                	mov    %eax,%ebp
  8042bd:	89 d6                	mov    %edx,%esi
  8042bf:	88 d9                	mov    %bl,%cl
  8042c1:	d3 ee                	shr    %cl,%esi
  8042c3:	89 f9                	mov    %edi,%ecx
  8042c5:	d3 e2                	shl    %cl,%edx
  8042c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042cb:	88 d9                	mov    %bl,%cl
  8042cd:	d3 e8                	shr    %cl,%eax
  8042cf:	09 c2                	or     %eax,%edx
  8042d1:	89 d0                	mov    %edx,%eax
  8042d3:	89 f2                	mov    %esi,%edx
  8042d5:	f7 74 24 0c          	divl   0xc(%esp)
  8042d9:	89 d6                	mov    %edx,%esi
  8042db:	89 c3                	mov    %eax,%ebx
  8042dd:	f7 e5                	mul    %ebp
  8042df:	39 d6                	cmp    %edx,%esi
  8042e1:	72 19                	jb     8042fc <__udivdi3+0xfc>
  8042e3:	74 0b                	je     8042f0 <__udivdi3+0xf0>
  8042e5:	89 d8                	mov    %ebx,%eax
  8042e7:	31 ff                	xor    %edi,%edi
  8042e9:	e9 58 ff ff ff       	jmp    804246 <__udivdi3+0x46>
  8042ee:	66 90                	xchg   %ax,%ax
  8042f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8042f4:	89 f9                	mov    %edi,%ecx
  8042f6:	d3 e2                	shl    %cl,%edx
  8042f8:	39 c2                	cmp    %eax,%edx
  8042fa:	73 e9                	jae    8042e5 <__udivdi3+0xe5>
  8042fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042ff:	31 ff                	xor    %edi,%edi
  804301:	e9 40 ff ff ff       	jmp    804246 <__udivdi3+0x46>
  804306:	66 90                	xchg   %ax,%ax
  804308:	31 c0                	xor    %eax,%eax
  80430a:	e9 37 ff ff ff       	jmp    804246 <__udivdi3+0x46>
  80430f:	90                   	nop

00804310 <__umoddi3>:
  804310:	55                   	push   %ebp
  804311:	57                   	push   %edi
  804312:	56                   	push   %esi
  804313:	53                   	push   %ebx
  804314:	83 ec 1c             	sub    $0x1c,%esp
  804317:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80431b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80431f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804323:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804327:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80432b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80432f:	89 f3                	mov    %esi,%ebx
  804331:	89 fa                	mov    %edi,%edx
  804333:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804337:	89 34 24             	mov    %esi,(%esp)
  80433a:	85 c0                	test   %eax,%eax
  80433c:	75 1a                	jne    804358 <__umoddi3+0x48>
  80433e:	39 f7                	cmp    %esi,%edi
  804340:	0f 86 a2 00 00 00    	jbe    8043e8 <__umoddi3+0xd8>
  804346:	89 c8                	mov    %ecx,%eax
  804348:	89 f2                	mov    %esi,%edx
  80434a:	f7 f7                	div    %edi
  80434c:	89 d0                	mov    %edx,%eax
  80434e:	31 d2                	xor    %edx,%edx
  804350:	83 c4 1c             	add    $0x1c,%esp
  804353:	5b                   	pop    %ebx
  804354:	5e                   	pop    %esi
  804355:	5f                   	pop    %edi
  804356:	5d                   	pop    %ebp
  804357:	c3                   	ret    
  804358:	39 f0                	cmp    %esi,%eax
  80435a:	0f 87 ac 00 00 00    	ja     80440c <__umoddi3+0xfc>
  804360:	0f bd e8             	bsr    %eax,%ebp
  804363:	83 f5 1f             	xor    $0x1f,%ebp
  804366:	0f 84 ac 00 00 00    	je     804418 <__umoddi3+0x108>
  80436c:	bf 20 00 00 00       	mov    $0x20,%edi
  804371:	29 ef                	sub    %ebp,%edi
  804373:	89 fe                	mov    %edi,%esi
  804375:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804379:	89 e9                	mov    %ebp,%ecx
  80437b:	d3 e0                	shl    %cl,%eax
  80437d:	89 d7                	mov    %edx,%edi
  80437f:	89 f1                	mov    %esi,%ecx
  804381:	d3 ef                	shr    %cl,%edi
  804383:	09 c7                	or     %eax,%edi
  804385:	89 e9                	mov    %ebp,%ecx
  804387:	d3 e2                	shl    %cl,%edx
  804389:	89 14 24             	mov    %edx,(%esp)
  80438c:	89 d8                	mov    %ebx,%eax
  80438e:	d3 e0                	shl    %cl,%eax
  804390:	89 c2                	mov    %eax,%edx
  804392:	8b 44 24 08          	mov    0x8(%esp),%eax
  804396:	d3 e0                	shl    %cl,%eax
  804398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80439c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043a0:	89 f1                	mov    %esi,%ecx
  8043a2:	d3 e8                	shr    %cl,%eax
  8043a4:	09 d0                	or     %edx,%eax
  8043a6:	d3 eb                	shr    %cl,%ebx
  8043a8:	89 da                	mov    %ebx,%edx
  8043aa:	f7 f7                	div    %edi
  8043ac:	89 d3                	mov    %edx,%ebx
  8043ae:	f7 24 24             	mull   (%esp)
  8043b1:	89 c6                	mov    %eax,%esi
  8043b3:	89 d1                	mov    %edx,%ecx
  8043b5:	39 d3                	cmp    %edx,%ebx
  8043b7:	0f 82 87 00 00 00    	jb     804444 <__umoddi3+0x134>
  8043bd:	0f 84 91 00 00 00    	je     804454 <__umoddi3+0x144>
  8043c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8043c7:	29 f2                	sub    %esi,%edx
  8043c9:	19 cb                	sbb    %ecx,%ebx
  8043cb:	89 d8                	mov    %ebx,%eax
  8043cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8043d1:	d3 e0                	shl    %cl,%eax
  8043d3:	89 e9                	mov    %ebp,%ecx
  8043d5:	d3 ea                	shr    %cl,%edx
  8043d7:	09 d0                	or     %edx,%eax
  8043d9:	89 e9                	mov    %ebp,%ecx
  8043db:	d3 eb                	shr    %cl,%ebx
  8043dd:	89 da                	mov    %ebx,%edx
  8043df:	83 c4 1c             	add    $0x1c,%esp
  8043e2:	5b                   	pop    %ebx
  8043e3:	5e                   	pop    %esi
  8043e4:	5f                   	pop    %edi
  8043e5:	5d                   	pop    %ebp
  8043e6:	c3                   	ret    
  8043e7:	90                   	nop
  8043e8:	89 fd                	mov    %edi,%ebp
  8043ea:	85 ff                	test   %edi,%edi
  8043ec:	75 0b                	jne    8043f9 <__umoddi3+0xe9>
  8043ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8043f3:	31 d2                	xor    %edx,%edx
  8043f5:	f7 f7                	div    %edi
  8043f7:	89 c5                	mov    %eax,%ebp
  8043f9:	89 f0                	mov    %esi,%eax
  8043fb:	31 d2                	xor    %edx,%edx
  8043fd:	f7 f5                	div    %ebp
  8043ff:	89 c8                	mov    %ecx,%eax
  804401:	f7 f5                	div    %ebp
  804403:	89 d0                	mov    %edx,%eax
  804405:	e9 44 ff ff ff       	jmp    80434e <__umoddi3+0x3e>
  80440a:	66 90                	xchg   %ax,%ax
  80440c:	89 c8                	mov    %ecx,%eax
  80440e:	89 f2                	mov    %esi,%edx
  804410:	83 c4 1c             	add    $0x1c,%esp
  804413:	5b                   	pop    %ebx
  804414:	5e                   	pop    %esi
  804415:	5f                   	pop    %edi
  804416:	5d                   	pop    %ebp
  804417:	c3                   	ret    
  804418:	3b 04 24             	cmp    (%esp),%eax
  80441b:	72 06                	jb     804423 <__umoddi3+0x113>
  80441d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804421:	77 0f                	ja     804432 <__umoddi3+0x122>
  804423:	89 f2                	mov    %esi,%edx
  804425:	29 f9                	sub    %edi,%ecx
  804427:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80442b:	89 14 24             	mov    %edx,(%esp)
  80442e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804432:	8b 44 24 04          	mov    0x4(%esp),%eax
  804436:	8b 14 24             	mov    (%esp),%edx
  804439:	83 c4 1c             	add    $0x1c,%esp
  80443c:	5b                   	pop    %ebx
  80443d:	5e                   	pop    %esi
  80443e:	5f                   	pop    %edi
  80443f:	5d                   	pop    %ebp
  804440:	c3                   	ret    
  804441:	8d 76 00             	lea    0x0(%esi),%esi
  804444:	2b 04 24             	sub    (%esp),%eax
  804447:	19 fa                	sbb    %edi,%edx
  804449:	89 d1                	mov    %edx,%ecx
  80444b:	89 c6                	mov    %eax,%esi
  80444d:	e9 71 ff ff ff       	jmp    8043c3 <__umoddi3+0xb3>
  804452:	66 90                	xchg   %ax,%ax
  804454:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804458:	72 ea                	jb     804444 <__umoddi3+0x134>
  80445a:	89 d9                	mov    %ebx,%ecx
  80445c:	e9 62 ff ff ff       	jmp    8043c3 <__umoddi3+0xb3>
